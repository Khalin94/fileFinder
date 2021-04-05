<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="nads.dsdm.app.forum.SLForumUserDelegate" %>
<%@ page import="nads.dsdm.app.forum.SLDBForumDelegate" %>
<%@ page import="nads.dsdm.app.common.code.*" %>
<%@ page import="kr.co.kcc.pf.exception.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="nads.lib.session.*" %>

<%@ page import="nads.lib.message.MessageBean" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%@ include file="/forum/common/CheckSessionPop.jsp" %>

<%
	String strForumID = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("fid"))); //����ID
	String strOpenFlag = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("openYN"))); //��������
	String strForumNM = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("fnm"))); //������
	String strLoc = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("loc"))); //������������ ���Թ�ư Ŭ���� ��:Ind

	String strUserID = (String)session.getAttribute("USER_ID"); //���ǿ��� �޾ƿ;� ��
	String strUserNM = (String)session.getAttribute("USER_NM"); //���ǿ��� �޾ƿ;� ��
	String strUserEmail = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("email")));
%>

<html>
<head>
<title>���� ����</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link href="/css/System.css" rel="stylesheet" type="text/css">
<script src='/js/forum.js'></script>
<script language="JavaScript">
<!--
function fnChk() {
	if(document.form.joinRsn.value=="") {
		alert("���Ե��⸦ �Է����ּ���");
		document.form.joinRsn.focus();
		return false;
	}

	if (fnSpaceChk(document.form.joinRsn.value, "���Ե��⸦ �ùٸ��� �Է��ϼ���.") == false ) return false;

	if(document.form.joinRsn.value.length > 250) {
		alert("���Ե��⸦ 250�� �̳��� �Է����ּ���");
		document.form.joinRsn.focus();
		return false;
	}
	//document.form.submit();
	return true;
}
//-->
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="javascript:window.resizeTo(382, 340);">
<table width="380" border="0" cellspacing="0" cellpadding="0">
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
    <td height="25" valign="middle"><img src="/image/forum/icon_forumpop_soti.gif" width="9" height="9">&nbsp;<span class="soti_forumpop">���� ����</span></td>
  </tr>
  <tr>
    <td height="5"></td>
    <td height="5"></td>
  </tr>
  <tr> 
    <td height="5"></td>
    <td height="5"><table width="96%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
		<%
			if(strOpenFlag.equals("Y")) {
		%>
          <td height="25" valign="bottom" class="text_s">�����Ͻ� <strong>&quot;<%=strForumNM%>&quot;</strong> ������ �����Ͻðڽ��ϱ�?</td>
		<%
			} else {
		%>
          <td height="25" valign="bottom" class="text_s">�����Ͻ� <strong>&quot;<%=strForumNM%>&quot;</strong> ������ ����� �����̹Ƿ� �Ʒ��� ������ �Է��Ͻ� �� �������� ������ ��ٷ� �ּ���.</td>
		<%
			}
		%>
        </tr>
      </table></td>
  </tr>
  <tr> 
    <td height="10"></td>
    <td height="10"></td>
  </tr>
  <tr> 
    <td width="14">&nbsp;</td>
    <td height="23" align="left" valign="top"><table width="96%" border="0" cellspacing="0" cellpadding="0">
        <tr bgcolor="AED889" height="3"> 
          <td height="2"  colspan="2" class="td_forumpop"></td>
        </tr>
		<!--form-->
		<form name="form" method="post" action="ForumUserProc.jsp" onSubmit="return fnChk();">
		<input type="hidden" name="cmd" value="join">
		<input type="hidden" name="loc" value="<%=strLoc%>">
		<input type="hidden" name="fid" value="<%=strForumID%>">
		<input type="hidden" name="openYN" value="<%=strOpenFlag%>">
		<input type="hidden" name="uid" value="<%=strUserID%>">
        <tr > 
          <td width="72" height="25"  class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> ID</td>
          <td width="287" height="25"  class="td_lmagin" ><%=strUserID%> <div align="left"></div></td>
        </tr>
        <tr > 
          <td height="1" colspan="2"  class="tbl-line"></td>
        </tr>
        <tr > 
          <td height="25"  class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
            �̸�</td>
          <td height="25"  class="td_lmagin" ><%=strUserNM%>
            <div align="left"></div></td>
        </tr>
        <tr > 
          <td height="1" colspan="2"  class="tbl-line"></td>
        </tr>
        <tr > 
          <td height="25"  class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
            e-mail</td>
          <td height="25"  class="td_lmagin" ><%=strUserEmail%>
            <div align="left"></div></td>
        </tr>
        <tr > 
          <td height="1" colspan="2"  class="tbl-line"></td>
        </tr>
        <tr > 
          <td height="25"  class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
            ���Ե���</td>
          <td height="80" valign="middle"  class="td_lmagin" ><div align="left"> 
              <p>
                <textarea name="joinRsn" wrap="hard" style="WIDTH: 100% ; height: 70"></textarea>
              </p>
            </div></td>
        </tr>
        <tr> 
          <td height="2" colspan="2" class="tbl-line"></td>
        </tr>
      </table></td>
  </tr>
  <tr> 
    <td width="14">&nbsp;</td>
    <td height="40" align="left"><table width="96%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td height="25" align="right">&nbsp;<input type="image" src="/image/button/bt_join.gif" width="42" height="20"> 
            <a href="javascript:document.form.reset();"><img src="/image/button/bt_cancel.gif" width="43" height="20" border=0></a></td>
        </tr>
		</form>
      </table></td>
  </tr>
  <tr> 
    <td height="25" colspan="2" align="right" class="td_gray1">&nbsp;<a href="javascript:self.close()"><img src="/image/button/bt_close.gif" width="46" height="11" border="0"></a>&nbsp;&nbsp;</td>
  </tr>
</table>
</body>
</html>