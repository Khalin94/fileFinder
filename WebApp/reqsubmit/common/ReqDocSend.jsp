<%@ page language="java" contentType="text/html;charset=EUC-KR" %>

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
	// �䱸�� ���� (���ڰ��簡 �ʿ�� �ϴ� ����)
	String strReqDocType = StringUtil.getEmptyIfNull(request.getParameter("ReqDocType"));

	String strReqBoxNM = StringUtil.getEmptyIfNull(request.getParameter("ReqBoxNM"));

	// �䱸�� �� ���� (���Ծ��� �䱸�� ���� �ÿ� �ʿ�� �ϴ� ����)
	String strReqTp = null;
	String strReturnURL = null;

	// 2004-06-14
	// �̿����� �Ҽ� ��� ���� �ڵ忡 ���� �䱸�� ��, ���ڰ��� ���� �䱸�� ������ ��������. 
	// ���غ���
	String strOrgGbnCode = (String)objUserInfo.getOrganGBNCode();
	if (CodeConstants.ORGAN_GBN_ASM.equalsIgnoreCase(strOrgGbnCode) || CodeConstants.ORGAN_GBN_BUD.equalsIgnoreCase(strOrgGbnCode)) { // �繫ó or ������åó
		strReqDocType = CodeConstants.REQ_DOC_TYPE_001;
		strReqTp = CodeConstants.REQ_DOC_FORM_011;
		strReturnURL = "/reqsubmit/10_mem/20_reqboxsh/20_sendend/RSendBoxList.jsp";
	} else if (CodeConstants.ORGAN_GBN_MEM.equalsIgnoreCase(strOrgGbnCode)) { // �ǿ��� 
		strReqDocType = CodeConstants.REQ_DOC_TYPE_001;
		strReqTp = CodeConstants.REQ_DOC_FORM_001;
		strReturnURL = "/reqsubmit/10_mem/20_reqboxsh/20_sendend/RSendBoxList.jsp";
	} else if (CodeConstants.ORGAN_GBN_CMT.equalsIgnoreCase(strOrgGbnCode)) { // ����ȸ 
		if (StringUtil.isAssigned(strReqDocType) && CodeConstants.REQ_DOC_TYPE_001.equalsIgnoreCase(strReqDocType)) {
			strReqTp = CodeConstants.REQ_DOC_FORM_900;
			strReturnURL = "/reqsubmit/10_mem/20_reqboxsh/10_make/RMakeReqBoxList.jsp";
		} else {
			strReqDocType = CodeConstants.REQ_DOC_TYPE_002;
			strReqTp = CodeConstants.REQ_DOC_FORM_010;
			strReturnURL = "/reqsubmit/20_comm/20_reqboxsh/20_accend/RAccBoxList.jsp";
		}
	} else {
		strReqDocType = CodeConstants.REQ_DOC_TYPE_001;
		strReqTp = CodeConstants.REQ_DOC_FORM_001;
		strReturnURL = "/reqsubmit/10_mem/20_reqboxsh/10_make/RMakeReqBoxList.jsp";
	}

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
		String strOrganID = (String)objRsSH.getObject("SUBMT_ORGAN_ID");
		Hashtable hash = (Hashtable)objRDSDelegate.getUserListByOrganID(strOrganID);
		objRs = new ResultSetHelper(hash);
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
<jsp:include page="/inc/header.jsp" flush="true"/>
<SCRIPT LANGUAGE=JAVASCRIPT> 
/*
    var oLastBtn=0; 
    bIsMenu = false; 

    //No RIGHT CLICK************************ 
    // **************************** 
    if (window.Event) document.captureEvents(Event.MOUSEUP); 
    function nocontextmenu() { 
        event.cancelBubble = true 
        event.returnValue = false; 
        return false; 
    } 

    function norightclick(e) { 
        if (window.Event) {
            if (e.which !=1) return false; 
        } else { 
            if (event.button !=1) { 
                event.cancelBubble = true 
                event.returnValue = false; 
                return false; 
            } 
        } 
    }

    document.oncontextmenu = nocontextmenu; 
    document.onmousedown = norightclick; 

    // Block backspace onKeyDown************ 
    function onKeyDown() { 
        if ( (event.altKey) || ((event.keyCode == 8) && 
            (event.srcElement.type != "text" && 
            event.srcElement.type != "textarea" && 
            event.srcElement.type != "password")) || 
            ((event.ctrlKey) && ((event.keyCode == 78) || (event.keyCode == 82)) ) || 
            (event.keyCode == 116) ) { 
            event.keyCode = 0; 
            event.returnValue = false; 
        } 
    } 
*/
</SCRIPT> 


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
		f.action = "/reqsubmit/common/ReqDocSendProc.jsp";
		document.all.loadingDIV.style.display = '';
		f.submit();
	}
}

function cancelCheck() {
	self.close();
}
</script>
</head>

<body onKeyDown="javascript:onKeyDown()">
<DIV ID="loadingDIV" style="width:214px;height:160px;display:none;position:absolute;left:120;top:150">
	<img src="/image/reqsubmit/loading.jpg" border="0">
</DIV>
<div class="popup">
    <p>�䱸�� �߼�</p>
<FORM method="post" action="" name="reqDocForm" style="margin:0px">
			<input type="hidden" name="ReqBoxID" value="<%= strReqBoxID %>">
			<input type="hidden" name="ReqDocType" value="<%= strReqDocType %>">
			<input type="hidden" name="ReqTp" value="<%= strReqTp %>">
			<input type="hidden" name="ReturnURL" value="<%= strReturnURL %>">
			<input type="hidden" name="SndrID" value="<%= objUserInfo.getUserID() %>">
			<input type="hidden" name="SubmtOrgID" value="<%= objRsSH.getObject("SUBMT_ORGAN_ID") %>">
			<input type="hidden" name="ReqOrganNm" value="<%= objRsSH.getObject("REQ_ORGAN_NM") %>">

			<%
				if (CodeConstants.ORGAN_GBN_ASM.equalsIgnoreCase(objUserInfo.getOrganGBNCode()) || CodeConstants.ORGAN_GBN_BUD.equalsIgnoreCase(objUserInfo.getOrganGBNCode())) {
					out.println("<input type='hidden' name='ReqOrganID' value='"+objUserInfo.getBasicOrganID()+"'>");
				} else {
					out.println("<input type='hidden' name='ReqOrganID' value='"+objUserInfo.getOrganID()+"'>");
				}
			%>

       <table border="0" cellspacing="0" cellpadding="0"  class="list02">
			<%
				// 2004-07-08 �繫ó, ����ó�� ��쿡�� ����ȸ��°� ��������
				if (CodeConstants.ORGAN_GBN_ASM.equalsIgnoreCase(objUserInfo.getOrganGBNCode()) || CodeConstants.ORGAN_GBN_BUD.equalsIgnoreCase(objUserInfo.getOrganGBNCode())) {
				} else {
			%>
            <tr>
                <th height="25" >&bull;&nbsp;����ȸ </th>
                <td height="25"  colspan="3"><%= objRsSH.getObject("CMT_ORGAN_NM") %></td>
            </tr>
   	       	<% } %>
            <tr>
                <th height="25" >&bull;&nbsp;�䱸���</th>
                <td height="25"  colspan="3"><%= objRsSH.getObject("REQ_ORGAN_NM") %> </td>
            </tr>
            <tr>
                <th height="25">&bull;&nbsp;������ </th>
                <td height="25" colspan="3">
					<select name="RcvrID">
						<option value="">::: ������ �ּ��� :::</option>
						<%
							String temp1 = "";
						%>
						<% while(objRs.next()) { 
								if(objRs.getObject("REP_FLAG") != null && ((String)objRs.getObject("REP_FLAG")).equals("Y")){
									temp1 = "(�����ǥ)";	
								}
						%>
								<option value="<%= objRs.getObject("ORGAN_ID") %>^<%= objRs.getObject("USER_ID") %>"><%=temp1%><%= objRs.getObject("USER_NM") %> (<%= objRs.getObject("DEPT_NM") %> - <%= objRs.getObject("GRD_NM") %>)</option>
						<% 
							temp1 = "";
						} 
						%>
					</select>
				</td>
            </tr>
<% if (1==2 ) { %>
 <!-- �繫ó ����ó �Ҽ� ��� ����, ����ȸ �䱸�� ��� ����  || req_box_id = '0000012019' or req_box_id = '0000012018'-->

            <tr>
                <th height="25" >&bull;&nbsp;���ڹ��� </th>
                <td height="25" colspan="3">
				<input type="checkbox" name="ElcUse" value="<%= CodeConstants.SND_MTD_ELEC %>" class="borderNo"> ���ڹ��� �ý��� ����<BR>
						&nbsp;<img src="/image/common/icon_exclam_mark.gif" border="0"> �䱸�� ���� �亯 ������ �����ڷ� �������� <BR>&nbsp;&nbsp;&nbsp;&nbsp;�ý����� ���ؼ��� ��ȸ�Ͻ� �� �ֽ��ϴ�.
				</td>
            </tr>
<% } else { %>
			<input type="hidden" name="ElcUse" value="">
<% } %>
            <tr>
                <th height="25">&bull;&nbsp;����<br>&nbsp;���� ���� </th>
                <td height="25" colspan="3">
				<input type="checkbox" name="SmsUse" value="<%= CodeConstants.NTC_MTD_BOTH %>" class="borderNo"> �������� ���<BR>
						<!--&nbsp;<img src="/image/common/icon_exclam_mark.gif" border="0"> e-mail ������ �⺻������ ����˴ϴ�.-->
				</td>
            </tr>
        </table>
        
        <!-- /list --> 

    <p style= "height:2px;padding:0;"></p>
    <!-- ����Ʈ ��ư-->
    <div id="btn_all" class="t_right">
		<span class="list_bt"><a href="javascript:submitCheck()">Ȯ��</a></span>&nbsp;&nbsp;
		<span class="list_bt"><a href="javascript:cancelCheck()">���</a></span>&nbsp;&nbsp;
	</div>
    <!-- /����Ʈ ��ư--> 
</div>
</form>
</body>
</html>