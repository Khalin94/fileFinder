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
		out.println("제출정보가 하나도 선택되지 않았습니다.");	 
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
	 * 요구ID, 답변ID는 필수 항목.
	 *******************************************************************************************
	 */
	
try {

   int intResult =objAnsInfo.setNewCommRecord(ansIDs, strReqID);  
	   
   if(intResult < 0){
 	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	objMsgBean.setStrCode("DSDATA-0010");
  	objMsgBean.setStrMsg("요청하신 요구 정보를 등록하지 못했습니다");
  	out.println("<br>Error!!!" + "요청하신 요구 정보를 등록하지 못했습니다");   
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
	alert("위원회 제출을 완료하였습니다.");
	viewForm.action="./SCommReqInfoVList.jsp";
	viewForm.submit();
	}
 //-->
</script>
</head>
<body onload="init()">
	<form name="viewForm" method="post" action="">
	<!-- 요구함 등록 정보 관련 -->
	<input type="hidden" name="ReqBoxID" value="<%= objParams.getParamValue("ReqBoxID") %>">
	<input type="hidden" name="ReqBoxSortField" value="<%= objParams.getParamValue("ReqBoxSortField") %>"><!--요구함목록정렬필드 -->
	<input type="hidden" name="ReqBoxSortMtd" value="<%= objParams.getParamValue("ReqBoxSortMtd") %>"><!--요구함목록정렬방법-->
	<input type="hidden" name="ReqBoxPage" value="<%= objParams.getParamValue("ReqBoxPagNum") %>"><!--요구함 페이지 번호 -->
	<% if(StringUtil.isAssigned(objParams.getParamValue("ReqBoxQryField"))) { %>
	<input type="hidden" name="ReqBoxQryField" value="<%= objParams.getParamValue("ReqBoxQryField") %>"><!--요구함 조회필드 -->
	<input type="hidden" name="ReqBoxQryTerm" value="<%= objParams.getParamValue("ReqBoxQryTerm") %>"><!--요구함 조회필드 -->
	<% } //요구함 조회어가 있는 경우만 출력해서 사용함 %>
	
	<!-- 요구 목록 관련 -->
	<input type="hidden" name="ReqID" value="<%= strReqID %>"> <!-- 요구 ID -->
	<input type="hidden" name="ReqInfoSortField" value="<%= objParams.getParamValue("ReqInfoSortField") %>"><!--요구정보 목록정렬필드 -->
	<input type="hidden" name="ReqInfoSortMtd" value="<%= objParams.getParamValue("ReqInfoSortMtd") %>"><!--요구정보 목록정렬방법-->
	<% if(StringUtil.isAssigned(objParams.getParamValue("ReqInfoQryTerm"))) { %>
	<input type="hidden" name="ReqInfoQryField" value="<%= objParams.getParamValue("ReqInfoQryField") %>"><!--요구정보 조회필드 -->
	<input type="hidden" name="ReqInfoQryTerm" value="<%= objParams.getParamValue("ReqInfoQryTerm") %>"><!-- 요구정보 조회어 -->
	<% } %>
	<input type="hidden" name="ReqInfoPage" value="<%= objParams.getParamValue("ReqInfoPagNum") %>"><!-- 요구정보 페이지 번호 -->
</body>
</html>
			