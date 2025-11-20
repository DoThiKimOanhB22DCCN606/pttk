package dao;
import java.sql.*;
import java.util.ArrayList;
import model.Order;
import model.FoodOrdered;
import model.ComboOrdered;

public class OrderDAO extends DAO {
    public OrderDAO() { super(); }

    // Lấy danh sách đơn hàng (Kèm list món/combo để hiển thị)
    public ArrayList<Order> getOrdersByStatus(String status) {
        ArrayList<Order> list = new ArrayList<>();
        String sql = "SELECT o.*, m.Fullname, m.Number, m.Address FROM tblOrder o JOIN tblMember m ON o.tblMemberID = m.ID WHERE o.Status = ? ORDER BY o.OrderedTime DESC";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            while(rs.next()) {
                Order o = new Order();
                o.setId(rs.getInt("ID"));
                o.setCode(rs.getString("Code"));
                o.setShipFee(rs.getDouble("ShipFee"));
                o.setDiscount(rs.getDouble("Discount"));
                o.setTotal(rs.getDouble("Total"));
                o.setStatus(rs.getString("Status"));
                o.setOrderedTime(rs.getTimestamp("OrderedTime"));
                o.setNote(rs.getString("Note"));
                o.setCustomerName(rs.getString("Fullname"));
                o.setCustomerPhone(rs.getString("Number"));
                o.setCustomerAddress(rs.getString("Address"));
                
                // Load chi tiết (để hiển thị cột DS món)
                loadDetails(o);
                list.add(o);
            }
        } catch(Exception e) { e.printStackTrace(); }
        return list;
    }
    
    // Hàm phụ load chi tiết món/combo
    private void loadDetails(Order o) {
        try {
            PreparedStatement psF = con.prepareStatement("SELECT fo.*, f.Name, f.Price FROM tblFoodOrdered fo JOIN tblFood f ON fo.tblFoodID = f.ID WHERE fo.tblOrderID = ?");
            psF.setInt(1, o.getId());
            ResultSet rsF = psF.executeQuery();
            while(rsF.next()) {
                FoodOrdered fo = new FoodOrdered();
                fo.setId(rsF.getInt("ID"));
                fo.setQuantity(rsF.getInt("Quantity"));
                fo.setFoodId(rsF.getInt("tblFoodID"));
                fo.setFoodName(rsF.getString("Name"));
                fo.setFoodPrice(rsF.getDouble("Price"));
                o.getListFood().add(fo);
            }
            
            PreparedStatement psC = con.prepareStatement("SELECT co.*, c.Name, c.Price FROM tblComboOrdered co JOIN tblCombo c ON co.tblComboID = c.ID WHERE co.tblOrderID = ?");
            psC.setInt(1, o.getId());
            ResultSet rsC = psC.executeQuery();
            while(rsC.next()) {
                ComboOrdered co = new ComboOrdered();
                co.setId(rsC.getInt("ID"));
                co.setQuantity(rsC.getInt("Quantity"));
                co.setComboId(rsC.getInt("tblComboID"));
                co.setComboName(rsC.getString("Name"));
                co.setComboPrice(rsC.getDouble("Price"));
                o.getListCombo().add(co);
            }
        } catch(Exception e) {}
    }

    // Lấy chi tiết 1 đơn (Cho EditOrder)
    public Order getOrderById(int id) {
        Order o = null;
        String sql = "SELECT o.*, m.Fullname, m.Number, m.Address FROM tblOrder o JOIN tblMember m ON o.tblMemberID = m.ID WHERE o.ID = ?";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if(rs.next()) {
                o = new Order();
                o.setId(rs.getInt("ID"));
                o.setCode(rs.getString("Code"));
                o.setTotal(rs.getDouble("Total"));
                o.setShipFee(rs.getDouble("ShipFee"));
                o.setDiscount(rs.getDouble("Discount"));
                o.setStatus(rs.getString("Status"));
                o.setOrderedTime(rs.getTimestamp("OrderedTime"));
                o.setNote(rs.getString("Note"));
                o.setTblMemberID(rs.getInt("tblMemberID"));
                o.setCustomerName(rs.getString("Fullname"));
                o.setCustomerPhone(rs.getString("Number"));
                o.setCustomerAddress(rs.getString("Address"));
                loadDetails(o);
            }
        } catch(Exception e) { e.printStackTrace(); }
        return o;
    }

    // LƯU THAY ĐỔI (Transaction)
    public void updateOrderFull(Order o) {
        try {
            con.setAutoCommit(false);
            
            // 1. Update thông tin chung (Tiền, Note, Ship, Discount)
            PreparedStatement ps1 = con.prepareStatement("UPDATE tblOrder SET Total=?, Note=?, ShipFee=?, Discount=? WHERE ID=?");
            ps1.setDouble(1, o.getTotal());
            ps1.setString(2, o.getNote());
            ps1.setDouble(3, o.getShipFee());
            ps1.setDouble(4, o.getDiscount());
            ps1.setInt(5, o.getId());
            ps1.executeUpdate();

            // 2. Update thông tin Khách hàng (Tên, SĐT, ĐC)
            PreparedStatement ps2 = con.prepareStatement("UPDATE tblMember SET Fullname=?, Number=?, Address=? WHERE ID=?");
            ps2.setString(1, o.getCustomerName());
            ps2.setString(2, o.getCustomerPhone());
            ps2.setString(3, o.getCustomerAddress());
            ps2.setInt(4, o.getTblMemberID());
            ps2.executeUpdate();

            // 3. Update List Food (Xóa cũ insert mới)
            PreparedStatement psDelF = con.prepareStatement("DELETE FROM tblFoodOrdered WHERE tblOrderID=?");
            psDelF.setInt(1, o.getId());
            psDelF.executeUpdate();
            PreparedStatement psInsF = con.prepareStatement("INSERT INTO tblFoodOrdered(tblOrderID, tblFoodID, Quantity) VALUES(?,?,?)");
            for(FoodOrdered fo : o.getListFood()) {
                psInsF.setInt(1, o.getId());
                psInsF.setInt(2, fo.getFoodId());
                psInsF.setInt(3, fo.getQuantity());
                psInsF.executeUpdate();
            }

            // 4. Update List Combo
            PreparedStatement psDelC = con.prepareStatement("DELETE FROM tblComboOrdered WHERE tblOrderID=?");
            psDelC.setInt(1, o.getId());
            psDelC.executeUpdate();
            PreparedStatement psInsC = con.prepareStatement("INSERT INTO tblComboOrdered(tblOrderID, tblComboID, Quantity) VALUES(?,?,?)");
            for(ComboOrdered co : o.getListCombo()) {
                psInsC.setInt(1, o.getId());
                psInsC.setInt(2, co.getComboId());
                psInsC.setInt(3, co.getQuantity());
                psInsC.executeUpdate();
            }

            con.commit();
        } catch(Exception e) {
            try { con.rollback(); } catch(Exception ex){}
            e.printStackTrace();
        } finally {
            try { con.setAutoCommit(true); } catch(Exception ex){}
        }
    }
    
    public void approveOrder(int id) {
        try {
            con.prepareStatement("UPDATE tblOrder SET Status='Đã duyệt' WHERE ID=" + id).executeUpdate();
            con.prepareStatement("INSERT INTO tblOrderAccepted(tblOrderID, AcceptedTime) VALUES (" + id + ", NOW())").executeUpdate();
        } catch(Exception e) {}
    }

    public void cancelOrder(int id, String reason) {
        try {
            PreparedStatement ps = con.prepareStatement("UPDATE tblOrder SET Status='Đã hủy', Note=? WHERE ID=?");
            ps.setString(1, reason);
            ps.setInt(2, id);
            ps.executeUpdate();
            PreparedStatement ps2 = con.prepareStatement("INSERT INTO tblOrderCancelByCustomer(tblOrderID, CanceledTime, Reason) VALUES (?, NOW(), ?)");
            ps2.setInt(1, id);
            ps2.setString(2, reason);
            ps2.executeUpdate();
        } catch(Exception e) {}
    }
}