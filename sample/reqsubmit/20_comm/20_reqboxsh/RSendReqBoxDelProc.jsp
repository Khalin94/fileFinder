<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.SendReqBoxDelegate" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.params.requestinfo.RCommReqLogForm" %>
<%@ page import="nads.dsdm.app.common.ums.UmsInfoDelegate" %>
<%@ page import="kr.co.kcc.bf.config.*" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	/******************************************************************************
	* Name		  : RMakeReqBoxDelProc.jsp
	* Summary	  : 요구함 삭제  처리 기능.
	* Description : 요구함 정보를 삭제하고 요구함 목록 으로 이동한다.
	* 				※※ 체크 ※※
	*				 아직 에러처리후 포워딩 페이지로 넘기지 않음.
	******************************************************************************/
%>
<%
	UserInfoDelegate objUserInfo =null;
	CDInfoDelegate objCdinfo =null;
	
	String webURL = ""; //http 주소
	try {
		Config objConfig = PropertyConfig.getInstance(); //프로퍼티
		webURL = objConfig.get("nads.dsdm.url");
	} catch (ConfigException objConfigEx) {
		out.println(objConfigEx.toString() + "<br>");
		return;
	}
%>
<%@ include file="../../common/RUserCodeInfoInc.jsp" %>

<%
	/*************************************************************************************************/
	/** 					파라미터 체크 Part 														  */
	/*************************************************************************************************/
	/** 요구함 정보 설정 */  
	String[] arrReqBoxIDs = request.getParameterValues("ReqBoxID");

	if(arrReqBoxIDs.length < 1) {
  		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  		objMsgBean.setStrCode("DSPARAM-0000");
  		objMsgBean.setStrMsg("파라미터(요구함 ID)가 전달되지 않았습니다");
  		//out.println("ParamError:" + "파라미터(요구함 ID)가 전달되지 않았습니다");
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}

	/*************************************************************************************************/
	/** 					데이터 처리 Part 														  */
	/*************************************************************************************************/

	int resultInt = -1; //삭제 여부.

	try {
	
		/********* 대리자 정보 설정 *********/
		SendReqBoxDelegate objSReqBox = new SendReqBoxDelegate();
		resultInt = objSReqBox.removeAllRecords(arrReqBoxIDs);
		if(resultInt < 1) {
			throw new AppException();
		}

		RCommReqLogForm objParams = new RCommReqLogForm();
		boolean blnParamCheck = false;

		/**전달된 파리미터 체크 */
		blnParamCheck = objParams.validateParams(request);
		if(blnParamCheck==false) {
			objMsgBean.setMsgType(MessageBean.TYPE_WARN);
			objMsgBean.setStrCode("DSPARAM-0000");
			objMsgBean.setStrMsg(objParams.getStrErrors());
			out.println("ParamError:" + objParams.getStrErrors());
%>
			<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
			return;
		}
		String strNtcMtd = objParams.getParamValue("NtcMtd");
		
/*
    CommRequestInfoDelegate  objReqInfo = new CommRequestInfoDelegate();

	//SQL질의만들기.
	//수정/삭제 통보에서 할일...
	//1. NtcMtd에 따라 E-mail,sms(002), Email(001)선택적으로 보낸다.
	//2. 수신자는 예전 ReqID의 등록자에게 보낸다. 
	//3. 예전 데이터가 의원실에서 온경우에만 수정삭제 통보한다.
	//4. 요구 LOG 테이블에 예전 의원실 요구ID로 등록한다.
	//5. 수정/삭제 통보후 임시요구함과 일반요구였을때의 요구에 상태 update
	
	UmsInfoDelegate objUms = new UmsInfoDelegate();
	//메소드 새로 만들기.. User 데이터 갖구 오는 메소드  
	//발신정보가져오기
	ResultSetSingleHelper objRsSH = new ResultSetSingleHelper(objSReqBox.getSUserInfo(objUserInfo.getUserID(),objUserInfo.getOrganID()));    
	//수신정보,요구정보가져오기
	ResultSetSingleHelper objRsRI = new ResultSetSingleHelper(objSReqBox.getUserInfo(strReqBoxID));    
	
	//sms와 smtp 내용 담기 Hashtable
	Hashtable objHashSmtpData = new Hashtable();
	Hashtable objHashMaiData = new Hashtable();
	Hashtable objHashSmsData = new Hashtable();
	int intSend = 0;
	int intSmsSend = 0;
	int intReturn = 0;

	//수신
	String strCPhone = (String)objRsRI.getObject("CPHONE");
	//String strCPhone = "019-372-9424";
	strCPhone = strCPhone.replaceAll("-","");
	String strSmtOrganNm = (String)objRsRI.getObject("ORGAN_NM");	
	String strRID = (String)objRsRI.getObject("USER_ID");
	String strReqBoxNm = (String)objRsRI.getObject("REQ_BOX_NM");
	String strCmtOrganid = (String)objRsRI.getObject("CMT_ORGAN_ID");
	String strReqOrganid = (String)objRsRI.getObject("REQ_ORGAN_ID");
	String strSOrganid   = (String)objRsRI.getObject("ORGAN_ID");
	String strReqOrganNm = objSReqBox.getOrganNm(strReqOrganid);
	String strSOrganNm   = objSReqBox.getOrganNm(strSOrganid);
	String strOfficeTel =  (String)objRsRI.getObject("OFFICE_TEL");	
	String strReqContent = "";
	String strReqTitle = "";
	String strServGbn = "";
	System.out.println("strCPhone :"+strCPhone);
	System.out.println("strSmtOrganNm :"+strSmtOrganNm);
	System.out.println("strRID :"+strRID);
	System.out.println("strReqBoxNm :"+strReqBoxNm);
	System.out.println("strCmtOrganid :"+strCmtOrganid);
	System.out.println("strReqOrganid :"+strReqOrganid);
	System.out.println("이름 : "+(String)objRsRI.getObject("USER_NM"));
	//본문내용 만들기.
	strReqContent = strReqOrganNm+"에서 "+strSOrganNm+"의"+(String)objRsRI.getObject("USER_NM")+"님께서 작성하신 "+strReqBoxNm+" 요구함을 삭제하였습니다.";
	strReqTitle = "의정자료 전자유통 시스템에 제출하신 요구함이 삭제되었습니다. ["+strReqOrganNm+"]";
	strServGbn = "004";

	//발신
	String strSMail = (String)objRsSH.getObject("EMAIL");
	//String strSMail = "texon11@empal.com"; 
	String strSCPhone = (String)objRsSH.getObject("CPHONE");
	//String strSCPhone = "019-372-9424";;
	strSCPhone = strSCPhone.replaceAll("-","");	
	String strUID = objUserInfo.getUserID();
	
	//입력할 데이타를 HashTable 생성
	//e_mail

	objHashSmtpData.put("RID", strRID);
	objHashSmtpData.put("RNAME", (String)objRsRI.getObject("USER_NM"));
	objHashSmtpData.put("RMAIL", (String)objRsRI.getObject("EMAIL"));
	//objHashSmtpData.put("RMAIL", "texon11@empal.com");	

	objHashSmtpData.put("SID", objUserInfo.getUserID());		//발신자ID
	objHashSmtpData.put("SNAME", objUserInfo.getUserName());	//발신자명
	objHashSmtpData.put("SMAIL", strSMail);						//발신자메일주소
	objHashSmtpData.put("SUBJECT", "자료제출 요청내용이 삭제되었습니다");								//제목
	objHashSmtpData.put("CONTENTS", webURL+"/newsletter/ReqListDelete.jsp?title=자료요구함 삭제&sendname="+(String)objRsRI.getObject("USER_NM")+"&reqname="+objUserInfo.getUserName()+"&sendorg="+strSOrganNm+"의"+(String)objRsRI.getObject("USER_NM")+"님"+"&reqorg="+strReqOrganNm+"&reqtitle="+strReqTitle+"&reqcontent="+strReqContent+"&reqtel="+strOfficeTel+"&reqmail="+strSMail);		//내용  
	objHashSmtpData.put("SYSTEM_GBN", "S13001");				//시스템구분
	objHashSmtpData.put("SERVICE_GBN", strServGbn);					//서비스구분
	objHashSmtpData.put("STATUS", "0");							//전송상태
	objHashSmtpData.put("DEPT_GBN", objUserInfo.getOrganID());		//부서구분
	objHashSmtpData.put("DEPT_NM", strSOrganNm);		//부서명
	
	// 2005-08-06 kogaeng For Test 
	//intSend = objUms.insertSMTP_WEB_REC(objHashSmtpData);

	
	//sms 
	objHashSmsData.put("SEND_PHONE_NO", strCPhone);
	objHashSmsData.put("RETURN_NO", strSCPhone);		//회신번호
	objHashSmsData.put("SEND_STATUS", "1");				//전송상태
	objHashSmsData.put("MSG", strReqTitle);					//메시지
	objHashSmsData.put("SYSTEM_GBN", "S13001");			//시스템구분	
	objHashSmsData.put("SERVICE_GBN", strServGbn);			//서비스구분
	objHashSmsData.put("DEPT_GBN", objUserInfo.getOrganID());				//부서ID
	objHashSmsData.put("DEPT_NM", strSOrganNm);				//부서명
	objHashSmsData.put("USER_ID", objUserInfo.getUserID());				//사용자ID
	objHashSmsData.put("USER_NM", objUserInfo.getUserName());			//사용자명

	// 2005-08-06 kogaeng For Test 
	//intSmsSend = objUms.insertSMS(objHashSmsData);	
	
	//int intResult = objReqInfo.setNewLogRecord(objParams);
	//if(intResult < 0){
	//	out.println("<br>Error!!!");
	//}
	*/
	
	} catch(AppException objAppEx) { 
 		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		System.out.println("SysErrorCode:" + objAppEx.getStrErrCode());
  		objMsgBean.setStrCode("SYS-00010");//AppException에러.
  		objMsgBean.setStrMsg(objAppEx.getMessage());
 		//out.println("<br>Error!!!" + objAppEx.getMessage());
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%  	
		return; 
	}
%>

<html>
<script language="JavaScript">
	function init(){
		<% if(resultInt > 0) { %>
			alert("요구함 정보가 삭제되었습니다 ");
		<% } else { %>
			alert("요구함 삭제에 실패했습니다. 관리자에게 문의 바랍니다.");
		<% } %>
		opener.location.href = "/reqsubmit/20_comm/20_reqboxsh/30_sendend/RSendBoxList.jsp?AuditYear=<%=(String)request.getParameter("AuditYear")%>&CmtOrganID=<%=(String)request.getParameter("CmtOrganID")%>";
		self.close();
		//formName.submit();
	}
</script>
<body onLoad="init()">
				<form name="formName" method="<%=nads.lib.reqsubmit.EnvConstants.FORM_METHOD%>" action="/reqsubmit/20_comm/20_reqboxsh/30_sendend/RSendBoxList.jsp" >
				    <input type="hidden" name="AuditYear" value="<%=(String)request.getParameter("AuditYear")%>">
				    <input type="hidden" name="CmtOrganID" value="<%=(String)request.getParameter("CmtOrganID")%>"><!--위원회 기관 ID -->
				</form>
</body>
<html>
			