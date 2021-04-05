<%@page language="java" contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<%@page import="com.raonsecure.ksbiz.*"%>
<%@page import="com.raonsecure.ksbiz.log.*"%>
<%
response.setHeader("Access-Control-Allow-Methods", "POST, GET, OPTIONS, DELETE");
response.setHeader("Access-Control-Max-Age", "3600");
response.setHeader("Access-Control-Allow-Headers", "x-requested-with");
response.setHeader("Access-Control-Allow-Origin", "*");
%>
<%
	String sid = (String)session.getAttribute("KSBIZ_SID");
	KSBiz_v2 ksobj = new KSBiz_v2();
	
	String decryptData="";
	String serverEncData="";
	String serverEncData1="";
	String encryptedData="";
	int errorCode = -1;
	String errMsg = "";

	try 
	{
		ksobj.libInit();
		System.out.println("lib init success");

		encryptedData = request.getParameter("ksbizEnc");
		decryptData = ksobj.decodeEnv(encryptedData, sid);
		errorCode = ksobj.getErrorCode();
		
		if(errorCode != 0)
		{
			throw new KSBizException("DecodeEnv Failed", errorCode);
		}
		
		serverEncData = ksobj.encodeResScriptAsync("이 데이터는 서버에서 암호화한 데이터입니다. : " + decryptData);
		serverEncData1 = ksobj.encodeResScriptAsync("이 데이터는 서버에서 암호화한 데이터입니다.(콜백) : " + decryptData, "complete_decrypt");
		errorCode = ksobj.getErrorCode();
		
		if(errorCode != 0)
		{
			throw new KSBizException("EncodeResScript Failed", errorCode);
		}
	}
	catch(KSBizException e) 
	{
		errMsg = e.getMessage();
		System.out.println("KSBException occured : " + e.getMessage() + "("+ e.getErrorCode() + ")");
		ksobj.close();
	}
%>
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
	function complete_decrypt(result, context){
		if(result.status==1){
			document.getElementById(context).outerHTML = result.data;
		}
		else if(result.status!=0){
			alert("복호화 실패:" + result.message + ":" + result.status);
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
	<h1>암호화 테스트</h1>
	<ul>
		<li>sid : <%=sid%></li>
		<li>request encryptedData : <%=encryptedData%></li>
		<li>request decryptedData : <%=decryptData%></li>
<%
	if(!"".equals(errMsg))
	{
%>
		<li>복호화 오류 : <%=errMsg%></li>
<%
	}
%>
	</ul>
	<hr/>
	<ul>
		<li>Response 복호화 : <%=serverEncData%></li>
		<li>Response 복호화 :  <%=serverEncData1%></li>
	</ul>
	<br/><br/>
	<a href="index.jsp">[처음으로]</a>
	<a href="javascript:history.back(-1);">[뒤로]</a>
	</div>
	<div id="footer" style="width:96%; margin-left:auto; margin-right:auto  "><div style="border-top:1px solid #eaebec;width:100%;"></div><img src="images/logo_foot.gif" width="174" height="49" style="float:right;"/></div>
</div>

</body>
</html>
