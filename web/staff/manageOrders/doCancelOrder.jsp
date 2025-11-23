<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
    import="dao.OrderCancelByCustomerDAO, model.Order, model.OrderCancelByCustomer"%>
<%
    request.setCharacterEncoding("UTF-8");
    String reason = request.getParameter("reason");
    
    // Lấy Order từ Session
    Order o = (Order) session.getAttribute("orderToCancel");
    
    if(o != null) {
        // Tạo object
        OrderCancelByCustomer oc = new OrderCancelByCustomer();
        oc.setTblOrderID(o.getId());
        oc.setReason(reason);
        
        // Gọi DAO 
        OrderCancelByCustomerDAO dao = new OrderCancelByCustomerDAO();
        boolean result = dao.cancelOrder(oc);
        
        if(result) {
            // Clear Session
            session.removeAttribute("pendingOrderList");
            session.removeAttribute("acceptedOrderList");
            session.removeAttribute("canceledOrderList");
            session.removeAttribute("orderToCancel");
            
            response.sendRedirect("ManageOrder.jsp");
        } else {
            response.sendRedirect("ManageOrder.jsp?err=db");
        }
    } else {
        response.sendRedirect("ManageOrder.jsp");
    }
%>