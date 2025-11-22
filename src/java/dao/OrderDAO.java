package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import model.Order;
import model.Staff;
import model.FoodOrdered;
import model.ComboOrdered;

public class OrderDAO extends DAO {

    public OrderDAO() {
        super();
    }

    /*
    Lấy danh sách toàn bộ đơn hàng và chi tiết của chúng.
     */
    public ArrayList<Order> getOrderInfo(Staff s) {
        ArrayList<Order> list = new ArrayList<>();
        // 1. Lấy danh sách đơn hàng và thông tin khách hàng
        String sql = "SELECT o.*, m.Fullname, m.Number, m.Address "
                   + "FROM tblOrder o JOIN tblMember m ON o.tblMemberID = m.ID "
                   + "ORDER BY o.OrderedTime DESC";
        
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Order o = new Order();
                o.setId(rs.getInt("ID"));
                o.setCode(rs.getString("Code"));
                o.setShipFee(rs.getDouble("ShipFee"));
                o.setDiscount(rs.getDouble("Discount"));
                o.setTotal(rs.getDouble("Total"));
                o.setStatus(rs.getString("Status"));
                o.setOrderedTime(rs.getTimestamp("OrderedTime"));
                o.setNote(rs.getString("Note"));
                o.setTblMemberID(rs.getInt("tblMemberID"));
                
                o.setCustomerName(rs.getString("Fullname"));
                o.setCustomerPhone(rs.getString("Number"));
                o.setCustomerAddress(rs.getString("Address"));

                //Lấy danh sách món ăn cho đơn hàng này
                String sqlFood = "SELECT fo.*, f.Name, f.Price FROM tblFoodOrdered fo "
                               + "JOIN tblFood f ON fo.tblFoodID = f.ID WHERE fo.tblOrderID = ?";
                PreparedStatement psF = con.prepareStatement(sqlFood);
                psF.setInt(1, o.getId());
                ResultSet rsF = psF.executeQuery();
                while (rsF.next()) {
                    FoodOrdered fo = new FoodOrdered();
                    fo.setId(rsF.getInt("ID"));
                    fo.setQuantity(rsF.getInt("Quantity"));
                    fo.setFoodId(rsF.getInt("tblFoodID"));
                    fo.setFoodName(rsF.getString("Name"));
                    fo.setFoodPrice(rsF.getDouble("Price"));
                    o.getListFood().add(fo);
                }

                //Lấy danh sách Combo cho đơn hàng này
                String sqlCombo = "SELECT co.*, c.Name, c.Price FROM tblComboOrdered co "
                                + "JOIN tblCombo c ON co.tblComboID = c.ID WHERE co.tblOrderID = ?";
                PreparedStatement psC = con.prepareStatement(sqlCombo);
                psC.setInt(1, o.getId());
                ResultSet rsC = psC.executeQuery();
                while (rsC.next()) {
                    ComboOrdered co = new ComboOrdered();
                    co.setId(rsC.getInt("ID"));
                    co.setQuantity(rsC.getInt("Quantity"));
                    co.setComboId(rsC.getInt("tblComboID"));
                    co.setComboName(rsC.getString("Name"));
                    co.setComboPrice(rsC.getDouble("Price"));
                    o.getListCombo().add(co);
                }
                // -------------------------------------------

                list.add(o);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Cập nhật thông tin chung của đơn hàng (
     */
    public boolean updateOrder(Order o) {
        String sqlOrder = "UPDATE tblOrder SET Total=?, Note=?, ShipFee=?, Discount=? WHERE ID=?";
        String sqlMember = "UPDATE tblMember SET Fullname=?, Number=?, Address=? WHERE ID=?";
        
        try {
            con.setAutoCommit(false); // Bắt đầu transaction
            
            // Cập nhật bảng tblOrder
            PreparedStatement ps1 = con.prepareStatement(sqlOrder);
            ps1.setDouble(1, o.getTotal());
            ps1.setString(2, o.getNote());
            ps1.setDouble(3, o.getShipFee());
            ps1.setDouble(4, o.getDiscount());
            ps1.setInt(5, o.getId());
            ps1.executeUpdate();

            // Cập nhật bảng tblMember
            PreparedStatement ps2 = con.prepareStatement(sqlMember);
            ps2.setString(1, o.getCustomerName());
            ps2.setString(2, o.getCustomerPhone());
            ps2.setString(3, o.getCustomerAddress());
            ps2.setInt(4, o.getTblMemberID()); 
            ps2.executeUpdate();

            con.commit(); // Xác nhận lưu tất cả
            return true;  
            
        } catch(Exception e) {
            try { con.rollback(); } catch(Exception ex){} // Nếu lỗi thì hoàn tác
            e.printStackTrace();
            return false; // Trả về false nếu lỗi
        } finally {
            try { con.setAutoCommit(true); } catch(Exception ex){}
        }
    }

    /**
     * Cập nhật danh sách món ăn 
     */
    public boolean updateListFood(int orderId, ArrayList<FoodOrdered> listFood) {
        try {
            //xóa cũ
            String sqlDel = "DELETE FROM tblFoodOrdered WHERE tblOrderID = ?";
            PreparedStatement psDel = con.prepareStatement(sqlDel);
            psDel.setInt(1, orderId);
            psDel.executeUpdate();
            //thêm mới
            String sqlIns = "INSERT INTO tblFoodOrdered(tblOrderID, tblFoodID, Quantity) VALUES(?, ?, ?)";
            PreparedStatement psIns = con.prepareStatement(sqlIns);
            for (FoodOrdered fo : listFood) {
                psIns.setInt(1, orderId);
                psIns.setInt(2, fo.getFoodId());
                psIns.setInt(3, fo.getQuantity());
                psIns.executeUpdate();
            }
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Cập nhật danh sách Combo 
     */
    public boolean updateListCombo(int orderId, ArrayList<ComboOrdered> listCombo) {
        try {
            String sqlDel = "DELETE FROM tblComboOrdered WHERE tblOrderID = ?";
            PreparedStatement psDel = con.prepareStatement(sqlDel);
            psDel.setInt(1, orderId);
            psDel.executeUpdate();

            String sqlIns = "INSERT INTO tblComboOrdered(tblOrderID, tblComboID, Quantity) VALUES(?, ?, ?)";
            PreparedStatement psIns = con.prepareStatement(sqlIns);
            for (ComboOrdered co : listCombo) {
                psIns.setInt(1, orderId);
                psIns.setInt(2, co.getComboId());
                psIns.setInt(3, co.getQuantity());
                psIns.executeUpdate();
            }
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}