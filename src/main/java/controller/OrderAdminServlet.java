package controller;

import DAO.KeyDAO;
import DAO.OrderDAO;
import model.Order;
import model.OrderItem;
import model.User;
import util.SignatureUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.security.PublicKey;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/orders")
public class OrderAdminServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private KeyDAO keyDAO = new KeyDAO(); 

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
                        
                       
                        if ("VALID".equals(order.getVerifyStatus()) && order.getDigitalSignature() != null) {
                            String pubKeyPem = keyDAO.getActivePublicKey(order.getUserId());
                            if (pubKeyPem == null) {
                                order.setVerifyStatus("INVALID");
                            } else {
                                PublicKey pubKey = SignatureUtil.loadPublicKeyFromPem(pubKeyPem);
                                String currentData = order.getOrderCode() + "|" + order.getTotal();
                                boolean isIntact = SignatureUtil.verifySignature(currentData, order.getDigitalSignature(), pubKey);
                                if (!isIntact) {
                                    order.setVerifyStatus("INVALID");
                                }
                            }
                        }
       

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
        default -> {
            java.util.Map<Order, String> ordersMap = OrderDAO.getAllOrdersWithUsername();
            
           
            try {
               
                for (Order o : ordersMap.keySet()) {
                    if ("VALID".equals(o.getVerifyStatus()) && o.getDigitalSignature() != null) {
                        
                        String pubKeyPem = keyDAO.getActivePublicKey(o.getUserId());
                        if (pubKeyPem == null) {
                            o.setVerifyStatus("INVALID");
                            continue;
                        }
                        
                        PublicKey pubKey = SignatureUtil.loadPublicKeyFromPem(pubKeyPem);
                       
                        String currentData = o.getOrderCode() + "|" + o.getTotal();
                        boolean isIntact = SignatureUtil.verifySignature(currentData, o.getDigitalSignature(), pubKey);
                        
                        
                        if (!isIntact) {
                            o.setVerifyStatus("INVALID");
                        }
                    }
                }
            } catch (Exception e) {
                System.out.println("Lỗi khi Verify real-time Admin: " + e.getMessage());
                e.printStackTrace();
            }
           

            request.setAttribute("ordersMap", ordersMap);
            request.getRequestDispatcher("/admin/orders.jsp").forward(request, response);
        }
        }
    }
}