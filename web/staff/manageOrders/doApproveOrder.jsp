<%@page import="java.util.Date"%>
<%@page import="model.Staff"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
    import="dao.OrderAcceptedDAO, model.Order, model.OrderAccepted, java.util.ArrayList"%>
<%
    String code = request.getParameter("code");
    
    // 1. Tìm Order trong Session Pending List
    ArrayList<Order> list = (ArrayList<Order>) session.getAttribute("pendingOrderList");
    Order target = null;
    if(list != null && code != null) {
        for(Order o : list) {
            if(o.getCode().equals(code)) {
                target = o;
                break;
            }
        }
    }
    
    if(target != null) {
        // 2. Lấy nhân viên đang đăng nhập (SỬA: dùng đúng tên session "nhanvien")
        Staff currentStaff = (Staff) session.getAttribute("nhanvien"); 
        
        // Kiểm tra kỹ: Nếu staff null thì đá về trang login
        if(currentStaff == null) {
             response.sendRedirect("../../member/Login.jsp");
             return;
        }

        // 3. Gán nhân viên vào đơn hàng (SỬA: dùng biến 'target')
        target.setStaff(currentStaff);

        // 4. Khởi tạo OrderAccepted (Constructor này đã đúng với Model bạn sửa)
        OrderAccepted oa = new OrderAccepted(target, new Date());
        
        // 5. Gọi DAO
        OrderAcceptedDAO dao = new OrderAcceptedDAO();
        dao.addOrderAccepted(oa);
        
        // 6. Xóa Session để ManageOrder.jsp tự load lại dữ liệu mới từ DB
        session.removeAttribute("pendingOrderList");
        session.removeAttribute("acceptedOrderList");
        session.removeAttribute("canceledOrderList");
        
        response.sendRedirect("ManageOrder.jsp");
    } else {
        // Không tìm thấy đơn hàng
        response.sendRedirect("ManageOrder.jsp?err=notfound");
    }
%>