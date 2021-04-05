<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RMemReqBoxWriteForm"%>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RMemReqDocSendForm"%>

<%@ page import="nads.lib.reqsubmit.params.requestinfo.RMemReqInfoWriteForm"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.all.ReqInfoAllInOneDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.answerinfo.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.SMemReqBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.SMemReqInfoDelegate" %>
<%@ page import="nads.lib.reqsubmit.params.answerinfo.SMemAnsInfoWriteForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.MemReqDocSendDelegate" %>
<%@ page import="nads.lib.reqsubmit.form.RequestWrapper" %>
<%@ page import="nads.lib.reqsubmit.*" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	UserInfoDelegate objUserInfo =null;
	CDInfoDelegate objCdinfo =null;
%>

<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>

<%
	/*************************************************************************************************/
	/** 					파라미터 체크 Part 														  */
	/*************************************************************************************************/
	String strUserDN = StringUtil.getEmptyIfNull(request.getParameter("user_dn"));
	HttpSession objPrivateSession = request.getSession();
	objPrivateSession.setAttribute("UserDN", strUserDN);

	boolean blnParamCheck = false;
	boolean blnParamCheck1 = false;
	boolean blnParamCheck2 = false;

	/**전달된 파리미터 체크 */
	/**Multipart일경우 반드시 이녀석을 이용해서 담의 Valid파람으로 넘겨줘야함 */
	RequestWrapper objRequestWrapper = null;
	try {
		objRequestWrapper = new RequestWrapper(request);
	} catch(java.io.IOException ex) {
		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
		objMsgBean.setStrCode("DSPARAM-0010");
		objMsgBean.setStrMsg("업로드할 파일사이즈를 초과하였습니다. 제한된 파일사이즈를 확인해 주세요!!");
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}

	/** 요구함 생성위한 세션 파라미터 설정.*/
	RMemReqBoxWriteForm objReqBox = new RMemReqBoxWriteForm();
	RMemReqInfoWriteForm objReqInfo = new RMemReqInfoWriteForm();
	RMemReqDocSendForm objReqdoc = new RMemReqDocSendForm();
	ReqInfoAllInOneDelegate objAllInOne = new ReqInfoAllInOneDelegate();

	SMemAnsInfoWriteForm objParamForm = new SMemAnsInfoWriteForm();
	AnsInfoDelegate objSMAIDelegate = new AnsInfoDelegate();
	SMemReqBoxDelegate objBoxDelegate = new SMemReqBoxDelegate();
	MemReqDocSendDelegate objBean = new MemReqDocSendDelegate();

	blnParamCheck1 = objReqBox.validateParams(objRequestWrapper);
	blnParamCheck2 = objReqInfo.validateParams(objRequestWrapper);
	blnParamCheck = objParamForm.validateParams(objRequestWrapper);

	String strReqBoxTp = StringUtil.getEmptyIfNull(objReqBox.getParamValue("ReqBoxTp"));
	String strReqBoxNm = this.checkNull(objReqBox.getParamValue("req_box_nm"));
	String strNatCnt = StringUtil.getEmptyIfNull(objReqBox.getParamValue("NatCnt"));
	String CmtOrganID = StringUtil.getEmptyIfNull(objReqBox.getParamValue("CmtOrganID"));
	String[] strReqOrganIdData = StringUtil.split("^",StringUtil.getEmptyIfNull(objReqBox.getParamValue("ReqOrganID")));
	String strRltdDutyX = StringUtil.getEmptyIfNull(objReqBox.getParamValue("RltdDutyX"));
	String strAnsDuty = StringUtil.getEmptyIfNull(objReqBox.getParamValue("AnsDuty"));
	String strReqDate = StringUtil.getEmptyIfNull(objReqBox.getParamValue("reqdate"));
	String strReqName = StringUtil.getEmptyIfNull(objReqInfo.getParamValue("ReqCont"));
	String strReqCont = StringUtil.getEmptyIfNull(objReqInfo.getParamValue("ReqDtlCont"));
	String strRegId = StringUtil.getEmptyIfNull(objReqInfo.getParamValue("RegrID"));
	String strSubmtDln = StringUtil.getEmptyIfNull(objReqBox.getParamValue("SubmtDln"));
	String strReqOrganId = strReqOrganIdData[0];
	String[] strReqDateData = StringUtil.split("-",strReqDate);
	strReqDate = strReqDateData[0]+strReqDateData[1]+strReqDateData[2];
	String OrganNm = objAllInOne.getOrganNM((String)objUserInfo.getOrganID());

	System.out.println("strSubmtDln :: "+strSubmtDln);
	System.out.println("strReqName :: "+strReqName);
	System.out.println("strReqCont :: "+strReqCont);
	System.out.println("strSubmtDln :: "+strSubmtDln);

	strReqBoxNm = "(비전자요구)제"+strNatCnt+"회 "+strReqName;

	System.out.println("strSubmtDln :: "+strSubmtDln);
	System.out.println("strReqName :: "+strReqName);
	System.out.println("strReqCont :: "+strReqCont);
	System.out.println("strSubmtDln :: "+strSubmtDln);
	System.out.println("strReqBoxNm :: "+strReqBoxNm);

	String strDesc = strReqDateData[0]+"년"+strReqDateData[1]+"월"+strReqDateData[2]+"일 "+strReqOrganIdData[1]+"실에서 오프라인으로 요청한 자료입니다.";

	String strCount = (String)objParamForm.getParamValue("count");;
	int count = -1;
	int intElcAnsInfoProcResult =-1;


	String strRefreshURL = "";
	String strReqBoxStt = "";

	strRefreshURL = "/reqsubmit/10_mem/20_reqboxsh/10_make/RMakeReqBoxList.jsp";
	strReqBoxStt = CodeConstants.REQ_BOX_STT_006;




	/**전달된 파리미터 체크 */
	objReqBox.setParamValue("RegrID",strRegId);	//요구자 ID설정.
	objReqBox.setParamValue("ReqOrganID",strReqOrganId);//요구기관을 세션에서 넣어줌.
	objReqBox.setParamValue("ReqBoxStt", strReqBoxStt);
	objReqBox.setParamValue("SubmtDln", strSubmtDln);
	objReqBox.setParamValue("ReqBoxDsc",strDesc);
	objReqBox.setParamValue("AnsDuty",strAnsDuty);
	objReqBox.setParamValue("reqdate",strReqDate+"000000000");
	objReqBox.setParamValue("RecrId",objUserInfo.getUserID());
	objReqBox.setParamValue("SubmtCnt",strCount);


	if(blnParamCheck1==false) {
	  	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
	  	objMsgBean.setStrCode("DSPARAM-0000");
	  	objMsgBean.setStrMsg(objReqBox.getStrErrors());
	  	//out.println("ParamError:" + objParams.getStrErrors());
%>
  		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
	  	return;

	}

	if(blnParamCheck2==false){
	  	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
	  	objMsgBean.setStrCode("DSPARAM-0000");
	  	objMsgBean.setStrMsg(objReqInfo.getStrErrors());
	  	//out.println("ParamError:" + objParams.getStrErrors());
%>
  		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
  		return;
  	}
%>
<%
  	if(!blnParamCheck) {
		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
		objMsgBean.setStrCode("DSPARAM-0000");
	  	objMsgBean.setStrMsg(objParamForm.getStrErrors());
%>
  		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	} // end if
%>

<%
	/*************************************************************************************************/
	/** 					데이터 처리 Part 														  */
	/*************************************************************************************************/

	String strReqBoxID = "";//반환될 요구함번호 받기.
	String strTemp = "";
	String strReqID = "";

	try {

objReqBox.setParamValue("SubmtOrganID",objUserInfo.getOrganID());
		objReqBox.setParamValue("CmtOrganID",CmtOrganID);
		strReqBoxNm = this.strReplaceString(strReqBoxNm);
		objReqBox.setParamValue("req_box_nm",strReqBoxNm);

		/********* 등록실행하기  **************/
		strReqBoxID = objAllInOne.setOpNewRecord1(objReqBox);


		//System.out.println("strReqBoxID :"+strReqBoxID);

		if(strReqBoxID.equalsIgnoreCase("False")) {
			objMsgBean.setMsgType(MessageBean.TYPE_WARN);
			objMsgBean.setStrCode("DSDATA-0010");
%>
			<script language="JavaScript">
				alert("신규 요구함 등록 정보가 중복되었습니다.");
				history.go(-1);
			</script>
<%
			return;
		}
		objReqInfo.setParamValue("ReqBoxID",strReqBoxID);
		objReqInfo.setParamValue("ReqOrganID",strReqOrganId);//요구기관을 세션에서 넣어줌.
		objReqInfo.setParamValue("RegrID",strRegId);//요구생성자를 세션에서 넣어줌.

		objReqInfo.setParamValue("ReqCont", this.checkNull(this.strReplaceString(strReqName)));
		objReqInfo.setParamValue("ReqDtlCont", this.checkNull(this.strReplaceString(strReqCont)));

		strReqID = objAllInOne.setNewRecord2(objReqInfo);


		if(!StringUtil.isAssigned(strReqID)) {
			objMsgBean.setMsgType(MessageBean.TYPE_WARN);
			objMsgBean.setStrCode("DSDATA-0011");
			objMsgBean.setStrMsg("요청하신 요구 정보를 등록하지 못했습니다");
%>
			<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
			return;
		}

	} catch(AppException objAppEx) {
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		objMsgBean.setStrCode(objAppEx.getStrErrCode());
		//objMsgBean.setStrMsg(objAppEx.getMessage());
		//out.println("<br>Error!!!" + objAppEx.getMessage());
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}
%>

<%
try {
		//String strReqBoxID = (String)objParamForm.getParamValue("ReqBoxID");
		//String strReqID = (String)objParamForm.getParamValue("ReqID");
		objReqdoc.setParamValue("ReqBoxID",strReqBoxID);
		objReqdoc.setParamValue("SndrID",strRegId);
		objReqdoc.setParamValue("RcvrID",objUserInfo.getUserID());

		objBean.setNewRecordToSendInfo(objReqdoc);

		String strAnsType = (String)objParamForm.getParamValue("AnsType");
		String strAddAnsFlag = "N";
		String AuditYear	  = objReqBox.getParamValue("AuditYear");

		// 2004-06-07 kogaeng
		String strReturnURL = (String)objParamForm.getParamValue("returnURL");
		String str2ReturnURL = (String)objParamForm.getParamValue("returnURL");

		String strAlertMsg = null;
		int intTotalReqCountAnsIsNull = 0;
		String strflag = "";
		System.out.println("strReqBoxID :"+strReqBoxID);
		System.out.println("strReqID :"+strReqID);
		System.out.println("strAnsType :"+strAnsType);
		System.out.println("strAddAnsFlag :"+strAddAnsFlag);

		objParamForm.setParamValue("ReqBoxID",strReqBoxID);
		objParamForm.setParamValue("ReqID",strReqID);
		//objParamForm.setParamValue("MatType",(String)objParamForm.getParamValue("MatTypeNew"));
		//objParamForm.setParamValue("SendWay",(String)objParamForm.getParamValue("SendWayNew"));
		//objParamForm.setParamValue("AnsType",(String)objParamForm.getParamValue("AnsTypeNew"));

		objParamForm.setParamValue("MatType",(String)objParamForm.getParamValue("MatTypeNew"));
		objParamForm.setParamValue("SendWay",(String)objParamForm.getParamValue("SendWayNew"));
		objParamForm.setParamValue("AnsType",(String)objParamForm.getParamValue("AnsTypeNew"));

		if (CodeConstants.ANS_MTD_ELEC.equalsIgnoreCase(strAnsType)) { // 전자문서이다.
			// 1. 파일명 시퀀스 아이디로 복사
			// 2. 답변파일등록
			// 3. 답변등록
			// 4. PDF 파일 하일라이트 인덱스 파일 생성
			// 5. PDF 파일 검색엔진 색인용 TXT 파일 생성
			// 6. 정리된 모든 파일 저장 경로로 이동(복사)
			// 위의 작업을 진행하는 함수를 호출한다.

			// 원래는 여기에 Ans File ID를 SEQ로 받아와서 SET 하는 부분이 설정되어져 있었지만 POPUP에서 미리 선 작업하도록 한다.

			//System.out.println("strCount:"+strCount);
			count = Integer.parseInt(strCount);
			System.out.println("PdfFilePath :"+objParamForm.getParamValue("PdfFilePath"));
			String PdfFilePath[] = StringUtil.split("Ω",objParamForm.getParamValue("PdfFilePath"));
			System.out.println("DocFilePath :"+objParamForm.getParamValue("DocFilePath"));
			String DocFilePath[] = StringUtil.split("Ω",objParamForm.getParamValue("DocFilePath"));
			System.out.println("AnsFileID :"+objParamForm.getParamValue("AnsFileID"));
			String AnsFileID[] = StringUtil.split("Ω",objParamForm.getParamValue("AnsFileID"));
			System.out.println("PdfFileName :"+objParamForm.getParamValue("PdfFileName"));
			String PdfFileName[] = StringUtil.split("Ω",objParamForm.getParamValue("PdfFileName"));
			System.out.println("OriginFileName :"+objParamForm.getParamValue("OriginFileName"));
			String OriginFileName[] = StringUtil.split("Ω",objParamForm.getParamValue("OriginFileName"));
			//System.out.println("MsgDigest :"+objParamForm.getParamValue("MsgDigest"));
			//String MsgDigest[] = StringUtil.split("Ω",objParamForm.getParamValue("MsgDigest"));
			String OrgRealFileName[] = StringUtil.split("Ω",objParamForm.getParamValue("OrgRealFileName"));
			String PdfRealFileName[] = StringUtil.split("Ω",objParamForm.getParamValue("PdfRealFileName"));
			System.out.println("count :"+count);
			for(int i = 0;i<count; i++){
			    String strAnsID2 = objSMAIDelegate.getSeqNextVal("TBDS_ANSWER_INFO");
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
				objParamForm.setParamValue("OrgRealFileName",OrgRealFileName[i]);
				objParamForm.setParamValue("PdfRealFileName",PdfRealFileName[i]);
				objParamForm.setParamValue("MsgDigest","undefined");
				System.out.println("ANSTIMECHEK(6) : "+this.getCurrentTime());
				intElcAnsInfoProcResult = objSMAIDelegate.setNewRecordElcAnsInfoProc(objParamForm);
				System.out.println("ANSTIMECHEK(7) : "+this.getCurrentTime());
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
			}
		} // 전자문서?? 비전자문서??

		out.println("<script language='javascript'>");
		out.println("alert('정상적으로 등록하였습니다.\\n작성하신 답변내용은 [작성중 요구함]의 상세화면에서 확인/수정하실 수 있습니다.');");
		out.println("parent.opener.location.reload();");
		out.println("parent.close();");
		out.println("</script>");

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
	public String strReplaceString(String strData) {
		if(strData != null && !strData.equals("")){
			strData = StringUtil.ReplaceString(strData, "'", "`");
			//strData = StringUtil.ReplaceString(strData, "&", "＆");
			strData = StringUtil.ReplaceString(strData, "^", "＾");
			strData = StringUtil.ReplaceString(strData, "\"", "＂");
		}
		return strData;
     }


	public String checkNull(String strData) {
		if(strData != null && !strData.equals("")){
			strData=StringUtil.ReplaceString(strData,"&#34;","\"");
			strData=StringUtil.ReplaceString(strData,"&#39;","\'");
			//strData=StringUtil.ReplaceString(strData,"＆lt;","<");
			//strData=StringUtil.ReplaceString(strData,"＆gt;",">");
		}else{
			strData = "";
		}
		return strData;
     }

%>
<%!
	public String getCurrentTime() {
        Calendar oCalendar = Calendar.getInstance();
		String serverDate = oCalendar.get(Calendar.YEAR) + "/" +(oCalendar.get(Calendar.MONTH) + 1)+"/"+ oCalendar.get(Calendar.DAY_OF_MONTH)+"  "+oCalendar.get(Calendar.HOUR_OF_DAY)+":"+oCalendar.get(Calendar.MINUTE)+":"+oCalendar.get(Calendar.SECOND)+":"+oCalendar.get(Calendar.MILLISECOND);
		 return serverDate;
     }

%>