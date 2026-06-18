package controller;

import DAO.KeyDAO;
import DAO.OrderDAO;
import model.User;
import util.SignatureUtil;

import java.io.IOException;
import java.security.PublicKey;
import java.util.Base64;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/SignServlet")
public class SignServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private KeyDAO keyDAO = new KeyDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Cấu hình UTF-8 để không bị lỗi font tiếng Việt
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        Integer orderId = (Integer) session.getAttribute("lastOrderId");
        String signature = request.getParameter("signature");
        String total = request.getParameter("total"); 

        if (orderId == null || signature == null || signature.isEmpty()) {
            request.setAttribute("error", "Dữ liệu chữ ký không hợp lệ hoặc phiên làm việc đã hết hạn!");
            request.getRequestDispatcher("/sign.jsp").forward(request, response);
            return;
        }

        try {
            // 1. Kiểm tra định dạng Base64
            byte[] signatureBytes = Base64.getDecoder().decode(signature);

            // 2. Lấy Public Key từ DB
            String pubKeyPem = keyDAO.getActivePublicKey(user.getId());
            if (pubKeyPem == null) {
                // ĐẨY LỖI VỀ TRANG JSP
                request.setAttribute("error", "Lỗi: Không tìm thấy Public Key! Khóa của bạn có thể chưa đăng ký hoặc đã bị thu hồi bởi chủ sở hữu nếu bạn không phải chủ xin hãy thận trọng .");
                request.getRequestDispatcher("/sign.jsp").forward(request, response);
                return;
            }
            PublicKey pubKey = SignatureUtil.loadPublicKeyFromPem(pubKeyPem);

            // 3. Tái tạo dữ liệu để Verify
            String orderCode = (String) session.getAttribute("lastOrderCode");
            String dataToVerify = orderCode + "|" + total;

            // 4. Xác thực chữ ký
            boolean isValid = SignatureUtil.verifySignature(dataToVerify, signature, pubKey);

            if (isValid) {
                OrderDAO.saveSignature(orderId, signature, keyDAO.getActiveKeyId(user.getId()));
                
                session.removeAttribute("lastOrderId");
                session.removeAttribute("lastOrderCode");
                session.removeAttribute("totalPrice");
                
                response.sendRedirect(request.getContextPath() + "/orders");
            } else {
                request.setAttribute("error", "Xác thực thất bại! Chữ ký không khớp với dữ liệu đơn hàng hoặc đã bị làm giả.");
                request.getRequestDispatcher("/sign.jsp").forward(request, response);
            }
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", "Lỗi: Chữ ký không đúng định dạng Base64!");
            request.getRequestDispatcher("/sign.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("/sign.jsp").forward(request, response);
        }
    }
}