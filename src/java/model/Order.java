package model;
import java.util.ArrayList;
import java.util.Date;

public class Order {
    private int id;
    private String code;
    private double shipFee;
    private double discount;
    private double total;
    private String status;
    private Date orderedTime;
    private String note;
    private ArrayList<FoodOrdered> listFood;
    private ArrayList<ComboOrdered> listCombo;
    private Customer customer;
    private Staff staff;

    public Order() {
        this.listFood = new ArrayList<>();
        this.listCombo = new ArrayList<>();
        this.customer = new Customer();
        this.staff = new Staff();
    }
    
    // Hiển thị danh sách món an va combo trong bang duyet don hang
    public String getFoodListAsString() {
        StringBuilder sb = new StringBuilder();
        if (listFood != null) {
            for (FoodOrdered fo : listFood) {
                if (fo.getFood() != null) {
                    sb.append(fo.getFood().getName()).append(" x").append(fo.getQuantity()).append(", ");
                }
            }
        }
        if (listCombo != null) {
            for (ComboOrdered co : listCombo) {
                if (co.getCombo() != null) {
                    sb.append(co.getCombo().getName()).append(" x").append(co.getQuantity()).append(", ");
                }
            }
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

    public ArrayList<FoodOrdered> getListFood() { return listFood; }
    public void setListFood(ArrayList<FoodOrdered> listFood) { this.listFood = listFood; }

    public ArrayList<ComboOrdered> getListCombo() { return listCombo; }
    public void setListCombo(ArrayList<ComboOrdered> listCombo) { this.listCombo = listCombo; }

    public Customer getCustomer() { return customer; }
    public void setCustomer(Customer customer) { this.customer = customer; }

    public Staff getStaff() { return staff; }
    public void setStaff(Staff staff) { this.staff = staff; }
}