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
var ReplyBox  = React.createClass({
	render : function(){
		return (
			<span>안녕하세요 리액트!</span>
		)
	}
});

React.render(<ReplyBox/>, document.getElementById('replyBox') );
</script>



</body>
</html>