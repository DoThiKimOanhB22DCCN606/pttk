<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" 
    import="model.Order, model.FoodOrdered, model.ComboOrdered, dao.OrderDAO"%>
<%
    request.setCharacterEncoding("UTF-8");
    Order o = (Order) session.getAttribute("orderToEdit");
    if(o == null) { response.sendRedirect("ManageOrder.jsp"); return; }

    // Update session object from input
    o.getCustomer().setFullname(request.getParameter("cusName"));
    o.getCustomer().setNumber(request.getParameter("cusPhone"));
    o.getCustomer().setAddress(request.getParameter("cusAddr"));
    
    o.setNote(request.getParameter("note"));
    try { o.setDiscount(Double.parseDouble(request.getParameter("discount"))); } catch(Exception e) {}
    try { o.setShipFee(Double.parseDouble(request.getParameter("shipFee"))); } catch(Exception e) {}

    // Handle clicking save
    if(request.getParameter("save") != null) {
        // Recalculate total
        double subTotal = 0;
        for(FoodOrdered f : o.getListFood()) subTotal += f.getFood().getPrice() * f.getQuantity();
        for(ComboOrdered c : o.getListCombo()) subTotal += c.getCombo().getPrice() * c.getQuantity();
        
        o.setTotal(subTotal + o.getShipFee() - o.getDiscount());
        
        OrderDAO dao = new OrderDAO();
        //update general info
        dao.updateOrder(o); 
        //update list food ordered
        dao.updateListFood(o.getId(), o.getListFood());
        //update list combo ordered
        dao.updateListCombo(o.getId(), o.getListCombo());
        
        session.removeAttribute("orderToEdit");
        session.removeAttribute("pendingOrderList"); 
        response.sendRedirect("ManageOrder.jsp?back=true");
    
    //handle edit food
    } else if(request.getParameter("action_edit_food") != null) {
        int idx = Integer.parseInt(request.getParameter("action_edit_food"));
        int qty = Integer.parseInt(request.getParameter("qty_food_" + idx));
        o.getListFood().get(idx).setQuantity(qty);
        response.sendRedirect("EditOrder.jsp");
        
    //handlfe remove food
    } else if(request.getParameter("action_remove_food") != null) {
        int idx = Integer.parseInt(request.getParameter("action_remove_food"));
        o.getListFood().remove(idx);
        response.sendRedirect("EditOrder.jsp");
        
    //handle edit combo
    } else if(request.getParameter("action_edit_combo") != null) {
        int idx = Integer.parseInt(request.getParameter("action_edit_combo"));
        int qty = Integer.parseInt(request.getParameter("qty_combo_" + idx));
        o.getListCombo().get(idx).setQuantity(qty);
        response.sendRedirect("EditOrder.jsp");
        
    //handle remove combo
    } else if(request.getParameter("action_remove_combo") != null) {
        int idx = Integer.parseInt(request.getParameter("action_remove_combo"));
        o.getListCombo().remove(idx);
        response.sendRedirect("EditOrder.jsp");
    }
%>