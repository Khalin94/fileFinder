<%@ page language="java" contentType="text/html; charset=EUC-KR" %>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.SMemReqBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.answerinfo.AnsInfoDelegate" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	UserInfoDelegate objUserInfo = null;
	CDInfoDelegate objCdinfo = null;
%>

<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>

<%
	String strReturnURL = request.getParameter("ReturnURL");
	String strReqBoxID = request.getParameter("ReqBoxID");
	String strReqID = request.getParameter("ReqID");
	String strReqStt = request.getParameter("ReqStt");

	String strURL[] =StringUtil.split("?",strReturnURL)	;
	if(strURL[0] == null ||strURL[0].equals("")){
		strURL[0] = 	strReturnURL;
	}
	String strReturnURL2 = strURL[0];

	System.out.println("strReqBoxID :"+strReqBoxID);
	System.out.println("strReqID :"+strReqID);
	System.out.println("strReqStt :"+strReqStt);
	System.out.println("strReturnURL :"+strReturnURL);
	System.out.println("objUserInfo.getOrganID() :"+objUserInfo.getOrganID());
	System.out.println("objUserInfo.getUserID() :"+objUserInfo.getUserID());

	if (!StringUtil.isAssigned(strReqID)) {
		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  		objMsgBean.setStrCode("DSPARAM-0000");
	  	objMsgBean.setStrMsg("�䱸 ID�� �����ϴ�.");
%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
	}

	SMemReqBoxDelegate objReqBox = new SMemReqBoxDelegate();
	AnsInfoDelegate objAnsDelegate = new AnsInfoDelegate();
	int intResult = 0;
	String strMsg = "";

	if(objReqBox.getReqCntNotSubmit(strReqBoxID) == 1) {							// ������ ����Ϸ� �̹Ƿ� ����Ϸ� ó�� �� �亯�� �ڵ� �߼� ������ �����Ѵ�.
		intResult = 0;

		if (strReturnURL2.indexOf("10_mem")>0){
            strReturnURL = "/reqsubmit/10_mem/20_reqboxsh/30_makeend/SMakeEndBoxList.jsp";
        } else {
            strReturnURL = "/reqsubmit/20_comm/20_reqboxsh/40_subend/SSubEndBoxList.jsp";
        }
		strMsg = "��� �䱸�� ���� �亯 ������ �Ϸ��Ͽ����Ƿ�, �ڵ� �亯�� �߼� ó���Ͽ����ϴ�.";
		objAnsDelegate.setLastReqSubmtDone(strReqBoxID, strReqID, strReqStt, objUserInfo.getOrganID(), objUserInfo.getUserID());

	} else {

		// ������ ����Ϸᰡ �ƴϱ� ������ �׳� �ش� �䱸�� ����Ϸ� ������Ʈ �ϰ� ������ �Ѵ�.
		intResult = objAnsDelegate.setReqSubmtDone2(strReqID, strReqStt);
		if(strReturnURL2.equals("/reqsubmit/20_comm/30_reqlistsh/20_nonsub/SNonReqInfo.jsp")){
			strReturnURL = "/reqsubmit/20_comm/30_reqlistsh/20_nonsub/SNonReqList.jsp";
		}else if(strReturnURL2.equals("/reqsubmit/10_mem/30_reqlistsh/20_nonsub/SNonReqVList.jsp")){
			 strReturnURL = "/reqsubmit/10_mem/30_reqlistsh/20_nonsub/SNonReqList.jsp";
		}else{
			strReturnURL = strReturnURL;
		}
		strMsg = "�ش� �䱸�� ���� �亯 ������ �Ϸ��Ͽ����ϴ�.";
		if (intResult < 1) {
			objMsgBean.setMsgType(MessageBean.TYPE_WARN);
	  		objMsgBean.setStrCode("");
		  	objMsgBean.setStrMsg("����Ϸ� DB�۾����� ���� �߻�");
%>
		  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
			return;
		}

	}


	out.println("<script language='javascript'>");
	out.println("alert('"+strMsg+"');");
	out.println("</script>");
	out.println("<meta http-equiv='refresh' content='0; url="+strReturnURL+"'>");
%>