<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>

 
<%
	ResultSetHelper UserRS = null;

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
	String strStatus               = StringUtil.getNVLNULL(request.getParameter("status")); 				//���ۻ���
	String strDeptGbn            = StringUtil.getNVLNULL(request.getParameter("deptgbn")); 			//�μ�����
	String strDeptNm             = StringUtil.getNVLNULL(request.getParameter("deptnm")); 			//�μ���
	String strUserSttCd           = StringUtil.getNVLNULL(request.getParameter("stt_cd"));
    String webURL = ""; //http �ּ�
	
	//strContents = "http://naps.assembly.go.kr/newsletter/SendAllDoc.jsp?reqtitle="+strContents;
	
	//��Delegate �����.
    nads.dsdm.app.reqsubmit.delegate.common.UmsDelegate objUmsInfo = new  nads.dsdm.app.reqsubmit.delegate.common.UmsDelegate();
    UserRS =  new ResultSetHelper((List)objUmsInfo.getSUserInfo(strUserSttCd));

	//�Է��� ����Ÿ�� HashTable ����
	Hashtable objHashData = null;
	
	int intResult = 0;
    
	if(strCmd.equals("create")){
		while(UserRS.next()){
			objHashData = new Hashtable();
			System.out.println("111");
			strRid = (String)UserRS.getObject("USER_ID");
			strRname = (String)UserRS.getObject("USER_NM");
			strMail = (String)UserRS.getObject("EMAIL");

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
			
			try {
				intResult = objUmsInfo.insertSMTP_WEB_REC(objHashData);
			} catch (AppException objAppEx) {
			
				// ���� �߻� �޼��� �������� �̵��Ѵ�.
				out.println(objAppEx.getStrErrCode() + "<br>");
				out.println("�޼��� �������� �̵��Ͽ��� �Ѵ�.<br>");
				return;
			}							
		}
	}
	
%>

<input type="button" value="�������� ����" style="cursor:hand" OnClick="javascript:history.go(-1);">