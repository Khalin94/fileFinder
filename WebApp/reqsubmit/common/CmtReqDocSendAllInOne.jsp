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
	String BUDGET_CMT_ORG_ID = "GI00004773";		// 예산결산위원회 기관 코드 
	String LAWS_CMT_ORG_ID = "GI00004757";			// 법제사법위원회 기관 코드
	
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
	int intResult = 0;							// 전체 처리 결과 
	String[] strReturns = new String[arrReqID.length];				// 등록된 제출신청함 및 요구ID 배열 
	String strCmtSubmtBoxID = "";		// 제출신청함 ID
	String strReqScheID = "";				// 위원회 요구 일정 ID
	String[] arrPdfInfo = null;					// 제출신청서를 생성했을 경우 반환되는 정보 배열 
	String strCmtReqBoxID = "";			// 위원회 요구함 ID
	String strNatCnt = request.getParameter("NatCnt");		// 회기 
	String strSubmtDln = StringUtil.ReplaceString(StringUtil.getEmptyIfNull(request.getParameter("SubmtDln")), "-", "");

	String strSysdate = StringUtil.getSysDate2();

	String strYear = strSysdate.substring(0,4);
	String strMonth = strSysdate.substring(4,6);
	String strDate = strSysdate.substring(6,8);

	String strRegOrganNm = request.getParameter("ReqOrganNm");
	String strRegrNm = request.getParameter("RegrNm");

	String strRegOrganId = StringUtil.getEmptyIfNull(request.getParameter("ReqOrganId"));


	String strReqBoxDsc = strYear+"년"+strMonth+"월"+strDate+"일 "+strRegOrganNm+" "+strRegrNm+"님의 신청에 의해서 자동으로 생성된 요구함 입니다.";

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
		// 1.제출신청함 등록
		strCmtSubmtBoxID = objReqBox.copyRecord(arrReqID[0], (String)objUserInfo.getUserID()); 
		
		for(int i=0; i<arrReqID.length; i++) {
			//System.out.println("User ID : " + (String)objUserInfo.getUserID()+"<BR>");
			//System.out.println("Req ID : " + arrReqID[i]+"<BR>");
			//System.out.println("Submt Box ID : " + strCmtSubmtBoxID+"<BR>");
			
			// 2.요구함의 요구를 제출신청함의 요구로 복사(등록)
			strReturns[i] = objSubmtReqInfo.copyRecord((String)objUserInfo.getUserID(), arrReqID[i], strCmtSubmtBoxID);
			//System.out.println("strReturns : " + strReturns[i]);
		}
		
		// 3. 위원회 요구일정을 체크해보고 없으면 생성한다.
		strReqScheID = objReqBox.checkHavingCommSche(strCmtOrganID, strAuditYear, strNatCnt);

		if(!StringUtil.isAssigned(strReqScheID)) { // 일정이 존재하지 않는다면 생성해야 한다.
			objMsgBean.setMsgType(MessageBean.TYPE_INFO);
			objMsgBean.setStrCode("DSDATA-0020");
			objMsgBean.setStrMsg("진행중인 위원회 일정이 없습니다.");
%>
			<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%  	
		  	return; 
		}

		System.out.println("Cmt Submt Box ID : " + strCmtSubmtBoxID);

		// 4. 위원회 제출신청서를 생성
   		arrPdfInfo = objReqBox.getApplyPdfDocEncBase64(objUserInfo.getUserID(), strCmtSubmtBoxID);

		objhashdata.put("CMTSUBMTBOXID",strCmtSubmtBoxID);
		objhashdata.put("REQ_SCHE_ID",strReqScheID);

		// 5. 위원회 요구함으로 등록한다.
		int resultInt2 = objReqBox.approveCmtSubmtReqBoxNew(objhashdata, true);

		/** 2004-12-16 ADD Process 위원회 요구 일정 마감 ***********************/
		int intReqScheFinish = objSche.updateCommSchStt(strReqScheID);
		
		MemRequestBoxDelegate objMemReqBox = new MemRequestBoxDelegate();		// 요구함 관련 
		MemReqDocSendDelegate objRDSDelegate = new MemReqDocSendDelegate();	// 요구서 등록정보 처리 관련 
		CommReqDocDelegate objBindDelegate = new CommReqDocDelegate(); 			// 요구서 생성 관련 DELEGATE
		UmsInfoDelegate objUmsDelegate = new UmsInfoDelegate();								// UMS 관련 DELEGATE		// 테스트 위해 주석처리 hyo
		
		/************************************ LAST WORK START ***************************************/
		//Boolean objBool1 = objMemReqBox.updateReqBoxStt(strReqBoxID, CodeConstants.REQ_BOX_STT_010);
		
		// 2005-01-15 위원회 요구함으로 등록된 요구함을 접수완료로 상태를 변경한다. 
		//Boolean objBool2 = objMemReqBox.updateReqBoxSttAndSubmtDln(strCmtReqBoxID, CodeConstants.REQ_BOX_STT_002, strSubmtDln);

		objRS = new ResultSetHelper(objRDSDelegate.getRepUserList3(strCmtOrganID));

		String strSmsMsg = "의정자료전자유통시스템에 1건의 요구서가 접수되었습니다.[국회사무처]";

		int intSmsSendResult = 0;

		if(objRS != null && objRS.getRecordSize() > 0) {
			while(objRS.next()){
				Hashtable hashSmsInfo = new Hashtable();

				String strRcvrPhoneNo = (String)objRS.getObject("CPHONE");

				hashSmsInfo.put("SEND_PHONE_NO", StringUtil.ReplaceString(strRcvrPhoneNo, "-", ""));
				hashSmsInfo.put("RETURN_NO", "027883882");
				hashSmsInfo.put("SEND_STATUS", "1"); // 즉시발송 : 1, 대기 : 9
				hashSmsInfo.put("MSG", strSmsMsg);
				hashSmsInfo.put("SYSTEM_GBN", CodeConstants.ELC_SMS_SYSTEM_REQ);
				hashSmsInfo.put("SERVICE_GBN", CodeConstants.ELC_SMS_SERVICE_REQ);
				hashSmsInfo.put("DEPT_GBN", "");
				hashSmsInfo.put("USER_ID", (String)objUserInfo.getUserID());
				hashSmsInfo.put("DEPT_NM", ""); // 2004-04-13 추가 1
				hashSmsInfo.put("USER_NM", (String)objUserInfo.getUserName()); // 2004-04-13 추가 2

				// 2005-07-27 kogaeng EDIT
				// 테스트를 위해서 임시로 막아둔다.
				intSmsSendResult = objUmsDelegate.insertSMS(hashSmsInfo);		// 테스트 위해 주석처리 hyo
				//intSmsSendResult = 1;	// 테스트 위해 추가 hyo
			}
		}

		if(resultInt2 > 0) {
			/** 성공적으로 처리되었으므로 화면 이동을 위한 메세지 출력 */
			out.println("<script language='javascript'>");
			//out.println("parent.notProcessing();");
			out.println("var elem = parent.document.getElementById('loading_layer');");
			out.println("elem.parentNode.removeChild(elem);");

			out.println("alert('위원회 접수완료 요구함으로 정상적으로 신청 되었습니다.');");
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
		out.println("Error 발생 : " + e.getMessage());
		System.out.println(e.getMessage());
		e.printStackTrace();
	}
%>