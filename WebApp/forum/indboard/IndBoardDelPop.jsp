<%@ page language="java"  contentType="text/html;charset=euc-kr" %>	
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>

<%
	/*�������� ������ �Ķ���� (����ID, ȸ������, ��������, ������)*/
	String strForumID = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("fid"))); 				 //����ID
	String strUserStt = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("uStt"))); 			 //ȸ������
	String strOpenFlag = ""; 																										//��������
	String strForumNM = "";																										//������
	
	/*GET �Ķ����*/
	String strCurrentPage =  nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("strCurrentPage"))); //���� ������
	String strAncTgt = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("anctgt")));			 //�������
	String strCmd =  nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("cmd")));					 //���� 
	String strBbrdID =  nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("bbrdid")));			 //�Խ��� ���̵�
	String strDataID = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("dataid")));			 //�Խù� ���̵�
	String strOneID=  nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("oneid")));				 //���ٴ�� ���̵�
%>
<html>
<head>
<title>���� �Խù� ����</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link href="/css/System.css" rel="stylesheet" type="text/css">
<script language="javascript" src="/js/forum.js"></script>
<script language="javascript">
	
	function goToOprDelete(){
		
		var frm = document.frmOprDel;
		
		if (frm.delrsn.value == "" || frm.delrsn.value == null){
			alert("���������� �Է��� �ּ���.");
			frm.delrsn.focus();
			return false;
		} 

		//�ѱ�, ���� �����Ͽ� ���ڿ� ���̸� üũ�Ѵ�.
        if(checkStrLen(frm.delrsn, 500, "��������") == false){
            return false;
        }

       var msg = "�ش� ������ ���� �Ͻðڽ��ϱ�?";

	    if(confirm(msg)){
			frm.cmd.value = "<%=strCmd%>"
			//frm.submit();
	    }
	    else{
	        return false;
	    }
	    
	}

</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="380" border="0" cellspacing="0" cellpadding="0">
<form name="frmOprDel" method="post" action="IndOprProc.jsp" onSubmit="return goToOprDelete();"> 
<input type="hidden" name="fid" value="<%=strForumID%>">
<input type="hidden" name="uStt" value="<%=strUserStt%>">
<input type="hidden" name="cmd" value="">
<input type="hidden" name="strCurrentPage" value="<%=strCurrentPage%>">
<input type="hidden" name="anctgt" value="<%=strAncTgt%>">
<input type="hidden" name="bbrdid" value="<%=strBbrdID%>">
<input type="hidden" name="dataid" value="<%=strDataID%>">
<input type="hidden" name="oneid" value="<%=strOneID%>">
  <tr class="td_forumpop"> 
    <td height="5"></td>
    <td height="5"></td>
  </tr>
  <tr> 
    <td width="14" height="10"></td>
    <td width="386" height="10"></td>
  </tr>
  <tr> 
    <td width="14">&nbsp;</td>
    <td height="25" valign="middle"><img src="/image/forum/icon_forumpop_soti.gif" width="9" height="9">&nbsp;<span class="soti_forumpop">���� ��� ����</span></td>
  </tr>
  <tr>
    <td height="5"></td>
    <td height="5"><table width="96%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td height="25" valign="bottom" class="text_s">���� �Ͻ� �ڷ� ���� ������ �Է��� �ּ���.</td>
        </tr>
      </table></td>
  </tr>
  <tr> 
    <td height="10"></td>
    <td height="10"></td>
  </tr>
  <tr> 
    <td width="14">&nbsp;</td>
    <td height="23" align="left" valign="top"><textarea name="delrsn" wrap="hard" class="textfield" style="WIDTH: 96% ; height: 140"></textarea></td>
  </tr>
  <tr> 
    <td width="14">&nbsp;</td>
    <td height="40" align="left"><table width="96%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td height="25" align="right">&nbsp;
          	<input type="image" src="/image/button/bt_confirm.gif" width="42" height="20"> 
            <img src="/image/button/bt_cancel.gif" width="43" height="20" style="cursor:hand;"  onClick="reset();"></td>
        </tr>
      </table></td>
  </tr>
  <tr> 
    <td height="25" colspan="2" align="right" class="td_gray1">&nbsp;<a href="javascript:self.close()"><img src="/image/button/bt_close.gif" width="46" height="11" border="0"></a>&nbsp;&nbsp;</td>
  </tr>
</form>
</table>
</body>
</html>
