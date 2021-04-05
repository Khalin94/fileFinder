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
	font-family: "����";
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
			alert("������ ������ ����Ͽ����ϴ�.");
		}else if(result.status == -10301){
			//�����ü ��ġ�� ���� ���ڼ���â�� ������ ���
		}else if(result.status!=0){
			alert("���ڼ��� ����:" + result.message + "[" + result.status + "]");
		}
	}

	function complete_sign_context(result, context){
		alert("context:" + context);
		if(result.status==1){			
			document.getElementById("ksbizSig").value = result.data;
		}else if(result.status == 0){
			alert("������ ������ ����Ͽ����ϴ�.");
		}else if(result.status == -10301){
			//�����ü ��ġ�� ���� ���ڼ���â�� ������ ���
		}else if(result.status != 0){
			alert("���ڼ��� ����:" + result.message + "[" + result.status + "]");
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
	  <h2>�α���</h2>
	<br/>
	<a href="#" onclick="KeySharpBiz.setLang('KOR');return false;">�ѱ���</a>
	<a href="#" onclick="KeySharpBiz.setLang('ENG');return false;">����</a>
	<a href="#" onclick="KeySharpBiz.setLang('CHN');return false;">�߱���</a>
	<a href="#" onclick="KeySharpBiz.setLang('JPN');return false;">�Ϻ���</a>
   	<br/>
   	<form id="frm" name="frm" method="post" action="result.jsp">
	pwd1 : <input type="password" id="pwd" name="pwd" /><br/>
</form>
   	<form name="ksbizForm" id="ksbizForm" method="post" action="/demo/ksbiz/signAction.jsp">
		<input type="hidden" id="ksbizEnc" name="ksbizEnc" value="">
	</form>
   	<form id=inputform name="inputform" method="post" action="/demo/ksbiz/signAction.jsp">
   		<h4>�� ��°�</h4>
		- ���ڼ��� �޽���<br/>
   		<textarea id="ksbizSig" name="ksbizSig" cols="100" rows="5"></textarea><br/>
   		���ڼ��� �˰���: RSA_V15��� <input type="checkbox" id="signAlgorithm" name="signAlgorithm" value="rsaEncryption" onclick="checkSignAlgorithm();">(�⺻��: RSA_PSS)<br>
		<button onclick="KeySharpBiz.login('', complete_sign);return false;">������ �α���</button>
		<button onclick="KeySharpBiz.login('', {complete:complete_sign_context, context:'String, Object ���ް���'});return false;">������ �α���(�ݹ鿡 context ���)</button>
		<button onclick="KeySharpBiz.autoLogin('', complete_sign);return false;">������ �α���(auto)</button>
		<button onclick="send();return false;">������ ����</button><br/>
	</form>
	<br>
	<br>
	<a href="index.jsp">[ó������]</a>
	<a href="javascript:history.back(-1);">[�ڷ�]</a>
	</div>
	<div id="footer" style="width:96%; margin-left:auto; margin-right:auto  "><div style="border-top:1px solid #eaebec;width:100%;"></div><img src="images/logo_foot.gif" width="174" height="49" style="float:right;"/></div>
</div>

</body>
</html>
