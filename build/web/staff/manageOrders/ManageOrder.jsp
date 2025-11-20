<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" 
    import="dao.OrderDAO, model.Order, java.util.ArrayList"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@include file="../../header.jsp" %>
<title>Manage order</title>
<style>
    table { width: 100%; border-collapse: collapse; margin-bottom: 20px; }
    th, td { border: 1px solid black; padding: 5px; text-align: left; font-size: 13px; }
</style>
</head>
<body>
    <%
    if(session.getAttribute("nhanvien") == null) { response.sendRedirect("../../member/Login.jsp"); return; }

    ArrayList<Order> pendingList = (ArrayList<Order>) session.getAttribute("pendingOrderList");
    ArrayList<Order> approvedList = (ArrayList<Order>) session.getAttribute("acceptedOrderList");
    ArrayList<Order> cancelledList = (ArrayList<Order>) session.getAttribute("canceledOrderList");

    if(request.getParameter("back") == null || pendingList == null) {
        OrderDAO dao = new OrderDAO();
        pendingList = dao.getOrdersByStatus("Đã đặt");
        approvedList = dao.getOrdersByStatus("Đã duyệt");
        cancelledList = dao.getOrdersByStatus("Đã hủy");
        
        session.setAttribute("pendingOrderList", pendingList);
        session.setAttribute("acceptedOrderList", approvedList);
        session.setAttribute("canceledOrderList", cancelledList);
    }
    %>

    <h3>DS các đơn hàng chờ duyệt:</h3>
    <table>
        <thead>
            <tr>
                <th>TT</th><th>Mã ĐH</th><th>Tên KH</th><th>SĐT KH</th><th>ĐC KH</th><th>TG đặt</th>
                <th>Ghi chú</th><th>DS món ăn</th><th>Mã giảm giá</th><th>Phí vận chuyển</th>
                <th>Tổng tiền</th><th>Trạng thái</th><th>Chọn</th>
            </tr>
        </thead>
        <tbody>
            <% int i=1; for(Order o : pendingList) { %>
            <tr>
                <td><%=i++%></td><td><%=o.getCode()%></td><td><%=o.getCustomerName()%></td><td><%=o.getCustomerPhone()%></td><td><%=o.getCustomerAddress()%></td>
                <td><%=o.getOrderedTime()%></td><td><%=o.getNote()%></td><td><%=o.getFoodListAsString()%></td>
                <td><%=String.format("%,.0f", o.getDiscount())%></td><td><%=String.format("%,.0f", o.getShipFee())%></td>
                <td><%=String.format("%,.0f", o.getTotal())%></td><td><%=o.getStatus()%></td>
                <td>
                    <a href="doApproveOrder.jsp?id=<%=o.getId()%>">Duyệt</a>/
                    <a href="CancelOrder.jsp?id=<%=o.getId()%>">Hủy</a>/
                    <a href="EditOrder.jsp?code=<%=o.getCode()%>">Chỉnh sửa</a>
                </td>
            </tr>
            <% } %>
        </tbody>
    </table>

    <h3>DS các đơn hàng đã duyệt</h3>
    <table>
        <tr><th>TT</th><th>Mã ĐH</th><th>Tên KH</th><th>TG duyệt</th></tr>
        <% int j=1; for(Order o : approvedList) { %>
        <tr><td><%=j++%></td><td><%=o.getCode()%></td><td><%=o.getCustomerName()%></td><td><%=o.getOrderedTime()%></td></tr>
        <% } %>
    </table>

    <h3>DS các đơn hàng đã hủy</h3>
    <table>
        <tr><th>TT</th><th>Mã ĐH</th><th>Tên KH</th><th>TG hủy</th><th>Lý do hủy</th></tr>
        <% int k=1; for(Order o : cancelledList) { %>
        <tr><td><%=k++%></td><td><%=o.getCode()%></td><td><%=o.getCustomerName()%></td><td><%=o.getOrderedTime()%></td><td><%=o.getNote()%></td></tr>
        <% } %>
    </table>

    <button onclick="openPage('../Staff.jsp')">Quay lại.</button>
</body>
</html>