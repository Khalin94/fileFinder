<%@ page language="java" contentType="text/html;charset=EUC-KR" errorPage="/reqsubmit/DefaultErrorPage.jsp"%>

<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.message.MessageBean" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.answerinfo.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.lib.reqsubmit.CodeConstants" %>
<%@ page import="nads.lib.reqsubmit.params.answerinfo.SMemAnsInfoWriteForm" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	UserInfoDelegate objUserInfo =null; // �̿��� ����
	CDInfoDelegate objCdinfo =null; // �ý��� ����(���)

	SMemAnsInfoWriteForm objParamForm = new SMemAnsInfoWriteForm();
	AnsInfoDelegate objSMAIDelegate = new AnsInfoDelegate();
%>

<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>

<%
	// �Ķ���Ͱ� ���������� �Ѿ�°��� Ȯ���غ���
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

	try {
		String strAnsType = (String)objParamForm.getParamValue("AnsType");
		
		// �亯 ID�� �̸� �޾ƿ;� ���߿� �����÷� ���� ��׶��� �۾��� ó���� �� �ִ�.
		String strAnsID = objSMAIDelegate.getSeqNextVal("TBDS_ANSWER_INFO");
		objParamForm.setParamValue("AnsID", StringUtil.padl(strAnsID, 10));
		
		if (CodeConstants.ANS_MTD_ELEC.equalsIgnoreCase(strAnsType)) { // ���ڹ����̴�.
			// 1. ���ϸ� ������ ���̵�� ����
			// 2. �亯���ϵ��
			// 3. �亯���
			// 4. PDF ���� ���϶���Ʈ �ε��� ���� ����
			// 5. PDF ���� �˻����� ���ο� TXT ���� ����
			// 6. ������ ��� ���� ���� ��η� �̵�(����)
			// ���� �۾��� �����ϴ� �Լ��� ȣ���Ѵ�. 
			
			String strAnsFileID = objSMAIDelegate.getSeqNextVal("TBDS_ANS_FILE_INFO");
			objParamForm.setParamValue("AnsFileID", StringUtil.padl(strAnsFileID, 10));

			int intElcAnsInfoProcResult = objSMAIDelegate.setNewRecordElcAnsInfoProc(objParamForm);
			
			if (intElcAnsInfoProcResult< 1) { // ���������� ó������ ���ߴٸ�
				out.println("<script language='javascript'>alert('�亯(���ڹ���) ����� ���� �߻�.');</script>");
				out.println("<meta http-equiv='refresh' content='0; url="+(String)objParamForm.getParamValue("returnURL")+"'>");
			} else {
				out.println("<script language='javascript'>alert('�亯(���ڹ���) ����� ���������� �Ϸ��Ͽ����ϴ�.');</script>");
				out.println("<meta http-equiv='refresh' content='0; url="+(String)objParamForm.getParamValue("returnURL")+"'>");
			}
		
		} else { // �����ڹ��� or �ش����ƴ�
			// �׳� �亯���̺� ����ϸ� �ȴ�.
			int intInsertAnsInfoResult = objSMAIDelegate.setNewRecordToAnsInfo(objParamForm);
			if (intInsertAnsInfoResult < 1) { // ���������� ó������ ���ߴٸ�
				objMsgBean.setMsgType(MessageBean.TYPE_WARN);
				objMsgBean.setStrCode("");
	  			objMsgBean.setStrMsg("");
%>
  				<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
				return;
			} else {
				out.println("<script language='javascript'>alert('�亯 ����� ���������� �Ϸ��Ͽ����ϴ�.');</script>");
				out.println("<meta http-equiv='refresh' content='0; url="+(String)objParamForm.getParamValue("returnURL")+"'>");
			}
		}
	} catch(Exception e) {
		e.printStackTrace();
		System.out.println(e.getMessage());
		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
		objMsgBean.setStrCode("");
		objMsgBean.setStrMsg(e.getMessage());
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}
%>