package model;
import java.util.Date;

public class OrderCancelByCustomer {
    private int id;
    private Date canceledTime;
    private String reason;
    private int tblOrderID;

    public OrderCancelByCustomer() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public Date getCanceledTime() { return canceledTime; }
    public void setCanceledTime(Date canceledTime) { this.canceledTime = canceledTime; }
    
    public String getReason() { return reason; }
    public void setReason(String reason) { this.reason = reason; }
    
    public int getTblOrderID() { return tblOrderID; }
    public void setTblOrderID(int tblOrderID) { this.tblOrderID = tblOrderID; }
}