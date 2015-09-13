<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Happy coding : React</title>
<script src="/js/lib/react.js"></script>
<script src="/js/lib/JSXTransformer.js"></script>
<script src="/js/lib/jquery-1.11.3.min.js"></script>
<script src="/js/lib/marked.min.js"></script>
<style>
	span.originalView{ display: inline;}
	div.reply { margin-bottom: 10px;}
</style>
</head>
<body>
<h1>hello react</h1>
<div id="replyBox"></div>

<script type="text/jsx">
var replies = [
	          	{"replyId": 0, "author": "아라한사", "comment": "하하하"},
	            {"replyId": 1, "author": "아라한사22", "comment": "하하하22"}
	          ];

var Reply = React.createClass({
	makeFormView: function(){
		this.setState({isModifying: true});
	},
	cancelUpdate: function(){
		this.setState({isModifying: false});
	},
	deleteReply: function(){
		/*  TODO */
		this.props.del();
	},
	getInitialState: function() {
    	return {isModifying: false};
  	},
	render: function(){
		if(this.state.isModifying){
			return(
				<div className="reply">
					<span className="author">{this.props.reply.author} : </span>
					<textarea id="updatedComment" defaultValue={this.props.reply.comment}></textarea>
					<button>수정!</button>
					<button onClick={this.cancelUpdate}>취소</button>
				</div>
			)	
		}else{
			return(
				<div className="reply">
        		 	<span className="author">{this.props.reply.author} : </span>
        			<span className="comment">{this.props.reply.comment}</span>
        		 	<button onClick={this.makeFormView}>update</button>
        		 	<button onClick={this.deleteReply}>delete</button>
        		</div>
			)
		}
	}
});

var ReplyList = React.createClass({
	deleteReply: function(e){
		console.log("여기는 리플라이 리스트 !");
		this.props.del();
	},
	render: function(){
		var del = this.props.del;
		var replyNodes = this.props.replies.map(function (reply) {
			return (
        		<Reply key={reply.id} reply={reply} del={del}></Reply>
      		);
    	});
		return(
			<div className="replyList">
				{replyNodes}
			</div>	
		)
	}
});

var ReplyForm = React.createClass({
	handleReplySubmit: function(e){
		e.preventDefault();
		
		var reply = {author: this.state.author, comment: this.state.comment};
		this.props.onReplySubmit(reply);
		this.setState({author:'', comment:''})
	},
	getInitialState: function() {
    	return {author:'', comment:''};
  	},
	onChangeAuthor: function(e){
		this.setState({author:e.target.value})
	},
	onChangeComment: function(e){
		this.setState({comment:e.target.value})
	},
	render: function(){
		return(
			<div>
			 <h4>comment input 입력</h4>
			 nick : <input type="text" name="author" value={this.state.author} onChange={this.onChangeAuthor} /> ,  
	         comment : <input type="text" name="comment" value={this.state.comment} onChange={this.onChangeComment}  /> 
			 <button onClick={this.handleReplySubmit}>전송!</button> 
			</div> 
		);
	}
}); 

var ReplyBox  = React.createClass({
	loadRepliesFromServer: function(){
		$.ajax({
      		url: "/comment",
     		dataType: 'json',
      		cache: false,
      		success: function(data) {
        		this.setState({replies: data});
      		}.bind(this),
      		error: function(xhr, status, err) {
        		console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
     		}.bind(this)
    	});
	},
	getInitialState: function() {
    	return {replies: []};
  	},
	componentDidMount: function() {
		this.loadRepliesFromServer();
  	},
	handleReplySubmit: function(reply) {
		var currentReplies = this.state.replies;
    	$.ajax({
      		type : 'POST',
            url : '/comment',
            contentType: 'application/json',
            data : JSON.stringify( reply ),
            dataType: 'json',
      		success: function(data) {
        		var newReplies = currentReplies.concat(data);
    			this.setState({replies: newReplies});
      		}.bind(this),
      		error: function(xhr, status, err) {
        		console.error(this.props.url, status, err.toString());
      		}.bind(this)
    	});
  	},
	deleteReply: function(){
		console.log("여기는 리플라이 박스! 삭제 호출");
		/* var index = this.state.replies.indexOf(this.props.reply); 
		
		$.ajax({
		    url: '/comment/'+this.props.reply.id,
		    type: 'DELETE',
		    success: function(result) {
		        if(result == 'DELETE'){
		        	console.log("삭제 성공");
		        }
		    },error : function(xhr, status, error){
                console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
            }
		});*/
	},
	render: function(){
		return (
			<div className="replyBox">
				<ReplyForm onReplySubmit={this.handleReplySubmit}/>
				<hr/>
				<ReplyList replies={this.state.replies} del={this.deleteReply} />
			</div>
		)
	}
});


  React.render(<ReplyBox/>, document.getElementById('replyBox') );
  
		
</script>
<!-- 
 
-->


</body>
</html>