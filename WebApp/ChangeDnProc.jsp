<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="kr.co.kcc.bf.log.Log" %>
<%@ page import="nads.lib.pentasecurity.egsign.*" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="kr.co.kcc.bf.config.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="kr.co.kcc.pf.exception.*" %>
<%@ page import="java.text.*" %>
<%@ page import="nads.dsdm.app.forum.SLDBForumDelegate" %>
<%@ page import="nads.dsdm.app.common.ums.UmsInfoDelegate" %>
<%@ page import="nads.lib.message.MessageBean" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%@ include file="/common/CheckSession.jsp" %>

<%
		nads.dsdm.app.join.JoinMemberDelegate objJoinMemberDelegate = new nads.dsdm.app.join.JoinMemberDelegate();
		String strUserId =(String)session.getAttribute("USER_ID");
		String strDn = request.getParameter("certDn");
		String strStt = "001";


	String strError = "no";	
	try
	{

		
		int intResult = objJoinMemberDelegate.updateDn4Change( strUserId,strDn,strStt);
		
		if(intResult == 1) {
			
			out.println("<script language='javascript'>alert('성공적으로 등록하였습니다.');location.href='/ChangeDn.jsp?ChangeDnYn=Y';</script>");


		}else {

			out.println("<script language='javascript'>alert('실패하였습니다.');location.href='/ChangeDn.jsp?ChangeDnYn=N';	</script>");

		}
	
		
	}
	catch(AppException objAppEx)
	{	
		
		if(objAppEx.getStrErrCode().equals("ORA-00001") == true)
		{

				out.println("<script language='javascript'>alert('이미 등록되어 있는 인증서입니다. \\n다른 인증서를 선택하십시오.');history.back();	</script>");
			System.out.println("==============>"+objAppEx.getStrErrCode());
			return;


		}
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  		objMsgBean.setStrCode(objAppEx.getStrErrCode());
  		objMsgBean.setStrMsg(objAppEx.getMessage());
  		Log.debug.println("Error!!!" + objAppEx.getMessage());
%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%  	
		return;
	}
	
%>


