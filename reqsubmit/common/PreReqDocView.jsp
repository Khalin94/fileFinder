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
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.MemReqDocSendDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
 UserInfoDelegate objUserInfo =null;
 CDInfoDelegate objCdinfo =null;
%>

<%
	//System.out.println(" ********************************************************88 ");
	boolean blnCheckPerson = false;
	String strReqDocFilePath = null;
	String strReqBoxID = request.getParameter("ReqBoxId");
	//System.out.println("strReqBoxID = " + strReqBoxID);
	String strReqTp = request.getParameter("ReqTp");
	System.out.println("strReqTp = " + strReqTp); // 의원실 001 위원회 010 사무처 011
	

	String strHttpPathInfo = null;
	int intResult = -1;
	
	UserInfoDelegate objUser = new UserInfoDelegate(request);
	String strUserID = objUser.getUserID();
	
	String strCodeCheck = objUser.getOrganGBNCode();
	System.out.println(" 사용자 권한 = " +  strCodeCheck);

	// 위원회 ( 004 )
	if(strCodeCheck.equals("004")) {
		if (CodeConstants.PRE_REQ_DOC_FORM_901.equalsIgnoreCase(strReqTp)) strReqTp = CodeConstants.PRE_REQ_DOC_FORM_901;
		else strReqTp = "110";
	// 의원실 ( 003 )
	} else if(strCodeCheck.equals("003")) {
		strReqTp = "101";
	// 사무처 ( 001 )
	} else if( strCodeCheck.equals("001")) { 
		strReqTp = "111";
	// 예산정책처 
	} else { 
		strReqTp = "111";	
	}
	
	CommReqDocDelegate objReqDoc = new CommReqDocDelegate();

	// 어쩔수없이 무조건 요구서 ID Sequence를 만들어야한다
	MemReqDocSendDelegate objRDSDelegate = new MemReqDocSendDelegate();
	String strReqDocSeq = objRDSDelegate.getSeqNextVal("TBDS_REQ_DOC_INFO");
	System.out.println("[PreReqDocView.jsp] Req Box ID : "+strReqBoxID);
	System.out.println("[PreReqDocView.jsp] Req Tp : "+strReqTp);
    strReqDocFilePath  = objReqDoc.PreCreateReqDoc(strReqBoxID, strReqTp, StringUtil.padl(strReqDocSeq, 10));

		
	if(strReqDocFilePath == null || strReqDocFilePath.equals("")){ //요구서가 없다

		//System.out.println("요구서가 존재하지 않음 ");
		
		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
		objMsgBean.setStrCode("DSDATA-0038"); //요구서가 존재하지 않는다.
		objMsgBean.setStrMsg("요구서 생성 실패");
			//out.println("ParamError:" + objParams.getStrErrors());
%>
			<jsp:forward page="/common/message/ViewMsg.jsp"/>	  	  	
<%
	}else{

		//System.out.println(" [PreReqDocView] strReqDocFilePath =" + strReqDocFilePath);
		strHttpPathInfo = objReqDoc.getHttpFileInfo(strReqDocFilePath);
		//System.out.println(" [PreReqDocView] strHttpPathInfo =" + strHttpPathInfo);
    }
%>
	<html>
	<head>
	<title>요구서 보기</title>
	</head>
	<body leftmargin="0" topmargin="0" > <!--onLoad="javascript:open()">-->

		<iframe name="view" width=100% height=100% src="<%=strHttpPathInfo%>"  frameborder=0>
		</iframe>
		<!--<img src="/image/button/bt_closeWindow.gif" style="cursor:hand" onclick="javascript:self.close()">-->
	</body>
	</html>


