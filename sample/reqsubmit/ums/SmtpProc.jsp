<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.common.UmsDelegate"%>

<%

	String strCmd =StringUtil.getNVLNULL(request.getParameter("cmd"));						  //����
	
	//���� �������� ������ ��.
	String strRid    		= StringUtil.getNVLNULL(request.getParameter("rid"));	    	  		  //������ID
	String strRname   = StringUtil.getNVLNULL(request.getParameter("rname")); 			  	  //�����ڸ�
	String strMail        = StringUtil.getNVLNULL(request.getParameter("rmail")); 			  	  //�����ڸ����ּ�
    
	String strSid    	  	  = StringUtil.getNVLNULL(request.getParameter("sid"));	    	 		  //�߽���ID
	String strSname     = StringUtil.getNVLNULL(request.getParameter("sname")); 			  //�߽��ڸ�
	String strSmail       = StringUtil.getNVLNULL(request.getParameter("smail")); 			      //�߽��ڸ����ּ�
	String strSubject    = StringUtil.getNVLNULL(request.getParameter("subject")); 			  //����
	String strContents  = StringUtil.getNVLNULL(request.getParameter("contents")); 		  //����
	String strSystemGbn       = StringUtil.getNVLNULL(request.getParameter("systemgbn"));		//�ý��۱���
	String strServiceGbn       = StringUtil.getNVLNULL(request.getParameter("servicegbn")); 		//���񽺱���
	String strStatus               = StringUtil.getNVLNULL(request.getParameter("status")); 			//���ۻ���
	String strDeptGbn            = StringUtil.getNVLNULL(request.getParameter("deptgbn")); 			//�μ�����
	String strDeptNm             = StringUtil.getNVLNULL(request.getParameter("deptnm")); 			//�μ���
//	String strUserID               = StringUtil.getNVLNULL(request.getParameter("userid")); 			    //�����ID
//	String strOffiDocID           = StringUtil.getNVLNULL(request.getParameter("offidocid")); 			//����ID
//	String strInOutGbn           = StringUtil.getNVLNULL(request.getParameter("inoutgbn")); 			//���ܱ���
   
	out.print("strRid : " + strRid + "<br>");
	out.print("strRname : " + strRname + "<br>");
	out.print("strMail : " + strMail + "<br>");
	
	out.print("strSid : " + strSid + "<br>");
	out.print("strSname : " + strSname + "<br>");
	out.print("strSmail : " + strSmail + "<br>");
	out.print("strSubject : " + strSubject + "<br>");
	out.print("strContents : " + strContents + "<br>");
	out.print("strSystemGbn : " + strSystemGbn + "<br>");
	out.print("strServiceGbn : " + strServiceGbn + "<br>");
	out.print("strStatus : " + strStatus + "<br>");
	out.print("strDeptGbn : " + strDeptGbn + "<br>");
	out.print("strDeptNm : " + strDeptNm + "<br>");
//	out.print("strUserID : " + strUserID + "<br>");
//	out.print("strOffiDocID : " + strOffiDocID + "<br>");
//	out.print("strInOutGbn : " + strInOutGbn + "<br>");
	
	
	//��Delegate �����.
    UmsDelegate objUmsInfo = new  UmsDelegate();
    
	//�Է��� ����Ÿ�� HashTable ����
	Hashtable objHashData = new Hashtable();
	int intResult = 0;
    
	if(strCmd.equals("create")){
		out.println("����<br>");
		
		objHashData.put("RID", strRid);
		objHashData.put("RNAME", strRname);
		objHashData.put("RMAIL", strMail);
		
		objHashData.put("SID", strSid);
		objHashData.put("SNAME", strSname);
		objHashData.put("SMAIL", strSmail);
		objHashData.put("SUBJECT", strSubject);
		objHashData.put("CONTENTS", strContents);
		objHashData.put("SYSTEM_GBN", strSystemGbn);
		objHashData.put("SERVICE_GBN", strServiceGbn);
		objHashData.put("STATUS", strStatus);		
		objHashData.put("DEPT_GBN", strDeptGbn);
		objHashData.put("DEPT_NM", strDeptNm);
//		objHashData.put("USER_ID", strUserID);
//		objHashData.put("OFFI_DOC_ID", strOffiDocID);
//		objHashData.put("IN_OUT_GBN", strInOutGbn);
	    
		try {
			intResult = objUmsInfo.insertSMTP_REC(objHashData);
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
	
	
	
	if(strCmd.equals("create2")){
		out.println("����<br>");
		
		objHashData.put("SID", strSid);
		objHashData.put("SNAME", strSname);
		objHashData.put("SMAIL", strSmail);
		objHashData.put("SUBJECT", strSubject);
		objHashData.put("CONTENTS", strContents);
		
		
		try {
			intResult = objUmsInfo.insertSMTP_MAI(objHashData);
		} catch (AppException objAppEx) {
		
			// ���� �߻� �޼��� �������� �̵��Ѵ�.
			out.println(objAppEx.getStrErrCode() + "<br>");
			out.println("�޼��� �������� �̵��Ͽ��� �Ѵ�.<br>");
			return;
		}
		
		out.print("intResult : " + intResult);
		
		if(intResult != 0 ){
			out.println("���� ����<br>");
//			response.sendRedirect("SmsTest.jsp");
		}
	}
	
	
%>

<input type="button" value="�������۸��" style="cursor:hand" OnClick="javascript:history.go(-1);">