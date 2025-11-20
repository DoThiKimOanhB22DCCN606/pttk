<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="model.Member, model.Food, dao.FoodDAO"%>
<%
    //  Kiểm tra session
    Member nv = (Member) session.getAttribute("nhanvien");
    if (nv == null) {
        response.sendRedirect("../member/Login.jsp?err=timeout");
        return;
    }
    
    //  Thiết lập encoding cho Tiếng Việt
    request.setCharacterEncoding("UTF-8");
    String foodId = request.getParameter("id");
    
    // Lấy dữ liệu từ form (EditFood.jsp)
    Food food = new Food();
    try {
        food.setId(Integer.parseInt(request.getParameter("id")));
        food.setName(request.getParameter("name"));
        food.setDescription(request.getParameter("desc"));
        food.setPrice(Double.parseDouble(request.getParameter("price")));
        food.setStatus(request.getParameter("status"));
        
        // Gọi DAO để cập nhật
        FoodDAO dao = new FoodDAO();
        dao.updateFood(food);
        
        // Quay về GD sửa
        response.sendRedirect("EditFood.jsp?id=" + foodId + "&msg=update_ok");
        
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("../Staff.jsp?msg=update_fail");
    }
%>