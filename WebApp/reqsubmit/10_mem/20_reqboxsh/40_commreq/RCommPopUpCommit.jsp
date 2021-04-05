<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.bf.config.*"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.params.cmtsubmt.CmtSubmitReqBoxApplyForm"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.cmtsubmt.CmtSubmtReqBoxDelegate" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%
 UserInfoDelegate objUserInfo =null;
 CDInfoDelegate objCdinfo =null;
%>
<%@ include file="../../../common/RUserCodeInfoInc.jsp" %>
<%
 /*************************************************************************************************/
 /** 					�Ķ���� üũ Part 														  */
 /*************************************************************************************************/
  CmtSubmitReqBoxApplyForm objParams =new CmtSubmitReqBoxApplyForm();  
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
 String strReqScheID=null;  //ó���� �䱸������ ID
 try{
   /********* �븮�� ���� ���� *********/
   CmtSubmtReqBoxDelegate objReqBox=new CmtSubmtReqBoxDelegate();
   /** 1.����ȸ ����Ȯ�� */
   strReqScheID=objReqBox.checkHavingCommSche(objParams.getParamValue("CmtOrganID"));
   if(!StringUtil.isAssigned(strReqScheID)){
 	objMsgBean.setMsgType(MessageBean.TYPE_INFO);
  	objMsgBean.setStrCode("DSDATA-0020");
  	objMsgBean.setStrMsg("�������� ����ȸ ������ �����ϴ�.");
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%  	
  	return; 
   }
   
   /** 2.�����û ���ó��. */
   objReqBox.approveCmtSubmtReqBox(objParams.getParamValue("ReqBoxID"),true);
 }catch(AppException objEx){ 
 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  	objMsgBean.setStrCode(objEx.getStrErrCode());
  	objMsgBean.setStrMsg(objEx.getMessage());
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%  	
  	return; 
 }
  String strFormType="hidden";
%>
<html>
<head>
<title>����ȸ �����û �Ϸ�</title>
<script language="javascript">
	function selfClose(){
	  opener.location.reload();
	  self.close();
	}
</script>
</head>
<body>
<center>
<h4>����ȸ �����û�� ó���� �Ϸ�Ǿ����ϴ�.</h4>
<a href="javascript:selfClose()"><font size="3">�ݱ�</font></a>
</center>
</body>
</html>