<%@ page language="java" contentType="text/html; charset=EUC-KR" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.db.sql.SqlRequestBox" %>

<%
	
%>

<html>
<head>
<title>의정자료 전자유통 시스템 - 회기입력 폼</title>

<link href="/css/System.css" rel="stylesheet" type="text/css">
<script language=Javascript src="/js/reqsubmit/common.js"></script>
<script language=Javascript src="/js/nads_lib.js"></script>
<script language=Javascript src="/js/datepicker.js"></script>

<script language="javascript">	

	function doSubmit() {
		var f = document.formName;
		
		if(f.sessionNo.value == ""){
			alert("회기를 입력해 주십시오.");
			f.sessionNo.focus();
			return;
		}else if (f.DaeNum.value == ""){
			alert("대수를 입력해 주십시오.");
			f.DaeNum.focus();
			return;
		}else if (f.startDate.value == ""){
			alert("회기 시작일을 입력해 주십시오.");
			f.startDate.focus();
			return;
		}else if (f.endDate.value ==""){
			alert("회기 종료일을 입력해 주십시오");
			f.endDate.focus();
			return;
		}

		f.submit();
	}
</script>

</head>

<body leftmargin="0" topmargin="0">
	<CENTER>
	<p><BR></p>
	<font style="font-family:HY헤드라인M; font-size:18px; color:darkblue;">
		의정자료 전자유통 시스템<BR>
	</font>
	<font style="font-family:HY헤드라인M; font-size:24px; color:darkblue; font-weight:bold;">
		요구함 회기 입력폼 
	</font>
	<p>

<FORM name="formName" method="post" action="insertSessionDataProc.jsp" style="margin:0px">
	<table border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td width="600" align="left" height="50">
				* 요구함생성시 자동으로 회기정보를 넣어주기 위해 회기정보를 입력하는 폼입니다.<BR>
				* 회기와 회기 기간정보를 입력한 후 확인 버튼을 눌러 주십시오.
			</td>
		</tr>
		<tr>
			<td align="left" style="border:1px solid #808080;padding:5px">				
				<p>
				<DIV ID="formDiv" style="width:580px;height:40px;display:"> 
					<table border="0" cellpadding="0" cellspacing="0" style="border:1px solid #c0c0c0"> 
						 <tr>
							<td height="30" width="580">
								회기 : <input type="text" name="sessionNo" size="4" class="textfield">
							</td>
						</tr>
						<tr>
							<td height="30" width="580">
								대수 : <input type="text" name="DaeNum" size="4" class="textfield"> 
							</td>
						</tr>
						<tr>
							<td height="30" width="580">
								회기기간 : <input type="text" class="textfield" name="startDate" size="10" maxlength="8""  OnClick="this.select()" 
						OnKeyPress="if ((event.keyCode&lt;48)||(event.keyCode&gt;57)) event.returnValue=false;" OnBlur="javascript:SetFormatDate(this);">&nbsp;<img src="/image/button/bt_viewCalendar.gif" border="0" style="cursor:hand"  OnClick="javascript:show_calendar('formName.startDate');" align="absmiddle">

 - <input type="text" class="textfield" name="endDate" size="10" maxlength="8"  OnClick="this.select()" 
						OnKeyPress="if ((event.keyCode&lt;48)||(event.keyCode&gt;57)) event.returnValue=false;" OnBlur="javascript:SetFormatDate(this);">&nbsp;<img src="/image/button/bt_viewCalendar.gif" border="0" style="cursor:hand"  OnClick="javascript:show_calendar('formName.endDate');" align="absmiddle">


							</td>
						</tr> 						 
					</table> 
				</DIV> 
				<p>
				&nbsp;* 비밀번호 : <input type="password" name="pwd" value="" size="15" class="textfield"><p>
				<input type="button" name="btn" value="SUBMIT" onClick="javascript:doSubmit()" style="cursor:hand; font-size:11px; font-family:Verdana,돋움; background-color:white; color:#909090">
			</td>
		</tr>
	</table>
</FORM>	

	</CENTER>
</body>

</html>