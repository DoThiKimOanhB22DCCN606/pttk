package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import model.Customer;
import model.OrderAccepted;
import model.OrderCancelByShipper;
import model.OrderPickUpByShipper;
import model.Shipper;
import model.Staff;

public class OrderAcceptedDAO extends DAO {

    public OrderAcceptedDAO() {
        super();
    }

    public void addOrderAccepted(OrderAccepted oa) {
        String sql1 = "INSERT INTO tblOrderAccepted (AcceptedTime, tblOrderID, staffID) VALUES (?, ?, ?)";
        String sql2 = "UPDATE tblOrder SET status = 'Approved' WHERE id = ?";

        try {
            // 1. Insert vào bảng OrderAccepted
            PreparedStatement ps1 = con.prepareStatement(sql1);
            ps1.setTimestamp(1, new java.sql.Timestamp(oa.getAcceptedTime().getTime()));
            ps1.setInt(2, oa.getId()); 
            ps1.setInt(3, oa.getStaff().getId());
            ps1.executeUpdate();

            // 2. Update trạng thái trong bảng Order
            PreparedStatement ps2 = con.prepareStatement(sql2);
            ps2.setInt(1, oa.getId());
            ps2.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    /**
     * Lấy toàn bộ danh sách đơn hàng đã được duyệt (Accepted).
     * Bao gồm cả các đơn đã được Shipper nhận (PickUp) và đơn Shipper đã hủy (CancelShipper).
     * Hàm này phục vụ cho trang ChooseOrder.jsp để lọc thành 3 list.
     */
    public ArrayList<OrderAccepted> getOrderInfo() {
        ArrayList<OrderAccepted> result = new ArrayList<>();
        
        // Câu SQL kết nối các bảng theo thứ tự kế thừa:
        // Order -> OrderAccepted -> PickUpByShipper -> CancelByShipper
        // Đồng thời join bảng Member để lấy thông tin Khách hàng và Shipper
        String sql = "SELECT o.*, "
                   + "m.Fullname AS CusName, m.Address AS CusAddress, m.Number AS CusPhone, " // Thông tin Khách
                   + "oa.AcceptedTime, "
                   + "op.PickUpTime, "
                   + "s.ID AS ShipperID, s.Fullname AS ShipperName, s.Code AS ShipperCode, " // Thông tin Shipper
                   + "ocs.CanceledTime, ocs.Reason "
                   + "FROM tblOrder o "
                   + "JOIN tblOrderAccepted oa ON o.ID = oa.tblOrderID " // Chỉ lấy đơn đã duyệt
                   + "JOIN tblMember m ON o.tblMemberID = m.ID "         // Join Khách hàng
                   + "LEFT JOIN tblOrderPickUpByShipper op ON oa.tblOrderID = op.tblOrderAcceptedID " // Join bảng PickUp
                   + "LEFT JOIN tblMember s ON op.shipperID = s.ID "     // Join Shipper (nếu có)
                   + "LEFT JOIN tblOrderCancelByShipper ocs ON op.tblOrderAcceptedID = ocs.tblOrderPickUpByShipperID " // Join bảng Hủy
                   + "ORDER BY o.ID DESC";

        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                // 1. Tạo đối tượng Customer
                Customer cus = new Customer();
                cus.setId(rs.getInt("tblMemberID"));
                cus.setFullname(rs.getString("CusName"));
                cus.setAddress(rs.getString("CusAddress"));
                cus.setNumber(rs.getString("CusPhone"));

                // 2. Kiểm tra xem đơn hàng thuộc loại nào (dựa trên dữ liệu các bảng con)
                OrderAccepted oa = null;

                if (rs.getDate("CanceledTime") != null) {
                    // --- TRƯỜNG HỢP 3: Đơn đã bị Shipper hủy ---
                    OrderCancelByShipper oc = new OrderCancelByShipper();
                    oc.setCanceledTime(rs.getTimestamp("CanceledTime"));
                    oc.setReason(rs.getString("Reason"));
                    
                    // Set thông tin Shipper
                    Shipper shipper = new Shipper();
                    shipper.setId(rs.getInt("ShipperID"));
                    shipper.setFullname(rs.getString("ShipperName"));
                    shipper.setCode(rs.getString("ShipperCode"));
                    oc.setShipper(shipper);
                    
                    oc.setPickUpTime(rs.getTimestamp("PickUpTime"));
                    oa = oc; // Gán vào biến cha
                    
                } else if (rs.getDate("PickUpTime") != null) {
                    // --- TRƯỜNG HỢP 2: Đơn đang được giao (Đã PickUp) ---
                    OrderPickUpByShipper op = new OrderPickUpByShipper();
                    op.setPickUpTime(rs.getTimestamp("PickUpTime"));
                    
                    // Set thông tin Shipper
                    Shipper shipper = new Shipper();
                    shipper.setId(rs.getInt("ShipperID"));
                    shipper.setFullname(rs.getString("ShipperName"));
                    shipper.setCode(rs.getString("ShipperCode"));
                    op.setShipper(shipper);
                    
                    oa = op; // Gán vào biến cha
                    
                } else {
                    // --- TRƯỜNG HỢP 1: Đơn mới duyệt (Chưa ai nhận) ---
                    oa = new OrderAccepted();
                }

                // 3. Map các thông tin chung từ bảng Order và OrderAccepted
                oa.setId(rs.getInt("ID"));
                oa.setCode(rs.getString("Code"));
                oa.setTotal(rs.getDouble("Total"));
                oa.setStatus(rs.getString("Status"));
                oa.setNote(rs.getString("Note"));
                oa.setAcceptedTime(rs.getTimestamp("AcceptedTime"));
                oa.setCustomer(cus);

                result.add(oa);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }
}