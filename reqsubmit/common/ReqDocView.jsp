<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Hashtable"%>
<%@ page import="java.util.Vector"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.bf.config.*"%>
<%@ page import="kr.co.kcc.pf.util.PageCount"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.EnvConstants"%>
<%@ page import="java.io.UnsupportedEncodingException"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RMemReqBoxVListForm" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.commReqDoc.CommReqDocDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.UserInfoDelegate"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.CDInfoDelegate"%>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
 UserInfoDelegate objUserInfo =null;
 CDInfoDelegate objCdinfo =null;
%>

<%
	boolean blnCheckPerson = false;
	String strReqDocFilePath = null;
	String strReqBoxId = request.getParameter("ReqBoxId");
	//System.out.println("strReqBoxId = " + strReqBoxId);
	String strReqTp = request.getParameter("ReqTp");
	//System.out.println("strReqTp = " + strReqTp);
	String strHttpPathInfo = null;
	int intResult = -1;

	UserInfoDelegate objUser = new UserInfoDelegate(request);
	String strUserID = objUser.getUserID();

	CommReqDocDelegate objReqDoc = new CommReqDocDelegate();
/** DB��ȸ�� �䱸�� ������ �����ϴ��� �ľ��� �����Ѵٸ� DB�� ����ִ� �䱸�� �����н� ����*/
	String strReqDocPath = objReqDoc.strCheckReqDocFile(strReqBoxId);
	//System.out.println(" [RecDocView.jsp] DB��ȸ�� REQDOC PATH = "+ strReqDocPath );

	if(strReqDocPath == null || strReqDocPath.equals("")){ //�䱸���� ����

		System.out.println("�䱸���� �������� ���� ");

		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
	  	objMsgBean.setStrCode("DSDATA-0031"); //�䱸���� �������� �ʴ´�.
	  	objMsgBean.setStrMsg("�䱸���� �������� �ʽ��ϴ�.");
	  	//out.println("ParamError:" + objParams.getStrErrors());
%>
	  	<!--jsp:forward page="/common/message/ViewMsg.jsp"/-->
        <script>alert("�䱸���� �������� �ʽ��ϴ�.");self.close();</script>
<%

		//	�䱸�� ������
		/*
		String strReqDocNo = "0000000009"; // �䱸�� ���Ƿ� ������
		strReqDocFilePath  = objReqDoc.CreateReqDoc(strReqBoxId,strReqTp,strReqDocNo);
		System.out.println(" [ReqDocView] strReqDocFilePath =" + strReqDocFilePath);
		strHttpPathInfo = objReqDoc.getHttpFileInfo(strReqDocFilePath);
		System.out.println(" [ReqDocView] strHttpPathInfo =" + strHttpPathInfo);
		blnCheckPerson = objReqDoc.getRecDocFirstAccepPersonId(strReqBoxId);
	 	System.out.println("[ReqDocView] blnCheckPerson =" + blnCheckPerson);
	 	if(blnCheckPerson){
			 intResult = objReqDoc.UpdateFirstAcceptPerson(strUserID,strReqBoxId);
			 if(intResult > 0){
			 	System.out.println("[ReqDocView] ���� ��ȸ�ڸ� ������Ʈ �ߴ�.");
			 }else{
			 	System.out.println("[ReqDocView] ���� ��ȸ�ڸ� ������Ʈ ���� ���Ͽ���.");
			 }
		}
		*/

	}else{

		System.out.println("�䱸���� ������ ");

		//strHttpPathInfo = objReqDoc.getHttpFileInfo(strReqDocPath);
		strHttpPathInfo = "/reqsubmit/common/PDFView.jsp?PDF=" + strReqDocPath;
		//System.out.println("[ReqDocView] strHttpPathInfo =" + strHttpPathInfo);

	 	// ���� ��ȸ�ڸ� ��ȸ�Ѵ�.
		blnCheckPerson = objReqDoc.getRecDocFirstAccepPersonId(strReqBoxId);

	 	// ���� ��ȸ�ڸ� ������Ʈ�Ѵ�
	 	if(blnCheckPerson){
			 intResult = objReqDoc.UpdateFirstAcceptPerson(strUserID,strReqBoxId);
			 if(intResult > 0){
			 	System.out.println("[ReqDocView] ���� ��ȸ�ڸ� ������Ʈ �ߴ�.");
			 }else{
			 	System.out.println(" [ReqDocView] ���� ��ȸ�ڸ� ������Ʈ ���� ���Ͽ���.");
			 }
		}
%>
	<html>
	<head>
	<title>�䱸�� ����</title>
	</head>
	<body leftmargin="0" topmargin="0" > <!--onLoad="javascript:open()">-->
		<iframe name="view" width=100% height=100% src="<%=strHttpPathInfo%>"  frameborder=0>
		</iframe>
	</body>
	</html>
<%
	}
%>

