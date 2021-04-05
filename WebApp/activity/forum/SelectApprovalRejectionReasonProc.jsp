<%@ page import="java.util.*"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	String strMessage = "";
	String strError = "no";

	String strReason = "";
	try
	{
		String strUserId = (String)session.getAttribute("USER_ID");
	
		nads.dsdm.app.activity.forum.UserForumDelegate objUserForumDelegate = new nads.dsdm.app.activity.forum.UserForumDelegate();
		
		String strGubn   = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(request.getParameter("gubn"));
		String strForumId   = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(request.getParameter("forum_id"));
				
		Vector objForumId = new Vector();
		objForumId.add(strForumId);
		
		Hashtable objReason = new Hashtable();
		//strGubn : 1 ==> 포럼테이블 조회, 2 ===> 포럼회원조회
		if(strGubn.equals("1")){
			objReason = objUserForumDelegate.selectApprovalRejectionReason(objForumId);
		
			String strEstab   = (String)objReason.get("ESTAB_NOT_RSN");
			String strClose   = (String)objReason.get("CLOSE_NOT_RSN");
		
			String strForumStt   = request.getParameter("forum_stt");
			if(strForumStt.equals("002")){
				strReason = strEstab;   //개설거부 사유
			}else if(strForumStt.equals("005")){
				strReason = strClose;	//폐쇄거부 사유
			}//if(strForumStt.equals("002"))		
		}else{
			objForumId.add(strUserId);
			objReason = objUserForumDelegate.selectUserReason(objForumId);
			strReason = (String)objReason.get("USER_NOT_RSN");
		}//if(strGubn.equals("1")){
	}catch(AppException objAppEx)
	{	
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  		objMsgBean.setStrCode(objAppEx.getStrErrCode());
  		objMsgBean.setStrMsg(objAppEx.getMessage());
  		out.println("<br>Error!!!" + objAppEx.getMessage());
%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%  	
		return;
	}
	
%>