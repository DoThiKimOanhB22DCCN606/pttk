package model;

public class ComboOrdered {
    private int id;
    private int comboId;
    private String comboName;
    private double comboPrice;
    private int quantity;

    public ComboOrdered() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getComboId() { return comboId; }
    public void setComboId(int comboId) { this.comboId = comboId; }
    public String getComboName() { return comboName; }
    public void setComboName(String comboName) { this.comboName = comboName; }
    public double getComboPrice() { return comboPrice; }
    public void setComboPrice(double comboPrice) { this.comboPrice = comboPrice; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
}