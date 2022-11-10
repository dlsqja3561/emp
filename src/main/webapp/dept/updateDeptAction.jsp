<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="vo.Department" %>
<%@ page import="java.net.URLEncoder" %>
<%
	//안전장치 : Actoin 을 실행하면 deptList 으로 가도록
	if(request.getParameter("deptNo") == null 
		|| request.getParameter("deptName") == null ) {

		response.sendRedirect(request.getContextPath()+"/dept/deptList.jsp");
		return;
	}

	request.setCharacterEncoding("utf-8"); // 한글 utf-8 인코딩
	
	// form 에서 값 받기
	String deptNo = request.getParameter("deptNo");
	String deptName = request.getParameter("deptName");
	System.out.println(deptNo +"<--deptNo"); // 디버깅
	System.out.println(deptName +"<--deptName");
		
	Department dept = new Department();
	dept.deptNo = deptNo;
	dept.deptName = deptName;
		
	// 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("드라이버 로딩 성공"); // 디버깅
	// mariadb 접속
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees","root","java1234");
	System.out.println(conn +"<--conn"); // 디버깅
	// 쿼리 만들기

	// 2-1 dept_name 중복검사 (dept_no 는 고정)
	String sql1 = "select * from departments where dept_name = ?"; // 입력하기전에 같은 dept_name가 존재하는지 확인
	PreparedStatement stmt1 = conn.prepareStatement(sql1);
	stmt1.setString(1, deptName);
	ResultSet rs = stmt1.executeQuery();
	if(rs.next()) { // 결과물이있다 -> 같은 dept_no OR dept_name가 이미 존재한다.
		String msg = "부서이름이 중복되었습니다.";
		response.sendRedirect(request.getContextPath()+"/dept/updateDeptForm.jsp?msg="+URLEncoder.encode(msg,"UTF-8"));
		return;
	}
		
	// 2-2 입력
	String sql2 = "update departments set dept_name=? where dept_no=?";
	PreparedStatement stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1, deptName);
	stmt2.setString(2, deptNo);

	int row = stmt2.executeUpdate();
	if(row == 1) {
		System.out.println("수정성공");
	} else {
		System.out.println("수정실패");
	}


	response.sendRedirect(request.getContextPath()+"/dept/deptList.jsp");
	
	
%>