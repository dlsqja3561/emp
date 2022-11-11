<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
	//	한글처리 utf-8로 인코딩
	request.setCharacterEncoding("utf-8");
	//	msg 값이 넘어오면 msg 출력
	if(request.getParameter("msg") != null) { 
		String msg = request.getParameter("msg");
		out.println("<script>alert('"+msg+"');</script>");
	}


	// 1. 요청분석
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	// 댓글 페이징에 사용할 현재 페이지
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}

	// 2. 요청처리
	// 2-1 게시글
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("드라이버 로딩 성공"); // 디버깅
	// mariadb 접속
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees","root","java1234");
	System.out.println(conn +"<--conn"); // 디버깅
	// 쿼리 입력
	String boardSql = "select board_title boardTitle, board_content boardContent, board_writer boardWriter, createdate from board where board_no = ?";
	PreparedStatement boardStmt = conn.prepareStatement(boardSql);
	boardStmt.setInt(1, boardNo);
	ResultSet boardRs = boardStmt.executeQuery();
	Board board = null;
	if(boardRs.next()) {
		board = new Board();
		board.boardNo = boardNo;
		board.boardTitle = boardRs.getString("boardTitle");
		board.boardContent = boardRs.getString("boardContent");
		board.boardWriter = boardRs.getString("boardWriter");
		board.createdate = boardRs.getString("createdate");
	}

	// 2-2 댓글 목록
	// 댓글 페이징 추가 
	int rowPerPage = 5;  // 1페이지당 5행
	int beginRow = (currentPage - 1) * rowPerPage;
	
	
	String commentSql = "SELECT comment_no commentNo, comment_content commentContent FROM comment WHERE board_no = ? ORDER BY comment_no DESC LIMIT ?, ?";
	PreparedStatement commentStmt = conn.prepareStatement(commentSql);
	commentStmt.setInt(1, boardNo);
	commentStmt.setInt(2, beginRow);
	commentStmt.setInt(3, rowPerPage);
	ResultSet commentRs = commentStmt.executeQuery();
	ArrayList<Comment> commentList = new ArrayList<Comment>();
	while(commentRs.next()) {
		Comment c = new Comment();
		c.commentNo = commentRs.getInt("commentNo");
		c.commentContent = commentRs.getString("commentContent");
		commentList.add(c);
	}
	
	// 2-3 댓글 전체행 구한 후 -> 마지막페이지 구하기
	String countSql = "SELECT COUNT(*) FROM comment"; // 전체 행 개수 구하기 쿼리
	PreparedStatement countStmt = conn.prepareStatement(countSql);
	ResultSet countRs = countStmt.executeQuery();
	int count = 0;
	if(countRs.next()) {
		count = countRs.getInt("COUNT(*)"); // 전체 행 개수
	}
	
	int lastPage = count / rowPerPage;
	if(count % rowPerPage != 0) {
		lastPage = lastPage + 1;
	}
	
	
%>


<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>boardOne</title>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
	<style>
		th {
			width : 100px;
		}
	</style>
</head>
<body>
	<!-- 메뉴 partial jsp 구성 -->
	<div>
		<jsp:include page="/inc/menu.jsp"></jsp:include>
	</div>
	<div class="container pt-5" style="text-align: center">
		<h1 class="alert alert-success">게시글 상세보기</h1>
		<table class="table table-bordered">
			<tr>
				<th class="table-dark">번호</th>
				<td><%=board.boardNo%></td>
			</tr>
			<tr>
				<th class="table-dark">제목</th>
				<td><%=board.boardTitle%></td>
			</tr>
			<tr>
				<th class="table-dark">내용</th>
				<td><%=board.boardContent%></td>
			</tr>
			<tr>
				<th class="table-dark">글쓴이</th>
				<td><%=board.boardWriter%></td>
			</tr>
			<tr>
				<th class="table-dark">생성날짜</th>
				<td><%=board.createdate%></td>
			</tr>
		</table>
	</div>
		<a href="<%=request.getContextPath()%>/board/updateBoardForm.jsp?boardNo=<%=boardNo%>">수정</a>
		<a href="<%=request.getContextPath()%>/board/deleteBoardForm.jsp?boardNo=<%=boardNo%>">삭제</a>


	<div>
		<!-- 댓글입력 폼 -->
		<h2>댓글입력</h2>
		<form action="<%=request.getContextPath()%>/board/insertCommentAction.jsp" method="post">
			<input type="hidden" name="boardNo" value="<%=board.boardNo%>">
			<table border="1">
				<tr>
					<td>내용</td>
					<td><textarea rows="3" cols="80" name="commentContent"></textarea></td>
				</tr>
				<tr>
					<td>비밀번호</td>
					<td><input type="password" name="commentPw"></td>
				</tr>
			</table>
			<button type="submit">댓글입력</button>
		</form>
	</div>
	<div>
		<!-- 댓글목록 -->
		<h2>댓글목록</h2>
		<%
		for(Comment c : commentList) {
		%>
			<div>
				<div><%=c.commentNo%></div>
				<div><%=c.commentContent%></div>
				<a href="<%=request.getContextPath()%>/board/deleteCommentForm.jsp?commentNo=<%=c.commentNo%>&boardNo=<%=boardNo%>">삭제</a>
			</div>
		<%		
		}
		%>
		<!-- 댓글 페이징 -->
		<%
			if(currentPage > 1) {
		%>
				<a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=boardNo%>&currentPage=<%=currentPage-1%>">이전</a>
		<%
			}
		%>
			<span><%=currentPage%>/<%=lastPage%></span>
		<%
			if(currentPage < lastPage) {
		%>
				<a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=boardNo%>&currentPage=<%=currentPage+1%>">다음</a>
		<%
			}
		%>
	</div>


</body>
</html>