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
<%@ page import="nads.lib.reqsubmit.params.requestinfo.SPreReqInfoVListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.prereqinfo.SPreReqInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.prereqinfo.SPreAnsInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.prereqbox.PreRequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.prereqbox.SPreReqBoxDelegate" %>


<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	UserInfoDelegate objUserInfo = null;
	CDInfoDelegate objCdinfo = null;
%>

<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>

<%
  //�α��� ����� ������ �����´�. ���Ѿ��� ��� ������ �����ϴ�.
  String strReqSubmitFlag = objUserInfo.getReqSubmitFlag();


	PreRequestBoxDelegate reqDelegate = null;
	SPreReqInfoDelegate selfDelegate = null;
	SPreAnsInfoDelegate ansDelegate = null;
	SPreReqBoxDelegate selfDelegateBox = null; //�䱸�� ������ �Ѿ�� ���� �ӽù���

	SPreReqInfoVListForm objParams = new SPreReqInfoVListForm();

	boolean blnParamCheck=false;
	blnParamCheck = objParams.validateParams(request);
	if(blnParamCheck==false) {
  		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  		objMsgBean.setStrCode("DSPARAM-0000");
  		objMsgBean.setStrMsg(objParams.getStrErrors());
  		out.println("ParamError:" + objParams.getStrErrors());
	  	return;
  	}//endif

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

	String strReqStt = null; // �䱸 ���� ���� ����

	// �亯 ���� �� ����¡ ����
	int intTotalRecordCount = 0;

	ResultSetSingleHelper objRsSH = null;
	ResultSetHelper objRs = null;

	try{
	   	reqDelegate = new PreRequestBoxDelegate();
	   	selfDelegate = new SPreReqInfoDelegate();
	   	ansDelegate = new SPreAnsInfoDelegate();
	   	selfDelegateBox = new SPreReqBoxDelegate();

	   	boolean blnHashAuth = reqDelegate.checkReqBoxAuth(strReqBoxID, objUserInfo.getOrganID()).booleanValue();
	    //boolean blnHashAuth = selfDelegateBox.checkReqBoxAuth(strReqBoxID, objUserInfo.getOrganID()).booleanValue();
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
<link href="/css/System.css" rel="stylesheet" type="text/css">
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
		f.action = "SBasicReqBoxVList.jsp";
		f.submit();
	}

	// �䱸�� ��� ��ȸ
	function goReqBoxList() {
		f = document.viewForm;
		f.target = "";
		f.action = "SBasicReqBoxList.jsp";
		f.submit();
	}

  	// �亯 �󼼺���� ����
  	function gotoDetail(strID){
  		f = document.viewForm;
  		f.target = "popwin";
		f.action = "/reqsubmit/common/SAnsInfoView.jsp?returnURL=POPUP&ReqBoxID=<%= strReqBoxID %>&ReqID=<%= strReqID %>&AnsID="+strID;
		NewWindow('/blank.html', 'popwin', '520', '400');
		f.submit();
  		//var add_sub = window.showModalDialog('SAnsInfoView.jsp?returnURL=POPUP&ReqBoxID=<%= strReqBoxID %>&ReqID=<%= strReqID %>&AnsID='+strID, '', 'dialogWidth:500px;dialogHeight:300px; center:yes; help:no; status:no; scroll:no; resizable:yes');
  		//window.open(', '', 'width=520 height=400, scrollbars=no, resizable=yes, toolbar=no, menubar=no, location=no, directories=no, status=no');
  	}

  	// �亯 �ۼ� ȭ������ �̵�
  	function goSbmtReqForm() {
  		f = document.viewForm;
  		f.ReqID.value = "<%= strReqID %>";
		f.target = "newpopup";
		f.action = "/reqsubmit/common/SAnsInfoWrite.jsp";
		window.open("/blank.html","newpopup","resizable=yes,menubar=no,status=no,titlebar=no, scrollbars=yes,location=no,toolbar=no,height=540,width=620");
		f.submit();
  	}

  	// ���� �亯 ����
  	function selectDelete() {
  		var f = document.viewForm;
  		if (getCheckCount(f, "AnsID") < 1) {
  			alert("�ϳ� �̻��� üũ�ڽ��� ������ �ּ���");
  			return;
  		}
		f.target = "";
  		f.action = "/reqsubmit/common/SAnsInfoDelProc.jsp";
 		if (confirm("�����Ͻ� �亯���� �����Ͻðڽ��ϱ�?\n�ش� �亯���� �����ϸ� ���Ե� ���ϵ鵵 �ϰ� �����˴ϴ�.")) f.submit();
  	}

  	// �䱸 �ߺ� ��ȸ
  	function checkOverlapReq() {
  		var f = document.viewForm;
  		f.target = "popwin";
  		f.action = "/reqsubmit/common/SReqOverlapCheck.jsp?queryText=<%= objRsSH.getObject("REQ_CONT") %>&ReqID=<%= strReqID %>&ReqBoxID=<%= strReqBoxID %>";
		NewWindow('/blank.html', 'popwin', '500', '400');
		f.submit();
  		//window.open('/reqsubmit/common/SReqOverlapCheck.jsp?queryText=<%= objRsSH.getObject("REQ_CONT") %>&ReqID=<%= strReqID %>&ReqBoxID=<%= strReqBoxID %>', '', 'width=500, height=400, scrollbars=no, resizable=yes, toolbar=no, menubar=no, location=no, directories=no, status=no');
  	}
</script>

</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
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
      <SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>
	  <SCRIPT language="JavaScript" src="/js/reqsubmit/reqinfo.js"></SCRIPT>
    </div>
    <div id="rightCon">
      <!-- pgTit -->
      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3>���� �ڷ� �䱸��<span class="sub_stl" >- �䱸 �� ����</span></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.REQUEST_BOX_COMM%> > <%=MenuConstants.REQUEST_BOX_PRE%> > <B><%=MenuConstants.REQ_BOX_PRE%></B></div>
        <p><!--����--></p>
      </div>
      <!-- /pgTit -->

      <!-- contents -->

      <div id="contents">

        <!-- �˻����� ���� ��� �Ʒ� div ���� �� �ּ����� ��������.-->
        <!-- /�˻�����-->


        <!-- �������� ���� -->
         <!-- list view-->

        <span class="list02_tl">�䱸�� ��� ���� </span>
        <div class="top_btn"><samp>
            <%
            if(!strReqSubmitFlag.equals("004")){ %>
            <!-- ��� ����  -->
            <% if (!CodeConstants.REQ_STT_SUBMT.equalsIgnoreCase(strReqStt)  ) { // ����Ϸᰡ �ƴ� ��츸 �����ּ��� %>
                <span class="btn"><a href="#" onClick="javascript:checkOverlapReq()">�ߺ� ��ȸ</a></span>
            <% }//end if StrReqStt
            } %>
            <span class="btn"><a href="#" onClick="javascript:goReqBoxView()">�䱸�� ����</a></span>
            <span class="btn"><a href="#" onClick="javascript:goReqBoxList()">�䱸�� ���</a></span>
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
					<input type="hidden" name="ReqID" value="<%= strReqID %>"> <!-- �䱸 ID -->
					<input type="hidden" name="ReqInfoSortField" value="<%= strReqInfoSortField %>"><!--�䱸���� ��������ʵ� -->
					<input type="hidden" name="ReqInfoSortMtd" value="<%= strReqInfoSortMtd %>"><!--�䱸���� ������Ĺ��-->
					<% if(StringUtil.isAssigned(strReqInfoQryTerm)) { %>
					<input type="hidden" name="ReqInfoQryField" value="<%= strReqInfoQryField %>"><!--�䱸���� ��ȸ�ʵ� -->
					<input type="hidden" name="ReqInfoQryTerm" value="<%= strReqInfoQryTerm %>"><!-- �䱸���� ��ȸ�� -->
					<% } %>
					<input type="hidden" name="ReqInfoPage" value="<%= strReqInfoPagNum %>"><!-- �䱸���� ������ ��ȣ -->

					<!-- ���� �� ��ȯ�� URL�� �����ϱ� ���� Parameter ���� -->
					<input type="hidden" name="WinType" value="SELF">
					<input type="hidden" name="ReqStt" value="<%= strReqStt %>">
					<input type="hidden" name="ReturnURL" value="<%= request.getRequestURI() %>?ReqBoxID=<%= strReqBoxID %>&ReqID=<%= strReqID %>">

					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="list02">
                    	<tr>
                      		<th scope="col">&bull;&nbsp; ����ȸ</th>
                      		<td height="25" colspan="3"><%= objRsSH.getObject("CMT_ORGAN_NM") %></td>
                    	</tr>
                    	<tr>
                      		<th scope="col">&bull;&nbsp; �䱸�Ը�</th>
                      		<td height="25" colspan="3"><%= objRsSH.getObject("REQ_BOX_NM") %></td>
                    	</tr>
                    	<tr>
                      		<th scope="col">&bull;&nbsp; ������</th>
                      		<td width="191" height="25"><%= objRsSH.getObject("SUBMT_ORGAN_NM") %></td>
                      		<th scope="col">&bull;&nbsp; �䱸���</th>
                      		<td width="191"><%= objRsSH.getObject("REQ_ORGAN_NM") %></td>
                    	</tr>
                    	<tr>
                      		<th scope="col">&bull;&nbsp; �䱸 ����</th>
                      		<td height="25" colspan="3"><%= objRsSH.getObject("REQ_CONT") %></td>
                    	</tr>
                    	<tr>
                      		<th scope="col">&bull;&nbsp; �䱸 ����</th>
                      		<td height="25" colspan="3"><%= StringUtil.getDescString((String)objRsSH.getObject("REQ_DTL_CONT")) %>
                    		<%= nads.dsdm.app.reqsubmit.delegate.requestinfo.RequestInfoDelegate.getAppendRequestInfo((List)objRsSH.getObject("TBDS_REQ_LOG")) %>
                    		</td>
                    	</tr>
                    	<tr>
                      		<th scope="col">&bull;&nbsp; �������</th>
                      		<td width="181" height="25"><%= CodeConstants.getOpenClass((String)objRsSH.getObject("OPEN_CL")) %></td>
                      		<th scope="col">&bull;&nbsp;����������</th>
                      		<td width="242">
                      			<%= StringUtil.makeAttachedFileLink((String)objRsSH.getObject("ANS_ESTYLE_FILE_PATH"), (String)objRsSH.getObject("REQ_ID")) %>
                      		</td>
                    	</tr>
                    	<tr>
                      		<th scope="col">&bull;&nbsp; �����</th>
                      		<td width="181" height="25"><%=(String)objRsSH.getObject("REGR_NM") %></td>
                      		<th scope="col">&bull;&nbsp; �������</th>
                      		<td width="242"><%= StringUtil.getDate((String)objRsSH.getObject("LAST_REQ_DT")) %></td>
                    	</tr>
                    	<tr>
                      		<th scope="col">&bull;&nbsp; ���⿩��</th>
                      		<td height="25" colspan="3"><%= CodeConstants.getRequestStatus(strReqStt) %></td>
                    	</tr>
                    </table>
                    <div id="btn_all"><div  class="t_right">
                        <%
                        if(!strReqSubmitFlag.equals("004")){ %>
                        <!-- ��� ����  -->
                        <% if (!CodeConstants.REQ_STT_SUBMT.equalsIgnoreCase(strReqStt)  ) { // ����Ϸᰡ �ƴ� ��츸 �����ּ��� %>
                            <% if (intTotalRecordCount > 0) { %>
                            <div class="mi_btn"><a href="#" onClick="javascript:sbmtReq()"><span>��� ����</span></a></div>
                            <%  }// end if intTotalRecordCount %>
                        <% }//end if StrReqStt
                        } %>
                    </div></div>

                    <span class="list01_tl">�亯 ��� <span class="list_total">&bull;&nbsp;��ü�ڷ�� : <%= intTotalRecordCount %>��</span></span>
                    <table>
                        <tr><td>&nbsp;</td></tr>
                    </table>

                	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
                        <thead>
    	                <tr>
            	          	<th scope="col" width="64" height="22">
            	          		<% if (!CodeConstants.REQ_STT_SUBMT.equalsIgnoreCase(strReqStt)) { // ����Ϸᰡ �ƴ� ��츸 �����ּ��� %>
	            	          		<input type="checkbox" name="checkAll" value="" onClick="checkAllOrNot(document.viewForm)">
	            	          		<!--input type="checkbox" name="checkAll" value="" onClick="javascript:checkAllOrNot(viewForm)"-->
	            	          	<% } %>
            	          	</th>
	                	    <th scope="col" width="335"><a>���� �ǰ�</a></th>
                    	  	<th scope="col" width="80"><a>�ۼ���</a></th>
    	                  	<th scope="col" width="60"><a>��������</a></th>
        	              	<th scope="col" width="150"><a>�亯</a></th>
	                      	<th scope="col" width="80"><a>�ۼ���</a></th>
            	        </tr>
                        </thead>
                        <tbody>
                    	<%
                    		int intRecordNumber= 0;
                    		if(objRs.getRecordSize()>0){
							while(objRs.next()){
						%>
						<tr>
							<td height="22" align="center">
								<% if (!CodeConstants.REQ_STT_SUBMT.equalsIgnoreCase(strReqStt)) { // ����Ϸᰡ �ƴ� ��츸 �����ּ��� %>
									<input type="checkbox" name="AnsID" value="<%= objRs.getObject("ANS_ID") %>">
								<% } else { %>
									<%= intRecordNumber+1 %>
								<% } %>
							</td>
							<td><a href="javascript:gotoDetail('<%= objRs.getObject("ANS_ID") %>')"><%= objRs.getObject("ANS_OPIN") %></a></td>
							<td align="center"><%= objRs.getObject("USER_NM") %></td>
							<td align="center"><%= CodeConstants.getOpenClass((String)objRs.getObject("OPEN_CL")) %></td>
							<td align="center"><%=nads.lib.reqsubmit.util.DBAccessUtil.makeAnsInfoHtml((String)objRs.getObject("ANS_ID"), (String)objRs.getObject("ANS_MTD")) %></td>
							<td align="center"><%= StringUtil.getDate((String)objRs.getObject("ANS_DT")) %></td>
						</tr>
                    	<%
                    			intRecordNumber++;
							} //endwhile
                    	}else{
		  				%>
			      			<tr>
								<td height="22" colspan="6" align="center">��ϵ� �亯������ �����ϴ�.</td>
				  			</tr>

		  				<%
						}//end if ��� ��� ��.
		  				%>
                    </table>
	               	<!------------------------------------------------- �䱸 ��� ���̺� �� ------------------------------------------------->
            <%
            //���� ����
            if(!strReqSubmitFlag.equals("004")){ %>
            <% if (!CodeConstants.REQ_STT_SUBMT.equalsIgnoreCase(strReqStt)) { // ����Ϸᰡ �ƴ� ��츸 �����ּ��� %>
            <div id="btn_all" >        <!-- ����Ʈ �� �˻� -->
                <span class="right">
                    <span class="list_bt"><a href="#" onclick="javascript:goSbmtReqForm()">�亯�ۼ�</a></span>
                    <span class="list_bt"><a href="#" onClick="javascript:selectDelete()">���û���</a></span>
                </span>
            </div>
            <% }
             } //end if ���Ѿ����� ���� %>

        <!-- /����Ʈ ��ư-->
        <!-- /�������� ���� -->
      </div>
      <!-- /contents -->

    </div>
  </div>
  </form>
  <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>