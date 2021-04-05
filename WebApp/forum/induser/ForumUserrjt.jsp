<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>

<%@ include file="/forum/common/CheckSessionPop.jsp" %>

<%
	String strForumID = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("fid"))); //포럼ID
	String strForumNM = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("fnm"))); //포럼명
	String strUserStt = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("uStt"))); //회원상태
	String strCMD = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("cmd"))); //가입승인거부:joinRjt 탈퇴승인거부:leaveRjt
	String strTitle = (strCMD.equals("joinRjt"))?"가입":"탈퇴";

	String strUserIDs = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("uids")));
	//out.print("strUserIDs:"+strUserIDs);
%>

<html>
<head>
<title>회원<%=strTitle%>승인거부</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link href="/css/System.css" rel="stylesheet" type="text/css">
<script src='/js/forum.js'></script>
<script language="JavaScript">
<!--
function fnChk() {
	if(document.form.rjtRsn.value=="") {
		alert("회원 <%=strTitle%> 승인 거부 사유를 입력해주세요");
		document.form.rjtRsn.focus();
		return false;
	}

	if (fnSpaceChk(document.form.rjtRsn.value, "회원 <%=strTitle%> 승인 거부 사유를 올바르게 입력하세요.") == false ) return false;

	if(document.form.rjtRsn.value.length > 250) {
		alert("회원 <%=strTitle%> 승인 거부 사유를 250자 이내로 입력해주세요");
		document.form.rjtRsn.focus();
		return false;
	}
	document.form.submit();
}
//-->
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="380" border="0" cellspacing="0" cellpadding="0">
	<!--form-->
	<form name="form" method="post" action="ForumUserProc.jsp" onSubmit="return fnChk();">
	<input type="hidden" name="cmd" value="<%=strCMD%>">
	<input type="hidden" name="fid" value="<%=strForumID%>">
	<input type="hidden" name="uStt" value="<%=strUserStt%>">
	<input type="hidden" name="uids" value="<%=strUserIDs%>">
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
    <td height="25" valign="middle"><img src="/image/forum/icon_forumpop_soti.gif" width="9" height="9">&nbsp;<span class="soti_forumpop">회원 <%=strTitle%> 승인 거부 </span></td>
  </tr>
  <tr>
    <td height="5"></td>
    <td height="5"><table width="96%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td height="25" valign="bottom" class="text_s">선택하신 이용자의 승인 거부 사유를 입력해 주세요.
		  </td>
        </tr>
      </table></td>
  </tr>
  <tr> 
    <td height="10"></td>
    <td height="10"></td>
  </tr>
  <tr>
    <td width="14">&nbsp;</td>
    <td height="23" align="left" valign="top"><textarea name="rjtRsn" wrap="hard" class="textfield" style="WIDTH: 96% ; height: 140"></textarea></td>
  </tr>
  <tr> 
    <td width="14">&nbsp;</td>
    <td height="40" align="left"><table width="96%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td height="25" align="right">&nbsp;<input type="image" src="/image/button/bt_confirm.gif" width="42" height="20"> 
            <a href="javascript:document.form.reset();"><img src="/image/button/bt_cancel.gif" width="43" height="20" border=0></a></td>
        </tr>
      </table></td>
  </tr>
  <tr> 
    <td height="25" colspan="2" align="right" class="td_gray1">&nbsp;<a href="javascript:self.close()"><img src="/image/button/bt_close.gif" width="46" height="11" border="0"></a>&nbsp;&nbsp;</td>
  </tr>
</table>
</body>
</html>