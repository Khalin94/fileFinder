<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Hashtable"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.EnvConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.binder.bindDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.UserInfoDelegate"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.CDInfoDelegate"%>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
 UserInfoDelegate objUserInfo =null;
 CDInfoDelegate objCdinfo =null;
%>

<%@ include file="../common/RUserCodeInfoInc.jsp" %>

<%
/********************************************************************************************/	
/*****  바인딩 요구 목록에서 바인딩 버튼 선택시 SYNC JOB 으로 실행되는 PROCCESS         ********/	
/********************************************************************************************/	


 //이용자 정보 설정.
	String strBinderSortField = request.getParameter("binderSortField");
	//System.out.println(" [binderProc] strBinderSortField = " + strBinderSortField);
 	String strBinderSortMtd= request.getParameter("binderSortMtd");
	//System.out.println(" [binderProc] strBinderSortMtd = " + strBinderSortMtd);		

	String strReqId = null;
	String strNewBindedFileName =  null;
	ArrayList objAllBinderArray = null;
	Hashtable objBinderHash = null;
	ResultSetHelper objRs = null;
	String 	strHttpFile = null;
	
	int	intTotalRecordCount = 0;
	int	intCurrentPageNum = 0;
	int	intTotalPage = 0;
	int	intRecordNumber = 0;
	int intIndexNum = 1;
	
	bindDelegate objBindDelegate = new bindDelegate();
	objAllBinderArray = (ArrayList)session.getAttribute(EnvConstants.BINDER);
    if(objAllBinderArray == null || objAllBinderArray.equals("")){ 
       System.out.println("요구 ID 리스트가 세션에 없다." );
    }else{
	   int intCnt = objAllBinderArray.size();
	   //System.out.println("요구 ID 리스트 사이즈  = " + intCnt);
    }
    
    
    objBinderHash = objBindDelegate.getBindListInfo("ANS_ID",strBinderSortMtd,strBinderSortField,objAllBinderArray);
   
    /* 북마크정보인 Xtoc 생성*/
    
    String strCodeCheck = objUserInfo.getOrganGBNCode();
    
	//System.out.println(" [BindProc.jsp] 사용자 권한 = " +  strCodeCheck);
	String strXtocPath = null;
	 
	// 위원회 ( 004 )
	if(strCodeCheck.equals("004")){
		strXtocPath   = objBindDelegate.createXtocToDelegate(objBinderHash,strCodeCheck);  
	}else{
		strXtocPath = objBindDelegate.createXtocToDelegate(objBinderHash); 
	}
	/*
	System.out.println("[BindProc.jsp] strCodeCheck = " + strCodeCheck);
	System.out.println("[BindProc.jsp] Temp 폴더에 생성된 xtoc 파일 패스 정보   strXtocPath =" + strXtocPath);
	*/
    if(strXtocPath.compareTo("Error") == 0){
       //System.out.println("[BindProc.jsp] strXtocPath 가 null 이다");
    }else{
		 //System.out.println("*****[ start binding ]******");
	     strNewBindedFileName =  objBindDelegate.StartBinding(strXtocPath);
	     //System.out.println("[BindProc.jsp] 생성된 Binder 파일의 리턴값 = " + strNewBindedFileName);
	     //System.out.println("*****[ bind End ]***********");	 
	}
	//strHttpFile = objBindDelegate.getHttpFileInfo(strNewBindedFilePath);
	
	String strNewBindedFilePath =  "pdf_temp/Binder/" + strNewBindedFileName;
	strHttpFile = "/reqsubmit/common/PDFView.jsp?PDF=" + strNewBindedFilePath;
	
	//System.out.println("[bindProc] strHttpFile =" + strHttpFile);
	
	
	if( strNewBindedFileName == "Error" || strNewBindedFileName.equals("Error") ){
		System.out.println("바인딩 실패");
		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
	  	objMsgBean.setStrCode("DSDATA-0034");	  	
	  	objMsgBean.setStrMsg("바인딩된 파일 생성 실패.");
%>
	  	<jsp:forward page="/common/message/ViewMsg.jsp"/>	  
<%
	}else{
%>	
<html>
<head>
<title>바인딩</title>
</head>
<body leftmargin="0" topmargin="0"> <!--onLoad="javascript:open()">-->
	<iframe name="view" width=100% height=100% src="<%=strHttpFile%>"  frameborder=0>	
	</iframe>
<body>
</html>
<%
	}
%>	

	