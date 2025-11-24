package dao;

import java.sql.PreparedStatement;
import java.sql.SQLException;
import model.OrderPickUpByShipper;

public class OrderPickUpByShipperDAO extends DAO {

    public OrderPickUpByShipperDAO() {
        super();
    }

    public boolean pickUpOrder(OrderPickUpByShipper o) {
        String sqlInsert = "INSERT INTO tblorderpickupbyshipper(tblOrderAcceptedID, PickUpTime, shipperID) VALUES(?,?,?)";
        
        String sqlUpdateOrder = "UPDATE tblorder SET Status = 'Shipping' WHERE ID = ?";
        
        boolean result = false;
        try {
            con.setAutoCommit(false); // Transaction
            
            // 1. Insert vào bảng PickUp
            PreparedStatement ps1 = con.prepareStatement(sqlInsert);
            ps1.setInt(1, o.getId()); // ID của Order
            ps1.setTimestamp(2, new java.sql.Timestamp(o.getPickUpTime().getTime()));
            ps1.setInt(3, o.getShipper().getId()); // Lưu ID shipper
            ps1.executeUpdate();
            
            // 2. Update trạng thái đơn hàng
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