<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>

<%
	//추후 세션으로 변경할 값.
	String strUserID = "tester1"; 																//로그인 ID
	
	//GET 파라미터
	String strCurrentPage =  nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("strCurrentPage"))); //현재 페이지
	String strCmd = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("cmd")));						 //구분
	String strBbrdID =  nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("bbrdid")));				 //게시판 아이디
	String strDataID = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("dataid")));				 //게시물 아이디
	String strOneWord = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("oneword")));				//한줄답글 내용
	String strOneID = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("oneid")));					 //한줄답글 아이디
	String strOneCnt = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("onecnt")));				 //한줄답글 갯수 (답글삭제)
	String strNowExt = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("nowext")));				 //한줄답글 유무

	out.print("strDataID : " + strDataID + "<br>");
	out.println("strOneID " + strOneID + "<br>");
	out.println("strOneWord " + strOneWord + "<br>");
	out.println("strOneCnt " + strOneCnt + "<br>");
	
	//초기값 설정 
	nads.dsdm.app.board.SLBoardDelegate objOprBoard = new nads.dsdm.app.board.SLBoardDelegate();	
	Hashtable objHshOneData = new Hashtable();
	int intResult = 0;
	
	if(strCmd.equals("ONE_CREATE")){
	
		out.print("한줄답글 생성<br>");
		
		//1. ONE_ANS에 데이타를 INSERT 한다.
		objHshOneData.put("DATA_ID", strDataID);
		objHshOneData.put("WRITER_ID", strUserID);
		objHshOneData.put("ONE_WORD", strOneWord);
		objHshOneData.put("DEL_FLAG", "N");							//임시로 'N' 하드코딩 => 코드테이블
		objHshOneData.put("REMARK", ""); 
		objHshOneData.put("ONE_ANS_EXT", "Y");					//임시로 "Y" 하드코딩 => 코드테이블
		objHshOneData.put("NOW_EXT", strNowExt);				//한줄답글 유무
		
		try {
		
			intResult = objOprBoard.insertOneAns(objHshOneData);
			
		} catch (AppException objAppEx) {
	
			// 에러 발생 메세지 페이지로 이동한다.
			out.println(objAppEx.getStrErrCode());
			out.println("메세지 페이지로 이동하여야 한다.");
			return;
			
		}
		
		out.print("intResult : " + intResult +"<br>");
		
		if(intResult != 0){
			out.print("한줄답글 입력 성공<br>");
			response.sendRedirect("OprNoticeContent.jsp?strCurrentPage=" + strCurrentPage + "&bbrdid=" + strBbrdID + "&dataid=" + strDataID);
		}
		
	} else if(strCmd.equals("ONE_DELETE")) {
	
		out.println("한줄답글 삭제<br>");
		
		//한줄답글을 삭제한다.
		//규칙 : 마지막 답글 삭제인 경우 BBRD_DATA 테이블의 ONE_ANS_EXT 값 'N'로 수정 
		objHshOneData.put("DATA_ID", strDataID);
		objHshOneData.put("ONE_ANS_ID", strOneID);
		objHshOneData.put("ONE_ANS_EXT", "N");			//한줄답글 갯수가 1일 경우만 사용되므로 "N"값 설정 
		objHshOneData.put("ONE_CNT", strOneCnt);		//한줄답글 갯수 

		try {
		
			intResult = objOprBoard.deleteOneAns(objHshOneData);
			
		} catch (AppException objAppEx) {
	
			// 에러 발생 메세지 페이지로 이동한다.
			out.println(objAppEx.getStrErrCode());
			out.println("메세지 페이지로 이동하여야 한다.");
			return;
		
		}
		
		if(intResult != 0){
			out.print("한줄답글 삭제 성공<br>");
			response.sendRedirect("OprNoticeContent.jsp?strCurrentPage=" + strCurrentPage + "&bbrdid=" + strBbrdID + "&dataid=" + strDataID);
		}
	}
	
%>
