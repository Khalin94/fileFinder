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
	 
	if (ansIDs.length < 1) throw new AppException("[SCommAnsInfoDelete.jsp] �亯ID(AnsID)�� �ϳ��� �Էµ��� �ʾҽ��ϴ�.");
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
	// �Ѿ�� �Ķ���͸� �����ؼ� �ʿ��� �� ������ ����
	// �䱸�� ����
	
%>
<html>
<head>
<script language="JavaScript">
	function init(){
		alert("�����Ͻ� �亯 ������ �����Ͽ����ϴ�.");
		formName.action="./SCommReqInfoVList.jsp";
		formName.submit();
	}
</script>
</head>
<body onLoad="init()">

	<form name="formName" method="post" action="" style="margin:0px">
	<!-- �䱸�� ��� ���� ���� -->
	<input type="hidden" name="ReqBoxID" value="<%= strReqBoxID %>">
	<input type="hidden" name="CommReqID" value="<%= strReqID %>">
	<input type="hidden" name="CommReqBoxSortField" value="<%= objParams.getParamValue("CommReqBoxSortField") %>"><!--�䱸�Ը�������ʵ� -->
	<input type="hidden" name="CommReqBoxSortMtd" value="<%= objParams.getParamValue("CommReqBoxSortMtd") %>"><!--�䱸�Ը�����Ĺ��-->
	<input type="hidden" name="CommReqBoxPage" value="<%= objParams.getParamValue("CommReqBoxPage") %>"><!--�䱸�� ������ ��ȣ -->
	<% if(StringUtil.isAssigned(objParams.getParamValue("CommReqBoxQryTerm"))) { %>
	<input type="hidden" name="ReqBoxQryField" value="<%= objParams.getParamValue("CommReqBoxQryField") %>"><!--�䱸�� ��ȸ�ʵ� -->
	<input type="hidden" name="ReqBoxQryTerm" value="<%= objParams.getParamValue("CommReqBoxQryTerm") %>"><!--�䱸�� ��ȸ�ʵ� -->
	<% } //�䱸�� ��ȸ� �ִ� ��츸 ����ؼ� ����� %>
	
	<!-- �䱸 ��� ���� -->
	<input type="hidden" name="CommReqInfoSortField" value="<%= objParams.getParamValue("CommReqInfoSortField") %>"><!--�䱸���� ��������ʵ� -->
	<input type="hidden" name="CommReqInfoSortMtd" value="<%= objParams.getParamValue("CommReqInfoSortMtd") %>"><!--�䱸���� ������Ĺ��-->
	<% if(StringUtil.isAssigned(objParams.getParamValue("CommReqInfoQryTerm"))) { %>
	<input type="hidden" name="CommReqInfoQryField" value="<%= objParams.getParamValue("CommReqInfoQryField") %>"><!--�䱸���� ��ȸ�ʵ� -->
	<input type="hidden" name="CommReqInfoQryTerm" value="<%= objParams.getParamValue("CommReqInfoQryTerm") %>"><!-- �䱸���� ��ȸ�� -->
	<% } %>
	<input type="hidden" name="CommReqInfoPage" value="<%= objParams.getParamValue("CommReqInfoPage") %>"><!-- �䱸���� ������ ��ȣ -->
	<!-- ���� �� ��ȯ�� URL�� �����ϱ� ���� Parameter ���� -->
	</form>

</body>
</html>
