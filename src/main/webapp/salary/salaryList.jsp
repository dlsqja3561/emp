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
	
	// 
	int rowPerPage = 10; 
	int beginRow = (currentPage - 1) * rowPerPage;
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees","root","java1234");

	
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
	System.out.println(lastPage + "lastPage");
	System.out.println(word + "word");
			
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
	System.out.println(lastPage + "lastPage");
	System.out.println(word + "word");
	
	
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
	System.out.println(lastPage + "lastPage");
	System.out.println(word + "word");
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
	<div>
		<table border="1">
			<tr>
				<th>empNo</th>
				<th>salary</th>
				<th>fromDate</th>
				<th>toDate</th>
				<th>firstName</th>
				<th>lastName</th>
			</tr>
			<%
				for(Salary s : salaryList) {
			%>
					<tr>
						<td><%=s.emp.empNo%></td>
						<td><%=s.salary%></td>
						<td><%=s.fromDate%></td>
						<td><%=s.toDate%></td>
						<td><%=s.emp.firstName%></td>
						<td><%=s.emp.lastName%></td>
					</tr>
			<%      
				}
			%>
		</table>
	</div>
	
	<div>
		<!-- 검색창 -->
		<form method="post" action="<%=request.getContextPath()%>/salary/salaryList.jsp">
			<label>번호 or 이름 검색 : </label>	
		 		<input type="text" name="word" id="word">
		 		<button type="submit">검색</button>
		</form>
	</div>
	<!-- 페이징 코드 -->
	<div style="text-align: center">
		<%
		// word 값 X 페이징-----------------------------------------------
			if(word == null) {
		%>
				<a href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=1">처음</a>
		<%
				if(currentPage > 1) {
		%>
				<a href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=<%=currentPage-1%>" class="btn btn-outline-dark btn-sm"><%="<"%></a>
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
					<a href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=<%=currentPage+1%>" class="btn btn-outline-dark btn-sm"><%=">"%></a>
		<%
				} else {
		%>
					<a href="" class="btn btn-outline-dark btn-sm"><%=">"%></a>
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
		<%
				} else {
		%>
					<a href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=<%=currentPage%>&word=<%=word%>" class="btn btn-outline-dark btn-sm"><%="<"%></a>
		<%
			}
		%>
			<span><%=currentPage%>/<%=lastPage%></span>
		<%
				if(currentPage < lastPage) {
		%>
					<a href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=<%=currentPage+1%>&word=<%=word%>" class="btn btn-outline-dark btn-sm"><%=">"%></a>
		<%
				} else {
		%>
					<a href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=<%=currentPage%>&word=<%=word%>" class="btn btn-outline-dark btn-sm"><%=">"%></a>
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