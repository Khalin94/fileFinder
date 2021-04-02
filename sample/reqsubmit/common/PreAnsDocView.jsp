<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.bf.config.*"%>
<%@ page import="kr.co.kcc.pf.util.PageCount"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.commAnsDoc.CommAnsDocDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.UserInfoDelegate"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.CDInfoDelegate"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.MemReqDocSendDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.MemAnsDocSendDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
 UserInfoDelegate objUserInfo =null;
 CDInfoDelegate objCdinfo =null;
%>

<%
	//System.out.println(" ********************************************************88 ");
	boolean blnCheckPerson = false;
	String strAnsDocFilePath = null;
	String strReqBoxID = request.getParameter("ReqBoxId");
	//System.out.println("strReqBoxID = " + strReqBoxID);
	String strReqTp = request.getParameter("ReqTp");
	//System.out.println("strReqTp = " + strReqTp);
	String strHttpPathInfo = null;
	int intResult = -1;
	
	UserInfoDelegate objUser = new UserInfoDelegate(request);
	String strUserID = objUser.getUserID();
	
	CommAnsDocDelegate objAnsDoc = new CommAnsDocDelegate();
	
	// 어쩔수없이 무조건 답변서 ID Sequence를 만들어야한다
	MemReqDocSendDelegate objRDSDelegate = new MemReqDocSendDelegate();
	String strAnsDocSeq = objRDSDelegate.getSeqNextVal("TBDS_ANS_DOC_INFO");
	strAnsDocSeq = StringUtil.padl(strAnsDocSeq, 10);
	strAnsDocFilePath = objAnsDoc.PreCreateAnsDoc(strReqBoxID, strAnsDocSeq);

	if(strAnsDocFilePath == null || strAnsDocFilePath.equals("")){ //요구서가 없다

		//System.out.println("답변서가 존재하지 않음 ");
		
		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
		objMsgBean.setStrCode("DSDATA-0039"); //답변서가 존재하지 않는다.
		objMsgBean.setStrMsg("답변서 생성 실패");
			//out.println("ParamError:" + objParams.getStrErrors());
%>
			<jsp:forward page="/common/message/ViewMsg.jsp"/>	  	  	
<%
	}else{
		strHttpPathInfo = objAnsDoc.getHttpFileInfo(strAnsDocFilePath);
    }
%>
	<html>
	<head>
	<title>요구서 보기</title>
	</head>
	<body leftmargin="0" topmargin="0" > <!--onLoad="javascript:open()">-->

		<iframe name="view" width=100% height=100% src="<%=strHttpPathInfo%>"  frameborder=0>
		</iframe>
	</body>
	</html>


