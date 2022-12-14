<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="vo.*" %>
<%@ page import="java.util.*" %>
<%
	//한글처리 utf-8로 인코딩
	request.setCharacterEncoding("utf-8");

	// 1
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
		countSql = "SELECT COUNT(*) FROM salaries"; // 전체 행 개수 구하기 쿼리
		countStmt = conn.prepareStatement(countSql);
	} else {
		countSql = "SELECT COUNT(*) FROM salaries s INNER JOIN employees e ON s.emp_no = e.emp_no WHERE s.emp_no LIKE ? OR e.first_name LIKE ? OR e.last_name LIKE ?";
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
		
	/*
	SELECT s.emp_no empNo
	     , s.salary salary
	     , s.from_date fromDate
	     , s.to_date toDate
	     , e.first_name firstName 
	     , e.last_name lastName
	from
	salaries s INNER JOIN employees e    # 테이블 두개를 합칠때 : 테이블1 JOIN 테이블2 ON 합치는 조건식 
	ON s.emp_no = e.emp_no
	LIMIT ?, ?
	*/

	String salarySql = null;
	PreparedStatement alaryStmt = null;
	if(word == null) {
		salarySql = "SELECT s.emp_no empNo, s.salary salary, s.from_date fromDate, s.to_date toDate, e.first_name firstName, e.last_name lastName FROM salaries s INNER JOIN employees e ON s.emp_no = e.emp_no ORDER BY s.emp_no ASC LIMIT ?, ?";
		alaryStmt = conn. prepareStatement(salarySql);
		alaryStmt.setInt(1, beginRow);
		alaryStmt.setInt(2, rowPerPage);
	} else {
		salarySql = "SELECT s.emp_no empNo, s.salary salary, s.from_date fromDate, s.to_date toDate, e.first_name firstName, e.last_name lastName FROM salaries s INNER JOIN employees e ON s.emp_no = e.emp_no WHERE s.emp_no LIKE ? OR e.first_name LIKE ? OR e.last_name LIKE ? ORDER BY s.emp_no ASC LIMIT ?, ?";
		alaryStmt = conn. prepareStatement(salarySql);
		alaryStmt.setString(1, "%"+word+"%");
		alaryStmt.setString(2, "%"+word+"%");
		alaryStmt.setString(3, "%"+word+"%");
		alaryStmt.setInt(4, beginRow);
		alaryStmt.setInt(5, rowPerPage);
	}

	ResultSet rs = alaryStmt.executeQuery();
	ArrayList<Salary> salaryList = new ArrayList<Salary>();
	while(rs.next()) {
		Salary s = new Salary();
		s.emp = new Employee(); // ☆☆☆☆☆☆☆
		s.emp.empNo = rs.getInt("empNo");
		s.salary = rs.getInt("salary");
		s.fromDate = rs.getString("fromDate");
		s.toDate = rs.getString("toDate");
		s.emp.firstName = rs.getString("firstName");
		s.emp.lastName = rs.getString("lastName");
		salaryList.add(s);
	}
%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
	<style>
		 a.menu:link, a.menu:visited {
		  background-color: white;
		  color: black;
		  border: 2px solid green;
		  padding: 5px 20px;
		  text-align: center;
		  text-decoration: none;
		  display: inline-block;
		}
		
		 a.menu:hover, a.menu:active {
		  background-color: green;
		  color: white;
		}
	</style>
</head>
<body>
	<!-- 메뉴 partial jsp 구성  -->
	<div style="text-align: center">
		<jsp:include page="/inc/menu.jsp"></jsp:include>
	</div>
	<div class="container pt-5" style="text-align: center">
		<h1 class="alert alert-success">salaryList</h1>
		<table class="table table-bordered table-striped">
			<tr>
				<th>empNo</th>
				<th>salary</th>
				<th>fromDate</th>
				<th>toDate</th>
				<th>Name</th>
			</tr>
			<%
				for(Salary s : salaryList) {
			%>
					<tr>
						<td><%=s.emp.empNo%></td>
						<td><%=s.salary%></td>
						<td><%=s.fromDate%></td>
						<td><%=s.toDate%></td>
						<td><%=s.emp.firstName%> <%=s.emp.lastName%></td>
					</tr>
			<%      
				}
			%>
		</table>
	</div>
	
	<div>
		<!-- 검색창 -->
		<form method="post" action="<%=request.getContextPath()%>/salary/salaryList.jsp">
			<div style="text-align: center">
			 	<input type="text" name="word" id="word" placeholder="번호 or 이름 검색">
			 	<button type="submit">검색</button>
		 	</div>
		</form>
	</div>
	<!-- 페이징 코드 -->
	<div style="text-align: center">
		<%
		// word(검색) 값 X 페이징-----------------------------------------------
			if(word == null) {
		%>
				<a href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=1">처음</a>
		<%
				if(currentPage > 1) {
		%>
				<a href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=<%=currentPage-1%>" class="btn btn-outline-dark btn-sm"><%="<"%></a>
		<%	// 1페이지일때 이전버튼 클릭시 
				} else {
		%>
					<a href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=1" class="btn btn-outline-dark btn-sm"><%="<"%></a>
		<%
			}
		%>
			<span><%=currentPage%>/<%=lastPage%></span>
		<%
				if(currentPage < lastPage) {
		%>
					<a href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=<%=currentPage+1%>" class="btn btn-outline-dark btn-sm"><%=">"%></a>
		<%	// 마지막페이지 일때 다음버튼 클릭시
				} else {
		%>
					<a href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=<%=lastPage%>" class="btn btn-outline-dark btn-sm"><%=">"%></a>
		<%
			}
		%>
				<a href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=<%=lastPage%>">마지막</a>
		<%
		// 검색 후 페이징 -------------------------------------------------
			} else {
		%>
				<a href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=1&word=<%=word%>">처음</a>
		<%
				if(currentPage > 1) {
		%>
					<a href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=<%=currentPage-1%>&word=<%=word%>" class="btn btn-outline-dark btn-sm"><%="<"%></a>
		<%	// 1페이지일때 이전버튼 클릭시 
				} else {
		%>
					<a href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=1&word=<%=word%>" class="btn btn-outline-dark btn-sm"><%="<"%></a>
		<%
			}
		%>
			<span><%=currentPage%>/<%=lastPage%></span>
		<%
				if(currentPage < lastPage) {
		%>
					<a href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=<%=currentPage+1%>&word=<%=word%>" class="btn btn-outline-dark btn-sm"><%=">"%></a>
		<%	// 마지막페이지 일때 다음버튼 클릭시
				} else {
		%>
					<a href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=<%=lastPage%>&word=<%=word%>" class="btn btn-outline-dark btn-sm"><%=">"%></a>
		<%
			}
		%>
				<a href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=<%=lastPage%>&word=<%=word%>">마지막</a>
		<%
			}
		%>
	</div>

</body>
</html>