<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Register – Complaint Tracking System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="auth-wrapper">
  <div class="auth-box">
    <h2>🛡 Create Account</h2>
    <p class="subtitle">Register to submit complaints</p>

    <% if (request.getAttribute("error") != null) { %>
      <div class="alert alert-error">${error}</div>
    <% } %>

    <form action="${pageContext.request.contextPath}/register" method="post">
      <div class="form-group">
        <label>Full Name</label>
        <input type="text" name="name" placeholder="Your full name" required/>
      </div>
      <div class="form-group">
        <label>Email Address</label>
        <input type="email" name="email" placeholder="you@email.com" required/>
      </div>
      <div class="form-group">
        <label>Phone Number</label>
        <input type="text" name="phone" placeholder="10-digit mobile number"/>
      </div>
      <div class="form-group">
        <label>Password</label>
        <input type="password" name="password" placeholder="Min 6 characters" required minlength="6"/>
      </div>
      <button type="submit" class="btn btn-primary" style="width:100%;margin-top:6px;">Register</button>
    </form>

    <div class="auth-footer">
      Already have an account? <a href="${pageContext.request.contextPath}/login">Login here</a>
    </div>
  </div>
</div>
</body>
</html>
