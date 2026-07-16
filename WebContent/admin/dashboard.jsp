<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List, java.util.Map, com.complaint.model.Complaint" %>
<%
    if (!"admin".equals(session.getAttribute("userRole"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp"); return;
    }
    List<Complaint> complaints = (List<Complaint>) request.getAttribute("complaints");
    Map<String, Integer> stats = (Map<String, Integer>) request.getAttribute("stats");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<div class="navbar">
  <h1>🛡 Complaint Tracking – Admin</h1>
  <div class="nav-links">
    <span style="opacity:0.8;font-size:13px;">Admin: ${sessionScope.userName}</span>
    <a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a>
    <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Logout</a>
  </div>
</div>

<div class="container">

  <!-- Stats Grid -->
  <div class="stats-grid">
    <a href="${pageContext.request.contextPath}/admin/dashboard" style="text-decoration:none;">
      <div class="stat-card">
        <div class="stat-num"><%= stats != null ? stats.getOrDefault("total",0) : 0 %></div>
        <div class="stat-label">Total Complaints</div>
      </div>
    </a>
    <a href="${pageContext.request.contextPath}/admin/dashboard?status=Open" style="text-decoration:none;">
      <div class="stat-card open">
        <div class="stat-num"><%= stats != null ? stats.getOrDefault("open",0) : 0 %></div>
        <div class="stat-label">Open</div>
      </div>
    </a>
    <a href="${pageContext.request.contextPath}/admin/dashboard?status=In+Progress" style="text-decoration:none;">
      <div class="stat-card prog">
        <div class="stat-num"><%= stats != null ? stats.getOrDefault("inprogress",0) : 0 %></div>
        <div class="stat-label">In Progress</div>
      </div>
    </a>
    <a href="${pageContext.request.contextPath}/admin/dashboard?status=Resolved" style="text-decoration:none;">
      <div class="stat-card res">
        <div class="stat-num"><%= stats != null ? stats.getOrDefault("resolved",0) : 0 %></div>
        <div class="stat-label">Resolved</div>
      </div>
    </a>
    <a href="${pageContext.request.contextPath}/admin/dashboard?status=Closed" style="text-decoration:none;">
      <div class="stat-card">
        <div class="stat-num"><%= stats != null ? stats.getOrDefault("closed",0) : 0 %></div>
        <div class="stat-label">Closed</div>
      </div>
    </a>
    <a href="${pageContext.request.contextPath}/admin/dashboard" style="text-decoration:none;">
      <div class="stat-card crit">
        <div class="stat-num"><%= stats != null ? stats.getOrDefault("critical",0) : 0 %></div>
        <div class="stat-label">Critical</div>
      </div>
    </a>
  </div>

  <!-- Complaints Table -->
  <div class="card">
    <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:16px;">
      <h2 style="border:none;margin:0;padding:0;">
        All Complaints
        <% String af = (String)request.getAttribute("activeFilter");
           if (af != null) { %>
          <span style="font-size:14px;font-weight:400;color:#2a5298;"> – Filtered: <%= af %></span>
        <% } %>
      </h2>
      <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-primary btn-sm">Show All</a>
    </div>

    <% if (complaints == null || complaints.isEmpty()) { %>
      <div style="text-align:center;padding:40px;color:#999;">No complaints found.</div>
    <% } else { %>
    <div style="overflow-x:auto;">
    <table>
      <thead>
        <tr>
          <th>#</th>
          <th>Title</th>
          <th>User</th>
          <th>Category</th>
          <th>Priority</th>
          <th>Status</th>
          <th>Dept</th>
          <th>Date</th>
          <th>Action</th>
        </tr>
      </thead>
      <tbody>
        <% for (Complaint c : complaints) { %>
        <tr>
          <td><strong>#<%= c.getComplaintId() %></strong></td>
          <td><%= c.getTitle().length() > 40 ? c.getTitle().substring(0,40)+"…" : c.getTitle() %></td>
          <td><%= c.getUserName() != null ? c.getUserName() : "—" %></td>
          <td><%= c.getCategory() %></td>
          <td><span class="badge" style="background:<%= c.getPriorityBadgeColor() %>"><%= c.getPriority() %></span></td>
          <td><span class="badge" style="background:<%= c.getStatusBadgeColor() %>"><%= c.getStatus() %></span></td>
          <td><%= c.getDeptName() != null ? c.getDeptName() : "—" %></td>
          <td style="font-size:12px;color:#888;"><%= c.getCreatedAt() != null ? c.getCreatedAt().toString().substring(0,10) : "" %></td>
          <td>
            <a href="${pageContext.request.contextPath}/admin/view?id=<%= c.getComplaintId() %>"
               class="btn btn-primary btn-sm">Manage</a>
          </td>
        </tr>
        <% } %>
      </tbody>
    </table>
    </div>
    <% } %>
  </div>

</div>
</body>
</html>
