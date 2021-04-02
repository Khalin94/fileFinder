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
	// 요구함의 종류에 따라서 입력정보와 전환될 URL이 달라야 한다.
	String strReqBoxTp = StringUtil.getEmptyIfNull(request.getParameter("ReqBoxTp"), "001");
	String strReqScheID = StringUtil.getEmptyIfNull(request.getParameter("ReqScheID"));

	String strTitle = "요구자료 등록";
	String strAction = "/reqsubmit/common/ReqInfoWriteAllInOneProc_old.jsp";
	if(CodeConstants.REQ_BOX_TP_CMT.equals(strReqBoxTp)) {
		strTitle = "위원회 요구함 작성";
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

	//String[] SubSelectID = request.getParameterValues("SubSelectID");/**  선택된 제출기관 리스트  */


	System.out.println("CMT ::: "+CmtOrganID);

	//겸직정보를 가져온다.

	ResultSetSingleHelper objRsSH=null;	/** 요구일정 정보 출력용  ResultSetSingleHelper*/
	ResultSetHelper objSubmtOrganRs=null;  /** 제출기관 리스트 출력용 ResultSetHelper */
	ResultSetHelper objRltdDutyRs=null;   /** 관련기관 리스트 출력용 RsHelper */
	ResultSetHelper objOrganRs = null;
	ResultSetHelper objSelectOrganRs = null;
	ResultSetHelper objSelectUser = null;
	Hashtable objhashdata4 = null;
	String SessionNo2 = "";

	try {
	   	/********* 대리자 정보 설정 *********/
		CommRequestBoxDelegate objReqBox=new CommRequestBoxDelegate(); 		/**요구함 Delegate*/
	    ReqInfoAllInOneDelegate objReqAllOne = new ReqInfoAllInOneDelegate();
		OrganInfoDelegate objOrganInfo=new OrganInfoDelegate();   /** 기관정보 출력용 대리자 */

	    if(CmtOrganID.equals("")){
	   		/********* 값가져오기 **************/
	    	objOrganRs=new ResultSetHelper(objUserInfo.getCurrentCMTList());   /** 소속 위원회 */
	    	if(objOrganRs.next()) CmtOrganID=(String)objOrganRs.getObject("ORGAN_ID");
		}

		objOrganRs=new ResultSetHelper(objReqAllOne.getReqOrganChart());   /** 전체 위원회 */
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

		/********* 값가져오기 **************/

		//objSubmtOrganRs=new ResultSetHelper(objOrganInfo.getSubmtOrganList(CmtOrganID));/**제출기관리스트*/
		if(FLAG.equals("CHAT")){
			if(CmtOrganID != null) objSelectOrganRs =new ResultSetHelper(objReqBox.getReqOrganListData(CmtOrganID));/** 선택된 위원회관련 의원실리스트*/
		}

		if(FLAG2.equals("CHAT2")){
			if(strReqOrganId != null) objSelectUser =new ResultSetHelper(objReqAllOne.selectOrganUser(strReqOrganId));/** 선택된 위원회관련 의원실사용자리스트*/
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
<title>요구서 작성 - All In One</title>

<style>
	BODY, table, tr, td { font-family:Verdana, 돋움; font-size:11px; color:#585858; }
	form { margin:0px }
	a.hover { text-decoration: underline }
	SELECT { font-family:Verdana, 돋움; font-size:11px; background-color:#f1f1f1; color:#585858; }
	BUTTON { font-family:verdana,돋움; font-size:11px; border:0px solid #ffffff; background-color:white; cursor:hand; }
	.button { font-family:verdana, 돋움; font-size:11px; background-color:#E5E6FD; cursor:hand; }
	.buttonRect { font-family:verdana, 돋움; font-size:11px; background-color:#E5E6FD; cursor:hand; width:45px;height:45px; }
	.input { font-family:verdana, 돋움; font-size:11px; }
	.input2 { font-family:verdana, 돋움; font-size:11px; border:1px solid #909090;}
	INPUT { font-family:verdana, 돋움; font-size:11px; height:19px }
	TEXTAREA { font-family:verdana, 돋움; font-size:11px; border:1px solid #909090;}
</style>
<script language=Javascript src="/js/reqsubmit/common.js"></script>
<script language=Javascript src="/js/nads_lib.js"></script>
<script language=Javascript src="/js/datepicker.js"></script>
<script language="javascript" src="/js/forum.js"></script>

<script language="javascript">


var numRef = 1;
function changeInputForm(value) {
	var str = "";
	if (value == "<%= CodeConstants.ANS_MTD_ELEC %>") { // 전자파일의 경우
		str = "";
		str = str + "<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\"><tr>\n"
		str	= str + "<td width=\"100\" height=\"20\" class=\"td_gray1\"><img src=\"/image/common/icon_nemo_gray.gif\" width=\"3\" height=\"6\">\n"
		str	= str + "원본 파일</td>\n"
		str	= str + "<td width=\"320\" height=\"20\" class=\"td_lmagin\"><input type=\"file\" class=\"textfield\" name=\"OriginFile0\" size=\"30\"></td>\n";
		str	= str + "<td width=\"82\" align=\"center\"><a href=\"javascript:submitbutton()\"><img src=\"/image/button/bt_add_admin.gif\" border=\"0\"></a></td></tr>\n"
		str = str + "<tr height=\"1\" class=\"tbl-line\">\n"
		str	= str + "<td height=\"1\" colspan=\"3\"></tr>\n"
		str	= str + "<tr><td height=\"20\" class=\"td_gray1\"><img src=\"/image/common/icon_nemo_gray.gif\" width=\"3\" height=\"6\">\n"
		str	= str + "PDF 파일</td>\n"
		str	= str + "<td height=\"20\" class=\"td_lmagin\"><input type=\"file\" class=\"textfield\" name=\"PdfFile0\" size=\"30\"></td>\n";
		str	= str + "<td align=\"center\">&nbsp;</td></tr>\n";
		str	= str + "<tr height=\"1\" class=\"tbl-line\">\n"
		str	= str + "<td height=\"1\" colspan=\"3\"></tr></table>\n"
		str = str + "<input type=hidden name=MatType value=''>\n";
		str = str + "<input type=hidden name=SendWay value=''>\n";

		document.all.inputDiv.innerHTML = str;

	} else if (value == "<%= CodeConstants.ANS_MTD_ETCS%>") { // 비전자파일의 경우
		for(var i = 1;i<5; i++){
		   document.all.filesubmit[i].innerHTML="";
		}
		numRef = 1
		str = "";
		str = str + "<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\n";
		str = str + "<tr>\n";
		str = str + "<td width=\"80\" height=\"25\" class=\"td_gray1\"><img src='/image/common/icon_nemo_gray.gif'> 매체유형</td>\n";
		str = str + "<td width=\"380\" class=\"td_lmagin\"><select name=\"MatType\" class='select'><option value=''>::: 선택해 주세요 :::</option>";
		<%
			List matList = (List)objCdinfo.getNotElecMediumList();
			if (matList.size() == 0) {
				out.println("str = str + \"<option value=''>등록된 매체가 없습니다.</option>\";");
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
		str = str + "<td height=\"25\" class=\"td_gray1\"><img src='/image/common/icon_nemo_gray.gif'> 발송 방법</td>\n";
		str = str + "<td class=\"td_lmagin\"><select name=\"SendWay\" class='select'><option value=''>::: 선택해 주세요 :::</option>";
		<%
			List swList = (List)objCdinfo.getSendWayList();
			if (swList.size() == 0) {
				out.println("str = str + \"<option value=''>등록된 발송방법이 없습니다.</option>\";");
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
	} else { // 해당 기관 아님의 경우
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
		alert("더이상 파일을 추가하실 수 없습니다.");
	}else{
		var strBgcolor;
		if((numRef % 2) == 0) strBgcolor = " class=td_gray1";
		else strBgcolor = " class=td_grayAnother";
		str = "";
		str = str + "<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\"><tr>\n";
		str	= str + "<td width=\"80\" height=\"20\" "+strBgcolor+"><img src=\"/image/common/icon_nemo_gray.gif\" width=\"3\" height=\"6\">\n";
		str	= str + "원본 파일</td>\n";
		str	= str + "<td width=\"320\" height=\"20\" class=\"td_lmagin\"><input type=\"file\" class=\"textfield\" name=\"OriginFile"+numRef+"\" size=\"30\"></td>\n";
		str	= str + "<td width=\"60\" align=\"center\"><a href=\"javascript:removebutton("+(numRef)+")\"><img src='/image/button/bt_cancel_admin.gif' border='0'></a></td></tr>\n";
		str = str + "<tr height=\"1\" class=\"tbl-line\">\n";
		str	= str + "<td height=\"1\" colspan=\"3\"></tr>\n";
		str	= str + "<tr><td height=\"20\" "+strBgcolor+"><img src=\"/image/common/icon_nemo_gray.gif\" width=\"3\" height=\"6\">\n";
		str	= str + "PDF 파일</td>\n";
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
	/*** 숫자만 입력받기.*/
	function CheckNumeric(field){
		var objEv = event.srcElement;
		var numPattern = /([^0-9])/;
		numPattern = objEv.value.match(numPattern);
		if(numPattern != null){
			alert("숫자만 입력해 주세요!");
			objEv.value="";
			objEv.focus();
			return;
		}
	}

	/*** 숫자만 입력받기.*/
	function CheckNumeric(){
		var objEv = event.srcElement;
		var numPattern = /([^0-9])/;
		numPattern = objEv.value.match(numPattern);
		if(numPattern != null){
			alert("숫자만 입력해 주세요!");
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
			alert("업무구분을 선택해주세요");
			return false;
		}
		if(formName.elements['AnsDuty'].value == ""){
			alert("오프라인 요구유형을 선택해주세요");
			return false;
		}
		if(formName.elements['reqdate'].value == ""){
			alert("요청일자를 선택해주세요");
			return false;
		}
		if(formName.elements['CmtOrganID'].value == ""){
			alert("소관위원회를 선택해주세요");
			return false;
		}
		if(formName.elements['ReqOrganID'].value == ""){
			alert("의원실을 선택해주세요");
			return false;
		}if(formName.elements['RegrID'].value == ""){
			alert("담당자를 선택해주세요");
			return false
		}
		if(formName.elements['ReqCont'].value == ""){
			alert("요구명을 작성해 주세요");
			return false
		}
		if(formName.elements['ReqDtlCont'].value == ""){
			alert("요구내용을 작성해 주세요");
			return false
		}
		var f = document.formName;
		var ansType = f.AnsType.value;
		//alert(numRef);
		if (ansType == "<%= CodeConstants.ANS_MTD_ELEC %>") { // 전자파일인가요?
			for(var j = 0;j < numRef ; j++){
				var Ofile = eval("f.OriginFile"+j);
				var Pfile = eval("f.PdfFile"+j);
			   //alert(Ofile.value);
			   //alert(Pfile.value);
			   if (Ofile.value == "") {
					alert("원본 문서 파일을 선택해 주세요");
					//f.OriginFile.focus();
					return;
				} else if (Pfile.value == "") {
					alert("PDF 파일을 선택해 주세요");
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



		} else if (ansType == "<%= CodeConstants.ANS_MTD_ETCS%>") { // 비전자파일인가요?
			if (f.MatType.value == "") {
				alert("매체유형을 선택해 주세요");
				f.MatType.focus();
				return;
			} else if (f.SendWay.value == "") {
				alert("발송방법을 선택해 주세요");
				f.SendWay.focus();
				return;
			} else if (f.AnsOpin.value == "") {
				//alert("제출의견을 입력해 주세요");
				f.AnsOpin.value = "제출 의견 없음";
				//return;
			}
		} else if (ansType == "<%= CodeConstants.ANS_MTD_NONE %>") { // 해당기관이 아닌가요?
			if (f.AnsOpin.value == "") {
				//alert("제출의견을 입력해 주세요");
				f.AnsOpin.value = "제출 의견 없음";
				//return;
			}
		}

		if (confirm("작성하신 답변 자료를 등록하시겠습니까?")) {
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
				<font style="font-size:18px;color:darkblue;font-family:HY헤드라인M"><%= strTitle %></font>
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
							<img src="/image/common/icon_reqsubmit_soti.gif"> 제출 기관 : <B style="color:darkblue"><%= strOrgnaNM %></B>
						</td>
						<%if (objUserInfo.getUserID().equals("0000039924")){%>
							<td width="380" height="23" style="cursor:hand;" align="right" onclick="javascript:document.location.href='AnsInfoWriteAllInOne2.jsp';">
								<b>[대용량 파일등록]</b>
							</td>
						<%} else {%>
							<td width="380" height="23" style="cursor:hand;" align="right" onclick="javascript:document.location.href='AnsInfoWriteAllInOne.jsp';">
								<b>[대용량 파일등록]</b>
							</td>
						<%}%>
					</tr>
				</table>

				<table border="0" cellpadding="0" cellspacing="0" style="border:1px solid #c0c0c0">
					<tr>
						<td width="100">
							&nbsp;&nbsp;<img src="/image/common/icon_reqsubmit_soti.gif"> 회기 :
						</td>
						<td width="280" colspan="3">
							제 <input type="text" value="<%=SessionNo2%>" name="NatCnt" size="3" maxLength="3" onKeyUp="CheckNumeric()"> 회 국회
						</td>
					</tr>
					<tr>
						<td colspan="4" height="1" bgcolor="#c0c0c0"></td>
					</tr>
					<tr>
						<td height="25">&nbsp;&nbsp;<img src="/image/common/icon_reqsubmit_soti.gif"> 업무구분 :
						</td>
						<td colspan="3">
							<select name="RltdDutyX">
								<option value="">선택</option>
								<option value="001" <%if(strRltdDutyX.equals("001")){%>selected<%}%>>국정감사</option>
								<option value="002" <%if(strRltdDutyX.equals("002")){%>selected<%}%>>국정조사</option>
								<option value="004" <%if(strRltdDutyX.equals("004")){%>selected<%}%>>결산</option>
								<option value="005" <%if(strRltdDutyX.equals("005")){%>selected<%}%>>기금</option>
								<option value="006" <%if(strRltdDutyX.equals("006")){%>selected<%}%>>법안</option>
								<option value="003" <%if(strRltdDutyX.equals("003")){%>selected<%}%>>예산안</option>
								<option value="007" <%if(strRltdDutyX.equals("007")){%>selected<%}%>>기타(임시회 등)</option>
							</select>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/image/common/icon_reqsubmit_soti.gif"> 비전자 자료요구 유형
							<select name="AnsDuty">
								<option value="">선택</option>
								<option value="001" <%if(strAnsDuty.equals("001")){%>selected<%}%>>전화</option>
								<option value="002" <%if(strAnsDuty.equals("002")){%>selected<%}%>>e-메일</option>
								<option value="003" <%if(strAnsDuty.equals("003")){%>selected<%}%>>팩스</option>
								<option value="004" <%if(strAnsDuty.equals("004")){%>selected<%}%>>구두</option>
								<option value="005" <%if(strAnsDuty.equals("005")){%>selected<%}%>>기타</option>

							</select>
						</td>

					</tr>
					<tr>
						<td colspan="4" height="1" bgcolor="#c0c0c0"></td>
					</tr>
					<tr>
						<td height="25">&nbsp;&nbsp;<img src="/image/common/icon_reqsubmit_soti.gif"> 요구일자 :
						</td>
						<td width="200">
							<input type="text" class="textfield" name="reqdate" size="10" maxlength="8" value="<%=strReqDate%>"  OnClick="this.select()"
						OnKeyPress="if ((event.keyCode&lt;48)||(event.keyCode&gt;57)) event.returnValue=false;" OnBlur="javascript:SetFormatDate(this);" Onfocus="javascript:datechange();">&nbsp;&nbsp;
						<img src="/image/button/bt_viewCalendar.gif" border="0" style="cursor:hand"  OnClick="javascript:show_calendar('formName.reqdate');" align="absmiddle">
						</td>
						<td height="25">&nbsp;&nbsp;<img src="/image/common/icon_reqsubmit_soti.gif"> 제출기한 :
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
						<td width="100" height="25">&nbsp;&nbsp;<img src="/image/common/icon_reqsubmit_soti.gif"> 소관 위원회 :
						</td>
						<td width="660" colspan="3">

								<select name="CmtOrganID" onChange="searchSubmit()">
									<option value="">::::위원회를 선택해주세요:::</option>
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
						<td width="100" height="25">&nbsp;&nbsp;<img src="/image/common/icon_reqsubmit_soti.gif"> 의원실 :
						</td>
						<td width="660" colspan="3">

								<select name="ReqOrganID" onChange="searchReqUserId()">
									<option value="">:::의원실을 선택해주세요:::</option>
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
									<option value="">:::담당자를 선택해주세요:::</option>
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
						<td width="100">&nbsp;&nbsp;<img src="/image/common/icon_reqsubmit_soti.gif"> 요구명 : </td><td width="660"><input type="text" name="ReqCont" size="80"></td>
					</tr>
					<tr>
						<td colspan="4" height="1" bgcolor="#c0c0c0"></td>
					</tr>
					<tr>
						<td>&nbsp;&nbsp;<img src="/image/common/icon_reqsubmit_soti.gif"> 요구내용 : </td><td><textarea name="ReqDtlCont" rows="9" cols="80"></textarea></td>
					</tr>
					<tr>
						<td colspan="4" height="1" bgcolor="#c0c0c0"></td>
					</tr>
				</table>
				<br>
				<table border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td><font style="font-size:18px;color:darkblue;font-family:HY헤드라인M">답변 등록</font></td>
					</tr>
				</table>

				<table border="0" cellpadding="0" cellspacing="0" style="border:1px solid #c0c0c0">
					<tr>
                      <td width="100" height="25" class="td_gray1">&nbsp;&nbsp;<img src="/image/common/icon_reqsubmit_soti.gif"> 답변유형 : </td>
                      <td width="660" height="25" class="td_lmagin"><select name="AnsType" onChange="javascript:changeInputForm(this.value)" class="select">
								<option value="<%= CodeConstants.ANS_MTD_ELEC %>"><%= CodeConstants.getAnswerMethod(CodeConstants.ANS_MTD_ELEC) %></option>
								<option value="<%= CodeConstants.ANS_MTD_ETCS %>"><%= CodeConstants.getAnswerMethod(CodeConstants.ANS_MTD_ETCS) %></option>
							</select></td>
                    </tr>
					<tr>
						<td colspan="4" height="1" bgcolor="#c0c0c0"></td>
					</tr>
					<tr>
						<td>&nbsp;&nbsp;<img src="/image/common/icon_reqsubmit_soti.gif"> 답변파일 : </td>
						<td>
							<DIV id="inputDiv" style="position:relative; left:0px;top:0px;width:460; border-width:0px; border-style:none;">
						<table border="0" cellpadding="0" cellspacing="0">
            				<tr>
								<td width="80" height="20" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6">
								원본 파일</td>
								<td width="320" height="20" class="td_lmagin"><input type="file" class="textfield" name="OriginFile0" size="30"></td>
								<td width="60" align="center"><a href="javascript:submitbutton()"><img src="/image/button/bt_add_admin.gif" border="0"></a></td>
							</tr>
							<tr height="1" class="tbl-line">
								<td height="1" colspan="3">
							</tr>
							<tr>
								<td height="20" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6">
									PDF 파일</td>
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
						<td>&nbsp;&nbsp;<img src="/image/common/icon_reqsubmit_soti.gif"> 제출의견 : </td><td><textarea name="AnsOpin" rows="9" cols="80"></textarea></td>
					</tr>
				</table>


				<!----------------------------------------------- TABLE END ---------------------------------------------------->
				<p>
				<input type="button" value="요구함 저장" class="button" onClick="checkFormData()">&nbsp;&nbsp;<input type="button" value="초기화" class="button" onClick="document.formName.reset()">
				&nbsp;&nbsp;<input type="button" value="작성 취소" class="button" onClick="self.close()">
				<p><br></p>
			</td>
		</tr>
	</table>
	</CENTER>

</FORM>

</BODY>
</html>
