<%
	//�������� üũ�� ������ �α��� �������� Redirect
	if(session.getAttribute("ORGAN_KIND") == null) {
		out.println("<script language=javascript>");
        out.println("self.window.close();");
        out.println("opener.location.href='/login/Login4ReSession.jsp';");
        out.println("</script>");
	}
	if(!((String)request.getHeader("Proxy-Client-IP")).equals((String)session.getAttribute("CHECKIP"))){

		session.invalidate();
		response.sendRedirect("/index.html");

	}
%>