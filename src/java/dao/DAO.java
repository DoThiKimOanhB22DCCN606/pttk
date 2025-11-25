package dao;

import java.sql.Connection;
import java.sql.DriverManager;

public class DAO {
    public static Connection con;

    public DAO() {
        if (con == null) {
            // 1. Cổng chuẩn của MySQL xịn là 3306
            String dbUrl = "jdbc:mysql://localhost:3306/db_quanlychbandoannhanh?autoReconnect=true&useSSL=false&useUnicode=true&characterEncoding=UTF-8";               String dbClass = "com.mysql.cj.jdbc.Driver";

            try {
                Class.forName(dbClass);
                con = DriverManager.getConnection(dbUrl, "root", "kimo"); 

            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}