<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:th="http://www.thymeleaf.org">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Insert title here</title>
</head>
<body>
	<form:form commandName="boardVO" method="POST">
		<table border="1">
			<tr>
				<th><label for="title">제목</label></th>
				<td><input name="title" /></td>
			</tr>
			<tr>
				<th><label for="content">내용</label></th>
				<td><input name="content" /></td>
			</tr>
			<tr>
				<th><label for="writer">작성자</label></th>
				<td><input name="writer" /></td>
			</tr>
			<tr>
				<th><label for="password">비밀번호</label></th>
				<td><input name="password" /></td>
			</tr>
		</table>
		<div>
			<input type="submit" value="등록" />
			<a href="<c:url value="/board/list" />">목록</a>
		</div>
	</form>
</body>
</html>