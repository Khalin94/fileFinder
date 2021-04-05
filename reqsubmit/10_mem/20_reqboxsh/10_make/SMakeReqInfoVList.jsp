<%@ page language="java" contentType="text/html;charset=EUC-KR" %>

<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.pf.util.PageCount"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.lib.reqsubmit.params.requestinfo.SMemReqInfoVListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.SMemReqInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.answerinfo.AnsInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.MemRequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.SMemReqBoxDelegate" %>
<%@ page import="nads.dsdm.app.common.page.PagingDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	UserInfoDelegate objUserInfo = null;
	CDInfoDelegate objCdinfo = null;
%>

<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>
<%
	/*** PagingDelegate */
	PagingDelegate objPaging=new PagingDelegate(); 		/*����¡ ��ȯ Delegate*/
%>

<%
	MemRequestBoxDelegate reqDelegate = null;
	SMemReqBoxDelegate sReqDelegate = null;
	SMemReqInfoDelegate selfDelegate = null;
	AnsInfoDelegate ansDelegate = null;

	SMemReqInfoVListForm objParams = new SMemReqInfoVListForm();

	boolean blnParamCheck=false;
	blnParamCheck = objParams.validateParams(request);
	if(blnParamCheck==false) {
  		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  		objMsgBean.setStrCode("DSPARAM-0000");
  		objMsgBean.setStrMsg(objParams.getStrErrors());
  		out.println("ParamError:" + objParams.getStrErrors());
	  	return;
  	}//endif

  	reqDelegate = new MemRequestBoxDelegate();
	sReqDelegate = new SMemReqBoxDelegate();
	selfDelegate = new SMemReqInfoDelegate();
	ansDelegate = new AnsInfoDelegate();

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
	
	//��������� �׽�Ʈ
  String strOpenCL = request.getParameter("ReqOpenCL");
  System.out.println("kangthis logs SMakeReqInfoVList.jsp(strOpenCL) => " + strOpenCL);

	String strReqStt = null; // �䱸 ���� ���� ����

	// �亯 ���� �� ����¡ ����
	int intTotalRecordCount = 0;
	int intCurrentPageNum = 0;
	int intTotalPage = 0;

	ResultSetSingleHelper objRsSH = null;
	ResultSetHelper objRs = null;

	try{
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
	    	// �䱸 ���� ���� ������ ����!
	    	strReqStt = (String)objRsSH.getObject("REQ_STT");

	    	// �亯 ����� SELECT �Ѵ�.
	    	objRs = new ResultSetHelper(ansDelegate.getRecordList(objParams));

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
		f.target = "";
		f.action = "SMakeReqBoxVList.jsp";
		f.submit();
	}

	// �䱸�� ��� ��ȸ
	function goReqBoxList() {
		f = document.viewForm;
		f.target = "";
		f.action = "SMakeReqBoxList.jsp";
		f.submit();
	}
    // �ռ��� 2012.2.13
    // ����� ���ε� ������Ʈ ������ gotoDetail-> gotoDetail_old//gotoDetail_old-> gotoDetail ����
  	// �亯 �󼼺���� ����
  	function gotoDetail(strAnsID){
  		f = document.viewForm;
  		f.target = "popwin";
  		f.action="/reqsubmit/common/SAnsInfoView.jsp?AnsID="+strAnsID;
  		NewWindow('/blank.html', 'popwin', '618', '590');
  		f.submit();
  	}

    // ������ �亯 �󼼺���� ����
  	function gotoDetail_old(strAnsID){
  		f = document.viewForm;
  		f.target = "popwin";
  		f.action="/reqsubmit/common/SAnsInfoView_old.jsp?AnsID="+strAnsID;
  		NewWindow('/blank.html', 'popwin', '520', '350');
  		f.submit();
  	}
    
    

    
 	// ���� �亯 �ۼ� ȭ������ �̵�
  	function goSbmtReqForm_test() {
  		f = document.viewForm;
  		f.ReqID.value = "<%= strReqID %>";
		f.target = "newpopup";
		f.action = "/reqsubmit/common/SAnsInfoWrite_before.jsp";	  	
		var winl = (screen.width - 600) / 2;
		var winh = (screen.height - 600) / 2;
		//window.open("/blank.html","newpopup","resizable=no,menubar=no,status=no,titlebar=no,scrollbars=yes,location=no,toolbar=no,height=530,width=595, left="+winl+", top="+winh);
		window.open("/blank.html","newpopup","resizable=no,menubar=no,status=no,titlebar=no,scrollbars=yes,location=no,toolbar=no,height=530,width=595, left="+winl+", top="+winh);
		f.submit();
  	}

  	// �亯 �ۼ� ȭ������ �̵�
  	function goSbmtReqForm() {
  		f = document.viewForm;
  		f.ReqID.value = "<%= strReqID %>";
		f.target = "newpopup";
		f.action = "/reqsubmit/common/SAnsInfoWrite.jsp";		
		var winl = (screen.width - 600) / 2;
		var winh = (screen.height - 600) / 2;
		//window.open("/blank.html","newpopup","resizable=no,menubar=no,status=no,titlebar=no,scrollbars=yes,location=no,toolbar=no,height=530,width=595, left="+winl+", top="+winh);
		window.open("/blank.html","newpopup","resizable=no,menubar=no,status=no,titlebar=no,scrollbars=yes,location=no,toolbar=no,height=600,width=595, left="+winl+", top="+winh);
		f.submit();
  	}
	function goSbmtReqForm2() {
  		f = document.viewForm;
  		f.ReqID.value = "<%= strReqID %>";
		f.target = "newpopup";
		f.action = "/reqsubmit/common/SAnsInfoWrite2.jsp";
		var winl = (screen.width - 600) / 2;
		var winh = (screen.height - 600) / 2;
		window.open("/blank.html","newpopup","resizable=no,menubar=no,status=no,titlebar=no,scrollbars=no,location=no,toolbar=no,height=530,width=595, left="+winl+", top="+winh);
		f.submit();
  	}
    //������ �亯 �ۼ� ȭ��
  	function goSbmtReqForm_old() {
  		f = document.viewForm;
  		f.ReqID.value = "<%= strReqID %>";
		f.target = "newpopup";
		f.action = "/reqsubmit/common/SAnsInfoWrite_old.jsp";
		var winl = (screen.width - 550) / 2;
		var winh = (screen.height - 350) / 2;
		window.open("/blank.html","newpopup","resizable=yes,menubar=no,status=no,titlebar=no, scrollbars=yes,location=no,toolbar=no,height=350,width=520, left="+winl+", top="+winh);
		f.submit();
  	}
  	// ���� �亯 ����
  	function selectDelete() {
  		var f = document.viewForm;
  		f.target = "";
  		if (getCheckCount(f, "AnsID") < 1) {
  			alert("�ϳ� �̻��� üũ�ڽ��� ������ �ּ���");
  			return;
  		}
  		f.action = "/reqsubmit/common/SAnsInfoDelProc.jsp";
  		if (confirm("�����Ͻ� �亯���� �����Ͻðڽ��ϱ�?\n�ش� �亯���� �����ϸ� ���Ե� ���ϵ鵵 �ϰ� �����˴ϴ�.")) f.submit();
  	}

  	// �䱸 �ߺ� ��ȸ
  	function checkOverlapReq() {
  		var f2 = document.dupCheckForm;
  		f2.target = "popwin";
  		f2.action = "/reqsubmit/common/SReqOverlapCheck.jsp";
  		NewWindow('/blank.html', 'popwin', '500', '480');
  		f2.submit();
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
	
	// ����¡ �ٷΰ���
  	function goPage(strPage){
  		f = document.viewForm;
  		f.ReqInfoPage.value = strPage;
  		f.action = "/reqsubmit/10_mem/20_reqboxsh/10_make/SMakeReqInfoVList.jsp";
  		f.target = "_self";
  		f.submit();
  	}
</script>
</head>

<body
<%
	int intNotSubmitReqCnt = sReqDelegate.getReqCntNotSubmit(strReqBoxID);
	int intRemaindReqCnt = sReqDelegate.checkReqInfoAnsIsNull(strReqBoxID);

	if(intNotSubmitReqCnt == 0 || intRemaindReqCnt == 0) {
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
					<input type="hidden" name="ReqStt" value="<%= strReqStt %>">
					<input type="hidden" name="ReqOpenCL" value="<%= objRsSH.getObject("OPEN_CL") %>">

					<!-- ���� �� ��ȯ�� URL�� �����ϱ� ���� Parameter ���� -->
					<input type="hidden" name="WinType" value="SELF">
					<input type="hidden" name="ReturnURL" value="<%= request.getRequestURI() %>?ReqBoxID=<%= strReqBoxID %>&ReqID=<%= strReqID %>">

					<!-- ���� �亯 ������ ���� AnsID ���� -->
					<input type="hidden" name="AnsID2" value="">

      <!-- pgTit -->

      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=MenuConstants.REQ_BOX_MAKE%><span class="sub_stl" >- <%= MenuConstants.REQ_INFO_DETAIL_VIEW %></span></h3>
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
        <span class="list02_tl">�䱸 ��� ���� </span>
        <div class="top_btn"><samp>
		<% if (!CodeConstants.REQ_STT_SUBMT.equalsIgnoreCase(strReqStt)) { // ����Ϸᰡ �ƴ� ��츸 �����ּ��� %>
			 <span class="btn"><a href="javascript:checkOverlapReq()">�ߺ���ȸ</a></span>
		<% } %>
			 <span class="btn"><a href="javascript:goReqBoxView()">�䱸�� ����</a></span>
			 <span class="btn"><a href="javascript:goReqBoxList()">�䱸�� ���</a></span>
			 <span class="btn"><a href="javascript:viewReqHistory('<%= strReqID %>')">�䱸 �̷� ����</a></div>
        </samp></div>
        <table border="0" cellspacing="0" cellpadding="0" width="680" class="list02">

            <tr>
                <th height="25"">&bull; �䱸���� </th>
                <td height="25" colspan="3"><strong><%= objRsSH.getObject("REQ_CONT") %></strong></td>
            </tr>
            <tr>
                <th height="25">&bull; �䱸���� </th>
                <td height="25" colspan="3"><%= StringUtil.getDescString((String)objRsSH.getObject("REQ_DTL_CONT")) %>
				</td>
            </tr>
            <tr>
                <th height="25">&bull; �䱸�Ը� </th>
                <td height="25" colspan="3"><%= objRsSH.getObject("REQ_BOX_NM") %></td>
            </tr>
            <tr>
                <th height="25">&bull; �䱸��� </th>
                <td height="25"><%= objRsSH.getObject("REQ_ORGAN_NM") %></td>
                <th height="25">&bull;&nbsp;������</th>
                <td height="25"><%= objRsSH.getObject("SUBMT_ORGAN_NM") %></td>
            </tr>
            <tr>
                <th height="25">&bull; ������� </th>
                <td height="25"><%= CodeConstants.getOpenClass((String)objRsSH.getObject("OPEN_CL")) %></td>
                <th height="25">&bull;&nbsp;÷������</th>
                <td height="25"><%= StringUtil.makeAttachedFileLink((String)objRsSH.getObject("ANS_ESTYLE_FILE_PATH"), (String)objRsSH.getObject("REQ_ID")) %></td>
            </tr>
            <tr>
                <th height="25">&bull; ������� </th>
                <td height="25"><%= StringUtil.getDate((String)objRsSH.getObject("SUBMT_DLN")) %> 24:00</td>
                <th height="25">&bull;&nbsp;�������</th>
                <td height="25"><%= StringUtil.getDate2((String)objRsSH.getObject("LAST_REQ_DT")) %></td>
            </tr>
            <tr>
                <th height="25" width="18%">&bull; ����� </th>
                <td height="25" width="32%"><%= objRsSH.getObject("USER_NM") %></td>
                <th height="25" width="18%">&bull;&nbsp;���� ����</th>
                <td height="25" width="32%"><%= CodeConstants.getRequestStatus(strReqStt) %></td>
            </tr>
        </table>
        <!-- /list view -->
        <p class="warning mt10">* ��� �䱸��Ͽ� ���ؼ� ������� �Ǵ� �亯�ۼ� �� �ۼ��߿䱸�� > �ش� �䱸�� �󼼺��� ȭ���� �亯���߼� ��ư��&nbsp;�����ֽñ� �ٶ��ϴ�.</p>
        
        <!-- ����Ʈ ��ư-->
        <div id="btn_all">
        <div  class="t_right">
	  <% if (!CodeConstants.REQ_STT_SUBMT.equalsIgnoreCase(strReqStt) && intTotalRecordCount > 0) { %>
			 <div class="mi_btn"><a href="javascript:sbmtReq()"><span>�������</span></a></div>
	  <% } %>
        </div>
		</div>

        <!-- /����Ʈ ��ư-->

        <!-- list -->
        <%-- <span class="list01_tl">�亯��� <span class="list_total">&bull;&nbsp;��ü�ڷ�� :  <%= intTotalRecordCount %>�� </span></span> --%>
        <span class="list01_tl">�亯 ��� <span class="list_total">&bull;&nbsp;��ü�ڷ�� : <%= intTotalRecordCount %>�� (<%= intCurrentPageNum %>/<%= intTotalPage %> page)</span></span>
		<table>
			<tr>
				<td>&nbsp;</td>
			</tr>
		</table>
<!--
checkbox
<input name="" type="checkbox" value="" class="borderNo" />
-->
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
          <tbody>
			<%
				int intRecordNumber= 0;
				if (intTotalRecordCount > 0) {
					while(objRs.next()){
			%>
            <tr>
              <td>
			  <% if (!CodeConstants.REQ_STT_SUBMT.equalsIgnoreCase(strReqStt)) { // ����Ϸᰡ �ƴ� ��츸 �����ּ��� %>
				<input name="AnsID" type="checkbox" value="<%= objRs.getObject("ANS_ID") %>" class="borderNo"/>
			  <% } else { %>
			  <%=intRecordNumber+1%>
			  <%	}	%>
			  </td>
			  <td style="text-align:left;"><%= StringUtil.getNotifyImg((String)objRs.getObject("ANS_DT"), CodeConstants.REQ_STT_NOT) %><a href="javascript:gotoDetail('<%= objRs.getObject("ANS_ID") %>')"><%= objRs.getObject("ANS_OPIN") %></a></td>
              <td><%= objRs.getObject("USER_NM") %></td>
              <td><%= CodeConstants.getOpenClass((String)objRsSH.getObject("OPEN_CL")) %></td>
              <td><%=nads.lib.reqsubmit.util.DBAccessUtil.makeAnsInfoHtml((String)objRs.getObject("ANS_ID"), (String)objRs.getObject("ANS_MTD")) %></td>
              <td><%= StringUtil.getDate2((String)objRs.getObject("ANS_DT")) %></td>
            </tr>
			<%
						intRecordNumber++;
					} //endwhile
				} else {
			%>
			<tr>
				<td colspan="6" align="center">��ϵ� �亯�� �����ϴ�.</td>
            </tr>
			<%
					}
           	%>

<!--
	�ڷᰡ ���� ���
			<tr>
			 <td colspan="6"  align ="center"> ��ϵ� �䱸������ �����ϴ�. </td>
            </tr>
-->
          </tbody>
        </table>
		<!--<p class="warning mt10">* PDF��ȯ���� �� "�����亯�ۼ�" ����� �̿��� �ֽñ� �ٶ��ϴ�. </p>--><br>
        <!-- /list -->
        <%=objPaging.pagingTrans(PageCount.getLinkedString(
								new Integer(intTotalRecordCount).toString(),
								new Integer(intCurrentPageNum).toString(),
								"10"))%>

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
                <!-- �ռ��� 2012.2.13-->
                <!-- ����� ���ε� ������Ʈ ������ goSbmtReqForm-> goSbmtReqForm_old ����-->
				<%if (objUserInfo.getUserID().equals("0000039924")){%>
					<span class="list_bt"><a href="javascript:goSbmtReqForm2()">�׽�Ʈ</a></span>
				<%}%>
				<span class="list_bt"><a href="javascript:goSbmtReqForm_old()">�亯�ۼ�</a></span>
                <span class="list_bt"><a href="javascript:selectDelete()">���û���</a></span>
				<span class="list_bt"><a href="javascript:goSbmtReqForm()">��뷮���ϵ��</a></span>				
				
			</span>
		</div>

<!--         /����Ʈ ��ư-->
        <!-- /�������� ����
      </div>
      <!-- /contents -->

    </div>
  </div>
</form>

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
