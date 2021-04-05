<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.common.ums.UmsInfoDelegate" %>
<%@ include file="/forum/common/CheckSessionPop.jsp" %>

<%
	System.out.println("<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
	String strMessage = "";
	String strError = "no";
	
	try
	{	
		String strUserId = (String)session.getAttribute("USER_ID");

		nads.dsdm.app.activity.userinfo.UserInfoDelegate objUserInfoDelegate = new nads.dsdm.app.activity.userinfo.UserInfoDelegate();
		
		String strSttChgRsn   = StringUtil.getNoTagStr(request.getParameter("stt_chg_rsn"));
		String strSystemUseGbn = request.getParameter("system_use_gbn")==null?"":request.getParameter("system_use_gbn");
		strSystemUseGbn = StringUtil.getNoTagStr(strSystemUseGbn);
		
		if(strSystemUseGbn.equals("G19C02")){
			strSystemUseGbn = "G19C04";
		}else if(strSystemUseGbn.equals("G19C03")){
			strSystemUseGbn = "G19C01";
		}else if(strSystemUseGbn.equals("G19C04")){
			strSystemUseGbn = "G19C04";
		}else{
			strSystemUseGbn =  strSystemUseGbn;
		}

		Vector objSttVt = new Vector();
		
		objSttVt.add(strSttChgRsn);//탈퇴사유
		objSttVt.add(strUserId);
		objSttVt.add(strSystemUseGbn);
		objSttVt.add(strUserId);
		System.out.println("여기?");
		int intResult = objUserInfoDelegate.updateStatus(objSttVt);
		System.out.println("응?");
		
		//--out.println("Result : " + intResult);
		strMessage = "탈퇴 신청이 완료 되었습니다.";
		//--response.sendRedirect("SendFax.jsp");
		
		
		/** SMS 전송 시작 **/
		nads.dsdm.app.join.JoinMemberDelegate objJoinMemberDelegate = new nads.dsdm.app.join.JoinMemberDelegate ();
		nads.dsdm.app.common.ums.UmsInfoDelegate objUmsDelegate = new nads.dsdm.app.common.ums.UmsInfoDelegate();

		Hashtable objAdminInfoHt = null;
		Hashtable objUserInfoHt = null;
		Hashtable hashSmsInfo = new Hashtable();
		String strSendPhoneNo = null;
		String strReturnPhoneNo=null;
		String strSmsMsg=null;
		String strSystemGbn="S13002";

		String strServiceGbn="004";//003:가입신청 004:가입승인 005:탈퇴대기
		String strOrganId=null;
		String strOrganNm=null;
		String strName=null;		
		
		
			//관리자 정보 조회

			objAdminInfoHt = objJoinMemberDelegate.getUserInfo("ADMIN");
			objUserInfoHt = objJoinMemberDelegate.getUserInfo(strUserId);
			strSendPhoneNo = StringUtil.ReplaceString((String)objAdminInfoHt.get("CPHONE"), "-", "");
			strReturnPhoneNo = StringUtil.ReplaceString((String)objUserInfoHt.get("CPHONE"), "-", "");
			strOrganId = (String)objUserInfoHt.get("ORGAN_ID");
			strOrganNm = (String)objUserInfoHt.get("ORGAN_NM");
			strName = (String)objUserInfoHt.get("USER_NM");
			strSmsMsg = strName +"님의 [의정자료 전자유통 시스템] 탈퇴신청 요청입니다.";


			int intSmsSendResult = 0;
/*
			out.println("=====>"+strSendPhoneNo);
			out.println("=====>"+strReturnPhoneNo);
			out.println("=====>"+strSmsMsg);
			out.println("=====>"+strSystemGbn);
			out.println("=====>"+strServiceGbn);
			out.println("=====>"+strOrganId);
			out.println("=====>"+strUserID);
			out.println("=====>"+strOrganNm);
			out.println("=====>"+strName);
*/
			// 서류제출의 경우만 SMS & email 등록한다.
			// SMS 발송 Hashtable 담자
			hashSmsInfo.put("SEND_PHONE_NO", strSendPhoneNo);
			hashSmsInfo.put("RETURN_NO", strReturnPhoneNo);
			//hashSmsInfo.put("SEND_STATUS", strSendStatus);
			hashSmsInfo.put("SEND_STATUS", "1"); // 즉시발송 : 1, 대기 : 9
			hashSmsInfo.put("MSG", strSmsMsg);
			hashSmsInfo.put("SYSTEM_GBN", strSystemGbn);
			hashSmsInfo.put("SERVICE_GBN", strServiceGbn);
			hashSmsInfo.put("DEPT_GBN", strOrganId);
			hashSmsInfo.put("USER_ID", strUserId);
			hashSmsInfo.put("DEPT_NM", strOrganNm); // 2004-04-13 추가 1
			hashSmsInfo.put("USER_NM", strName); // 2004-04-13 추가 2

			

			intSmsSendResult = objUmsDelegate.insertSMS(hashSmsInfo);	
			System.out.println("응?");
			//intSmsSendResult = 1;

			if (intSmsSendResult < 1) System.out.println("[RMakeReqDocSendProc.jsp] SMS 발송 결과 사실은 여기서 에러가 발생했습니다. T_T");

			/** SMS 전송 끝 **/			
		
		
		
		
	}
	catch(AppException objAppEx)
	{	
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  		objMsgBean.setStrCode(objAppEx.getStrErrCode());
  		objMsgBean.setStrMsg(objAppEx.getMessage());
  		out.println("<br>Error!!!" + objAppEx.getMessage());
		strError = "yes";
%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%  	
		return;
	}
	
%>

<script language="javascript">
<!--
	alert("<%=strMessage%>");
		
	<%if(strError.equals("no")){%>
	self.window.close(); 
	<%}else{%>
	history.back();
	<%}%>
//-->
</script>
