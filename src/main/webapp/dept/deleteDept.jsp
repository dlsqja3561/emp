<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	
	request.setCharacterEncoding("utf-8"); // 한글 utf-8 인코딩
	String deptNo = request.getParameter("deptNo");
	
	// 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("드라이버 로딩 성공"); // 디버깅
	// 마리아db 접속
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees","root","java1234");
	// 쿼리 입력
	String sql = "delete from departments where dept_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, deptNo);

	int row = stmt.executeUpdate();
	if(row == 1) {
		System.out.println("입력성공");
	} else {
		System.out.println("입력실패");
	}
			
	

	response.sendRedirect(request.getContextPath()+"/dept/deptList.jsp");
	// 3. 출력
%>