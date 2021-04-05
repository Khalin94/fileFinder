<%@page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="com.raonsecure.ksbiz.log.KSBizLogger"%>
<%@ page import="com.raonsecure.ksbiz.*" %>
<%@ page import="com.raonsecure.ksbiz.crypto.*" %>

<%
	KSBiz_v2 ksobj = new KSBiz_v2();
	String signData = request.getParameter("ksbizSig");
	String version = "";
	String serialNum = "";
	String signaturealg = "";
	String datebefore = "";
	String dateafter = "";
	String issureDN = "";
	String subjectDN = "";
	String oid = "";
	String vidmsg = "";
	String crldp = "";
	String subjectidentifier = "";
	String subjectkey = "";
	String orgData = "";
	String errorMsg = "";
	String errorMsg_ocsp = "";
	String errorMsg_crl = "";
	int errorCode=-1;
	int errorCode_ocsp=-1;
	int errorCode_crl=-1;
	
	try 
	{
		ksobj.libInit();
		System.out.println("lib init success");
		
		ksobj.verifym(signData);
		errorCode = ksobj.getErrorCode();
		if(errorCode != 0)
		{
			errorMsg = ksobj.getErrorMsg();
		}
		else
		{
			byte[] signCert = ksobj.getSignedCert();
			
			ksobj.verifyPvdOCSP(signCert);
			errorCode_ocsp = ksobj.getErrorCode();
			if(errorCode_ocsp != 0){
				errorMsg_ocsp = ksobj.getErrorMsg();
			}
			
			ksobj.verifyPvdCRL(signCert);
			errorCode_crl = ksobj.getErrorCode();
			if(errorCode_crl != 0){
				errorMsg_crl = ksobj.getErrorMsg();
			}
			
			orgData = ksobj.getVerifiedPlainText();
			version = ksobj.getCertInfo(KSBizCertInfo.VERSION);
			serialNum = ksobj.getCertInfo(KSBizCertInfo.SERIALNUM);
			signaturealg = ksobj.getCertInfo(KSBizCertInfo.SIGNATUREALG);
			datebefore = ksobj.getCertInfo(KSBizCertInfo.DATEBEFORE);
			dateafter = ksobj.getCertInfo(KSBizCertInfo.DATEAFTER);
			issureDN = ksobj.getCertInfo(KSBizCertInfo.ISSUERDN);
			subjectDN = ksobj.getCertInfo(KSBizCertInfo.SUBJECTDN);
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
<%if(errorCode != 0){ %>
		<h2>서명검증 실패</h2>
		<div><%=errorCode + " : " + errorMsg%></div>
<%}else{ %>
		<h2>서명검증 성공</h2>
<%}%>

<%
  // OCSP 인증서 검증 결과
  if(errorCode_ocsp != 0){ %>
		<h2>OCSP 인증서 검증 실패</h2>
		<div><%=errorCode_ocsp + " : " + errorMsg_ocsp%></div>
<%}else{ %>
		<h2>OCSP 인증서 검증 성공</h2>
<%}%>

<%
  //CRL 인증서 검증 결과
  if(errorCode_crl != 0){ %>
		<h2>CRL 인증서 검증 실패</h2>
		<div><%=errorCode_crl + " : " + errorMsg_crl%></div>
<%}else{ %>
		<h2>CRL 인증서 검증 성공</h2>
<%}%>

		<h3>서명 데이터</h3>
		<ul>
		<li>signData : <%=signData%></li>
		<li>서명원문 : <%=orgData%></li>
		</ul>
<%if(subjectDN!=null){ %>
		<div>
		<h3>인증서 정보</h3>
		<ul>
		<li>버전 : <%=version%></li>
		<li>발급자 : <%=issureDN%></li>
		<li>주체 : <%=subjectDN%></li>
		<li>시리얼번호 : <%=serialNum%></li>
		<li>유효기간 : <%=datebefore%> ~ <%=dateafter%></li>
		<li>OID : <%=oid%></li>
		<li>서명알고리즘 : <%=signaturealg%></li>
		<li>vidmsg : <%=vidmsg%></li>
		<li>crldp : <%=crldp%></li>
		<li>subjectidentifier : <%=subjectidentifier%></li>
		<li>subjectkey : <%=subjectkey%></li>
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
