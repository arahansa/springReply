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
<body ng-controller="replyController"  ng-init="init(1)">
<h1>Hello Angular</h1>

<h4>댓글 입력</h4>
	닉넴 : <input type="text" id="author"> ,  
	내용 : <input type="text" id="comment"> 
	<button ng-click="submit( reply )">전송!</button> 
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
	$scope.replyCount=1;
	$scope.replies = [];
	
	$scope.del = del;
	$scope.submit = submit;
	$scope.init = init;
	
	function init(pagenumber){
		console.log(pagenumber+"의 글을 읽습니다.!");
		var req = {method: "GET", url: '/comment'};
		$http(req)
			.success(function(data) { $scope.replies=data; })
			.error(function() { alert("댓글 읽어오는데 에러 발생"); });
	}
	
	function submit(){
		var reply = {
				author : $("#author").val(),
				comment : $("#comment").val()
		};
		var req = { method: "POST", url: '/comment', data: reply };
		$http(req)
		.success(function(data) { console.log(data); $scope.replies.push(data);})
		.error(function() { alert("댓글 쓰는데 에러 발생"); });
		
		// reply.author=""; reply.comment=""; 
		$("#author").val("");
		$("#comment").val("");
	}
	
	function del( reply ){
		var req = {method: "DELETE", url: '/comment/'+reply.id};
		$http(req)
		.success(function(data) { 
			var index = $scope.replies.indexOf(reply);
			$scope.replies.splice(index ,1);
		})
		.error(function() { alert("댓글 삭제시 에러 발생"); });
	}
});

app.directive('myReply', function($compile, $http){
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
						'<button ng-click="update( reply, $event )">수정!</button>'+
						'<button ng-click="cancelUpdate( reply )">취소</button>')(scope));
			};
			
			scope.update = function( reply , event ){
				var req = { method: "PUT", url: '/comment/'+reply.id, data: reply };
				$http(req)
				.success(function(data) { 
					var replyDiv = $(event.currentTarget).closest("div.reply");
					makeOrigianlView( replyDiv ); 
				}).error(function() { alert("댓글 수정 실패"); });
			}
			
			scope.cancelUpdate = function( reply ){
				reply.comment = scope.tempContent;
				var replyDiv = $(event.currentTarget).closest("div.reply");
				makeOrigianlView( replyDiv ); 
			}
			
			function makeOrigianlView( replyDiv ){
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