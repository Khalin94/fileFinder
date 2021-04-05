<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="java.util.*" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.params.requestinfo.RCommReqLogForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.CommRequestInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.common.UmsDelegate" %>
<%@ page import="kr.co.kcc.bf.config.*" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
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
  /**일반 요구함 상세보기 파라미터 설정.*/
  RCommReqLogForm objParams =new RCommReqLogForm(); 
  
  boolean blnParamCheck=false;
  /**전달된 파리미터 체크 */
  blnParamCheck=objParams.validateParams(request);
  if(blnParamCheck==false){
  	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	objMsgBean.setStrCode("DSPARAM-0000");
  	objMsgBean.setStrMsg(objParams.getStrErrors());
  	//out.println("ParamError:" + objParams.getStrErrors());
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%
  	return;
  }//endif
  
  String strReqBoxID=(String)request.getParameter("ReqBoxID");
  String strUdFlag = StringUtil.getEmptyIfNull(request.getParameter("UdFlag"));
  
  if(strUdFlag.equalsIgnoreCase("Update")){
  	objParams.setParamValue("LogGbn",CodeConstants.REQ_LOG_GBN_EDIT);
  } else {
   	objParams.setParamValue("LogGbn",CodeConstants.REQ_LOG_GBN_DELETE);  
  }
  
  String strNtcMtd = objParams.getParamValue("NtcMtd");
  if(!strNtcMtd.equals("002")){
  	objParams.setParamValue("NtcMtd","001");
  	strNtcMtd = "001";
  }
  String strRefReqID = objParams.getParamValue("RefReqID");
  CommRequestInfoDelegate  objReqInfo=null;		/** 요구정보 Delegate */

 try{
    /**요구 정보 대리자 New */      
    objReqInfo=new CommRequestInfoDelegate();
    
	//SQL질의만들기.
	//수정/삭제 통보에서 할일...
	//1. NtcMtd에 따라 E-mail,sms(002), Email(001)선택적으로 보낸다.
	//2. 수신자는 예전 ReqID의 등록자에게 보낸다. 
	//3. 예전 데이터가 의원실에서 온경우에만 수정삭제 통보한다.
	//4. 요구 LOG 테이블에 예전 의원실 요구ID로 등록한다.
	//5. 수정/삭제 통보후 임시요구함과 일반요구였을때의 요구에 상태 update
	
	String strRsn = objParams.getParamValue("Rsn");
	String strReqID = objParams.getParamValue("CommReqID");
	
	UmsDelegate objUms = new UmsDelegate();
	//메소드 새로 만들기.. User 데이터 갖구 오는 메소드  
	//발신정보가져오기
	ResultSetSingleHelper objRsSH = new ResultSetSingleHelper(objReqInfo.getSUserInfo(objUserInfo.getUserID(),objUserInfo.getOrganID()));    
	//수신정보,요구정보가져오기
	ResultSetSingleHelper objRsRI = new ResultSetSingleHelper(objReqInfo.getUserInfo(strReqID,strRefReqID));    
	
	//sms와 smtp 내용 담기 Hashtable
	Hashtable objHashSmtpData = new Hashtable();
	Hashtable objHashMaiData = new Hashtable();
	Hashtable objHashSmsData = new Hashtable();
	int intSend = 0;
	int intSmsSend = 0;
	int intReturn = 0;

	//수신
	String strCPhone = (String)objRsRI.getObject("CPHONE");
	strCPhone = strCPhone.replaceAll("-","");
	String strSmtOrganNm = (String)objRsRI.getObject("SUBMT_ORGAN_NM");	
	String strRID = (String)objRsRI.getObject("USER_ID");
	String strReqCont = (String)objRsRI.getObject("REQ_CONT");
	String strReqBoxNm = (String)objRsRI.getObject("CMT_SUBMT_REQ_BOX_NM");
	String strCmtOrganNm = (String)objRsRI.getObject("CMT_ORGAN_NM");
	String strReqOrganNm = (String)objRsRI.getObject("REQ_ORGAN_NM");	
	String strOfficeTel =  (String)objRsRI.getObject("OFFICE_TEL");	
	String strReqContent = "";
	String strReqTitle = "";
	String strServGbn = "";
	
	//본문내용 만들기.
  if(strUdFlag.equalsIgnoreCase("Update")){	
	strReqContent = strReqOrganNm+"에서 "+strCmtOrganNm+"의 "+strReqBoxNm+" 요구함에 자료제출 요청하신 " + strReqCont + "가 수정되었습니다.";
	strReqTitle = "의정자료 전자유통 시스템에 요구목록이 수정되었습니다. ["+strCmtOrganNm+"]";
	strServGbn = "003";
  } else {
    strReqContent = strReqOrganNm+"에서 "+strCmtOrganNm+"의 "+strReqBoxNm+" 요구함에 자료제출 요청하신 " + strReqCont + "가 삭제되었습니다.";
	strReqTitle = "의정자료 전자유통 시스템에 요구목록이 삭제되었습니다. ["+strCmtOrganNm+"]";
	strServGbn = "004";
  }
	//발신
	String strSMail = (String)objRsSH.getObject("EMAIL");
	String strSCPhone = (String)objRsSH.getObject("CPHONE");
	strSCPhone = strSCPhone.replaceAll("-","");	
	String strUID = objUserInfo.getUserID();
	
	//입력할 데이타를 HashTable 생성
	//e_mail

	objHashSmtpData.put("RID", strRID);
	objHashSmtpData.put("RNAME", (String)objRsRI.getObject("USER_NM"));
	objHashSmtpData.put("RMAIL", (String)objRsRI.getObject("EMAIL"));

	objHashSmtpData.put("SID", objUserInfo.getUserID());		//발신자ID
	objHashSmtpData.put("SNAME", objUserInfo.getUserName());	//발신자명
	objHashSmtpData.put("SMAIL", strSMail);						//발신자메일주소
  if(strUdFlag.equalsIgnoreCase("Update")){	
	objHashSmtpData.put("SUBJECT", "자료제출 요청내용이 수정되었습니다");								//제목
	objHashSmtpData.put("CONTENTS", webURL+"/newsletter/ReqListUpdate.jsp?title=자료요구목록 수정&sendname="+(String)objRsRI.getObject("USER_NM")+"&reqname="+objUserInfo.getUserName()+"&sendorg="+strReqOrganNm+"&reqorg="+strCmtOrganNm+"&reqtitle="+strReqTitle+"&reqcontent="+strReqContent+"&reqtel="+strOfficeTel+"&reqmail="+strSMail);		//내용
  } else {
	objHashSmtpData.put("SUBJECT", "자료제출 요청내용이 삭제되었습니다");								//제목
	objHashSmtpData.put("CONTENTS", webURL+"/newsletter/ReqListDelete.jsp?title=자료요구목록 삭제&sendname="+(String)objRsRI.getObject("USER_NM")+"&reqname="+objUserInfo.getUserName()+"&sendorg="+strReqOrganNm+"&reqorg="+strCmtOrganNm+"&reqtitle="+strReqTitle+"&reqcontent="+strReqContent+"&reqtel="+strOfficeTel+"&reqmail="+strSMail);		//내용  
  }
	objHashSmtpData.put("SYSTEM_GBN", "S13001");				//시스템구분
	objHashSmtpData.put("SERVICE_GBN", strServGbn);					//서비스구분
	objHashSmtpData.put("STATUS", "0");							//전송상태
	objHashSmtpData.put("DEPT_GBN", objUserInfo.getOrganID());		//부서구분
	objHashSmtpData.put("DEPT_NM", strCmtOrganNm);		//부서명
    
	intSend = objUms.insertSMTP_WEB_REC(objHashSmtpData);

	if(strNtcMtd.equals("002")){
		//sms 
		objHashSmsData.put("SEND_PHONE_NO", strCPhone);
		objHashSmsData.put("RETURN_NO", strSCPhone);		//회신번호
		objHashSmsData.put("SEND_STATUS", "1");				//전송상태
		objHashSmsData.put("MSG", strReqTitle);					//메시지
		objHashSmsData.put("SYSTEM_GBN", "S13001");			//시스템구분	
		objHashSmsData.put("SERVICE_GBN", strServGbn);			//서비스구분
		objHashSmsData.put("DEPT_GBN", objUserInfo.getOrganID());				//부서ID
		objHashSmsData.put("DEPT_NM", strCmtOrganNm);				//부서명
		objHashSmsData.put("USER_ID", objUserInfo.getUserID());				//사용자ID
		objHashSmsData.put("USER_NM", objUserInfo.getUserName());			//사용자명

		intSmsSend = objUms.insertSMS(objHashSmsData);	
	}
	int intResult = objReqInfo.setNewLogRecord(objParams);
	if(intResult < 0){
		out.println("<br>Error!!!");
	}
    
 }catch(AppException objAppEx){
 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  	objMsgBean.setStrCode(objAppEx.getStrErrCode());
  	objMsgBean.setStrMsg(objAppEx.getMessage());
  	out.println("<br>Error!!!" + objAppEx.getMessage());
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>  	
  	<%  	
  	return;
 } 
%>

<!DOCTYPE HTML PUBLIC "-//w3c//dtd html 4.0 transitional//en">
<html>
<head>
<title><%=MenuConstants.REQ_UP_INFORM%></title>
<link href="/css/System.css" rel="stylesheet" type="text/css">
<script language="javascript">
<!--
  //요구함 삭제로 가기.
  function gotoDel(){
	opener.window.location.href='./RCommReqDelProc.jsp?ReqBoxID=<%=strReqBoxID%>&CommReqID=<%=objParams.getParamValue("CommReqID")%>&RefReqID=<%=strRefReqID%>&ReturnURL=<%=(String)request.getParameter("ReturnURL")%>';
	self.close();
 }
  function gotoUp(){
	var f = opener.window.document.formName;
	f.action = "./RCommReqInfoEditProc.jsp";
	f.submit();
	self.close();
 }
//-->
</script>
</head>
<%
	String strMode = "";
	if(strUdFlag.equalsIgnoreCase("Update")) {
		strMode = "gotoUp()";
	} else {
		strMode = "gotoDel()";
	}
%>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onload="<%=strMode%>">
</body>
</html>


