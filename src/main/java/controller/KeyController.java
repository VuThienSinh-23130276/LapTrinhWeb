package controller;

import DAO.UserKeyDAO;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/KeyController")
public class KeyController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        User user = (session == null) ? null : (User) session.getAttribute("user");

        PrintWriter out = response.getWriter();

        if (user == null) {
            out.print("{\"success\":false,\"message\":\"Unauthorized\"}");
            out.flush();
            return;
        }

        String action = request.getParameter("action");
        if ("reissue".equals(action)) {
            String publicKey = request.getParameter("publicKey");

            if (publicKey == null || publicKey.isBlank()) {
                out.print("{\"success\":false,\"message\":\"Invalid Public Key\"}");
                out.flush();
                return;
            }

            try {
                int userId = user.getId();
                
                UserKeyDAO.revokeOldKeys(userId);
                
                int currentVersion = UserKeyDAO.getMaxVersion(userId);
                int nextVersion = currentVersion + 1;
                
                boolean isSaved = UserKeyDAO.saveNewKey(userId, publicKey, nextVersion);

                if (isSaved) {
                    out.print("{\"success\":true}");
                } else {
                    out.print("{\"success\":false,\"message\":\"Database error\"}");
                }
            } catch (Exception e) {
                e.printStackTrace();
                out.print("{\"success\":false,\"message\":\"" + e.getMessage() + "\"}");
            }
        } else {
            out.print("{\"success\":false,\"message\":\"Unknown action\"}");
        }
        out.flush();
    }
}