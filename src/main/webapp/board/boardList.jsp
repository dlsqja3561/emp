<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
	//한글 처리 utf-8로 인코딩
	request.setCharacterEncoding("utf-8");

	// 1. 요청분석
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	// 검색 입력값 받기
	String word = request.getParameter("word");
	
	// 2. 요청처리 후 필요하다면 모델데이터를 생성
	final int ROW_PER_PAGE = 10; // 변수앞에 final -> (상수)더이상 바뀔 수 없게, 대문자로 표시
	int beginRow = (currentPage-1) * ROW_PER_PAGE; // ... Limit beginRow, ROW_PER_PAGE
	// 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	// 마리아db 접속
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees","root","java1234");
	
	// 2-1
	String cntSql = null;
	PreparedStatement cntStmt = null;
	// 검색 X 전체 행 구하기
	if(word == null) {
		cntSql = "SELECT COUNT(*) cnt FROM board";
		cntStmt = conn.prepareStatement(cntSql);
	// 검색 했을때 쿼리
	} else {
		cntSql = "SELECT COUNT(*) cnt FROM board WHERE board_title LIKE ? ORDER BY board_no ASC";
		cntStmt = conn.prepareStatement(cntSql);
		cntStmt.setString(1, "%"+word+"%");
	}
	
	ResultSet cntRs = cntStmt.executeQuery();
	int cnt = 0; // 전체 행 수
	if(cntRs.next()) {
		cnt = cntRs.getInt("cnt");
	}
	// Math.ceil 올림 = 5.3 -> 6.0 , 5.0 -> 5.0
	int lastPage = (int)Math.ceil((double)cnt / (double)ROW_PER_PAGE);

	// 2-2
	
	String listSql = null;
	PreparedStatement listStmt = null;
	// 검색 X 
	if(word == null) {
		listSql = "select board_no boardNo, board_title boardTitle from board order by board_no asc limit ?, ?";
		listStmt = conn.prepareStatement(listSql);
		listStmt.setInt(1, beginRow);
		listStmt.setInt(2, ROW_PER_PAGE);
		// 검색 했을때 쿼리
	} else {
		listSql = "select board_no boardNo, board_title boardTitle from board WHERE board_title LIKE ? order by board_no asc limit ?, ?";
		listStmt = conn.prepareStatement(listSql);
		listStmt.setString(1, "%"+word+"%");
		listStmt.setInt(2, beginRow);
		listStmt.setInt(3, ROW_PER_PAGE);
	}
	
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
	<title>boardList</title>
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
	<h1 class="alert alert-success">자유 게시판</h1>
	<div class="alert alert-primary" style="width:200px">
		<a href="<%=request.getContextPath()%>/dept/insertCommentAction.jsp">글쓰기</a>
	</div>
	<!-- 3-1. 모델데이터(ArrayList<Board>) 출력 -->
	<table class="table table-bordered table-striped">
		<tr>
			<th style="width:200px">번호</th>
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
	<!-- 검색창 -->
	<form method="post" action="<%=request.getContextPath()%>/board/boardList.jsp">
		<label>제목 검색 : </label>	
	 		<input type="text" name="word" id="word" value="">
	 		<button type="submit">검색</button>
	</form>

	<!-- 3-2. 페이징 -->
	<div style="text-align: center">
	<!-- word null일때 페이징 -->
	<%
		if(word == null) {
	%>
			<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=1">처음</a>
		<%
			if(currentPage > 1) {
		%>
				<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage-1%>" class="btn btn-outline-dark btn-sm"><%="<"%></a>
		<%
			}
		%>
		<span><%=currentPage%>/<%=lastPage%></span>
		<%
			if(currentPage < lastPage) {
		%>
				<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage+1%>" class="btn btn-outline-dark btn-sm"><%=">"%></a>
		<%
			}
		%>
		<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=lastPage%>">마지막</a>
		<%
		} else {
		%>
		<!-- word 값이 있을때 페이징 -->
		<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=1&word=<%=word%>">처음</a>
		<%
			if(currentPage > 1) {
		%>
				<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage-1%>&word=<%=word%>" class="btn btn-outline-dark btn-sm"><%="<"%></a>
		<%
			}
		%>
		<span><%=currentPage%>/<%=lastPage%></span>
		<%
			if(currentPage < lastPage) {
		%>
				<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage+1%>&word=<%=word%>" class="btn btn-outline-dark btn-sm"><%=">"%></a>
		<%
			}
		%>
		<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=lastPage%>&word=<%=word%>">마지막</a>
		<%
		}
		%>
	</div>
</body>
</html>