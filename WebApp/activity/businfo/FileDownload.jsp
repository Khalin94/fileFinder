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
	String strDutyId = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("duty_id")));			//게시물 아이디
	String strFilePath = AdminIo.getDefaultDir() ;   //파일의 물리적 위치
	String strRealFile = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("real_file")));  
	//물리적 파일명
	String strFileName = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("file_name")));  
	//논리적 파일명
	String strOrganId = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("organ_id")));  
	//기관ID
	String strFullPath = strFilePath + strOrganId + "/" + strRealFile;  //물리적 파일위치 + 파일명

	System.out.println(strFilePath + "@@@@@@@@@@@@@@@@@@");
	System.out.println(strFullPath + "!!!!!!!!!!!!!!!!!");

	
	if (strFullPath.indexOf("../") != -1){
		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
		objMsgBean.setStrCode("DSDATA-0015");
		objMsgBean.setStrMsg("부정확한 경로입니다.");
		%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
		<%
		return;
	}
	
	if (strFileName.indexOf("..\\") != -1){
		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
		objMsgBean.setStrCode("DSDATA-0015");
		objMsgBean.setStrMsg("부정확한 경로입니다.");
		%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
		<%
		return;
	}
	nads.dsdm.app.activity.businfo.BusInfoDelegate objBusInfoDelegate = new nads.dsdm.app.activity.businfo.BusInfoDelegate();

	int iResult;
	try {
		//2. 물리적 파일 다운로드 한다.
		FileDownload.flush(request, response, strFullPath, strFileName);
		
		//3. 파일 다운로드 횟수를 + 1 한다.
		Vector objDutyIdVt = new Vector();
		objDutyIdVt.add(strDutyId);  //업무정보ID
		objDutyIdVt.add(strDutyId);  //업무정보ID
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