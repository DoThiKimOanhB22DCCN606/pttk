<%@ page import="dao.OrderDAO"%>
<%
    request.setCharacterEncoding("UTF-8");
    int id = Integer.parseInt(request.getParameter("id"));
    String reason = request.getParameter("reason");
    OrderDAO dao = new OrderDAO();
    dao.cancelOrder(id, reason);
    response.sendRedirect("ManageOrder.jsp");
%>