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
/** DB조회후 요구서 파일이 존재하는지 파악후 존재한다면 DB에 들어있는 요구서 파일패스 리턴*/
	String strReqDocPath = objReqDoc.strCheckReqDocFile(strReqBoxId);
	//System.out.println(" [RecDocView.jsp] DB조회한 REQDOC PATH = "+ strReqDocPath );

	if(strReqDocPath == null || strReqDocPath.equals("")){ //요구서가 없다

		System.out.println("요구서가 존재하지 않음 ");

		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
	  	objMsgBean.setStrCode("DSDATA-0031"); //요구서가 존재하지 않는다.
	  	objMsgBean.setStrMsg("요구서가 존재하지 않습니다.");
	  	//out.println("ParamError:" + objParams.getStrErrors());
%>
	  	<!--jsp:forward page="/common/message/ViewMsg.jsp"/-->
        <script>alert("요구서가 존재하지 않습니다.");self.close();</script>
<%

		//	요구서 생성함
		/*
		String strReqDocNo = "0000000009"; // 요구서 임의로 정의함
		strReqDocFilePath  = objReqDoc.CreateReqDoc(strReqBoxId,strReqTp,strReqDocNo);
		System.out.println(" [ReqDocView] strReqDocFilePath =" + strReqDocFilePath);
		strHttpPathInfo = objReqDoc.getHttpFileInfo(strReqDocFilePath);
		System.out.println(" [ReqDocView] strHttpPathInfo =" + strHttpPathInfo);
		blnCheckPerson = objReqDoc.getRecDocFirstAccepPersonId(strReqBoxId);
	 	System.out.println("[ReqDocView] blnCheckPerson =" + blnCheckPerson);
	 	if(blnCheckPerson){
			 intResult = objReqDoc.UpdateFirstAcceptPerson(strUserID,strReqBoxId);
			 if(intResult > 0){
			 	System.out.println("[ReqDocView] 최초 조회자를 업데이트 했다.");
			 }else{
			 	System.out.println("[ReqDocView] 최초 조회자를 업데이트 하지 못하였다.");
			 }
		}
		*/

	}else{

		System.out.println("요구서가 존재함 ");

		//strHttpPathInfo = objReqDoc.getHttpFileInfo(strReqDocPath);
		strHttpPathInfo = "/reqsubmit/common/PDFView.jsp?PDF=" + strReqDocPath;
		//System.out.println("[ReqDocView] strHttpPathInfo =" + strHttpPathInfo);

	 	// 최초 조회자를 조회한다.
		blnCheckPerson = objReqDoc.getRecDocFirstAccepPersonId(strReqBoxId);

	 	// 최초 조회자를 업데이트한다
	 	if(blnCheckPerson){
			 intResult = objReqDoc.UpdateFirstAcceptPerson(strUserID,strReqBoxId);
			 if(intResult > 0){
			 	System.out.println("[ReqDocView] 최초 조회자를 업데이트 했다.");
			 }else{
			 	System.out.println(" [ReqDocView] 최초 조회자를 업데이트 하지 못하였다.");
			 }
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
<%
	}
%>

