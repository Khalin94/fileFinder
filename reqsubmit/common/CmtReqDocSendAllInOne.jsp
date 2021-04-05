<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.cmtsubmt.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.commreqsch.*" %>
<%@ page import="nads.lib.reqsubmit.CodeConstants" %>
<%@ page import="nads.lib.reqsubmit.util.*" %> 

<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.MemRequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.MemReqDocSendDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.commReqDoc.CommReqDocDelegate" %>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RMemReqDocSendForm" %>
<%@ page import="nads.dsdm.app.common.ums.UmsInfoDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	// 2005-01-15 SETUP ORGAN CODE
	String BUDGET_CMT_ORG_ID = "GI00004773";		// ����������ȸ ��� �ڵ� 
	String LAWS_CMT_ORG_ID = "GI00004757";			// �����������ȸ ��� �ڵ�
	
	UserInfoDelegate objUserInfo =null;
 	CDInfoDelegate objCdinfo =null;
%>
	<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>
<%
 	String strAuditYear = request.getParameter("AuditYear")==null?"2014":request.getParameter("AuditYear");
	String strCmtOrganID = request.getParameter("CmtOrganID");
	String strReqBoxID = request.getParameter("ReqBoxID");
	String[] arrReqID = request.getParameterValues("ReqID");
	String strReqBoxNm = request.getParameter("ReqBoxNm");
	int intResult = 0;							// ��ü ó�� ��� 
	String[] strReturns = new String[arrReqID.length];				// ��ϵ� �����û�� �� �䱸ID �迭 
	String strCmtSubmtBoxID = "";		// �����û�� ID
	String strReqScheID = "";				// ����ȸ �䱸 ���� ID
	String[] arrPdfInfo = null;					// �����û���� �������� ��� ��ȯ�Ǵ� ���� �迭 
	String strCmtReqBoxID = "";			// ����ȸ �䱸�� ID
	String strNatCnt = request.getParameter("NatCnt");		// ȸ�� 
	String strSubmtDln = StringUtil.ReplaceString(StringUtil.getEmptyIfNull(request.getParameter("SubmtDln")), "-", "");

	String strSysdate = StringUtil.getSysDate2();

	String strYear = strSysdate.substring(0,4);
	String strMonth = strSysdate.substring(4,6);
	String strDate = strSysdate.substring(6,8);

	String strRegOrganNm = request.getParameter("ReqOrganNm");
	String strRegrNm = request.getParameter("RegrNm");

	String strRegOrganId = StringUtil.getEmptyIfNull(request.getParameter("ReqOrganId"));


	String strReqBoxDsc = strYear+"��"+strMonth+"��"+strDate+"�� "+strRegOrganNm+" "+strRegrNm+"���� ��û�� ���ؼ� �ڵ����� ������ �䱸�� �Դϴ�.";

	Hashtable objhashdata = new Hashtable();

	objhashdata.put("REQ_BOX_DSC",strReqBoxDsc);
	objhashdata.put("REQ_BOX_ID",strReqBoxID);
	objhashdata.put("CMT_ORGAN_ID",strCmtOrganID);
	objhashdata.put("SUBMT_DLN",strSubmtDln);
	objhashdata.put("REQ_ORGAN_ID",strRegOrganId);

	ResultSetHelper objRS = null;

	String strReturnURL = "/reqsubmit/20_comm/20_reqboxsh/20_accend/RAccBoxList.jsp?CmtOrganID="+strCmtOrganID;

	try {
		CmtSubmtReqBoxDelegate objReqBox=new CmtSubmtReqBoxDelegate();
		CmtSubmtReqInfoDelegate objSubmtReqInfo=new CmtSubmtReqInfoDelegate();
		CommMakeBoxDelegate objSche = new CommMakeBoxDelegate();
		RequestInfoDelegate objReqInfo = new RequestInfoDelegate();		
		// 1.�����û�� ���
		strCmtSubmtBoxID = objReqBox.copyRecord(arrReqID[0], (String)objUserInfo.getUserID()); 
		
		for(int i=0; i<arrReqID.length; i++) {
			//System.out.println("User ID : " + (String)objUserInfo.getUserID()+"<BR>");
			//System.out.println("Req ID : " + arrReqID[i]+"<BR>");
			//System.out.println("Submt Box ID : " + strCmtSubmtBoxID+"<BR>");
			
			// 2.�䱸���� �䱸�� �����û���� �䱸�� ����(���)
			strReturns[i] = objSubmtReqInfo.copyRecord((String)objUserInfo.getUserID(), arrReqID[i], strCmtSubmtBoxID);
			//System.out.println("strReturns : " + strReturns[i]);
		}
		
		// 3. ����ȸ �䱸������ üũ�غ��� ������ �����Ѵ�.
		strReqScheID = objReqBox.checkHavingCommSche(strCmtOrganID, strAuditYear, strNatCnt);

		if(!StringUtil.isAssigned(strReqScheID)) { // ������ �������� �ʴ´ٸ� �����ؾ� �Ѵ�.
			objMsgBean.setMsgType(MessageBean.TYPE_INFO);
			objMsgBean.setStrCode("DSDATA-0020");
			objMsgBean.setStrMsg("�������� ����ȸ ������ �����ϴ�.");
%>
			<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%  	
		  	return; 
		}

		System.out.println("Cmt Submt Box ID : " + strCmtSubmtBoxID);

		// 4. ����ȸ �����û���� ����
   		arrPdfInfo = objReqBox.getApplyPdfDocEncBase64(objUserInfo.getUserID(), strCmtSubmtBoxID);

		objhashdata.put("CMTSUBMTBOXID",strCmtSubmtBoxID);
		objhashdata.put("REQ_SCHE_ID",strReqScheID);

		// 5. ����ȸ �䱸������ ����Ѵ�.
		int resultInt2 = objReqBox.approveCmtSubmtReqBoxNew(objhashdata, true);

		/** 2004-12-16 ADD Process ����ȸ �䱸 ���� ���� ***********************/
		int intReqScheFinish = objSche.updateCommSchStt(strReqScheID);
		
		MemRequestBoxDelegate objMemReqBox = new MemRequestBoxDelegate();		// �䱸�� ���� 
		MemReqDocSendDelegate objRDSDelegate = new MemReqDocSendDelegate();	// �䱸�� ������� ó�� ���� 
		CommReqDocDelegate objBindDelegate = new CommReqDocDelegate(); 			// �䱸�� ���� ���� DELEGATE
		UmsInfoDelegate objUmsDelegate = new UmsInfoDelegate();								// UMS ���� DELEGATE		// �׽�Ʈ ���� �ּ�ó�� hyo
		
		/************************************ LAST WORK START ***************************************/
		//Boolean objBool1 = objMemReqBox.updateReqBoxStt(strReqBoxID, CodeConstants.REQ_BOX_STT_010);
		
		// 2005-01-15 ����ȸ �䱸������ ��ϵ� �䱸���� �����Ϸ�� ���¸� �����Ѵ�. 
		//Boolean objBool2 = objMemReqBox.updateReqBoxSttAndSubmtDln(strCmtReqBoxID, CodeConstants.REQ_BOX_STT_002, strSubmtDln);

		objRS = new ResultSetHelper(objRDSDelegate.getRepUserList3(strCmtOrganID));

		String strSmsMsg = "�����ڷ���������ý��ۿ� 1���� �䱸���� �����Ǿ����ϴ�.[��ȸ�繫ó]";

		int intSmsSendResult = 0;

		if(objRS != null && objRS.getRecordSize() > 0) {
			while(objRS.next()){
				Hashtable hashSmsInfo = new Hashtable();

				String strRcvrPhoneNo = (String)objRS.getObject("CPHONE");

				hashSmsInfo.put("SEND_PHONE_NO", StringUtil.ReplaceString(strRcvrPhoneNo, "-", ""));
				hashSmsInfo.put("RETURN_NO", "027883882");
				hashSmsInfo.put("SEND_STATUS", "1"); // ��ù߼� : 1, ��� : 9
				hashSmsInfo.put("MSG", strSmsMsg);
				hashSmsInfo.put("SYSTEM_GBN", CodeConstants.ELC_SMS_SYSTEM_REQ);
				hashSmsInfo.put("SERVICE_GBN", CodeConstants.ELC_SMS_SERVICE_REQ);
				hashSmsInfo.put("DEPT_GBN", "");
				hashSmsInfo.put("USER_ID", (String)objUserInfo.getUserID());
				hashSmsInfo.put("DEPT_NM", ""); // 2004-04-13 �߰� 1
				hashSmsInfo.put("USER_NM", (String)objUserInfo.getUserName()); // 2004-04-13 �߰� 2

				// 2005-07-27 kogaeng EDIT
				// �׽�Ʈ�� ���ؼ� �ӽ÷� ���Ƶд�.
				intSmsSendResult = objUmsDelegate.insertSMS(hashSmsInfo);		// �׽�Ʈ ���� �ּ�ó�� hyo
				//intSmsSendResult = 1;	// �׽�Ʈ ���� �߰� hyo
			}
		}

		if(resultInt2 > 0) {
			/** ���������� ó���Ǿ����Ƿ� ȭ�� �̵��� ���� �޼��� ��� */
			out.println("<script language='javascript'>");
			//out.println("parent.notProcessing();");
			out.println("var elem = parent.document.getElementById('loading_layer');");
			out.println("elem.parentNode.removeChild(elem);");

			out.println("alert('����ȸ �����Ϸ� �䱸������ ���������� ��û �Ǿ����ϴ�.');");
			//out.println("self.close();");
			out.println("parent.location.href='"+strReturnURL+"'");
			out.println("</script>");
		} else {
			System.out.println("ReqBox Status Update Error ");
		}
		
	} catch(AppException objEx) { 
		System.out.println(objEx.getMessage());
		objEx.printStackTrace();
	 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
	  	objMsgBean.setStrCode(objEx.getStrErrCode());
	  	objMsgBean.setStrMsg(objEx.getMessage());
%>
	  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%  	
	  	return; 
 	} catch(Exception e) {
		out.println("Error �߻� : " + e.getMessage());
		System.out.println(e.getMessage());
		e.printStackTrace();
	}
%>