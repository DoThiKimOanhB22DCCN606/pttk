package model;

import java.io.Serializable;
import java.util.Date;

public class OrderCancelByCustomer extends Order implements Serializable {
    private Date canceledTime;
    private String reason;

    public OrderCancelByCustomer() {
        super();
    }

    // Constructor nhận vào đối tượng Order gốc, thời gian hủy và lý do
    public OrderCancelByCustomer(Order order, Date canceledTime, String reason) {
        super(); // Gọi constructor mặc định của class cha để khởi tạo các list
        if (order != null) {
            this.setId(order.getId());
            this.setCode(order.getCode());
            this.setShipFee(order.getShipFee());
            this.setDiscount(order.getDiscount());
            this.setTotal(order.getTotal());
            this.setStatus(order.getStatus());
            this.setOrderedTime(order.getOrderedTime());
            this.setNote(order.getNote());
            this.setListFood(order.getListFood());
            this.setListCombo(order.getListCombo());
            this.setCustomer(order.getCustomer());
            this.setStaff(order.getStaff());
        }
        
        // Gán các thuộc tính riêng của đơn hủy
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