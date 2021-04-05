<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="nads.lib.message.MessageBean" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%@ include file="/board/common/GetBoardProperty.jsp" %>
<%
	/*세션값 */
	String strLoginID = (String)session.getAttribute("USER_ID");										//로그인 ID
	
	/*개별포럼 페이지 파라미터 (포럼ID, 회원상태, 공개여부, 포럼명)*/
	String strForumID = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("fid"))); 				 //포럼 아이디
	String strUserStt = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("uStt")));		 		 //회원상태
	String strOpenFlag = ""; 	//공개여부
	String strForumNM = ""; 	//포럼명
	
	/*GET 파라미터*/
	String strCmd = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("cmd")));					 //구분
	String strBbrdID =  nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("bbrdid")));			 //게시판 아이디(수정, 삭제)
	String strBbrdNm =  nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("bbrdnm")));			 //게시판 이름
	String strBbrdKind =  nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("bbrdkind")));		 //게시판 종류
	String strBbrdFileCnt =  nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("filecnt")));	 //게시판 첨부파일 갯수
	String strBbrdAnsExt =  nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("ansext")));		 //게시판 답글유무
	String strBbrdOneExt =  nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("oneext")));		 //게시판 한줄답글 유무
	String strBbrdDsc =  nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("dsc")));			 //게시판 설명
	String strDataCnt =  nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("datacnt")));		 //게시판 속한 게시물 갯수

	/*초기값 설정 */
	nads.dsdm.app.forum.SLMngBoardDelegate objMngBoard = new nads.dsdm.app.forum.SLMngBoardDelegate();
	int intResult = 0;
	
	if(strCmd.equals("CREATE")){
		
		//out.println ("생성<br>");
		
		//1. BbrdInfo 객체를 생성한다.
		Hashtable objHshBbrdInfo = new Hashtable();
		
		objHshBbrdInfo.put("FORUM_ID", strForumID);
		objHshBbrdInfo.put("BBRD_NM", strBbrdNm);
		objHshBbrdInfo.put("BBRD_KIND", strBbrdKind);
		objHshBbrdInfo.put("ANS_EXT", strBbrdAnsExt);
		objHshBbrdInfo.put("APD_FILE_CNT", strBbrdFileCnt);
		objHshBbrdInfo.put("ONE_ANS_EXT", strBbrdOneExt);
		objHshBbrdInfo.put("BBRD_COLOR", "");								//개별포럼에서 사용하지 않는 값 
		objHshBbrdInfo.put("IMG_ID", "");											//개별포럼에서 사용하지 않는 값 
		objHshBbrdInfo.put("DSC", strBbrdDsc);
		objHshBbrdInfo.put("REGR_ID", strLoginID);
		objHshBbrdInfo.put("AUTH_NEED_FLAG", "N");						//디폴트 값 - N
		objHshBbrdInfo.put("ORD", new Integer(0));						//디폴트 값 - 0
		objHshBbrdInfo.put("DEL_FLAG", "N");
		objHshBbrdInfo.put("REMARK", "OPERATOR");

		try {
			//2. 생성 메소드 호출한다.

			intResult = objMngBoard.insertBbrdInfo(objHshBbrdInfo);

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

		if(intResult != 0 ){
		
			//등록을 성공하면 게시판 목록 페이지로 이동한다.
			response.sendRedirect("ManageBoardList.jsp?fid=" + strForumID + "&uStt=" + strUserStt);
		
		} else {
		
			objMsgBean.setMsgType(MessageBean.TYPE_ERR);
			objMsgBean.setStrCode("DSDATA-0010");
			
			// 에러 발생 메세지 페이지로 이동한다.
%>
			<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
			return;
			
		}

	} else if (strCmd.equals("UPDATE")){
		
		//out.println ("수정<br>");
		
		//1. BbrdInfo 객체를 생성한다.
		Hashtable objHshBbrdInfo = new Hashtable();
		
		objHshBbrdInfo.put("BBRD_ID", strBbrdID);
		objHshBbrdInfo.put("BBRD_NM", strBbrdNm);
		objHshBbrdInfo.put("BBRD_KIND", strBbrdKind);
		objHshBbrdInfo.put("ANS_EXT", strBbrdAnsExt);
		objHshBbrdInfo.put("APD_FILE_CNT", strBbrdFileCnt);
		objHshBbrdInfo.put("ONE_ANS_EXT", strBbrdOneExt);
		objHshBbrdInfo.put("DSC", strBbrdDsc);
		objHshBbrdInfo.put("UPDR_ID", strLoginID);
		
		try {
			//2. 수정 메소드 호출한다.
			intResult = objMngBoard.updateBbrdInfo(objHshBbrdInfo);
		
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

		if(intResult != 0 ){
		
			//수정을 성공하면 게시판 목록 페이지로 이동한다.
			response.sendRedirect("ManageBoardList.jsp?fid=" + strForumID + "&uStt=" + strUserStt);
		
		} else {
		
			objMsgBean.setMsgType(MessageBean.TYPE_ERR);
			objMsgBean.setStrCode("DSDATA-0011");
			
			// 에러 발생 메세지 페이지로 이동한다.
%>
			<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
			return;
		
		}
		
	} else if (strCmd.equals("DELETE")){
	
		//out.println ("삭제<br>");
		
		//1. BbrdInfo 객체를 생성한다.
		Hashtable objHshBbrdInfo = new Hashtable();
		
		objHshBbrdInfo.put("BBRD_ID", strBbrdID);
		objHshBbrdInfo.put("UPDR_ID", strLoginID);
		objHshBbrdInfo.put("DEL_FLAG", "Y");

		try {
			//2. 삭제 메소드 호출한다.
			intResult = objMngBoard.updateBbrdDelFlag(objHshBbrdInfo);
		
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
		
		if(intResult != 0 ){
			//삭제를 성공하면 게시판 목록 페이지로 이동한다.
			response.sendRedirect("ManageBoardList.jsp?fid=" + strForumID + "&uStt=" + strUserStt);
			
		} else {
		
			objMsgBean.setMsgType(MessageBean.TYPE_ERR);
			objMsgBean.setStrCode("DSDATA-0012");
			
			// 에러 발생 메세지 페이지로 이동한다.
%>
			<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
			return;
		
		}
		
	}
%>