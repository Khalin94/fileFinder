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
<%@ page import="nads.lib.reqsubmit.params.requestinfo.SMemReqInfoVListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.SMemReqInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.answerinfo.AnsInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.MemRequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.SMemReqBoxDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	UserInfoDelegate objUserInfo = null;
	CDInfoDelegate objCdinfo = null;
%>


<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>

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

	String strReqStt = null; // �䱸 ���� ���� ����

	//��������� �׽�Ʈ
    String strOpenCL = request.getParameter("ReqOpenCL");
    System.out.println("kangthis logs SMakeOpReqInfoVList.jsp(strOpenCL) => " + strOpenCL);

	// �亯 ���� �� ����¡ ����
	int intTotalRecordCount = 0;

	ResultSetSingleHelper objRsSH = null;
	ResultSetHelper objRs = null;

	try{
	   	boolean blnHashAuth = reqDelegate.checkReqBoxAuth(strReqBoxID, objUserInfo.getOrganID()).booleanValue();

	   	if(!blnHashAuth) {
	   		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	  		objMsgBean.setStrCode("DSAUTH-0001");
  	  		objMsgBean.setStrMsg("�ش� �䱸�ڷḦ �� ������ �����ϴ�.");
  	  		out.println("�ش� �䱸�ڷḦ �� ������ �����ϴ�.");
		    return;
		} else {
	    	// �䱸 ��� ������ SELECT �Ѵ�.
	    	objRsSH = new ResultSetSingleHelper(selfDelegate.getRecord(strReqID));
	    	// �䱸 ���� ���� ������ ����!
	    	strReqStt = (String)objRsSH.getObject("REQ_STT");

	    	// �亯 ����� SELECT �Ѵ�.
	    	objRs = new ResultSetHelper(ansDelegate.getRecordList(objParams));

			intTotalRecordCount = objRs.getTotalRecordCount();
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
		f.action = "SMakeOpReqBoxVList.jsp";
		f.submit();
	}

	// �䱸�� ��� ��ȸ
	function goReqBoxList() {
		f = document.viewForm;
		f.target = "";
		f.action = "SMakeOpReqBoxList.jsp";
		f.submit();
	}

  	// �亯 �󼼺���� ����
  	function gotoDetail(strAnsID){
  		f = document.viewForm;
  		f.target = "popwin";
  		f.action="/reqsubmit/common/SAnsInfoView.jsp?AnsID="+strAnsID;
  		var winl = (screen.width - 550) / 2;
		var winh = (screen.height - 550) / 2;
        window.open("/blank.html","popwin","resizable=yes,menubar=no,status=no,titlebar=no, scrollbars=no,location=no,toolbar=no,height=550,width=610, left="+winl+", top="+winh);
		f.submit();
  	}

  	// �亯 �ۼ� ȭ������ �̵�
  	function goSbmtReqForm() {
  		f = document.viewForm;
  		f.ReqID.value = "<%= strReqID %>";
		f.target = "newpopup";
		f.action = "/reqsubmit/common/SAnsInfoWrite.jsp";
		var winl = (screen.width - 550) / 2;
		var winh = (screen.height - 550) / 2;
		window.open("/blank.html","newpopup","resizable=yes,menubar=no,status=no,titlebar=no, scrollbars=no,location=no,toolbar=no,height=600,width=610, left="+winl+", top="+winh);
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
<SCRIPT language="JavaScript" src="/js/reqsubmit/reqinfo.js"></SCRIPT>
<div id="wrap">
  <jsp:include page="/inc/top.jsp" flush="true"/>
  <jsp:include page="/inc/top_menu02.jsp" flush="true"/>
  <div id="container">
    <div id="leftCon">
      <jsp:include page="/inc/log_info.jsp" flush="true"/>
      <jsp:include page="/inc/left_menu02.jsp" flush="true"/>
    </div>
    <div id="rightCon">
      <!-- pgTit -->
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

      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=MenuConstants.REQ_BOX_MAKE%><span class="sub_stl" >- <%= MenuConstants.REQ_INFO_DETAIL_VIEW %></span></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > ��ȸ�ǿ� ������ �ڷ� �䱸 > <%=MenuConstants.REQ_BOX_MAKE%></div>
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
			 <span class="btn"><a href="javascript:goReqBoxView()">�䱸�Ժ���</a></span>
			 <span class="btn"><a href="javascript:goReqBoxList()">�䱸�Ը��</a></span>
			 <span class="btn"><a href="javascript:viewReqHistory('<%= strReqID %>')">�䱸 �̷� ����</a></span>
		</samp></div>


        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list02">

            <tr>

              <th scope="col">&bull;&nbsp;�䱸���� </th>
				  <td colspan="3"><%= objRsSH.getObject("REQ_CONT") %>
     			  </td>
            </tr>

            <tr>
              <th scope="col">&bull;&nbsp;�䱸���� </th>
			  <td colspan="3"><%= StringUtil.getDescString((String)objRsSH.getObject("REQ_DTL_CONT")) %></td>
            </tr>
            <tr>
              <th scope="col">&bull;&nbsp;�䱸�ڷ�  </th>
			  <td colspan="3"><%= objRsSH.getObject("REQ_BOX_NM") %></td>
            </tr>
             <tr>
              <th scope="col">&bull;&nbsp;�䱸��� </th>
			  <td><%= objRsSH.getObject("REQ_ORGAN_NM") %></td>
              <th scope="col">&bull;&nbsp;������ </th>
			  <td><%= objRsSH.getObject("SUBMT_ORGAN_NM") %></td>
            </tr>
             <tr>
              <th scope="col">&bull;&nbsp;������� </th>
			  <td><%= CodeConstants.getOpenClass((String)objRsSH.getObject("OPEN_CL")) %></td>
              <th scope="col">&bull;&nbsp;÷������ </th>
			  <td><%= StringUtil.makeAttachedFileLink((String)objRsSH.getObject("ANS_ESTYLE_FILE_PATH"), (String)objRsSH.getObject("REQ_ID")) %></td>
            </tr>
             <tr>
              <th scope="col">&bull;&nbsp;������� </th>
			  <td><%= StringUtil.getDate((String)objRsSH.getObject("SUBMT_DLN")) %> 24:00</td>
              <th scope="col">&bull;&nbsp;������� </th>
			  <td><%= StringUtil.getDate2((String)objRsSH.getObject("LAST_REQ_DT")) %></td>
            </tr>
             <tr>
              <th scope="col">&bull;&nbsp;����� </th>
			  <td><%= objRsSH.getObject("USER_NM") %></td>
              <th scope="col">&bull;&nbsp;���� ���� </th>
			  <td><%= CodeConstants.getRequestStatus(strReqStt) %></td>
            </tr>
        </table>
        <!-- /list view -->

		<!-- �亯�� �߼� -->

        <!-- ����Ʈ ��ư-->
<!--
�䱸�� ���, ���ε�, �䱸�� ����, �亯�� �̸� ����, �亯�� �߼�, �������� ����
-->
         <div id="btn_all">
         <div  class="t_right">
         &nbsp;
         </div>
		 </div>

        <!-- /����Ʈ ��ư-->

        <!-- list -->
        <span class="list01_tl">�亯 ��� <span class="list_total">&bull;&nbsp;��ü�ڷ�� : <%= intTotalRecordCount %>��</span></span>
        <table>
			<tr>
				<td>&nbsp;</td>
			</tr>
		</table>
        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
          <thead>
            <tr>
			<% if (!CodeConstants.REQ_STT_SUBMT.equalsIgnoreCase(strReqStt)) { // ����Ϸᰡ �ƴ� ��츸 �����ּ��� %>
			  <th scope="col"><input name="checkAll" type="checkbox" onClick="javascript:checkAllOrNot(viewForm)" class="borderNo" /></th>
			<% } %>
              <th scope="col" style="width:40%; "><a>���� �ǰ�</a></th>
              <th scope="col"><a>�ۼ���</a></th>
              <th scope="col"><a>�������</a></th>
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
			<% if (!CodeConstants.REQ_STT_SUBMT.equalsIgnoreCase(strReqStt)) { // ����Ϸᰡ �ƴ� ��츸 �����ּ��� %>
              <td><input name="AnsID" type="checkbox" value="<%= objRs.getObject("ANS_ID")%>"  class="borderNo"/></td>
			<% } else { %>
				<%= intRecordNumber+1 %>
			<% } %>
              <td><%= StringUtil.getNotifyImg((String)objRs.getObject("ANS_DT"), CodeConstants.REQ_STT_NOT) %><a href="javascript:gotoDetail('<%= objRs.getObject("ANS_ID") %>')"><%= objRs.getObject("ANS_OPIN") %></a></td>
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
				<td colspan="6" align="center">  ��ϵ� �亯�� �����ϴ�.</td>
			</tr>
		<%
			}
		%>
          </tbody>
        </table>
        <!-- /list -->

        <!-- ����¡-->

        <!-- /����¡-->


       <!-- ����Ʈ ��ư-->
        <div id="btn_all" >        <!-- ����Ʈ �� �˻� -->
        <!-- /����Ʈ �� �˻� -->
			<span class="right">
<% if (!CodeConstants.REQ_STT_SUBMT.equalsIgnoreCase(strReqStt)) { // ����Ϸᰡ �ƴ� ��츸 �����ּ��� %>
			<span class="list_bt"><a href="javascript:goSbmtReqForm()">�߰��亯�ۼ�</a></span>
			<span class="list_bt"><a href="javascript:selectDelete()">���û���</a></span>
<% } %>
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
</form>
<form method="post" action="" name="dupCheckForm" style="margin:0px">
	<input type="hidden" name="queryText" value="<%= StringUtil.ReplaceString((String)objRsSH.getObject("REQ_CONT"), "'", "") %>">
	<input type="hidden" name="ReqBoxID" value="<%= strReqBoxID %>">
	<input type="hidden" name="ReqID" value="<%= strReqID %>">
	<input type="hidden" name="ReturnURL" value="<%= request.getRequestURI() %>?ReqBoxID=
<%= strReqBoxID %>&ReqID=<%= strReqID %>">
</form>
  </div>
  <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>