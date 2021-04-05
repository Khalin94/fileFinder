<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import=" java.util.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="nads.lib.fileupdown.FileDownload" %>
<%@ page import="nads.lib.message.MessageBean" %>
<%@ page import="kr.co.kcc.bf.config.*" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	try {
		Config objConfig = PropertyConfig.getInstance();
		String strFullPath = objConfig.get("messenger.download.file.path");	
			
		FileDownload.flush(request, response, strFullPath, "AssemblyMessenger.exe");
			
	} catch (AppException objAppEx) {
		
			objMsgBean.setMsgType(MessageBean.TYPE_ERR);
			objMsgBean.setStrCode(objAppEx.getStrErrCode());
			objMsgBean.setStrMsg(objAppEx.getMessage());
			
			// ���� �߻� �޼��� �������� �̵��Ѵ�.
%>
	<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
			return;
			
	} catch(Exception objEx) {
			
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		//objMsgBean.setStrMsg(objEx.getMessage());
		objMsgBean.setStrCode("DSDATA-0015");
		objMsgBean.setStrMsg(objEx.getMessage());
			
		// ���� �߻� �޼��� �������� �̵��Ѵ�.
%>
	<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}
%>