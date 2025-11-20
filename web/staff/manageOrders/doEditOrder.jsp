<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" 
    import="model.Order, model.FoodOrdered, model.ComboOrdered, dao.OrderDAO"%>
<%
    request.setCharacterEncoding("UTF-8");
    Order o = (Order) session.getAttribute("orderToEdit");
    if(o == null) { response.sendRedirect("ManageOrder.jsp"); return; }

    // 1. CẬP NHẬT THÔNG TIN TỪ INPUT VÀO SESSION TRƯỚC KHI LÀM GÌ KHÁC
    o.setCustomerName(request.getParameter("cusName"));
    o.setCustomerPhone(request.getParameter("cusPhone"));
    o.setCustomerAddress(request.getParameter("cusAddr"));
    o.setNote(request.getParameter("note"));
    try { o.setDiscount(Double.parseDouble(request.getParameter("discount"))); } catch(Exception e) {}
    try { o.setShipFee(Double.parseDouble(request.getParameter("shipFee"))); } catch(Exception e) {}

    // 2. XỬ LÝ NÚT BẤM
    if(request.getParameter("save") != null) {
        double subTotal = 0;
        for(FoodOrdered f : o.getListFood()) subTotal += f.getFoodPrice() * f.getQuantity();
        for(ComboOrdered c : o.getListCombo()) subTotal += c.getComboPrice() * c.getQuantity();
        o.setTotal(subTotal + o.getShipFee() - o.getDiscount());
        
        new OrderDAO().updateOrderFull(o); // LƯU VÀO DB
        session.removeAttribute("orderToEdit");
        response.sendRedirect("ManageOrder.jsp?back=true");
    } 
    else if(request.getParameter("action_edit_food") != null) {
        int idx = Integer.parseInt(request.getParameter("action_edit_food"));
        o.getListFood().get(idx).setQuantity(Integer.parseInt(request.getParameter("qty_food_" + idx)));
        response.sendRedirect("EditOrder.jsp");
    }
    else if(request.getParameter("action_remove_food") != null) {
        o.getListFood().remove(Integer.parseInt(request.getParameter("action_remove_food")));
        response.sendRedirect("EditOrder.jsp");
    }
    else if(request.getParameter("action_edit_combo") != null) {
        int idx = Integer.parseInt(request.getParameter("action_edit_combo"));
        o.getListCombo().get(idx).setQuantity(Integer.parseInt(request.getParameter("qty_combo_" + idx)));
        response.sendRedirect("EditOrder.jsp");
    }
    else if(request.getParameter("action_remove_combo") != null) {
        o.getListCombo().remove(Integer.parseInt(request.getParameter("action_remove_combo")));
        response.sendRedirect("EditOrder.jsp");
    }
%>