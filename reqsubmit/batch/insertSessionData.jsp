<%@ page language="java" contentType="text/html; charset=EUC-KR" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.db.sql.SqlRequestBox" %>

<%
	
%>

<html>
<head>
<title>�����ڷ� �������� �ý��� - ȸ���Է� ��</title>

<link href="/css/System.css" rel="stylesheet" type="text/css">
<script language=Javascript src="/js/reqsubmit/common.js"></script>
<script language=Javascript src="/js/nads_lib.js"></script>
<script language=Javascript src="/js/datepicker.js"></script>

<script language="javascript">	

	function doSubmit() {
		var f = document.formName;
		
		if(f.sessionNo.value == ""){
			alert("ȸ�⸦ �Է��� �ֽʽÿ�.");
			f.sessionNo.focus();
			return;
		}else if (f.DaeNum.value == ""){
			alert("����� �Է��� �ֽʽÿ�.");
			f.DaeNum.focus();
			return;
		}else if (f.startDate.value == ""){
			alert("ȸ�� �������� �Է��� �ֽʽÿ�.");
			f.startDate.focus();
			return;
		}else if (f.endDate.value ==""){
			alert("ȸ�� �������� �Է��� �ֽʽÿ�");
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
	<font style="font-family:HY������M; font-size:18px; color:darkblue;">
		�����ڷ� �������� �ý���<BR>
	</font>
	<font style="font-family:HY������M; font-size:24px; color:darkblue; font-weight:bold;">
		�䱸�� ȸ�� �Է��� 
	</font>
	<p>

<FORM name="formName" method="post" action="insertSessionDataProc.jsp" style="margin:0px">
	<table border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td width="600" align="left" height="50">
				* �䱸�Ի����� �ڵ����� ȸ�������� �־��ֱ� ���� ȸ�������� �Է��ϴ� ���Դϴ�.<BR>
				* ȸ��� ȸ�� �Ⱓ������ �Է��� �� Ȯ�� ��ư�� ���� �ֽʽÿ�.
			</td>
		</tr>
		<tr>
			<td align="left" style="border:1px solid #808080;padding:5px">				
				<p>
				<DIV ID="formDiv" style="width:580px;height:40px;display:"> 
					<table border="0" cellpadding="0" cellspacing="0" style="border:1px solid #c0c0c0"> 
						 <tr>
							<td height="30" width="580">
								ȸ�� : <input type="text" name="sessionNo" size="4" class="textfield">
							</td>
						</tr>
						<tr>
							<td height="30" width="580">
								��� : <input type="text" name="DaeNum" size="4" class="textfield"> 
							</td>
						</tr>
						<tr>
							<td height="30" width="580">
								ȸ��Ⱓ : <input type="text" class="textfield" name="startDate" size="10" maxlength="8""  OnClick="this.select()" 
						OnKeyPress="if ((event.keyCode&lt;48)||(event.keyCode&gt;57)) event.returnValue=false;" OnBlur="javascript:SetFormatDate(this);">&nbsp;<img src="/image/button/bt_viewCalendar.gif" border="0" style="cursor:hand"  OnClick="javascript:show_calendar('formName.startDate');" align="absmiddle">

 - <input type="text" class="textfield" name="endDate" size="10" maxlength="8"  OnClick="this.select()" 
						OnKeyPress="if ((event.keyCode&lt;48)||(event.keyCode&gt;57)) event.returnValue=false;" OnBlur="javascript:SetFormatDate(this);">&nbsp;<img src="/image/button/bt_viewCalendar.gif" border="0" style="cursor:hand"  OnClick="javascript:show_calendar('formName.endDate');" align="absmiddle">


							</td>
						</tr> 						 
					</table> 
				</DIV> 
				<p>
				&nbsp;* ��й�ȣ : <input type="password" name="pwd" value="" size="15" class="textfield"><p>
				<input type="button" name="btn" value="SUBMIT" onClick="javascript:doSubmit()" style="cursor:hand; font-size:11px; font-family:Verdana,����; background-color:white; color:#909090">
			</td>
		</tr>
	</table>
</FORM>	

	</CENTER>
</body>

</html>