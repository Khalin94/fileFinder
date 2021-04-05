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
		var obj = JSON.parse(result.response);
		if(obj.errorCode != 0){
			alert("업로드 실패:" + obj.errorCode + "\n" + obj.errorMsg);
		}else{
			alert("업로드 성공:" + result.response);
		}
	}
	else if(result.status!=0){
		alert("업로드 실패:" + result.message + ":" + result.status);
	}
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
	  <h2>업로드 파일 채널 암호화 </h2>
	<form name="upload">
		업로드 URL : <input type="text" id="url" name="url"value="/demo/fileUpload.jsp" style="width:400px;"/><br/>
	</form>	
	<button onclick="KeySharpBiz.channelEncryptFileUrl(document.upload.url.value, upload_complete)">채널 암호화 업로드</button><br/>
	<br/><br/>
<a href="index.jsp">[처음으로]</a>
<a href="javascript:history.back(-1);">[뒤로]</a>
	</div>
	<div id="footer" style="width:96%; margin-left:auto; margin-right:auto  "><div style="border-top:1px solid #eaebec;width:100%;"></div><img src="images/logo_foot.gif" width="174" height="49" style="float:right;"/></div>
</div>

</body>
</html>
