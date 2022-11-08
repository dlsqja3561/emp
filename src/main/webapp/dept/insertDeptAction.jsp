<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	//안전장치 : Actoin 을 실행하면 Form 으로 가도록
	if(request.getParameter("deptNo") == null 
		|| request.getParameter("deptName") == null ) {

		response.sendRedirect(request.getContextPath()+"/dept/insertDeptForm.jsp");
		return;
	}

	request.setCharacterEncoding("utf-8"); // 한글 utf-8 인코딩
	// 1. 요청분석
	String deptNo = request.getParameter("deptNo");
	String deptName = request.getParameter("deptName"); 
	
	System.out.println(deptNo +"<--deptNo"); // 디버깅
	System.out.println(deptName +"<--deptName");

	
	// 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("드라이버 로딩 성공"); // 디버깅
	// mariadb 접속
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees","root","java1234");
	System.out.println(conn +"<--conn"); // 디버깅
	// 쿼리 만들기
	String sql = "insert into departments(dept_no, dept_name) values(?,?)";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, deptNo);
	stmt.setString(2, deptName);

	int row = stmt.executeUpdate();
	if(row == 1) {
		System.out.println("입력성공");
	} else {
		System.out.println("입력실패");
	}

	response.sendRedirect(request.getContextPath()+"/dept/deptList.jsp");
	
	
%>