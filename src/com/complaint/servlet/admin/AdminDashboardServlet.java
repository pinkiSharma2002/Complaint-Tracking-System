package com.complaint.servlet.admin;

import com.complaint.dao.ComplaintDAO;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class AdminDashboardServlet extends HttpServlet {
    private final ComplaintDAO dao = new ComplaintDAO();

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        HttpSession session = req.getSession();
        if (!"admin".equals(session.getAttribute("userRole"))) {
            res.sendRedirect(req.getContextPath() + "/login.jsp"); return;
        }
        String filter = req.getParameter("status");
        if (filter != null && !filter.isEmpty()) {
            req.setAttribute("complaints", dao.getComplaintsByStatus(filter));
            req.setAttribute("activeFilter", filter);
        } else {
            req.setAttribute("complaints", dao.getAllComplaints());
        }
        req.setAttribute("stats", dao.getDashboardStats());
        req.getRequestDispatcher("/admin/dashboard.jsp").forward(req, res);
    }
}
