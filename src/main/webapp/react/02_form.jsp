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
var ReplyForm = React.createClass({
	render: function(){
		return(
			<div>
			 	<h4> 댓글  입력</h4>
			 	nick : <input type="text" name="author" /> ,  
	         	comment : <input type="text" name="comment" /> 
			 	<button> 전송!</button> 
			</div> 
		);
	}
});

var ReplyList = React.createClass({
	render : function(){
		return(
			<div className="replyList">
				
			</div>	
		);
	}
});

var ReplyBox  = React.createClass({
	render : function(){
		return (
			<div className="replyBox">
				<ReplyForm />
				<hr/>
				<ReplyList />
			</div>
		);
	}
});

React.render(<ReplyBox/>, document.getElementById('replyBox') );
</script>
</body>
</html>