package model;
import java.util.Date;
import java.util.ArrayList;

public class Order {
    //Thông tin đơn hàng
    private int id;
    private String code;
    private double shipFee;
    private double discount;
    private double total;
    private String status;
    private Date orderedTime;
    private String note;
    private int tblMemberID;
    
    // Thông tin khách hàng 
    private String customerName;
    private String customerPhone;
    private String customerAddress;
    
    // Danh sách food và combo
    private ArrayList<FoodOrdered> listFood;
    private ArrayList<ComboOrdered> listCombo;

    public Order() {
        this.listFood = new ArrayList<>();
        this.listCombo = new ArrayList<>();
    }
    
    // Helper hiển thị bảng DS món ăn và ds combo
    public String getFoodListAsString() {
        StringBuilder sb = new StringBuilder();
        if(listFood != null) {
            for (FoodOrdered fo : listFood) 
                sb.append(fo.getFoodName()).append(" x").append(fo.getQuantity()).append(", ");
        }
        if(listCombo != null) {
            for (ComboOrdered co : listCombo) 
                sb.append(co.getComboName()).append(" x").append(co.getQuantity()).append(", ");
        }
        return (sb.length() > 2) ? sb.substring(0, sb.length() - 2) : "Không có";
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }
    
    public double getShipFee() { return shipFee; }
    public void setShipFee(double shipFee) { this.shipFee = shipFee; }
    
    public double getDiscount() { return discount; }
    public void setDiscount(double discount) { this.discount = discount; }
    
    public double getTotal() { return total; }
    public void setTotal(double total) { this.total = total; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public Date getOrderedTime() { return orderedTime; }
    public void setOrderedTime(Date orderedTime) { this.orderedTime = orderedTime; }
    
    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }
    
    public int getTblMemberID() { return tblMemberID; }
    public void setTblMemberID(int tblMemberID) { this.tblMemberID = tblMemberID; }
    
    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }
    
    public String getCustomerPhone() { return customerPhone; }
    public void setCustomerPhone(String customerPhone) { this.customerPhone = customerPhone; 
    }
    public String getCustomerAddress() { return customerAddress; }
    public void setCustomerAddress(String customerAddress) { this.customerAddress = customerAddress; }
    
    public ArrayList<FoodOrdered> getListFood() { return listFood; }
    public void setListFood(ArrayList<FoodOrdered> listFood) { this.listFood = listFood; }
    
    public ArrayList<ComboOrdered> getListCombo() { return listCombo; }
    public void setListCombo(ArrayList<ComboOrdered> listCombo) { this.listCombo = listCombo; }
}