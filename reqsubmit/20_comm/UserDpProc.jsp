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
	
	String strRelOrganID = StringUtil.getNVLNULL(request.getParameter("strOrganID")).trim();	
	//기관관계
	String strRelCd = StringUtil.getNVLNULL(request.getParameter("strRelCd")).trim();
	//조회 문자집합 인덱스
	String strOrganIndex = StringUtil.getNVLNULL(request.getParameter("strOrganIndex")).trim();
	//선택된 기관	
	String[] arrOrganList 		= request.getParameterValues("ckUser");
	
	int intResult = 0;	
	int intcount = 0;	
	
	/** 관계기관 관련 delegate */
	CmtManagerDelegate  objRelationMgr = new CmtManagerDelegate();

		try {
			intResult = objRelationMgr.clearUpdateBrg(strRelOrganID);
			if(intResult > 0 && arrOrganList != null && arrOrganList.length > 0){
				for(int i = 0; i < arrOrganList.length; i++){
					intResult = objRelationMgr.updateRepUser(strRelOrganID,arrOrganList[i]);
					intcount++;
				}
			}
			
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
			alert("대표담당자가 설정되었습니다.");
			history.back(-1);
		//-->
		</script>

<%  %>