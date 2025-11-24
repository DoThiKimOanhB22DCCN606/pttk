<%@page import="dao.OrderCancelByShipperDAO"%>
<%@page import="model.OrderCancelByShipper"%>
<%@page import="model.OrderPickUpByShipper"%>
<%@page import="java.util.Date"%>
<%@page import="model.Shipper"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    request.setCharacterEncoding("UTF-8");
    
    // Lấy lý do từ form và đơn cần hủy từ Session
    String reason = request.getParameter("reason");
    OrderPickUpByShipper orderToCancel = (OrderPickUpByShipper) session.getAttribute("orderToCancel");
    Shipper currentShipper = (Shipper) session.getAttribute("currentShipper");
    
    if (orderToCancel != null && reason != null && !reason.trim().isEmpty()) {
        //Tạo đối tượng OrderCancelByShipper
        OrderCancelByShipper orderCancel = new OrderCancelByShipper(orderToCancel, new Date(), reason);
        
        //Gọi DAO để lưu thông tin hủy
        OrderCancelByShipperDAO dao = new OrderCancelByShipperDAO();
        boolean result = dao.cancelOrder(orderCancel);
        
        if (result) {
            //Thành công: Xóa session cũ để load lại dữ liệu mới
            session.removeAttribute("pendingList");
            session.removeAttribute("deliveringList");
            session.removeAttribute("cancelledList");
            session.removeAttribute("orderToCancel"); // Xóa biến tạm
            
            // Quay lại trang chọn đơn
            response.sendRedirect("ChooseOrder.jsp?shipperCode=" + (currentShipper != null ? currentShipper.getCode() : ""));
        } else {
            out.println("<script>alert('Lỗi CSDL! Không thể hủy đơn.'); history.back();</script>");
        }
    } else {
        response.sendRedirect("ChooseOrder.jsp");
    }
%>
