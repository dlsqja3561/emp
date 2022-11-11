<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	int commentNo = Integer.parseInt(request.getParameter("commentNo"));

	//	msg 값이 넘어오면 msg 출력 (댓글 삭제 비밀번호 다를시 출력)
	if(request.getParameter("msg") != null) { 
		String msg = request.getParameter("msg");
		out.println("<script>alert('"+msg+"');</script>");
	}
	

%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>deleteCommentForm</title>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<form method="post" action="<%=request.getContextPath()%>/board/deleteCommentAction.jsp">
		<div class="container pt-5" style="text-align: center">
			<h2 class="alert alert-success mx-auto" style="width:35%">댓글삭제</h2>
			<table class="table table-bordered mx-auto" style="width:35%">
				<tr>
					<th>비밀번호를 입력해 주세요.</th>
				</tr>
				<tr>
					<td><input type="password" name="commentPw"></td>
				</tr>
			</table>
			<button type="submit" class="btn btn-outline-primary" style="width:10%">삭제</button>
		</div>
		<input type="hidden" name="boardNo" value="<%=boardNo%>">
		<input type="hidden" name="commentNo" value="<%=commentNo%>">
	</form>
</body>
</html>