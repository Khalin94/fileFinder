<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.lib.reqsubmit.params.requestinfo.SMemAnsInfoViewForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.answerinfo.AnsInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.SMemReqInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.MemRequestBoxDelegate" %>
<%@ page import="kr.co.kcc.pf.ejb.EJBExtendException" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	UserInfoDelegate objUserInfo =null;
	CDInfoDelegate objCdinfo =null;
%>

<%
	// 현재연도
	Calendar calendar = Calendar.getInstance();
	int year = calendar.get(calendar.YEAR);
	String yearStr = Integer.toString(year);
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
	String strClientIP = request.getHeader("Proxy-Client-IP");

	System.out.println("ANSINFO IP############################################# :: "+strClientIP);

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

	// 넘어온 파라미터를 설정해서 필요할 ?? 쓰도록 하자
	// 요구함 관련
	String strReqBoxID = objParams.getParamValue("ReqBoxID");
	String strReqID = objParams.getParamValue("ReqID");
    String strAnsID = objParams.getParamValue("AnsID");

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

	// 2004-05-08 추가된 파라미터 : 추가답변여부
	String strAddAnsFlag = StringUtil.getEmptyIfNull(request.getParameter("AddAnsFlag"), "N");

	ResultSetSingleHelper objRsSH = null;
    String strAnsMtd = "";
	try{
		reqDelegate = new MemRequestBoxDelegate();
		ReqInfoDelegate = new SMemReqInfoDelegate();
	   	selfDelegate = new AnsInfoDelegate();

        boolean blnHashAuth = reqDelegate.checkReqBoxAuth(strReqBoxID, objUserInfo.getOrganID()).booleanValue();

	   	if(!blnHashAuth) {
	   		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	  		objMsgBean.setStrCode("DSAUTH-0001");
  	  		objMsgBean.setStrMsg("해당 요구함을 볼 권한이 없습니다.");
  	  		out.println("해당 요구함을 볼 권한이 없습니다.");
		    return;
		} else {
	    	// 요구 등록 정보를 SELECT 한다.
            objRsSH = new ResultSetSingleHelper(selfDelegate.getRecord(strAnsID));
            strAnsMtd = (String)objRsSH.getObject("ANS_MTD");
            System.out.println("strAnsMtd"+strAnsMtd);
	    	// 2004-06-04 이용자의 인증서 USER DN 값을 가져와서 세팅한다.
	    	//strUserDN = ReqInfoDelegate.getUserDN(objUserInfo.getUserID());
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

<jsp:include page="/inc/header.jsp" flush="true"/>
<style>
.td_grayAnother {
	FONT-WEIGHT: bold; FONT-SIZE: 12px; COLOR: #5c5c5c; FONT-FAMILY: 돋움,verdana,seoul,Arial;BACKGROUND-COLOR: #E9E9E9 ; padding-left: 15px;
}
</style>
<script>
/* IMAGE_ROLLOVER 스크립트 */
function menuOn(imgEl)
{
	imgEl.src = imgEl.src.replace(".gif", "_on.gif");
}

function menuOut(imgEl)
{
	imgEl.src = imgEl.src.replace("_on.gif", ".gif");
}
</script>
<script language="javascript" src="/js/reqsubmit/common.js"></script>
<script language="javascript">
	
	var new_filename_v = new Array(100);

	function BrowserInfo() 
	{
		this.isMSIE = false;
		this.isFirefox = false;
		this.isChrome = false;
		this.isSafari = false;
		this.etc = false; // IE, FF를 제외한 브라우저
		this.isMSIEx64 = false;

		try {
			var x = ActiveXObject;
			this.isMSIE = true;
		} catch (e) {
			this.isMSIE = false;
		}
		var userAgentString = navigator.userAgent.toLowerCase();
		if (userAgentString.indexOf("chrome") > -1) this.isChrome = true;
		if (userAgentString.indexOf("firefox") > -1) this.isFirefox = true;
		if (userAgentString.indexOf("safari") > -1) this.isSafari = true;
		if (this.isFirefox) this.isWindowlessSupported = "true";
		if (!this.isMSIE && !this.isFirefox) this.etc = true;
		if (this.isMSIE && userAgentString.indexOf("win64; x64") > -1) this.isMSIEx64 = true;
	}

	var GBrowser = new BrowserInfo();

	function ExistPlugin() 
	{
		var mimetype = navigator.mimeTypes["application/x-tabsfileup"];
		if (mimetype) 
		{
			var enablePlugin = mimetype.enabledPlugin;
			if (enablePlugin)
				return true;
			else
				return false;
		}
		else 
		{
			return false;
		}
	}
	var shtml;
	var filectl;
	var licensekey = 'hTBMSylD3xqJrfOFCJI5EtLWiMbyWH9k6s1uJuRbDxI=';	// for localhost
	var pluginpage = '../dist/download.htm';
	var bkimageurl =  location.href.substr(0, location.href.lastIndexOf('/') + 1) + 'bkimage.png';
	if (GBrowser.isMSIE)
	{
		// IE인 경우 액티브엑스를 설치한다.
		shtml = '<OBJECT ID="filectl" width="0" height="0" border="0" '; 
		shtml += 'CLASSID="CLSID:2342E134-C396-43EC-BCB8-13D513BC5FE0" ';
		if (GBrowser.isMSIEx64) shtml += 'CODEBASE="/cab/tabsfileup4setup_x64.cab">';
		else shtml += 'CODEBASE="/cab/tabsfileup4setup.cab">';
		shtml += '<PARAM NAME="mode" VALUE="upload">';
		shtml += '<PARAM NAME="bkimageurl" VALUE="' + bkimageurl + '">';
		shtml += '<PARAM NAME="licensekey" VALUE="' + licensekey + '">';
		shtml += '</OBJECT>';
	}
	else
	{
		// Firefox, Chrome, Safari인 경우 플러그인을 생성한다.			
		shtml = '<div style="border: solid 1px;width:0"><embed id="filectl" type="application/x-tabsfileup" width="0" height="0" ';
		shtml += 'mode="upload" licensekey="' + licensekey + '" ';
		shtml += 'bkimageurl="' + bkimageurl + '" ';
		shtml += 'pluginspage="' + pluginpage + '"/></div>';
	}		

	if (GBrowser.isMSIE == false && ExistPlugin() == false)
	{
		shtml += '<p><div style="background: #ffffaa;padding: 20px"><ul>';
		shtml += '<li>이 콘텐츠를 표시하는데 사용할 플러그인이 없습니다.</li>';
		shtml += '<li>플러그인을 다운로드 하려면 <a href="' + pluginpage + '">[여기]</a>를 선택하십시오.</li>';
		shtml += '<li>설치 페이지로 이동합니다.</li>';
		shtml += '</ul></div>';
	}
	function filectl_ChangingUploadFile(filePath, fileSize, totalFileCount, totalFileSize)
	{
		// 업로드 파일 개수 및 용량을 제한하지 않습니다.
		return true;
	}

	function filectl_UploadSuccessObjectMoved(locationURL)
	{
		location.href = locationURL;	
	}

	function filectl_UploadErrorOccurred(errorType, errorCode, errorDesc, response)
	{
		alert('업로드 오류:\ntype=' + errorType + '\ncode=' + errorCode + '\ndesctiption=' + errorDesc);
		alert('서버 응답:\n' + response);
		deleteUnnecessaryFiles();
	}

	function filectl_UploadCanceled()
	{
		alert('업로드가 취소되었습니다.');
		deleteUnnecessaryFiles();
	}
	
	function deleteUnnecessaryFiles()
	{
		// 사용자에 의한 업로드 취소 또는 업로드 오류 발생시 Ajax을 사용해 서버에 일부 저장 완료된 업로드 파일 지웁니다.
		// 다음은 jQuery ajax을 사용한 예입니다.
		$.ajax({ type: 'post', async: true, url: 'clear2.jsp', 
			success: function(data) 
			{
			}
		});
	}

	function addFiles()  
	{
		filectl.AddFile();
	}

	function addFolder()  
	{
		filectl.AddFolder();
	}

	function removeFiles()  
	{
		filectl.RemoveFile();
	}

	function removeAllFiles()  
	{
		filectl.RemoveAllFiles();
	}

	function selectAllFiles()  
	{
		filectl.SelectAllFiles();
	}

	function setIconsViewStyle()
	{
		filectl.ViewStyle = 'icons';
	}

	function setListViewStyle()
	{
		filectl.ViewStyle = 'list';
	}

	function setDetailsViewStyle()
	{
		filectl.ViewStyle = 'details';
	}

	function submitForm()
	{
		filectl.UploadURL = 'upload2.jsp';
		filectl.CodePage = 65001;
		// 지정된 크기 이상의 파일은 분할해서 업로드 됩니다.
		// 웹서버는 지정된 크기의 HTTP 요청을 받을 수 있도록 설정되어 있어야 합니다.
		filectl.SplitUploadMB = 256;
		// 파일만 업로드를 시작합니다.
		// 업로드 종료 후 발생하는 UploadSuccess 이벤트에서 폼을 submit 합니다.
		filectl.StartUpload();
	}


var Enc = "F1yV/Ih1CIWKmwpkR++vU4L5x6Qw09ZdbnfMOMAF4yP/qX8ir89PSOJEu0KGxmZ7+nwY4oq8SqjF6+BH2rAyuehELATMrnCBJd33fPqR3zO0/EZoPZFUTOJnU4al6tZO+4gcNw==";
var InputType = "fixed";
var SubDir = "<%=yearStr%>";
var UploadURL = "/InnoDSP/action_nads2.jsp";
// 어처구니 없는 함수임에 분명하다.
// 당장에는 별다른 대책이 없어서 우선 이렇게 둔다.
// 보다 획기적인 개선안이 하루빨리 떠오르길 바라며... -ㅅ-
var numRef = 1;
function changeInputForm(value) {
	var str = "";
	if (value == "<%= CodeConstants.ANS_MTD_ELEC %>") { // 전자파일의 경우
	    document.all.inputDiv.style.display = "none";
		document.all.inputDiv2.style.display = "";

	} else if (value == "<%= CodeConstants.ANS_MTD_ETCS%>") { // 비전자파일의 경우
		for(var i = 1;i<5; i++){
		   document.all.filesubmit[i].innerHTML="";
		}
		numRef = 1
		str = "";
		str = str + "<table width=\"590\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\n";
		str = str + "<tr>\n";
		str = str + "<th width=\"160\" height=\"25\" class=\"td_gray1\"><img src='/image/common/icon_nemo_gray.gif'> 매체유형</th>\n";
		str = str + "<td class=\"td_lmagin\"><select name=\"MatType\" class='select'><option value=''>::: 선택해 주세요 :::</option>";
		<%
			List matList = (List)objCdinfo.getNotElecMediumList();
			if (matList.size() == 0) {
				out.println("str = str + \"<option value=''>등록된 매체가 없습니다.</option>\";");
			} else {
				for(int i=0; i<matList.size(); i++) {
					Hashtable hash = (Hashtable)matList.get(i);
					String code = (String)hash.get("MSORT_CD");
					String codeValue = (String)hash.get("CD_NM");
                    if(String.valueOf(objRsSH.getObject("NON_ELC_DOC_MED")).equalsIgnoreCase(code)) {
		    			out.println("str = str + \"<option value='"+code+"' selected>"+codeValue+"</option>\";");
                    } else {
		    			out.println("str = str + \"<option value='"+code+"'>"+codeValue+"</option>\";");
                    }
				}
			}
		%>
		str = str + "</select>\n";
		str = str + "</td>\n";
		str = str + "</tr>\n";
		str = str + "<tr>\n";
		str = str + "<th height=\"25\" class=\"td_gray1\"><img src='/image/common/icon_nemo_gray.gif'> 발송방법</th>\n";
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
                    if(String.valueOf(objRsSH.getObject("NON_ELC_DOC_SUBMT_MTD")).equalsIgnoreCase(code)) {
		    			out.println("str = str + \"<option value='"+code+"' selected>"+codeValue+"</option>\";");
                    } else {
    					out.println("str = str + \"<option value='"+code+"'>"+codeValue+"</option>\";");
                    }

				}
			}
		%>
		str = str + "</tr>\n";
//		str = str + "<tr height=\"1\" class=\"tbl-line\"><td height=\"1\"></td><td height=\"1\"></td></tr>\n";
		str = str + "</table>\n";
		str = str + "<input type=hidden name=OriginFile value=''>\n";
		str = str + "<input type=hidden name=PdfFile value=''>\n";
		str = str + "<table width=\"590\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">\n";
		str = str + "<tr>\n";
		str = str + "<td height=\"40\" style=\"text-align:right;\" colspan=\"2\">\n";
//		str = str + "<img src=\"/image/button/bt_save.gif\" border=\"0\" onClick=\"javascript:checkSubmit()\" style=\"cursor:hand\">\n";
		str = str + "<span class=\"list_bt\"><a href=\"#\" onClick=\"javascript:checkSubmit()\" style=\"cursor:hand\">저장</a></span>&nbsp;&nbsp;";
//		str = str + "&nbsp;<img src=\"/image/button/bt_closeWindow.gif\" border=\"0\" onClick=\"javascript:self.close()\" style=\"cursor:hand\">\n";
		str = str + "<span class=\"list_bt\"><a href=\"#\" onClick=\"javascript:self.close()\" style=\"cursor:hand\">취소</a></span>&nbsp;&nbsp;\n";
		str = str + "</td>\n";
		str = str + "</tr>\n";
		str = str + "</table>\n";

		document.all.inputDiv.innerHTML = str;
		document.all.inputDiv.style.display = "";
		document.all.inputDiv2.style.display = "none";

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
		str = str + "<table width=\"590\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\n";
		str = str + "<tr>\n";
		str = str + "<td height=\"40\" style=\"text-align:right;\" colspan=\"2\">\n";
//		str = str + "<img src=\"/image/button/bt_save.gif\" border=\"0\" onClick=\"javascript:checkSubmit()\" style=\"cursor:hand\">\n";
		str = str + "<span class=\"list_bt\"><a href=\"#\" onClick=\"javascript:checkSubmit()\" style=\"cursor:hand\">저장</a></span>&nbsp;&nbsp;";
//		str = str + "&nbsp;<img src=\"/image/button/bt_closeWindow.gif\" border=\"0\" onClick=\"javascript:self.close()\" style=\"cursor:hand\">\n";
		str = str + "<span class=\"list_bt\"><a href=\"#\" onClick=\"javascript:self.close()\" style=\"cursor:hand\">취소</a></span>&nbsp;&nbsp;\n";
		str = str + "</td>\n";
		str = str + "</tr>\n";
		str = str + "</table>\n";

		document.all.inputDiv.innerHTML = str;
		document.all.inputDiv.style.display = "";
		document.all.inputDiv2.style.display = "none";

	}
}

function submitbutton() {
	var str;
	if (numRef > 1) {
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
	if (ansType == "<%= CodeConstants.ANS_MTD_ELEC %>") { // 전자파일인가요?
       for(var j = 0;j < ezPDFConv.count ; j++){
           var Ofile = eval("f.OriginFile"+j);
           var Pfile = eval("f.PdfFile"+j);
           if (Ofile.value == "") {
                alert("원본 문서 파일을 선택해 주세요");
                return;
            } else if (Pfile.value == "") {
                alert("PDF 파일을 선택해 주세요");
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
	if (getByteLength(f.AnsOpin.value) < 1) {
		alert("제출 의견을 입력해 주세요.");
		f.AnsOpin.focus();
		return;
	}

	if (confirm("작성하신 답변 자료를 등록하시겠습니까?")) {
		document.returnSubmitForm.AnsOpin.value = f.AnsOpin.value;
		f.count.value = numRef;
		if (ansType == "<%= CodeConstants.ANS_MTD_ELEC %>") {
            if (ezPDFConv.CountItem()>0) {
                f.action = "/reqsubmit/common/SAnsInfoEditProcPopup.jsp";
                f.target="processingFrame";
                document.all.loadingDiv.style.display = '';
                f.submit();
            } else {
    			var f2 = document.returnSubmitForm;
                f2.PdfFile.value = "";
                f2.OriginFile.value = "";
                f2.PdfFilePath.value = "";
                f2.DocFilePath.value = "";
                f2.MatType.value = "";
                f2.SendWay.value = "";
                f2.AnsOpin.value = f.AnsOpin.value;
                f2.AnsType.value = f.AnsType.value;
                f2.OpenCL.value = f.OpenCL.value;
                f2.action = "/reqsubmit/common/SAnsInfoEditProc.jsp";
                document.all.loadingDiv.style.display = '';
                f2.submit();
            }
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
			f2.action = "/reqsubmit/common/SAnsInfoEditProc.jsp";
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


<!-- /////////////////////////////	ezPDF Workboard XS SCRIPT START	///////////////////////////// -->

<!--
메소드

- InitParam : 웹브라우저가 IE가 아닌 경우에 컨트롤을 초기화하기 위해 호출한다.
	원형	: void InitParam(void);
	Param	: 없음
	Return	: 없음

- CountItem	: 컨트롤에 등록된 아이템 개수를 얻는다.
	원형	: LONG CountItem(void);
	Param	: 없음
	Return	: 아이템 개수(성공), -1(실패)

- AddItem : 컨트롤에 파일 아이템을 등록 한다.
	원형 : BOOL AddItem(LPCTSTR szPath, bool bFileDialog);
	Param	: szPath(파일 경로), bFileDialog(1[파일 열기 다이얼로그 보기], 0[파일 열기 다이얼로그 보지 않기])
	Return : TRUE(성공), FALSE(실패)

- DeleteItem : 컨트롤의 아이템 삭제 한다.
	원형	: LONG DeleteItem(LONG index);
	Param	: index(삭제할 아이템의 인덱스)
	Return	: 삭제된 아이템의 인덱스(성공), -1(실패)

- DeleteItemAll : 컨트롤의 전체 아이템을 삭제 한다.
	원형	: void DeleteItemAll(void);
	Param	: 없음
	Return	: 없음

- DeleteItemSel : 컨트롤의 선택된 아이템을 삭제 한다.
	원형	: void DeleteItemSel(void);
	Param	: 없음
	Return	: 없음

- GetItemPath : 원본 파일의 경로를 얻는다.
	원형	: BSTR GetItemPath(LONG index);
	Param	: index(아이템의 인덱스)
	Return	: 원본 파일의 경로

- GetItemPdfPath : 변환된 PDF 파일의 경로를 얻는다.
	원형	: BSTR GetItemPdfPath(LONG index);
	Param	: index(아이템의 인덱스)
	Return	: PDF 파일의 경로

- GetItemState : 아이템의 상태 정보를 얻는다.
	원형	: LONG GetItemState(LONG index);
	Param	: index(아이템의 인덱스)
	Return	: 변환 대기(1), 변환중(2), 변환 완료(3), 변환 실패(4)

- ConvertStart : 변환 작업을 시작한다.
	원형	: LONG ConvertStart();
	Param	: 없음
	Return	: 0(성공), 0을 제외한 수(실패)

- ConvertCancel : 변환 작업을 중지한다.
	원형	: LONG ConvertCancel();
	Param	: 없음
	Return	: 0(성공), 0을 제외한 수(실패)

이벤트
IE
- FinishProcess(nError) : 변환 작업이 종료되어 다시 변환 작업을 시작 할 수 있을 때 호출된다.
	nError : 변환 실패한 개수

모질라 계열(※모질라 계열은 이벤트 처리기가 없으므로... 모듈에서 아래의 자바스크립트를 실행함)
- ezPDFConv_EnableProcess(nError)
	nError : 변환 실패한 개수
-->

<script language="javascript">
function ezPDFConv_FinishProcess(nError)
{
	var str = "FinishProcess0000 = ";
	str += nError;
	alert(str);
}
</script>

<script LANGUAGE="JavaScript" FOR="ezPDFConv" EVENT="FinishProcess(nError)">
	var str = "FinishProcess = ";
	str += nError;
//	alert(str);

	var i=0;
	var state;
	var count = ezPDFConv.CountItem();

	for(i=0; i<count; i++)
	{
		state = ezPDFConv.GetItemState(i);
		if(state == 3) // 변환 완료.
		{
			 // 로컬 파일(원본,PDF) 경로를 업로드 컴포넌트에 전송
			document.getElementById('filectl').AddLocalFile(ezPDFConv.GetItemPath(i));
            document.getElementById('filectl').AddLocalFile(ezPDFConv.GetItemPdfPath(i));
		}
	}
	var dt = new Date();
	for (i = 0; i < filectl.FileCount; i++)
	{
		var fileinfo = filectl.GetFileInfo(i);
		document.getElementById('filectl').AddHiddenValue("filename",fileinfo.FileName);
		var v_time = dt.getTime()+"<%=objUserInfo.getUserID()%>"+i;
		document.getElementById('filectl').AddHiddenValue("newfilename",v_time);
		new_filename_v[i] = v_time;
	}
	document.getElementById('filectl').AddHiddenValue("_SUB_DIR",SubDir);
	// upload();
    setTimeout("upload()", 1000);

</script>

<script language="javascript" >
window.onload = function () {
	if (navigator.appName != "Microsoft Internet Explorer")
	{
		document.ezPDFConv.InitParam();
	}
}
</script>

<!-- /////////////////////////////	ezPDF Workboard XS SCRIPT END	///////////////////////////// -->

<!-- /////////////////////////////	INNODSP SCRIPT START	///////////////////////////// -->
<script type="text/javascript">
    function upload()
    {
        if (filectl.FileCount > 0) {
			filectl.UploadURL = "/InnoDSP/action_nads2.jsp";
			//filectl.SplitUploadMB = 10;
            filectl.StartUpload();
        }
    }
	
    function filectl_UploadSuccess(response){
		var fileCount = filectl.FileCount;
        var oForm = document.inputForm;
        oForm.count.value = filectl.FileCount/2;
        oForm.target = "processingFrame";
        InnoDSSubmitMulti(document.inputForm);
    }
	function InnoDSSubmitMulti(_FormObject)
	{
		var itemCount = filectl.FileCount;
		var z = '';
		for( var i = 0 ; i < itemCount ; i++ )
		{
			var fileinfo = filectl.GetFileInfo(i);
			if (InputType == 'array') 
			{
				z = '[]';
			} 
			else if (InputType == 'ordernum') 
			{
				z = new String(i+1);
			} 
			else 
			{
				z = '';
			}
			var index = ""+i;
			var FileName = new_filename_v[index]+"."+fileinfo.FileName.substring(fileinfo.FileName.length-3);
			
			var _ds_filename = '_innods_filename' + z;
			var oInput1 = document.createElement( 'input' );
			oInput1.type = 'hidden';
			oInput1.name = _ds_filename ;
			oInput1.value = FileName;
			_FormObject.insertBefore( oInput1, _FormObject.firstChild );
		}
		var oInput  = document.createElement('input');
		oInput.type = 'hidden';
		oInput.name = '_SUB_DIR';
		oInput.value = SubDir;
		_FormObject.insertBefore(oInput, _FormObject.firstChild);
		_FormObject.submit();
	}
</script>

<!-- /////////////////////////////	INNODSP SCRIPT END	///////////////////////////// -->

</head>
<title>
답변 수정
</title>
<body onload="javascript:changeInputForm('<%=strAnsMtd %>');">
<!-- 업로드 알림창 -->
<!-- <div id="uploadInfo" style="display:none;position:absolute; left:150px; top:250px; width:131px; height:75px; z-index:12;  border: 1px none #000000;"> -->
<div id="uploadInfo" style="display:none;position:absolute; left:175px; top:240px; width:285px; height:119px; z-index:12;  border: 1px none #000000;">
    <img src="/images2/common/loading.gif">
</div>
<!-- 업로드 알림창 -->
<div  id="fileupload">
<iframe name='processingFrame' height='0' width='0'></iframe>

<DIV ID="loadingDiv" style="width:220;height:180;display:none;position:absolute;left:80;top:120">
	<img src="/image/reqsubmit/loading.jpg" border="0"> </td>
</DIV>

<div class="popup">
<p>답변 수정</p>

<!------------------------- 답변 작성 정보 입력 폼 시작 ------------------------->
<form 	name="inputForm"
	action="/reqsubmit/common/SAnsInfoEditProcPopup.jsp"
	method="post" enctype="multipart/form-data" style="margin:0px">
		<input type="hidden" name="ReqBoxID" value="<%= strReqBoxID %>">
		<input type="hidden" name="ReqID" value="<%= strReqID %>">
    	<input type="hidden" name="AnsID" value="<%= strAnsID %>">
        <input type="hidden" name="AnsFileID" value="<%= objRsSH.getObject("ANS_FILE_ID") %>">
        <input type="hidden" name="AnsType" value="<%= strAnsMtd%>">
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
		<input type="hidden" name="OpenCL" value="<%= CodeConstants.OPN_CL_OPEN %>">
		<input type="hidden" name="AddAnsFlag" value="<%= strAddAnsFlag %>">
		<input type="hidden" name="UserDN" value="<%= strUserDN %>">
		<input type="hidden" name="count">
		<input type="hidden" name="_SUB_DIR" value="<%=yearStr%>">

		<table width="100%" cellpadding="0" cellspacing="0">
			<tr>
				<td width="100%" style="padding:10px;">
					<table border="0" cellspacing="0" cellpadding="0" class="list02">
						<tbody>
							<tr>
								<th height="25">&bull;&nbsp;&nbsp;답변유형 </th>
                                <td>
                                    <%= CodeConstants.getAnswerMethod(strAnsMtd) %>
                                </td>
							</tr>
                            <tr>
                                <th height="25">&bull;&nbsp;&nbsp;제출자 </th>
                                <td>
                                    <%= objRsSH.getObject("USER_NM") %>
                                </td>
                            </tr>
                            <tr>
                                <th height="25">&bull;&nbsp;&nbsp;제출일 </th>
                                <td><%= StringUtil.getDate((String)objRsSH.getObject("ANS_DT")) %></td>
                            </tr>
							<tr>
								<th height="25">&bull;&nbsp;&nbsp;제출의견 </th>
								<td>
								<textarea
								onKeyDown="javascript:updateCharAnother(document.inputForm, 'AnsOpin', 250)"
								onKeyUp="javascript:updateCharAnother(document.inputForm, 'AnsOpin', 250)"
								onFocus="javascript:updateCharAnother(document.inputForm, 'AnsOpin', 250)"
								onClick="javascript:updateCharAnother(document.inputForm, 'AnsOpin', 250)"
								name="AnsOpin" wrap="hard" rows="6" cols="72" style="width:90%;"><%= objRsSH.getObject("ANS_OPIN") %></textarea>
								<br />
								<span id ="textlimit"></span>&nbsp;bytes (250 bytes 까지만 입력됩니다)
								</td>
							</tr>
                            <%
                                if (CodeConstants.ANS_MTD_ELEC.equalsIgnoreCase(strAnsMtd)) { // 답변 유형이 전자문서라면
                            %>
                            <tr>
                                <th height="25">&bull;&nbsp;&nbsp;원본파일 </th>
                                <td>
                                    <%= objRsSH.getObject("ORG_FILE_PATH") %>
                                </td>
                            </tr>
                            <tr>
                                <th height="25">&bull;&nbsp;&nbsp;제출파일 </th>
                                <td>
                                    <input type="hidden" name="AnsFileID" value="<%= StringUtil.padl((String)objRsSH.getObject("ANS_FILE_ID"), 10) %>">
                                    <%= objRsSH.getObject("PDF_FILE_PATH") %>
                                </td>
                            </tr>
                            <%}%>
							<tr>
								<td height="25" colspan="2">
									<!-------------------------------------------- 동적으로 변화하는 FORM START ---------------------------------------------------->
									<DIV id="inputDiv" style="position:relative; left:0px;top:0px;width:460; border-width:0px; border-style:none;">
									<!--
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
									-->
									</DIV>

									<!-------------------------------------------- 동적으로 변화하는 FORM END ---------------------------------------------------->
									<span id="filesubmit"></span><span id="filesubmit"></span>
									<span id="filesubmit"></span><span id="filesubmit"></span><span id="filesubmit"></span>
								</td>
							</tr>
						 </tbody>
					</table>
				</td>
			</tr>
		</table>
</form>

</div>

<!-- /////////////////////////////	ezPDF DIV START	///////////////////////////// -->
<table id="inputDiv2" width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr><td>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr><td  align="center">
		<script language="javascript">
			if (navigator.appName == "Microsoft Internet Explorer") {
				var str = "<OBJECT ID='ezPDFConv' height='80' width='580' CLASSID='CLSID:ABBFCE48-008E-4DA1-8F5F-DF9E9749DC9D'";
				str = str + " codebase='http://naps.assembly.go.kr/cab/ezPDFConv.cab#Version=1,0,0,6' ";
				str = str + " hspace='10' vspace='10' align='middle'>";
				str = str + "</OBJECT>";
				document.write(str);
			}else{
				// Mozilla Plugin Info.
				var	ezPDF_PluginType = "application/npezPDFConv";
				var	ezPDF_PluginName = "ezPDFConv";
				var	ezPDF_PluginDescription = "ezPDFConv Plugin Ver. 1.0.0.5";

				// Mozilla Plugin Check
				var	ezPDF_PluginOK = false;
				var	ezPDF_PluginVersionOK = false;
				var ezPDFPlugin = navigator.plugins[ezPDF_PluginName];
				if( ezPDFPlugin != null ){
					ezPDF_PluginOK = true;
					if(ezPDFPlugin.description >= ezPDF_PluginDescription) {
						 ezPDF_PluginVersionOK = true;
					}
				}

				var str = "";
			if (ezPDF_PluginOK) {
				if(ezPDF_PluginVersionOK) {
					str = str + "<embed type='" + ezPDF_PluginType + "'";
					str = str + " name='ezPDFConv' id='ezPDFConv' width='60%' height='70%' border='0'";
					str = str + " hspace='10' vspace='10' align='middle' />";
				}
				else {
					var str = "";
					str = str + "<table width='100%' height='80%' border='0'>";
					str = str + "<TR><TD>";
					str = str + "<center>";
					str = str + "뷰어(ezPDFConv Plug-in)가 최신 버젼이 아닙니다.<BR>";
					str = str + "최신 버젼을  설치하여 주시기 바랍니다.<BR>";
					str = str + "<BR>";
					str = str + "<A HREF='http://naps.assembly.go.kr/cab/ezPDFConv.exe'>Install ezPDFConv Plug-in</A>";
					str = str + "</TD></TR>";
					str = str + "</table>";
				}
			}
			else {
				str = str + "<table width='100%' height='80%' border='0'>";
				str = str + "<TR><TD>";
				str = str + "<center>";
				str = str + "뷰어(ezPDFMg Plug-in)를 설치하지 않으면 문서를 열람하실 수 없습니다.<BR>";
				str = str + "뷰어를 설치하여 주시기 바랍니다.<BR>";
				str = str + "<BR>";
				str = str + "<A HREF='http://naps.assembly.go.kr/cab/ezPDFConv.exe'>Install ezPDFConv Plug-in</A>";
				str = str + "</TD></TR>";
				str = str + "</table>";
			}
			document.write(str);


		}
		</script>
		<script type="text/javascript">
			document.writeln(shtml);
			filectl = document.getElementById('filectl');
			if (GBrowser.isMSIE)
			{
				shtml = '<sc' + 'ript type="text/javascript" for="filectl" Event="UploadSuccess(response)">			filectl_UploadSuccess(response);</sc' + 'ript>';
				shtml += '<sc' + 'ript type="text/javascript" for="filectl" Event="UploadSuccessObjectMoved(locationURL)">			filectl_UploadSuccessObjectMoved(locationURL);</sc' + 'ript>';
				shtml += '<sc' + 'ript type="text/javascript" for="filectl" Event="UploadErrorOccurred(errorType, errorCode, errorDesc, response)">filectl_UploadErrorOccurred(errorType, errorCode, errorDesc, response);</sc' + 'ript>';
				shtml += '<sc' + 'ript type="text/javascript" for="filectl" Event="UploadCanceled()">filectl_UploadCanceled();</sc' + 'ript>';
				shtml += '<sc' + 'ript type="text/javascript" for="filectl" Event="ChangingUploadFile(filePath, fileSize, totalFileCount, totalFileSize)">return filectl_ChangingUploadFile(filePath, fileSize, totalFileCount, totalFileSize);</sc' + 'ript>';
				document.writeln(shtml);
			}
			else
			{
				filectl.EventChangingUploadFile = 'filectl_ChangingUploadFile';
				filectl.EventUploadSuccess = 'filectl_UploadSuccess';
				filectl.EventUploadSuccessObjectMoved = 'filectl_UploadSuccessObjectMoved';
				filectl.EventUploadErrorOccurred = 'filectl_UploadErrorOccurred';
				filectl.EventUploadCanceled  = 'filectl_UploadCanceled';
			}
		</script>
        </td></tr>
	</table>
    </td></tr>
    <tr><td>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
		<tr>
			<td align="left" height="50px;">&nbsp;&nbsp;&nbsp;

				<input type="button" value="파일추가" onClick="ezPDFConv.AddItem('c:\\1.xml', 1)" style="cursor:hand; width:70px; height:25px;" onfocus="this.blur();">
				<input type="button" value="개별삭제" onClick="ezPDFConv.DeleteItemSel();" style="cursor:hand; width:70px; height:25px;" onfocus="this.blur();">
				<input type="button" value="전체삭제" onClick="ezPDFConv.DeleteItemAll();" style="cursor:hand; width:70px; height:25px;" onfocus="this.blur();">

			</td>
		</tr>
	</table>
    </td></tr>
    <tr><td>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
		<tr>
			<td align="center" height="50px;">
                <span class="list_bt" onclick="javascript:if (document.inputForm.AnsOpin.value == ''){alert('제출의견을 입력해 주세요');}else{if(ezPDFConv.CountItem()==1){ezPDFConv.ConvertStart();} else if(ezPDFConv.CountItem()>1){alert('1개만 등록이 가능합니다.');}else{checkSubmit();}}" style="cursor:hand"><a href="#">답변수정</a></span>
                <span class="list_bt"><a href="javascript:window.close();">답변취소</a></span>
			</td>
		</tr>
	</table>
    </td>
    </tr>
</table>

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
    <input type="hidden" name="AnsID" value="<%= strAnsID %>">
    <input type="hidden" name="AnsFileID" value="<%= objRsSH.getObject("ANS_FILE_ID") %>">
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

	<input type="hidden" name="AnsType" value="<%=strAnsMtd%>">
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
	<input type="hidden" name="count" value="0">
</FORM>

</center>
</div>
<div id="download" style="display:none;">
<script>
    function fdown(){
		if (GBrowser.isMSIEx64) document.location.href="/cab/tabsfileup4setup_x64.exe";
		else document.location.href="/cab/tabsfileup4setup.exe";
    }
    function pdown(){
        document.location.href="/cab/ezSetup.exe";
    }
</script>
<table border="0" cellpadding="0" cellspacing="0" width="480" height="260" align="center">
	<tr><td background="/js2/InnoDSP/img/install_bg_01.gif" style="padding-top:179px" valign="top" align="center">
	<table border="0" cellpadding="0" cellspacing="0">
		<tr><td style="padding:0px 0px 1px 0px;">
			</td>
			<td style="padding-left:10px">
            <span id="filedownload" style="display:none">
                <a id="innomp_download_link" href="javascript:fdown();"><img src='/images2/btn/btn01.gif'/></a>
            </span>
            <span id="pdfdownload" style="display:none">
                <a id="innomp_download_link" href="javascript:pdown();"><img src='/images2/btn/btn02.gif'/></a>
            </span>
			</td>
		</tr>
	</table>
	<iframe id="innomp_downlaod_frame" src="download.html" style="width:0px;height:0px;border:0px"></iframe>
	<div id="innomp_check_obj"></div>
	</td></tr>
</table>
</div>

<div style="border: 0px solid #c0c0c0; width:0px;">
<script type="text/javascript">

    try{
        document.getElementById('filectl').AddLocalFile("");
    } catch(err) {
        document.getElementById("fileupload").style.display="none";
        document.getElementById("download").style.display="";
        document.getElementById("filedownload").style.display="";
    }

</script>
</div>
</body>
</html>