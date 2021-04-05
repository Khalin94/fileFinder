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
    // 현재연도
    Calendar calendar = Calendar.getInstance();
    int year = calendar.get(calendar.YEAR);
    String yearStr = Integer.toString(year);
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
    String strAction = "/reqsubmit/common/ReqInfoWriteAllInOneProc.jsp";
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

    ResultSetSingleHelper objRsSH=null;    /** 요구일정 정보 출력용  ResultSetSingleHelper*/
    ResultSetHelper objSubmtOrganRs=null;  /** 제출기관 리스트 출력용 ResultSetHelper */
    ResultSetHelper objRltdDutyRs=null;   /** 관련기관 리스트 출력용 RsHelper */
    ResultSetHelper objOrganRs = null;
    ResultSetHelper objSelectOrganRs = null;
    ResultSetHelper objSelectUser = null;
    Hashtable objhashdata4 = null;
    String SessionNo2 = "";

    try {
           /********* 대리자 정보 설정 *********/
        CommRequestBoxDelegate objReqBox=new CommRequestBoxDelegate();         /**요구함 Delegate*/
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
//SessionNo2 = "333";
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

<jsp:include page="/inc/header.jsp" flush="true"/>
<script language=Javascript src="/js/reqsubmit/common.js"></script>
<script language=Javascript src="/js/nads_lib.js"></script>
<script language=Javascript src="/js/datepicker.js"></script>
<script language="javascript" src="/js/forum.js"></script>



<script src="/unidocs/ezPDF.js" type="text/javascript"></script>
<script src="/raonkupload/js/raonkupload.js" type="text/javascript"></script>

<script type="text/javascript">
	//팝업이 화면 뒤로 숨었을 경우 앞으로 돌려준다.
	window.focus();



	var G_UploadID = "kupload";
	var G_ConvertList = null;
	var G_CurrIndex = 0;
	var G_FocusElementForScroll = null;
	var G_LastPDFConvertResult = null;

	var SubDir = "<%=yearStr%>";
	var InputType = "fixed";
		//유니닥스 베이스 객체 생성
	var ezpdf = null;

	window.onload = function() {

		ezpdf = new ezPDFWFLauncher(ezPDFWSPrinter, ezPDFData);

		//라온업로드 생성
		new RAONKUpload({
			Width : '98%',
			Id: G_UploadID,
            UploadHolder: "uploadHoder_PlaceHolder",
			ButtonBarEdit: "add,remove,remove_all",
			HeaderBarItem: "변환상태",
			HeaderBarItemWidth: "75",
			HeaderBarItemAlign: "center",
			ExtensionAllowOrLimit: "1",
			ExtensionArr: "txt,hwp,doc,docx,xls,xlsx,ppt,pptx,jpg,jpeg,png,gif,tif,tiff,pdf",
			UseFileSort: 0
        });

	}


	// Unidocs
	function WorkBoard_LoadWBXS() {

		console.log("PDF Convert - WorkBoard_LoadWBXS");

		fn_convertPDF();
	}
	// 변환요청 성공
	function WorkBoard_SetUploadFile(s) {
		console.log("PDF Convert - WorkBoard_SetUploadFile");

		var result = eval(s);
		G_LastPDFConvertResult = result;
		// PDF 상태
		RAONKUPLOAD.SetCustomHeaderByIndex(G_CurrIndex, "<img alt='변환완료' src='/unidocs/icon/pdf.png' /> 변환완료", G_UploadID);

		G_ConvertList.shift();
		G_CurrIndex++;

		fn_convertPDF(G_LastPDFConvertResult);
	}
	// 변환요청 실패
	function WorkBoard_FailConvert(code){
		console.log("PDF Convert - WorkBoard_FailConvert");

		var errCode = code;
		var error = "";

		error = strJobFile + "을(를) 변환할 수 없습니다.";
		alert(error);

		G_ConvertList.shift();
		G_CurrIndex++;

		fn_convertPDF();
	}
	function ezPDF_SendMessage(msg) {
		ezpdf.SetData(msg);
	}
	function ezPDF_SetConvertFile(msg, filepath) {
		var d = "AddItem|";
		d += filepath;
		d += ";";

		return msg + d;
	}
	function ezPDF_ConvertStart(msg) {
		var d = "ConvertStart|";
		d += ";";

		return msg + d;
	}
	function ezPDF_DeleteItemAll(msg) {
		var d = "DeleteItemAll|";
		d += ";";

		return msg + d;
	}
	// Unidocs

	// K UPload
	// 추가버튼
	function fn_openFileDialog() {
		RAONKUPLOAD.OpenFileDialog(G_UploadID);
	}

	// PDF 변환 후 전송
	function fn_PDFConvertUpload() {


			G_CurrIndex = 0;
			var dataArray = RAONKUPLOAD.GetListInfo('array', G_UploadID);
			G_ConvertList = dataArray.mergeFile;


			ezpdf.Launch();


	}

	function fn_convertPDF(convertResult) {
		if(G_ConvertList && G_ConvertList.length > 0) {
			ezPDF_DeleteItemAll("");

			if(G_ConvertList[0].isWebFile == "1") {
				G_ConvertList.shift();
				G_CurrIndex++;
				fn_convertPDF();
			} else {
				// PDF 상태
				var _elem = RAONKUPLOAD.SetCustomHeaderByIndex(G_CurrIndex, "<img alt='변환중' src='/unidocs/icon/spinner.gif' /> 변환중", G_UploadID);
				var _divHeight = parseInt(RAONKUPLOAD.GetUploadByName(G_UploadID).frameWin.document.getElementById("RAON_K_UP_file_temp").style.height);
				var _uploadViewCount = parseInt( _divHeight / 20 );

				if( (G_CurrIndex+1) % _uploadViewCount == 0) {
					G_FocusElementForScroll && G_FocusElementForScroll.scrollIntoView(true);
				} else {
					G_FocusElementForScroll = _elem;
				}

				var encfilePath = Base64.encode(G_ConvertList[0].localPath);
				var msg = "";
				msg = ezPDF_SetConvertFile(msg, encfilePath);
				msg += ezPDF_ConvertStart(msg);

				ezPDF_SendMessage(msg);
			}
		} else {

			if(convertResult) {
				var arrayFileList = new Array();
				for(var idx=0, len=convertResult.length; idx < len; idx++) {
					arrayFileList.push({
						path: convertResult[idx].filePath
					});
				}

				var _fileInfo = RAONKUPLOAD.GetListInfo('array', G_UploadID);

				// 기존 변환된 웹파일 처리 (수정시)
				RAONKUPLOAD.ResetUpload(G_UploadID);

				if(_fileInfo.webFile != null) {
					for(var idx=0, _webFile = _fileInfo.webFile, len = _webFile.length; idx < len; idx++) {
						RAONKUPLOAD.AddUploadedFileEx(_webFile[idx].uniqKey, _webFile[idx].originalName, _webFile[idx].uploadPath, _webFile[idx].size, _webFile[idx].customValue, "<img alt='변환완료' src='/unidocs/icon/pdf.png' />", G_UploadID);
					}
				}

				// 변환된 신규 파일 처리
				RAONKUPLOAD.AddLocalFileDirectlyEx(arrayFileList, function() {
						// 변환상태 처리
						var _defaultIdx = _fileInfo.webFile == null ? 0 : _fileInfo.webFile.length;
						for(var idx=_defaultIdx, len=idx+arrayFileList.length; idx < len; idx++) {
							RAONKUPLOAD.SetCustomHeaderByIndex(idx, "<img alt='변환중' src='/unidocs/icon/pdf.png' />", G_UploadID);
						}

						window.setTimeout(function(){
							RAONKUPLOAD.Transfer(G_UploadID);
						}, 500)
					}
				, G_UploadID);
			}
		}
	}

    // 생성완료 이벤트
    function RAONKUPLOAD_CreationComplete(uploadID) {
		//RAONKUPLOAD.AddUploadedFileEx("1", "test.jpg", "", "1000", "", "<img alt='변환완료' src='/unidocs/icon/pdf.png' /> 변환완료", uploadID)
		//RAONKUPLOAD.AddUploadedFileEx("1", "test.jpg.pdf", "", "1000", "", "<img alt='변환완료' src='/unidocs/icon/pdf.png' /> 변환완료", uploadID)
    }

 // 파일 추가 후 이벤트 (추가되는 파일 개수 만큼 발생합니다.)
    function RAONKUPLOAD_AfterAddFile(uploadID, paramObj) {
        // paramObj.nIndex : 파일 인덱스
        // paramObj.strName : 파일명
        // paramObj.nSize : 파일 사이즈
        // paramObj.strPath : 파일 경로

        // 추가된 파일에 원하는 data를 추가해 주는 API 입니다.
        // 이 페이지에서는 파일 추가 시 "markvalue_순번" 값을 넣어주도록 되어있습니다.
        RAONKUPLOAD.SetFileCustomValue(-1, paramObj.nIndex, uploadID);

        // SetFileMark API 설명
        // 첫번째 파라미터 : 0부터 시작되는 파일의 순서정보, -1입력시 마지막에 추가된 파일
        // 2번째 파라미터 : 해당 파일에 추가할 data
        // 3번째 파라미터 : API를 실행할 업로드 ID

        //var logBox = document.getElementById("logBox");
        //logBox.innerHTML += paramObj.strName + ' 파일에 customvalue_' + paramObj.nIndex + ' 값을 추가하였습니다.' + '<br/>';

    }

    // 전송완료 이벤트
    function RAONKUPLOAD_UploadComplete(uploadID) {
		//alert("전송성공");

		ezpdf.Close();

		var oForm = document.formName;
		var fileCount =  RAONKUPLOAD.GetTotalFileCount(uploadID);
		var getFileList = RAONKUPLOAD.GetListInfo("array", uploadID);



        oForm.count.value = getFileList.newFile.length / 2;
        oForm.action = "/reqsubmit/common/AnsInfoWriteAllInOneProcPopup.jsp";
        oForm.encoding="multipart/form-data";
        oForm.target = 'processingFrame';

        uploadProcess(oForm, getFileList);


    }

    // 오류 이벤트
    function RAONKUPLOAD_OnError(uploadID, paramObj) {
        alert("전송오류 : " + paramObj.strMessage);
		ezpdf.Close();
		RAONKUPLOAD.ResetUpload(G_UploadID);
    }

    // 취소 이벤트
    function RAONKUPLOAD_UploadingCancel(uploadID, paramObj) {
        alert("전송취소");
		ezpdf.Close();
		RAONKUPLOAD.ResetUpload(G_UploadID);
    }
	// K UPload 이벤트




    //InnoDSSubmit과 같은 역활
	function uploadProcess(_FormObject, _DSObject)
	{

		var itemCount = _DSObject.newFile.length;

		var z = '';

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

		var orgName="";
		var orgPdfName="";
		console.log( "uploadProcess=============" );
		console.log( _DSObject );
		console.log( "=============" );


		arrayFileName = _DSObject.newFile;

		for( var i = 0 ; i < itemCount ; i++ )
		{
			var FileName = arrayFileName[i].uploadName;
			var FileSize = arrayFileName[i].size;
			var Folder = "";
			var SendBytes = arrayFileName[i].size;
			var Status = "";


			var clientFile = arrayFileName[i].originalName;

			var fileType = arrayFileName[i].extension;

			if( fileType.toLowerCase() == "pdf") {

				if( i%2 != 0 ) {
					orgPdfName +=  clientFile + "Ω";
				}
				else {
					orgName += clientFile + "Ω";
				}
			}
			else {
				orgName += clientFile + "Ω";
			}


			console.log("orgPdfName="+orgPdfName );
			console.log("orgName="+orgName );

			var _ds_filename = '_innods_filename' + z;
			var _ds_filesize = '_innods_filesize' + z;
			var _ds_filefolder = '_innods_folder' + z;
			var _ds_sendbytes = '_innods_sendbytes' + z;
			var _ds_status = '_innods_status' + z;

			var oInput1 = document.createElement( 'input' );
			var oInput2 = document.createElement( 'input' );
			var oInput3 = document.createElement( 'input' );
			var oInput4 = document.createElement( 'input' );
			var oInput5 = document.createElement( 'input' );

			oInput1.type = 'hidden';
			oInput2.type = 'hidden';
			oInput3.type = 'hidden';
			oInput4.type = 'hidden';
			oInput5.type = 'hidden';

			oInput1.name = _ds_filename;
			oInput2.name = _ds_filesize;
			oInput3.name = _ds_filefolder;
			oInput4.name = _ds_sendbytes;
			oInput5.name = _ds_status;

			oInput1.value = FileName;
			oInput2.value = FileSize;
			oInput3.value = Folder;
			oInput4.value = SendBytes;
			oInput5.value = Status;

			_FormObject.insertBefore( oInput1, _FormObject.firstChild );
			_FormObject.insertBefore( oInput2, _FormObject.firstChild );
			_FormObject.insertBefore( oInput3, _FormObject.firstChild );
			_FormObject.insertBefore( oInput4, _FormObject.firstChild );
			_FormObject.insertBefore( oInput5, _FormObject.firstChild );

		}

		console.log("폼준비")

		var _ds_orifilename = '_innods_orifilename';
	    var _ds_oripdffilename = '_innods_oripdffilename';
	    var oInput1 = document.createElement('input');
	    var oInput2 = document.createElement('input');
	    oInput1.type = 'hidden';
	    oInput2.type = 'hidden';
	    oInput1.name = _ds_orifilename;
	    oInput2.name = _ds_oripdffilename;
	    oInput1.value = orgName;
	    oInput2.value = orgPdfName;
	    _FormObject.insertBefore(oInput1, _FormObject.firstChild);
	    _FormObject.insertBefore(oInput2, _FormObject.firstChild);


		var oInput  = document.createElement('input');
		oInput.type = 'hidden';
		oInput.name = '_SUB_DIR';
		oInput.value = SubDir;

		_FormObject.insertBefore(oInput, _FormObject.firstChild);


		_FormObject.submit();
	}//uploadProcess

</script>




<script type="text/javascript" >
var numRef = 1;

function changeInputForm(value) {
    var str = "";
    if (value == "<%= CodeConstants.ANS_MTD_ELEC %>") { // 전자파일의 경우
        document.all.AFILE.style.display="none";
        document.all.inputDiv.style.display="none";
        document.all.inputDiv2.style.display="";


    } else if (value == "<%= CodeConstants.ANS_MTD_ETCS%>") { // 비전자파일의 경우
        for(var i = 1;i<5; i++){
           document.all.filesubmit[i].innerHTML="";
        }
        numRef = 1
        str = "";
        str = str + "<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\n";
        str = str + "<tr>\n";
        str = str + "<td style=\"width:100px;\" >* 매체유형</td>\n";
        str = str + "<td style=\"width:400px;\"><select name=\"MatType\"><option value=''>::: 선택해 주세요 :::</option>";
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
        str = str + "<tr>\n";
        str = str + "<td style=\"width:100px;\">* 발송 방법</td>\n";
        str = str + "<td style=\"width:400px;\"><select name=\"SendWay\"><option value=''>::: 선택해 주세요 :::</option>";
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
        str = str + "</table>\n";
        str = str + "<input type=hidden name=OriginFile value=''>\n";
        str = str + "<input type=hidden name=PdfFile value=''>\n";
        document.all.AFILE.style.display="";
        document.all.inputDiv2.style.display="none";
        document.all.inputDiv.style.display="";
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
        str    = str + "<td style=\"width:100px;\" "+strBgcolor+">\n";
        str    = str + "*원본 파일</td>\n";
        str    = str + "<td style=\"width:400px;\"><input type=\"file\" name=\"OriginFile"+numRef+"\" size=\"30\">\n";
        str    = str + "<a href=\"javascript:removebutton("+(numRef)+")\"><img src='/image/button/bt_cancel_admin.gif' border='0'></a></td></tr>\n";
        str    = str + "<tr><td style=\"width:100px;\" "+strBgcolor+">\n";
        str    = str + "*PDF 파일</td>\n";
        str    = str + "<td style=\"width:400px;\"><input type=\"file\" name=\"PdfFile"+numRef+"\" size=\"30\"></td>\n";
        str    = str + "<td align=\"center\">&nbsp;</td></tr>\n";
        str    = str + "</table>\n";
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
            return;
        }
        if(formName.elements['AnsDuty'].value == ""){
            alert("오프라인 요구유형을 선택해주세요");
            return;
        }
        if(formName.elements['reqdate'].value == ""){
            alert("요청일자를 선택해주세요");
            return;
        }
        if(formName.elements['CmtOrganID'].value == ""){
            alert("소관위원회를 선택해주세요");
            return;
        }
        if(formName.elements['ReqOrganID'].value == ""){
            alert("의원실을 선택해주세요");
            return;
        }if(formName.elements['RegrID'].value == ""){
            alert("담당자를 선택해주세요");
            return;
        }
        if(formName.elements['ReqCont'].value == ""){
            alert("요구명을 작성해 주세요");
            return;
        }
        if(formName.elements['ReqDtlCont'].value == ""){
            alert("요구내용을 작성해 주세요");
            return;
        }
        var f = document.formName;
        var ansType = f.AnsType.value;
        //alert(numRef);
        if (ansType == "<%= CodeConstants.ANS_MTD_ELEC %>") { // 전자파일인가요?

        	if (f.AnsOpin.value == '') {
                alert('제출의견을 입력해 주세요');
                return;
           	}
    		else if(RAONKUPLOAD.GetTotalFileCount(G_UploadID) <= 0) {
    			alert("등록 대상 파일이 없습니다.");
    			return;

    		}

            /* if (f.AnsOpin.value == "") {
                    f.AnsOpin.value = "";
            }

            if (control.getAllFiles()<1){
                alert("파일을 선택해주세요");
                return;
            } */

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

            return "1";
            //formName.action = "/reqsubmit/common/AnsInfoWriteAllInOneProcPopup.jsp";
            //formName.encoding="multipart/form-data";
            //formName.target = 'processingFrame';
            //formName.submit();
        } else {
            formName.target = 'processingFrame';
            formName.MatTypeNew.value = formName.MatType.value;
            formName.SendWayNew.value = formName.SendWay.value;
            formName.AnsTypeNew.value = formName.AnsType.value;
            formName.action = "/reqsubmit/common/AnsInfoWriteAllInOneProc.jsp";
            //document.all.loadingDiv.style.display = '';
            formName.submit();
        }
    }

        //formName.encoding="multipart/form-data";
        //formName.action = "AnsInfoWriteAllInOneProc.jsp";
        //formName.target = 'processingFrame';
        //formName.submit();
    }
    //
    function datechange(){
        formName.SubmtDln.focus();
        formName.SubmtDln.value = formName.reqdate.value;
    }
    function old_version(){
        document.location.href="AnsInfoWriteAllInOne_old.jsp";
    }
</script>




<script language="javascript" >
/* window.onload = function () {
    if (navigator.appName != "Microsoft Internet Explorer")
    {
        document.ezPDFConv.InitParam();
    }
} */

//업로드 알림창 함수
function showUploadInfo()
{
	var d = document;
	var uploadInfo = d.getElementById("uploadInfo");
	uploadInfo.style.display = "";
}
</script>

<!-- /////////////////////////////    ezPDF Workboard XS SCRIPT END    ///////////////////////////// -->

<!-- /////////////////////////////    INNODSP SCRIPT START    ///////////////////////////// -->
<%--
<script type="text/javascript" src="/js2/InnoDSP/InnoDS.js"></script>
<script type="text/javascript">
     function upload()
    {
        if (InnoDS.GetFileCount() > 0) {
            showUploadInfo();// 업로드 알림창 시작
			InnoDS.SilentMode = true;
            InnoDS.AddPostData("_SUB_DIR", SubDir);
            InnoDS.StartUpload();
        }
        else{
            var oForm = document.formName;
            oForm.count.value = InnoDS.GetFileCount()/2;
            oForm.target = "processingFrame";
            InnoDSSubmit(document.formName);
        }
    }
    function OnUploadComplete(objName){
		var fileCount = InnoDS.GetFileCount();
        var oForm = document.formName;
        oForm.count.value = InnoDS.GetFileCount()/2;
        formName.action = "/reqsubmit/common/AnsInfoWriteAllInOneProcPopup.jsp";
        formName.encoding="multipart/form-data";
        formName.target = 'processingFrame';
        oForm.target = "processingFrame";
        InnoDSSubmit(document.formName);
    }

</script>
 --%>
</head>

<body>
<!--<div id="uploadInfo" style="display:none;position:absolute; left:245px; top:320px; width:336px; height:76px; z-index:12;  border: 1px none #000000;">-->
<div id="uploadInfo" style="display:none;position:absolute; left:255px; top:320px; width:336px; height:76px; z-index:12;  border: 1px none #000000;">
    <img src="/images2/common/loading.gif">
</div>


<iframe name='processingFrame' height='0' width='0'></iframe>
<div class="reqBox">
<FORM method="post" name="formName">
    <p><%= strTitle %><span style="position:absolute; text-align:right; top:13px; right:15px;"><a href="javascript:old_version()"><img  src="/images2/btn/hand_answer.gif" width="95" height="25" border="0" /></a></span></p>

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
<input type="hidden" name="count">
<input type="hidden" name="_SUB_DIR" value="<%=yearStr%>">
<input type="hidden" name="OrgRealFileName" value="">
<input type="hidden" name="PdfRealFileName" value="">

    <table width="100%" cellpadding="0" cellspacing="0">
        <tr>
            <td width="100%" style="padding:10px;">
                <!-------------------- TABLE START-------------------------------->
                <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list02">
                    <tr>
                        <th align="left" scope="col" colspan="4">&bull;&nbsp;<strong>제출 기관   : <%= strOrgnaNM %></strong></th>
                    </tr>
                     <tr>
                        <th align="left" scope="col" style="width:150px;"><strong>&bull;&nbsp;회기 : </strong></th>
                        <td colspan="3">제
                            <input onKeyUp="CheckNumeric()" value="<%=SessionNo2%>" name="NatCnt" size="3" maxLength="3" onKeyUp="CheckNumeric()" />회 국회 </td>
                    </tr>
                    <tr>
                        <th align="left" scope="col" style="width:150px;"><strong>&bull;&nbsp;업무구분  </strong></th>
                        <td>
                            <select name="RltdDutyX">
                                <option value="">선택</option>
                                <option value="001" <%if(strRltdDutyX.equals("001")){%>selected<%}%>>국정감사</option>
                                <option value="002" <%if(strRltdDutyX.equals("002")){%>selected<%}%>>국정조사</option>
                                <option value="004" <%if(strRltdDutyX.equals("004")){%>selected<%}%>>결산</option>
                                <option value="005" <%if(strRltdDutyX.equals("005")){%>selected<%}%>>기금</option>
                                <option value="006" <%if(strRltdDutyX.equals("006")){%>selected<%}%>>법안</option>
                                <option value="003" <%if(strRltdDutyX.equals("003")){%>selected<%}%>>예산안</option>
                                <option value="007" <%if(strRltdDutyX.equals("007")){%>selected<%}%>>기타(임시회   등)</option>
                            </select>
                        </td>
                        <th scope="col" style="width:150px;">
                            <strong>&bull;&nbsp; 비전자 자료요구 유형</strong>
                        </th>
                        <td>
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
                        <th align="left" scope="col"><strong>&bull;&nbsp;요구 일자 : </strong></th>
                        <td>
                            <input name="reqdate" size="10" maxlength="8" value="<%=strReqDate%>"  OnClick="this.select()"
                        OnKeyPress="if ((event.keyCode&lt;48)||(event.keyCode&gt;57)) event.returnValue=false;" OnBlur="javascript:SetFormatDate(this);" Onfocus="javascript:datechange();" />&nbsp;&nbsp;<img src="/images2/btn/bt_calender.gif" width="17" height="13" OnClick="javascript:show_calendar('formName.reqdate');"/>
                        </td>
                        <th scope="col">
                            <strong>&bull;&nbsp;제출기한</strong>
                        </th>
                        <td>
                            <input name="SubmtDln" size="10" maxlength="8" value="<%=strSubmtDln%>"  OnClick="this.select()"
                        OnKeyPress="if ((event.keyCode&lt;48)||(event.keyCode&gt;57)) event.returnValue=false;" OnBlur="javascript:SetFormatDate(this);"/>&nbsp;&nbsp;<img src="/images2/btn/bt_calender.gif" width="17" height="13" OnClick="javascript:show_calendar('formName.SubmtDln');"/>
                        </td>
                    </tr>
                    <tr>
                        <th align="left" scope="col">&bull;&nbsp;소관위원회</th>
                        <td colspan="3">
                            <select name="CmtOrganID" onChange="searchSubmit()" style="width:350px;" >
                                <option value="">::::위원회를 선택해주세요:::</option>
                                <%while(objOrganRs.next()){%>
                                <option value="<%=objOrganRs.getObject("ORGAN_ID")%>" <%if(tempCmtOrganID.equals(objOrganRs.getObject("ORGAN_ID"))){%> selected <%}%>>
                                <%=objOrganRs.getObject("ORGAN_NM")%></option>
                                <%}%>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th align="left" scope="col">&bull;&nbsp;<strong>의원실   : </strong>
                        </th>
                        <td colspan="3">
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
<br />
                <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list02">
                    <tr>
                        <th align="left" scope="col"  style="width:150px;">&bull;&nbsp;<strong>요구명   : </strong>
                        </th>
                        <td colspan="3">
                            <input name="ReqCont" size="80" />
                        </td>
                    </tr>
                    <tr>
                        <th align="left" scope="col"  style="width:150px;">&bull;&nbsp;<strong>요구내용   : </strong>
                        </th>
                        <td colspan="3">
                            <textarea name="ReqDtlCont" rows="9" cols="80"  style="width:90%;"></textarea>
                        </td>
                    </tr>
                </table>
<br />
                 <p>답변 등록</p>

                <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list02">
                    <!--tr>
                        <th align="left" scope="col"  style="width:150px;">&bull;&nbsp;<strong>답변등록유형 : </strong>
                        </th>
                        <td colspan="3">
                            <div id="btn_all"  class="t_left">
                                <span class="list_bt"><a href="#" onClick="old_version();">수동답변등록</a></span>
                            </div>
                        </td>
                    </tr-->
                    <tr>
                        <th align="left" scope="col"  style="width:150px;">&bull;&nbsp;<strong>답변유형 : </strong>
                        </th>
                        <td colspan="3">
                            <select name="AnsType" onChange="javascript:changeInputForm(this.value)" class="select">
                                <option value="<%= CodeConstants.ANS_MTD_ELEC %>"><%= CodeConstants.getAnswerMethod(CodeConstants.ANS_MTD_ELEC) %></option>
                                <option value="<%= CodeConstants.ANS_MTD_ETCS %>"><%= CodeConstants.getAnswerMethod(CodeConstants.ANS_MTD_ETCS) %></option>
                            </select>
                        </td>
                    </tr>

                    <tr>
                        <th align="left" scope="col">&bull;&nbsp;<strong>제출의견 : </strong>
                        </th>
                        <td colspan="3">
                            <textarea name="AnsOpin" rows="9" cols="80"  style="width:90%;"></textarea>
                        </td>
                    </tr>
                    <tr id="AFILE" style="display:none;">
                        <th scope="col"  style="width:150px;">&bull;&nbsp;<strong>답변파일   : </strong>
                        </th>
                        <td colspan="3">
                            <DIV id="inputDiv" style="position:relative; left:0px;top:0px;width:600; border-width:0px; border-style:none;"></DIV>
                            <span id="filesubmit"></span><span id="filesubmit"></span>
                            <span id="filesubmit"></span><span id="filesubmit"></span><span id="filesubmit"></span>
                        </td>
                    </tr>
                </table>
                            <!-- /////////////////////////////    ezPDF DIV START    ///////////////////////////// -->

<DIV id="inputDiv2" style="position:relative; left:0px;top:0px;width:100%; border-width:0px; border-style:none;">
    <br>
    <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
	        <td align="center">
				<!-- 라온업로드 리스트 -->
                <div id="uploadHoder_PlaceHolder"></div>
	        </td>
        </tr>
    </table>
</DIV>
            </td>
        </tr>
    </table>
    <p style= "height:2px;padding:0;"></p>
    <br/>
    <font color="red">* PDF변환실패 시 상단의 "수동답변등록" 기능을 이용해 주시기 바랍니다. </font>
    <!-- 리스트 버튼-->
    <div id="btn_all"  class="t_right">
    	<input type="button" value="요구함저장" onClick="if(checkFormData()=='1'){fn_PDFConvertUpload();}"  style="cursor:hand; width:70px; height:25px;" onfocus="this.blur();">
        <!-- <span class="list_bt"><a href="#" onClick="if(checkFormData()=='1'){ConvertAndUpload();}">요구함저장</a></span> -->
        <!-- <span class="list_bt"><a href="#"  onClick="document.formName.reset();ezPDFConv.DeleteItemAll();">초기화</a></span> -->
        <span class="list_bt"><a href="#" onClick="self.close()">작성취소</a></span>&nbsp;&nbsp;
    </div>
</form>
    <!-- /리스트 버튼-->
</div>

</body>
</html>
