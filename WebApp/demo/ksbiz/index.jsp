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
	function complete_isInstall(result){
		if(result){
			alert("[컨트롤 설치확인] 설치");
		}else{
			alert("[컨트롤 설치확인] 미설치");
		}			
	}
</script>
</head>

<body>
<div id="wrapper" style="width:100%;">
<form id="ksbizForm" name="ksbizForm" method="post" action="">	
	<input type="hidden" id="ksbizEnc"  name="ksbizEnc"/>
</form>
 <div id="header" style="background-image:url('images/bg_head.gif');width:100%; height:43px;">
  <img src="images/logo_head.gif" width="187" height="43" style="float:right;"/>
 
 </div>
 <div style="background-color:#eaebec; padding:0;">
  <img src="images/img_top_main01.gif" width="234" height="264" style="float:left;"/><img src="images/img_top_main02.gif"/>
 </div>

 <div style="padding:30px 240px" >
 	<ul>
   		<li style="margin-bottom: 5px"><a href="sample_tk_crt.jsp">보안키패드 샘플(라온 native) </a></li> 
		<li style="margin-bottom: 5px"><a href="transkey.jsp">보안키패드 샘플(라온 HTML5)</a></li>
		<br>
		<li style="margin-bottom: 5px"><a href="testChannelEncrypt.jsp">채널암호화 테스트</a></li>
		<br>
		<li style="margin-bottom: 5px"><a href="#" onclick="KeySharpBiz.getVersion(function(version){ alert(JSON.stringify(version)); });">모듈 버전</a></li>
		<li style="margin-bottom: 5px"><a href="#" onclick="KeySharpBiz.isInstall(false, complete_isInstall);return false;">모듈 설치체크</a></li>
		<li style="margin-bottom: 5px">
			<a href="#" onclick="KeySharpBiz.setLang('KOR');">한국어</a>
			<a href="#" onclick="KeySharpBiz.setLang('ENG');">영어</a>
			<a href="#" onclick="KeySharpBiz.setLang('CHN');">중국어</a>
			<a href="#" onclick="KeySharpBiz.setLang('JPN');">일본어</a>
		</li>
		<!-- li style="margin-bottom: 5px"><a href="#"><font color="red">resetConfigure - 함수미존재</font></a></li -->
		<li style="margin-bottom: 5px"><a href="#" onclick="KeySharpBiz.getMACAddress(function(data){alert(data);});">MAC주소 얻기 - callback으로만 받을수 있음</a></li>
   	</ul>
   	<img src="./images/line.gif" width="563" height="9" border="0" alt="line">
	<ul>
		<li style="margin-bottom: 5px"><a href="#" onclick="KeySharpBiz.manageCertificate();">인증서 관리</a></li>
		<li style="margin-bottom: 5px"><a href="#" onclick="KeySharpBiz.manageCertificate(function(result){alert(result);});">인증서 관리-complete</a></li>
		<li style="margin-bottom: 5px"><a href="#" onclick="KeySharpBiz.resetCertificate();">인증서 캐시 삭제</a></li>
		<li style="margin-bottom: 5px"><a href="#" onclick="KeySharpBiz.resetCertificate(function(result){alert(result);});">인증서 캐시 삭제-complete</a></li>
   	</ul>
   	<img src="./images/line.gif" width="563" height="9" border="0" alt="line">
   	<ul>
   		<li style="margin-bottom: 5px"><a href="sign.jsp">전자서명</a></li>
   		<li style="margin-bottom: 5px"><a href="signOcspCrl.jsp">전자서명(OCSP, CRL 별도 검증)</a></li>
   		<li style="margin-bottom: 5px"><a href="vidcheck.jsp">본인확인</a></li>
   		<br>
   		<li style="margin-bottom: 5px"><a href="login.jsp">로그인</a></li>
		<li style="margin-bottom: 5px"><a href="login-subjectCertFilter.jsp">로그인(subjectCertFilter)</a></li>
		<br>
		<li style="margin-bottom: 5px"><a href="autologin.jsp">로그인 (auto)</a></li>
		<li style="margin-bottom: 5px"><a href="autosign.jsp">전자서명 (auto)</a></li>
		<li style="margin-bottom: 5px"><a href="autovidcheck.jsp">본인확인 (auto)</a></li>
		<br>
		<li style="margin-bottom: 5px"><a href="multiSign.jsp">다중전자서명</a></li>
		<br>
		<li style="margin-bottom: 5px"><a href="mdSign.jsp">pdf검증 서명</a></li>
		<li style="margin-bottom: 5px"><a href="pkcs1Sign.jsp">코스콤서명-축약서명(PKCS#1)</a></li>
		<li style="margin-bottom: 5px"><a href="signedDataSign.jsp">코스콤서명-풀서명(signedData)</a></li>
   	</ul>
   	<img src="./images/line.gif" width="563" height="9" border="0" alt="line">
	<ul>
		<li style="margin-bottom: 5px"><a href="confirmSign-form.jsp">데이터표시 전자서명 (폼)</a></li>
		<li style="margin-bottom: 5px"><a href="confirmSign-formstring.jsp">데이터표시 전자서명 (form-urlencoding문자열)</a></li>
		<li style="margin-bottom: 5px"><a href="confirmSign-strings.jsp">데이터표시 전자서명 (문자열)</a></li>
		<br>
		<li style="margin-bottom: 5px"><a href="confirmMultiSign-formstring.jsp">데이터표시 다중전자서명 (form-urlencoding문자열)</a></li>
		<li style="margin-bottom: 5px"><a href="confirmMultiSign-strings.jsp">데이터표시 다중전자서명 (문자열)</a></li>
	</ul>
   	<img src="./images/line.gif" width="563" height="9" border="0" alt="line">
	<ul>
		<li style="margin-bottom: 5px"><a href="cmp.jsp">cmp</a></li>
	</ul>
   	<img src="./images/line.gif" width="563" height="9" border="0" alt="line">
   	<br>[파일 관련]
   	<br><br>로컬
   	<ul>
   		<li style="margin-bottom: 5px"><a href="signfile.jsp">파일 서명</a></li>
   		<li style="margin-bottom: 5px"><a href="addSignFile.jsp">파일서명-서명자 추가</a></li>
   		<!--li style="margin-bottom: 5px"><a href="channelEncryptFile.jsp">파일암호화</a></li>
   		<li style="margin-bottom: 5px"><a href="channelDecryptFile.jsp">파일복호화</a></li>
   		<li style="margin-bottom: 5px"><a href="passwordEncryptFile.jsp">파일 패스워드 암복호화</a></li-->
   		<li style="margin-bottom: 5px"><a href="compressFile.jsp">파일 압축</a></li>
   	</ul>
   	<br><br>업로드
   	<ul>
   		<li style="margin-bottom: 5px"><a href="signFileUrl.jsp">파일 서명 업로드</a></li>
   		<!--li style="margin-bottom: 5px"><a href="channelEncryptFileUrl.jsp">파일 채널 암호화 업로드</a></li>
   		<li style="margin-bottom: 5px"><a href="passwordEncryptFileUrl.jsp">파일 패스워드 암호화 업로드</a></li>
   		<li style="margin-bottom: 5px"><a href="signAndChannelEncryptFileUrl.jsp">파일 압축/서명/암호화 업로드 </a></li-->
   		<li style="margin-bottom: 5px"><a href="addSignFileUrl.jsp">파일 서명 추가 다운로드 및 업로드</a></li>
   	</ul>
   	<!--br>다운로드
   	<ul>
   		<li style="margin-bottom: 5px"><a href="channelDecryptFileUrl.jsp">파일 채널 암호화 다운 로드</a></li>
   		<li style="margin-bottom: 5px"><a href="passwordDecryptFileUrl.jsp">파일 패스워드 복호화 다운 로드 </a></li-->
   	</ul>
	<br><br>
   
</div>

 <div id="footer" style="width:96%; margin-left:auto; margin-right:auto  "><div style="border-top:1px solid #eaebec;width:100%;"></div><img src="images/logo_foot.gif" width="174" height="49" style="float:right;"/></div>
</div>

</body>
</html>
