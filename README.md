# 🛡 Complaint Tracking System
### JSP + Advanced Java + MySQL Mini Project

---

## 📁 Project Structure

```
ComplaintTrackingSystem/
│
├── src/com/complaint/
│   ├── db/         DBConnection.java
│   ├── model/      User.java, Complaint.java, ComplaintTimeline.java
│   ├── dao/        UserDAO.java, ComplaintDAO.java
│   └── servlet/
│       ├── LoginServlet.java, RegisterServlet.java, LogoutServlet.java
│       ├── user/   SubmitComplaintServlet.java, MyComplaintsServlet.java, ViewComplaintServlet.java
│       └── admin/  AdminDashboardServlet.java, AdminViewServlet.java, AdminUpdateServlet.java
│
├── WebContent/
│   ├── WEB-INF/    web.xml
│   ├── css/        style.css
│   ├── index.jsp, login.jsp, register.jsp
│   ├── user/       submit_complaint.jsp, my_complaints.jsp, view_complaint.jsp
│   └── admin/      dashboard.jsp, view_complaint.jsp
│
└── database/
    └── complaint_db.sql
```

---

## ⚙️ Setup Steps

### Step 1: Database Setup
1. Open MySQL Workbench or Command Prompt
2. Run the SQL file:
   ```sql
   source /path/to/complaint_db.sql
   ```
   OR copy-paste the contents of `database/complaint_db.sql` and execute.

### Step 2: Eclipse / IntelliJ Setup
1. Open IDE → File → New → **Dynamic Web Project**
2. Project Name: `ComplaintTrackingSystem`
3. Copy `src/` files into your `src` folder
4. Copy `WebContent/` files into your `WebContent` folder

### Step 3: Add MySQL Connector JAR
1. Download `mysql-connector-java-8.x.x.jar` from https://dev.mysql.com/downloads/connector/j/
2. Place it inside `WebContent/WEB-INF/lib/`
3. Right-click jar → Build Path → Add to Build Path

### Step 4: Configure Database Password
Open `src/com/complaint/db/DBConnection.java` and update:
```java
private static final String PASS = "your_mysql_password";
```

### Step 5: Run on Tomcat
1. Right-click Project → Run As → Run on Server
2. Choose Apache Tomcat 9 (or 8.5)
3. Open browser: http://localhost:8080/ComplaintTrackingSystem/

---

## 🔑 Login Credentials

| Role  | Email                   | Password  |
|-------|-------------------------|-----------|
| Admin | admin@complaint.com     | admin123  |
| User  | rahul@email.com         | user123   |
| User  | priya@email.com         | user123   |

---

## ✅ Features

### User Side
- Register & Login
- Submit complaint (title, category, priority, department, description)
- View all my complaints with status badges
- View detailed complaint + full status timeline

### Admin Side
- Dashboard with stats (Total / Open / In Progress / Resolved / Critical)
- Click stat cards to filter complaints by status
- View any complaint in detail
- Update status (Open → In Progress → Resolved → Closed / Rejected)
- Assign complaint to an officer
- Add admin remarks
- Auto-records every status change in timeline

---

## 🗄️ Database Tables

| Table               | Purpose                        |
|---------------------|-------------------------------|
| users               | Login accounts (user + admin) |
| departments         | Department list               |
| complaints          | All complaints                |
| complaint_timeline  | Every status change history   |

---

## 🛠️ Tech Stack

| Layer      | Technology            |
|------------|-----------------------|
| Frontend   | JSP + HTML + CSS      |
| Backend    | Java Servlets         |
| Database   | MySQL + JDBC          |
| Server     | Apache Tomcat 9       |
| IDE        | Eclipse / IntelliJ    |
