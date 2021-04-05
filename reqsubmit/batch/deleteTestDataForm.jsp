<%@ page language="java" contentType="text/html; charset=EUC-KR" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.db.sql.SqlRequestBox" %>

<%
	String strMethod = StringUtil.getEmptyIfNull(request.getParameter("method"));
	String strSelected1 = " checked";
	String strSelected2 = "";
	String strDivDisplay = "none";
	if("1".equals(strMethod)) {
		strSelected1 = "";
		strSelected2 = " checked";
		strDivDisplay = "";
	} 
%>

<html>
<head>
<title>�����ڷ� �������� �ý��� - ������ �׽�Ʈ �ڷ� �ϰ� ���� ��</title>

<link href="/css/System.css" rel="stylesheet" type="text/css">

<script language="javascript">
	function showDiv() {
		document.all.formDiv.style.display = '';
	}

	function hiddenDiv() {
		document.all.formDiv.style.display = 'none';
	}

	function doSubmit() {
		var f = document.delForm;
		if(f.method.value == "0") {
			f.fieldType.value = "";
			f.fieldValue.value = "";
		} else if (f.method.value == "1") {
			if(f.fieldType.value.length == 0) {
				alert("�˻� ��� �÷��� ������ �ּ���.");
				f.fieldType.focus();
				return;
			}
			if(f.fieldValue.value.length == 0) {
				alert("�˻��� ������ �Է��� �ּ���.");
				f.fieldValue.focus();
				return;
			}
		}
		if(f.pwd.value.length == 0) {
			alert("��й�ȣ�� �Է��� �ּ���.");
			f.pwd.focus();
			return;
		}
		if(confirm("�׽�Ʈ �����͸� �����Ͻðڽ��ϱ�?")) f.submit();
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
		������ �׽�Ʈ ������ �ϰ� ���� 
	</font>
	<p>

<FORM name="delForm" method="post" action="deleteTestDataProc.jsp" style="margin:0px">
	<table border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td width="600" align="left" height="50">
				* ���� �� �߻��� �׽�Ʈ �����͸� �ϰ� �����ϱ� ���� ������ �Դϴ�.<BR>
				* ���� ����� �����Ͻ� �� [Ȯ��] ��ư�� Ŭ���� �ּ���.
			</td>
		</tr>
		<tr>
			<td align="left" style="border:1px solid #808080;padding:5px">
				<input type="radio" name="method" value="0"<%= strSelected1 %> onClick="javascript:hiddenDiv()"> '����01' �� ���� ���·� �ӽ� ������ �̿��ڰ� ����(�׽�Ʈ) ���� �߿� �۾��� ������ �ϰ� ����
				<br>
				<input type="radio" name="method" value="1"<%= strSelected2 %> onClick="javascript:showDiv()">  Ư�� ���̵� Ȥ�� �̸��� ���� �̿��ڰ� �۾��� ������ �ϰ� ����
				<p>
				<DIV ID="formDiv" style="width:580px;height:40px;display:<%= strDivDisplay %>"> 
					<table border="0" cellpadding="0" cellspacing="0" style="border:1px solid #c0c0c0"> 
						 <tr>
							<td height="30" width="580">
								&nbsp;&nbsp;&nbsp;
								<select name="fieldType">
									<option value="user_id">:: �̿��� ID :: </option>
									<option value="user_nm">:: �̿��� �̸� :: </option>
								</select>
								<input type="text" size="30" name="fieldValue">
							</td>
						</tr> 
					</table> 
				</DIV> 
				<p>
				&nbsp;* ��й�ȣ : <input type="password" name="pwd" value="" size="15"><p>
				<input type="button" name="btn" value="SUBMIT" onClick="javascript:doSubmit()" style="cursor:hand; font-size:11px; font-family:Verdana,����; background-color:white; color:#909090">
			</td>
		</tr>
	</table>
</FORM>	

	</CENTER>
</body>

</html>