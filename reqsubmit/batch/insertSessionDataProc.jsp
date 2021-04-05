<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*" %>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="kr.co.kcc.bf.db.*" %> 
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="java.io.*"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.answerinfo.AnsInfoDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<link href="/css/System.css" rel="stylesheet" type="text/css">

<%
	String strPwd = StringUtil.getEmptyIfNull(request.getParameter("pwd"));
	String strSessionNo = StringUtil.getEmptyIfNull(request.getParameter("sessionNo"));
	String strDaeNum = StringUtil.getEmptyIfNull(request.getParameter("DaeNum"));
	String strStartDate = StringUtil.getEmptyIfNull(request.getParameter("startDate"));
	String strEndDate = StringUtil.getEmptyIfNull(request.getParameter("endDate"));
	strStartDate = strStartDate.replaceAll("-","");
	strEndDate = strEndDate.replaceAll("-","");
	java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyyMMdd");
	String strNowDate = sdf.format(new java.util.Date());
	int intResult = -1;
																										 
	if(!"naps337".equalsIgnoreCase(strPwd)) {
		out.println("<script language='javascript'>\n");
		out.println("alert(\"��й�ȣ�� Ʋ�Ƚ��ϴ�. �ٽ� �Է� �ٶ��ϴ�.\");\n");
		out.println("</script>\n");
		out.println("<meta http-equiv='refresh' content='0; url=insertSessionData.jsp'>\n");
		return;
	}
	
	
	try {

		StringBuffer strSQL = new StringBuffer();
		DBAccess objDAO=null;
		Hashtable objReturnHash = new Hashtable();
		int intCount = 0;

		objDAO = new DBAccess(this.getClass());
		
		/**
		 *************************************************************************************
		 * NO : 1
		 * TABLE : tbds_send_info
		 * DESC : �䱸�� �߼� ����
		 *************************************************************************************
		 */
		strSQL.append("insert into TBDM_SESSION (DAE_NUM,SES_NUM,START_DATE,END_DATE,REG_DATE) VALUES ('"+strDaeNum+"','"+strSessionNo+"','"+strStartDate+"','"+strEndDate+"','"+strNowDate+"')");				
		objDAO.setSQL(strSQL.toString(), null);
		intResult = objDAO.doUpdate();


	} catch(Exception e) {
		ByteArrayOutputStream bout = new ByteArrayOutputStream();
		e.printStackTrace(new PrintStream(bout));
		out.println(bout.toString());
		//out.println(e.getMessage());
	}


	if(intResult > 0) {
		out.println("<script language='javascript'>\n");
		out.println("alert(\"ȸ�������� �ԷµǾ����ϴ�.\");\n");
		out.println("</script>\n");
		out.println("<meta http-equiv='refresh' content='0; url=insertSessionData.jsp'>\n");
		return;
	}else{
		out.println("<script language='javascript'>\n");
		out.println("alert(\"ȸ�ⵥ���� �Է� ����.\");\n");
		out.println("</script>\n");
		out.println("<meta http-equiv='refresh' content='0; url=insertSessionData.jsp'>\n");
		return;
	}

%>