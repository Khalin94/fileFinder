<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.CommRequestBoxDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	/******************************************************************************
	* Name		  : RCommReqBoxDelProc.jsp
	* Summary	  : 요구함 삭제  처리 기능.
	* Description : 요구함 정보를 삭제하고 요구함 목록 으로 이동한다.
	* 				※※ 체크 ※※
	*				 아직 에러처리후 포워딩 페이지로 넘기지 않음.
	*				 요구함 삭제시 요구목록에 데이터가 있으면 삭제가 안됨(체크하기)
	*				 confirm 으로 체크하기
	******************************************************************************/
%>

<%
	UserInfoDelegate objUserInfo = null;
	CDInfoDelegate objCdinfo = null;
%>
<%@ include file="../../common/RUserCodeInfoInc.jsp" %>

<%
	/*************************************************************************************************/
	/** 					파라미터 체크 Part 														  */
	/*************************************************************************************************/
	 /** 요구함 정보 설정 */
	String[] arrReqBoxIDs = request.getParameterValues("ReqBoxID");

	if(arrReqBoxIDs.length < 1) {
  		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
	  	objMsgBean.setStrCode("DSPARAM-0000");
  		objMsgBean.setStrMsg("파라미터(요구함 ID)가 전달되지 않았습니다");
	  	out.println("ParamError:" + "파라미터(요구함 ID)가 전달되지 않았습니다");
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

	String strDelURL = request.getParameter("DelURL");
	String strReqBoxNm = request.getParameter("ReqBoxNm");

	boolean blnEditOk = false; //삭제 여부.
	try {
		/********* 대리자 정보 설정 *********/
		CommRequestBoxDelegate objReqBox=new CommRequestBoxDelegate();

		/********* 데이터 삭제 하기  **************/
		blnEditOk = ((Boolean)objReqBox.removeRecords(arrReqBoxIDs)).booleanValue();

		if(!blnEditOk) {
			objMsgBean.setMsgType(MessageBean.TYPE_WARN);
			objMsgBean.setStrCode("DSDATA-0012");
%>
			<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
			return;
		}
	} catch(AppException objAppEx) {
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		objMsgBean.setStrCode(objAppEx.getStrErrCode());
		objMsgBean.setStrMsg(objAppEx.getMessage());
		out.println("<br>Error!!!" + objAppEx.getMessage());
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}
%>

<html>
<script language="JavaScript">
		//2018-09-20 hgyoo 화면 로딩창 수정
		parent.notProcessing();
		
		alert("요구함이 정상적으로 삭제되었습니다 ");
		
        parent.location.reload();
		self.close();
</script>
</html>

