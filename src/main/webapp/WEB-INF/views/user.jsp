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
<script src="/js/lib/jquery-1.11.3.min.js"></script>
<script src="http://connect.facebook.net/en_US/all.js"></script>
<fb:login-button autologoutlink="true" onlogin="OnRequestPermission();" scope="publish_actions">
</fb:login-button>
<script>
FB.init({
    appId  : '539303639551098',
    status : true, // check login status
    cookie : true, // enable cookies to allow the server to access the session
    xfbml  : true, // parse XFBML
    oauth  : true // enable OAuth 2.0
  });
</script>
<button onclick="loginCheck()">로그인체크</button>
<script>
function loginCheck(){
	FB.getLoginStatus(function(response) {
		 if (response.session) {
		   console.log("로그인중");
		 } else {
			 console.log("로그아웃 중");
		 }
		});
}
</script>
<button onclick="login()">로그인</button>
<script>

function login(){
	FB.login(function(response) {
		 if (response.session) {
		   console.log(response.session);
		 } else {
			 console.log(response.session);
		 }
		}, {scope: 'publish_actions'});
}
</script>
<br>
<button name="my_full_name" onclick="ShowMyName()" value="My Name" >my name</button>
<script language="javascript" type="text/javascript">
function ShowMyName() {
        FB.api("/me",
                function (response) {
        			console.log( response );
                    alert('Name is ' + response.name);
                });
         
    }
</script>

<button onclick="postFacebook()">글쓰기</button>
<script>
function postFacebook(){
	var message_str= '페이스북 글쓰기 연습';
	FB.api('/me/feed', 'post', { message: message_str}, function(response) {
	  if (!response || response.error) {
		  console.log(response);
	    alert('발행 못함');
	  } else {
	    alert("메시지 성공적");
	  }
	});
}
</script>





</body>
</html>