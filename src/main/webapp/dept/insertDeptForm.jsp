<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
	<style>
		h1 {
		  text-shadow: 0 0 5px blue;
		}
	</style>
</head>
<body>
	<div class="container pt-5" style="text-align: center">
		<h1 class="alert alert-success mx-auto" style="width:35%">입력하기</h1>
		<form method="post" action="<%=request.getContextPath()%>/dept/insertDeptAction.jsp">
			<table class="table table-bordered table-striped mx-auto" style="width:35%">
				<tr>
					<td>번호</td>
					<td><input type="text" name="deptNo"></td>
				</tr>
				<tr>
					<td>이름</td>
					<td><input type="text" name="deptName"></td>
				</tr>
			</table>
			<button type="submit" style="width:10%" class="btn btn-outline-primary">입력</button>
		</form>
	</div>
</body>
</html>