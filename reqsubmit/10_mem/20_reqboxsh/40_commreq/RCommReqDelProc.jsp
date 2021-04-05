<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.cmtsubmt.CmtSubmtReqBoxDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	/******************************************************************************
	 * Name		  : RCommReqDelProc.jsp
	 * Summary	  : 신청함 삭제 처리 기능.
 	 * Description : 신청함 정보를 삭제하고 신청함 목록 으로 이동한다.
	 * 				※※ 체크 ※※
	 *				 아직 에러처리후 포워딩 페이지로 넘기지 않음.
	 ******************************************************************************/
	UserInfoDelegate objUserInfo =null;
	CDInfoDelegate objCdinfo =null;
%>
<%@ include file="../../../common/RUserCodeInfoInc.jsp" %>

<%
	/*************************************************************************************************/
	/** 					파라미터 체크 Part 														  */
	/*************************************************************************************************/
	/** 요구함 정보 설정 */  
	String strReqBoxID = (String)request.getParameter("ReqBoxID");
	String[] arrReqInfoIDs = request.getParameterValues("ReqInfoIDs");
	
	if(!StringUtil.isAssigned(strReqBoxID)){
  		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
	  	objMsgBean.setStrCode("DSPARAM-0000");
  		objMsgBean.setStrMsg("파라미터(신청함 ID)가 전달되지 않았습니다");
%>
	  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
	  	return;
	  }
%>

<%
	/*************************************************************************************************/
	/** 					데이터 처리 Part 														  */
	/*************************************************************************************************/
	
	boolean blnOk=false; //삭제 여부.
	try {
		/********* 대리자 정보 설정 *********/
		CmtSubmtReqBoxDelegate objReqBox=new CmtSubmtReqBoxDelegate();  

		/********* 데이터 삭제 하기  **************/
		if (arrReqInfoIDs == null || arrReqInfoIDs.length < 1) {
			blnOk =((Boolean)objReqBox.removeRecord(strReqBoxID)).booleanValue(); 
		} else {
			blnOk =((Boolean)objReqBox.removeRecord(strReqBoxID, arrReqInfoIDs)).booleanValue(); 
		}
		
		if(!blnOk) {
	 		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  			objMsgBean.setStrCode("DSDATA-0012");
  			objMsgBean.setStrMsg("요청하신 신청함 정보를 삭제하지 못했습니다");
	  		//out.println("<br>Error!!!" + "요청하신 요구함 정보를 수정하지 못했습니다");   
%>
  			<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%  	
	  		return;   	
	   	}
 	} catch(AppException objAppEx) { 
 		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		System.out.println("SysErrorCode:" + objAppEx.getStrErrCode());
  		objMsgBean.setStrCode("SYS-00010");//AppException에러.
	  	objMsgBean.setStrMsg(objAppEx.getMessage());
  		//out.println("<br>Error!!!" + objAppEx.getMessage());
%>
	  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%  	
	  	return; 
 	}
%>
<%
	/*************************************************************************************************/
	/** 					페이지 전환 Part 														  */
	/*************************************************************************************************/
%>
<html>
<script language="JavaScript">
		alert("제출신청함 정보가 삭제되었습니다 ");
		location.href="./RCommReqList.jsp";
</script>
</html>