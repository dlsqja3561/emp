<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<!-- 메뉴 partial jsp 구성 -->
	<div>
		<jsp:include page="/inc/menu.jsp"></jsp:include>
	</div>
	<div class="container pt-5" style="text-align: center">
		<h1 class="alert alert-success mx-auto" style="width:40%">입력하기</h1>
		<!-- msg 파라메타 값이 있으면 출력 -->
		<%
			if(request.getParameter("msg") != null) {
		%>
				<div><%=request.getParameter("msg")%></div>
		<%
			}
		%>
		<form method="post" action="<%=request.getContextPath()%>/board/insertBoardAction.jsp">
			<table class="table table-bordered table-striped mx-auto" style="width:40%">
				
				<tr>
					<td>내용</td>
					<td><textarea rows="4" cols="40" name="boardTitle"></textarea></td>
				</tr>
			</table>
			<button type="submit" style="width:10%" class="btn btn-outline-primary">입력</button>
		</form>
	</div>
</body>
</html>