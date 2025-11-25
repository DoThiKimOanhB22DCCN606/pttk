<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
    import="dao.OrderCancelByCustomerDAO, model.Order, model.OrderCancelByCustomer, java.util.Date"%>
<%
    request.setCharacterEncoding("UTF-8");
    String reason = request.getParameter("reason");
    
    // Lấy Order từ Session
    Order o = (Order) session.getAttribute("orderToCancel");
    
    if(o != null && reason != null) {
        // Tạo đối tượng Model
        OrderCancelByCustomer oc = new OrderCancelByCustomer(o, new Date(), reason);
        
        // Gọi DAO
        OrderCancelByCustomerDAO dao = new OrderCancelByCustomerDAO();
        
        // SỬA: Nhận kết quả trả về (boolean)
        boolean isSuccess = dao.addOrderCancel(oc);
        
        if (isSuccess) {
            // Thành công: Xóa session cũ để load lại dữ liệu mới
            session.removeAttribute("pendingOrderList");
            session.removeAttribute("acceptedOrderList");
            session.removeAttribute("canceledOrderList");
            session.removeAttribute("orderToCancel");

            response.sendRedirect("ManageOrder.jsp");
        } else {
            // Thất bại: Báo lỗi (Có thể do đơn này đã bị hủy trước đó rồi)
            out.println("<script>alert('Lỗi: Không thể hủy đơn hàng này! (Có thể lỗi CSDL hoặc đơn đã hủy)'); window.location='ManageOrder.jsp';</script>");
        }
    } else {
        response.sendRedirect("ManageOrder.jsp");
    }
%>