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
	function download_complete(result){		
		if(result.status==1){			
			alert("서명추가 성공:" + result.response);
		}
		else if(result.status!=0){
			alert("서명추가 실패:" + result.message + ":" + result.status);
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
	<h2>파일 서명 추가 암호화 업/다운로드 </h2>
	<br/>
	<a href="#" onclick="KeySharpBiz.setLang('KOR');return false;">한국어</a>
	<a href="#" onclick="KeySharpBiz.setLang('ENG');return false;">영어</a>
	<a href="#" onclick="KeySharpBiz.setLang('CHN');return false;">중국어</a>
	<a href="#" onclick="KeySharpBiz.setLang('JPN');return false;">일본어</a>
   	<br/><br/>
	<form name="input">
		서명파일 URL: <input type="text" id="dataUrl" name="dataUrl" value="/demo/data.fsig" style="width:400px"/><br/>
		업로드 URL: <input type="text" id="url" name="url" value="/demo/fileUpload.jsp" style="width:400px"/><br/>
	</form>	
	<button onclick="KeySharpBiz.resetCertificate();KeySharpBiz.addSignFileUrl(document.input.dataUrl.value, document.input.url.value, download_complete)">파일 서명 추가 다운로드/업로드</button><br/>	

	<br/><br/>
<a href="index.jsp">[처음으로]</a>
<a href="javascript:history.back(-1);">[뒤로]</a>
	</div>
	<div id="footer" style="width:96%; margin-left:auto; margin-right:auto  "><div style="border-top:1px solid #eaebec;width:100%;"></div><img src="images/logo_foot.gif" width="174" height="49" style="float:right;"/></div>
</div>

<script type="text/javascript">
	//var urlvalue = window.location.protocol + "//" + window.location.host + document.getElementById("url").value;
	var urlvalue = document.getElementById("url").value;
	//var dataUrlvalue = window.location.protocol + "//" + window.location.host + document.getElementById("dataUrl").value;
	var dataUrlvalue = document.getElementById("dataUrl").value;
	document.getElementById("url").value = urlvalue;
	document.getElementById("dataUrl").value = dataUrlvalue;
</script>

</body>
</html>
