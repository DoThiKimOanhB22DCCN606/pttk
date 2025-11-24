<%@page import="dao.OrderPickUpByShipperDAO"%>
<%@page import="model.OrderPickUpByShipper"%>
<%@page import="model.Shipper"%>
<%@page import="model.OrderAccepted"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Date"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Lấy tham số orderCode từ URL
    String orderCode = request.getParameter("orderCode");
    
    // Lấy danh sách chờ giao (pendingList) và Shipper hiện tại từ Session
    ArrayList<OrderAccepted> pendingList = (ArrayList<OrderAccepted>) session.getAttribute("pendingList");
    Shipper currentShipper = (Shipper) session.getAttribute("currentShipper");
    
    OrderAccepted targetOrder = null;
    
    // Tìm đơn hàng trong pendingList khớp với orderCode
    if (pendingList != null && orderCode != null) {
        for (OrderAccepted o : pendingList) {
            if (o.getCode().equals(orderCode)) {
                targetOrder = o;
                break;
            }
        }
    }
    
    // Tạo đối tượng OrderPickUpByShipper
    OrderPickUpByShipper orderPU = new OrderPickUpByShipper(targetOrder, new Date(), currentShipper);

    //Gọi DAO để lưu xuống DB
    OrderPickUpByShipperDAO dao = new OrderPickUpByShipperDAO();
    boolean result = dao.pickUpOrder(orderPU);

    if (result) {
        // Thành công: Xóa các list trong Session để trang ChooseOrder.jsp tự load lại dữ liệu mới từ DB
        session.removeAttribute("pendingList");
        session.removeAttribute("deliveringList");
        session.removeAttribute("cancelledList");

        // Quay lại trang chọn đơn
        response.sendRedirect("ChooseOrder.jsp?shipperCode=" + currentShipper.getCode());
    } else {
        // Thất bại: Báo lỗi
        out.println("<script>alert('Lỗi cơ sở dữ liệu! Không thể nhận đơn.'); location.href='ChooseOrder.jsp?shipperCode=" + currentShipper.getCode() + "';</script>");
    }
%>