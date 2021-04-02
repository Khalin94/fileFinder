<%@ page language="java" contentType="text/html; charset=EUC-KR" %>

<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.MemRequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.MemReqDocSendDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<% 
	UserInfoDelegate objUserInfo = null;
	CDInfoDelegate objCdinfo = null;
%>

<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>

<%
	// �䱸�� ���� ID
	String strReqBoxID = StringUtil.getEmptyIfNull(request.getParameter("ReqBoxID"));
	// �䱸�� ����
	String strReqDocType = StringUtil.getEmptyIfNull(request.getParameter("ReqDocType"));
	
	System.out.println("[Request Box ID] "+strReqBoxID);
	System.out.println("[Request Doc Type] "+strReqDocType);
	
	// û���� �ٽ�! �䱸�� ���� ID�� ����. ���� �߻��� �翬����!
	if (!StringUtil.isAssigned(strReqBoxID)) {
		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  		objMsgBean.setStrCode("DSPARAM-0000");
	  	objMsgBean.setStrMsg("�䱸�� ID�� �����ϴ�.");
%>
  		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%	
		return;
	} // end if 
	
	MemRequestBoxDelegate objReqBox = null;
	MemReqDocSendDelegate objRDSDelegate = null;
	ResultSetSingleHelper objRsSH = null;
	ResultSetHelper objRs = null;
	
	try {
		objReqBox = new MemRequestBoxDelegate();
		objRDSDelegate = new MemReqDocSendDelegate();
		objRsSH = new ResultSetSingleHelper(objReqBox.getRecord(strReqBoxID));
		System.out.println("RMakeReqDocSend.jsp out 1");
		String strOrganID = (String)objRsSH.getObject("SUBMT_ORGAN_ID");
		System.out.println("RMakeReqDocSend.jsp out 2");
		Hashtable hash = (Hashtable)objRDSDelegate.getUserListByOrganID(strOrganID);
		System.out.println("RMakeReqDocSend.jsp out 3");
		objRs = new ResultSetHelper(hash);
		System.out.println("RMakeReqDocSend.jsp out 4");
	} catch(AppException objAppEx) { 
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  		objMsgBean.setStrCode(objAppEx.getStrErrCode());
  		objMsgBean.setStrMsg(objAppEx.getMessage());
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
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
	if (f.RcvrID.value == "") {
		alert("����ڸ� ������ �ּ���");
		f.RcvrID.focus();
		return;
	}
	
	if (f.ElcUse.value == "") {
		f.ElcUse.value = "<%= CodeConstants.SND_MTD_DOCS %>";
	}
	
	if (f.SmsUse.value == "") {
		f.SmsUse.value = "<%= CodeConstants.NTC_MTD_EMAIL %>";
	}
	
	if (confirm("�䱸���� �߼��Ͻðڽ��ϱ�?")) {
		f.action = "RMakeReqDocSendProc.jsp";
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
		<td height="30" width="450" align="center">�䱸�� �߼�</td>
	</tr>
	<tr>
		<td height="470" align="center" valign="top">
		<!------------------------------------------------------------------------------------------------------------------>
<FORM method="post" action="" name="reqDocForm" style="margin:0px">
			<input type="hidden" name="ReqBoxID" value="<%= strReqBoxID %>">
			<input type="hidden" name="ReqDocType" value="<%= strReqDocType %>">
			<input type="hidden" name="ReqTp" value="<%= CodeConstants.REQ_ORGAN_PERSON %>">
			<input type="hidden" name="SndrID" value="<%= objUserInfo.getUserID() %>">
			
			<table border="0" cellpadding="0" cellspacing="0">
				<tr class="td_reqsubmit"> 
            		<td height="2" colspan="2"></td>
            	</tr>
				<tr>
					<td width="100" height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6">
					����ȸ </td>
					<td width="310" class="td_lmagin"><%= objRsSH.getObject("CMT_ORGAN_NM") %></td>
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
					<td class="td_lmagin">
						<select name="RcvrID" class="select">
							<option value="">::: ������ �ּ��� :::</option>
							<% while(objRs.next()) { %>
									<option value="<%= objRs.getObject("USER_ID") %>"><%= objRs.getObject("USER_NM") %></option>
							<% } %>
						</select>
					</td>
				</tr>
				<tr class="tbl-line"> 
	            	<td height="1" colspan="2"></td>
    	       	</tr>
    	       	<tr>
					<td class="td_gray1" height="50"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6">
					���ڰ���<BR>&nbsp;�������� </td>
					<td class="td_lmagin">
						<input type="checkbox" name="ElcUse" value="<%= CodeConstants.SND_MTD_ELEC %>"> ���ڰ��翬��<BR>
						* ���� ���� �ý��ۿ��� �⺻������ �ݿ��˴ϴ�.
					</td>
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