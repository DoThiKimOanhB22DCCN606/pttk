<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" 
    import="model.Order, model.FoodOrdered, model.ComboOrdered, dao.OrderDAO, java.util.ArrayList"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@include file="../../header.jsp" %>
<title>Edit Order</title>
<style>
    table { width: 100%; border-collapse: collapse; margin-bottom: 20px; }
    th, td { border: 1px solid black; padding: 5px; }
    input { width: 90%; }
</style>
</head>
<body>
    <%
    String code = request.getParameter("code");
    Order o = null;
    
    // Tìm order trong Session List 
    if(code != null) {
        // Lấy danh sách từ session 
        ArrayList<Order> list = (ArrayList<Order>) session.getAttribute("pendingOrderList");
        
        if(list != null) {
            for(Order order : list) {
                if(order.getCode().equals(code)) {
                    //Lấy trực tiếp object từ list
                    o = order;
                    session.setAttribute("orderToEdit", o);
                    break;
                }
            }
        }
    } else {
        // quay lại từ trang thêm món/sửa món
        o = (Order) session.getAttribute("orderToEdit");
    }
    
    // Nếu không tìm thấy thì quay về trang quản lý
    if(o == null) { 
        response.sendRedirect("ManageOrder.jsp"); 
        return; 
    }
    %>

    <h3>Edit Order</h3>
    <form action="doEditOrder.jsp" method="post">
        
        <table>
            <tr>
                <th>Mã ĐH</th><th>Tên KH</th><th>SĐT KH</th><th>ĐC KH</th><th>TG đặt</th>
                <th>Ghi chú</th><th>Mã giảm giá</th><th>Phí vận chuyển</th><th>Trạng thái</th><th>Tổng tiền</th>
            </tr>
            <tr>
                <td><%=o.getCode()%></td>
                <td><input type="text" name="cusName" value="<%=o.getCustomerName()%>"></td>
                <td><input type="text" name="cusPhone" value="<%=o.getCustomerPhone()%>"></td>
                <td><input type="text" name="cusAddr" value="<%=o.getCustomerAddress()%>"></td>
                <td><%=o.getOrderedTime()%></td>
                <td><input type="text" name="note" value="<%=(o.getNote()==null)?"":o.getNote()%>"></td>
                <td><%=(long)o.getDiscount()%></td>
                <td><%=(long)o.getShipFee()%></td>
                <td><%=o.getStatus()%></td>
                <td><%=String.format("%,.0f", o.getTotal())%></td>
            </tr>
        </table>

        <h4>DS món ăn</h4>
        <table style="width: 60%">
            <tr><th>Tên</th><th>SL</th><th>Chọn</th></tr>
            <% 
            if(o.getListFood() != null) {
                for(int i=0; i<o.getListFood().size(); i++) { 
                    FoodOrdered f = o.getListFood().get(i); 
            %>
            <tr>
                <td><%=f.getFoodName()%></td>
                <td><input type="number" name="qty_food_<%=i%>" value="<%=f.getQuantity()%>" style="width:50px"></td>
                <td>
                    <button type="submit" name="action_edit_food" value="<%=i%>">Sửa</button> 
                    <button type="submit" name="action_remove_food" value="<%=i%>">Xóa</button>
                </td>
            </tr>
            <%  } 
            } %>
        </table>

        <h4>DS combo</h4>
        <table style="width: 60%">
            <tr><th>Tên</th><th>SL</th><th>Chọn</th></tr>
            <% 
            if(o.getListCombo() != null) {
                for(int i=0; i<o.getListCombo().size(); i++) { 
                    ComboOrdered c = o.getListCombo().get(i); 
            %>
            <tr>
                <td><%=c.getComboName()%></td>
                <td><input type="number" name="qty_combo_<%=i%>" value="<%=c.getQuantity()%>" style="width:50px"></td>
                <td>
                    <button type="submit" name="action_edit_combo" value="<%=i%>">Sửa</button> 
                    <button type="submit" name="action_remove_combo" value="<%=i%>">Xóa</button>
                </td>
            </tr>
            <%  }
            } %>
        </table>
        
        <br>
        <button type="button" onclick="openPage('SearchFoodAndCombo.jsp')">thêm món ăn hoặc thêm combo</button>
        <button type="submit" name="save" value="true">lưu thay đổi.</button>
    </form>
</body>
</html>