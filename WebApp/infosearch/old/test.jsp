<!--
**      Program Name :ISearch_News.jsp
**      Program Date : 2004. 05.19.
**      Last    Date : 2004. 05.19.
**      Programmer   : Kim Kang Soo
**      Description  :상세검색중 뉴스검색

**      1)뉴스사이트 리스트를 끌어오는 부분에서 DB커넥션을 사용함
**      2)가장 부하가 많이 걸릴것으로 예상됨 1일 2-3000건 정도 쌓임
**      3)요약문을 보여줌과 동시에 검색어와 매칭된다면 하일라이팅 지원

-->
<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import=" java.util.*"%>
<%@ page import="com.verity.search.*" %>
<%@ page import="nads.dsdm.app.infosearch.common.IsSelectDelegate" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>


<%@ include file="utils.jsp" %> 
<%@ page import="nads.lib.message.MessageBean"%>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%@ page errorPage = "bad.jsp" %>
<html>
<head>
<title>의정자료 전자유통 시스템</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link href="../css/System.css" rel="stylesheet" type="text/css">


<%

	IsSelectDelegate objCMD = new IsSelectDelegate();
out.println("objC");
System.out.println("objCMD : "+objCMD);
	ArrayList objArrselectNews;		

	try {

		objArrselectNews = objCMD.selectNews("70");
System.out.println("objArrselectNews : "+objArrselectNews);
		out.println(objArrselectNews.size());
System.out.println("dfdfdf"); 
	} 
	catch (AppException objAppEx) {
	
		// 에러 발생 메세지 페이지로 이동한다.
	 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
	  	objMsgBean.setStrCode(objAppEx.getStrErrCode());
	  	objMsgBean.setStrMsg(objAppEx.getMessage());
		System.out.println(objAppEx.getStrErrCode());
	}
%>
