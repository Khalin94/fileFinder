<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.lib.reqsubmit.params.requestinfo.SPreReqInfoVListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.prereqinfo.SPreReqInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.prereqbox.PreRequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.prereqbox.SPreReqBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.SMemReqInfoDelegate" %>
<%@ page import="kr.co.kcc.pf.ejb.EJBExtendException" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	UserInfoDelegate objUserInfo =null;
	CDInfoDelegate objCdinfo =null;
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

	PreRequestBoxDelegate reqDelegate = null;
	SPreReqInfoDelegate selfDelegate = null;
	SPreReqBoxDelegate selfDelegateBox =null; //�䱸�� ���� �ӽù��� -by yan
	SMemReqInfoDelegate objSReqInfo = null;

	SPreReqInfoVListForm objParams = new SPreReqInfoVListForm();

	boolean blnParamCheck=false;
	blnParamCheck = objParams.validateParams(request);
	if(blnParamCheck==false) {
  		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  		objMsgBean.setStrCode("DSPARAM-0000");
  		objMsgBean.setStrMsg(objParams.getStrErrors());
  		out.println("ParamError:" + objParams.getStrErrors());
	  	return;
  	}//endif

	// �Ѿ�� �Ķ���͸� �����ؼ� �ʿ��� �� ������ ����
	// �䱸�� ����
	String strReqBoxID = objParams.getParamValue("ReqBoxID");
	String strReqID = objParams.getParamValue("ReqID");

	String strReqBoxSortField = StringUtil.getEmptyIfNull((String)objParams.getParamValue("ReqBoxSortField"));
	String strReqBoxSortMtd = StringUtil.getEmptyIfNull((String)objParams.getParamValue("ReqBoxSortMtd"));
	String strReqBoxPagNum = StringUtil.getEmptyIfNull((String)objParams.getParamValue("ReqBoxPage"));
	String strReqBoxQryField = StringUtil.getEmptyIfNull((String)objParams.getParamValue("ReqBoxQryField"));
	String strReqBoxQryTerm = StringUtil.getEmptyIfNull((String)objParams.getParamValue("ReqBoxQryTerm"));

	// �䱸 ��� ����
	String strReqInfoSortField = objParams.getParamValue("ReqInfoSortField");
	String strReqInfoSortMtd = objParams.getParamValue("ReqInfoSortMtd");
	String strReqInfoQryField = objParams.getParamValue("ReqInfoQryField");
	String strReqInfoQryTerm = objParams.getParamValue("ReqInfoQryTerm");
	String strReqInfoPagNum = objParams.getParamValue("ReqInfoPage");

	// 2004-06-04 �̿��� ������ USER DN
	String strUserDN = null;

	// 2004-05-04 �߰��� �Ķ���� : ���� �����ϱ� ���� �׳� �̷��� ����. -��-
	String strReturnURL = StringUtil.getEmptyIfNull(request.getParameter("ReturnURL"));

	// 2004-05-08 �߰��� �Ķ���� : �߰��亯����
	String strAddAnsFlag = StringUtil.getEmptyIfNull(request.getParameter("AddAnsFlag"), "N");

	if ("".equalsIgnoreCase(StringUtil.getEmptyIfNull(strReqID))) { // �䱸ID�� NULL�̸� �ȵȴ�. �����~~
		throw new EJBExtendException("�䱸 ID�� ���� �ȵ���~~~");
	}

	if ("".equalsIgnoreCase(StringUtil.getEmptyIfNull(strReqBoxID))) { // �䱸�� ID�� NULL�̸� �ȵȴ�. �����~~
		throw new EJBExtendException("�䱸�� ID�� ���� �ȵ���~~~");
	}

	ResultSetSingleHelper objRsSH = null;

	try{
	   	reqDelegate = new PreRequestBoxDelegate();
	   	selfDelegate = new SPreReqInfoDelegate();
	   	selfDelegateBox = new SPreReqBoxDelegate();
		objSReqInfo = new SMemReqInfoDelegate();

	   	//boolean blnHashAuth = selfDelegateBox.checkReqBoxAuth(strReqBoxID, objUserInfo.getOrganID()).booleanValue();
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
	    	//strUserDN = objSReqInfo.getUserDN(objUserInfo.getUserID());
	    	HttpSession objPrivateSession = request.getSession();
			strUserDN = StringUtil.getEmptyIfNull((String)objPrivateSession.getAttribute("UserDN"));
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
<link href="/css/System.css" rel="stylesheet" type="text/css">
<script src="/js/reqsubmit/common.js"></script>
<script language="javascript">
<!--
// ��ó���� ���� �Լ��ӿ� �и��ϴ�.
// ���忡�� ���ٸ� ��å�� ��� �켱 �̷��� �д�.
// ���� ȹ������ �������� �Ϸ绡�� �������� �ٶ��... -��-
function changeInputForm(value) {
	var str = "";
	if (value == "<%= CodeConstants.ANS_MTD_ELEC %>") { // ���������� ���
        document.getElementById("inputDiv1").style.display = "block";
        document.getElementById("inputDiv2").style.display = "block";
        document.getElementById("inputDiv3").style.display = "none";
        document.getElementById("inputDiv4").style.display = "none";
	} else if (value == "<%= CodeConstants.ANS_MTD_ETCS%>") { // ������������ ���
        document.getElementById("inputDiv1").style.display = "none";
        document.getElementById("inputDiv2").style.display = "none";
        document.getElementById("inputDiv3").style.display = "block";
        document.getElementById("inputDiv4").style.display = "block";
	} else { // �ش� ��� �ƴ��� ���
        document.getElementById("inputDiv1").style.display = "none";
        document.getElementById("inputDiv2").style.display = "none";
        document.getElementById("inputDiv3").style.display = "none";
        document.getElementById("inputDiv4").style.display = "none";
	}
}

// �亯 ������ ���� �Է� ���� �޶����Ƿ� ������ �ʼ��Է°��� ���� ���並 ����.. �־��ֽþ��~

function checkSubmit() {
	var f = document.inputForm;
	var ansType = f.AnsType.value;

	if (ansType == "<%= CodeConstants.ANS_MTD_ELEC %>") { // ���������ΰ���?
		if (f.OriginFile.value == "") {
			alert("���� ���� ������ ������ �ּ���");
			f.OriginFile.focus();
			return;
		} else if (f.PdfFile.value == "") {
			alert("PDF ������ ������ �ּ���");
			f.PdfFile.focus();
			return;
		} else if (f.AnsOpin.value == "") {
			f.AnsOpin.value = "���� �ǰ� ����";
		}

		var pdfFileName = f.PdfFile.value;
		var orgFileName = f.OriginFile.value;

		var pdfDot = pdfFileName.lastIndexOf('.');
		var orgDot = orgFileName.lastIndexOf('.');

		var pdfExt = pdfFileName.substring(pdfDot+1);
		var orgExt = orgFileName.substring(orgDot+1);

		if (orgExt.toUpperCase() != "PDF") {
			f.OriginFile.value == "";
			//orgFileName == pdfFileName;
		}

		if (pdfExt.toUpperCase() != "PDF") {
			alert("PDF ������ ������ �ּ���");
			f.PdfFile.focus();
			return;
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
			f.AnsOpin.value = "���� �ǰ� ����";
		}
	} else if (ansType == "<%= CodeConstants.ANS_MTD_NONE %>") { // �ش����� �ƴѰ���?
		if (f.AnsOpin.value == "") {
			f.AnsOpin.value = "���� �ǰ� ����";
		}
	}

	if (getByteLength(f.AnsOpin.value) > 500) {
		alert("�ѱ�, ������ ���� 500�� �̳��� �Է��� �ּ���. ��, �ѱ��� 2�ڷ� ó���˴ϴ�.");
		f.AnsOpin.focus();
		return;
	}

	if (confirm("�Է��Ͻ� �亯 �ڷḦ ����Ͻðڽ��ϱ�?")) {
		if (ansType == "<%= CodeConstants.ANS_MTD_ELEC %>") {
			f.action = "/reqsubmit/common/SAnsInfoWriteProcPopup.jsp";
			f.target="hiddenPop";
			document.returnSubmitForm.AnsOpin.value = f.AnsOpin.value;
			NewWindow2('/blank.html', 'hiddenPop', '320', '240', 'OUT');
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
	f.action = "<%= strReturnURL.substring(0, StringUtil.getLastIndex(strReturnURL, "?")) %>";
	f.target = "";
	f.submit();
}
//-->
</script>
</head>

<body>
<div id="wrap">
  <jsp:include page="/inc/top.jsp" flush="true"/>
  <jsp:include page="/inc/top_menu02.jsp" flush="true"/>
  <div id="container">
    <div id="leftCon">
      <jsp:include page="/inc/log_info.jsp" flush="true"/>
      <jsp:include page="/inc/left_menu02.jsp" flush="true"/>
    </div>

	<div id="rightCon">
      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <%
            if ("Y".equalsIgnoreCase(strAddAnsFlag)) out.println("<h3>�߰� �亯 �ۼ�</h3>");
            else out.println("<h3>"+MenuConstants.REQ_BOX_PRE+"<span class='sub_stl'>- �亯 �ۼ�</span></h3>");
        %>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.REQUEST_BOX_COMM%> > <%=MenuConstants.REQUEST_BOX_PRE%> >
        <%
							if ("Y".equalsIgnoreCase(strAddAnsFlag)) out.println("�߰� �亯 �ۼ�");
							else out.println("�亯 �ۼ�");
						    %>
        </div>
        <p><!--����--></p>
      </div>
      <!-- /pgTit -->
      <!-- contents -->
      <div id="contents">
        <!-- �˻����� ���� ��� �Ʒ� div ���� �� �ּ����� ��������.--><!-- /�˻�����-->
        <!-- �������� ���� -->
        <!-- list -->
		<span class="list02_tl">�䱸 ���� </span>
        <table border="0" cellspacing="0" cellpadding="0" class="list02">
            <tr>
                <th height="25">&bull;&nbsp; �䱸�Ը�</th>
                <td height="25" colspan="3"><%= objRsSH.getObject("REQ_BOX_NM") %></td>
            </tr>
            <tr>
                <th height="25">&bull;&nbsp; �䱸����</th>
                <td height="25" colspan="3"><%= StringUtil.getDescString((String)objRsSH.getObject("REQ_CONT")) %></td>
            </tr>
            <tr>
                <th height="25">&bull;&nbsp; �䱸����</th>
                <td height="25" colspan="3"><%= StringUtil.getDescString((String)objRsSH.getObject("REQ_DTL_CONT")) %></td>
            </tr>
            <tr>
                <th height="25">&bull;&nbsp; �����䱸����</th>
                <td width="191" height="25"><%= StringUtil.getDate((String)objRsSH.getObject("REG_DT")) %></td>
                <th height="25">&bull;&nbsp; �䱸���</th>
                <td width="191"><%= objRsSH.getObject("REQ_ORGAN_NM") %></td>
            </tr>
            <tr>
                <th height="25">&bull;&nbsp; �������</th>
                <td width="181" height="25"><%= CodeConstants.getOpenClass((String)objRsSH.getObject("OPEN_CL")) %></td>
                <th height="25">&bull;&nbsp; ����������</th>
                <td width="242">
                    <%= StringUtil.makeAttachedFileLink((String)objRsSH.getObject("ANS_ESTYLE_FILE_PATH"), (String)objRsSH.getObject("REQ_ID")) %>
                </td>
            </tr>
        </table>
    <!------------------------- TAB�� �ش��ϴ� ���̺�(����̵� ������̵� ��������) ��� �� ------------------------->
        <div id="btn_all"  class="t_right">
            <span class="list_bt"><a href="#" onClick="javascript:gotoReqInfoView()" >����ȭ��</a></span>
        </div>

    <!------------------------- �� TAB�� �ΰ� �����ø� ���� �ҽ����� �����ؼ� �� ���� �ٿ��ֱ� �ؼ� �����ϼ��� ------------------------->
    <!----- [����] TAB <tr> �� �� �ؿ� ������ �����ϴ� <tr>�� �� �����ؼ� �� ì�� �ֽþ��. ������.. -------->
    <span class="list02_tl">�亯 ���� </span>
    <!------------------------- �亯 ���� ���� �Է� �� ���� ------------------------->
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
    <input type="hidden" name="ReturnURL" value="<%= strReturnURL %>">
    <% // ���� ��� : ������ �����̾����� �亯�� ��� ������ �ϱ�� �����Ƿ� ���� ó�� %>
    <input type="hidden" name="OpenCL" value="<%= CodeConstants.OPN_CL_OPEN %>">
    <input type="hidden" name="AddAnsFlag" value="<%= strAddAnsFlag %>">
    <input type="hidden" name="UserDN" value="<%= strUserDN %>">

    <table border="0" cellspacing="0" cellpadding="0" class="list02">
        <tr>
          <th height="25">&bull;&nbsp; �亯 ����</td>
          <td height="25"><select name="AnsType" onChange="javascript:changeInputForm(this.value)" class="select">
                    <option value="<%= CodeConstants.ANS_MTD_ELEC %>"><%= CodeConstants.getAnswerMethod(CodeConstants.ANS_MTD_ELEC) %></option>
                    <option value="<%= CodeConstants.ANS_MTD_ETCS %>"><%= CodeConstants.getAnswerMethod(CodeConstants.ANS_MTD_ETCS) %></option>
                    <option value="<%= CodeConstants.ANS_MTD_NONE %>"><%= CodeConstants.getAnswerMethod(CodeConstants.ANS_MTD_NONE) %></option>
                </select></td>
        </tr>
        <tr id="inputDiv1" style="position:relative; left:0px;top:0px;width:700; z-index:1; border-width:0px; border-style:none;">
            <th height="25">&bull;&nbsp; ���� ����</th>
            <td height="25"><input type="file" class="textfield" name="OriginFile" size="40"></td>
        </tr>
        <tr id="inputDiv2">
            <th height="25">&bull;&nbsp; PDF ����</th>
            <td height="25"><input type="file" class="textfield" name="PdfFile" size="40"></td>
        </tr>
        <tr id="inputDiv3" style="display:none">
            <th height="25">&bull;&nbsp; ��ü����</th>
	    	<td width="560" class="td_lmagin">
                <select name="MatType" class='select'><option value=''>::: ������ �ּ��� :::</option>
                <%
                    List matList = (List)objCdinfo.getNotElecMediumList();
                    if (matList.size() == 0) {
                        out.println("<option value=''>��ϵ� ��ü�� �����ϴ�.</option>");
                    } else {
                        for(int i=0; i<matList.size(); i++) {
                            Hashtable hash = (Hashtable)matList.get(i);
                            String code = (String)hash.get("MSORT_CD");
                            String codeValue = (String)hash.get("CD_NM");
                            out.println("<option value='"+code+"'>"+codeValue+"</option>");
                        }
                    }
                %>
                </select>
    		</td>
		</tr>
		<tr id="inputDiv4" style="display:none">
    		<th height="25">&bull;&nbsp; �߼� ���</th>
	    	<td class="td_lmagin"><select name="SendWay" class='select'>
            <option value=''>::: ������ �ּ��� :::</option>
            <%
                List swList = (List)objCdinfo.getSendWayList();
                if (swList.size() == 0) {
                    out.println("<option value=''>��ϵ� �߼۹���� �����ϴ�.</option>");
                } else {
                    for(int i=0; i<swList.size(); i++) {
                        Hashtable hash = (Hashtable)swList.get(i);
                        String code = (String)hash.get("MSORT_CD");
                        String codeValue = (String)hash.get("CD_NM");
                        out.println("<option value='"+code+"'>"+codeValue+"</option>");
                    }
                }
            %>
        </tr>
        <tr>
            <th height="25">&bull;&nbsp; ���� �ǰ�</th>
            <td width="560"  height="25" style="padding-top:5px;padding-bottom:5px"><textarea name="AnsOpin" wrap="hard" class="textfield" style="WIDTH: 90% ; height: 80"></textarea></td>
        </tr>
    </table>
    <p>
</form>
        <div id="btn_all"  class="t_right">
            <span class="list_bt"><a href="#" onClick="javascript:checkSubmit()" >����</a></span>
            <span class="list_bt"><a href="#" onClick="javascript:document.inputForm.reset()" >���</a></span>
        </div>
        <p><br></p>
        <p><br></p>
    <!------------------------- �亯 ���� ���� �Է� �� �� ------------------------->
    </td>
 </tr>
 <tr>
    <td height="35">&nbsp;</td>
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
	<input type="hidden" name="ReturnURL" value="<%= strReturnURL %>">
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

	<% // ���� ��� : ������ �����̾����� �亯�� ��� ������ �ϱ�� �����Ƿ� ���� ó�� %>
	<input type="hidden" name="OpenCL" value="<%= CodeConstants.OPN_CL_OPEN %>">
	<input type="hidden" name="AddAnsFlag" value="<%= strAddAnsFlag %>">

	<input type="hidden" name="AnsType" value="">
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

	<input type="hidden" name="user_dn" value="<%= strUserDN %>">
	<input type="hidden" name="UserDN" value="<%= strUserDN %>">

</FORM>

<DIV ID="loadingDiv" style="width:220;height:180;display:none;position:absolute;left:450;top:500">
	<img src="/image/reqsubmit/loading.gif" border="0"> </td>
</DIV>

</body>
</html>