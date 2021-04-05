<%@page language="java" contentType="text/html;"%>
<%@page import="com.raonsecure.ksbiz.log.KSBizLogger"%>
<%@page import="com.raonsecure.ksbiz.*" %>
<%@page import="com.raonsecure.ksbiz.crypto.*" %>
<%
	KSBiz_v2 ksobj = new KSBiz_v2();
	String orgData = "";
	String errorMsg = "";
	String signData = request.getParameter("ksbizSig");
	String version = "";
	String serialNum = "";
	String serialNumInt = "";
	String signaturealg = "";
	String datebefore = "";
	String dateafter = "";
	String issureDN = "";
	String issuerCN = "";
	String issuerOU = "";
	String issuerO = "";
	String issuerC = "";
	String subjectDN = "";
	String subjectCN = "";
	String subjectOU = "";
	String subjectO = "";
	String subjectC = "";
	String oid = "";
	String vidmsg = "";
	String crldp = "";
	String subjectidentifier = "";
	String subjectkey = "";
	int errorCode=-1;
	
	try 
	{
		ksobj.libInit();
		System.out.println("lib init success");
		
		ksobj.verify(signData);
		errorCode = ksobj.getErrorCode();
		if(errorCode != 0)
		{
			errorMsg = ksobj.getErrorMsg();
		}
		else
		{
			orgData = ksobj.getVerifiedPlainText();
			version = ksobj.getCertInfo(KSBizCertInfo.VERSION);
			serialNum = ksobj.getCertInfo(KSBizCertInfo.SERIALNUM);
			serialNumInt = ksobj.getCertInfo(KSBizCertInfo.SERIALNUMINT);
			signaturealg = ksobj.getCertInfo(KSBizCertInfo.SIGNATUREALG);
			datebefore = ksobj.getCertInfo(KSBizCertInfo.DATEBEFORE);
			dateafter = ksobj.getCertInfo(KSBizCertInfo.DATEAFTER);
			issureDN = ksobj.getCertInfo(KSBizCertInfo.ISSUERDN);
			issuerCN = ksobj.getCertInfo(KSBizCertInfo.ISSUERCN);
			issuerOU = ksobj.getCertInfo(KSBizCertInfo.ISSUEROU);
			issuerO = ksobj.getCertInfo(KSBizCertInfo.ISSUERO);
			issuerC = ksobj.getCertInfo(KSBizCertInfo.ISSUERC);
			subjectDN = ksobj.getCertInfo(KSBizCertInfo.SUBJECTDN);
			subjectCN = ksobj.getCertInfo(KSBizCertInfo.SUBJECTCN);
			subjectOU = ksobj.getCertInfo(KSBizCertInfo.SUBJECTOU);
			subjectO = ksobj.getCertInfo(KSBizCertInfo.SUBJECTO);
			subjectC = ksobj.getCertInfo(KSBizCertInfo.SUBJECTC);
			oid = ksobj.getCertInfo(KSBizCertInfo.OID);
			vidmsg = ksobj.getCertInfo(KSBizCertInfo.VIDMSG);
			crldp = ksobj.getCertInfo(KSBizCertInfo.CRLDP);
			subjectidentifier = ksobj.getCertInfo(KSBizCertInfo.SUBJECTIDENTIFIER);
			subjectkey = ksobj.getCertInfo(KSBizCertInfo.SUBJECTKEY);
		}
	} 
	catch ( Exception e ) 
	{
	    out.print( e.toString() );
	    out.flush();
	    return;
	}
%>
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
<%if(errorCode != 0){ %>
		<h2>서명확인 실패</h2>
		<div><%=errorCode + " : " + errorMsg%></div>
<%}else{ %>
		<h2>서명확인 성공</h2>
<%}%>
		<h3>서명 데이터</h3>
		<ul>
		<li>signData : <%=signData%></li>
		<li>서명원문 : <%=orgData%></li>
		</ul>
<%if(subjectDN!=null && !"".equals(subjectDN)){ %>
		<div>
		<h3>인증서 정보</h3>
		<ul>
		<li>버전 : <%=version%></li>
		<li>발급자 : <%=issureDN%></li>
		<li>주체 : <%=subjectDN%></li>
		<li>시리얼번호 : <%=serialNum%></li>
		<li>시리얼번호(10진수) : <%=serialNumInt%></li>
		<li>유효기간 : <%=datebefore%> ~ <%=dateafter%></li>
		<li>OID : <%=oid%></li>
		<li>서명알고리즘 : <%=signaturealg%></li>
		<li>VID 메시지 : <%=vidmsg%></li>
		<li>CRL 배포지점 : <%=crldp%></li>
		<li>주체키 식별자 : <%=subjectidentifier%></li>
		<li>공개키 : <%=subjectkey%></li>
		</ul>
		</div>
<%}%>
		<br>
		<br>
		<a href="index.jsp">[처음으로]</a>
		<a href="javascript:history.back(-1);">[뒤로]</a>
	</div>
	<div id="footer" style="width:96%; margin-left:auto; margin-right:auto  "><div style="border-top:1px solid #eaebec;width:100%;"></div><img src="images/logo_foot.gif" width="174" height="49" style="float:right;"/></div>
</div>

</body>
</html>
