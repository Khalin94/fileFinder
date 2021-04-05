<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="java.util.*" %>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.CommRequestInfoDelegate" %>
<%@ page import="nads.lib.reqsubmit.params.requestinfo.RCommReqLogForm" %>
<%@ page import="nads.dsdm.app.common.ums.UmsInfoDelegate" %>
<%@ page import="kr.co.kcc.bf.config.*" %>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%
/******************************************************************************
* Name		  : RCommReqDelProc.jsp
* Summary	  : �䱸����  ó�� ���.
* Description : �䱸������ �����ϰ� �䱸�� �󼼺������� �̵��Ѵ�.
* 				�ء� üũ �ء�
*				 ���� ����ó���� ������ �������� �ѱ��� ����.
*				 �䱸�� ������ �䱸��Ͽ� �����Ͱ� ������ ������ �ȵ�(üũ�ϱ�)
*				 confirm ���� üũ�ϱ�
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

  String strReqID=(String)request.getParameter("CommReqID");
  String strReqBoxID=(String)request.getParameter("ReqBoxID");
  String strIngStt=(String)request.getParameter("IngStt");
  String strReturnURL = "";

  if("002".equalsIgnoreCase(strIngStt)){
  	strReturnURL = "/reqsubmit/20_comm/20_reqboxsh/20_accend/RAccBoxVList.jsp";
  } else {
  	strReturnURL = "/reqsubmit/20_comm/20_reqboxsh/RCommReqBoxVList.jsp";
  }

  RCommReqLogForm objParams = new RCommReqLogForm();
  boolean blnParamCheck=false;
  /**���޵� �ĸ����� üũ */
  blnParamCheck=objParams.validateParams(request);
  if(blnParamCheck==false){
  	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	objMsgBean.setStrCode("DSPARAM-0000");
  	objMsgBean.setStrMsg(objParams.getStrErrors());
  	out.println("ParamError:" + objParams.getStrErrors());
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%
  	return;
  }//endif

  objParams.setParamValue("CommReqID",strReqID);

  if(!StringUtil.isAssigned(strReqID)){
  	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	objMsgBean.setStrCode("DSPARAM-0000");
  	objMsgBean.setStrMsg("�Ķ����(�䱸ID)�� ���޵��� �ʾҽ��ϴ�");
  	out.println("ParamError:" + "�Ķ����(�䱸ID)�� ���޵��� �ʾҽ��ϴ�");
  	%>
  	<!--jsp:forward page="/common/message/ViewMsg.jsp"/-->
  	<%
  	return;
  }//endif
%>

<%
 /*************************************************************************************************/
 /** 					������ ó�� Part 														  */
 /*************************************************************************************************/
 boolean blnEditOk=false; //���� ����.
 try{
   /********* �븮�� ���� ���� *********/
   CommRequestInfoDelegate objReq=new CommRequestInfoDelegate();
   /********* ������ �����ϱ� **************/
   blnEditOk =((Boolean)objReq.removeRecord(strReqID)).booleanValue();

   if(!blnEditOk){
 	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	objMsgBean.setStrCode("DSDATA-0012");
  	objMsgBean.setStrMsg("��û�Ͻ� �䱸������ �������� ���߽��ϴ�");
  	//out.println("<br>Error!!!" + "��û�Ͻ� �䱸������ �������� ���߽��ϴ�");
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
%>
<%
  objParams.setParamValue("LogGbn",CodeConstants.REQ_LOG_GBN_DELETE);
  String strNtcMtd = objParams.getParamValue("NtcMtd");
  String strRefReqID = objParams.getParamValue("RefReqID");

  System.out.println("strRefReqID : " + strRefReqID);

  if(!"".equalsIgnoreCase(strRefReqID)){
	  if(!strNtcMtd.equals("002")){
	  	objParams.setParamValue("NtcMtd","001");
	  	strNtcMtd = "001";
	  }
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

		UmsInfoDelegate objUms = new UmsInfoDelegate();
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
	    strReqContent = strReqOrganNm+"���� "+strCmtOrganNm+"�� "+strReqBoxNm+" �䱸�Կ� �ڷ����� ��û�Ͻ� " + strReqCont + "�� �����Ǿ����ϴ�.";
		strReqTitle = "�����ڷ� �������� �ý��ۿ� �䱸����� �����Ǿ����ϴ�. ["+strCmtOrganNm+"]";
		strServGbn = "004";

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
		objHashSmtpData.put("SUBJECT", "�ڷ����� ��û������ �����Ǿ����ϴ�");								//����
		objHashSmtpData.put("CONTENTS", webURL+"/newsletter/ReqListDelete.jsp?title=�ڷ�䱸��� ����&sendname="+(String)objRsRI.getObject("USER_NM")+"&reqname="+objUserInfo.getUserName()+"&sendorg="+strReqOrganNm+"&reqorg="+strCmtOrganNm+"&reqtitle="+strReqTitle+"&reqcontent="+strReqContent+"&reqtel="+strOfficeTel+"&reqmail="+strSMail);		//����
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
  }
%>
<html>
<head>
<script language="JavaScript">
	function init(){
		alert("�䱸������ �����Ǿ����ϴ� ");
		formName.submit();
	}
</script>
</head>
<body onload="init()">
	<form name="formName" method="post" action="<%=strReturnURL%>"><!--�䱸�� �ű����� ���� -->
	    <input type="hidden" name="ReqBoxID" value="<%=strReqBoxID%>">
		<input type="hidden" name="CommReqInfoSortField" value="<%=objParams.getParamValue("CommReqInfoSortField")%>"><!--�䱸���� ��������ʵ� -->
		<input type="hidden" name="CommReqInfoSortMtd" value="<%=objParams.getParamValue("CommReqInfoSortMtd")%>"><!--�䱸���� ������ɹ��-->
		<input type="hidden" name="CommReqInfoPage" value="<%=objParams.getParamValue("CommReqInfoPage")%>"><!--�䱸���� ������ ��ȣ -->
		<input type="hidden" name="CommReqInfoQryField" value="<%=objParams.getParamValue("CommReqInfoQryField")%>"><!--�䱸 ��ȸ�ʵ� -->
		<input type="hidden" name="CommReqInfoQryTerm" value="<%=objParams.getParamValue("CommReqInfoQryMtd")%>"><!--�䱸 ��ȸ�� -->
		<input type="hidden" name="CommReqID" value="<%=strReqID%>"><!--�䱸���� ID-->
	</form>
</body>
</html>

