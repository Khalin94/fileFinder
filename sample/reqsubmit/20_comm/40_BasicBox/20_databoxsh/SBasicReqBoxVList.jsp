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
<%@ page import="nads.lib.reqsubmit.params.requestbox.SPreReqBoxVListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.prereqbox.SPreReqBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.prereqinfo.SPreReqInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.prereqbox.PreRequestBoxDelegate" %>
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

  //�α��� ����� ������ �����´�. ���Ѿ��� ��� ������ �����ϴ�.
  String strReqSubmitFlag = objUserInfo.getReqSubmitFlag();


	SPreReqBoxDelegate selfDelegate = null;
	PreRequestBoxDelegate reqDelegate = null;
	SPreReqInfoDelegate reqInfoDelegate = null;

	SPreReqBoxVListForm objParams = new SPreReqBoxVListForm();
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

	// �Ѿ�� �Ķ���͸� �����ؼ� �ʿ��� �� ������ ����
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

	ResultSetSingleHelper objRsSH = null;
	ResultSetHelper objRs = null;

	try{
		selfDelegate = new SPreReqBoxDelegate();
	   	reqDelegate = new PreRequestBoxDelegate();
	   	reqInfoDelegate = new SPreReqInfoDelegate();

	   boolean blnHashAuth = reqDelegate.checkReqBoxAuth(strReqBoxID, objUserInfo.getOrganID()).booleanValue();


	   	if(!blnHashAuth) {
	   		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	  		objMsgBean.setStrCode("DSAUTH-0001");
  	  		objMsgBean.setStrMsg("�ش� �䱸���� �� ������ �����ϴ�.");
  	  		out.println("�ش� �䱸���� �� ������ �����ϴ�.");
		    return;
		} else {
	    	// �䱸�� ��� ������ SELECT �Ѵ�.
	    	objRsSH = new ResultSetSingleHelper(selfDelegate.getRecord(strReqBoxID));

	    	// �䱸 ����� SELECT �Ѵ�.
	    	objRs = new ResultSetHelper(reqInfoDelegate.getRecordList(objParams));

	    	 /**�䱸���� �����ȸ�� ��� ��ȯ.*/
			intTotalRecordCount = objRs.getTotalRecordCount();
 			intCurrentPageNum = objRs.getPageNumber();
 			intTotalPage = objRs.getTotalPageCount();
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
<script language="javascript">
	var f;
	// �䱸 ��� ��ȸ
	function goReqBoxList() {
		f = document.viewForm;
		f.action = "SBasicReqBoxList.jsp";
		f.submit();
	}

	// ���Ĺ�� �ٲٱ�
	function changeSortQuery(sortField, sortMethod){
		f = document.viewForm;
  		f.ReqInfoSortField.value = sortField;
  		f.ReqInfoSortMtd.value = sortMethod;
  		f.submit();
  	}

  	// �䱸 �󼼺���� ���� */
  	function gotoDetail(strID){
  		f = document.viewForm;
  		f.ReqID.value = strID;
  		f.action="SBasicReqInfoVList.jsp";
  		f.submit();
  	}

  	// ����¡ �ٷΰ���
  	function goPage(strPage){
  		f = document.viewForm;
  		f.ReqInfoPage.value = strPage;
  		f.submit();
  	}
</script>
</head>

<body>
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
    <SCRIPT language="JavaScript" src="/js/reqsubmit/reqinfo.js"></SCRIPT>
	<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>
    </div>
    <div id="rightCon">
      <!-- pgTit -->
      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3>���� �ڷ� �䱸��<span class="sub_stl" >- �䱸�� �� ����</span></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.REQUEST_BOX_COMM%>
                         > <%=MenuConstants.REQUEST_BOX_PRE%> > <%=MenuConstants.REQ_BOX_PRE%></div>
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
					<input type="hidden" name="ReqInfoQryField" value="<%= strReqInfoQryField %>"><!--�䱸���� ��ȸ�ʵ� -->
					<input type="hidden" name="ReqInfoQryTerm" value="<%= strReqInfoQryTerm %>"><!-- �䱸���� ��ȸ�� -->
					<input type="hidden" name="ReqInfoPage" value="<%= strReqInfoPagNum %>"><!-- �䱸���� ������ ��ȣ -->
					<input type="hidden" name="ReturnUrl" value="<%=request.getRequestURI()%>"><!--�ǵ��ƿ� URL -->


        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list02">

            <tr>

              <th width="100px;" scope="col">&bull;&nbsp;�䱸�Ը� </th>
				  <td colspan="3"><%= objRsSH.getObject("REQ_BOX_NM") %></td>
            </tr>
            <tr>
              <th scope="col">&bull;&nbsp;�������� </th>
			  <td><%= objCdinfo.getRelatedDuty((String)objRsSH.getObject("RLTD_DUTY")) %></td>
            </tr>
            <tr>
              <th scope="col">&bull;&nbsp;�䱸���  </th>
			  <td><%= objRsSH.getObject("REQ_ORGAN_NM") %></td>
            </tr>
            <tr>
              <th scope="col">&bull;&nbsp;�䱸�����  </th>
			  <td><%= objRsSH.getObject("USER_NM") %></td>
            </tr>
            <tr>
              <th scope="col">&bull;&nbsp;��������  </th>
			  <td><%= StringUtil.getDate(String.valueOf(objRsSH.getObject("REG_DT"))) %></td>
            </tr>
            <tr>
              <th scope="col">&bull;&nbsp;����Ϸ�����  </th>
			  <td><%= StringUtil.getDate(String.valueOf(objRsSH.getObject("SUBMT_DLN"))) %></td>
            </tr>
             <tr>
              <th scope="col">&bull;&nbsp;�䱸�Լ��� </th>   <td colspan="3"><%= StringUtil.getDescString((String)objRsSH.getObject("REQ_BOX_DSC")) %></td>
            </tr>
        </table>
        <!-- /list view -->
        <!-- ����Ʈ ��ư-->
        <br/>
        <!-- /����Ʈ ��ư-->
        <!-- list -->
        <span class="list01_tl">�䱸 ��� <span class="list_total">&bull;&nbsp;��ü�ڷ�� : <%= intTotalRecordCount %>�� (<%= intCurrentPageNum %>/<%= intTotalPage %> page)</span></span>
        <table width="100%" style="padding:0;">
            <tr>
                <td>&nbsp;</td>
            </tr>
        </table>
<!------------------------------------------------- �䱸 ��� ���̺� ���� ------------------------------------------------->

        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
          <thead>
            <tr>
			  <th scope="col"><a>NO</a></th>
              <th scope="col"><%= SortingUtil.getSortLink("changeSortQuery", "REQ_CONT", strReqInfoSortField, strReqInfoSortMtd, "�䱸����") %></th>
              <th scope="col"><%= SortingUtil.getSortLink("changeSortQuery", "REQ_STT", strReqInfoSortField, strReqInfoSortMtd, "����") %></th>
              <th scope="col"><%= SortingUtil.getSortLink("changeSortQuery", "OPEN_CL", strReqInfoSortField, strReqInfoSortMtd, "��������") %></th>
              <th scope="col"><a>�亯</a></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery", "LAST_ANS_DT", strReqInfoSortField, strReqInfoSortMtd, "�����亯��")%></th>
            </tr>
          </thead>
          <tbody>
		<%
			int intRecordNumber= (intCurrentPageNum -1) * Integer.parseInt((String)objParams.getParamValue("ReqInfoPageSize")) +1;
			if(objRs.getRecordSize()>0){
			String strReqInfoID = "";
			while(objRs.next()){
				strReqInfoID = (String)objRs.getObject("REQ_ID");
		%>
            <tr>
              <td><%= intRecordNumber %></td>
              <td><a href="javascript:gotoDetail('<%= objRs.getObject("REQ_ID") %>')"><%= objRs.getObject("REQ_CONT") %></a></td>
              <td><%= CodeConstants.getRequestStatus((String)objRs.getObject("REQ_STT")) %></td>
              <td><%= CodeConstants.getOpenClass((String)objRs.getObject("OPEN_CL")) %></td>
              <td><%= nads.lib.reqsubmit.util.DBAccessUtil.makeAnsInfoHtml((String)objRs.getObject("ANS_ID"),(String)objRs.getObject("ANS_MTD"),(String)objRs.getObject("ANS_OPIN"),(String)objRs.getObject("SUBMT_FLAG"),objUserInfo.isRequester()) %></td>
              <td><%= StringUtil.getDate((String)objRs.getObject("LAST_ANS_DT")) %></td>
            </tr>
		<%
				intRecordNumber++;
			} //endwhile
		}else{
		%>
			<tr>
				<td colspan="6" align="center">��û�� �䱸������ �����ϴ�.</td>
			</tr>
	<%
		}//end if ��� ��� ��.
	%>
          </tbody>
        </table>
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
							objParams.getParamValue("ReqInfoPageSize")))
						%>

       <!-- /����¡-->


       <!-- ����Ʈ ��ư-->
        <div id="btn_all" >        <!-- ����Ʈ �� �˻� -->
        <div class="list_ser" >
          <select name="ReqInfoQryField" class="selectBox5"  style="width:70px;" >
            <option <%=(strReqInfoQryField.equalsIgnoreCase("req_cont"))? " selected ": ""%> value="req_cont">�䱸����</option>
			<option <%=(strReqInfoQryField.equalsIgnoreCase("req_dtl_cont"))? " selected ": ""%> value="req_dtl_cont">�䱸����</option>
          </select>
          <input name="ReqInfoQryTerm" onKeyDown="return ch()" onMouseDown="return ch()" value="<%= strReqInfoQryTerm %>"
		 class="li_input"  style="width:100px"/>
          <img src="/images2/btn/bt_list_search.gif"  onMouseOver="menuOn(this);" onMouseOut="menuOut(this);" onClick="viewForm.submit()"/> </div>
        <!-- /����Ʈ �� �˻� -->
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
  </div>
  <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>