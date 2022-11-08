<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
	request.setCharacterEncoding("utf-8"); // 한글 utf-8 인코딩
	String deptNo = request.getParameter("deptNo");
	
	// 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver"); // mariadb사용에 필요한 클래스 풀네임 입력
	System.out.println("드라이버 로딩 성공"); // 디버깅
	// 마리아db 접속
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1234");
	System.out.println(conn +"<--conn"); // 디버깅
	// 쿼리입력
	String sql = "select dept_name deptName from departments where dept_no =?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, deptNo);
	ResultSet rs = stmt.executeQuery();
	
	String deptName  = null;
	if(rs.next()) {
		deptName = rs.getString("deptName");
	}
	

	
	// 3. 출력
%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
	<style>
		h1 {
		  text-shadow: 0 0 5px blue;
		}
	</style>
</head>
<body>
	<div class="container pt-5" style="text-align: center">
		<h1 class="alert alert-success mx-auto" style="width:35%">수정하기</h1>
		<form method="post" action="<%=request.getContextPath()%>/dept/updateDeptAction.jsp">
			<table class="table table-bordered table-striped mx-auto" style="width:35%">
				<tr>
					<td>번호</td>
					<td><input type="text" name="deptNo" value="<%=deptNo%>" readonly="readonly"></td>
				</tr>
				<tr>
					<td>이름</td>
					<td><input type="text" name="deptName" value="<%=deptName%>"></td>
				</tr>
			</table>
			<button type="submit" style="width:10%" class="btn btn-outline-primary">수정</button>
		</form>
	</div>
</body>
</html>