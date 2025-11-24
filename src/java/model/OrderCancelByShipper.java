package model;

import java.util.Date;

public class OrderCancelByShipper extends OrderPickUpByShipper {
    private Date canceledTime;
    private String reason;

    public OrderCancelByShipper() {
        super();
    }

    public OrderCancelByShipper(OrderPickUpByShipper order, Date canceledTime, String reason) {
        super(order, order.getPickUpTime(), order.getShipper());
        this.canceledTime = canceledTime;
        this.reason = reason;
    }

    public Date getCanceledTime() {
        return canceledTime;
    }

    public void setCanceledTime(Date canceledTime) {
        this.canceledTime = canceledTime;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }
}