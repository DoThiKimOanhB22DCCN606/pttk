package model;

import java.util.ArrayList;

public class Combo {
    private int id;
    private String name;
    private String description;
    private double price;
    private String code;
    
    private ArrayList<FoodInCombo> listFoodInCombo;

    public Combo() {
        this.listFoodInCombo = new ArrayList<>();
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
    
    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }

    public ArrayList<FoodInCombo> getListFoodInCombo() { return listFoodInCombo; }
    public void setListFoodInCombo(ArrayList<FoodInCombo> listFoodInCombo) { 
        this.listFoodInCombo = listFoodInCombo; 
    }
}