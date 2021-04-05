<%@ page language="java" contentType="text/html;charset=EUC-KR" %>

<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
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
    String strReturnURLFLAG = request.getParameter("ReturnURLFLAG")==null?"":request.getParameter("ReturnURLFLAG");

	System.out.println("strReturnURLFLAG ::"+strReturnURLFLAG);
	String strReturnURL = "";
	if(strReturnURLFLAG.equals("CMT")){
	   strReturnURL = "/reqsubmit/20_comm/20_reqboxsh/40_subend/SSubEndBoxList.jsp";
	}else{
		strReturnURL = StringUtil.getEmptyIfNull(request.getParameter("ReturnURL"), "/reqsubmit/10_mem/20_reqboxsh/30_makeend/SMakeEndBoxList.jsp");
	}


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

	// 넘어온 파라미터를 설정해서 필요할 떄 쓰도록 하자
	// 요구함 관련
	String strReqBoxID = objParams.getParamValue("ReqBoxID");
	String strReqBoxSortField = objParams.getParamValue("ReqBoxSortField");
	String strReqBoxSortMtd = objParams.getParamValue("ReqBoxSortMtd");
	String strReqBoxPagNum = objParams.getParamValue("ReqBoxPage");
	String strReqBoxQryField = objParams.getParamValue("ReqBoxQryField");
	String strReqBoxQryTerm = objParams.getParamValue("ReqBoxQryTerm");
	String strAnswPermCD = request.getParameter("AnswPermCD");
	System.out.println("kangthis logs AnsDocSend.jsp AnswPermCD => " + strAnswPermCD);

	ResultSetSingleHelper objRsSH = null;
	try{
		selfDelegate = new SMemReqBoxDelegate();
	   	reqDelegate = new MemRequestBoxDelegate();

	   	boolean blnHashAuth = reqDelegate.checkReqBoxAuth(strReqBoxID, objUserInfo.getOrganID()).booleanValue();
	   	if(!blnHashAuth) {
	   		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	  		objMsgBean.setStrCode("DSAUTH-0001");
  	  		objMsgBean.setStrMsg("해당 요구함을 볼 권한이 없습니다.");
  	  		out.println("해당 요구함을 볼 권한이 없습니다.");
		    return;
		}

	    // 요구함 등록 정보를 SELECT 한다.
	    objRsSH = new ResultSetSingleHelper(selfDelegate.getRecord(strReqBoxID, objUserInfo.getOrganID()));

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
<title>답변서 발송 선택화면입니다.</title>
<link href="/css/System.css" rel="stylesheet" type="text/css">

<script language="javascript">
function submitCheck() {
	var f = document.reqDocForm;
	if (f.SmsUse.value == "") {
		f.SmsUse.value = "<%= CodeConstants.NTC_MTD_EMAIL %>";
	}

	if (confirm("답변서를 발송하시겠습니까?")) {
		var AnswPermCD = f.AnswPermCD.value;
		f.action = "/reqsubmit/common/AnsDocSendProc.jsp";
		document.all.loadingDIV.style.display = '';
		f.submit();
	}
}

function cancelCheck() {
	self.close();
}
</script>

</head>

<body leftmargin="0" topmargin="0">
<DIV ID="loadingDIV" style="width:200px;display:none;position:absolute;left:120;top:60">
	<img src="/image/reqsubmit/loading.gif" border="1">
</DIV>
<table border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td width="450" height="30" align="center">
			<table border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td height="5" class="td_reqsubmit"></td>
				</tr>
				<tr>
					<td width="450"><img src="/image/title/title_sendAnsDoc.jpg" border="0"></td>
				</tr>
				<tr><td height="1" bgcolor="#c0c0c0"></td></tr>
			</table>
		</td>
	</tr>
	<tr>
		<td height="10" bgcolor="#ffffff"></td>
	</tr>
	<tr>
		<td align="center" valign="top">
		<!------------------------------------------------------------------------------------------------------------------>
<FORM method="post" action="" name="reqDocForm" style="margin:0px">
			<input type="hidden" name="ReqBoxID" value="<%= strReqBoxID %>">
			<input type="hidden" name="ReqTp" value="<%= CodeConstants.REQ_ORGAN_PERSON %>">
			<input type="hidden" name="SndrID" value="<%= objUserInfo.getUserID() %>">
			<input type="hidden" name="RcvrID" value="<%= objRsSH.getObject("REGR_ID") %>">
			<input type="hidden" name="ElcUse" value="<%= CodeConstants.SND_MTD_ELEC %>">
			<input type="hidden" name="ReqOrganNm" value="<%= objRsSH.getObject("REQ_ORGAN_NM") %>">
			<input type="hidden" name="ReqOrganID" value="<%= objRsSH.getObject("REQ_ORGAN_ID") %>">
			<input type="hidden" name="ReturnURL" value="<%= strReturnURL %>">
			<input type="hidden" name="AnswPermCD" value="<%=strAnswPermCD%>">

			<!-- 2004-07-28 add -->
			<input type="hidden" name="SubmtOrganNm" value="<%= objRsSH.getObject("SUBMT_ORGAN_NM") %>">

			<table border="0" cellpadding="0" cellspacing="0">
				<tr class="td_reqsubmit">
            		<td height="2" colspan="2"></td>
            	</tr>
				<tr>
					<td width="100" height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6">
					요구자료 </td>
					<td width="310" class="td_lmagin"><B><%= objRsSH.getObject("REQ_BOX_NM") %></B></td>
				</tr>
				<tr bgcolor="#d0d0d0">
	            	<td height="1" colspan="2"></td>
    	       	</tr>
    	       	<tr bgcolor="#ffffff">
	            	<td height="1" colspan="2"></td>
    	       	</tr>
    	       	<tr bgcolor="#d0d0d0">
	            	<td height="1" colspan="2"></td>
    	       	</tr>
    	       	<tr>
					<td class="td_gray1" height="25"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6">
					요구기관 </td>
					<td class="td_lmagin"><%= objRsSH.getObject("REQ_ORGAN_NM") %></td>
				</tr>
				<tr class="tbl-line">
	            	<td height="1" colspan="2"></td>
    	       	</tr>
    	       	<tr>
					<td class="td_gray1" height="25"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6">
					요구자 </td>
					<td class="td_lmagin"><%= objRsSH.getObject("REGR_NM") %> (<%= objRsSH.getObject("REGR_EMAIL") %> / <%= objRsSH.getObject("REGR_CPHONE") %>)</td>
				</tr>
				<tr class="tbl-line">
	            	<td height="1" colspan="2"></td>
    	       	</tr>
    	       	<tr>
					<td class="td_gray1" height="25"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6">
					제출기관 </td>
					<td class="td_lmagin"><%= objRsSH.getObject("SUBMT_ORGAN_NM") %></td>
				</tr>
				<tr class="tbl-line">
	            	<td height="1" colspan="2"></td>
    	       	</tr>
    	       	<tr>
					<td class="td_gray1" height="25"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6">
					제출기한 </td>
					<td class="td_lmagin"><B><%= StringUtil.getDate((String)objRsSH.getObject("SUBMT_DLN")) %> 24:00</B></td>
				</tr>
				<tr class="tbl-line">
	            	<td height="1" colspan="2"></td>
    	       	</tr>
    	       	<tr>
					<td class="td_gray1" height="50"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6">
					문자 전송</td>
					<td class="td_lmagin">
						자료 요구자에게 문자메시지를 전송합니다. [예]<input type="checkbox" name="SmsUse" value="<%= CodeConstants.NTC_MTD_BOTH %>" align="absmiddle"><BR>
						<!--* e-mail은 선택과 상관없이 전송됩니다.-->
					</td>
				</tr>
				<tr class="tbl-line">
	            	<td height="2" colspan="2"></td>
    	       	</tr>
			</table>
			<p>
			<img src="/image/button/bt_ok.gif" border="0" onClick="javascript:submitCheck()" style="cursor:hand">&nbsp;&nbsp;
			<img src="/image/button/bt_closeWindow.gif" border="0" onClick="javascript:cancelCheck()" style="cursor:hand">
</FORM>
		<!------------------------------------------------------------------------------------------------------------------>
		</td>
	</tr>
</table>
</body>
</html>