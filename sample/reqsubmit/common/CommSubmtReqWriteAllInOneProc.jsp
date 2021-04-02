<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.lib.reqsubmit.params.cmtsubmt.CmtSubmtReqBoxWriteForm"%>
<%@ page import="nads.lib.reqsubmit.params.cmtsubmt.CmtSubmtReqInfoWriteForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.cmtsubmt.CmtSubmtReqBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.cmtsubmt.CmtSubmtReqInfoDelegate" %>
<%@ page import="nads.lib.reqsubmit.form.RequestWrapper" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	UserInfoDelegate objUserInfo = null;
	CDInfoDelegate objCdinfo = null;
%>

<%@ include file="../common/RUserCodeInfoInc.jsp" %>

<%
	/**Multipart�ϰ�� �ݵ�� �̳༮�� �̿��ؼ� ���� Valid�Ķ����� �Ѱ������ */
	RequestWrapper objReqWrapper = null;
	try {
		objReqWrapper = new RequestWrapper(request);
	} catch(java.io.IOException ex) {
		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
		objMsgBean.setStrCode("DSPARAM-0010");
		objMsgBean.setStrMsg("���ε��� ���ϻ���� �ʰ��Ͽ����ϴ�. ���ѵ� ���ϻ���� Ȯ���� �ּ���!!");
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;  	
	}
	
	CmtSubmtReqBoxWriteForm objWriteForm = new CmtSubmtReqBoxWriteForm();  
	CmtSubmtReqInfoWriteForm objWriteForm2 = new CmtSubmtReqInfoWriteForm();
	
	// �⺻������ Session���� Form�� ���������� ������ �����Ѵ�.
	objWriteForm.setParamValue("ReqOrganID", objUserInfo.getOrganID());					// �䱸����� ���ǿ��� �־���.
	objWriteForm.setParamValue("CmtSubmtReqrID", objUserInfo.getUserID());				// �ۼ��� ID
	objWriteForm2.setParamValue("ReqrNm", objUserInfo.getUserName());						//�䱸�ڸ��� ���ǿ��� �־���.
  	objWriteForm2.setParamValue("RegrID", objUserInfo.getUserID());							//�䱸��ID�� ���ǿ��� �־���.
	
	boolean blnParamCheck1 = false;
	boolean blnParamCheck2 = false;
	blnParamCheck1 = objWriteForm.validateParams(objReqWrapper);
	blnParamCheck2 = objWriteForm2.validateParams(objReqWrapper);
	if(blnParamCheck1 == false || blnParamCheck2 == false) {
		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
		objMsgBean.setStrCode("DSPARAM-0000");
		objMsgBean.setStrMsg("[1st] "+ objWriteForm.getStrErrors() + "[2nd]" + objWriteForm2.getStrErrors());
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}
	
	try {
		// �����ڷ� �������� �� �Ķ���� ���ڿ��� Ȱ�� ������ �迭�� ��ȯ�Ѵ�.
		// 1. ����ȸ, ������
		// 2. �䱸����
		// 3. �䱸����
		String strSubOrganIdList = StringUtil.getEmptyIfNull(objWriteForm2.getParamValue("SubmtOrganID"));
		String strReqContList = StringUtil.getEmptyIfNull(objWriteForm2.getParamValue("TempTitle"));
		String strReqDtlContList = StringUtil.getEmptyIfNull(objWriteForm2.getParamValue("TempContent"));
		String[] arrSubmtOrganID = strSubOrganIdList.split(",");
		String[] arrReqCont = strReqContList.split("��");
		String[] arrReqDtlCont = strReqDtlContList.split("��");
		
		CmtSubmtReqBoxDelegate objReqBox = new CmtSubmtReqBoxDelegate();			// �䱸�� ���� �Է¿�
		CmtSubmtReqInfoDelegate objReqInfo = new CmtSubmtReqInfoDelegate();			// �䱸 ���� �Է¿�
		
		// ��û���� ����ϸ� ������� ��û�� ID�� ��ȯ�Ѵ�.
		String strReqBoxID = objReqBox.setNewRecord2(objWriteForm);
		String strReqID = "";

		// [�䱸 ����� ���� �� ����] ��û�� ID
		objWriteForm2.setParamValue("ReqBoxID", strReqBoxID);
		
		for(int i=0; i<arrSubmtOrganID.length; i++) {
			String strSubmtOrganID = StringUtil.split("^", arrSubmtOrganID[i])[1];
			// [�䱸 ����� ���� �� ����] ������ ID
			objWriteForm2.setParamValue("SubmtOrganID", strSubmtOrganID);
			for(int j=0; j<arrReqCont.length; j++) {
				//System.out.println(arrReqCont[j]+"<BR>");
				//System.out.println(arrReqDtlCont[j]+"<BR>");
				objWriteForm2.setParamValue("ReqCont", StringUtil.ReplaceString(arrReqCont[j], "'", "`"));
				objWriteForm2.setParamValue("ReqDtlCont", StringUtil.ReplaceString(arrReqDtlCont[j], "'", "`"));
				objWriteForm2.setParamValue("AnsEstyleFilePath", objWriteForm2.getParamValue("AnsEstyleFilePath"+j));
				objWriteForm2.setParamValue("OpenCL", "002"); 			// �ӽ÷�
				
				strReqID = objReqInfo.setNewRecord2(objWriteForm2);
				
				if(!StringUtil.isAssigned(strReqID)) {
					objMsgBean.setMsgType(MessageBean.TYPE_WARN);
					objMsgBean.setStrCode("DSDATA-0010");
					objMsgBean.setStrMsg("��û�Ͻ� �䱸 ������ ������� ���߽��ϴ�");
%>
					<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%  	
					return;   	
				}
				
			}
		}
%>
		<script language="javascript">
			alert("����ȸ ���� ��û�� ����� ���������� �Ϸ��߽��ϴ�.");
			opener.window.location.href='/reqsubmit/10_mem/20_reqboxsh/40_commreq/RCommReqList.jsp?AuditYear=<%= objWriteForm.getParamValue("AuditYear") %>&CmtOrganIDX=<%= objWriteForm.getParamValue("CmtOrganIDX") %>';
			self.close();
		</script>

<%
	} catch(AppException objAppEx) { 
 		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		System.out.println("SysErrorCode:" + objAppEx.getStrErrCode());
		if(objAppEx.getStrErrCode().equals("DSDATA-0002")) {
			objMsgBean.setStrCode(objAppEx.getStrErrCode());
			objMsgBean.setStrMsg("�ߺ��� ��û���� �ֽ��ϴ�. ��û�� ����� Ȯ���ϼ���!!");
		} else {
	  		objMsgBean.setStrCode("SYS-00010");//AppException����.
	  		objMsgBean.setStrMsg(objAppEx.getMessage());
		}
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%  	
		return; 
	}
%>