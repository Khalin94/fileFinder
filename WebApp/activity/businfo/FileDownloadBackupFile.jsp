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
	String strFilePath = AdminIo.getDefaultDirTmp() ;   //������ ������ ��ġ
	String strRealFile = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("real_file")));  
	//������ ���ϸ�
	String strFileName = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("file_name")));  
	//���� ���ϸ�
	String strFullPath = strFilePath + "/" + strRealFile;  //������ ������ġ + ���ϸ�
	
	try {
		//2. ������ ���� �ٿ�ε� �Ѵ�.
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