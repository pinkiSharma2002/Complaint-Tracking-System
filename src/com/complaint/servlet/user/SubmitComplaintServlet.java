package com.complaint.servlet.user;

import com.complaint.dao.ComplaintDAO;
import com.complaint.model.Complaint;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class SubmitComplaintServlet extends HttpServlet {
    private final ComplaintDAO dao = new ComplaintDAO();

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        if (req.getSession().getAttribute("userId") == null) {
            res.sendRedirect(req.getContextPath() + "/login.jsp"); return;
        }
        req.setAttribute("departments", dao.getDepartments());
        req.getRequestDispatcher("/user/submit_complaint.jsp").forward(req, res);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        HttpSession session = req.getSession();
        if (session.getAttribute("userId") == null) {
            res.sendRedirect(req.getContextPath() + "/login.jsp"); return;
        }
        Complaint c = new Complaint();
        c.setUserId((int) session.getAttribute("userId"));
        c.setTitle(req.getParameter("title").trim());
        c.setDescription(req.getParameter("description").trim());
        c.setCategory(req.getParameter("category"));
        c.setPriority(req.getParameter("priority"));
        c.setDeptId(Integer.parseInt(req.getParameter("deptId")));

        if (dao.submitComplaint(c)) {
            res.sendRedirect(req.getContextPath() + "/user/mycomplaints?submitted=true");
        } else {
            req.setAttribute("error", "Failed to submit complaint. Try again.");
            req.setAttribute("departments", dao.getDepartments());
            req.getRequestDispatcher("/user/submit_complaint.jsp").forward(req, res);
        }
    }
}
