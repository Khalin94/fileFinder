<%@page language="java" contentType="text/html;" pageEncoding="EUC-KR"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content = "text/html;">
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
		console.log(result);
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

	function complete_sign_context(result, context){
		alert("context:" + context);
		if(result.status==1){			
			document.getElementById("ksbizSig").value = result.data;
		}else if(result.status == 0){
			alert("인증서 선택을 취소하였습니다.");
		}else if(result.status == -10301){
			//저장매체 설치를 위해 전자서명창이 닫히는 경우
		}else if(result.status != 0){
			alert("전자서명 오류:" + result.message + "[" + result.status + "]");
		}
	}
	
	function send()
	{
		document.getElementById("inputform").submit();
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
	  <h2>로그인</h2>
	<br/>
	<a href="#" onclick="KeySharpBiz.setLang('KOR');return false;">한국어</a>
	<a href="#" onclick="KeySharpBiz.setLang('ENG');return false;">영어</a>
	<a href="#" onclick="KeySharpBiz.setLang('CHN');return false;">중국어</a>
	<a href="#" onclick="KeySharpBiz.setLang('JPN');return false;">일본어</a>
   	<br/>
   	<form id="frm" name="frm" method="post" action="result.jsp">
	pwd1 : <input type="password" id="pwd" name="pwd" /><br/>
</form>
   	<form name="ksbizForm" id="ksbizForm" method="post" action="/demo/ksbiz/signAction.jsp">
		<input type="hidden" id="ksbizEnc" name="ksbizEnc" value="">
	</form>
   	<form id=inputform name="inputform" method="post" action="/demo/ksbiz/signAction.jsp">
   		<h4>◆ 출력값</h4>
		- 전자서명 메시지<br/>
   		<textarea id="ksbizSig" name="ksbizSig" cols="100" rows="5"></textarea><br/>
   		전자서명 알고리즘: RSA_V15사용 <input type="checkbox" id="signAlgorithm" name="signAlgorithm" value="rsaEncryption" onclick="checkSignAlgorithm();">(기본값: RSA_PSS)<br>
		<button onclick="KeySharpBiz.login('', complete_sign);return false;">인증서 로그인</button>
		<button onclick="KeySharpBiz.login('', {complete:complete_sign_context, context:'String, Object 전달가능'});return false;">인증서 로그인(콜백에 context 사용)</button>
		<button onclick="KeySharpBiz.autoLogin('', complete_sign);return false;">인증서 로그인(auto)</button>
		<button onclick="send();return false;">서버로 전송</button><br/>
	</form>
	<br>
	<br>
	<a href="index.jsp">[처음으로]</a>
	<a href="javascript:history.back(-1);">[뒤로]</a>
	</div>
	<div id="footer" style="width:96%; margin-left:auto; margin-right:auto  "><div style="border-top:1px solid #eaebec;width:100%;"></div><img src="images/logo_foot.gif" width="174" height="49" style="float:right;"/></div>
</div>

</body>
</html>
