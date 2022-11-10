<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="vo.*" %>
<%
	request.setCharacterEncoding("utf-8"); // 한글처리 utf-8 인코딩

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
<title>Insert title here</title>
</head>
<body>
	<h1></h1>
	<form method="post" action="<%=request.getContextPath()%>/board/deleteBoardAction.jsp">
		<table>
			<tr>
				<td><input type="text" name="boardNo" value="<%=board.boardNo%>" style="width:20px" readonly="readonly">.<%=board.boardTitle%> 을(를) 삭제 하시겠습니까?</td>
			</tr>
			<tr>
				<td><input type="password" name="boardPw" placeholder="비밀번호입력"></td>
			</tr>
		</table>
		<button type="submit">삭제</button>
	</form>
</body>
</html>