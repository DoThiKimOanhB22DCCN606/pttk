package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import model.Member;

public class MemberDAO extends DAO {

    public MemberDAO() {
        super();
    }

    /**
     * Kiem tra dang nhap 
     */
    public Member checkLogin(String username, String password) {
        Member member = null; // Tra ve null neu that bai

        // Tránh SQL Injection
        if (username.contains("true") || username.contains("=")
                || password.contains("true") || password.contains("=")) {
            return null;
        }
        
        String sql = "SELECT * FROM tblMember WHERE Username = ? AND Password = ? AND Role = 'Staff'";

        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();

            // Nếu tìm thấy 1 dòng, tạo đối tượng Member
            if (rs.next()) {
                member = new Member();
                member.setId(rs.getInt("ID"));
                member.setFullname(rs.getString("Fullname"));
                member.setRole(rs.getString("Role"));
                member.setUsername(rs.getString("Username"));
                member.setAddress(rs.getString("Address"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return member; 
    }
}