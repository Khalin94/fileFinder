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
<%@ page import="nads.lib.reqsubmit.params.requestbox.RMemReqBoxVListForm" %> 

<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.MemRequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.MemReqDocSendDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.commReqDoc.CommReqDocDelegate" %>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RMemReqDocSendForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.MemRequestInfoDelegate" %>
<%@ page import="nads.dsdm.app.common.ums.UmsInfoDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	UserInfoDelegate objUserInfo =null;
 	CDInfoDelegate objCdinfo =null;
%>
	<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>
<%
	String strCmtOrganID = request.getParameter("CmtOrganID");
	String[] arrReqBoxIDs = request.getParameterValues("ReqBoxID");
	String strReturnURL = "/reqsubmit/20_comm/20_reqboxsh/20_accend/RAccBoxList.jsp?CmtOrganID="+strCmtOrganID;
	int intReqBoxTotalCnt = arrReqBoxIDs.length;
	int intSuccessCnt = 0;
	int intFailCnt = 0;
	StringBuffer strSuccessResult = new StringBuffer();
	StringBuffer strFailResult = new StringBuffer();

	String strSysdate = StringUtil.getSysDate2();

	String strYear = strSysdate.substring(0,4);
	String strMonth = strSysdate.substring(4,6);
	String strDate = strSysdate.substring(6,8);
	
	if(arrReqBoxIDs == null || arrReqBoxIDs.length < 1) {
		out.println("<script language=javascript>");
		out.println("alert('�䱸�� ID�� ���޵��� �ʾҽ��ϴ�. Ȯ�� �ٶ��ϴ�.');");
		out.println("history.go(-1);");
		out.println("</script>");
		return;
	}
	
	/** �� ������ ������ Object�� �����ϰڴ� */
	MemRequestBoxDelegate objReqBoxInfo = new MemRequestBoxDelegate(); 		// �䱸�� ��ȸ�� ���� Delegate
	RMemReqBoxVListForm objParams = new RMemReqBoxVListForm();					// �䱸 ���� ��ȸ�� ���� FORM
	MemRequestInfoDelegate objReqInfo = new MemRequestInfoDelegate(); 			// �䱸 ���� ��ȸ�� ���� Delegate
	ResultSetHelper objReqRS = null;
	CmtSubmtReqBoxDelegate objReqBox = new CmtSubmtReqBoxDelegate();
	CmtSubmtReqInfoDelegate objSubmtReqInfo = new CmtSubmtReqInfoDelegate();
	CommMakeBoxDelegate objSche = new CommMakeBoxDelegate();
	MemReqDocSendDelegate objBean = new MemReqDocSendDelegate();
	UmsInfoDelegate objUmsBean = new UmsInfoDelegate();
	Hashtable objhashdata = null;
	ResultSetHelper objRS = null;

	String tempReqOrganId = "";
	String tempReqOrganNm = "";
	
	try {
	
		for(int i=0; i<intReqBoxTotalCnt; i++) {	
			String strReqBoxID = (String)arrReqBoxIDs[i];
			String strAuditYear = "";
			String strNatCnt = "";
			String strSubmtDln = "";
			String strCmtSubmtBoxID = "";			// ������ �� ��ȯ�Ǵ� �����û�� ID
			String strReqScheID = "";					// ������ �� ��ȯ�Ǵ� �䱸 ����
			String[] arrPdfInfo = null;					// �����û���� �������� ��� ��ȯ�Ǵ� ���� �迭 
			String strCmtReqBoxID = "";				// ������ �� ��ȯ�Ǵ� ����ȸ �䱸�� ID
			String strReqBoxNm = "";
			String strReqOrganNm = "";
			String strRerNm = "";
			String strReqBoxDsc ="";
			String strReqOrganID = "";
			
			// �䱸�� ���� ���� ����
			Hashtable objBoxInfoHash = (Hashtable)objReqBoxInfo.getRecord(strReqBoxID);
			strAuditYear = (String)objBoxInfoHash.get("AUDIT_YEAR")==null?"2008":(String)objBoxInfoHash.get("AUDIT_YEAR");
			strNatCnt = (String)objBoxInfoHash.get("NAT_CNT")==null?"":(String)objBoxInfoHash.get("NAT_CNT");
			strSubmtDln = StringUtil.ReplaceString((String)objBoxInfoHash.get("SUBMT_DLN"), "-", "");
			strReqBoxNm = (String)objBoxInfoHash.get("REQ_BOX_NM")==null?"":(String)objBoxInfoHash.get("REQ_BOX_NM");
			strReqOrganNm =(String)objBoxInfoHash.get("REQ_ORGAN_NM")==null?"":(String)objBoxInfoHash.get("REQ_ORGAN_NM");
			strRerNm =(String)objBoxInfoHash.get("REGR_NM")==null?"":(String)objBoxInfoHash.get("REGR_NM");
			strReqOrganID = (String)objBoxInfoHash.get("REQ_ORGAN_ID")==null?"":(String)objBoxInfoHash.get("REQ_ORGAN_ID");
			strReqBoxDsc = strYear+"��"+strMonth+"��"+strDate+"�� "+strReqOrganNm+" "+strRerNm+"���� ��û�� ���ؼ� �ڵ����� ������ �䱸�� �Դϴ�.";
			/*
			System.out.println("Cmt Organ ID : " + strCmtOrganID+"<BR>"); 
			System.out.println("Req Box ID : " + strReqBoxID+"<BR>"); 
			System.out.println("Audit Year : " +(String)objBoxInfoHash.get("AUDIT_YEAR")+"<BR>"); 
			System.out.println("NAT CNT : " +(String)objBoxInfoHash.get("NAT_CNT")+"<BR>"); 
			System.out.println("Submit Dln : " +(String)objBoxInfoHash.get("SUBMT_DLN")+"<BR>");
			System.out.println("-------------------------------------------------------------------<BR>");
			*/

			objhashdata = new Hashtable();

			objhashdata.put("REQ_BOX_DSC",strReqBoxDsc);
			objhashdata.put("REQ_BOX_ID",strReqBoxID);
			objhashdata.put("CMT_ORGAN_ID",strCmtOrganID);
			objhashdata.put("SUBMT_DLN",strSubmtDln);
			objhashdata.put("REQ_ORGAN_ID",strReqOrganID);

	
			// �䱸 ID �迭 �Ҵ�
			/**���޵� �ĸ����� üũ */
			boolean blnParamCheck = objParams.validateParams(request);
			if(blnParamCheck == false){
				objMsgBean.setMsgType(MessageBean.TYPE_WARN);
				objMsgBean.setStrCode("DSPARAM-0000");
				objMsgBean.setStrMsg(objParams.getStrErrors());
				//out.println("ParamError:" + objParams.getStrErrors());
	%>
				<jsp:forward page="/common/message/ViewMsg.jsp"/>
	<%
				return;
			} //endif
			objParams.setParamValue("ReqBoxID", strReqBoxID);

			objParams.setParamValue("ReqInfoPageSize", "30"); //�䱸 ����� ������ 15�� �̻��� ��� ������ �߻��Ǿ� 30�������� �÷�����
			
			objReqRS = new ResultSetHelper((Hashtable)objReqInfo.getRecordList(objParams));
			objRS = new ResultSetHelper(objBean.getRepUserList(strReqBoxID));
			System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>> " + objReqRS.getRecordSize());
			int intReqTotalCnt = objReqRS.getTotalRecordCount();
			String[] arrReqID = new String[intReqTotalCnt];
			int j=0;
			while(objReqRS.next()) {
				arrReqID[j] = (String)objReqRS.getObject("REQ_ID");
				//System.out.println("REQ ID : " +arrReqID[j]+"<BR>");
				j++;
			}
			//System.out.println("=====================================<BR>");
			
			if(intReqTotalCnt > 0) {		// ��ϵ� �䱸�� 1�� �̻� �־�� �۾��� ������ �� �ִ�.
			
				// 1.�����û�� ���
				strCmtSubmtBoxID = objReqBox.copyRecord(arrReqID[0], (String)objUserInfo.getUserID()); 
				
				// 2.�䱸���� �䱸�� �����û���� �䱸�� ����(���)
				String[] strReturns = new String[arrReqID.length];				// ��ϵ� �����û�� �� �䱸ID �迭 
				for(int k=0; k<arrReqID.length; k++) {
					strReturns[k] = objSubmtReqInfo.copyRecord((String)objUserInfo.getUserID(), arrReqID[k], strCmtSubmtBoxID);
				}
				
				// 3. ����ȸ �䱸������ üũ�غ��� ������ �����Ѵ�.
				strReqScheID = objReqBox.checkHavingCommSche(strCmtOrganID, strAuditYear, strNatCnt);
				
				// 4. ����ȸ �����û���� ����
		   		arrPdfInfo = objReqBox.getApplyPdfDocEncBase64(objUserInfo.getUserID(), strCmtSubmtBoxID);

				objhashdata.put("CMTSUBMTBOXID",strCmtSubmtBoxID);
				objhashdata.put("REQ_SCHE_ID",strReqScheID);
		   		
		   		// 5. ����ȸ �䱸������ ����Ѵ�.
				int resultInt2 = objReqBox.approveCmtSubmtReqBoxNew(objhashdata, true);
				
				// 6. ����ȸ �䱸 ���� ����.
				int intReqScheFinish = objSche.updateCommSchStt(strReqScheID);
				
				// 7. �ǿ��� �䱸���� �������� �ʰ�, ���������� '����ȸ ���� �߼�' ���� ��� �Ѵ�.
				//Boolean objBool1 = objReqBoxInfo.updateReqBoxStt(strReqBoxID, CodeConstants.REQ_BOX_STT_010);
				
				// 8. ����ȸ �䱸������ ��ϵ� �䱸���� '�����Ϸ�' �� ���¸� �����Ѵ�. 
				//Boolean objBool2 = objReqBoxInfo.updateReqBoxSttAndSubmtDln(strCmtReqBoxID, CodeConstants.REQ_BOX_STT_002, strSubmtDln);
								
				
				strSuccessResult.append("[�䱸�� ��ȣ : "+strReqBoxID+"] ���� �Ϸ�");
				intSuccessCnt++;
			
			} else {
				strFailResult.append("[�䱸�� ��ȣ : "+strReqBoxID+"] : ��ϵ� �䱸�� �����ϴ�.");
				intFailCnt++;
			}
			
		}

		objRS = new ResultSetHelper(objBean.getRepUserList3(strCmtOrganID));

		String strSmsMsg = "�����ڷ���������ý��ۿ� "+intSuccessCnt+"���� �䱸���� �����Ǿ����ϴ�.[��ȸ�繫ó]";

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
				hashSmsInfo.put("DEPT_GBN", tempReqOrganId);
				hashSmsInfo.put("USER_ID", (String)objUserInfo.getUserID());
				hashSmsInfo.put("DEPT_NM", tempReqOrganNm); // 2004-04-13 �߰� 1
				hashSmsInfo.put("USER_NM", (String)objUserInfo.getUserName()); // 2004-04-13 �߰� 2

				// 2005-07-27 kogaeng EDIT
				// �׽�Ʈ�� ���ؼ� �ӽ÷� ���Ƶд�.
				intSmsSendResult = objUmsBean.insertSMS(hashSmsInfo);	
			}
		}

		StringBuffer sbMsg = new StringBuffer();
		sbMsg.append("[�䱸�� �߼� �۾� ���]\\r\\n");
		sbMsg.append("- ��ü ���� : "+intReqBoxTotalCnt +" ��\\r\\n");
		sbMsg.append("- �߼� ���� : "+intSuccessCnt+" ��\\r\\n");
		sbMsg.append("- ��ó�� ���� : "+intFailCnt+" ��\\r\\n\\r\\n");
		if(StringUtil.isAssigned(strFailResult.toString())){
			sbMsg.append("[��ó�� ����]\\r\\n");
			sbMsg.append(strFailResult.toString()+"\\r\\n");
		}		
		sbMsg.append("���������� �߼۵Ǿ����ϴ�.");
				
		out.println("<script language='javascript'>");
		//out.println("parent.notProcessing();");

		out.println("var elem = parent.document.getElementById('loading_layer');");
		out.println("elem.parentNode.removeChild(elem);");

		out.println("alert('"+sbMsg.toString()+"')");		
		out.println("parent.location.href='"+strReturnURL+"';");
		//out.println("self.close();");
		out.println("</script>");

	
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