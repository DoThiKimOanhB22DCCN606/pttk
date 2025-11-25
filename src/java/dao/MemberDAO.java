package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import model.Member;
import model.Staff; // Bổ sung import Staff

public class MemberDAO extends DAO {

    public MemberDAO() {
        super();
    }

    /**
     * Kiem tra dang nhap 
     */
    public Member checkLogin(String username, String password) {
        Member member = null; 
        
        String sql = "SELECT * FROM tblMember WHERE Username = ? AND Password = ? AND Role = 'Staff'";

        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();

            // Nếu tìm thấy 1 dòng
            if (rs.next()) {
                // Khởi tạo Staff 
                member = new Staff(); 
                
                member.setId(rs.getInt("ID"));
                member.setFullname(rs.getString("Fullname"));
                member.setRole(rs.getString("Role"));
                member.setUsername(rs.getString("Username"));
                member.setAddress(rs.getString("Address"));
                member.setCode(rs.getString("Code"));
                member.setNumber(rs.getString("Number"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return member; 
    }
}