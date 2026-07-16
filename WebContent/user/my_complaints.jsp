<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List, com.complaint.model.Complaint" %>
<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp"); return;
    }
    List<Complaint> complaints = (List<Complaint>) request.getAttribute("complaints");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Complaints</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<div class="navbar">
  <h1>🛡 Complaint Tracking System</h1>
  <div class="nav-links">
    <span style="opacity:0.8;font-size:13px;">Hello, ${sessionScope.userName}</span>
    <a href="${pageContext.request.contextPath}/user/mycomplaints">My Complaints</a>
    <a href="${pageContext.request.contextPath}/user/submit">+ New Complaint</a>
    <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Logout</a>
  </div>
</div>

<div class="container">

  <% if ("true".equals(request.getParameter("submitted"))) { %>
    <div class="alert alert-success">✅ Complaint submitted successfully! We will review it soon.</div>
  <% } %>

  <div class="card">
    <h2>📋 My Complaints</h2>

    <% if (complaints == null || complaints.isEmpty()) { %>
      <div style="text-align:center;padding:40px;color:#999;">
        <div style="font-size:40px;">📭</div>
        <p style="margin-top:10px;">No complaints submitted yet.</p>
        <a href="${pageContext.request.contextPath}/user/submit" class="btn btn-primary" style="margin-top:14px;">Submit First Complaint</a>
      </div>
    <% } else { %>
      <table>
        <thead>
          <tr>
            <th>#ID</th>
            <th>Title</th>
            <th>Category</th>
            <th>Priority</th>
            <th>Status</th>
            <th>Department</th>
            <th>Submitted</th>
            <th>Action</th>
          </tr>
        </thead>
        <tbody>
          <% for (Complaint c : complaints) { %>
          <tr>
            <td><strong>#<%= c.getComplaintId() %></strong></td>
            <td><%= c.getTitle() %></td>
            <td><%= c.getCategory() %></td>
            <td>
              <span class="badge" style="background:<%= c.getPriorityBadgeColor() %>">
                <%= c.getPriority() %>
              </span>
            </td>
            <td>
              <span class="badge" style="background:<%= c.getStatusBadgeColor() %>">
                <%= c.getStatus() %>
              </span>
            </td>
            <td><%= c.getDeptName() != null ? c.getDeptName() : "—" %></td>
            <td style="font-size:12px;color:#888;"><%= c.getCreatedAt() != null ? c.getCreatedAt().toString().substring(0,16) : "" %></td>
            <td>
              <a href="${pageContext.request.contextPath}/user/view?id=<%= c.getComplaintId() %>"
                 class="btn btn-primary btn-sm">View</a>
            </td>
          </tr>
          <% } %>
        </tbody>
      </table>
    <% } %>
  </div>
</div>

</body>
</html>
