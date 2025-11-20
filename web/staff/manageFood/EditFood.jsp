<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="model.Member, model.Food, dao.FoodDAO"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@include file="../../header.jsp" %>
<title>Sửa Món ăn</title>
</head>
<body>
    <%
    Member nv = (Member) session.getAttribute("nhanvien");
    if (nv == null) {
        response.sendRedirect("../member/Login.jsp?err=timeout");
        return;
    }
    
    // Lấy món ăn từ CSDL dựa vào ID trên URL
    int id = Integer.parseInt(request.getParameter("id"));
    FoodDAO dao = new FoodDAO();
    Food food = dao.getFoodById(id);
    
    // Kiểm tra null để tránh crash trang
    if(food == null) {
        out.println("Lỗi: Không tìm thấy món ăn với ID = " + id);
        return; 
    }
    
    %>
    
    <h2>Sửa thông tin món ăn</h2>
    
    <%-- trỏ đến doEditFood.jsp --%>
    <form action="doEditFood.jsp" method="post">
        <input type="hidden" name="id" value="<%=food.getId()%>" />
        <table border="0">
            <tr>
                <td>Tên món:</td>
                <td><input type="text" name="name" value="<%=food.getName()%>" size="50"/></td>
            </tr>
            <tr>
                <td>Mô tả:</td>
                <td><textarea name="desc" rows="3" cols="50"><%=food.getDescription()%></textarea></td>
            </tr>
            <tr>
                <td>Tình trạng:</td>
                <td><input type="text" name="status" value="<%=food.getStatus()%>" /></td>
            </tr>
            <tr>
                <td>Giá:</td>
                <td><input type="number" name="price" value="<%=food.getPrice()%>" /></td>
            </tr>
            <tr>
                <td></td>
                <td><input type="submit" value="Lưu thay đổi" /></td>
            </tr>
        </table>
    </form>
    <br/>
    
    <%-- quay về trang tìm kiếm --%>
    <button onclick="openPage('FindFood.jsp')">Quay lại </button>
    
    <%--  Quay về trang chính của nhân viên --%>
    <button onclick="openPage('../Staff.jsp')">Quay về GDNV</button>
    
</body>
</html>