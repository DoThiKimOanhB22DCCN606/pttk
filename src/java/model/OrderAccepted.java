package model;

import java.io.Serializable;
import java.util.Date;

public class OrderAccepted extends Order implements Serializable {
    private Date acceptedTime;

    public OrderAccepted() {
        super();
    }

    // Constructor nhận vào đối tượng Order gốc và thời gian duyệt
    public OrderAccepted(Order order, Date acceptedTime) {
        super(); // Gọi constructor mặc định của Order để khởi tạo các list
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
        
        this.acceptedTime = acceptedTime;
    }

    public Date getAcceptedTime() {
        return acceptedTime;
    }

    public void setAcceptedTime(Date acceptedTime) {
        this.acceptedTime = acceptedTime;
    }
}