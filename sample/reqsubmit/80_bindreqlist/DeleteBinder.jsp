<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Vector"%>
<%@ page import="java.util.Hashtable"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.EnvConstants"%>
<%@ page import="nads.lib.reqsubmit.PageConstants"%>
<%@ page import="java.io.UnsupportedEncodingException"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.UserInfoDelegate"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.CDInfoDelegate"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
 UserInfoDelegate objUserInfo =null;
 CDInfoDelegate objCdinfo =null;
%>
<%@ include file="../common/RUserCodeInfoInc.jsp" %>
<%!
public String toKSC5601(String str) throws UnsupportedEncodingException
{		

	 if(str == null){
	 	return null;
	 }
	return(new String(str.getBytes("8859_1"),"KSC5601"));
	
}
%>
<html>
<head>
<%
//	String strUserID = (String)session.getAttribute(CodeConstants.SESSION_USERID);
//	strUserID = "tester1";
	
 //이용자 정보 설정.
	String strReqId = null;
	ArrayList objTotalBinderList = null;
	Hashtable objBinderHash = null;	
	int intAnsIdSize = 0;
	String[] strReqIdArray = new String[300];
	
	String strBinderSortField = null;
	String strBinderSortMtd = null;
	String strCurrentPageNum = null;
	int	intCurrentPageNum = 0;
	
	// sort 필드
	strBinderSortField = request.getParameter("binderSortField");
	//System.out.println("[del] strBinderSortField = " + strBinderSortField);
	// sort 종류
 	strBinderSortMtd= request.getParameter("binderSortMtd");
	//System.out.println("[del] strBinderSortMtd = " + strBinderSortMtd);
	// 정보 페이지 번호 받기.
	strCurrentPageNum = request.getParameter("binderPageNum");
	Integer objIntD = new Integer(strCurrentPageNum);
	intCurrentPageNum = objIntD.intValue();
	//System.out.println("[del] intCurrentPageNum = " + intCurrentPageNum);
		

	objTotalBinderList = (ArrayList)session.getAttribute(EnvConstants.BINDER);	
	intAnsIdSize = objTotalBinderList.size();
	//System.out.println("intAnsIdSize =" + intAnsIdSize);
	
	strReqIdArray = request.getParameterValues("Del");
	
	if (strReqIdArray != null)
	{
		int intlength = strReqIdArray.length ;
		String strDeleteFileIndex = null;		
		String strBinderList = null;
		
		for(int i=0; i<intlength ; i++) {
			strDeleteFileIndex = strReqIdArray[i];
			//System.out.println(" 삭제할 대상  =" + strDeleteFileIndex );
												
			for(int j =0 ; j < intAnsIdSize ; j++){
				strBinderList = (String)objTotalBinderList.get(j);
				//System.out.println("검색할 값 =" + strBinderList);
				if(strBinderList.compareTo(strDeleteFileIndex)== 0){
					//System.out.println(" <br> 선택된 값이 세션에 있는 답변 id = " + strBinderList + "<br>");
					objTotalBinderList.remove(j);
					break;
				}
		 	}
		}
	}
	 
	intAnsIdSize = objTotalBinderList.size();
	//System.out.println("[삭제함] 남아있는  intAnsIdSize =" + intAnsIdSize);
	 
	for(int i = 0 ; i < intAnsIdSize ; i++){	 	
		String strBinderList2 = (String)objTotalBinderList.get(i); 
	 	 //System.out.println("strBinderList2 =" + strBinderList2);
	}
	
    session.setAttribute(EnvConstants.BINDER,objTotalBinderList);
	String strHttpSend =  "/reqsubmit/80_bindreqlist/BindList.jsp?binderSortField=" + strBinderSortField + "&binderSortMtd=" + strBinderSortMtd + "&binderPageNum=" + strCurrentPageNum;
    response.sendRedirect(strHttpSend);
%>
</head>
<body  bgcolor="#FFFFFF" > 
</body>
</html>

