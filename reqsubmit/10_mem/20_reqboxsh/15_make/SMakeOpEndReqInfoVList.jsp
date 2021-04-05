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

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	UserInfoDelegate objUserInfo = null;
	CDInfoDelegate objCdinfo = null;
%>

<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>

<%
	MemRequestBoxDelegate reqDelegate = null;
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

	// �亯 ���� �� ����¡ ����
	int intTotalRecordCount = 0;

	ResultSetSingleHelper objRsSH = null;
	ResultSetHelper objRs = null;

	try{
	   	reqDelegate = new MemRequestBoxDelegate();
	   	selfDelegate = new SMemReqInfoDelegate();
	   	ansDelegate = new AnsInfoDelegate();

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
//		f.action = "SMakeEndBoxVList.jsp";
        f.action = "../30_makeend/SMakeEndBoxVList.jsp";
		f.target = "";
		f.submit();
	}

	// �䱸�� ��� ��ȸ
	function goReqBoxList() {
		f = document.viewForm;
        f.action = "../30_makeend/SMakeEndBoxList.jsp";
//        f.action = "SMakeEndBoxList.jsp";
		f.target = "";
		f.submit();
	}

  	// �亯 �󼼺���� ����
  	function gotoDetail(strID){
  		f = document.viewForm;
  		//f.AnsID.value = strID;
		f.target = "popwin";
  		f.action="/reqsubmit/common/SAnsInfoView.jsp?AnsID="+strID;
		NewWindow('/blank.html', 'popwin', '618', '590');
  		f.submit();
  		//var add_sub = window.showModalDialog('SMakeAnsInfoView.jsp?returnURL=POPUP&ReqBoxID=<%= strReqBoxID %>&ReqID=<%= strReqID %>&AnsID='+strID, '', 'dialogWidth:500px;dialogHeight:300px; center:yes; help:no; status:no; scroll:no; resizable:yes');
  		//window.open('/reqsubmit/common/SAnsInfoView.jsp?returnURL=POPUP&ReqBoxID=<%= strReqBoxID %>&ReqID=<%= strReqID %>&AnsID='+strID, '', 'width=500,height=400, scrollbars=no, resizable=yes, toolbar=no, menubar=no, location=no, directories=no, status=no');
  	}

  	// �亯 �ۼ� ȭ������ �̵�
  	function goSbmtReqForm() {
  		//f = document.viewForm;
  		//f.ReqID.value = "<%= strReqID %>";
  		//f.AddAnsFlag.value = "Y";
  		//f.action = "/reqsubmit/10_mem/20_reqboxsh/10_make/SMakeAnsInfoWrite.jsp";
		//f.target = "";
 		//f.submit();

		f = document.viewForm;
  		f.ReqID.value = "<%= strReqID %>";
		f.AddAnsFlag.value = "Y";
		f.target = "newpopup";
		f.action = "/reqsubmit/common/SAnsInfoWrite.jsp";
		var winl = (screen.width - 550) / 2;
		var winh = (screen.height - 350) / 2;
		window.open("/blank.html","newpopup","resizable=yes,menubar=no,status=no,titlebar=no, scrollbars=yes,location=no,toolbar=no,height=350,width=520, left="+winl+", top="+winh);
		f.submit();
  	}

  	// ���� �亯 ����
  	function selectDelete() {
  		var f = document.viewForm;
  		if (getCheckCount(f, "AnsID") < 1) {
  			alert("�ϳ� �̻��� üũ�ڽ��� ������ �ּ���");
  			return;
  		}
  		f.action = "SMakeAnsInfoDelProc.jsp";
		f.target = "";
  		if (confirm("�����Ͻ� �亯���� �����Ͻðڽ��ϱ�?\n�ش� �亯���� �����ϸ� ���Ե� ���ϵ鵵 �ϰ� �����˴ϴ�.")) f.submit();
  	}
</script>
</head>

<body>
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
      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%= MenuConstants.REQ_BOX_MAKE_END%></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> <%= MenuConstants.GOTO_HOME %> > <%= MenuConstants.REQ_SUBMIT_MAIN_MENU %> > ��ȸ�ǿ� ������ �ڷ� �䱸 > <%= MenuConstants.REQ_BOX_MAKE_END %></div>
        <p><!--����--></p>
      </div>
      <!-- /pgTit -->
    <div id="contents">
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

					<!-- ���� �� ��ȯ�� URL�� �����ϱ� ���� Parameter ���� -->
					<input type="hidden" name="WinType" value="SELF">
					<input type="hidden" name="ReturnURL" value="<%= request.getRequestURI() %>?ReqBoxID=<%= strReqBoxID %>&ReqID=<%= strReqID %>">
					<input type="hidden" name="AddAnsFlag" value="">

                    <span class="list02_tl">�䱸 ��� ���� </span>
                    <div class="top_btn"><samp>
                    <span class="btn"><a href="javascript:viewReqHistory('<%= strReqID %>')">�䱸 �̷� ����</a></span>
                    <span class="btn"><a href="javascript:goReqBoxView()">�䱸�� ����</a></span>
                    <span class="btn"><a href="javascript:goReqBoxList()">�䱸�� ���</a></span>
                    </samp></div>

					<table border="0" cellspacing="0" cellpadding="0" width="680" class="list02">
                    	<tr>
                      		<th height="25">&bull; �䱸���� </th>
                      		<td height="25" colspan="3"><strong><%= objRsSH.getObject("REQ_CONT") %></strong></td>
                    	</tr>
                    	<tr>
                      		<th height="25">&bull; �䱸����</th>
                      		<td height="25" colspan="3">
                      			<%= StringUtil.getDescString((String)objRsSH.getObject("REQ_DTL_CONT")) %>
                      			<%= nads.dsdm.app.reqsubmit.delegate.requestinfo.RequestInfoDelegate.getAppendRequestInfo((List)objRsSH.getObject("TBDS_REQ_LOG")) %>
                      		</td>
                    	</tr>
                    	<tr>
                      		<th height="25">&bull; �䱸�Ը�</th>
                      		<td height="25" colspan="3"><%= objRsSH.getObject("REQ_BOX_NM") %></td>
                    	</tr>
                    	<tr>
                      		<th height="25" width="18%">&bull; �䱸���</th>
                      		<td width="32%"><%= objRsSH.getObject("REQ_ORGAN_NM") %> (<%= objRsSH.getObject("USER_NM") %>)</td>
                      		<th height="25" width="18%">&bull; ������</th>
                      		<td width="32%"><%= objRsSH.getObject("SUBMT_ORGAN_NM") %></td>
                    	</tr>
                    	<tr>
                      		<th height="25">&bull; �������</th>
                      		<td><%= CodeConstants.getOpenClass((String)objRsSH.getObject("OPEN_CL")) %></td>
                      		<th height="25">&bull; ÷������</th>
                      		<td><%= StringUtil.makeAttachedFileLink((String)objRsSH.getObject("ANS_ESTYLE_FILE_PATH"), (String)objRsSH.getObject("REQ_ID")) %></td>
                    	</tr>
                    	<tr>
                      		<th height="25">&bull; �䱸����</th>
                      		<td><%= StringUtil.getDate2((String)objRsSH.getObject("LAST_REQ_DT")) %></td>
                      		<th height="25">&bull; ��������</th>
                      		<td><%= StringUtil.getDate2((String)objRsSH.getObject("LAST_ANS_DT")) %></td>
                    	</tr>
                    	<tr>
                    		<th height="25">&bull; �������</th>
                      		<td><strong><%= StringUtil.getDate((String)objRsSH.getObject("SUBMT_DLN")) %> 24:00</strong></td>
                      		<th height="25">&bull; ���� ����</th>
                      		<td><%= CodeConstants.getRequestStatus(strReqStt) %></td>
                    	</tr>
                    </table>

                    <div id="btn_all"><div  class="t_right">
                    <% if (!CodeConstants.REQ_STT_SUBMT.equalsIgnoreCase(strReqStt)) { // ����Ϸᰡ �ƴ� ��츸 �����ּ��� %>
	                    <div class="mi_btn"><a href="javascript:sbmtReq()"><span>��� ����</span></a></div>
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
                <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
                  <thead>
                    <tr>
                      <th scope="col" width="10">
                        <% if (!CodeConstants.REQ_STT_SUBMT.equalsIgnoreCase(strReqStt)) { // ����Ϸᰡ �ƴ� ��츸 �����ּ��� %>
                              <input type="checkbox" name="" value="" onClick="javascript:revCheck(this.form, 'AnsID')">
                        <% }  else { %>
                              NO
                        <% } %>
                      </th>
                      <th scope="col" style="width:250px;">���� �ǰ�</th>
                      <th scope="col" style="width:50px; ">�ۼ���</th>
                      <th scope="col">��������</th>
                      <th scope="col">�亯</th>
                      <th scope="col">�ۼ���</th>
                    </tr>
                  </thead>
                  <tbody>
        <%
            int intRecordNumber= 0;
            while(objRs.next()){
        %>
                    <tr>
                      <td width="64" height="22" align="center">
                      <% if (!CodeConstants.REQ_STT_SUBMT.equalsIgnoreCase(strReqStt)) { // ����Ϸᰡ �ƴ� ��츸 �����ּ��� %>
                          <input type="checkbox" name="AnsID" value="<%= objRs.getObject("ANS_ID") %>">
                      <% } else { %>
                          <%= intRecordNumber+1 %>
                      <% } %>
                      </td>
                      <td style="text-align:left;"><a href="javascript:gotoDetail('<%= objRs.getObject("ANS_ID") %>')"><%= objRs.getObject("ANS_OPIN") %></a></td>
                      <td><%= objRs.getObject("USER_NM") %></td>
                      <td><%= CodeConstants.getOpenClass((String)objRs.getObject("OPEN_CL")) %></td>
                      <td><%= nads.lib.reqsubmit.util.DBAccessUtil.makeAnsInfoHtml((String)objRs.getObject("ANS_ID"), (String)objRs.getObject("ANS_MTD")) %></td>
                      <td><%= StringUtil.getDate2((String)objRs.getObject("ANS_DT")) %></td>
                    </tr>
                <%
                        intRecordNumber++;
                    } //endwhile
                %>

                  </tbody>
                </table>

        <div id="btn_all" >
            <span class="right">
            <% if (!CodeConstants.REQ_STT_SUBMT.equalsIgnoreCase(strReqStt)) { // ����Ϸᰡ �ƴ� ��츸 �����ּ��� %>
                <span class="list_bt"><a href="javascript:goSbmtReqForm()">�߰��亯���</a></span>
                <span class="list_bt"><a href="javascript:selectDelete()">���û���</a></span>
            <% } %>
            </span>
        </div>
</form>

    </div>
  </div>
  <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>
