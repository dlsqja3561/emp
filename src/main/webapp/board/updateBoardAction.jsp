<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="vo.Board" %>
<%@ page import="java.net.URLEncoder" %>
<%
	//안전장치 : Actoin 을 실행하면 deptList 으로 가도록
	if(request.getParameter("boardNo") == null) {
		response.sendRedirect(request.getContextPath()+"/board/boardList.jsp");
		return;
	}

	request.setCharacterEncoding("utf-8"); // 한글 utf-8 인코딩
	
	// form 에서 값 받기
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String boardContent = request.getParameter("boardContent");
	String boardTitle = request.getParameter("boardTitle");
	String boardWriter = request.getParameter("boardWriter");
	String boardPw = request.getParameter("boardPw");

	System.out.println(boardNo +"<--boardNo"); // 디버깅
	System.out.println(boardContent +"<--boardContent");
	System.out.println(boardTitle +"<--boardTitle");
	System.out.println(boardWriter +"<--boardWriter");
	System.out.println(boardPw +"<--boardPw");
	
	Board bo = new Board();
	bo.boardNo = boardNo;
	bo.boardContent = boardContent;
	bo.boardTitle = boardTitle;
	bo.boardWriter = boardWriter;
	bo.boardPw = boardPw;
	
		
	// 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("드라이버 로딩 성공"); // 디버깅
	// mariadb 접속
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees","root","java1234");
	System.out.println(conn +"<--conn"); // 디버깅
	// 쿼리 만들기

	String sql = "update board set board_content=?,board_title=?,board_writer=? where board_no=? and board_pw=?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, bo.boardContent);
	stmt.setString(2, bo.boardTitle);
	stmt.setString(3, bo.boardWriter);
	stmt.setInt(4, bo.boardNo);
	stmt.setString(5, bo.boardPw);

	int row = stmt.executeUpdate();
	if(row == 1) {
		System.out.println("수정성공");
	} else {
		System.out.println("수정실패");
		String msg = URLEncoder.encode("수정실패 비밀번호가 틀렸습니다.","utf-8"); // get방식 주소창에 문자열 인코딩
		response.sendRedirect(request.getContextPath()+"/board/boardList.jsp?msg="+msg);
		return;
	}


	response.sendRedirect(request.getContextPath()+"/board/boardList.jsp");
	
	
%>