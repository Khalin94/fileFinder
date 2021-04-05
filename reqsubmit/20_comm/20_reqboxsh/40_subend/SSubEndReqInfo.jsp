<%@ page language="java" contentType="text/html;charset=EUC-KR" %>

<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.lib.reqsubmit.params.requestinfo.SCommReqInfoVListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.CommAnsInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.SCommRequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.cmtsubmt.CmtSubmtReqBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.SMemReqBoxDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	UserInfoDelegate objUserInfo = null;
	CDInfoDelegate objCdinfo = null;
%>

<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>

<%
	CommAnsInfoDelegate objAnsInfo = new CommAnsInfoDelegate();
	SCommReqInfoVListForm objParams = new SCommReqInfoVListForm();
	SMemReqBoxDelegate sReqDelegate = new SMemReqBoxDelegate();

	boolean blnParamCheck=false;
	blnParamCheck = objParams.validateParams(request);
	if(blnParamCheck==false) {
  		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  		objMsgBean.setStrCode("DSPARAM-0000");
  		objMsgBean.setStrMsg(objParams.getStrErrors());
  		out.println("ParamError:" + objParams.getStrErrors());
	  	return;
  	}

	//�α��� ����� ������ �����´�. ���Ѿ��� ��� ������ �����ϴ�.
	String strReqSubmitFlag = objUserInfo.getReqSubmitFlag();

	String strReqStt = null;
	// �Ѿ�� �Ķ���͸� �����ؼ� �ʿ��� �� ������ ����
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

	// �亯 ���� �� ����¡ ����
	int intTotalRecordCount = 0;

	ResultSetSingleHelper objRsSH = null;
	ResultSetHelper objRs = null;
	ResultSetHelper objRsAns = null;
 	SCommRequestBoxDelegate objReqBox=null; 		/**�䱸�� Delegate*/

	try {
		objReqBox=new SCommRequestBoxDelegate();



	    // �䱸 ������ SELECT �Ѵ�.
	    objRsSH = new ResultSetSingleHelper(objAnsInfo.getReqRecord(strReqID));
	    // �亯 ����� SELECT �Ѵ�.
	    strReqStt = (String)objRsSH.getObject("REQ_STT");
	    objRs = new ResultSetHelper(objAnsInfo.getRecordList(strReqID));

	} catch(AppException e) {
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  		objMsgBean.setStrCode(e.getStrErrCode());
  		objMsgBean.setStrMsg(e.getMessage());
  		out.println("<br>Error!!!" + e.getMessage());
%>
	  		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
	  	return;
 	}

	String UserID = objUserInfo.getUserID();
	String ANSW_PERM_CD = (String)objRsSH.getObject("ANSW_PERM_CD");
%>
<jsp:include page="/inc/header.jsp" flush="true"/>
<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>
<script language="javascript">
	var f;
	var ANSW_PERM_CD = '<%=ANSW_PERM_CD %>';

	// ���� �Ϸ�
	function sbmtReq() {
		f = document.viewForm;
		f.target = "";
		f.action = "/reqsubmit/common/SReqSubmtDoneProc.jsp";
		if (confirm("���� �䱸�� ���� �亯 ������ �Ϸ��Ͻðڽ��ϱ�?")) f.submit();
	}

	// �䱸�� ����
	function goReqBoxView() {
		f = document.viewForm;
		f.action = "./SSubEndBoxVList.jsp";
		f.target = "";
		f.submit();
	}
    function gotoDetail(AnID,AnsrID,AnswPermCD){
        f = document.viewForm;
        f.target = "popwin";
        f.AnsrID.value = AnsrID;
        f.AnswPermCD.value = AnswPermCD;
        f.action="/reqsubmit/common/SAnsInfoView2.jsp?AnsrID="+AnsrID+"&AnsID="+AnID+"&AnswPermCD="+AnswPermCD;
        NewWindow('/blank.html', 'popwin', '618', '590');
        f.submit();
          //var add_sub = window.showModalDialog('SMakeAnsInfoView.jsp?returnURL=POPUP&ReqBoxID=<%= strReqBoxID %>&ReqID=<%= strReqID %>&AnsID='+strID, '', 'dialogWidth:500px;dialogHeight:300px; center:yes; help:no; status:no; scroll:no; resizable:yes');
          //window.open('/reqsubmit/common/SAnsInfoView.jsp?returnURL=POPUP&ReqBoxID=<%= strReqBoxID %>&ReqID=<%= strReqID %>&AnsID='+strID, '', 'width=500,height=400, scrollbars=no, resizable=yes, toolbar=no, menubar=no, location=no, directories=no, status=no');
      }

	// �߰� �亯 �ۼ� ȭ������ �̵�
	function gotoAddAnsInfoWrite() {
//		f = document.viewForm;
//		f.action = "/reqsubmit/20_comm/20_reqboxsh/SCommAnsInfoWrite.jsp";
//		f.target = "";
//		f.submit();

		/*if(ANSW_PERM_CD == '222'){	// �亯 ���ν�

			// �߰��亯��� ���
			alert("�ش� �䱸�� ���� �亯�� �䱸�ڰ� �����Ͽ� �߰��亯�� ����� �� �����ϴ�.");

		}else{		// �亯 �̽��ν�*/

			f = document.viewForm;
			f.ReqID.value = "<%= strReqID %>";
			f.AddAnsFlag.value = "Y";
			f.target = "newpopup";
			f.action = "/reqsubmit/common/SAnsInfoWrite.jsp";
			var winl = (screen.width - 600) / 2;
			var winh = (screen.height - 600) / 2;
			window.open("/blank.html","newpopup","resizable=no,menubar=no,status=no,titlebar=no, scrollbars=no,location=no,toolbar=no,height=530,width=595, left="+winl+", top="+winh);
			f.submit();

		//}
	}
	// �߰� �亯 �ۼ� ȭ������ �̵�
	function gotoAddAnsInfoWrite_old() {
//		f = document.viewForm;
//		f.action = "/reqsubmit/20_comm/20_reqboxsh/SCommAnsInfoWrite.jsp";
//		f.target = "";
//		f.submit();

		/*if(ANSW_PERM_CD == '222'){	// �亯 ���ν�

			// �߰��亯��� ���
			alert("�ش� �䱸�� ���� �亯�� �䱸�ڰ� �����Ͽ� �߰��亯�� ����� �� �����ϴ�.");

		}else{		// �亯 �̽��ν�*/

			f = document.viewForm;
			f.ReqID.value = "<%= strReqID %>";
			f.AddAnsFlag.value = "Y";
			f.target = "newpopup";
			f.action = "/reqsubmit/common/SAnsInfoWrite_old.jsp";
			var winl = (screen.width - 550) / 2;
			var winh = (screen.height - 350) / 2;
			window.open("/blank.html","newpopup","resizable=yes,menubar=no,status=no,titlebar=no,	scrollbars=yes,location=no,toolbar=no,height=350,width=520, left="+winl+", top="+winh);
			f.submit();

		//}
	}
	// ���� �亯 ����
//  	function selectDelete() {
//  		var f = document.viewForm;
//  		if (getCheckCount(f, "AnsID") < 1) {
//  			alert("�ϳ� �̻��� üũ�ڽ��� ������ �ּ���");
//  			return;
//  		}
//  		f.action = "SMakeAnsInfoDelProc.jsp";
//		f.target = "";
//  		if (confirm("�����Ͻ� �亯���� �����Ͻðڽ��ϱ�?\n�ش� �亯���� �����ϸ� ���Ե� ���ϵ鵵 �ϰ� �����˴ϴ�.")) f.submit();
//  	}

	// �亯���� : �����ڷ�����ý��۱�ɰ������_2011
	function gotoEditForm() {

		// üũ�ڽ� ���� üũ
		var f = document.viewForm;
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
			f2.action="/reqsubmit/common/SAnsInfoEdit.jsp?AnsID="+strID+"&AnsrId="+Ansr_id;
			NewWindow('/blank.html', 'popwin', '580', '580');
			f2.submit();
		}

	}

  	// ���û��� : �����ڷ�����ý��۱�ɰ������_2011
  	function selectDelete() {

  		// üũ�ڽ� ���� üũ
		var f = document.viewForm;
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
        if(ANSW_PERM_CD == '222' && (ANSW_INQ_YN == 'Y')){	// �亯 ���ν�
            // �亯 ���� ���� ���
//						alert("�����Ͻ� �亯 �߿� ��û�ڰ� ������ �亯�� �ֽ��ϴ�.\nȮ�� �� �̿����� �亯�� ������ �ֽñ� �ٶ��ϴ�.");
            alert("�ش� �䱸�� ���� �亯�� �䱸�ڰ� �����Ͽ� �亯�� ������ �� �����ϴ�.");
            return;
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
		if (confirm("�����Ͻ� �亯���� �����Ͻðڽ��ϱ�?\n�ش� �亯���� �����ϸ� ���Ե� ���ϵ鵵 �ϰ� �����˴ϴ�.")) {
	    	f.action = "/reqsubmit/common/SAnsInfoDelProc3.jsp";
    		f.target = "";
            f.submit();
        }

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
			var f = document.viewForm;
			f.AnsID2.value = AnsID;
			f.target = "";
			f.action = "/reqsubmit/common/SAnsInfoDelProc2.jsp";
			if (confirm("�ش� �亯�� �����Ͻðڽ��ϱ�?\n�ش� �亯�� �����ϸ� ���Ե� ���ϵ鵵 �ϰ� �����˴ϴ�.")) f.submit();
		}

	}

	// �亯�� �߼�
	function sendAnsDoc() {
		var f = document.viewForm;
		//������� �׽�Ʈ
		var AnswPermCD = f.AnswPermCD.value;		
		f.action = "/reqsubmit/common/AnsDocSend.jsp?ReqBoxID=<%= strReqBoxID %>";
		f.ReturnURL.value = "/reqsubmit/20_comm/20_reqboxsh/40_subend/SCommReqBoxList.jsp?ReqBoxID=<%= strReqBoxID %>";
		f.target = "popwin";
		NewWindow('/blank.html', 'popwin', '470', '300');
		f.submit();
	}
 
	// �ڵ� �亯�� �߼� Ȯ��
	function checkSendAnsDoc() {				
		if(confirm("��� �䱸�� ���� �亯�� ����ϼ̽��ϴ�. �亯�� �߼��� �����Ͻðڽ��ϱ�?")) sendAnsDoc();
	}
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0"
<%
	int intNotSubmitReqCnt = sReqDelegate.getReqCntNotSubmit1(strReqBoxID);	
	System.out.println("kangthis logs SMakeEndReqInfoVList.jsp intNotSubmitReqCnt => " + intNotSubmitReqCnt);	

	if(intNotSubmitReqCnt > 0) {
		out.println(" onLoad='javascript:checkSendAnsDoc()'");
	}
%>
>
<div id="wrap">
<SCRIPT language="JavaScript" src="/js/reqsubmit/reqinfo.js"></SCRIPT>
  <jsp:include page="/inc/top.jsp" flush="true"/>
  <jsp:include page="/inc/top_menu02.jsp" flush="true"/>
  <div id="container">
    <div id="leftCon">
      <jsp:include page="/inc/log_info.jsp" flush="true"/>
      <jsp:include page="/inc/left_menu02.jsp" flush="true"/>
    </div>
    <div id="rightCon">
<form name="viewForm" method="post" action="" style="margin:0px">
			<!-- �䱸�� ��� ���� ���� -->
			<input type="hidden" name="ReqBoxID" value="<%= strReqBoxID %>">
			<input type="hidden" name="ReqID" value="<%= strReqID %>">
			<input type="hidden" name="ReqBoxSortField" value="<%= strReqBoxSortField %>"><!--�䱸�Ը�������ʵ� -->
			<input type="hidden" name="ReqBoxSortMtd" value="<%= strReqBoxSortMtd %>"><!--�䱸�Ը�����Ĺ��-->
			<input type="hidden" name="ReqBoxPage" value="<%= strReqBoxPagNum %>"><!--�䱸�� ������ ��ȣ -->
			<% if(StringUtil.isAssigned(strReqBoxQryTerm)) { %>
			<input type="hidden" name="ReqBoxQryField" value="<%= strReqBoxQryField %>"><!--�䱸�� ��ȸ�ʵ� -->
			<input type="hidden" name="ReqBoxQryTerm" value="<%= strReqBoxQryTerm %>"><!--�䱸�� ��ȸ�ʵ� -->
			<% } //�䱸�� ��ȸ� �ִ� ��츸 ����ؼ� ����� %>

			<!-- �䱸 ��� ���� -->
			<input type="hidden" name="ReqInfoSortField" value="<%= strReqInfoSortField %>"><!--�䱸���� ��������ʵ� -->
			<input type="hidden" name="ReqInfoSortMtd" value="<%= strReqInfoSortMtd %>"><!--�䱸���� ������Ĺ��-->
			<% if(StringUtil.isAssigned(strReqInfoQryTerm)) { %>
			<input type="hidden" name="ReqInfoQryField" value="<%= strReqInfoQryField %>"><!--�䱸���� ��ȸ�ʵ� -->
			<input type="hidden" name="ReqInfoQryTerm" value="<%= strReqInfoQryTerm %>"><!-- �䱸���� ��ȸ�� -->
			<% } %>
			<input type="hidden" name="ReqInfoPage" value="<%= strReqInfoPagNum %>"><!-- �䱸���� ������ ��ȣ -->
			<input type="hidden" name="ReqOpenCL" value="<%= objRsSH.getObject("OPEN_CL") %>">
			<!-- ���� �� ��ȯ�� URL�� �����ϱ� ���� Parameter ���� -->
			<input type="hidden" name="returnURL" value="SELF">
			<input type="hidden" name="AuditYear" value="<%=objRsSH.getObject("AUDIT_YEAR")%>">
			<input type="hidden" name="ReturnURL" value="<%=request.getRequestURI()%>?ReqBoxID=<%=strReqBoxID%>&ReqID=<%=strReqID%>&AuditYear=<%=objRsSH.getObject("AUDIT_YEAR")%>">
			<input type="hidden" name="ReturnUrl" value="<%=request.getRequestURI()%>?ReqBoxID=<%=strReqBoxID%>&ReqID=<%=strReqID%>&AuditYear=<%=objRsSH.getObject("AUDIT_YEAR")%>">
			<input type="hidden" name="AddAnsFlag" value="Y">

			<!-- ���� �亯 ������ ���� Parameter ���� -->
			<input type="hidden" name="AnsID2" value="">
            <input type="hidden" name="AnsrID" value="<%=objRs.getObject("ANSR_ID")%>">
			<input type="hidden" name="AnswPermCD" value="">
      <!-- pgTit -->

      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=MenuConstants.COMM_REQ_BOX_SUBMT_END%><span class="sub_stl" >- �䱸 �� ����</span></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /><%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%= MenuConstants.REQUEST_BOX_COMM %> > <%=MenuConstants.COMM_REQ_BOX_SUBMT_END%></div>
        <p><!--����--></p>
      </div>
      <!-- /pgTit -->
      <!-- contents -->
      <div id="contents">
        <!-- �˻����� ���� ��� �Ʒ� div ���� �� �ּ����� ��������.-->
        <!-- /�˻�����-->
        <!-- �������� ���� -->
         <!-- list view-->
        <span class="list02_tl">�䱸���� </span>
        <div class="top_btn"><samp>
			<span class="btn"><a href="javascript:goReqBoxView()">�䱸�� ����</a></span>
			<span class="btn"><a href="javascript:viewReqHistory('<%=strReqID%>')">�䱸 �̷� ����</a></span>
		</samp></div>

        <table border="0" cellspacing="0" cellpadding="0" width="680" class="list02">
            <tr>
                <th height="25">&bull; �䱸���� </th>
                <td height="25" colspan="3"><%= objRsSH.getObject("REQ_CONT") %></td>
            </tr>
            <tr>
                <th height="25">&bull; �䱸���� </th>
                <td height="25" colspan="3">- <%= StringUtil.getDescString((String)objRsSH.getObject("REQ_DTL_CONT")) %><br>
			  	<%= nads.dsdm.app.reqsubmit.delegate.requestinfo.RequestInfoDelegate.getAppendRequestInfo((List)objRsSH.getObject("TBDS_REQ_LOG")) %>
				</td>
            </tr>
            <tr>
                <th height="25">&bull; �䱸�Ը� </th>
                <td height="25" colspan="3"><%= objRsSH.getObject("REQ_BOX_NM") %></td>
            </tr>
            <tr>
                <th height="25" width="18%">&bull; �Ұ� ����ȸ </th>
                <td height="25" width="32%"><%= objRsSH.getObject("CMT_ORGAN_NM") %></td>
                <th height="25" width="18%">&bull;&nbsp;�������</th>
                <td height="25" width="32%"><%= CodeConstants.getOpenClass((String)objRsSH.getObject("OPEN_CL")) %></td>
            </tr>
            <tr>
                <th height="25">&bull; �䱸��� </th>
                <td height="25"><%= objRsSH.getObject("REQ_ORGAN_NM") %> (<%= objRsSH.getObject("REGR_NM") %>)</td>
                <th height="25">&bull;&nbsp;������</th>
                <td height="25"><%= objRsSH.getObject("SUBMT_ORGAN_NM") %></td>
            </tr>
            <tr>
                <th height="25">&bull; �䱸�Ͻ� </th>
                <td height="25"><%= StringUtil.getDate2((String)objRsSH.getObject("LAST_REQ_DT")) %></td>
                <th height="25">&bull;&nbsp;�����Ͻ�</th>
                <td height="25"><%= StringUtil.getDate2((String)objRsSH.getObject("LAST_ANS_DT")) %></td>
            </tr>
            <tr>
                <th height="25">&bull; ������� </th>
                <td height="25"><%= StringUtil.getDate((String)objRsSH.getObject("SUBMT_DLN")) %> 24:00</td>
                <th height="25">&bull;&nbsp;÷������</th>
                <td height="25"><%= StringUtil.makeAttachedFileLink((String)objRsSH.getObject("ANS_ESTYLE_FILE_PATH"), (String)objRsSH.getObject("REQ_ID")) %></td>
            </tr>
            <tr>
                <th height="25">&bull; �亯 ���λ��� </th>
                <td height="25"><%= CodeConstants.getAnsApprStt(ANSW_PERM_CD) %></td>
                <th height="25">&nbsp;</th>
                <td height="25">&nbsp;</td>
            </tr>
        </table>
        <!-- /list view -->
<!--        <p class="warning mt10">* �䱸�� �߼� : �ǿ���(�Ǵ� �Ҽӱ��) ���Ƿ� �ش� �������� �䱸���� �߼��մϴ�.</p>-->
			<p class="warning mt10">* �߰��亯 ��Ͻÿ��� �ݵ�� �亯���߼��� �����ؾ� �亯�Ϸᰡ �˴ϴ�.<br> * �亯�� �߼��� ���Ͽ� F5�� ������ �亯�� �߼��� �����ϼ���.</p>
        <!-- ����Ʈ ��ư-->
        <div id="btn_all"><div  class="t_right">
		<%if (!CodeConstants.REQ_STT_SUBMT.equalsIgnoreCase(strReqStt)) { // ����Ϸᰡ �ƴ� ��츸 �����ּ��� %>
			<div class="mi_btn"><a href="javascript:sbmtReq()"><span>�������</span></a></div>
		<%} %>
		</div></div>

        <!-- /����Ʈ ��ư-->

        <!-- list -->
        <span class="list01_tl">�亯��� <span class="list_total">&bull;&nbsp;��ü�ڷ�� :  <%=objRs.getRecordSize()%>�� </span></span>
        <table width="100%" style="padding:0;">
            <tr>
                <td>&nbsp;</td>
            </tr>
        </table>
        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
          <thead>
            <tr>
<%// if (!CodeConstants.REQ_STT_SUBMT.equalsIgnoreCase(strReqStt)) { // ����Ϸᰡ �ƴ� ��츸 �����ּ��� %>
              <th scope="col"><input name="" type="checkbox" value="" class="borderNo" onClick="javascript:revCheck(this.form, 'AnsID')"/></th>
<%// } %>
			<!--
              <th scope="col">NO</th>
			-->
              <th scope="col"><a>���� �ǰ�</a></th>
              <th scope="col"><a>�ۼ���</a></th>
              <th scope="col"><a>�亯</a></th>
			  <th scope="col">&nbsp;</th>
              <th scope="col"><a>�亯����</a></th>
            </tr>
          </thead>
          <tbody>
			<%
				int intCnt = 1;
				while(objRs.next()){
                    String testkey = objRs.getObject("ANS_ID")+"$$"+objRs.getObject("ANSR_ID")+"$$"+objRs.getObject("ANSW_INQ_YN");
                    String testkey2 = objRs.getObject("ANS_ID")+"$$"+objRs.getObject("ANSR_ID")+"$$"+ANSW_PERM_CD;
			%>
            <tr>
<%// if (!CodeConstants.REQ_STT_SUBMT.equalsIgnoreCase(strReqStt)) { // ����Ϸᰡ �ƴ� ��츸 �����ּ��� %>
              <td> 
				<input type="checkbox" name="AnsID" value="<%=testkey%>">
				<input name="AnswInqYn" type="hidden" value="<%= (String)objRs.getObject("ANSW_INQ_YN") %>">
                                <input name="AnsrId" type="hidden" value="<%= (String)objRs.getObject("ANSR_ID") %>" />
			  </td>
<%// } %>
			<!--
			  <td><%=intCnt%></td>
			-->
              <td><a href="javascript:gotoDetail('<%=objRs.getObject("ANS_ID")%>','<%=objRs.getObject("ANSR_ID")%>','<%=ANSW_PERM_CD%>')"><%= objRs.getObject("ANS_OPIN") %></a></td>
              <td style="text-align:left;"><%= objRs.getObject("ANSR_NM") %></td>
              <td align="center"><%=nads.lib.reqsubmit.util.DBAccessUtil.makeAnsInfoHtml((String)objRs.getObject("ANS_ID"), (String)objRs.getObject("ANS_MTD")) %></td>
			  <td><span class="list_bt"><a href="javascript:delAnsDoc('<%= objRs.getObject("ANS_ID") %>','<%= objRs.getObject("ANSR_ID") %>','<%= objRs.getObject("ANSW_INQ_YN") %>');">����</a></span></td>
              <td><%= StringUtil.getDate2((String)objRs.getObject("ANS_DT")) %></td>
            </tr>
			<%
					intCnt++;
				} //endwhile
			%>

<!--
	�ڷᰡ ���� ���
			<tr>
			 <td colspan="6"  align ="center"> ��ϵ� �䱸������ �����ϴ�. </td>
            </tr>
-->
          </tbody>
        </table>

        <!-- /list -->

        <!-- ����¡
        <span class="paging" > <span class="list_num_on"><a href="#">1</a></span> <span class="list_num"><a href="#">2</a></span> <span class="list_num"><a href="#">3</a></span> <span class="list_num"><a href="#">4</a></span> <span class="list_num"><a href="#">5</a></span> </span>

         /����¡-->


       <!-- ����Ʈ ��ư
        <div id="btn_all" >
		<!-- ����Ʈ �� �˻� -->
<!--
		<div class="list_ser" >
          <select name="select" class="selectBox5"  style="width:70px;" >
            <option value="">�䱸����</option>
            <option value="">�䱸����</option>
          </select>
          <input name="iptName" onKeyDown="return ch()" onMouseDown="return ch()"
		 class="li_input"  style="width:100px"/>
          <img src="/images2/btn/bt_list_search.gif"  onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"/> </div>
-->
        <!-- /����Ʈ �� �˻�  -->
			<span class="right">
				<span class="list_bt"><a href="javascript:gotoAddAnsInfoWrite_old()">�߰��亯���</a></span>
				<span class="list_bt"><a href="javascript:gotoAddAnsInfoWrite()">��뷮���ϵ��</a></span>
				<span class="list_bt"><a href="javascript:gotoEditForm()">�亯����</a></span>
				<!--span class="list_bt"><a href="javascript:selectDelete()">���û���</a></span-->
			</span>
		</div>

        <!-- /����Ʈ ��ư-->
        <!-- /�������� ����
      </div>
      <!-- /contents -->

    </div>
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

  <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>
