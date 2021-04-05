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
  RCommReqInfoEditForm objEditParams =new RCommReqInfoEditForm();  
  boolean blnParamCheck=false;
  /**���޵� �ĸ����� üũ */
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
 /** 					������ ó�� Part 														  */
 /*************************************************************************************************/

 try{
   /********* �븮�� ���� ���� *********/
   CommRequestInfoDelegate objReqInfo=new CommRequestInfoDelegate();   /** �䱸 ���� ������ */
   /********* ������ ��� �ϱ�  **************/
   boolean blnReturn=objReqInfo.setRecord(objEditParams).booleanValue();  
   if(!blnReturn){
 	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	objMsgBean.setStrCode("DSDATA-0011");
  	objMsgBean.setStrMsg("��û�Ͻ� �䱸 ������ �������� ���߽��ϴ�");
  	//out.println("<br>Error!!!" + "��û�Ͻ� �䱸 ������ �������� ���߽��ϴ�");   
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

  /** �䱸 ������ �ʿ��� �Ķ� ���� üũ.*/
  RCommReqBoxVListForm objParams =new RCommReqBoxVListForm();  
  blnParamCheck=false;
  /** �䱸������ ���� �ĸ����� üũ */
  /** ������ ������ Wrapper */
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


  	
  /**�Ϲ� �䱸�� �󼼺��� �Ķ���� ����.*/
  RCommReqLogForm objLogParams =new RCommReqLogForm(); 
  objLogParams.setParamValue("LogGbn",CodeConstants.REQ_LOG_GBN_EDIT);
    
  boolean blnParamCheckLog=false;
  /**���޵� �ĸ����� üũ */
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
		
		String strRsn = objLogParams.getParamValue("Rsn");
		String strReqID = objLogParams.getParamValue("CommReqID");
		
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
		strServGbn = "003";
	
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
		objHashSmtpData.put("CONTENTS", webURL+"/newsletter/ReqListUpdate.jsp?title=�ڷ�䱸��� ����&sendname="+(String)objRsRI.getObject("USER_NM")+"&reqname="+objUserInfo.getUserName()+"&sendorg="+strReqOrganNm+"&reqorg="+strCmtOrganNm+"&reqtitle="+strReqTitle+"&reqcontent="+strReqContent+"&reqtel="+strOfficeTel+"&reqmail="+strSMail);		//����
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
 /** 					������ ��ȯ Part 														  */
 /*************************************************************************************************/
%>
<html>
<script language="JavaScript">
	function init(){
	    alert("�䱸 ������ �����Ǿ����ϴ� ");
		formName.submit();
	}
</script>
<body onLoad="init()">
	<form name="formName" method="post" action="<%= strReturnURL %>" ><!--�䱸�� �ű����� ���� -->
	    <input type="hidden" name="ReqBoxID" value="<%=objParams.getParamValue("ReqBoxID")%>">
		<input type="hidden" name="CommReqBoxSortField" value="<%=objParams.getParamValue("CommReqBoxSortField")%>"><!--�䱸�Ը�������ʵ� -->
		<input type="hidden" name="CommReqBoxSortMtd" value="<%=objParams.getParamValue("CommReqBoxSortMtd")%>"><!--�䱸�Ը�����ɹ��-->
		<input type="hidden" name="CommReqBoxPage" value="<%=objParams.getParamValue("CommReqBoxPage")%>"><!--�䱸�� ������ ��ȣ -->
		<input type="hidden" name="CommReqBoxQryField" value="<%=objParams.getParamValue("CommReqBoxQryField")%>"><!--�䱸�� ��ȸ�ʵ� -->
		<input type="hidden" name="CommReqBoxQryTerm" value="<%=objParams.getParamValue("CommReqBoxQryMtd")%>"><!--�䱸�� ��ȸ�� -->
		<input type="hidden" name="CommReqInfoSortField" value="<%=objParams.getParamValue("CommReqInfoSortField")%>"><!--�䱸���� ��������ʵ� -->
		<input type="hidden" name="CommReqInfoSortMtd" value="<%=objParams.getParamValue("CommReqInfoSortMtd")%>"><!--�䱸���� ������ɹ��-->
		<input type="hidden" name="CommReqInfoPage" value="<%=objParams.getParamValue("CommReqInfoPage")%>"><!--�䱸���� ������ ��ȣ -->
		<input type="hidden" name="CommReqInfoQryField" value="<%=objParams.getParamValue("CommReqInfoQryField")%>"><!--�䱸 ��ȸ�ʵ� -->
		<input type="hidden" name="CommReqInfoQryTerm" value="<%=objParams.getParamValue("CommReqInfoQryMtd")%>"><!--�䱸 ��ȸ�� -->										
		<input type="hidden" name="CommReqID" value="<%=objEditParams.getParamValue("ReqInfoID")%>"><!--�䱸���� ID-->
	</form>
</body>
</html>

