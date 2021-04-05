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
	  <h1>암호화 테스트</h1>
	문자열 원문 : 가나다라1234ABCD<br>
	<button onclick="KeySharpBiz.channelEncrypt({data:'가나다라1234ABCD', action:'channelEncryptAction.jsp', target:'_self'}/*, complete_encrypt*/);return false;">문자열 암호화후 전송</button>
	
	<hr/>
	<form id="inputform" name="inputform" method="post" action="channelEncryptAction.jsp">
			name1 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; : <input type="text" id="name1" name="name1" value="abcd"/><br/>
			name2 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; : <input type="text" id="name2" name="name2" value="가나다라"/>
	</form>
	<form id="ksbizForm" name="ksbizForm" method="post" action="">	
		암호화 데이터 : <input type="text" id="ksbizEnc"  name="ksbizEnc"/>
	</form>
	암호화 알고리즘: RSA_V15사용 <input type="checkbox" id="encAlgorithm" name="encAlgorithm" value="rsaEncryption" onclick="checkAlgorithm();">(기본값: RSA_OAEP)<br/>
	<button onclick="KeySharpBiz.channelEncrypt(document.inputform, complete_encrypt);return false;">암호화</button>
	<button onclick="KeySharpBiz.channelEncrypt(document.inputform, {complete:complete_encrypt_context, context:'String, Object 전달가능'});return false;">암호화(콜백에 context 사용)</button>
	<button onclick="send();return false;">서버로 전송</button><br/>
	<button onclick="KeySharpBiz.channelEncrypt(document.inputform);return false;">암호화후 전송</button>
	
	<hr/>
	<a href="channelEncryptAction.jsp" onclick="KeySharpBiz.channelEncrypt(this);return false;">링크 암호화-쿼리스트링 없음</a><br/>
	<a href="channelEncryptAction.jsp?name1=abcd&name2=1234" onclick="KeySharpBiz.channelEncrypt(this);return false">링크 암호화-쿼리스트링 있음</a>
	
	<script type="text/javascript">
		function complete_encrypt(result){
			
			if(result.status==1){
				document.getElementById("ksbizEnc").value = result.data;
			}
			else if(result.status!=0){
				alert("암호화 실패:" + result.message + ":" + result.status);
			}
		}
		
		function complete_encrypt_context(result, context){
			alert("context:" + context);
			if(result.status==1){
				document.getElementById("ksbizEnc").value = result.data;
			}
			else if(result.status!=0){
				alert("암호화 실패:" + result.message + ":" + result.status);
			}
		}
		
		function send()
		{
			document.getElementById("ksbizForm").action = document.getElementById("inputform").action;
			document.getElementById("ksbizForm").submit();
		}

		function checkAlgorithm(){
			if(document.getElementById("encAlgorithm").checked){
				KSBizConfig.cmsKeyEncryptionAlgorithm = "rsaEncryption";
			}else{
				KSBizConfig.cmsKeyEncryptionAlgorithm = "rsaOAEP";
			}
		}
	</script>
	<br/><br/>
<a href="index.jsp">[처음으로]</a>
<a href="javascript:history.back(-1);">[뒤로]</a>
	</div>
	<div id="footer" style="width:96%; margin-left:auto; margin-right:auto  "><div style="border-top:1px solid #eaebec;width:100%;"></div><img src="images/logo_foot.gif" width="174" height="49" style="float:right;"/></div>
</div>

</body>
</html>
