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
	function complete_sign(result){
		if(result.status==1){			
			document.getElementById("ksbizSig").value = result.data;
		}else if(result.status==0){
			alert("인증서 선택을 취소하였습니다.");
		}else if(result.status == -10301){
			//저장매체 설치를 위해 전자서명창이 닫히는 경우
		}else if(result.status!=0){
			alert("전자서명 오류:" + result.message + "[" + result.status + "]");
		}
	}
	
	function send(){
		document.getElementById("ksbizForm").submit();
	}

	function checkSignAlgorithm(){
		if(document.getElementById("signAlgorithm").checked){
			KSBizConfig.signAlgorithm = "rsaEncryption";
		}else{
			KSBizConfig.signAlgorithm = "preferRsaPSS";
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
	  <h2>다중전자서명</h2>
   	한번의 패스워드 입력으로 여러개의 서명(PKCS7)값을 생성 하고 싶은 경우 사용된다.<br/> 
    서버에서는 여러개를 각각 잘라내 PKCS7값을 검증해야한다. <br/>
	<br/>
	<a href="#" onclick="KeySharpBiz.setLang('KOR');return false;">한국어</a>
	<a href="#" onclick="KeySharpBiz.setLang('ENG');return false;">영어</a>
	<a href="#" onclick="KeySharpBiz.setLang('CHN');return false;">중국어</a>
	<a href="#" onclick="KeySharpBiz.setLang('JPN');return false;">일본어</a>
   	<br/>
   	<form name="ksbizForm" method="post">
		<input type="hidden" name="ksbizSig"/>
	</form>
	<br/>
	<h4>◆ 입력값</h4>
    <form id="inputform" name="inputform" method="post" action="multiSignAction.jsp">
    	- 서명원문<br>
		<textarea rows="3" cols="100" id="multiData" name="multiData">a=1&b=2&c=3|a=11&b=22&c=33|a=111&b=222&c=333</textarea>
	</form>
	
	<hr/>
	<h4>◆ 출력값</h4>
   	<form id="ksbizForm" name="ksbizForm" method="post" action="multiSignAction.jsp">
   		- 전자서명 메시지<br>
   		<textarea id="ksbizSig" name="ksbizSig" cols="100" rows="5"></textarea>
   	</form>
	<br/>
	전자서명 알고리즘: RSA_V15사용 <input type="checkbox" id="signAlgorithm" name="signAlgorithm" value="rsaEncryption" onclick="checkSignAlgorithm();">(기본값: RSA_PSS)<br>
	<button onclick="KeySharpBiz.multiSign({data:document.getElementById('multiData').value, action:'multiSignAction.jsp'}, complete_sign);return false;">전자서명</button>
	<button onclick="send();return false;">서버로 전송</button>
	<br/><br/>
<a href="index.jsp">[처음으로]</a>
<a href="javascript:history.back(-1);">[뒤로]</a>
	</div>
	<div id="footer" style="width:96%; margin-left:auto; margin-right:auto  "><div style="border-top:1px solid #eaebec;width:100%;"></div><img src="images/logo_foot.gif" width="174" height="49" style="float:right;"/></div>
</div>

</body>
</html>
