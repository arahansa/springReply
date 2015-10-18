<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html ng-app="testApp">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Happy coding : Angular</title>
<style>
	div.reply { margin-bottom: 10px; }
</style>
</head>
<body ng-controller="replyController" ng-init="init(1)">
<h1>Hello Angular</h1>

<h4>댓글 입력</h4>
	닉넴 : <input type="text" name="author" id="author" ng-model="reply.author"> ,  
	내용 : <input type="text" name="comment" id="comment" ng-model="reply.comment"> 
	<button ng-click="submit(reply)">전송!</button> 
<hr>
<h4>댓글 내용 ({{replies.length }} 개의 댓글)</h4>
<div id="replyContent">
	<my-reply ng-repeat="reply in replies|orderBy:'-id'"></my-reply>
</div>



<script src="/js/lib/jquery-1.11.3.min.js"></script>
<script src="/js/lib/angular.min.js"></script>
<script>
var app = angular.module('testApp', []);

app.controller('replyController', function ($scope, $http) {
	$scope.init = init;
	$scope.submit = submit;
		
	function init(pagenumber){
		console.log(pagenumber+"의 글을 읽습니다.!");
		var req = {method: "GET", url: '/comment'};
		$http(req)
			.success(function(data) { $scope.replies=data; })
			.error(function() { alert("댓글 읽어오는데 에러 발생"); });
	}
	
	function submit(reply){
		var req = { method: "POST", url: '/comment', data: reply };
		$http(req)
		.success(function(data) { console.log(data); $scope.replies.push(data); reply.author=""; reply.comment=""; })
		.error(function() { alert("댓글 쓰는데 에러 발생"); });
		
	}
})
.directive('myReply', function($compile, $http){
	return {
		restrict: 'E',
		replace : true,
		template:
			'<div class="reply" data-id="{{reply.replyId}}">'+
			' <span class="author"> {{reply.author}} : </span>'+ 
			' <original-view></original-view>'+
			'</div>',
		link: function(scope, element){
			scope.modifyForm = function modifyForm(){
				var replyDiv = $(event.currentTarget).closest("div.reply");
				
				$(replyDiv).attr("status", "modifying");
				scope.tempContent = $(event.currentTarget).prev().text();
				
				$(replyDiv).find("span.author").next().replaceWith(
						$compile('<update-form></update-form>')(scope));
			};
			scope.del = function del(reply){
				var req = {method: "DELETE", url: '/comment/'+reply.id};
				$http(req)
				.success(function(data) { 
					var index = scope.replies.indexOf(reply);
					scope.replies.splice(index ,1);
				})
				.error(function() { alert("댓글 삭제시 에러 발생"); });
			};
		}
	};
})
.directive('updateForm', function($compile, $http){
	return {
		restrict: 'E',
		template : 
			'<textarea ng-model="reply.comment">{{reply.comment}}</textarea>'+
			'<button ng-click="update(reply, $event)">수정!</button>'+
			'<button ng-click="cancelUpdate(reply)">취소</button>',
		link: function(scope, element) {
			scope.update = function update( reply , event ){
				var req = { method: "PUT", url: '/comment/'+reply.id, data: reply };
				$http(req)
				.success(function(data) { makeOrigianlView( data, event ); })
				.error(function() { alert("댓글 수정 실패"); });
			};
			scope.cancelUpdate = function cancelUpdate( reply ){
				reply.comment = scope.tempContent;
				makeOrigianlView( reply, event );
			};
			function makeOrigianlView( reply, event ){
				var replyDiv = $(event.currentTarget).closest("div.reply");
				$(replyDiv).removeAttr("status");
				$(replyDiv).find("span.author").next().replaceWith(
						$compile('<original-view></original-view>')(scope));
			}
		}
	};
}).directive('originalView', function($compile){
	return{
		restrict: 'E',
		template :
			' <span class="comment"> {{reply.comment}} </span>'+
			' <button ng-click="modifyForm()">수정</button>'+  
			' <button ng-click="del(reply)">삭제</button>'
	};
});
</script>
</body>
</html>