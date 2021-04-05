<%@ page language="java"  contentType="text/html;charset=euc-kr" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>

<%
	String strCurrentPage =  nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("strCurrentPage"))); //현재 페이지
	String strBbrdID = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("bbrdid")));				//게시물 아이디
	String strDataID = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("dataid")));				 //게시물 아이디	
	
	nads.dsdm.app.board.SLBoardDelegate objIndBoard = new nads.dsdm.app.board.SLBoardDelegate();
	int intResult = 0;
	
	try{

		//공지사항 조회수 +1 을 한다.
		intResult = objIndBoard.updateQryCnt(strDataID);

	} catch (AppException objAppEx) {
	
		// 에러 발생 메세지 페이지로 이동한다.
		out.println(objAppEx.getStrErrCode());
		out.println("메세지 페이지로 이동하여야 한다.");
		return;
		
	}
	
	if(intResult != 0){
	
			response.sendRedirect("OprNoticeContent.jsp?strCurrentPage=" + strCurrentPage + "&dataid=" + strDataID + "&bbrdid="+ strBbrdID);
	
	}
%>