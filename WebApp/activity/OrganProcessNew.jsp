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
		result=objJoinMemberDelegate.createOrganRel(strOrganID.trim(),strSubOrganID.trim(),strSubOrganNM.trim());		//������� ���� ����
		//�̷����� ���
		result+=objJoinMemberDelegate.insertOrganHistory(strOrganID,"������� ���",strUserID+"���� ���");
	} catch (AppException objAppEx) {
%>
	<script language="javascript">
		alert("������ �߻��Ͽ����ϴ�.");
        history.back();
	</script>
<%
		return;
	}
%>


	<script language="javascript">
	<!--
		if(<%=result%>>0){
			alert("������� ����� �Ϸ�Ǿ����ϴ�.");
		}
            opener.parent.location.href="http://nafs.assembly.go.kr/activity/OrganInfoMng.jsp"
			self.close();
	//-->
	</script>
