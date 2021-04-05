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
		out.println("alert('요구함 ID가 전달되지 않았습니다. 확인 바랍니다.');");
		out.println("history.go(-1);");
		out.println("</script>");
		return;
	}
	
	/** 각 역할을 수행할 Object를 정의하겠다 */
	MemRequestBoxDelegate objReqBoxInfo = new MemRequestBoxDelegate(); 		// 요구함 조회를 위한 Delegate
	RMemReqBoxVListForm objParams = new RMemReqBoxVListForm();					// 요구 정보 조회를 위한 FORM
	MemRequestInfoDelegate objReqInfo = new MemRequestInfoDelegate(); 			// 요구 정보 조회를 위한 Delegate
	ResultSetHelper objReqRS = null;
	CmtSubmtReqBoxDelegate objReqBox = new CmtSubmtReqBoxDelegate();
	CmtSubmtReqInfoDelegate objSubmtReqInfo = new CmtSubmtReqInfoDelegate();
	CommMakeBoxDelegate objSche = new CommMakeBoxDelegate();
	Hashtable objhashdata = null;
	
	try {
	
		for(int i=0; i<intReqBoxTotalCnt; i++) {	
			String strReqBoxID = (String)arrReqBoxIDs[i];
			String strAuditYear = "";
			String strNatCnt = "";
			String strSubmtDln = "";
			String strCmtSubmtBoxID = "";			// 생성된 후 반환되는 제출신청서 ID
			String strReqScheID = "";					// 생성된 후 반환되는 요구 일정
			String[] arrPdfInfo = null;					// 제출신청서를 생성했을 경우 반환되는 정보 배열 
			String strCmtReqBoxID = "";				// 생성된 후 반환되는 위원회 요구함 ID
			String strReqBoxNm = "";
			String strReqOrganNm = "";
			String strRerNm = "";
			String strReqBoxDsc ="";
			String strReqOrganID = "";
			
			// 요구함 관련 정보 설정
			Hashtable objBoxInfoHash = (Hashtable)objReqBoxInfo.getRecord(strReqBoxID);
			strAuditYear = (String)objBoxInfoHash.get("AUDIT_YEAR")==null?"2008":(String)objBoxInfoHash.get("AUDIT_YEAR");
			strNatCnt = (String)objBoxInfoHash.get("NAT_CNT")==null?"":(String)objBoxInfoHash.get("NAT_CNT");
			strSubmtDln = StringUtil.ReplaceString((String)objBoxInfoHash.get("SUBMT_DLN"), "-", "");
			strReqBoxNm = (String)objBoxInfoHash.get("REQ_BOX_NM")==null?"":(String)objBoxInfoHash.get("REQ_BOX_NM");
			strReqOrganNm =(String)objBoxInfoHash.get("REQ_ORGAN_NM")==null?"":(String)objBoxInfoHash.get("REQ_ORGAN_NM");
			strRerNm =(String)objBoxInfoHash.get("REGR_NM")==null?"":(String)objBoxInfoHash.get("REGR_NM");
			strReqOrganID = (String)objBoxInfoHash.get("REQ_ORGAN_ID")==null?"":(String)objBoxInfoHash.get("REQ_ORGAN_ID");
			strReqBoxDsc = strYear+"년"+strMonth+"월"+strDate+"일 "+strReqOrganNm+" "+strRerNm+"님의 신청에 의해서 자동으로 생성된 요구함 입니다.";
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

	
			// 요구 ID 배열 할당
			/**전달된 파리미터 체크 */
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
			objReqRS = new ResultSetHelper((Hashtable)objReqInfo.getRecordList(objParams));
			int intReqTotalCnt = objReqRS.getTotalRecordCount();
			String[] arrReqID = new String[intReqTotalCnt];
			int j=0;
			while(objReqRS.next()) {
				arrReqID[j] = (String)objReqRS.getObject("REQ_ID");
				//System.out.println("REQ ID : " +arrReqID[j]+"<BR>");
				j++;
			}
			//System.out.println("=====================================<BR>");
			
			if(intReqTotalCnt > 0) {		// 등록된 요구가 1개 이상 있어야 작업을 진행할 수 있다.
			
				// 1.제출신청함 등록
				strCmtSubmtBoxID = objReqBox.copyRecord(arrReqID[0], (String)objUserInfo.getUserID()); 
				
				// 2.요구함의 요구를 제출신청함의 요구로 복사(등록)
				String[] strReturns = new String[arrReqID.length];				// 등록된 제출신청함 및 요구ID 배열 
				for(int k=0; k<arrReqID.length; k++) {
					strReturns[k] = objSubmtReqInfo.copyRecord((String)objUserInfo.getUserID(), arrReqID[k], strCmtSubmtBoxID);
				}
				
				// 3. 위원회 요구일정을 체크해보고 없으면 생성한다.
				strReqScheID = objReqBox.checkHavingCommSche(strCmtOrganID, strAuditYear, strNatCnt);
				
				// 4. 위원회 제출신청서를 생성
		   		arrPdfInfo = objReqBox.getApplyPdfDocEncBase64(objUserInfo.getUserID(), strCmtSubmtBoxID);

				objhashdata.put("CMTSUBMTBOXID",strCmtSubmtBoxID);
				objhashdata.put("REQ_SCHE_ID",strReqScheID);
		   		
		   		// 5. 위원회 요구함으로 등록한다.
				int resultInt2 = objReqBox.approveCmtSubmtReqBoxNew(objhashdata, true);
				
				// 6. 위원회 요구 일정 마감.
				int intReqScheFinish = objSche.updateCommSchStt(strReqScheID);
				
				// 7. 의원실 요구함을 삭제하지 않고, 상태정보만 '위원회 명의 발송' 됨을 명시 한다.
				//Boolean objBool1 = objReqBoxInfo.updateReqBoxStt(strReqBoxID, CodeConstants.REQ_BOX_STT_010);
				
				// 8. 위원회 요구함으로 등록된 요구함을 '접수완료' 로 상태를 변경한다. 
				//Boolean objBool2 = objReqBoxInfo.updateReqBoxSttAndSubmtDln(strCmtReqBoxID, CodeConstants.REQ_BOX_STT_002, strSubmtDln);
								
				
				strSuccessResult.append("[요구함 번호 : "+strReqBoxID+"] 정상 완료");
				intSuccessCnt++;
			
			} else {
				strFailResult.append("[요구함 번호 : "+strReqBoxID+"] : 등록된 요구가 없습니다.");
				intFailCnt++;
			}
			
		}
		StringBuffer sbMsg = new StringBuffer();
		sbMsg.append("[요구서 발송 작업 결과]\\r\\n");
		sbMsg.append("- 전체 개수 : "+intReqBoxTotalCnt +" 개\\r\\n");
		sbMsg.append("- 발송 개수 : "+intSuccessCnt+" 개\\r\\n");
		sbMsg.append("- 미처리 개수 : "+intFailCnt+" 개\\r\\n\\r\\n");
		if(StringUtil.isAssigned(strFailResult.toString())){
			sbMsg.append("[미처리 사유]\\r\\n");
			sbMsg.append(strFailResult.toString()+"\\r\\n");
		}		
		sbMsg.append("정상적으로 발송되었습니다.");
				
		out.println("<script language='javascript'>");
		out.println("parent.notProcessing();");
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
		out.println("Error 발생 : " + e.getMessage());
		System.out.println(e.getMessage());
		e.printStackTrace();
	}
%>