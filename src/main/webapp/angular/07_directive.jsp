<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html ng-app="testApp">
<head>
<title> Happy WOrld </title>
</head>
<body>
<h1>디렉티브를 알아보자. </h1>
<my-view></my-view>

<script src="/js/lib/jquery-1.11.3.min.js"></script>
<script src="/js/lib/angular.min.js"></script>

<script>
var app = angular.module('testApp', []);
app.directive('myView', function($compile){
	return {
		restrict: 'E',
		template : '<span>안녕하세요</span>'
	};
});
</script>
</body>
</html>