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
	 System.out.println("sessiontimeout : "+time_used+"��");
	 System.out.println("sessionip : "+request.getHeader("Proxy-Client-IP"));

	UserInfoDelegate objUser = new UserInfoDelegate(request);
	String strUserID = objUser.getUserID();
	 //System.out.println(" [AnsDocView.jsp] strUserID =" + strUserID);


	 //�亯�� Delegate �����.
	 Hashtable objHashtable = null;

	 objAnsDoc = new CommAnsDocDelegate();
/** DB��ȸ�� �亯�� ������ �����ϴ��� �ľ��� �����Ѵٸ� DB�� ����ִ� �亯�� �����н� ����*/
	 String strAnsDocPath = objAnsDoc.strCheckAnsDocFile(strReqBoxID);

	//System.out.println(" [AnsDocView.jsp] DB��ȸ�� ANSDOC PATH = "+ strAnsDocPath );

	 if(strAnsDocPath == null || strAnsDocPath.equals("") ){ //�亯���� ����  �亯�� ���� ?
		System.out.println("�亯���� �������� �ʴ´�.");
		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
	  	objMsgBean.setStrCode("DSDATA-0032"); //�亯���� �������� �ʴ´�.
	  	objMsgBean.setStrMsg("�亯���� ���� ���� �ʽ��ϴ�.");
%>
	  	<!--jsp:forward page="/common/message/ViewMsg.jsp"/-->
        <script>alert("�亯���� �������� �ʽ��ϴ�.");self.close();</script>
<%
		/*
		String strReqDocNo = "0000000009"; //�亯����ȣ�� ���Ƿ� �ش�.
		strAnsDocFilePath  = objAnsDoc.CreateAnsDoc(strReqBoxID,strReqDocNo);
		strHttpPathInfo = objAnsDoc.getHttpFileInfo(strAnsDocFilePath);
		System.out.println(" [AnsDocView.jsp] strHttpPathInfo =" + strHttpPathInfo);
		//String	strAnsDocIdData =	objAnsDoc.getAnsDocId(); //�䱸�� id
		blnCheckFirstAccept  = objAnsDoc.getAnsDocFirstAccepPersonId(strReqBoxID);


	 	if(blnCheckFirstAccept){
			intResult = objAnsDoc.UpdateFirstAcceptPerson(strUserID,strReqBoxID);
			  if(intResult > 0){
				 	System.out.println(" [AnsDocView.jsp]  ���� ��ȸ�ڸ� ������Ʈ �ߴ�.");
			  }else{
			 	System.out.println(" [AnsDocView.jsp]  ���� ��ȸ�ڸ� ������Ʈ ���� ���Ͽ���.");
			  }
		}*/
        return;
	 }else{

		//strHttpPathInfo = objAnsDoc.getHttpFileInfo(strAnsDocPath);
		strHttpPathInfo = "/reqsubmit/common/PDFView.jsp?PDF=" + strAnsDocPath;
		//System.out.println(" [AnsDocView.jsp] strHttpPathInfo =" + strHttpPathInfo);

	 	blnCheckFirstAccept = objAnsDoc.getAnsDocFirstAccepPersonId(strReqBoxID);

	 	/* ���� ��ȸ�ڸ� ������Ʈ�Ѵ� */
	 	if(blnCheckFirstAccept){
			 intResult = objAnsDoc.UpdateFirstAcceptPerson(strUserID,strReqBoxID);

			 if(intResult > 0){
			 	System.out.println(" [AnsDocView.jsp]  ���� ��ȸ�ڸ� ������Ʈ �ߴ�.");
			 }else{
			 	System.out.println("  [AnsDocView.jsp] ���� ��ȸ�ڸ� ������Ʈ ���� ���Ͽ���.");
			 }
		}
%>
		<html>
		<head>
		<title>�亯�� ����</title>
		</head>
		<body leftmargin="0" topmargin="0" > <!--onLoad="javascript:open()">-->
			<iframe name="view" width=100% height=100% src="<%=strHttpPathInfo%>"  frameborder=0>
			</iframe>
		<body>
		</html>
<%
	 }
%>
