<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="nads.ss.app.statistics.MainStaticsDelegate"%>
<%@ page import="nads.lib.message.MessageBean" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%--@ include file="../common/include/AuthCheck.jsp" --%>

<%
	String strYear =StringUtil.getNVLNULL(request.getParameter("strYear"));					//�⵵
	String strStart =StringUtil.getNVLNULL(request.getParameter("strStart"));					//������
	String strEnd  =StringUtil.getNVLNULL(request.getParameter("strEnd"));		   			    //������
%>

<html>
<title>�����ڷ� �������� �����ý���</title>
<link href="../css/global.css"  rel="stylesheet" type="text/css" />
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<head>
<script language=Javascript src="../js/nads_lib.js"></script>
<script language=Javascript src="../js/datepicker.js"></script>
<script language="javascript">
function fUsrActionUpdate(mode, strNew, strStart, strEnd) {
  switch(mode) {   
    case "Update" :
       	 form1.action = "UpdateYear_AuditPorc.jsp?cmd="+mode+"&strNew="+strNew+"&strStart="+strStart+"&strEnd="+strEnd;         	 
      	 form1.submit();
         break;                  
  }
}

function fCheckField() {
  with (form1) {
    if (audit_str_day.value == '') {
      alert('�������� �������� �����ϼ���!');
      audit_str_day.focus();
      return false;
    }
    if (audit_end_day.value == '') {
      alert('�������� �������� �����ϼ���!');
      audit_end_day.focus();
      return false;
    }
  }  
  return true;
}

function list()
{
	form1.action='SelectYear_Audit.jsp';
	form1.submit();
}
</script>
</head>


<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../image/common/manageUser_over_top.gif','../image/common/manageForum_over_top.gif','../image/common/manageBoard_over_top.gif','../image/common/manageSystem_over_top.gif','../image/common/manageStatistics_over_top.gif','../image/common/manageEtc_over_top.gif','../image/common/go_home_over.gif','../image/common/sitemap_over.gif')">
<form name="form1" method="post" >
<%@ include file="../common/include/TopAdmin.jsp" %>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr align="left" valign="top"> 
    <td width="170" background="../image/common/bg_left.gif"> 
      <%@ include file="../common/include/LeftLogin.jsp" %>
      <%@ include file="include/MenuLeftStatistics.jsp" %>
    </td>
    <td width="973"><table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr bgcolor="EDEDED"> 
          <td height="25" colspan="2" align="left" valign="middle">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Ȩ 
            &gt; ��� ���� &gt; ���� �䱸 ���� ��� &gt; <strong>�⵵�� �������� �Ⱓ ����</strong></td>
        </tr> 
        <tr> 
          <td width="27" height="21" align="left" valign="top"><img src="../image/common/left_white.gif" width="27" height="1"></td>
          <td width="2949" height="21" align="left" valign="top"></td>
        </tr>
        <tr> 
          <td align="left" valign="top">&nbsp;</td>
          <td align="left" valign="top" class="copy-exb"><img src="../image/common/icon_bigTit.gif" width="13" height="13" align="absmiddle"> 
            �⵵�� �������� �Ⱓ ����</td>
        </tr>
        
        <tr> 
          <td align="left" valign="top"></td>
          <td height="30" align="left"> �⵵�� �������� �Ⱓ ������ ���� �� �� �ֽ��ϴ�.</td>
        </tr>
        <tr> 
          <td align="left" valign="top">&nbsp;</td>
          <td align="left" valign="top"><table width="95%" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td width="28%" height="3" class="td0_1"></td>
                <td width="72%" height="3" class="td0_1"></td>
              </tr>
              <tr height="5" class="td0_2"> 
                <td height="5"></td>
                <td height="5"></td>
              </tr>
              <tr> 
                <td height="23" class="td_gray1"><img src="../image/common/icon_sqaure_grary.gif" width="3" height="6"> 
                  ����⵵<font color="990033">&nbsp;</font></td>
                <td height="23" class="td_lmagin"><%=strYear%>
                <input type="hidden" name="audit_yaer_new" value="<%=strYear%>">
                </td>
              </tr>
              <tr class="tbl-line"> 
                <td height="1"></td>
                <td height="1"></td>
              </tr>
              <tr> 
                <td height="23" class="td_gray1"><img src="../image/common/icon_sqaure_grary.gif" width="3" height="6"> 
                  ���������<font color="990033">&nbsp;</font></td>
                <td height="23" class="td_lmagin">
			  	<input type="text" class="textbox" name="audit_str_day" size="10" maxlength="8" value="<%=strStart%>"  readonly OnClick="this.select()" OnKeyPress="if ((event.keyCode&lt;48)||(event.keyCode&gt;57)) event.returnValue=false;" OnBlur="javascript:SetFormatDate(this);" >
			    <input type="button" value="..." style="cursor:hand" OnClick="javascript:show_calendar('form1.audit_str_day');">                              
                </td>
              </tr>
              <tr class="tbl-line"> 
                <td height="1"></td>
                <td height="1"></td>
              </tr>
              <tr> 
                <td height="23" class="td_gray1"><img src="../image/common/icon_sqaure_grary.gif" width="3" height="6"> 
                  ����������<font color="990033">&nbsp;</font></td>
                <td height="23" class="td_lmagin">
			  	<input type="text" class="textbox" name="audit_end_day" size="10" maxlength="8" value="<%=strEnd%>"  readonly OnClick="this.select()" OnKeyPress="if ((event.keyCode&lt;48)||(event.keyCode&gt;57)) event.returnValue=false;" OnBlur="javascript:SetFormatDate(this);" >
			    <input type="button" value="..." style="cursor:hand" OnClick="javascript:show_calendar('form1.audit_end_day');">                                              
                </td>
              </tr>
              <tr class="tbl-line"> 
                <td height="1"></td>
                <td height="1"></td>
              </tr>
            </table></td>
        </tr>
        <tr> 
          <td height="35" align="left" valign="top">&nbsp;</td>
          <td height="35" align="left">
  		  <img src="../image/button/bt_modify.gif" width="43"  height="20" border=0 style="cursor:hand" OnClick="javascript:fUsrActionUpdate('Update',form1.audit_yaer_new.value, form1.audit_str_day.value, form1.audit_end_day.value);">
  		  <img src="../image/button/bt_list.gif" width="43"  height="20" border=0 style="cursor:hand" OnClick="javascript:list();">  		  
        </tr>
 
        <tr height="35"> 
          <td height="35" align="left" valign="top"></td>
          <td height="35" align="left" valign="top"></td>
        </tr>
      </table></td>
  </tr>
</table>
<%@ include file="../common/include/Bottom.jsp" %>
</form>
</body>
</html>
