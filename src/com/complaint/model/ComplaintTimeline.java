package com.complaint.model;

import java.sql.Timestamp;

public class ComplaintTimeline {
    private int       timelineId;
    private int       complaintId;
    private String    changedBy;
    private String    oldStatus;
    private String    newStatus;
    private String    remarks;
    private Timestamp changedAt;

    public int       getTimelineId()           { return timelineId; }
    public void      setTimelineId(int v)      { timelineId = v; }
    public int       getComplaintId()          { return complaintId; }
    public void      setComplaintId(int v)     { complaintId = v; }
    public String    getChangedBy()            { return changedBy; }
    public void      setChangedBy(String v)    { changedBy = v; }
    public String    getOldStatus()            { return oldStatus; }
    public void      setOldStatus(String v)    { oldStatus = v; }
    public String    getNewStatus()            { return newStatus; }
    public void      setNewStatus(String v)    { newStatus = v; }
    public String    getRemarks()              { return remarks; }
    public void      setRemarks(String v)      { remarks = v; }
    public Timestamp getChangedAt()            { return changedAt; }
    public void      setChangedAt(Timestamp v) { changedAt = v; }
}
