<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import=" java.util.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="nads.lib.fileupdown.FileDownload" %>
<%@ page import="nads.lib.message.MessageBean" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%@ include file="/board/common/GetBoardProperty.jsp" %>
<%
	String strDataID = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("dataid")));			//�Խù� ���̵�
	String strFileID = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("fileid")));			//���� ���̵�
	
	ArrayList objAryFileInfo = null;
	Hashtable objHshDataInfo = null;
	String strFilePath = "";
	
	String[] strFileIDs = new String[1];
	strFileIDs[0] = strFileID;
	int intResult = 0;
	
	nads.dsdm.app.board.SLBoardDelegate objBoard = new nads.dsdm.app.board.SLBoardDelegate();
	
	try{
		//1. �Խù� ������ �����´�. (���ϰ��)
		objHshDataInfo = objBoard.selectBbrdDataInfo(strDataID);
		strFilePath = (String)objHshDataInfo.get("FILE_PATH");
		
		if (strFilePath.indexOf("./") != -1){
			objMsgBean.setMsgType(MessageBean.TYPE_WARN);
			objMsgBean.setStrCode("DSDATA-0015");
			objMsgBean.setStrMsg("����Ȯ�� ����Դϴ�.");
			%>
			<jsp:forward page="/common/message/ViewMsgIndex.jsp"/>
			<%
			return;
		}
		
		if (strFilePath.indexOf("../") != -1){
			objMsgBean.setMsgType(MessageBean.TYPE_WARN);
			objMsgBean.setStrCode("DSDATA-0015");
			objMsgBean.setStrMsg("����Ȯ�� ����Դϴ�.");
			%>
			<jsp:forward page="/common/message/ViewMsgIndex.jsp"/>
			<%
			return;
		}
		if (strFilePath.indexOf("..\\") != -1){
			objMsgBean.setMsgType(MessageBean.TYPE_WARN);
			objMsgBean.setStrCode("DSDATA-0015");
			objMsgBean.setStrMsg("����Ȯ�� ����Դϴ�.");
			%>
			<jsp:forward page="/common/message/ViewMsgIndex.jsp"/>
			<%
			return;
		}
		
		//2. �ٿ�ε� ��û�ϳ� ���������� �����´�.
		objAryFileInfo = objBoard.selectFileInfo(strFileIDs);
		
	} catch (AppException objAppEx) {
	
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		objMsgBean.setStrCode(objAppEx.getStrErrCode());
		objMsgBean.setStrMsg(objAppEx.getMessage());
		
		// ���� �߻� �޼��� �������� �̵��Ѵ�.
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
		
	}  
	
	String strFileName = null;
	String strRealFile = null;
	String strFileFullPath = null;
	
	if (objAryFileInfo.size() != 0) {
	
		Hashtable objHshFileInfo = (Hashtable)objAryFileInfo.get(0);
		
		
		strFileName = (String)objHshFileInfo.get("FILE_NAME");
		strRealFile = (String)objHshFileInfo.get("REAL_FILE");
		strFileFullPath =  webPath + strFilePath + "/" + strRealFile;
		System.out.println("������"+strFileName);
		System.out.println("������"+strFileFullPath);
			

		try {
			//2. ������ ���� �ٿ�ε� �Ѵ�.
			FileDownload.flush(request, response, strFileFullPath, strFileName);
			
			//3. ���� �ٿ�ε� Ƚ���� + 1 �Ѵ�.
			intResult = objBoard.updateFileDownCnt(strFileID);
		
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
		
	} // end if
%>