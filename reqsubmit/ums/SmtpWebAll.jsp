<%@ page language="java" contentType="text/html;charset=euc-kr" %>

<%@ page import="java.util.*"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.UserInfoDelegate"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="kr.co.kcc.bf.config.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>

<%
	String webURL = ""; //http �ּ�
	try {
		Config objConfig = PropertyConfig.getInstance(); //������Ƽ
		webURL = objConfig.get("nads.dsdm.url");
	} catch (ConfigException objConfigEx) {
		out.println(objConfigEx.toString() + "<br>");
		return;
	}
	
%>

<html>
<head>
<title>���ڿ��� �׽�Ʈ</title>
<link href="/css/global.css"  rel="stylesheet" type="text/css" />
<head>
<script>
	function dosubmit(){
		if(document.form1.stt_cd.value == ""){
			alert("���۱׷��� ������ �ּ���");
			return;
		}
		if(document.form1.sname.value == ""){
			alert("�߽��ڸ��� �Է����ּ���.");
			return;
		}
		if(document.form1.smail.value == ""){
			alert("�߽����ּҸ� �Է����ּ���.");
			return;
		}
		if(document.form1.subject.value == ""){
			alert("������ �Է����ּ���");
			return;
		}
		if(document.form1.contents.value == ""){
			alert("�߽ų����� �Է����ּ���.");
			return;
		}

		if(confirm("�߼��Ͻðڽ��ϱ�?")) {
			document.form1.submit();
		}else{
			return;
		}
		
	}
</script>
</head>

<body leftmargin="0" topmargin="0">
	<table border="0" cellpadding="0" cellspacing="0" width="980" height="500">
		<tr>
			<td width="980" height="90" align="center" colspan="2"></td>
		</tr>
		<tr>
			<td width="190" align="center" valign="top"></td>
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
						<td width="100%" class="title" height="30">&nbsp;&nbsp;&nbsp;���ڿ��� �׽�Ʈ</td>					
					</tr>
				</table>

				<!---------------------------------------------------------------- START --------------------------------------------------------------->
				<table>
				<tr>
				<td>&nbsp;&nbsp;</td>
				<td>
				<table>
				<form name="form1" method="post" action="SmtpWebAllProc.jsp">
					<input type="hidden" name="cmd" value="create">
					<tr>
						<td>
						  <table>
				 		    <tr>
				 		    	<a>���Ϲ߼ۿ��� (TS_MAILQUEUE) ���̺� ����</a>
				 		    </tr>						  
						    <tr> 
						      <td width=100 bgcolor="#CCCCCC" align="center"><b>���۱׷�</b></td>
						      <td colspan="2">
						        <select name="stt_cd">
									<option value="">�����ϼ���</option>
									<option value="001">����</option>
									<option value="005">���Խ�û</option>
									<option value="006">���Խ���</option>
								</select>
						      </td>  
						    </tr>	
						    <tr> 
						      <td bgcolor="#CCCCCC" align="center"><b>�߽���ID</b></td>
						      <td colspan="2">
   						        <input type="text" class="textbox" name="sid" size="40" maxlength="80" value="ADMIN">
						      </td>
						    </tr>
						    <tr> 
						      <td bgcolor="#CCCCCC" align="center"><b>�߽��ڸ�</b></td>
						      <td colspan="2">
   						        <input type="text" class="textbox" name="sname" size="30"  value="">
						      </td>
						    </tr>						    
						    <tr> 
						      <td bgcolor="#CCCCCC" align="center"><b>�߽��ڸ����ּ�</b></td>
						      <td colspan="2">
   						        <input type="text" class="textbox" name="smail" size="30"  value="">
						      </td>
						    </tr>
						    <tr>
						      <td bgcolor="#CCCCCC" align="center"><b>����</b></td>
						      <td colspan="2">
   						        <input type="text" class="textbox" name="subject" size="60"  value="">
						      </td>
						    </tr>						    						    
						    <tr> 
						      <td bgcolor="#CCCCCC" align="center"><b>����</b></td>						      
						      <td colspan="2">
						        <TEXTAREA  name="contents" cols="103" rows="8" value="">http://naps.assembly.go.kr/newsletter/SendAllDoc.jsp</TEXTAREA>        
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
   						        001(�����䱸), 002(��������), 003(�����䱸��ϼ���), 004(�����䱸��ϻ���), 005(����Ϸ�)
						      </td>
						    </tr>
						    <tr>
						      <td bgcolor="#CCCCCC" align="center"><b>���ۻ���</b></td>
						      <td colspan="2">
   						        <input type="text" class="textbox" name="status" size="30"  value="0">
   						        ���ۻ��� : ���۴��='9'   ���ۿ�û = '0'
   						        ���ڰ��縦 Ÿ�� 9�� �׷��� ������ 0���� parameter���� �ѱ��.
						      </td>
						    </tr>
						    <tr>
						      <td bgcolor="#CCCCCC" align="center"><b>�μ�ID</b></td>
						      <td colspan="2">
   						        <input type="text" class="textbox" name="deptgbn" size="30"  value="9710137">
						      </td>
						    </tr>
						    <tr>
						      <td bgcolor="#CCCCCC" align="center"><b>�μ���</b></td>
						      <td colspan="2">
   						        <input type="text" class="textbox" name="deptnm" size="30"  value="�Թ�����ȭ ������">
						      </td>
						    </tr>	
						    <tr>
						      <td colspan="2" bgcolor="#CCCCCC" align="center"><b>## ���� ������ �ʼ� �� �Դϴ�.</b></td>
						    </tr>						    
						  </table>
						  <table>
						   	<tr>
						  	  <td align="center"> 
								<input type="button" value="����" style="cursor:hand" onclick="dosubmit()">&nbsp;							
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
			<td width="980" height="45" align="center" colspan="2"><!--%@ include file="/common/bottom.jsp" %--></td>
		</tr>
	</table>
</body>

</html>