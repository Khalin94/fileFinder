<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="nads.dsdm.app.forum.SLForumUserDelegate" %>
<%@ page import="nads.dsdm.app.activity.userinfo.UserInfoDelegate" %>
<%@ page import="nads.dsdm.app.common.code.*" %>
<%@ page import="kr.co.kcc.pf.exception.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="nads.lib.session.*" %>

<%@ page import="nads.lib.message.MessageBean" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%@ include file="/forum/common/CheckSessionPop.jsp" %>

<%
	String strForumID = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("fid"))); //포럼ID
	String strOpenFlag = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("openYN"))); //공개여부
	String strForumNM = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("fnm"))); //포럼명
	String strLoc = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("loc"))); 
	//개별포럼에서 가입버튼 클릭시 값:Ind

	String strUserID = (String)session.getAttribute("USER_ID"); //세션에서 받아와야 함
	String strUserNM = (String)session.getAttribute("USER_NM"); //세션에서 받아와야 함
	String strUserEmail = "";
	String strUserSttWord = "";
%>

<%
	try {
		SLForumUserDelegate objForumUser = new SLForumUserDelegate(); //포럼회원 Delegate
		UserInfoDelegate objUserInfoDelegate = new UserInfoDelegate();

		CodeInfoDelegate objCodeInfo = new CodeInfoDelegate(); //코드관련 Delegate

		Hashtable objHashData = objForumUser.selectForumUserYN(strForumID, strUserID);
		String strUserStt_DB = StringUtil.getNVLNULL((String)objHashData.get("USER_STT"));

		Hashtable objHashUserInfoData = objUserInfoDelegate.selectUserInfo(strUserID);
		strUserEmail = StringUtil.getNVLNULL((String)objHashUserInfoData.get("EMAIL"));

		if(!strUserStt_DB.equals("")) { //현재 이 포럼과 관련된 경우
			strUserSttWord = objCodeInfo.lookUpCodeName("M04", strUserStt_DB);
		} else {
%>
				<script language="JavaScript">
				<!--
					location.href="/forum/induser/ForumJoinreq2.jsp?fid=<%=strForumID%>&openYN=<%=strOpenFlag%>&fnm=<%=strForumNM%>&loc=<%=strLoc%>&email=<%=strUserEmail%>";
				//-->
				</script>
<%
				return;


		} //end if(strUserStt_DB)
		
	} catch (AppException objAppEx) {
		
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		objMsgBean.setStrCode(objAppEx.getStrErrCode());
		objMsgBean.setStrMsg(objAppEx.getMessage());

		// 에러 발생 메세지 페이지로 이동한다.
%>

		<jsp:forward page="/common/message/ViewMsg.jsp"/>

<%
		return;
		
	}
%>

<html>
<head>
<title>의정자료 전자유통 시스템</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">

<link href="/css/System.css" rel="stylesheet" type="text/css">
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="247" height="125" border="0" cellpadding="0" cellspacing="0">
  <tr height="5"> 
    <td height="5" align="left" valign="top" class="td_forumpop"></td>
  </tr>
  <tr> 
    <td align="center" valign="middle"><table width="95%" border="0" cellspacing="4" cellpadding="0">
        <tr> 
          <td align="center">해당포럼에 <%=strUserSttWord%> 되어있습니다.</td>
        </tr>
      </table></td>
  </tr>
  <tr>
    <td height="25" align="center" valign="top"><table width="94%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td height="25" align="right">&nbsp;<a href="javascript:self.close();"><img src="/image/button/bt_confirm.gif" width="42" height="20" border="0"></a></td>
        </tr>
      </table></td>
  </tr>
</table>
</body>
</html>
