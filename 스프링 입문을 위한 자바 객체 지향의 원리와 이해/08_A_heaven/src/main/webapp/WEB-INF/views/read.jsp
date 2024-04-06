<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:th="http://www.thymeleaf.org">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Insert title here</title>
</head>
<body>
	<table border="1">
		<tr>
			<th>제목</th>
			<td th:text="${boardVO.title}">제목입니다.</td>
		</tr>
		<tr>
			<th>내용</th>
			<td th:text="${boardVO.content}">내용입니다.</td>
		</tr>
		<tr>
			<th>작성자</th>
			<td th:text="${boardVO.writer}">일지매</td>
		</tr>
		<tr>
			<th>작성일</th>
			<td th:text="${boardVO.regDate}">2015-10-31 15:32</td>
		</tr>
		<tr>
			<th>조회수</th>
			<td th:text="${boardVO.cnt}">1234</td>
		</tr>
	</table>
	<div>
		<a href="<c:url value="/board/edit/${boardVO.seq}"/>">수정</a>
		<a href="<c:url value="/board/delete/${boardVO.seq}"/>">삭제</a> 
		<a href="<c:url value="/board/list"/>">목록</a>
	</div>
</body>
</html>