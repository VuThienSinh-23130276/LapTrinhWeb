package controller;

import DAO.CartDAO;
import DAO.ProductDAO;
import DAO.UserKeyDAO;
import model.CartItem;
import model.Product;
import model.User;
import util.RSAUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private String safeBack(HttpServletRequest request) {
        String ref = request.getHeader("Referer");
        if (ref == null || ref.isBlank()) {
            return request.getContextPath() + "/cart";
        }
        return ref;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?redirect=cart");
            return;
        }

        List<CartItem> cart = CartDAO.loadCart(user.getId());
        session.setAttribute("cart", cart);

        request.setAttribute("cartItems", cart);

        double total = 0;
        for (CartItem item : cart) total += item.getSubTotal();
        request.setAttribute("total", total);

        request.getRequestDispatcher("/cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?redirect=cart");
            return;
        }

        List<CartItem> cart = CartDAO.loadCart(user.getId());
        session.setAttribute("cart", cart);

        String action = request.getParameter("action");
        if (action == null) action = "add";

        if ("checkout".equals(action)) {
            String orderDataString = request.getParameter("orderData");
            String clientSignature = request.getParameter("signature");

            if (orderDataString == null || clientSignature == null || orderDataString.isBlank() || clientSignature.isBlank()) {
                request.setAttribute("error", "Thiếu dữ liệu đơn hàng hoặc chữ ký điện tử!");
                request.getRequestDispatcher("/cart.jsp").forward(request, response);
                return;
            }

            try {
                String activePublicKeyPEM = UserKeyDAO.getActivePublicKey(user.getId()); 

                if (activePublicKeyPEM == null) {
                    request.setAttribute("error", "Tài khoản của bạn chưa cấu hình khóa ký điện tử. Vui lòng vào mục Tài khoản để tạo mới!");
                    request.getRequestDispatcher("/cart.jsp").forward(request, response);
                    return;
                }

                boolean isVerified = RSAUtil.verifyRSASignature(orderDataString, clientSignature, activePublicKeyPEM);

                if (isVerified) {
                    CartDAO.clear(user.getId()); 
                    session.removeAttribute("cart");
                    response.sendRedirect(request.getContextPath() + "/success.jsp");
                } else {
                    request.setAttribute("error", "Chữ ký không hợp lệ! Thiết bị của bạn có thể đang dùng khóa cũ đã bị hủy.");
                    request.getRequestDispatcher("/cart.jsp").forward(request, response);
                }
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "Lỗi xảy ra trong quá trình xác thực chữ ký hệ thống!");
                request.getRequestDispatcher("/cart.jsp").forward(request, response);
            }
            return;
        }

        int variantId;
        Integer productIdForAdd = null;
        String colorForAdd = null;
        String sizeForAdd = null;

        if ("add".equals(action)) {
            int productId;
            try {
                productId = Integer.parseInt(request.getParameter("id"));
            } catch (Exception e) {
                response.sendRedirect(safeBack(request));
                return;
            }

            String color = request.getParameter("color");
            String size  = request.getParameter("size");

            if (color != null) color = color.trim();
            if (size  != null) size  = size.trim();

            if (color == null || color.isBlank() || size == null || size.isBlank()) {
                response.sendRedirect(safeBack(request));
                return;
            }

            Integer vId = ProductDAO.getVariantId(productId, color, size);

            if (vId == null) {
                response.sendRedirect(safeBack(request));
                return;
            }

            variantId = vId;
            productIdForAdd = productId;
            colorForAdd = color;
            sizeForAdd = size;

        } else {
            try {
                variantId = Integer.parseInt(request.getParameter("id"));
            } catch (Exception e) {
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }
        }

        switch (action) {
            case "add" -> {
                int qty = 1;
                String qtyStr = request.getParameter("qty");
                if (qtyStr != null && !qtyStr.trim().isEmpty()) {
                    try {
                        qty = Integer.parseInt(qtyStr.trim());
                        if (qty <= 0) qty = 1;
                    } catch (Exception ignored) {
                        qty = 1;
                    }
                }

                Product p = ProductDAO.getById(productIdForAdd);
                if (p != null) {
                    boolean found = false;
                    for (CartItem item : cart) {
                        if (item.getVariantId() == variantId) {
                            item.setQuantity(item.getQuantity() + qty);
                            found = true;
                            break;
                        }
                    }
                    if (!found) {
                        CartItem ci = new CartItem(p, qty);
                        ci.setVariantId(variantId);
                        ci.setColor(colorForAdd);
                        ci.setSize(sizeForAdd);
                        cart.add(ci);
                    }
                }

                try {
                    CartDAO.add(user.getId(), variantId, qty);
                    cart = CartDAO.loadCart(user.getId());
                    session.setAttribute("cart", cart);
                } catch (Exception e) {
                    e.printStackTrace();
                }

                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }

            case "inc" -> {
                CartDAO.add(user.getId(), variantId, 1);
                cart = CartDAO.loadCart(user.getId());
                session.setAttribute("cart", cart);
            }

            case "dec" -> {
                CartItem target = null;
                for (CartItem item : cart) {
                    if (item.getVariantId() == variantId) {
                        target = item;
                        break;
                    }
                }
                if (target != null) {
                    int newQty = target.getQuantity() - 1;
                    if (newQty <= 0) {
                        CartDAO.remove(user.getId(), variantId);
                    } else {
                        CartDAO.updateQty(user.getId(), variantId, newQty);
                    }
                    cart = CartDAO.loadCart(user.getId());
                    session.setAttribute("cart", cart);
                }
            }

            case "update" -> {
                int qty;
                try {
                    qty = Integer.parseInt(request.getParameter("qty"));
                } catch (Exception e) {
                    qty = 1;
                }

                if (qty <= 0) {
                    CartDAO.remove(user.getId(), variantId);
                } else {
                    CartDAO.updateQty(user.getId(), variantId, qty);
                }
                cart = CartDAO.loadCart(user.getId());
                session.setAttribute("cart", cart);
            }

            case "remove" -> {
                CartDAO.remove(user.getId(), variantId);
                cart = CartDAO.loadCart(user.getId());
                session.setAttribute("cart", cart);
            }
        }

        response.sendRedirect(safeBack(request));
    }
}