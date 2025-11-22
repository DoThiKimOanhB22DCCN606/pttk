package model;
import java.util.Date;

public class OrderAccepted {
    private int id; // Có thể không dùng nếu thiết kế DB là 1-1 PK=FK
    private Date acceptedTime;
    private int tblOrderID; // FK trỏ về Order

    public OrderAccepted() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public Date getAcceptedTime() { return acceptedTime; }
    public void setAcceptedTime(Date acceptedTime) { this.acceptedTime = acceptedTime; }
    
    public int getTblOrderID() { return tblOrderID; }
    public void setTblOrderID(int tblOrderID) { this.tblOrderID = tblOrderID; }
}