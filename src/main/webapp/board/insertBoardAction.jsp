<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.URLEncoder" %>
<%
	request.setCharacterEncoding("utf-8");
	// 1.요청분석
	String boardPw = request.getParameter("boardPw");
	String boardTitle = request.getParameter("boardTitle");
	String boardContent = request.getParameter("boardContent");
	String boardWriter = request.getParameter("boardWriter");

	System.out.println(boardPw +"<--boardPw"); // 디버깅
	System.out.println(boardTitle +"<--boardTitle");
	System.out.println(boardContent +"<--boardContent");
	System.out.println(boardWriter +"<--boardWriter");

	//  값이 없으면 insertDeptForm.jsp 으로 이동 msg 출력
	if(boardPw == null || boardPw.equals("") 
		|| boardTitle == null || boardTitle.equals("") 
		|| boardContent == null || boardContent.equals("") 
		|| boardWriter == null || boardWriter.equals("") ) {
		String msg = URLEncoder.encode("내용을 입력해주세요.","utf-8"); // get방식 주소창에 문자열 인코딩
		response.sendRedirect(request.getContextPath()+"/board/insertBoardForm.jsp?msg="+msg);
		return;
	}
	
	// 2. 요청처리
	// 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("드라이버 로딩 성공"); // 디버깅
	// mariadb 접속
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees","root","java1234");
	System.out.println(conn +"<--conn"); // 디버깅
	
	String sql = "insert into board(board_pw, board_title, board_content, board_writer, createdate) values(?, ?, ?, ?, CURDATE())";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, boardPw);
	stmt.setString(2, boardTitle);
	stmt.setString(3, boardContent);
	stmt.setString(4, boardWriter);

	int row = stmt.executeUpdate();
	if(row == 1) {
		System.out.println("입력성공");
	} else {
		System.out.println("입력실패");
	}
	
	response.sendRedirect(request.getContextPath()+"/board/boardList.jsp"); 
%>
