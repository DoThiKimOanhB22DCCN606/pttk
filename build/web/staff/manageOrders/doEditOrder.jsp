<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" 
    import="model.Order, model.FoodOrdered, model.ComboOrdered, dao.OrderDAO"%>
<%
    request.setCharacterEncoding("UTF-8");
    Order o = (Order) session.getAttribute("orderToEdit");
    if(o == null) { response.sendRedirect("ManageOrder.jsp"); return; }

    // CẬP NHẬT THÔNG TIN INPUT VÀO SESSION
    o.setCustomerName(request.getParameter("cusName"));
    o.setCustomerPhone(request.getParameter("cusPhone"));
    o.setCustomerAddress(request.getParameter("cusAddr"));
    o.setNote(request.getParameter("note"));

    // XỬ LÝ ACTION
    if(request.getParameter("save") != null) {
        // Tính lại tổng tiền
        double subTotal = 0;
        for(FoodOrdered f : o.getListFood()) subTotal += f.getFoodPrice() * f.getQuantity();
        for(ComboOrdered c : o.getListCombo()) subTotal += c.getComboPrice() * c.getQuantity();
        o.setTotal(subTotal + o.getShipFee() - o.getDiscount());
        
        //gọi hàm Update
        OrderDAO dao = new OrderDAO();
        dao.updateOrder(o); // Update Order Info
        dao.updateListFood(o.getId(), o.getListFood()); // Update Food
        dao.updateListCombo(o.getId(), o.getListCombo()); // Update Combo
        
        // Xóa session để reload
        session.removeAttribute("orderToEdit");
        session.removeAttribute("pendingOrderList"); // Buộc ManageOrder load lại từ DB
        response.sendRedirect("ManageOrder.jsp?back=true");
        
    } else if(request.getParameter("action_edit_food") != null) {
        int idx = Integer.parseInt(request.getParameter("action_edit_food"));
        int qty = Integer.parseInt(request.getParameter("qty_food_" + idx));
        o.getListFood().get(idx).setQuantity(qty);
        response.sendRedirect("EditOrder.jsp");
        
    } else if(request.getParameter("action_remove_food") != null) {
        int idx = Integer.parseInt(request.getParameter("action_remove_food"));
        o.getListFood().remove(idx);
        response.sendRedirect("EditOrder.jsp");
        
    } else if(request.getParameter("action_edit_combo") != null) {
        int idx = Integer.parseInt(request.getParameter("action_edit_combo"));
        int qty = Integer.parseInt(request.getParameter("qty_combo_" + idx));
        o.getListCombo().get(idx).setQuantity(qty);
        response.sendRedirect("EditOrder.jsp");
        
    } else if(request.getParameter("action_remove_combo") != null) {
        int idx = Integer.parseInt(request.getParameter("action_remove_combo"));
        o.getListCombo().remove(idx);
        response.sendRedirect("EditOrder.jsp");
    }
%>