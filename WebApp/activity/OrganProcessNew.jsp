<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<jsp:include page="/inc/header.jsp" flush="true"/>
<link href="/css2/style.css" rel="stylesheet" type="text/css">

<%


	String strOrganID 		= StringUtil.getNVLNULL(request.getParameter("strOrganID")).trim();
	String strSubOrganID 		= StringUtil.getNVLNULL(request.getParameter("strSubOrganID")).trim();
	String strSubOrganNM 		= StringUtil.getNVLNULL(request.getParameter("strSubOrganNM")).trim();
	String strUserID = StringUtil.getNVLNULL(request.getParameter("strUserID")).trim();

    System.out.println("strOrganID"+strOrganID);
    System.out.println("strSubOrganID"+strSubOrganID);
    System.out.println("strSubOrganNM"+strSubOrganNM);
    System.out.println("strUserID"+strUserID);


	nads.dsdm.app.join.JoinMemberDelegate objJoinMemberDelegate = new nads.dsdm.app.join.JoinMemberDelegate();
	int result=0;
	try {
		result=objJoinMemberDelegate.createOrganRel(strOrganID.trim(),strSubOrganID.trim(),strSubOrganNM.trim());		//하위기관 관계 생성
		//이력정보 기록
		result+=objJoinMemberDelegate.insertOrganHistory(strOrganID,"하위기관 등록",strUserID+"님이 등록");
	} catch (AppException objAppEx) {
%>
	<script language="javascript">
		alert("에러가 발생하였습니다.");
        history.back();
	</script>
<%
		return;
	}
%>


	<script language="javascript">
	<!--
		if(<%=result%>>0){
			alert("하위기관 등록이 완료되었습니다.");
		}
            opener.parent.location.href="http://nafs.assembly.go.kr/activity/OrganInfoMng.jsp"
			self.close();
	//-->
	</script>
