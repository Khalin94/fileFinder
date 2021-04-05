<%@ page language="java" contentType="text/html;charset=EUC-KR" %>

<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="java.util.*" %>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RCommSubReqListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.CommRequestInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.CommAnsInfoDelegate" %>
<%@ page import="nads.dsdm.app.common.page.PagingDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.SMemReqBoxDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	UserInfoDelegate objUserInfo =null;
	CDInfoDelegate objCdinfo =null;
%>
<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>
<%
	/*** PagingDelegate */
	PagingDelegate objPaging=new PagingDelegate(); 		/*����¡ ��ȯ Delegate*/
%>
<%
	/**�Ϲ� �䱸�� �󼼺��� �Ķ���� ����.*/
	RCommSubReqListForm objParams =new RCommSubReqListForm();
	SMemReqBoxDelegate sReqDelegate = new SMemReqBoxDelegate();
	objParams.setParamValue("IsRequester",String.valueOf(objUserInfo.isRequester()));//�䱸�亯�ڿ��μ���

	boolean blnParamCheck=false;
	/**���޵� �ĸ����� üũ */
	blnParamCheck=objParams.validateParams(request);
	if(blnParamCheck==false) {
	  	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
	  	objMsgBean.setStrCode("DSPARAM-0000");
	  	objMsgBean.setStrMsg(objParams.getStrErrors());
	  	out.println("ParamError:" + objParams.getStrErrors());
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}

	//�α��� ����� ������ �����´�. ���Ѿ��� ��� ������ �����ϴ�.
	String strReqSubmitFlag = objUserInfo.getReqSubmitFlag();

	/*** Delegate �� ������ Container��ü ���� */
	CommRequestInfoDelegate objReqInfo=null;		/** �䱸���� Delegate */
	CommAnsInfoDelegate objAnsInfo = new CommAnsInfoDelegate();
	ResultSetSingleHelper objRsRI=null;			/** �䱸 �󼼺��� ���� */
	ResultSetHelper objRs = null;					/** �亯 ��� */
	String strReqStt = null;
	String strReqID = objParams.getParamValue("ReqID");
	String strReqBoxID = (String)request.getParameter("ReqBoxID");    	
	try {
		/**�䱸 ���� �븮�� New */
		objReqInfo=new CommRequestInfoDelegate();
		objRsRI=new ResultSetSingleHelper(objReqInfo.getRecord((String)objParams.getParamValue("ReqID")));
		// �亯 ����� SELECT �Ѵ�.
		strReqStt = (String)objRsRI.getObject("REQ_STT");
		objRs = new ResultSetHelper(objAnsInfo.getRecordList((String)objParams.getParamValue("ReqID")));

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

	String UserID = objUserInfo.getUserID();
	String ANSW_PERM_CD = (String)objRsRI.getObject("ANSW_PERM_CD");
%>
<jsp:include page="/inc/header.jsp" flush="true"/>
<link href="/css2/style.css" rel="stylesheet" type="text/css">
<script language="javascript">

	var f;
	var ANSW_PERM_CD = '<%=ANSW_PERM_CD %>';

  	// �亯 �󼼺���� ����
  	function gotoDetail(strID){
//  		NewWindow('/reqsubmit/common/SAnsInfoView.jsp?returnURL=POPUP&AnsID='+strID, '', 520, 400);
  		//window.open('/reqsubmit/common/SAnsInfoView.jsp?returnURL=POPUP&AnsID='+strID, '', 'width=520,height=400, scrollbars=no, resizable=yes, toolbar=no, menubar=no, location=no, directories=no, status=no');

 		f = document.formName;
  		//f.AnsID.value = strID;
		f.target = "popwin";
  		f.action="/reqsubmit/common/SAnsInfoView2.jsp?AnsID="+strID;
		NewWindow('/blank.html', 'popwin', '618', '590');
  		f.submit();
  	}

  	// ����� �䱸������� ����
  	function gotoList(){
  		f = document.formName;
        f.target = "";
  		f.action="SCommSubReqList.jsp";
  		f.submit();
 	}

	// �߰� �亯 �ۼ� ȭ������ �̵�
	function gotoAddAnsInfoWrite() {
		f = document.formName;
		f.action = "/reqsubmit/20_comm/20_reqboxsh/SCommAnsInfoWrite.jsp";
		f.target = "";
		f.submit();
	}

	// �߰� �亯 �ۼ� ȭ������ �̵�
  	function goSbmtReqForm() {
//		f = document.formName;
//		f.action = "/reqsubmit/20_comm/20_reqboxsh/SCommAnsInfoWrite.jsp";
//		f.target = "";
//		f.submit();

		/*if(ANSW_PERM_CD == '222'){	// �亯 ���ν�

			// �߰��亯��� ���
			alert("�ش� �䱸�� ���� �亯�� �䱸�ڰ� �����Ͽ� �߰��亯�� ����� �� �����ϴ�.");

		}else{		// �亯 �̽��ν�*/

			f = document.formName;
			f.ReqID.value = "<%= strReqID %>";
			f.AddAnsFlag.value = "Y";
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
		//������� �׽�Ʈ
		var AnswPermCD = f.AnswPermCD.value;
		f.action = "/reqsubmit/common/AnsDocSend.jsp?ReqBoxID=<%= strReqBoxID %>";
		//f.ReturnURL.value = "/reqsubmit/20_comm/30_reqlistsh/SCommSubReqInfo.jsp?ReqBoxID=<%= strReqBoxID %>";
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
	System.out.println("kangthis logs SCommSubReqInfo.jsp intNotSubmitReqCnt => " + intNotSubmitReqCnt);	

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
	<SCRIPT language="JavaScript" src="/js/reqsubmit/reqinfo.js"></SCRIPT>
	<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>
    </div>
    <div id="rightCon">
<form name="formName" method="post" action="<%=request.getRequestURI()%>">

<%  //�䱸 ���� ���� ���� �ޱ�.
	String strCommReqInfoSortField=objParams.getParamValue("CommReqInfoSortField");
	String strCommReqInfoSortMtd=objParams.getParamValue("CommReqInfoSortMtd");
	//�䱸�� ���� ������ ��ȣ �ޱ�.
	String strCommReqInfoPagNum=objParams.getParamValue("CommReqInfoPageNum");
%>
	<input type="hidden" name="CommReqInfoSortField" value="<%=strCommReqInfoSortField%>"><!--�䱸���� ��������ʵ� -->
	<input type="hidden" name="CommReqInfoSortMtd" value="<%=strCommReqInfoSortMtd%>"><!--�䱸���� ������ɹ��-->
	<input type="hidden" name="CommReqInfoPage" value="<%=strCommReqInfoPagNum%>"><!--�䱸���� ������ ��ȣ -->
	<input type="hidden" name="WinType" value="SELF">
	<input type="hidden" name="ReturnURL" value="<%=request.getRequestURI()%>?ReqBoxID=<%=objRsRI.getObject("REQ_BOX_ID")%>&ReqID=<%=(String)objParams.getParamValue("ReqID")%>&AuditYear=<%=objParams.getParamValue("AuditYear")%>">
	<input type="hidden" name="AddAnsFlag" value="Y">
	<input type="hidden" name="ReqBoxID" value="<%=objRsRI.getObject("REQ_BOX_ID") %>">
	<input type="hidden" name="ReqID" value="<%= (String)objParams.getParamValue("ReqID") %>">
	<input type="hidden" name="AuditYear" value="<%=objParams.getParamValue("AuditYear")%>">
	<input type="hidden" name="CmtOrganID" value="<%=objParams.getParamValue("CmtOrganID")%>">
	<input type="hidden" name="ReqOpenCL" value="<%= objRsRI.getObject("OPEN_CL") %>">
	<input type="hidden" name="AnswPermCD" value="<%=ANSW_PERM_CD%>">

	<!-- ���� �亯 ������ ���� Parameter ���� -->
	<input type="hidden" name="AnsID2" value="">
      <!-- pgTit -->
      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=MenuConstants.REQ_INFO_LIST_SUBMT_DONE%><span class="sub_stl" >- �䱸�󼼺���</span></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.REQUEST_BOX_COMM%> > <%=MenuConstants.REQ_INFO_LIST_SUBMT_DONE%></div>
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
			 <span class="btn"><a href="javascript:viewReqHistory('<%=(String)objParams.getParamValue("ReqID")%>')">�䱸 �̷� ����</a></span>
			 <span class="btn"><a href="javascript:gotoList()">�䱸���</a></span>
		</samp></div>
        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list02">
			<%
				if(!objRsRI.next()){
			%>
			<tr>
              <th scope="col">&bull;&nbsp;�䱸 ���� �� �����ϴ�. </th>
			 </tr>
			<%
				}else{
			%>
            <tr>
              <th scope="col">&bull;&nbsp;�䱸���� </th>
				  <td colspan="3"><%=objRsRI.getObject("REQ_CONT")%>
				</td>

            </tr>

            <tr>
              <th scope="col">&bull;&nbsp;�䱸���� </th>
			  <td colspan="3">- <%=StringUtil.getDescString((String)objRsRI.getObject("REQ_DTL_CONT")) %><br>
			  	<%= nads.dsdm.app.reqsubmit.delegate.requestinfo.RequestInfoDelegate.getAppendRequestInfo((List)objRsRI.getObject("TBDS_REQ_LOG")) %></td>
            </tr>
            <tr>
              <th scope="col">&bull;&nbsp;�䱸�Ը�  </th>
			  <td colspan="3"><%=objRsRI.getObject("REQ_BOX_NM")%></td>
            </tr>
            <tr>
                <th width="18%" scope="col">&bull;&nbsp;�Ұ�����ȸ </th>
			    <td width="32%"><%= (String)objRsRI.getObject("CMT_ORGAN_NM") %></td>
                <th width="18%" scope="col">&bull;&nbsp;������� </th>
				<td width="32%" ><%=CodeConstants.getOpenClass((String)objRsRI.getObject("OPEN_CL"))%></td>
            </tr>
            <tr>
              <th scope="col">&bull;&nbsp;�䱸���  </th>
			  <td><%=objRsRI.getObject("REQ_ORGAN_NM")%> (<%=objRsRI.getObject("REGR_NM")%>)</td>
              <th scope="col">&bull;&nbsp;������  </th>
			  <td><%=objRsRI.getObject("SUBMT_ORGAN_NM")%></td>
            </tr>
            <tr>
              <th scope="col">&bull;&nbsp;�䱸�Ͻ�  </th>
			  <td><%= StringUtil.getDate2((String)objRsRI.getObject("LAST_REQ_DT")) %></td>
              <th scope="col">&bull;&nbsp;�����Ͻ�  </th>
			  <td><%= StringUtil.getDate2((String)objRsRI.getObject("LAST_ANS_DT")) %></td>
            </tr>
            <tr>
              <th scope="col">&bull;&nbsp;�������  </th>
			  <td><%= StringUtil.getDate((String)objRsRI.getObject("SUBMT_DLN")) %> 24:00</td>
              <th scope="col">&bull;&nbsp;÷������  </th>
			  <td><%=StringUtil.makeAttachedFileLink((String)objRsRI.getObject("ANS_ESTYLE_FILE_PATH"),(String)objRsRI.getObject("REQ_ID"))%></td>
            </tr>
            <tr>
                <th height="25">&bull; �亯 ���λ��� </th>
                <td height="25"><%= CodeConstants.getAnsApprStt(ANSW_PERM_CD) %></td>
                <th height="25">&nbsp;</th>
                <td height="25">&nbsp;</td>
            </tr>
			<%
				}/** �䱸 ���� �� ������. */
			%>
        </table>
        <!-- /list view -->
		<!-- �亯�� �߼� -->
		            <p class="warning mt10">* �߰��亯 ��Ͻÿ��� �ݵ�� �亯���߼��� �����ؾ� �亯�Ϸᰡ �˴ϴ�.<br> * �亯�� �߼��� ���Ͽ� F5�� ������ �亯�� �߼��� �����ϼ���.</p>
        <!-- ����Ʈ ��ư-->
<!--
�䱸 �̷� ����, �䱸 ���
-->
        <div id="btn_all"><div  class="t_right">
        </div></div>
        <!-- /����Ʈ ��ư-->

        <!-- list -->
        <span class="list01_tl">�亯 ��� <span class="list_total">&bull;&nbsp;��ü�ڷ�� :  <%=objRs.getRecordSize()%>�� </span></span>
        <table width="100%" style="padding:0;">
            <tr>
                <td>&nbsp;</td>
            </tr>
        </table>
        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
          <thead>
            <tr>
			  <th scope="col"><input name="" type="checkbox" value="" class="borderNo" onClick="javascript:revCheck(this.form, 'AnsID')"/></th>
              <th scope="col"><a>���� �ǰ�</a></th>
              <th scope="col"><a>�亯</a></th>
			  <th scope="col">&nbsp;</th>
              <th scope="col""><a>������</a></th>
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
          </tbody>
        </table>
        <!-- /list -->

       <!-- ����Ʈ ��ư-->
       <span class="right">
            <span class="list_bt"><a href="javascript:goSbmtReqForm_old()">�߰��亯���</a></span>
			<span class="list_bt"><a href="javascript:goSbmtReqForm()">��뷮���ϵ��</a></span>
            <span class="list_bt"><a href="javascript:gotoEditForm()">�亯����</a></span>
            <!--span class="list_bt"><a href="javascript:selectDelete()">���û���</a></span-->
        </span>
        <!-- /����Ʈ ��ư-->
        <!-- /�������� ���� -->
      </div>
      <!-- /contents -->

    </div>
    </div>
    </form>
    <form name="viewForm2" method="post" action="" style="margin:0px">
        <!-- �亯 ������ ���� Parameter ���� -->
        <input type="hidden" name="ReqBoxID" value="<%=objRsRI.getObject("REQ_BOX_ID") %>">
        <input type="hidden" name="ReqID" value="<%= (String)objParams.getParamValue("ReqID") %>">
        <input type="hidden" name="AnsID">
        <input type="hidden" name="WinType" value="POPUP" %>
        <input type="hidden" name="ReturnURL" value="<%=request.getRequestURI()%>?ReqBoxID=<%=objRsRI.getObject("REQ_BOX_ID")%>&ReqID=<%=(String)objParams.getParamValue("ReqID")%>&AuditYear=<%=objParams.getParamValue("AuditYear")%>">
        <input type="hidden" name="ReqOpenCL" value="">
    </form>
<jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>