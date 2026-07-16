package com.complaint.dao;

import com.complaint.db.DBConnection;
import com.complaint.model.Complaint;
import com.complaint.model.ComplaintTimeline;
import java.sql.*;
import java.util.*;

public class ComplaintDAO {

    // ── Submit new complaint ─────────────────────────────────────
    public boolean submitComplaint(Complaint c) {
        String sql = "INSERT INTO complaints (user_id, dept_id, title, description, category, priority) VALUES (?,?,?,?,?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, c.getUserId());
            ps.setInt(2, c.getDeptId());
            ps.setString(3, c.getTitle());
            ps.setString(4, c.getDescription());
            ps.setString(5, c.getCategory());
            ps.setString(6, c.getPriority());
            int rows = ps.executeUpdate();
            if (rows > 0) {
                ResultSet keys = ps.getGeneratedKeys();
                if (keys.next()) {
                    c.setComplaintId(keys.getInt(1));
                    addTimeline(c.getComplaintId(), "User", null, "Open", "Complaint submitted");
                }
                return true;
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    // ── Get complaints by user ───────────────────────────────────
    public List<Complaint> getComplaintsByUser(int userId) {
        List<Complaint> list = new ArrayList<>();
        String sql = "SELECT c.*, d.dept_name FROM complaints c " +
                     "LEFT JOIN departments d ON c.dept_id = d.dept_id " +
                     "WHERE c.user_id = ? ORDER BY c.created_at DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // ── Get all complaints (admin) ───────────────────────────────
    public List<Complaint> getAllComplaints() {
        List<Complaint> list = new ArrayList<>();
        String sql = "SELECT c.*, u.name AS user_name, u.email AS user_email, d.dept_name " +
                     "FROM complaints c " +
                     "JOIN users u ON c.user_id = u.user_id " +
                     "LEFT JOIN departments d ON c.dept_id = d.dept_id " +
                     "ORDER BY c.created_at DESC";
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                Complaint comp = mapRow(rs);
                try { comp.setUserName(rs.getString("user_name")); }  catch(SQLException ignored) {}
                try { comp.setUserEmail(rs.getString("user_email")); } catch(SQLException ignored) {}
                list.add(comp);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // ── Filter complaints by status (admin) ─────────────────────
    public List<Complaint> getComplaintsByStatus(String status) {
        List<Complaint> list = new ArrayList<>();
        String sql = "SELECT c.*, u.name AS user_name, u.email AS user_email, d.dept_name " +
                     "FROM complaints c " +
                     "JOIN users u ON c.user_id = u.user_id " +
                     "LEFT JOIN departments d ON c.dept_id = d.dept_id " +
                     "WHERE c.status = ? ORDER BY c.created_at DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Complaint comp = mapRow(rs);
                try { comp.setUserName(rs.getString("user_name")); }  catch(SQLException ignored) {}
                try { comp.setUserEmail(rs.getString("user_email")); } catch(SQLException ignored) {}
                list.add(comp);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // ── Get single complaint by ID ───────────────────────────────
    public Complaint getComplaintById(int id) {
        String sql = "SELECT c.*, u.name AS user_name, u.email AS user_email, d.dept_name " +
                     "FROM complaints c " +
                     "JOIN users u ON c.user_id = u.user_id " +
                     "LEFT JOIN departments d ON c.dept_id = d.dept_id " +
                     "WHERE c.complaint_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Complaint comp = mapRow(rs);
                try { comp.setUserName(rs.getString("user_name")); }  catch(SQLException ignored) {}
                try { comp.setUserEmail(rs.getString("user_email")); } catch(SQLException ignored) {}
                return comp;
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    // ── Admin: update status, assign, remarks ───────────────────
    public boolean updateComplaint(int complaintId, String status, String assignedTo,
                                   String remarks, String updatedBy) {
        Complaint old = getComplaintById(complaintId);
        String sql = "UPDATE complaints SET status=?, assigned_to=?, admin_remarks=?, " +
                     "resolved_at = CASE WHEN ? IN ('Resolved','Closed') THEN NOW() ELSE resolved_at END " +
                     "WHERE complaint_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, assignedTo);
            ps.setString(3, remarks);
            ps.setString(4, status);
            ps.setInt(5, complaintId);
            boolean done = ps.executeUpdate() > 0;
            if (done && old != null && !old.getStatus().equals(status)) {
                addTimeline(complaintId, updatedBy, old.getStatus(), status, remarks);
            }
            return done;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    // ── Timeline ─────────────────────────────────────────────────
    public boolean addTimeline(int complaintId, String changedBy, String oldStatus,
                               String newStatus, String remarks) {
        String sql = "INSERT INTO complaint_timeline (complaint_id, changed_by, old_status, new_status, remarks) VALUES (?,?,?,?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, complaintId);
            ps.setString(2, changedBy);
            ps.setString(3, oldStatus);
            ps.setString(4, newStatus);
            ps.setString(5, remarks);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public List<ComplaintTimeline> getTimeline(int complaintId) {
        List<ComplaintTimeline> list = new ArrayList<>();
        String sql = "SELECT * FROM complaint_timeline WHERE complaint_id=? ORDER BY changed_at ASC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, complaintId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ComplaintTimeline t = new ComplaintTimeline();
                t.setTimelineId(rs.getInt("timeline_id"));
                t.setComplaintId(rs.getInt("complaint_id"));
                t.setChangedBy(rs.getString("changed_by"));
                t.setOldStatus(rs.getString("old_status"));
                t.setNewStatus(rs.getString("new_status"));
                t.setRemarks(rs.getString("remarks"));
                t.setChangedAt(rs.getTimestamp("changed_at"));
                list.add(t);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // ── Dashboard stats (admin) ──────────────────────────────────
    public Map<String, Integer> getDashboardStats() {
        Map<String, Integer> stats = new LinkedHashMap<>();
        String sql = "SELECT " +
                     "COUNT(*) AS total, " +
                     "SUM(status='Open') AS open_count, " +
                     "SUM(status='In Progress') AS inprogress_count, " +
                     "SUM(status='Resolved') AS resolved_count, " +
                     "SUM(status='Closed') AS closed_count, " +
                     "SUM(priority='Critical') AS critical_count " +
                     "FROM complaints";
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) {
                stats.put("total",       rs.getInt("total"));
                stats.put("open",        rs.getInt("open_count"));
                stats.put("inprogress",  rs.getInt("inprogress_count"));
                stats.put("resolved",    rs.getInt("resolved_count"));
                stats.put("closed",      rs.getInt("closed_count"));
                stats.put("critical",    rs.getInt("critical_count"));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return stats;
    }

    // ── Get departments ──────────────────────────────────────────
    public List<String[]> getDepartments() {
        List<String[]> list = new ArrayList<>();
        String sql = "SELECT dept_id, dept_name FROM departments ORDER BY dept_name";
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) list.add(new String[]{rs.getString("dept_id"), rs.getString("dept_name")});
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    private Complaint mapRow(ResultSet rs) throws SQLException {
        Complaint c = new Complaint();
        c.setComplaintId(rs.getInt("complaint_id"));
        c.setUserId(rs.getInt("user_id"));
        c.setTitle(rs.getString("title"));
        c.setDescription(rs.getString("description"));
        c.setCategory(rs.getString("category"));
        c.setPriority(rs.getString("priority"));
        c.setStatus(rs.getString("status"));
        c.setAssignedTo(rs.getString("assigned_to"));
        c.setAdminRemarks(rs.getString("admin_remarks"));
        c.setCreatedAt(rs.getTimestamp("created_at"));
        c.setUpdatedAt(rs.getTimestamp("updated_at"));
        c.setResolvedAt(rs.getTimestamp("resolved_at"));
        try { c.setDeptId(rs.getInt("dept_id")); }    catch(SQLException ignored) {}
        try { c.setDeptName(rs.getString("dept_name")); } catch(SQLException ignored) {}
        return c;
    }
}
