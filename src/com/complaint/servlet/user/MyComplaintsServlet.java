package com.complaint.servlet.user;

import com.complaint.dao.ComplaintDAO;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class MyComplaintsServlet extends HttpServlet {
    private final ComplaintDAO dao = new ComplaintDAO();

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        HttpSession session = req.getSession();
        if (session.getAttribute("userId") == null) {
            res.sendRedirect(req.getContextPath() + "/login.jsp"); return;
        }
        int userId = (int) session.getAttribute("userId");
        req.setAttribute("complaints", dao.getComplaintsByUser(userId));
        req.getRequestDispatcher("/user/my_complaints.jsp").forward(req, res);
    }
}
