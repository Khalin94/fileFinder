<%@ page language="java" contentType="text/html;charset=EUC-KR" %>

<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.lib.reqsubmit.params.requestinfo.SMemAnsInfoViewForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.SMemAnsInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.MemRequestBoxDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<% 
	UserInfoDelegate objUserInfo = null;
	CDInfoDelegate objCdinfo = null;
%>

<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %> 

<%
	MemRequestBoxDelegate reqDelegate = null;
	SMemAnsInfoDelegate selfDelegate = null;
	
	SMemAnsInfoViewForm objParams = new SMemAnsInfoViewForm();  
	
	boolean blnParamCheck=false;
	blnParamCheck = objParams.validateParams(request);
	if(blnParamCheck==false) {
  		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  		objMsgBean.setStrCode("DSPARAM-0000");
  		objMsgBean.setStrMsg(objParams.getStrErrors());
  		out.println("ParamError:" + objParams.getStrErrors());
	  	return;
  	}//endif
  	
	// �Ѿ�� �Ķ���͸� �����ؼ� �ʿ��� �� ������ ����
	String strReqBoxID = objParams.getParamValue("ReqBoxID");
	String strReqID = objParams.getParamValue("ReqID");
	String strAnsID = objParams.getParamValue("AnsID");
	
	ResultSetSingleHelper objRsSH = null;
	
	// �亯 ������ ���� ����ؾ��ϴ� �׸���� �޶�����.
	String strAnsMtd = null;
	
	try{
		reqDelegate = new MemRequestBoxDelegate();
	   	selfDelegate = new SMemAnsInfoDelegate();
	   
	   	boolean blnHashAuth = reqDelegate.checkReqBoxAuth(strReqBoxID, objUserInfo.getOrganID()).booleanValue();
	   
	   	if(!blnHashAuth) { 
	   		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	  		objMsgBean.setStrCode("DSAUTH-0001");
  	  		objMsgBean.setStrMsg("�ش� �䱸���� �� ������ �����ϴ�.");
  	  		out.println("�ش� �䱸���� �� ������ �����ϴ�.");
		    return;
		} else {
	    	// �亯 �� ��� ������ SELECT �Ѵ�.
	    	objRsSH = new ResultSetSingleHelper(selfDelegate.getRecord(strAnsID));
	    	strAnsMtd = (String)objRsSH.getObject("ANS_MTD");
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
<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>

<script language="javascript">
	function submitDelete() {
		f.action = "SMakeAnsInfoDelete.jsp";
		if (confirm("�ش� �亯�� �����Ͻðڽ��ϱ�?")) f.submit();
	}
</script>

</head>

<body leftmargin="0" topmargin="0">
<table border="0" cellpadding="0" cellspacing="0" width="500">
	<tr class="td-top">
		<td width="500" height="30" align="center">�亯 �� ����</td> 
	</tr>
	<tr>
		<td height="250" align="center">
		<!----------------------------------------------------------------------------------->
<FORM method="post" action="" name="viewForm" style="margin:0px">
		
		<input type="hidden" name="ReqBoxID" value="<%= strReqBoxID %>">
		<input type="hidden" name="ReqID" value="<%= strReqID %>">
		<input type="hidden" name="AnsID" value="<%= strAnsID %>">
		<input type="hidden" name="returnURL" value="<%= request.getParameter("returnURL") %>">

		<table border="0" cellpadding="0" cellspacing="0">
			<tr class="td_reqsubmit"> 
            	<td height="2" colspan="2"></td>
            </tr>
			<tr>
				<td width="100" class="td_gray1" height="25">
					<img src="/image/common/icon_nemo_gray.gif" width="3" height="6">
					��������
				</td>
				<td width="340" class="td_lmagin"><%= CodeConstants.getOpenClass((String)objRsSH.getObject("OPEN_CL")) %></td>
			</tr>
			<tr class="tbl-line"> 
            	<td height="1" colspan="2"></td>
           	</tr>
           	<tr>
				<td class="td_gray1" height="25">
					<img src="/image/common/icon_nemo_gray.gif" width="3" height="6">
					�亯����
				</td>
				<td class="td_lmagin"><%= CodeConstants.getAnswerMethod(strAnsMtd) %></td>
			</tr>
			<tr class="tbl-line"> 
            	<td height="1" colspan="2"></td>
           	</tr>
<%
	if (CodeConstants.ANS_MTD_ELEC.equalsIgnoreCase(strAnsMtd)) { // �亯 ������ ���ڹ������
%>
           	<tr>
				<td class="td_gray1" height="25">
					<img src="/image/common/icon_nemo_gray.gif" width="3" height="6">
					��������
				</td>
				<td class="td_lmagin"><%= objRsSH.getObject("PDF_FILE_PATH") %></td>
			</tr>
			<tr class="tbl-line"> 
            	<td height="1" colspan="2"></td>
           	</tr>
           	<tr>
				<td class="td_gray1" height="25">
					<img src="/image/common/icon_nemo_gray.gif" width="3" height="6">
					��������
				</td>
				<td class="td_lmagin"><%= objRsSH.getObject("ORG_FILE_PATH") %></td>
			</tr>
			<tr class="tbl-line"> 
            	<td height="1" colspan="2"></td>
           	</tr>
<%
	} else if (CodeConstants.ANS_MTD_ETCS.equalsIgnoreCase(strAnsMtd)){
%>
           	<tr>
				<td class="td_gray1" height="25">
					<img src="/image/common/icon_nemo_gray.gif" width="3" height="6">
						��ü����
				</td>
				<td class="td_lmagin"><%= objCdinfo.m_hashNotElecMedium.get((String)objRsSH.getObject("NON_ELC_DOC_MED")) %></td>
			</tr>
			<tr class="tbl-line"> 
            	<td height="1" colspan="2"></td>
           	</tr>
           	<tr>
				<td class="td_gray1" height="25">
					<img src="/image/common/icon_nemo_gray.gif" width="3" height="6">
					�߼� ���
				</td>
				<td class="td_lmagin"><%= StringUtil.getEmptyIfNull((String)objCdinfo.m_hashSendWay.get((String)objRsSH.getObject("NON_ELC_DOC_SUBMT_MTD"))) %></td>
			</tr>
			<tr class="tbl-line"> 
            	<td height="1" colspan="2"></td>
           	</tr>
<% } %>
           	<tr>
				<td class="td_gray1" height="25">
					<img src="/image/common/icon_nemo_gray.gif" width="3" height="6">
					������
				</td>
				<td class="td_lmagin"><%= objRsSH.getObject("USER_NM") %></td>
			</tr>
			<tr class="tbl-line"> 
            	<td height="1" colspan="2"></td>
           	</tr>
           	<tr>
				<td class="td_gray1" height="25">
					<img src="/image/common/icon_nemo_gray.gif" width="3" height="6">
					������
				</td>
				<td class="td_lmagin"><%= StringUtil.getDate((String)objRsSH.getObject("ANS_DT")) %></td>
			</tr>
			<tr class="tbl-line"> 
            	<td height="1" colspan="2"></td>
           	</tr>
           	<tr>
				<td width="100" class="td_gray1" height="25">
					<img src="/image/common/icon_nemo_gray.gif" width="3" height="6">
					���� �ǰ�
				</td>
				<td width="340" class="td_lmagin"><%= objRsSH.getObject("ANS_OPIN") %></td>
			</tr>
			<tr class="tbl-line"> 
            	<td height="1" colspan="2"></td>
           	</tr>
		</table>
		<p>
		&nbsp;&nbsp;
		<button onClick="javascript:gotoEditForm()" style="width:43px;height:20px"><img src="/image/button/bt_modify.gif" border="0"></button>
		&nbsp;&nbsp;
		<button onClick="javascript:submitDelete()" style="width:43px;height:20px"><img src="/image/button/bt_delete.gif" border="0"></button>
		&nbsp;&nbsp;
		<button onClick="javascript:window.close();" style="width:43px;height:20px"><img src="/image/button/bt_cancel.gif" border="0"></button>

</FORM>
		<!----------------------------------------------------------------------------------->
		</td>
	</tr>
	<tr class="td-top">
		<td height="20" align="right">[close]&nbsp;&nbsp;</td>
	</tr>
</table>
</body>

</html>