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
	* Summary	  : �䱸�� ����  ó�� ���.
	* Description : �䱸�� ������ �����ϰ� �䱸�� ��� ���� �̵��Ѵ�.
	* 				�ء� üũ �ء�
	*				 ���� ����ó���� ������ �������� �ѱ��� ����.
	******************************************************************************/
%>
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
	/*************************************************************************************************/
	/** 					�Ķ���� üũ Part 														  */
	/*************************************************************************************************/
	/** �䱸�� ���� ���� */  
	String[] arrReqBoxIDs = request.getParameterValues("ReqBoxID");

	if(arrReqBoxIDs.length < 1) {
  		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  		objMsgBean.setStrCode("DSPARAM-0000");
  		objMsgBean.setStrMsg("�Ķ����(�䱸�� ID)�� ���޵��� �ʾҽ��ϴ�");
  		//out.println("ParamError:" + "�Ķ����(�䱸�� ID)�� ���޵��� �ʾҽ��ϴ�");
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}

	/*************************************************************************************************/
	/** 					������ ó�� Part 														  */
	/*************************************************************************************************/

	int resultInt = -1; //���� ����.

	try {
	
		/********* �븮�� ���� ���� *********/
		SendReqBoxDelegate objSReqBox = new SendReqBoxDelegate();
		resultInt = objSReqBox.removeAllRecords(arrReqBoxIDs);
		if(resultInt < 1) {
			throw new AppException();
		}

		RCommReqLogForm objParams = new RCommReqLogForm();
		boolean blnParamCheck = false;

		/**���޵� �ĸ����� üũ */
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

	//SQL���Ǹ����.
	//����/���� �뺸���� ����...
	//1. NtcMtd�� ���� E-mail,sms(002), Email(001)���������� ������.
	//2. �����ڴ� ���� ReqID�� ����ڿ��� ������. 
	//3. ���� �����Ͱ� �ǿ��ǿ��� �°�쿡�� �������� �뺸�Ѵ�.
	//4. �䱸 LOG ���̺� ���� �ǿ��� �䱸ID�� ����Ѵ�.
	//5. ����/���� �뺸�� �ӽÿ䱸�԰� �Ϲݿ䱸�������� �䱸�� ���� update
	
	UmsInfoDelegate objUms = new UmsInfoDelegate();
	//�޼ҵ� ���� �����.. User ������ ���� ���� �޼ҵ�  
	//�߽�������������
	ResultSetSingleHelper objRsSH = new ResultSetSingleHelper(objSReqBox.getSUserInfo(objUserInfo.getUserID(),objUserInfo.getOrganID()));    
	//��������,�䱸������������
	ResultSetSingleHelper objRsRI = new ResultSetSingleHelper(objSReqBox.getUserInfo(strReqBoxID));    
	
	//sms�� smtp ���� ��� Hashtable
	Hashtable objHashSmtpData = new Hashtable();
	Hashtable objHashMaiData = new Hashtable();
	Hashtable objHashSmsData = new Hashtable();
	int intSend = 0;
	int intSmsSend = 0;
	int intReturn = 0;

	//����
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
	System.out.println("�̸� : "+(String)objRsRI.getObject("USER_NM"));
	//�������� �����.
	strReqContent = strReqOrganNm+"���� "+strSOrganNm+"��"+(String)objRsRI.getObject("USER_NM")+"�Բ��� �ۼ��Ͻ� "+strReqBoxNm+" �䱸���� �����Ͽ����ϴ�.";
	strReqTitle = "�����ڷ� �������� �ý��ۿ� �����Ͻ� �䱸���� �����Ǿ����ϴ�. ["+strReqOrganNm+"]";
	strServGbn = "004";

	//�߽�
	String strSMail = (String)objRsSH.getObject("EMAIL");
	//String strSMail = "texon11@empal.com"; 
	String strSCPhone = (String)objRsSH.getObject("CPHONE");
	//String strSCPhone = "019-372-9424";;
	strSCPhone = strSCPhone.replaceAll("-","");	
	String strUID = objUserInfo.getUserID();
	
	//�Է��� ����Ÿ�� HashTable ����
	//e_mail

	objHashSmtpData.put("RID", strRID);
	objHashSmtpData.put("RNAME", (String)objRsRI.getObject("USER_NM"));
	objHashSmtpData.put("RMAIL", (String)objRsRI.getObject("EMAIL"));
	//objHashSmtpData.put("RMAIL", "texon11@empal.com");	

	objHashSmtpData.put("SID", objUserInfo.getUserID());		//�߽���ID
	objHashSmtpData.put("SNAME", objUserInfo.getUserName());	//�߽��ڸ�
	objHashSmtpData.put("SMAIL", strSMail);						//�߽��ڸ����ּ�
	objHashSmtpData.put("SUBJECT", "�ڷ����� ��û������ �����Ǿ����ϴ�");								//����
	objHashSmtpData.put("CONTENTS", webURL+"/newsletter/ReqListDelete.jsp?title=�ڷ�䱸�� ����&sendname="+(String)objRsRI.getObject("USER_NM")+"&reqname="+objUserInfo.getUserName()+"&sendorg="+strSOrganNm+"��"+(String)objRsRI.getObject("USER_NM")+"��"+"&reqorg="+strReqOrganNm+"&reqtitle="+strReqTitle+"&reqcontent="+strReqContent+"&reqtel="+strOfficeTel+"&reqmail="+strSMail);		//����  
	objHashSmtpData.put("SYSTEM_GBN", "S13001");				//�ý��۱���
	objHashSmtpData.put("SERVICE_GBN", strServGbn);					//���񽺱���
	objHashSmtpData.put("STATUS", "0");							//���ۻ���
	objHashSmtpData.put("DEPT_GBN", objUserInfo.getOrganID());		//�μ�����
	objHashSmtpData.put("DEPT_NM", strSOrganNm);		//�μ���
	
	// 2005-08-06 kogaeng For Test 
	//intSend = objUms.insertSMTP_WEB_REC(objHashSmtpData);

	
	//sms 
	objHashSmsData.put("SEND_PHONE_NO", strCPhone);
	objHashSmsData.put("RETURN_NO", strSCPhone);		//ȸ�Ź�ȣ
	objHashSmsData.put("SEND_STATUS", "1");				//���ۻ���
	objHashSmsData.put("MSG", strReqTitle);					//�޽���
	objHashSmsData.put("SYSTEM_GBN", "S13001");			//�ý��۱���	
	objHashSmsData.put("SERVICE_GBN", strServGbn);			//���񽺱���
	objHashSmsData.put("DEPT_GBN", objUserInfo.getOrganID());				//�μ�ID
	objHashSmsData.put("DEPT_NM", strSOrganNm);				//�μ���
	objHashSmsData.put("USER_ID", objUserInfo.getUserID());				//�����ID
	objHashSmsData.put("USER_NM", objUserInfo.getUserName());			//����ڸ�

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
  		objMsgBean.setStrCode("SYS-00010");//AppException����.
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
			alert("�䱸�� ������ �����Ǿ����ϴ� ");
		<% } else { %>
			alert("�䱸�� ������ �����߽��ϴ�. �����ڿ��� ���� �ٶ��ϴ�.");
		<% } %>
		opener.location.href = "/reqsubmit/20_comm/20_reqboxsh/30_sendend/RSendBoxList.jsp?AuditYear=<%=(String)request.getParameter("AuditYear")%>&CmtOrganID=<%=(String)request.getParameter("CmtOrganID")%>";
		self.close();
		//formName.submit();
	}
</script>
<body onLoad="init()">
				<form name="formName" method="<%=nads.lib.reqsubmit.EnvConstants.FORM_METHOD%>" action="/reqsubmit/20_comm/20_reqboxsh/30_sendend/RSendBoxList.jsp" >
				    <input type="hidden" name="AuditYear" value="<%=(String)request.getParameter("AuditYear")%>">
				    <input type="hidden" name="CmtOrganID" value="<%=(String)request.getParameter("CmtOrganID")%>"><!--����ȸ ��� ID -->
				</form>
</body>
<html>
			