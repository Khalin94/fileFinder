<%@ page language="java" contentType="text/html;charset=EUC-KR"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.CommAnsInfoDelegate" %>
<%@ page import="nads.lib.reqsubmit.params.requestinfo.SCommReqInfoVListForm" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	String[] ansIDs = request.getParameterValues("RefAnsID");
	String strReqBoxID = request.getParameter("ReqBoxID");
	String strReqID = request.getParameter("ReqID");
	
	
	if (ansIDs.length < 1) {
		out.println("���������� �ϳ��� ���õ��� �ʾҽ��ϴ�.");	 
	}
	
	CommAnsInfoDelegate objAnsInfo = new CommAnsInfoDelegate();
	SCommReqInfoVListForm objParams = new SCommReqInfoVListForm();  

	boolean blnParamCheck=false;
	blnParamCheck = objParams.validateParams(request);
	if(blnParamCheck==false) {
  		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  		objMsgBean.setStrCode("DSPARAM-0000");
  		objMsgBean.setStrMsg(objParams.getStrErrors());
  		out.println("ParamError:" + objParams.getStrErrors());
	  	return;
  	}//endif
  	
	/*
	 *******************************************************************************************
	 * �䱸ID, �亯ID�� �ʼ� �׸�.
	 *******************************************************************************************
	 */
	
try {

   int intResult =objAnsInfo.setNewCommRecord(ansIDs, strReqID);  
	   
   if(intResult < 0){
 	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	objMsgBean.setStrCode("DSDATA-0010");
  	objMsgBean.setStrMsg("��û�Ͻ� �䱸 ������ ������� ���߽��ϴ�");
  	out.println("<br>Error!!!" + "��û�Ͻ� �䱸 ������ ������� ���߽��ϴ�");   
  	return;   	
   }
	 	
} catch(AppException e) {
	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
	objMsgBean.setStrCode(e.getStrErrCode());
	objMsgBean.setStrMsg(e.getMessage());
	out.println("<br>Error!!!" + e.getMessage());
  	return;
}
	
%>
<html>
<head>
<title></title>
<link href="/css/System.css" rel="stylesheet" type="text/css">
<script language="javascript">
<!--
  function init(){
	alert("����ȸ ������ �Ϸ��Ͽ����ϴ�.");
	viewForm.action="./SCommReqInfoVList.jsp";
	viewForm.submit();
	}
 //-->
</script>
</head>
<body onload="init()">
	<form name="viewForm" method="post" action="">
	<!-- �䱸�� ��� ���� ���� -->
	<input type="hidden" name="ReqBoxID" value="<%= objParams.getParamValue("ReqBoxID") %>">
	<input type="hidden" name="ReqBoxSortField" value="<%= objParams.getParamValue("ReqBoxSortField") %>"><!--�䱸�Ը�������ʵ� -->
	<input type="hidden" name="ReqBoxSortMtd" value="<%= objParams.getParamValue("ReqBoxSortMtd") %>"><!--�䱸�Ը�����Ĺ��-->
	<input type="hidden" name="ReqBoxPage" value="<%= objParams.getParamValue("ReqBoxPagNum") %>"><!--�䱸�� ������ ��ȣ -->
	<% if(StringUtil.isAssigned(objParams.getParamValue("ReqBoxQryField"))) { %>
	<input type="hidden" name="ReqBoxQryField" value="<%= objParams.getParamValue("ReqBoxQryField") %>"><!--�䱸�� ��ȸ�ʵ� -->
	<input type="hidden" name="ReqBoxQryTerm" value="<%= objParams.getParamValue("ReqBoxQryTerm") %>"><!--�䱸�� ��ȸ�ʵ� -->
	<% } //�䱸�� ��ȸ� �ִ� ��츸 ����ؼ� ����� %>
	
	<!-- �䱸 ��� ���� -->
	<input type="hidden" name="ReqID" value="<%= strReqID %>"> <!-- �䱸 ID -->
	<input type="hidden" name="ReqInfoSortField" value="<%= objParams.getParamValue("ReqInfoSortField") %>"><!--�䱸���� ��������ʵ� -->
	<input type="hidden" name="ReqInfoSortMtd" value="<%= objParams.getParamValue("ReqInfoSortMtd") %>"><!--�䱸���� ������Ĺ��-->
	<% if(StringUtil.isAssigned(objParams.getParamValue("ReqInfoQryTerm"))) { %>
	<input type="hidden" name="ReqInfoQryField" value="<%= objParams.getParamValue("ReqInfoQryField") %>"><!--�䱸���� ��ȸ�ʵ� -->
	<input type="hidden" name="ReqInfoQryTerm" value="<%= objParams.getParamValue("ReqInfoQryTerm") %>"><!-- �䱸���� ��ȸ�� -->
	<% } %>
	<input type="hidden" name="ReqInfoPage" value="<%= objParams.getParamValue("ReqInfoPagNum") %>"><!-- �䱸���� ������ ��ȣ -->
</body>
</html>
			