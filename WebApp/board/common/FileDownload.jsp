<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import=" java.util.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="nads.lib.fileupdown.FileDownload" %>
<%@ page import="nads.lib.message.MessageBean" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%@ include file="/board/common/GetBoardProperty.jsp" %>
<%
	String strDataID = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("dataid")));			//게시물 아이디
	String strFileID = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("fileid")));			//파일 아이디
	
	ArrayList objAryFileInfo = null;
	Hashtable objHshDataInfo = null;
	String strFilePath = "";
	
	String[] strFileIDs = new String[1];
	strFileIDs[0] = strFileID;
	int intResult = 0;
	
	nads.dsdm.app.board.SLBoardDelegate objBoard = new nads.dsdm.app.board.SLBoardDelegate();
	
	try{
		//1. 게시물 정보를 가져온다. (파일경로)
		objHshDataInfo = objBoard.selectBbrdDataInfo(strDataID);
		strFilePath = (String)objHshDataInfo.get("FILE_PATH");
		
		if (strFilePath.indexOf("./") != -1){
			objMsgBean.setMsgType(MessageBean.TYPE_WARN);
			objMsgBean.setStrCode("DSDATA-0015");
			objMsgBean.setStrMsg("부정확한 경로입니다.");
			%>
			<jsp:forward page="/common/message/ViewMsgIndex.jsp"/>
			<%
			return;
		}
		
		if (strFilePath.indexOf("../") != -1){
			objMsgBean.setMsgType(MessageBean.TYPE_WARN);
			objMsgBean.setStrCode("DSDATA-0015");
			objMsgBean.setStrMsg("부정확한 경로입니다.");
			%>
			<jsp:forward page="/common/message/ViewMsgIndex.jsp"/>
			<%
			return;
		}
		if (strFilePath.indexOf("..\\") != -1){
			objMsgBean.setMsgType(MessageBean.TYPE_WARN);
			objMsgBean.setStrCode("DSDATA-0015");
			objMsgBean.setStrMsg("부정확한 경로입니다.");
			%>
			<jsp:forward page="/common/message/ViewMsgIndex.jsp"/>
			<%
			return;
		}
		
		//2. 다운로드 요청하나 파일정보를 가져온다.
		objAryFileInfo = objBoard.selectFileInfo(strFileIDs);
		
	} catch (AppException objAppEx) {
	
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		objMsgBean.setStrCode(objAppEx.getStrErrCode());
		objMsgBean.setStrMsg(objAppEx.getMessage());
		
		// 에러 발생 메세지 페이지로 이동한다.
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
		System.out.println("오진일"+strFileName);
		System.out.println("아정말"+strFileFullPath);
			

		try {
			//2. 물리적 파일 다운로드 한다.
			FileDownload.flush(request, response, strFileFullPath, strFileName);
			
			//3. 파일 다운로드 횟수를 + 1 한다.
			intResult = objBoard.updateFileDownCnt(strFileID);
		
		} catch (AppException objAppEx) {
		
			objMsgBean.setMsgType(MessageBean.TYPE_ERR);
			objMsgBean.setStrCode(objAppEx.getStrErrCode());
			objMsgBean.setStrMsg(objAppEx.getMessage());
			
			// 에러 발생 메세지 페이지로 이동한다.
	%>
			<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
			return;
			
		} catch(Exception objEx) {
			
			objMsgBean.setMsgType(MessageBean.TYPE_ERR);
			//objMsgBean.setStrMsg(objEx.getMessage());
			objMsgBean.setStrCode("DSDATA-0015");
			objMsgBean.setStrMsg(objEx.getMessage());
			
			// 에러 발생 메세지 페이지로 이동한다.
	%>
			<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
			return;
			
		}
		
	} // end if
%>