<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="nads.dsdm.app.forum.SLForumUserDelegate" %>
<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.pf.exception.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="nads.lib.session.*" %>
<%@ page import="nads.lib.message.MessageBean" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%@ include file="/forum/common/CheckSessionPop.jsp" %>

<%
	String strForumID = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("fid"))); //포럼ID
	String strOpenFlag = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("openYN"))); //공개여부
	String strUserID = (String)session.getAttribute("USER_ID"); //회원ID
	String uStt = "";
	// OO:공개포럼운영자 CO:비공개포럼운영자 Y:포럼가입자(정상) YL:탈퇴신청/탈퇴거부자 N:미가입자 NJ:가입신청/가입거부자
	// 가입신청/가입거부자, 탈퇴신청/탈퇴거부자 에게는 가입/탈퇴 버튼을 보여주지 않는다. (포럼가입자에게는 탈퇴버튼을, 미가입자에게는 가입버튼을 표시)

	String strParam = request.getQueryString(); //게시판으로 바로 넘어가는 경우 사용

	String actionURL = "";
	if(strParam.indexOf("actionURL") > 0) {
		actionURL = strParam.substring(strParam.indexOf("actionURL") + "actionURL=".length(), strParam.length()) + "&";
	} else {
		actionURL = "/forum/indmain/ForumIndMain.jsp?";
	}

	actionURL += "fid="+strForumID;

/*
	out.print("strForumID : "+strForumID);
	out.print("<br>strOpenFlag : "+strOpenFlag);
	out.print("<br>strUserID : "+strUserID);
*/

	try {
		SLForumUserDelegate objForumUser = new SLForumUserDelegate();

		Hashtable objHashData = objForumUser.selectForumUserYN(strForumID, strUserID);
		String strUserStt_DB = StringUtil.getNVLNULL((String)objHashData.get("USER_STT")); //회원상태
		String strOprtrGbn_DB = StringUtil.getNVLNULL((String)objHashData.get("OPRTR_GBN")); //운영자구분

		if(strUserStt_DB.equals("") || strUserStt_DB.equals("001") || strUserStt_DB.equals("002")) { //가입이 안된경우
			if(strUserStt_DB.equals("001") || strUserStt_DB.equals("002"))
				actionURL += "&uStt=NJ";

			if(strOpenFlag.equals("Y")) { //공개포럼인 경우
				actionURL += "&uStt=N";

			} else { //비공개포럼인 경우
%>
					<script language="JavaScript">
					<!--
						alert("해당포럼은 비공개포럼입니다.\n 포럼가입 후 이용해주십시요.");
						self.close();
					//-->
					</script>
<%
					return;

			}
		} else { //가입된 경우
				int intCnt = objForumUser.updateForumVisit(strForumID, strUserID); //방문처리

				if (intCnt < 1) {
		%>
					<jsp:forward page="/common/message/ViewMsg.jsp"/>			
		<%
					return;

				} else {
					if(strOprtrGbn_DB.equals("Y")) { //운영자인 경우

						actionURL += (strOpenFlag.equals("Y")) ? "&uStt=OO" : "&uStt=CO";
						/*
						if(strOpenFlag.equals("Y")) {
							actionURL += "&uStt=OO";
						} else { //비공개포럼 && 운영자인 경우
							actionURL += "&uStt=CO";
						}
						*/

					} else { //운영자가 아닌경우

						actionURL += (strUserStt_DB.equals("003")) ? "&uStt=Y" : "&uStt=YL";
						/*
						if(strUserStt_DB.equals("004")) { //탈퇴신청자
							actionURL += "&uStt=L";
						} else {
							actionURL += "&uStt=Y";
						}
						*/
					}

				} //방문처리
		}
		
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

	response.sendRedirect(actionURL);
	return;

	//out.print("actionURL = "+actionURL);
%>