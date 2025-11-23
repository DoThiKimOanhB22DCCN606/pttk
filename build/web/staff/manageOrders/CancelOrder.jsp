<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" 
    import="model.Order, java.util.ArrayList"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Cancel View</title>
</head>
<body>
    <%
    String code = request.getParameter("code");
    ArrayList<Order> list = (ArrayList<Order>) session.getAttribute("pendingOrderList");
    Order o = null;
    //find order to cancel
    if(list != null) {
        for(Order ord : list) {
            if(ord.getCode().equals(code)) {
                o = ord;
                break;
            }
        }
    }
    
    if(o != null) {
        session.setAttribute("orderToCancel", o);
    } else {
        response.sendRedirect("ManageOrder.jsp");
        return;
    }
    %>
    
    <h3>Cancel view</h3>
    <form action="doCancelOrder.jsp" method="post">
        <table border="1" style="border-collapse: collapse;">
            <tr>
                <td>Ô nhập lý do hủy</td>
                <td><input type="text" name="reason" required style="width: 300px;"></td>
            </tr>
            <tr>
                <td colspan="2"><input type="submit" value="xác nhận hủy"></td>
            </tr>
        </table>
    </form>
</body>
</html>