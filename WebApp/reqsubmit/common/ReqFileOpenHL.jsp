<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.reqsubmit.EnvConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.answerinfo.AnsInfoDelegate" %>

<%
	String strWebServerAddress = EnvConstants.getWebServerIP();
	
	AnsInfoDelegate objAnsDelegate = null;
	ResultSetSingleHelper objRsSH = null;
	
	String strAnsID = StringUtil.getEmptyIfNull(request.getParameter("ansID"));
	String strFileType = StringUtil.getEmptyIfNull(request.getParameter("DOC"), "PDF");
	String strKeyword = StringUtil.getEmptyIfNull(request.getParameter("keyword"));
	strKeyword = java.net.URLEncoder.encode(strKeyword);
	String strPDF = null;
	
	if (!StringUtil.isAssigned(strAnsID) || !StringUtil.isAssigned(strKeyword)) {
		out.println("답변ID와 검색 Keyword는 필수입력 값입니다. 누락되지 않도록 다시 확인바랍니다.");
	}
	
	try {
		objAnsDelegate = new AnsInfoDelegate();
	   	objRsSH = new ResultSetSingleHelper(objAnsDelegate.getRecord(strAnsID));
	   	
		strPDF = (String)objRsSH.getObject("PDF_FILE_PATH");
		
		String strPdfURL = strWebServerAddress+"/reqsubmit/common/PDFView.jsp?PDF="+strPDF; 
		String strXML = strPDF.substring(strPDF.lastIndexOf('/')+1, strPDF.lastIndexOf('.'))+".xml";
		StringBuffer strBufXmlURL = new StringBuffer();
		strBufXmlURL.append(strWebServerAddress); 
		strBufXmlURL.append("/reqsubmit/common/HLSearchXml.jsp");
		strBufXmlURL.append("?PDF_PATH="+strPDF+"&KEYWORD="+strKeyword);
		//strBufXmlURL.append("&XML_PATH="+strXML);
%>
	<iframe src=<%= strPdfURL %>#xml=<%= strBufXmlURL.toString() %> width="100%" height="100%"></iframe>
<%
		
	} catch(Exception e) {
		out.println("[ReqFileOpen.jsp] Exception : "+e.getMessage());
		System.out.println("[ReqFileOpen.jsp] Exception : "+e.getMessage());
		e.printStackTrace();
	}
%>