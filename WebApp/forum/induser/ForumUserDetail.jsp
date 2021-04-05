<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="nads.dsdm.app.forum.SLForumUserDelegate" %>
<%@ page import="nads.dsdm.app.activity.userinfo.UserInfoDelegate" %>
<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.pf.exception.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="kr.co.kcc.bf.config.*" %>

<%@ page import="nads.lib.message.MessageBean" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/> 

<%@ include file="/forum/common/CheckSessionPop.jsp" %>

<%
	/*개별포럼 페이지 파라미터 (포럼ID, 회원상태, 공개여부, 포럼명)*/
	String strForumID = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("fid"))); //포럼ID
	String strUserStt = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("uStt"))); //회원상태
	String strOpenFlag = ""; //공개여부
	String strForumNM = ""; //포럼명

	String strUserID = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("uid"))); //회원ID
	String strGbn = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("gbn")));
					//회원목록:없음 승인회원목록:O 가입신청목록:jReq 탈퇴신청목록:lReq
	String strTitle = "포럼 회원";
	String strTitleWidth = "12";
	if(strGbn.equals("jReq")) {
		strTitle = "가입신청 회원";
		strTitleWidth = "20";
	} else if (strGbn.equals("lReq")) {
		strTitle = "탈퇴신청 회원";
		strTitleWidth = "20";
	}

	Hashtable objHashData;
	SLForumUserDelegate objForumUser = new SLForumUserDelegate();

	ArrayList objChargeInfoArry = new ArrayList();
	ArrayList objUserChargeArry = new ArrayList();	
	UserInfoDelegate objUserInfoDelegate = new UserInfoDelegate();

	try {

		objHashData = objForumUser.selectForumUserInfo(strForumID, strUserID);

		objChargeInfoArry = objUserInfoDelegate.selectChargeCdInfo();
		objUserChargeArry = objUserInfoDelegate.selectUserCharge(strUserID);

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
<script src='/js/forum.js'></script>
<script language="JavaScript">
<!--
function fnChk(cmd) {
	if(cmd=="forceLeave") { //강제탈퇴
		openWinB('ForumLeavereq.jsp?fid=<%=strForumID%>&uStt=<%=strUserStt%>&cmd='+cmd+'&uids=<%=strUserID%>','winJoin','380','280');
		return;
	} else if(cmd=="entrust") { //운영자위임

		if(confirm("선택하신 회원에게 \n운영자의 권한을 위임하시겠습니까?")) {
		} else {
			return;
		}

	} else if(cmd=="joinRjt" || cmd=="leaveRjt") { //가입승인거부,탈퇴승인거부
		openWinB('ForumUserrjt.jsp?fid=<%=strForumID%>&uStt=<%=strUserStt%>&cmd='+cmd+'&uids=<%=strUserID%>','winJoin','380','280');
		return;

	} //end if(gbn)
	document.form.action="ForumUserProc.jsp"
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
                <td width="<%=strTitleWidth%>%" background="/image/forum/bg_forumpop_tit.gif"><span class="title"><%=strTitle%></span></td>
                <td align="left" background="/image/common/bg_titLine.gif">&nbsp;</td>
              </tr>
            </table></td>
        </tr>
        <tr> 
          <td height="30" align="left" class="text_s">회원의 상세정보 입니다.</td>
        </tr>
        <tr> 
          <td height="30" align="left"><img src="/image/forum/icon_forumpop_soti.gif" width="9" height="9">&nbsp;<span class="soti_forumpop">기본 정보 </span></td>
        </tr>
<%
	if(objHashData!=null) {

		String strUserNM = StringUtil.getNVLNULL((String)objHashData.get("USER_NM")); //이름
		String strJuminNo = StringUtil.getNVLNULL((String)objHashData.get("JUMIN_NO"));
		String strSex = ""; //성별
		if(strJuminNo.length()==13) {
			if((strJuminNo.substring(6,7)).equals("1") || (strJuminNo.substring(6,7)).equals("3"))
				strSex = "남자";
			else
				strSex = "여자";
		}

		String strOrganNM = StringUtil.getNVLNULL((String)objHashData.get("ORGAN_NM")); //소속기관
		String strDeptNM = StringUtil.getNVLNULL((String)objHashData.get("DEPT_NM")); //부서명


//		String strCGDuty = StringUtil.getNVLNULL((String)objHashData.get("CG_DUTY")); //담당업무



		String strEmail = StringUtil.getNVLNULL((String)objHashData.get("EMAIL")); //e-mail
		String strOfficeTel = StringUtil.getNVLNULL((String)objHashData.get("OFFICE_TEL")); //사무실전화
		String strCphone = StringUtil.getNVLNULL((String)objHashData.get("CPHONE")); //이동통신번호
		String strOprtrGbn = StringUtil.getNVLNULL((String)objHashData.get("OPRTR_GBN")); //회원유형
		strOprtrGbn = (strOprtrGbn.equals("Y"))?"운영자":"회원";
		
		String strJoinTS = (String)objHashData.get("JOIN_TS"); //가입일
		if(strJoinTS.length() > 8) {
			strJoinTS = strJoinTS.substring(0, 4) + "-" + strJoinTS.substring(4, 6) + "-" + strJoinTS.substring(6, 8);
		}

		String strRcntConnTS = (String)objHashData.get("RCNT_CONN_TS"); //최종접속일
		if(strRcntConnTS.length() > 14) {
			strRcntConnTS = strRcntConnTS.substring(0,4) + "-" + strRcntConnTS.substring(4,6) + "-" + strRcntConnTS.substring(6,8) + " "+strRcntConnTS.substring(8,10) + ":"+strRcntConnTS.substring(10,12) + ":"+strRcntConnTS.substring(12,14);
		}

		String strVisitCnt = StringUtil.getNVLNULL((String)objHashData.get("VISIT_CNT")); //접속회수

		String strRsnTitle = "가입 인사말";
		String strRsn = StringUtil.getNVLNULL((String)objHashData.get("JOIN_RSN")); //가입인사말 및 가입사유
		if(strGbn.equals("jReq")) {
			strRsnTitle = "가입 사유";
		} else if(strGbn.equals("lReq")) {
			strRsnTitle = "탈퇴 사유";
			strRsn = StringUtil.getNVLNULL((String)objHashData.get("LEAVE_RSN")); //탈퇴사유
		}
%>
		<!-- form -->
		<form name="form" method="post">

		<input type="hidden" name="fid" value="<%=strForumID%>">
		<input type="hidden" name="uStt" value="<%=strUserStt%>">
		<input type="hidden" name="uids" value="<%=strUserID%>">
		<input type="hidden" name="cmd">

		<!-- 운영자위임 -->
		<input type="hidden" name="uid1" value="<%=(String)session.getAttribute("USER_ID")%>"><!--세션에서 받아옴-->
		<input type="hidden" name="uid2" value="<%=strUserID%>">
        <tr> 
          <td align="left" valign="top"><table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
              <tr> 
                <td height="2" class="td_forumpop"></td>
                <td class="td_forumpop"></td>
              </tr>
              <tr> 
                <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 이름</td>
                <td class="td_lmagin"><%=strUserNM%></td>
              </tr>
              <tr> 
                <td width="22%" height="1" class="tbl-line"></td>
                <td width="78%" class="tbl-line"></td>
              </tr>
              <tr> 
                <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 성별</td>
                <td class="td_lmagin"><%=strSex%></td>
              </tr>
              <tr> 
                <td height="1" class="tbl-line"></td>
                <td class="tbl-line"></td>
              </tr>
              <tr> 
                <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 소속기관</td>
                <td class="td_lmagin"><%=strOrganNM%></td>
              </tr>
              <tr> 
                <td height="1" class="tbl-line"></td>
                <td class="tbl-line"></td>
              </tr>
              <tr> 
                <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 부서명</td>
                <td class="td_lmagin"><%=strDeptNM%></td>
              </tr>
              <tr> 
                <td height="1" class="tbl-line"></td>
                <td class="tbl-line"></td>
              </tr>
              <tr> 
                <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 담당업무</td>
                <td class="td_lmagin"> <b>주업무 : </b>
				<%
					String strMsortCd = "";
					String strCdNm = "";
					
					String strType = "";
					String strCharge = "";
					
					String strChecked = "";
					String strDisabled = "";
					String strFunction = "";
					String strChkName = "";
					String strSpace = "";
					String strMRemark = "";
					String strTextType="hidden";
					
					Hashtable objChargeInfoHt = new Hashtable();
					Hashtable objUserChargeHt = new Hashtable();
					for(int i=0; i < objChargeInfoArry.size(); i++){
						objChargeInfoHt = (Hashtable)objChargeInfoArry.get(i);
						strMsortCd = (String)objChargeInfoHt.get("MSORT_CD");
						strCdNm = (String)objChargeInfoHt.get("CD_NM");			
						
						strChecked = "";
						strDisabled = "";
						for(int k=0; k < objUserChargeArry.size(); k++){
							objUserChargeHt = (Hashtable)objUserChargeArry.get(k);
							strType = (String)objUserChargeHt.get("CHARGE_TYPE");
							strCharge = (String)objUserChargeHt.get("CHARGE_CD");
							if(strType.equals("S") && !strCharge.equals("999")){  ////담당업무가 기타항목이 아닐 경우 적용
								if(strCharge.equals(strMsortCd)){
									strDisabled = "disabled";
									break;
								}
								continue;
							}
							if(strType.equals("M") && strCharge.equals(strMsortCd)){
								strChecked = "checked";
								if(strCharge.equals("999")){   //담당업무가 기타항목에 적용
									strMRemark = (String)objUserChargeHt.get("REMARK");
								}
								break;
							}
						}
						if(strMsortCd.equals("999")){   //담당업무가 기타항목에 적용
							strDisabled = "";
							strChkName = "mchr999";
							strSpace = "";
							strFunction = "fun_make('m', '" + strMRemark + "')";
						}else{
							strChkName = "mchr" + Integer.toString(i);
							strFunction = "fun_check(this)";
							strSpace = "&nbsp;&nbsp;";
						}
				%>
                        <input name="<%=strChkName%>" type="checkbox" value="<%=strMsortCd%>"   <%=strChecked%>  disabled><%=strCdNm%><%=strSpace%>
				<%
					}
					if(!strMRemark.equals("")) {
				%>
						<input type="text" name="MRemark" class="textfield" size="15" maxlength='15' value="<%=strMRemark%>">
				<%
					}
				%>

				<br> <b>부업무 : </b>
				<%
					strChecked = "";
					strDisabled = "";
					strFunction = "";
					strTextType="hidden";
					strChkName = "";
					strSpace = "";
					String strSRemark = "";
					
					for(int i=0; i < objChargeInfoArry.size(); i++){
						objChargeInfoHt = (Hashtable)objChargeInfoArry.get(i);
						strMsortCd = (String)objChargeInfoHt.get("MSORT_CD");
						strCdNm = (String)objChargeInfoHt.get("CD_NM");
						
						strChecked = "";
						strDisabled = "";
						for(int k=0; k < objUserChargeArry.size(); k++){
							objUserChargeHt = (Hashtable)objUserChargeArry.get(k);
							strType = (String)objUserChargeHt.get("CHARGE_TYPE");
							strCharge = (String)objUserChargeHt.get("CHARGE_CD");
							if(strType.equals("M")){
								if(strCharge.equals(strMsortCd) && !strCharge.equals("999")){ //담당업무가 기타항목이 아닐 경우 적용
									strDisabled = "disabled";
									break;
								}
								continue;
							}
							if(strType.equals("S") && strCharge.equals(strMsortCd)){
								strChecked = "checked";
								if(strCharge.equals("999")){   //담당업무가 기타항목에 적용
									strSRemark = (String)objUserChargeHt.get("REMARK");
								}
								break;
							}
						}
						if(strMsortCd.equals("999")){   //담당업무가 기타항목에 적용
							strDisabled = "";
							strSpace = "";
							strChkName = "schr999";
							strFunction = "fun_make('s', '" + strSRemark + "')";
						}else{
							strChkName = "schr" + Integer.toString(i);
							strFunction = "fun_checkm(this)";
							strSpace = "&nbsp;&nbsp;";
						}
				%>
						<input name="<%=strChkName%>" type="checkbox" value="<%=strMsortCd%>" <%=strChecked%> disabled><%=strCdNm%><%=strSpace%>
				<%
					}
					if(!strSRemark.equals("")) {
				%>
						<input type="text" name="MRemark" class="textfield" size="15" maxlength='15' value="<%=strSRemark%>">
				<%
					}
				%>
				</td>
              </tr>
              <tr> 
                <td height="1" class="tbl-line"></td>
                <td class="tbl-line"></td>
              </tr>
              <tr> 
                <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> e-mail</td>
                <td class="td_lmagin"><%=strEmail%></td>
              </tr>
              <tr> 
                <td height="1" class="tbl-line"></td>
                <td class="tbl-line"></td>
              </tr>
              <tr> 
                <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 사무실 </td>
                <td class="td_lmagin"><%=strOfficeTel%></td>
              </tr>
              <tr> 
                <td height="1" class="tbl-line"></td>
                <td class="tbl-line"></td>
              </tr>
              <tr> 
                <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 이동통신번호</td>
                <td class="td_lmagin"><%=strCphone%></td>
              </tr>
              <tr> 
                <td height="2" class="tbl-line"></td>
                <td height="2" class="tbl-line"></td>
              </tr>
              <tr> 
                <td height="15"></td>
                <td height="15"></td>
              </tr>
              <tr> 
                <td height="2" class="td_forumpop"></td>
                <td class="td_forumpop"></td>
              </tr>
	<%
		if(strGbn.equals("O") || strGbn.equals("")) {
	%>
              <tr> 
                <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 회원유형</td>
                <td class="td_lmagin"><%=strOprtrGbn%></td>
              </tr>
              <tr> 
                <td height="1" class="tbl-line"></td>
                <td class="tbl-line"></td>
              </tr>
              <tr> 
                <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 가입일</td>
                <td class="td_lmagin"><%=strJoinTS%></td>
              </tr>
              <tr> 
                <td height="1" class="tbl-line"></td>
                <td class="tbl-line"></td>
              </tr>
              <tr> 
                <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 최종접속일자</td>
                <td class="td_lmagin"><%=strRcntConnTS%></td>
              </tr>
              <tr> 
                <td height="1" class="tbl-line"></td>
                <td class="tbl-line"></td>
              </tr>
              <tr> 
                <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 접속회수</td>
                <td class="td_lmagin"><%=strVisitCnt%>회</td>
              </tr>
              <tr> 
                <td height="1" class="tbl-line"></td>
                <td class="tbl-line"></td>
              </tr>
	<%
		} //end if(포럼회원정보)
	%>
              <tr> 
                <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> <%=strRsnTitle%></td>
                <td valign="top" class="td_box"><%=strRsn%></td>
              </tr>
              <tr> 
                <td height="2" class="tbl-line"></td>
                <td class="tbl-line"></td>
              </tr>
            </table></td>
        </tr>
        <tr> 
          <td height="35" align="left" valign="middle">
		<%
			//회원목록:없음 승인회원목록:O 가입신청목록:jReq 탈퇴신청목록:lReq
			if(strGbn.equals("O") && strOprtrGbn.equals("회원")) { //승인회원목록(탈퇴,운영자위임)
		%>
				<a href="javascript:fnChk('forceLeave');"><img src="/image/button/bt_break.gif" width="43" height="20" border="0"></a>&nbsp;
				<a href="javascript:fnChk('entrust');"><img src="/image/button/bt_entrustSysop.gif" width="83" height="20" border="0"></a>&nbsp;
		<%
			} else if(strGbn.equals("jReq")) { //가입신청목록(회원승인,승인거부)
		%>

				  <a href="javascript:fnChk('joinApv');"><img src="/image/button/bt_agreeMember.gif" width="67" height="20" border="0"></a>&nbsp;
				  <a href="javascript:fnChk('joinRjt');"><img src="/image/button/bt_rejectionAgree.gif" width="67" height="20" border="0"></a>&nbsp;

		<%
			} else if(strGbn.equals("lReq")) { //탈퇴신청목록(회원승인,승인거부)
		%>

				  <a href="javascript:fnChk('leaveApv');"><img src="/image/button/bt_agreeQuit.gif" width="67" height="20" border="0"></a>&nbsp;
				  <a href="javascript:fnChk('leaveRjt');"><img src="/image/button/bt_rejectionAgree.gif" width="67" height="20" border="0"></a>&nbsp;

		<%
			}
		%>
			<a href="javascript:history.go(-1);"><img src="/image/button/bt_list.gif" width="43" height="20" border="0"></a>

		  </td>
        </tr>
<%
	} //end if(objHashData)
%>
		</form>
        <tr> 
          <td height="15" align="left" valign="top"></td>
        </tr>
      </table>
      </td>
  </tr>
</table>
<%@ include file="/forum/common/BottomForumPop.jsp" %>
</body>
</html>
