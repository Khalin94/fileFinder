<%@page language="java" contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content = "text/html; charset=utf-8">
<meta http-equiv="Cache-control" content = "no-cache">
<meta http-equiv="Pragma" content = "no-cache">
<title>KeySharpBiz2.1 Demo</title>
<style type="text/css">
body,td,th {
	font-family: "돋움";
	font-size: 12px;
}
body {
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
}
</style>
<%@ include file="../../raonnx/jsp/raonnx.jsp" %>
<script type="text/javascript">
	function upload_complete(result){
		if(result.status==1){			
			alert("업로드 성공:" + result.response);
		}
		else if(result.status!=0){
			alert("업로드 실패:" + result.message + ":" + result.status);
		}
	}

	function send()
	{
		document.getElementById("input").submit();
	}
</script>
</head>
<body leftmargin="0" topmargin="0">
<div id="wrapper" style="width:100%;">

	<div id="header" style="background-image:url('images/bg_head.gif');width:100%; height:43px;">
		<img src="images/logo_head.gif" width="187" height="43" style="float:right;"/>
	
	</div>
	<div style="background-color:#eaebec; padding:0;">
		<img src="images/img_top_sub01.gif" width="234" height="185" style="float:left;"/><img src="images/img_top_main02.gif"/>
	</div>
	<div style="padding:30px 70px" >
	  <h2>파일서명 암호화 업로드 </h2>
	<form name="input" id="input" method="post" onsubmit="return false;" action="signfileAction.jsp">
		업로드 URL : <input type="text" id="url" name="url" value="/demo/fileUpload.jsp" style="width:400px;"/><br/><br/>
		<button onclick="KeySharpBiz.signFileUrl(document.input.url.value, upload_complete);">파일서명 업로드</button><br/><br/>
		서버에서검증 : <input type="text" id="outFile" name="outFile" value="/var/tmp/nxbiz/data.fsig"/><br/><br/>
		<button onclick="send();return false;">서버검증</button>
	</form>
	<br/><br/>
<a href="index.jsp">[처음으로]</a>
<a href="javascript:history.back(-1);">[뒤로]</a>
	</div>
	<div id="footer" style="width:96%; margin-left:auto; margin-right:auto  "><div style="border-top:1px solid #eaebec;width:100%;"></div><img src="images/logo_foot.gif" width="174" height="49" style="float:right;"/></div>
</div>

</body>
</html>
