package com.complaint.model;

import java.sql.Timestamp;

public class Complaint {
    private int       complaintId;
    private int       userId;
    private int       deptId;
    private String    title;
    private String    description;
    private String    category;
    private String    priority;
    private String    status;
    private String    assignedTo;
    private String    adminRemarks;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private Timestamp resolvedAt;

    // Display fields (joined)
    private String userName;
    private String userEmail;
    private String deptName;

    public Complaint() {}

    // ── Getters & Setters ──────────────────────────────────────
    public int       getComplaintId()            { return complaintId; }
    public void      setComplaintId(int v)       { complaintId = v; }
    public int       getUserId()                 { return userId; }
    public void      setUserId(int v)            { userId = v; }
    public int       getDeptId()                 { return deptId; }
    public void      setDeptId(int v)            { deptId = v; }
    public String    getTitle()                  { return title; }
    public void      setTitle(String v)          { title = v; }
    public String    getDescription()            { return description; }
    public void      setDescription(String v)    { description = v; }
    public String    getCategory()               { return category; }
    public void      setCategory(String v)       { category = v; }
    public String    getPriority()               { return priority; }
    public void      setPriority(String v)       { priority = v; }
    public String    getStatus()                 { return status; }
    public void      setStatus(String v)         { status = v; }
    public String    getAssignedTo()             { return assignedTo; }
    public void      setAssignedTo(String v)     { assignedTo = v; }
    public String    getAdminRemarks()           { return adminRemarks; }
    public void      setAdminRemarks(String v)   { adminRemarks = v; }
    public Timestamp getCreatedAt()              { return createdAt; }
    public void      setCreatedAt(Timestamp v)   { createdAt = v; }
    public Timestamp getUpdatedAt()              { return updatedAt; }
    public void      setUpdatedAt(Timestamp v)   { updatedAt = v; }
    public Timestamp getResolvedAt()             { return resolvedAt; }
    public void      setResolvedAt(Timestamp v)  { resolvedAt = v; }
    public String    getUserName()               { return userName; }
    public void      setUserName(String v)       { userName = v; }
    public String    getUserEmail()              { return userEmail; }
    public void      setUserEmail(String v)      { userEmail = v; }
    public String    getDeptName()               { return deptName; }
    public void      setDeptName(String v)       { deptName = v; }

    // Helper: badge color for status
    public String getStatusBadgeColor() {
        switch (status) {
            case "Open":        return "#e74c3c";
            case "In Progress": return "#f39c12";
            case "Resolved":    return "#27ae60";
            case "Closed":      return "#7f8c8d";
            case "Rejected":    return "#c0392b";
            default:            return "#3498db";
        }
    }

    // Helper: badge color for priority
    public String getPriorityBadgeColor() {
        switch (priority) {
            case "Critical": return "#c0392b";
            case "High":     return "#e74c3c";
            case "Medium":   return "#f39c12";
            case "Low":      return "#27ae60";
            default:         return "#7f8c8d";
        }
    }
}
