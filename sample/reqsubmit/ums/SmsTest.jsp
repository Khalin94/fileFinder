<%@ page language="java" contentType="text/html;charset=euc-kr" %>

<%@ page import="java.util.*"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.UserInfoDelegate"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>


<html>
<head>
<title>�������� �׽�Ʈ</title>
<link href="/css/global.css"  rel="stylesheet" type="text/css" />
<head>

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
						<td width="100%" class="title" height="30">&nbsp;&nbsp;&nbsp;�������� �׽�Ʈ</td>					
					</tr>
				</table>

				<!---------------------------------------------------------------- START --------------------------------------------------------------->								
				<table>
				<tr>
				<td>&nbsp;&nbsp;</td>
				<td>
				<table>
				<form name="form1" method="get" action="SmsProc.jsp">
					<input type="hidden" name="cmd" value="create">				
					<tr>
						<td>
						  <table>
						    <tr> 
						      <td width=100 bgcolor="#CCCCCC" align="center"><b>��������ȣ</b></td>
						      <td colspan="2">
						        <input type="text" class="textbox" name="sendphoneno" size="30"  value="">
						      </td>  
						    </tr>
						    <tr>
						      <td bgcolor="#CCCCCC" align="center"><b>ȸ�Ź�ȣ</b></td>
						      <td colspan="2">
   						        <input type="text" class="textbox" name="returnno" size="30"  value="">
						      </td>
						    </tr>
						    <tr> 
						      <td bgcolor="#CCCCCC" align="center"><b>���ۻ���</b></td>
						      <td colspan="2">
   						        <input type="text" class="textbox" name="sendstatus" size="30"  value="1">
   						        ���ۻ��� : ���۴��='9'   ���ۿ�û = '1'
   						        ���ڰ��縦 Ÿ�� 9�� �׷��� ������ 1�� parameter���� �ѱ��.
						      </td>
						    </tr>						    						    
						    <tr>
						      <td bgcolor="#CCCCCC" align="center"><b>�޽���</b></td>
						      <td colspan="2">
   						        <input type="text" class="textbox" name="smsmsg" size="40" maxlength="80" value="">
						      </td>
						    </tr>
						    <tr> 
						      <td bgcolor="#CCCCCC" align="center"><b>�ý��۱���</b></td>
						      <td colspan="2">
   						        <input type="text" class="textbox" name="systemgbn" size="30"  value="S13001">
   						        S13001(��������), S13002(��������),S13003(���ڰ���), S13004(Ȩ������)
						      </td>
						    </tr>
						    <tr>
						      <td bgcolor="#CCCCCC" align="center"><b>���񽺱���</b></td>
						      <td colspan="2">
   						        <input type="text" class="textbox" name="servicegbn" size="30"  value="001">
   						        001(�����䱸), 002(��������), 003(�����䱸��ϼ���), 004(�����䱸��ϻ���)
						      </td>
						    </tr>
						    <tr>
						      <td bgcolor="#CCCCCC" align="center"><b>�μ�ID</b></td>
						      <td colspan="2">
   						        <input type="text" class="textbox" name="deptgbn" size="30"  value="">
						      </td>
						    </tr>
						    <tr>
						      <td bgcolor="#CCCCCC" align="center"><b>�μ���</b></td>
						      <td colspan="2">
   						        <input type="text" class="textbox" name="deptnm" size="30"  value="">
						      </td>
						    </tr>						    
						    <tr>
						      <td bgcolor="#CCCCCC" align="center"><b>�����ID</b></td>
						      <td colspan="2">
   						        <input type="text" class="textbox" name="userid" size="30"  value="ADMIN">
						      </td>
						    </tr>
						    <tr>
						      <td bgcolor="#CCCCCC" align="center"><b>����ڸ�</b></td>
						      <td colspan="2">
   						        <input type="text" class="textbox" name="usernm" size="30"  value="������">
						      </td>
						    </tr>						    				    
						  </table>
						  <table>
						   	<tr>
						  	  <td align="center">
								<input type="submit" value="����" style="cursor:hand" >&nbsp;
								<input type="reset" value="���" style="cursor:hand" >&nbsp;
							  </td>
							</tr>
						  </table>
				 		    <tr>
				 		    </tr>
				 		    <tr>
				 		    </tr>
				 		    <tr>
				 		    </tr>				 		  
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
			<td width="980" height="45" align="center" colspan="2"><!--%@ include file="/common/bottom.jsp" %--> </td>
		</tr>
	</table>
</body>
</html>