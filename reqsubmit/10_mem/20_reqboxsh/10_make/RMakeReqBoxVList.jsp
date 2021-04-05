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
<%@ page import="nads.lib.reqsubmit.params.requestbox.RMemReqBoxVListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.MemRequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.MemRequestInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.cmtsubmt.CmtSubmtReqBoxDelegate" %>
<%@ page import="nads.dsdm.app.common.page.PagingDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%
	/*** PagingDelegate */
	PagingDelegate objPaging=new PagingDelegate(); 		/*����¡ ��ȯ Delegate*/
%>
<%
	UserInfoDelegate objUserInfo =null;
	CDInfoDelegate objCdinfo =null;
%>

<%@ include file="../../../common/RUserCodeInfoInc.jsp" %>

<%
	/*************************************************************************************************/
	/** 					�Ķ���� üũ Part 														  */
	/*************************************************************************************************/

	/**�Ϲ� �䱸�� �󼼺��� �Ķ���� ����.*/
	RMemReqBoxVListForm objParams =new RMemReqBoxVListForm();
	boolean blnParamCheck=false;
	/**���޵� �ĸ����� üũ */
	blnParamCheck=objParams.validateParams(request);
	if(blnParamCheck==false){
		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
		objMsgBean.setStrCode("DSPARAM-0000");
		objMsgBean.setStrMsg(objParams.getStrErrors());
		//out.println("ParamError:" + objParams.getStrErrors());
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	} //endif

	/*************************************************************************************************/
	/** 					������ ȣ�� Part 														  */
	/*************************************************************************************************/

	String strAuditYear = (String)objParams.getParamValue("AuditYear") == null ? "2008" : (String)objParams.getParamValue("AuditYear");
	String strCmtGubun = objUserInfo.getOrganGBNCode();
	strAuditYear = StringUtil.getEmptyIfNull(strAuditYear);
	/*** Delegate �� ������ Container��ü ���� */
	MemRequestBoxDelegate objReqBox=null; 		/**�䱸�� Delegate*/
	MemRequestInfoDelegate  objReqInfo=null;	/** �䱸���� Delegate */
	ResultSetSingleHelper objRsSH=null;		/** �䱸�� �󼼺��� ���� */
	ResultSetHelper objRs=null;				/**�䱸 ��� */
	CmtSubmtReqBoxDelegate objCmtSubmt = null;

	try{
		/**�䱸�� ���� �븮�� New */
		objReqBox=new MemRequestBoxDelegate();
		objCmtSubmt = new CmtSubmtReqBoxDelegate();

		/**�䱸�� �̿� ���� üũ */
		boolean blnHashAuth=objReqBox.checkReqBoxAuth((String)objParams.getParamValue("ReqBoxID"),objUserInfo.getOrganID()).booleanValue();
		if(!blnHashAuth){
		    objMsgBean.setMsgType(MessageBean.TYPE_WARN);
		  	objMsgBean.setStrCode("DSAUTH-0001");
		  	objMsgBean.setStrMsg("�ش� �䱸���� �� ������ �����ϴ�.");
		  	//out.println("�ش� �䱸���� �� ������ �����ϴ�.");
%>
			<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
			return;
		} else {
			/** �䱸�� ���� */
			objRsSH=new ResultSetSingleHelper(objReqBox.getRecord((String)objParams.getParamValue("ReqBoxID")));

			/**�䱸 ���� �븮�� New */
			objReqInfo=new MemRequestInfoDelegate();
			objRs=new ResultSetHelper(objReqInfo.getRecordList(objParams));

			if(strAuditYear.equals("")){
				strAuditYear = ((String)objRsSH.getObject("REG_DT")).substring(0,4);
			}
		}/**���� endif*/
	} catch(AppException objAppEx) {
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		objMsgBean.setStrCode(objAppEx.getStrErrCode());
		objMsgBean.setStrMsg(objAppEx.getMessage());
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}

	/*************************************************************************************************/
	/** 					������ �� �Ҵ�  Part 														  */
	/*************************************************************************************************/

	/**�䱸���� �����ȸ�� ��� ��ȯ.*/
	int intTotalRecordCount=objRs.getTotalRecordCount();
	int intCurrentPageNum=objRs.getPageNumber();
	int intTotalPage=objRs.getTotalPageCount();
%>
<jsp:include page="/inc/header.jsp" flush="true"/>
<link href="/css2/style.css" rel="stylesheet" type="text/css">
<script language="javascript">
  /** ���Ĺ�� �ٲٱ� */
  function changeSortQuery(sortField,sortMethod){
  	formName.ReqInfoSortField.value=sortField;
  	formName.ReqInfoSortMtd.value=sortMethod;
  	formName.target = '';
  	formName.submit();
  }
  /**�䱸 �󼼺���� ����.*/
  function gotoDetail(strID){
  	formName.ReqInfoID.value=strID;
  	formName.action="./RMakeReqInfoVList.jsp";
  	formName.target = '';
  	formName.submit();
  }

  /** ������� ���� */
  function gotoList(){
  	formName.action="./RMakeReqBoxList.jsp";
  	formName.target = '';
  	formName.submit();
  }

  /** ����¡ �ٷΰ��� */
  function goPage(strPage){
  	formName.ReqInfoPage.value=strPage;
  	formName.target = '';
  	formName.submit();
  }

  /** �䱸����������� ����. */
  function gotoRegReqInfo(){
  	formName.action="./RMakeReqInfoWrite.jsp";
  	formName.target = '';
  	formName.submit();
  }

	var IsClick=false;
	var strPopup;
	var strGubun = -1;

	function ButtonProcessing()
	{
		try{
			if(strGubun < 0){
				var oPopup = window.createPopup();
				var  oPopBody  =  oPopup.document.body;
				oPopBody.style.backgroundColor  =  "white";
				oPopBody.style.border  =  "solid  #dddddd 1px";



				// "ó�����Դϴ�"��� �޽����� �ε��̹����� ǥ�õǵ��� �Ѵ�.
				oPopBody.innerHTML  = "<table width='100%' height='100%' border='1'><tr><td align='center' style='font-size:9pt;'><b>ó�����Դϴ�. ��ø� ��ٷ��ּ���...<b><br><img src='/image/reqsubmit/processing.gif'></td></tr></table>";



				var leftX = document.body.clientWidth/2 -130;
				var topY = (document.body.clientHeight/1.7) - (oPopBody.offsetHeight/2);

				oPopup.show(leftX,  topY,  270,  130,  document.body);



				// createPopup()�� �̿��� �˾��������� ����� ���
				// �⺻������ �ش� �˾����� onblur�̺�Ʈ�� �߻��ϸ� �� �˾��������� ������ �˴ϴ�.

				// �ش� �˾����������� onblur�̺�Ʈ�� �߻��Ҷ�����  �޼ҵ带 ��ȣ���Ͽ�

				// �˾��������� �׻� ǥ�õǰ� �մϴ�.
				oPopBody.attachEvent("onblur", ButtonProcessing);
				strPopup = oPopup;
			}
			strGubun = -1;
		}
		catch(e) {}
	}

	function notProcessing(){
		if(strPopup.isOpen){
			strPopup.hide();
			strGubun = 1;
		}
	}


	function sendReqDocByCmtTitle() {

		if(!IsClick){

		}else{
			alert("���μ����� �۵����Դϴ�. ��� ��ٷ��ֽʽÿ�.");
			return false;
		}
		if(confirm("�ش� �䱸 ������ ����ȸ�� ��û�Ͻ� �� ����ȸ ���Ƿ� �߼��Ͻðڽ��ϱ�?")) {
			IsClick = true;  //��ư ó���� ������..
//			ButtonProcessing();  //ó�����¸� ǥ���ϴ� �޼ҵ� ȣ��

			var innHtml = '<div id="loading_layer"><b>ó�����Դϴ�. ��ø� ��ٷ��ּ���...</b><br><img src="/image/reqsubmit/processing.gif" ></div>'
			$('body').prepend(innHtml);

			formName.method = "POST";
			formName.target = "processingFrame";
			formName.action = "/reqsubmit/common/CmtReqDocSendAllInOne.jsp";
			//var winl = (screen.width - 304) / 2;
			//var winh = (screen.height - 118) / 2;
			//document.all.loadingDiv.style.left = winl;
			//document.all.loadingDiv.style.top = winh;
			//document.all.loadingDiv.style.display = '';
			//window.open('about:blank', 'popwin', 'width=100px, height=100px, left=1500px, top=1500px');
			formName.submit();
		}
	}

	function sendReqDocNew(strReqDocType, strReqBoxID) {
		if(!IsClick){
			NewWindowFixSize('/reqsubmit/common/ReqDocSend.jsp?ReqBoxID='+strReqBoxID+'&ReqDocType='+strReqDocType, '', '460', '340');
		}else{
			alert("���μ����� �۵����Դϴ�. ��� ��ٷ��ֽʽÿ�.");
			return false;
		}
  	//var popModal = window.showModalDialog('RMakeReqDocSend.jsp?ReqDocType="+strReqDocType+"&ReqBoxID=' + strReqBoxID,
  	//															'', 'dialogWidth:450px;dialogHeight:500px; center:yes; help:no; status:no; scroll:no; resizable:yes');
  	//window.open('/reqsubmit/common/ReqDocSend.jsp?ReqBoxID='+strReqBoxID+'&ReqDocType='+strReqDocType, '', 'width=450,height=320, scrollbars=no, resizable=no, toolbar=no, menubar=no, location=no, directories=no, status=no');

  }

	function copyReqBox(ReqBoxID) {
		NewWindow('/reqsubmit/common/MemReqBoxCopyList.jsp?ReqBoxID='+ReqBoxID,'', '640', '450');
	}

</script>
<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="/js/reqsubmit/reqboxview.js"></SCRIPT>
</head>

<body>
<iframe name='processingFrame' height='0' width='0'></iframe>
<DIV ID="loadingDiv" style="display:none;position:absolute;">
	<img src="/image/reqsubmit/loading.jpg" border="0"> </td>
</DIV>
<div id="balloonHint" style="display:none;height:100px;background:#fff">
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
    </div>
    <div id="rightCon">
<form name="formName" method="<%=nads.lib.reqsubmit.EnvConstants.FORM_METHOD%>" action="<%=request.getRequestURI()%>"><!--�䱸�� �ű����� ���� -->
			<%//�䱸�� ���� ���� �ޱ�.
				String strReqBoxSortField=objParams.getParamValue("ReqBoxSortField");
				String strReqBoxSortMtd=objParams.getParamValue("ReqBoxSortMtd");
				//�䱸�� ������ ��ȣ �ޱ�.
				String strReqBoxPagNum=objParams.getParamValue("ReqBoxPage");
				//�䱸�� ��ȸ���� �ޱ�.
				String strReqBoxQryField=objParams.getParamValue("ReqBoxQryField");
				String strReqBoxQryTerm=objParams.getParamValue("ReqBoxQryTerm");
				//�䱸 ���� ���� ���� �ޱ�.
				String strReqInfoSortField=objParams.getParamValue("ReqInfoSortField");
				String strReqInfoSortMtd=objParams.getParamValue("ReqInfoSortMtd");
				//�䱸�� ���� ������ ��ȣ �ޱ�.
				String strReqInfoPagNum=objParams.getParamValue("ReqInfoPage");
				//�䱸��ȸ�����±׾��ֱ�����.
				objParams.getFormElement("ReqInfoQryField").setFormTagType(nads.lib.reqsubmit.form.FormElement.FORM_TAG_TYPE_SESSION);
				objParams.getFormElement("ReqInfoQryTerm").setFormTagType(nads.lib.reqsubmit.form.FormElement.FORM_TAG_TYPE_SESSION);
		    %>
		    <!-- %= objParams.getHiddenFormTags()% -->

			<input type="hidden" name="ReqBoxPage" value="<%= strReqBoxPagNum %>">
			<input type="hidden" name="ReqBoxPageSize" value="<%= (String)objParams.getParamValue("ReqBoxPageSize") %>">
			<input type="hidden" name="ReqBoxQryField" value="<%= (String)objParams.getParamValue("ReqBoxQryField") %>">
			<input type="hidden" name="ReqBoxQryTerm" value="<%= (String)objParams.getParamValue("ReqBoxQryTerm") %>">
			<input type="hidden" name="ReqBoxSortField" value="<%= (String)objParams.getParamValue("ReqBoxSortField") %>">
			<input type="hidden" name="ReqBoxSortMtd" value="<%= (String)objParams.getParamValue("ReqBoxSortMtd") %>">
			<input type="hidden" name="ReqInfoPage" value="<%= (String)objParams.getParamValue("ReqInfoPage") %>">
			<input type="hidden" name="ReqInfoPageSize" value="<%= (String)objParams.getParamValue("ReqInfoPageSize") %>">
			<input type="hidden" name="ReqInfoSortField" value="<%= (String)objParams.getParamValue("ReqInfoSortField") %>">
			<input type="hidden" name="ReqInfoSortMtd" value="<%= (String)objParams.getParamValue("ReqInfoSortMtd") %>">
			<input type="hidden" name="AuditYear" value="<%= strAuditYear %>">
			<input type="hidden" name="RltdDuty" value="<%= (String)objParams.getParamValue("RltdDuty") %>">

			<input type="hidden" name="ReturnUrl" value="<%=request.getRequestURI()%>"><!--�ǵ��ƿ� URL -->
			<input type="hidden" name="ReqDocType" value="<%= CodeConstants.REQ_DOC_TYPE_001 %>"><!-- ReqDocType -->
			<input type="hidden" name="CmtOrganID" value="<%= objRsSH.getObject("CMT_ORGAN_ID") %>">
			<input type="hidden" name="ReqBoxID" value="<%= (String)objParams.getParamValue("ReqBoxID") %>">
			<input type="hidden" name="ReqInfoID" value="">
			<input type="hidden" name="ReqBoxIDs">
			<input type="hidden" name="SubmtDln" value="<%= StringUtil.getDate((String)objRsSH.getObject("SUBMT_DLN")) %>">
			<input type="hidden" name="ReqBoxNm" value="<%=objRsSH.getObject("REQ_BOX_NM")%>">
			<input type="hidden" name="ReqOrganNm" value="<%=objRsSH.getObject("REQ_ORGAN_NM")%>">
			<input type="hidden" name="RegrNm" value="<%=objRsSH.getObject("REGR_NM")%>">
			<input type="hidden" name="ReqOrganId" value="<%=objRsSH.getObject("REQ_ORGAN_ID")%>">

			<%
				int int1st = String.valueOf(objRsSH.getObject("REQ_BOX_NM")).indexOf("��");
				int int2nd = String.valueOf(objRsSH.getObject("REQ_BOX_NM")).indexOf("ȸ");
				String strNatCnt = String.valueOf(objRsSH.getObject("REQ_BOX_NM")).substring(int1st+1, int2nd);
			%>
			<input type="hidden" name="NatCnt" value="<%= strNatCnt %>">

      <!-- pgTit -->

      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=MenuConstants.REQ_BOX_MAKE%></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /><%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.getReqBoxGeneral(request)%> > <%=MenuConstants.REQ_BOX_MAKE%></div>
        <p><!--����--></p>
      </div>
      <!-- /pgTit -->

      <!-- contents -->

      <div id="contents">

        <!-- �˻����� ���� ��� �Ʒ� div ���� �� �ּ����� ��������.-->
        <!-- /�˻�����-->


        <!-- �������� ���� -->
         <!-- list view-->

        <span class="list02_tl">�䱸�� ����</span>
		<%
		  //�䱸�� ���� ����.
		  String strReqBoxStt=(String)objRsSH.getObject("REQ_BOX_STT");
		%>
		 <!-- ��� ��ư ����-->
		 <div class="top_btn">
		  <samp>
		<%
			//��������(���),��ȴ����  ���¿����� �䱸�� ����,����,�䱸�� �߼� ��ư�� Disable�Ǿ��־����.
			//�� �ۼ��߰� �ݷ����¿����� ������.
			//
			if(strReqBoxStt.equals(CodeConstants.REQ_BOX_STT_003) || strReqBoxStt.equals(CodeConstants.REQ_BOX_STT_005) || strReqBoxStt.equals(CodeConstants.REQ_BOX_STT_009)){

				/** ����ڿ�  �α����ڰ� �������� ȭ�鿡 �����.*/
				if(objUserInfo.getUserID().equals((String)objRsSH.getObject("REGR_ID"))){
		%>
        <!-- ����Ʈ ��ư-->
			 <span class="btn"><a href="javascript:gotoMemEditPage()">�䱸�� ����</a></span>
			 <span class="btn"><a href="javascript:gotoMemDeletePage(<%=objRs.getTotalRecordCount()%>)">�䱸�� ����</a></span>
		<%
				} // ����ڿ�  �α����ڰ� �������� ȭ�鿡 �����.
		%>
			 <span class="btn"><a href="javascript:copyReqBox('<%=objRsSH.getObject("REQ_BOX_ID")%>')">�䱸�� ����</a></span>
			 <span class="btn"><a href="javascript:gotoList()">�䱸�� ���</a></span>
		<%
			} // endif
		%>
		  </samp>
		 </div>
        <!-- ��� ��ư ��-->
        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list02">

            <tr>
              <th scope="col">&bull;&nbsp;�䱸�Ը� </th>
				  <td colspan="3"><%=objRsSH.getObject("REQ_BOX_NM")%></td>
            </tr>
			<%
				// 2004-07-08 �繫ó, ����ó�� ��쿡�� ����ȸ��°� ��������
				if (CodeConstants.ORGAN_GBN_ASM.equalsIgnoreCase(objUserInfo.getOrganGBNCode()) || CodeConstants.ORGAN_GBN_BUD.equalsIgnoreCase(objUserInfo.getOrganGBNCode())) {
				} else {
			%>
            <tr>
              <th scope="col">&bull;&nbsp;�Ұ� ����ȸ </th>
			  <td><%=objRsSH.getObject("CMT_ORGAN_NM")%></td>
            </tr>
			<% } %>
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
						 <td class="fonts"><%=(String)objRsSH.getObject("REGR_NM")%></td>
						 <td class="fonts">(�߼۵��� �ʾ����Ƿ�, �亯 ����� ������ �����ϴ�.)</td>
					 </tr>
				 </table>
			</td>

            </tr>
                <tr>

              <th scope="col">&bull;&nbsp;�䱸�� �̷� </th>  <td colspan="3">
              <ul class="list_in">
              <li><span class="tl">&bull;&nbsp;�䱸�Ի����Ͻ� :</span> <%=StringUtil.getDate2((String)objRsSH.getObject("REG_DT"))%></li>
              <li><span class="tl">&bull;&nbsp;������� :</span> <%=StringUtil.getDate((String)objRsSH.getObject("SUBMT_DLN"))%> 24:00</li>
              </ul>
              </td>

            </tr>
                <tr>
              <th scope="col">&bull;&nbsp;�䱸�Լ��� </th>   <td colspan="3"><%=StringUtil.getDescString((String)objRsSH.getObject("REQ_BOX_DSC"))%></td>
            </tr>
        </table>
        <!-- /list view -->
        <p class="warning mt10">�䱸�� �߼� : �ǿ���(�Ǵ� �Ҽӱ��) ���Ƿ� �ش� �������� �䱸���� �߼��մϴ�.</p>
		<%
			if(objCmtSubmt.checkCmtOrganMakeAutoSche((String)objRsSH.getObject("CMT_ORGAN_ID")) && objUserInfo.getIsMyCmtOrganID((String)objRsSH.getObject("CMT_ORGAN_ID"))) {
			//if(objUserInfo.getIsMyCmtOrganID((String)objRsSH.getObject("CMT_ORGAN_ID")) && ("GI00004757".equalsIgnoreCase((String)objRsSH.getObject("CMT_ORGAN_ID")) || "GI00004773".equalsIgnoreCase((String)objRsSH.getObject("CMT_ORGAN_ID"))) && objCmtSubmt.checkCmtOrganMakeAutoSche((String)objRsSH.getObject("CMT_ORGAN_ID")) == true) {
		%>
        <p class="warning mt10">����ȸ ���� �䱸�� �߼� : ����ȸ�� �ۼ��� �䱸 ������ �ڵ� ��û �մϴ�. ����ȸ �����Ϸ� �䱸�� ���� �ش� ������ Ȯ���ϼ���.</p>
		<% } %>

	<!-- �ߴܹ�ư ���� -->
         <div id="btn_all">
			<div  class="t_right">
		<%
			//��������(���),��ȴ����  ���¿����� �䱸�� ����,����,�䱸�� �߼� ��ư�� Disable�Ǿ��־����.
			//�� �ۼ��߰� �ݷ����¿����� ������.
			//
			if(strReqBoxStt.equals(CodeConstants.REQ_BOX_STT_003) || strReqBoxStt.equals(CodeConstants.REQ_BOX_STT_005) || strReqBoxStt.equals(CodeConstants.REQ_BOX_STT_009)){
		%>

		<%
				if(intTotalRecordCount>0){
		%>
			<% if(objUserInfo.getIsMyCmtOrganID("GI00004757") && "GI00004757".equalsIgnoreCase((String)objRsSH.getObject("CMT_ORGAN_ID"))) { %>
			<% } else { %>
				<%if(strCmtGubun.equals("004")){%>
		     <div class="mi_btn"><a href="javascript:sendReqDocNew('<%= CodeConstants.REQ_DOC_TYPE_001 %>', '<%= (String)objParams.getParamValue("ReqBoxID") %>')"><span>�䱸�� �߼�</span></a></div>
				 <%}else{%>
			 <div class="mi_btn"><a href="javascript:sendReqDocNew('<%= CodeConstants.REQ_DOC_TYPE_001 %>', '<%= (String)objParams.getParamValue("ReqBoxID") %>')"><span>�ǿ��� ���� �䱸�� �߼�</span></a></div>
			<%}%>
		<% } %>
		<%
					if(objCmtSubmt.checkCmtOrganMakeAutoSche((String)objRsSH.getObject("CMT_ORGAN_ID")) && objUserInfo.getIsMyCmtOrganID((String)objRsSH.getObject("CMT_ORGAN_ID"))) {
		%>
			 <div class="mi_btn"><a href="javascript:sendReqDocByCmtTitle()"><span>����ȸ ���� �䱸�� �߼�</span></a></div>
		<%
			}
		%>
		<%
				}//�����ı����־�� ����.

			} // endif

			/*��ȸ��� ������ ��� ����.*/
			if(objRs.getRecordSize()>0){
		%>
		<%
			String strReqTp = "";
			if (CodeConstants.ORGAN_GBN_CMT.equalsIgnoreCase(objUserInfo.getOrganGBNCode())) strReqTp = CodeConstants.PRE_REQ_DOC_FORM_901;
			else strReqTp = CodeConstants.PRE_REQ_DOC_FORM_101;
		%>
			 <div class="mi_btn"><a href="javascript:PreReqDocView(formName,'<%= (String)objParams.getParamValue("ReqBoxID") %>', '<%= strReqTp %>')"><span>�䱸�� �̸� ����</span></a></div>
		<%
			}//endif �䱸�� �̸����� ��ư ���� ��.
		%>
			</div>
		 </div>
        <!-- /�ߴ� ��ư-->

        <!-- list -->
        <span class="list01_tl">�䱸 ��� <span class="list_total">&bull;&nbsp;��ü�ڷ�� : <%= intTotalRecordCount %>�� (<%= intCurrentPageNum %>/<%= intTotalPage %> page)</span></span>
        <table>
		<tr><td>&nbsp;</td></tr>
		</table>



        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
          <thead>
            <tr>
			  <th scope="col" style="width:10px; ">
				<input name="checkAll" type="checkbox" value="" class="borderNo"onClick="checkAllOrNot(document.formName);" />
			  </th>
              <th scope="col"  style="width:20px; "><a>NO</a></th>
				<%
					int intTmpWidth1=490;
					if(objUserInfo.getOrganGBNCode().equals("003")){//�ǿ��ǼҼ�
					  intTmpWidth1=intTmpWidth1-50;
					}//endif�ǿ��ǼҼ�Ȯ��
				%>
              <th scope="col" style="width:250px; "><%=SortingUtil.getSortLink("changeSortQuery","REQ_CONT",strReqInfoSortField,strReqInfoSortMtd,"�䱸����")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","OPEN_CL",strReqInfoSortField,strReqInfoSortMtd,"�������")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","REQ_STT",strReqInfoSortField,strReqInfoSortMtd,"����")%></th>
			<%
				if(objUserInfo.getOrganGBNCode().equals("003")){//�ǿ��ǼҼ�
			%>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","CMT_REQ_APP_FLAG",strReqInfoSortField,strReqInfoSortMtd,"����ȸ")%></th>
			<%
				}//endif�ǿ��ǼҼ�Ȯ��
			%>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","REG_DT",strReqInfoSortField,strReqInfoSortMtd,"����Ͻ�")%></th>
            </tr>
          </thead>
          <tbody>

	<%
		int intRecordNumber= intTotalRecordCount - ((intCurrentPageNum -1) * Integer.parseInt((String)objParams.getParamValue("ReqInfoPageSize")));
		String strReqInfoID = "";
		String strCmtApplyValue = "Y";

		while(objRs.next()) {
			strReqInfoID = (String)objRs.getObject("REQ_ID");
			/** ����ȸ��û��������(Y) �ƴ��� "" ����*/
			if(CodeConstants.isDuplatedApplyToCmtReq((String)objRs.getObject("CMT_REQ_APP_FLAG"))) strCmtApplyValue = "";
			else strCmtApplyValue="Y";
	 %>
            <tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''">
              <td><input name="ReqInfoIDs" type="checkbox" value="<%= strReqInfoID %>"  class="borderNo"/></td>
              <td><%= intRecordNumber %></td>
			<%
				int intTmpWidth2=490;
				if(objUserInfo.getOrganGBNCode().equals("003")){//�ǿ��ǼҼ�
				  intTmpWidth2=intTmpWidth2-50;
				}//endif�ǿ��ǼҼ�Ȯ��
			%>
              <td style="text-align:left;"><%=StringUtil.getNotifyImg((String)objRs.getObject("REG_DT"))%><a href="JavaScript:gotoDetail('<%=strReqInfoID%>');" hint="<%= StringUtil.substring((String)objRs.getObject("REQ_DTL_CONT"), 40)+" ..."	 %>"><%=StringUtil.substring((String)objRs.getObject("REQ_CONT"),35)%></a>
			  </td>
              <td><%=CodeConstants.getOpenClass((String)objRs.getObject("OPEN_CL"))%></td>
              <td><%=CodeConstants.getRequestStatus((String)objRs.getObject("REQ_STT"))%></td>
			<%
				if(objUserInfo.getOrganGBNCode().equals("003")){//�ǿ��ǼҼ�
			%>
              <td><%=CodeConstants.getCmtRequestAppoint((String)objRs.getObject("CMT_REQ_APP_FLAG"))%></td>
			<%
				}//endif�ǿ��ǼҼ�Ȯ��
			%>
              <td><%=StringUtil.getDate2((String)objRs.getObject("REG_DT"))%></td>
            </tr>
			<input type="hidden" name="ReqID" value="<%= strReqInfoID %>">
			<input type="hidden" name="CmtApplys" value="<%=strCmtApplyValue%>">
<%
		intRecordNumber--;
	} //endwhile
%>
	<%
		/*��ȸ��� ������ ��� ����.*/
		if(objRs.getRecordSize()<1){
	%>
			<tr>
              <td colspan="7" align="center">��ϵ� �䱸������ �����ϴ�.</td>
            </tr>
		<%
			}/*��ȸ��� ������ ��� ��.*/
		%>
          </tbody>
        </table>
        <!-- /list -->
						<%=objPaging.pagingTrans(PageCount.getLinkedString(
							new Integer(intTotalRecordCount).toString(),
							new Integer(intCurrentPageNum).toString(),
							objParams.getParamValue("ReqInfoPageSize")))%>

       <!-- /����¡-->


       <!-- ����Ʈ ��ư-->
        <div id="btn_all" >        <!-- ����Ʈ �� �˻� -->
        <div class="list_ser" >
		<%
			String strReqInfoQryField=(String)objParams.getParamValue("ReqInfoQryField");
		%>
          <select name="ReqInfoQryField" class="selectBox5"  style="width:70px;" >
            <option <%=(strReqInfoQryField.equalsIgnoreCase("req_cont"))? " selected ": ""%>value="req_cont">�䱸����</option>
			<option <%=(strReqInfoQryField.equalsIgnoreCase("req_dtl_cont"))? " selected ": ""%>value="req_dtl_cont">�䱸����</option>
          </select>
          <input name="ReqInfoQryTerm" onKeyDown="return ch()" onMouseDown="return ch()" value="<%=objParams.getParamValue("ReqInfoQryTerm")%>"
		 class="li_input"  style="width:100px"/>
          <img src="/images2/btn/bt_list_search.gif"  onMouseOver="menuOn(this);" onMouseOut="menuOut(this);" onClick="gotoReqInfoSearch(formName);"/> </div>
        <!-- /����Ʈ �� �˻�
�䱸 ���

�䱸 �̵�

�䱸 ����

�䱸 ����

		-->
			<span class="right">
	   <%//��������(���),��ȴ����  ���¿����� �䱸�� ����,����,�䱸�� �߼� ��ư�� Disable�Ǿ��־����.
		  //�� �ۼ��߰� �ݷ����¿����� ������.
		 if(strReqBoxStt.equals(CodeConstants.REQ_BOX_STT_003) || strReqBoxStt.equals(CodeConstants.REQ_BOX_STT_005) || strReqBoxStt.equals(CodeConstants.REQ_BOX_STT_009) ){
	   %>
			<span class="list_bt" onclick="javascript:gotoRegReqInfo();return false;"><a href="#">�䱸 ���</a></span>
		<%
		if(objRs.getRecordSize()>0){/**�䱸�����������츸 ���*/
		%>
		<span class="list_bt" onclick="javascript:moveMemReqInfo(formName);return false;"><a href="#">�䱸 �̵�</a></span>
		<%
			}//endif
		%>
	   <%
			}//endif �䱸�� ���� üũ ��.
	   %>
		<%//��������(���),��ȴ����  ���¿����� �䱸�� ����,����,�䱸�� �߼� ��ư�� Disable�Ǿ��־����.
		  //�� �ۼ��߰� �ݷ����¿����� ������.
		 if(strReqBoxStt.equals(CodeConstants.REQ_BOX_STT_003) || strReqBoxStt.equals(CodeConstants.REQ_BOX_STT_005) || strReqBoxStt.equals(CodeConstants.REQ_BOX_STT_009)){
			if(objRs.getRecordSize()>0){/**�䱸�����������츸 ���*/
		%>
		<span class="list_bt" onclick="javascript:delMemReqInfos(formName);return false;"><a href="#">�䱸 ����</a></span>
		<% if(!objCmtSubmt.checkCmtOrganMakeAutoSche((String)objRsSH.getObject("CMT_ORGAN_ID")) || !objUserInfo.getIsMyCmtOrganID((String)objRsSH.getObject("CMT_ORGAN_ID"))) { %>
			<% } %>
		<%
			}//endif
		}//endif �䱸�� ���� üũ ��.
	   %>
		<%
			if(objRs.getRecordSize()>0){/**�䱸�����������츸 ���*/
		%>
			<span class="list_bt" style="cursor:hand" onClick="copyMemReqInfo(document.formName);" alt="���� �䱸�� ���纻�� ������ �䱸�Կ� �����մϴ�."><a>�䱸 ����</a></span>
		<%
			}//endif
		%>
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
</form>
  </div>
  <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>