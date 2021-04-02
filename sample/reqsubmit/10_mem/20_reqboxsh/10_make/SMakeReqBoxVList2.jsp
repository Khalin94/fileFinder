<%@ page language="java" contentType="text/html;charset=EUC-KR" %>

<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.pf.util.PageCount"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.lib.reqsubmit.params.requestbox.SMemReqBoxVListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.SMemReqBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.SMemReqInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.MemRequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.common.page.PagingDelegate" %>
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
	// 2004-05-11 �߰��� �Ķ����
	// �亯 ����� ��� �Ϸ�Ǹ� �ڵ����� �亯�� �߼� â�� ����.
	String strStartAnsDocSend = StringUtil.getEmptyIfNull(request.getParameter("startAnsDocSend"));

	SMemReqBoxDelegate selfDelegate = null;
	MemRequestBoxDelegate reqDelegate = null;
	SMemReqInfoDelegate reqInfoDelegate = null;

	SMemReqBoxVListForm objParams = new SMemReqBoxVListForm();
	//SReqInfoListForm objParams = new SReqInfoListForm();
	// �䱸�� ������ ���θ� Form�� �߰��Ѵ�
  	objParams.setParamValue("IsRequester", String.valueOf(objUserInfo.isRequester()));

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

	// �䱸 ���� �� ����¡ ����
	int intTotalRecordCount = 0;
	int intCurrentPageNum = 0;
	int intTotalPage = 0;

	// ���� �䱸���� �䱸�� ��ϵ� �亯 ����
	int intTotalAnsCount = 0;

	ResultSetSingleHelper objRsSH = null;
	ResultSetHelper objRs = null;

	try{
		selfDelegate = new SMemReqBoxDelegate();
	   	reqDelegate = new MemRequestBoxDelegate();
	   	reqInfoDelegate = new SMemReqInfoDelegate();

	   	boolean blnHashAuth = reqDelegate.checkReqBoxAuth(strReqBoxID, objUserInfo.getOrganID()).booleanValue();

	   	if(!blnHashAuth) {
	   		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	  		objMsgBean.setStrCode("DSAUTH-0001");
  	  		objMsgBean.setStrMsg("�ش� �䱸���� �� ������ �����ϴ�.");
  	  		out.println("�ش� �䱸���� �� ������ �����ϴ�.");
		    return;
		} else {
	    	// �䱸�� ��� ������ SELECT �Ѵ�.
	    	objRsSH = new ResultSetSingleHelper(selfDelegate.getRecord(strReqBoxID, objUserInfo.getUserID()));

	    	// �䱸 ����� SELECT �Ѵ�.
	    	objRs = new ResultSetHelper(reqInfoDelegate.getRecordList(objParams));

	    	// ���� �䱸���� ��ϵ� �䱸�� �亯 ������??
	    	intTotalAnsCount = selfDelegate.checkReqInfoAnsIsNull(strReqBoxID);

	    	 /**�䱸���� �����ȸ�� ��� ��ȯ.*/
			intTotalRecordCount = objRs.getTotalRecordCount();
 			intCurrentPageNum = objRs.getPageNumber();
 			intTotalPage = objRs.getTotalPageCount();
			System.out.println("SIZE : "+objRs.getRecordSize());
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
<link href="/css2/style.css" rel="stylesheet" type="text/css">
<script language="javascript" src="/js/reqsubmit/common.js"></script>
<script language="javascript">
	var f;

	// �䱸�� ����
	function goReqDocView() {
		NewWindow('/reqsubmit/common/ReqDocView.jsp?ReqBoxId=<%= strReqBoxID%>&ReqTp=001', '', '800', '600');
		//window.open("/reqsubmit/common/ReqDocView.jsp?ReqBoxId=<%= strReqBoxID%>&ReqTp=001", "",	"resizable=no,menubar=no,status=yes,titlebar=yes,scrollbars=no,location=no,toolbar=no,height=600,width=800" );
	}

	// �亯�� �߼�
	function sendAnsDoc() {
		var f = document.viewForm;
		f.action = "/reqsubmit/common/AnsDocSend.jsp?ReqBoxID=<%= strReqBoxID %>";
		f.target = "popwin";
		NewWindow('/blank.html', 'popwin', '470', '300');
		f.submit();
		//window.open('/reqsubmit/common/AnsDocSend.jsp?ReqBoxID=<%= strReqBoxID%>', '', 'width=450,height=300, scrollbars=no, resizable=yes, toolbar=no, menubar=no, location=no, directories=no, status=no');
	}

	// �䱸 ��� ��ȸ
	function goReqBoxList() {
		f = document.viewForm;
		f.action = "SMakeReqBoxList.jsp";
		f.target = "";
		f.submit();
	}

	// ���Ĺ�� �ٲٱ�
	function changeSortQuery(sortField, sortMethod){
		f = document.viewForm;
  		f.ReqInfoSortField.value = sortField;
  		f.ReqInfoSortMtd.value = sortMethod;
  		f.target = "";
  		f.submit();
  	}

  	// �䱸 �󼼺���� ���� */
  	function gotoDetail(strID){
  		f = document.viewForm;
  		f.ReqID.value = strID;
  		f.action="SMakeReqInfoVList.jsp";
  		f.target = "";
  		f.submit();
  	}

  	// ����¡ �ٷΰ���
  	function goPage(strPage){
  		f = document.viewForm;
  		f.ReqInfoPage.value = strPage;
  		f.target = "";
  		f.submit();
  	}

  	// �亯�� �߼��� �� �� ��ϵ� �亯�� �ϳ��� ������ �߼��� ���Ѵٴ� �޼����� �����ش�.
  	function alertSendAnsDocMessage() {
  		alert("�亯�� ��ϵ��� ���� �䱸�� �ֽ��ϴ�.\nȮ�� �� �ٽ� �õ��� �ֽñ� �ٶ��ϴ�.");
  	}

  	/**
  	 * 2005-10-20 kogaeng ADD
  	 * üũ�ڽ��� �ϳ��� �����ϰ� �ϴ� ��ũ��Ʈ
  	 */
  	function checkBoxValidate(cb, strID) {
		if(<%= objRs.getRecordSize() %> == 1) {
			if(cb == 0) {
				document.viewForm.ReqInfoID.checked = true;
				document.viewForm.ReqID.value = strID;
				return;
			}
		}
		for (j = 0; j < <%= objRs.getRecordSize() %>; j++) {
			if (eval("document.viewForm.ReqInfoID[" + j + "].checked") == true) {
				document.viewForm.ReqInfoID[j].checked = false;
				if (j == cb) {
					document.viewForm.ReqInfoID[j].checked = true;
					document.viewForm.ReqID.value = strID;
				} else {
					document.viewForm.ReqInfoID[j].checked = false;
					document.viewForm.ReqID.value = "";
				}
			}
		}
	}

  	// �亯 �ۼ� ȭ������ �̵�
  	function goSbmtReqForm() {
  		var cnt = 0;
		if(<%= intTotalRecordCount %> == 1) {
			if(eval("document.viewForm.ReqInfoID.checked") == true) cnt = 1;
		} else {
			for (j = 0; j < <%= intTotalRecordCount %>; j++) {
				if (eval("document.viewForm.ReqInfoID[" + j + "].checked") == true) {
					document.viewForm.ReqID.value = document.viewForm.ReqInfoID[j].value;
					cnt++;
				}
			}
		}
  		if(cnt == 0) {
  			alert("�䱸�� �����Ͻ� �Ŀ� ��ư�� �ٽ� Ŭ���� �ּ���");
  			return;
  		}
  		f = document.viewForm;
		f.target = "newpopup";
		f.action = "/reqsubmit/common/SAnsInfoWrite.jsp";
		var winl = (screen.width - 600) / 2;
		var winh = (screen.height - 600) / 2;
		window.open("/blank.html","newpopup","resizable=no,menubar=no,status=no,titlebar=no,scrollbars=no,location=no,toolbar=no,height=530,width=595, left="+winl+", top="+winh);
		f.submit();
  	}
  	// ������-�亯 �ۼ� ȭ������ �̵�
  	function goSbmtReqForm_old() {
  		var cnt = 0;
		if(<%= intTotalRecordCount %> == 1) {
			if(eval("document.viewForm.ReqInfoID.checked") == true) cnt = 1;
		} else {
			for (j = 0; j < <%= intTotalRecordCount %>; j++) {
				if (eval("document.viewForm.ReqInfoID[" + j + "].checked") == true) {
					document.viewForm.ReqID.value = document.viewForm.ReqInfoID[j].value;
					cnt++;
				}
			}
		}
  		if(cnt == 0) {
  			alert("�䱸�� �����Ͻ� �Ŀ� ��ư�� �ٽ� Ŭ���� �ּ���");
  			return;
  		}
  		f = document.viewForm;
		f.target = "newpopup";
		f.action = "/reqsubmit/common/SAnsInfoWrite_old.jsp";
		var winl = (screen.width - 550) / 2;
		var winh = (screen.height - 350) / 2;
		window.open("/blank.html","newpopup","resizable=yes,menubar=no,status=no,titlebar=no, scrollbars=yes,location=no,toolbar=no,height=350,width=520, left="+winl+", top="+winh);
		f.submit();
  	}
	/** �䱸 �̷º��� */
	function viewReqHistory() {
		var cnt = 0;
		if(<%= intTotalRecordCount %> == 1) {
			if(eval("document.viewForm.ReqInfoID.checked") == true) cnt = 1;
		} else {
			for (j = 0; j < <%= intTotalRecordCount %>; j++) {
				if (eval("document.viewForm.ReqInfoID[" + j + "].checked") == true) {
					document.viewForm.ReqID.value = document.viewForm.ReqInfoID[j].value;
					cnt++;
				}
			}
		}

  		if(cnt == 0) {
  			alert("�䱸�� �����Ͻ� �Ŀ� ��ư�� �ٽ� Ŭ���� �ּ���");
  			return;
  		}
  		f = document.viewForm;
		f.target = "newpopup";
		f.action = "/reqsubmit/common/ViewReqHistory.jsp?ReqInfoID="+document.viewForm.ReqID.value;
		var winl = (screen.width - 540) / 2;
		var winh = (screen.height - 450) / 2;
		window.open("/blank.html","newpopup","resizable=yes,menubar=no,status=no,titlebar=no, scrollbars=yes,location=no,toolbar=no,height=450,width=540, left="+winl+", top="+winh);
		f.submit();
		/*
  		var popModal = window.showModalDialog('/reqsubmit/common/ViewReqHistory.jsp?ReqInfoID='+document.viewForm.ReqID.value,
  																'', 'dialogWidth:540px;dialogHeight:450px; center:yes; help:no; status:no; scroll:yes; resizable:yes');
  		*/
	}

	// �亯 �ۼ� ȭ������ �̵�
  	function offlineSubmit() {
  		f = document.viewForm;
		f.target = "newpopup";
		f.action = "/reqsubmit/common/OffLineDocSend.jsp";
		var winl = (screen.width - 550) / 2;
		var winh = (screen.height - 350) / 2;
		window.open("/blank.html","newpopup","resizable=yes,menubar=no,status=no,titlebar=no, scrollbars=yes,location=no,toolbar=no,height=350,width=520, left="+winl+", top="+winh);
		f.submit();
  	}


</script>


</head>

<body <% if("Y".equalsIgnoreCase(strStartAnsDocSend)) { %> onLoad="javascript:sendAnsDoc()" <% } %>>
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
<div id="wrap">
  <jsp:include page="/inc/top.jsp" flush="true"/>
  <jsp:include page="/inc/top_menu02.jsp" flush="true"/>
  <div id="container">
    <div id="leftCon">
      <jsp:include page="/inc/log_info.jsp" flush="true"/>
      <jsp:include page="/inc/left_menu02.jsp" flush="true"/>
	  <SCRIPT language="JavaScript" src="/js/reqsubmit/reqinfo.js"></SCRIPT>
    </div>
    <div id="rightCon">
      <!-- pgTit -->
      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=MenuConstants.REQ_BOX_MAKE%><span class="sub_stl" >- <%= MenuConstants.REQ_BOX_DETAIL_VIEW %></span></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.getReqBoxGeneral(request)%> > <%=MenuConstants.REQ_BOX_MAKE%></div>
        <p><!--����--></p>
      </div>
      <!-- /pgTit -->

      <!-- contents -->

      <div id="contents">

        <!-- �˻����� ���� ��� �Ʒ� div ���� �� �ּ����� ��������.-->
        <!-- /�˻�����-->


        <!-- �������� ���� -->
         <!-- list view-->
		<%
			String strAnsDocURL = null;
			String strAnsDocPreviewScriptURL = null;
			if (intTotalAnsCount == 0) {
				strAnsDocURL = "javascript:sendAnsDoc()";
				strAnsDocPreviewScriptURL = "javascript:PreAnsDocView(viewForm,'"+strReqBoxID+"')";
			} else {
				strAnsDocURL = "javascript:alertSendAnsDocMessage()";
				strAnsDocPreviewScriptURL = "javascript:alertSendAnsDocMessage()";
			}
			//strAnsDocPreviewScriptURL = "javascript:PreAnsDocView(viewForm,'"+strReqBoxID+"')";
		%>
        <span class="list02_tl">�䱸�� ��� ���� </span>
         <div class="top_btn"><samp>
			 <span class="btn"><a href="javascript:goReqBoxList()">�䱸�� ���</a></span>
			 <span class="btn"><a href="javascript:submtBindingJob(viewForm, '<%= strReqBoxID %>');">���ε�</a></span>
		 </samp></div>
<form name="viewForm" method="post" action="" style="margin:0px">
	<!-- �䱸�� ��� ���� ���� -->
	<input type="hidden" name="ReqBoxID" value="<%= strReqBoxID %>">
	<input type="hidden" name="ReqBoxSortField" value="<%= strReqBoxSortField %>"><!--�䱸�Ը�������ʵ� -->
	<input type="hidden" name="ReqBoxSortMtd" value="<%= strReqBoxSortMtd %>"><!--�䱸�Ը�����Ĺ��-->
	<input type="hidden" name="ReqBoxPage" value="<%= strReqBoxPagNum %>"><!--�䱸�� ������ ��ȣ -->
	<% if(StringUtil.isAssigned(strReqBoxQryTerm)) { %>
	<input type="hidden" name="ReqBoxQryField" value="<%= strReqBoxQryField %>"><!--�䱸�� ��ȸ�ʵ� -->
	<input type="hidden" name="ReqBoxQryTerm" value="<%= strReqBoxQryTerm %>"><!--�䱸�� ��ȸ�ʵ� -->
	<% } //�䱸�� ��ȸ� �ִ� ��츸 ����ؼ� ����� %>

	<!-- �䱸 ��� ���� -->
	<input type="hidden" name="ReqID" value=""> <!-- �䱸 ID -->
	<input type="hidden" name="ReqInfoSortField" value="<%= strReqInfoSortField %>"><!--�䱸���� ��������ʵ� -->
	<input type="hidden" name="ReqInfoSortMtd" value="<%= strReqInfoSortMtd %>"><!--�䱸���� ������Ĺ��-->
	<input type="hidden" name="ReqInfoPage" value="<%= strReqInfoPagNum %>"><!-- �䱸���� ������ ��ȣ -->
	<input type="hidden" name="strReturnURLFLAG" value="NONECMT">

	<% if("Y".equalsIgnoreCase(strStartAnsDocSend)) { %>
		<input type="hidden" name="ReturnURL" value="/reqsubmit/10_mem/20_reqboxsh/30_makeend/SMakeEndBoxList.jsp">
	<%}else{%>
		<input type="hidden" name="ReturnURL" value="/reqsubmit/10_mem/20_reqboxsh/10_make/SMakeReqBoxVList.jsp">
	<%}%>
        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list02">

            <tr>

              <th scope="col">&bull;&nbsp;�䱸�Ը� </th>
				  <td colspan="3"><%= objRsSH.getObject("REQ_BOX_NM") %>
				  <%
										// 2004-06-15 ADD
										String strElcDocNo = (String)objRsSH.getObject("DOC_NO");
										if (StringUtil.isAssigned(strElcDocNo)) {
											out.println(" (���ڰ����ȣ : "+strElcDocNo+")");
										}
									%>
				</td>

            </tr>

            <tr>
              <th scope="col">&bull;&nbsp;�Ұ� ����ȸ </th>
			  <td><%= objRsSH.getObject("CMT_ORGAN_NM") %></td>
            </tr>
            <tr>
              <th scope="col">&bull;&nbsp;��������  </th>
			  <td><%= objCdinfo.getRelatedDuty((String)objRsSH.getObject("RLTD_DUTY")) %></td>
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
              <th scope="col" rowspan="2">&bull;&nbsp;�䱸���̷� </th>  <td colspan="3">
              <ul class="list_in">
              <li><span class="tl">&bull;&nbsp;�䱸�Ի����Ͻ� :</span>
              <%=StringUtil.getDate2((String)objRsSH.getObject("REG_DT"))%></li>
              <li><span class="tl">&bull;&nbsp;�䱸�� ������ :</span> <%=StringUtil.getDate2((String)objRsSH.getObject("LAST_REQ_DOC_SND_DT"))%></li>
              </ul>
              </td>
            </tr>
            <tr>
			  <td colspan="3">
              <ul class="list_in">
              <li><span class="tl">&bull;&nbsp;������ ��ȸ�� :</span> <%=StringUtil.getDate2((String)objRsSH.getObject("FST_QRY_DT"))%></li>
              <li><span class="tl">&bull;&nbsp;������� :</span><%=StringUtil.getDate((String)objRsSH.getObject("SUBMT_DLN"))%> 24:00</li>
              </ul>
              </td>
            </tr>
            <tr>
              <th scope="col">&bull;&nbsp;�䱸�Լ��� </th>   <td colspan="3"><%= objRsSH.getObject("REQ_BOX_DSC") %></td>
            </tr>
        </table>
        <!-- /list view -->
        <p class="warning mt10">* ��� �䱸��Ͽ� ���ؼ� ������� �Ǵ� �亯�ۼ��� ��ģ �� �亯���߼۹�ư�� �����ֽñ� �ٶ��ϴ�.</p>
		<!-- �亯�� �߼� -->
        <!-- ����Ʈ ��ư-->
<!--
�䱸�� ���, ���ε�, �䱸�� ����, �亯�� �̸� ����, �亯�� �߼�, �������� ����
-->
         <div id="btn_all">
			 <div >
				 <div class="mi_btn" style="float:right"><a href="javascript:goReqDocView()"><span>�䱸�� ����</span></a></div> 
				 <div class="mi_btn" style="float:right"><a href="<%= strAnsDocPreviewScriptURL %>"><span>�亯�� �̸� ����</span></a></div>
				 <div class="mi_btn" style="float:right"><a href="<%= strAnsDocURL %>"><span>�亯�� �߼�</span></a></div>
				 <div class="mi_btn" style="float:right"><a href="javascript:offlineSubmit()"><span>�������� ����</span></a></div>
			 </div>
		 </div>

        <!-- /����Ʈ ��ư-->

        <!-- list -->
        <span class="list01_tl">�䱸 ��� <span class="list_total">&bull;&nbsp;��ü�ڷ�� : <%= intTotalRecordCount %>�� (<%= intCurrentPageNum %>/<%= intTotalPage %> page)</span></span>
        <table>
			<tr><td>&nbsp;</td></tr>
		</table>



        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
          <thead>
            <tr>
			  <th scope="col" style="width:15px;"></th>
              <th scope="col" style="width:15px;"><a>NO</a></th>
              <th scope="col" style="width:250px;" style="text-align:center;">
				<%= SortingUtil.getSortLink("changeSortQuery", "REQ_CONT", strReqInfoSortField, strReqInfoSortMtd, "�䱸����") %>
			  </th>
              <th scope="col"><%= SortingUtil.getSortLink("changeSortQuery", "REQ_STT", strReqInfoSortField, strReqInfoSortMtd, "����") %></th>
              <th scope="col"><%= SortingUtil.getSortLink("changeSortQuery", "OPEN_CL", strReqInfoSortField, strReqInfoSortMtd, "�������") %></th>
              <th scope="col"><a>�亯</a></th>
              <th scope="col"><a>÷��</a></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery", "REG_DT", strReqInfoSortField, strReqInfoSortMtd, "�������")%></th>
            </tr>
          </thead>
          <tbody>
<%
	int intRecordNumber= (intCurrentPageNum -1) * Integer.parseInt((String)objParams.getParamValue("ReqInfoPageSize")) +1;
	String strReqInfoID = "";
	while(objRs.next()){
		strReqInfoID = (String)objRs.getObject("REQ_ID");
%>
            <tr>
              <td><input name="ReqInfoID" type="checkbox" value="<%= strReqInfoID %>"  class="borderNo" onClick="javascript:checkBoxValidate(<%= (intRecordNumber-1) %>, '<%= strReqInfoID %>')" /></td>
              <td><%= intRecordNumber %></td>
              <td style="text-align:left;"><a href="javascript:gotoDetail('<%= objRs.getObject("REQ_ID") %>')" hint="<%= StringUtil.substring((String)objRs.getObject("REQ_DTL_CONT"), 80) %>"><%= objRs.getObject("REQ_CONT") %></a></td>
              <td><%= CodeConstants.getRequestStatus((String)objRs.getObject("REQ_STT")) %></td>
              <td><%= CodeConstants.getOpenClass((String)objRs.getObject("OPEN_CL")) %></td>
			  <td width="50" align="center"><%= nads.lib.reqsubmit.util.DBAccessUtil.makeAnsInfoHtml((String)objRs.getObject("ANS_ID"), (String)objRs.getObject("ANS_MTD"), (String)objRs.getObject("ANS_OPIN"), (String)objRs.getObject("SUBMT_FLAG"), objUserInfo.isRequester()) %></td>
              <td><%=makeAttachedFileLink((String)objRs.getObject("ANS_ESTYLE_FILE_PATH"))%></td>
              <td><%= StringUtil.getDate2((String)objRs.getObject("REG_DT")) %></td>
            </tr>
<%
		intRecordNumber++;
	} //endwhile
%>
          </tbody>
        </table>
        <p class="warning mt10">* �亯�� �ۼ��� �䱸�� üũ�ڽ��� ������ �ֽ� �� �Ʒ��� �亯 �ۼ� ��ư�� Ŭ���� �ֽñ� �ٶ��ϴ�.</p><br>
		<!--<p class="warning mt10">* PDF��ȯ���� �� "�����亯�ۼ�" ����� �̿��� �ֽñ� �ٶ��ϴ�. </p>-->
        <!-- /list -->

        <!-- ����¡-->
					<!--	<%= PageCount.getLinkedString(
								new Integer(intTotalRecordCount).toString(),
								new Integer(intCurrentPageNum).toString(),
								objParams.getParamValue("ReqInfoPageSize"))
						%>
						-->
						<%=objPaging.pagingTrans(PageCount.getLinkedString(
								new Integer(intTotalRecordCount).toString(),
								new Integer(intCurrentPageNum).toString(),
								objParams.getParamValue("ReqInfoPageSize")))%>

       <!-- /����¡-->


       <!-- ����Ʈ ��ư-->
        <div id="btn_all" >        <!-- ����Ʈ �� �˻� -->
        <div class="list_ser" >
          <select name="ReqInfoQryField" class="selectBox5"  style="width:70px;" >
            <option <%=(strReqInfoQryField.equalsIgnoreCase("req_cont"))? " selected ": ""%> value="req_cont">�䱸����</option>
			<option <%=(strReqInfoQryField.equalsIgnoreCase("req_dtl_cont"))? " selected ": ""%> value="req_dtl_cont">�䱸����</option>
          </select>
          <input name="iptName" onKeyDown="return ch()" onMouseDown="return ch()" value="<%= strReqInfoQryTerm %>"
		 class="li_input"  style="width:100px"/>
          <img src="/images2/btn/bt_list_search.gif"  onMouseOver="menuOn(this);" onMouseOut="menuOut(this);" onClick="viewForm.submit()"/> </div>
        <!-- /����Ʈ �� �˻� -->
			<span class="right">
            <!-- �ռ��� 2012.2.13-->
            <!-- ����� ���ε� ������Ʈ ������ goSbmtReqForm-> goSbmtReqForm_old ����-->
			<span class="list_bt"><a href="javascript:goSbmtReqForm_old()">�亯�ۼ�</a></span>
			<span class="list_bt"><a href="javascript:viewReqHistory()">�䱸�̷º���</a></span>
            <span class="list_bt"><a href="javascript:goSbmtReqForm()">��뷮���ϵ��</a></span>
<!--
			<span class="list_bt"><a href="#">�䱸����</a></span>
			<span class="list_bt"><a href="#">�䱸����</a></span>
-->
			</span>
		</div>

        <!-- /����Ʈ ��ư-->
        <!-- /�������� ���� -->
      </div>
      <!-- /contents -->

    </div>
<%!
	public String makeAttachedFileLink(String strFileName){
		String strReturnURL = null;
		System.out.println("XXXXXXX : "+strFileName);
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
  </div>
  <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
<OBJECT ID="ezPDFConv" height="1" width="1" CLASSID="CLSID:ABBFCE48-008E-4DA1-8F5F-DF9E9749DC9D" codebase='cab/ezPDFConvtt.cab#Version=1,0,0,10'></OBJECT>
</body>
</html>