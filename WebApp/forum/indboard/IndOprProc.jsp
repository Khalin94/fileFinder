<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="nads.lib.message.MessageBean" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	/*개별포럼 페이지 파라미터 (포럼ID, 회원상태, 공개여부, 포럼명)*/
	String strForumID = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("fid"))); 			//포럼ID
	String strUserStt = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("uStt"))); 			//회원상태
	
	
	/*GET 파라미터*/
	String strCurrentPage =  nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("strCurrentPage"))); //현재 페이지
	String strBbrdID =  nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("bbrdid")));			 //게시판 아이디
	String strAncTgt = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("anctgt")));			 //공지대상
	
	String strCmd = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("cmd")));					 //구분
	String strDataID = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("dataid")));			 //게시물 아이디
	String strOneID=  nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("oneid")));				 //한줄답글 아이디
	String strDelRsn = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("delrsn")));			 //삭제사유

	/*초기값 설정 */ 
	nads.dsdm.app.board.SLBoardDelegate objIndBoard = new nads.dsdm.app.board.SLBoardDelegate();
	int intResult = 0;

	if(strCmd.equals("OPR_DELETE")){
		
		//out.println("운영자 게시물 삭제");
		
		Hashtable objHshDataInfo = new Hashtable();
		objHshDataInfo.put("DEL_FLAG", "Y");					//운영자 삭제는 "Y"
		objHshDataInfo.put("DEL_RSN", strDelRsn);
		objHshDataInfo.put("DATA_ID", strDataID);
		
		try {
		
			//게시물 삭제 메소드를 호출한다.
			intResult = objIndBoard.updateOprDelFlag(objHshDataInfo);
			
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
			
			//등록이 성공하면 창을 닫고 상세 페이지를 Reload한다.
			out.println("<script language=javascript>");
            out.println("<!--");
            out.println("opener.location.href='/forum/indboard/IndBoardContent.jsp?fid="+strForumID+"&uStt="+strUserStt+"&anctgt="+strAncTgt+"&strCurrentPage="+strCurrentPage+"&bbrdid="+strBbrdID+"&dataid="+strDataID+"';");
            out.println("self.close();");
            out.println("//-->"); 
            out.println("</script>");
			
		} else {
			
			objMsgBean.setMsgType(MessageBean.TYPE_ERR);
			objMsgBean.setStrCode("DSDATA-0010");
		
			// 에러 발생 메세지 페이지로 이동한다.
%>
			<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
			return;
			
		}

	} 
	else if(strCmd.equals("ONE_OPR_DELETE")) {
		
		//out.println("운영자 한줄답글 삭제");
		
		Hashtable objHshOneAns = new Hashtable();
		objHshOneAns.put("DEL_FLAG", "Y");					//운영자 삭제는 "Y"
		objHshOneAns.put("DEL_RSN", strDelRsn);
		objHshOneAns.put("ONE_ANS_ID", strOneID);

		try {
		
			//게시물 삭제 메소드를 호출한다.
			intResult = objIndBoard.updateOprOneDelFlag(objHshOneAns);
			
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
		
			//등록이 성공하면 창을 닫고 상세 페이지를 Reload한다.
			out.println("<script language=javascript>");
            out.println("<!--");
            out.println("opener.location.href='/forum/indboard/IndBoardContent.jsp?fid="+strForumID+"&uStt="+strUserStt+"&anctgt="+strAncTgt+"&strCurrentPage="+strCurrentPage+"&bbrdid="+strBbrdID+"&dataid="+strDataID+"';");
            out.println("self.close();");
            out.println("//-->"); 
            out.println("</script>");
            
		} else {
		
			objMsgBean.setMsgType(MessageBean.TYPE_ERR);
			objMsgBean.setStrCode("DSDATA-0010");
		
			// 에러 발생 메세지 페이지로 이동한다.
%>
			<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
			return;
		
		}
		
	}

%>