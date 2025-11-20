<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" 
    import="dao.FoodDAO, dao.ComboDAO, model.Food, model.Combo, java.util.ArrayList"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@include file="../../header.jsp" %>
<title>Search</title>
<style>
    table { width: 80%; border-collapse: collapse; margin-bottom: 20px; }
    th, td { border: 1px solid black; padding: 5px; text-align: left; }
</style>
</head>
<body>
    <%
    // Lấy ID đơn hàng từ session để quay lại đúng chỗ
    Object orderIdObj = session.getAttribute("currentOrderId");
    // Nếu mất session (do timeout), quay về ManageOrder
    if(orderIdObj == null) {
        // Tìm trong OrderToEdit nếu có
        model.Order o = (model.Order) session.getAttribute("orderToEdit");
        if(o != null) orderIdObj = o.getId();
        else {
            response.sendRedirect("ManageOrder.jsp");
            return;
        }
    }
    %>

    <h3>Search food and combo view</h3>
    <form action="SearchFoodAndCombo.jsp" method="post">
        Ô nhập tên: <input type="text" name="keyword" value="<%=request.getParameter("keyword")==null?"":request.getParameter("keyword")%>"> 
        <input type="submit" value="Tìm">
    </form>
    <br>
    
    <table border="1">
        <tr><th>Tên</th><th>Loại</th><th>SL</th><th>Chọn</th></tr>
        <%
        String k = request.getParameter("keyword");
        if(k != null && !k.trim().isEmpty()) {
            // 1. Tìm Món ăn
            dao.FoodDAO fd = new dao.FoodDAO();
            ArrayList<Food> foods = fd.findFoodByName(k);
            for(Food f : foods) {
        %>
        <tr>
            <form action="doAddItem.jsp" method="post">
                <input type="hidden" name="type" value="food">
                <input type="hidden" name="id" value="<%=f.getId()%>">
                <td><%=f.getName()%></td>
                <td>Món ăn</td>
                <td><input type="number" name="qty" value="1" style="width:50px"></td>
                <td><input type="submit" value="Thêm"></td>
            </form>
        </tr>
        <%  } 
        
            // 2. Tìm Combo
            dao.ComboDAO cd = new dao.ComboDAO();
            ArrayList<Combo> combos = cd.findComboByName(k);
            for(Combo c : combos) {
        %>
        <tr>
            <form action="doAddItem.jsp" method="post">
                <input type="hidden" name="type" value="combo">
                <input type="hidden" name="id" value="<%=c.getId()%>">
                <td><%=c.getName()%></td>
                <td>Combo</td>
                <td><input type="number" name="qty" value="1" style="width:50px"></td>
                <td><input type="submit" value="Thêm"></td>
            </form>
        </tr>
        <%  } 
        } %>
    </table>
    
    <br>
    <button onclick="openPage('EditOrder.jsp?code=<%=((model.Order)session.getAttribute("orderToEdit")).getCode()%>')">Quay lại</button>
</body>
</html>