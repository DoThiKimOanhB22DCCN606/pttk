<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="model.Member"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@include file="../../header.jsp" %>
<title>Quản lý món ăn</title>
</head>
<body>
    <%
    Member nv = (Member) session.getAttribute("nhanvien");
    if (nv == null) {
        response.sendRedirect("../member/Login.jsp?err=timeout");
        return;
    }
    %>
    <h2>Quản lý thông tin món ăn</h2>
    <button onclick="openPage('#')">Thêm</button>
    <button onclick="openPage('FindFood.jsp?action=edit')">Sửa</button>
    <button onclick="openPage('#')">Xóa</button>
    <br/><br/>
</body>
</html>