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
// 코스콤서명은 RSA_V15만 사용 가능함
KSBizConfig.signAlgorithm = "rsaEncryption";

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
	document.getElementById("t_plaintext").value = decodeURIComponent(CertManX.GetToken(verifydata, "data"));
	document.getElementById("t_cert").value = CertManX.GetToken(verifydata, "certificate");
}

function neverify()
{
	var nesigndata = form.t_nesigndata.value;
	var neplaintext = form.t_neplaintext.value;
	var pubkey = form.t_nepubkey.value;
	
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
	function complete_sign(result){
		if(result.status==1){			
			document.getElementById("ksbizSig").value = result.data;
		}
		else if(result.status==0){
			alert("인증서 선택을 취소하였습니다.");
		}
		else if(result.status!=0){
			alert("전자서명 오류:" + result.message + "[" + result.status + "]");
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
	  <h1>코스콤서명-풀서명</h1>
    
    <h4>◆ 입력값</h4>
	    <form id="inputform" name="inputform" method="post" action="pkcs1SignAction.jsp">
	    - 서명원문<br>
	    <input type="text" id="plain" name="plain" value="가나다라1234ABCD"/>			
		</form>
		
		<hr/>
		<h4>◆ 출력값</h4>
	   	<form id="ksbizForm" name="ksbizForm" method="post" action="">
	   		- 전자서명 메시지<br>
	   		<textarea id="ksbizSig" name="ksbizSig" cols="100" rows="5"></textarea>
	   	</form>
	   	
		<hr/>
	<h4>◆ 검증결과</h4>
		-검증 데이터 (인증서 정보)<br>
		<textarea id="t_verifydata" name="t_verifydata" cols="100" rows="5"></textarea><br>

		- 인증서 DN<br>
		<input type=text id=t_dn name=t_dn size=70><br>
		- 인증서 데이터<br>
		<input type=text id=t_cert name=t_cert size=70><br>

		- 원문<br>
		<textarea id="t_plaintext" name="t_plaintext" cols="100" rows="2"></textarea><br>		
		-공개키(Base 64)<br>
		<input type=text id=t_pubkey name=t_pubkey size=70><br>
		- 공개키(Hexa)<br>
		<input type=text id=t_pubkeyh name=t_pubkeyh size=70><br>
		
		<br/>
		<button onclick="KeySharpBiz.sign(document.inputform, complete_sign, {signType:'signedData', signedAttribute:''});return false;">코스콤서명-풀서명</button>
		<button onclick="verify();return false;">풀서명 검증</button> - 코스콤검증모듈은 IE만 지원
		
	<br/><br/>
<a href="index.jsp">[처음으로]</a>
<a href="javascript:history.back(-1);">[뒤로]</a>
	</div>
	<div id="footer" style="width:96%; margin-left:auto; margin-right:auto  "><div style="border-top:1px solid #eaebec;width:100%;"></div><img src="images/logo_foot.gif" width="174" height="49" style="float:right;"/></div>
</div>

</body>
</html>
