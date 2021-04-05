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
 /** 					�Ķ���� üũ Part 														  */
 /*************************************************************************************************/
  String strReqInfoID=(String)request.getParameter("ReqInfoID");
  String strAnsApprStt=(String)request.getParameter("ANSW_PERM_CD");

  boolean blnFlag=true;
  String strMessage="";
  if(!StringUtil.isAssigned(strReqInfoID)){
  	blnFlag=false;
  	strMessage="�Ķ����(�䱸���� ID)�� ���޵��� �ʾҽ��ϴ�";
  }
  if(!StringUtil.isAssigned(strAnsApprStt)){
  	blnFlag=false;
  	strMessage="�亯���λ��� �ڵ尡 ���޵��� �ʾҽ��ϴ�";
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
 /** 					������ ó�� Part 														  */
 /*************************************************************************************************/

 boolean blnEditOk=false; //���� ����.
 try{
   /********* �븮�� ���� ���� *********/
   RequestInfoDelegate objReqInfo=new RequestInfoDelegate();

   /********* �亯���λ��� �����ϱ�  **************/
   blnEditOk =((Boolean)objReqInfo.changeAnsApprStt(strReqInfoID,strAnsApprStt)).booleanValue();
   if(!blnEditOk){
 	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	objMsgBean.setStrCode("DSDATA-0011");
  	objMsgBean.setStrMsg("�䱸���� �亯���λ��� ���濡 �����Ͽ����ϴ�.");
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%
  	return;
   }
 }catch(AppException objAppEx){
 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
	System.out.println("SysErrorCode:" + objAppEx.getStrErrCode());
  	objMsgBean.setStrCode("SYS-00010");//AppException����.
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
 /** 					������ ��ȯ Part 														  */
 /*************************************************************************************************/
%>
<html>
<script language="JavaScript">
	function init(){
		alert("�䱸���� �亯���λ��°� ����Ǿ����ϴ�");
		formName.submit();
	}
</script>
<body onLoad="init()">
				<form name="formName" method="<%=nads.lib.reqsubmit.EnvConstants.FORM_METHOD%>" action="<%=(String)request.getParameter("ReturnUrl")%>">
	             <%=nads.lib.reqsubmit.form.Form.makeHiddenFormTags(request)%>
				</form>
</body>
</html>