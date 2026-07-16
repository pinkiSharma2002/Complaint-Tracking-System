<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.complaint.model.Complaint, com.complaint.model.ComplaintTimeline, java.util.List" %>
<%
    if (!"admin".equals(session.getAttribute("userRole"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp"); return;
    }
    Complaint c = (Complaint) request.getAttribute("complaint");
    List<ComplaintTimeline> timeline = (List<ComplaintTimeline>) request.getAttribute("timeline");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Complaint #<%= c != null ? c.getComplaintId() : "" %></title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<div class="navbar">
  <h1>🛡 Complaint Tracking – Admin</h1>
  <div class="nav-links">
    <a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a>
    <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Logout</a>
  </div>
</div>

<div class="container" style="max-width:900px;">

<% if ("true".equals(request.getParameter("updated"))) { %>
  <div class="alert alert-success">✅ Complaint updated successfully!</div>
<% } %>

<% if (c != null) { %>

  <div style="display:grid;grid-template-columns:1fr 360px;gap:20px;">

    <!-- Left: Details + Timeline -->
    <div>
      <!-- Complaint Info -->
      <div class="card">
        <div style="display:flex;justify-content:space-between;align-items:flex-start;">
          <h2 style="border:none;margin:0;padding:0;">Complaint #<%= c.getComplaintId() %></h2>
          <span class="badge" style="background:<%= c.getStatusBadgeColor() %>;font-size:14px;padding:6px 16px;">
            <%= c.getStatus() %>
          </span>
        </div>
        <p style="color:#999;font-size:12px;margin:6px 0 14px;">
          Submitted by <strong><%= c.getUserName() %></strong> (<%= c.getUserEmail() %>) on
          <%= c.getCreatedAt() != null ? c.getCreatedAt().toString().substring(0,16) : "" %>
        </p>

        <h3 style="margin-bottom:8px;"><%= c.getTitle() %></h3>
        <p style="color:#555;line-height:1.7;"><%= c.getDescription() %></p>

        <div style="display:grid;grid-template-columns:1fr 1fr 1fr;gap:14px;margin-top:18px;padding-top:14px;border-top:1px solid #eee;">
          <div>
            <div style="font-size:11px;color:#999;text-transform:uppercase;">Category</div>
            <div style="font-weight:600;"><%= c.getCategory() %></div>
          </div>
          <div>
            <div style="font-size:11px;color:#999;text-transform:uppercase;">Priority</div>
            <span class="badge" style="background:<%= c.getPriorityBadgeColor() %>"><%= c.getPriority() %></span>
          </div>
          <div>
            <div style="font-size:11px;color:#999;text-transform:uppercase;">Department</div>
            <div style="font-weight:600;"><%= c.getDeptName() != null ? c.getDeptName() : "—" %></div>
          </div>
          <% if (c.getAssignedTo() != null) { %>
          <div>
            <div style="font-size:11px;color:#999;text-transform:uppercase;">Assigned To</div>
            <div style="font-weight:600;"><%= c.getAssignedTo() %></div>
          </div>
          <% } %>
        </div>
      </div>

      <!-- Timeline -->
      <div class="card">
        <h2>📅 Status Timeline</h2>
        <% if (timeline != null && !timeline.isEmpty()) { %>
        <div class="timeline">
          <% for (ComplaintTimeline t : timeline) { %>
          <div class="timeline-item">
            <div class="tl-time"><%= t.getChangedAt() != null ? t.getChangedAt().toString().substring(0,16) : "" %></div>
            <div class="tl-title">
              <% if (t.getOldStatus() != null) { %>
                <%= t.getOldStatus() %> → <strong><%= t.getNewStatus() %></strong>
              <% } else { %>
                <strong><%= t.getNewStatus() %></strong>
              <% } %>
              <span style="color:#999;font-weight:400;font-size:12px;"> by <%= t.getChangedBy() %></span>
            </div>
            <% if (t.getRemarks() != null && !t.getRemarks().isEmpty()) { %>
            <div class="tl-desc"><%= t.getRemarks() %></div>
            <% } %>
          </div>
          <% } %>
        </div>
        <% } else { %>
          <p style="color:#999;">No history yet.</p>
        <% } %>
      </div>
    </div>

    <!-- Right: Update Form -->
    <div>
      <div class="card" style="position:sticky;top:20px;">
        <h2>⚙️ Update Complaint</h2>
        <form action="${pageContext.request.contextPath}/admin/update" method="post">
          <input type="hidden" name="complaintId" value="<%= c.getComplaintId() %>"/>

          <div class="form-group">
            <label>Status</label>
            <select name="status">
              <% String[] statuses = {"Open","In Progress","Resolved","Closed","Rejected"};
                 for (String s : statuses) { %>
                <option value="<%= s %>" <%= s.equals(c.getStatus()) ? "selected" : "" %>><%= s %></option>
              <% } %>
            </select>
          </div>

          <div class="form-group">
            <label>Assign To</label>
            <input type="text" name="assignedTo"
                   value="<%= c.getAssignedTo() != null ? c.getAssignedTo() : "" %>"
                   placeholder="Officer / Department name"/>
          </div>

          <div class="form-group">
            <label>Admin Remarks</label>
            <textarea name="remarks" rows="4" placeholder="Add update or remarks..."><%= c.getAdminRemarks() != null ? c.getAdminRemarks() : "" %></textarea>
          </div>

          <button type="submit" class="btn btn-success" style="width:100%;">Update Complaint</button>
        </form>

        <a href="${pageContext.request.contextPath}/admin/dashboard"
           style="display:block;text-align:center;margin-top:12px;color:#2a5298;font-size:13px;">
           ← Back to Dashboard
        </a>
      </div>
    </div>

  </div>

<% } else { %>
  <div class="alert alert-error">Complaint not found.</div>
<% } %>
</div>
</body>
</html>
