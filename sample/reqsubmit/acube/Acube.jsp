<%@ page language="java" contentType="text/html;charset=euc-kr" %>

<%@ page session="true" %>



<%@ page import="nads.lib.reqsubmit.encode.Base64Code" %>
<%@ page import="nads.lib.reqsubmit.util.*" %>


<%
    String strFileName = "a.txt";
    String strFileSize = Long.toString(FileUtil.getFileSize("C:/a.txt"));  //���ϻ���
    
	Base64Code objBase = new Base64Code();
    String strAttach1 =  objBase.encodeFromFile("C:/a.txt");
%>

<html>
<head>
<title>���ڰ��� �׽�Ʈ</title>
<link href="/css/global.css"  rel="stylesheet" type="text/css" />
<head>
<script language="javascript">
   function addAcube(formName){
   		    		 
		 if(confirm("POP-UP Ȯ��")==true){
			   addAcube = window.open("http://docs.assembly.go.kr/acubecn/legacy/ACN_LegacyBridge.jsp","addAcube",
				   										 "resizable=yes,menubar=yes,status=yes,titlebar=yes, scrollbars=yes,location=yes,toolbar=yes,height=500,width=800");
				
				formName.target="addAcube";
				formName.submit();
		 }
   }
</script>

<body leftmargin="0" topmargin="0">
	<table border="0" cellpadding="0" cellspacing="0" width="980" height="500">
		<tr>
			<td width="980" height="90" align="center" colspan="2"><%@ include file="/common/top.jsp" %></td>
		</tr>
		<tr>
			<td width="190" align="center" valign="top"><%@ include file="/common/menu.jsp" %></td>
			<td width="790" valign="top">
				<!-- ������� ���� ������ �Է��� �ּ��� -->
				
				<!-- ���� ��ġ Navigation -->
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td height="1" class="e1"></td> 
					</tr>
					<tr>

					</tr>
					<tr>
						<td height="1" class="e1"></td>
					</tr>
				</table>

				<!-- ���� ������ Ÿ��Ʋ �̹���(or �ؽ�Ʈ) -->
				<table border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td width="100%" class="title" height="30">&nbsp;&nbsp;&nbsp;ACUBE(���ڰ���) ���� �׽�Ʈ</td>					
					</tr>
				</table>

				<!---------------------------------------------------------------- START --------------------------------------------------------------->								
				<table>
				<tr>
				<td>&nbsp;&nbsp;</td>
				<td>
				<table>
<!--				<form name="form1" method="POST" action="http://10.201.10.39/acubecn/legacy/CN_AssemLegacyBridge.jsp">   -->
<!--				<form name="form1" method="get" action="http://docs.assembly.go.kr/acubecn/legacy/CN_AssemLegacyBridge.jsp">				-->
				<form name="form1" method="POST" action="http://docs.assembly.go.kr/acubecn/legacy/CN_AssemLegacyBridge.jsp" >				
					<tr>
						<td>
						  <table>
<!--						    
							<tr> 
						      <td width=60 bgcolor="#CCCCCC" align="center"><b>�����ID</b></td>
						      <td colspan="2">
						        <input type="text" class="textbox" name="userid" size="20"  value="admin">
						      </td>  
						    </tr>						  
-->						    
						    <tr> 
						      <td width=60 bgcolor="#CCCCCC" align="center"><b>�ý���ID</b></td>
						      <td colspan="2">
						        <input type="text" class="textbox" name="systemid" size="20"  value="request_send">
						      </td>
						    </tr>
						    <tr>
						      <td bgcolor="#CCCCCC" align="center"><b>����ID</b></td>
						      <td colspan="2">
   						        <input type="text" class="textbox" name="businessid" size="20"  value="request_private">
						      </td>
						    </tr>
						    <tr> 
						      <td bgcolor="#CCCCCC" align="center"><b>cssversion</b></td>
						      <td colspan="2">
   						        <input type="text" class="textbox" name="cssversion" size="20" maxlength="80" value="2.0">
						      </td>
						    </tr>
						    <tr>
						      <td bgcolor="#CCCCCC" align="center"><b>formversion</b></td>
						      <td colspan="2">
   						        <input type="text" class="textbox" name="formversion" size="20"  value="1.0">
						      </td>
						    </tr>
						    <tr>
						      <td bgcolor="#CCCCCC" align="center"><b>����</b></td>
						      <td colspan="2">
   						        <input type="text" class="textbox" name="title" size="110"  value="���ڰ��� ���� �׽�Ʈ">
						      </td>
						    </tr>
						    <tr>
						      <td bgcolor="#CCCCCC" align="center"><b>method</b></td>
						      <td colspan="2">
   						        <input type="text" class="textbox" name="method" size="20"  value="file">
						      </td>
						    </tr>
						    <tr>
						      <td bgcolor="#CCCCCC" align="center"><b>����1</b></td>
						      <td colspan="2">
								<textarea name="legacyout" cols="110" rows="10" OnFocus="this.select();">
<?xml version="1.0" encoding="euc-kr"?>
	<REQUEST_PRIVATE>
		<DOC_SUBMIT>
			<SUID>99999999</SUID>
		</DOC_SUBMIT>
	</REQUEST_PRIVATE>
								</textarea>
						      </td>
						    </tr>						    						    						    
						    <tr> 
						      <td bgcolor="#CCCCCC" align="center"><b>����2</b></td>
						      <td colspan="2">
								<textarea name="attaches" cols="110" rows="10" OnFocus="this.select();">
<?xml version='1.0' encoding='euc-kr'?>
<GENERAL_ATTACHES>
	<GENERAL_ATTACH METHOD='add' MODIFY=''>
		<DISPLAY_NAME><![CDATA[<%=strFileName%>]]></DISPLAY_NAME>
		<FILE_NAME><%=strFileName%></FILE_NAME>
		<FILE_SIZE><%=strFileSize%></FILE_SIZE>
		<FILE_BASE64_DATA><%=strAttach1%></FILE_BASE64_DATA>
	</GENERAL_ATTACH>
</GENERAL_ATTACHES>
								</textarea>
							  </td>
						    </tr>
						    <tr>
						      <td bgcolor="#CCCCCC" align="center"><b>�μ��ڵ�(���������� �߰�)</b></td>
						      <td colspan="2">
							    <INPUT id="deptcode" name="deptcode" type="text" value="9710137">
						      </td>
						    </tr>						   
						  </table>
						  <table>						  
						   	<tr>
						  	  <td align="center"> 
								<input type="submit" value="������" style="cursor:hand" >&nbsp;								
								<input type="reset" value="���" style="cursor:hand" >&nbsp;				
                                 <input type="button" name="Button" value="POP-UP������" style="cursor:hand" OnClick="javascript:addAcube(form1);">		        																		
							  </td>
							</tr>
						  </table>
						</td><!--��� ����Ʈ ��  -->
					</tr>
				</form>
				</table>
				</td>
				</tr>
				</table>				       								
				<!---------------------------------------------------------------- FINISH  --------------------------------------------------------------->

				<!-- ������� ���� ������ �Է��� �ּ��� -->
			</td>
		</tr>
		<tr>
			<td width="980" height="45" align="center" colspan="2"><%@ include file="/common/bottom.jsp" %> </td>
		</tr>
	</table>
</body>

</html>