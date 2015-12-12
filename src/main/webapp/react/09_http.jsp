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
	makeFormView: function(){
		this.setState({isModifying: true});
	},
	cancelUpdate: function(){
		this.setState({isModifying: false});	
	},
	updateReply: function(){
		this.setState({isModifying: false});
		this.props.reply.comment = React.findDOMNode(this.refs.comment).value;
		this.props.updateReply(this.props.reply);
	},
	deleteReply : function(){
		this.props.deleteReply(this.props.reply);
	},
	getInitialState: function() {
    	return {isModifying: false};
  	},
	render : function(){
		if(this.state.isModifying){
			return(
				<div className="reply">
					<span className="author">{this.props.reply.author} : </span>
					<textarea id="updatedComment" defaultValue={this.props.reply.comment} ref="comment"></textarea>
					<button onClick={this.updateReply}>수정!</button>
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
	loadRepliesFromServer: function(){
		$.ajax({
      		url: "/comment",
     		dataType: 'json',
      		success: function(data) {
        		this.setState({replies: data});
      		}.bind(this)
    	});
	},
	handleReplySubmit: function(reply) {
		$this=this;
		$.ajax({
      		type : 'POST',
            url : '/comment',
            contentType: 'application/json',
            data : JSON.stringify( reply ),
            dataType: 'json',
      		success: function(data) {
        		var newReplies = $this.state.replies.concat(data);
    			$this.setState({replies: newReplies});
      		}.bind(this),
      		error: function(xhr, status, err) {
        		console.error(this.props.url, status, err.toString());
      		}.bind(this)
    	});	
	},
	updateReply: function(reply){
		/* 궁금한 것! props로 전해준 reply 가 알아서 this.state.replies에 잘 반영이 되어있다! */
		console.log("받은 댓글", reply );
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
	sort : function(order){
		if(order == 'desc' && order == this.state.order)
			return;
		this.setState({order:order});
	},
	renderStates: function() {
    		var replies = sortById(this.state.replies, this.state.order)
			$this = this;
   	 		return replies.map(function(reply) {
      			return <Reply key={reply.id} reply={reply} deleteReply={$this.deleteReply} updateReply={$this.updateReply} ></Reply>;
    		});
  	},
	getInitialState: function() {
    	return {replies : [], order:'desc'};
  	},
	componentDidMount: function() {
		this.loadRepliesFromServer();
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