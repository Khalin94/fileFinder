<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import=" java.io.*" %>
<%@ page import=" java.util.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="nads.lib.fileupdown.FileDownload" %>
<%@ page import="nads.lib.util.AdminIo" %>
<%@ page import="nads.lib.message.MessageBean"%>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%@ include file="/common/CheckSession.jsp" %>

<%
	String strFilePath = AdminIo.getDefaultDirTmp() ;   //파일의 물리적 위치
	String strRealFile = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("real_file")));  
	//물리적 파일명
	String strFileName = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("file_name")));  
	//논리적 파일명
	String strFullPath = strFilePath + "/" + strRealFile;  //물리적 파일위치 + 파일명
	
	try {
		//2. 물리적 파일 다운로드 한다.
		FileDownload.flush(request, response, strFullPath, strFileName + ".tar");		
	}
	catch(AppException objAppEx)
	{	
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  		objMsgBean.setStrCode(objAppEx.getStrErrCode());
  		objMsgBean.setStrMsg(objAppEx.getMessage());
  		out.println("<br>Error!!!" + objAppEx.getMessage());
%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%  	
		return;
	}
%>