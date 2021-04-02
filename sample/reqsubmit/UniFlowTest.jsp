<%
	String strTmpRegDt = "20040911AAAA";
	strTmpRegDt = strTmpRegDt.substring(0, 4)+"."+strTmpRegDt.substring(4, 6)+"."+strTmpRegDt.substring(6, 8);
	out.println(strTmpRegDt);
%>