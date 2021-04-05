<%@ page language="java" contentType="text/html; charset=EUC-KR" %>

<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.CommAnsInfoDelegate" %>
<%@ page import="nads.lib.reqsubmit.params.requestinfo.SCommReqInfoVListForm" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<% 
	UserInfoDelegate objUserInfo = null;
	CDInfoDelegate objCdinfo = null;
%>

<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %> 

<%
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
	
	String[] ansIDs = request.getParameterValues("AnsID");
	String strReqBoxID = request.getParameter("ReqBoxID");
	String strReqID = request.getParameter("CommReqID");
	String returnURL = request.getParameter("returnURL");
	 
	if (ansIDs.length < 1) throw new AppException("[SCommAnsInfoDelete.jsp] 답변ID(AnsID)가 하나도 입력되지 않았습니다.");
	CommAnsInfoDelegate objAnsInfo = new CommAnsInfoDelegate();
	
	try {
		int result = objAnsInfo.deleteRecord(ansIDs, CodeConstants.REQ_BOX_STT_006);
		if (result < 0) {
			objMsgBean.setMsgType(MessageBean.TYPE_WARN);
		  	objMsgBean.setStrCode("DSDATA-0012");
  		%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
  		<%  	
  		return;   	
		}
	} catch(Exception e) {
		throw new AppException(e.getMessage());
	}
	// 넘어온 파라미터를 설정해서 필요할 떄 쓰도록 하자
	// 요구함 관련
	
%>
<html>
<head>
<script language="JavaScript">
	function init(){
		alert("선택하신 답변 삭제에 성공하였습니다.");
		formName.action="./SCommReqInfoVList.jsp";
		formName.submit();
	}
</script>
</head>
<body onLoad="init()">

	<form name="formName" method="post" action="" style="margin:0px">
	<!-- 요구함 등록 정보 관련 -->
	<input type="hidden" name="ReqBoxID" value="<%= strReqBoxID %>">
	<input type="hidden" name="CommReqID" value="<%= strReqID %>">
	<input type="hidden" name="CommReqBoxSortField" value="<%= objParams.getParamValue("CommReqBoxSortField") %>"><!--요구함목록정렬필드 -->
	<input type="hidden" name="CommReqBoxSortMtd" value="<%= objParams.getParamValue("CommReqBoxSortMtd") %>"><!--요구함목록정렬방법-->
	<input type="hidden" name="CommReqBoxPage" value="<%= objParams.getParamValue("CommReqBoxPage") %>"><!--요구함 페이지 번호 -->
	<% if(StringUtil.isAssigned(objParams.getParamValue("CommReqBoxQryTerm"))) { %>
	<input type="hidden" name="ReqBoxQryField" value="<%= objParams.getParamValue("CommReqBoxQryField") %>"><!--요구함 조회필드 -->
	<input type="hidden" name="ReqBoxQryTerm" value="<%= objParams.getParamValue("CommReqBoxQryTerm") %>"><!--요구함 조회필드 -->
	<% } //요구함 조회어가 있는 경우만 출력해서 사용함 %>
	
	<!-- 요구 목록 관련 -->
	<input type="hidden" name="CommReqInfoSortField" value="<%= objParams.getParamValue("CommReqInfoSortField") %>"><!--요구정보 목록정렬필드 -->
	<input type="hidden" name="CommReqInfoSortMtd" value="<%= objParams.getParamValue("CommReqInfoSortMtd") %>"><!--요구정보 목록정렬방법-->
	<% if(StringUtil.isAssigned(objParams.getParamValue("CommReqInfoQryTerm"))) { %>
	<input type="hidden" name="CommReqInfoQryField" value="<%= objParams.getParamValue("CommReqInfoQryField") %>"><!--요구정보 조회필드 -->
	<input type="hidden" name="CommReqInfoQryTerm" value="<%= objParams.getParamValue("CommReqInfoQryTerm") %>"><!-- 요구정보 조회어 -->
	<% } %>
	<input type="hidden" name="CommReqInfoPage" value="<%= objParams.getParamValue("CommReqInfoPage") %>"><!-- 요구정보 페이지 번호 -->
	<!-- 삭제 후 반환될 URL을 선택하기 위한 Parameter 설정 -->
	</form>

</body>
</html>
