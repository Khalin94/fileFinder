<%@ page import="
    java.util.*,
    kr.co.kcc.bf.bfutil.StringUtil"
%>
<%@ include file="/forum/common/CheckSessionPop.jsp" %>

<%
	String strUserId = (String)session.getAttribute("USER_ID");  //사용자 ID
	String strDocboxId = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVL(request.getParameter("docbox_id"), ""));  //클릭(선택)한 폴더(분류함)ID
	String strOrganId = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVL(request.getParameter("organ_id"), ""));  //클릭(선택)한 폴더(분류함)의 기관ID
%>	
