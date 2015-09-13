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



var OrigianlView = React.createClass({
	del: function(e){
		e.preventDefault();
		console.log(" delete ", this);
		this.props.deleteReply();
	},
	render: function(){
		return(
			<span className="originalView">
				 <span className="comment">{this.props.children.toString()}</span>
        		 <button>update</button>
        		 <button onClick={this.del}>delete</button>
			</span>
		)
	}
});

var modificationForm = React.createClass({
	render: function(){
		console.log("템프");
		return(
			<div className="modificationForm">
				<textarea id="updatedComment">템프</textarea>
				<button>수정!</button>
				<button>취소</button>
			</div>
		)
	}
});


var Reply = React.createClass({
	deleteReply: function(){
		console.log(" 부모 삭제 ", this);
		
	},
	render: function(){
		return(
			<div className="reply">
        		 <span className="author">{this.props.author} : </span>
        		 <OrigianlView deleteReply={this.deleteReply}>{this.props.children.toString()}</OrigianlView>
        	</div>
		)
	}
});

var ReplyList = React.createClass({
	render: function(){
		var replyNodes = this.props.replies.map(function (reply) {
      		return (
        		<Reply key={reply.id} author={reply.author}>{reply.comment}</Reply>
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
		var author = React.findDOMNode(this.refs.author).value;
		var comment = React.findDOMNode(this.refs.comment).value;
		var reply = {author: author, comment: comment};
		this.props.onReplySubmit(reply);
		React.findDOMNode(this.refs.author).value = '';
		React.findDOMNode(this.refs.comment).value = '';
	},
	render: function(){
		return(
			<div>
			 <h4>comment input 입력</h4>
			 nick : <input type="text" name="author" ref="author" /> ,  
	         comment : <input type="text" name="comment" ref="comment" /> 
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
	handleReplySubmit: function(reply) {
		console.log("들어온 댓글", reply );
		var currentReplies = this.state.replies;
    	var newReplies = currentReplies.concat(reply);
    	this.setState({replies: newReplies});
    	$.ajax({
      		type : 'POST',
            url : '/comment',
            contentType: 'application/json',
            data : JSON.stringify( reply ),
            dataType: 'json',
      		success: function(data) {
        		console.log("성공", data);
      		}.bind(this),
      		error: function(xhr, status, err) {
        		console.error(this.props.url, status, err.toString());
      		}.bind(this)
    	});
  	},
	getInitialState: function() {
    	return {replies: []};
  	},
	componentDidMount: function() {
		this.loadRepliesFromServer();
    	console.log("마운트");
  	},
	render: function(){
		return (
			<div className="replyBox">
				<ReplyForm onReplySubmit={this.handleReplySubmit}/>
				<hr/>
				<ReplyList replies={this.state.replies} />
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