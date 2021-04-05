<%@ page language="java" contentType="text/html;charset=EUC-KR" %>

<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="java.util.*" %>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RCommReqBoxVListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.CommRequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.CommRequestInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.CommAnsInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.SMemReqBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.SCommRequestBoxDelegate" %>
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
	/**�Ϲ� �䱸�� �󼼺��� �Ķ���� ����.*/
	RCommReqBoxVListForm objParams =new RCommReqBoxVListForm();

	boolean blnParamCheck=false;
	/**���޵� �ĸ����� üũ */
	blnParamCheck=objParams.validateParams(request);
	if(blnParamCheck==false){
		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
		objMsgBean.setStrCode("DSPARAM-0000");
		objMsgBean.setStrMsg(objParams.getStrErrors());
		out.println("ParamError:" + objParams.getStrErrors());
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}//endif
%>

<%
	//�α��� ����� ������ �����´�. ���Ѿ��� ��� ������ �����ϴ�.
	String strReqSubmitFlag = objUserInfo.getReqSubmitFlag();

	/*** Delegate �� ������ Container��ü ���� */
	CommRequestBoxDelegate objReqBox=null; 		/**�䱸�� Delegate*/
	SMemReqBoxDelegate selfDelegate = null;
	CommRequestInfoDelegate  objReqInfo=null;		/** �䱸���� Delegate */
	CommAnsInfoDelegate objAnsInfo = new CommAnsInfoDelegate();
	ResultSetSingleHelper objRsSH=null;			/** �䱸�� �󼼺��� ���� */
	ResultSetSingleHelper objRsRI=null;			/** �䱸 �󼼺��� ���� */
	ResultSetHelper objRs = null;					/** �亯 ��� */

	SCommRequestBoxDelegate objReqBox2 = null; 		/**�䱸�� Delegate*/
	ResultSetSingleHelper objRsSH2 = null;			/** �䱸�� �󼼺��� ���� */
	ResultSetHelper objRs2 = null;					/**�䱸 ��� */

	String strReqID = (String)objParams.getParamValue("CommReqID");
	int intTotalAnsCount = 0;

	try {
		/**�䱸�� ���� �븮�� New */
		objReqBox=new CommRequestBoxDelegate();
		objReqBox2 = new SCommRequestBoxDelegate();

		objRsSH2 = new ResultSetSingleHelper(objReqBox2.getRecord((String)objParams.getParamValue("ReqBoxID"), objUserInfo.getUserID()));
		/** �䱸 ���� �븮�� New */
		//objRs2 = new ResultSetHelper((Hashtable)objReqBox2.getReqRecordList(objParams));
		/** �䱸�� ���� */
		objRsSH=new ResultSetSingleHelper(objReqBox.getRecord((String)objParams.getParamValue("ReqBoxID")));
		/**�䱸 ���� �븮�� New */
		objReqInfo=new CommRequestInfoDelegate();
		objRsRI=new ResultSetSingleHelper(objReqInfo.getRecord((String)objParams.getParamValue("CommReqID")));
		objRs = new ResultSetHelper(objAnsInfo.getRecordList((String)objParams.getParamValue("CommReqID")));
		selfDelegate = new SMemReqBoxDelegate();
		intTotalAnsCount = selfDelegate.checkReqInfoAnsIsNull((String)objParams.getParamValue("ReqBoxID"));


	} catch(AppException objAppEx) {
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		objMsgBean.setStrCode(objAppEx.getStrErrCode());
		objMsgBean.setStrMsg(objAppEx.getMessage());
		//out.println("<br>Error!!!" + objAppEx.getMessage());
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}
%>
<jsp:include page="/inc/header.jsp" flush="true"/>
<link href="/css2/style.css" rel="stylesheet" type="text/css">
<script language="javascript">
  	// �亯 �ۼ� ȭ������ �̵�
  	function gotoNewAns111() {
  		f = document.formName;
  		f.action = "/reqsubmit/20_comm/20_reqboxsh/SCommAnsInfoWrite.jsp";
  		f.submit();
  	}

	// �亯 �ۼ� ȭ������ �̵�
  	function gotoNewAnsTest() {
  		f = document.formName;
		f.target = "newpopup";
		f.action = "/reqsubmit/common/SAnsInfoWrite_hyo.jsp";
		var winl = (screen.width - 600) / 2;
		var winh = (screen.height - 600) / 2;
		window.open("/blank.html","newpopup","resizable=yes,menubar=no,status=no,titlebar=no, scrollbars=yes,location=no,toolbar=no,height=600,width=618, left="+winl+", top="+winh);
		f.submit();
  	}

  	// �亯 �ۼ� ȭ������ �̵�
  	function gotoNewAns() {
  		f = document.formName;
		f.target = "newpopup";
		f.action = "/reqsubmit/common/SAnsInfoWrite.jsp";
		var winl = (screen.width - 600) / 2;
		var winh = (screen.height - 600) / 2;
		window.open("/blank.html","newpopup","resizable=yes,menubar=no,status=no,titlebar=no, scrollbars=yes,location=no,toolbar=no,height=600,width=618, left="+winl+", top="+winh);
		f.submit();
  	}
  	// �亯 �ۼ� ȭ������ �̵�
  	function gotoNewAns_old() {
  		f = document.formName;
		f.target = "newpopup";
		f.action = "/reqsubmit/common/SAnsInfoWrite_old.jsp";
		var winl = (screen.width - 550) / 2;
		var winh = (screen.height - 350) / 2;
		window.open("/blank.html","newpopup","resizable=yes,menubar=no,status=no,titlebar=no, scrollbars=yes,location=no,toolbar=no,height=350,width=520, left="+winl+", top="+winh);
		f.submit();
  	}
  	// �亯 �󼼺���� ����
  	function gotoDetail(strAnsID){
  		f = document.formName;
  		f.target = "popwin";
  		f.action="/reqsubmit/common/SAnsInfoView.jsp?AnsID="+strAnsID;
  		NewWindow('/blank.html', 'popwin', '618', '590');
  		//window.open('about:blank', 'popwin', 'width=520,height=400, scrollbars=no, resizable=yes, toolbar=no, menubar=no, location=no, directories=no, status=no');
  		f.submit();
  	}
  	// ����� �䱸������� ����
  	function gotoList(){
  		f = document.formName;
  		f.action="SNonReqList.jsp";
  		f.target = "";
  		f.submit();
 	}

	function sbmtReq() {
		f = document.formName;
		f.target = "";
		f.action = "/reqsubmit/common/SReqSubmtDoneProc.jsp";
		if (confirm("���� �䱸�� ���� �亯 ������ �Ϸ��Ͻðڽ��ϱ�?")) f.submit();
	}

	function selectDelete() {
  		var f = document.formName;
  		f.ReqID.value = "<%= strReqID %>";
  		f.target = "";
  		if (getCheckCount(f, "AnsID") < 1) {
  			alert("�ϳ� �̻��� üũ�ڽ��� ������ �ּ���");
  			return;
  		}
  		f.action = "/reqsubmit/common/SAnsInfoDelProc.jsp";
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
	<SCRIPT language="JavaScript" src="/js/reqinfo.js"></SCRIPT>
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
			<input type="hidden" name="ReqBoxID" value="<%=objRsRI.getObject("REQ_BOX_ID")%>"><!--�䱸���� ������ ��ȣ -->
			<input type="hidden" name="ReqID" value="<%=objRsRI.getObject("REQ_ID")%>"><!--�䱸���� ������ ��ȣ -->
			<input type="hidden" name="ReqStt" value="<%=objRsRI.getObject("REQ_STT")%>"><!--�䱸���� ������ ��ȣ -->
			<input type="hidden" name="WinType" value="SELF">
			<input type="text" name="ReqOpenCL" value="<%= objRsRI.getObject("OPEN_CL") %>">

			<input type="hidden" name="WriteURL" value="<%=request.getRequestURI()%>?ReqBoxID=<%=objRsRI.getObject("REQ_BOX_ID")%>&CommReqID=<%=objRsRI.getObject("REQ_ID")%>&AuditYear=<%=objParams.getParamValue("AuditYear")%>">
			<input type="hidden" name="AuditYear" value="<%=objParams.getParamValue("AuditYear")%>">
			<input type="hidden" name="CmtOrganID" value="<%=objParams.getParamValue("CmtOrganID")%>">
		    <input type="hidden" name="ReturnURL" value="<%=request.getRequestURI()%>?ReqBoxID=<%=objRsRI.getObject("REQ_BOX_ID")%>&CommReqID=<%=objRsRI.getObject("REQ_ID")%>&AuditYear=<%=objParams.getParamValue("AuditYear")%>">
      <!-- pgTit -->
      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=MenuConstants.REQ_INFO_LIST_SUBMT_NONE%><span class="sub_stl" >- �䱸�󼼺���</span></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%= MenuConstants.REQUEST_BOX_COMM %> > <%=MenuConstants.REQ_INFO_LIST%> > <%=MenuConstants.REQ_INFO_LIST_SUBMT_NONE%></div>
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
			 <span class="btn"><a href="javascript:viewReqHistory('<%=objRsRI.getObject("REQ_ID")%>')">�䱸 �̷� ����</a></span>
			 <span class="btn"><a href="javascript:gotoList()">�䱸 ���</a></span>
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
				  <td colspan="3"><strong><%=objRsRI.getObject("REQ_CONT")%></strong> </td>
            </tr>

            <tr>
              <th scope="col">&bull;&nbsp;�䱸���� </th>
			  <td colspan="3"><%=StringUtil.getDescString((String)objRsRI.getObject("REQ_DTL_CONT"))%><br>
       			<%= nads.dsdm.app.reqsubmit.delegate.requestinfo.RequestInfoDelegate.getAppendRequestInfo((List)objRsRI.getObject("TBDS_REQ_LOG")) %></td>
            </tr>
            <tr>
              <th scope="col">&bull;&nbsp;�䱸�Ը�  </th>
			  <td colspan="3"><%=objRsRI.getObject("REQ_BOX_NM")%></td>
            </tr>
            <tr>
              <th width="18%" scope="col">&bull;&nbsp;�Ұ�����ȸ </th>
			  <td width="32%"> <%= objRsRI.getObject("CMT_ORGAN_NM") %></td>
              <th width="18%" height="25" >&bull; ���� ����</th>
              <td width="32%" height="25"><%= CodeConstants.getRequestStatus(objRsRI.getObject("REQ_STT").toString()) %></td>
            </tr>
            <tr>
              <th scope="col">&bull;&nbsp;�䱸���  </th>
			  <td><%= objRsRI.getObject("REQ_ORGAN_NM") %> (<%=objRsRI.getObject("REGR_NM")%>)</td>
              <th scope="col">&bull; ������</th>
		  		<td><%= objRsRI.getObject("SUBMT_ORGAN_NM") %></td>
            </tr>
            <tr>
              <th scope="col">&bull;&nbsp;�������  </th>
			  <td><strong><%= StringUtil.getDate((String)objRsRI.getObject("SUBMT_DLN")) %> 24:00</strong></td>
              <th scope="col">&bull;&nbsp;�䱸����  </th>
			  <td><strong><%= StringUtil.getDate2((String)objRsRI.getObject("LAST_REQ_DT")) %></strong></td>
            </tr>
            <tr>
                <th height="25">&bull; �������</th>
		  		<td height="25"><%= CodeConstants.getOpenClass((String)objRsRI.getObject("OPEN_CL")) %></td>
                <th height="25">&bull; ÷������</th>
		  		<td height="25"><%= StringUtil.makeAttachedFileLink((String)objRsRI.getObject("ANS_ESTYLE_FILE_PATH"), (String)objRsRI.getObject("REQ_ID")) %></td>
			</tr>
			<%
				}/** �䱸 ���� �� ������. */
			%>
        </table>
        <!-- /list view -->
		<!-- �亯�� �߼� -->
        <!-- ����Ʈ ��ư-->
<!--
�䱸 �̷� ����, �䱸 ���
-->
        <div id="btn_all"><div  class="t_right">
		</div></div>
        <!-- /����Ʈ ��ư-->
        <!-- list -->
        <span class="list01_tl">�亯 ��� <span class="list_total">&bull;&nbsp;��ü�ڷ�� :  <%= objRs.getRecordSize()%>�� </span></span>
        <table width="100%" style="padding:0;">
            <tr>
                <td>&nbsp;</td>
            </tr>
        </table>
        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
          <thead>
            <tr>
			 <th style="width:15px;">
				<input name="checkAll" type="checkbox" value="" class="borderNo" onClick="javascript:checkAllOrNot(this.form)"/>
			 </th>
			  <th scope="col" style="width:15px;"><a>NO</a></th>
              <th scope="col" style="width:250px;"><a>���� �ǰ�</a></th>
              <th scope="col"><a>�ۼ���</a></th>
              <th scope="col"><a>����</a></th>
              <th scope="col"><a>�亯</a></th>
			  <th scope="col"><a>�亯��</a></th>
            </tr>
          </thead>
          <tbody>
			<%
				int intRecordNumber=1;
				String strAnsInfoID="";
				if (objRs.getRecordSize() > 0) {
					while(objRs.next()){
						 strAnsInfoID = (String)objRs.getObject("ANS_ID");
			 %>
            <tr>
			  <td>
				 <input name="AnsID" type="checkbox" value="<%= strAnsInfoID %>" class="borderNo"/>
			  </td>
              <td><%= intRecordNumber %></td>
              <td><a href="JavaScript:gotoDetail('<%=strAnsInfoID%>');"><%=StringUtil.substring((String)objRs.getObject("ANS_OPIN"),35)%></a></td>
              <td><%=(String)objRs.getObject("USER_NM")%></td>
              <td><%=CodeConstants.getOpenClass(((String)objRs.getObject("OPEN_CL")))%></td>
			  <td><%=nads.lib.reqsubmit.util.DBAccessUtil.makeAnsInfoHtml(strAnsInfoID,(String)objRs.getObject("ANS_MTD"))%></td>
			  <td><%=StringUtil.getDate2((String)objRs.getObject("ANS_DT"))%></td>
            </tr>
	<%
				intRecordNumber++;
			} //endwhile
		} else {
	%>
			<tr>
			  <td colspan="7" align="center">��ϵ� �亯�� �����ϴ�.</td>
            </tr>
	<%
		}
	%>
          </tbody>
        </table>
        <!-- /list -->

       <!-- ����Ʈ ��ư-->
        <span class="right">

		<%
		/**����ȸ���� �űԵ���� �䱸�� ����-> ����??*/
		//���� ����
		// �亯 �ۼ�, �䱸 �̷� ����, �䱸 ���, ��� ����
		if(!strReqSubmitFlag.equals("004")){
		%>
			<span class="list_bt"><a href="javascript:gotoNewAns_old()" onfocus="this.blur()">�亯�ۼ�</a></span>
		<% } %>
			<span class="list_bt"><a href="javascript:gotoNewAns()">��뷮���ϵ��</a></span>
			<!-- <span class="list_bt"><a href="javascript:gotoNewAnsTest()">��뷮���ϵ���׽�Ʈ</a></span> -->
			<span class="list_bt"><a href="javascript:selectDelete()">���û���</a></span>
	 <%
		if(!strReqSubmitFlag.equals("004") && !CodeConstants.REQ_STT_SUBMT.equalsIgnoreCase((String)objRsRI.getObject("REQ_STT")) && objRs.getRecordSize() > 0) {
	%>
			<span class="list_bt"><a href="javascript:sbmtReq()" onfocus="this.blur()">�������</a></span>
	<%
		}
	%>
<!--
			<span class="list_bt"><a href="#">�䱸����</a></span>
			<span class="list_bt"><a href="#">�䱸����</a></span>
-->
			</span>
        <!-- /����Ʈ ��ư-->
        <!-- /�������� ���� -->
      <!-- /contents -->

    </div>
  </div>
</form>
<form method="post" action="" name="dupCheckForm" style="margin:0px">
	<input type="hidden" name="queryText" value="<%= StringUtil.ReplaceString((String)objRsRI.getObject("REQ_CONT"), "'", "") %>">
	<input type="hidden" name="ReqBoxID" value="<%=objRsRI.getObject("REQ_BOX_ID")%>">
	<input type="hidden" name="ReqID" value="<%=objRsRI.getObject("REQ_ID")%>">
	<input type="hidden" name="ReturnURL" value="<%=request.getRequestURI()%>?ReqBoxID=<%=objRsRI.getObject("REQ_BOX_ID")%>&CommReqID=<%=objRsRI.getObject("REQ_ID")%>&AuditYear=<%=objParams.getParamValue("AuditYear")%>">
</form>
  <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>