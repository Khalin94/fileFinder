<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="kr.co.kcc.bf.db.DBAccess" %>
<%@ page import="kr.co.kcc.bf.db.DBAccessException" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.cmtmanager.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.all.ReqInfoAllInOneDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.CommRequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.common.addjob.AddJobDelegate" %>

<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>


<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%!
	public static String getSysDate(){
		String nowdate="";
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		nowdate = sdf.format(new Date());
		return nowdate;
	}
%>
<%
	UserInfoDelegate objUserInfo = null;
	CDInfoDelegate objCdinfo = null;
%>

<%@ include file="../common/RUserCodeInfoInc.jsp" %>

<%
	String strUserID   = objUserInfo.getUserID();
	String strOrganID  = objUserInfo.getOrganID();
	String strOrgnaNM  = "";
	String strUserNm = objUserInfo.getUserName();
	strUserNm = strUserNm.substring(0,2);

	// 2005-08-08 kogaeng ADD
	// �䱸���� ������ ���� �Է������� ��ȯ�� URL�� �޶�� �Ѵ�.
	String strReqBoxTp = StringUtil.getEmptyIfNull(request.getParameter("ReqBoxTp"), "001");
	String strReqScheID = StringUtil.getEmptyIfNull(request.getParameter("ReqScheID"));

	String strTitle = "�䱸�ڷ� ���";
	String strAction = "/reqsubmit/common/ReqInfoWriteAllInOneProc_old.jsp";
	if(CodeConstants.REQ_BOX_TP_CMT.equals(strReqBoxTp)) {
		strTitle = "����ȸ �䱸�� �ۼ�";
		//strAction = "/reqsubmit/common/CmtReqInfoWriteAllInOneProc.jsp";
	}

	String CmtOrganID = StringUtil.getEmptyIfNull(request.getParameter("CmtOrganID"));
	String tempCmtOrganID = StringUtil.getEmptyIfNull(request.getParameter("CmtOrganID"));
	String[] strReqOrganIdData = null;
	String strSubmtDln = StringUtil.getEmptyIfNull((String)request.getParameter("SubmtDln"));
	String strNatCnt   = StringUtil.getEmptyIfNull(request.getParameter("NatCnt"));
	String strRltdDutyX = StringUtil.getEmptyIfNull(request.getParameter("RltdDutyX"));
	String strAnsDuty = StringUtil.getEmptyIfNull(request.getParameter("AnsDuty"));
	String strReqDate = StringUtil.getEmptyIfNull(request.getParameter("reqdate"));
	String FLAG = StringUtil.getEmptyIfNull(request.getParameter("FLAG"));
	String FLAG2 = StringUtil.getEmptyIfNull(request.getParameter("FLAG2"));
	String strReqOrganId = "";

	if(FLAG2.equals("CHAT2")){
		strReqOrganIdData = StringUtil.split("^",StringUtil.getEmptyIfNull(request.getParameter("ReqOrganID")));
		strReqOrganId = strReqOrganIdData[0];
	}
	System.out.println("strReqOrganId :: "+strReqOrganId);
	String strUserDN = null;

	//String[] SubSelectID = request.getParameterValues("SubSelectID");/**  ���õ� ������ ����Ʈ  */


	System.out.println("CMT ::: "+CmtOrganID);

	//���������� �����´�.

	ResultSetSingleHelper objRsSH=null;	/** �䱸���� ���� ��¿�  ResultSetSingleHelper*/
	ResultSetHelper objSubmtOrganRs=null;  /** ������ ����Ʈ ��¿� ResultSetHelper */
	ResultSetHelper objRltdDutyRs=null;   /** ���ñ�� ����Ʈ ��¿� RsHelper */
	ResultSetHelper objOrganRs = null;
	ResultSetHelper objSelectOrganRs = null;
	ResultSetHelper objSelectUser = null;
	Hashtable objhashdata4 = null;
	String SessionNo2 = "";

	try {
	   	/********* �븮�� ���� ���� *********/
		CommRequestBoxDelegate objReqBox=new CommRequestBoxDelegate(); 		/**�䱸�� Delegate*/
	    ReqInfoAllInOneDelegate objReqAllOne = new ReqInfoAllInOneDelegate();
		OrganInfoDelegate objOrganInfo=new OrganInfoDelegate();   /** ������� ��¿� �븮�� */

	    if(CmtOrganID.equals("")){
	   		/********* ���������� **************/
	    	objOrganRs=new ResultSetHelper(objUserInfo.getCurrentCMTList());   /** �Ҽ� ����ȸ */
	    	if(objOrganRs.next()) CmtOrganID=(String)objOrganRs.getObject("ORGAN_ID");
		}

		objOrganRs=new ResultSetHelper(objReqAllOne.getReqOrganChart());   /** ��ü ����ȸ */
		strOrgnaNM = objReqAllOne.getOrganNM(strOrganID);

		objhashdata4 = (Hashtable)objReqAllOne.getSessionDBCode();

		String flagSession = (String)objhashdata4.get("USE_FLAG");
		String strCurDate = this.getSysDate();
		if(flagSession.equals("Y")){
			Hashtable hashdata = (Hashtable)objReqAllOne.getSessionNo(strCurDate);
			SessionNo2 = (String)hashdata.get("SESSION");
		}else{
			Hashtable hashdata = (Hashtable)objReqAllOne.getSessionNoDSDM(strCurDate);
			SessionNo2 = (String)hashdata.get("SES_NUM");
			if(SessionNo2 == null){
				Hashtable hashdata2 = (Hashtable)objReqAllOne.getSessionNo(strCurDate);
				SessionNo2 = (String)hashdata2.get("SESSION");
			}
		}
	      SessionNo2 = "332";
	        System.out.println("44444444444444444444444444444444");
	        System.out.println("ssss="+SessionNo2);

		/********* ���������� **************/

		//objSubmtOrganRs=new ResultSetHelper(objOrganInfo.getSubmtOrganList(CmtOrganID));/**����������Ʈ*/
		if(FLAG.equals("CHAT")){
			if(CmtOrganID != null) objSelectOrganRs =new ResultSetHelper(objReqBox.getReqOrganListData(CmtOrganID));/** ���õ� ����ȸ���� �ǿ��Ǹ���Ʈ*/
		}

		if(FLAG2.equals("CHAT2")){
			if(strReqOrganId != null) objSelectUser =new ResultSetHelper(objReqAllOne.selectOrganUser(strReqOrganId));/** ���õ� ����ȸ���� �ǿ��ǻ���ڸ���Ʈ*/
		}
		HttpSession objPrivateSession = request.getSession();
		strUserDN = StringUtil.getEmptyIfNull((String)objPrivateSession.getAttribute("UserDN"));
	} catch(AppException objAppEx) {
 		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  		objMsgBean.setStrCode(objAppEx.getStrErrCode());
  		objMsgBean.setStrMsg(objAppEx.getMessage());
  		out.println("<br>Error!!!" + objAppEx.getMessage());
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}
%>

<html>
<head>
<title>�䱸�� �ۼ� - All In One</title>

<style>
	BODY, table, tr, td { font-family:Verdana, ����; font-size:11px; color:#585858; }
	form { margin:0px }
	a.hover { text-decoration: underline }
	SELECT { font-family:Verdana, ����; font-size:11px; background-color:#f1f1f1; color:#585858; }
	BUTTON { font-family:verdana,����; font-size:11px; border:0px solid #ffffff; background-color:white; cursor:hand; }
	.button { font-family:verdana, ����; font-size:11px; background-color:#E5E6FD; cursor:hand; }
	.buttonRect { font-family:verdana, ����; font-size:11px; background-color:#E5E6FD; cursor:hand; width:45px;height:45px; }
	.input { font-family:verdana, ����; font-size:11px; }
	.input2 { font-family:verdana, ����; font-size:11px; border:1px solid #909090;}
	INPUT { font-family:verdana, ����; font-size:11px; height:19px }
	TEXTAREA { font-family:verdana, ����; font-size:11px; border:1px solid #909090;}
</style>
<script language=Javascript src="/js/reqsubmit/common.js"></script>
<script language=Javascript src="/js/nads_lib.js"></script>
<script language=Javascript src="/js/datepicker.js"></script>
<script language="javascript" src="/js/forum.js"></script>

<script language="javascript">


var numRef = 1;
function changeInputForm(value) {
	var str = "";
	if (value == "<%= CodeConstants.ANS_MTD_ELEC %>") { // ���������� ���
		str = "";
		str = str + "<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\"><tr>\n"
		str	= str + "<td width=\"100\" height=\"20\" class=\"td_gray1\"><img src=\"/image/common/icon_nemo_gray.gif\" width=\"3\" height=\"6\">\n"
		str	= str + "���� ����</td>\n"
		str	= str + "<td width=\"320\" height=\"20\" class=\"td_lmagin\"><input type=\"file\" class=\"textfield\" name=\"OriginFile0\" size=\"30\"></td>\n";
		str	= str + "<td width=\"82\" align=\"center\"><a href=\"javascript:submitbutton()\"><img src=\"/image/button/bt_add_admin.gif\" border=\"0\"></a></td></tr>\n"
		str = str + "<tr height=\"1\" class=\"tbl-line\">\n"
		str	= str + "<td height=\"1\" colspan=\"3\"></tr>\n"
		str	= str + "<tr><td height=\"20\" class=\"td_gray1\"><img src=\"/image/common/icon_nemo_gray.gif\" width=\"3\" height=\"6\">\n"
		str	= str + "PDF ����</td>\n"
		str	= str + "<td height=\"20\" class=\"td_lmagin\"><input type=\"file\" class=\"textfield\" name=\"PdfFile0\" size=\"30\"></td>\n";
		str	= str + "<td align=\"center\">&nbsp;</td></tr>\n";
		str	= str + "<tr height=\"1\" class=\"tbl-line\">\n"
		str	= str + "<td height=\"1\" colspan=\"3\"></tr></table>\n"
		str = str + "<input type=hidden name=MatType value=''>\n";
		str = str + "<input type=hidden name=SendWay value=''>\n";

		document.all.inputDiv.innerHTML = str;

	} else if (value == "<%= CodeConstants.ANS_MTD_ETCS%>") { // ������������ ���
		for(var i = 1;i<5; i++){
		   document.all.filesubmit[i].innerHTML="";
		}
		numRef = 1
		str = "";
		str = str + "<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\n";
		str = str + "<tr>\n";
		str = str + "<td width=\"80\" height=\"25\" class=\"td_gray1\"><img src='/image/common/icon_nemo_gray.gif'> ��ü����</td>\n";
		str = str + "<td width=\"380\" class=\"td_lmagin\"><select name=\"MatType\" class='select'><option value=''>::: ������ �ּ��� :::</option>";
		<%
			List matList = (List)objCdinfo.getNotElecMediumList();
			if (matList.size() == 0) {
				out.println("str = str + \"<option value=''>��ϵ� ��ü�� �����ϴ�.</option>\";");
			} else {
				for(int i=0; i<matList.size(); i++) {
					Hashtable hash = (Hashtable)matList.get(i);
					String code = (String)hash.get("MSORT_CD");
					String codeValue = (String)hash.get("CD_NM");
					out.println("str = str + \"<option value='"+code+"'>"+codeValue+"</option>\";");
				}
			}
		%>
		str = str + "</select>\n";
		str = str + "</td>\n";
		str = str + "</tr>\n";
		str = str + "<tr height=\"1\" class=\"tbl-line\"><td height=\"1\"></td><td height=\"1\"></td></tr>\n";
		str = str + "<tr>\n";
		str = str + "<td height=\"25\" class=\"td_gray1\"><img src='/image/common/icon_nemo_gray.gif'> �߼� ���</td>\n";
		str = str + "<td class=\"td_lmagin\"><select name=\"SendWay\" class='select'><option value=''>::: ������ �ּ��� :::</option>";
		<%
			List swList = (List)objCdinfo.getSendWayList();
			if (swList.size() == 0) {
				out.println("str = str + \"<option value=''>��ϵ� �߼۹���� �����ϴ�.</option>\";");
			} else {
				for(int i=0; i<swList.size(); i++) {
					Hashtable hash = (Hashtable)swList.get(i);
					String code = (String)hash.get("MSORT_CD");
					String codeValue = (String)hash.get("CD_NM");
					out.println("str = str + \"<option value='"+code+"'>"+codeValue+"</option>\";");
				}
			}
		%>
		str = str + "</tr>\n";
		str = str + "<tr height=\"1\" class=\"tbl-line\"><td height=\"1\"></td><td height=\"1\"></td></tr>\n";
		str = str + "</table>\n";
		str = str + "<input type=hidden name=OriginFile value=''>\n";
		str = str + "<input type=hidden name=PdfFile value=''>\n";

		document.all.inputDiv.innerHTML = str;
	} else { // �ش� ��� �ƴ��� ���
		for(var i = 1;i<5; i++){
		   document.all.filesubmit[i].innerHTML="";
		}
		numRef = 1
		str = "";
		str = str + "<input type=hidden name=MatType value=''>\n";
		str = str + "<input type=hidden name=SendWay value=''>\n";
		str = str + "<input type=hidden name=OriginFile value=''>\n";
		str = str + "<input type=hidden name=PdfFile value=''>\n";
		document.all.inputDiv.innerHTML = str;
	}
}

function submitbutton() {
	var str;
	if (numRef > 4) {
		alert("���̻� ������ �߰��Ͻ� �� �����ϴ�.");
	}else{
		var strBgcolor;
		if((numRef % 2) == 0) strBgcolor = " class=td_gray1";
		else strBgcolor = " class=td_grayAnother";
		str = "";
		str = str + "<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\"><tr>\n";
		str	= str + "<td width=\"80\" height=\"20\" "+strBgcolor+"><img src=\"/image/common/icon_nemo_gray.gif\" width=\"3\" height=\"6\">\n";
		str	= str + "���� ����</td>\n";
		str	= str + "<td width=\"320\" height=\"20\" class=\"td_lmagin\"><input type=\"file\" class=\"textfield\" name=\"OriginFile"+numRef+"\" size=\"30\"></td>\n";
		str	= str + "<td width=\"60\" align=\"center\"><a href=\"javascript:removebutton("+(numRef)+")\"><img src='/image/button/bt_cancel_admin.gif' border='0'></a></td></tr>\n";
		str = str + "<tr height=\"1\" class=\"tbl-line\">\n";
		str	= str + "<td height=\"1\" colspan=\"3\"></tr>\n";
		str	= str + "<tr><td height=\"20\" "+strBgcolor+"><img src=\"/image/common/icon_nemo_gray.gif\" width=\"3\" height=\"6\">\n";
		str	= str + "PDF ����</td>\n";
		str	= str + "<td height=\"20\" class=\"td_lmagin\"><input type=\"file\" class=\"textfield\" name=\"PdfFile"+numRef+"\" size=\"30\"></td>\n";
		str	= str + "<td align=\"center\">&nbsp;</td></tr>\n";
		str	= str + "<tr height=\"1\" class=\"tbl-line\">\n";
		str	= str + "<td height=\"1\" colspan=\"3\"></tr></table>\n";
		str = str + "<input type=hidden name=MatType value=''>\n";
		str = str + "<input type=hidden name=SendWay value=''>\n";
		document.all.filesubmit[numRef].innerHTML=str;
		numRef++;
	}
}

function removebutton(num){
	document.all.filesubmit[num].innerHTML="";
	numRef--;
}
	/*** ���ڸ� �Է¹ޱ�.*/
	function CheckNumeric(field){
		var objEv = event.srcElement;
		var numPattern = /([^0-9])/;
		numPattern = objEv.value.match(numPattern);
		if(numPattern != null){
			alert("���ڸ� �Է��� �ּ���!");
			objEv.value="";
			objEv.focus();
			return;
		}
	}

	/*** ���ڸ� �Է¹ޱ�.*/
	function CheckNumeric(){
		var objEv = event.srcElement;
		var numPattern = /([^0-9])/;
		numPattern = objEv.value.match(numPattern);
		if(numPattern != null){
			alert("���ڸ� �Է��� �ּ���!");
			objEv.value="";
			objEv.focus();
			return;
		}
	}




	function searchSubmit(){
		//var strOrganID = document.formName.CmtOrganID.value;
		//document.formName.target = "OrganFrame";
		//document.formName.action = "/reqsubmit/common/OrganSelect.jsp?CmtOrganID="+strOrganID;
		document.formName.FLAG.value="CHAT";

		document.formName.submit();
		//document.formName.target = "";
	}

	function searchReqUserId(){
		//var strOrganID = document.formName.CmtOrganID.value;
		//document.formName.target = "OrganFrame";
		//document.formName.action = "/reqsubmit/common/OrganSelect.jsp?CmtOrganID="+strOrganID;
		document.formName.FLAG.value="CHAT";

		document.formName.FLAG2.value="CHAT2";

		document.formName.submit();
		//document.formName.target = "";
	}

	function checkFormData(){
		if(formName.elements['RltdDutyX'].value == ""){
			alert("���������� �������ּ���");
			return false;
		}
		if(formName.elements['AnsDuty'].value == ""){
			alert("�������� �䱸������ �������ּ���");
			return false;
		}
		if(formName.elements['reqdate'].value == ""){
			alert("��û���ڸ� �������ּ���");
			return false;
		}
		if(formName.elements['CmtOrganID'].value == ""){
			alert("�Ұ�����ȸ�� �������ּ���");
			return false;
		}
		if(formName.elements['ReqOrganID'].value == ""){
			alert("�ǿ����� �������ּ���");
			return false;
		}if(formName.elements['RegrID'].value == ""){
			alert("����ڸ� �������ּ���");
			return false
		}
		if(formName.elements['ReqCont'].value == ""){
			alert("�䱸���� �ۼ��� �ּ���");
			return false
		}
		if(formName.elements['ReqDtlCont'].value == ""){
			alert("�䱸������ �ۼ��� �ּ���");
			return false
		}
		var f = document.formName;
		var ansType = f.AnsType.value;
		//alert(numRef);
		if (ansType == "<%= CodeConstants.ANS_MTD_ELEC %>") { // ���������ΰ���?
			for(var j = 0;j < numRef ; j++){
				var Ofile = eval("f.OriginFile"+j);
				var Pfile = eval("f.PdfFile"+j);
			   //alert(Ofile.value);
			   //alert(Pfile.value);
			   if (Ofile.value == "") {
					alert("���� ���� ������ ������ �ּ���");
					//f.OriginFile.focus();
					return;
				} else if (Pfile.value == "") {
					alert("PDF ������ ������ �ּ���");
					//f.PdfFile.focus();
					return;
				}

				var pdfFileName = Pfile.value;
				var orgFileName = Ofile.value;

				var pdfDot = pdfFileName.lastIndexOf('.');
				var orgDot = orgFileName.lastIndexOf('.');

				var pdfExt = pdfFileName.substring(pdfDot+1);
				var orgExt = orgFileName.substring(orgDot+1);

				if(orgExt.toUpperCase() == "PDF" || orgExt.toUpperCase() == "HWP" || orgExt.toUpperCase() == "XLS" || orgExt.toUpperCase() == "DOC" || orgExt.toUpperCase() == "PPT" || orgExt.toUpperCase() == "TXT"){

				}


			}
			if (f.AnsOpin.value == "") {
					f.AnsOpin.value = "";
			}



		} else if (ansType == "<%= CodeConstants.ANS_MTD_ETCS%>") { // �����������ΰ���?
			if (f.MatType.value == "") {
				alert("��ü������ ������ �ּ���");
				f.MatType.focus();
				return;
			} else if (f.SendWay.value == "") {
				alert("�߼۹���� ������ �ּ���");
				f.SendWay.focus();
				return;
			} else if (f.AnsOpin.value == "") {
				//alert("�����ǰ��� �Է��� �ּ���");
				f.AnsOpin.value = "���� �ǰ� ����";
				//return;
			}
		} else if (ansType == "<%= CodeConstants.ANS_MTD_NONE %>") { // �ش����� �ƴѰ���?
			if (f.AnsOpin.value == "") {
				//alert("�����ǰ��� �Է��� �ּ���");
				f.AnsOpin.value = "���� �ǰ� ����";
				//return;
			}
		}

		if (confirm("�ۼ��Ͻ� �亯 �ڷḦ ����Ͻðڽ��ϱ�?")) {
		formName.count.value = numRef;
		if (formName.AnsType.value == "<%= CodeConstants.ANS_MTD_ELEC %>") {
			//document.all.loadingDiv.style.display = '';
			formName.action = "/reqsubmit/common/AnsInfoWriteAllInOneProcPopup_old.jsp";
			formName.encoding="multipart/form-data";
			formName.target = 'processingFrame';
			formName.submit();
		} else {
			formName.target = 'processingFrame';
			formName.MatTypeNew.value = formName.MatType.value;
			formName.SendWayNew.value = formName.SendWay.value;
			formName.AnsTypeNew.value = formName.AnsType.value;
			formName.action = "/reqsubmit/common/AnsInfoWriteAllInOneProc_old.jsp";
			//document.all.loadingDiv.style.display = '';
			formName.submit();
		}
	}

		//formName.encoding="multipart/form-data";
		//formName.action = "AnsInfoWriteAllInOneProc.jsp";
		//formName.target = 'processingFrame';
		//formName.submit();
	}

	function datechange(){
		formName.SubmtDln.focus();
		formName.SubmtDln.value = formName.reqdate.value;
	}

</script>

</head>

<BODY leftmargin="0" topmargin="0">
<iframe name='processingFrame' height='0' width='0'></iframe>
<FORM method="post" name="formName">
	<CENTER>
	<table border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td height="35" align="center" bgcolor="#f4f4f4" width="800">
				<font style="font-size:18px;color:darkblue;font-family:HY������M"><%= strTitle %></font>
			</td>
		</tr>
		<tr>
			<td height="1" bgcolor="#c0c0c0"></td>
		</tr>
		<tr>
			<td height="10"></td>
		</tr>
		<tr>
			<td align="center" width="800">
<input type="hidden" name="AuditYear" value="">
<input type="hidden" name="ReqScheID" value="<%= strReqScheID %>">
<input type="hidden" name="IngStt" value="006">
<input type="hidden" name="SubmtOrganID">
<input type="hidden" name="SubmtOrganNM">
<input type="hidden" name="FLAG" value="">
<input type="hidden" name="FLAG2" value="">

<input type="hidden" name="ReqBoxTp" value="005">
<input type="hidden" name="PdfFilePath" value="">
<input type="hidden" name="DocFilePath" value="">
<input type="hidden" name="MatTypeNew" value="">
<input type="hidden" name="SendWayNew" value="">
<input type="hidden" name="AnsTypeNew" value="">
<input type="hidden" name="OpenCL" value="<%= CodeConstants.OPN_CL_CLOSE %>">
<input type="hidden" name="AnsFileID" value="">
<input type="hidden" name="PdfFileName" value="">
<input type="hidden" name="OriginFileName" value="">
<input type="hidden" name="MsgDigest" value="">
<input type="hidden" name="UserDN" value="<%=strUserDN%>">
<input type="hidden" name="user_dn" value="">
<input type="hidden" name="count" value="">
<input type="hidden" name="OrgRealFileName" value="">
<input type="hidden" name="PdfRealFileName" value="">
				<!----------------------------------------------- TABLE START ---------------------------------------------------->
				<table border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td width="380" height="23">
							<img src="/image/common/icon_reqsubmit_soti.gif"> ���� ��� : <B style="color:darkblue"><%= strOrgnaNM %></B>
						</td>
						<%if (objUserInfo.getUserID().equals("0000039924")){%>
							<td width="380" height="23" style="cursor:hand;" align="right" onclick="javascript:document.location.href='AnsInfoWriteAllInOne2.jsp';">
								<b>[��뷮 ���ϵ��]</b>
							</td>
						<%} else {%>
							<td width="380" height="23" style="cursor:hand;" align="right" onclick="javascript:document.location.href='AnsInfoWriteAllInOne.jsp';">
								<b>[��뷮 ���ϵ��]</b>
							</td>
						<%}%>
					</tr>
				</table>

				<table border="0" cellpadding="0" cellspacing="0" style="border:1px solid #c0c0c0">
					<tr>
						<td width="100">
							&nbsp;&nbsp;<img src="/image/common/icon_reqsubmit_soti.gif"> ȸ�� :
						</td>
						<td width="280" colspan="3">
							�� <input type="text" value="<%=SessionNo2%>" name="NatCnt" size="3" maxLength="3" onKeyUp="CheckNumeric()"> ȸ ��ȸ
						</td>
					</tr>
					<tr>
						<td colspan="4" height="1" bgcolor="#c0c0c0"></td>
					</tr>
					<tr>
						<td height="25">&nbsp;&nbsp;<img src="/image/common/icon_reqsubmit_soti.gif"> �������� :
						</td>
						<td colspan="3">
							<select name="RltdDutyX">
								<option value="">����</option>
								<option value="001" <%if(strRltdDutyX.equals("001")){%>selected<%}%>>��������</option>
								<option value="002" <%if(strRltdDutyX.equals("002")){%>selected<%}%>>��������</option>
								<option value="004" <%if(strRltdDutyX.equals("004")){%>selected<%}%>>���</option>
								<option value="005" <%if(strRltdDutyX.equals("005")){%>selected<%}%>>���</option>
								<option value="006" <%if(strRltdDutyX.equals("006")){%>selected<%}%>>����</option>
								<option value="003" <%if(strRltdDutyX.equals("003")){%>selected<%}%>>�����</option>
								<option value="007" <%if(strRltdDutyX.equals("007")){%>selected<%}%>>��Ÿ(�ӽ�ȸ ��)</option>
							</select>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/image/common/icon_reqsubmit_soti.gif"> ������ �ڷ�䱸 ����
							<select name="AnsDuty">
								<option value="">����</option>
								<option value="001" <%if(strAnsDuty.equals("001")){%>selected<%}%>>��ȭ</option>
								<option value="002" <%if(strAnsDuty.equals("002")){%>selected<%}%>>e-����</option>
								<option value="003" <%if(strAnsDuty.equals("003")){%>selected<%}%>>�ѽ�</option>
								<option value="004" <%if(strAnsDuty.equals("004")){%>selected<%}%>>����</option>
								<option value="005" <%if(strAnsDuty.equals("005")){%>selected<%}%>>��Ÿ</option>

							</select>
						</td>

					</tr>
					<tr>
						<td colspan="4" height="1" bgcolor="#c0c0c0"></td>
					</tr>
					<tr>
						<td height="25">&nbsp;&nbsp;<img src="/image/common/icon_reqsubmit_soti.gif"> �䱸���� :
						</td>
						<td width="200">
							<input type="text" class="textfield" name="reqdate" size="10" maxlength="8" value="<%=strReqDate%>"  OnClick="this.select()"
						OnKeyPress="if ((event.keyCode&lt;48)||(event.keyCode&gt;57)) event.returnValue=false;" OnBlur="javascript:SetFormatDate(this);" Onfocus="javascript:datechange();">&nbsp;&nbsp;
						<img src="/image/button/bt_viewCalendar.gif" border="0" style="cursor:hand"  OnClick="javascript:show_calendar('formName.reqdate');" align="absmiddle">
						</td>
						<td height="25">&nbsp;&nbsp;<img src="/image/common/icon_reqsubmit_soti.gif"> ������� :
						</td>
						<td>
							<input type="text" class="textfield" name="SubmtDln" size="10" maxlength="8" value="<%=strSubmtDln%>"  OnClick="this.select()"
						OnKeyPress="if ((event.keyCode&lt;48)||(event.keyCode&gt;57)) event.returnValue=false;" OnBlur="javascript:SetFormatDate(this);">&nbsp;&nbsp;
						<img src="/image/button/bt_viewCalendar.gif" border="0" style="cursor:hand"  OnClick="javascript:show_calendar('formName.SubmtDln');" align="absmiddle">
						</td>

					</tr>
					<tr>
						<td colspan="4" height="1" bgcolor="#c0c0c0"></td>
					</tr>
					<tr>
						<td width="100" height="25">&nbsp;&nbsp;<img src="/image/common/icon_reqsubmit_soti.gif"> �Ұ� ����ȸ :
						</td>
						<td width="660" colspan="3">

								<select name="CmtOrganID" onChange="searchSubmit()">
									<option value="">::::����ȸ�� �������ּ���:::</option>
									<%while(objOrganRs.next()){%>
									<option value="<%=objOrganRs.getObject("ORGAN_ID")%>" <%if(tempCmtOrganID.equals(objOrganRs.getObject("ORGAN_ID"))){%> selected <%}%>>
									<%=objOrganRs.getObject("ORGAN_NM")%></option>
									<%}%>
								</select>
						</td>
					</tr>
					<tr>
						<td colspan="4" height="1" bgcolor="#c0c0c0"></td>
					</tr>
					<tr>
						<td width="100" height="25">&nbsp;&nbsp;<img src="/image/common/icon_reqsubmit_soti.gif"> �ǿ��� :
						</td>
						<td width="660" colspan="3">

								<select name="ReqOrganID" onChange="searchReqUserId()">
									<option value="">:::�ǿ����� �������ּ���:::</option>
									<%if(objSelectOrganRs != null && objSelectOrganRs.getTotalRecordCount() > 0){%>
									<%while(objSelectOrganRs.next()){
									%>
									<option value="<%=objSelectOrganRs.getObject("ORGAN_ID")%>^<%=objSelectOrganRs.getObject("ORGAN_NM")%>" <%if(strReqOrganId.equals(objSelectOrganRs.getObject("ORGAN_ID"))){%> selected <%}%>>
									<%=objSelectOrganRs.getObject("ORGAN_NM")%></option>
									<%}%>
									<%}%>
								</select>
								&nbsp;&nbsp;&nbsp;&nbsp;
								<select name="RegrID">
									<option value="">:::����ڸ� �������ּ���:::</option>
									<%if(objSelectUser != null && objSelectUser.getTotalRecordCount() > 0){%>
									<%while(objSelectUser.next()){
									%>
									<option value="<%=objSelectUser.getObject("USER_ID")%>" <%if(strReqOrganId.equals(objSelectUser.getObject("USER_ID"))){%> selected <%}%>>
									<%=objSelectUser.getObject("USER_NM")%> <%=objSelectUser.getObject("GRD_NM")%></option>
									<%}%>
									<%}%>
								</select>

						</td>
					</tr>
				</table>

				<br>

				<!--
				### Sample ###
				<iframe frameborder="0" height="300" marginheight="0" marginwidth="0" scrolling="no"
				src="./notice.cgi" width="100%" topmargin="0"></iframe>
				-->

				<table border="0" cellpadding="0" cellspacing="0" style="border:1px solid #c0c0c0">
					<tr>
						<td width="100">&nbsp;&nbsp;<img src="/image/common/icon_reqsubmit_soti.gif"> �䱸�� : </td><td width="660"><input type="text" name="ReqCont" size="80"></td>
					</tr>
					<tr>
						<td colspan="4" height="1" bgcolor="#c0c0c0"></td>
					</tr>
					<tr>
						<td>&nbsp;&nbsp;<img src="/image/common/icon_reqsubmit_soti.gif"> �䱸���� : </td><td><textarea name="ReqDtlCont" rows="9" cols="80"></textarea></td>
					</tr>
					<tr>
						<td colspan="4" height="1" bgcolor="#c0c0c0"></td>
					</tr>
				</table>
				<br>
				<table border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td><font style="font-size:18px;color:darkblue;font-family:HY������M">�亯 ���</font></td>
					</tr>
				</table>

				<table border="0" cellpadding="0" cellspacing="0" style="border:1px solid #c0c0c0">
					<tr>
                      <td width="100" height="25" class="td_gray1">&nbsp;&nbsp;<img src="/image/common/icon_reqsubmit_soti.gif"> �亯���� : </td>
                      <td width="660" height="25" class="td_lmagin"><select name="AnsType" onChange="javascript:changeInputForm(this.value)" class="select">
								<option value="<%= CodeConstants.ANS_MTD_ELEC %>"><%= CodeConstants.getAnswerMethod(CodeConstants.ANS_MTD_ELEC) %></option>
								<option value="<%= CodeConstants.ANS_MTD_ETCS %>"><%= CodeConstants.getAnswerMethod(CodeConstants.ANS_MTD_ETCS) %></option>
							</select></td>
                    </tr>
					<tr>
						<td colspan="4" height="1" bgcolor="#c0c0c0"></td>
					</tr>
					<tr>
						<td>&nbsp;&nbsp;<img src="/image/common/icon_reqsubmit_soti.gif"> �亯���� : </td>
						<td>
							<DIV id="inputDiv" style="position:relative; left:0px;top:0px;width:460; border-width:0px; border-style:none;">
						<table border="0" cellpadding="0" cellspacing="0">
            				<tr>
								<td width="80" height="20" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6">
								���� ����</td>
								<td width="320" height="20" class="td_lmagin"><input type="file" class="textfield" name="OriginFile0" size="30"></td>
								<td width="60" align="center"><a href="javascript:submitbutton()"><img src="/image/button/bt_add_admin.gif" border="0"></a></td>
							</tr>
							<tr height="1" class="tbl-line">
								<td height="1" colspan="3">
							</tr>
							<tr>
								<td height="20" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6">
									PDF ����</td>
								<td height="20" class="td_lmagin"><input type="file" class="textfield" name="PdfFile0" size="30"></td>
								<td align="center">&nbsp;</td>
								</tr>
								<tr height="1" class="tbl-line">
									<td height="1" colspan="3">
								</tr>
        					</table>
						</DIV>
						<span id="filesubmit"></span><span id="filesubmit"></span>
						<span id="filesubmit"></span><span id="filesubmit"></span><span id="filesubmit"></span>
						</td>
					</tr>
					<tr>
						<td colspan="4" height="1" bgcolor="#c0c0c0"></td>
					</tr>
					<tr>
						<td>&nbsp;&nbsp;<img src="/image/common/icon_reqsubmit_soti.gif"> �����ǰ� : </td><td><textarea name="AnsOpin" rows="9" cols="80"></textarea></td>
					</tr>
				</table>


				<!----------------------------------------------- TABLE END ---------------------------------------------------->
				<p>
				<input type="button" value="�䱸�� ����" class="button" onClick="checkFormData()">&nbsp;&nbsp;<input type="button" value="�ʱ�ȭ" class="button" onClick="document.formName.reset()">
				&nbsp;&nbsp;<input type="button" value="�ۼ� ���" class="button" onClick="self.close()">
				<p><br></p>
			</td>
		</tr>
	</table>
	</CENTER>

</FORM>

</BODY>
</html>
