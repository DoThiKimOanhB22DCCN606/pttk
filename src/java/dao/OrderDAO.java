package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import model.Order;
import model.Staff;
import model.FoodOrdered;
import model.ComboOrdered;
import model.Food;
import model.Combo;

public class OrderDAO extends DAO {

    public OrderDAO() {
        super();
    }

    /**
     Retrieves all orders with details
     */
    public ArrayList<Order> getOrderInfo(Staff s) {
        ArrayList<Order> list = new ArrayList<>();
        // Join tblOrder with tblMember to get Customer info
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
                
                // set info to Customer 
                o.getCustomer().setId(rs.getInt("tblMemberID"));
                o.getCustomer().setFullname(rs.getString("Fullname"));
                o.getCustomer().setNumber(rs.getString("Number"));
                o.getCustomer().setAddress(rs.getString("Address"));

                // Load Food Details
                String sqlFood = "SELECT fo.*, f.Name, f.Price, f.Description, f.Status, f.Code "
                               + "FROM tblFoodOrdered fo JOIN tblFood f ON fo.tblFoodID = f.ID "
                               + "WHERE fo.tblOrderID = ?";
                PreparedStatement psF = con.prepareStatement(sqlFood);
                psF.setInt(1, o.getId());
                ResultSet rsF = psF.executeQuery();
                while (rsF.next()) {
                    FoodOrdered fo = new FoodOrdered();
                    fo.setId(rsF.getInt("ID"));
                    fo.setQuantity(rsF.getInt("Quantity"));
                    
                    // set info to Food object inside FoodOrdered
                    Food f = new Food();
                    f.setId(rsF.getInt("tblFoodID"));
                    f.setName(rsF.getString("Name"));
                    f.setPrice(rsF.getDouble("Price"));
                    f.setDescription(rsF.getString("Description"));
                    f.setStatus(rsF.getString("Status"));
                    f.setCode(rsF.getString("Code"));
                    
                    fo.setFood(f);
                    o.getListFood().add(fo);
                }

                // Load Combo Details
                String sqlCombo = "SELECT co.*, c.Name, c.Price, c.Description, c.Code "
                                + "FROM tblComboOrdered co JOIN tblCombo c ON co.tblComboID = c.ID "
                                + "WHERE co.tblOrderID = ?";
                PreparedStatement psC = con.prepareStatement(sqlCombo);
                psC.setInt(1, o.getId());
                ResultSet rsC = psC.executeQuery();
                while (rsC.next()) {
                    ComboOrdered co = new ComboOrdered();
                    co.setId(rsC.getInt("ID"));
                    co.setQuantity(rsC.getInt("Quantity"));
                    
                    // set info to Combo object inside ComboOrdered
                    Combo c = new Combo();
                    c.setId(rsC.getInt("tblComboID"));
                    c.setName(rsC.getString("Name"));
                    c.setPrice(rsC.getDouble("Price"));
                    c.setDescription(rsC.getString("Description"));
                    c.setCode(rsC.getString("Code"));
                    
                    co.setCombo(c);
                    o.getListCombo().add(co);
                }

                list.add(o);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     updates general order info and customer info.
     */
    public boolean updateOrder(Order o) {
        String sqlOrder = "UPDATE tblOrder SET Total=?, Note=?, ShipFee=?, Discount=? WHERE ID=?";
        String sqlMember = "UPDATE tblMember SET Fullname=?, Number=?, Address=? WHERE ID=?";
        
        try {
            con.setAutoCommit(false);
            
            // Update tblOrder
            PreparedStatement ps1 = con.prepareStatement(sqlOrder);
            ps1.setDouble(1, o.getTotal());
            ps1.setString(2, o.getNote());
            ps1.setDouble(3, o.getShipFee());
            ps1.setDouble(4, o.getDiscount());
            ps1.setInt(5, o.getId());
            ps1.executeUpdate();

            // Update tblMember 
            PreparedStatement ps2 = con.prepareStatement(sqlMember);
            ps2.setString(1, o.getCustomer().getFullname());
            ps2.setString(2, o.getCustomer().getNumber());
            ps2.setString(3, o.getCustomer().getAddress());
            ps2.setInt(4, o.getCustomer().getId());
            ps2.executeUpdate();
            
            con.commit();
            return true;
        } catch (Exception e) {
            try { con.rollback(); } catch(Exception ex){}
            e.printStackTrace();
            return false;
        } finally {
            try { con.setAutoCommit(true); } catch(Exception ex){}
        }
    }

    /**
     * Updates the list of foods ordered for an order.
     */
    public boolean updateListFood(int orderId, ArrayList<FoodOrdered> listFood) {
        try {
            String sqlDel = "DELETE FROM tblFoodOrdered WHERE tblOrderID = ?";
            PreparedStatement psDel = con.prepareStatement(sqlDel);
            psDel.setInt(1, orderId);
            psDel.executeUpdate();

            String sqlIns = "INSERT INTO tblFoodOrdered(tblOrderID, tblFoodID, Quantity) VALUES(?, ?, ?)";
            PreparedStatement psIns = con.prepareStatement(sqlIns);
            for (FoodOrdered fo : listFood) {
                psIns.setInt(1, orderId);
                // Access ID from the Food object
                psIns.setInt(2, fo.getFood().getId()); 
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
     Updates the list of combos ordered for an order.
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
                psIns.setInt(2, co.getCombo().getId());
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