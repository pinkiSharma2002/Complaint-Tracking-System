package com.complaint.servlet.admin;

import com.complaint.dao.ComplaintDAO;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class AdminViewServlet extends HttpServlet {
    private final ComplaintDAO dao = new ComplaintDAO();

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        if (!"admin".equals(req.getSession().getAttribute("userRole"))) {
            res.sendRedirect(req.getContextPath() + "/login.jsp"); return;
        }
        int id = Integer.parseInt(req.getParameter("id"));
        req.setAttribute("complaint", dao.getComplaintById(id));
        req.setAttribute("timeline",  dao.getTimeline(id));
        req.getRequestDispatcher("/admin/view_complaint.jsp").forward(req, res);
    }
}
