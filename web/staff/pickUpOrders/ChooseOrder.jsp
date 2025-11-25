<%@page import="model.OrderCancelByShipper"%>
<%@page import="model.OrderPickUpByShipper"%>
<%@page import="model.OrderAccepted"%>
<%@page import="dao.OrderAcceptedDAO"%>
<%@page import="model.Shipper"%>
<%@page import="model.Staff"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Chọn Đơn Hàng</title>
    </head>
    <body>
        <%
            // 1. Nhận tham số
            String shipperCode = request.getParameter("shipperCode");
            

            ArrayList<Shipper> shipperList = (ArrayList<Shipper>) session.getAttribute("shipperList");
            Shipper currentShipper = null;

            // 3. Tìm đối tượng Shipper
            if (shipperList != null && shipperCode != null) {
                for (Shipper s : shipperList) {
                    if (shipperCode.equals(s.getCode())) { // So sánh an toàn
                        currentShipper = s;
                        break;
                    }
                }
            }
            
            // Nếu không tìm thấy trong list (có thể do reload trang mất param), thử lấy từ session cũ
            if (currentShipper == null) {
                currentShipper = (Shipper) session.getAttribute("currentShipper");
            }

            if (currentShipper == null) {
                response.sendRedirect("SearchShipper.jsp");
                return;
            }
            
            // Lưu shipper hiện tại
            session.setAttribute("currentShipper", currentShipper);
            
            // 4. Gọi DAO lấy danh sách đơn hàng
            OrderAcceptedDAO oaDAO = new OrderAcceptedDAO();
            // Truyền tham số staff vào hàm getOrderInfo
            ArrayList<OrderAccepted> allOrders = oaDAO.getOrderInfo(); 
            
            // 5. Lọc đơn hàng
            ArrayList<OrderAccepted> pendingList = new ArrayList<>();
            ArrayList<OrderPickUpByShipper> deliveringList = new ArrayList<>();
            ArrayList<OrderCancelByShipper> cancelledList = new ArrayList<>();
            
            if (allOrders != null) {
                for (OrderAccepted order : allOrders) {
                    String status = order.getStatus();
                    
                    // Danh sách 1: Đơn chờ giao (Approved)
                    if ("Approved".equalsIgnoreCase(status)) {
                        pendingList.add(order);
                    } 
                    // Danh sách 2: Đang giao
                    else if ("Shipping".equalsIgnoreCase(status)) {
                        if(order instanceof OrderPickUpByShipper) {
                            OrderPickUpByShipper orderPU = (OrderPickUpByShipper) order;
                            if(orderPU.getShipper() != null && orderPU.getShipper().getId() == currentShipper.getId()){
                                deliveringList.add(orderPU);
                            }
                        }
                    } 
                    // Danh sách 3: Đã hủy
                    else if ("Cancelled".equalsIgnoreCase(status)) {
                         if(order instanceof OrderCancelByShipper) {
                            OrderCancelByShipper orderCancel = (OrderCancelByShipper) order;
                            if(orderCancel.getShipper() != null && orderCancel.getShipper().getId() == currentShipper.getId()){
                                cancelledList.add(orderCancel);
                            }
                        }
                    }
                }
            }
            
            session.setAttribute("pendingList", pendingList);
            session.setAttribute("deliveringList", deliveringList);
            session.setAttribute("cancelledList", cancelledList);
        %>

        <h2>Giao hàng cho NV: <%= currentShipper.getFullname() %></h2>
        <p>Mã NV: <%= currentShipper.getCode() %> | SĐT: <%= currentShipper.getNumber() %></p>

        <h3>Danh sách đơn hàng đã duyệt (Chờ giao)</h3>
        <table border="1">
            <tr>
                <th>Mã ĐH</th>
                <th>Địa chỉ nhận</th>
                <th>Tổng tiền</th>
                <th>Chọn</th>
            </tr>
            <% if (pendingList != null) { for (OrderAccepted o : pendingList) { %>
            <tr>
                <td><%= o.getCode() %></td>
                <td><%= o.getCustomer().getAddress() %></td>
                <td><%= String.format("%,.0f", o.getTotal()) %></td>
                <td><a href="doPickUpOrder.jsp?orderCode=<%= o.getCode() %>">Nhận đơn</a></td>
            </tr>
            <% }} %>
        </table>

        <h3>Danh sách đơn hàng đang giao</h3>
        <table border="1">
            <tr>
                <th>Mã ĐH</th>
                <th>Thời gian nhận</th>
                <th>Hành động</th>
            </tr>
            <% if (deliveringList != null) { for (OrderPickUpByShipper o : deliveringList) { %>
            <tr>
                <td><%= o.getCode() %></td>
                <td><%= o.getPickUpTime() %></td>
                <td><a href="CancelShipperOrder.jsp?orderCode=<%= o.getCode() %>">Hủy đơn</a></td>
            </tr>
            <% }} %>
        </table>

        <h3>Danh sách đơn hàng đã hủy</h3>
        <table border="1">
            <tr>
                <th>Mã ĐH</th>
                <th>Lý do hủy</th>
                <th>Thời gian hủy</th>
            </tr>
            <% if (cancelledList != null) { for (OrderCancelByShipper o : cancelledList) { %>
            <tr>
                <td><%= o.getCode() %></td>
                <td><%= o.getReason() %></td>
                <td><%= o.getCanceledTime() %></td>
            </tr>
            <% }} %>
        </table>
        
        <br>
        <a href="SearchShipper.jsp?back=true">Quay lại tìm kiếm</a>
        <br>
        <a href="../Staff.jsp">Về trang chủ</a>
    </body>
</html>