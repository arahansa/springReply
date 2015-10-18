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
	<my-reply ng-repeat="reply in replies|orderBy:'-replyId'"></my-reply>
	
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
	$scope.submit = submit;
	
	
	function submit(){
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

app.directive('myReply', function($compile){
	return {
		restrict: 'E', 
		replace: true,
		template: 
			'<div class="reply" data-id="{{reply.replyId}}" >' +
			'<span class="author"> {{reply.author}} : </span> '+
			'<span class="comment"> {{reply.comment}} </span>'+
			'<button ng-click="modifyForm( $event )">수정</button>'+  
			'<button ng-click="del( reply )">삭제</button>',
		link: function(scope, element){
			scope.modifyForm = function modifyForm(){
				var replyDiv = $(event.currentTarget).closest("div.reply");
				
				$(replyDiv).attr("status", "modifying");
				scope.tempContent = $(event.currentTarget).prev().text();
				
				$(replyDiv).find("button").remove();
				$(replyDiv).find("span.author").next().replaceWith(
						$compile(
						'<textarea ng-model="reply.comment">'+scope.tempContent+'</textarea>'+
						'<button ng-click="update( reply )">수정!</button>'+
						'<button ng-click="cancelUpdate( reply )">취소</button>')(scope));
			};
			
			scope.update = function( reply ){
				makeOrigianlView( reply , event );
			}
			
			scope.cancelUpdate = function( reply ){
				reply.comment = scope.tempContent;
				makeOrigianlView( reply, event ); 
			}
			
			function makeOrigianlView( reply, event ){
				var replyDiv = $(event.currentTarget).closest("div.reply");
				$(replyDiv).removeAttr("status");
				$(replyDiv).find("button").remove();
				$(replyDiv).find("span.author").next().replaceWith(
						$compile(
						'<span class="comment">{{reply.comment}}</span>'+
						' <button ng-click="modifyForm()">수정</button>'+  
						' <button ng-click="del(reply)">삭제</button>')(scope));
			}
			
		}
	}
});

</script>
</body>
</html>