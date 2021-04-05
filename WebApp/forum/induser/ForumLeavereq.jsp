<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>

<%@ include file="/forum/common/CheckSessionPop.jsp" %>

<%
	String strForumID = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("fid"))); //포럼ID
	String strForumNM = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("fnm"))); //포럼명
	String strUserStt = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("uStt"))); //회원상태
	String strCMD = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("cmd"))); 
	//탈퇴신청:leaveReq / 강제탈퇴:forceLeave

	String strAlert = strCMD.equals("leaveReq")?"탈퇴사유":"강제탈퇴사유";
	String strUserID = (String)session.getAttribute("USER_ID"); //세션에서 받아와야 함
	String strUserIDs = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("uids")));
	//out.print("strUserID:"+strUserID+"<br>strUserIDs:"+strUserIDs);
%>

<html>
<head>
<title>포럼 탈퇴</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link href="/css/System.css" rel="stylesheet" type="text/css">
<script src='/js/forum.js'></script>
<script language="JavaScript">
<!--
function fnChk() {
	if(document.form.leaveRsn.value=="") {
		alert("<%=strAlert%>를 입력해주세요");
		document.form.leaveRsn.focus();
		return false;
	}

	if (fnSpaceChk(document.form.leaveRsn.value, "<%=strAlert%>를 올바르게 입력하세요.") == false ) return false;

	if(document.form.leaveRsn.value.length > 250) {
		alert("<%=strAlert%>를 250자 이내로 입력해주세요");
		document.form.leaveRsn.focus();
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
	<input type="hidden" name="uid" value="<%=strUserID%>">
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
    <td height="25" valign="middle"><img src="/image/forum/icon_forumpop_soti.gif" width="9" height="9">&nbsp;<span class="soti_forumpop">포럼 탈퇴 </span></td>
  </tr>
  <tr>
    <td height="5"></td>
    <td height="5"><table width="96%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td height="25" valign="bottom" class="text_s">
			<%
				if(strCMD.equals("forceLeave"))
					out.print("선택하신 회원의 강제탈퇴 사유를 입력해 주세요");
				else
					out.print("선택하신 <strong>&quot;"+strForumNM+"&quot;</strong> 포럼 탈퇴 사유를 입력해 주세요.");
			%>
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
    <td height="23" align="left" valign="top"><textarea name="leaveRsn" wrap="hard" class="textfield" style="WIDTH: 96% ; height: 140"></textarea></td>
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