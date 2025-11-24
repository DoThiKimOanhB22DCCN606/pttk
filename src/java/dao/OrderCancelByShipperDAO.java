package dao;

import java.sql.PreparedStatement;
import java.sql.SQLException;
import model.OrderCancelByShipper;

public class OrderCancelByShipperDAO extends DAO {

    public OrderCancelByShipperDAO() {
        super();
    }

    public boolean cancelOrder(OrderCancelByShipper o) {
        String sqlInsert = "INSERT INTO tblordercancelbyshipper(tblOrderPickUpByShipperID, CanceledTime, Reason) VALUES(?,?,?)";
        
        // Update Status tblorder -> 'Cancelled' 
        String sqlUpdateOrder = "UPDATE tblorder SET Status = 'Cancelled' WHERE ID = ?";
        
        boolean result = false;
        try {
            con.setAutoCommit(false);
            
            // 1. Insert bảng Cancel
            PreparedStatement ps1 = con.prepareStatement(sqlInsert);
            ps1.setInt(1, o.getId()); // ID của đơn hàng
            ps1.setTimestamp(2, new java.sql.Timestamp(o.getCanceledTime().getTime()));
            ps1.setString(3, o.getReason());
            ps1.executeUpdate();
            
            // 2. Update trạng thái Order
            PreparedStatement ps2 = con.prepareStatement(sqlUpdateOrder);
            ps2.setInt(1, o.getId());
            ps2.executeUpdate();
            
            con.commit();
            result = true;
        } catch(Exception e) {
            try { con.rollback(); } catch(SQLException ex) {}
            e.printStackTrace();
        } finally {
            try { con.setAutoCommit(true); } catch(SQLException ex) {}
        }
        return result;
    }
}