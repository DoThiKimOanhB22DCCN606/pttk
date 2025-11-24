<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
    import="dao.OrderCancelByCustomerDAO, model.Order, model.OrderCancelByCustomer, java.util.Date"%>
<%
    request.setCharacterEncoding("UTF-8");
    String reason = request.getParameter("reason");
    
    // Lấy Order từ Session
    Order o = (Order) session.getAttribute("orderToCancel");
    
    if(o != null) {
        // Khởi tạo bằng Constructor (Order, Date, Reason) 
        OrderCancelByCustomer oc = new OrderCancelByCustomer(o, new Date(), reason);
        
        // Gọi DAO 
        OrderCancelByCustomerDAO dao = new OrderCancelByCustomerDAO();
        
        // Clear Session
        session.removeAttribute("pendingOrderList");
        session.removeAttribute("acceptedOrderList");
        session.removeAttribute("canceledOrderList");
        session.removeAttribute("orderToCancel");

        response.sendRedirect("ManageOrder.jsp");
        
    } else {
        response.sendRedirect("ManageOrder.jsp");
    }
%>