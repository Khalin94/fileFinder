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

	UserInfoDelegate objUserInfo =null; // 이용자 정보
	CDInfoDelegate objCdinfo =null; // 시스템 변수(상수)

	SMemAnsInfoWriteForm objParamForm = new SMemAnsInfoWriteForm();
	AnsInfoDelegate objSMAIDelegate = new AnsInfoDelegate();
	SMemReqBoxDelegate objBoxDelegate = new SMemReqBoxDelegate();
	String strCount = "";
	int count = -1;
	int intElcAnsInfoProcResult =-1;
%>

<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>

<%
	// 파라미터가 정상적으로 넘어온건지 확인해보자
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
		objParamForm.setParamValue("AnsOpin",StringUtil.ReplaceString((String)objParamForm.getParamValue("AnsOpin"), "^", "＾"));
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

		if (CodeConstants.ANS_MTD_ELEC.equalsIgnoreCase(strAnsType)) { // 전자문서이다.
			// 1. 파일명 시퀀스 아이디로 복사
			// 2. 답변파일등록
			// 3. 답변등록
			// 4. PDF 파일 하일라이트 인덱스 파일 생성
			// 5. PDF 파일 검색엔진 색인용 TXT 파일 생성
			// 6. 정리된 모든 파일 저장 경로로 이동(복사)
			// 위의 작업을 진행하는 함수를 호출한다.

			// 원래는 여기에 Ans File ID를 SEQ로 받아와서 SET 하는 부분이 설정되어져 있었지만 POPUP에서 미리 선 작업하도록 한다.
			strCount = (String)objParamForm.getParamValue("count");
			count = Integer.parseInt(strCount);
			String PdfFilePath[] = StringUtil.split("Ω",objParamForm.getParamValue("PdfFilePath"));
			String DocFilePath[] = StringUtil.split("Ω",objParamForm.getParamValue("DocFilePath"));
			String AnsFileID[] = StringUtil.split("Ω",objParamForm.getParamValue("AnsFileID"));
			String PdfFileName[] = StringUtil.split("Ω",objParamForm.getParamValue("PdfFileName"));
			String OriginFileName[] = StringUtil.split("Ω",objParamForm.getParamValue("OriginFileName"));
			String MsgDigest[] = StringUtil.split("Ω",objParamForm.getParamValue("MsgDigest"));
			//실제파일명 작업 20170818
			String OrgRealFileName[] = StringUtil.split("Ω",objParamForm.getParamValue("OrgRealFileName"));
			String PdfRealFileName[] = StringUtil.split("Ω",objParamForm.getParamValue("PdfRealFileName"));
			
			System.out.println("hgyoo===============================");
			System.out.println("PdfFilePath :"+Arrays.toString(PdfFilePath));
			System.out.println("DocFilePath :"+Arrays.toString(DocFilePath));
			System.out.println("AnsFileID :"+Arrays.toString(AnsFileID));
			System.out.println("PdfFileName :"+Arrays.toString(PdfFileName));
			System.out.println("OriginFileName :"+Arrays.toString(OriginFileName));
			System.out.println("MsgDigest :"+Arrays.toString(MsgDigest));
			System.out.println("OrgRealFileName :"+Arrays.toString(OrgRealFileName));
			System.out.println("PdfRealFileName :"+Arrays.toString(PdfRealFileName));
			System.out.println("hgyoo===============================");
			
			
			
			
			for(int i = 0;i<count; i++){
			    String strAnsID2 = objSMAIDelegate.getSeqNextVal("TBDS_ANSWER_INFO");
				objParamForm.setParamValue("AnsID", StringUtil.padl(strAnsID2, 10));
				objParamForm.setParamValue("PdfFilePath",PdfFilePath[i]);

                String DFP = "";
                String OFN = "";

                try{
                    DFP = DocFilePath[i];
                    OFN = OriginFileName[i];
                } catch(Exception e) {
                    DFP = PdfFilePath[i];
                    OFN = PdfFileName[i];
                }
                System.out.println("DocFilePath[i]"+DFP);
                System.out.println("OriginFileName[i]"+OFN);

                System.out.println("(1)======================");
                objParamForm.setParamValue("DocFilePath",DFP);
                
                System.out.println("(2)======================");
        		objParamForm.setParamValue("OriginFileName",OFN);
        		
        		System.out.println("(3)======================");
/*
                if(!objParamForm.getParamValue("DocFilePath").equals("")){
                    objParamForm.setParamValue("DocFilePath",DocFilePath[i]);
        			objParamForm.setParamValue("OriginFileName",OriginFileName[i]);
                } else {
                    objParamForm.setParamValue("DocFilePath","");
        			objParamForm.setParamValue("OriginFileName","");
                }
*/

				objParamForm.setParamValue("AnsFileID",AnsFileID[i]);
				System.out.println("(4)======================i:"+i);
				objParamForm.setParamValue("PdfFileName",PdfFileName[i]);
				System.out.println("(5)======================i:"+i);
				objParamForm.setParamValue("MsgDigest","undefined");
				System.out.println("(6)======================i:"+i+"/count:"+count);
				//실제파일명 작업 20170818
				objParamForm.setParamValue("OrgRealFileName",OrgRealFileName[count-(i+1)]);
				System.out.println("(7)======================i:"+i+"/count:"+count);
				objParamForm.setParamValue("PdfRealFileName",PdfRealFileName[count-(i+1)]);
				System.out.println("(8)======================i:"+i+"/count:"+count);
				//objParamForm.setParamValue("RegrID","undefined");
				System.out.println("ANSTIMECHEK(6) : "+this.getCurrentTime());
				intElcAnsInfoProcResult = objSMAIDelegate.setNewRecordElcAnsInfoProc(objParamForm);
				System.out.println("ANSTIMECHEK(7) : "+intElcAnsInfoProcResult);
			}


			//out.println(strReturnURL);

			// 2004-06-07 kogaeng

			intTotalReqCountAnsIsNull = objBoxDelegate.checkReqInfoAnsIsNull(strReqBoxID);
			if ("Y".equalsIgnoreCase(strAddAnsFlag)) { // 추가답변여부
				strAlertMsg = "추가 답변 등록을 정상적으로 완료하였습니다.";
				strReturnURL = strReturnURL+"?NONE=NONE";
			} else {
				if (intTotalReqCountAnsIsNull > 0) { // 등록해야할 답변이 있다면
					strAlertMsg = "답변 등록을 정상적으로 완료하였습니다.";
					strflag = "MORE";
					strReturnURL = strReturnURL+"?NONE=NONE";

				} else {
					if ("/reqsubmit/10_mem/20_reqboxsh/10_make/SMakeReqBoxVList.jsp".equalsIgnoreCase(strReturnURL.substring(0, StringUtil.getLastIndex(strReturnURL, "?")))) {
						strAlertMsg = "해당 요구함의 답변 제출을 모두 완료하였습니다. 답변서 발송을 진행하겠습니다.";
						strReturnURL = 	"/reqsubmit/10_mem/20_reqboxsh/10_make/SMakeReqBoxVList.jsp?ReqBoxID="+strReqBoxID+"&startAnsDocSend=Y";

					} else if ("/reqsubmit/20_comm/20_reqboxsh/SCommReqBoxVList.jsp".equalsIgnoreCase(strReturnURL.substring(0, StringUtil.getLastIndex(strReturnURL, "?")))) {
						strAlertMsg = "해당 요구함의 답변 제출을 모두 완료하였습니다. 답변서 발송을 진행하겠습니다.";
						strReturnURL = "/reqsubmit/20_comm/20_reqboxsh/SCommReqBoxVList.jsp?ReqBoxID="+strReqBoxID+"&startAnsDocSend=Y";
					} else {
						strAlertMsg = "답변 등록을 정상적으로 완료하였습니다.";
						strReturnURL = strReturnURL+"?NONE=NONE";
					}
				}
			}

			if (intElcAnsInfoProcResult < 0) { // 정상적으로 처리되지 못했다면
				out.println("<script language='javascript'>alert('[ERROR] 답변(전자문서) 등록 작업에서 에러 발생.');</script>");
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

		} else { // 비전자문서 or 해당기관아님
			// 그냥 답변테이블에 등록하면 된다.

			// 답변 ID를 미리 받아와야 나중에 유니플로 관련 백그라운드 작업을 처리할 수 있다.
			String strAnsID = objSMAIDelegate.getSeqNextVal("TBDS_ANSWER_INFO");
			objParamForm.setParamValue("AnsID", StringUtil.padl(strAnsID, 10));
			int intInsertAnsInfoResult = objSMAIDelegate.setNewRecordToAnsInfo(objParamForm);
			if (intInsertAnsInfoResult < 1) { // 정상적으로 처리되지 못했다면
				objMsgBean.setMsgType(MessageBean.TYPE_WARN);
				objMsgBean.setStrCode("");
	  			objMsgBean.setStrMsg("");
%>
  				<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
				return;
			} else {

				// 추가답변작성이라면 해당 요구 이력을 기록한다.
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
				if ("Y".equalsIgnoreCase(strAddAnsFlag)) { // 추가답변여부
					strAlertMsg = "추가 답변 등록을 정상적으로 완료하였습니다.";
					strReturnURL = strReturnURL+"?NONE=NONE";
				} else {
					if (intTotalReqCountAnsIsNull > 0) { // 등록해야할 답변이 있다면
						strAlertMsg = "답변 등록을 정상적으로 완료하였습니다.";
						strReturnURL = strReturnURL+"?NONE=NONE";
						strflag = "MORE";
					} else {
						if ("/reqsubmit/10_mem/20_reqboxsh/10_make/SMakeReqBoxVList.jsp".equalsIgnoreCase(strReturnURL.substring(0, StringUtil.getLastIndex(strReturnURL, "?")))) {
							strAlertMsg = "해당 요구함의 답변 제출을 모두 완료하였습니다. 답변서 발송을 진행하겠습니다.";
							strReturnURL = 	"/reqsubmit/10_mem/20_reqboxsh/10_make/SMakeReqBoxVList.jsp?ReqBoxID="+strReqBoxID+"&startAnsDocSend=Y";
						} else if ("/reqsubmit/20_comm/20_reqboxsh/SCommReqBoxVList.jsp".equalsIgnoreCase(strReturnURL.substring(0, StringUtil.getLastIndex(strReturnURL, "?")))) {
							strAlertMsg = "해당 요구함의 답변 제출을 모두 완료하였습니다. 답변서 발송을 진행하겠습니다.";
							strReturnURL = "/reqsubmit/20_comm/20_reqboxsh/SCommReqBoxVList.jsp?ReqBoxID="+strReqBoxID+"&startAnsDocSend=Y";
						} else {
							strAlertMsg = "답변 등록을 정상적으로 완료하였습니다.";
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

		} // 전자문서?? 비전자문서??

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
