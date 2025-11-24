<%@page import="java.util.ArrayList"%>
<%@page import="model.Shipper"%>
<%@page import="dao.ShipperDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Tìm kiếm NVGH</title>
</head>
<body>
    <h2>Giao hàng cho NVGH - Tìm kiếm</h2>
    
    <form action="SearchShipper.jsp" method="GET">
        Tên Shipper: <input type="text" name="keyword">
        <input type="submit" value="Tìm kiếm">
    </form>
    
    <%
        String keyword = request.getParameter("keyword");
        if(keyword != null) {
            ShipperDAO shipperDAO = new ShipperDAO();
            // gọi searchShipper() 
            ArrayList<Shipper> list = shipperDAO.searchShipper(keyword);
            
            // S lưu vào session 
            session.setAttribute("shipperList", list);
            
            if(list.isEmpty()){
                out.println("<p>Không tìm thấy NVGH nào!</p>");
            } else {
    %>
        <table border="1">
            <tr><th>ID</th><th>Tên</th><th>SĐT</th><th>Hành động</th></tr>
            <% for(Shipper s : list) { %>
            <tr>
                <td><%= s.getId() %></td>
                <td><%= s.getFullname() %></td>
                <td><%= s.getNumber() %></td>
                <td><a href="ChooseOrder.jsp?shipperCode=<%= s.getCode() %>">Chọn</a></td>
            </tr>
            <% } %>
        </table>
    <% 
            }
        }
    %>
</body>
</html>