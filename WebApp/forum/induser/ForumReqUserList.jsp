<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="nads.dsdm.app.forum.SLForumUserDelegate" %>
<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.pf.exception.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="kr.co.kcc.bf.config.*" %>
<%@ page import="kr.co.kcc.pf.util.PageCount" %>

<%@ page import="nads.lib.message.MessageBean" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/> 

<%@ include file="/forum/common/CheckSessionPop.jsp" %>

<%
	/*개별포럼 페이지 파라미터 (포럼ID, 회원상태, 공개여부, 포럼명)*/
	String strForumID = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("fid"))); //포럼ID
	String strUserStt = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("uStt"))); //회원상태
	String strOpenFlag = ""; //공개여부
	String strForumNM = ""; //포럼명

	String strGbn = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("gbn"))); //jReq:가입신청 lReq:탈퇴신청
	String strTitle = "가입";
	String strUsersStt = "001";
	String strCmdApv = "joinApv";
	String strCmdRjt = "joinRjt";
	String strApvBtn = "bt_selectAgree.gif";
	if(strGbn.equals("lReq")) {
		strTitle = "탈퇴";
		strUsersStt = "004";
		strCmdApv = "leaveApv";
		strCmdRjt = "leaveRjt";
		strApvBtn = "bt_agreeQuit.gif";
	}
	String strSrchText =  nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("strSrchText")));
	//out.print("<br>strGbn="+strGbn+":::strSrchText="+strSrchText);

	String strCurrentPage = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVL(request.getParameter("strCurrentPage"), "1"));	//현재 페이지
	String strCountPerPage;

	try {
		//CountPerPage를 가져온다.
		Config objConfig = PropertyConfig.getInstance();
		strCountPerPage = objConfig.get("page.rowcount");
		//strCountPerPage = "2";
	} catch (ConfigException objConfigEx) {
		strCountPerPage = StringUtil.getNVL(request.getParameter("strCountPerPage"), "10");
	}

	ArrayList objForumUserData;
	SLForumUserDelegate objForumUser = new SLForumUserDelegate();
	
	try {

		objForumUserData = objForumUser.selectForumUser(strForumID, strUsersStt, strSrchText, strCurrentPage, strCountPerPage);

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

	String strTotalCount = (String)((Hashtable)objForumUserData.get(0)).get("TOTAL_COUNT");
	int intTotalCount = Integer.valueOf(strTotalCount).intValue();
%>

<html>
<head>
<title>의정자료 전자유통 시스템</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link href="/css/System.css" rel="stylesheet" type="text/css">
<script src='/js/forum.js'></script>
<script language="JavaScript">
<!--
function fnChk(actionURL) {
	if(document.form.strSrchText.value=="") {
		alert("검색어를 입력해주세요");
		document.form.strSrchText.focus();
		return false;
	}
	document.form.strCurrentPage.value = "1";
	document.form.action = actionURL;
	document.form.submit();
}

function fnChkOprtr(cmd) {
	var check_num = 0;
	var uids = "";
	for(i= 0; i < document.form.elements.length ;i++){ 
		 if(document.form.elements[i].name=='choice' && document.form.elements[i].checked==true){
			check_num ++;
			uids = uids + document.form.elements[i].value + "||"
		 }
	}

	if(check_num==0) {
		alert("항목을 선택해 주세요");
		return;
	} else {
		uids = uids.substring(0, uids.length-2);

		if(cmd=="joinRjt" || cmd=="leaveRjt") { //가입승인거부, 탈퇴승인거부
			openWinB('ForumUserrjt.jsp?fid=<%=strForumID%>&uStt=<%=strUserStt%>&cmd='+cmd+'&uids='+uids,'winJoin','380','280');
			return;
		}
	}

	document.form.action="ForumUserProc.jsp"
	document.form.uids.value = uids;	
	document.form.cmd.value = cmd;
	document.form.submit();
}
//-->
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<%@ include file="/forum/common/MenuTopForumPop.jsp" %>
<table width="800" height="450" border="0" cellpadding="0" cellspacing="0">
  <tr align="left" valign="top">
    <td width="149" background="/image/forum/bg_forumLeft.gif"> 
<%@ include file="/forum/common/MenuLeftForumPop.jsp" %>
</td>
    <td align="center"><table width="589" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td height="21" align="left" valign="top"></td>
        </tr>
        <tr> 
          <td align="left" valign="top"><table width="100%" height="23" border="0" cellpadding="0" cellspacing="0">
              <tr> 
                <td width="18%" background="/image/forum/bg_forumpop_tit.gif"><span class="title"><%=strTitle%> 신청 회원</span></td>
                <td width="82%" align="left" background="/image/common/bg_titLine.gif">&nbsp;</td>
              </tr>
            </table></td>
        </tr>
        <tr> 
          <td height="50" align="left" class="text_s">이 포럼에 <%=strTitle%> 신청한 회원들의 목록입니다.
		  <br> 이름을 클릭하시면 회원의 상세 정보를 확인 할 수 있습니다.</td>
        </tr>
		<!-- form -->
		<form name="form" method="post" onSubmit="return fnChk('<%=request.getRequestURI()%>');">
		<input type="hidden" name="gbn" value="<%=strGbn%>">
		<input type="hidden" name="fid" value="<%=strForumID%>">
		<input type="hidden" name="uStt" value="<%=strUserStt%>">
		<input type="hidden" name="strCurrentPage">
		<input type="hidden" name="cmd">
		<!-- form(가입승인/탈퇴승인) -->
		<input type="hidden" name="uids">
        <tr> 
          <td align="left" valign="top"><table width="100%" border="0" cellpadding="0" cellspacing="1" bgcolor="CCCCCC">
              <tr> 
                <td height="45" align="center" bgcolor="#F3F3F3"><table width="58%" border="0" cellspacing="3" cellpadding="0">

                    <tr> 
                      <td width="33%" align="left"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6" align="absmiddle"> 
                        <strong>회원이름 검색:</strong></td>
                      <td width="49%" align="left"><strong> 
                        <input name="strSrchText" type="text" class="textfield" style="WIDTH: 150px" value="<%=strSrchText%>">
                        </strong></td>
                      <td width="18%" align="left"><input type="image" src="/image/button/bt_gumsack_icon.gif" border=0 width="47" height="19" align="absmiddle"></td>
                    </tr>
                  </table></td>
              </tr>
            </table></td>
        </tr>
        <tr> 
          <td height="10" align="left"></td>
        </tr>
        <tr> 
          <td height="30" align="left" valign="top"><table width="589" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td width="395" height="30"><img src="/image/forum/icon_forumpop_soti.gif" width="9" height="9">&nbsp;<span class="soti_forumpop">신청 회원 </span></td>
                <td width="194" height="25" align="right" class="text_s"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6" align="absmiddle"> 
                  <strong></strong>신청회원: <%=strTotalCount%>명&nbsp;&nbsp; </td>
              </tr>
            </table></td>
        </tr>
        <tr> 
          <td align="left" valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr class="td_forumpop"> 
                <td width="34" height="2"></td>
                <td width="1"></td>
                <td width="59" height="2"></td>
                <td width="144" height="2"></td>
                <td width="240" height="2"></td>
                <td width="111" height="2"></td>
              </tr>
              <tr class="td_top"> 
                <td height="22" align="center"><input type="checkbox" name="allChoice" onClick="javascript:all_choice()"></td>
                <td width="1" height="22"></td>
                <td height="22" align="center">NO</td>
                <td height="22" align="center">회원 이름</td>
                <td height="22" align="center">부서</td>
                <td height="22" align="center">신청일</td>
              </tr>
              <tr> 
                <td height="1" class="td_forumpop"></td>
                <td height="1" class="td_forumpop"></td>
                <td height="1" class="td_forumpop"></td>
                <td height="1" class="td_forumpop"></td>
                <td height="1" class="td_forumpop"></td>
                <td height="1" class="td_forumpop"></td>
              </tr>
				<%
				if(intTotalCount != 0){
					for(int i=1; i<objForumUserData.size(); i++) {
						Hashtable objHashForumUserData = (Hashtable)objForumUserData.get(i);

						String strRNUM = (String)objHashForumUserData.get("RNUM"); //rownum
						String strUserID = (String)objHashForumUserData.get("USER_ID"); //회원ID
						String strUserNM = (String)objHashForumUserData.get("USER_NM"); //회원명
						String strDeptNM = (String)objHashForumUserData.get("DEPT_NM"); //부서명

						String strJoinReqTS = (String)objHashForumUserData.get("JOIN_REQ_TS"); //가입신청일
						if(strJoinReqTS.length() > 8) {
							strJoinReqTS = strJoinReqTS.substring(0, 4) + "-" + strJoinReqTS.substring(4, 6) + "-" + strJoinReqTS.substring(6, 8);
						}
						String strLeaveReqTS = (String)objHashForumUserData.get("LEAVE_REQ_TS"); //탈퇴신청일
						if(strLeaveReqTS.length() > 8) {
							strLeaveReqTS = strLeaveReqTS.substring(0, 4) + "-" + strLeaveReqTS.substring(4, 6) + "-" + strLeaveReqTS.substring(6, 8);
						}
						String strReqTS = (strGbn.equals("jReq"))?strJoinReqTS:strLeaveReqTS; //신청일

						String strJoinRsn = (String)objHashForumUserData.get("JOIN_RSN"); //가입동기
						String strLeaveRsn = (String)objHashForumUserData.get("LEAVE_RSN"); //탈퇴동기
						String strRsn = (strGbn.equals("jReq"))?strJoinRsn:strLeaveRsn; //동기

						String strH = "1";
						if (i==objForumUserData.size()-1) {
							strH = "2";
						}
				%>
					<tr> 
						<td rowspan="3" align="center"><input type="checkbox" name="choice" value="<%=strUserID%>"></td>
						<td class="tbl-line"></td>
						<td height="22" align="center"><%=strRNUM%></td>
						<td height="22" align="center"><a href="/forum/induser/ForumUserDetail.jsp?fid=<%=strForumID%>&uStt=<%=strUserStt%>&uid=<%=strUserID%>&gbn=<%=strGbn%>"><%=strUserNM%></a></td>
						<td height="22" align="center"><%=strDeptNM%></td>
						<td height="22" align="center"><%=strReqTS%></td>
					</tr>
					<tr height="1"> 
						<td height="1"></td>
						<td height="1" colspan="4"  background="/image/common/line_dot_wide.gif"></td>
					</tr>
					<tr> 
						<td class="tbl-line" ></td>
						<td height="22" colspan="4" class="td_lmagin"><%=strRsn%></td>
					</tr>
					<tr> 
						<td height="<%=strH%>" class="tbl-line"></td>
						<td height="<%=strH%>" class="tbl-line"></td>
						<td height="<%=strH%>" class="tbl-line"></td>
						<td height="<%=strH%>" class="tbl-line"></td>
						<td height="<%=strH%>" class="tbl-line"></td>
						<td height="<%=strH%>" class="tbl-line"></td>
					</tr>
				<%
					} //end for
				} else {
				%>
					<tr> 
					  <td height="22" colspan=6 align="center">해당 데이타가 없습니다.</td>
					</tr>
					<tr class="tbl-line"> 
						<td height="2" colspan=6 align="center"></td>
					</tr>
				<%
				} //end if
				%>

            </table></td>
        </tr>
        <tr> 
          <td height="35" align="center" valign="middle"><%=PageCount.getLinkedString(strTotalCount , strCurrentPage, strCountPerPage) %></td>
        </tr>
        <tr height="3"> 
          <td height="3" align="left" valign="top" background="/image/common/line_table.gif"></td>
        </tr>
        <tr> 
          <td height="40" align="left" valign="middle"><a href="javascript:fnChkOprtr('<%=strCmdApv%>');"><img src="/image/button/<%=strApvBtn%>" width="67" height="20" border="0"></a>&nbsp;<a href="javascript:fnChkOprtr('<%=strCmdRjt%>');"><img src="/image/button/bt_rejectionAgree.gif" width="67" height="20" border="0"></a></td>
        </tr>
		</form>
		<!--form-->
        <tr> 
          <td height="10" align="left" valign="top"></td>
        </tr>
      </table>
      </td>
  </tr>
</table>
<%@ include file="/forum/common/BottomForumPop.jsp" %>
</body>
</html>
