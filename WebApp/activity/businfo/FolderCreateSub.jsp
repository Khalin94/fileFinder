<%@ page import="
    java.util.*,
    kr.co.kcc.bf.bfutil.StringUtil"
%>
<%@ include file="/forum/common/CheckSessionPop.jsp" %>

<%
	String strUserId = (String)session.getAttribute("USER_ID");  //����� ID
	String strDocboxId = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVL(request.getParameter("docbox_id"), ""));  //Ŭ��(����)�� ����(�з���)ID
	String strOrganId = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVL(request.getParameter("organ_id"), ""));  //Ŭ��(����)�� ����(�з���)�� ���ID
%>	
