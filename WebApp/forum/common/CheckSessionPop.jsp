<%
	//세션정보 체크후 없으면 로그인 페이지로 Redirect
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