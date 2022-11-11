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
	String sql = "select board_title boardTitle, board_content boardContent, board_writer boardWriter, createdate from board where board_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, boardNo);
	ResultSet rs = stmt.executeQuery();
	Board board = null;
	if(rs.next()) {
		board = new Board();
		board.boardNo = boardNo;
		board.boardTitle = rs.getString("boardTitle");
		board.boardContent = rs.getString("boardContent");
		board.boardWriter = rs.getString("boardWriter");
		board.createdate = rs.getString("createdate");
	}

%>



<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<!-- 메뉴 partial jsp 구성 -->
	<div>
		<jsp:include page="/inc/menu.jsp"></jsp:include>
	</div>
	
	<h1>게시글 수정하기</h1>
	<form method="post" action="<%=request.getContextPath()%>/board/updateBoardAction.jsp">
		<table border="1">
			<tr>
				<td>번호</td>
				<td><input type="text" name="boardNo" value="<%=board.boardNo%>" readonly="readonly"></td>
			</tr>
			<tr>
				<td>제목</td>
				<td><input type="text" name="boardTitle" value="<%=board.boardTitle%>"></td>
			</tr>
			<tr>
				<td>내용</td>
				<td><textarea rows="4" cols="40" name="boardContent"><%=board.boardContent%></textarea>
				</td>
			</tr>
			<tr>
				<td>글쓴이</td>
				<td><input type="text" name="boardWriter" value="<%=board.boardWriter%>"></td>
			</tr>
			<tr>
				<td>생성날짜</td>
				<td><input type="text" name="createdate" value="<%=board.createdate%>" readonly="readonly"></td>
			</tr>
			<tr>
				<td>비밀번호입력</td>
				<td><input type="text" name="boardPw"></td>
			</tr>
		</table>
		<button type="submit">수정</button>
	</form>
</body>
</html>