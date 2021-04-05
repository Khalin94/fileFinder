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
			}else if(result.status==0){
				alert("������ ������ ����Ͽ����ϴ�.");
			}else if(result.status == -10301){
				//�����ü ��ġ�� ���� ���ڼ���â�� ������ ���
			}else if(result.status!=0){
				alert("���ڼ��� ����:" + result.message + "[" + result.status + "]");
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
	<h1>���ڼ���</h1>
	<br/>
	<a href="#" onclick="KeySharpBiz.setLang('KOR');return false;">�ѱ���</a>
	<a href="#" onclick="KeySharpBiz.setLang('ENG');return false;">����</a>
	<a href="#" onclick="KeySharpBiz.setLang('CHN');return false;">�߱���</a>
	<a href="#" onclick="KeySharpBiz.setLang('JPN');return false;">�Ϻ���</a>
   	<br/>

	<h4>�� �Է°�</h4>
    <form id="inputform" name="inputform" method="post" action="/demo/ksbiz/signAction.jsp">
    - �������<br>
    <input type="text" id="plain" name="plain" value="�����ٶ�1234ABCD"/>
	</form>

	<hr/>
	<h4>�� ��°�</h4>
   	<form id="ksbizForm" name="ksbizForm" method="post" action="">
   		- ���ڼ��� �޽���<br>
   		<textarea id="ksbizSig" name="ksbizSig" cols="100" rows="5"></textarea>
   	</form>
	<br/>
	���ڼ��� �˰���: RSA_V15��� <input type="checkbox" id="signAlgorithm" name="signAlgorithm" value="rsaEncryption" onclick="checkSignAlgorithm();">(�⺻��: RSA_PSS)<br>
	<button onclick="KeySharpBiz.sign(document.getElementById('plain').value, complete_sign);return false">���ڼ���</button>
	<button onclick="KeySharpBiz.sign(document.getElementById('plain').value, complete_sign, {cacheCertFilter:false, cacheCert:false});return false;">���ڼ���(��� ������ǥ��)</button>
	<button onclick="KeySharpBiz.sign(document.getElementById('plain').value, {complete:complete_sign_context, context:'String, Object ���ް���'});return false;">���ڼ���(�ݹ鿡 context ���)</button>
	<button onclick="send();return false;">������ ����</button>
	<br>
	<br>
	<a href="index.jsp">[ó������]</a>
	<a href="javascript:history.back(-1);">[�ڷ�]</a>
	</div>
	<div id="footer" style="width:96%; margin-left:auto; margin-right:auto  "><div style="border-top:1px solid #eaebec;width:100%;"></div><img src="images/logo_foot.gif" width="174" height="49" style="float:right;"/></div>
</div>

</body>
</html>
