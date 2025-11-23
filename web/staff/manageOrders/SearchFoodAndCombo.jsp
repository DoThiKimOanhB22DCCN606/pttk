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
    //if session erase orderToEdit
    if (session.getAttribute("orderToEdit") == null) {
        response.sendRedirect("ManageOrder.jsp");
        return; 
    }
    %>
    
    <h3>Search food and combo view</h3>
    <form action="SearchFoodAndCombo.jsp" method="post">
        <!-- show keyword if existed -->
        Ô nhập tên: <input type="text" name="keyword" value="<%=request.getParameter("keyword")==null?"":request.getParameter("keyword")%>"> 
        <input type="submit" value="Tìm">
    </form>
    <br>
    
    <table border="1">
        <tr><th>Tên</th><th>Loại</th><th>SL</th><th>Chọn</th></tr>
        <%
        String k = request.getParameter("keyword");
        boolean foundAny = false; // Biến cờ để kiểm tra có tìm thấy gì không
        if(k != null && !k.trim().isEmpty()) {
            // Tìm Món ăn
            dao.FoodDAO fd = new dao.FoodDAO();
            ArrayList<Food> foods = fd.findFoodByName(k);
            
            // Kiểm tra null 
            if (foods != null && !foods.isEmpty()) {
                foundAny = true;
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
        <%      } 
            }
        
            // Tìm Combo
            dao.ComboDAO cd = new dao.ComboDAO();
            ArrayList<Combo> combos = cd.findComboByName(k);
            
            // Kiểm tra null 
            if (combos != null && !combos.isEmpty()) {
                foundAny = true;
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
        <%      } 
            }
            
            // Nếu không tìm thấy cả món lẫn combo
            if (!foundAny) {
        %>
            <tr><td colspan="4" style="text-align:center; color:red;">Không tìm thấy kết quả nào phù hợp!</td></tr>
        <%
            }
        } %>
    </table>
    
    <br>
    <button onclick="openPage('EditOrder.jsp?code=<%=((model.Order)session.getAttribute("orderToEdit")).getCode()%>')">Quay lại</button>
</body>
</html>