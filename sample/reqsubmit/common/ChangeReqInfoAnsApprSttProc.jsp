<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.bf.config.*"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.RequestInfoDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%
 UserInfoDelegate objUserInfo =null;
 CDInfoDelegate objCdinfo =null;
%>
<%@ include file="RUserCodeInfoInc.jsp" %>

<%
 /*************************************************************************************************/
 /** 					파라미터 체크 Part 														  */
 /*************************************************************************************************/
  String strReqInfoID=(String)request.getParameter("ReqInfoID");
  String strAnsApprStt=(String)request.getParameter("ANSW_PERM_CD");

  boolean blnFlag=true;
  String strMessage="";
  if(!StringUtil.isAssigned(strReqInfoID)){
  	blnFlag=false;
  	strMessage="파라미터(요구정보 ID)가 전달되지 않았습니다";
  }
  if(!StringUtil.isAssigned(strAnsApprStt)){
  	blnFlag=false;
  	strMessage="답변승인상태 코드가 전달되지 않았습니다";
  }
  if(blnFlag==false){
  	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	objMsgBean.setStrCode("DSPARAM-0000");
  	objMsgBean.setStrMsg(strMessage);
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%
  	return;
  }//endif
%>

<%
 /*************************************************************************************************/
 /** 					데이터 처리 Part 														  */
 /*************************************************************************************************/

 boolean blnEditOk=false; //변경 여부.
 try{
   /********* 대리자 정보 설정 *********/
   RequestInfoDelegate objReqInfo=new RequestInfoDelegate();

   /********* 답변승인상태 변경하기  **************/
   blnEditOk =((Boolean)objReqInfo.changeAnsApprStt(strReqInfoID,strAnsApprStt)).booleanValue();
   if(!blnEditOk){
 	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	objMsgBean.setStrCode("DSDATA-0011");
  	objMsgBean.setStrMsg("요구정보 답변승인상태 변경에 실패하였습니다.");
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%
  	return;
   }
 }catch(AppException objAppEx){
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
	function init(){
		alert("요구정보 답변승인상태가 변경되었습니다");
		formName.submit();
	}
</script>
<body onLoad="init()">
				<form name="formName" method="<%=nads.lib.reqsubmit.EnvConstants.FORM_METHOD%>" action="<%=(String)request.getParameter("ReturnUrl")%>">
	             <%=nads.lib.reqsubmit.form.Form.makeHiddenFormTags(request)%>
				</form>
</body>
</html>