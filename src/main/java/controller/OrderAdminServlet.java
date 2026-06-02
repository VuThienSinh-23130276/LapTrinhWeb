package controller;

import DAO.OrderDAO;
import model.Order;
import model.OrderItem;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.KeyFactory;
import java.security.PublicKey;
import java.security.Signature;
import java.security.spec.X509EncodedKeySpec;
import java.util.Base64;
import java.util.List;

@WebServlet("/admin/orders")
public class OrderAdminServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = session == null ? null : (User) session.getAttribute("user");

        if (user == null || !user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        String action = request.getParameter("action");
        if (action == null)
            action = "list";

        switch (action) {
            case "detail" -> {
                String idStr = request.getParameter("id");
                if (idStr != null) {
                    try {
                        int orderId = Integer.parseInt(idStr);
                        Order order = OrderDAO.getOrderById(orderId);
                        if (order != null) {
                            List<OrderItem> items = OrderDAO.getItemsByOrderId(orderId);
                            request.setAttribute("order", order);
                            request.setAttribute("items", items);
                            request.getRequestDispatcher("/admin/order-detail.jsp").forward(request, response);
                            return;
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
                response.sendRedirect(request.getContextPath() + "/admin/orders");
            }
            
            // ================= NEW CASE: XỬ LÝ RE-VERIFY CHỮ KÝ SỐ RSA CHO ADMIN =================
            case "verify" -> {
                String idStr = request.getParameter("id");
                if (idStr != null) {
                    try {
                        int orderId = Integer.parseInt(idStr);
                        Order order = OrderDAO.getOrderById(orderId);
                        
                        if (order != null) {
                            // 1. Giải quyết bài toán mất key: Lấy đúng Public Key tương ứng với Version của đơn hàng đó
                            String publicKeyPEM = DAO.UserKeyDAO.getPublicKeyByVersion(order.getUserId(), order.getPublicKeyVersion());
                            
                            // 2. Tái cấu trúc chuỗi dữ liệu gốc (Phải giống cấu trúc chuỗi JSON/String lúc tạo đơn ở Cart)
                            // Bạn cần đảm bảo hàm order.toSignString() hoặc ép thành JSON khớp 100% với lúc ký ở Client
                            String orderDataString = order.toSignString(); 
                            String clientSignature = order.getSignature();
                            
                            if (publicKeyPEM == null || clientSignature == null || clientSignature.isBlank()) {
                                request.setAttribute("rsaMessage", "🔴 Không tìm thấy Public Key hoặc chữ ký số cho đơn hàng này!");
                            } else {
                                // 3. Tiến hành đối chiếu thuật toán mã hóa
                                boolean isValid = verifyRSASignature(orderDataString, clientSignature, publicKeyPEM);
                                
                                if (isValid) {
                                    request.setAttribute("rsaMessage", "🟢 Xác minh thành công: Chữ ký HỢP LỆ. Đơn hàng toàn vẹn 100%!");
                                } else {
                                    request.setAttribute("rsaMessage", "🔴 CẢNH BÁO: Chữ ký KHÔNG HỢP LỆ! Dữ liệu đơn hàng hoặc khóa đã bị thay đổi bất hợp pháp.");
                                }
                            }
                            
                            // Đẩy lại dữ liệu hiển thị về trang chi tiết đơn hàng kèm theo thông báo xác minh chữ ký
                            List<OrderItem> items = OrderDAO.getItemsByOrderId(orderId);
                            request.setAttribute("order", order);
                            request.setAttribute("items", items);
                            request.getRequestDispatcher("/admin/order-detail.jsp").forward(request, response);
                            return;
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                        request.setAttribute("rsaMessage", "🔴 Lỗi hệ thống trong quá trình thực hiện thuật toán verify!");
                    }
                }
                response.sendRedirect(request.getContextPath() + "/admin/orders");
            }
            // ======================================================================================
            
            default -> {
                java.util.Map<Order, String> ordersMap = OrderDAO.getAllOrdersWithUsername();
                request.setAttribute("ordersMap", ordersMap);
                request.getRequestDispatcher("/admin/orders.jsp").forward(request, response);
            }
        }
    }

    /**
     * Hàm lõi xử lý thuật toán RSA SHA-256 đối chiếu chữ ký số từ DB
     */
    private boolean verifyRSASignature(String data, String signatureBase64, String publicKeyPEM) throws Exception {
        String publicKeyString = publicKeyPEM
                .replace("-----BEGIN PUBLIC KEY-----", "")
                .replace("-----END PUBLIC KEY-----", "")
                .replaceAll("\\s+", "");

        byte[] keyBytes = Base64.getDecoder().decode(publicKeyString);
        X509EncodedKeySpec spec = new X509EncodedKeySpec(keyBytes);
        KeyFactory kf = KeyFactory.getInstance("RSA");
        PublicKey publicKey = kf.generatePublic(spec);

        Signature publicSignature = Signature.getInstance("SHA256withRSA");
        publicSignature.initVerify(publicKey);
        publicSignature.update(data.getBytes(StandardCharsets.UTF_8));

        byte[] signatureBytes = Base64.getDecoder().decode(signatureBase64);
        return publicSignature.verify(signatureBytes);
    }
}