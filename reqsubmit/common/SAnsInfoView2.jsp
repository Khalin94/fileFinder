<%@ page language="java" contentType="text/html;charset=EUC-KR" %>

<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.lib.reqsubmit.params.answerinfo.SAnsInfoViewForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.answerinfo.AnsInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.MemRequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.MemRequestInfoDelegate" %>


<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>


<%
	UserInfoDelegate objUserInfo = null;
	CDInfoDelegate objCdinfo = null;
%>

<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>

<%
	MemRequestBoxDelegate reqDelegate = null;
	AnsInfoDelegate selfDelegate = null;
	ResultSetSingleHelper objInfoRsSH=null;
	MemRequestInfoDelegate  objReqInfo=null;

	SAnsInfoViewForm objParams = new SAnsInfoViewForm();

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
	String strReqBoxID = null;
	String strReqID = null;
	String strAnsID = request.getParameter("AnsID");
	String Ansr_id = request.getParameter("AnsrID");
	String ANSW_PERM_CD = request.getParameter("AnswPermCD");
	String strAnsSEQ = request.getParameter("AnsSEQ")==null?"":request.getParameter("AnsSEQ");
	//��������� �׽�Ʈ
  String strOpenCL = request.getParameter("ReqOpenCL");
  System.out.println("kangthis logs SAnsInfoView2.jsp(strOpenCL) => " + strOpenCL);

    System.out.println("strAnsID"+strAnsID);
    System.out.println("Ansr_id"+Ansr_id);
    System.out.println("ANSW_PERM_CD"+ANSW_PERM_CD);

	String strReturnURL = objParams.getParamValue("ReturnURL");

	ResultSetSingleHelper objRsSH = null;

	// �亯 ������ ���� ����ؾ��ϴ� �׸���� �޶�����.
	String strAnsMtd = null;
	String strAnsStt = null;
	String reqnm = null;
	String submtnm = null;
	String strPdfFileName = null;
	String strOrgFileName = null;

	try{
		reqDelegate = new MemRequestBoxDelegate();
		objReqInfo=new MemRequestInfoDelegate();
	   	selfDelegate = new AnsInfoDelegate();

    	objRsSH = new ResultSetSingleHelper(selfDelegate.getRecord(strAnsID));
    	strAnsMtd = (String)objRsSH.getObject("ANS_MTD");
    	strAnsStt = (String)objRsSH.getObject("SUBMT_FLAG");
    	strReqBoxID = (String)objRsSH.getObject("REQ_BOX_ID");
    	strReqID = (String)objRsSH.getObject("REQ_ID");
		strPdfFileName = (String)objRsSH.getObject("PDF_FILE_NAME");
		strOrgFileName = (String)objRsSH.getObject("ORG_FILE_NAME");


		objInfoRsSH=new ResultSetSingleHelper(objReqInfo.getRecord2(strReqID));
		reqnm = (String)objInfoRsSH.getObject("REQ_CONT");
		submtnm = (String)objInfoRsSH.getObject("SUBMT_ORGAN_NM");

	} catch(AppException e) {
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  		objMsgBean.setStrCode(e.getStrErrCode());
  		objMsgBean.setStrMsg(e.getMessage());
  		out.println("<br>Error!!!" + e.getMessage());
	  	return;
 	}

	String UserID = objUserInfo.getUserID();
%>


<jsp:include page="/inc/header.jsp" flush="true"/>
<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>

<script language="javascript">

	var strAnsID = '<%= strAnsID %>';	// �亯���̵�
	var Ansr_id = '<%= Ansr_id %>';	// �亯�ھ��̵�
//	var ANSW_INQ_YN = '<%//=ANSW_INQ_YN %>';	// �亯��������
	var ANSW_PERM_CD = '<%=ANSW_PERM_CD %>';	// �亯���λ���

	// �亯 ���� : �����ڷ�����ý��۱�ɰ������_2011
	function submitDelete() {

		// �亯�� üũ
		var UserID = '<%= UserID %>';
		if(UserID != Ansr_id){
			alert("�亯�� ���θ� �亯�� ������ �� �ֽ��ϴ�.");
			return;
		}

		// ��û�ڰ� �亯�� �����ߴ��� ���� ��ȸ
//		if(ANSW_INQ_YN == 'Y'){	// ������
		if(ANSW_PERM_CD == '222'){	// �亯���ν�
			// �亯 ���� ���� ���
			alert("�ش� �亯�� ��û�ڰ� �����Ͽ� ������ �� �����ϴ�.");
		}else{	// �̿�����
			// �亯 ���� ����
			var f = document.viewForm;
			f.AnsID2.value = strAnsID;
			f.target = "";
			f.action = "/reqsubmit/common/SAnsInfoDelProc2.jsp";
			if (confirm("�ش� �亯�� �����Ͻðڽ��ϱ�?\n�ش� �亯�� �����ϸ� ���Ե� ���ϵ鵵 �ϰ� �����˴ϴ�.")) f.submit();
		}

	}

	// �亯 ���� : �����ڷ�����ý��۱�ɰ������_2011
	function gotoEditForm() {

		// �亯�� üũ
		var UserID = '<%= UserID %>';
		if(UserID != Ansr_id){
			alert("�亯�� ���θ� �亯�� ������ �� �ֽ��ϴ�.");
			return;
		}

		// ��û�ڰ� �亯�� �����ߴ��� ���� ��ȸ
//		if(ANSW_INQ_YN == 'Y'){	// ������
		if(ANSW_PERM_CD == '222'){	// �亯���ν�
			// �亯 ���� ���� ���
			alert("�ش� �亯�� ��û�ڰ� �����Ͽ� ������ �� �����ϴ�.");
		}else{	// �̿�����
			// �亯 ���� ����
			// ���������� ����
			var f = document.viewForm;
			f.target = "popwin";
			f.action = "/reqsubmit/common/SAnsInfoEdit.jsp";
			f.submit();
		}
	}

	function viewFile(strAnsID, strType) {
		if (strType == "PDF") {
			location.href = "/reqsubmit/common/ReqFileOpen2.jsp?paramAnsId="+strAnsID+"&DOC="+strType+"&REQNM=<%=reqnm%>&REQSEQ=<%=strAnsSEQ%>&SubmtOrganNm=<%=submtnm%>";			
		} else {
			location.href = "/reqsubmit/common/ReqFileOpen2.jsp?paramAnsId="+strAnsID+"&DOC="+strType+"&REQNM=<%=reqnm%>&REQSEQ=<%=strAnsSEQ%>&SubmtOrganNm=<%=submtnm%>";
		}
	}

</script>
</head>

<body>
<div class="popup">
    <p>�亯�󼼺���</p>

    <table width="100%" cellpadding="0" cellspacing="0">
        <tr>
            <td width="100%" style="padding:10px;">  <!-- list -->
        <!-- <span class="list01_tl">�䱸 ��� <span class="list_total">&bull;&nbsp;��ü�ڷ�� : 2�� </span></span> -->

<FORM method="post" action="" name="viewForm" style="margin:0px">

		<input type="hidden" name="ReqBoxID" value="<%= strReqBoxID %>">
		<input type="hidden" name="ReqID" value="<%= strReqID %>">
		<input type="hidden" name="AnsID" value="<%= strAnsID %>">
		<input type="hidden" name="WinType" value="POPUP" %>
		<input type="hidden" name="ReturnURL" value="<%= strReturnURL %>">
		<input type="hidden" name="ReqOpenCL" value="<%= strOpenCL %>">

		<!-- �亯 ������ ���� Parameter ���� -->
		<input type="hidden" name="AnsID2" value="">


        <table border="0" cellspacing="0" cellpadding="0" class="list02">
            <tbody>
                <tr>
                    <th height="25">&bull;&nbsp;&nbsp;�亯���� </th>
                    <td>
						<%if(strAnsMtd.equals("004")){%>
						�������� ����
						<%}else{%>
						<%= CodeConstants.getAnswerMethod(strAnsMtd) %>
						<%}%>
					</td>
                </tr>
                <tr>
                    <th height="25">&bull;&nbsp;&nbsp;���� ���� </th>
                    <td>
						<% if ("Y".equalsIgnoreCase(strAnsStt)) out.println("����Ϸ�"); else out.println("������"); %>
					</td>
                </tr>
<%
	if (CodeConstants.ANS_MTD_ELEC.equalsIgnoreCase(strAnsMtd)) { // �亯 ������ ���ڹ������
%>
                <tr>
                    <th height="25">&bull;&nbsp;&nbsp;�������� </th>
                    <td><a href="javascript:viewFile('<%= strAnsID %>', 'PDF');"><img border="0" src="/images2/common/icon_pdf.gif" /> [PDF ����] <%= strPdfFileName %></a></td>
                </tr>
                <tr>
                    <th height="25">&bull;&nbsp;&nbsp;�������� </th>
                    <td><a href="javascript:viewFile('<%= strAnsID %>', 'DOC');"><img border="0" src="/images2/common/icon_file.gif" /> [��������] <%= strOrgFileName %></a></td>
                </tr>
<%
	} else if (CodeConstants.ANS_MTD_ETCS.equalsIgnoreCase(strAnsMtd)){
%>

                <tr>
                    <th height="25">&bull;&nbsp;&nbsp;��ü���� </th>
                    <td>
						<%= objCdinfo.getNotElecMedium((String)objRsSH.getObject("NON_ELC_DOC_MED")) %>
					</td>
                </tr>
                <tr>
                    <th height="25">&bull;&nbsp;&nbsp;�߼� ��� </th>
                    <td>
						<%= StringUtil.getEmptyIfNull((String)objCdinfo.getSendWay((String)objRsSH.getObject("NON_ELC_DOC_SUBMT_MTD"))) %>
					</td>
                </tr>
<% } %>
                <tr>
                    <th height="25">&bull;&nbsp;&nbsp;������ </th>
                    <td><%= objRsSH.getObject("USER_NM") %></td>
                </tr>
                <tr>
                    <th height="25">&bull;&nbsp;&nbsp;������ </th>
                    <td><%= StringUtil.getDate2((String)objRsSH.getObject("ANS_DT")) %></td>
                </tr>
                <tr>
                    <th height="25" width="100">&bull;&nbsp;&nbsp;���� �ǰ� </th>
                    <td width="340"><%= objRsSH.getObject("ANS_OPIN") %></td>
                </tr>
            </tbody>
        </table>        <!-- /list -->



       </td>
        </tr>
    </table>
    <p style= "height:2px;padding:0;"></p>
    <!-- ����Ʈ ��ư-->
    <div id="btn_all"  class="t_right">
		<%// if (!"Y".equalsIgnoreCase(strAnsStt)) { %>
		<%// if ("N".equals(ANSW_INQ_YN)) { // ������%>
		<% if ("111".equals(ANSW_PERM_CD)) { // �亯�̽��ν�%>
		<span class="list_bt"><a href="#" onClick="javascript:gotoEditForm()">����</a></span>&nbsp;&nbsp;
		<span class="list_bt"><a href="#" onClick="javascript:submitDelete()">����</a></span>&nbsp;&nbsp;
		<span class="list_bt"><a href="#" onClick="javascript:window.close()">â�ݱ�</a></span>&nbsp;&nbsp;
		<% } else { %>
		<span class="list_bt"><a href="#" onClick="javascript:window.close()">Ȯ��</a></span>&nbsp;&nbsp;
		<% } %>
	</div>
</form>
    <!-- /����Ʈ ��ư-->
</div>
</body>
</html>
