<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="vo.*" %>
<%@ page import="java.util.*" %>
<%	
	//한글처리 utf-8로 인코딩
	request.setCharacterEncoding("utf-8");

	// 1
	// 검색 입력값 받기
	String word = request.getParameter("word");
	// 페이지 알고리즘
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	// 2
	int rowPerPage = 10; 
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees","root","java1234");

	
	// lastPage 처리
	String countSql = null;
	PreparedStatement countStmt = null;
	if(word == null) {
		countSql = "SELECT COUNT(*) FROM employees"; // 전체 행 개수 구하기 쿼리
		countStmt = conn.prepareStatement(countSql);
	} else {
		countSql = "SELECT COUNT(*) FROM employees WHERE first_name LIKE ? OR last_name LIKE ?";
		countStmt = conn.prepareStatement(countSql);
		countStmt.setString(1, "%"+word+"%");
		countStmt.setString(2, "%"+word+"%");
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

	String empSql = null;
	PreparedStatement empStmt = null;
	if(word == null) {
		// 한페이지당 출력할 emp목록
		empSql = "SELECT emp_no empNo, first_name firstName, last_name lastName FROM employees ORDER BY emp_no ASC LIMIT ?, ?";
		empStmt = conn.prepareStatement(empSql);
		empStmt.setInt(1, rowPerPage * (currentPage - 1));
		empStmt.setInt(2, rowPerPage);
	} else {
		empSql = "SELECT emp_no empNo, first_name firstName, last_name lastName FROM employees WHERE first_name LIKE ? OR last_name LIKE ? ORDER BY emp_no ASC LIMIT ?, ?";
		empStmt = conn.prepareStatement(empSql);
		empStmt.setString(1, "%"+word+"%");
		empStmt.setString(2, "%"+word+"%");
		empStmt.setInt(3, rowPerPage * (currentPage - 1));
		empStmt.setInt(4, rowPerPage);
	}
	
	ResultSet empRs = empStmt.executeQuery();
	ArrayList<Employee> empList = new ArrayList<Employee>();
	while(empRs.next()) { //행이 있다면~
		Employee e = new Employee();
		e.empNo = empRs.getInt("empNo");
		e.firstName = empRs.getString("firstName");
		e.lastName = empRs.getString("lastName");
		empList.add(e);
	}
		
%>


<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>empList</title>
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
		<h1 class="alert alert-success">사원목록</h1>
		<table class="table table-bordered table-striped">
			<tr class="table-dark">
				<th>사원번호</th>
				<th>퍼스트네임</th>
				<th>라스트네임</th>
			</tr>
		<%
			for(Employee e : empList) {
		%>
				<tr>
					<td><%=e.empNo%></td>
					<td><a href=""><%=e.firstName%></a></td>
					<td><%=e.lastName%></td>
				</tr>
		<%
			}
		%>
		</table>
	</div>

	<!-- 검색창 -->
	<form method="post" action="<%=request.getContextPath()%>/emp/empList.jsp">
		<label>이름 검색 : </label>	
	 		<input type="text" name="word" id="word">
	 		<button type="submit">검색</button>
	</form>
	
	<!-- 페이징 코드 -->
	<div style="text-align: center">
		<%
			// word 값 X 페이징
			if(word == null) {
		%>
				<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=1">처음</a>
		<%
			if(currentPage > 1) {
		%>
				<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage-1%>" class="btn btn-outline-dark btn-sm"><%="<"%></a>
		<%
			} else {
		%>
				<a href="" class="btn btn-outline-dark btn-sm"><%="<"%></a>
		<%
			}
		%>
			<span><%=currentPage%>/<%=lastPage%></span>
		<%
			if(currentPage < lastPage) {
		%>
				<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage+1%>" class="btn btn-outline-dark btn-sm"><%=">"%></a>
		<%
			}
		%>
				<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=lastPage%>">마지막</a>
		<%
			// 검색 후 페이징
			} else {
		%>
				<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=1&word=<%=word%>">처음</a>
		<%
			if(currentPage > 1) {
		%>
				<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage-1%>&word=<%=word%>" class="btn btn-outline-dark btn-sm"><%="<"%></a>
		<%
				}
		%>
		<span><%=currentPage%>/<%=lastPage%></span>
		<%
			if(currentPage < lastPage) {
		%>
				<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage+1%>&word=<%=word%>" class="btn btn-outline-dark btn-sm"><%=">"%></a>
		<%
				}
		%>
				<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=lastPage%>&word=<%=word%>">마지막</a>
		<%
			}
		%>
	</div>
</body>
</html>