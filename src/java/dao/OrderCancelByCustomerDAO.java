package dao;
import java.sql.PreparedStatement;
import model.OrderCancelByCustomer;

public class OrderCancelByCustomerDAO extends DAO {
    public OrderCancelByCustomerDAO() { super(); }

    public boolean cancelOrder(OrderCancelByCustomer oc) {
        String sqlUpdate = "UPDATE tblOrder SET Status = 'Đã hủy', Note = ? WHERE ID = ?";
        String sqlInsert = "INSERT INTO tblOrderCancelByCustomer(tblOrderID, CanceledTime, Reason) VALUES (?, NOW(), ?)";
        try {
            con.setAutoCommit(false);
            
            // Update trạng thái Order (kèm lý do vào Note cho tiện theo dõi)
            PreparedStatement ps1 = con.prepareStatement(sqlUpdate);
            ps1.setString(1, oc.getReason());
            ps1.setInt(2, oc.getTblOrderID());
            ps1.executeUpdate();
            
            // Insert vào bảng Cancel
            PreparedStatement ps2 = con.prepareStatement(sqlInsert);
            ps2.setInt(1, oc.getTblOrderID());
            ps2.setString(2, oc.getReason());
            ps2.executeUpdate();
            
            con.commit();
            return true;
        } catch(Exception e) {
            try { con.rollback(); } catch(Exception ex){}
            e.printStackTrace();
            return false;
        } finally {
            try { con.setAutoCommit(true); } catch(Exception ex){}
        }
    }
}