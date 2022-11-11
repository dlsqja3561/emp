<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%@ page import="java.net.URLEncoder" %>
<%
	request.setCharacterEncoding("utf-8"); // 한글 utf-8 인코딩

	
	
	String deptNo = request.getParameter("deptNo");
	//deptList의 링크로 호출하지 않고 updateDeptForm.jsp 주소창에 직접 호출하면 deptNo는 null값이된다.
   if(deptNo == null) { 
	  String msg = request.getParameter("msg");
      response.sendRedirect(request.getContextPath()+"/dept/deptList.jsp?msg="+URLEncoder.encode(msg,"UTF-8"));
      return;
   }



	

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
	
	Department dept = null;
	if(rs.next()) { // ResultSet의 API(사용방법)를 모른다면 사용할 수 없는 반복문
		dept = new Department();
		dept.deptNo = deptNo;
		dept.deptName = rs.getString("deptName");
	}
	System.out.println(dept.deptName+"dept.deptName");

	
	// 3. 출력
%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>updateDeptForm</title>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
	<style>
		h1 {
		  text-shadow: 0 0 5px blue;
		}
	</style>
</head>
<body>
	<!-- 메뉴 partial jsp 구성 -->
	<div>
		<jsp:include page="/inc/menu.jsp"></jsp:include>
	</div>
	<div class="container pt-5" style="text-align: center">
		<h1 class="alert alert-success mx-auto" style="width:35%">수정하기</h1>
		<form method="post" action="<%=request.getContextPath()%>/dept/updateDeptAction.jsp">
			<table class="table table-bordered table-striped mx-auto" style="width:35%">
				<tr>
					<td>부서번호</td>
					<td><input type="text" name="deptNo" value="<%=dept.deptNo%>" readonly="readonly"></td>
				</tr>
				<tr>
					<td>부서이름</td>
					<td><input type="text" name="deptName" value="<%=dept.deptName%>"></td>
				</tr>
			</table>
			<button type="submit" style="width:10%" class="btn btn-outline-primary">수정</button>
		</form>
	</div>
</body>
</html>