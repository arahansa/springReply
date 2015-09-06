<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<!-- 네트워크 없이 그냥 되는.  -->
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
	닉넴 : <input type="text" name="author" id="author" ng-model="reply.author"> ,  
	내용 : <input type="text" name="comment" id="comment" ng-model="reply.comment"> 
	<button ng-click="submit(reply)">전송!</button> 
<hr>
<h4>댓글 내용 ({{replies.length }} 개의 댓글)</h4>
<div id="replyContent">
	<my-reply ng-repeat="reply in replies|orderBy:'-replyId'"></my-reply>
</div>



<script src="/js/lib/jquery-1.11.3.min.js"></script>
<script src="/js/lib/angular.min.js"></script>
<script>

var app = angular.module('testApp', []);

app.controller('replyController', function ($scope, $http, $compile) {
	$scope.replyCount=1;
	$scope.replies = [
	                  {"replyId": 0, "author": "아라한사", "comment": "하하하"},
	                  {"replyId": 1, "author": "아라한사22", "comment": "하하하22"}
	                  ];
	
	$scope.submit = submit;
	$scope.tempContent = "";
	
	
	function submit(reply){
		$scope.replyCount++;
		reply.replyId = $scope.replyCount;
		$scope.replies.push(angular.copy(reply));
	}
	
})
.directive('myReply', function($compile){
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
				var index = scope.replies.indexOf(reply);
				scope.replies.splice(index ,1);
			};
		}
	};
})
.directive('updateForm', function($compile){
	return {
		restrict: 'E',
		template : 
			'<textarea ng-model="reply.comment">{{reply.comment}}</textarea>'+
			'<button ng-click="update(reply)">수정!</button>'+
			'<button ng-click="cancelUpdate(reply)">취소</button>',
		link: function(scope, element) {
			scope.update = function update( reply ){
				cancelUpdateAction(reply, event );
			};
			scope.cancelUpdate = function cancelUpdate( reply ){
				reply.comment = scope.tempContent;
				cancelUpdateAction(reply, event );
			};
			function cancelUpdateAction( reply, event ){
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