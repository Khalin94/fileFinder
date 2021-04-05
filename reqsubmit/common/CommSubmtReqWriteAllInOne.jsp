<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.all.ReqInfoAllInOneDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.CommRequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.cmtsubmt.*" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	UserInfoDelegate objUserInfo = null;
	CDInfoDelegate objCdinfo = null;
%>

<%@ include file="../common/RUserCodeInfoInc.jsp" %>

<%
	String strUserID   = objUserInfo.getUserID();
	String strOrganID  = objUserInfo.getOrganID();
	String strOrgnaNM  = "";
	
	String strAuditYear = StringUtil.getEmptyIfNull(request.getParameter("AuditYear"));
	String CmtOrganID = StringUtil.getEmptyIfNull(request.getParameter("CmtOrganIDX"));
	String strRltdDuty = StringUtil.getEmptyIfNull(request.getParameter("RltdDuty"));
	String[] SubSelectID = request.getParameterValues("SubSelectID");/**  ���õ� ������ ����Ʈ  */

	ResultSetSingleHelper objRsSH = null;	/** �䱸���� ���� ��¿�  ResultSetSingleHelper*/
	ResultSetHelper objSubmtOrganRs = null;  /** ������ ����Ʈ ��¿� ResultSetHelper */
	ResultSetHelper objRltdDutyRs = null;   /** ���ñ�� ����Ʈ ��¿� RsHelper */
	ResultSetHelper objOrganRs = null;	
	ResultSetHelper objSelectOrganRs = null;

	CommRequestBoxDelegate objReqBox = null;
	ReqInfoAllInOneDelegate objReqAllOne = null;
	OrganInfoDelegate objOrganInfo = null;
	CmtSubmtReqBoxDelegate objCmtSubmt = null;

	try{
		/********* �븮�� ���� ���� *********/
		objReqBox = new CommRequestBoxDelegate(); 		/**�䱸�� Delegate*/
		objReqAllOne = new ReqInfoAllInOneDelegate();
		objOrganInfo = new OrganInfoDelegate();   /** ������� ��¿� �븮�� */
		
		// �䱸�����ڵ������� üũ�ϱ� ���ؼ� �߰��Ǵ� Delegate
		objCmtSubmt = new CmtSubmtReqBoxDelegate();
		
		// 2005-09-14 kogaeng ADD
		// ������ ��ü ����ȸ ����� ��ȸ�ϰ� �� �� ���� ����ȸ�� �����ϴ� ���̾�����
		// ����ȸ ���� ��û�� Ư�� �� �Ҽ� ����ȸ�� ������ �����Ѵ�.
		/*
		if(CmtOrganID.equals("")) {
			objOrganRs = new ResultSetHelper(objUserInfo.getCurrentCMTList());
			if(objOrganRs.next()) CmtOrganID=(String)objOrganRs.getObject("ORGAN_ID");
		}
		objOrganRs = new ResultSetHelper(objReqAllOne.getReqOrganChart());
		*/
		objOrganRs = new ResultSetHelper(objUserInfo.getCurrentCMTList());   /** �Ҽ� ����ȸ */
		if(!StringUtil.isAssigned(CmtOrganID) && objOrganRs.next()) CmtOrganID=(String)objOrganRs.getObject("ORGAN_ID");
   
		strOrgnaNM = objReqAllOne.getOrganNM(strOrganID);
		/********* ���������� **************/
		String FLAG = StringUtil.getEmptyIfNull(request.getParameter("FLAG"));
		objSubmtOrganRs=new ResultSetHelper(objOrganInfo.getSubmtOrganList(CmtOrganID));/**����������Ʈ*/
		
		if(FLAG.equals("select")){
			if(SubSelectID != null) objSelectOrganRs =new ResultSetHelper(objOrganInfo.getSubmtOrganList2(SubSelectID));/** ���õ�����������Ʈ*/
		}
	
		objRltdDutyRs=new ResultSetHelper(objCdinfo.getRelatedDutyList()); 
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
<title>����ȸ ���� ��û�� �ۼ� - All In One</title>

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
<script language="javascript">
    var singleSelect = true; 
	var sortSelect = true; 
	var sortPick = true; 

	function initIt() {
		var SubOrganID = document.getElementById("SubOrganID");
		var selectOptions = SubOrganID.options;
		var selectIndex = SubOrganID.selectedIndex;
		var SubSelectID = document.getElementById("SubSelectID");
		var pickOptions = SubSelectID.options;
		pickOptions[0] = null; 
		if (!(selectIndex > -1)) {
			selectOptions[0].selected = true;
			selectOptions[0].defaultSelected = true;
		}
		SubOrganID.focus();
	}
	function checkdata(){
		var SubOrganID = document.getElementById("SubOrganID");
		var selectedLength = SubOrganID.length;
		var selectOptions = SubOrganID.options;
		var SubSelectID = document.getElementById("SubSelectID");
		var pickOptions = SubSelectID.options;
		var pickOLength = pickOptions.length;
		for(var i = 0 ;i < pickOLength;i++ ){
			for(var j = 0; j < selectedLength;j++){
				if(selectOptions[j].selected == true){
					if(pickOptions[i].value == selectOptions[j].value){
					alert(pickOptions[i].text+"����� �̹� �����ϼ̽��ϴ�.");
					selectOptions[j].selected = false;
					}
				}
			}
		}
	}
	function addIt() {
		checkdata();
		var SubOrganID = document.getElementById("SubOrganID");
		var selectIndex = SubOrganID.selectedIndex;
		var selectOptions = SubOrganID.options;
		var SubSelectID = document.getElementById("SubSelectID");
		var pickOptions = SubSelectID.options;
		var pickOLength = pickOptions.length;
		while (selectIndex > -1) {
			pickOptions[pickOLength] = new Option(SubOrganID[selectIndex].text);
			pickOptions[pickOLength].value = SubOrganID[selectIndex].value;
			if (singleSelect) {
				selectOptions[selectIndex] = null;
			}
			if (sortPick) {
				var tempText;
				var tempValue;
				while (pickOLength > 0 && pickOptions[pickOLength].value < pickOptions[pickOLength-1].value) {
					tempText = pickOptions[pickOLength-1].text;
					tempValue = pickOptions[pickOLength-1].value;
					pickOptions[pickOLength-1].text = pickOptions[pickOLength].text;
					pickOptions[pickOLength-1].value = pickOptions[pickOLength].value;
					pickOptions[pickOLength].text = tempText;
					pickOptions[pickOLength].value = tempValue;
					pickOLength = pickOLength - 1;
				}
			}
		selectIndex = SubOrganID.selectedIndex;
		pickOLength = pickOptions.length;
		}
		//selectOptions[0].selected = true;
	}

	function delIt() {
		var SubOrganID = document.getElementById("SubOrganID");
		var selectOptions = SubOrganID.options;
		var selectOLength = selectOptions.length;
		var SubSelectID = document.getElementById("SubSelectID");
		var pickIndex = SubSelectID.selectedIndex;
		var pickOptions = SubSelectID.options;
		while (pickIndex > -1) {
			if (singleSelect) {
				selectOptions[selectOLength] = new Option(SubSelectID[pickIndex].text);
				selectOptions[selectOLength].value = SubSelectID[pickIndex].value;
			}
			pickOptions[pickIndex] = null;
			if (singleSelect && sortSelect) {
				var tempText;
				var tempValue;
				while (selectOLength > 0 && selectOptions[selectOLength].value < selectOptions[selectOLength-1].value) {
					tempText = selectOptions[selectOLength-1].text;
					tempValue = selectOptions[selectOLength-1].value;
					selectOptions[selectOLength-1].text = selectOptions[selectOLength].text;
					selectOptions[selectOLength-1].value = selectOptions[selectOLength].value;
					selectOptions[selectOLength].text = tempText;
					selectOptions[selectOLength].value = tempValue;
					selectOLength = selectOLength - 1;
				}
			}
		pickIndex = SubSelectID.selectedIndex;
		selectOLength = selectOptions.length;
		}
	}

	function selIt(btn) {
		var SubSelectID = document.getElementById("SubSelectID");
		var pickOptions = SubSelectID.options;
		var pickOLength = pickOptions.length;
		if (pickOLength < 1) {
			alert("No Selections in the SubSelectID\nPlease Select using the [->] button");
			return false;
		}
		for (var i = 0; i < pickOLength; i++) {
			pickOptions[i].selected = true;
		}
		return true;
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

	function showPeriodDiv() {
		document.all.PeriodDIV.style.left = "400px";
		document.all.PeriodDIV.style.top = "108px";
		document.all.PeriodDIV.style.display = '';
		document.formName.AddDate.focus();
	}

	function hiddenPeriodDiv() {
		document.formName.AddDate.value = "";
		document.all.PeriodDIV.style.display = 'none';
	}

	function closeWindows() {
		if(confirm("���� â�� �ݰ� �Ǹ� �۾� ���̴� ��� ������ �Ұ� �˴ϴ�. ��� �����Ͻðڽ��ϱ�?")) {
			self.close();
		}
	}

	var numRef = 0;
	function AddReqInfoForm() {
		var str;
		if (numRef > 100) {
			alert("���̻� �Է¶��� �߰��Ͻ� �� �����ϴ�.");
		}else{
			str = "<table border=\"0\" cellpadding=\"0\" cellspacing=\"1\">";
			str = str + "<tr>";
			str = str + "<td width=\"30\" rowspan=\"3\" align=\"center\" bgcolor=\"steelblue\"><B style=\"color:white\">"+(numRef+2)+"</B></td>";
			str = str + "<td width=\"60\" bgcolor=\"#f4f4f4\" align=\"center\" style=\"border:1px solid #c0c0c0\"><b>�䱸����</b></td>";
			str = str + "<td width=\"415\" valign=\"top\"><input type=\"text\" size=\"64\" name=\"ReqInfoTitle"+(numRef+1)+"\" onKeyDown=\"if(event.keyCode==13) event.keyCode=9;\" class=\"input2\" style=\"font:bold\"></td>";
			str = str + "<td width=\"30\" rowspan=\"2\" align=\"center\" valign=\"top\">";
			str = str + "<input type=\"button\" value=\"����\" tabindex=\"-1\" class=\"button\" onClick=\"DelReqInfoForm("+(numRef)+")\" style=\"height:21px\"></td>";
			str = str + "</tr>";
			str = str + "<tr>";
			str = str + "<td bgcolor=\"#f4f4f4\" align=\"center\" style=\"border:1px solid #c0c0c0\"><b>�䱸����</b></td>";
			str = str + "<td colspan=\"2\" valign=\"top\"><textarea cols=\"72\" rows=\"6\" name=\"ReqInfoDesc"+(numRef+1)+"\"";
			str = str + " onKeyDown=\"javascript:updateChar(document.formName, 'ReqInfoDesc"+(numRef+1)+"', '4000', 'textlimit"+(numRef+1)+"')\" onKeyUp=\"javascript:updateChar(document.formName, 'ReqInfoDesc"+(numRef+1)+"', '4000', 'textlimit"+(numRef+1)+"')\" onFocus=\"javascript:updateChar(document.formName, 'ReqInfoDesc"+(numRef+1)+"', '4000', 'textlimit"+(numRef+1)+"')\" onClick=\"javascript:updateChar(document.formName, 'ReqInfoDesc"+(numRef+1)+"', '4000', 'textlimit"+(numRef+1)+"')\"";
			str = str + "></textarea>";
			str = str + "<table border='0' cellpadding='0' cellspacing='0'><tr><td width='400' style=\"padding-left:5px\">";
			str = str + "<input type='text' name='textlimit"+(numRef+1)+"' size='4' style=\"border:0px solid #ffffff; font-family:verdana,����; font-size:11px;font-weight:bold;\"> bytes (4000 bytes ������ �Էµ˴ϴ�) ";
			str = str + "</td></tr></table>";
			str = str + "</td></tr>";
			str = str + "<tr>";
			str = str + "<td bgcolor='#f4f4f4' align='center' style=\"border:1px solid #c0c0c0;padding-top:4px;padding-bottom:4px\">";
			str = str + "<b>������<BR>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</b></td>";
			str = str + "<td colspan='2'><input type='file' size='55' name='AnsEstyleFilePath"+(numRef+1)+"' class='input2'></tr>";
			str = str + "</table>";
			
			document.all.divReqInfo[numRef].innerHTML=str;
			var strtitle = eval("document.formName.ReqInfoTitle"+(numRef+1));
			document.formName.submitbutton.focus();
			strtitle.focus();
			numRef++;
		}
		
	}

	function DelReqInfoForm(num){
		document.all.divReqInfo[num].innerHTML="";
		numRef--;
	}
	function searchSubmit(){
		//var strOrganID = document.formName.CmtOrganID.value;
		//document.formName.target = "OrganFrame";
		//document.formName.action = "/reqsubmit/common/OrganSelect.jsp?CmtOrganID="+strOrganID;
		document.formName.FLAG.value="select";
		for(var j=0;j<formName.SubSelectID.options.length;j++){
		   formName.SubSelectID.options[j].selected=true;
		   //alert(formName.SubSelectID.options[j].value);
		}
		document.formName.submit();
		//document.formName.target = "";
	}
	function selectAll() {
		var SubOrganID = document.getElementById("SubOrganID");
		var selectOptions = SubOrganID.options;
		var selectOLength = selectOptions.length;
		for(var i=0 ; i<selectOLength; i++){
			selectOptions[i].selected = true;
		}
	}

	function checkFormData(){ 
  		var alertStr = "";
		var strValue = "";
		
		if(formName.ReqBoxNm.value.length == 0) {
			alert("��û�Ը��� �ʼ� �Է� ���Դϴ�.");
			formName.ReqBoxNm.focus();
			return;
		}
		
		for(var j=0;j<formName.SubSelectID.options.length;j++){
			   if(j == formName.SubSelectID.options.length-1){
					strValue = strValue+formName.SubSelectID.options[j].value;
			   }else{
					strValue = strValue+formName.SubSelectID.options[j].value+",";
			   }
			   
		}
		if(strValue == ""){
			alert("�������� �����Ͽ� �ֽʽÿ�.");
			return;
		}
	
		formName.ContentCount.value = numRef+1;
		var strTitle = "";
		var strContent = "";
		for(var j = 0 ; j < formName.ContentCount.value ; j++){
			tempTitle = eval("formName.ReqInfoTitle"+j);
			tempContent = eval("formName.ReqInfoDesc"+j);
			tempContLength = eval("formName.textlimit"+j);

			if(tempTitle.value == ""){
				alert((j+1)+"��° �䱸������ �ۼ��� �ֽʽÿ�.");
				return;
			}
			if(tempContent.value == ""){
				alert((j+1)+"��° �䱸������ �ۼ��� �ֽʽÿ�.");
				return;
			}

			if(getByteLength(tempTitle.value) > 1000) {
				alert((j+1)+"��° �䱸 ������ ���� �Է� ���� �ʰ��߽��ϴ�.\n\r�䱸 ������ �ѱ� 500 �� (1000bytes) �̻��� �Է��Ͻ� �� �����ϴ�.");
				return;
			}

			if(tempContLength > 4000) {
				alert((j+1)+"��° �䱸 ������ ���� �Է� ���� �ʰ��߽��ϴ�.\n\r�䱸 ������ �ѱ� 2000 �� (4000bytes) �̻��� �Է��Ͻ� �� �����ϴ�.");
				return;
			}
			
			if(j == formName.ContentCount.value-1){
				strTitle = strTitle + tempTitle.value;
				strContent = strContent + tempContent.value;
			}else{
				strTitle = strTitle + tempTitle.value+"��";
				strContent = strContent + tempContent.value+"��";
			}	
		}

		formName.TempTitle.value = strTitle;
		formName.TempContent.value = strContent;
		formName.SubmtOrganID.value = strValue;
		formName.encoding="multipart/form-data";
		formName.action = "/reqsubmit/common/CommSubmtReqWriteAllInOneProc.jsp";
		
		if(confirm("����ȸ �����û���� ����Ͻðڽ��ϱ�?")) formName.submit();
  }//endfunc

</script>

</head>

<BODY leftmargin="0" topmargin="0" onLoad="document.formName.ReqBoxNm.focus();">
<FORM method="post" name="formName" action="<%=request.getRequestURI()%>">
	<CENTER>
	<table border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td height="35" align="center" bgcolor="#f4f4f4" width="800">
				<font style="font-size:18px;color:darkblue;font-family:HY������M">����ȸ ���� ��û�� �ۼ�</font>
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
<input type="hidden" name="AuditYear" value="<%= strAuditYear %>"> 
<input type="hidden" name="ReqScheID" value="">     
<input type="hidden" name="IngStt" value="003">
<input type="hidden" name="SubmtOrganID">
<input type="hidden" name="ContentCount">
<input type="hidden" name="TempTitle">
<input type="hidden" name="TempContent">
<input type="hidden" name="FLAG" value="">
				<!----------------------------------------------- TABLE START ---------------------------------------------------->
				<table border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td width="380" height="23">
							<img src="/image/common/icon_reqsubmit_soti.gif"> �ǿ��� : <B style="color:darkblue"><%=strOrgnaNM%></B>
						</td>
						<td width="380" height="23">
							
						</td>
					</tr>
				</table>

				<table border="0" cellpadding="0" cellspacing="0" style="border:1px solid #c0c0c0">
					<tr>
						<td width="100">
							&nbsp;&nbsp;<img src="/image/common/icon_reqsubmit_soti.gif"> ��û�Ը� : 
						</td>
						<td width="660" height="24">
							<input type="text" value="" name="ReqBoxNm" size="80" class="input2" style="font-weight:bold">
						</td>

					</tr>
					<tr>
						<td colspan="2" height="1" bgcolor="#c0c0c0"></td>
					</tr>
					<tr>
						<td height="25">&nbsp;&nbsp;<img src="/image/common/icon_reqsubmit_soti.gif"> �������� : 
						</td>
						<td>
							<select name="RltdDuty">
								<option value="001" <%if(strRltdDuty.equals("001")){%>selected<%}%>>��������</option>
								<option value="002" <%if(strRltdDuty.equals("002")){%>selected<%}%>>��������</option>
								<option value="004" <%if(strRltdDuty.equals("004")){%>selected<%}%>>���</option>
								<option value="005" <%if(strRltdDuty.equals("005")){%>selected<%}%>>���</option>
								<option value="006" <%if(strRltdDuty.equals("006")){%>selected<%}%>>����</option>
								<option value="003" <%if(strRltdDuty.equals("003")){%>selected<%}%>>�����</option>
								<option value="007" <%if(strRltdDuty.equals("007")){%>selected<%}%>>��Ÿ(û��ȸ ��)</option>
							</select>
						</td>
					</tr>
					<tr>
						<td colspan="2" height="1" bgcolor="#c0c0c0"></td>
					</tr>
					<tr>
						<td width="100" height="25">&nbsp;&nbsp;<img src="/image/common/icon_reqsubmit_soti.gif"> �Ұ� ����ȸ : 
						</td>
						<td width="660">
							<select name="CmtOrganIDX" onChange="searchSubmit()">
								<%
									while(objOrganRs.next()) { 
										if(!objCmtSubmt.checkCmtOrganMakeAutoSche((String)objOrganRs.getObject("ORGAN_ID"))) {
								%>
									<option value="<%=objOrganRs.getObject("ORGAN_ID")%>" <%if(CmtOrganID.equals(objOrganRs.getObject("ORGAN_ID"))){%> selected <%}%>>
										<%=objOrganRs.getObject("ORGAN_NM")%>
									</option>
								<%
										}
									}
								%>
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
						<td width="190" height="25" bgcolor="#f4f4f4" align="center">������</td>
						<td width="1" bgcolor="#c0c0c0"></td>
						<td width="569" align="center" bgcolor="#f4f4f4" align="center">�䱸 ���</td>
					</tr>
					<tr>
						<td height="1" bgcolor="#c0c0c0" colspan="3"></td>
					</tr>
					<tr>
						<td width="190" height="25" valign="top" style="padding-top:10px;padding-bottom:10px">
							<!---------------------------- START ------------------------------>
							<!--
							<iframe src="OrganSelect.jsp" id="OrganFrame" name="OrganFrame" frameBorder="0" 
							height="80" marginheight="0" marginwidth="0" scrolling="auto" width="100%" topmargin="0"></iframe>
							-->
							&nbsp;
							<img src="/image/common/icon_reqsubmit_soti.gif">&nbsp;���������
							<br>
							&nbsp;<select name="SubOrganID" ID="SubOrganID" size="10" multiple="multiple" style="width:180px">
								<%if(objSubmtOrganRs != null){%>
									<%while(objSubmtOrganRs.next()){%>
										<option value="<%=objSubmtOrganRs.getObject("CMT_ORGAN_ID")%>^<%=objSubmtOrganRs.getObject("SUBMT_ORGAN_ID")%>">
										<%=objSubmtOrganRs.getObject("SUBMT_ORGAN_NM")%></option>
									<%}%>
								<%}%>
							</select>
							<br>
							&nbsp;
							<br>
							&nbsp;<a href="javascript:selectAll()"><img src="/image/button/bt_checkAll.gif" border="0"></a>
							<img src="/image/button/bt_add_admin.gif" width="38" height="18" onClick="addIt();" style="cursor:hand">
							<img src="/image/button/bt_cancel_admin.gif" width="38" height="18"  onClick="delIt();" style="cursor:hand">
							<br><br>&nbsp;
							<img src="/image/common/icon_reqsubmit_soti.gif">&nbsp;���õ����������
							<br>
							&nbsp;<select name="SubSelectID" ID="SubSelectID" size="10" multiple="multiple" style="width:180px">
								<%while(objSelectOrganRs!=null && objSelectOrganRs.next()){%>
									<option value="<%=objSelectOrganRs.getObject("CMT_ORGAN_ID")%>^<%=objSelectOrganRs.getObject("ORGAN_ID")%>">
									<%=objSelectOrganRs.getObject("ORGAN_NM")%></option>
								 <%}%>
							</select><br>
							<!--&nbsp;&nbsp; <input type="button" value="��� ����" class="button" onClick="selectSubmit()">-->
							<br><br>
							<!--
							<iframe src="SubmitOrganSelect.jsp" id="SubmitOrganFrame" name="SubmitOrganFrame" frameBorder="0" height="300" marginheight="0" marginwidth="0" scrolling="auto" width="100%" topmargin="0"></iframe>
							-->
						</td>
						<td width="1" bgcolor="#c0c0c0"></td>
						<td width="569" align="center" style="padding-top:10px;padding-bottom:10px" valign="top">
							<table border="0" cellpadding="0" cellspacing="1">
								<tr>
									<td width="30" rowspan="3" align="center" bgcolor="steelblue"><B style="color:white">1</B></td>
									<td width="60" bgcolor="#f4f4f4" align="center" style="border:1px solid #c0c0c0"><b>�䱸����</b></td>
									<td width="420" valign="top"><input type="text" size="72" name="ReqInfoTitle0" onKeyDown="if(event.keyCode==13) event.keyCode=9;"  class="input2" style="font:bold"></td>
								</tr>
								<tr>
									<td bgcolor="#f4f4f4" align="center" style="border:1px solid #c0c0c0"><b>�䱸����</b></td>
									<td valign="top"><textarea cols="72" rows="6" name="ReqInfoDesc0"  
                      		onKeyDown="javascript:updateChar(document.formName, 'ReqInfoDesc0', '4000', 'textlimit0')" 
                      		onKeyUp="javascript:updateChar(document.formName, 'ReqInfoDesc0', '4000', 'textlimit0')" 
                      		onFocus="javascript:updateChar(document.formName, 'ReqInfoDesc0', '4000', 'textlimit0')" 
                      		onClick="javascript:updateChar(document.formName, 'ReqInfoDesc0', '4000', 'textlimit0')"></textarea>
									<table border="0" cellpadding="0" cellspacing="0"><tr><td width="400" style="padding-left:5px">
									<input type="text" name="textlimit0" size="4" style="border:0px solid #ffffff; font-family:verdana,����; font-size:11px;font-weight:bold;" align="right"> bytes (4000 bytes ������ �Էµ˴ϴ�) 
									</td></tr></table>
								</td>
								</tr>
								<tr>
									<td bgcolor="#f4f4f4" align="center" style="border:1px solid #c0c0c0;padding-top:4px;padding-bottom:4px"><b>������<BR>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</b></td>
									<td><input type="file" size="55" name="AnsEstyleFilePath0" class="input2">
								</tr>
							</table>
							 <span id="divReqInfo"></span><span id="divReqInfo"></span>
							 <span id="divReqInfo"></span><span id="divReqInfo"></span>
							 <span id="divReqInfo"></span><span id="divReqInfo"></span>
							 <span id="divReqInfo"></span><span id="divReqInfo"></span>
							 <span id="divReqInfo"></span><span id="divReqInfo"></span>
							 <span id="divReqInfo"></span><span id="divReqInfo"></span>
							 <span id="divReqInfo"></span><span id="divReqInfo"></span>
							 <span id="divReqInfo"></span><span id="divReqInfo"></span>
							 <span id="divReqInfo"></span><span id="divReqInfo"></span>
							 <span id="divReqInfo"></span><span id="divReqInfo"></span>
							 <span id="divReqInfo"></span><span id="divReqInfo"></span>
							 <span id="divReqInfo"></span><span id="divReqInfo"></span>
							 <span id="divReqInfo"></span><span id="divReqInfo"></span>
							 <span id="divReqInfo"></span><span id="divReqInfo"></span>
							 <span id="divReqInfo"></span><span id="divReqInfo"></span>
							 <span id="divReqInfo"></span><span id="divReqInfo"></span>
							 <span id="divReqInfo"></span><span id="divReqInfo"></span>
							 <span id="divReqInfo"></span><span id="divReqInfo"></span>
							 <span id="divReqInfo"></span><span id="divReqInfo"></span>
							 <span id="divReqInfo"></span><span id="divReqInfo"></span>
							 <span id="divReqInfo"></span><span id="divReqInfo"></span>
							 <span id="divReqInfo"></span><span id="divReqInfo"></span>
							 <span id="divReqInfo"></span><span id="divReqInfo"></span>
							 <span id="divReqInfo"></span><span id="divReqInfo"></span>
							 <span id="divReqInfo"></span><span id="divReqInfo"></span>
							 <span id="divReqInfo"></span><span id="divReqInfo"></span>
							 <span id="divReqInfo"></span><span id="divReqInfo"></span>
							 <span id="divReqInfo"></span><span id="divReqInfo"></span>
							 <span id="divReqInfo"></span><span id="divReqInfo"></span>
							 <span id="divReqInfo"></span><span id="divReqInfo"></span>
							 <span id="divReqInfo"></span><span id="divReqInfo"></span>
							 <span id="divReqInfo"></span><span id="divReqInfo"></span>
							 <span id="divReqInfo"></span><span id="divReqInfo"></span>
							 <span id="divReqInfo"></span><span id="divReqInfo"></span>
							 <span id="divReqInfo"></span><span id="divReqInfo"></span>
							 <span id="divReqInfo"></span><span id="divReqInfo"></span>
							 <span id="divReqInfo"></span><span id="divReqInfo"></span>
							 <span id="divReqInfo"></span><span id="divReqInfo"></span>
							 <span id="divReqInfo"></span><span id="divReqInfo"></span>
							 <span id="divReqInfo"></span><span id="divReqInfo"></span>
							<div align="left">
							&nbsp;&nbsp;<img src="/image/common/icon_exclam_mark.gif"> �䱸������ �ѱ� 500�� �̳�, �䱸 ������ �ѱ� 2000�� ���� �Է� �����մϴ�.<br>
							&nbsp;&nbsp;<input name="submitbutton" type="button" value="�䱸 �߰�" class="button" onClick="AddReqInfoForm()" style="height:23px"></div>
						</td>
					</tr>
					<tr>
						<td height="1" bgcolor="#c0c0c0" colspan="3"></td>
					</tr>
					<!--
					<tr> 
                      <td height="25" bgcolor="#f4f4f4" align="center">�����Ļ���</td>
					  <td width="1" bgcolor="#c0c0c0"></td>
                      <td height="25" align="center" colspan="3">	
                      	<input type="file" name="AnsEstyleFilePath" size="70"  class="textfield">
					  </td>
                    </tr>
					<tr>
						<td height="1" bgcolor="#c0c0c0" colspan="3"></td>
					</tr>
					-->
					<!--
					<tr>
                      <td height="25" bgcolor="#f4f4f4" align="center">��������</td>
					  <td width="1" bgcolor="#c0c0c0"></td>
                      <td height="25" align="left" colspan="3">
					    &nbsp;&nbsp;&nbsp;&nbsp;
                      	<input type="radio" name="OpenCL" value="001">����
						<input type="radio" name="OpenCL" value="002" checked>�����
						&nbsp;&nbsp;<img src="/image/common/icon_exclam_mark.gif" border="0">
						�䱸 ������ Ÿ �ǿ��ǿ� �������� ���θ� �����ϴ� ����Դϴ�.
					  </td>
                   </tr>
                   -->
				</table>
				<!----------------------------------------------- TABLE END ---------------------------------------------------->
				<p>
				<input type="button" value="��û�� ����" class="button" onClick="checkFormData()">&nbsp;&nbsp;<input type="button" value="�ʱ�ȭ" class="button" onClick="document.formName.reset()">
				&nbsp;&nbsp;<input type="button" value="�ۼ� ���" class="button" onClick="closeWindows()">
				<p><br></p>
			</td>
		</tr>
	</table>
	</CENTER>

</FORM>

</BODY>
</html>