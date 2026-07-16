<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.complaint.model.Complaint, com.complaint.model.ComplaintTimeline, java.util.List" %>
<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp"); return;
    }
    Complaint c = (Complaint) request.getAttribute("complaint");
    List<ComplaintTimeline> timeline = (List<ComplaintTimeline>) request.getAttribute("timeline");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Complaint #<%= c != null ? c.getComplaintId() : "" %></title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<div class="navbar">
  <h1>🛡 Complaint Tracking System</h1>
  <div class="nav-links">
    <a href="${pageContext.request.contextPath}/user/mycomplaints">My Complaints</a>
    <a href="${pageContext.request.contextPath}/user/submit">+ New</a>
    <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Logout</a>
  </div>
</div>

<div class="container" style="max-width:800px;">
  <% if (c != null) { %>

  <!-- Complaint Details -->
  <div class="card">
    <div style="display:flex;justify-content:space-between;align-items:flex-start;margin-bottom:16px;">
      <div>
        <h2 style="border:none;margin:0;padding:0;">Complaint #<%= c.getComplaintId() %></h2>
        <p style="color:#999;font-size:13px;margin-top:4px;">Submitted on <%= c.getCreatedAt() != null ? c.getCreatedAt().toString().substring(0,16) : "" %></p>
      </div>
      <span class="badge" style="background:<%= c.getStatusBadgeColor() %>;font-size:14px;padding:6px 16px;">
        <%= c.getStatus() %>
      </span>
    </div>

    <h3 style="margin-bottom:10px;"><%= c.getTitle() %></h3>
    <p style="color:#555;line-height:1.6;"><%= c.getDescription() %></p>

    <div style="display:grid;grid-template-columns:1fr 1fr 1fr;gap:16px;margin-top:20px;padding-top:16px;border-top:1px solid #eee;">
      <div>
        <div style="font-size:11px;color:#999;text-transform:uppercase;">Category</div>
        <div style="font-weight:600;margin-top:4px;"><%= c.getCategory() %></div>
      </div>
      <div>
        <div style="font-size:11px;color:#999;text-transform:uppercase;">Priority</div>
        <div style="margin-top:4px;">
          <span class="badge" style="background:<%= c.getPriorityBadgeColor() %>"><%= c.getPriority() %></span>
        </div>
      </div>
      <div>
        <div style="font-size:11px;color:#999;text-transform:uppercase;">Department</div>
        <div style="font-weight:600;margin-top:4px;"><%= c.getDeptName() != null ? c.getDeptName() : "—" %></div>
      </div>
      <% if (c.getAssignedTo() != null && !c.getAssignedTo().isEmpty()) { %>
      <div>
        <div style="font-size:11px;color:#999;text-transform:uppercase;">Assigned To</div>
        <div style="font-weight:600;margin-top:4px;"><%= c.getAssignedTo() %></div>
      </div>
      <% } %>
      <% if (c.getResolvedAt() != null) { %>
      <div>
        <div style="font-size:11px;color:#999;text-transform:uppercase;">Resolved On</div>
        <div style="font-weight:600;margin-top:4px;"><%= c.getResolvedAt().toString().substring(0,16) %></div>
      </div>
      <% } %>
    </div>

    <% if (c.getAdminRemarks() != null && !c.getAdminRemarks().isEmpty()) { %>
    <div style="margin-top:16px;padding:12px 16px;background:#f0f4ff;border-radius:6px;border-left:4px solid #2a5298;">
      <strong style="font-size:13px;">Admin Remarks:</strong>
      <p style="margin-top:4px;color:#555;font-size:14px;"><%= c.getAdminRemarks() %></p>
    </div>
    <% } %>

    <div style="margin-top:16px;">
      <a href="${pageContext.request.contextPath}/user/mycomplaints" class="btn" style="background:#eee;color:#333;">← Back</a>
    </div>
  </div>

  <!-- Timeline -->
  <div class="card">
    <h2>📅 Complaint Timeline</h2>
    <% if (timeline != null && !timeline.isEmpty()) { %>
    <div class="timeline">
      <% for (ComplaintTimeline t : timeline) { %>
      <div class="timeline-item">
        <div class="tl-time"><%= t.getChangedAt() != null ? t.getChangedAt().toString().substring(0,16) : "" %></div>
        <div class="tl-title">
          <% if (t.getOldStatus() != null) { %>
            Status changed: <%= t.getOldStatus() %> → <%= t.getNewStatus() %>
          <% } else { %>
            <%= t.getNewStatus() %>
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
      <p style="color:#999;">No timeline entries yet.</p>
    <% } %>
  </div>

  <% } else { %>
    <div class="alert alert-error">Complaint not found.</div>
  <% } %>
</div>

</body>
</html>
