<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
	//msg 파라메타 값이 있으면 출력
	if(request.getParameter("msg") != null) {
		String msg = request.getParameter("msg");
		out.println("<script>alert('"+msg+"');</script>");
	}

	//한글 처리 utf-8로 인코딩
	request.setCharacterEncoding("utf-8");

	// 1. 요청분석
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	// 2. 요청처리 후 필요하다면 모델데이터를 생성
	final int ROW_PER_PAGE = 10; // 변수앞에 final -> (상수)더이상 바뀔 수 없게, 대문자로 표시
	int beginRow = (currentPage-1) * ROW_PER_PAGE; // ... Limit beginRow, ROW_PER_PAGE
	
	Class.forName("org.mariadb.jdbc.Driver");
	
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees","root","java1234");

	String cntSql = "SELECT COUNT(*) cnt FROM board";
	PreparedStatement cntStmt = conn.prepareStatement(cntSql);
	ResultSet cntRs = cntStmt.executeQuery();
	int cnt = 0; // 전체 행 수
	if(cntRs.next()) {
		cnt = cntRs.getInt("cnt");
	}
	// Math.ceil 올림 = 5.3 -> 6.0 , 5.0 -> 5.0
	int lastPage = (int)Math.ceil((double)cnt / (double)ROW_PER_PAGE);
	
	
	String listSql = "select board_no boardNo, board_title boardTitle from board order by board_no asc limit ?, ?";
	PreparedStatement listStmt = conn.prepareStatement(listSql);
	listStmt.setInt(1, beginRow);
	listStmt.setInt(2, ROW_PER_PAGE);
	ResultSet listRs = listStmt.executeQuery(); // 모델 source data
	ArrayList<Board> boardList = new ArrayList<Board>(); // 모델 new data
	while(listRs.next()) {
		Board b = new Board();
		b.boardNo = listRs.getInt("boardNo");
		b.boardTitle = listRs.getString("boardTitle");
		boardList.add(b);
	}



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
	<!-- 메뉴 partial jsp 구성  -->
	<div style="text-align: center">
		<jsp:include page="/inc/menu.jsp"></jsp:include>
	</div>
	<div class="container pt-5" style="text-align: center">
	<h1 class="alert alert-success">자유 게시판</h1>
	<!-- 3-1. 모델데이터(ArrayList<Board>) 출력 -->
	<table class="table table-bordered table-striped">
		<tr>
			<th>번호</th>
			<th>제목</th>
		</tr>
		
		<%
			for(Board b : boardList) {
		%>
				<tr>
					<td><%=b.boardNo%></td>
					<!-- 내용 클릭시 상세보기로 이동 -->
					<td><a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=b.boardNo%>"><%=b.boardTitle%></a></td>
				</tr>
		<%
			}
		%>
	</table>
	</div>
	
	<!-- 3-2. 페이징 -->
	<div style="text-align: center">
		<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=1">처음</a>
		<%
			if(currentPage > 1) {
		%>
				<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage-1%>">이전</a>
		<%
			}
		%>
		<span><%=currentPage%></span>
		<%
			if(currentPage < lastPage) {
		%>
				<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage+1%>">다음</a>
		<%
			}
		%>
		<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=lastPage%>">마지막</a>
	</div>
</body>
</html>