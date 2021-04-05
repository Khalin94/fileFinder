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

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	 UserInfoDelegate objUserInfo =null;
	 CDInfoDelegate objCdinfo =null;

 	 String strAnsDocFilePath = null;
	 String	strReqBoxID = null;
	 String strHttpPathInfo = null;
	 int intResult = -1;
	 boolean blnCheckFirstAccept = false;

 	 CommAnsDocDelegate objAnsDoc = null;

	 strReqBoxID = request.getParameter("ReqBoxId");
	 //System.out.println(" [AnsDocView.jsp] strReqBoxId = " + strReqBoxID);
	 long lasttime=session.getLastAccessedTime();

	 long createdtime=session.getCreationTime();

	 long time_used=(lasttime-createdtime)/60000;
	 System.out.println("sessiontimeout : "+time_used+"분");
	 System.out.println("sessionip : "+request.getHeader("Proxy-Client-IP"));

	UserInfoDelegate objUser = new UserInfoDelegate(request);
	String strUserID = objUser.getUserID();
	 //System.out.println(" [AnsDocView.jsp] strUserID =" + strUserID);


	 //답변서 Delegate 선언※.
	 Hashtable objHashtable = null;

	 objAnsDoc = new CommAnsDocDelegate();
/** DB조회후 답변서 파일이 존재하는지 파악후 존재한다면 DB에 들어있는 답변서 파일패스 리턴*/
	 String strAnsDocPath = objAnsDoc.strCheckAnsDocFile(strReqBoxID);

	//System.out.println(" [AnsDocView.jsp] DB조회한 ANSDOC PATH = "+ strAnsDocPath );

	 if(strAnsDocPath == null || strAnsDocPath.equals("") ){ //답변서가 없다  답변서 생성 ?
		System.out.println("답변서가 존재하지 않는다.");
		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
	  	objMsgBean.setStrCode("DSDATA-0032"); //답변서가 존재하지 않는다.
	  	objMsgBean.setStrMsg("답변서가 존재 하지 않습니다.");
%>
	  	<!--jsp:forward page="/common/message/ViewMsg.jsp"/-->
        <script>alert("답변서가 존재하지 않습니다.");self.close();</script>
<%
		/*
		String strReqDocNo = "0000000009"; //답변서번호를 임의로 준다.
		strAnsDocFilePath  = objAnsDoc.CreateAnsDoc(strReqBoxID,strReqDocNo);
		strHttpPathInfo = objAnsDoc.getHttpFileInfo(strAnsDocFilePath);
		System.out.println(" [AnsDocView.jsp] strHttpPathInfo =" + strHttpPathInfo);
		//String	strAnsDocIdData =	objAnsDoc.getAnsDocId(); //요구서 id
		blnCheckFirstAccept  = objAnsDoc.getAnsDocFirstAccepPersonId(strReqBoxID);


	 	if(blnCheckFirstAccept){
			intResult = objAnsDoc.UpdateFirstAcceptPerson(strUserID,strReqBoxID);
			  if(intResult > 0){
				 	System.out.println(" [AnsDocView.jsp]  최초 조회자를 업데이트 했다.");
			  }else{
			 	System.out.println(" [AnsDocView.jsp]  최초 조회자를 업데이트 하지 못하였다.");
			  }
		}*/
        return;
	 }else{

		//strHttpPathInfo = objAnsDoc.getHttpFileInfo(strAnsDocPath);
		strHttpPathInfo = "/reqsubmit/common/PDFView.jsp?PDF=" + strAnsDocPath;
		//System.out.println(" [AnsDocView.jsp] strHttpPathInfo =" + strHttpPathInfo);

	 	blnCheckFirstAccept = objAnsDoc.getAnsDocFirstAccepPersonId(strReqBoxID);

	 	/* 최초 조회자를 업데이트한다 */
	 	if(blnCheckFirstAccept){
			 intResult = objAnsDoc.UpdateFirstAcceptPerson(strUserID,strReqBoxID);

			 if(intResult > 0){
			 	System.out.println(" [AnsDocView.jsp]  최초 조회자를 업데이트 했다.");
			 }else{
			 	System.out.println("  [AnsDocView.jsp] 최초 조회자를 업데이트 하지 못하였다.");
			 }
		}
%>
		<html>
		<head>
		<title>답변서 보기</title>
		</head>
		<body leftmargin="0" topmargin="0" > <!--onLoad="javascript:open()">-->
			<iframe name="view" width=100% height=100% src="<%=strHttpPathInfo%>"  frameborder=0>
			</iframe>
		<body>
		</html>
<%
	 }
%>
