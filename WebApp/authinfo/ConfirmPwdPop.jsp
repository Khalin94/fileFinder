<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import = "java.net.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>

<%
	/*GET �Ķ����*/
	String strCurrentPage =  StringUtil.getNVLNULL(request.getParameter("strCurrentPage"));			//���� ������
	String strGoToPage = StringUtil.getNVLNULL(URLDecoder.decode(request.getParameter("strGoToPage"), "UTF-8"));	//��ũ�� ������
	String strBbrdID =  StringUtil.getNVLNULL(request.getParameter("bbrdid"));									//�Խ��� ���̵�
	String strDataID =  StringUtil.getNVLNULL(request.getParameter("dataid"));									//�Խù� ���̵�
	String strPwdCmd =  StringUtil.getNVLNULL(request.getParameter("pwdcmd"));								//���� 
%>

<html>
<head>
<title>�Խù� ���� ����</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link href="/css/System.css" rel="stylesheet" type="text/css">
<script language="javascript">

	function cfmPwd(){

		frm = document.frmPwd;
		
		if (frm.cfmpwd.value == "" || frm.cfmpwd.value == null){
			alert("��й�ȣ�� �Է��� �ּ���.");
			frm.cfmpwd.focus();
			return false;
		} 
		
	}
	
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<!-- ��й�ȣ Ȯ�� ���̺� ���� ------------------------------->
<table width="247" border="0" cellspacing="0" cellpadding="0">
<form name="frmPwd" method="post" action="https://naps.assembly.go.kr/authinfo/AuthPwdProc.jsp"  onSubmit="return cfmPwd();">
<input type="hidden" name="strCurrentPage" value="<%=strCurrentPage%>">
<input type="hidden" name="strGoToPage" value="<%=strGoToPage%>">
<input type="hidden" name="bbrdid" value="<%=strBbrdID%>">
<input type="hidden" name="dataid" value="<%=strDataID%>">
<input type="hidden" name="pwdcmd" value="<%=strPwdCmd%>">
  <tr class="td_board"> 
    <td height="5"></td>
    <td height="5"></td>
  </tr>
  <tr> 
    <td height="10"></td>
    <td height="10"></td>
  </tr>
  <tr> 
    <td width="14">&nbsp;</td>
    <td width="386" height="25" valign="middle"><span class="soti_reqsubmit"><img src="/image/board/icon_board_soti.gif" width="9" height="9" align="absmiddle"> 
      </span><span class="soti_board">�Խù� ����/����</span></td>
  </tr>
  <tr> 
    <td height="10"></td>
    <td height="10"></td>
  </tr>
  <tr> 
    <td width="14">&nbsp;</td>
    <td height="23" align="left" valign="top"><table width="95%" border="0" cellspacing="4" cellpadding="0">
        <tr> 
          <td align="center">��й�ȣ�� �Է��ϼ���.</td>
        </tr>
        <tr> 
          <td align="center"><input name="cfmpwd" type="password" class="textfield" style="WIDTH: 100px"></td>
        </tr>
      </table></td>
  </tr>
  <tr> 
    <td height="10"></td>
    <td height="10"></td>
  </tr>
  <tr> 
    <td width="14">&nbsp;</td>
    <td height="40" align="left"><table width="96%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td height="25" align="right">
            <input type="image" src="/image/button/bt_confirm.gif" width="42" height="20">&nbsp;
            <img src="/image/button/bt_cancel.gif" width="43" height="20" style="cursor:hand;" onClick="reset();">
          </td>
        </tr>
      </table></td>
  </tr>
  <tr> 
    <td height="25" colspan="2" align="right" class="td_gray1">&nbsp;<a href="javascript:self.close()"><img src="/image/button/bt_close.gif" width="46" height="11" border="0"></a>&nbsp;&nbsp;</td>
  </tr>
  </form>
</table>
<!-- ��й�ȣ Ȯ�� ���̺� �� ------------------------------->
</body>
</html>
