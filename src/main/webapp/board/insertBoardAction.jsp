<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.URLEncoder" %>
<%
	request.setCharacterEncoding("utf-8");
	// 1.요청분석
	String boardTitle = request.getParameter("boardTitle");
	System.out.println(boardTitle +"<--boardTitleboardTitle"); // 디버깅

	//  값이 없으면 insertDeptForm.jsp 으로 이동 msg 출력
	if(boardTitle == null || boardTitle.equals("")) {
		String msg = URLEncoder.encode("내용을 입력하세요.","utf-8"); // get방식 주소창에 문자열 인코딩
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
	
	String sql = "insert into board(board_no, board_title) values(?)";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, boardTitle);

	int row = stmt.executeUpdate();
	if(row == 1) {
		System.out.println("입력성공");
	} else {
		System.out.println("입력실패");
	}
	
	response.sendRedirect(request.getContextPath()+"/board/boardList.jsp"); 
%>
