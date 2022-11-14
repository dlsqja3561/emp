<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%@ page import="java.net.URLEncoder" %>
<%
	// 한글처리 utf-8로 인코딩
	request.setCharacterEncoding("utf-8");
	//1. 요청분석(Controller)	

	// msg 파라메타 값이 있으면 출력
	if(request.getParameter("msg") != null) {
		String msg = request.getParameter("msg");
		out.println("<script>alert('"+msg+"');</script>");
	}

	String word = request.getParameter("word");
	// 1) word -> null , 2) word -> '' or word -> '단어'  2가지 형태로 쿼리가 분기


	// 2. 업무처리(Model) -> 모델데이터(단일값 or 자료구조형태(배열, 리스트, ...))
	// 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver"); // mariadb사용에 필요한 클래스 풀네임 입력
	System.out.println("드라이버 로딩 성공");

	// 연결
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1234");
	System.out.println(conn +"<--conn");

	// 접속한 데이터베이스에 쿼리 만들기
	String sql = null;
	PreparedStatement stmt = null;
	if(word == null) {
		sql = "SELECT dept_no deptNo, dept_name deptName FROM departments ORDER BY dept_no ASC";
		stmt = conn.prepareStatement(sql);
	} else {
      /*
      SELECT *
      FROM departments
      WHERE dept_name LIKE ?
      ORDER BY dept_no ASC
   */
	sql = "SELECT dept_no deptNo, dept_name deptName FROM departments WHERE dept_name LIKE ? ORDER BY dept_no ASC";
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, "%"+word+"%");
	}
	
	
	
	
	/*	PreparedStatement stmt = conn.prepareStatement("select dept_no deptNo, dept_name deptName from departments order by dept_no desc");
	String sql = "select dept_no deptNo, dept_name deptName from departments order by dept_no asc";
	PreparedStatement stmt = conn.prepareStatement(sql);
*/
	
	// 쿼리 실행 메서드 (select 쿼리 결과물)
	ResultSet rs = stmt.executeQuery(); // <- 모델데이터로 ResultSet은 일반적인 타입이 아니고 독립적인 타입도 아니다
										// ResultSet rs라는 모델자료구조를 좀더 일반적이고 독립적인 자료구조 변경을 하자

	ArrayList<Department> list = new ArrayList<Department>(); // ResultSet 항상 ArrayList 로 변경
	while(rs.next()) { // ResultSet의 API(사용방법)를 모른다면 사용할 수 없는 반복문
		Department d = new Department();
		d.deptNo = rs.getString("deptNo");
		d.deptName = rs.getString("deptName");
		list.add(d); // d 를 list에 추가시킨다
	}
										
										
	// 3. 출력(View) -> 모델데이터를 고객이 원하는 형태로 출력 -> 뷰(리포트)
/*	for(Department d : list) { // 자바문법에서 제공하는 foreach문
		
	}
*/
%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>deptList</title>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
	<style>
		h1 {
		  text-shadow: 1px 1px 2px black, 0 0 25px blue, 0 0 5px darkblue;
		}
		a:link, a:visited {
		  background-color: white;
		  color: black;
		  border: 2px solid green;
		  padding: 5px 20px;
		  text-align: center;
		  text-decoration: none;
		  display: inline-block;
		}
		
		a:hover, a:active {
		  background-color: green;
		  color: white;
		}
	</style>
</head>
<body>
	<!-- 메뉴 partial jsp 구성 -->
	<div class="pt-2" style="text-align: center">
		<jsp:include page="/inc/menu.jsp"></jsp:include>
	</div>

	<div class="container pt-4" style="text-align: center">
		<h1 class="alert alert-success">부서관리</h1>
		<div class="alert alert-primary" style="width:200px">
			<a href="<%=request.getContextPath()%>/dept/insertDeptForm.jsp">부서등록</a>
	</div>
		<!-- 부서명 검색창 -->
	<form method="post" action="<%=request.getContextPath()%>/dept/deptList2.jsp">
		<label>부서이름 검색 : </label>	
		<input type="text" name="word" id="word">
		<button type="submit">검색</button>
	</form>
	<div class="pt-2">
		<!-- 부서목록출력(부서번호 내림차순으로) -->
		<table class="table table-bordered table-striped">
			<tr class="table-dark">
				<th>부서번호</th>
				<th>부서이름</th>
				<th>수정</th>
				<th>삭제</th>
			</tr>
				<%
					for(Department d : list) {
				%>
					<tr>
						<td><%=d.deptNo%></td>
						<td><%=d.deptName%></td>
						<td><a href="<%=request.getContextPath()%>/dept/updateDeptForm.jsp?deptNo=<%=d.deptNo%>">수정</a></td>
						<td><a href="<%=request.getContextPath()%>/dept/deleteDept.jsp?deptNo=<%=d.deptNo%>">삭제</a></td>
					</tr>
				<%
					}
				%>
		</table>
	</div>
	</div>
</body>
</html>