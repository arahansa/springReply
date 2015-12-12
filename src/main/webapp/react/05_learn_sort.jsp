<%@ page contentType="text/html; charset=UTF-8" %>
<<html>
<head>
	<meta charset="utf-8">
	<title>test</title>
</head>
<body>
흐믛ㅁ<br>
working on 브라우저싱크 
asdfsadf


<button onclick="test()">클릭</button>
<button onclick="test2()">클릭</button>

<script type="text/javascript">
function test(){
	console.log("데이터", alphabetical())
}
function alphabetical() {
  return sortBy(getStates(), 'name');
}
function getStates() {
  return [
  	{ abbr: "BR", name: "broad"},
    { abbr: "AR", name: "arahansa"},
    { abbr: "WY", name: "Wyoming"}
  ];
}
function sortBy(arr, prop) {
  return arr.slice(0).sort(function(a, b) {
  	if (a[prop] < b[prop]) return -1;	
    if (a[prop] > b[prop]) return 1;	
    else return 0;	
  });
}
// 참고 블로깅 : http://programmingsummaries.tistory.com/150
function test2(){
	console.log("댓글 데이터 ", repliles());
	console.log("slice 0 은 ? : ", getReplies().slice(0));
}
function repliles(){
	return sortRepliesBy(getReplies(), 'id');
}
function getReplies(){
	return [
		{ id : 2, comment : "줄리아" },
		{ id : 1, comment : "아라한사"},
    	{ id : 3, comment : "애드" }
	];
}
function sortRepliesBy(arr, prop){
	return arr.sort(function(a, b) {
  	if (a[prop] < b[prop]) return -1;	
    if (a[prop] > b[prop]) return 1;	
    else return 0;	
  });
}






</script>
</body>
</html>