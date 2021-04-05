<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.cmtmanager.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.*" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>

<%@ page import="nads.lib.message.MessageBean" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	UserInfoDelegate objUserInfo =null;	
	CDInfoDelegate objCdinfo =null;
%>

<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>


<%		
	//session_user_id	
	String strUpdrID = objUserInfo.getUserID();	
	
	//command
	String strCmd = StringUtil.getNVLNULL(request.getParameter("strCmd")).trim();	
	//관계기관 상위기관 ID(선택된 기관)
	String strRelOrganID = StringUtil.getNVLNULL(request.getParameter("strOrganID")).trim();	
	//기관관계
	String strRelCd = StringUtil.getNVLNULL(request.getParameter("strRelCd")).trim();
	//조회 문자집합 인덱스
	String strOrganIndex = StringUtil.getNVLNULL(request.getParameter("strOrganIndex")).trim();
	//선택된 기관	
	String[] arrOrganList 		= request.getParameterValues("ckOrgan");
	
	//기관 Array
	String[] arrOrganID 		= request.getParameterValues("strOrganIDs");
	//기관정렬순서 Array
	String[] arrOrd 				= request.getParameterValues("strOrd");
	
	int intResult = 0;	
	
	/** 관계기관 관련 delegate */
	CmtManagerDelegate  objRelationMgr = new CmtManagerDelegate();

	if(strCmd.equals("C")) {	
		try {
			intResult = objRelationMgr.setRelOrganList(strRelOrganID, strRelCd, arrOrganList, strUpdrID);	
		} catch (AppException objAppEx) {
			
			objMsgBean.setMsgType(MessageBean.TYPE_ERR);
			objMsgBean.setStrCode(objAppEx.getStrErrCode());
			objMsgBean.setStrMsg(objAppEx.getMessage());
		
			// 에러 발생 메세지 페이지로 이동한다.
%>
			<jsp:forward page="../common/message/ViewMsg.jsp"/>
<%
			return;
		
		}
%>	
			
		<script language="javascript">
		<!--
			alert("<%=String.valueOf(intResult)%>개의 기관관계가 설정되었습니다.");
			opener.getList();
			this.close();		
		//-->
		</script>

<%	} else if(strCmd.equals("D")) { //삭제인 경우
			try {
				System.out.println("arrOrganList : "+arrOrganList);
				System.out.println("strRelOrganID : "+strRelOrganID);
				System.out.println("strRelCd : "+strRelCd);
				System.out.println("strUpdrID : "+strUpdrID);
				intResult = objRelationMgr.delRelOrganList(arrOrganList, strRelOrganID, strRelCd, strUpdrID);	
			} catch (AppException objAppEx) {
			
				objMsgBean.setMsgType(MessageBean.TYPE_ERR);
				objMsgBean.setStrCode(objAppEx.getStrErrCode());
				objMsgBean.setStrMsg(objAppEx.getMessage());
		
				// 삭제 중 에러발생하여 에러 발생 메세지 페이지로 이동
%>
				<jsp:forward page="../common/message/ViewMsg.jsp"/>
<%
				return;		
			}
%>
			<form name="frmList" method="post">
				<input type="hidden" name="strOrganID" value="<%=strRelOrganID%>">
				<input type="hidden" name="strRelCd" value="<%=strRelCd%>">
			</form>

			
			<script language="javascript">
			<!--
				alert("<%=String.valueOf(intResult)%>개의 기관관계가 삭제되었습니다.");								
				frmList.action = "SubmissionOrgan.jsp";
				frmList.submit();
			//-->
			</script>

<% } else if(strCmd.equals("A")) { //전체 관계 설정인 경우

		try {
			intResult = objRelationMgr.setAllRelOrganList(strRelOrganID, strRelCd, strUpdrID);	
		} catch (AppException objAppEx) {
			
			objMsgBean.setMsgType(MessageBean.TYPE_ERR);
			objMsgBean.setStrCode(objAppEx.getStrErrCode());
			objMsgBean.setStrMsg(objAppEx.getMessage());
		
			// 에러 발생 메세지 페이지로 이동한다.
%>
			<jsp:forward page="../common/message/ViewMsg.jsp"/>
<%
			return;
		
		}
%>	
			
		<script language="javascript">
		<!--
			alert("<%=String.valueOf(intResult)%>개의 기관관계가 설정되었습니다.");
			opener.getList();
			this.close();		
		//-->
		</script>

<% } else if(strCmd.equals("Z")) { //정렬순서저장인 경우

		try {
			intResult = objRelationMgr.setOrders(arrOrganID, arrOrd, strRelOrganID, strRelCd, strUpdrID);	
		} catch (AppException objAppEx) {
				
			objMsgBean.setMsgType(MessageBean.TYPE_ERR);
			objMsgBean.setStrCode(objAppEx.getStrErrCode());
			objMsgBean.setStrMsg(objAppEx.getMessage());
			
			// 에러 발생 메세지 페이지로 이동한다.
%>
			<jsp:forward page="../common/message/ViewMsg.jsp"/>
<%
			return;
		
		}
%>	

			<form name="frmList" method="post">
				<input type="hidden" name="strOrganID" value="<%=strRelOrganID%>">
				<input type="hidden" name="strRelCd" value="<%=strRelCd%>">
			</form>

			
			<script language="javascript">
			<!--
				alert("정렬순서가 저장되었습니다.");								
				frmList.action = "SubmissionOrgan.jsp";
				frmList.submit();
			//-->
			</script>
				

<% } %>