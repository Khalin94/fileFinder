<%@ page language="java" contentType="text/html;charset=EUC-KR" %>

<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.lib.reqsubmit.params.requestbox.SMemReqBoxVListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.SMemReqBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.MemRequestBoxDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	UserInfoDelegate objUserInfo =null;
	CDInfoDelegate objCdinfo =null;
%>

<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>

<%
	SMemReqBoxDelegate selfDelegate = null;
	MemRequestBoxDelegate reqDelegate = null;
	
	SMemReqBoxVListForm objParams = new SMemReqBoxVListForm();  
	//SReqInfoListForm objParams = new SReqInfoListForm();  
	
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
	// �䱸�� ����
	String strReqBoxID = objParams.getParamValue("ReqBoxID");
	String strReqBoxSortField = objParams.getParamValue("ReqBoxSortField");
	String strReqBoxSortMtd = objParams.getParamValue("ReqBoxSortMtd");
	String strReqBoxPagNum = objParams.getParamValue("ReqBoxPage");
	String strReqBoxQryField = objParams.getParamValue("ReqBoxQryField");
	String strReqBoxQryTerm = objParams.getParamValue("ReqBoxQryTerm");
	
	ResultSetSingleHelper objRsSH = null;
	try{
		selfDelegate = new SMemReqBoxDelegate();
	   	reqDelegate = new MemRequestBoxDelegate();
	   
	   	boolean blnHashAuth = reqDelegate.checkReqBoxAuth(strReqBoxID, objUserInfo.getOrganID()).booleanValue();
	   
	   	if(!blnHashAuth) { 
	   		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	  		objMsgBean.setStrCode("DSAUTH-0001");
  	  		objMsgBean.setStrMsg("�ش� �䱸���� �� ������ �����ϴ�.");
  	  		out.println("�ش� �䱸���� �� ������ �����ϴ�.");
		    return;
		} else {
	    	// �䱸�� ��� ������ SELECT �Ѵ�.
	    	objRsSH = new ResultSetSingleHelper(selfDelegate.getRecord(strReqBoxID));
		}
	} catch(AppException e) {
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  		objMsgBean.setStrCode(e.getStrErrCode());
  		objMsgBean.setStrMsg(e.getMessage());
  		out.println("<br>Error!!!" + e.getMessage());
	  	return;
 	}
%>

<Html>
<head>
<title></title>
<link href="/css/System.css" rel="stylesheet" type="text/css">

<script language="javascript">
function submitCheck() {
	var f = document.reqDocForm;
	if (f.SmsUse.value == "") {
		f.SmsUse.value = "<%= CodeConstants.NTC_MTD_EMAIL %>";
	}
	
	if (confirm("�亯���� �߼��Ͻðڽ��ϱ�?")) {
		f.action = "SMakeAnsDocSendProc.jsp";
		f.submit();
	}
}

function cancelCheck() {
	self.close();
}
</script>

</head>

<body leftmargin="0" topmargin="0">
<table border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="30" width="450" align="center">�亯�� �߼�</td>
	</tr>
	<tr>
		<td height="470" align="center" valign="top">
		<!------------------------------------------------------------------------------------------------------------------>
<FORM method="post" action="" name="reqDocForm" style="margin:0px">
			<input type="hidden" name="ReqBoxID" value="<%= strReqBoxID %>">
			<input type="hidden" name="ReqTp" value="<%= CodeConstants.REQ_ORGAN_PERSON %>">
			<input type="hidden" name="SndrID" value="<%= objUserInfo.getUserID() %>">
			<input type="hidden" name="RcvrID" value="<%= objRsSH.getObject("REGR_ID") %>">
			<input type="hidden" name="ElcUse" value="<%= CodeConstants.SND_MTD_ELEC %>">
			
			<table border="0" cellpadding="0" cellspacing="0">
				<tr class="td_reqsubmit"> 
            		<td height="2" colspan="2"></td>
            	</tr>
				<tr>
					<td width="100" height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6">
					�䱸�Ը� </td>
					<td width="310" class="td_lmagin"><%= objRsSH.getObject("REQ_BOX_NM") %></td>
				</tr>
				<tr class="tbl-line"> 
	            	<td height="1" colspan="2"></td>
    	       	</tr>
    	       	<tr>
					<td class="td_gray1" height="25"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6">
					�䱸��� </td>
					<td class="td_lmagin"><%= objRsSH.getObject("REQ_ORGAN_NM") %></td>
				</tr>
				<tr class="tbl-line"> 
	            	<td height="1" colspan="2"></td>
    	       	</tr>
    	       	<tr>
					<td class="td_gray1" height="25"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6">
					������ </td>
					<td class="td_lmagin"><%= objRsSH.getObject("SUBMT_ORGAN_NM") %></td>
				</tr>
				<tr class="tbl-line"> 
	            	<td height="1" colspan="2"></td>
    	       	</tr>
    	       	<tr>
					<td class="td_gray1" height="25"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6">
					����� </td>
					<td class="td_lmagin"><%= objRsSH.getObject("USER_NM") %></td>
				</tr>
				<tr class="tbl-line"> 
	            	<td height="1" colspan="2"></td>
    	       	</tr>
    	       	<tr>
					<td class="td_gray1" height="50"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6">
					���� ����<BR>&nbsp;����</td>
					<td class="td_lmagin">
						<input type="checkbox" name="SmsUse" value="<%= CodeConstants.NTC_MTD_BOTH %>"> �������� ���<BR>
						* e-mail ������ �⺻������ ����˴ϴ�.
					</td>
				</tr>
				<tr class="tbl-line"> 
	            	<td height="2" colspan="2"></td>
    	       	</tr>
			</table>
			<p>
			<img src="/image/button/bt_ok.gif" border="0" onClick="javascript:submitCheck()" style="cursor:hand">&nbsp;&nbsp;
			<img src="/image/button/bt_cancel.gif" border="0" onClick="javascript:cancelCheck()" style="cursor:hand">
</FORM>
		<!------------------------------------------------------------------------------------------------------------------>
		</td>
	</tr>
</table>
</body>
</Html>