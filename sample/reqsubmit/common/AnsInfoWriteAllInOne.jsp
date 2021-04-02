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
    // ���翬��
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
    // �䱸���� ������ ���� �Է������� ��ȯ�� URL�� �޶�� �Ѵ�.
    String strReqBoxTp = StringUtil.getEmptyIfNull(request.getParameter("ReqBoxTp"), "001");
    String strReqScheID = StringUtil.getEmptyIfNull(request.getParameter("ReqScheID"));

    String strTitle = "�䱸�ڷ� ���";
    String strAction = "/reqsubmit/common/ReqInfoWriteAllInOneProc.jsp";
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

    ResultSetSingleHelper objRsSH=null;    /** �䱸���� ���� ��¿�  ResultSetSingleHelper*/
    ResultSetHelper objSubmtOrganRs=null;  /** ������ ����Ʈ ��¿� ResultSetHelper */
    ResultSetHelper objRltdDutyRs=null;   /** ���ñ�� ����Ʈ ��¿� RsHelper */
    ResultSetHelper objOrganRs = null;
    ResultSetHelper objSelectOrganRs = null;
    ResultSetHelper objSelectUser = null;
    Hashtable objhashdata4 = null;
    String SessionNo2 = "";

    try {
           /********* �븮�� ���� ���� *********/
        CommRequestBoxDelegate objReqBox=new CommRequestBoxDelegate();         /**�䱸�� Delegate*/
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
//SessionNo2 = "333";
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

<jsp:include page="/inc/header.jsp" flush="true"/>
<script language=Javascript src="/js/reqsubmit/common.js"></script>
<script language=Javascript src="/js/nads_lib.js"></script>
<script language=Javascript src="/js/datepicker.js"></script>
<script language="javascript" src="/js/forum.js"></script>



<script src="/unidocs/ezPDF.js" type="text/javascript"></script>
<script src="/raonkupload/js/raonkupload.js" type="text/javascript"></script>

<script type="text/javascript">
	//�˾��� ȭ�� �ڷ� ������ ��� ������ �����ش�.
	window.focus();



	var G_UploadID = "kupload";
	var G_ConvertList = null;
	var G_CurrIndex = 0;
	var G_FocusElementForScroll = null;
	var G_LastPDFConvertResult = null;

	var SubDir = "<%=yearStr%>";
	var InputType = "fixed";
		//���ϴڽ� ���̽� ��ü ����
	var ezpdf = null;

	window.onload = function() {

		ezpdf = new ezPDFWFLauncher(ezPDFWSPrinter, ezPDFData);

		//��¾��ε� ����
		new RAONKUpload({
			Width : '98%',
			Id: G_UploadID,
            UploadHolder: "uploadHoder_PlaceHolder",
			ButtonBarEdit: "add,remove,remove_all",
			HeaderBarItem: "��ȯ����",
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
	// ��ȯ��û ����
	function WorkBoard_SetUploadFile(s) {
		console.log("PDF Convert - WorkBoard_SetUploadFile");

		var result = eval(s);
		G_LastPDFConvertResult = result;
		// PDF ����
		RAONKUPLOAD.SetCustomHeaderByIndex(G_CurrIndex, "<img alt='��ȯ�Ϸ�' src='/unidocs/icon/pdf.png' /> ��ȯ�Ϸ�", G_UploadID);

		G_ConvertList.shift();
		G_CurrIndex++;

		fn_convertPDF(G_LastPDFConvertResult);
	}
	// ��ȯ��û ����
	function WorkBoard_FailConvert(code){
		console.log("PDF Convert - WorkBoard_FailConvert");

		var errCode = code;
		var error = "";

		error = strJobFile + "��(��) ��ȯ�� �� �����ϴ�.";
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
	// �߰���ư
	function fn_openFileDialog() {
		RAONKUPLOAD.OpenFileDialog(G_UploadID);
	}

	// PDF ��ȯ �� ����
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
				// PDF ����
				var _elem = RAONKUPLOAD.SetCustomHeaderByIndex(G_CurrIndex, "<img alt='��ȯ��' src='/unidocs/icon/spinner.gif' /> ��ȯ��", G_UploadID);
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

				// ���� ��ȯ�� ������ ó�� (������)
				RAONKUPLOAD.ResetUpload(G_UploadID);

				if(_fileInfo.webFile != null) {
					for(var idx=0, _webFile = _fileInfo.webFile, len = _webFile.length; idx < len; idx++) {
						RAONKUPLOAD.AddUploadedFileEx(_webFile[idx].uniqKey, _webFile[idx].originalName, _webFile[idx].uploadPath, _webFile[idx].size, _webFile[idx].customValue, "<img alt='��ȯ�Ϸ�' src='/unidocs/icon/pdf.png' />", G_UploadID);
					}
				}

				// ��ȯ�� �ű� ���� ó��
				RAONKUPLOAD.AddLocalFileDirectlyEx(arrayFileList, function() {
						// ��ȯ���� ó��
						var _defaultIdx = _fileInfo.webFile == null ? 0 : _fileInfo.webFile.length;
						for(var idx=_defaultIdx, len=idx+arrayFileList.length; idx < len; idx++) {
							RAONKUPLOAD.SetCustomHeaderByIndex(idx, "<img alt='��ȯ��' src='/unidocs/icon/pdf.png' />", G_UploadID);
						}

						window.setTimeout(function(){
							RAONKUPLOAD.Transfer(G_UploadID);
						}, 500)
					}
				, G_UploadID);
			}
		}
	}

    // �����Ϸ� �̺�Ʈ
    function RAONKUPLOAD_CreationComplete(uploadID) {
		//RAONKUPLOAD.AddUploadedFileEx("1", "test.jpg", "", "1000", "", "<img alt='��ȯ�Ϸ�' src='/unidocs/icon/pdf.png' /> ��ȯ�Ϸ�", uploadID)
		//RAONKUPLOAD.AddUploadedFileEx("1", "test.jpg.pdf", "", "1000", "", "<img alt='��ȯ�Ϸ�' src='/unidocs/icon/pdf.png' /> ��ȯ�Ϸ�", uploadID)
    }

 // ���� �߰� �� �̺�Ʈ (�߰��Ǵ� ���� ���� ��ŭ �߻��մϴ�.)
    function RAONKUPLOAD_AfterAddFile(uploadID, paramObj) {
        // paramObj.nIndex : ���� �ε���
        // paramObj.strName : ���ϸ�
        // paramObj.nSize : ���� ������
        // paramObj.strPath : ���� ���

        // �߰��� ���Ͽ� ���ϴ� data�� �߰��� �ִ� API �Դϴ�.
        // �� ������������ ���� �߰� �� "markvalue_����" ���� �־��ֵ��� �Ǿ��ֽ��ϴ�.
        RAONKUPLOAD.SetFileCustomValue(-1, paramObj.nIndex, uploadID);

        // SetFileMark API ����
        // ù��° �Ķ���� : 0���� ���۵Ǵ� ������ ��������, -1�Է½� �������� �߰��� ����
        // 2��° �Ķ���� : �ش� ���Ͽ� �߰��� data
        // 3��° �Ķ���� : API�� ������ ���ε� ID

        //var logBox = document.getElementById("logBox");
        //logBox.innerHTML += paramObj.strName + ' ���Ͽ� customvalue_' + paramObj.nIndex + ' ���� �߰��Ͽ����ϴ�.' + '<br/>';

    }

    // ���ۿϷ� �̺�Ʈ
    function RAONKUPLOAD_UploadComplete(uploadID) {
		//alert("���ۼ���");

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

    // ���� �̺�Ʈ
    function RAONKUPLOAD_OnError(uploadID, paramObj) {
        alert("���ۿ��� : " + paramObj.strMessage);
		ezpdf.Close();
		RAONKUPLOAD.ResetUpload(G_UploadID);
    }

    // ��� �̺�Ʈ
    function RAONKUPLOAD_UploadingCancel(uploadID, paramObj) {
        alert("�������");
		ezpdf.Close();
		RAONKUPLOAD.ResetUpload(G_UploadID);
    }
	// K UPload �̺�Ʈ




    //InnoDSSubmit�� ���� ��Ȱ
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
					orgPdfName +=  clientFile + "��";
				}
				else {
					orgName += clientFile + "��";
				}
			}
			else {
				orgName += clientFile + "��";
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

		console.log("���غ�")

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
    if (value == "<%= CodeConstants.ANS_MTD_ELEC %>") { // ���������� ���
        document.all.AFILE.style.display="none";
        document.all.inputDiv.style.display="none";
        document.all.inputDiv2.style.display="";


    } else if (value == "<%= CodeConstants.ANS_MTD_ETCS%>") { // ������������ ���
        for(var i = 1;i<5; i++){
           document.all.filesubmit[i].innerHTML="";
        }
        numRef = 1
        str = "";
        str = str + "<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\n";
        str = str + "<tr>\n";
        str = str + "<td style=\"width:100px;\" >* ��ü����</td>\n";
        str = str + "<td style=\"width:400px;\"><select name=\"MatType\"><option value=''>::: ������ �ּ��� :::</option>";
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
        str = str + "<tr>\n";
        str = str + "<td style=\"width:100px;\">* �߼� ���</td>\n";
        str = str + "<td style=\"width:400px;\"><select name=\"SendWay\"><option value=''>::: ������ �ּ��� :::</option>";
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
        str = str + "</table>\n";
        str = str + "<input type=hidden name=OriginFile value=''>\n";
        str = str + "<input type=hidden name=PdfFile value=''>\n";
        document.all.AFILE.style.display="";
        document.all.inputDiv2.style.display="none";
        document.all.inputDiv.style.display="";
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
        str    = str + "<td style=\"width:100px;\" "+strBgcolor+">\n";
        str    = str + "*���� ����</td>\n";
        str    = str + "<td style=\"width:400px;\"><input type=\"file\" name=\"OriginFile"+numRef+"\" size=\"30\">\n";
        str    = str + "<a href=\"javascript:removebutton("+(numRef)+")\"><img src='/image/button/bt_cancel_admin.gif' border='0'></a></td></tr>\n";
        str    = str + "<tr><td style=\"width:100px;\" "+strBgcolor+">\n";
        str    = str + "*PDF ����</td>\n";
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
            return;
        }
        if(formName.elements['AnsDuty'].value == ""){
            alert("�������� �䱸������ �������ּ���");
            return;
        }
        if(formName.elements['reqdate'].value == ""){
            alert("��û���ڸ� �������ּ���");
            return;
        }
        if(formName.elements['CmtOrganID'].value == ""){
            alert("�Ұ�����ȸ�� �������ּ���");
            return;
        }
        if(formName.elements['ReqOrganID'].value == ""){
            alert("�ǿ����� �������ּ���");
            return;
        }if(formName.elements['RegrID'].value == ""){
            alert("����ڸ� �������ּ���");
            return;
        }
        if(formName.elements['ReqCont'].value == ""){
            alert("�䱸���� �ۼ��� �ּ���");
            return;
        }
        if(formName.elements['ReqDtlCont'].value == ""){
            alert("�䱸������ �ۼ��� �ּ���");
            return;
        }
        var f = document.formName;
        var ansType = f.AnsType.value;
        //alert(numRef);
        if (ansType == "<%= CodeConstants.ANS_MTD_ELEC %>") { // ���������ΰ���?

        	if (f.AnsOpin.value == '') {
                alert('�����ǰ��� �Է��� �ּ���');
                return;
           	}
    		else if(RAONKUPLOAD.GetTotalFileCount(G_UploadID) <= 0) {
    			alert("��� ��� ������ �����ϴ�.");
    			return;

    		}

            /* if (f.AnsOpin.value == "") {
                    f.AnsOpin.value = "";
            }

            if (control.getAllFiles()<1){
                alert("������ �������ּ���");
                return;
            } */

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

//���ε� �˸�â �Լ�
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
            showUploadInfo();// ���ε� �˸�â ����
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
                        <th align="left" scope="col" colspan="4">&bull;&nbsp;<strong>���� ���   : <%= strOrgnaNM %></strong></th>
                    </tr>
                     <tr>
                        <th align="left" scope="col" style="width:150px;"><strong>&bull;&nbsp;ȸ�� : </strong></th>
                        <td colspan="3">��
                            <input onKeyUp="CheckNumeric()" value="<%=SessionNo2%>" name="NatCnt" size="3" maxLength="3" onKeyUp="CheckNumeric()" />ȸ ��ȸ </td>
                    </tr>
                    <tr>
                        <th align="left" scope="col" style="width:150px;"><strong>&bull;&nbsp;��������  </strong></th>
                        <td>
                            <select name="RltdDutyX">
                                <option value="">����</option>
                                <option value="001" <%if(strRltdDutyX.equals("001")){%>selected<%}%>>��������</option>
                                <option value="002" <%if(strRltdDutyX.equals("002")){%>selected<%}%>>��������</option>
                                <option value="004" <%if(strRltdDutyX.equals("004")){%>selected<%}%>>���</option>
                                <option value="005" <%if(strRltdDutyX.equals("005")){%>selected<%}%>>���</option>
                                <option value="006" <%if(strRltdDutyX.equals("006")){%>selected<%}%>>����</option>
                                <option value="003" <%if(strRltdDutyX.equals("003")){%>selected<%}%>>�����</option>
                                <option value="007" <%if(strRltdDutyX.equals("007")){%>selected<%}%>>��Ÿ(�ӽ�ȸ   ��)</option>
                            </select>
                        </td>
                        <th scope="col" style="width:150px;">
                            <strong>&bull;&nbsp; ������ �ڷ�䱸 ����</strong>
                        </th>
                        <td>
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
                        <th align="left" scope="col"><strong>&bull;&nbsp;�䱸 ���� : </strong></th>
                        <td>
                            <input name="reqdate" size="10" maxlength="8" value="<%=strReqDate%>"  OnClick="this.select()"
                        OnKeyPress="if ((event.keyCode&lt;48)||(event.keyCode&gt;57)) event.returnValue=false;" OnBlur="javascript:SetFormatDate(this);" Onfocus="javascript:datechange();" />&nbsp;&nbsp;<img src="/images2/btn/bt_calender.gif" width="17" height="13" OnClick="javascript:show_calendar('formName.reqdate');"/>
                        </td>
                        <th scope="col">
                            <strong>&bull;&nbsp;�������</strong>
                        </th>
                        <td>
                            <input name="SubmtDln" size="10" maxlength="8" value="<%=strSubmtDln%>"  OnClick="this.select()"
                        OnKeyPress="if ((event.keyCode&lt;48)||(event.keyCode&gt;57)) event.returnValue=false;" OnBlur="javascript:SetFormatDate(this);"/>&nbsp;&nbsp;<img src="/images2/btn/bt_calender.gif" width="17" height="13" OnClick="javascript:show_calendar('formName.SubmtDln');"/>
                        </td>
                    </tr>
                    <tr>
                        <th align="left" scope="col">&bull;&nbsp;�Ұ�����ȸ</th>
                        <td colspan="3">
                            <select name="CmtOrganID" onChange="searchSubmit()" style="width:350px;" >
                                <option value="">::::����ȸ�� �������ּ���:::</option>
                                <%while(objOrganRs.next()){%>
                                <option value="<%=objOrganRs.getObject("ORGAN_ID")%>" <%if(tempCmtOrganID.equals(objOrganRs.getObject("ORGAN_ID"))){%> selected <%}%>>
                                <%=objOrganRs.getObject("ORGAN_NM")%></option>
                                <%}%>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th align="left" scope="col">&bull;&nbsp;<strong>�ǿ���   : </strong>
                        </th>
                        <td colspan="3">
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
<br />
                <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list02">
                    <tr>
                        <th align="left" scope="col"  style="width:150px;">&bull;&nbsp;<strong>�䱸��   : </strong>
                        </th>
                        <td colspan="3">
                            <input name="ReqCont" size="80" />
                        </td>
                    </tr>
                    <tr>
                        <th align="left" scope="col"  style="width:150px;">&bull;&nbsp;<strong>�䱸����   : </strong>
                        </th>
                        <td colspan="3">
                            <textarea name="ReqDtlCont" rows="9" cols="80"  style="width:90%;"></textarea>
                        </td>
                    </tr>
                </table>
<br />
                 <p>�亯 ���</p>

                <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list02">
                    <!--tr>
                        <th align="left" scope="col"  style="width:150px;">&bull;&nbsp;<strong>�亯������� : </strong>
                        </th>
                        <td colspan="3">
                            <div id="btn_all"  class="t_left">
                                <span class="list_bt"><a href="#" onClick="old_version();">�����亯���</a></span>
                            </div>
                        </td>
                    </tr-->
                    <tr>
                        <th align="left" scope="col"  style="width:150px;">&bull;&nbsp;<strong>�亯���� : </strong>
                        </th>
                        <td colspan="3">
                            <select name="AnsType" onChange="javascript:changeInputForm(this.value)" class="select">
                                <option value="<%= CodeConstants.ANS_MTD_ELEC %>"><%= CodeConstants.getAnswerMethod(CodeConstants.ANS_MTD_ELEC) %></option>
                                <option value="<%= CodeConstants.ANS_MTD_ETCS %>"><%= CodeConstants.getAnswerMethod(CodeConstants.ANS_MTD_ETCS) %></option>
                            </select>
                        </td>
                    </tr>

                    <tr>
                        <th align="left" scope="col">&bull;&nbsp;<strong>�����ǰ� : </strong>
                        </th>
                        <td colspan="3">
                            <textarea name="AnsOpin" rows="9" cols="80"  style="width:90%;"></textarea>
                        </td>
                    </tr>
                    <tr id="AFILE" style="display:none;">
                        <th scope="col"  style="width:150px;">&bull;&nbsp;<strong>�亯����   : </strong>
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
				<!-- ��¾��ε� ����Ʈ -->
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
    <font color="red">* PDF��ȯ���� �� ����� "�����亯���" ����� �̿��� �ֽñ� �ٶ��ϴ�. </font>
    <!-- ����Ʈ ��ư-->
    <div id="btn_all"  class="t_right">
    	<input type="button" value="�䱸������" onClick="if(checkFormData()=='1'){fn_PDFConvertUpload();}"  style="cursor:hand; width:70px; height:25px;" onfocus="this.blur();">
        <!-- <span class="list_bt"><a href="#" onClick="if(checkFormData()=='1'){ConvertAndUpload();}">�䱸������</a></span> -->
        <!-- <span class="list_bt"><a href="#"  onClick="document.formName.reset();ezPDFConv.DeleteItemAll();">�ʱ�ȭ</a></span> -->
        <span class="list_bt"><a href="#" onClick="self.close()">�ۼ����</a></span>&nbsp;&nbsp;
    </div>
</form>
    <!-- /����Ʈ ��ư-->
</div>

</body>
</html>
