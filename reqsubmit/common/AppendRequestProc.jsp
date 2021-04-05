<%@ page language="java" contentType="text/html; charset=EUC-KR" %>

<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.params.requestinfo.RAppendAnswerRequestForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.RequestInfoDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	UserInfoDelegate objUserInfo = null;
	CDInfoDelegate objCdinfo = null;
%>

<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>
<%
 /*************************************************************************************************/
 /** 					�Ķ���� üũ Part 														  */
 /*************************************************************************************************/
  String strReqInfoID=(String)request.getParameter("ReqInfoID");
  RAppendAnswerRequestForm objParams =new RAppendAnswerRequestForm();
  boolean blnParamCheck=false;
  /**���޵� �ĸ����� üũ */
  blnParamCheck=objParams.validateParams(request);
  if(blnParamCheck==false){
  	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	objMsgBean.setStrCode("DSPARAM-0000");
  	objMsgBean.setStrMsg(objParams.getStrErrors());
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%
  	return;
  }//endif
%>
<%
 /*************************************************************************************************/
 /** 					������ ó�� Part 														  */
 /*************************************************************************************************/
	try{
		RequestInfoDelegate objReqInfo=new RequestInfoDelegate();

        String strAnsApprStt="111";
        boolean blnEditOk=false;

        blnEditOk =((Boolean)objReqInfo.changeAnsApprStt(strReqInfoID,strAnsApprStt)).booleanValue();
		String strReturn=objReqInfo.requestAppendAnswer(objParams);
		if(blnEditOk=false || !StringUtil.isAssigned(strReturn)){
		 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		  	objMsgBean.setStrCode("DSDATA-0010");
		  	objMsgBean.setStrMsg("�߰��䱸 ��Ͽ� �����Ͽ����ϴ�.");
		  	%>
		  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
		  	<%
		  	return;
		}
	 }catch(AppException objAppEx){
	 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
	  	objMsgBean.setStrCode(objAppEx.getStrErrCode());
	  	objMsgBean.setStrMsg(objAppEx.getMessage());
	  	%>
	  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
	  	<%
	  	return;
	 }//endoftry
%>
<%
 /*************************************************************************************************/
 /** 					������ ��ȯ Part 														  */
 /*************************************************************************************************/
%>
<html>
<script language="JavaScript">
	function init(){
		alert("�������� �߰��䱸�� ��ϵǾ����ϴ�.");
		formName.submit();
	}
</script>
<body onLoad="init()">
				<form name="formName" method="post" action="<%=request.getParameter("ReturnUrl")%>" >
				<%=nads.lib.reqsubmit.form.Form.makeHiddenFormTags(request)%>
				</form>
</body>
</html>