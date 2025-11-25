package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import model.Food;
import model.Food;
public class FoodDAO extends DAO {
    public FoodDAO() {
        super();
    }
    /**
     * Tìm món ăn theo tên 
     */
    public ArrayList<Food> findFoodByName(String keyword) {
        ArrayList<Food> kq = null;
        String sql = "SELECT * FROM tblFood WHERE Name LIKE ?"; 
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, "%" + keyword + "%"); // chống SQL Injection
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                if (kq == null) kq = new ArrayList<Food>();
                Food food = new Food();
                food.setId(rs.getInt("ID"));
                food.setName(rs.getString("Name"));
                food.setDescription(rs.getString("Description"));
                food.setPrice(rs.getDouble("Price"));
                food.setStatus(rs.getString("Status"));
                food.setCode(rs.getString("Code"));
                
                kq.add(food);
            }
        } catch (Exception e) {
            e.printStackTrace();
            kq = null;
        }
        return kq;
    }

    /**
     * Lấy thông tin 1 món ăn bằng ID 
     */
    public Food getFoodById(int foodId) {
        Food food = null;
        String sql = "SELECT * FROM tblFood WHERE ID = ?"; 

        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, foodId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                food = new Food();
                food.setId(rs.getInt("ID"));
                food.setName(rs.getString("Name"));
                food.setDescription(rs.getString("Description"));
                food.setPrice(rs.getDouble("Price"));
                food.setStatus(rs.getString("Status"));
                food.setCode(rs.getString("Code"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return food;
    }

    /**
     * Cập nhật thông tin món ăn 
     */
    public boolean updateFood(Food food) {
        // SQL thuần với 5 tham số
        String sql = "UPDATE tblFood SET Name = ?, Description = ?, Price = ?, Status = ? WHERE ID = ?";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, food.getName());
            ps.setString(2, food.getDescription());
            ps.setDouble(3, food.getPrice());
            ps.setString(4, food.getStatus());
            ps.setInt(5, food.getId()); 
            
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}