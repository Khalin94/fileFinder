<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>


<%
	ResultSetHelper UserRS = null;
	String strCmd =StringUtil.getNVLNULL(request.getParameter("cmd"));										//����
	
	//���� �������� ������ ��.
	String strSendPhoneNo   = "";   //���۹�ȣ
	String strReturnNo           = StringUtil.getNVLNULL(request.getParameter("returnno")); 		    //ȸ�Ź�ȣ
	String strSendStatus        = StringUtil.getNVLNULL(request.getParameter("sendstatus")); 		//���ۻ���
	String strSmsMsg 	       = StringUtil.getNVLNULL(request.getParameter("smsmsg"));	    	//�޽���
	String strSystemGbn       = StringUtil.getNVLNULL(request.getParameter("systemgbn"));		//�ý��۱���
	String strServiceGbn       = StringUtil.getNVLNULL(request.getParameter("servicegbn")); 		//���񽺱���
	String strUserID               = StringUtil.getNVLNULL(request.getParameter("userid")); 			    //�����ID
	String strUserNm              = StringUtil.getNVLNULL(request.getParameter("usernm")); 			    //�����Nm
	String strUserSttCd           = StringUtil.getNVLNULL(request.getParameter("stt_cd"));
	
	
	
	//��Delegate �����. 	 
    nads.dsdm.app.reqsubmit.delegate.common.UmsDelegate objUmsInfo = new  nads.dsdm.app.reqsubmit.delegate.common.UmsDelegate();
    UserRS =  new ResultSetHelper(objUmsInfo.getSUserInfo(strUserSttCd));
	//�Է��� ����Ÿ�� HashTable ����
	Hashtable objHashData = null;
	int intResult = 0;
    
	if(strCmd.equals("create")){
		while(UserRS.next()){
			objHashData = new Hashtable();
			strSendPhoneNo = ((String)UserRS.getObject("CPHONE")).replaceAll("-","");
			objHashData.put("SEND_PHONE_NO", strSendPhoneNo);
			objHashData.put("RETURN_NO", strReturnNo);
			objHashData.put("SEND_STATUS", strSendStatus);
			objHashData.put("MSG", strSmsMsg);
			objHashData.put("SYSTEM_GBN", strSystemGbn);
			objHashData.put("SERVICE_GBN", strServiceGbn);
			objHashData.put("DEPT_GBN", "");
			objHashData.put("DEPT_NM", "");
			objHashData.put("USER_ID", strUserID);
			objHashData.put("USER_NM", strUserNm);
			
			
			try {
				intResult = objUmsInfo.insertSMS(objHashData);	
			} catch (AppException objAppEx) {
			
				// ���� �߻� �޼��� �������� �̵��Ѵ�.
				out.println(objAppEx.getStrErrCode() + "<br>");
				out.println("�޼��� �������� �̵��Ͽ��� �Ѵ�.<br>");
				return;
			}
		}		
	}
	
%>

<input type="button" value="�������۸��" style="cursor:hand" OnClick="javascript:history.go(-1);">