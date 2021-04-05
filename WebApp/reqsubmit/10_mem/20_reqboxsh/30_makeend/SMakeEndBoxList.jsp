<%@ page language="java" contentType="text/html; charset=EUC-KR" %>
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
<%@ page import="nads.lib.reqsubmit.params.requestbox.SMemReqBoxListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.SMemReqBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.MemRequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.RequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.common.page.PagingDelegate" %>


<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	UserInfoDelegate objUserInfo =null;
	CDInfoDelegate objCdinfo =null;
%>
<%
	/*** PagingDelegate */
	PagingDelegate objPaging=new PagingDelegate(); 		/*����¡ ��ȯ Delegate*/
%>
<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>

<%
	String strSelectedAuditYear= null;
	String strSelectedReqOrganID = null;
	String strDaesuInfo = StringUtil.getEmptyIfNull(request.getParameter("DaeSu"));
	String strDaeSuCh = StringUtil.getEmptyIfNull(request.getParameter("DAESUCH"));
	String strSubmtOrganId = StringUtil.getEmptyIfNull(request.getParameter("submtOrganId2"));
	String strOrganId = null;

	if(strSubmtOrganId.equals("")){
		strOrganId = objUserInfo.getOrganID();
	}else{
		strOrganId = strSubmtOrganId;
	}


	String strDaesu = null;
	String strStartdate = null;
	String strEnddate = null;

	SMemReqBoxDelegate selfDelegate = null;
	MemRequestBoxDelegate objReqBox=null;
	RequestBoxDelegate objReqBoxDelegate = null;
	SMemReqBoxListForm paramForm = new SMemReqBoxListForm();
	paramForm.setParamValue("SubmtOrganID", strSubmtOrganId); // '������' �̹Ƿ�
	paramForm.setParamValue("ReqBoxStt", CodeConstants.REQ_BOX_STT_007); // '�������� �ۼ� ��' �̹Ƿ�

	//������ ���� ���� ����
	//paramForm.setParamValue("ReqBoxTp", "001");

	if(((String)paramForm.getParamValue("ReqBoxSortField")).equals("last_req_doc_snd_dt")){
		paramForm.setParamValue("ReqBoxSortField", "LAST_ANS_DOC_SND_DT");
	}
	//������ ���� ���� ��

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
	ResultSetHelper objRsAuditYear = null;
	ResultSetHelper objRsReqOrgan = null;
	ResultSetHelper objDaeRs=null;
	ResultSetHelper objSubmtRs=null;

	try {
		objReqBoxDelegate = new RequestBoxDelegate();
		strSelectedAuditYear = paramForm.getParamValue("AuditYear");
		strSelectedReqOrganID = paramForm.getParamValue("ReqOrganID");

		objDaeRs = new ResultSetHelper(objReqBoxDelegate.getOrganDaesu(strOrganId));
		List lst = objReqBoxDelegate.getSubmtOrganList(objUserInfo.getOrganID());
		objSubmtRs = new ResultSetHelper(lst);
		if(strDaesuInfo.equals("")){
			if(objDaeRs != null){
				if(objDaeRs.next()){
					strDaesu = (String)objDaeRs.getObject("DAE_NUM");
					strStartdate = (String)objDaeRs.getObject("START_DATE");
					strEnddate = (String)objDaeRs.getObject("END_DATE");
					objDaeRs.first();
				}
			}
		}else{
			String[] strDaesuInfos = StringUtil.split("^",strDaesuInfo);
			strDaesu = strDaesuInfos[0];
			strStartdate = strDaesuInfos[1];
			strEnddate = strDaesuInfos[2];

		}


		Hashtable objhashdata = new Hashtable();

		objhashdata.put("START_DATE",strStartdate);
		objhashdata.put("END_DATE",strEnddate);
		objhashdata.put("SUBMTORGANIDZ",lst);

		selfDelegate = new SMemReqBoxDelegate();
		objReqBox=new MemRequestBoxDelegate();

		// ���� + ������
		Hashtable objaaa = (Hashtable)selfDelegate.getSOpRecordDaeList(paramForm,objhashdata);

		rsHelper = new ResultSetHelper(objaaa);
		objRsAuditYear = new ResultSetHelper(selfDelegate.getAuditYearDaeList(lst,strSubmtOrganId,strStartdate,strEnddate,CodeConstants.REQ_BOX_STT_007));
		objRsReqOrgan = new ResultSetHelper(selfDelegate.getReqOrganDaeList(paramForm,objhashdata));

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

	/** ���Ĺ�� �ٲٱ� */
	function changeSortQuery(sortField, sortMethod){
		form = document.listqry;
  		form.ReqBoxSortField.value = sortField;
  		form.ReqBoxSortMtd.value = sortMethod;
		form.DAESUCH.value = "N";
  		form.submit();
  	}

  	/** �䱸�Ի󼼺���� ���� */
  	function gotoDetail(strID, strReqBoxTP){
  		form = document.listqry;
  		form.ReqBoxID.value = strID;
		if(strReqBoxTP == '����'){
			form.action="SMakeEndBoxVList.jsp";
		}else if(strReqBoxTP == '������'){
			form.action="../15_make/SMakeOpEndBoxVList.jsp";
		}
  		form.submit();
  	}

  	/** ����¡ �ٷΰ��� */
  	function goPage(strPage){
  		form = document.listqry;
  		form.ReqBoxPage.value=strPage;
		form.DAESUCH.value = "N";
  		form.submit();
  	}

  	function doRefresh() {
		var f = document.listqry;
		f.DAESUCH.value = "N";
		f.target = "";
		f.submit();
	}

	function changeDaesu(){
		form = document.listqry;
		form.target = '';
		form.DAESUCH.value = "Y";
		form.submit();
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
        <h3><%= MenuConstants.REQ_BOX_MAKE_END %></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" />  <%= MenuConstants.GOTO_HOME %> > <%= MenuConstants.REQ_SUBMIT_MAIN_MENU %> > <%= MenuConstants.getReqBoxGeneral(request) %> > <%= MenuConstants.REQ_BOX_MAKE_END %></div>
        <p><!--����--></p>
      </div>
      <!-- /pgTit -->

      <!-- contents -->

      <div id="contents">
<form name="listqry" method="post" action="<%=request.getRequestURI()%>" style="margin:0px">
<input type="hidden" name="DAESUCH"/>
        <!-- �˻����� ���� ��� �Ʒ� div ���� �� �ּ����� ��������.-->
        <div class="schBox">
          <p>�䱸����ȸ����</p>
          <span class="line"><img src="/images2/foundation/search_line.gif" width="172" height="3" /></span>
          <div class="box">
            <!-- ������ �˻� ����Ʈ�� ��ư�� ��������-->
            <select onChange="changeDaesu()" name="DaeSu">
			<%
				if(objDaeRs != null){
					while(objDaeRs.next()){
						String str = objDaeRs.getObject("DAE_NUM")+"^"+objDaeRs.getObject("START_DATE")+"^"+objDaeRs.getObject("END_DATE");
			%>
					<option value="<%=objDaeRs.getObject("DAE_NUM")%>^<%=objDaeRs.getObject("START_DATE")%>^<%=objDaeRs.getObject("END_DATE")%>" <%if(str.equals(strDaesuInfo)){%>selected<%}%>><%=objDaeRs.getObject("DAE_NUM")%>��</option>
			<%
					}
				}
			%>
            </select>
            <select onChange="javascript:doRefresh()" name="AuditYear">
              <option value="">��ü</option>
			  <%
				if(objRsAuditYear != null && objRsAuditYear.getTotalRecordCount() > 0) {
					String strSelected1 = "";
					while(objRsAuditYear.next()) {
						if(strSelectedAuditYear.equals((String)objRsAuditYear.getObject("AUDIT_YEAR"))) strSelected1 = " selected";
						else strSelected1 = "";
						out.println("<option value="+(String)objRsAuditYear.getObject("AUDIT_YEAR")+strSelected1+">"+(String)objRsAuditYear.getObject("AUDIT_YEAR")+"</option>");
					}
				}
			%>
            </select> �⵵
			<%
				if(objSubmtRs.getTotalRecordCount() < 2){
			%>
			<%
				}else{
			%>
            <select onChange="javascript:doRefresh()" name="submtOrganId2">
              <option value="">��ü</option>
			  <%
				while(objSubmtRs.next()){
			  %>
			  <option value="<%=objSubmtRs.getObject("ORGAN_ID")%>"
			<%
			 if(strSubmtOrganId.equals(objSubmtRs.getObject("ORGAN_ID"))){
			%>
				selected
			<%
			}%>
			><%=objSubmtRs.getObject("ORGAN_NM")%></option>
			<%}%>
            </select>
			<%
				}
			%>
            <select onChange="javascript:doRefresh()" name="ReqOrganID">
              <option value="">:::: ��ü �䱸��� ::::</option>
              <%
				if(objRsReqOrgan.getTotalRecordCount() < 1) {
					out.println("<option value=''>::: �䱸����� �����ϴ� :::</option>");
				}
				String strSelected2 = "";
				while(objRsReqOrgan.next()) {
					if(strSelectedReqOrganID.equalsIgnoreCase((String)objRsReqOrgan.getObject("REQ_ORGAN_ID"))) strSelected2 = " selected";
					else strSelected2 = "";
					out.println("<option value="+(String)objRsReqOrgan.getObject("REQ_ORGAN_ID")+strSelected2+">"+(String)objRsReqOrgan.getObject("REQ_ORGAN_NM")+"</option>");
				}
			%>
            </select>�䱸�� ���
<!-- <a href="#"><img src="/images2/btn/bt_search2.gif" width="50" height="22" /></a> </div> -->
        </div>
        <!-- /�˻�����-->

        <!-- �������� ���� -->

        <!-- list -->

        <span class="list_total">&bull;&nbsp;��ü�ڷ�� : <%=intTotalRecordCount%>�� (<%=intCurrentPageNum%> / <%=intTotalPage%> page)</span>


        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
          <thead>
<%
	// ���� ���� �ޱ�.
	String strReqBoxSortField = paramForm.getParamValue("ReqBoxSortField");
	String strReqBoxSortMtd = paramForm.getParamValue("ReqBoxSortMtd");
%>
					<input type="hidden" name="ReqBoxSortField" value="<%= strReqBoxSortField %>">
					<input type="hidden" name="ReqBoxSortMtd" value="<%= strReqBoxSortMtd %>">
					<input type="hidden" name="ReqBoxPage" value="<%= intCurrentPageNum %>">
					<input type="hidden" name="ReqBoxID" value="<%= "" %>">
            <tr>
              <th scope="col"><a>NO</a></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery", "REQ_BOX_TP", strReqBoxSortField, strReqBoxSortMtd, "���ڱ���")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery", "REQ_BOX_NM", strReqBoxSortField, strReqBoxSortMtd, "�䱸�Ը�")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery", "REQ_ORGAN_NM", strReqBoxSortField, strReqBoxSortMtd, "�䱸���")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery", "RLTD_DUTY", strReqBoxSortField, strReqBoxSortMtd, "��������")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery", "LAST_ANS_DOC_SND_DT", strReqBoxSortField, strReqBoxSortMtd, "�����Ͻ�")%></th>
               <th scope="col"><a>�亯/�䱸</a></th>
            </tr>
          </thead>
          <tbody>
		<%
			int intRecordNumber = intTotalRecordCount - ((intCurrentPageNum -1) * Integer.parseInt((String)paramForm.getParamValue("ReqBoxPageSize")));
			if(rsHelper.getRecordSize() > 0) {
				String strReqBoxID = "";
				while(rsHelper.next()) {
					strReqBoxID = (String)rsHelper.getObject("REQ_BOX_ID");
					//Hashtable countHash = (Hashtable)selfDelegate.getReqBoxRelateCount(strReqBoxID);

					// ����, ������ �������� �ʵ�
					String strReqBoxTP = "";
					if("001".equals((String)rsHelper.getObject("REQ_BOX_TP"))){
						strReqBoxTP = "����";
					}else if("005".equals((String)rsHelper.getObject("REQ_BOX_TP"))){
						strReqBoxTP = "������";
					}
		%>
            <tr>
              <td style="text-align:center;"><%= intRecordNumber %></td>
              <td><%=strReqBoxTP %></td>
              <td><a href="javascript:gotoDetail('<%=strReqBoxID%>','<%=strReqBoxTP %>')"><%= (String)rsHelper.getObject("REQ_BOX_NM") %></a></td>
              <td><%= (String)rsHelper.getObject("REQ_ORGAN_NM") %></td>
              <td><%= objCdinfo.getRelatedDuty((String)rsHelper.getObject("RLTD_DUTY")) %></td>
              <td><%= StringUtil.getDate2((String)rsHelper.getObject("LAST_ANS_DOC_SND_DT")) %></td>
              <td><%= (String)rsHelper.getObject("SUBMT_CNT") %> / <%= (String)rsHelper.getObject("REQ_CNT") %></td>
            </tr>
				<%
							intRecordNumber--;
						} // endofwhile
					} else {
				%>
            <tr>
              <td colspan="6" align="center">��ϵ� �䱸���� �����ϴ�.
			  </td>
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
			paramForm.getParamValue("ReqBoxPageSize")))%>
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
            <option <%=(strReqBoxQryField.equalsIgnoreCase("regr_nm"))? " selected ": ""%>value="regr_nm">�����</option>
          </select>
          <input name="ReqBoxQryTerm" onKeyDown="return ch()" onMouseDown="return ch()"
		 class="li_input"  style="width:100px" value="<%= paramForm.getParamValue("ReqBoxQryTerm") %>"/>
          <img src="/images2/btn/bt_list_search.gif"  onMouseOver="menuOn(this);" onMouseOut="menuOut(this);" onClick="listqry.submit()"/> </div>
        <!-- /����Ʈ �� �˻� -->
		<!--<span class="right"> <span class="list_bt"><a href="#">�䱸�Ի���</a></span> </span>
		-->
		</div>

        <!-- /����Ʈ ��ư-->

        <!-- /�������� ���� -->
      </div>
      <!-- /contents -->

    </div>
</form>
  </div>
  <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>