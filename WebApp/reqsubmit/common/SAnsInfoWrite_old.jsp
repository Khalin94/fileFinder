<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.lib.reqsubmit.params.requestinfo.SMemReqInfoVListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.SMemReqInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.MemRequestBoxDelegate" %>
<%@ page import="kr.co.kcc.pf.ejb.EJBExtendException" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	UserInfoDelegate objUserInfo =null;
	CDInfoDelegate objCdinfo =null;
%>

<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>

<%
	/**********************************************************************
	 * 기본적으로 항상 각 페이지별로 해야하는 작업. 이용자 로그인 정보를 확인한다.
	 * 즉, 세션이 생성되어져 있는지를 확인한다.
	 * 그리고, 현재 화면을 구성하기 위해서 해당하는 요구의 간략 정보를 출력한다.
	 * 해당 간략 정보를 출력하기 위해서 요구ID를 파라미터로 받아서 해당하는 함수를 호출한다.
	 * 그 하단에는 요구의 답변을 등록하는 등록 폼을 생성한다.
	 * 등록 폼은 답변 유형에 따라서 각기 다른 형태로 폼을 제공하여야 한다.
	 * 답변 유형에 따라서 처리되는 프로세스의 내용도 고려되어야 하는 것을 잊지 말자!!
	 * 멀티 파일 업로드 컴퍼넌트를 이용해서 답변을 등록하는 것! 폼의 타입을 잘 지정해 주자.
	 * 자 그럼 열심히 (__)
	 *
	 **********************************************************************
	 */
	String strClientIP = request.getHeader("WL-Proxy-Client-IP");

	System.out.println("ANSINFO IP############################################# :: "+strClientIP);

	MemRequestBoxDelegate reqDelegate = null;
	SMemReqInfoDelegate selfDelegate = null;

	SMemReqInfoVListForm objParams = new SMemReqInfoVListForm();

	boolean blnParamCheck=false;
	blnParamCheck = objParams.validateParams(request);
	if(blnParamCheck==false) {
  		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  		objMsgBean.setStrCode("DSPARAM-0000");
  		objMsgBean.setStrMsg(objParams.getStrErrors());
  		out.println("ParamError:" + objParams.getStrErrors());
	  	return;
  	}//endif

	// 넘어온 파라미터를 설정해서 필요할 ?? 쓰도록 하자
	// 요구함 관련
	String strReqBoxID = objParams.getParamValue("ReqBoxID");
	String strReqID = objParams.getParamValue("ReqID");

	String strReqBoxSortField = StringUtil.getEmptyIfNull((String)objParams.getParamValue("ReqBoxSortField"));
	String strReqBoxSortMtd = StringUtil.getEmptyIfNull((String)objParams.getParamValue("ReqBoxSortMtd"));
	String strReqBoxPagNum = StringUtil.getEmptyIfNull((String)objParams.getParamValue("ReqBoxPage"));
	String strReqBoxQryField = StringUtil.getEmptyIfNull((String)objParams.getParamValue("ReqBoxQryField"));
	String strReqBoxQryTerm = StringUtil.getEmptyIfNull((String)objParams.getParamValue("ReqBoxQryTerm"));
	String AuditYear = StringUtil.getEmptyIfNull((String)request.getParameter("AuditYear"));


	// 요구 목록 관련
	String strReqInfoSortField = objParams.getParamValue("ReqInfoSortField");
	String strReqInfoSortMtd = objParams.getParamValue("ReqInfoSortMtd");
	String strReqInfoQryField = objParams.getParamValue("ReqInfoQryField");
	String strReqInfoQryTerm = objParams.getParamValue("ReqInfoQryTerm");
	String strReqInfoPagNum = objParams.getParamValue("ReqInfoPage");
	
	//공개비공개 테스트
  String strOpenCL = request.getParameter("ReqOpenCL");
  System.out.println("kangthis logs SAnsInfoWrite_old.jsp(strOpenCL) => " + strOpenCL);

	// 2004-06-04 이용자 인증서 USER DN
	String strUserDN = null;

	if ("".equalsIgnoreCase(StringUtil.getEmptyIfNull(strReqID))) { // 요구ID가 NULL이면 안된다. 절대로~~
		throw new AppException("요구 ID가 없음 안돼유~~~");
	}

	if ("".equalsIgnoreCase(StringUtil.getEmptyIfNull(strReqBoxID))) { // 요구함 ID가 NULL이면 안된다. 절대로~~
		throw new AppException("요구함 ID가 없음 안돼유~~~");
	}

	// 2004-05-04 추가된 파라미터 : 폼을 수정하기 힘들어서 그냥 이렇게 쓴다. -ㅅ-
	String strReturnURL = StringUtil.getEmptyIfNull(request.getParameter("ReturnURL"));
	//if (StringUtil.isAssigned(strReturnURL)) strReturnURL = strReturnURL+"?ReqBoxID="+strReqBoxID+"&ReqID="+strReqID;
	//else strReturnURL = "/reqsubmit/10_mem/20_reqboxsh/10_make/SMakeReqInfoVList.jsp?ReqBoxID="+strReqBoxID+"&ReqID="+strReqID;

	// 2004-05-08 추가된 파라미터 : 추가답변여부
	String strAddAnsFlag = StringUtil.getEmptyIfNull(request.getParameter("AddAnsFlag"), "N");

	ResultSetSingleHelper objRsSH = null;

	try{
	   	reqDelegate = new MemRequestBoxDelegate();
	   	selfDelegate = new SMemReqInfoDelegate();

	   	boolean blnHashAuth = reqDelegate.checkReqBoxAuth(strReqBoxID, objUserInfo.getOrganID()).booleanValue();

	   	if(!blnHashAuth) {
	   		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	  		objMsgBean.setStrCode("DSAUTH-0001");
  	  		objMsgBean.setStrMsg("해당 요구함을 볼 권한이 없습니다.");
  	  		out.println("해당 요구함을 볼 권한이 없습니다.");
		    return;
		} else {
	    	// 요구 등록 정보를 SELECT 한다.
	    	objRsSH = new ResultSetSingleHelper(selfDelegate.getRecord(strReqID));

	    	// 2004-06-04 이용자의 인증서 USER DN 값을 가져와서 세팅한다.
	    	//strUserDN = selfDelegate.getUserDN(objUserInfo.getUserID());
	    	HttpSession objPrivateSession = request.getSession();
			strUserDN = StringUtil.getEmptyIfNull((String)objPrivateSession.getAttribute("UserDN"));
			System.out.println("objPrivateSession : "+strUserDN);
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
<title>
<%
	if ("Y".equalsIgnoreCase(strAddAnsFlag)) out.println("추가 답변 작성");
	else out.println(MenuConstants.REQ_BOX_MAKE+"- 답변 작성");
%>
</title>
<link href="/css/System.css" rel="stylesheet" type="text/css">

<style>
.td_grayAnother {
	FONT-WEIGHT: bold; FONT-SIZE: 12px; COLOR: #5c5c5c; FONT-FAMILY: 돋움,verdana,seoul,Arial;BACKGROUND-COLOR: #E9E9E9 ; padding-left: 15px;
}
</style>

<script language="javascript" src="/js/reqsubmit/common.js"></script>
<script language="javascript">
// 어처구니 없는 함수임에 분명하다.
// 당장에는 별다른 대책이 없어서 우선 이렇게 둔다.
// 보다 획기적인 개선안이 하루빨리 떠오르길 바라며... -ㅅ-
var numRef = 1;
function changeInputForm(value) {
	var str = "";
	if (value == "<%= CodeConstants.ANS_MTD_ELEC %>") { // 전자파일의 경우
		str = "";
		str = str + "<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\"><tr>\n"
		str	= str + "<td width=\"80\" height=\"20\" class=\"td_gray1\"><img src=\"/image/common/icon_nemo_gray.gif\" width=\"3\" height=\"6\">\n"
		str	= str + "원본 파일</td>\n"
		str	= str + "<td width=\"380\" height=\"20\" class=\"td_lmagin\"><input type=\"file\" class=\"textfield\" name=\"OriginFile0\" size=\"30\"></td>\n"
		str	= str + "<td width=\"100\" align=\"center\"><a href=\"javascript:submitbutton()\">파일추가</a></td></tr>\n"
		str = str + "<tr height=\"1\" class=\"tbl-line\">\n"
		str	= str + "<td height=\"1\" colspan=\"3\"></tr>\n"
		str	= str + "<tr><td height=\"20\" class=\"td_gray1\"><img src=\"/image/common/icon_nemo_gray.gif\" width=\"3\" height=\"6\">\n"
		str	= str + "PDF 파일</td>\n"
		str	= str + "<td height=\"20\" class=\"td_lmagin\"><input type=\"file\" class=\"textfield\" name=\"PdfFile0\" size=\"30\"></td>\n"
		str	= str + "<td align=\"center\">&nbsp;</td></tr>\n"
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

// 답변 유형에 따라서 입력 폼이 달라지므로 유형별 필수입력값에 대한 강요를 하자.. 넣어주시어요~
function checkSubmit() {
	var f = document.inputForm;
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
			if(pdfExt.toUpperCase() != "PDF"){
				alert("PDF파일을 선택하여주세요");
				return false;
			}

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

	if (getByteLength(f.AnsOpin.value) > 500) {
		alert("한글, 영문을 포함 500자 이내로 입력해 주세요. 단, 한글은 2자로 처리됩니다.");
		f.AnsOpin.focus();
		return;
	}

	if (confirm("작성하신 답변 자료를 등록하시겠습니까?")) {
		document.returnSubmitForm.AnsOpin.value = f.AnsOpin.value;
		f.count.value = numRef;
		if (ansType == "<%= CodeConstants.ANS_MTD_ELEC %>") {
			f.action = "/reqsubmit/common/SAnsInfoWriteProcPopup_old.jsp";
			f.target="processingFrame";
			document.returnSubmitForm.AnsOpin.value = f.AnsOpin.value;
			//formName.target = 'processingFrame';
			//NewWindow2('/blank.html', 'hiddenPopup', '320', '240', 'OUT');
			//window.open('about:blank', 'popwin', 'width=320px, height=240px, status=yes');
			document.all.loadingDiv.style.display = '';
			f.submit();
		} else {
			var f2 = document.returnSubmitForm;
			f2.PdfFile.value = f.PdfFile.value;
			f2.OriginFile.value = f.OriginFile.value;
			f2.PdfFilePath.value = f.PdfFile.value;
			f2.DocFilePath.value = f.OriginFile.value;
			f2.MatType.value = f.MatType.value;
			f2.SendWay.value = f.SendWay.value;
			f2.AnsOpin.value = f.AnsOpin.value;
			f2.AnsType.value = f.AnsType.value;
			f2.OpenCL.value = f.OpenCL.value;
			f2.action = "/reqsubmit/common/SAnsInfoWriteProc_old.jsp";
			document.all.loadingDiv.style.display = '';
			f2.submit();
		}
	}
} // end checkSubmit()

function gotoReqInfoView() {
	var f = document.inputForm;
	f.target = "";
	f.action = "<%= strReturnURL.substring(0, StringUtil.getLastIndex(strReturnURL, "?")) %>";
	f.submit();
}

function selfclosed(){

	opener.document.viewForm.target = "";
	self.close();

}

function updateCharAnother(formName, elementName, length_limit) {
	var comment='';
	comment = formName.elements[elementName];
	var length = calculate_msglen(comment.value);
	document.getElementById("textlimit").innerHTML = length;
	if (length > length_limit) {
		alert("최대 " + length_limit + "byte이므로 초과된 글자수는 자동으로 삭제됩니다.");
		comment.value = comment.value.replace(/\r\n$/, "");
		comment.value = assert_msglen(comment.value, length_limit);
	}
}
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<iframe name='processingFrame' height='0' width='0'></iframe>

<DIV ID="loadingDiv" style="width:220;height:180;display:none;position:absolute;left:80;top:120">
	<img src="/image/reqsubmit/processing.gif" border="0"> </td>	
</DIV>

<center>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr align="left" valign="top">
    <td width="186" height="470" background="/image/common/bg_leftMenu.gif">
	</td>
<!------- 2004-06-02 디자인 수정으로 인해 변경된 부분 시작 ------->
<td width="100%" align="center"><table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr valign="top">
          <td align="center">
		    <table width="500" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td height="5" class="td_reqsubmit"></td>
              </tr>
              <tr>
                <td height="30" align="left">
                	<!-------------------- TAB 에 해당하는 제목을 기술하는 곳이지요. ------------------------>
                  <img src="/image/title/<%= ("Y".equalsIgnoreCase(strAddAnsFlag))?"title_regAddAnswer.jpg":"title_regAnswer.jpg" %>" border="0"></td>
              </tr>
			  <tr>
				<td height="1" bgcolor="#c0c0c0"></td>
			  </tr>
			  <tr>
				<td height="15"></td>
			  </tr>
              <tr>
                <td align="center" valign="top" class="soti_reqsubmit">
                <!------------------------- 답변 작성 정보 입력 폼 시작 ------------------------->
<form name="inputForm" method="post" enctype="multipart/form-data" style="margin:0px">
				<input type="hidden" name="ReqBoxID" value="<%= strReqBoxID %>">
				<input type="hidden" name="ReqID" value="<%= strReqID %>">
				<input type="hidden" name="RegrID" value="<%= objUserInfo.getUserID() %>">
				<input type="hidden" name="MsgDigest" value="">

				<input type="hidden" name="ReqBoxSortField" value="<%= strReqBoxSortField %>">
				<input type="hidden" name="ReqBoxSortMtd" value="<%= strReqBoxSortMtd %>">
				<input type="hidden" name="ReqBoxPagNum" value="<%= strReqBoxPagNum %>">
				<input type="hidden" name="ReqBoxQryField" value="<%= strReqBoxQryField %>">
				<input type="hidden" name="ReqBoxQryTerm" value="<%= strReqBoxQryTerm %>">

				<input type="hidden" name="ReqInfoSortField" value="<%= strReqInfoSortField %>">
				<input type="hidden" name="ReqInfoSortMtd" value="<%= strReqInfoSortMtd %>">
				<input type="hidden" name="ReqInfoQryField" value="<%= strReqInfoQryField %>">
				<input type="hidden" name="ReqInfoQryTerm" value="<%= strReqInfoQryTerm %>">
				<input type="hidden" name="ReqInfoPagNum" value="<%= strReqInfoPagNum %>">
				<input type="hidden" name="AuditYear" value="<%=AuditYear%>">


				<input type="hidden" name="returnURL" value="<%= strReturnURL %>">

				<% // 공개 등급 : 원래는 선택이었으나 답변은 모두 공개로 하기로 했으므로 고정 처리 %>
				<%// 공개 등급 : 원래는 고정이였으나 동적으로 변경 2015.11.09 ksw %>
				<input type="hidden" name="OpenCL" value="<%= strOpenCL %>">
				<input type="hidden" name="AddAnsFlag" value="<%= strAddAnsFlag %>">
				<input type="hidden" name="UserDN" value="<%= strUserDN %>">
				<input type="hidden" name="count">
                <table width="460" border="0" cellspacing="0" cellpadding="0">
                    <tr class="td_reqsubmit">
                      <td width="100" height="2"></td>
                      <td width="360" height="2"></td>
                    </tr>
                    <tr>
                      <td width="100" height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6">
                        답변 유형</td>
                      <td width="360" height="25" class="td_lmagin"><select name="AnsType" onChange="javascript:changeInputForm(this.value)" class="select">
								<option value="<%= CodeConstants.ANS_MTD_ELEC %>"><%= CodeConstants.getAnswerMethod(CodeConstants.ANS_MTD_ELEC) %></option>
								<option value="<%= CodeConstants.ANS_MTD_ETCS %>"><%= CodeConstants.getAnswerMethod(CodeConstants.ANS_MTD_ETCS) %></option>
								<option value="<%= CodeConstants.ANS_MTD_NONE %>"><%= CodeConstants.getAnswerMethod(CodeConstants.ANS_MTD_NONE) %></option>
							</select></td>
                   </tr>
                    <tr height="1" class="tbl-line">
                      <td height="1" colspan="2">
                    </tr>
					<tr>
						<td colspan="2" align="left">
						<!-------------------------------------------- 동적으로 변화하는 FORM START ---------------------------------------------------->
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
					<!-------------------------------------------- 동적으로 변화하는 FORM END ---------------------------------------------------->
						</td>

				</tr>
				<tr>
					<td width="100"  height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 제출 의견</td>
					<td width="360"  height="25" class="td_lmagin"
					style="padding-top:5px;padding-bottom:5px"><textarea name="AnsOpin" wrap="hard"
						class="textfield" style="WIDTH: 90% ; height: 80"
						onKeyDown="javascript:updateCharAnother(document.inputForm, 'AnsOpin', 250)"
						onKeyUp="javascript:updateCharAnother(document.inputForm, 'AnsOpin', 250)"
						onFocus="javascript:updateCharAnother(document.inputForm, 'AnsOpin', 250)"
						onClick="javascript:updateCharAnother(document.inputForm, 'AnsOpin', 250)"></textarea><br>
						<table border="0">
							<tr><td width="30" align="right"><B><div id ="textlimit"> </div></B></td>
							<td width="500"> bytes (250 bytes 까지만 입력됩니다) </td></tr>
						</table>
					</td>
				</tr>
				<tr>
					<td  colspan="2" align="center"><font color="blue">* 100메가 초과되는 파일은 대용량첨부기능을 이용하여 주시기 바랍니다.</font></td>
				</tr>
				<tr height="1" class="tbl-line">
					<td height="1" colspan="2">
				</tr>
           		</table>
				<p>
               <table width="460" border="0" cellspacing="0" cellpadding="0">
                   <tr>
                     <td height="40" align="center">
                     	<img src="/image/button/bt_save.gif" border="0" onClick="javascript:checkSubmit()" style="cursor:hand">
                     	&nbsp;<img src="/image/button/bt_closeWindow.gif" border="0" onClick="javascript:selfclosed()" style="cursor:hand">
                      </td>
                    </tr>
	               </table>
</form>
            		<p><br></p>
            		<p><br></p>
                <!------------------------- 답변 작성 정보 입력 폼 끝 ------------------------->
               	</td>
             </tr>

            </table></td>
        </tr>
      </table></td>
  </tr>
</table>
<!-- 전자문서 의 경우 Msg Digest를 생성하고 결과값을 받아서 String만 보내면 되고, 나머지는 그냥 String뿐이니깐... -->
<FORM method="post" style="margin:0px" name="returnSubmitForm">
	<input type="hidden" name="ReqBoxID" value="<%= strReqBoxID %>">
	<input type="hidden" name="ReqID" value="<%= strReqID %>">
	<input type="hidden" name="RegrID" value="<%= objUserInfo.getUserID() %>">
	<input type="hidden" name="MsgDigest" value="">
	<input type="hidden" name="returnURL" value="<%= strReturnURL %>">
	<input type="hidden" name="ReqBoxSortField" value="<%= strReqBoxSortField %>">
	<input type="hidden" name="ReqBoxSortMtd" value="<%= strReqBoxSortMtd %>">
	<input type="hidden" name="ReqBoxPagNum" value="<%= strReqBoxPagNum %>">
	<input type="hidden" name="ReqBoxQryField" value="<%= strReqBoxQryField %>">
	<input type="hidden" name="ReqBoxQryTerm" value="<%= strReqBoxQryTerm %>">

	<input type="hidden" name="ReqInfoSortField" value="<%= strReqInfoSortField %>">
	<input type="hidden" name="ReqInfoSortMtd" value="<%= strReqInfoSortMtd %>">
	<input type="hidden" name="ReqInfoQryField" value="<%= strReqInfoQryField %>">
	<input type="hidden" name="ReqInfoQryTerm" value="<%= strReqInfoQryTerm %>">
	<input type="hidden" name="ReqInfoPagNum" value="<%= strReqInfoPagNum %>">
	<input type="hidden" name="AuditYear" value="<%=AuditYear%>">

	<input type="hidden" name="AnsType" value="">
	<input type="hidden" name="OpenCL" value="">
	<input type="hidden" name="PdfFile" value="">
	<input type="hidden" name="OriginFile" value="">
	<input type="hidden" name="PdfFilePath" value="">
	<input type="hidden" name="DocFilePath" value="">
	<input type="hidden" name="MatType" value="">
	<input type="hidden" name="SendWay" value="">
	<input type="hidden" name="AnsOpin" value="">
	<input type="hidden" name="PdfFileName" value="">
	<input type="hidden" name="OriginFileName" value="">
	<input type="hidden" name="AnsFileID" value="">
	<input type="hidden" name="AddAnsFlag" value="<%= strAddAnsFlag %>">
	<input type="hidden" name="user_dn" value="<%= strUserDN %>">
	<input type="hidden" name="UserDN" value="<%= strUserDN %>">
	<input type="hidden" name="count">
	<!-- 실제파일명 작업 20170818 -->
	<input type="hidden" name="OrgRealFileName" value="">
	<input type="hidden" name="PdfRealFileName" value="">
</FORM>

</center>
</body>
</html>