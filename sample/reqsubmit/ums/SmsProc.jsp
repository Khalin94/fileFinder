<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>

<%

	String strCmd =StringUtil.getNVLNULL(request.getParameter("cmd"));										//����
	
	//���� �������� ������ ��.
	String strSendPhoneNo   = StringUtil.getNVLNULL(request.getParameter("sendphoneno"));   //���۹�ȣ
	String strReturnNo           = StringUtil.getNVLNULL(request.getParameter("returnno")); 		    //ȸ�Ź�ȣ
	String strSendStatus        = StringUtil.getNVLNULL(request.getParameter("sendstatus")); 		//���ۻ���
	String strSmsMsg 	       = StringUtil.getNVLNULL(request.getParameter("smsmsg"));	    	//�޽���
	String strSystemGbn       = StringUtil.getNVLNULL(request.getParameter("systemgbn"));		//�ý��۱���
	String strServiceGbn       = StringUtil.getNVLNULL(request.getParameter("servicegbn")); 		//���񽺱���
	String strDeptGbn            = StringUtil.getNVLNULL(request.getParameter("deptgbn")); 			//�μ�ID
	String strDeptNm             = StringUtil.getNVLNULL(request.getParameter("deptgnm")); 			//�μ���
	String strUserID               = StringUtil.getNVLNULL(request.getParameter("userid")); 			    //�����ID
	String strUserNm              = StringUtil.getNVLNULL(request.getParameter("usernm")); 			    //�����Nm
//	String strOffiDocID           = StringUtil.getNVLNULL(request.getParameter("offidocid")); 			//����ID
//	String strInOutGbn           = StringUtil.getNVLNULL(request.getParameter("inoutgbn")); 			//���ܱ���
	
	out.print("strSendPhoneNo : " + strSendPhoneNo + "<br>");
	out.print("strReturnNo : " + strReturnNo + "<br>");
	out.print("strSendStatus : " + strSendStatus + "<br>");
	out.print("strSmsMsg : " + strSmsMsg + "<br>");
	out.print("strSystemGbn : " + strSystemGbn + "<br>");
	out.print("strServiceGbn : " + strServiceGbn + "<br>");
	out.print("strDeptGbn : " + strDeptGbn + "<br>");
	out.print("strUserID : " + strUserID + "<br>");
//	out.print("strOffiDocID : " + strOffiDocID + "<br>");
//	out.print("strInOutGbn : " + strInOutGbn + "<br>");
	
	
	//��Delegate �����. 	 
    nads.dsdm.app.reqsubmit.delegate.common.UmsDelegate objUmsInfo = new  nads.dsdm.app.reqsubmit.delegate.common.UmsDelegate();
    
	//�Է��� ����Ÿ�� HashTable ����
	Hashtable objHashData = new Hashtable();
	int intResult = 0;
    
	if(strCmd.equals("create")){
		out.println("����<br>");
		
		objHashData.put("SEND_PHONE_NO", strSendPhoneNo);
		objHashData.put("RETURN_NO", strReturnNo);
		objHashData.put("SEND_STATUS", strSendStatus);
		objHashData.put("MSG", strSmsMsg);
		objHashData.put("SYSTEM_GBN", strSystemGbn);
		objHashData.put("SERVICE_GBN", strServiceGbn);
		objHashData.put("DEPT_GBN", strDeptGbn);
		objHashData.put("DEPT_NM", strDeptNm);
		objHashData.put("USER_ID", strUserID);
		objHashData.put("USER_NM", strUserNm);
//		objHashData.put("OFFI_DOC_ID", strOffiDocID);
//		objHashData.put("IN_OUT_GBN", strInOutGbn);
		
		
		try {
			intResult = objUmsInfo.insertSMS(objHashData);	
		} catch (AppException objAppEx) {
		
			// ���� �߻� �޼��� �������� �̵��Ѵ�.
			out.println(objAppEx.getStrErrCode() + "<br>");
			out.println("�޼��� �������� �̵��Ͽ��� �Ѵ�.<br>");
			return;
		}
		
		out.print("intResult : " + intResult + "�� SEQ <br>");
		
		if(intResult != 0 ){
			out.println("���� ����<br>");
//			response.sendRedirect("SmsTest.jsp");
		}
	}
	
%>

<input type="button" value="�������۸��" style="cursor:hand" OnClick="javascript:history.go(-1);">