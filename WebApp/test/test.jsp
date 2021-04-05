<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%
	out.println("Remote Addr : " + request.getRemoteAddr()+"<BR>");
	out.println("Remote Host : " + request.getRemoteHost()+"<BR>");
	out.println("Remote User : " + request.getRemoteUser()+"<BR>");
	out.println("Request URI : " + request.getRequestURI()+"<BR>");
	out.println("Request URL : " + request.getRequestURL()+"<BR>");
%>