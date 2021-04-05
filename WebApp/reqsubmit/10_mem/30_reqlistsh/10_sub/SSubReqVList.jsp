<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.bf.config.*"%>
<%@ page import="kr.co.kcc.pf.util.PageCount"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.params.requestinfo.SMemReqInfoViewForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.SMemReqInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.answerinfo.AnsInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.SMemReqBoxDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	UserInfoDelegate objUserInfo =null;
 	CDInfoDelegate objCdinfo =null;
%>

<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>

<%
	SMemReqInfoViewForm objParams = new SMemReqInfoViewForm();
	SMemReqInfoDelegate objReqInfo = new SMemReqInfoDelegate();
	AnsInfoDelegate objAnsInfo = new AnsInfoDelegate();
	SMemReqBoxDelegate sReqDelegate = new SMemReqBoxDelegate();

  	boolean blnParamCheck = false;
  	blnParamCheck = objParams.validateParams(request);
  	if(blnParamCheck == false){
  		System.out.println("Param Check Error ");
  		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  		objMsgBean.setStrCode("DSPARAM-0000");
  		objMsgBean.setStrMsg(objParams.getStrErrors());
%>
  		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
  		return;
  	}

	String strReqID = (String)objParams.getParamValue("ReqID");

	// 2004-06-04
	String strAuditYear = (String)objParams.getParamValue("strAuditYear");
	String strReqBoxID = (String)objParams.getParamValue("ReqBoxID");
	String strReqOrganID = (String)objParams.getParamValue("ReqOrganID");

 	ResultSetSingleHelper objInfoRsSH = null;	/**�䱸 ���� �󼼺��� */
 	ResultSetHelper objRs = null;				/** �亯���� ��� ���*/

 	try{
  		objInfoRsSH = new ResultSetSingleHelper(objReqInfo.getRecord2((String)objParams.getParamValue("ReqID")));
   		objRs = new ResultSetHelper(objAnsInfo.getRecordList(strReqID));
	} catch(AppException objAppEx) {
		System.out.println("AppException : "+objAppEx.getMessage());
  		objAppEx.printStackTrace();
 		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  		objMsgBean.setStrCode(objAppEx.getStrErrCode());
  		objMsgBean.setStrMsg(objAppEx.getMessage());
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
  		return;
	}

	String UserID = objUserInfo.getUserID();
	String ANSW_PERM_CD = (String)objInfoRsSH.getObject("ANSW_PERM_CD");
%>
<jsp:include page="/inc/header.jsp" flush="true"/>
<script language="javascript">
	var f;
	var ANSW_PERM_CD = '<%=ANSW_PERM_CD %>';

	// ���� �Ϸ�
	function sbmtReq() {
		f = document.formName;
		f.target = "";
		f.action = "/reqsubmit/10_mem/20_reqboxsh/10_make/SMakeReqSubmtDoneProc.jsp";
		if (confirm("���� �䱸�� ���� �亯 ������ �Ϸ��Ͻðڽ��ϱ�?")) f.submit();
	}

  	// �亯 �󼼺���� ����
  	function gotoDetail(AnID,AnsrID,AnswPermCD,strSeq){
        f = document.formName;
        f.target = "popwin";
		f.AnsSEQ.value = strSeq;
        f.action="/reqsubmit/common/SAnsInfoView2.jsp?AnsrID="+AnsrID+"&AnsID="+AnID+"&AnswPermCD="+AnswPermCD;
        NewWindow('/blank.html', 'popwin', '618', '590');
        f.submit();
          //var add_sub = window.showModalDialog('SMakeAnsInfoView.jsp?returnURL=POPUP&ReqBoxID=<%= strReqBoxID %>&ReqID=<%= strReqID %>&AnsID='+strID, '', 'dialogWidth:500px;dialogHeight:300px; center:yes; help:no; status:no; scroll:no; resizable:yes');
          //window.open('/reqsubmit/common/SAnsInfoView.jsp?returnURL=POPUP&ReqBoxID=<%= strReqBoxID %>&ReqID=<%= strReqID %>&AnsID='+strID, '', 'width=500,height=400, scrollbars=no, resizable=yes, toolbar=no, menubar=no, location=no, directories=no, status=no');
      }

  	/** ������� ���� */
  	function gotoList(){
  		formName.action="SSubReqList.jsp";
	  	formName.target = "";
  		formName.submit();
	}

	// �߰� �亯 �ۼ� ȭ������ �̵�
  	function goSbmtReqForm() {

		/*if(ANSW_PERM_CD == '222'){	// �亯 ���ν�

			// �߰��亯��� ���
			alert("�ش� �䱸�� ���� �亯�� �䱸�ڰ� �����Ͽ� �߰��亯�� ����� �� �����ϴ�.");

		}else{		// �亯 �̽��ν�*/

			f = document.formName;
			f.target = "newpopup";
			f.action = "/reqsubmit/common/SAnsInfoWrite.jsp";
			var winl = (screen.width - 600) / 2;
			var winh = (screen.height - 600) / 2;
			window.open("/blank.html","newpopup","resizable=no,menubar=no,status=no,titlebar=no, scrollbars=no,location=no,toolbar=no,height=600,width=595, left="+winl+", top="+winh);
			f.submit();

		//}

  	}
	// �߰� �亯 �ۼ� ȭ������ �̵�
  	function goSbmtReqForm_old() {

		/*if(ANSW_PERM_CD == '222'){	// �亯 ���ν�

			// �߰��亯��� ���
			alert("�ش� �䱸�� ���� �亯�� �䱸�ڰ� �����Ͽ� �߰��亯�� ����� �� �����ϴ�.");

		}else{		// �亯 �̽��ν�*/

			f = document.formName;
			f.target = "newpopup";
			f.action = "/reqsubmit/common/SAnsInfoWrite_old.jsp";
			var winl = (screen.width - 550) / 2;
			var winh = (screen.height - 350) / 2;
			window.open("/blank.html","newpopup","resizable=yes,menubar=no,status=no,titlebar=no,	scrollbars=yes,location=no,toolbar=no,height=350,width=520, left="+winl+", top="+winh);
			f.submit();
		//}

  	}
	// �亯���� : �����ڷ�����ý��۱�ɰ������_2011
	function gotoEditForm() {

		// üũ�ڽ� ���� üũ
		var f = document.formName;
		if (getCheckCount(f, "AnsID") != 1) {
  			alert("�ϳ��� üũ�ڽ��� ������ �ּ���");
  			return;
  		}

		// üũ�ڽ� �� ����(�亯���̵�-�亯�ھ��̵�-�亯��������)
		var obj = f.AnsID;
		var strID = "";	// üũ�� �亯���̵�
		var Ansr_id = "";	// üũ�� �亯�ھ��̵�
		var ANSW_INQ_YN = f.AnswInqYn.value; // �䱸�� �亯 ���� ���� FLAG

		if(obj.length==undefined){	// �亯 ����� 1���� �� üũ���� ���
			strID = obj.value;
			var arr = new Array();
			arr = strID.split("$$");
			strID = arr[0];
			Ansr_id = arr[1];
			ANSW_INQ_YN = arr[2];
		}else{		// �亯 ����� 1���̻��� �� üũ���� ���
			for(i=0; i<obj.length; i++){
				if(obj[i].checked){
					strID = obj[i].value;
					var arr = new Array();
					arr = strID.split("$$");
					strID = arr[0];
					Ansr_id = arr[1];
					ANSW_INQ_YN = arr[2];
				}
			}
		}

		// �亯�� üũ
		var UserID = '<%= UserID %>';
		if(UserID != Ansr_id){
			alert("�亯�� ���θ� �亯�� ������ �� �ֽ��ϴ�.");
			return;
		}

		// ��û�ڰ� �亯�� �����ߴ��� ���� ��ȸ
//		if(ANSW_INQ_YN == 'Y'){	// ������
		if(ANSW_PERM_CD == '222' && (ANSW_INQ_YN == 'Y')){	// �亯 ���ν�
			// �亯 ���� ���� ���
//			alert("�ش� �亯�� ��û�ڰ� �����Ͽ� ������ �� �����ϴ�.");
			alert("�ش� �䱸�� ���� �亯�� �䱸�ڰ� �����Ͽ� �亯�� ������ �� �����ϴ�.");
		}else{	// �̿�����
			// �亯 ���� ����
			// ���������� ����
			var f2 = document.viewForm2;
			f2.ReqOpenCL.value = f.ReqOpenCL.value;
			f2.target = "popwin";
			f2.action="/reqsubmit/common/SAnsInfoEdit_old.jsp?AnsID="+strID;
			//f2.action="/reqsubmit/common/SAnsInfoEdit.jsp?AnsID="+strID;
			NewWindow('/blank.html', 'popwin', '520', '380');
			f2.submit();
		}

	}

  	// ���û��� : �����ڷ�����ý��۱�ɰ������_2011
  	function selectDelete() {

  		// üũ�ڽ� ���� üũ
		var f = document.formName;
  		if (getCheckCount(f, "AnsID") < 1) {
  			alert("�ϳ� �̻��� üũ�ڽ��� ������ �ּ���");
  			return;
  		}

		// üũ�ڽ� �� ����(�亯���̵�-�亯�ھ��̵�-�亯��������)
		var obj = f.AnsID;
		var strID = "";	// üũ�� �亯���̵�
		var Ansr_id = "";	// üũ�� �亯�ھ��̵�
		var ANSW_INQ_YN = f.AnswInqYn.value; // �䱸�� �亯 ���� ���� FLAG

		var AnsID = new Array(); // �亯���̵� �迭
		var ArrAnsr_id = new Array(); // �亯�ھ��̵� �迭

		if(obj.length==undefined){	// �亯 ����� 1���� �� üũ���� ���
			strID = obj.value;
			var arr = new Array();
			arr = strID.split("$$");
			strID = arr[0];
			Ansr_id = arr[1];
			ANSW_INQ_YN = arr[2];
			f.AnsID.value = strID;	// �Ķ���Ϳ� �亯���̵� �缳��
		}else{		// �亯 ����� 1���̻��� �� üũ���� ���
			var j=0;
			var k=0;
			var paraID = "";	// �Ķ���Ϳ� �亯���̵�
			for(i=0; i<obj.length; i++){
				if(obj[i].checked){
					strID = obj[i].value;
					var arr = new Array();
					arr = strID.split("$$");
					strID = arr[0];
					Ansr_id = arr[1];
					ANSW_INQ_YN = arr[2];

					AnsID[j] = strID;
					j++;

					ArrAnsr_id[k] = Ansr_id;
					k++;

					// ��û�ڰ� �亯�� �����ߴ��� ���� ��ȸ
//					if(ANSW_INQ_YN == 'Y'){	// ������
					if(ANSW_PERM_CD == '222' && (ANSW_INQ_YN == 'Y')){	// �亯 ���ν�
						// �亯 ���� ���� ���
//						alert("�����Ͻ� �亯 �߿� ��û�ڰ� ������ �亯�� �ֽ��ϴ�.\nȮ�� �� �̿����� �亯�� ������ �ֽñ� �ٶ��ϴ�.");
						alert("�ش� �䱸�� ���� �亯�� �䱸�ڰ� �����Ͽ� �亯�� ������ �� �����ϴ�.");
						return;
					}
				}
			}
			for(l=0; l<AnsID.length; l++){
				if(l == AnsID.length-1){
					paraID = paraID + AnsID[l];
				}else{
					paraID = paraID + AnsID[l] + ",";
				}
			}
			f.AnsID.value = paraID;	// �Ķ���Ϳ� �亯���̵� �缳��
		}

		// �亯�� üũ
		var UserID = '<%= UserID %>';
		for(m=0; m<ArrAnsr_id.length; m++){
			if(UserID != ArrAnsr_id[m]){
				alert("�α��� ����ڿ� �亯�ڰ� �ٸ� �亯�� �����մϴ�.\nȮ�� �� ������ �ۼ��� �亯�� ������ �ֽñ� �ٶ��ϴ�.");
				return;
			}
		}


		// �亯 ���� ����
		f.action = "/reqsubmit/common/SAnsInfoDelProc3.jsp";
		f.target = "";
		if (confirm("�����Ͻ� �亯���� �����Ͻðڽ��ϱ�?\n�ش� �亯���� �����ϸ� ���Ե� ���ϵ鵵 �ϰ� �����˴ϴ�.")) f.submit();

  	}

	// �亯��Ͽ��� �亯 ���� : �����ڷ�����ý��۱�ɰ������_2011
	function delAnsDoc(AnsID,Ansr_id,ANSW_INQ_YN) {	// AnsID : �亯���̵�, Ansr_id : �亯�ھ��̵�, ANSW_INQ_YN : �䱸�� �亯�������� FLAG

		// �亯�� üũ
		var UserID = '<%= UserID %>';
		if(UserID != Ansr_id){
			alert("�亯�� ���θ� �亯�� ������ �� �ֽ��ϴ�.");
			return;
		}

		// ��û�ڰ� �亯�� �����ߴ��� ���� ��ȸ
//		if(ANSW_INQ_YN == 'Y'){	// ������
		if(ANSW_PERM_CD == '222' && (ANSW_INQ_YN == 'Y')){	// �亯 ���ν�
			// �亯 ���� ���� ���
//			alert("�ش� �亯�� ��û�ڰ� �����Ͽ� ������ �� �����ϴ�.");
			alert("�ش� �䱸�� ���� �亯�� �䱸�ڰ� �����Ͽ� �亯�� ������ �� �����ϴ�.");
		}else{	// �̿�����
			// �亯 ���� ����
			var f = document.formName;
			f.AnsID2.value = AnsID;
			f.target = "";
			f.action = "/reqsubmit/common/SAnsInfoDelProc2.jsp";
			if (confirm("�ش� �亯�� �����Ͻðڽ��ϱ�?\n�ش� �亯�� �����ϸ� ���Ե� ���ϵ鵵 �ϰ� �����˴ϴ�.")) f.submit();
		}

	}

	// �亯�� �߼�
	function sendAnsDoc() {
		var f = document.formName;
		var AnswPermCD = f.AnswPermCD.value;
		f.action = "/reqsubmit/common/AnsDocSend.jsp?ReqBoxID=<%= strReqBoxID %>";
		//f.ReturnURL.value = "/reqsubmit/10_mem/30_reqlistsh/10_sub/SSubReqList.jsp?ReqBoxID=<%= strReqBoxID %>";
		f.ReturnURL.value = "/reqsubmit/10_mem/20_reqboxsh/30_makeend/SMakeEndBoxList.jsp?ReqBoxID=<%= strReqBoxID %>";
		f.target = "popwin";
		NewWindow('/blank.html', 'popwin', '470', '300');
		f.submit();
	}
 
	// �ڵ� �亯�� �߼� Ȯ��
	function checkSendAnsDoc() {
		if(confirm("��� �䱸�� ���� �亯�� ����ϼ̽��ϴ�. �亯�� �߼��� �����Ͻðڽ��ϱ�?")) sendAnsDoc();
	}

</script>
<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>
</head>

<body
<%
	int intNotSubmitReqCnt = sReqDelegate.getReqCntNotSubmit1(strReqBoxID);	
	System.out.println("kangthis logs SSubReqVList.jsp intNotSubmitReqCnt => " + intNotSubmitReqCnt);	

	if(intNotSubmitReqCnt > 0) {
		out.println(" onLoad='javascript:checkSendAnsDoc()'");
	}
%>
>
<div id="wrap">
  <jsp:include page="/inc/top.jsp" flush="true"/>
  <jsp:include page="/inc/top_menu02.jsp" flush="true"/>
  <div id="container">
    <div id="leftCon">
      <jsp:include page="/inc/log_info.jsp" flush="true"/>
      <jsp:include page="/inc/left_menu02.jsp" flush="true"/>
    </div>
    <div id="rightCon">
<form name="formName" method="post" action="<%=request.getRequestURI()%>"><!--�䱸�� �ű����� ���� -->
			<%
			//�䱸 ���� ���� ���� �ޱ�.
			String strReqInfoSortField=objParams.getParamValue("ReqInfoSortField");
			String strReqInfoSortMtd=objParams.getParamValue("ReqInfoSortMtd");
			//�䱸 ���� ������ ��ȣ �ޱ�.
			String strReqInfoPagNum=objParams.getParamValue("ReqInfoPage");
		    %>
		    <input type="hidden" name="ReqBoxID" value="<%= objInfoRsSH.getObject("REQ_BOX_ID") %>">
		    <input type="hidden" name="ReqID" value="<%= strReqID %>">

		    <!-- 2004-06-04 �䱸���ID �� ����⵵ �Ķ���� ���� -->
		    <input type="hidden" name="ReqOrganID" value="<%= strReqOrganID %>">
		    <input type="hidden" name="AuditYear" value="<%= strAuditYear %>">

			<input type="hidden" name="ReqInfoSortField" value="<%=objParams.getParamValue("ReqInfoSortField")%>"><!--�䱸���� ��������ʵ� -->
			<input type="hidden" name="ReqInfoSortMtd" value="<%=objParams.getParamValue("ReqInfoSortMtd")%>"><!--�䱸���� ������ɹ��-->
			<input type="hidden" name="ReqInfoQryField" value="<%=objParams.getParamValue("ReqInfoQryField")%>"><!--�䱸���� ��ȸ �ʵ�-->
			<input type="hidden" name="ReqInfoQryTerm" value="<%=objParams.getParamValue("ReqInfoQryTerm")%>"><!--�䱸���� ��ȸ��-->
			<input type="hidden" name="ReqInfoPage" value="<%=objParams.getParamValue("ReqInfoPage")%>"><!--�䱸���� ������ ��ȣ -->
			<input type="hidden" name="ReqInfoID" value="<%=objParams.getParamValue("ReqID")%>"><!--�䱸���� ID-->
			<input type="hidden" name="ReqOpenCL" value="<%= objInfoRsSH.getObject("OPEN_CL") %>">

			<input type="hidden" name="AnsInfoID" value=""><!--�亯����ID -->
			<input type="hidden" name="AnsID" value=""><!--�亯����ID -->
			<input type="hidden" name="AnsSEQ" value="">
			<input type="hidden" name="WinType" value="SELF">
			<input type="hidden" name="ReturnURL" value="<%= request.getRequestURI() %>?ReqBoxID=<%= objInfoRsSH.getObject("REQ_BOX_ID") %>&ReqID=<%= strReqID %>">
			<input type="hidden" name="AddAnsFlag" value="Y">

			<!-- ���� �亯 ������ ���� Parameter ���� -->
			<input type="hidden" name="AnsID2" value="">
			<input type="hidden" name="AnswPermCD" value="<%=ANSW_PERM_CD%>">
      <!-- pgTit -->
      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=MenuConstants.REQ_INFO_LIST_SUBMT_DONE%><span class="sub_stl" >- <%=MenuConstants.REQ_INFO_DETAIL_VIEW%></span></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> > <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.getReqBoxGeneral(request)%> > <%=MenuConstants.REQ_INFO_LIST_SUBMT_DONE%></div>
        <p><!--����--></p>
      </div>
      <!-- /pgTit -->

      <!-- contents -->

      <div id="contents">
        <!-- �˻����� ���� ��� �Ʒ� div ���� �� �ּ����� ��������.-->
        <!-- /�˻�����-->
        <!-- �������� ���� -->
         <!-- list view-->
        <span class="list02_tl">�䱸 ���� </span>
        <div class="top_btn"><samp>
			 <span class="btn"><a href="javascript:viewReqHistory('<%= strReqID %>')">�䱸 �̷� ����</a></span>
			 <span class="btn"><a href="javascript:gotoList()">�䱸���</a></span>
		</samp></div>

        <table border="0" cellspacing="0" cellpadding="0" width="680" class="list02">

            <tr>
                <th height="25">&bull; �䱸���� </th>
                <td height="25" colspan="3"><strong><%=StringUtil.getDescString((String)objInfoRsSH.getObject("REQ_CONT"))%></strong></td>
            </tr>
            <tr>
                <th height="25">&bull; �䱸���� </th>
                <td height="25" colspan="3">- <%=StringUtil.getDescString((String)objInfoRsSH.getObject("REQ_DTL_CONT"))%> </td>
            </tr>
            <tr>
                <th height="25">&bull; �䱸�Ը� </th>
                <td height="25" colspan="3"><%=objInfoRsSH.getObject("REQ_BOX_NM")%> </td>
            </tr>
            <tr>
                <th height="25" width="18%">&bull; �䱸��� </th>
                <td height="25" width="32%"><%=(String)objInfoRsSH.getObject("REQ_ORGAN_NM")%> (<%=(String)objInfoRsSH.getObject("USER_NM")%>) </td>
                <th height="25" width="18%">&bull;&nbsp;������ </th>
                <td height="25" width="32%"><%=(String)objInfoRsSH.getObject("SUBMT_ORGAN_NM")%> </td>
            </tr>
            <tr>
                <th height="25">&bull; ������� </th>
                <td height="25">
				<%= CodeConstants.getOpenClass((String)objInfoRsSH.getObject("OPEN_CL")) %>
				</td>
                <th height="25">&bull;&nbsp;÷������</th>
                <td height="25"><%=StringUtil.makeAttachedFileLink((String)objInfoRsSH.getObject("ANS_ESTYLE_FILE_PATH"),(String)objInfoRsSH.getObject("REQ_ID"))%></td>
            </tr>
            <tr>
                <th height="25">&bull; �䱸�Ͻ�</th>
                <td height="25"><%= StringUtil.getDate2((String)objInfoRsSH.getObject("LAST_REQ_DT")) %> </td>
                <th height="25">&bull;&nbsp;�亯�Ͻ� </th>
                <td height="25"><%= StringUtil.getDate2((String)objInfoRsSH.getObject("LAST_ANS_DT"))%> </td>
            </tr>
            <tr>
                <th height="25">&bull; �亯 ���λ��� </th>
                <td height="25"><%= CodeConstants.getAnsApprStt(ANSW_PERM_CD) %></td>
                <th height="25">&nbsp;</th>
                <td height="25">&nbsp;</td>
            </tr>
        </table>
        <!-- /list view -->
        <!--<p class="warning mt10">* �䱸�� �߼� : �ǿ���(�Ǵ� �Ҽӱ��) ���Ƿ� �ش� �������� �䱸���� �߼��մϴ�.</p>  -->
		    <p class="warning mt10">* �߰��亯 ��Ͻÿ��� �ݵ�� �亯���߼��� �����ؾ� �亯�Ϸᰡ �˴ϴ�.<br> * �亯�� �߼��� ���Ͽ� F5�� ������ �亯�� �߼��� �����ϼ���.</p>
        <!-- ����Ʈ ��ư-->
         <div id="btn_all"><div  class="t_right">
		 </div></div>

        <!-- /����Ʈ ��ư-->

        <!-- list -->
        <span class="list01_tl">�亯��� <span class="list_total">&bull;&nbsp;��ü�ڷ�� : <%= objRs.getRecordSize() %>�� </span></span>
        <table>
			<tr>
				<td>&nbsp;</td>
			</tr>
		</table>
        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
          <thead>
            <tr>

              <th scope="col"><input name="" type="checkbox" value="" class="borderNo" onClick="javascript:revCheck(this.form, 'AnsID')"/></th>
              <th scope="col" style="width:40%; "><a>�����ǰ�</a></th>
              <th scope="col"><a>�ۼ���</a></th>
              <th scope="col"><a>����</a></th>
              <th scope="col"><a>�亯</a></th>
			  <th scope="col">&nbsp;</th>
              <th scope="col"><a>�亯����</a></th>
            </tr>
          </thead>
          <tbody>
			<%
				int intRecordNumber=1;
				String strAnsInfoID="";
				if (objRs.getRecordSize() > 0) {
					while(objRs.next()) {
						strAnsInfoID=(String)objRs.getObject("ANS_ID");
                    String testkey = objRs.getObject("ANS_ID")+"$$"+objRs.getObject("ANSR_ID")+"$$"+objRs.getObject("ANSW_INQ_YN");
                    String testkey2 = objRs.getObject("ANS_ID")+"$$"+objRs.getObject("ANSR_ID")+"$$"+ANSW_PERM_CD;
			 %>
            <tr>
              <td>
				<input type="checkbox" name="AnsID" value="<%=testkey%>"><%//=intRecordNumber%>
				<input name="AnswInqYn" type="hidden" value="<%= (String)objRs.getObject("ANSW_INQ_YN") %>" >
			  </td>
              <td style="text-align:left;"><a href="JavaScript:gotoDetail('<%=objRs.getObject("ANS_ID")%>','<%=objRs.getObject("ANSR_ID")%>','<%=ANSW_PERM_CD%>','<%=intRecordNumber%>');"><%=StringUtil.substring((String)objRs.getObject("ANS_OPIN"),35)%></a></td>
              <td><%=(String)objRs.getObject("USER_NM")%></td>
              <td><%=CodeConstants.getOpenClass(((String)objRs.getObject("OPEN_CL")))%></td>
              <td><%=this.makeAnsInfoHtml2((String)objRs.getObject("ANS_ID"), (String)objRs.getObject("ANS_MTD"),(String)objInfoRsSH.getObject("REQ_CONT"),intRecordNumber+"",(String)objInfoRsSH.getObject("SUBMT_ORGAN_NM")) %></td>
			  <td><span class="list_bt"><a href="javascript:delAnsDoc('<%= objRs.getObject("ANS_ID") %>','<%= objRs.getObject("ANSR_ID") %>','<%= objRs.getObject("ANSW_INQ_YN") %>');">����</a></span></td>
              <td><%=StringUtil.getDate2((String)objRs.getObject("ANS_DT"))%></td>

            </tr>
			<%
						intRecordNumber ++;
					} // endwhile
				} else {
			%>
            <tr>
				<td colspan="6" align="center"> ��ϵ� �亯�� �����ϴ�.</td>
            </tr>
			<%
				}
//�߰� �亯 ���			%>

          </tbody>
        </table>
		<!-- ����Ϸ� ���¶� �ϴ��� ��ư�� �ϴ� ��� �����ְ�, ��ư Ŭ���� �ش� �亯�� ���� �䱸���� �亯 ���� ���θ� üũ�Ͽ� �׼��� ���� �� �����Ѵ�. -->
		<%
			//if(CodeConstants.REQ_STT_ADD.equals((String)objInfoRsSH.getObject("REQ_STT"))) {
		%>
         <div id="btn_all"class="t_right">
			 <span class="list_bt"><a href="javascript:goSbmtReqForm_old()" onfocus="this.blur()">�߰��亯���</a></span>
			 <span class="list_bt"><a href="javascript:goSbmtReqForm()">��뷮���ϵ��</a></span>
			 <span class="list_bt"><a href="javascript:gotoEditForm()">�亯����</a></span>
    		 <!--span class="list_bt"><a href="javascript:selectDelete()">���û���</a></span-->
		 </div>
		<%
			//}
		%>

        <!-- /list -->


        <!-- /�������� ���� -->
      </div>
</form>

<form name="viewForm2" method="post" action="" style="margin:0px">
                    <!-- �亯 ������ ���� Parameter ���� -->
					<input type="hidden" name="ReqBoxID" value="<%= strReqBoxID %>">
					<input type="hidden" name="ReqID" value="<%= strReqID %>">
					<input type="hidden" name="AnsID">
					<input type="hidden" name="WinType" value="POPUP" %>
					<input type="hidden" name="ReturnURL" value="<%= request.getRequestURI() %>?ReqBoxID=<%= strReqBoxID %>&ReqID=<%= strReqID %>">
					<input type="hidden" name="ReqOpenCL" value="">
</form>
      <!-- /contents -->

    </div>
  </div>
  <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>

<%!
	public static String makeAnsInfoHtml2(String strAnsID,String strAnsMtd,String strReqCont,String strSeq,String strSubmt){

		StringBuffer strBufReturn=new StringBuffer();

		strBufReturn.append("<table width=\"100%\" border=\"0\"><tr>");

		if(strAnsMtd.equals(CodeConstants.ANS_MTD_ELEC)){

			strBufReturn.append("<td width='18' height='18' align='left' valign='top'>");

			strBufReturn.append("<img src='/image/reqsubmit/bt_EDoc.gif' width='73' height='16' border='0' >");

			strBufReturn.append("</td>");

			strBufReturn.append("<td width='37%' height='18' valign='top'>");

			strBufReturn.append("<a href='/reqsubmit/common/ReqFileOpen2.jsp?paramAnsId=" + strAnsID + "&DOC=PDF&REQNM=" + strReqCont + "&REQSEQ=" + strSeq + "&SubmtOrganNm="+strSubmt+"' target='_self'>");

			strBufReturn.append("<img src='/image/common/icon_pdf.gif' width='16' height='16' border='0' alt='PDF����'>");

			strBufReturn.append("</a>");

			strBufReturn.append("&nbsp;<a href='/reqsubmit/common/ReqFileOpen2.jsp?paramAnsId=" + strAnsID + "&DOC=DOC&REQNM=" + strReqCont + "&REQSEQ=" + strSeq + "&SubmtOrganNm="+strSubmt+"' target='_self'>");

			strBufReturn.append("<img src='/image/common/icon_file.gif' border='0' alt='��������'>");

			strBufReturn.append("</a>");

			strBufReturn.append("</td>");

		}else if(strAnsMtd.equals(CodeConstants.ANS_MTD_ETCS)){

			strBufReturn.append("<td colspan='2' width='18' height='18' align='left' valign='top'>");

			strBufReturn.append("<img src='/image/reqsubmit/bt_NotEDoc.gif' width='73' height='16' border='0' >");

			strBufReturn.append("</td>");					

		}else if(strAnsMtd.equals("004")){
			strBufReturn.append("<td colspan=\\'2\\' width=\\'18\\' height=\\'18\\' align=\\'left\\' valign=\\'top\\'>");
			strBufReturn.append("<img src=\\'/image/reqsubmit/bt_offLineSubmit.gif\\' width=\\'73\\' height=\\'16\\' border=\\'0\\' alt=\\'���������� ���� ����\\'>");
			strBufReturn.append("</td>");					
		}else {

			strBufReturn.append("<td colspan='2' width='18' height='18' align='left' valign='top'>");

			strBufReturn.append("<img src='/image/reqsubmit/bt_NotPertinentOrg.gif' width='73' height='16' border='0'>");

			strBufReturn.append("</td>");					

		}

		strBufReturn.append("</tr></table>");

		return strBufReturn.toString();

	}
%>
