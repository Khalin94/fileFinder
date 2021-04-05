<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="nads.lib.message.MessageBean" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	/*GET 파라미터*/
	String strCurrentPage =  StringUtil.getNVLNULL(request.getParameter("strCurrentPage")); //현재 페이지
	String strGoToPage = StringUtil.getNVLNULL(URLDecoder.decode(request.getParameter("strGoToPage"), "UTF-8"));	//링크될 페이지
	String strBbrdID =  StringUtil.getNVLNULL(request.getParameter("bbrdid"));						//게시판 아이디
	String strDataID =  StringUtil.getNVLNULL(request.getParameter("dataid"));						//게시물 아이디
	String strPwdCmd =  StringUtil.getNVLNULL(request.getParameter("pwdcmd"));					//구분
	String strCfmPwd = StringUtil.getNVLNULL(request.getParameter("cfmpwd"));					//게시물 비밀번호
	
	/*초기값 설정 */ 
	nads.dsdm.app.board.SLBoardDelegate objAuthBoard = new nads.dsdm.app.board.SLBoardDelegate();
	Hashtable objHshDataInfo = null;
	
	try {
		
		//1. 게시물 정보를 가져온다.
		objHshDataInfo = objAuthBoard.selectBbrdDataInfo(strDataID);
	
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
	
	//2. 비밀번호를 확인한다.
	String strDataPwd = (String)objHshDataInfo.get("DATA_PWD");
	
	if(strDataPwd.equals(strCfmPwd)){
		
		//비밀번호가 일치하면 수정 또는 삭제 화면을 보여준다.UpdateAuthBoard
		String strUrl = null;
		
		if(strPwdCmd.equals("CFM_UPDATE")){
		
			out.println("<script language=javascript>");
	        out.println("opener.location.href='"+strGoToPage+"?strCurrentPage="+strCurrentPage+"&bbrdid="+strBbrdID+"&dataid="+strDataID + "';");
	        out.println("self.close();");
	        out.println("</script>");
        
        } else if (strPwdCmd.equals("CFM_DELETE")) {
        	
        	out.println("<script language=javascript>");
			out.println("opener.goToDelete();");
			out.println("self.close();");
	        out.println("</script>");
	        
		}
	
	} else {
	
			//등록이 성공하면 창을 닫고 상세 페이지를 Reload한다.
			out.println("<script language=javascript>");
            out.println("alert('비밀번호가 일치하지 않습니다.')");
            out.println("history.back();");
            out.println("</script>");
	
	}
%>


			