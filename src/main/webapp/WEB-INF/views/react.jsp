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
	span.originalView, div.reply { display: inline;}
</style>
</head>
<body>
<h1>hello react</h1>

<div id="replyForm">


</div> 
<hr>
<h4>댓글 내용</h4>
<div id="replyContent">
	<div class="reply"> 글쓴이 : 하하하 </div>
</div>

<script type="text/jsx">
var ReplyForm = React.createClass({
	render: function(){
		return(
			<div>
			 <h4>댓글 입력</h4>
			 닉넴 : <input type="text" name="author" ref="author" /> ,  
	         내용 : <input type="text" name="comment" ref="comment" /> 
			 <button onclick="submit()">전송!</button> 
			</div> 
		);
	}
}); 

var OrigianlView = React.createClass({
	render: function(){
		return(
			<span className="originalView">
				 <span className="comment">{this.props.children.toString()}</span>
        		 <button>수정</button>
        		 <button>삭제</button>
			</span>
		)
	}
});


var Reply = React.createClass({
	render: function(){
		return(
			<div className="reply">
        		 <span className="author">{this.props.author} : </span>
        		 <OrigianlView>하하하</OrigianlView>
        	</div>
		)
	}
});

  React.render(<ReplyForm/>, document.getElementById('replyForm') );
  React.render(<Reply author="아라한사"/>, document.getElementById('replyContent') );		
</script>
<!-- 
 
-->


</body>
</html>