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
            // Nhận tham số shipperCode từ SearchShipper.jsp
            String shipperCode = request.getParameter("shipperCode");
            
            // Lấy thông tin từ Session (Staff, ShipperList)
            ArrayList<Shipper> shipperList = (ArrayList<Shipper>) session.getAttribute("shipperList");
            Shipper currentShipper = null;

            // Tìm đối tượng Shipper trong danh sách dựa vào code
            if (shipperList != null && shipperCode != null) {
                for (Shipper s : shipperList) {
                    if (s.getCode().equals(shipperCode)) {
                        currentShipper = s;
                        break;
                    }
                }
            }
            
            // Lưu shipper hiện tại vào session để các trang sau (doPickUp, Cancel) dùng
            session.setAttribute("currentShipper", currentShipper);
            

            
            // Gọi DAO lấy danh sách đơn hàng (getOrderInfo)
            // Theo thiết kế: Lấy 1 list tổng rồi tự lọc
            OrderAcceptedDAO oaDAO = new OrderAcceptedDAO();
            ArrayList<OrderAccepted> allOrders = oaDAO.getOrderInfo(); 
            
            // Lọc đơn hàng thành 3 danh sách
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
                    // Danh sách 2: Đơn đang giao bởi Shipper này
                    else if ("Shipping".equalsIgnoreCase(status)) {
                        if(order instanceof OrderPickUpByShipper) {
                            OrderPickUpByShipper orderPU = (OrderPickUpByShipper) order;
                            // Kiểm tra đúng shipper này đang giao không
                            if(orderPU.getShipper().getId() == currentShipper.getId()){
                                deliveringList.add(orderPU);
                            }
                        }
                    } 
                    // Danh sách 3: Đơn đã hủy bởi Shipper này
                    else if ("Cancelled".equalsIgnoreCase(status) || "ShippingCancelled".equalsIgnoreCase(status)) { // Tùy status DB bạn quy định
                         if(order instanceof OrderCancelByShipper) {
                            OrderCancelByShipper orderCancel = (OrderCancelByShipper) order;
                            // Kiểm tra đúng shipper này hủy không (thông qua orderPickUp cha)
                            if(orderCancel.getShipper().getId() == currentShipper.getId()){
                                cancelledList.add(orderCancel);
                            }
                        }
                    }
                }
            }
            
            // Lưu 3 danh sách vào Session 
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
            <% 
                if (pendingList != null && !pendingList.isEmpty()) {
                    for (OrderAccepted o : pendingList) { 
            %>
            <tr>
                <td><%= o.getCode() %></td>
                <td><%= o.getTotal() %></td>
                <td><a href="doPickUpOrder.jsp?orderCode=<%= o.getCode() %>">Nhận đơn</a></td>
            </tr>
            <% 
                    }
                } 
            %>
        </table>

        <h3>Danh sách đơn hàng đang giao</h3>
        <table border="1">
            <tr>
                <th>Mã ĐH</th>
                <th>Thời gian nhận</th>
                <th>Hành động</th>
            </tr>
            <% 
                if (deliveringList != null && !deliveringList.isEmpty()) {
                    for (OrderPickUpByShipper o : deliveringList) { 
            %>
            <tr>
                <td><%= o.getCode() %></td>
                <td><%= o.getPickUpTime() %></td>
                <td><a href="CancelShipperOrder.jsp?orderCode=<%= o.getCode() %>">Hủy đơn</a></td>
            </tr>
            <% 
                    }
                } 
            %>
        </table>

        <h3>Danh sách đơn hàng đã hủy</h3>
        <table border="1">
            <tr>
                <th>Mã ĐH</th>
                <th>Lý do hủy</th>
                <th>Thời gian hủy</th>
            </tr>
            <% 
                if (cancelledList != null && !cancelledList.isEmpty()) {
                    for (OrderCancelByShipper o : cancelledList) { 
            %>
            <tr>
                <td><%= o.getCode() %></td>
                <td><%= o.getReason() %></td>
                <td><%= o.getCanceledTime() %></td>
            </tr>
            <% 
                    }
                } 
            %>
        </table>
        
        <br>
        <a href="SearchShipper.jsp?back=true">Quay lại tìm kiếm</a>
        <br>
        <a href="../Staff.jsp">Về trang chủ</a>
    </body>
</html>