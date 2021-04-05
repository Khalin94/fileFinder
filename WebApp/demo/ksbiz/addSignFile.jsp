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
		function complete(result){		
			if(result.status==1){			
				alert("서명 성공:" + result.fileName);
			}
			else if(result.status!=0){
				alert("서명실패:" + result.message + ":" + result.status);
			} else {
				alert("취소");
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
<div id="wrapper" style="width:100%;">

	<div id="header" style="background-image:url('images/bg_head.gif');width:100%; height:43px;">
		<img src="images/logo_head.gif" width="187" height="43" style="float:right;"/>
	
	</div>
	<div style="background-color:#eaebec; padding:0;">
		<img src="images/img_top_sub01.gif" width="234" height="185" style="float:left;"/><img src="images/img_top_main02.gif"/>
	</div>
	<div style="padding:30px 70px" >
	<h1>파일 전자 서명 추가 테스트</h1>
	<br/>
	<a href="#" onclick="KeySharpBiz.setLang('KOR');return false;">한국어</a>
	<a href="#" onclick="KeySharpBiz.setLang('ENG');return false;">영어</a>
	<a href="#" onclick="KeySharpBiz.setLang('CHN');return false;">중국어</a>
	<a href="#" onclick="KeySharpBiz.setLang('JPN');return false;">일본어</a>
   	<br/><br/>
	<form name="input">
		입력파일 : <input type="text" name="inFile" value="d:\temp\data.fsig"/><br/>
		출력파일 : <input type="text" name="outFile" value="d:\temp\data.fsig"/><br/>		
	</form>
	전자서명 알고리즘: RSA_V15사용 <input type="checkbox" id="signAlgorithm" name="signAlgorithm" value="rsaEncryption" onclick="checkSignAlgorithm();">(기본값: RSA_PSS)<br>
	<button onclick="KeySharpBiz.resetCertificate();KeySharpBiz.addSignFile(document.input.inFile.value, document.input.outFile.value, complete, {saveType:0})">서명추가-출력파일지정</button><br/>	
	<button onclick="KeySharpBiz.resetCertificate();KeySharpBiz.addSignFile(document.input.inFile.value, null, complete, {saveType:1})">서명추가-디폴트위치</button><br/>
	<button onclick="KeySharpBiz.resetCertificate();KeySharpBiz.addSignFile(document.input.inFile.value, null, complete, {saveType:2})">서명추가-입력파일과 같은 위치</button><br/>
	<button onclick="KeySharpBiz.resetCertificate();KeySharpBiz.addSignFile(document.input.inFile.value, null, complete, {saveType:3})">서명추가-사용자선택</button><br/>
	<br>
	<br>
	<a href="index.jsp">[처음으로]</a>
	<a href="javascript:history.back(-1);">[뒤로]</a>
	</div>
	<div id="footer" style="width:96%; margin-left:auto; margin-right:auto  "><div style="border-top:1px solid #eaebec;width:100%;"></div><img src="images/logo_foot.gif" width="174" height="49" style="float:right;"/></div>
</div>

</body>
</html>
