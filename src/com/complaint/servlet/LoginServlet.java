package com.complaint.servlet;

import com.complaint.dao.UserDAO;
import com.complaint.model.User;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class LoginServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String email    = req.getParameter("email").trim();
        String password = req.getParameter("password").trim();

        User user = userDAO.login(email, password);
        if (user != null) {
            HttpSession session = req.getSession();
            session.setAttribute("loggedUser", user);
            session.setAttribute("userId",   user.getUserId());
            session.setAttribute("userName", user.getName());
            session.setAttribute("userRole", user.getRole());

            if ("admin".equals(user.getRole())) {
                res.sendRedirect(req.getContextPath() + "/admin/dashboard");
            } else {
                res.sendRedirect(req.getContextPath() + "/user/mycomplaints");
            }
        } else {
            req.setAttribute("error", "Invalid email or password.");
            req.getRequestDispatcher("/login.jsp").forward(req, res);
        }
    }

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        req.getRequestDispatcher("/login.jsp").forward(req, res);
    }
}
