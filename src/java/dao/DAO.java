package dao;

import java.sql.Connection;
import java.sql.DriverManager;

public class DAO {
    public static Connection con;

    public DAO() {
        if (con == null) {
            String dbUrl = "jdbc:mysql://localhost:3306/db_quanlychbandoannhanh?autoReconnect=true&useSSL=false";
            String dbClass = "com.mysql.cj.jdbc.Driver";
            try {
                Class.forName(dbClass);
                // Sửa "root" và "password" thành "kimo"
                con = DriverManager.getConnection(dbUrl, "kimo", "kimo"); 
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}