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
<script language="javascript">
	var new_filename_v = new Array(100);

	function BrowserInfo() 
	{
		this.isMSIE = false;
		this.isFirefox = false;
		this.isChrome = false;
		this.isSafari = false;
		this.etc = false; // IE, FF�� ������ ������
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
			// IE�� ��� ��Ƽ�꿢���� ��ġ�Ѵ�.
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
			// Firefox, Chrome, Safari�� ��� �÷������� �����Ѵ�.			
			shtml = '<div style="border: solid 1px;width:0"><embed id="filectl" type="application/x-tabsfileup" width="0" height="0" ';
			shtml += 'mode="upload" licensekey="' + licensekey + '" ';
			shtml += 'bkimageurl="' + bkimageurl + '" ';
			shtml += 'pluginspage="' + pluginpage + '"/></div>';
		}		

		if (GBrowser.isMSIE == false && ExistPlugin() == false)
		{
			shtml += '<p><div style="background: #ffffaa;padding: 20px"><ul>';
			shtml += '<li>�� �������� ǥ���ϴµ� ����� �÷������� �����ϴ�.</li>';
			shtml += '<li>�÷������� �ٿ�ε� �Ϸ��� <a href="' + pluginpage + '">[����]</a>�� �����Ͻʽÿ�.</li>';
			shtml += '<li>��ġ �������� �̵��մϴ�.</li>';
			shtml += '</ul></div>';
		}
		function filectl_ChangingUploadFile(filePath, fileSize, totalFileCount, totalFileSize)
		{
			// ���ε� ���� ���� �� �뷮�� �������� �ʽ��ϴ�.
			return true;
		}

		function filectl_UploadSuccessObjectMoved(locationURL)
		{
			location.href = locationURL;	
		}

		function filectl_UploadErrorOccurred(errorType, errorCode, errorDesc, response)
		{
			alert('���ε� ����:\ntype=' + errorType + '\ncode=' + errorCode + '\ndesctiption=' + errorDesc);
			alert('���� ����:\n' + response);
			deleteUnnecessaryFiles();
		}

		function filectl_UploadCanceled()
		{
			alert('���ε尡 ��ҵǾ����ϴ�.');
			deleteUnnecessaryFiles();
		}
		
		function deleteUnnecessaryFiles()
		{
			// ����ڿ� ���� ���ε� ��� �Ǵ� ���ε� ���� �߻��� Ajax�� ����� ������ �Ϻ� ���� �Ϸ�� ���ε� ���� ����ϴ�.
			// ������ jQuery ajax�� ����� ���Դϴ�.
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

var Enc = "F1yV/Ih1CIWKmwpkR++vU4L5x6Qw09ZdbnfMOMAF4yP/qX8ir89PSOJEu0KGxmZ7+nwY4oq8SqjF6+BH2rAyuehELATMrnCBJd33fPqR3zO0/EZoPZFUTOJnU4al6tZO+4gcNw==";
var InputType = "fixed";
var SubDir = "<%=yearStr%>";
var UploadURL = "/InnoDSP/action_nads.jsp?_SUB_DIR="+SubDir;

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
            return false;
        }
        if(formName.elements['ReqCont'].value == ""){
            alert("�䱸���� �ۼ��� �ּ���");
            return false;
        }
        if(formName.elements['ReqDtlCont'].value == ""){
            alert("�䱸������ �ۼ��� �ּ���");
            return false;
        }
        var f = document.formName;
        var ansType = f.AnsType.value;
        //alert(numRef);
        if (ansType == "<%= CodeConstants.ANS_MTD_ELEC %>") { // ���������ΰ���?

            if (f.AnsOpin.value == "") {
                    f.AnsOpin.value = "";
            }
            if (f.ezPDFConv.CountItem()<1){
                alert("������ �������ּ���");
                return false
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
//    alert(str);

    var i=0;
    var state;
    var count = ezPDFConv.CountItem();

    for(i=0; i<count; i++)
    {
        state = ezPDFConv.GetItemState(i);
        if(state == 3) // ��ȯ �Ϸ�.
        {
            // ���� ����(����,PDF) ��θ� ���ε� ������Ʈ�� ����
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

<!-- /////////////////////////////    ezPDF Workboard XS SCRIPT END    ///////////////////////////// -->

<!-- /////////////////////////////    INNODSP SCRIPT START    ///////////////////////////// -->
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
        var oForm = document.formName;
        oForm.count.value = filectl.FileCount/2;
        oForm.action = "/reqsubmit/common/AnsInfoWriteAllInOneProcPopup.jsp";
        oForm.encoding="multipart/form-data";
        oForm.target = 'processingFrame';
        oForm.target = "processingFrame";
        InnoDSSubmitMulti(oForm);
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
</head>

<body>
<!--<div id="uploadInfo" style="display:none;position:absolute; left:245px; top:320px; width:336px; height:76px; z-index:12;  border: 1px none #000000;">-->
<div id="uploadInfo" style="display:none;position:absolute; left:255px; top:320px; width:336px; height:76px; z-index:12;  border: 1px none #000000;">
    <img src="/images2/common/loading.gif">
</div>
<div id="fileupload">

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

<DIV id="inputDiv2" style="position:relative; left:0px;top:0px;width:800; border-width:0px; border-style:none;">
    <br>
    <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr><td align="center">
        <script language="javascript">
            if (navigator.appName == "Microsoft Internet Explorer") {
                var str = "<OBJECT ID='ezPDFConv' height='173' width='730' CLASSID='CLSID:ABBFCE48-008E-4DA1-8F5F-DF9E9749DC9D'";
                str = str + " codebase='http://naps.assembly.go.kr/cab/ezPDFConv.cab#Version=1,0,0,6' ";
                str = str + " hspace='10' vspace='10' align='middle'>";
                str = str + "</OBJECT>";
                document.write(str);
            }else{
                // Mozilla Plugin Info.
                var    ezPDF_PluginType = "application/npezPDFConv";
                var    ezPDF_PluginName = "ezPDFConv";
                var    ezPDF_PluginDescription = "ezPDFConv Plugin Ver. 1.0.0.5";

                // Mozilla Plugin Check
                var    ezPDF_PluginOK = false;
                var    ezPDF_PluginVersionOK = false;
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
                        str = str + "���(ezPDFConv Plug-in)�� �ֽ� ������ �ƴմϴ�.<BR>";
                        str = str + "�ֽ� ������  ��ġ�Ͽ� �ֽñ� �ٶ��ϴ�.<BR>";
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
                str = str + "���(ezPDFMg Plug-in)�� ��ġ���� ������ ������ �����Ͻ� �� �����ϴ�.<BR>";
                str = str + "�� ��ġ�Ͽ� �ֽñ� �ٶ��ϴ�.<BR>";
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
    <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
            <td align="left" height="50px;">&nbsp;&nbsp;&nbsp;

                <input type="button" value="�����߰�" onClick="ezPDFConv.AddItem('c:\\1.xml', 1)" style="cursor:hand; width:70px; height:25px;" onfocus="this.blur();">
                <input type="button" value="��������" onClick="ezPDFConv.DeleteItemSel();" style="cursor:hand; width:70px; height:25px;" onfocus="this.blur();">
                <input type="button" value="��ü����" onClick="ezPDFConv.DeleteItemAll();" style="cursor:hand; width:70px; height:25px;" onfocus="this.blur();">

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
        <span class="list_bt"><a href="#" onClick="if(checkFormData()=='1'){ezPDFConv.ConvertStart();}">�䱸������</a></span>
        <span class="list_bt"><a href="#"  onClick="document.formName.reset();ezPDFConv.DeleteItemAll();">�ʱ�ȭ</a></span>
        <span class="list_bt"><a href="#" onClick="self.close()">�ۼ����</a></span>&nbsp;&nbsp;
    </div>
</form>
    <!-- /����Ʈ ��ư-->
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
