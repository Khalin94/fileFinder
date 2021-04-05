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
	
	String webURL = ""; //http �ּ�
	try {
		Config objConfig = PropertyConfig.getInstance(); //������Ƽ
		webURL = objConfig.get("nads.dsdm.url");
	} catch (ConfigException objConfigEx) {
		out.println(objConfigEx.toString() + "<br>");
		return;
	}
%>
<%@ include file="../../common/RUserCodeInfoInc.jsp" %>

<%
  /**�Ϲ� �䱸�� �󼼺��� �Ķ���� ����.*/
  RCommReqLogForm objParams =new RCommReqLogForm(); 
  
  boolean blnParamCheck=false;
  /**���޵� �ĸ����� üũ */
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
  CommRequestInfoDelegate  objReqInfo=null;		/** �䱸���� Delegate */

 try{
    /**�䱸 ���� �븮�� New */      
    objReqInfo=new CommRequestInfoDelegate();
    
	//SQL���Ǹ����.
	//����/���� �뺸���� ����...
	//1. NtcMtd�� ���� E-mail,sms(002), Email(001)���������� ������.
	//2. �����ڴ� ���� ReqID�� ����ڿ��� ������. 
	//3. ���� �����Ͱ� �ǿ��ǿ��� �°�쿡�� �������� �뺸�Ѵ�.
	//4. �䱸 LOG ���̺� ���� �ǿ��� �䱸ID�� ����Ѵ�.
	//5. ����/���� �뺸�� �ӽÿ䱸�԰� �Ϲݿ䱸�������� �䱸�� ���� update
	
	String strRsn = objParams.getParamValue("Rsn");
	String strReqID = objParams.getParamValue("CommReqID");
	
	UmsDelegate objUms = new UmsDelegate();
	//�޼ҵ� ���� �����.. User ������ ���� ���� �޼ҵ�  
	//�߽�������������
	ResultSetSingleHelper objRsSH = new ResultSetSingleHelper(objReqInfo.getSUserInfo(objUserInfo.getUserID(),objUserInfo.getOrganID()));    
	//��������,�䱸������������
	ResultSetSingleHelper objRsRI = new ResultSetSingleHelper(objReqInfo.getUserInfo(strReqID,strRefReqID));    
	
	//sms�� smtp ���� ��� Hashtable
	Hashtable objHashSmtpData = new Hashtable();
	Hashtable objHashMaiData = new Hashtable();
	Hashtable objHashSmsData = new Hashtable();
	int intSend = 0;
	int intSmsSend = 0;
	int intReturn = 0;

	//����
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
	
	//�������� �����.
  if(strUdFlag.equalsIgnoreCase("Update")){	
	strReqContent = strReqOrganNm+"���� "+strCmtOrganNm+"�� "+strReqBoxNm+" �䱸�Կ� �ڷ����� ��û�Ͻ� " + strReqCont + "�� �����Ǿ����ϴ�.";
	strReqTitle = "�����ڷ� �������� �ý��ۿ� �䱸����� �����Ǿ����ϴ�. ["+strCmtOrganNm+"]";
	strServGbn = "003";
  } else {
    strReqContent = strReqOrganNm+"���� "+strCmtOrganNm+"�� "+strReqBoxNm+" �䱸�Կ� �ڷ����� ��û�Ͻ� " + strReqCont + "�� �����Ǿ����ϴ�.";
	strReqTitle = "�����ڷ� �������� �ý��ۿ� �䱸����� �����Ǿ����ϴ�. ["+strCmtOrganNm+"]";
	strServGbn = "004";
  }
	//�߽�
	String strSMail = (String)objRsSH.getObject("EMAIL");
	String strSCPhone = (String)objRsSH.getObject("CPHONE");
	strSCPhone = strSCPhone.replaceAll("-","");	
	String strUID = objUserInfo.getUserID();
	
	//�Է��� ����Ÿ�� HashTable ����
	//e_mail

	objHashSmtpData.put("RID", strRID);
	objHashSmtpData.put("RNAME", (String)objRsRI.getObject("USER_NM"));
	objHashSmtpData.put("RMAIL", (String)objRsRI.getObject("EMAIL"));

	objHashSmtpData.put("SID", objUserInfo.getUserID());		//�߽���ID
	objHashSmtpData.put("SNAME", objUserInfo.getUserName());	//�߽��ڸ�
	objHashSmtpData.put("SMAIL", strSMail);						//�߽��ڸ����ּ�
  if(strUdFlag.equalsIgnoreCase("Update")){	
	objHashSmtpData.put("SUBJECT", "�ڷ����� ��û������ �����Ǿ����ϴ�");								//����
	objHashSmtpData.put("CONTENTS", webURL+"/newsletter/ReqListUpdate.jsp?title=�ڷ�䱸��� ����&sendname="+(String)objRsRI.getObject("USER_NM")+"&reqname="+objUserInfo.getUserName()+"&sendorg="+strReqOrganNm+"&reqorg="+strCmtOrganNm+"&reqtitle="+strReqTitle+"&reqcontent="+strReqContent+"&reqtel="+strOfficeTel+"&reqmail="+strSMail);		//����
  } else {
	objHashSmtpData.put("SUBJECT", "�ڷ����� ��û������ �����Ǿ����ϴ�");								//����
	objHashSmtpData.put("CONTENTS", webURL+"/newsletter/ReqListDelete.jsp?title=�ڷ�䱸��� ����&sendname="+(String)objRsRI.getObject("USER_NM")+"&reqname="+objUserInfo.getUserName()+"&sendorg="+strReqOrganNm+"&reqorg="+strCmtOrganNm+"&reqtitle="+strReqTitle+"&reqcontent="+strReqContent+"&reqtel="+strOfficeTel+"&reqmail="+strSMail);		//����  
  }
	objHashSmtpData.put("SYSTEM_GBN", "S13001");				//�ý��۱���
	objHashSmtpData.put("SERVICE_GBN", strServGbn);					//���񽺱���
	objHashSmtpData.put("STATUS", "0");							//���ۻ���
	objHashSmtpData.put("DEPT_GBN", objUserInfo.getOrganID());		//�μ�����
	objHashSmtpData.put("DEPT_NM", strCmtOrganNm);		//�μ���
    
	intSend = objUms.insertSMTP_WEB_REC(objHashSmtpData);

	if(strNtcMtd.equals("002")){
		//sms 
		objHashSmsData.put("SEND_PHONE_NO", strCPhone);
		objHashSmsData.put("RETURN_NO", strSCPhone);		//ȸ�Ź�ȣ
		objHashSmsData.put("SEND_STATUS", "1");				//���ۻ���
		objHashSmsData.put("MSG", strReqTitle);					//�޽���
		objHashSmsData.put("SYSTEM_GBN", "S13001");			//�ý��۱���	
		objHashSmsData.put("SERVICE_GBN", strServGbn);			//���񽺱���
		objHashSmsData.put("DEPT_GBN", objUserInfo.getOrganID());				//�μ�ID
		objHashSmsData.put("DEPT_NM", strCmtOrganNm);				//�μ���
		objHashSmsData.put("USER_ID", objUserInfo.getUserID());				//�����ID
		objHashSmsData.put("USER_NM", objUserInfo.getUserName());			//����ڸ�

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
  //�䱸�� ������ ����.
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


