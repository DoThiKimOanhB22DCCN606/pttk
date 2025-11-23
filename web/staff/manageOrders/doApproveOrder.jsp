<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
    import="dao.OrderAcceptedDAO, model.Order, model.OrderAccepted, java.util.ArrayList"%>
<%
    String code = request.getParameter("code");
    
    // Tìm Order trong Session Pending List
    ArrayList<Order> list = (ArrayList<Order>) session.getAttribute("pendingOrderList");
    Order target = null;
    if(list != null) {
        for(Order o : list) {
            if(o.getCode().equals(code)) {
                target = o;
                break;
            }
        }
    }
    
    if(target != null) {
        // Tạo OrderAccepted
        OrderAccepted oa = new OrderAccepted();
        oa.setTblOrderID(target.getId());
        
        // Gọi DAO 
        OrderAcceptedDAO dao = new OrderAcceptedDAO();
        boolean result = dao.acceptOrder(oa);
        
        if(result) {
            //Xóa Session để ManageOrder.jsp tự load lại dữ liệu mới từ DB
            session.removeAttribute("pendingOrderList");
            session.removeAttribute("acceptedOrderList");
            session.removeAttribute("canceledOrderList");
            response.sendRedirect("ManageOrder.jsp");
        } else {
            // Lỗi DB
            response.sendRedirect("ManageOrder.jsp?err=db");
        }
    } else {
        // Không tìm thấy trong session
        response.sendRedirect("ManageOrder.jsp?err=notfound");
    }
%>