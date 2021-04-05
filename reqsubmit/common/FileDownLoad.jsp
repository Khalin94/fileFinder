<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%
	if(session.getAttribute("ORGAN_KIND") == null)
	{
		return;
	}
%>
<jsp:forward page="/servlet/nads.dsdm.app.reqsubmit.servlets.OrgFileDownLoad"/>
