package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import model.Shipper;

public class ShipperDAO extends DAO {

    public ShipperDAO() {
        super();
    }

    // Tìm kiếm Shipper theo tên 
    public ArrayList<Shipper> searchShipper(String name) {
        ArrayList<Shipper> result = new ArrayList<>();
        // SQL tìm trong bảng tblmember với điều kiện tên gần đúng và chức vụ là Shipper
        String sql = "SELECT * FROM tblmember WHERE fullname LIKE ? AND role = 'Shipper'";
        
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, "%" + name + "%");
            ResultSet rs = ps.executeQuery();
            
            while(rs.next()) {
                Shipper s = new Shipper();
                
                // Map đúng cột trong DB vào đúng thuộc tính của Member (lớp cha)
                s.setId(rs.getInt("ID"));
                s.setCode(rs.getString("Code"));
                s.setNumber(rs.getString("Number"));   
                s.setBirth(rs.getDate("Birth"));
                s.setAddress(rs.getString("Address"));
                s.setUsername(rs.getString("username"));
                s.setFullname(rs.getString("fullname")); 
                s.setPassword(rs.getString("password"));
                s.setRole(rs.getString("role"));      
                
                result.add(s);
            }
        } catch(Exception e) {
            e.printStackTrace();
        }
        return result;
    }
}