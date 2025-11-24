<%@page import="java.util.Date"%>
<%@page import="model.Staff"%>
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
        // Lấy nhân viên đang đăng nhập (để biết ai duyệt đơn này)
        Staff currentStaff = (Staff) session.getAttribute("staff"); 
        if(currentStaff != null) {
            target.setStaff(currentStaff);
        }

        // Khởi tạo OrderAccepted bằng Constructor (Order, Date)
        OrderAccepted oa = new OrderAccepted(target, new Date());
        
        // Gọi DAO
        OrderAcceptedDAO dao = new OrderAcceptedDAO();
        
        dao.addOrderAccepted(oa);
        //Xóa Session để ManageOrder.jsp tự load lại dữ liệu mới từ DB
        session.removeAttribute("pendingOrderList");
        session.removeAttribute("acceptedOrderList");
        session.removeAttribute("canceledOrderList");
        response.sendRedirect("ManageOrder.jsp");
    } else {
        // Không tìm thấy trong session
        response.sendRedirect("ManageOrder.jsp?err=notfound");
    }
%>