<%@ page language="java" contentType="text/html;charset=EUC-KR" %>

<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.pf.util.PageCount"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.lib.reqsubmit.params.requestbox.SPreReqBoxListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.prereqbox.SPreReqBoxDelegate" %>
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

<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>

<%
  //�α��� ����� ������ �����´�. ���Ѿ��� ��� ������ �����ϴ�.
  String strReqSubmitFlag = objUserInfo.getReqSubmitFlag();


	SPreReqBoxDelegate selfDelegate = null;
	SPreReqBoxListForm paramForm = new SPreReqBoxListForm();
	paramForm.setParamValue("SubmtOrganID", objUserInfo.getOrganID()); // '������' �̹Ƿ�
	paramForm.setParamValue("ReqBoxStt", CodeConstants.REQ_BOX_STT_006); // '�������� �ۼ� ��' �̹Ƿ�

	String AuditYear= paramForm.getParamValue("AuditYear"); // ����⵵
	if ("".equalsIgnoreCase(AuditYear) || AuditYear == null || AuditYear.length() == 0) {
		Calendar now = Calendar.getInstance();
		AuditYear = String.valueOf(now.get(Calendar.YEAR));
	}
	paramForm.setParamValue("AuditYear", AuditYear);

	boolean blnCheckParam = false;
	blnCheckParam = paramForm.validateParams(request);

	if(!blnCheckParam) {
		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
		objMsgBean.setStrCode("DSPARAM-0000");
		objMsgBean.setStrMsg(paramForm.getStrErrors());
		out.println("ParamError:" + paramForm.getStrErrors());
	  	return;
	}

	ResultSetHelper rsHelper = null;
	try {
		selfDelegate = new SPreReqBoxDelegate();
		rsHelper = new ResultSetHelper((Hashtable)selfDelegate.getRecordList(paramForm));
	} catch(AppException e) {
		e.printStackTrace();
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		objMsgBean.setStrCode(e.getStrErrCode());
		objMsgBean.setStrMsg(e.getMessage());
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
  		return;
 	}

	// �䱸�� �����ȸ�� ��� ��ȯ.
	int intTotalRecordCount = rsHelper.getTotalRecordCount();
	int intCurrentPageNum = rsHelper.getPageNumber();
	int intTotalPage = rsHelper.getTotalPageCount();

%>
<jsp:include page="/inc/header.jsp" flush="true"/>
<link href="/css2/style.css" rel="stylesheet" type="text/css">
<script language="javascript">

	var form;

	/** ���Ĺ�� �ٲٱ� */
	function changeSortQuery(sortField, sortMethod){
		form = document.listqry;
  		form.ReqBoxSortField.value = sortField;
  		form.ReqBoxSortMtd.value = sortMethod;
  		form.submit();
  	}

  	/** �䱸�Ի󼼺���� ���� */
  	function gotoDetail(strID){
  		form = document.listqry;
  		form.ReqBoxID.value = strID;
  		form.action="SBasicReqBoxVList.jsp";
  		form.submit();
  	}

  	/** ����¡ �ٷΰ��� */
  	function goPage(strPage){
  		form = document.listqry;
  		form.ReqBoxPage.value=strPage;
  		form.submit();
  	}
</script>
</head>

<body>
  <jsp:include page="/inc/top.jsp" flush="true"/>
  <jsp:include page="/inc/top_menu02.jsp" flush="true"/>
<div id="wrap">
  <div id="container">
    <div id="leftCon">
      <jsp:include page="/inc/log_info.jsp" flush="true"/>
      <jsp:include page="/inc/left_menu02.jsp" flush="true"/>
    </div>
    <div id="rightCon">
      <!-- pgTit -->
      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3>���� �ڷ� �䱸��<span class="sub_stl" >- �䱸�� ���</span></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.REQUEST_BOX_COMM%>
                        > <%=MenuConstants.REQUEST_BOX_PRE%> > <%=MenuConstants.REQ_BOX_PRE%></div>
        <p><!--����--></p>
      </div>
      <!-- /pgTit -->

      <!-- contents -->

      <div id="contents">
        <!-- �˻����� ���� ��� �Ʒ� div ���� �� �ּ����� ��������.-->
        <div class="schBox">
          <p>�䱸����ȸ����</p>
          <span class="line"><img src="/images2/foundation/search_line.gif" width="172" height="3" /></span>
          <div class="box">
            <!-- ������ �˻� ����Ʈ�� ��ư�� ��������-->
            <select name="AuditYear">
				<option>2004</option>
            </select> �䱸�� ���
        </div>
        <!-- /�˻�����-->

        <!-- �������� ���� -->

        <!-- list -->

        <span class="list_total">&bull;&nbsp;��ü�ڷ�� : <%=intTotalRecordCount%>�� (<%=intCurrentPageNum%> / <%=intTotalPage%> page)</span>

<form name="listqry" method="post" action="<%=request.getRequestURI()%>">
<%
	// ���� ���� �ޱ�.
	String strReqBoxSortField = paramForm.getParamValue("ReqBoxSortField");
	String strReqBoxSortMtd = paramForm.getParamValue("ReqBoxSortMtd");
%>
					<input type="hidden" name="ReqBoxSortField" value="<%= strReqBoxSortField %>">
					<input type="hidden" name="ReqBoxSortMtd" value="<%= strReqBoxSortMtd %>">
					<input type="hidden" name="ReqBoxPage" value="<%= intCurrentPageNum %>">
					<input type="hidden" name="ReqBoxID" value="<%= "" %>">


        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
          <thead>
            <tr>
              <th scope="col" style="width:15px;"><a>NO</a></th>
              <th scope="col" style="width:250px;"><%=SortingUtil.getSortLink("changeSortQuery", "REQ_BOX_NM", strReqBoxSortField, strReqBoxSortMtd, "�䱸�Ը�")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery", "REQ_ORGAN_NM", strReqBoxSortField, strReqBoxSortMtd, "�䱸���")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery", "RLTD_DUTY", strReqBoxSortField, strReqBoxSortMtd, "��������")%></th>
              <th scope="col"><a>�亯/�䱸</a></th>
               <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery", "REG_DT", strReqBoxSortField, strReqBoxSortMtd, "�������")%></th>
            </tr>
          </thead>
          <tbody>
		<%
			int intRecordNumber=intTotalRecordCount;
			if(rsHelper.getRecordSize() > 0) {
				String strReqBoxID = "";
				while(rsHelper.next()) {
					strReqBoxID = (String)rsHelper.getObject("REQ_BOX_ID");
					Hashtable countHash = (Hashtable)selfDelegate.getReqBoxRelateCount(strReqBoxID);
		%>
            <tr>
              <td><%= intRecordNumber %></td>
              <td><a href="javascript:gotoDetail('<%=strReqBoxID%>')"><%= (String)rsHelper.getObject("REQ_BOX_NM") %></a></td>
              <td><%= (String)rsHelper.getObject("REQ_ORGAN_NM") %> </td>
              <td><%= objCdinfo.getRelatedDuty((String)rsHelper.getObject("RLTD_DUTY")) %></td>
              <td><%= (String)rsHelper.getObject("SUBMT_CNT") %> / <%= (String)rsHelper.getObject("REQ_CNT") %></td>
              <td><%= StringUtil.getDate((String)rsHelper.getObject("REG_DT")) %></td>
            </tr>
				<%
						intRecordNumber --;
					}//endwhile
				} else {
				%>
			<tr>
				<td colspan="6" align="center">��ϵ� ���� �ڷ� �䱸���� �����ϴ�</td>
			</tr>
				<%
					} // end if
				%>
          </tbody>
        </table>

        <!-- /list -->
					<%=objPaging.pagingTrans(PageCount.getLinkedString(
							new Integer(intTotalRecordCount).toString(),
							new Integer(intCurrentPageNum).toString(),
							paramForm.getParamValue("ReqBoxPageSize")))
					%>
        <!-- ����¡-->
         <!-- /����¡-->
        <!--  <p class="warning">* �䱸���� �߼��ϰ� �Ǹ� �ش� ���� ��� ��ǥ ����ڿ��� ���� �߼۵Ǹ�, ����ڰ� ���� ���� �ۼ� �� �䱸�Կ� �״�� �����ְ� �˴ϴ�.  </p>
          <p class="warning">* �䱸�� �߼� ��ư�� �̿��Ͻñ� ���ؼ��� ����ȸ�� ������ �ֽñ� �ٶ��ϴ�.  </p>  -->



        <!-- ����Ʈ ��ư-->
        <div id="btn_all" >        <!-- ����Ʈ �� �˻� -->
        <div class="list_ser" >
		<% String strReqBoxQryField = paramForm.getParamValue("ReqBoxQryField"); %>
          <select name="ReqBoxQryField" class="selectBox5"  style="width:70px;" >
            <option <%=(strReqBoxQryField.equalsIgnoreCase("req_box_nm"))? " selected ": ""%>value="req_box_nm">�䱸�Ը�</option>
          </select>
          <input name="ReqBoxQryTerm" onKeyDown="return ch()" onMouseDown="return ch()"
		 class="li_input"  style="width:100px" value="<%= paramForm.getParamValue("ReqBoxQryTerm") %>"/>
          <img src="/images2/btn/bt_list_search.gif"  onMouseOver="menuOn(this);" onMouseOut="menuOut(this);" onClick="listqry.submit()"/> </div>
        <!-- /����Ʈ �� �˻�
		<span class="right"><span class="list_bt"><a href="javascript:AllInOne()">�䱸 �ڷ� ���</a></span></span>
-->
		</div>

        <!-- /����Ʈ ��ư-->

        <!-- /�������� ���� -->
      </div>
      <!-- /contents -->
</form>
    </div>
  </div>
  <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>