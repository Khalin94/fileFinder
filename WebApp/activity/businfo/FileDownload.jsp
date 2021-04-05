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
	String strDutyId = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("duty_id")));			//�Խù� ���̵�
	String strFilePath = AdminIo.getDefaultDir() ;   //������ ������ ��ġ
	String strRealFile = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("real_file")));  
	//������ ���ϸ�
	String strFileName = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("file_name")));  
	//���� ���ϸ�
	String strOrganId = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("organ_id")));  
	//���ID
	String strFullPath = strFilePath + strOrganId + "/" + strRealFile;  //������ ������ġ + ���ϸ�

	System.out.println(strFilePath + "@@@@@@@@@@@@@@@@@@");
	System.out.println(strFullPath + "!!!!!!!!!!!!!!!!!");

	
	if (strFullPath.indexOf("../") != -1){
		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
		objMsgBean.setStrCode("DSDATA-0015");
		objMsgBean.setStrMsg("����Ȯ�� ����Դϴ�.");
		%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
		<%
		return;
	}
	
	if (strFileName.indexOf("..\\") != -1){
		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
		objMsgBean.setStrCode("DSDATA-0015");
		objMsgBean.setStrMsg("����Ȯ�� ����Դϴ�.");
		%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
		<%
		return;
	}
	nads.dsdm.app.activity.businfo.BusInfoDelegate objBusInfoDelegate = new nads.dsdm.app.activity.businfo.BusInfoDelegate();

	int iResult;
	try {
		//2. ������ ���� �ٿ�ε� �Ѵ�.
		FileDownload.flush(request, response, strFullPath, strFileName);
		
		//3. ���� �ٿ�ε� Ƚ���� + 1 �Ѵ�.
		Vector objDutyIdVt = new Vector();
		objDutyIdVt.add(strDutyId);  //��������ID
		objDutyIdVt.add(strDutyId);  //��������ID
		iResult = objBusInfoDelegate.updateDownCnt(objDutyIdVt);
	
	}
	catch(AppException objAppEx)
	{	
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  		objMsgBean.setStrCode(objAppEx.getStrErrCode());
  		objMsgBean.setStrMsg(objAppEx.getMessage());
%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%  	
		return;
	}
	catch(Exception  objException)
	{
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  		objMsgBean.setStrCode("DMPARAM-0020");
  		objMsgBean.setStrMsg(objException.getMessage());
%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%  	
		return	;
	}
%>