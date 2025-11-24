package dao;

import java.sql.PreparedStatement;
import java.sql.SQLException;
import model.OrderCancelByCustomer;

public class OrderCancelByCustomerDAO extends DAO {

    public OrderCancelByCustomerDAO() {
        super();
    }

    public void addOrderCancel(OrderCancelByCustomer oc) {
        String sql1 = "INSERT INTO tblOrderCancelByCustomer (canceledTime, reason, tblOrderID) VALUES (?, ?, ?)";
        String sql2 = "UPDATE tblOrder SET status = 'Cancelled' WHERE id = ?";

        try {
            // 1. Insert bảng Hủy
            PreparedStatement ps1 = con.prepareStatement(sql1);
            ps1.setTimestamp(1, new java.sql.Timestamp(oc.getCanceledTime().getTime()));
            ps1.setString(2, oc.getReason());
            ps1.setInt(3, oc.getId()); 
            ps1.executeUpdate();

            // 2. Update bảng Order
            PreparedStatement ps2 = con.prepareStatement(sql2);
            ps2.setInt(1, oc.getId());
            ps2.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}