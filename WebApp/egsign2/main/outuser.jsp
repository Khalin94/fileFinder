<%@ page contentType="text/html; charset=euc-kr" language="java"%>
<%@ page import="nads.lib.reqsubmit.encode.Base64Code"%>
<%@ page import="nads.lib.reqsubmit.util.HashEncrypt"%>


<%
	String id = (String)session.getAttribute("id");
	String pwd = (String)session.getAttribute("pwd");
    Base64Code objBase64Code = new Base64Code();

    byte[] bPwd = objBase64Code.decode(pwd);
    String sPwd = new String(bPwd);

	id = HashEncrypt.encrypt(id);
	sPwd = HashEncrypt.encrypt(sPwd);
	
	System.out.println("outuser id  : "+id);
	System.out.println("outuser pwd  : "+sPwd);
	
	System.out.println("outuser id  : "+(String)session.getAttribute("id"));
	System.out.println("outuser pwd  : "+pwd);
%>

<form name="form1" action="http://nafs.assembly.go.kr/login/Login4ReSessionOuterProc.jsp" method="post">
    <input type="hidden" name="USER_ID" value="<%=id%>">
    <input type="hidden" name="PWD" value="<%=sPwd%>">
</form>

<script language="javascript">
document.form1.submit();
</script>
