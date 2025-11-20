<%@ page import="dao.OrderDAO"%>
<%
    int id = Integer.parseInt(request.getParameter("id"));
    OrderDAO dao = new OrderDAO();
    dao.approveOrder(id);
    response.sendRedirect("ManageOrder.jsp");
%>