package model;

import java.util.Date;

public class OrderPickUpByShipper extends OrderAccepted {
    private Date pickUpTime;
    private Shipper shipper;

    public OrderPickUpByShipper() {
        super();
    }

    // Constructor gọi super để copy dữ liệu
    public OrderPickUpByShipper(OrderAccepted order, Date pickUpTime, Shipper shipper) {
        super(order, order.getAcceptedTime()); 
        this.pickUpTime = pickUpTime;
        this.shipper = shipper;
    }

    public Date getPickUpTime() {
        return pickUpTime;
    }

    public void setPickUpTime(Date pickUpTime) {
        this.pickUpTime = pickUpTime;
    }

    public Shipper getShipper() {
        return shipper;
    }

    public void setShipper(Shipper shipper) {
        this.shipper = shipper;
    }
}