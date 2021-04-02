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

<%
    // ���翬��
    Calendar calendar = Calendar.getInstance();
    int year = calendar.get(calendar.YEAR);
    String yearStr = Integer.toString(year);
%>

<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>

<%
    /**********************************************************************
     * �⺻������ �׻� �� ���������� �ؾ��ϴ� �۾�. �̿��� �α��� ������ Ȯ���Ѵ�.
     * ��, ������ �����Ǿ��� �ִ����� Ȯ���Ѵ�.
     * �׸���, ���� ȭ���� �����ϱ� ���ؼ� �ش��ϴ� �䱸�� ���� ������ ����Ѵ�.
     * �ش� ���� ������ ����ϱ� ���ؼ� �䱸ID�� �Ķ���ͷ� �޾Ƽ� �ش��ϴ� �Լ��� ȣ���Ѵ�.
     * �� �ϴܿ��� �䱸�� �亯�� ����ϴ� ��� ���� �����Ѵ�.
     * ��� ���� �亯 ������ ���� ���� �ٸ� ���·� ���� �����Ͽ��� �Ѵ�.
     * �亯 ������ ���� ó���Ǵ� ���μ����� ���뵵 ����Ǿ�� �ϴ� ���� ���� ����!!
     * ��Ƽ ���� ���ε� ���۳�Ʈ�� �̿��ؼ� �亯�� ����ϴ� ��! ���� Ÿ���� �� ������ ����.
     * �� �׷� ������ (__)
     *
     **********************************************************************
     */
    String strClientIP = request.getHeader("Proxy-Client-IP");

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

    // �Ѿ�� �Ķ���͸� �����ؼ� �ʿ��� ?? ������ ����
    // �䱸�� ����
    String strReqBoxID = objParams.getParamValue("ReqBoxID");
    String strReqID = objParams.getParamValue("ReqID");

    String strReqBoxSortField = StringUtil.getEmptyIfNull((String)objParams.getParamValue("ReqBoxSortField"));
    String strReqBoxSortMtd = StringUtil.getEmptyIfNull((String)objParams.getParamValue("ReqBoxSortMtd"));
    String strReqBoxPagNum = StringUtil.getEmptyIfNull((String)objParams.getParamValue("ReqBoxPage"));
    String strReqBoxQryField = StringUtil.getEmptyIfNull((String)objParams.getParamValue("ReqBoxQryField"));
    String strReqBoxQryTerm = StringUtil.getEmptyIfNull((String)objParams.getParamValue("ReqBoxQryTerm"));
    String AuditYear = StringUtil.getEmptyIfNull((String)request.getParameter("AuditYear"));


    // �䱸 ��� ����
    String strReqInfoSortField = objParams.getParamValue("ReqInfoSortField");
    String strReqInfoSortMtd = objParams.getParamValue("ReqInfoSortMtd");
    String strReqInfoQryField = objParams.getParamValue("ReqInfoQryField");
    String strReqInfoQryTerm = objParams.getParamValue("ReqInfoQryTerm");
    String strReqInfoPagNum = objParams.getParamValue("ReqInfoPage");
    
    //��������� �׽�Ʈ
    String strOpenCL = request.getParameter("ReqOpenCL");
    System.out.println("kangthis logs SAnsInfoWrite.jsp(strOpenCL) => " + strOpenCL);

    // 2004-06-04 �̿��� ������ USER DN
    String strUserDN = null;

    if ("".equalsIgnoreCase(StringUtil.getEmptyIfNull(strReqID))) { // �䱸ID�� NULL�̸� �ȵȴ�. �����~~
        throw new AppException("�䱸 ID�� ���� �ȵ���~~~");
    }

    if ("".equalsIgnoreCase(StringUtil.getEmptyIfNull(strReqBoxID))) { // �䱸�� ID�� NULL�̸� �ȵȴ�. �����~~
        throw new AppException("�䱸�� ID�� ���� �ȵ���~~~");
    }

    // 2004-05-04 �߰��� �Ķ���� : ���� �����ϱ� ���� �׳� �̷��� ����. -��-
    String strReturnURL = StringUtil.getEmptyIfNull(request.getParameter("ReturnURL"));
    //if (StringUtil.isAssigned(strReturnURL)) strReturnURL = strReturnURL+"?ReqBoxID="+strReqBoxID+"&ReqID="+strReqID;
    //else strReturnURL = "/reqsubmit/10_mem/20_reqboxsh/10_make/SMakeReqInfoVList.jsp?ReqBoxID="+strReqBoxID+"&ReqID="+strReqID;

    // 2004-05-08 �߰��� �Ķ���� : �߰��亯����
    String strAddAnsFlag = StringUtil.getEmptyIfNull(request.getParameter("AddAnsFlag"), "N");

    ResultSetSingleHelper objRsSH = null;

    try{
           reqDelegate = new MemRequestBoxDelegate();
           selfDelegate = new SMemReqInfoDelegate();

           boolean blnHashAuth = reqDelegate.checkReqBoxAuth(strReqBoxID, objUserInfo.getOrganID()).booleanValue();

           if(!blnHashAuth) {
               objMsgBean.setMsgType(MessageBean.TYPE_WARN);
                objMsgBean.setStrCode("DSAUTH-0001");
                objMsgBean.setStrMsg("�ش� �䱸���� �� ������ �����ϴ�.");
                out.println("�ش� �䱸���� �� ������ �����ϴ�.");
            return;
        } else {
            // �䱸 ��� ������ SELECT �Ѵ�.
            objRsSH = new ResultSetSingleHelper(selfDelegate.getRecord(strReqID));

            // 2004-06-04 �̿����� ������ USER DN ���� �����ͼ� �����Ѵ�.
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

<jsp:include page="/inc/header.jsp" flush="true"/>
<style>
.td_grayAnother {
    FONT-WEIGHT: bold; FONT-SIZE: 12px; COLOR: #5c5c5c; FONT-FAMILY: ����,verdana,seoul,Arial;BACKGROUND-COLOR: #E9E9E9 ; padding-left: 15px;
}
</style>
<script>
/* IMAGE_ROLLOVER ��ũ��Ʈ */
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
<script type="text/javascript" src="/js2/InnoDSP/InnoDS.js"></script>
<script language="javascript">
// ��ó���� ���� �Լ��ӿ� �и��ϴ�.
// ���忡�� ���ٸ� ��å�� ��� �켱 �̷��� �д�.
// ���� ȹ������ �������� �Ϸ绡�� �������� �ٶ��... -��-

var Enc = "F1yV/Ih1CIWKmwpkR++vU4L5x6Qw09ZdbnfMOMAF4yP/qX8ir89PSOJEu0KGxmZ7+nwY4oq8SqjF6+BH2rAyuehELATMrnCBJd33fPqR3zO0/EZoPZFUTOJnU4al6tZO+4gcNw==";
var InputType = "fixed";
var SubDir = "<%=yearStr%>";
var UploadURL = "/InnoDSP/action_nads.jsp?_SUB_DIR="+SubDir;

var numRef = 1;
function changeInputForm(value) {
    var str = "";
    if (value == "<%= CodeConstants.ANS_MTD_ELEC %>") { // ���������� ���
    /*
        str = "";
        str = str + "<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\"><tr>\n"
        str    = str + "<td width=\"80\" height=\"20\" class=\"td_gray1\"><img src=\"/image/common/icon_nemo_gray.gif\" width=\"3\" height=\"6\">\n"
        str    = str + "���� ����</td>\n"
        str    = str + "<td width=\"380\" height=\"20\" class=\"td_lmagin\"><input type=\"file\" class=\"textfield\" name=\"OriginFile0\" size=\"30\"></td>\n"
        str    = str + "<td width=\"100\" align=\"center\"><a href=\"javascript:submitbutton()\">�����߰�</a></td></tr>\n"
        str = str + "<tr height=\"1\" class=\"tbl-line\">\n"
        str    = str + "<td height=\"1\" colspan=\"3\"></tr>\n"
        str    = str + "<tr><td height=\"20\" class=\"td_gray1\"><img src=\"/image/common/icon_nemo_gray.gif\" width=\"3\" height=\"6\">\n"
        str    = str + "PDF ����</td>\n"
        str    = str + "<td height=\"20\" class=\"td_lmagin\"><input type=\"file\" class=\"textfield\" name=\"PdfFile0\" size=\"30\"></td>\n"
        str    = str + "<td align=\"center\">&nbsp;</td></tr>\n"
        str    = str + "<tr height=\"1\" class=\"tbl-line\">\n"
        str    = str + "<td height=\"1\" colspan=\"3\"></tr></table>\n"
        str = str + "<input type=hidden name=MatType value=''>\n";
        str = str + "<input type=hidden name=SendWay value=''>\n";
    */
        document.all.inputDiv.style.display = "none";
        document.all.inputDiv2.style.display = "";

    } else if (value == "<%= CodeConstants.ANS_MTD_ETCS%>") { // ������������ ���
        for(var i = 1;i<5; i++){
           document.all.filesubmit[i].innerHTML="";
        }
        numRef = 1
        str = "";
        str = str + "<table width=\"590\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\n";
        str = str + "<tr>\n";
        str = str + "<th width=\"160\" height=\"25\" class=\"td_gray1\"><img src='/image/common/icon_nemo_gray.gif'> ��ü����</th>\n";
        str = str + "<td class=\"td_lmagin\"><select name=\"MatType\" class='select'><option value=''>::: ������ �ּ��� :::</option>";
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
//        str = str + "<tr height=\"1\" class=\"tbl-line\"><td height=\"1\"></td><td height=\"1\"></td></tr>\n";
        str = str + "<tr>\n";
        str = str + "<th height=\"25\" class=\"td_gray1\"><img src='/image/common/icon_nemo_gray.gif'> �߼۹��</th>\n";
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
//        str = str + "<tr height=\"1\" class=\"tbl-line\"><td height=\"1\"></td><td height=\"1\"></td></tr>\n";
        str = str + "</table>\n";
        str = str + "<input type=hidden name=OriginFile value=''>\n";
        str = str + "<input type=hidden name=PdfFile value=''>\n";
        str = str + "<table width=\"590\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">\n";
        str = str + "<tr>\n";
        str = str + "<td height=\"40\" style=\"text-align:right;\" colspan=\"2\">\n";
//        str = str + "<img src=\"/image/button/bt_save.gif\" border=\"0\" onClick=\"javascript:checkSubmit()\" style=\"cursor:hand\">\n";
        str = str + "<span class=\"list_bt\"><a href=\"#\" onClick=\"javascript:checkSubmit()\" style=\"cursor:hand\">����</a></span>&nbsp;&nbsp;";
//        str = str + "&nbsp;<img src=\"/image/button/bt_closeWindow.gif\" border=\"0\" onClick=\"javascript:self.close()\" style=\"cursor:hand\">\n";
        str = str + "<span class=\"list_bt\"><a href=\"#\" onClick=\"javascript:self.close()\" style=\"cursor:hand\">���</a></span>&nbsp;&nbsp;\n";
        str = str + "</td>\n";
        str = str + "</tr>\n";
        str = str + "</table>\n";

        document.all.inputDiv.innerHTML = str;
        document.all.inputDiv.style.display = "";
        document.all.inputDiv2.style.display = "none";

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
        str = str + "<table width=\"590\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\n";
        str = str + "<tr>\n";
        str = str + "<td height=\"40\" style=\"text-align:right;\" colspan=\"2\">\n";
//        str = str + "<img src=\"/image/button/bt_save.gif\" border=\"0\" onClick=\"javascript:checkSubmit()\" style=\"cursor:hand\">\n";
        str = str + "<span class=\"list_bt\"><a href=\"#\" onClick=\"javascript:checkSubmit()\" style=\"cursor:hand\">����</a></span>&nbsp;&nbsp;";
//        str = str + "&nbsp;<img src=\"/image/button/bt_closeWindow.gif\" border=\"0\" onClick=\"javascript:self.close()\" style=\"cursor:hand\">\n";
        str = str + "<span class=\"list_bt\"><a href=\"#\" onClick=\"javascript:self.close()\" style=\"cursor:hand\">���</a></span>&nbsp;&nbsp;\n";
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
        alert("���̻� ������ �߰��Ͻ� �� �����ϴ�.");
    }else{
        var strBgcolor;
        if((numRef % 2) == 0) strBgcolor = " class=td_gray1";
        else strBgcolor = " class=td_grayAnother";
        str = "";
        str = str + "<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\"><tr>\n";
        str    = str + "<td width=\"80\" height=\"20\" "+strBgcolor+"><img src=\"/image/common/icon_nemo_gray.gif\" width=\"3\" height=\"6\">\n";
        str    = str + "���� ����</td>\n";
        str    = str + "<td width=\"320\" height=\"20\" class=\"td_lmagin\"><input type=\"file\" class=\"textfield\" name=\"OriginFile"+numRef+"\" size=\"30\"></td>\n";
        str    = str + "<td width=\"60\" align=\"center\"><a href=\"javascript:removebutton("+(numRef)+")\"><img src='/image/button/bt_cancel_admin.gif' border='0'></a></td></tr>\n";
        str    = str + "<tr height=\"1\" class=\"tbl-line\">\n";
        str    = str + "<td height=\"1\" colspan=\"3\"></tr>\n";
        str    = str + "<tr><td height=\"20\" "+strBgcolor+"><img src=\"/image/common/icon_nemo_gray.gif\" width=\"3\" height=\"6\">\n";
        str    = str + "PDF ����</td>\n";
        str    = str + "<td height=\"20\" class=\"td_lmagin\"><input type=\"file\" class=\"textfield\" name=\"PdfFile"+numRef+"\" size=\"30\"></td>\n";
        str    = str + "<td align=\"center\">&nbsp;</td></tr>\n";
        str    = str + "<tr height=\"1\" class=\"tbl-line\">\n";
        str    = str + "<td height=\"1\" colspan=\"3\"></tr></table>\n";
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

// �亯 ������ ���� �Է� ���� �޶����Ƿ� ������ �ʼ��Է°��� ���� ���並 ����.. �־��ֽþ��~
function checkSubmit() {
    var f = document.inputForm;
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
            if(pdfExt.toUpperCase() != "PDF"){
                alert("PDF������ �����Ͽ��ּ���");
                return false;
            }

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

    if (getByteLength(f.AnsOpin.value) > 500) {
        alert("�ѱ�, ������ ���� 500�� �̳��� �Է��� �ּ���. ��, �ѱ��� 2�ڷ� ó���˴ϴ�.");
        f.AnsOpin.focus();
        return;
    }
    if (getByteLength(f.AnsOpin.value) < 1) {
        alert("���� �ǰ��� �Է��� �ּ���.");
        f.AnsOpin.focus();
        return;
    }
    if (confirm("�ۼ��Ͻ� �亯 �ڷḦ ����Ͻðڽ��ϱ�?")) {
        document.returnSubmitForm.AnsOpin.value = f.AnsOpin.value;
        f.count.value = numRef;
        if (ansType == "<%= CodeConstants.ANS_MTD_ELEC %>") {
            f.action = "/reqsubmit/common/SAnsInfoWriteProcPopup.jsp";
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
            f2.action = "/reqsubmit/common/SAnsInfoWriteProc.jsp";
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
        alert("�ִ� " + length_limit + "byte�̹Ƿ� �ʰ��� ���ڼ��� �ڵ����� �����˴ϴ�.");
        comment.value = comment.value.replace(/\r\n$/, "");
        comment.value = assert_msglen(comment.value, length_limit);
    }
}
</script>


<!-- /////////////////////////////    ezPDF Workboard XS SCRIPT START    ///////////////////////////// -->
<!--
�޼ҵ�

- InitParam : ���������� IE�� �ƴ� ��쿡 ��Ʈ���� �ʱ�ȭ�ϱ� ���� ȣ���Ѵ�.
    ����    : void InitParam(void);
    Param    : ����
    Return    : ����

- CountItem    : ��Ʈ�ѿ� ��ϵ� ������ ������ ��´�.
    ����    : LONG CountItem(void);
    Param    : ����
    Return    : ������ ����(����), -1(����)

- AddItem : ��Ʈ�ѿ� ���� �������� ��� �Ѵ�.
    ���� : BOOL AddItem(LPCTSTR szPath, bool bFileDialog);
    Param    : szPath(���� ���), bFileDialog(1[���� ���� ���̾�α� ����], 0[���� ���� ���̾�α� ���� �ʱ�])
    Return : TRUE(����), FALSE(����)

- DeleteItem : ��Ʈ���� ������ ���� �Ѵ�.
    ����    : LONG DeleteItem(LONG index);
    Param    : index(������ �������� �ε���)
    Return    : ������ �������� �ε���(����), -1(����)

- DeleteItemAll : ��Ʈ���� ��ü �������� ���� �Ѵ�.
    ����    : void DeleteItemAll(void);
    Param    : ����
    Return    : ����

- DeleteItemSel : ��Ʈ���� ���õ� �������� ���� �Ѵ�.
    ����    : void DeleteItemSel(void);
    Param    : ����
    Return    : ����

- GetItemPath : ���� ������ ��θ� ��´�.
    ����    : BSTR GetItemPath(LONG index);
    Param    : index(�������� �ε���)
    Return    : ���� ������ ���

- GetItemPdfPath : ��ȯ�� PDF ������ ��θ� ��´�.
    ����    : BSTR GetItemPdfPath(LONG index);
    Param    : index(�������� �ε���)
    Return    : PDF ������ ���

- GetItemState : �������� ���� ������ ��´�.
    ����    : LONG GetItemState(LONG index);
    Param    : index(�������� �ε���)
    Return    : ��ȯ ���(1), ��ȯ��(2), ��ȯ �Ϸ�(3), ��ȯ ����(4)

- ConvertStart : ��ȯ �۾��� �����Ѵ�.
    ����    : LONG ConvertStart();
    Param    : ����
    Return    : 0(����), 0�� ������ ��(����)

- ConvertCancel : ��ȯ �۾��� �����Ѵ�.
    ����    : LONG ConvertCancel();
    Param    : ����
    Return    : 0(����), 0�� ������ ��(����)

�̺�Ʈ
IE
- FinishProcess(nError) : ��ȯ �۾��� ����Ǿ� �ٽ� ��ȯ �۾��� ���� �� �� ���� �� ȣ��ȴ�.
    nError : ��ȯ ������ ����

������ �迭(�ظ����� �迭�� �̺�Ʈ ó���Ⱑ �����Ƿ�... ��⿡�� �Ʒ��� �ڹٽ�ũ��Ʈ�� ������)
- ezPDFConv_EnableProcess(nError)
    nError : ��ȯ ������ ����
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

//    alert("��ȯ�Ϸ�");

    var i=0;
    var state;
    var count = ezPDFConv.CountItem();
    var orgName = '';
    var orgPdfName = '';

//    alert("÷�����ϼ�"+count+"*2");

    for(i=0; i<count; i++)
    {
        state = ezPDFConv.GetItemState(i);
        if(state == 3) // ��ȯ �Ϸ�.
        {
            // ���� ����(����,PDF) ��θ� ���ε� ������Ʈ�� ����
            InnoDS.AddLocalFile(ezPDFConv.GetItemPath(i));
            InnoDS.AddLocalFile(ezPDFConv.GetItemPdfPath(i));
            orgName += ezPDFConv.GetItemPath(i).substring(ezPDFConv.GetItemPath(i).lastIndexOf("\\") + 1) + "��";
            orgPdfName += ezPDFConv.GetItemPdfPath(i).substring(ezPDFConv.GetItemPdfPath(i).lastIndexOf("\\") + 1) + "��";
        }
    }
    var _ds_orifilename = '_innods_orifilename';
    var _ds_oripdffilename = '_innods_oripdffilename'
    var oInput1 = document.createElement( 'input' );
    var oInput2 = document.createElement( 'input' );
    oInput1.type = 'hidden';
    oInput2.type = 'hidden';
    oInput1.name = _ds_orifilename;
    oInput2.name = _ds_oripdffilename;
    oInput1.value = orgName;
    oInput2.value = orgPdfName;
    alert('kangthis logs => ' + oInput1.value);
    alert('kangthis logs => ' + oInput2.value);
    document.inputForm.insertBefore( oInput1, document.inputForm.firstChild );
    document.inputForm.insertBefore( oInput2, document.inputForm.firstChild );
    // ���ε�������Ʈ ȣ��
    // upload();
//    alert("��ȯ�Ϸ�");
    setTimeout("upload()", 2000);
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
alert('kangthis logs => ' + InnoDS.GetFileCount());
        if (InnoDS.GetFileCount() > 0) {
            showUploadInfo();// ���ε� �˸�â ����
			InnoDS.SilentMode = true;
            InnoDS.AddPostData("_SUB_DIR", SubDir);
            InnoDS.StartUpload();
        }
        else{
            var oForm = document.inputForm;
            oForm.count.value = InnoDS.GetFileCount()/2;
            oForm.target = "processingFrame";
            InnoDSSubmit(document.inputForm);
        }
    }
    
	function OnUploadComplete(objName){

        alert('kangthis log => 111'); 

		var fileCount = InnoDS.GetFileCount();
		document.getElementById('uploadInfo').style.display = "none";

        var oForm = document.inputForm;
        oForm.count.value = InnoDS.GetFileCount()/2;
        //oForm.OrgRealFileName.value = ezPDFConv.GetItemPath(0);
        alert('kangthis log => 222'); 
        alert('kangthis log => 333'+document.inputForm.action); 
        oForm.target = "processingFrame";
        InnoDSSubmit(document.inputForm);
    }
	

    //���ε� �˸�â �Լ�
	function showUploadInfo()
	{
		var d = document;
		var uploadInfo = d.getElementById("uploadInfo");
		uploadInfo.style.display = "";
	}
</script>

<!-- /////////////////////////////    INNODSP SCRIPT END    ///////////////////////////// -->
<meta http-equiv="X-UA-Compatible" content="IE=10">
</head>
<title>
<%
    if ("Y".equalsIgnoreCase(strAddAnsFlag)) out.println("�߰� �亯 �ۼ�");
    else out.println(MenuConstants.REQ_BOX_MAKE+"- �亯 �ۼ�");
%>
</title>
<body>
<!--�������� ��-->
<!-- <div id="uploadInfo" style="display:none;position:absolute; left:125px; top:164px; width:336px; height:76px; z-index:12; "> -->
<div id="uploadInfo" style="display:none;position:absolute; left:145px; top:117px; width:285px; height:119px; z-index:12; ">
    <img src="/images2/common/loading.gif">
</div>

<!--  ���¹� -->
<div  id="fileupload">
<iframe name='processingFrame' height='0' width='0'></iframe>

<DIV ID="loadingDiv" style="width:220;height:180;display:none;position:absolute;left:80;top:120">
    <img src="/image/reqsubmit/loading.jpg" border="0">
</DIV>


<div class="popup">
<p>�亯 �ۼ�</p>

<!------------------------- �亯 �ۼ� ���� �Է� �� ���� ------------------------->
<form     name="inputForm"
    action="/reqsubmit/common/SAnsInfoWriteProcPopup_test.jsp"
    method="post" enctype="multipart/form-data" style="margin:0px">
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

        <%// ���� ��� : ������ �����̾����� �亯�� ��� ������ �ϱ�� �����Ƿ� ���� ó�� %>
        <%// ���� ��� : ������ �����̿����� �������� ���� 2015.11.09 ksw %>
        <input type="hidden" name="OpenCL" value="<%= strOpenCL %>">
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
                                <th height="25">&bull;&nbsp;&nbsp;�亯���� </th>
                                <td>
                                    <select name="AnsType" onChange="javascript:changeInputForm(this.value)">
                                        <option value="<%= CodeConstants.ANS_MTD_ELEC %>"><%= CodeConstants.getAnswerMethod(CodeConstants.ANS_MTD_ELEC) %></option>
                                        <option value="<%= CodeConstants.ANS_MTD_ETCS %>"><%= CodeConstants.getAnswerMethod(CodeConstants.ANS_MTD_ETCS) %></option>
                                        <option value="<%= CodeConstants.ANS_MTD_NONE %>"><%= CodeConstants.getAnswerMethod(CodeConstants.ANS_MTD_NONE) %></option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <th height="25">&bull;&nbsp;&nbsp;���� �ǰ� </th>
                                <td>
                                <textarea
                                onKeyDown="javascript:updateCharAnother(document.inputForm, 'AnsOpin', 250)"
                                onKeyUp="javascript:updateCharAnother(document.inputForm, 'AnsOpin', 250)"
                                onFocus="javascript:updateCharAnother(document.inputForm, 'AnsOpin', 250)"
                                onClick="javascript:updateCharAnother(document.inputForm, 'AnsOpin', 250)"
                                name="AnsOpin" wrap="hard" rows="6" cols="72" style="width:90%;"></textarea>
                                <br />
                                <span id ="textlimit"></span>&nbsp;bytes (250 bytes ������ �Էµ˴ϴ�)
                                </td>
                            </tr>
                            <tr>
                                <td height="25" colspan="2">
                                    <!-------------------------------------------- �������� ��ȭ�ϴ� FORM START ---------------------------------------------------->
                                    <DIV id="inputDiv" style="position:relative; left:0px;top:0px;width:460; border-width:0px; border-style:none;">
                                    </DIV>
                                    <!-------------------------------------------- �������� ��ȭ�ϴ� FORM END ---------------------------------------------------->
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
        <script language="javascript">
            if (navigator.appName == "Microsoft Internet Explorer") {
                var str = "<OBJECT ID='ezPDFConv' height='173' width='570' CLASSID='CLSID:ABBFCE48-008E-4DA1-8F5F-DF9E9749DC9D'";
                str = str + " codebase='http://naps.assembly.go.kr/cab/ezPDFConv.cab#Version=1,0,0,6' ";
                str = str + " hspace='10' vspace='10' align='middle'>";
                str = str + "</OBJECT>";
                document.write(str);
            }else{
                // Mozilla Plugin Info.
                var    ezPDF_PluginType = "application/npezPDFConv";
                var    ezPDF_PluginName = "ezPDFConv";
                var    ezPDF_PluginDescription = "ezPDFConv Plugin Ver. 1.0.0.6";

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
        </td>
        </tr>
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

    <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
            <td align="center" height="50px;">

                <span onclick="javascript:if (document.inputForm.AnsOpin.value == ''){alert('�����ǰ��� �Է��� �ּ���');}else{if(ezPDFConv.CountItem()<1){alert('������ ������ �ּ���');}else{ezPDFConv.ConvertStart();}}" onfocus="this.blur();"><img border="0" src="/images2/btn/w_answer.gif" alt="�亯���" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"  /></span>
                <span onclick="javascript:window.close();" onfocus="this.blur();"><img border="0" src="/images2/btn/w_answer_cancel.gif" alt="�亯���" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);" /></span>

            </td>
        </tr>
    </table>

</DIV>
                     <p><br></p>
                    <p><br></p>
                <!------------------------- �亯 �ۼ� ���� �Է� �� �� ------------------------->
                   </td>
             </tr>

            </table></td>
        </tr>
      </table></td>
  </tr>
</table>
<!-- ���ڹ��� �� ��� Msg Digest�� �����ϰ� ������� �޾Ƽ� String�� ������ �ǰ�, �������� �׳� String���̴ϱ�... -->
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
    <input type="hidden" name="OrgRealFileName" value="">
    <input type="hidden" name="PdfRealFileName" value="">
</FORM>

</center>
</div>

<div id="download" style="display:none;">
<script>
    function fdown(){
        document.location.href="/cab/innomp_win.exe";
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

    var Enc = "F1yV/Ih1CIWKmwpkR++vU4L5x6Qw09ZdbnfMOMAF4yP/qX8ir89PSOJEu0KGxmZ7+nwY4oq8SqjF6+BH2rAyuehELATMrnCBJd33fPqR3zO0/EZoPZFUTOJnU4al6tZO+4gcNw==";
    var InputType = "fixed";
    var SubDir = "<%=yearStr%>";
    var UploadURL = "/InnoDSP/action_nads.jsp?_SUB_DIR="+SubDir;
    InnoDSInit( -1 , -1 , -1 , 1 , 1 );
    innomp_install_check();
    //document.getElementById("inputDiv2").style.display="none";
    try{
        innomp_get_obj("innomp").GetVersion();
        document.getElementById('innomp_check_obj').innerHTML = "";
    } catch(err) {
        document.getElementById("fileupload").style.display="none";
        document.getElementById("download").style.display="";
        document.getElementById("filedownload").style.display="";
    }

    try{
        document.ezPDFConv.DeleteItemAll();
    } catch(err){
        document.getElementById("fileupload").style.display="none";
        document.getElementById("download").style.display="";
        document.getElementById("pdfdownload").style.display="";
    }

</script>
<!--input type="button" value="���ε�" onClick="InnoDS.StartUpload();"-->
</div>
</body>
</html>
