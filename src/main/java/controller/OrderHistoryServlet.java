package controller;

import DAO.KeyDAO;
import DAO.OrderDAO;
import model.Order;
import model.User;
import util.SignatureUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.security.PublicKey;
import java.util.List;

@WebServlet("/orders")
public class OrderHistoryServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private KeyDAO keyDAO = new KeyDAO(); // Thêm KeyDAO để gọi Public Key

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session == null) ? null : (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

       
        List<Order> orders = OrderDAO.getOrdersByUser(user.getId());

  try {
            
            String pubKeyPem = keyDAO.getActivePublicKey(user.getId());
            PublicKey pubKey = null;
            if (pubKeyPem != null) {
                pubKey = SignatureUtil.loadPublicKeyFromPem(pubKeyPem);
            }

           
            for (Order o : orders) {
               
                if ("VALID".equals(o.getVerifyStatus()) && o.getDigitalSignature() != null) {
                    
                   
                    if (pubKey == null) {
                        o.setVerifyStatus("INVALID");
                        continue;
                    }

                  
                    String currentData = o.getOrderCode() + "|" + o.getTotal();

                   
                    String originalSignature = o.getDigitalSignature();

                  
                    boolean isIntact = SignatureUtil.verifySignature(currentData, originalSignature, pubKey);

                    
                    if (!isIntact) {
                     
                        o.setVerifyStatus("INVALID");
                        
                        
                    }
                }
            }
        } catch (Exception e) {
            System.out.println("Lỗi khi Verify real-time: " + e.getMessage());
            e.printStackTrace();
        }

        request.setAttribute("orders", orders);
        request.getRequestDispatcher("/orders.jsp").forward(request, response);
    }
}