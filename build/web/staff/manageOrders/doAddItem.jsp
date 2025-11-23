<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" 
    import="model.Order, model.FoodOrdered, model.ComboOrdered, model.Food, model.Combo, dao.FoodDAO, dao.ComboDAO"%>
<%
    //Get Order from Session
    Order o = (Order) session.getAttribute("orderToEdit");
    
    // Check if session is valid
    if(o == null) {
        response.sendRedirect("ManageOrder.jsp");
        return;
    }

    // Get parameters
    String type = request.getParameter("type");
    int id = Integer.parseInt(request.getParameter("id"));
    int qty = Integer.parseInt(request.getParameter("qty"));
    
    // Handle adding food or combo
    if("food".equals(type)) {
        FoodDAO fd = new FoodDAO();
        Food f = fd.getFoodById(id);
        
        if(f != null) {
            FoodOrdered fo = new FoodOrdered();
            fo.setFood(f); 
            fo.setQuantity(qty);
            
            o.getListFood().add(fo);
        }
    } else if("combo".equals(type)) {
        ComboDAO cd = new ComboDAO();
        Combo c = cd.getComboById(id);
        
        if(c != null) {
            ComboOrdered co = new ComboOrdered(); 
            co.setCombo(c);
            co.setQuantity(qty);
            
            o.getListCombo().add(co);
        }
    }
    
    //Redirect back to Search page to continue adding items
    String k = request.getParameter("keyword"); 
    if(k == null) k = "";
    
    response.sendRedirect("SearchFoodAndCombo.jsp?keyword=" + k);
%>