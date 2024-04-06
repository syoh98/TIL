<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:th="http://www.thymeleaf.org">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Insert title here</title>
</head>
<body>
  <form name="deleteForm" action="<c:url value="/board/delete" />" method="post">
   <input type="hidden" value="${seq}" />
   비밀번호<input name="pwd"/>
   <input type="submit" />
   <a href="<c:url value="/board/read/${seq}" />">취소</a>
  </form>
  <div>${msg}</div>
</body>
</html>