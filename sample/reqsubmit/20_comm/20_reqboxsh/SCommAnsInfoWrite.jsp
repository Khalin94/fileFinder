<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.lib.reqsubmit.params.requestinfo.SCommReqInfoVListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.SCommRequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.SMemReqInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.CommRequestInfoDelegate" %>
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

	SCommRequestBoxDelegate objReqBox = null;
	CommRequestInfoDelegate objReqInfo = null;
	SMemReqInfoDelegate objSReqInfo = null;

	SCommReqInfoVListForm objParams = new SCommReqInfoVListForm();  

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
	
	String strReqBoxSortField = objParams.getParamValue("ReqBoxSortField");
	String strReqBoxSortMtd = objParams.getParamValue("ReqBoxSortMtd");
	String strReqBoxPagNum = objParams.getParamValue("ReqBoxPage");
	String strReqBoxQryField = objParams.getParamValue("ReqBoxQryField");
	String strReqBoxQryTerm = objParams.getParamValue("ReqBoxQryTerm");
	
	// �䱸 ��� ���� 
	String strReqInfoSortField = objParams.getParamValue("ReqInfoSortField");
	String strReqInfoSortMtd = objParams.getParamValue("ReqInfoSortMtd");
	String strReqInfoQryField = objParams.getParamValue("ReqInfoQryField");
	String strReqInfoQryTerm = objParams.getParamValue("ReqInfoQryTerm");
	String strReqInfoPagNum = objParams.getParamValue("ReqInfoPage");
	
	// 2004-05-04 �߰��� �Ķ���� : ���� �����ϱ� ���� �׳� �̷��� ����. -��-
	String strReturnURL = StringUtil.getEmptyIfNull(request.getParameter("ReturnURL"));
	//if (StringUtil.isAssigned(strReturnURL)) strReturnURL = strReturnURL+"?ReqBoxID="+strReqBoxID+"&ReqID="+strReqID;
	//else strReturnURL = "/reqsubmit/10_mem/20_reqboxsh/10_make/SMakeReqInfoVList.jsp?ReqBoxID="+strReqBoxID+"&ReqID="+strReqID;
	
	if ("".equalsIgnoreCase(StringUtil.getEmptyIfNull(strReqID))) { // �䱸ID�� NULL�̸� �ȵȴ�. �����~~
		throw new EJBExtendException("�䱸 ID�� ���� �ȵ���~~~");
	}
	
	if ("".equalsIgnoreCase(StringUtil.getEmptyIfNull(strReqBoxID))) { // �䱸�� ID�� NULL�̸� �ȵȴ�. �����~~
		throw new EJBExtendException("�䱸�� ID�� ���� �ȵ���~~~");
	}
	
	// 2004-05-08 �߰��� �Ķ���� : �߰��亯����
	String strAddAnsFlag = StringUtil.getEmptyIfNull(request.getParameter("AddAnsFlag"), "N");

	// 2004-06-04 �̿��� ������ USER DN
	String strUserDN = null;

	ResultSetSingleHelper objRsSH = null;
	
	try{
	   	objReqBox = new SCommRequestBoxDelegate();
	   	objReqInfo = new CommRequestInfoDelegate();
		objSReqInfo = new SMemReqInfoDelegate();
   
	   /*
	   	boolean blnHashAuth = reqDelegate.checkReqBoxAuth(strReqBoxID, objUserInfo.getOrganID()).booleanValue();
	   
	   	if(!blnHashAuth) { 
	   		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	  		objMsgBean.setStrCode("DSAUTH-0001");
  	  		objMsgBean.setStrMsg("�ش� �䱸���� �� ������ �����ϴ�.");
  	  		out.println("�ش� �䱸���� �� ������ �����ϴ�.");
		    return;
		} else {
	   */
    	// �䱸 ��� ������ SELECT �Ѵ�.
    	objRsSH = new ResultSetSingleHelper(objReqInfo.getRecord(strReqID));
		
		// 2004-06-04 �̿����� ������ USER DN ���� �����ͼ� �����Ѵ�.
    	//strUserDN = objSReqInfo.getUserDN(objUserInfo.getUserID());
    	HttpSession objPrivateSession = request.getSession();
		strUserDN = StringUtil.getEmptyIfNull((String)objPrivateSession.getAttribute("UserDN"));
		//}

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
	if ("Y".equalsIgnoreCase(strAddAnsFlag)) {
		out.println("�߰� �亯 �ۼ�");
	} else { 
		out.println("�ۼ� �� �䱸��- �亯 �ۼ�");
	} 
%>
</title>
<link href="/css/System.css" rel="stylesheet" type="text/css">
<script language="javascript" src="/js/reqsubmit/common.js"></script>
<script language="javascript">
<!--
// ��ó���� ���� �Լ��ӿ� �и��ϴ�.
// ���忡�� ���ٸ� ��å�� ��� �켱 �̷��� �д�.
// ���� ȹ������ �������� �Ϸ绡�� �������� �ٶ��... -��-
function changeInputForm(value) {
	var str = "";
	if (value == "<%= CodeConstants.ANS_MTD_ELEC %>") { // ���������� ���
		str = "";
		str = str + "<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\n";
		str = str + "<tr>\n";
		str = str + "<td width=\"120\" height=\"25\" class=\"td_gray1\"><img src='/image/common/icon_nemo_gray.gif'> ���� ���� </td>\n";
		str = str + "<td width=\"560\" height=\"25\" class=\"td_lmagin\"><input type=\"file\" class=\"textfield\" name=\"OriginFile\" size=\"40\"></td></tr>\n";
		str = str + "<tr height=\"1\" class=\"tbl-line\"><td height=\"1\"></td><td height=\"1\"></td></tr>\n";
		str = str + "<tr>\n";
		str = str + "<td height=\"25\" class=\"td_gray1\"><img src='/image/common/icon_nemo_gray.gif'> PDF ���� </td>\n";
		str = str + "<td height=\"25\" class=\"td_lmagin\"><input type=\"file\" class=\"textfield\" name=\"PdfFile\" size=\"40\"></td></tr>\n";
		str = str + "<tr height=\"1\" class=\"tbl-line\"><td height=\"1\"></td><td height=\"1\"></td></tr>\n";
		str = str + "</table>\n";
		str = str + "<input type=hidden name=MatType value=''>\n";
		str = str + "<input type=hidden name=SendWay value=''>\n";
		
		document.all.inputDiv.innerHTML = str;

	} else if (value == "<%= CodeConstants.ANS_MTD_ETCS%>") { // ������������ ���
	
		str = "";
		str = str + "<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\n";
		str = str + "<tr>\n";
		str = str + "<td width=\"120\" height=\"25\" class=\"td_gray1\"><img src='/image/common/icon_nemo_gray.gif'> ��ü����</td>\n";
		str = str + "<td width=\"560\" class=\"td_lmagin\"><select name=\"MatType\" class='select'><option value=''>::: ������ �ּ��� :::</option>";
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
		str = str + "<tr height=\"1\" class=\"tbl-line\"><td height=\"1\"></td><td height=\"1\"></td></tr>\n";
		str = str + "<tr>\n";
		str = str + "<td height=\"25\" class=\"td_gray1\"><img src='/image/common/icon_nemo_gray.gif'> �߼� ���</td>\n";
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
		str = str + "<tr height=\"1\" class=\"tbl-line\"><td height=\"1\"></td><td height=\"1\"></td></tr>\n";
		str = str + "</table>\n";
		str = str + "<input type=hidden name=OriginFile value=''>\n";
		str = str + "<input type=hidden name=PdfFile value=''>\n";
		
		document.all.inputDiv.innerHTML = str;
	} else { // �ش� ��� �ƴ��� ���
		str = "";
		str = str + "<input type=hidden name=MatType value=''>\n";
		str = str + "<input type=hidden name=SendWay value=''>\n";
		str = str + "<input type=hidden name=OriginFile value=''>\n";
		str = str + "<input type=hidden name=PdfFile value=''>\n";
		document.all.inputDiv.innerHTML = str;
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
		document.returnSubmitForm.AnsOpin.value = f.AnsOpin.value;
		if (ansType == "<%= CodeConstants.ANS_MTD_ELEC %>") {
			f.action = "/reqsubmit/common/SAnsInfoWriteProcPopup.jsp";
			f.target="hiddenPopup";
			document.returnSubmitForm.AnsOpin.value = f.AnsOpin.value;
			NewWindow2('/blank.html', 'hiddenPopup', '320', '240', 'OUT');
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
	f.action = "<%=strReturnURL.substring(0, StringUtil.getLastIndex(strReturnURL, "?")) %>";
	f.target= "";
	f.submit();
}
//-->
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<%@ include file="/reqsubmit/common/MenuTopReqsubmit.jsp" %>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr align="left" valign="top">
    <td width="186" height="470" background="/image/common/bg_leftMenu.gif">
	<%@ include file="/reqsubmit/common/MenuLeftReqsubmit.jsp" %></td>
<!------- 2004-06-02 ������ �������� ���� ����� �κ� ���� ------->
	<td width="100%">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr height="24" valign="top"> 
    	<td height="24" colspan="2" align="left"><table width="789" height="24" border="0" cellpadding="0" cellspacing="0" bgcolor="DEEFCC">
    <tr>
    	<td height="24"></td>
	</tr>
    </table></td>
    </tr>
<!------- 2004-06-02 ������ �������� ���� ����� �κ� �� ------->
        <tr valign="top"> 
          <td width="30" align="left"><img src="/image/common/bg_leftBody.gif" width="30" height="1"></td>
          <td align="left">
          <table width="759" border="0" cellspacing="0" cellpadding="0">
          <tr> 
                <td align="left" valign="top">
                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                <tr>
					<td colspan="3" height="23px">
				</tr>
                <tr> 
                      <td width="25%" background="/image/reqsubmit/bg_reqsubmit_tit.gif" height="23" >
                      		<!-------------------- Ÿ��Ʋ�� �Է��� �ּ��� ------------------------>
                      		<% 
								if ("Y".equalsIgnoreCase(strAddAnsFlag)) {
									out.println("<span class='title'>�߰� �亯 �ۼ�</span>");
								} else { 
									out.println("<span class='title'>"+MenuConstants.REQ_BOX_MAKE+"</span> <strong>- �亯 �ۼ�</strong>");
								} 
							%>
                      </td>
                      <td width="16%" align="left" background="/image/common/bg_titLine.gif">&nbsp;</td>
                      <td width="59%" align="right" background="/image/common/bg_titLine.gif" class="text_s">
                      		<!-------------------- ���� ��ġ ������ ����Ѵ�ϴ�. ------------------------>
                      		<img src="/image/common/icon_navi.gif" width="3" height="5" align="absmiddle"> 
							<% if ("Y".equalsIgnoreCase(strAddAnsFlag)) { %>
									<%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <B>�߰� �亯 �ۼ�</B>
							<% } else { %>
									<%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.REQUEST_BOX_GENERAL%> > <B><%=MenuConstants.REQ_BOX_MAKE%></B>
							<% } %>
                      </td>
                    </tr>
                  </table></td>
              </tr>
              <tr> 
                <td height="30" align="left" class="text_s">
                		<!-------------------- ���� �������� ���� ���� ��� ------------------------>
                		�䱸 ����� �䱸�� ���� �亯�� �����Ͻ� �� �ֽ��ϴ�.
                </td>
              </tr>
              <tr> 
                <td height="5" align="left" class="soti_reqsubmit"></td>
              </tr>
              <tr> 
                <td height="30" align="left" class="soti_reqsubmit">
                	<!-------------------- TAB �� �ش��ϴ� ������ ����ϴ� ��������. ------------------------>
                	<img src="/image/reqsubmit/icon_reqsubmit_soti.gif" width="9" height="9" align="absmiddle"> 
                  �䱸 ����
                </td>
              </tr>
              <tr> 
                <td align="left" valign="top" class="soti_reqsubmit">

                <!------------------------- TAB�� �ش��ϴ� ���̺�(����̵� ������̵� ��������) ��� ��~~~�� ------------------------->
					<table width="680" border="0" cellspacing="0" cellpadding="0">
                    	<tr class="td_reqsubmit"> 
                      		<td width="149" height="2"></td>
                      		<td height="2" colspan="3"></td>
                    	</tr>
                    	
                    	<tr> 
                      		<td height="25" class="td_gray1">
                      			<img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> �䱸����
                      		</td>
                      		<td height="25" colspan="3" class="td_lmagin"><B><%= objRsSH.getObject("REQ_CONT") %></B></td>
                    	</tr>
                    	<tr height="1" class="tbl-line"> 
                      		<td height="1"></td>
                      		<td height="1" colspan="3"></td>
                    	</tr>
                    	<tr> 
                      		<td height="25" class="td_gray1">
                      			<img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> �䱸����
                      		</td>
                      		<td height="25" colspan="3" class="td_lmagin"><%= objRsSH.getObject("REQ_DTL_CONT") %></td>
                    	</tr>
                    	<tr height="1" class="tbl-line"> 
                      		<td height="1"></td>
                      		<td height="1" colspan="3"></td>
                    	</tr>
                    	
                    	<tr> 
                      		<td height="25" class="td_gray1">
                      			<img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> �䱸�Ը�
                      		</td>
                      		<td height="25" colspan="3" class="td_lmagin"><%= objRsSH.getObject("REQ_BOX_NM") %></td>
                    	</tr>
                    	<tr height="1" class="tbl-line"> 
                      		<td height="1"></td>
                      		<td height="1" colspan="3"></td>
                    	</tr>
                    	
                    	<tr> 
                      		<td height="25" class="td_gray1">
                      			<img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> �����䱸����
                      		</td>
                      		<td width="181" height="25" class="td_lmagin"><%= StringUtil.getDate((String)objRsSH.getObject("LAST_REQ_DT")) %></td>
                      		<td width="108" height="25" class="td_gray1">
                      			<img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> �䱸���
                      		</td>
                      		<td width="242" class="td_lmagin"><%= objRsSH.getObject("REQ_ORGAN_NM") %></td>
                    	</tr>
                    	<tr height="1" class="tbl-line"> 
                      		<td height="1"></td>
                      		<td height="1" colspan="3"></td>
                    	</tr>
                    	<tr> 
                      		<td height="25" class="td_gray1">
                      			<img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> �������
                      		</td>
                      		<td width="181" height="25" class="td_lmagin"><%= CodeConstants.getOpenClass((String)objRsSH.getObject("OPEN_CL")) %></td>
                      		<td width="108" height="25" class="td_gray1">
                      			<img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> ����������
                      		</td>
                      		<td width="242" class="td_lmagin">
                      			<%= StringUtil.makeAttachedFileLink((String)objRsSH.getObject("ANS_ESTYLE_FILE_PATH"), (String)objRsSH.getObject("REQ_ID")) %>
                      		</td>
                    	</tr>
                    	<tr height="1" class="tbl-line"> 
                      		<td height="1"></td>
                      		<td height="1" colspan="3"></td>
                    	</tr>
                    	<tr height="1" class="tbl-line"> 
                      		<td height="1"></td>
                      		<td height="1" colspan="3"></td>
                    	</tr>
                    	
                    </table>
				<!------------------------- TAB�� �ش��ϴ� ���̺�(����̵� ������̵� ��������) ��� �� ------------------------->
               </td>
              </tr>
              <tr>
                <td height="40" align="left" class="soti_reqsubmit">
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td height="40" align="left">&nbsp;<img src="/image/button/bt_prevPage.gif" border="0" onClick="javascript:gotoReqInfoView()" style="cursor:hand">
                        <div align="right"></div></td>
                    </tr>
               </table>
               </td>
              </tr>
            	<!------------------------- �� TAB�� �ΰ� �����ø� ���� �ҽ����� �����ؼ� �� ���� �ٿ��ֱ� �ؼ� �����ϼ��� ------------------------->
            	<!----- [����] TAB <tr> �� �� �ؿ� ������ �����ϴ� <tr>�� �� �����ؼ� �� ì�� �ֽþ��. ������.. -------->
            	<tr> 
                <td height="30" align="left" class="soti_reqsubmit">
                	<!-------------------- TAB �� �ش��ϴ� ������ ����ϴ� ��������. ------------------------>
                	<img src="/image/reqsubmit/icon_reqsubmit_soti.gif" width="9" height="9" align="absmiddle"> 
                  �亯 �ۼ�</td>
              </tr>
              <tr> 
                <td height="203" align="left" valign="top" class="soti_reqsubmit">
                <!------------------------- �亯 �ۼ� ���� �Է� �� ���� ------------------------->
<form name="inputForm" method="post" enctype="multipart/form-data" style="margin:0px">
				<input type="hidden" name="ReqBoxID" value="<%= strReqBoxID %>">
				<input type="hidden" name="ReqID" value="<%= strReqID %>">
				<input type="hidden" name="CommReqID" value="<%= strReqID %>">
				<input type="hidden" name="RegrID" value="<%= objUserInfo.getUserID()  %>">
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

				<input type="hidden" name="returnURL" value="<%= strReturnURL %>">
			
				<% // ���� ��� : ������ �����̾����� �亯�� ��� ������ �ϱ�� �����Ƿ� ���� ó�� %>
				<input type="hidden" name="OpenCL" value="<%= CodeConstants.OPN_CL_OPEN %>">
				<input type="hidden" name="AddAnsFlag" value="<%= strAddAnsFlag %>">
				<input type="hidden" name="UserDN" value="<%= strUserDN %>">
				
				<% // 2004-07-13 ����ȸ���� �ƴ����� ������ �ʿ䰡 �����. %>
				<input type="hidden" name="CmtYn" value="Y">
				
                <table width="680" border="0" cellspacing="0" cellpadding="0">
                    <tr class="td_reqsubmit"> 
                      <td width="120" height="2"></td>
                      <td width="560" height="2"></td>
                    </tr>
                    <tr> 
                      <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        �亯 ����</td>
                      <td height="25" class="td_lmagin"><select name="AnsType" onChange="javascript:changeInputForm(this.value)" class="select">
								<option value="<%= CodeConstants.ANS_MTD_ELEC %>"><%= CodeConstants.getAnswerMethod(CodeConstants.ANS_MTD_ELEC) %></option>
								<option value="<%= CodeConstants.ANS_MTD_ETCS %>"><%= CodeConstants.getAnswerMethod(CodeConstants.ANS_MTD_ETCS) %></option>
								<option value="<%= CodeConstants.ANS_MTD_NONE %>"><%= CodeConstants.getAnswerMethod(CodeConstants.ANS_MTD_NONE) %></option>
							</select>
							</td>
                    </tr>
                    <tr height="1" class="tbl-line"> 
                      <td height="1" colspan="2">
                    </tr>
					<tr>
						<td colspan="2" align="left">
						<!-------------------------------------------- �������� ��ȭ�ϴ� FORM START ---------------------------------------------------->
					  <DIV id="inputDiv" style="position:relative; left:0px;top:0px;width:700; z-index:1; border-width:0px; border-style:none;">
						<table border="0" cellpadding="0" cellspacing="0">
            				<tr> 
								<td width="120" height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
								���� ����</td>
								<td width="560" height="25" class="td_lmagin"><input type="file" class="textfield" name="OriginFile" size="40"></td>
							</tr>
							<tr height="1" class="tbl-line"> 
								<td height="1" colspan="2">
							</tr>
							<tr> 
								<td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
									PDF ����</td>
								<td height="25" class="td_lmagin"><input type="file" class="textfield" name="PdfFile" size="40"></td>
								</tr>
								<tr height="1" class="tbl-line"> 
									<td height="1" colspan="2">
								</tr>
        					</table>
						</DIV>
					<!-------------------------------------------- �������� ��ȭ�ϴ� FORM END ---------------------------------------------------->
						</td>
					</tr>
          			<tr>
           				<td width="120"  height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> ���� �ǰ�</td>
           				<td width="560"  height="25" class="td_lmagin" style="padding-top:5px;padding-bottom:5px"><textarea name="AnsOpin" wrap="hard" class="textfield" style="WIDTH: 90% ; height: 80"></textarea></td>
           			</tr>
           			<tr height="1" class="tbl-line">
           				<td height="1" colspan="2">
           			</tr>
           		</table>
				<p>
               <table width="680" border="0" cellspacing="0" cellpadding="0">
                   <tr> 
                     <td height="40" align="left">
                     	<img src="/image/button/bt_save.gif" border="0" onClick="javascript:checkSubmit()" style="cursor:hand">&nbsp;
                      	<img src="/image/button/bt_cancel.gif" border="0" onClick="javascript:document.inputForm.reset()" style="cursor:hand"> 
                      </td>
                    </tr>
	               </table>
				 </form>
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
<%@ include file="/common/Bottom.jsp" %>

<!-- ���ڹ��� �� ��� Msg Digest�� �����ϰ� ������� �޾Ƽ� String�� ������ �ǰ�, �������� �׳� String���̴ϱ�... -->
<FORM method="post" style="margin:0px" name="returnSubmitForm">
	<input type="hidden" name="ReqBoxID" value="<%= strReqBoxID %>">
	<input type="hidden" name="ReqID" value="<%= strReqID %>">
	<input type="hidden" name="CommReqID" value="<%= strReqID %>">
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

	<% // ���� ��� : ������ �����̾����� �亯�� ��� ������ �ϱ�� �����Ƿ� ���� ó�� %>
	<input type="hidden" name="OpenCL" value="">
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
	
	<% // 2004-07-13 ����ȸ���� �ƴ����� ������ �ʿ䰡 �����. %>
	<input type="hidden" name="CmtYn" value="Y">
</FORM>

<DIV ID="loadingDiv" style="display:none;position:absolute;left:450;top:350">
	<img src="/image/reqsubmit/loading.jpg" border="0"> </td>
</DIV>

</body>
</html>