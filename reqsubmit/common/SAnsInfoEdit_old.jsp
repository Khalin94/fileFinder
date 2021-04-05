<%@ page language="java" contentType="text/html;charset=EUC-KR" %>

<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="nads.lib.message.MessageBean" %>
<%@ page import="nads.lib.reqsubmit.CodeConstants" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.lib.reqsubmit.params.requestinfo.SMemAnsInfoViewForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.answerinfo.AnsInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.SMemReqInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.MemRequestBoxDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	UserInfoDelegate objUserInfo = null;
	CDInfoDelegate objCdinfo = null;
%>

<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>

<%
	MemRequestBoxDelegate reqDelegate = null;
	SMemReqInfoDelegate ReqInfoDelegate = null;
	AnsInfoDelegate selfDelegate = null;

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

	// 2004-06-04 �̿��� ������ USER DN
	String strUserDN = null;

	try{
		reqDelegate = new MemRequestBoxDelegate();
		ReqInfoDelegate = new SMemReqInfoDelegate();
	   	selfDelegate = new AnsInfoDelegate();

    	objRsSH = new ResultSetSingleHelper(selfDelegate.getRecord(strAnsID));
    	strAnsMtd = (String)objRsSH.getObject("ANS_MTD");

    	// 2004-06-04 �̿����� ������ USER DN ���� �����ͼ� �����Ѵ�.
    	//strUserDN = ReqInfoDelegate.getUserDN(objUserInfo.getUserID());
    	HttpSession objPrivateSession = request.getSession();
		strUserDN = StringUtil.getEmptyIfNull((String)objPrivateSession.getAttribute("UserDN"));

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
	function submitEdit() {
		var f = document.editForm;
		f.action = "/reqsubmit/common/SAnsInfoEditProc_old.jsp";

		if (f.AnsType.value == "001") {
			if ((f.PdfFile.value == "" && f.OriginFile.value != "") || (f.PdfFile.value != "" && f.OriginFile.value == "")) {
				alert("�亯 ������ �����ϽǷ��� �������ϰ� PDF ������ ���ÿ� �����ϼž� �մϴ�.");
				f.PdfFile.focus();
				return;
			}
		}

		if (f.AnsOpin.value == "") {
			f.AnsOpin.value = "���� �ǰ� ����";
		}

		if (getByteLength(f.AnsOpin.value) > 500) {
			alert("�ѱ�, ������ ���� 500�� �̳��� �Է��� �ּ���. ��, �ѱ��� 2�ڷ� ó���˴ϴ�.");
			f.AnsOpin.focus();
			return;
		}

		if (confirm("�����Ͻðڽ��ϱ�?")) {
			showLoadingDiv();
			f.submit();
		}
	}

	function showLoadingDiv() {
		document.all.loadingDiv.style.top = (520 - 214) / 2;
		document.all.loadingDiv.style.left = 350 - 200;
		document.all.loadingDiv.style.display = '';
	}
</script>

</head>

<body leftmargin="0" topmargin="0">
<table border="0" cellpadding="0" cellspacing="0" width="500">
	<tr class="td-top">
		<td width="500" height="30" align="center">
			<table border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td width="500" height="29" bgcolor="#f4f4f4" align="center"><span class="title">�亯 ����</span></td>
				</tr>
				<tr><td height="1" bgcolor="#c0c0c0"></td></tr>
			</table>
		</td>
	</tr>
	<tr>
		<td height="10" bgcolor="#ffffff"></td>
	</tr>
	<tr>
		<td height="250" align="center">
		<!----------------------------------------------------------------------------------->
<%
	String strFormType = null;
	if (CodeConstants.ANS_MTD_ELEC.equalsIgnoreCase(strAnsMtd)) // �亯 ������ ���ڹ������
		strFormType = "multipart/form-data";
	else
		strFormType = "";
%>
<FORM method="post" action="" name="editForm" style="margin:0px" enctype="<%= strFormType %>">

		<input type="hidden" name="ReqBoxID" value="<%= strReqBoxID %>">
		<input type="hidden" name="ReqID" value="<%= strReqID %>">
		<input type="hidden" name="AnsID" value="<%= strAnsID %>">
		<input type="hidden" name="ReturnURL" value="<%= request.getParameter("ReturnURL") %>">
		<input type="hidden" name="RegrID" value="<%= objRsSH.getObject("ANSR_ID") %>">
		<% // ���� ��� : ������ �����̾����� �亯�� ��� ������ �ϱ�� �����Ƿ� ���� ó�� %>
		<input type="hidden" name="OpenCL" value="<%= CodeConstants.OPN_CL_OPEN %>">
		<input type="hidden" name="UserDN" value="<%= strUserDN %>">
		<input type="hidden" name="user_dn" value="<%= strUserDN %>">

		<table border="0" cellpadding="0" cellspacing="0">
			<tr class="td_reqsubmit">
            	<td height="2" colspan="2"></td>
            </tr>
           	<tr>
				<td class="td_gray1" height="25">
					<img src="/image/common/icon_nemo_gray.gif" width="3" height="6">
					�亯����
				</td>
				<td class="td_lmagin"><%= CodeConstants.getAnswerMethod(strAnsMtd) %>
					<input type="hidden" name="AnsType" value="<%= strAnsMtd %>">
				</td>
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
				<td class="td_lmagin">
					<input type="file" size="40" name="OriginFile" class="textfield"><BR>
					<%= objRsSH.getObject("ORG_FILE_PATH") %>
				</td>
			</tr>
			<tr class="tbl-line">
            	<td height="1" colspan="2"></td>
           	</tr>
           	<tr>
				<td class="td_gray1" height="25">
					<img src="/image/common/icon_nemo_gray.gif" width="3" height="6">
					��������
				</td>
				<td class="td_lmagin">
					<input type="file" size="40" name="PdfFile" class="textfield"><BR>
					<input type="hidden" name="AnsFileID" value="<%= StringUtil.padl((String)objRsSH.getObject("ANS_FILE_ID"), 10) %>">
					<%= objRsSH.getObject("PDF_FILE_PATH") %>
				</td>
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
				<td class="td_lmagin">
					<SELECT name="MatType">
					<%
						List matList = (List)objCdinfo.getNotElecMediumList();
						if (matList.size() == 0) {
							out.println("<option value=''>��ϵ� ��ü�� �����ϴ�.</option>");
						} else {
							for(int i=0; i<matList.size(); i++) {
								Hashtable hash = (Hashtable)matList.get(i);
								String code = (String)hash.get("MSORT_CD");
								String codeValue = (String)hash.get("CD_NM");
								if(String.valueOf(objRsSH.getObject("NON_ELC_DOC_MED")).equalsIgnoreCase(code))
									out.println("<option value='"+code+"' selected>"+codeValue+"</option>");
								else
									out.println("<option value='"+code+"'>"+codeValue+"</option>");
							}
						}
					%>
					</SELECT>
				</td>
			</tr>
			<tr class="tbl-line">
            	<td height="1" colspan="2"></td>
           	</tr>
           	<tr>
				<td class="td_gray1" height="25">
					<img src="/image/common/icon_nemo_gray.gif" width="3" height="6">
					�߼� ���
				</td>
				<td class="td_lmagin">
					<SELECT name="SendWay">
					<%
						List swList = (List)objCdinfo.getSendWayList();
						if (swList.size() == 0) {
							out.println("<option value=''>��ϵ� �߼۹���� �����ϴ�.</option>");
						} else {
							for(int i=0; i<swList.size(); i++) {
								Hashtable hash = (Hashtable)swList.get(i);
								String code = (String)hash.get("MSORT_CD");
								String codeValue = (String)hash.get("CD_NM");
								if(String.valueOf(objRsSH.getObject("NON_ELC_DOC_SUBMT_MTD")).equalsIgnoreCase(code))
									out.println("<option value='"+code+"' selected>"+codeValue+"</option>");
								else
									out.println("<option value='"+code+"'>"+codeValue+"</option>");
							}
						}
					%>
					</SELECT>
				</td>
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
				<td width="340" class="td_lmagin">
					<textarea cols="50" rows="5" class="textfield" name="AnsOpin" style="WIDTH: 90% ; height: 80"><%= objRsSH.getObject("ANS_OPIN") %></textarea>
				</td>
			</tr>
			<tr class="tbl-line">
            	<td height="1" colspan="2"></td>
           	</tr>
		</table>
		<p>
		&nbsp;&nbsp;
		<img src="/image/button/bt_ok.gif" border="0" onClick="javascript:submitEdit()" style="cursor:hand">
		&nbsp;&nbsp;
		<img src="/image/button/bt_prevPage.gif" border="0" onClick="javascript:history.go(-1);" style="cursor:hand">
		&nbsp;&nbsp;
		<img src="/image/button/bt_closeWindow.gif" border="0" onClick="javascript:window.close();" style="cursor:hand">

</FORM>
		<!----------------------------------------------------------------------------------->
		</td>
	</tr>
</table>

<!--<DIV id="loadingDiv" style="width:300px">
	<img src="/image/reqsubmit/loading.gif" border="0">
</DIV>-->

</body>

</html>