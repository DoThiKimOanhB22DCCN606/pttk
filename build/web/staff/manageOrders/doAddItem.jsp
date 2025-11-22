<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" 
    import="model.Order, model.FoodOrdered, model.ComboOrdered, model.Food, model.Combo, dao.FoodDAO, dao.ComboDAO"%>
<%
    // 1. Lấy Order từ Session
    Order o = (Order) session.getAttribute("orderToEdit");
    
    // Nếu session bị mất, quay về trang quản lý
    if(o == null) {
        response.sendRedirect("ManageOrder.jsp");
        return;
    }

    // 2. Lấy tham số từ form gửi sang
    String type = request.getParameter("type");
    int id = Integer.parseInt(request.getParameter("id"));
    int qty = Integer.parseInt(request.getParameter("qty"));
    
    // 3. Xử lý thêm Món hoặc Combo
    if("food".equals(type)) {
        FoodDAO fd = new FoodDAO();
        Food f = fd.getFoodById(id);
        
        if(f != null) {
            FoodOrdered fo = new FoodOrdered();
            fo.setFoodId(f.getId()); 
            fo.setFoodName(f.getName()); 
            fo.setFoodPrice(f.getPrice()); 
            fo.setQuantity(qty);
            
            // Thêm vào list Food trong session
            o.getListFood().add(fo);
        }
    } else if("combo".equals(type)) {
        ComboDAO cd = new ComboDAO();
        Combo c = cd.getComboById(id);
        
        if(c != null) {
            // --- SỬA LỖI Ở ĐÂY (Xóa dấu ? đi) ---
            ComboOrdered co = new ComboOrdered(); 
            
            co.setComboId(c.getId());
            co.setComboName(c.getName());
            co.setComboPrice(c.getPrice());
            co.setQuantity(qty);
            
            // Thêm vào list Combo trong session
            o.getListCombo().add(co);
        }
    }
    
    // 4. Giữ lại từ khóa tìm kiếm để người dùng đỡ phải nhập lại
    String k = request.getParameter("keyword"); 
    if(k == null) k = "";
    
    // Quay lại trang tìm kiếm để thêm tiếp
    response.sendRedirect("SearchFoodAndCombo.jsp?keyword=" + k);
%>