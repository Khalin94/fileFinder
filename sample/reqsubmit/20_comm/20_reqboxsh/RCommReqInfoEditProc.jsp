<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="java.util.*" %>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RCommReqBoxVListForm" %>
<%@ page import="nads.lib.reqsubmit.params.requestinfo.RCommReqInfoEditForm" %>
<%@ page import="nads.lib.reqsubmit.params.requestinfo.RCommReqLogForm" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.CommRequestInfoDelegate" %>
<%@ page import="nads.dsdm.app.common.ums.UmsInfoDelegate" %>
<%@ page import="kr.co.kcc.bf.config.*" %>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
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
  RCommReqInfoEditForm objEditParams =new RCommReqInfoEditForm();  
  boolean blnParamCheck=false;
  /**전달된 파리미터 체크 */
  nads.lib.reqsubmit.form.RequestWrapper objRequestWrapper=new nads.lib.reqsubmit.form.RequestWrapper(request);  
  
  blnParamCheck=objEditParams.validateParams(objRequestWrapper);
  if(blnParamCheck==false){
  	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	objMsgBean.setStrCode("DSPARAM-0000");
  	objMsgBean.setStrMsg(objEditParams.getStrErrors());
  	//out.println("ParamError:" + objParams.getStrErrors());
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%
  	return;
  }//endif
  String strReturnURL = (String)objEditParams.getParamValue("ReturnURL");
%>
<%
 /*************************************************************************************************/
 /** 					데이터 처리 Part 														  */
 /*************************************************************************************************/

 try{
   /********* 대리자 정보 설정 *********/
   CommRequestInfoDelegate objReqInfo=new CommRequestInfoDelegate();   /** 요구 정보 수정용 */
   /********* 데이터 등록 하기  **************/
   boolean blnReturn=objReqInfo.setRecord(objEditParams).booleanValue();  
   if(!blnReturn){
 	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	objMsgBean.setStrCode("DSDATA-0011");
  	objMsgBean.setStrMsg("요청하신 요구 정보를 수정하지 못했습니다");
  	//out.println("<br>Error!!!" + "요청하신 요구 정보를 수정하지 못했습니다");   
  	%>
	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%  	
  	return;   	
   }
 }catch(AppException objAppEx){ 
 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  	objMsgBean.setStrCode(objAppEx.getStrErrCode());
  	objMsgBean.setStrMsg(objAppEx.getMessage());
  	//out.println("<br>Error!!!" + objAppEx.getMessage());
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%  	
  	return; 
 }

  /** 요구 수정에 필요한 파라 미터 체크.*/
  RCommReqBoxVListForm objParams =new RCommReqBoxVListForm();  
  blnParamCheck=false;
  /** 요구함정보 수정 파리미터 체크 */
  /** 위에서 선언한 Wrapper */
  blnParamCheck=objParams.validateParams(objRequestWrapper);
  if(blnParamCheck==false){
  	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	objMsgBean.setStrCode("DSPARAM-0000");
  	objMsgBean.setStrMsg(objParams.getStrErrors());
  	out.println("ParamError:" + objEditParams.getStrErrors());
  	%>
	<!--jsp:forward page="/common/message/ViewMsg.jsp"/-->
  	<%
  	return;
  }//endif


  	
  /**일반 요구함 상세보기 파라미터 설정.*/
  RCommReqLogForm objLogParams =new RCommReqLogForm(); 
  objLogParams.setParamValue("LogGbn",CodeConstants.REQ_LOG_GBN_EDIT);
    
  boolean blnParamCheckLog=false;
  /**전달된 파리미터 체크 */
  blnParamCheckLog=objLogParams.validateParams(objRequestWrapper);
  if(blnParamCheckLog==false){
  	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	objMsgBean.setStrCode("DSPARAM-0000");
  	objMsgBean.setStrMsg(objLogParams.getStrErrors());
  	//out.println("ParamError:" + objLogParams.getStrErrors());
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%
  	return;
  }//endif
  
  String strNtcMtd = objLogParams.getParamValue("NtcMtd");
  String strRefReqID = objLogParams.getParamValue("RefReqID");

  if(!"".equalsIgnoreCase(strRefReqID)){
	  if(!strNtcMtd.equals("002")){
	  	objLogParams.setParamValue("NtcMtd","001");
	  	strNtcMtd = "001";
	  }
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
		
		String strRsn = objLogParams.getParamValue("Rsn");
		String strReqID = objLogParams.getParamValue("CommReqID");
		
		UmsInfoDelegate objUms = new UmsInfoDelegate();
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
		strReqContent = strReqOrganNm+"에서 "+strCmtOrganNm+"의 "+strReqBoxNm+" 요구함에 자료제출 요청하신 " + strReqCont + "가 수정되었습니다.";
		strReqTitle = "의정자료 전자유통 시스템에 요구목록이 수정되었습니다. ["+strCmtOrganNm+"]";
		strServGbn = "003";
	
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
		objHashSmtpData.put("SUBJECT", "자료제출 요청내용이 수정되었습니다");								//제목
		objHashSmtpData.put("CONTENTS", webURL+"/newsletter/ReqListUpdate.jsp?title=자료요구목록 수정&sendname="+(String)objRsRI.getObject("USER_NM")+"&reqname="+objUserInfo.getUserName()+"&sendorg="+strReqOrganNm+"&reqorg="+strCmtOrganNm+"&reqtitle="+strReqTitle+"&reqcontent="+strReqContent+"&reqtel="+strOfficeTel+"&reqmail="+strSMail);		//내용
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
		int intResult = objReqInfo.setNewLogRecord(objLogParams);
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
  }
%>

<%
 /*************************************************************************************************/
 /** 					페이지 전환 Part 														  */
 /*************************************************************************************************/
%>
<html>
<script language="JavaScript">
	function init(){
	    alert("요구 정보가 수정되었습니다 ");
		formName.submit();
	}
</script>
<body onLoad="init()">
	<form name="formName" method="post" action="<%= strReturnURL %>" ><!--요구함 신규정보 전달 -->
	    <input type="hidden" name="ReqBoxID" value="<%=objParams.getParamValue("ReqBoxID")%>">
		<input type="hidden" name="CommReqBoxSortField" value="<%=objParams.getParamValue("CommReqBoxSortField")%>"><!--요구함목록정렬필드 -->
		<input type="hidden" name="CommReqBoxSortMtd" value="<%=objParams.getParamValue("CommReqBoxSortMtd")%>"><!--요구함목록정령방법-->
		<input type="hidden" name="CommReqBoxPage" value="<%=objParams.getParamValue("CommReqBoxPage")%>"><!--요구함 페이지 번호 -->
		<input type="hidden" name="CommReqBoxQryField" value="<%=objParams.getParamValue("CommReqBoxQryField")%>"><!--요구함 조회필드 -->
		<input type="hidden" name="CommReqBoxQryTerm" value="<%=objParams.getParamValue("CommReqBoxQryMtd")%>"><!--요구함 조회어 -->
		<input type="hidden" name="CommReqInfoSortField" value="<%=objParams.getParamValue("CommReqInfoSortField")%>"><!--요구정보 목록정렬필드 -->
		<input type="hidden" name="CommReqInfoSortMtd" value="<%=objParams.getParamValue("CommReqInfoSortMtd")%>"><!--요구정보 목록정령방법-->
		<input type="hidden" name="CommReqInfoPage" value="<%=objParams.getParamValue("CommReqInfoPage")%>"><!--요구정보 페이지 번호 -->
		<input type="hidden" name="CommReqInfoQryField" value="<%=objParams.getParamValue("CommReqInfoQryField")%>"><!--요구 조회필드 -->
		<input type="hidden" name="CommReqInfoQryTerm" value="<%=objParams.getParamValue("CommReqInfoQryMtd")%>"><!--요구 조회어 -->										
		<input type="hidden" name="CommReqID" value="<%=objEditParams.getParamValue("ReqInfoID")%>"><!--요구정보 ID-->
	</form>
</body>
</html>

