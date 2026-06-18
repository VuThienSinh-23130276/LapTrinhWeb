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

        HttpSession session = request.getSession(false);
        // Kiểm tra session và dữ liệu cần thiết
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        Integer orderId = (Integer) session.getAttribute("lastOrderId");
        String signature = request.getParameter("signature");
        String total = request.getParameter("total"); // Lấy từ input hidden trong sign.jsp

        if (orderId == null || signature == null || signature.isEmpty()) {
            response.getWriter().println("Dữ liệu chữ ký không hợp lệ!");
            return;
        }

        try {
            // 1. Kiểm tra định dạng Base64 của chữ ký
            byte[] signatureBytes = Base64.getDecoder().decode(signature);

            // 2. Lấy Public Key từ DB
            String pubKeyPem = keyDAO.getActivePublicKey(user.getId());
            if (pubKeyPem == null) {
                response.getWriter().println("Lỗi: Không tìm thấy Public Key!");
                return;
            }
            PublicKey pubKey = SignatureUtil.loadPublicKeyFromPem(pubKeyPem);

            // 3. Tái tạo dữ liệu để Verify (Phải khớp 100% với chuỗi ký trong Tool Offline)
            String orderCode = (String) session.getAttribute("lastOrderCode");
            String dataToVerify = orderCode + "|" + total;

            // 4. Xác thực chữ ký
            boolean isValid = SignatureUtil.verifySignature(dataToVerify, signature, pubKey);

            if (isValid) {
                // Lưu chữ ký vào database
                OrderDAO.saveSignature(orderId, signature, keyDAO.getActiveKeyId(user.getId()));
                
                // Xóa session cũ và chuyển hướng đến trang danh sách đơn hàng
                session.removeAttribute("lastOrderId");
                session.removeAttribute("lastOrderCode");
                session.removeAttribute("totalPrice");
                
                response.sendRedirect(request.getContextPath() + "/orders");
            } else {
                response.getWriter().println("<h1>Xác thực thất bại!</h1><p>Chữ ký không khớp với dữ liệu đơn hàng.</p>");
            }
        } catch (IllegalArgumentException e) {
            response.getWriter().println("Lỗi: Chữ ký không đúng định dạng Base64!");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Lỗi hệ thống: " + e.getMessage());
        }
    }
}