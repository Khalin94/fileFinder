<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.SCommRequestBoxDelegate" %>
<%@ page import="nads.lib.reqsubmit.params.requestinfo.SCommReqInfoVListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.CommAnsInfoDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%
	UserInfoDelegate objUserInfo = null;
	CDInfoDelegate objCdinfo = null;
%>
<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>
<%
	CommAnsInfoDelegate objAnsInfo = new CommAnsInfoDelegate();
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

  //�α��� ����� ������ �����´�. ���Ѿ��� ��� ������ �����ϴ�.
  String strReqSubmitFlag = objUserInfo.getReqSubmitFlag();

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
	String strReqStt = "";

	// �亯 ���� �� ����¡ ����
	int intTotalRecordCount = 0;

 	SCommRequestBoxDelegate objReqBox=null; 		/**�䱸�� Delegate*/
	ResultSetSingleHelper objRsSH = null;
	ResultSetHelper objRs = null;
	ResultSetHelper objRsAns = null;

	try{
   objReqBox=new SCommRequestBoxDelegate();
   /**�䱸�� �̿� ���� üũ */


	// �䱸 ������ SELECT �Ѵ�.
	objRsSH = new ResultSetSingleHelper(objAnsInfo.getReqRecord(strReqID));
	// �䱸 ���� ���� ������ ����!
	strReqStt = (String)objRsSH.getObject("REQ_STT");
	// �亯 ����� SELECT �Ѵ�.
	String strRefReqID = (String)objRsSH.getObject("REF_REQ_ID");
	objRs = new ResultSetHelper(objAnsInfo.getRecordList(strReqID));
	intTotalRecordCount = objRs.getTotalRecordCount();
	// ���� ���� ����� SELECT �Ѵ�.
	objRsAns = new ResultSetHelper(objAnsInfo.getRecordList((String)objRsSH.getObject("REF_REQ_ID")));

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
<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>
<script language="javascript">
	var f;

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
		f.action = "./SCommReqBoxVList.jsp";
		f.target = "";
		f.submit();
	}

	// �䱸�� ��� ��ȸ
	function goReqBoxList() {
		f = document.viewForm;
		f.action = "/reqsubmit/20_comm/20_reqboxsh/SCommReqBoxList.jsp";
		f.target = "";
		f.submit();
	}

  	// �亯 �󼼺���� ����
  	function gotoDetail(strAnsID){
  		f = document.viewForm;
  		f.target = "popwin";
  		f.action="/reqsubmit/common/SAnsInfoView.jsp?AnsID="+strAnsID;
  		NewWindow('/blank.html', 'popwin', '618', '590');
  		//window.open('about:blank', 'popwin', 'width=520,height=400, scrollbars=no, resizable=yes, toolbar=no, menubar=no, location=no, directories=no, status=no');
  		f.submit();
  	}

  	// �亯 �ۼ� ȭ������ �̵�
  	function gotoNewAns() {
		f = document.viewForm;
  		f.ReqID.value = "<%= strReqID %>";
		f.target = "newpopup";
		f.action = "/reqsubmit/common/SAnsInfoWrite.jsp";
		var winl = (screen.width - 600) / 2;
		var winh = (screen.height - 600) / 2;
		window.open("/blank.html","newpopup","resizable=no,menubar=no,status=no,titlebar=no,scrollbars=no,location=no,toolbar=no,height=600,width=595, left="+winl+", top="+winh);
		f.submit();
  	}
  	// �亯 �ۼ� ȭ������ �̵�
  	function gotoNewAns_old() {
		f = document.viewForm;
  		f.ReqID.value = "<%= strReqID %>";
		f.target = "newpopup";
		f.action = "/reqsubmit/common/SAnsInfoWrite_old.jsp";
		var winl = (screen.width - 550) / 2;
		var winh = (screen.height - 350) / 2;
		window.open("/blank.html","newpopup","resizable=yes,menubar=no,status=no,titlebar=no,	scrollbars=yes,location=no,toolbar=no,height=350,width=520, left="+winl+", top="+winh);
		f.submit();
  	}
  	// �������� ȭ������ �̵�
  	function gotoCommAns() {
  		var f = document.viewForm;
  		if (getCheckCount(f, "RefAnsID") < 1) {
  			alert("�ϳ� �̻��� üũ�ڽ��� ������ �ּ���");
  			return;
  		}
  		f.action = "SCommAnsWriteProc.jsp";
		f.target = "";
  		f.submit();
  	}

  	// ���� �亯 ����
  	function gotoDelAns() {
  		var f = document.viewForm;
  		if (getCheckCount(f, "AnsID") < 1) {
  			alert("�ϳ� �̻��� üũ�ڽ��� ������ �ּ���");
  			return;
  		}
  		f.action = "/reqsubmit/common/SAnsInfoDelProc.jsp";
		f.target = "";
  		if (confirm("�����Ͻ� �亯���� �����Ͻðڽ��ϱ�?\n�ش� �亯���� �����ϸ� ���Ե� ���ϵ鵵 �ϰ� �����˴ϴ�.")) f.submit();
  	}
  	// �亯�� �߼�
	function sendAnsDoc() {
		var f = document.viewForm;
		f.action = "/reqsubmit/common/AnsDocSend.jsp?ReqBoxID=<%= strReqBoxID %>";
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

</head>
<body>
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
    <div id="contents">
			<form name="viewForm" method="post" action="" style="margin:0px">
			<!-- �䱸�� ��� ���� ���� -->
			<input type="hidden" name="CmtOrganID" value="<%=request.getParameter("CmtOrganID")%>">
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
			<input type="hidden" name="ReqID" value="<%= strReqID %>"> <!-- �䱸 ID -->
			<input type="hidden" name="ReqInfoSortField" value="<%= strReqInfoSortField %>"><!--�䱸���� ��������ʵ� -->
			<input type="hidden" name="ReqInfoSortMtd" value="<%= strReqInfoSortMtd %>"><!--�䱸���� ������Ĺ��-->
			<% if(StringUtil.isAssigned(strReqInfoQryTerm)) { %>
			<input type="hidden" name="ReqInfoQryField" value="<%= strReqInfoQryField %>"><!--�䱸���� ��ȸ�ʵ� -->
			<input type="hidden" name="ReqInfoQryTerm" value="<%= strReqInfoQryTerm %>"><!-- �䱸���� ��ȸ�� -->
			<% } %>
			<input type="hidden" name="ReqInfoPage" value="<%= strReqInfoPagNum %>"><!-- �䱸���� ������ ��ȣ -->
			<input type="hidden" name="ReqOpenCL" value="<%= (String)objRsSH.getObject("OPEN_CL") %>">
			<!-- ���� �� ��ȯ�� URL�� �����ϱ� ���� Parameter ���� -->
			<input type="hidden" name="returnURL" value="SELF">
		    <input type="hidden" name="WinType" value="SELF">
		    <input type="hidden" name="ReturnURL" value="<%= request.getRequestURI() %>?ReqBoxID=<%= strReqBoxID %>&ReqID=<%= strReqID %>">
		    <input type="hidden" name="WriteURL" value="<%=request.getRequestURI()%>">
			<input type="hidden" name="AuditYear" value="<%=objParams.getParamValue("AuditYear")%>">
			<input type="hidden" name="ReqStt" value="<%=strReqStt%>">
            <input type="hidden" name="ReturnURLFLAG" value="CMT">

      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=MenuConstants.REQ_BOX_MAKE%><span class="sub_stl" >- <%= MenuConstants.REQ_INFO_DETAIL_VIEW %></span></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.REQUEST_BOX_COMM%> > <%=MenuConstants.REQ_BOX_MAKE%></div>
        <p><!--����--></p>
      </div>
      <div id="contents">


        <!-- �˻����� ���� ��� �Ʒ� div ���� �� �ּ����� ��������.-->
        <!-- /�˻�����-->


        <!-- �������� ���� -->
         <!-- list view-->

        <span class="list02_tl">�䱸 ��� ���� </span>
        <div class="top_btn"><samp>
        <!-- �䱸�� ���� -->
			 <span class="btn"><a href="javascript:goReqBoxView();">�䱸�� ����</a></span>
			  <!-- �䱸�� ��� -->
			 <!--span class="list_bt"><a href="javascript:goReqBoxList();">�䱸�� ���</a></span-->
			 <!-- �䱸 �̷� ��ȸ -->
			 <span class="btn"><a href="javascript:viewReqHistory('<%= strReqID %>');">�䱸 �̷� ��ȸ</a></span>
		</samp></div>


			<table border="0" cellspacing="0" cellpadding="0" width="680" class="list02">
			<tr>
                <th height="25">&bull; �䱸����</th>
		  		<td height="25" colspan="3"><strong><%= objRsSH.getObject("REQ_CONT") %></strong></td>
			</tr>
						<tr>
                <th height="25">&bull; �䱸����</th>
		  		<td height="25" colspan="3"><%= StringUtil.getDescString((String)objRsSH.getObject("REQ_DTL_CONT")) %></td>
			</tr>
			<tr>
                <th height="25">&bull; �䱸�Ը�</th>
		  		<td height="25" colspan="3"><%= objRsSH.getObject("REQ_BOX_NM") %></td>
			</tr>
			<tr>
                <th height="25" width="18%">&bull; �Ұ� ����ȸ</th>
		  		<td height="25" width="32%"><%= objRsSH.getObject("CMT_ORGAN_NM") %></td>
                <th height="25" width="18%">&bull; ���� ����</th>
		  		<td height="25" width="32%"><%= CodeConstants.getRequestStatus(strReqStt) %></td>
			</tr>
			<tr>
                <th height="25">&bull; �䱸���</th>
		  		<td height="25"><%= objRsSH.getObject("REQ_ORGAN_NM") %> (<%= objRsSH.getObject("REGR_NM") %>)</td>
                <th height="25">&bull; ������</th>
		  		<td height="25"><%= objRsSH.getObject("SUBMT_ORGAN_NM") %></td>
			</tr>
			<tr>
                <th height="25">&bull; �������</th>
		  		<td height="25"><strong><%= StringUtil.getDate((String)objRsSH.getObject("SUBMT_DLN")) %> 24:00</strong></td>
                <th height="25">&bull; �䱸����</th>
		  		<td height="25"><strong><%= StringUtil.getDate2((String)objRsSH.getObject("LAST_REQ_DT")) %></strong></td>
			</tr>
			<tr>
                <th height="25">&bull; �������</th>
		  		<td height="25"><%= CodeConstants.getOpenClass((String)objRsSH.getObject("OPEN_CL")) %></td>
                <th height="25">&bull; ÷������</th>
		  		<td height="25"><%= StringUtil.makeAttachedFileLink((String)objRsSH.getObject("ANS_ESTYLE_FILE_PATH"), (String)objRsSH.getObject("REQ_ID")) %></td>
			</tr>
			</table>
            <p class="warning mt10">* ��� �䱸��Ͽ� ���ؼ� ������� �Ǵ� �亯�ۼ� �� �ۼ��߿䱸�� > �ش� �䱸�� �󼼺��� ȭ���� �亯���߼� ��ư��&nbsp;�����ֽñ� �ٶ��ϴ�.</p>
        <!-- ����Ʈ ��ư-->
         <div id="btn_all"><div  class="t_right">
	  <% if(!strReqSubmitFlag.equals("004") && !CodeConstants.REQ_STT_SUBMT.equalsIgnoreCase(strReqStt) && intTotalRecordCount > 0) { %>
			 <div class="mi_btn"><a href="javascript:sbmtReq();"><span>�������</span></a></div>
	  <% } %>
		 </div></div>
        <!-- /����Ʈ ��ư-->
        <!-- list -->
        <span class="list01_tl">�亯��� <span class="list_total">&bull;&nbsp;��ü�ڷ�� :  <%= intTotalRecordCount %>�� </span></span>
		<table>
			<tr>
				<td>&nbsp;</td>
			</tr>
		</table>

			<!------------------------------------------------- �亯 ��� ���̺� ���� ------------------------------------------------->
        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
          <thead>
            <tr>
			<th scope="col">
			<% if (!CodeConstants.REQ_STT_SUBMT.equalsIgnoreCase(strReqStt)) { // ����Ϸᰡ �ƴ� ��츸 �����ּ��� %>
			<input name="checkAll" type="checkbox" value="" class="borderNo" onClick="javascript:checkAllOrNot(viewForm)"/>
			<% } else { %>
			  No
			  <%	}	%>
			  </th>
              <th scope="col" width="250px;"><a>���� �ǰ�</a></th>
              <th scope="col" width="50px;"><a>�ۼ���</a></th>
              <th scope="col"><a>��������</a></th>
              <th scope="col"><a>�亯</a></th>
              <th scope="col"><a>�ۼ�����</a></th>
            </tr>
          </thead>
			<%
			Vector vct = new Vector();
  			if(objRs.getRecordSize() > 0){
				while(objRs.next()){
				String strRefAnsID = (String)objRs.getObject("REF_ANS_ID");
					if(!strRefAnsID.equalsIgnoreCase("")){
						vct.add(strRefAnsID);
					}
			%>

			<tr>
				<td>
			  	<% if (!CodeConstants.REQ_STT_SUBMT.equalsIgnoreCase(strReqStt)) { // ����Ϸᰡ �ƴ� ��츸 �����ּ��� %>
   	          		<input type="checkbox" name="AnsID" value="<%= objRs.getObject("ANS_ID") %>">
   	          	<% } %>
				</td>
				<td style="text-align:left;"><%= StringUtil.getNotifyImg((String)objRs.getObject("ANS_DT"), CodeConstants.REQ_STT_NOT) %><a href="javascript:gotoDetail('<%=objRs.getObject("ANS_ID") %>')"><%= objRs.getObject("ANS_OPIN") %></a></td>
				<td><%= objRs.getObject("ANSR_NM") %></td>
                <td><%= CodeConstants.getOpenClass((String)objRsSH.getObject("OPEN_CL")) %></td>
				<td><%=nads.lib.reqsubmit.util.DBAccessUtil.makeAnsInfoHtml((String)objRs.getObject("ANS_ID"), (String)objRs.getObject("ANS_MTD")) %></td>
				<td><%= StringUtil.getDate2((String)objRs.getObject("ANS_DT")) %></td>
			</tr>
			<%
				} //endwhile
			} else {
			%>
			<tr>
				<td colspan="7" height="40" align="center">��ϵ� �亯������ �����ϴ�.</td>
			</tr>
			<%	}	%>
			</table>

            <span class="right">
			  	<% if (!CodeConstants.REQ_STT_SUBMT.equalsIgnoreCase(strReqStt)) { // ����Ϸᰡ �ƴ� ��츸 �����ּ��� %>
                    <span class="list_bt"><a href="javascript:gotoNewAns_old()">�亯�ۼ�</a></span>
					<span class="list_bt"><a href="javascript:gotoNewAns()">��뷮���ϵ��</a></span>
    				<span class="list_bt"><a href="javascript:gotoDelAns()">���û���</a></span>
   	          	<% } %>
            </span>
		<%
		if(objRsAns.getRecordSize() > 0) {
		%>
		<!----- ���� ���� ��� -------->
			<!-------------------- TAB �� �ش��ϴ� ������ ����ϴ� ��������. ------------------------>
			<table border="0" cellpadding="0" cellspacing="0" width="759">
			<tr>
				<td width="300" class="soti_reqsubmit">
				<img src="/image/reqsubmit/icon_reqsubmit_soti.gif" width="9" height="9" align="absmiddle">
				������ �ڷ� ���</td>
				<td width="459" align="right" valign="bottom">
				<!------------------------- COUNT (PAGE) ------------------------------------>
				</td>
			</tr>
			</table>
			<!------------------------------------------------- ���� ���� ��� ���̺� ���� ------------------------------------------------->
			<table width="759" border="0" cellspacing="0" cellpadding="0">
			<tr>
		  		<td height="2" colspan="7" class="td_reqsubmit">������ �����Ͻ� �ڷᰡ �ֽ��ϴ�.<br>
			÷�ε� �亯�ڷḦ �����Ͽ� ���ۼ� �Ͻðų� ���������� ������ �Ʒ��� [����ȸ ����]��ư�� Ŭ���Ͽ� ��� �Ͻ� �� �ֽ��ϴ�.</td>
			</tr>
			<tr align="center" class="td_top">
			  	<td width="64" height="22">
			  	<% if (!CodeConstants.REQ_STT_SUBMT.equalsIgnoreCase(strReqStt)) { // ����Ϸᰡ �ƴ� ��츸 �����ּ��� %>
						<input type="checkbox" name="" value="" onClick="javascript:revCheck(this.form, 'RefAnsID')">
				<% } %>
				</td>
				<td width="335" height="22">���� �ǰ�</td>
			  	<td width="80">�ۼ���</td>
			  	<td width="80">�ۼ���</td>
			  	<td width="150">�亯</td>
			</tr>
			<tr>
			  	<td height="1" colspan="7" class="td_reqsubmit"></td>
			</tr>
			<%
			int intRefNumber= 0;
			while(objRsAns.next()){
			%>
			<tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''">
				<td height="20" align="center">
				<% if (!CodeConstants.REQ_STT_SUBMT.equalsIgnoreCase(strReqStt)) { // ����Ϸᰡ �ƴ� ��츸 �����ּ���
					if(!vct.contains(objRsAns.getObject("ANS_ID"))){ %>
				   	<input type="checkbox" name="RefAnsID" value="<%= objRsAns.getObject("ANS_ID") %>">
				<% }
				}%></td>
				<td class="td_lmagin" height="20"><a href="javascript:gotoDetail('<%= objRsAns.getObject("ANS_ID") %>')"><%= objRsAns.getObject("ANS_OPIN") %></a></td>
				<td align="center"><%= objRsAns.getObject("ANSR_NM") %></td>
				<td align="center"><%= StringUtil.getDate((String)objRsAns.getObject("ANS_DT")) %></td>
				<td align="center"><%=nads.lib.reqsubmit.util.DBAccessUtil.makeAnsInfoHtml((String)objRsAns.getObject("ANS_ID"), (String)objRsAns.getObject("ANS_MTD")) %></td>
			</tr>
			<tr class="tbl-line">
			  	<td height="1" colspan="7"></td>
			</tr>
			<%
				intRefNumber++;
			} //endwhile
			%>
			<tr class="tbl-line">
			  	<td height="1" colspan="7"></td>
			</tr>
			</table>


			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
		  		<td width="300" height="40">
  				<!-- ��ư�� �ʿ��ϴٸ� ���⿡ �߰��Ͻ� �˴ϴٿ� -->
				<%
				if(!strReqSubmitFlag.equals("004")){
					if (!CodeConstants.REQ_STT_SUBMT.equalsIgnoreCase(strReqStt)) { // ����Ϸᰡ �ƴ� ��츸 �����ּ���
						if(!vct.contains(objRsAns.getObject("ANS_ID"))){ %>
					   	<img src="/image/button/bt_committeeSubmit.gif" height="20" style="cursor:hand" onClick="gotoCommAns();" alt="��û�Կ� �ִ� �䱸������ ����ȸ���Ƿ� ���������� �����û�մϴ�.">
					<% }
				}	}%>
  				</td>
  				<td width="459" align="right" valign="middle">
			  	</td>
			</tr>
		  	</table>
			</td>
		</tr>
		<%
		}
		%>
        <tr>
        	<td height="35px"></td>
        </tr>
		</table>
</form>
        </div>

<!--         /����Ʈ ��ư-->
        <!-- /�������� ����
      </div>
      <!-- /contents -->

    </div>
  </div>
<form method="post" action="" name="dupCheckForm" style="margin:0px">
	<input type="hidden" name="queryText" value="<%= StringUtil.ReplaceString((String)objRsSH.getObject("REQ_CONT"), "'", "") %>">
	<input type="hidden" name="ReqBoxID" value="<%= strReqBoxID %>">
	<input type="hidden" name="ReqID" value="<%= strReqID %>">
	<input type="hidden" name="ReturnURL" value="<%= request.getRequestURI() %>?ReqBoxID=
<%= strReqBoxID %>&ReqID=<%= strReqID %>">
</form>
  <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>