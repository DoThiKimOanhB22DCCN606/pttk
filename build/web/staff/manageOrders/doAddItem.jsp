<%@ page import="model.*, dao.*"%>
<%
    Order o = (Order) session.getAttribute("orderToEdit");
    String type = request.getParameter("type");
    int id = Integer.parseInt(request.getParameter("id"));
    int qty = Integer.parseInt(request.getParameter("qty"));
    
    if("food".equals(type)) {
        Food f = new FoodDAO().getFoodById(id);
        if(f != null) {
            FoodOrdered fo = new FoodOrdered();
            fo.setFoodId(f.getId()); 
            fo.setFoodName(f.getName()); 
            fo.setFoodPrice(f.getPrice()); 
            fo.setQuantity(qty);
            o.getListFood().add(fo);
        }
    } else if("combo".equals(type)) {
        Combo c = new ComboDAO().getComboById(id);
        if(c != null) {
            ComboOrdered co = new C?omboOrdered();
            co.setComboId(c.getId());
            co.setComboName(c.getName());
            co.setComboPrice(c.getPrice());
            co.setQuantity(qty);
            o.getListCombo().add(co);
        }
    }
    
    // Quay l?i trang tìm ki?m ?? thêm ti?p (gi? keyword)
    String k = request.getParameter("keyword"); // C?n g?i keyword t? form sang n?u mu?n gi?
    response.sendRedirect("SearchFoodAndCombo.jsp?keyword=" + (k!=null?k:""));
%>