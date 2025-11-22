package dao;
import java.sql.PreparedStatement;
import model.OrderAccepted;

public class OrderAcceptedDAO extends DAO {
    public OrderAcceptedDAO() { super(); }

    public boolean acceptOrder(OrderAccepted oa) {
        String sqlUpdate = "UPDATE tblOrder SET Status = 'Đã duyệt' WHERE ID = ?";
        String sqlInsert = "INSERT INTO tblOrderAccepted(tblOrderID, AcceptedTime) VALUES (?, NOW())";
        try {
            con.setAutoCommit(false);
            
            // 1. Update trạng thái Order
            PreparedStatement ps1 = con.prepareStatement(sqlUpdate);
            ps1.setInt(1, oa.getTblOrderID());
            ps1.executeUpdate();
            
            // 2. Insert vào bảng OrderAccepted
            PreparedStatement ps2 = con.prepareStatement(sqlInsert);
            ps2.setInt(1, oa.getTblOrderID());
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