<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp"); return;
    }
    List<String[]> departments = (List<String[]>) request.getAttribute("departments");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Submit Complaint</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<!-- Navbar -->
<div class="navbar">
  <h1>🛡 Complaint Tracking System</h1>
  <div class="nav-links">
    <a href="${pageContext.request.contextPath}/user/mycomplaints">My Complaints</a>
    <a href="${pageContext.request.contextPath}/user/submit">+ New</a>
    <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Logout</a>
  </div>
</div>

<div class="container" style="max-width:680px;">
  <div class="card">
    <h2>📝 Submit a New Complaint</h2>

    <% if (request.getAttribute("error") != null) { %>
      <div class="alert alert-error">${error}</div>
    <% } %>

    <form action="${pageContext.request.contextPath}/user/submit" method="post">

      <div class="form-group">
        <label>Complaint Title *</label>
        <input type="text" name="title" placeholder="Short description of the issue" required maxlength="200"/>
      </div>

      <div class="form-row">
        <div class="form-group">
          <label>Category *</label>
          <select name="category" required>
            <option value="">-- Select Category --</option>
            <option>Infrastructure</option>
            <option>Academic</option>
            <option>Administration</option>
            <option>Technical</option>
            <option>Other</option>
          </select>
        </div>
        <div class="form-group">
          <label>Priority *</label>
          <select name="priority" required>
            <option value="Low">Low</option>
            <option value="Medium" selected>Medium</option>
            <option value="High">High</option>
            <option value="Critical">Critical</option>
          </select>
        </div>
      </div>

      <div class="form-group">
        <label>Department</label>
        <select name="deptId">
          <option value="5">General</option>
          <% if (departments != null) {
              for (String[] dept : departments) { %>
            <option value="<%= dept[0] %>"><%= dept[1] %></option>
          <% }} %>
        </select>
      </div>

      <div class="form-group">
        <label>Detailed Description *</label>
        <textarea name="description" rows="5" placeholder="Describe the issue in detail..." required></textarea>
      </div>

      <div style="display:flex;gap:12px;">
        <button type="submit" class="btn btn-primary">Submit Complaint</button>
        <a href="${pageContext.request.contextPath}/user/mycomplaints" class="btn" style="background:#eee;color:#333;">Cancel</a>
      </div>
    </form>
  </div>
</div>

</body>
</html>
