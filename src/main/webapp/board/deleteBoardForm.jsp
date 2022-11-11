<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="vo.*" %>
<%
	request.setCharacterEncoding("utf-8"); // 한글처리 utf-8 인코딩
	// 비밀번호가 다를시 msg 출력
	if(request.getParameter("msg") != null) {
		String msg = request.getParameter("msg");
		out.println("<script>alert('"+msg+"');</script>");
	}
	
	// 1. 요청분석
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));

	// 2. 요청처리
	
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("드라이버 로딩 성공"); // 디버깅
	// mariadb 접속
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees","root","java1234");
	System.out.println(conn +"<--conn"); // 디버깅
	// 쿼리 입력
	String sql = "select board_title boardTitle from board where board_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, boardNo);
	ResultSet rs = stmt.executeQuery();
	Board board = null;
	if(rs.next()) {
		board = new Board();
		board.boardNo = boardNo;
		board.boardTitle = rs.getString("boardTitle");
	}
%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>deleteBoardForm</title>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<!-- 메뉴 partial jsp 구성 -->
	<div>
		<jsp:include page="/inc/menu.jsp"></jsp:include>
	</div>
	<div class="container pt-5" style="text-align: center">
		<h1 class="alert alert-success mx-auto" style="width:35%">삭제하기</h1>
		<form method="post" action="<%=request.getContextPath()%>/board/deleteBoardAction.jsp">
			<table class="table table-bordered table-striped mx-auto" style="width:35%">
				<tr>
					<td><input type="text" name="boardNo" value="<%=board.boardNo%>" style="width:20px" readonly="readonly">.<%=board.boardTitle%> 을(를) 삭제 하시겠습니까?</td>
				</tr>
				<tr>
					<td><input type="password" name="boardPw" placeholder="비밀번호를 입력 하세요." style="width:300px"></td>
				</tr>
			</table>
			<button type="submit" style="width:10%" class="btn btn-outline-primary">삭제</button>
		</form>
	</div>
</body>
</html>