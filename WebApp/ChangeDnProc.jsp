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
			
			out.println("<script language='javascript'>alert('���������� ����Ͽ����ϴ�.');location.href='/ChangeDn.jsp?ChangeDnYn=Y';</script>");


		}else {

			out.println("<script language='javascript'>alert('�����Ͽ����ϴ�.');location.href='/ChangeDn.jsp?ChangeDnYn=N';	</script>");

		}
	
		
	}
	catch(AppException objAppEx)
	{	
		
		if(objAppEx.getStrErrCode().equals("ORA-00001") == true)
		{

				out.println("<script language='javascript'>alert('�̹� ��ϵǾ� �ִ� �������Դϴ�. \\n�ٸ� �������� �����Ͻʽÿ�.');history.back();	</script>");
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


