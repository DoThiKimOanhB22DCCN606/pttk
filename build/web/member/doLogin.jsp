<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" 
    import="dao.MemberDAO, model.Member" %>
<%
    // 1. Lấy dữ liệu từ form
    String username = (String) request.getParameter("username");
    String password = (String) request.getParameter("password");
    
    // 2. Gọi DAO
    MemberDAO dao = new MemberDAO();
    Member member = dao.checkLogin(username, password); // Hàm này trả về Member hoặc null

    // 3. Kiểm tra kết quả
    if (member != null) {
        // Neu != null, nghia la dang nhap thanh cong VA da la 'Staff'
        
        // 4. Lưu vào session
        session.setAttribute("nhanvien", member); 
        
        // 5. Chuyển hướng
        response.sendRedirect("../staff/Staff.jsp"); 
    } else {
        // 6. Nếu là null (sai pass, sai user, hoac khong phai Staff), quay lại
        response.sendRedirect("Login.jsp?err=fail");
    }
%>