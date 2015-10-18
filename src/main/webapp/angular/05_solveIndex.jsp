<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html ng-app="testApp">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Happy coding : Angular</title>
<style>
	div.reply { margin-bottom: 10px; }
</style>
</head>
<body ng-controller="replyController">
<h1>Hello Angular</h1>

<h4>댓글 입력</h4>
	닉넴 : <input type="text" id="author"> ,  
	내용 : <input type="text" id="comment"> 
	<button ng-click="submit( reply )">전송!</button> 
<hr>
<h4>댓글 내용 ({{replies.length }} 개의 댓글)</h4>
<div id="replyContent">
	<div class="reply" data-id="{{reply.replyId}}" ng-repeat="reply in replies|orderBy:'-replyId'"> 
		<span class="author"> {{reply.author}} : </span> 
		<span class="comment"> {{reply.comment}} </span> 
		<button>수정</button>  
		<button ng-click="del( reply )">삭제</button>
	</div>
</div>



<script src="/js/lib/jquery-1.11.3.min.js"></script>
<script src="/js/lib/angular.min.js"></script>
<script>
var app = angular.module('testApp', []);

app.controller('replyController', function ($scope, $http) {
	$scope.replyCount=1;
	$scope.replies = [
	                  {"replyId": 0, "author": "아라한사", "comment": "하하하"},
	                  {"replyId": 1, "author": "아라한사22", "comment": "하하하22"}
	                  ];
	
	$scope.del = del; 
	
	$scope.submit = function( ){
		$scope.replyCount++;
		var reply = {
				replyId : $scope.replyCount,
				author : $("#author").val(),
				comment : $("#comment").val()
		};
		$scope.replies.push(reply);
		$("#author").val("");
		$("#comment").val("");
	}
	
	function del( reply ){
		var index = $scope.replies.indexOf(reply);
		$scope.replies.splice(index ,1);
	}
	
	
});
</script>
</body>
</html>