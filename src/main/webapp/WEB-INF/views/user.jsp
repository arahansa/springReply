<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<title> Happy WOrld </title>
</head>
<body>
<c:if test="${sessionScope.userSession ne null }">
유저 로그인 중.. <br> ${sessionScope.userSession.name}님 안녕하세요<br>
  <a href="/user/logout">로그아웃으로 이동</a>
</c:if>

<c:if test="${sessionScope.userSession eq null }">
유저 로그 아웃 중
  <a href="/loginPage">로그인으로 이동</a><br>
  <a href="/user/registerForm">회원 가입 이동</a>
</c:if>

<div id="fb-root"></div>
<script src="//connect.facebook.net/en_US/all.js"></script>
<script>
  FB.init({
    appId  : '539303639551098',
    status : true, // check login status
    cookie : true, // enable cookies to allow the server to access the session
    xfbml  : true, // parse XFBML
    channelUrl : 'http://WWW.MYDOMAIN.COM/channel.html', // channel.html file
    oauth  : true // enable OAuth 2.0
  });
</script>

</body>
</html>