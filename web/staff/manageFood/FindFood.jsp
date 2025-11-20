<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="model.Member, model.Food, dao.FoodDAO, java.util.ArrayList"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@include file="../../header.jsp" %>
<title>Tìm món ăn</title>
</head>
<body>
    <%
    Member nv = (Member) session.getAttribute("nhanvien");
    if (nv == null) {
        response.sendRedirect("../member/Login.jsp?err=timeout");
        return;
    }
    // Đảm bảo encoding UTF-8 khi nhận keyword
    request.setCharacterEncoding("UTF-8");
    String keyword = request.getParameter("keyword");
    %>
    
    <h2>Tìm món ăn </h2>
    <%-- Form tìm kiếm, dựa theo thiết kế GD --%>
    <form action="FindFood.jsp" method="post">
        <input type="hidden" name="action" value="edit">
        Từ khóa: 
        <input type="text" name="keyword" value="<%=(keyword != null) ? keyword : ""%>">
        <input type="submit" value="Tìm">
    </form>
    <br/>
    
    <table style="border: 1px solid black; border-collapse: collapse;">
        <thead style="border: 1px solid black;">
            <td style="padding: 5px;">TT</td>
            <td style="padding: 5px;">Tên món</td>
            <td style="padding: 5px;">Mô tả</td>
            <td style="padding: 5px;">Tình trạng</td>
            <td style="padding: 5px;">Giá</td>
            <td style="padding: 5px;">Chọn</td>
        </thead>
        <%
        if (keyword != null && !keyword.isEmpty()) {
            FoodDAO dao = new FoodDAO();
            ArrayList<Food> list = dao.findFoodByName(keyword);
            
            if (list != null && list.size() > 0) {
                int i = 1;
                for (Food f : list) {
        %>
        <tr style="border-bottom: 1px solid #ccc;">
            <td style="padding: 5px;"><%= i++ %></td>
            <td style="padding: 5px;"><%=f.getName()%></td>
            <td style="padding: 5px;"><%=f.getDescription()%></td>
            <td style="padding: 5px;"><%=f.getStatus()%></td>
            <td style="padding: 5px;"><%=f.getPrice()%></td>
            <td style="padding: 5px;">
                <%-- trỏ đến EditFood.jsp --%>
                <a href="EditFood.jsp?id=<%=f.getId()%>">Sửa</a>
            </td>
        </tr>
        <%
                }
            } else {
        %>
        <tr><td colspan="6">Không tìm thấy món ăn nào.</td></tr>
        <%
            }
        }
        %>
    </table>
    <br/>
    <button onclick="openPage('ManageFood.jsp')">Quay lại</button>
</body>
</html>