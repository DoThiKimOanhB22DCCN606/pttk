<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Đăng nhập</title>
</head>
<body>
    <%
    // Hiển thị lỗi nếu đăng nhập sai hoặc hết phiên làm việc
    if (request.getParameter("err") != null && request.getParameter("err").equalsIgnoreCase("timeout")) {
    %> <h4>Hết phiên làm việc. Làm ơn đăng nhập lại!</h4> <%
    } else if (request.getParameter("err") != null && request.getParameter("err").equalsIgnoreCase("fail")) {
    %> <h4 style="color:red;">Sai tên đăng nhập/mật khẩu </h4> <%
    }
    %>
    <h2>Đăng nhập </h2>
    
    <%-- gửi dữ liệu đến doLogin.jsp --%>
    <form name="dangnhap" action="doLogin.jsp" method="post">
        <table>
            <tr>
                <td>Tên đăng nhập:</td>
                <td><input type="text" name="username" required /></td>
            </tr>
            <tr>
                <td>Mật khẩu:</td>
                <td><input type="password" name="password" required /></td>
            </tr>
            <tr>
                <td></td>
                <td><input type="submit" value="Đăng nhập" /></td>
            </tr>
        </table>
    </form>
</body>
</html>