package com.complaint.servlet;

import com.complaint.dao.UserDAO;
import com.complaint.model.User;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class RegisterServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String name     = req.getParameter("name").trim();
        String email    = req.getParameter("email").trim();
        String password = req.getParameter("password").trim();
        String phone    = req.getParameter("phone").trim();

        if (userDAO.emailExists(email)) {
            req.setAttribute("error", "Email already registered. Please login.");
            req.getRequestDispatcher("/register.jsp").forward(req, res);
            return;
        }
        User user = new User();
        user.setName(name); user.setEmail(email);
        user.setPassword(password); user.setPhone(phone);

        if (userDAO.register(user)) {
            res.sendRedirect(req.getContextPath() + "/login.jsp?registered=true");
        } else {
            req.setAttribute("error", "Registration failed. Please try again.");
            req.getRequestDispatcher("/register.jsp").forward(req, res);
        }
    }

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        req.getRequestDispatcher("/register.jsp").forward(req, res);
    }
}
