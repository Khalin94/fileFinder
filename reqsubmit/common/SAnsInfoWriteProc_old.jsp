<%@ page language="java" contentType="text/html;charset=EUC-KR" %>

<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.util.FileUtil" %>
<%@ page import="nads.lib.message.MessageBean" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.answerinfo.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.SMemReqBoxDelegate" %>
<%@ page import="nads.lib.reqsubmit.CodeConstants" %>
<%@ page import="nads.lib.reqsubmit.params.answerinfo.SMemAnsInfoWriteForm" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	System.out.println("ANSTIMECHEK(5) : "+this.getCurrentTime());

	String strUserDN = StringUtil.getEmptyIfNull(request.getParameter("user_dn"));
	HttpSession objPrivateSession = request.getSession();
	objPrivateSession.setAttribute("UserDN", strUserDN);

	UserInfoDelegate objUserInfo =null; // �̿��� ����
	CDInfoDelegate objCdinfo =null; // �ý��� ����(���)

	SMemAnsInfoWriteForm objParamForm = new SMemAnsInfoWriteForm();
	AnsInfoDelegate objSMAIDelegate = new AnsInfoDelegate();
	SMemReqBoxDelegate objBoxDelegate = new SMemReqBoxDelegate();
	String strCount = "";
	int count = -1;
	int intElcAnsInfoProcResult =-1;
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
		String strReqBoxID = (String)objParamForm.getParamValue("ReqBoxID");
		String strReqID = (String)objParamForm.getParamValue("ReqID");
		String strRegRID = (String)objParamForm.getParamValue("RegrID");
		String strAnsType = (String)objParamForm.getParamValue("AnsType");
		String strAddAnsFlag = (String)objParamForm.getParamValue("AddAnsFlag");
		String AuditYear	  = request.getParameter("AuditYear")==null?"":request.getParameter("AuditYear");

		// 2004-06-07 kogaeng
		String strReturnURL = (String)objParamForm.getParamValue("returnURL");
		String str2ReturnURL = (String)objParamForm.getParamValue("returnURL");
		objParamForm.setParamValue("AnsOpin",StringUtil.ReplaceString((String)objParamForm.getParamValue("AnsOpin"), "^", "��"));
		String strAlertMsg = null;
		int intTotalReqCountAnsIsNull = 0;
		String strflag = "";
		System.out.println("strReqBoxID :"+strReqBoxID);
		System.out.println("strReqID :"+strReqID);
		System.out.println("strAnsType :"+strAnsType);
		System.out.println("strAddAnsFlag :"+strAddAnsFlag);
		System.out.println("strReturnURL :"+strReturnURL);
		System.out.println("strRegRID :"+strRegRID);
		String strURL[] =StringUtil.split("?",strReturnURL)	;
			if(strURL[0] == null ||strURL[0].equals("")){
				strURL[0] = 	strReturnURL;
			}
			strReturnURL = strURL[0];
			str2ReturnURL  = strURL[0];
		System.out.println("strReturnURL :"+strReturnURL);
		System.out.println("str2ReturnURL :"+str2ReturnURL);
		System.out.println("str1112ReturnURL :"+str2ReturnURL);

		if (CodeConstants.ANS_MTD_ELEC.equalsIgnoreCase(strAnsType)) { // ���ڹ����̴�.
			// 1. ���ϸ� ������ ���̵�� ����
			// 2. �亯���ϵ��
			// 3. �亯���
			// 4. PDF ���� ���϶���Ʈ �ε��� ���� ����
			// 5. PDF ���� �˻����� ���ο� TXT ���� ����
			// 6. ������ ��� ���� ���� ��η� �̵�(����)
			// ���� �۾��� �����ϴ� �Լ��� ȣ���Ѵ�.

			// ������ ���⿡ Ans File ID�� SEQ�� �޾ƿͼ� SET �ϴ� �κ��� �����Ǿ��� �־����� POPUP���� �̸� �� �۾��ϵ��� �Ѵ�.
			strCount = (String)objParamForm.getParamValue("count");
			//System.out.println("strCount:"+strCount);
			count = Integer.parseInt(strCount);
			//System.out.println("PdfFilePath :"+objParamForm.getParamValue("PdfFilePath"));
			String PdfFilePath[] = StringUtil.split("��",objParamForm.getParamValue("PdfFilePath"));
			//System.out.println("DocFilePath :"+objParamForm.getParamValue("DocFilePath"));
			String DocFilePath[] = StringUtil.split("��",objParamForm.getParamValue("DocFilePath"));
			//System.out.println("AnsFileID :"+objParamForm.getParamValue("AnsFileID"));
			String AnsFileID[] = StringUtil.split("��",objParamForm.getParamValue("AnsFileID"));
			//System.out.println("PdfFileName :"+objParamForm.getParamValue("PdfFileName"));
			String PdfFileName[] = StringUtil.split("��",objParamForm.getParamValue("PdfFileName"));
			//System.out.println("OriginFileName :"+objParamForm.getParamValue("OriginFileName"));
			String OriginFileName[] = StringUtil.split("��",objParamForm.getParamValue("OriginFileName"));
			//System.out.println("MsgDigest :"+objParamForm.getParamValue("MsgDigest"));
			String MsgDigest[] = StringUtil.split("��",objParamForm.getParamValue("MsgDigest"));
			// �������̸� 20170818
			String OrgRealFileName[] = StringUtil.split("��",objParamForm.getParamValue("OrgRealFileName"));
			String PdfRealFileName[] = StringUtil.split("��",objParamForm.getParamValue("PdfRealFileName"));
			System.out.println("count :"+count);
			for(int i = 0;i<count; i++){
				System.out.println("CHK1 : "+i);
			    String strAnsID2 = objSMAIDelegate.getSeqNextVal("TBDS_ANSWER_INFO");
				System.out.println("CHK2 : "+i);
				objParamForm.setParamValue("AnsID", StringUtil.padl(strAnsID2, 10));

				System.out.println("PdfFilePath :"+PdfFilePath[i]);
				System.out.println("DocFilePath :"+DocFilePath[i]);
				System.out.println("AnsFileID :"+AnsFileID[i]);
				System.out.println("PdfFileName :"+PdfFileName[i]);
				System.out.println("OriginFileName :"+OriginFileName[i]);
				//System.out.println("MsgDigest :"+MsgDigest[i]);

				objParamForm.setParamValue("PdfFilePath",PdfFilePath[i]);
				objParamForm.setParamValue("DocFilePath",DocFilePath[i]);
				objParamForm.setParamValue("AnsFileID",AnsFileID[i]);
				objParamForm.setParamValue("PdfFileName",PdfFileName[i]);
				objParamForm.setParamValue("OriginFileName",OriginFileName[i]);
				objParamForm.setParamValue("MsgDigest","undefined");
				objParamForm.setParamValue("RegrID",strRegRID);
				// �������ϸ� 20170818
				objParamForm.setParamValue("OrgRealFileName",OrgRealFileName[i]);
				objParamForm.setParamValue("PdfRealFileName",PdfRealFileName[i]);
				System.out.println("ANSTIMECHEK(6) : "+this.getCurrentTime());
				intElcAnsInfoProcResult = objSMAIDelegate.setNewRecordElcAnsInfoProc(objParamForm);
				System.out.println("CHK3 : "+i);
				System.out.println("ANSTIMECHEK(7) : "+this.getCurrentTime());
				System.out.println("RESULT : "+intElcAnsInfoProcResult);
			}


			//out.println(strReturnURL);

			// 2004-06-07 kogaeng

			intTotalReqCountAnsIsNull = objBoxDelegate.checkReqInfoAnsIsNull(strReqBoxID);
			if ("Y".equalsIgnoreCase(strAddAnsFlag)) { // �߰��亯����
				strAlertMsg = "�߰� �亯 ����� ���������� �Ϸ��Ͽ����ϴ�.";
				strReturnURL = strReturnURL+"?NONE=NONE";
			} else {
				if (intTotalReqCountAnsIsNull > 0) { // ����ؾ��� �亯�� �ִٸ�
					strAlertMsg = "�亯 ����� ���������� �Ϸ��Ͽ����ϴ�.";
					strflag = "MORE";
					strReturnURL = strReturnURL+"?NONE=NONE";

				} else {
					if ("/reqsubmit/10_mem/20_reqboxsh/10_make/SMakeReqBoxVList.jsp".equalsIgnoreCase(strReturnURL.substring(0, StringUtil.getLastIndex(strReturnURL, "?")))) {
						strAlertMsg = "�ش� �䱸���� �亯 ������ ��� �Ϸ��Ͽ����ϴ�. �亯�� �߼��� �����ϰڽ��ϴ�.";
						strReturnURL = 	"/reqsubmit/10_mem/20_reqboxsh/10_make/SMakeReqBoxVList.jsp?ReqBoxID="+strReqBoxID+"&startAnsDocSend=Y";

					} else if ("/reqsubmit/20_comm/20_reqboxsh/SCommReqBoxVList.jsp".equalsIgnoreCase(strReturnURL.substring(0, StringUtil.getLastIndex(strReturnURL, "?")))) {
						strAlertMsg = "�ش� �䱸���� �亯 ������ ��� �Ϸ��Ͽ����ϴ�. �亯�� �߼��� �����ϰڽ��ϴ�.";
						strReturnURL = "/reqsubmit/20_comm/20_reqboxsh/SCommReqBoxVList.jsp?ReqBoxID="+strReqBoxID+"&startAnsDocSend=Y";
					} else {
						strAlertMsg = "�亯 ����� ���������� �Ϸ��Ͽ����ϴ�.";
						strReturnURL = strReturnURL+"?NONE=NONE";
					}
				}
			}

			if (intElcAnsInfoProcResult < 1) { // ���������� ó������ ���ߴٸ�
				out.println("<script language='javascript'>alert('[ERROR] �亯(���ڹ���) ��� �۾����� ���� �߻�.');</script>");
				out.println("<meta http-equiv='refresh' content='0; url="+strReturnURL+"'>");
			} else {
				if(strflag.equals("MORE")){
					out.println("<script language='javascript'>");
					out.println("alert('"+strAlertMsg+"');");
					if(strReturnURL.equals("/reqsubmit/20_comm/30_reqlistsh/20_nonsub/SNonReqInfo.jsp?NONE=NONE")){
						out.println("opener.location.href='"+strReturnURL+"&ReqBoxID="+strReqBoxID+"&CommReqID="+strReqID+"&AuditYear="+AuditYear+"' ");
					}else{
						out.println("opener.location.href='"+strReturnURL+"&ReqBoxID="+strReqBoxID+"&ReqID="+strReqID+"' ");
					}
					out.println("self.close();");
					out.println("</script>");
				}else{
					out.println("<script language='javascript'>");
					out.println("if(confirm('"+strAlertMsg+"')){	 ");
					if(strReturnURL.equals("/reqsubmit/20_comm/30_reqlistsh/20_nonsub/SNonReqInfo.jsp?NONE=NONE")){
						out.println("opener.location.href='"+strReturnURL+"&ReqBoxID="+strReqBoxID+"&CommReqID="+strReqID+"&AuditYear="+AuditYear+"' ");
					}else{
						out.println("opener.location.href='"+strReturnURL+"&ReqBoxID="+strReqBoxID+"&ReqID="+strReqID+"' ");
					}
					out.println("self.close();");
					out.println("}else{	");
					if(strReturnURL.equals("/reqsubmit/20_comm/30_reqlistsh/20_nonsub/SNonReqInfo.jsp?NONE=NONE")){
						out.println("opener.location.href='"+strReturnURL+"&ReqBoxID="+strReqBoxID+"&CommReqID="+strReqID+"&AuditYear="+AuditYear+"' ");
					}else{
						out.println("opener.location.href='"+strReturnURL+"&ReqBoxID="+strReqBoxID+"&ReqID="+strReqID+"' ");
					}
					out.println("self.close();");
					out.println("}");
					out.println("</script>");
				}
			}

		} else { // �����ڹ��� or �ش����ƴ�
			// �׳� �亯���̺��� ����ϸ� �ȴ�.

			// �亯 ID�� �̸� �޾ƿ;� ���߿� �����÷� ���� ��׶��� �۾��� ó���� �� �ִ�.
			String strAnsID = objSMAIDelegate.getSeqNextVal("TBDS_ANSWER_INFO");
			objParamForm.setParamValue("AnsID", StringUtil.padl(strAnsID, 10));
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

				// �߰��亯�ۼ��̶�� �ش� �䱸 �̷��� ����Ѵ�.
				if ("Y".equalsIgnoreCase(strAddAnsFlag)) {
					int intInsertReqLogResult = objSMAIDelegate.setNewRecordReqLog(objParamForm);
					if (intInsertReqLogResult < 1) {
						objMsgBean.setMsgType(MessageBean.TYPE_WARN);
						objMsgBean.setStrCode("");
			  			objMsgBean.setStrMsg("");
%>
		  				<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
						return;
					}
				}

				// 2004-06-07 kogaeng
				intTotalReqCountAnsIsNull = objBoxDelegate.checkReqInfoAnsIsNull(strReqBoxID);
				if ("Y".equalsIgnoreCase(strAddAnsFlag)) { // �߰��亯����
					strAlertMsg = "�߰� �亯 ����� ���������� �Ϸ��Ͽ����ϴ�.";
					strReturnURL = strReturnURL+"?NONE=NONE";
				} else {
					if (intTotalReqCountAnsIsNull > 0) { // ����ؾ��� �亯�� �ִٸ�
						strAlertMsg = "�亯 ����� ���������� �Ϸ��Ͽ����ϴ�.";
						strReturnURL = strReturnURL+"?NONE=NONE";
						strflag = "MORE";
					} else {
						if ("/reqsubmit/10_mem/20_reqboxsh/10_make/SMakeReqBoxVList.jsp".equalsIgnoreCase(strReturnURL.substring(0, StringUtil.getLastIndex(strReturnURL, "?")))) {
							strAlertMsg = "�ش� �䱸���� �亯 ������ ��� �Ϸ��Ͽ����ϴ�. �亯�� �߼��� �����ϰڽ��ϴ�.";
							strReturnURL = 	"/reqsubmit/10_mem/20_reqboxsh/10_make/SMakeReqBoxVList.jsp?ReqBoxID="+strReqBoxID+"&startAnsDocSend=Y";
						} else if ("/reqsubmit/20_comm/20_reqboxsh/SCommReqBoxVList.jsp".equalsIgnoreCase(strReturnURL.substring(0, StringUtil.getLastIndex(strReturnURL, "?")))) {
							strAlertMsg = "�ش� �䱸���� �亯 ������ ��� �Ϸ��Ͽ����ϴ�. �亯�� �߼��� �����ϰڽ��ϴ�.";
							strReturnURL = "/reqsubmit/20_comm/20_reqboxsh/SCommReqBoxVList.jsp?ReqBoxID="+strReqBoxID+"&startAnsDocSend=Y";
						} else {
							strAlertMsg = "�亯 ����� ���������� �Ϸ��Ͽ����ϴ�.";
							strReturnURL = strReturnURL+"?NONE=NONE";
						}
					}
				}

				if(strflag.equals("MORE")){
					out.println("<script language='javascript'>");
					out.println("alert('"+strAlertMsg+"');");
					if(strReturnURL.equals("/reqsubmit/20_comm/30_reqlistsh/20_nonsub/SNonReqInfo.jsp?NONE=NONE")){
						out.println("opener.location.href='"+strReturnURL+"&ReqBoxID="+strReqBoxID+"&CommReqID="+strReqID+"&AuditYear="+AuditYear+"' ");
					}else{
						out.println("opener.location.href='"+strReturnURL+"&ReqBoxID="+strReqBoxID+"&ReqID="+strReqID+"' ");
					}
					out.println("self.close();");
					out.println("</script>");
				}else{
					out.println("<script language='javascript'>");
					out.println("if(confirm('"+strAlertMsg+"')){	 ");
					if(strReturnURL.equals("/reqsubmit/20_comm/30_reqlistsh/20_nonsub/SNonReqInfo.jsp?NONE=NONE")){
						out.println("opener.location.href='"+strReturnURL+"&ReqBoxID="+strReqBoxID+"&CommReqID="+strReqID+"&AuditYear="+AuditYear+"' ");
					}else{
						out.println("opener.location.href='"+strReturnURL+"&ReqBoxID="+strReqBoxID+"&ReqID="+strReqID+"' ");
					}
					out.println("self.close();");
					out.println("}else{	");
					if(strReturnURL.equals("/reqsubmit/20_comm/30_reqlistsh/20_nonsub/SNonReqInfo.jsp?NONE=NONE")){
						out.println("opener.location.href='"+strReturnURL+"&ReqBoxID="+strReqBoxID+"&CommReqID="+strReqID+"' ");
					}else{
						out.println("opener.location.href='"+strReturnURL+"&ReqBoxID="+strReqBoxID+"&ReqID="+strReqID+"&AuditYear="+AuditYear+"' ");
					}
					out.println("self.close();");
					out.println("}");
					out.println("</script>");
				}
			}

		} // ���ڹ���?? �����ڹ���??

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

<%!
	public String getCurrentTime() {
        Calendar oCalendar = Calendar.getInstance();
		String serverDate = oCalendar.get(Calendar.YEAR) + "/" +(oCalendar.get(Calendar.MONTH) + 1)+"/"+ oCalendar.get(Calendar.DAY_OF_MONTH)+"  "+oCalendar.get(Calendar.HOUR_OF_DAY)+":"+oCalendar.get(Calendar.MINUTE)+":"+oCalendar.get(Calendar.SECOND)+":"+oCalendar.get(Calendar.MILLISECOND);
		 return serverDate;
     }

%>