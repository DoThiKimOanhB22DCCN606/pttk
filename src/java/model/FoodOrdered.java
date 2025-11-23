package model;

public class FoodOrdered {
    private int id;
    private int quantity;
    private String note; 
    private Food food; 

    public FoodOrdered() {
        this.food = new Food(); // Khởi tạo tránh null
    }
    
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }

    public Food getFood() { return food; }
    public void setFood(Food food) { this.food = food; }
}