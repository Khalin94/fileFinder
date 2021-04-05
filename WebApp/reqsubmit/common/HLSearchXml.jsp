<%@ page language="java" contentType="text/xml;charset=EUC-KR" %>

<%@ page import="unidocs.pdf.jhighlight.*" %>
<%@ page import="nads.lib.reqsubmit.EnvConstants" %>
<%@ page import="unidocs.pdf.jhighlight.ResponseHLOutput" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%> 

<% 
	try {
		//java.util.Date objDate = new java.util.Date();
		//String strNow = objDate.toGMTString(); 
		//String strXML = StringUtil.getEmptyIfNull(request.getParameter("XML_PATH"));
		String strPDF = EnvConstants.UNIX_SAVE_PATH+request.getParameter("PDF_PATH");
		int intSP = strPDF.lastIndexOf('/'); 
		int intPDFDP = strPDF.lastIndexOf('.');
		//String strIDX = EnvConstants.UNIX_TEMP_SAVE_PATH+strPDF.substring(intSP+1, intPDFDP+1)+"idx";
		String strIDX = strPDF.substring(0, intPDFDP+1)+"idx";
		String strKeyword = request.getParameter("KEYWORD");

		if (!StringUtil.isAssigned(strPDF) || !StringUtil.isAssigned(strKeyword)) {
			throw new AppException("[HLSearchXml.jsp] PDF 파일 경로 및 검색어는 반드시 필요합니다. 체크해주세요");
		}
		
		//strXML = EnvConstants.UNIX_TEMP_SAVE_PATH+strXML;
		HighlightExtractor objHLExt = new HighlightExtractor();
		//System.out.println("[HLSearchXml.jsp] 현재시간 : "+strNow);
		//System.out.println("[HLSearchXml.jsp] Keyword : "+strKeyword);
		response.reset();
		//response.setHeader("Last-Modified", strNow);
		response.setHeader("Content-Type", "text/xml;charset=euc-kr");
		ResponseHLOutput objHLOut = new ResponseHLOutput(response);
		//FileHLOutput objHLOut = new FileHLOutput(strXML);
		objHLExt.startHighlight(strIDX, strKeyword, 0, objHLOut);
	} catch(Exception e) { 
		System.out.println("[HLSearchXml.jsp] ERROR : " + e.getMessage());
		e.printStackTrace();
	}
%>