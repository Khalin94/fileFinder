<%@ page language="java" contentType="text/html;charset=euc-kr" %>

<%@ page session="true" %>

<html>
<head>
<title>���ڰ��� �׽�Ʈ</title>
<link href="/css/global.css"  rel="stylesheet" type="text/css" />
<head>
<script language="javascript">
   function addBinder(formName){
   		 
		 if(confirm("POP-UP Ȯ��")==true){
			   addBind = window.open("http://www.empas.co.kr","addBind",
				   "resizable=yes,menubar=yes,status=yes,titlebar=yes,	      scrollbars=yes,location=yes,toolbar=yes,height=500,width=800");
				formName.action="http://www.empas.co.kr";
		 }else{
			window.close();
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
				<form name="form1" method="POST" action="AcubeResponse.jsp">  
					<tr>
						<td>
						  <table>						  
						   	<tr>
						  	  <td align="center"> 
								<input type="submit" value="������" style="cursor:hand" >&nbsp;								
								<input type="reset" value="���" style="cursor:hand" >&nbsp;						
<!--                                 <input type="button" name="Button" value="POPUP" style="cursor:hand" OnClick="javascript:addBinder('form1');">		        	-->
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