<!--
**      Program Name :ISearch_News.jsp
**      Program Date : 2004. 05.19.
**      Last    Date : 2004. 05.19.
**      Programmer   : Kim Kang Soo
**      Description  :�󼼰˻��� �����˻�

**      1)��������Ʈ ����Ʈ�� ������� �κп��� DBĿ�ؼ��� �����
**      2)���� ���ϰ� ���� �ɸ������� ����� 1�� 2-3000�� ���� ����
**      3)��๮�� �����ܰ� ���ÿ� �˻���� ��Ī�ȴٸ� ���϶����� ����

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
<title>�����ڷ� �������� �ý���</title>
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
	
		// ���� �߻� �޼��� �������� �̵��Ѵ�.
	 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
	  	objMsgBean.setStrCode(objAppEx.getStrErrCode());
	  	objMsgBean.setStrMsg(objAppEx.getMessage());
		System.out.println(objAppEx.getStrErrCode());
	}
%>
