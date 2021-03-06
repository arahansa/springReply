<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Happy coding : React</title>
	<script src="/node_modules/react/dist/react.js"></script>
	<script src="/node_modules/babel-core/browser.js"></script>
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

<script type="text/babel">


var replies = [
	          	{"replyId": 0, "author": "아라한사", "comment": "하하하"},
	            {"replyId": 1, "author": "아라한사22", "comment": "하하하22"}
	          ];


var ReplyForm = React.createClass({
	handleReplySubmit: function(){
		var reply = {author: this.state.author, comment: this.state.comment};
		this.props.onReplySubmit(reply);
		this.setState({author:'', comment:''})
	},
	getInitialState: function() {
    	return {author:'', comment:''};
  	},
	onChangeAuthor: function(e){
		/* 유튜브 영상에서 봤던 방식. ref 가 아니라 onChange 로 걸어주고 있더라?! */ 
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


var Reply = React.createClass({
	makeFormView: function(){
		this.setState({isModifying: true});
	},
	updateComment: function(){
		this.setState({isModifying: false});
		this.props.reply.comment = React.findDOMNode(this.refs.comment).value;
		this.props.update(this.props.reply);
	},
	cancelUpdate: function(){
		this.setState({isModifying: false});	
	},
	deleteReply: function(){
		this.props.del(this.props.reply);
	},
	getInitialState: function() {
    	return {isModifying: false};
  	},
	render: function(){
		if(this.state.isModifying){
			return(
				<div className="reply">
					<span className="author">{this.props.reply.author} : </span>
					<textarea id="updatedComment" defaultValue={this.props.reply.comment} ref="comment"></textarea>
					<button onClick={this.updateComment}>수정!</button>
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
	render: function(){
		var del = this.props.del;
		var update = this.props.update;
		var replyNodes = this.props.replies.map(function (reply) {
			return (
        		<Reply key={reply.id} reply={reply} del={del} update={update}></Reply>
      		);
    	});
		return(
			<div className="replyList">
				{replyNodes}
			</div>	
		)
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
	updateReply: function(reply){
		/* 궁금한 것! props로 전해준 reply 가 알아서 this.state.replies에 잘 반영이 되어있다! */
		console.log("받은 댓글", reply );
		var $this = this;
		$.ajax({
            type : 'PUT',
            url : '/comment/'+reply.id,
            contentType: 'application/json',
            data : JSON.stringify( reply ),
            dataType: 'json',
            success : function(result) {
            	$this.setState( $this.state.replies );
            },error : function(xhr, status, error){
                console.log("code:"+xhr.status+"\n"+"message:"+xhr.responseText+"\n"+"error:"+error);
            }
        });
	},
	deleteReply: function(reply){
		var index = this.state.replies.indexOf(reply); 
		var $this = this;	
		$.ajax({
		    url: '/comment/'+reply.id,
		    type: 'DELETE',
		    success: function(result) {
		        $this.state.replies.splice(index ,1);
				$this.setState($this.state.replies);
		    },error : function(xhr, status, error){
                console.log("code:"+xhr.status+"\n"+"message:"+xhr.responseText+"\n"+"error:"+error);
            }
		});
	},
	render: function(){
		return (
			<div className="replyBox">
				<ReplyForm onReplySubmit={this.handleReplySubmit}/>
				<hr/>
				<ReplyList  del={this.deleteReply} update={this.updateReply} />
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