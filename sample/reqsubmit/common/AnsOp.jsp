<%@ page language="java" contentType="text/html; charset=EUC-KR" %>

<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.lib.reqsubmit.params.requestbox.SMemAnsDocSendForm" %>
<%@ page import="nads.dsdm.app.common.ums.UmsInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.MemReqDocSendDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.MemAnsDocSendDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.commAnsDoc.CommAnsDocDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.commReqDoc.CommReqDocDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.OrganInfoDelegate" %>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RMemReqDocSendForm" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<% 
	UserInfoDelegate objUserInfo = null;
	CDInfoDelegate objCdinfo = null;
%>

<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>

<%
	MemReqDocSendDelegate objRDSDelegate = new MemReqDocSendDelegate();
	CommReqDocDelegate objDocBean = new CommReqDocDelegate();
	SMemAnsDocSendForm objParamForm = new SMemAnsDocSendForm();
	RMemReqDocSendForm objForm = new RMemReqDocSendForm();
	
		boolean blnParamCheck = false;
	blnParamCheck = objParamForm.validateParams(request);
  	if(!blnParamCheck) {
		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  		objMsgBean.setStrCode("DSPARAM-0000");
	  	objMsgBean.setStrMsg(objParamForm.getStrErrors());
%>
  		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	} // end if 
	
	String strReqDocFilePath = null;
	
	try {
		String strReqDocSeq = objRDSDelegate.getSeqNextVal("TBDS_REQ_DOC_INFO");
		strReqDocFilePath  = objDocBean.CreateReqDoc("0000154377", "001", StringUtil.padl(strReqDocSeq, 10));	
		
		if (!StringUtil.isAssigned(strReqDocFilePath)) {
			objMsgBean.setMsgType(MessageBean.TYPE_ERR);
	  		objMsgBean.setStrCode("�������.. �亯�� ���� ����µ� �ڲ� ���� ���ڳ�!!!!");
  			objMsgBean.setStrMsg("�亯�� ���� ���� ���� : �亯�� ���� ���� ���� ���� �ٶ��ϴ�.");
%>
			<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
			return;
		} else {  // �亯�� ������ ���������� ����Ǿ���.
								
			objForm.setParamValue("ReqBoxID", "0000154377");
			objForm.setParamValue("ReqDocFilePath", strReqDocFilePath);
			objForm.setParamValue("ReqDocID", strReqDocSeq);
			int intResult00 = objRDSDelegate.setNewRecordToReqDocInfo(objForm);

		} // ���� �䱸�� ���� ������.. ¼��¼��
		
	} catch(AppException objAppEx) {
 		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  		objMsgBean.setStrCode(objAppEx.getStrErrCode());
  		objMsgBean.setStrMsg(objAppEx.getMessage());
  		
  		//out.println("Error Message : " + objAppEx.getMessage());
  		objAppEx.printStackTrace();
%>
  		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%  	
	  	return;
 	} // end try
%>