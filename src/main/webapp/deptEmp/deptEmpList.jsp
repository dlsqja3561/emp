<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="vo.*" %>
<%@ page import="java.util.*" %>
<%
	
	//한글처리 utf-8로 인코딩
	request.setCharacterEncoding("utf-8");
	// 1.
	// 검색 입력값
	String word = request.getParameter("word");
	// 페이징
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	// 2.

	// 드라이버 로딩 db 접속
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://localhost:3306/employees";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);	
	// Connection 연결
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	
	// 페이징 필요 변수
	int rowPerPage = 10;
	int beginRow = (currentPage - 1) * rowPerPage;

	// lastPage 처리
	String countSql = null;
	PreparedStatement countStmt = null;
	if(word == null) {
		countSql = "SELECT COUNT(*) FROM dept_emp de INNER JOIN employees e ON de.emp_no = e.emp_no INNER JOIN departments d ON de.dept_no = d.dept_no"; // 전체 행 개수 구하기 쿼리
		countStmt = conn.prepareStatement(countSql);
	} else {
		countSql = "SELECT COUNT(*) FROM dept_emp de INNER JOIN employees e ON de.emp_no = e.emp_no INNER JOIN departments d ON de.dept_no = d.dept_no WHERE de.emp_no LIKE ? OR e.first_name LIKE ? OR de.dept_no LIKE ?";
		countStmt = conn.prepareStatement(countSql);
		countStmt.setString(1, "%"+word+"%");
		countStmt.setString(2, "%"+word+"%");
		countStmt.setString(3, "%"+word+"%");
	}
	ResultSet countRs = countStmt.executeQuery();

	int count = 0;
	if(countRs.next()) {
		count = countRs.getInt("COUNT(*)"); // 전체 행 개수
	}
	
	int lastPage = count / rowPerPage;
	if(count % rowPerPage != 0) {
		lastPage = lastPage + 1; // lastPage++, lastPage+=1
	}

	
	String sql = null;
	PreparedStatement stmt = null;
	if(word == null) {
		sql = "SELECT de.emp_no empNo, d.dept_no deptNo, d.dept_name deptName, e.first_name firstName, de.from_date fromDate, de.to_date toDate FROM dept_emp de INNER JOIN employees e ON de.emp_no = e.emp_no INNER JOIN departments d ON de.dept_no = d.dept_no ORDER BY de.emp_no ASC LIMIT ?, ?";
		stmt = conn. prepareStatement(sql);
		stmt.setInt(1, beginRow);
		stmt.setInt(2, rowPerPage);
	} else {
		sql = "SELECT de.emp_no empNo, d.dept_no deptNo, d.dept_name deptName, e.first_name firstName, de.from_date fromDate, de.to_date toDate FROM dept_emp de INNER JOIN employees e ON de.emp_no = e.emp_no INNER JOIN departments d ON de.dept_no = d.dept_no WHERE de.emp_no LIKE ? OR e.first_name LIKE ? OR de.dept_no LIKE ? ORDER BY de.emp_no ASC LIMIT ?, ?";
		stmt = conn. prepareStatement(sql);
		stmt.setString(1, "%"+word+"%");
		stmt.setString(2, "%"+word+"%");
		stmt.setString(3, "%"+word+"%");
		stmt.setInt(4, beginRow);
		stmt.setInt(5, rowPerPage);
	}
	
	ResultSet rs = stmt.executeQuery();

	ArrayList<DeptEmp> list = new ArrayList<DeptEmp>();
	while(rs.next()) {
		DeptEmp de = new DeptEmp();
		de.emp = new Employee();
		de.emp.empNo = rs.getInt("empNo");
		de.emp.firstName = rs.getString("firstName");
		de.dept = new Department();
		de.dept.deptNo = rs.getString("deptNo");
		de.dept.deptName = rs.getString("deptname");
		de.fromDate = rs.getString("fromDate");
		de.toDate = rs.getString("toDate");
		list.add(de);
	}
	
	// Connection 연결종료
	rs.close();
	countRs.close();
	stmt.close();
	countStmt.close();
	conn.close();
%>



<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>

</head>
<body>
	<!-- 메뉴 partial jsp 구성  -->
	<div style="text-align: center">
		<jsp:include page="/inc/menu.jsp"></jsp:include>
	</div>
	<div class="container pt-5" style="text-align: center">
		<h1 class="alert alert-success">deptEmpList</h1>
		<table class="table table-bordered table-striped">
			<tr>
				<th>사원번호</th>
				<th>부서번호</th>
				<th>이름</th>
				<th>fromDate</th>
				<th>toDate</th>
			</tr>
			<%
				for(DeptEmp de : list) {
			%>
					<tr>
						<td><%=de.emp.empNo%></td>
						<td><%=de.dept.deptNo%></td>
						<td><%=de.emp.firstName%></td>
						<td><%=de.fromDate%></td>
						<td><%=de.toDate%></td>
					</tr>
			<%      
				}
			%>
		</table>
	</div>
	<div>
		<!-- 검색창 -->
		<form method="post" action="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp">
	 		<input type="text" name="word" id="word" placeholder="번호 or 이름 검색">
	 		<button type="submit">검색</button>
		</form>
	</div>
	<!-- 페이징 코드 -->
	<div style="text-align: center">
		<%
		// word(검색) 값 X 페이징-----------------------------------------------
			if(word == null) {
		%>
				<a href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=1">처음</a>
		<%
				if(currentPage > 1) {
		%>
				<a href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=<%=currentPage-1%>" class="btn btn-outline-dark btn-sm"><%="<"%></a>
		<%	// 1페이지일때 이전버튼 클릭시 
				} else {
		%>
					<a href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=1" class="btn btn-outline-dark btn-sm"><%="<"%></a>
		<%
			}
		%>
			<span><%=currentPage%>/<%=lastPage%></span>
		<%
				if(currentPage < lastPage) {
		%>
					<a href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=<%=currentPage+1%>" class="btn btn-outline-dark btn-sm"><%=">"%></a>
		<%	// 마지막페이지 일때 다음버튼 클릭시
				} else {
		%>
					<a href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=<%=lastPage%>" class="btn btn-outline-dark btn-sm"><%=">"%></a>
		<%
			}
		%>
				<a href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=<%=lastPage%>">마지막</a>
		<%
		// 검색 후 페이징 -------------------------------------------------
			} else {
		%>
				<a href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=1&word=<%=word%>">처음</a>
		<%
				if(currentPage > 1) {
		%>
					<a href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=<%=currentPage-1%>&word=<%=word%>" class="btn btn-outline-dark btn-sm"><%="<"%></a>
		<%	// 1페이지일때 이전버튼 클릭시 
				} else {
		%>
					<a href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=1&word=<%=word%>" class="btn btn-outline-dark btn-sm"><%="<"%></a>
		<%
			}
		%>
			<span><%=currentPage%>/<%=lastPage%></span>
		<%
				if(currentPage < lastPage) {
		%>
					<a href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=<%=currentPage+1%>&word=<%=word%>" class="btn btn-outline-dark btn-sm"><%=">"%></a>
		<%	// 마지막페이지 일때 다음버튼 클릭시
				} else {
		%>
					<a href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=<%=lastPage%>&word=<%=word%>" class="btn btn-outline-dark btn-sm"><%=">"%></a>
		<%
			}
		%>
				<a href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=<%=lastPage%>&word=<%=word%>">마지막</a>
		<%
			}
		%>
	</div>
</body>
</html>