<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.pf.util.PageCount"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.params.requestbox.SCommReqBoxVListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.SMemReqBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.SCommRequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.common.page.PagingDelegate" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<jsp:include page="/inc/header.jsp" flush="true"/>
<%
	UserInfoDelegate objUserInfo = null;
	CDInfoDelegate objCdinfo = null;
%>
<%
	/*** PagingDelegate */
	PagingDelegate objPaging=new PagingDelegate(); 		/*����¡ ��ȯ Delegate*/
%>
<%@ include file="../../common/RUserCodeInfoInc.jsp" %>

<%
	// 2004-05-11 �߰��� �Ķ����
	// �亯 ����� ��� �Ϸ�Ǹ� �ڵ����� �亯�� �߼� â�� ����.
	String strStartAnsDocSend = StringUtil.getEmptyIfNull(request.getParameter("startAnsDocSend"));

	/**�Ϲ� �䱸�� �󼼺��� �Ķ���� ����.*/
	SCommReqBoxVListForm objParams = new SCommReqBoxVListForm();
	objParams.setParamValue("IsRequester",String.valueOf(objUserInfo.isRequester()));//�䱸�亯�ڿ��μ���

	boolean blnParamCheck = false;
	/**���޵� �ĸ����� üũ */
	blnParamCheck = objParams.validateParams(request);
	if(blnParamCheck == false){
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
	SCommRequestBoxDelegate objReqBox = null; 		/**�䱸�� Delegate*/
	ResultSetSingleHelper objRsSH = null;			/** �䱸�� �󼼺��� ���� */
	ResultSetHelper objRs = null;					/**�䱸 ��� */
	String strReqBoxID = (String)objParams.getParamValue("ReqBoxID");
	SMemReqBoxDelegate selfDelegate = null;

	// ���� �䱸���� �䱸�� ��ϵ� �亯 ����
	int intTotalAnsCount = 0;

	try {
		/**�䱸�� ���� �븮�� New */
		objReqBox = new SCommRequestBoxDelegate();
		selfDelegate = new SMemReqBoxDelegate();

		/**�䱸�� �̿� ���� üũ */
		/*
		List objUserCmtList = (List)objUserInfo.getCurrentCMTList();
		boolean blnHashAuth = objReqBox.checkReqBoxAuth(strReqBoxID, objUserCmtList).booleanValue();
		for(int i=0; i<objUserCmtList.size(); i++) {
			Hashtable objABC = (Hashtable)objUserCmtList.get(i);
			for(Enumeration enum = objABC.keys(); enum.hasMoreElements();){
				String strKey=(String)enum.nextElement();
				String strValue = (String)objABC.get(strKey);
				if(strKey.equalsIgnoreCase("ORGAN_ID")){
					out.println(strValue);
				}
			}
		}
		if(!blnHashAuth) {
			objMsgBean.setMsgType(MessageBean.TYPE_WARN);
			objMsgBean.setStrCode("DSAUTH-0001");
			objMsgBean.setStrMsg("�ش� �䱸���� �� ������ �����ϴ�.");
			out.println("�ش� �䱸���� �� ������ �����ϴ�.");
		*/
%>
			<!-- jsp:forward page="/common/message/ViewMsg.jsp"/ -->
<%
		/*
			return;
		}
		*/

		/** �䱸�� ���� */
		objRsSH = new ResultSetSingleHelper(objReqBox.getRecord(strReqBoxID, objUserInfo.getUserID()));
		/** �䱸 ���� �븮�� New */
		objRs = new ResultSetHelper((Hashtable)objReqBox.getReqRecordList(objParams));

		// ���� �䱸���� ��ϵ� �䱸�� �亯 ������??
		intTotalAnsCount = selfDelegate.checkReqInfoAnsIsNull(strReqBoxID);

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

	/**�䱸���� �����ȸ�� ��� ��ȯ.*/
	int intTotalRecordCount=objRs.getTotalRecordCount();
	int intCurrentPageNum=objRs.getPageNumber();
	int intTotalPage=objRs.getTotalPageCount();
%>

<link href="/css2/style.css" rel="stylesheet" type="text/css">
<style type="text/css">
	.tooltip_text, .tooltip_close{
		cursor: pointer;
	}
	div.tooltip {
		
		position:absolute;
	}
</style>
<script language="javascript">
  /** �䱸�Ը������ ���� */
  function gotoList(){
  	form=document.formName;
  	form.action="./SCommReqBoxList.jsp";
  	form.target = "";
  	form.submit();
  }

  /** �䱸�󼼺���� ���� */
  function gotoDetail(strID){
  	form=document.formName;
	form.ReqID.value = strID;
  	form.action="./SCommReqInfoVList.jsp";
  	form.target = "";
  	form.submit();
  }

  function gotoView(){
  	form=document.formName;
  	form.action="./SCommAnsInfoWrite.jsp";
  	form.target = "";
  	form.submit();
  }

  	// �亯�� �߼�
	function sendAnsDoc() {
		var f = document.formName;
		f.action = "/reqsubmit/common/AnsDocSend.jsp?ReqBoxID=<%= strReqBoxID %>";
		f.target = "popwin";
		f.ReturnURL.value = "/reqsubmit/20_comm/20_reqboxsh/SCommReqBoxList.jsp?ReqBoxID=<%= strReqBoxID %>";
		NewWindow('/blank.html', 'popwin', '470', '300');
		f.submit();
		//window.open('/reqsubmit/common/AnsDocSend.jsp?ReqBoxID=<%= strReqBoxID%>', '', 'width=450,height=300, scrollbars=no, resizable=yes, toolbar=no, menubar=no, location=no, directories=no, status=no');
	}

  /** ���Ĺ�� �ٲٱ� */
  function changeSortQuery(sortField,sortMethod){
  	form=document.formName;
  	form.ReqInfoSortField.value=sortField;
  	form.ReqInfoSortMtd.value=sortMethod;
  	form.target = "";
  	form.submit();
  }

  function cantAnsDocPreview() {
		alert("��ϵ� �亯�� �����Ƿ�, �亯�� �̸����⸦ �Ͻ� �� �����ϴ�.");
	}

	// �亯�� �߼��� �� �� ��ϵ� �亯�� �ϳ��� ������ �߼��� ���Ѵٴ� �޼����� �����ش�.
  	function alertSendAnsDocMessage() {
  		alert("�亯�� ��ϵ��� ���� �䱸�� �ֽ��ϴ�.\nȮ�� �� �亯����� �Ͻð� �亯���� �߼��� �ֽñ� �ٶ��ϴ�.");
  	}

	// ����¡ �ٷΰ���
  	function goPage(strPage){
  		f = document.formName;
  		f.ReqInfoPage.value = strPage;
  		f.target = "";
  		f.action ="<%=request.getRequestURI()%>";
  		f.submit();
  	}

  	/**
  	 * 2005-10-20 kogaeng ADD
  	 * üũ�ڽ��� �ϳ��� �����ϰ� �ϴ� ��ũ��Ʈ
  	 */
  	function checkBoxValidate(cb) {
		if(<%= intTotalRecordCount %> == 1) {
			if(cb == 0) {
				//document.formName.ReqInfoID.checked = true;
				//document.formName.ReqID.value = document.formName.ReqInfoID.value;
				return;
			}
		}
		for (j = 0; j < <%= objRs.getRecordSize() %>; j++) {
			if (document.formName.ReqInfoID[j].checked == true) {

				document.formName.ReqInfoID[j].checked = false;
				if (j == cb) {

					document.formName.ReqInfoID[j].checked = true;
					document.formName.ReqID.value = document.formName.ReqInfoID[j].value;
				} else {
					document.formName.ReqInfoID[j].checked = false;
					document.formName.ReqID.value = "";
				}
			}
		}
	}

  	// �亯 �ۼ� ȭ������ �̵�
  	function goSbmtReqForm() {
  		var cnt = 0;
		if(<%= intTotalRecordCount %> == 1) {
			if(eval("document.formName.ReqInfoID.checked") == true) {
                cnt = 1;
				document.formName.ReqID.value = document.formName.ReqInfoID.value;
				//��������� �߰�
				document.formName.ReqOpenCL.value = document.formName.OpenCL.value;
            }
		} else {
			for (j = 0; j < <%= objRs.getRecordSize() %>; j++) {
				if (eval("document.formName.ReqInfoID[" + j + "].checked") == true) {
					document.formName.ReqID.value = document.formName.ReqInfoID[j].value;
					//��������� �߰�
					document.formName.ReqOpenCL.value = document.formName.OpenCL[j].value;
					cnt++;
				}
			}
		}
  		if(cnt == 0) {
  			alert("�䱸�� �����Ͻ� �Ŀ� ��ư�� �ٽ� Ŭ���� �ּ���");
  			return;
  		}
  		f = document.formName;
		f.target = "newpopup";
		f.action = "/reqsubmit/common/SAnsInfoWrite.jsp";
		var winl = (screen.width - 600) / 2;
		var winh = (screen.height - 600) / 2;
		window.open("/blank.html","newpopup","resizable=no,menubar=no,status=no,titlebar=no,scrollbars=no,location=no,toolbar=no,height=600,width=595, left="+winl+", top="+winh);
		f.submit();
  	}
  	// �亯 �ۼ� ȭ������ �̵�
  	function goSbmtReqForm_old() {
  		var cnt = 0;
		if(<%= intTotalRecordCount %> == 1) {
			if(eval("document.formName.ReqInfoID.checked") == true) {
                cnt = 1;
				document.formName.ReqID.value = document.formName.ReqInfoID.value;
				//��������� �߰�
				document.formName.ReqOpenCL.value = document.formName.OpenCL.value;
            }
		} else {
			for (j = 0; j < <%= objRs.getRecordSize() %>; j++) {
				if (eval("document.formName.ReqInfoID[" + j + "].checked") == true) {
					document.formName.ReqID.value = document.formName.ReqInfoID[j].value;
					//��������� �߰�
					document.formName.ReqOpenCL.value = document.formName.OpenCL[j].value;
					cnt++;
				}
			}
		}
  		if(cnt == 0) {
  			alert("�䱸�� �����Ͻ� �Ŀ� ��ư�� �ٽ� Ŭ���� �ּ���");
  			return;
  		}
  		f = document.formName;
		f.target = "newpopup";
		f.action = "/reqsubmit/common/SAnsInfoWrite_old.jsp";
		var winl = (screen.width - 550) / 2;
		var winh = (screen.height - 350) / 2;
		window.open("/blank.html","newpopup","resizable=yes,menubar=no,status=no,titlebar=no, scrollbars=yes,location=no,toolbar=no,height=350,width=520, left="+winl+", top="+winh);
		f.submit();
  	}

	/** �䱸 �̷º��� */
	function viewReqHistoryAAA() {
		var cnt = 0;
		if(<%= intTotalRecordCount %> == 1) {
			if(eval("document.formName.ReqInfoID.checked") == true) cnt = 1;
			else cnt = 0;
		} else {
			for (j = 0; j < <%= objRs.getRecordSize() %>; j++) {
				if (eval("document.formName.ReqInfoID[" + j + "].checked") == true) {
					document.formName.ReqID.value = document.formName.ReqInfoID[j].value;
					cnt++;
				}
			}
		}
  		if(cnt == 0) {
  			alert("�䱸�� �����Ͻ� �Ŀ� ��ư�� �ٽ� Ŭ���� �ּ���");
  			return;
  		}

		f = document.formName;
		f.target = "newpopup";
		f.action = "/reqsubmit/common/ViewReqHistory.jsp?ReqInfoID="+document.formName.ReqID.value;
		var winl = (screen.width - 540) / 2;
		var winh = (screen.height - 450) / 2;
		window.open("/blank.html","newpopup","resizable=yes,menubar=no,status=no,titlebar=no, scrollbars=yes,location=no,toolbar=no,height=450,width=540, left="+winl+", top="+winh);
		f.submit();
		/*
  		var popModal = window.showModalDialog('/reqsubmit/common/ViewReqHistory.jsp?ReqInfoID='+document.formName.ReqID.value,
  																'', 'dialogWidth:540px;dialogHeight:450px; center:yes; help:no; status:no; scroll:yes; resizable:yes');
  		*/
	}


	// �亯 �ۼ� ȭ������ �̵�
  	function offlineSubmit() {
  		f = document.formName;
  	//��������� �߰�
  	//f.ReqOpenCL.value = f.OpenCL.value;
                var cnt = 0;
		if(<%= intTotalRecordCount %> == 1) {
                cnt = 1;
				f.ReqOpenCL.value = f.OpenCL.value;
		} else {
			for (j = 0; j < <%= objRs.getRecordSize() %>; j++) {
					f.ReqOpenCL.value = f.OpenCL[0].value;
			}
		}
		f.target = "newpopup";
		f.action = "/reqsubmit/common/OffLineDocSend.jsp";
		var winl = (screen.width - 550) / 2;
		var winh = (screen.height - 350) / 2;
		window.open("/blank.html","newpopup","resizable=yes,menubar=no,status=no,titlebar=no, scrollbars=yes,location=no,toolbar=no,height=350,width=520, left="+winl+", top="+winh);
		f.submit();
  	}

</script>
<script type="text/javascript">
	$(document).ready(function(){
		//alert ('jQuery running');
		
		/* �⺻ ������ ���� */
		var defaults = {
			w : 170, /*���̾� �ʺ�*/
			padding: 0,
			bgColor: '#F6F6F6',
			borderColor: '#333'
		};
		
		var options = $.extend(defaults, options);
		
		/* ���̾� â �ݱ� */
		$(".tooltip_close").click(function(){
			$(this).parents(".tooltip").css({display:'none'});
		});
		
		/* ���콺 ������ */
		$('span.tooltip_text').hover(
			function(over){

				var top = $(this).offset().top;
				var left = $(this).offset().left;
				
				$(".tooltip").css({display:'none'});
				
				$(this).next(".tooltip").css({
					display:'',
					top:  top + 20 + 'px',
					left: left + 'px',
					background : options.bgColor,
					padding: options.padding,
					paddingRight: options.padding+1,
					width: (options.w+options.padding)
				});
				
				
			},
			/* ���콺 �ƿ��� */			   
			function(out){
				//$(this).html(currentText);
				//$('#link-text').pa
			}
		);
		
		


		
	});
	
	function test(){
		//$("button").next().css()
		//$("button").css({top});
	}
</script>
</head>

<body <% if("Y".equalsIgnoreCase(strStartAnsDocSend)) { %>
 onLoad="javascript:sendAnsDoc()"
<% } %>>
<div id="wrap">
<div id="balloonHint" style="display:none;height:100px">
<table border="0" cellspacing="0" cellpadding="4">
	<tr>
		<td bgcolor="#EBF2F5" width="30" height="20" align="center" style="border-left:1px solid #808080;border-top:1px solid #808080;border-bottom:2px solid #808080;"><font style="font-size:11px;font-family:verdana,����;font-weight:bold">�䱸<BR>��<BR>����</font></td>
		<td style="border-left:1px solid #808080;border-top:1px solid #808080;border-bottom:2px solid #808080;border-right:2px solid #808080;text-align:justify;word-break:break-all;" width="220">
			<font style="font-size:11px;font-family:verdana,����">{{hint}}</font>
		</td>
	</tr>
</table>
</div>
<SCRIPT language="JavaScript" src="/js2/reqsubmit/tooltip.js"></SCRIPT>
<script language="javascript">balloonHint("balloonHint")</script>
  <jsp:include page="/inc/top.jsp" flush="true"/>
  <jsp:include page="/inc/top_menu02.jsp" flush="true"/>
  <div id="container">
    <div id="leftCon">
      <jsp:include page="/inc/log_info.jsp" flush="true"/>
      <jsp:include page="/inc/left_menu02.jsp" flush="true"/>
	<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>
	<SCRIPT language="JavaScript" src="/js/reqsubmit/reqinfo.js"></SCRIPT>
    </div>
    <div id="rightCon">
<form name="formName" method="post" action="<%=request.getRequestURI()%>">

		<%  //�䱸�� ���� ���� �ޱ�.
			String strReqBoxSortField=objParams.getParamValue("ReqBoxSortField");
			String strReqBoxSortMtd=objParams.getParamValue("ReqBoxSortMtd");
			//�䱸�� ������ ��ȣ �ޱ�.
			String strReqBoxPagNum=objParams.getParamValue("ReqBoxPageNum");
			//�䱸�� ��ȸ���� �ޱ�.
			String strReqBoxQryField=objParams.getParamValue("ReqBoxQryField");
			String strReqBoxQryTerm=objParams.getParamValue("ReqBoxQryTerm");

			//�䱸 ���� ���� ���� �ޱ�.
			String strReqInfoSortField=objParams.getParamValue("ReqInfoSortField");
			String strReqInfoSortMtd=objParams.getParamValue("ReqInfoSortMtd");
			//�䱸�� ���� ������ ��ȣ �ޱ�.
			String strReqInfoPagNum=objParams.getParamValue("ReqInfoPageNum");
		%>
	    <input type="hidden" name="ReqBoxID" value="<%=objParams.getParamValue("ReqBoxID")%>">
	    <input type="hidden" name="AuditYear" value="<%=objParams.getParamValue("AuditYear")%>">
		<input type="hidden" name="ReqBoxSortField" value="<%=strReqBoxSortField%>"><!--�䱸�Ը�������ʵ� -->
		<input type="hidden" name="ReqBoxSortMtd" value="<%=strReqBoxSortMtd%>"><!--�䱸�Ը�����ɹ��-->
		<input type="hidden" name="ReqBoxPage" value="<%=strReqBoxPagNum%>"><!--�䱸�� ������ ��ȣ -->
		<input type="hidden" name="ReqInfoSortField" value="<%=strReqInfoSortField%>"><!--�䱸���� ��������ʵ� -->
		<input type="hidden" name="ReqInfoSortMtd" value="<%=strReqInfoSortMtd%>"><!--�䱸���� ������ɹ��-->
		<input type="hidden" name="ReqInfoPage" value="<%=strReqInfoPagNum%>"><!--�䱸���� ������ ��ȣ -->
		<input type="hidden" name="ReqID" value=""> <!-- �䱸 ID -->
		<input type="hidden" name="ReturnURLFLAG" value="CMT">
		<input type="hidden" name="ReturnURL" value="<%= request.getRequestURI() %>?ReqBoxID=<%= strReqBoxID %>">
		<input type="hidden" name="ReqOpenCL" value="">
      <!-- pgTit -->

      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=MenuConstants.REQ_BOX_MAKE%><span class="sub_stl" >- <%=MenuConstants.REQ_BOX_DETAIL_VIEW%></span></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> > <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.REQUEST_BOX_COMM%> > <%=MenuConstants.REQ_BOX_MAKE%></div>
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
<%
	//������ �䱸��(�����Ϸ�-��������,�䱸�Ը��)
	//�����Ϸ� �䱸��((�䱸������,����׹߼�,(�䱸�Ի���)-��������,�䱸�Ը��)-��ư���ٸ���)
	//�߼ۿϷ�䱸��(�䱸������-��������,�䱸�Ը��)
	//����Ϸ�䱸��(�䱸������,���⹮������-��������,�䱸�Ը��)
	String strAnsDocURL = null;
	String strAnsDocPreviewScriptURL = null;
	if (intTotalAnsCount == 0) {
		strAnsDocURL = "javascript:sendAnsDoc()";
		strAnsDocPreviewScriptURL = "javascript:PreAnsDocView(formName,'"+objRsSH.getObject("REQ_BOX_ID")+"')";
	} else {
		strAnsDocURL = "javascript:alertSendAnsDocMessage()";
		if(intTotalAnsCount == intTotalRecordCount){
			strAnsDocPreviewScriptURL = "javascript:cantAnsDocPreview()";
		} else {
			strAnsDocPreviewScriptURL = "javascript:PreAnsDocView(formName,'"+objRsSH.getObject("REQ_BOX_ID")+"')";
		}
	}
%>
			<span class="btn"><a href="javascript:gotoList()">�䱸�� ���</a></span>
			<span class="btn"><a href="javascript:submtBindingJob(formName,'<%=objRsSH.getObject("REQ_BOX_ID")%>')">���ε�</a></span>
		</samp></div>



        <table border="0" cellspacing="0" cellpadding="0" width="680" class="list02">
	<%
		//�䱸�� ���� ����.
		String strIngStt=(String)objRsSH.getObject("ING_STT");
	%>
            <tr>
                <th width="100px;" height="25">&bull; �䱸�Ը� </th>
                <td height="25" colspan="3"><%=objRsSH.getObject("REQ_BOX_NM")%>
      				<%
		   				// 2004-06-17 ADD
		   				String strElcDocNo = (String)objRsSH.getObject("DOC_NO");
						if (StringUtil.isAssigned(strElcDocNo)) {
		                    out.println(" (���ڰ����ȣ : "+strElcDocNo+")");
   						}
       				%>	</td>
            </tr>
            <tr>
                <th height="25">&bull; �Ұ� ����ȸ </th>
                <td height="25" colspan="3">- <%= objRsSH.getObject("CMT_ORGAN_NM") %> </td>
            </tr>
            <tr>
                <th height="25">&bull; �������� </th>
                <td height="25" colspan="3"><%= objCdinfo.getRelatedDuty((String)objRsSH.getObject("RLTD_DUTY")) %> </td>
            </tr>
            <tr>
                <th scope="col">&bull;&nbsp;�߼����� </th>
			  <td colspan="3">
				 <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list_none">
					 <tr>
						 <td width="17" rowspan="2"><img src="/images2/common/icon_assembly.gif" width="16" height="13" /></td>
						 <td><%=(String)objRsSH.getObject("REQ_ORGAN_NM")%></td>
						 <td rowspan="2"><img src="/images2/common/arrow01.gif" width="26" height="14" /></td>
						 <td width="15" rowspan="2"><img src="/images2/common/icon_cube.gif" width="11" height="15" /></td>
						 <td><%=(String)objRsSH.getObject("SUBMT_ORGAN_NM")%></td>
					 </tr>
					 <tr>
						 <td class="fonts"><%=(String)objRsSH.getObject("REGR_NM")%> (<a href="mailto:<%=(String)objRsSH.getObject("REGR_EMAIL")%>"><%=(String)objRsSH.getObject("REGR_EMAIL")%></a> / <%=(String)objRsSH.getObject("REGR_CPHONE")%>)</td>
						 <td class="fonts"><%=(String)objRsSH.getObject("RCVR_NM")%></td>
					 </tr>
				 </table>
			</td>
            </tr>
            <tr>
                <th scope="col">&bull;&nbsp;�䱸���̷� </th>  <td colspan="3">
                <ul class="list_in">
				  <li><span class="tl">&bull;&nbsp;�䱸�Ի����Ͻ� :</span> <%=StringUtil.getDate2((String)objRsSH.getObject("REG_DT"))%></li>
				  <li><span class="tl">&bull;&nbsp;�䱸�� ������ :</span> <%=StringUtil.getDate2((String)objRsSH.getObject("LAST_REQ_DOC_SND_DT"))%></li>
				  <li><span class="tl">&bull;&nbsp;������ ��ȸ�� :</span> <%=StringUtil.getDate2((String)objRsSH.getObject("FST_QRY_DT"))%></li>
				  <li><span class="tl">&bull;&nbsp;������� :</span> <%=StringUtil.getDate((String)objRsSH.getObject("SUBMT_DLN"))%> 24:00</li>

              </ul>
              </td>
            </tr>
			<tr>
              <th scope="col">&bull;&nbsp;�䱸�Լ��� </th>   <td colspan="3"><%= objRsSH.getObject("REQ_BOX_DSC") %></td>
            </tr>
        </table>
        <!-- /list view -->
 <p class="warning mt10">* ��� �亯�� �ۼ��Ͻ� ���, �ݵ�� �Ʒ��� '�亯�� �߼�'  �۾��� ������ �ֽñ� �ٶ��ϴ�. </p>
        <!-- ����Ʈ ��ư-->
         <div id="btn_all"><div  class="t_right">
			 <div class="mi_btn" style="float:right"><a href="javascript:ReqDocOpenView('<%=strReqBoxID%>','002')"><span>�䱸�� ����</span></a></div>
			 <div class="mi_btn" style="float:right"><a href="<%= strAnsDocPreviewScriptURL %>"><span>�亯�� �̸�����</span></a></div>
<%
	//���� ����
	if(!strReqSubmitFlag.equals("004")){
%>
		     <div class="mi_btn" style="float:right"><a href="<%= strAnsDocURL %>"><span>�亯�� �߼�</span></a></div>
			 <div class="mi_btn" style="float:right"><a href="javascript:offlineSubmit()"><span>�������� ����</span></a></div>
		 </div></div>

        <!-- /����Ʈ ��ư-->

        <!-- list -->
        <span class="list01_tl">�䱸��� <span class="list_total">&bull;&nbsp;��ü�ڷ�� : <%= intTotalRecordCount %>�� (<%= intCurrentPageNum %>/<%= intTotalPage %> page) </span></span>
        <table width="100%" style="padding:0;">
           <tr>
            <td>&nbsp;</td>
           </tr>
        </table>
        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
          <thead>
            <tr>
               <th scope="col">
			  </th>
              <th scope="col" style="width:10px;"><a>NO</a></th>
              <th scope="col" style="width:250px;"><%= SortingUtil.getSortLink("changeSortQuery", "REQ_CONT", strReqInfoSortField, strReqInfoSortMtd, "�䱸����") %></th>
              <th scope="col"><%= SortingUtil.getSortLink("changeSortQuery", "REQ_STT", strReqInfoSortField, strReqInfoSortMtd, "����") %></th>
              <th scope="col"><%= SortingUtil.getSortLink("changeSortQuery", "OPEN_CL", strReqInfoSortField, strReqInfoSortMtd, "��������") %></th>
               <th scope="col"><a>�亯</a></th>
              <th scope="col"><a>÷��</a></th>
			  <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery", "LAST_ANS_DT", strReqInfoSortField, strReqInfoSortMtd, "�䱸����")%></th>
            </tr>
          </thead>
          <tbody>
		<%
			int intRecordNumber= intTotalRecordCount - ((intCurrentPageNum -1) * Integer.parseInt((String)objParams.getParamValue("ReqInfoPageSize")));
			int strNumber = intRecordNumber;
			int strNumberNo = intRecordNumber;
			String strReqInfoID = "";

			if(objRs.getRecordSize()>0){
				while(objRs.next()){
					strReqInfoID = (String)objRs.getObject("REQ_ID");
			%>
            <tr>
			  <td>
			  <input type="checkbox" name="ReqInfoID" value="<%= strReqInfoID %>" class="borderNo" onClick="javascript:checkBoxValidate(<%= (intRecordNumber-strNumber) %>)"/>
			  <input name="OpenCL" type="hidden" value="<%= (String)objRs.getObject("OPEN_CL") %>" />
			  </td>
              <td><%= strNumberNo %></td>
              <td style="text-align:left;"><a href="javascript:gotoDetail('<%= objRs.getObject("REQ_ID") %>')" hint="<%= StringUtil.substring((String)objRs.getObject("REQ_DTL_CONT"), 80) %>"><%= objRs.getObject("REQ_CONT") %></a>
			  </td>

              <td><%= CodeConstants.getRequestStatus((String)objRs.getObject("REQ_STT")) %>
			  </td>
              <td><%= CodeConstants.getOpenClass((String)objRs.getObject("OPEN_CL")) %>
			  </td>              
			  <td>
			  <span class="tooltip_text"><%=this.makeAnsInfoImg((String)objRs.getObject("ANS_ID"),(String)objRs.getObject("ANS_MTD"),(String)objRs.getObject("ANS_OPIN"),(String)objRs.getObject("SUBMT_FLAG"),objUserInfo.isRequester(),"","_blank","")%></span> 
				<div class="tooltip" style="display:none;">
					<table width=100% height=100%>
					  <tr>
					   <td width=100% height=5% style="align:right">
						<img src="/images/bt-close.gif" style="cursor:hand" align="absmiddle" border="0" class="tooltip_close">
					   </td>
					  </tr>
					  <tr> 
					   <td  bgcolor="#FFFFFF" align="left" ><%=this.makeAnsInfoHtml2((String)objRs.getObject("ANS_ID"),(String)objRs.getObject("ANS_MTD"),(String)objRs.getObject("ANS_OPIN"),(String)objRs.getObject("SUBMT_FLAG"),objUserInfo.isRequester(),"","_blank","")%></td>
					  </tr>
					 </table>
				</div>
			  </td>
              <td><%=makeAttachedFileLink((String)objRs.getObject("ANS_ESTYLE_FILE_PATH"))%></td>
              <td><%= StringUtil.getDate2((String)objRs.getObject("LAST_REQ_DT")) %></td>
            </tr>
			<%
				strNumberNo--;
				intRecordNumber++;
				} //endwhile
			} else {
			%>
            <tr>
				<td colspan="7" align="center"> ��ϵ� �亯�� �����ϴ�.</td>
            </tr>
			<%
				}//�߰� �亯 ���
			%>
          </tbody>
        </table>
 <p class="warning mt10">* ��� �亯�� �ۼ��Ͻ� ���, �ݵ�� �Ʒ��� '�亯�� �߼�'  �۾��� ������ �ֽñ� �ٶ��ϴ�. </p>
	    <%
			//���� ����
			if(!strReqSubmitFlag.equals("004")){
		%>
        <div id="btn_all" class="t_right" >
			<span class="list_bt"><a href="javascript:goSbmtReqForm_old()">�亯 �ۼ�</a></span>
			<span class="list_bt"><a href="javascript:goSbmtReqForm()">��뷮���ϵ��</a></span>
			<span class="list_bt"><a href="javascript:viewReqHistoryAAA()">�䱸�̷º���</a></span>
        </div>
		<% } %>

				<%=objPaging.pagingTrans(PageCount.getLinkedString(
						new Integer(intTotalRecordCount).toString(),
						new Integer(intCurrentPageNum).toString(),
						objParams.getParamValue("ReqInfoPageSize")))
					%>
        <!-- /����Ʈ �� �˻� -->
		<%
			}
		%>

        <!-- /list -->


        <!-- /�������� ���� -->
      </div>
</form>
      <!-- /contents -->

    </div>
  </div>
<%!
	public String makeAttachedFileLink(String strFileName){
		String strReturnURL = null;
		if(!StringUtil.isAssigned(strFileName)){
			//���ϰ�ΰ� ������ �⺻ ���ϰ�η� ��ġ��.
			strReturnURL = "";
			//strFileName=nads.lib.reqsubmit.EnvConstants.getConstFilePath();
		} else {
			strReturnURL = "<a href=\"/reqsubmit/common/AttachStyleFileDownload.jsp?path=" + strFileName+ "\"><img src=\"/image/common/icon_etc.gif\" border=\"0\"></a>";
		}
		return strReturnURL;
	}

%>
  <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>
<%!

	public static String makeAnsInfoHtml2(String strAnsIDs,String strAnsMtds,String strAnsOpins,String strSubmtFlags, boolean blnIsRequester,String strKeywords,String strLinkTarget,String strSummary){
		if(strLinkTarget.equals("0")){
			strLinkTarget="_blank";
		}else if(strLinkTarget.equals("1")){
			strLinkTarget="_self";
		}
		String strMsgSummary=StringUtil.getEmptyIfNull(strSummary,"PDF����");
		String strTop="";		//��¿� ��� ���ڿ�<a><talbe>
		String strMiddle="";	//��¿� �߰� <tr></tr>+
		String strBottom="";	//��¿� �ϴ� ���ڿ�..</table></a>
		if(strAnsIDs==null || strAnsIDs.trim().equals("")){
			return "";//�亯���� ������.
		}
		if(strAnsOpins!=null){
			strAnsOpins=strAnsOpins.replaceAll("'"," ");
			strAnsOpins=strAnsOpins.replaceAll("\""," ");
		}else{
			strAnsOpins="";
		}
		StringTokenizer strTokenAnsIDs=new StringTokenizer(strAnsIDs,",");
		StringTokenizer strTokenAnsMtds=new StringTokenizer(strAnsMtds,",");
		StringTokenizer strTokenAnsOpins=new StringTokenizer(strAnsOpins,",");
		StringTokenizer strTokenSubmtFlags=new StringTokenizer(strSubmtFlags,",");
		StringBuffer strBufReturn=new StringBuffer();
		String strAnsID=null;
		String strAnsMtd=null; 
		String strAnsOpin=null;
		String strSubmtFlag="Y";
		int intAnsCount=0;
		
		while(strTokenAnsIDs.hasMoreElements()&& strTokenAnsMtds.hasMoreElements() && strTokenSubmtFlags.hasMoreElements() ){
			strAnsID=strTokenAnsIDs.nextToken();
			strAnsMtd=strTokenAnsMtds.nextToken();
			strSubmtFlag=strTokenSubmtFlags.nextToken();
			try{
				if(strTokenAnsOpins.hasMoreElements()){
					strAnsOpin=strTokenAnsOpins.nextToken();
				}else{
					strAnsOpin="";
				}
			}catch(NoSuchElementException ex){
				strAnsOpin="";
			}
			strAnsOpin=StringUtil.getEmptyIfNull(strAnsOpin);
			strAnsOpin=strAnsOpin.replace('\n',' ');
			strAnsOpin=strAnsOpin.replace('\r',' ');
			//�䱸��(true)�̸鼭 �亯�Ϸ�(Y) �̰ų� ������(false)�̸� �亯���� ���̰��ϱ�.
			if((blnIsRequester && strSubmtFlag.equalsIgnoreCase("Y")) || blnIsRequester==false){
				//<tr>����
				if(strAnsMtd.equals(CodeConstants.ANS_MTD_ELEC)){
					strBufReturn.append("<img src='/image/reqsubmit/bt_EDoc.gif' width='73' height='16' border='0' alt='" + strAnsOpin + "'>");
					if(StringUtil.isAssigned(strKeywords)){
						strBufReturn.append("<a href='/reqsubmit/common/ReqFileOpenHL.jsp?ansID=" + strAnsID + "&keyword=" +  strKeywords+ "&DOC=PDF' target='" + strLinkTarget + "'>");						
					}else{
						strBufReturn.append("<a href='/reqsubmit/common/ReqFileOpen.jsp?paramAnsId=" + strAnsID + "&DOC=PDF' target='" + strLinkTarget + "'>");
					}
					/** ���ŵ� 2004.05.13
					if(intAnsCount>0){//ó���ѹ��� ��๮ �����شٰ���.
						strMsgSummary="PDF����";
					}
					 */
					strBufReturn.append("<img src='/image/common/icon_pdf.gif' width='16' height='16' border='0' alt='" + strMsgSummary + "'>");
					strBufReturn.append("</a>");
					strBufReturn.append("&nbsp;<a href='/reqsubmit/common/ReqFileOpen.jsp?paramAnsId=" + strAnsID + "&DOC=DOC' target='_self'>");
					strBufReturn.append("<img src='/image/common/icon_file.gif' border='0' alt='��������'>");
					strBufReturn.append("</a>");
					strBufReturn.append("<br>");
				}else if(strAnsMtd.equals(CodeConstants.ANS_MTD_ETCS)){
					strBufReturn.append("<img src='/image/reqsubmit/bt_NotEDoc.gif' width='73' height='16' border='0' alt='" + strAnsOpin + "'>");
					strBufReturn.append("<br>");					
				}else if(strAnsMtd.equals("004")){
					strBufReturn.append("<img src='/image/reqsubmit/bt_offLineSubmit.gif' width='73' height='16' border='0' alt='���������� ���� ����'>");
					strBufReturn.append("<br>");					
				}else {
					strBufReturn.append("<img src='/image/reqsubmit/bt_NotPertinentOrg.gif' width='73' height='16' border='0' alt='" + strAnsOpin + "'>");
					strBufReturn.append("<br>");					
				}
				//</tr>�� 
				intAnsCount++; //�亯���� ī��Ʈ �ø�.
			}
		}
		
		strMiddle=strBufReturn.toString();//�߰����ڿ� �ޱ�.
		

		
		//�亯���� ��µ� ������ ������ ���.
		if(intAnsCount>0){
			return  strMiddle;
		}else{
			return "";//�亯���� ������.
		}
	}

	public static String makeAnsInfoImg(String strAnsIDs,String strAnsMtds,String strAnsOpins,String strSubmtFlags, boolean blnIsRequester,String strKeywords,String strLinkTarget,String strSummary){
		
		if(strAnsIDs==null || strAnsIDs.trim().equals("")){
			return "<img src='/image/reqsubmit/icon_noAnswer.gif' border='0'>";//�亯���� ������.
		}		
		
		
		StringTokenizer strTokenAnsIDs=new StringTokenizer(strAnsIDs,",");
		StringTokenizer strTokenAnsMtds=new StringTokenizer(strAnsMtds,",");
		StringTokenizer strTokenAnsOpins=new StringTokenizer(strAnsOpins,",");
		StringTokenizer strTokenSubmtFlags=new StringTokenizer(strSubmtFlags,",");
		StringBuffer strBufReturn=new StringBuffer();
		String strAnsID=null;
		String strAnsMtd=null; 
		String strAnsOpin=null;
		String strSubmtFlag="Y";
		int intAnsCount=0;
		
		while(strTokenAnsIDs.hasMoreElements()&& strTokenAnsMtds.hasMoreElements() && strTokenSubmtFlags.hasMoreElements() ){	
			strAnsID=strTokenAnsIDs.nextToken();
			strAnsMtd=strTokenAnsMtds.nextToken();
			strSubmtFlag=strTokenSubmtFlags.nextToken();
			try{
				if(strTokenAnsOpins.hasMoreElements()){
					strAnsOpin=strTokenAnsOpins.nextToken();
				}else{
					strAnsOpin="";
				}
			}catch(NoSuchElementException ex){
				strAnsOpin="";
			}
			//�䱸��(true)�̸鼭 �亯�Ϸ�(Y) �̰ų� ������(false)�̸� �亯���� ���̰��ϱ�.
			if((blnIsRequester && strSubmtFlag.equalsIgnoreCase("Y")) || blnIsRequester==false){

				intAnsCount++; //�亯���� ī��Ʈ �ø�.
			}
		}
				
		
		//�亯���� ��µ� ������ ������ ���.
		if(intAnsCount>0){
			return "<img src='/image/reqsubmit/icon_answer.gif' border='0'>";
		}else{
			return "<img src='/image/reqsubmit/icon_noAnswer.gif' border='0'>";//�亯���� ������.
		}
	}

%>
