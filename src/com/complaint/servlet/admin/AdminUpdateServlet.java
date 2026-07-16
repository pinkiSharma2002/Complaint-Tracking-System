package com.complaint.servlet.admin;

import com.complaint.dao.ComplaintDAO;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class AdminUpdateServlet extends HttpServlet {
    private final ComplaintDAO dao = new ComplaintDAO();

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        if (!"admin".equals(req.getSession().getAttribute("userRole"))) {
            res.sendRedirect(req.getContextPath() + "/login.jsp"); return;
        }
        int    id         = Integer.parseInt(req.getParameter("complaintId"));
        String status     = req.getParameter("status");
        String assignedTo = req.getParameter("assignedTo");
        String remarks    = req.getParameter("remarks");
        String updatedBy  = (String) req.getSession().getAttribute("userName");

        dao.updateComplaint(id, status, assignedTo, remarks, updatedBy);
        res.sendRedirect(req.getContextPath() + "/admin/view?id=" + id + "&updated=true");
    }
}
