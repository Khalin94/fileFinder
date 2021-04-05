<%@page language="java" contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.raonsecure.ksbiz.*" %>
<%@ page import="com.raonsecure.ksbiz.servlet.*" %>
<%@ page import="com.raonsecure.ksbiz.util.*" %>
<%@ page import="com.raonsecure.ksbiz.crypto.*" %>

<%
	String orgData = "";
	String idn= "";
	String signData = "";
	String vidRandom = "";

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
	
	String errorMsg1 = "";
	String errorMsg2 = "";
	String errorMsg3 = "";
	int    errorCode1=-1;
	int    errorCode2=-1;

	KSBiz_v2 ksobj = null;
	try 
	{
		ksobj = new KSBiz_v2();
		ksobj.libInit();
		System.out.println("lib init success");
		
		idn = request.getParameter("idn");
		signData = request.getParameter("ksbizSig");
		vidRandom = request.getParameter("ksbizVidRandom");
		
		// 1. 전자서명 검증
		ksobj.verify(signData);
		errorCode1 = ksobj.getErrorCode();
		
		if(errorCode1 != 0)
		{
			errorMsg1 = ksobj.getErrorMsg();
		}
		else
		{
			vidmsg = ksobj.getCertInfo(KSBizCertInfo.VIDMSG);
			// 2. 본인확인(VID) 검증
			ksobj.verifyIdv(vidmsg, vidRandom, idn);
			System.out.println("vidmsg : " + vidmsg);
			System.out.println("vidRandom : " + vidRandom);
			System.out.println("idn : " + idn);
			
			errorCode2 = ksobj.getErrorCode();
			if(errorCode2 != 0)
			{
				errorMsg2 = ksobj.getErrorMsg();
			}
			else
			{
				orgData = ksobj.getVerifiedPlainText();
				version = ksobj.getCertInfo(KSBizCertInfo.VERSION);
				serialNum = ksobj.getCertInfo(KSBizCertInfo.SERIALNUM);
				signaturealg = ksobj.getCertInfo(KSBizCertInfo.SIGNATUREALG);
				datebefore = ksobj.getCertInfo(KSBizCertInfo.DATEBEFORE);
				dateafter = ksobj.getCertInfo(KSBizCertInfo.DATEAFTER);
				issureDN = ksobj.getCertInfo(KSBizCertInfo.ISSUERDN);
				subjectDN = ksobj.getCertInfo(KSBizCertInfo.SUBJECTDN);
				oid = ksobj.getCertInfo(KSBizCertInfo.OID);
				crldp = ksobj.getCertInfo(KSBizCertInfo.CRLDP);
				subjectidentifier = ksobj.getCertInfo(KSBizCertInfo.SUBJECTIDENTIFIER);
				subjectkey = ksobj.getCertInfo(KSBizCertInfo.SUBJECTKEY);
				
				String temp = KSBizStringUtil.getSplitData(orgData, "ksbizNonce");
				// 3. ReplayAttack확인을 위해 서명원문에 있는 ksbizNonce값과 nonce 생성시 세션에 등록된 KSBIZ_NONCE값을 비교한다.
				if(session.getAttribute("KSBIZ_NONCE") == null || !session.getAttribute("KSBIZ_NONCE").equals(temp))
				{
					errorMsg3 = "nonce검증오류!!! 서명문이 재사용되었습니다.";
				}
			}
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
<%if(errorCode1 != 0){ %>
	<h1>서명검증 실패</h1>
	<div><%=errorCode1 + " : " + errorMsg1%></div>
<%}else{ %>
	<h1>서명검증 성공</h1>

	<%if(!"".equals(errorMsg3)){ %>
		<h2><%=errorMsg3%></h2>
	<%}else{ %>
		<h2>nonce확인 성공</h2>
	<%} %>
<%} %>

<%if(errorCode2 != 0){ %>
	<h2>본인확인 실패</h2>
	<div><%=errorCode2 + " : " + errorMsg2%></div>
<%}else{ %>
	<h2>본인확인 성공</h2>
<%} %>

	<div>
	<h3>서명 데이터</h3>
	<ul>
	<li>signData : <%=signData%></li>
	<li>서명원문 : <%=orgData%></li>
	</ul>
	</div>

<%if(subjectDN!=null && !"".equals(subjectDN)){ %>
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
