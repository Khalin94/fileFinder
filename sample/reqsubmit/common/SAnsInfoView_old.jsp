<%@ page language="java" contentType="text/html;charset=EUC-KR" %>

<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.lib.reqsubmit.params.answerinfo.SAnsInfoViewForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.answerinfo.AnsInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.MemRequestBoxDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	UserInfoDelegate objUserInfo = null;
	CDInfoDelegate objCdinfo = null;
%>

<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>

<%
	MemRequestBoxDelegate reqDelegate = null;
	AnsInfoDelegate selfDelegate = null;

	SAnsInfoViewForm objParams = new SAnsInfoViewForm();

	boolean blnParamCheck=false;
	blnParamCheck = objParams.validateParams(request);
	if(blnParamCheck==false) {
  		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  		objMsgBean.setStrCode("DSPARAM-0000");
  		objMsgBean.setStrMsg(objParams.getStrErrors());
  		out.println("ParamError:" + objParams.getStrErrors());
	  	return;
  	}//endif

	// 넘어온 파라미터를 설정해서 필요할 때 쓰도록 하자
	String strReqBoxID = null;
	String strReqID = null;
	String strAnsID = objParams.getParamValue("AnsID");
	String strReturnURL = objParams.getParamValue("ReturnURL");

	ResultSetSingleHelper objRsSH = null;

	// 답변 유형에 따라서 출력해야하는 항목들이 달라진다.
	String strAnsMtd = null;
	String strAnsStt = null;

	try{
		reqDelegate = new MemRequestBoxDelegate();
	   	selfDelegate = new AnsInfoDelegate();

    	objRsSH = new ResultSetSingleHelper(selfDelegate.getRecord(strAnsID));
    	strAnsMtd = (String)objRsSH.getObject("ANS_MTD");
    	strAnsStt = (String)objRsSH.getObject("SUBMT_FLAG");
    	strReqBoxID = (String)objRsSH.getObject("REQ_BOX_ID");
    	strReqID = (String)objRsSH.getObject("REQ_ID");


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
<title>답변 상세 보기</title>
<link href="/css/System.css" rel="stylesheet" type="text/css">
<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>

<script language="javascript">
	function submitDelete() {
		var f = document.viewForm;
		f.action = "/reqsubmit/common/SAnsInfoDelProc.jsp";
		if (confirm("해당 답변을 삭제하시겠습니까?")) f.submit();
	}

	function gotoEditForm() {
		var f = document.viewForm;
		f.target = "";
		f.action = "/reqsubmit/common/SAnsInfoEdit_old.jsp";
		//NewWindow('/reqsubmit/common/SAnsInfoEdit.jsp', 'popwin', '500', '580');
		f.submit();
		//self.close();
	}

	function viewFile(strAnsID, strType) {
		if (strType == "PDF") {
			var strURL = "/reqsubmit/common/ReqFileOpen.jsp?paramAnsId="+strAnsID+"&DOC="+strType;
			window.open(strURL, '', 'width=800px, height=600px');
		} else {
			location.href = "/reqsubmit/common/ReqFileOpen.jsp?paramAnsId="+strAnsID+"&DOC="+strType;
		}
	}

</script>

</head>

<body leftmargin="0" topmargin="0">
<table border="0" cellpadding="0" cellspacing="0" width="500">
	<tr>
		<td width="500" height="30" align="center">
			<table border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td height="4" class="td_reqsubmit"></td>
				</tr>
				<tr>
					<td width="500" height="30"><img src="/image/title/title_viewAnsInfo.jpg" border="0"></td>
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
<FORM method="post" action="" name="viewForm" style="margin:0px">

		<input type="hidden" name="ReqBoxID" value="<%= strReqBoxID %>">
		<input type="hidden" name="ReqID" value="<%= strReqID %>">
		<input type="hidden" name="AnsID" value="<%= strAnsID %>">
		<input type="hidden" name="WinType" value="POPUP" %>
		<input type="hidden" name="ReturnURL" value="<%= strReturnURL %>">

		<table border="0" cellpadding="0" cellspacing="0">
			<tr class="td_reqsubmit">
            	<td height="2" colspan="2"></td>
            </tr>
	           	<tr>
				<td class="td_gray1" height="25">
					<img src="/image/common/icon_nemo_gray.gif" width="3" height="6">
					답변유형
				</td>
				<td class="td_lmagin">
				<%if(strAnsMtd.equals("004")){%>
				오프라인제출
				<%}else{%>
				<%= CodeConstants.getAnswerMethod(strAnsMtd) %>
				<%}%>
				</td>
			</tr>
			<tr class="tbl-line">
            	<td height="1" colspan="2"></td>
           	</tr>
           	<tr>
				<td class="td_gray1" height="25">
					<img src="/image/common/icon_nemo_gray.gif" width="3" height="6">
					제출 여부
				</td>
				<td class="td_lmagin"><% if ("Y".equalsIgnoreCase(strAnsStt)) out.println("제출완료"); else out.println("미제출"); %></td>
			</tr>
			<tr class="tbl-line">
            	<td height="1" colspan="2"></td>
           	</tr>
<%
	if (CodeConstants.ANS_MTD_ELEC.equalsIgnoreCase(strAnsMtd)) { // 답변 유형이 전자문서라면
%>
           	<tr>
				<td class="td_gray1" height="25">
					<img src="/image/common/icon_nemo_gray.gif" width="3" height="6">
					제출파일
				</td>
				<td class="td_lmagin"><a href="javascript:viewFile('<%= strAnsID %>', 'PDF');"><img src="/image/common/icon_pdf.gif" border="0"> [PDF 문서]</a></td>
			</tr>
			<tr class="tbl-line">
            	<td height="1" colspan="2"></td>
           	</tr>
           	<tr>
				<td class="td_gray1" height="25">
					<img src="/image/common/icon_nemo_gray.gif" width="3" height="6">
					원본파일
				</td>
				<td class="td_lmagin"><a href="javascript:viewFile('<%= strAnsID %>', 'DOC');"><img src="/image/common/icon_file.gif" border="0"> [원본파일]</a></td>
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
						매체유형
				</td>
				<td class="td_lmagin"><%= objCdinfo.getNotElecMedium((String)objRsSH.getObject("NON_ELC_DOC_MED")) %></td>
			</tr>
			<tr class="tbl-line">
            	<td height="1" colspan="2"></td>
           	</tr>
           	<tr>
				<td class="td_gray1" height="25">
					<img src="/image/common/icon_nemo_gray.gif" width="3" height="6">
					발송 방법
				</td>
				<td class="td_lmagin"><%= StringUtil.getEmptyIfNull((String)objCdinfo.getSendWay((String)objRsSH.getObject("NON_ELC_DOC_SUBMT_MTD"))) %></td>
			</tr>
			<tr class="tbl-line">
            	<td height="1" colspan="2"></td>
           	</tr>
<% } %>
           	<tr>
				<td class="td_gray1" height="25">
					<img src="/image/common/icon_nemo_gray.gif" width="3" height="6">
					제출자
				</td>
				<td class="td_lmagin"><%= objRsSH.getObject("USER_NM") %></td>
			</tr>
			<tr class="tbl-line">
            	<td height="1" colspan="2"></td>
           	</tr>
           	<tr>
				<td class="td_gray1" height="25">
					<img src="/image/common/icon_nemo_gray.gif" width="3" height="6">
					제출일
				</td>
				<td class="td_lmagin"><%= StringUtil.getDate2((String)objRsSH.getObject("ANS_DT")) %></td>
			</tr>
			<tr class="tbl-line">
            	<td height="1" colspan="2"></td>
           	</tr>
           	<tr>
				<td width="100" class="td_gray1" height="25">
					<img src="/image/common/icon_nemo_gray.gif" width="3" height="6">
					제출 의견
				</td>
				<td width="340" class="td_lmagin" style="padding-top:5px;padding-bottom:5px"><%= objRsSH.getObject("ANS_OPIN") %></td>
			</tr>
			<tr class="tbl-line">
            	<td height="1" colspan="2"></td>
           	</tr>
		</table>
		<p>
		<% if (!"Y".equalsIgnoreCase(strAnsStt)) { %>
		&nbsp;&nbsp;
		<img src="/image/button/bt_modify.gif" border="0" onClick="javascript:gotoEditForm()" style="cursor:hand">
		&nbsp;&nbsp;
		<img src="/image/button/bt_delete.gif" border="0" onClick="javascript:submitDelete()" style="cursor:hand">
		&nbsp;&nbsp;
		<img src="/image/button/bt_closeWindow.gif" border="0" onClick="javascript:window.close();" style="cursor:hand">
		<% } else { %>
		<img src="/image/button/bt_ok.gif" border="0" onClick="javascript:window.close();" style="cursor:hand">
		<% } %>

</FORM>
		<!----------------------------------------------------------------------------------->
		</td>
	</tr>
</table>
</body>

</html>