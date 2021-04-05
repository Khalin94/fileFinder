<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="nads.lib.message.MessageBean" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	/*세션값 */
	String strLoginID = (String)session.getAttribute("USER_ID");											//로그인 ID
	
	/*GET 파라미터*/
	String strGoToPage = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(URLDecoder.decode(request.getParameter("strGoToPage"), "UTF-8")));//링크페이지
	String strCurrentPage =  nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("strCurrentPage"))); //현재 페이지
	String strCmd = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("cmd")));	//구분
	String strBbrdID =  nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("bbrdid")));
	//게시판 아이디
	String strDataID = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("dataid")));			//게시물 아이디
	String strOneWord = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("oneword")));			//한줄답글 내용
	String strOneID = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("oneid")));				//한줄답글 아이디
	String strOneCnt = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("onecnt")));			//한줄답글 갯수 (답글삭제)
	String strNowExt = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("nowext")));			//한줄답글 유무
	
	if(strBbrdID == null || strBbrdID.equals("") || strBbrdID.equals(" ")){
		
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		objMsgBean.setStrCode("DSPARAM-0000");
		objMsgBean.setStrMsg("게시판 정보를 알수 없습니다.");
		
		// 에러 발생 메세지 페이지로 이동한다.
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
			
	}
	
	if(strDataID == null || strDataID.equals("") || strDataID.equals(" ")){
		
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		objMsgBean.setStrCode("DSPARAM-0000");
		objMsgBean.setStrMsg("게시물 정보를 알수 없습니다.");
		
		// 에러 발생 메세지 페이지로 이동한다.
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
			
	}
	
	/*초기값 설정 */
	nads.dsdm.app.board.SLBoardDelegate objBoard = new nads.dsdm.app.board.SLBoardDelegate();	
	Hashtable objHshOneData = new Hashtable();
	int intResult = 0;
	
	if(strCmd.equals("ONE_CREATE")){
	
		//out.print("한줄답글 생성<br>");
		
		//1. ONE_ANS에 데이타를 INSERT 한다.
		objHshOneData.put("DATA_ID", strDataID);
		objHshOneData.put("WRITER_ID", strLoginID);
		objHshOneData.put("ONE_WORD", strOneWord);
		objHshOneData.put("DEL_FLAG", "N");							//'N' 하드코딩
		objHshOneData.put("REMARK", ""); 
		objHshOneData.put("ONE_ANS_EXT", "Y");					// "Y" 하드코딩
		objHshOneData.put("NOW_EXT", strNowExt);				//한줄답글 유무
		
		try {
		
			intResult = objBoard.insertOneAns(objHshOneData);
		
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

		if(intResult != 0){
		
			//등록이 성공하면 상세정보 페이지로 이동한다.
			response.sendRedirect(strGoToPage + "?strCurrentPage=" + strCurrentPage + "&bbrdid=" + strBbrdID + "&dataid=" + strDataID);
		
		} else {
			
			objMsgBean.setMsgType(MessageBean.TYPE_ERR);
			objMsgBean.setStrCode("DSDATA-0010");
		
			// 에러 발생 메세지 페이지로 이동한다.
%>
			<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
			return;
			
			}
		
	} else if(strCmd.equals("ONE_DELETE")) {
	
		//out.println("한줄답글 삭제<br>");

		//규칙 : 마지막 답글 삭제인 경우 BBRD_DATA 테이블의 ONE_ANS_EXT 값 'N'로 수정 
		objHshOneData.put("DATA_ID", strDataID);
		objHshOneData.put("ONE_ANS_ID", strOneID);
		objHshOneData.put("ONE_ANS_EXT", "N");			//한줄답글 갯수가 1일 경우만 사용되므로 "N"값 설정 
		objHshOneData.put("ONE_CNT", strOneCnt);		//한줄답글 갯수 

		try {
		
			intResult = objBoard.deleteOneAns(objHshOneData);
			
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
		
		if(intResult != 0){
		
			//삭제를 성공하면 상세정보 페이지로 이동한다.
			response.sendRedirect(strGoToPage + "?strCurrentPage=" + strCurrentPage + "&bbrdid=" + strBbrdID + "&dataid=" + strDataID);
		
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
<%!
	public String replaceXss(String str){
		
		if(str.equals("") || str == null){			
			str = "";
		}else{
			str = str.replaceAll("<","&lt;");
			str = str.replaceAll(">","&gt;");
		}		
		
		return str;
	}	
%>