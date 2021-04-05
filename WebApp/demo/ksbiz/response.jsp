<%@page language="java" contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content = "text/html; charset=utf-8">
<meta http-equiv="Cache-control" content = "no-cache">
<meta http-equiv="Pragma" content = "no-cache">
<title>KeySharpBiz2.1 Demo</title>
<style type="text/css">
body,td,th {
	font-family: "돋움";
	font-size: 12px;
}
body {
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
}
</style>
<%@ include file="../../raonnx/jsp/raonnx.jsp" %>
<script type='text/javascript'>
	function send_org()
	{
		document.frm.action = "response.jsp";
		document.frm.submit();
	}
	
	function encryptCallback(result)
	{
		if(result.status==1)
		{
			alert("CallBack 재정의함수(encryptCallback) 호출");
			document.getElementById("ksbizForm").action = "decrypt.jsp";
			document.getElementById("ksbizEnc").value = result.data;
			document.getElementById("ksbizForm").submit();
		}
		else if(result.status!=0)
		{
			alert("encrypt error:" + result.message + "[" + result.status + "]");
		}
	}
</script>
</head>

<body leftmargin="0" topmargin="0">
<div id="wrapper" style="width:100%;">

	<div id="header" style="background-image:url('images/bg_head.gif');width:100%; height:43px;">
		<img src="images/logo_head.gif" width="187" height="43" style="float:right;"/>
	
	</div>
	<div style="background-color:#eaebec; padding:0;">
		<img src="images/img_top_sub01.gif" width="234" height="185" style="float:left;"/><img src="images/img_top_main02.gif"/>
	</div>
	<div style="padding:30px 70px" >
	<h1>평문전송 결과</h1>
		<FORM name="ksbizForm" id="ksbizForm" method="post" action="decrypt.jsp">
		<INPUT type="hidden" id="ksbizEnc" name="ksbizEnc" value="">
		</FORM>
		
		<table border="0" cellspacing="0" cellpadding="30" height="100%" width="100%">
		  <tr> 
		    <td>
		      <table width="680" border="0" cellspacing="0" cellpadding="0">
				<TR>
					<TD>
						<b>1. textbox 전송데이터</b>
					</TD>
				</TR>
				<TR>
					<TD>
						textbox1 : <%= request.getParameter("textbox1")%><br>
						textbox2 : <%= request.getParameter("textbox2")%>
					</TD>
				</TR>
				<TR>
					<TD><br></TD>
				</TR>
				<TR>
					<TD>
						<b>2. select box</b>
					</TD>
				</TR>
				<TR>
					<TD>
					    - 단일선택 데이터<br>
						<%= request.getParameter("select1")%>
					</TD>
				</TR>
				<TR>
					<TD><br></TD>
				</TR>
				<TR>
					<TD>
					   - 다중선택<br>
						<% 
							String[] arrSelect = request.getParameterValues("select2");
						
							if(arrSelect != null)
							{
								for(int i=0; i < arrSelect.length; i++)
								{
									out.println(arrSelect[i]);
									
									if(i != arrSelect.length)
										out.println(", ");
								}
							}
						%>
					</TD>
				</TR>
				<TR>
					<TD><br></TD>
				</TR>
				<TR>
					<TD>
						<b>3. radio button</b>
					</TD>
				</TR>
				<TR>
					<TD>
						<%= request.getParameter("radio1")%>
					</TD>
				</TR>
				</TR>
				<TR>
					<TD><br></TD>
				</TR>
				<TR>
					<TD>
						<b>4. checkbox</b>
					</TD>
				</TR>
				<TR>
					<TD>
						<% 
							String[] arrCheck = request.getParameterValues("check1");
					
							if(arrCheck != null)
							{
								for(int i=0; i < arrCheck.length; i++)
								{
									if(i > 0)
										out.println(", ");
									
									out.println(arrCheck[i]);
								}
							}
						%>
					</TD>
				</TR>
				<TR>
					<TD><br></TD>
				</TR>
				<TR>
					<TD>
						<b>5. TEXTAREA</b>
					</TD>
				</TR>
				<TR>
					<TD>
						<%= request.getParameter("textarea1")%>
					</TD>
				</TR>
				<TR>
					<TD><br></TD>
				</TR>
				<TR>
					<TD>
						<b>6. request.getParameterNames() 사용</b>
					</TD>
				</TR>
				<TR>
					<TD>
		<%
			Enumeration e = request.getParameterNames();
			while( e.hasMoreElements())
			{
			    String   name   = (String)e.nextElement();
			    String[] values = request.getParameterValues(name);
			    for(int i=0; i<values.length; i++)
			    {
			        out.println(name + " : " + values[i] + "<br>");
			     }
			 }
		%>
					</TD>
				</TR>
				<TR>
					<TD><br></TD>
				</TR>
				<TR>
					<TD>
						<b>7. request.getParameterMap() 사용</b>
					</TD>
				</TR>
				<TR>
					<TD>
		<%
			Map paramMap = request.getParameterMap();
			Enumeration enums = request.getParameterNames();
			String  paramName = "";
			
			for(int i=0; i<paramMap.size(); i++) 
			{
				  paramName = (String)enums.nextElement();
		
				  //파라메터가 배열로 들어오는 경우 체크
				  String str = "";
				  for (int j=0; j < ((String[])paramMap.get(paramName)).length  ;j++) 
				  {
				   str = ((String[])paramMap.get(paramName))[j];
				  
				   out.println(paramName + " = " + str + "<br>");
				  }
			}
		%>	
					</td>
				</tr>
				</table>
			</td>
		  </tr>
		</table>
		<br>
		<br>
		<a href="index.jsp">[처음으로]</a>
		<a href="javascript:history.back(-1);">[뒤로]</a>
	</div>
	<div id="footer" style="width:96%; margin-left:auto; margin-right:auto  "><div style="border-top:1px solid #eaebec;width:100%;"></div><img src="images/logo_foot.gif" width="174" height="49" style="float:right;"/></div>
</div>
</body>
</html>
