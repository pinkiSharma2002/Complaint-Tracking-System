package com.complaint.servlet.user;

import com.complaint.dao.ComplaintDAO;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class ViewComplaintServlet extends HttpServlet {
    private final ComplaintDAO dao = new ComplaintDAO();

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        if (req.getSession().getAttribute("userId") == null) {
            res.sendRedirect(req.getContextPath() + "/login.jsp"); return;
        }
        int id = Integer.parseInt(req.getParameter("id"));
        req.setAttribute("complaint", dao.getComplaintById(id));
        req.setAttribute("timeline",  dao.getTimeline(id));
        req.getRequestDispatcher("/user/view_complaint.jsp").forward(req, res);
    }
}
