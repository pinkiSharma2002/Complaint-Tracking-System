<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login – Complaint Tracking System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="auth-wrapper">
  <div class="auth-box">
    <h2>🛡 Complaint Tracking</h2>
    <p class="subtitle">Sign in to your account</p>

    <% if ("true".equals(request.getParameter("registered"))) { %>
      <div class="alert alert-success">Registration successful! Please login.</div>
    <% } %>
    <% if (request.getAttribute("error") != null) { %>
      <div class="alert alert-error">${error}</div>
    <% } %>

    <form action="${pageContext.request.contextPath}/login" method="post">
      <div class="form-group">
        <label>Email Address</label>
        <input type="email" name="email" placeholder="you@email.com" required/>
      </div>
      <div class="form-group">
        <label>Password</label>
        <input type="password" name="password" placeholder="••••••••" required/>
      </div>
      <button type="submit" class="btn btn-primary" style="width:100%;margin-top:6px;">Login</button>
    </form>

    <div class="auth-footer">
      Don't have an account? <a href="${pageContext.request.contextPath}/register">Register here</a>
    </div>

    <div style="margin-top:18px;padding:12px;background:#f0f4ff;border-radius:6px;font-size:12px;color:#555;">
      <strong>Demo Credentials:</strong><br/>
      Admin: admin@complaint.com / admin123<br/>
      User:  rahul@email.com / user123
    </div>
  </div>
</div>
</body>
</html>
