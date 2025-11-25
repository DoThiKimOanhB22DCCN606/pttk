package dao;

import java.sql.PreparedStatement;
import java.sql.SQLException;
import model.OrderCancelByCustomer;

public class OrderCancelByCustomerDAO extends DAO {

    public OrderCancelByCustomerDAO() {
        super();
    }

    // SỬA: Đổi void thành boolean để báo kết quả cho JSP
    public boolean addOrderCancel(OrderCancelByCustomer oc) {
        String sql1 = "INSERT INTO tblOrderCancelByCustomer (canceledTime, reason, tblOrderID) VALUES (?, ?, ?)";
        String sql2 = "UPDATE tblOrder SET status = 'Cancelled' WHERE id = ?"; // Lưu ý: status 'Cancelled' phải khớp với DB và JSP

        boolean result = false;
        
        try {
            con.setAutoCommit(false); // Bắt đầu Transaction
            
            // 1. Insert bảng Hủy
            PreparedStatement ps1 = con.prepareStatement(sql1);
            ps1.setTimestamp(1, new java.sql.Timestamp(oc.getCanceledTime().getTime()));
            ps1.setString(2, oc.getReason());
            ps1.setInt(3, oc.getId()); 
            ps1.executeUpdate();
            
            // 2. Update bảng Order
            PreparedStatement ps2 = con.prepareStatement(sql2);
            ps2.setInt(1, oc.getId());
            int rowsAffected = ps2.executeUpdate();
            
            // Chỉ commit khi cả 2 lệnh đều chạy tốt
            if (rowsAffected > 0) {
                con.commit();
                result = true;
            } else {
                con.rollback();
            }

        } catch (SQLException e) {
            try { con.rollback(); } catch (SQLException ex) {} // Hoàn tác nếu lỗi
            e.printStackTrace();
            result = false;
        } finally {
            try { con.setAutoCommit(true); } catch (SQLException ex) {}
        }
        
        return result;
    }
}