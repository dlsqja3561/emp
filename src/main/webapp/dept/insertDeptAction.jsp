<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.URLEncoder" %>
<%

	request.setCharacterEncoding("utf-8"); // 한글 utf-8 인코딩
	// 1. 요청분석
	String deptNo = request.getParameter("deptNo");
	String deptName = request.getParameter("deptName"); 
	System.out.println(deptNo +"<--deptNo"); // 디버깅
	System.out.println(deptName +"<--deptName");

	//  값이 없으면 insertDeptForm.jsp 으로 이동 msg 출력
	if(deptNo == null || deptName == null || deptNo.equals("") || deptName.equals("")) {
		String msg = URLEncoder.encode("부서번호와 부서이름을 입력하세요.","utf-8"); // get방식 주소창에 문자열 인코딩
		response.sendRedirect(request.getContextPath()+"/dept/insertDeptForm.jsp?msg="+msg);
		return;
	}
	
	
	// 2. 요청처리
	// 이미 존재하는 key(dept_no)값에 동일한 값이 입력되면 예외(에러) 발생 -> 동일한 dept_no값이 들어오지 않도록 막아야 한다.
	// 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("드라이버 로딩 성공"); // 디버깅
	// mariadb 접속
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees","root","java1234");
	System.out.println(conn +"<--conn"); // 디버깅

	// 쿼리 만들기
	// 2-1 dept_no, dept_name 중복검사
	String sql1 = "select * from departments where dept_no = ? or dept_name = ?"; // 입력하기전에 같은 dept_no가 존재하는지 확인
	PreparedStatement stmt1 = conn.prepareStatement(sql1);
	stmt1.setString(1, deptNo);
	stmt1.setString(2, deptName);
	ResultSet rs = stmt1.executeQuery();
	if(rs.next()) { // 결과물이있다 -> 같은 dept_no OR dept_name가 이미 존재한다.
		String msg = URLEncoder.encode("부서번호 또는 부서이름이 중복되었습니다.","utf-8");
		response.sendRedirect(request.getContextPath()+"/dept/insertDeptForm.jsp?msg="+msg);
		return;
	}

	// 2-2 입력
	String sql2 = "insert into departments(dept_no, dept_name) values(?,?)";
	PreparedStatement stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1, deptNo);
	stmt2.setString(2, deptName);

	int row = stmt2.executeUpdate();
	if(row == 1) {
		System.out.println("입력성공");
	} else {
		System.out.println("입력실패");
	}

	response.sendRedirect(request.getContextPath()+"/dept/deptList.jsp");
	
	
%>