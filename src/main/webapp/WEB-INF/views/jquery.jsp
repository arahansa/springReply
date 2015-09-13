<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>happy coding : jquery</title>
<style>
	div.reply { margin-bottom: 10px; }
</style>
</head>
<body>
<h1>jsp</h1>

<h4>댓글 입력</h4>
	닉넴 : <input type="text" name="author" id="author"> ,  
	내용 : <input type="text" name="comment" id="comment"> 
	<button onclick="submit()">전송!</button> 
<hr>
<h4>댓글 내용</h4>
<div id="replyContent">
	<div class="reply"> 
		<span class="author">글쓴이 :</span>
		<span class="comment">하하하</span>
		<button>수정</button>
		<button>삭제</button>
	</div>
</div>
<script src="/js/lib/jquery-1.11.3.min.js"></script>

<script>
	var tempContent="";
	// List
	$(document).ready(function(){
		console.log("Hello world");
		$.get( "/comment" , function( data ) {
	        $(data).each( function(k,v){
	        	addNewReply(v);
	        });
	    });
	});
	
	function addNewReply(v){
		$("#replyContent").prepend(
        		'<div class="reply" data-id='+v.id+'>'+
        		' <span class="author">'+v.author +' : </span>' +
        		' <span class="comment">'+v.comment +'</span>' +
        		' <button onclick="modifyForm(this)">수정</button> '+
        		' <button onclick="del(this)">삭제</button>' +
        		'</div>'
        );
	}
	
	// Create
	function submit(){
		var reply = { author : $("#author").val(), comment : $("#comment").val() };
		
		$.ajax({
            type : 'POST',
            url : '/comment',
            contentType: 'application/json',
            data : JSON.stringify( reply ),
            dataType: 'json',
            success : function(result) {
                addNewReply(result);
            },error : function(xhr, status, error){
                console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
            }
        });
	}
	
	// UpdateForm
	function modifyForm(obj){
		makeCommentView($("div[status=modifying]"), tempContent);
		$(obj).closest("div.reply").attr("status", "modifying");
		
		tempContent = $(obj).prev().text();
		$(obj).prev().replaceWith(
				'<textarea id="updatedComment">'+tempContent +'</textarea>'+
				'<button onclick="update(this)">수정!</button>'+
				'<button onclick="cancelUpdate(this)">취소</button>'
		);
		$(obj).next().remove();
		$(obj).remove();
	}
	
	// Update
	function update(obj){
		var replyDiv = $(obj).closest("div.reply");
		var replyId = $(replyDiv).attr("data-id");
		var reply = { comment : $("#updatedComment").val() };
		
		$.ajax({
            type : 'PUT',
            url : '/comment/'+replyId,
            contentType: 'application/json',
            data : JSON.stringify( reply ),
            dataType: 'json',
            success : function(result) {
            	makeCommentView(replyDiv, result.comment);
            },error : function(xhr, status, error){
                console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
            }
        });
	}
	
	// Cancel Update
	function cancelUpdate(obj){
		var replyDiv = $(obj).closest("div.reply");
		makeCommentView(replyDiv, tempContent);
	}
	
	function makeCommentView(replyDiv, comment){
		$(replyDiv).removeAttr("status");
		$(replyDiv).find("button").remove();
        $("#updatedComment").replaceWith(
        		' <span class="comment">'+comment +'</span>' +
        		' <button onclick="modifyForm(this)">수정</button> '+
        		' <button onclick="del(this)">삭제</button>'	
        );
	}
	
	function del(obj){
		var replyId = $(obj).parent().attr("data-id");
		$.ajax({
		    url: '/comment/'+replyId,
		    type: 'DELETE',
		    success: function(result) {
		        if(result == 'DELETE'){
		        	console.log("삭제 성공");
		        	$(obj).parent().remove();
		        }
		    },error : function(xhr, status, error){
                console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
            }
		});
	}
</script>
</body>
</html>