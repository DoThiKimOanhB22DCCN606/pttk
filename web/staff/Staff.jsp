<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="model.Member"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@include file="../header.jsp" %>
<title>Trang chủ nhân viên</title>
</head>
<body>
    <%
    Member nv = (Member) session.getAttribute("nhanvien");
    if (nv == null) {
        response.sendRedirect("../member/Login.jsp?err=timeout");
        return; 
    }
    %>
    <h2>Trang chủ nhân viên Cửa hàng</h2>
    <p>Xin chào, <%=nv.getFullname() %>!</p>
    
    <button onclick="openPage('manageFood/ManageFood.jsp')">quản lý thông tin món ăn</button>
    <button onclick="openPage('manageOrders/ManageOrder.jsp')">quản lý danh sách các đơn hàng chờ duyệt</button>
    <button onclick="openPage('pickUpOrders/SearchShipper.jsp')">giao hàng cho NVGH</button>
</body>
</html>