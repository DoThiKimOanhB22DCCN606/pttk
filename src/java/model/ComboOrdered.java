package model;

public class ComboOrdered {
    private int id;
    private int quantity;
    private String note; 
    private Combo combo; 

    public ComboOrdered() {
        this.combo = new Combo(); // Khởi tạo để tránh NullPointerException
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }

    public Combo getCombo() { return combo; }
    public void setCombo(Combo combo) { this.combo = combo; }
}