<%@ page contentType="text/html; charset=UTF-8" %>
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
	getInitialState: function() {
    	return {author:'', comment:''};
  	},
	render: function(){
		return(
			<div>
			 <h4>comment input 입력</h4>
			 nick : <input type="text" name="author" value={this.state.author}  /> ,  
	         comment : <input type="text" name="comment" value={this.state.comment}  /> 
			 <button>전송!</button> 
			</div> 
		);
	}
}); 


var Reply = React.createClass({
	render: function(){
		<div className="reply">
        		 	<span className="author">{this.props.reply.author} : </span>
        			<span className="comment">{this.props.reply.comment}</span>
        		 	<button>update</button>
        		 	<button>delete</button>
       	</div>
	}
});

var ReplyList = React.createClass({
	render: function(){
		var replyNodes = this.props.replies.map(function (reply) {
			return (
        		<Reply key={reply.id} reply={reply}></Reply>
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
	getInitialState: function() {
    	return {replies: replies};
  	},
	render: function(){
		return (
			<div className="replyBox">
				<ReplyForm />
				<hr/>
				<ReplyList replies={this.state.replies} />
			</div>
		)
	}
});
  React.render(<ReplyBox/>, document.getElementById('replyBox') );	
</script>



</body>
</html>