<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<title> Happy WOrld </title>
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

<div id="replyBox"></div>

<script type="text/jsx">
var replyCount=2;
var replies = [
	          	{"id": 0, "author": "아라한사", "comment": "하하하"},
	            {"id": 1, "author": "아라한사22", "comment": "하하하22"}
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
	sort: function(order){
		console.log("오더", order);
		this.props.sort(order);
	},
	render: function(){
		return(
			<div>
			 	<h4> 댓글  입력</h4>
			 	nick : <input type="text" name="author" value={this.state.author} onChange={this.onChangeAuthor} /> ,  
	         	comment : <input type="text" name="comment"  value={this.state.comment} onChange={this.onChangeComment}  /> 
			 	<button  onClick={this.handleReplySubmit} > 전송!</button> <br/>
				<button  onClick={this.sort.bind(this, 'asc')} > 원래순 정렬!</button> <br/>
				<button  onClick={this.sort.bind(this, 'desc')} > 역순정렬!</button> <br/> 
			</div> 
		);
	}
});


var Reply = React.createClass({
	render : function(){
		return (
			<div className="reply">
				<span class="author">{this.props.reply.author} : </span>
				<span class="comment">{this.props.reply.comment}</span>
				<button>수정</button>
				<button>삭제</button>
			</div>
		)
	}
});


function sortById(arr, type) {
  		return arr.slice(0).sort(function(a, b) {
			if(type=="desc"){
				if (a['id'] < b['id']) return -1;
    			if (a['id'] > b['id']) return 1;
			}else if(type="asc"){
				if (a['id'] < b['id']) return 1;
    			if (a['id'] > b['id']) return -1;
			}
    		return 0;
  		});
}
var ReplyBox  = React.createClass({
	handleReplySubmit: function(reply) {
		reply.id = replyCount;
		replyCount++;

		var newReplies = this.state.replies.concat(reply);
    	this.setState({replies: newReplies});
	},
	sort : function(order){
		if(order == 'desc' && order == this.state.order)
			return;
		this.setState({order:order});
	},
	renderStates: function() {
    		var replies = sortById(this.state.replies, this.state.order)
   	 		return replies.map(function(reply) {
      			return <Reply key={reply.id} reply={reply} ></Reply>;
    		});
  	},
	getInitialState: function() {
    	return {replies: sortById(replies, 'desc') , order:'desc'};
  	},
	render : function(){
		return (
			<div className="replyBox">
				<ReplyForm onReplySubmit={this.handleReplySubmit} sort={this.sort} />
				<hr/>
				<div className="replyList">
					{this.renderStates()}
				</div>	
			</div>
		);
	}
});

React.render(<ReplyBox/>, document.getElementById('replyBox') );
</script>
</body>
</html>