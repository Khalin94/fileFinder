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
    UserInfoDelegate objUserInfo = null;
    CDInfoDelegate objCdinfo = null;   
%>

<%
    // 현재연도
    Calendar calendar = Calendar.getInstance();
    int year = calendar.get(calendar.YEAR);
    String yearStr = Integer.toString(year);
%>

<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>

<%    /**
     * ********************************************************************
     * 기본적으로 항상 각 페이지별로 해야하는 작업. 이용자 로그인 정보를 확인한다. 즉, 세션이 생성되어져 있는지를 확인한다. 그리고,
     * 현재 화면을 구성하기 위해서 해당하는 요구의 간략 정보를 출력한다. 해당 간략 정보를 출력하기 위해서 요구ID를 파라미터로 받아서
     * 해당하는 함수를 호출한다. 그 하단에는 요구의 답변을 등록하는 등록 폼을 생성한다. 등록 폼은 답변 유형에 따라서 각기 다른 형태로
     * 폼을 제공하여야 한다. 답변 유형에 따라서 처리되는 프로세스의 내용도 고려되어야 하는 것을 잊지 말자!! 멀티 파일 업로드
     * 컴퍼넌트를 이용해서 답변을 등록하는 것! 폼의 타입을 잘 지정해 주자. 자 그럼 열심히 (__)
     *
     **********************************************************************
     */
    String strClientIP = request.getHeader("Proxy-Client-IP");

    System.out.println("ANSINFO IP############################################# :: " + strClientIP);

    MemRequestBoxDelegate reqDelegate = null;
    SMemReqInfoDelegate selfDelegate = null;
    SMemReqInfoVListForm objParams = new SMemReqInfoVListForm();

    boolean blnParamCheck = false;
    blnParamCheck = objParams.validateParams(request);
    if (blnParamCheck == false) {
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

    String strReqBoxSortField = StringUtil.getEmptyIfNull((String) objParams.getParamValue("ReqBoxSortField"));
    String strReqBoxSortMtd = StringUtil.getEmptyIfNull((String) objParams.getParamValue("ReqBoxSortMtd"));
    String strReqBoxPagNum = StringUtil.getEmptyIfNull((String) objParams.getParamValue("ReqBoxPage"));
    String strReqBoxQryField = StringUtil.getEmptyIfNull((String) objParams.getParamValue("ReqBoxQryField"));
    String strReqBoxQryTerm = StringUtil.getEmptyIfNull((String) objParams.getParamValue("ReqBoxQryTerm"));
    String AuditYear = StringUtil.getEmptyIfNull((String) request.getParameter("AuditYear"));

    // 요구 목록 관련
    String strReqInfoSortField = objParams.getParamValue("ReqInfoSortField");
    String strReqInfoSortMtd = objParams.getParamValue("ReqInfoSortMtd");
    String strReqInfoQryField = objParams.getParamValue("ReqInfoQryField");
    String strReqInfoQryTerm = objParams.getParamValue("ReqInfoQryTerm");
    String strReqInfoPagNum = objParams.getParamValue("ReqInfoPage");

    //공개비공개 테스트
    String strOpenCL = request.getParameter("ReqOpenCL");
    System.out.println("kangthis logs SAnsInfoWrite.jsp(strOpenCL) => " + strOpenCL);

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

    try {
        reqDelegate = new MemRequestBoxDelegate();
        selfDelegate = new SMemReqInfoDelegate();

        boolean blnHashAuth = reqDelegate.checkReqBoxAuth(strReqBoxID, objUserInfo.getOrganID()).booleanValue();

        if (!blnHashAuth) {
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
            strUserDN = StringUtil.getEmptyIfNull((String) objPrivateSession.getAttribute("UserDN"));
            System.out.println("objPrivateSession : " + strUserDN);
        }
    } catch (AppException e) {
        objMsgBean.setMsgType(MessageBean.TYPE_ERR);
        objMsgBean.setStrCode(e.getStrErrCode());
        objMsgBean.setStrMsg(e.getMessage());
        out.println("<br>Error!!!" + e.getMessage());
        return;
    }
%>

<jsp:include page="/inc/header.jsp" flush="true"/>  
<%-- <%@ include file="/inc/header.jsp" %> --%>

<style>
    .td_grayAnother {
        FONT-WEIGHT: bold; FONT-SIZE: 12px; COLOR: #5c5c5c; FONT-FAMILY: 돋움,verdana,seoul,Arial;BACKGROUND-COLOR: #E9E9E9 ; padding-left: 15px;
    }
</style>

<script language="javascript" src="/js/reqsubmit/common.js"></script>

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
		//** 여기에 없는 옵션은 /raonkupload/config/raonkupload.config.xml 에 설정되어있음
		//** 반드시 확인할것!!
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
			UseFileSort: 0,
			TransferProcess:"1"
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
		
		if (document.inputForm.AnsOpin.value == '') {
            alert('제출의견을 입력해 주세요');
            return;
       	} 
		else if(RAONKUPLOAD.GetTotalFileCount(G_UploadID) <= 0) {
			alert("등록 대상 파일이 없습니다.");
			return;			
			
		} else {
			
			G_CurrIndex = 0;
			var dataArray = RAONKUPLOAD.GetListInfo('array', G_UploadID);			
			G_ConvertList = dataArray.mergeFile;
			
			
			ezpdf.Launch();
			
		}
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
		
		ezpdf.Close();
		
		var oForm = document.inputForm;        
		var fileCount =  RAONKUPLOAD.GetTotalFileCount(uploadID);
		var getFileList = RAONKUPLOAD.GetListInfo("array", uploadID);
        		
		
		oForm.target = "processingFrame";
        oForm.count.value = getFileList.newFile.length / 2;
     
        
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
		
		/* var h = [];
		var j = [];
		
		var arrayFileName = [];
		
		
		for( var i=0; i < itemCount; i++) {
			
			 
			if( i%2 == 0) {
				j.push(_DSObject.files[i]);	
			}
			else {
				h.push(_DSObject.files[i]);
			}		
		}
		
		arrayFileName = j.concat(h); */
			
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
	    _FormObject.insertBefore(oInput1, document.inputForm.firstChild);
	    _FormObject.insertBefore(oInput2, document.inputForm.firstChild);
		

		var oInput  = document.createElement('input');
		oInput.type = 'hidden';
		oInput.name = '_SUB_DIR';
		oInput.value = SubDir;

		_FormObject.insertBefore(oInput, _FormObject.firstChild);	
				
		
		_FormObject.submit();
	}//uploadProcess
    
</script>


<script type="text/javascript">
// 어처구니 없는 함수임에 분명하다.
// 당장에는 별다른 대책이 없어서 우선 이렇게 둔다.
// 보다 획기적인 개선안이 하루빨리 떠오르길 바라며... -ㅅ-

    //var Enc = "F1yV/Ih1CIWKmwpkR++vU4L5x6Qw09ZdbnfMOMAF4yP/qX8ir89PSOJEu0KGxmZ7+nwY4oq8SqjF6+BH2rAyuehELATMrnCBJd33fPqR3zO0/EZoPZFUTOJnU4al6tZO+4gcNw==";
    
    
    

    var numRef = 1;
    function changeInputForm(value) {
        var str = "";
        if (value == "<%= CodeConstants.ANS_MTD_ELEC%>") { // 전자파일의 경우
            /*
             str = "";
             str = str + "<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\"><tr>\n"
             str    = str + "<td width=\"80\" height=\"20\" class=\"td_gray1\"><img src=\"/image/common/icon_nemo_gray.gif\" width=\"3\" height=\"6\">\n"
             str    = str + "원본 파일</td>\n"
             str    = str + "<td width=\"380\" height=\"20\" class=\"td_lmagin\"><input type=\"file\" class=\"textfield\" name=\"OriginFile0\" size=\"30\"></td>\n"
             str    = str + "<td width=\"100\" align=\"center\"><a href=\"javascript:submitbutton()\">파일추가</a></td></tr>\n"
             str = str + "<tr height=\"1\" class=\"tbl-line\">\n"
             str    = str + "<td height=\"1\" colspan=\"3\"></tr>\n"
             str    = str + "<tr><td height=\"20\" class=\"td_gray1\"><img src=\"/image/common/icon_nemo_gray.gif\" width=\"3\" height=\"6\">\n"
             str    = str + "PDF 파일</td>\n"
             str    = str + "<td height=\"20\" class=\"td_lmagin\"><input type=\"file\" class=\"textfield\" name=\"PdfFile0\" size=\"30\"></td>\n"
             str    = str + "<td align=\"center\">&nbsp;</td></tr>\n"
             str    = str + "<tr height=\"1\" class=\"tbl-line\">\n"
             str    = str + "<td height=\"1\" colspan=\"3\"></tr></table>\n"
             str = str + "<input type=hidden name=MatType value=''>\n";
             str = str + "<input type=hidden name=SendWay value=''>\n";
             */
            document.all.inputDiv.style.display = "none";
            document.all.inputDiv2.style.display = "";

        } else if (value == "<%= CodeConstants.ANS_MTD_ETCS%>") { 
        	// 비전자파일의 경우
        	for (var i = 1; i < 5; i++) {
                document.all.filesubmit[i].innerHTML = "";
            }
            numRef = 1
            str = "";
            str = str + "<table width=\"590\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\n";
            str = str + "<tr>\n";
            str = str + "<th width=\"160\" height=\"25\" class=\"td_gray1\"><img src='/image/common/icon_nemo_gray.gif'> 매체유형</th>\n";
            str = str + "<td class=\"td_lmagin\"><select name=\"MatType\" class='select'><option value=''>::: 선택해 주세요 :::</option>";
    <%
            List matList = (List) objCdinfo.getNotElecMediumList();
            if (matList.size() == 0) {
                out.println("str = str + \"<option value=''>등록된 매체가 없습니다.</option>\";");
            } else {
                for (int i = 0; i < matList.size(); i++) {
                    Hashtable hash = (Hashtable) matList.get(i);
                    String code = (String) hash.get("MSORT_CD");
                    String codeValue = (String) hash.get("CD_NM");
                    out.println("str = str + \"<option value='" + code + "'>" + codeValue + "</option>\";");
                }
            }
    %>
            str = str + "</select>\n";
            str = str + "</td>\n";
            str = str + "</tr>\n";
//        str = str + "<tr height=\"1\" class=\"tbl-line\"><td height=\"1\"></td><td height=\"1\"></td></tr>\n";
            str = str + "<tr>\n";
            str = str + "<th height=\"25\" class=\"td_gray1\"><img src='/image/common/icon_nemo_gray.gif'> 발송방법</th>\n";
            str = str + "<td class=\"td_lmagin\"><select name=\"SendWay\" class='select'><option value=''>::: 선택해 주세요 :::</option>";
    <%
            List swList = (List) objCdinfo.getSendWayList();
            if (swList.size() == 0) {
                out.println("str = str + \"<option value=''>등록된 발송방법이 없습니다.</option>\";");
            } else {
                for (int i = 0; i < swList.size(); i++) {
                    Hashtable hash = (Hashtable) swList.get(i);
                    String code = (String) hash.get("MSORT_CD");
                    String codeValue = (String) hash.get("CD_NM");
                    out.println("str = str + \"<option value='" + code + "'>" + codeValue + "</option>\";");
                }
            }
    %>
            str = str + "</tr>\n";
//        str = str + "<tr height=\"1\" class=\"tbl-line\"><td height=\"1\"></td><td height=\"1\"></td></tr>\n";
            str = str + "</table>\n";
            str = str + "<input type=hidden name=OriginFile value=''>\n";
            str = str + "<input type=hidden name=PdfFile value=''>\n";
            str = str + "<table width=\"590\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">\n";
            str = str + "<tr>\n";
            str = str + "<td height=\"40\" style=\"text-align:right;\" colspan=\"2\">\n";
//        str = str + "<img src=\"/image/button/bt_save.gif\" border=\"0\" onClick=\"javascript:checkSubmit()\" style=\"cursor:hand\">\n";
            str = str + "<span class=\"list_bt\"><a href=\"#\" onClick=\"javascript:checkSubmit()\" style=\"cursor:hand\">저장</a></span>&nbsp;&nbsp;";
//        str = str + "&nbsp;<img src=\"/image/button/bt_closeWindow.gif\" border=\"0\" onClick=\"javascript:self.close()\" style=\"cursor:hand\">\n";
            str = str + "<span class=\"list_bt\"><a href=\"#\" onClick=\"javascript:self.close()\" style=\"cursor:hand\">취소</a></span>&nbsp;&nbsp;\n";
            str = str + "</td>\n";
            str = str + "</tr>\n";
            str = str + "</table>\n";

            document.all.inputDiv.innerHTML = str;
            document.all.inputDiv.style.display = "";
            document.all.inputDiv2.style.display = "none";

        } else { // 해당 기관 아님의 경우
            for (var i = 1; i < 5; i++) {
                document.all.filesubmit[i].innerHTML = "";
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
//        str = str + "<img src=\"/image/button/bt_save.gif\" border=\"0\" onClick=\"javascript:checkSubmit()\" style=\"cursor:hand\">\n";
            str = str + "<span class=\"list_bt\"><a href=\"#\" onClick=\"javascript:checkSubmit()\" style=\"cursor:hand\">저장</a></span>&nbsp;&nbsp;";
//        str = str + "&nbsp;<img src=\"/image/button/bt_closeWindow.gif\" border=\"0\" onClick=\"javascript:self.close()\" style=\"cursor:hand\">\n";
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
        if (numRef > 4) {
            alert("더이상 파일을 추가하실 수 없습니다.");
        } else {
            var strBgcolor;
            if ((numRef % 2) == 0)
                strBgcolor = " class=td_gray1";
            else
                strBgcolor = " class=td_grayAnother";
            str = "";
            str = str + "<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\"><tr>\n";
            str = str + "<td width=\"80\" height=\"20\" " + strBgcolor + "><img src=\"/image/common/icon_nemo_gray.gif\" width=\"3\" height=\"6\">\n";
            str = str + "원본 파일</td>\n";
            str = str + "<td width=\"320\" height=\"20\" class=\"td_lmagin\"><input type=\"file\" class=\"textfield\" name=\"OriginFile" + numRef + "\" size=\"30\"></td>\n";
            str = str + "<td width=\"60\" align=\"center\"><a href=\"javascript:removebutton(" + (numRef) + ")\"><img src='/image/button/bt_cancel_admin.gif' border='0'></a></td></tr>\n";
            str = str + "<tr height=\"1\" class=\"tbl-line\">\n";
            str = str + "<td height=\"1\" colspan=\"3\"></tr>\n";
            str = str + "<tr><td height=\"20\" " + strBgcolor + "><img src=\"/image/common/icon_nemo_gray.gif\" width=\"3\" height=\"6\">\n";
            str = str + "PDF 파일</td>\n";
            str = str + "<td height=\"20\" class=\"td_lmagin\"><input type=\"file\" class=\"textfield\" name=\"PdfFile" + numRef + "\" size=\"30\"></td>\n";
            str = str + "<td align=\"center\">&nbsp;</td></tr>\n";
            str = str + "<tr height=\"1\" class=\"tbl-line\">\n";
            str = str + "<td height=\"1\" colspan=\"3\"></tr></table>\n";
            str = str + "<input type=hidden name=MatType value=''>\n";
            str = str + "<input type=hidden name=SendWay value=''>\n";
            document.all.filesubmit[numRef].innerHTML = str;
            numRef++;
        }
    }

    function removebutton(num) {
        document.all.filesubmit[num].innerHTML = "";
        numRef--;
    }

// 답변 유형에 따라서 입력 폼이 달라지므로 유형별 필수입력값에 대한 강요를 하자.. 넣어주시어요~
    function checkSubmit() {
        var f = document.inputForm;
        var ansType = f.AnsType.value;
        //alert(numRef);
        if (ansType == "<%= CodeConstants.ANS_MTD_ELEC%>") { // 전자파일인가요?
            for (var j = 0; j < numRef; j++) {
                var Ofile = eval("f.OriginFile" + j);
                var Pfile = eval("f.PdfFile" + j);
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

                var pdfExt = pdfFileName.substring(pdfDot + 1);
                var orgExt = orgFileName.substring(orgDot + 1);
                if (pdfExt.toUpperCase() != "PDF") {
                    alert("PDF파일을 선택하여주세요");
                    return false;
                }

                if (orgExt.toUpperCase() == "PDF" || orgExt.toUpperCase() == "HWP" || orgExt.toUpperCase() == "XLS" || orgExt.toUpperCase() == "DOC" || orgExt.toUpperCase() == "PPT" || orgExt.toUpperCase() == "TXT") {

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
        } else if (ansType == "<%= CodeConstants.ANS_MTD_NONE%>") { // 해당기관이 아닌가요?
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
            if (ansType == "<%= CodeConstants.ANS_MTD_ELEC%>") {
                f.action = "/reqsubmit/common/SAnsInfoWriteProcPopup.jsp";
                f.target = "processingFrame";
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
                f2.action = "/reqsubmit/common/SAnsInfoWriteProc.jsp";
                document.all.loadingDiv.style.display = '';
                f2.submit();
            }
        }
    } // end checkSubmit()

    function gotoReqInfoView() {
        var f = document.inputForm;
        f.target = "";
        f.action = "<%= strReturnURL.substring(0, StringUtil.getLastIndex(strReturnURL, "?"))%>";
        f.submit();
    }

    function updateCharAnother(formName, elementName, length_limit) {
        var comment = '';
        comment = formName.elements[elementName];
        var length = calculate_msglen(comment.value);
        document.getElementById("textlimit").innerHTML = length;
        if (length > length_limit) {
            alert("최대 " + length_limit + "byte이므로 초과된 글자수는 자동으로 삭제됩니다.");
            comment.value = comment.value.replace(/\r\n$/, "");
            comment.value = assert_msglen(comment.value, length_limit);
        }
    }
    
    //업로드 알림창 함수
    function showUploadInfo()
    {
        var d = document;
        var uploadInfo = d.getElementById("uploadInfo");
        uploadInfo.style.display = "";
    }
</script>


<title>
    <%
        if ("Y".equalsIgnoreCase(strAddAnsFlag)) {
            out.println("추가 답변 작성");
        } else {
            out.println(MenuConstants.REQ_BOX_MAKE + "- 답변 작성");
        }
    %>
</title>
</head>
<body>
	
	
    <!--파일전송 중-->
    <!-- <div id="uploadInfo" style="display:none;position:absolute; left:125px; top:164px; width:336px; height:76px; z-index:12; "> -->
    <div id="uploadInfo" style="display:none;position:absolute; left:145px; top:117px; width:285px; height:119px; z-index:12; ">
        <img src="/images2/common/loading.gif">
    </div>

    <!--  상태바 -->
    <div  id="fileupload">
        <iframe name='processingFrame' height='0' width='0'></iframe>

        <DIV ID="loadingDiv" style="width:220;height:180;display:none;position:absolute;left:80;top:120">
            <img src="/image/reqsubmit/loading.jpg" border="0">
        </DIV>


        <div class="popup">
            <p>답변 작성</p>

            <!------------------------- 답변 작성 정보 입력 폼 시작 ------------------------->
            <form     name="inputForm"
                      action="/reqsubmit/common/SAnsInfoWriteProcPopup.jsp"
                      method="post" enctype="multipart/form-data" style="margin:0px">
                <input type="hidden" name="ReqBoxID" value="<%= strReqBoxID%>">
                <input type="hidden" name="ReqID" value="<%= strReqID%>">
                <input type="hidden" name="RegrID" value="<%= objUserInfo.getUserID()%>">
                <input type="hidden" name="MsgDigest" value="">

                <input type="hidden" name="ReqBoxSortField" value="<%= strReqBoxSortField%>">
                <input type="hidden" name="ReqBoxSortMtd" value="<%= strReqBoxSortMtd%>">
                <input type="hidden" name="ReqBoxPagNum" value="<%= strReqBoxPagNum%>">
                <input type="hidden" name="ReqBoxQryField" value="<%= strReqBoxQryField%>">
                <input type="hidden" name="ReqBoxQryTerm" value="<%= strReqBoxQryTerm%>">

                <input type="hidden" name="ReqInfoSortField" value="<%= strReqInfoSortField%>">
                <input type="hidden" name="ReqInfoSortMtd" value="<%= strReqInfoSortMtd%>">
                <input type="hidden" name="ReqInfoQryField" value="<%= strReqInfoQryField%>">
                <input type="hidden" name="ReqInfoQryTerm" value="<%= strReqInfoQryTerm%>">
                <input type="hidden" name="ReqInfoPagNum" value="<%= strReqInfoPagNum%>">
                <input type="hidden" name="AuditYear" value="<%=AuditYear%>">

                <input type="hidden" name="returnURL" value="<%= strReturnURL%>">

                <%// 공개 등급 : 원래는 선택이었으나 답변은 모두 공개로 하기로 했으므로 고정 처리 %>
                <%// 공개 등급 : 원래는 고정이였으나 동적으로 변경 2015.11.09 ksw %>
                <input type="hidden" name="OpenCL" value="<%= strOpenCL%>">
                <input type="hidden" name="AddAnsFlag" value="<%= strAddAnsFlag%>">
                <input type="hidden" name="UserDN" value="<%= strUserDN%>">
                <input type="hidden" name="count">
                <input type="hidden" name="_SUB_DIR" value="<%=yearStr%>">
                <input type="hidden" name="OrgRealFileName">

                <table width="100%" cellpadding="0" cellspacing="0">
                    <tr>
                        <td width="100%" style="padding:10px;">
                            <table border="0" cellspacing="0" cellpadding="0" class="list02">
                                <tbody>
                                    <tr>
                                        <th height="25">&bull;&nbsp;&nbsp;답변유형 </th>
                                        <td>
                                            <select name="AnsType" onChange="javascript:changeInputForm(this.value)">
                                                <option value="<%= CodeConstants.ANS_MTD_ELEC%>"><%= CodeConstants.getAnswerMethod(CodeConstants.ANS_MTD_ELEC)%></option>
                                                <option value="<%= CodeConstants.ANS_MTD_ETCS%>"><%= CodeConstants.getAnswerMethod(CodeConstants.ANS_MTD_ETCS)%></option>
                                                <option value="<%= CodeConstants.ANS_MTD_NONE%>"><%= CodeConstants.getAnswerMethod(CodeConstants.ANS_MTD_NONE)%></option>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th height="25">&bull;&nbsp;&nbsp;제출 의견 </th>
                                        <td>
                                            <textarea
                                                onKeyDown="javascript:updateCharAnother(document.inputForm, 'AnsOpin', 250)"
                                                onKeyUp="javascript:updateCharAnother(document.inputForm, 'AnsOpin', 250)"
                                                onFocus="javascript:updateCharAnother(document.inputForm, 'AnsOpin', 250)"
                                                onClick="javascript:updateCharAnother(document.inputForm, 'AnsOpin', 250)"
                                                name="AnsOpin" wrap="hard" rows="6" cols="72" style="width:90%;"></textarea>
                                            <br />
                                            <span id ="textlimit"></span>&nbsp;bytes (250 bytes 까지만 입력됩니다)
                                        </td>
                                    </tr>
                                    <tr>
                                        <td height="25" colspan="2">
                                            <!-------------------------------------------- 동적으로 변화하는 FORM START ---------------------------------------------------->
                                            <DIV id="inputDiv" style="position:relative; left:0px;top:0px;width:460; border-width:0px; border-style:none;">
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
        <!-- /////////////////////////////    ezPDF DIV START    ///////////////////////////// -->
        <DIV id="inputDiv2" style="position:relative; left:0px;top:0px;width:460; border-width:0px; border-style:none;">
 

            <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
                <tr>
                    <td align="center">
                   		<!-- 라온업로드 리스트 -->
                    	<div id="uploadHoder_PlaceHolder"></div>
                    	
                    </td>
                </tr>
            </table>

            <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
                <tr>
                    <td align="left" height="50px;">&nbsp;&nbsp;&nbsp;

                        <!-- <input type="button" value="파일추가" onClick="ezPDFConv.AddItem('c:\\1.xml', 1)" style="cursor:hand; width:70px; height:25px;" onfocus="this.blur();">
                        <input type="button" value="개별삭제" onClick="ezPDFConv.DeleteItemSel();" style="cursor:hand; width:70px; height:25px;" onfocus="this.blur();">                        
                        <input type="button" value="전체삭제" onClick="ezPDFConv.DeleteItemAll();" style="cursor:hand; width:70px; height:25px;" onfocus="this.blur();"> -->
                        <!-- 							
							<input type="button" value="파일추가" id="addItem"    style="cursor:hand; width:70px; height:25px;" onfocus="this.blur();">
	                        <input type="button" value="개별삭제" id="delItemSel" style="cursor:hand; width:70px; height:25px;" onfocus="this.blur();">
	                        <input type="button" value="전체삭제" id="delItemAll" style="cursor:hand; width:70px; height:25px;" onfocus="this.blur();">
							      -->                 
                        
                        
                        <!-- <input type="button" value="INNO멀티파일" onClick="control.openFileDialog(); console.log('파일작동');" style="cursor:hand; width:70px; height:25px;" onfocus="this.blur();"> -->
                       <!--  <input type="button" id="inno_file_dialog" value="INNO멀티파일" style="cursor:hand; width:70px; height:25px;" onfocus="this.blur();">
                        <input type="button" id="inno_folder_dialog" value="INNO폴더선택"  style="cursor:hand; width:70px; height:25px;" onfocus="this.blur();">
                        <input type="button" id="inno_upload" value="INNO업로드"  style="cursor:hand; width:70px; height:25px;" onfocus="this.blur();"> -->

                    </td>
                </tr>
            </table>

            <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
                <tr>
                    <td align="center" height="50px;">

                        <span onclick="fn_PDFConvertUpload()" onfocus="this.blur();"><img border="0" src="/images2/btn/w_answer.gif" alt="답변등록" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"  /></span>
                        <span onclick="window.close();" onfocus="this.blur();"><img border="0" src="/images2/btn/w_answer_cancel.gif" alt="답변취소" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);" /></span>

                    </td>
                </tr>
            </table>

        </DIV>
        <p><br></p>
        <p><br></p>
        <!------------------------- 답변 작성 정보 입력 폼 끝 ------------------------->

<!-- 전자문서 의 경우 Msg Digest를 생성하고 결과값을 받아서 String만 보내면 되고, 나머지는 그냥 String뿐이니깐... -->
<FORM method="post" style="margin:0px" name="returnSubmitForm">
    <input type="hidden" name="ReqBoxID" value="<%= strReqBoxID%>">
    <input type="hidden" name="ReqID" value="<%= strReqID%>">
    <input type="hidden" name="RegrID" value="<%= objUserInfo.getUserID()%>">
    <input type="hidden" name="MsgDigest" value="">
    <input type="hidden" name="returnURL" value="<%= strReturnURL%>">
    <input type="hidden" name="ReqBoxSortField" value="<%= strReqBoxSortField%>">
    <input type="hidden" name="ReqBoxSortMtd" value="<%= strReqBoxSortMtd%>">
    <input type="hidden" name="ReqBoxPagNum" value="<%= strReqBoxPagNum%>">
    <input type="hidden" name="ReqBoxQryField" value="<%= strReqBoxQryField%>">
    <input type="hidden" name="ReqBoxQryTerm" value="<%= strReqBoxQryTerm%>">

    <input type="hidden" name="ReqInfoSortField" value="<%= strReqInfoSortField%>">
    <input type="hidden" name="ReqInfoSortMtd" value="<%= strReqInfoSortMtd%>">
    <input type="hidden" name="ReqInfoQryField" value="<%= strReqInfoQryField%>">
    <input type="hidden" name="ReqInfoQryTerm" value="<%= strReqInfoQryTerm%>">
    <input type="hidden" name="ReqInfoPagNum" value="<%= strReqInfoPagNum%>">
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
    <input type="hidden" name="AddAnsFlag" value="<%= strAddAnsFlag%>">
    <input type="hidden" name="user_dn" value="<%= strUserDN%>">
    <input type="hidden" name="UserDN" value="<%= strUserDN%>">
    <input type="hidden" name="count">
    <!-- 실제파일명 작업 20170818 -->
    <input type="hidden" name="OrgRealFileName" value="">
    <input type="hidden" name="PdfRealFileName" value="">
</FORM>

</div>

</body>
</html>