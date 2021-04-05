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
function verify()
{
	var signdata = document.getElementById("ksbizSig").value;

	if(signdata.length <= 0)
	{
		alert("검증오류: 전자서명 메시지가 없습니다.");
		return;
	}
	
	if(signdata.charAt(0) != 'M')
	{
		signdata = CertManX.X2P(signdata);
	}

	CertManX.LocalPathValidationOnOff(0);
	
	verifydata = CertManX.VerifyDataB64(signdata, 1);
	if(verifydata == "")
	{
		alert("서명 검증 실패 : [" + CertManX.GetLastErrorCode() + "]" + CertManX.GetLastErrorMsg());
		return;
	}

	document.getElementById("t_dn").value = CertManX.GetToken(verifydata, "dn");
	document.getElementById("t_verifydata").value = verifydata;
	document.getElementById("t_pubkey").value = CertManX.GetToken(verifydata, "pubkey");
	document.getElementById("t_pubkeyh").value = CertManX.P2X(CertManX.GetToken(verifydata, "pubkey"));
	document.getElementById("t_plaintext").value = CertManX.GetToken(verifydata, "data");
	document.getElementById("t_cert").value = CertManX.GetToken(verifydata, "certificate");
}

function neverify()
{
	var nesigndata = document.getElementById("ksbizSig").value;
	var neplaintext = document.getElementById("ksbizData").value;
	var pubkey = document.getElementById("pubKey").value;
	
	if(pubkey.charAt(0) != 'M')
	{
		pubkey = CertManX.X2P(pubkey);
	}

	if(neverifydata = CertManX.VerifyData_ne_B64(neplaintext, nesigndata, pubkey, 1) == false)	
	{
		alert("축약 검증 실패 : [" + CertManX.GetLastErrorCode() + "]" + CertManX.GetLastErrorMsg());
		return;
	}
	
	alert("축약 검증 성공");
}
</script>

<script type="text/javascript">
	function complete_sign(result, context){
		if(result.status==1){
/*			
			document.getElementById("ksbizSig").value = result.data;
			document.getElementById("ksbizSigner").value = result.signer;
			//document.getElementById("ksbizData").value = decodeURIComponent(result.rawData);
			document.getElementById("ksbizData").value = result.rawData;
			//document.getElementById("ksbizVidRandom").value = decodeURIComponent(result.vidRandom);
			document.getElementById("ksbizVidRandom").value = result.vidRandom;
*/			
			document.ksbizForm.ksbizSig.value = result.data;
			if(result.signAlgorithm!=null && result.signAlgorithm!="")
				document.ksbizForm.ksbizSig.value = document.ksbizForm.ksbizSig.value + "|" + result.signAlgorithm;
			if(document.ksbizForm.ksbizSigner!=null && result.signer!=null) 
				document.ksbizForm.ksbizSigner.value = result.signer;
			if(document.ksbizForm.ksbizData!=null && result.rawData!=null)
				document.ksbizForm.ksbizData.value = result.rawData;
			if(document.ksbizForm.ksbizVidRandom!=null && result.vidRandom!=null)
				document.ksbizForm.ksbizVidRandom.value = result.vidRandom;
			
			if(context == "euckr"){
				document.getElementsByName("encoding")[1].checked= true;
			}else{
				document.getElementsByName("encoding")[0].checked= true;
			}
		}else if(result.status==0){
			alert("인증서 선택을 취소하였습니다.");
		}else if(result.status == -10301){
			//저장매체 설치를 위해 전자서명창이 닫히는 경우
		}else if(result.status!=0){
			alert("전자서명 오류:" + result.message + "[" + result.status + "]");
		}
	}
	
	function complete_ksign(result, context){
		if(result.status==1){
			document.ksbizForm.ksbizSig.value = result.data;
			if(document.ksbizForm.ksbizSigner!=null && result.signer!=null) 
				document.ksbizForm.ksbizSigner.value = result.signer;
			if(document.ksbizForm.ksbizData!=null && result.rawData!=null)
				document.ksbizForm.ksbizData.value = result.rawData;
			if(document.ksbizForm.ksbizVidRandom!=null && result.vidRandom!=null)
				document.ksbizForm.ksbizVidRandom.value = result.vidRandom;
			
			if(context == "euckr"){
				document.getElementsByName("encoding")[1].checked= true;
			}else{
				document.getElementsByName("encoding")[0].checked= true;
			}
		}else if(result.status==0){
			alert("인증서 선택을 취소하였습니다.");
		}else if(result.status == -10301){
			//저장매체 설치를 위해 전자서명창이 닫히는 경우
		}else if(result.status!=0){
			alert("전자서명 오류:" + result.message + "[" + result.status + "]");
		}
	}
	
	function send()
	{
		document.getElementById("ksbizForm").action = document.getElementById("inputform").action;
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

<OBJECT classid=CLSID:EC5D5118-9FDE-4A3E-84F3-C2B711740E70
codeBase="http://www.signkorea.com/SKCommAX.cab#version=9,6,0,2"
height=1 id=CertManX width=1>
</OBJECT>

<div id="wrapper" style="width:100%;">

	<div id="header" style="background-image:url('images/bg_head.gif');width:100%; height:43px;">
		<img src="images/logo_head.gif" width="187" height="43" style="float:right;"/>
	
	</div>
	<div style="background-color:#eaebec; padding:0;">
		<img src="images/img_top_sub01.gif" width="234" height="185" style="float:left;"/><img src="images/img_top_main02.gif"/>
	</div>
	<div style="padding:30px 70px" >
	  <h1>코스콤서명-축약서명(PKCS#1)</h1>
	<br/>
	<a href="#" onclick="KeySharpBiz.setLang('KOR');return false;">한국어</a>
	<a href="#" onclick="KeySharpBiz.setLang('ENG');return false;">영어</a>
	<a href="#" onclick="KeySharpBiz.setLang('CHN');return false;">중국어</a>
	<a href="#" onclick="KeySharpBiz.setLang('JPN');return false;">일본어</a>
   	<br/>
	  
	    <h4>◆ 입력값</h4>
	    <form id="inputform" name="inputform" method="post" action="pkcs1SignAction.jsp">
	    - 서명원문<br>
	    <input type="text" id="plain" name="plain" value="가나다라1234ABCD"/>			
		</form>
		
		<hr/>
		<h4>◆ 출력값</h4>
	   	<form id="ksbizForm" name="ksbizForm" method="post" action="">
	   		- 전자서명 메시지<br>
	   		<textarea id="ksbizSig" name="ksbizSig" cols="100" rows="4"></textarea><br>
			- vidRandom<br>
			<input type="text" id="ksbizVidRandom" name="ksbizVidRandom"/><br/>
	   		- 서명자 인증서<br>
   		    <textarea id="ksbizSigner" name="ksbizSigner" cols="100" rows="5"></textarea><br>
	   		- 서명자 인증서 공개키<br>
	   		<input type="text" id="pubKey" name="pubKey"><br>
	   		- 서명원문<br>
	   		<input type="text" id="ksbizData" name="ksbizData">
			<br/><br/>
			 - 코스콤검증모듈(IE만 지원)<br/>
			     서명자 인증서 공개키는 [코스콤서명-풀서명(signedData)] 데모에서 복사해 온다.<br/>
			<button onclick="KSBizConfig.signAlgorithm = 'rsaEncryption';KeySharpBiz.sign(encodeURIComponent(document.getElementById('plain').value), complete_ksign, {signType:'PKCS1'});return false;">축약서명</button>
			<button onclick="neverify();return false;">축약서명 검증</button>
			<hr/>
			- 위택스서명검증<br>
			<button onclick="KeySharpBiz.sign(document.getElementById('plain').value, complete_sign, {signType:'PKCS1'});return false;">위택스(utf8)</button>
			<button onclick="KeySharpBiz.sign(document.getElementById('plain').value, {complete:complete_sign, context:'euckr'}, {signType:'PKCS1', encoding:'euckr'});return false;">위택스(euckr)</button><br>
			원문인코딩: utf-8 <input type="radio" id="encoding" name="encoding" value="utf8" checked> EUC-KR <input type="radio" id="encoding" name="encoding" value="euckr"><br>
			전자서명 알고리즘: RSA_V15사용 <input type="checkbox" id="signAlgorithm" name="signAlgorithm" value="rsaEncryption" onclick="checkSignAlgorithm();">(기본값: RSA_PSS)<br>
			<button onclick="send();return false;">서버로 전송</button>
	   	</form>
	<br/><br/>
<a href="index.jsp">[처음으로]</a>
<a href="javascript:history.back(-1);">[뒤로]</a>
	</div>
	<div id="footer" style="width:96%; margin-left:auto; margin-right:auto  "><div style="border-top:1px solid #eaebec;width:100%;"></div><img src="images/logo_foot.gif" width="174" height="49" style="float:right;"/></div>
</div>

</body>
</html>
