<%@ page contentType="text/html; charset=euc-kr" language="java"%>
<% //page import = "com.hitlive.collection.*" %>
<% //page import = "common.util.HashEncrypt" %>
<% //page import = "common.util.Base64Code" %>
<% //page import = "common.util.Base64Code" %>
<%@ page import="nads.lib.reqsubmit.encode.*" %>
<%@ page import="nads.lib.reqsubmit.util.HashEncrypt" %>


<%
System.out.println("1111111111111");
	//String strFlag = (String)session.getAttribute("systemgubun"); 
	String id = (String)session.getAttribute("id");
	String pwd = (String)session.getAttribute("pwd");
        System.out.println("outuser id  : "+id);
	System.out.println("outuser id  : "+pwd);
    Base64Code objBase64Code = new Base64Code();

    byte[] bPwd = objBase64Code.decode(pwd);
    String sPwd = new String(bPwd);

	id = HashEncrypt.encrypt(id);
	sPwd = HashEncrypt.encrypt(sPwd);

	//System.out.println("strFlag : " + strFlag);
	
	System.out.println("outuser id  : "+id);
	System.out.println("outuser pwd  : "+sPwd);
	
	System.out.println("outuser id  : "+(String)session.getAttribute("id"));
	System.out.println("outuser pwd  : "+pwd);
	session.setAttribute("USER_ID",id);
	session.setAttribute("PWD",sPwd);
%>

<form name="form1" action="/login/Login4ReSessionOuterProc.jsp" method="post">
</form>

<form name="form2" action="http://nafs.assembly.go.kr:82/index.jsp" method="post">
    <input type="hidden" name="user_id" value="<%=(String)session.getAttribute("id")%>">
    <input type="hidden" name="pswd" value="<%=pwd%>">
	<input type="hidden" name="task" value="com.Usr.command.FS_UsrR10Cmd">
</form>
<script language="javascript">
<%//if(strFlag.equals("DS")){%>
document.form1.submit();
<%//}else if(strFlag.equals("FS")){%>
//document.form2.submit();
<%//}%>
</script>
