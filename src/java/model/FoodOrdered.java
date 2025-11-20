package model;

public class FoodOrdered {
    private int id; 
    private int quantity;
    private int foodId;
    private String foodName; 
    private double foodPrice; 

    public FoodOrdered() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    public int getFoodId() { return foodId; }
    public void setFoodId(int foodId) { this.foodId = foodId; }
    public String getFoodName() { return foodName; }
    public void setFoodName(String foodName) { this.foodName = foodName; }
    public double getFoodPrice() { return foodPrice; }
    public void setFoodPrice(double foodPrice) { this.foodPrice = foodPrice; }
}