<%@page import="model.OrderPickUpByShipper"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    //Lấy orderCode từ tham số
    String orderCode = request.getParameter("orderCode");
    
    //Lấy danh sách đang giao (deliveringList) từ Session
    ArrayList<OrderPickUpByShipper> deliveringList = (ArrayList<OrderPickUpByShipper>) session.getAttribute("deliveringList");
    OrderPickUpByShipper orderToCancel = null;
    
    //Tìm đơn hàng cần hủy trong danh sách
    if (deliveringList != null && orderCode != null) {
        for (OrderPickUpByShipper o : deliveringList) {
            if (o.getCode().equals(orderCode)) {
                orderToCancel = o;
                break;
            }
        }
    }
    
    //Lưu đơn hàng cần hủy vào Session để trang xử lý (doCancel) dùng
    if (orderToCancel != null) {
        session.setAttribute("orderToCancel", orderToCancel);
    } else {
        // Nếu không tìm thấy, quay lại trang chọn đơn
        response.sendRedirect("ChooseOrder.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Hủy Đơn Hàng Đang Giao</title>
    </head>
    <body>
        <h2>Hủy giao đơn hàng: <%= orderToCancel.getCode() %></h2>
        <p>Khách hàng: <%= orderToCancel.getCustomer().getFullname() %></p>
        
        <form action="doCancelShipperOrder.jsp" method="POST">
            <label>Lý do hủy:</label><br>
            <textarea name="reason" rows="4" cols="50" required></textarea>
            <br><br>
            <input type="submit" value="Xác nhận hủy">
            <a href="ChooseOrder.jsp"><button type="button">Quay lại</button></a>
        </form>
    </body>
</html>