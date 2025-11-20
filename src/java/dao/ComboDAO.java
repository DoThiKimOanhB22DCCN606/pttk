package dao;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import model.Combo;

public class ComboDAO extends DAO {

    public ComboDAO() { super(); }

    public ArrayList<Combo> findComboByName(String keyword) {
        ArrayList<Combo> list = new ArrayList<>();
        String sql = "SELECT * FROM tblCombo WHERE Name LIKE ?";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();
            while(rs.next()) {
                Combo c = new Combo();
                c.setId(rs.getInt("ID"));
                c.setName(rs.getString("Name"));
                c.setDescription(rs.getString("Description"));
                c.setPrice(rs.getDouble("Price"));
                c.setCode(rs.getString("Code"));
                list.add(c);
            }
        } catch(Exception e) { e.printStackTrace(); }
        return list;
    }
    
    public Combo getComboById(int id) {
        Combo c = null;
        String sql = "SELECT * FROM tblCombo WHERE ID = ?";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if(rs.next()) {
                c = new Combo();
                c.setId(rs.getInt("ID"));
                c.setName(rs.getString("Name"));
                c.setDescription(rs.getString("Description"));
                c.setPrice(rs.getDouble("Price"));
                c.setCode(rs.getString("Code"));
            }
        } catch(Exception e) { e.printStackTrace(); }
        return c;
    }
}