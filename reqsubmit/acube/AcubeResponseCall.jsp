<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page session="true" %>
<%@ page import="nads.lib.reqsubmit.util.*" %>




<html>
<head>
<title>���ڰ��� �׽�Ʈ</title>
<link href="/css/global.css"  rel="stylesheet" type="text/css" />
<head>
<script language="javascript">

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
				<form name="form1" method="POST" action="/reqsubmit/10_mem/20_reqboxsh/40_commreq/RCommReqInfoResponse.jsp" >				
					<tr>
						<td>
						  <table>
						    <tr> 
						      <td width=200 bgcolor="#CCCCCC" align="center"><b>�ý���ID</b></td>
						      <td colspan="2">
						        <input type="text" class="textbox" name="systemid" size="20"  value="request_send">
						      </td>
						    </tr>
						    <tr>
						      <td bgcolor="#CCCCCC" align="center"><b>����ID</b></td>
						      <td colspan="2">
   						        <input type="text" class="textbox" name="businessid" size="20"  value="requset_in_comm">
						      </td>
						    </tr>
						    <tr> 
						      <td bgcolor="#CCCCCC" align="center"><b>���繮��ID</b></td>
						      <td colspan="2">
   						        <input type="text" class="textbox" name="docid" size="50" maxlength="80" value="003D63A77BE8E5FC0241D1B4FFFF8365">
						      </td>
						    </tr>
             			    <tr>
						      <td bgcolor="#CCCCCC" align="center"><b>����1</b></td>
						      <td colspan="2">
								<textarea name="legacyin" cols="80" rows="10" OnFocus="this.select();">
									<?xml version="1.0" encoding="euc-kr"?>
									<REQUEST_IN_COMM>
									<DOC_SUBMIT>
										<SUID><![CDATA[0000000095]]></SUID>
									</DOC_SUBMIT>
								</REQUEST_IN_COMM>
								</textarea>
						      </td>
						    </tr>						    						    						    
						    <tr> 
						      <td bgcolor="#CCCCCC" align="center"><b>����2</b></td>
						      <td colspan="2">
								<textarea name="event" cols="80" rows="10" OnFocus="this.select();">1</textarea>
								���(1), �ݷ�(16), �Ϸ�(8), ��Ⱥ���(256)
							  </td>
						    </tr>
						  </table>
						  <table>
						   	<tr>
						  	  <td align="center">
								<input type="submit" value="������" style="cursor:hand" >&nbsp;
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