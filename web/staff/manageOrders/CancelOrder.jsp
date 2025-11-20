<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Cancel view</title>
</head>
<body>
    <h3>Cancel view</h3>
    <form action="doCancelOrder.jsp" method="post">
        <input type="hidden" name="id" value="<%=request.getParameter("id")%>">
        
        <table border="1" style="border-collapse: collapse;">
            <tr>
                <td>Ô nhập lý do hủy</td>
                <td><input type="text" name="reason" style="width: 300px;"></td>
            </tr>
            <tr>
                <td colspan="2"><input type="submit" value="xác nhận hủy"></td>
            </tr>
        </table>
    </form>
</body>
</html>