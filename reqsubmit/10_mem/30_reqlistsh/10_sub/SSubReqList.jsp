<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.pf.util.PageCount"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.params.requestinfo.SMemReqInfoListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.SMemReqBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.SMemReqInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.RequestBoxDelegate" %>
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
	String strSelectedAuditYear = null; // ����⵵
	String strSelectedReqOrganID = null; // �䱸��� ID
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

	SMemReqInfoListForm objParams = new SMemReqInfoListForm();
	objParams.setParamValue("ReqStt", CodeConstants.REQ_STT_SUBMT); // �䱸��������
	objParams.setParamValue("SubmtOrganID", strOrganId); // ������ ID
	objParams.setParamValue("ReqInfoSortField", "last_ans_dt"); // ���ļ���. �����亯��
	objParams.setParamValue("IsRequester", String.valueOf(objUserInfo.isRequester())); // �䱸�亯�ڿ��μ���


	boolean blnParamCheck=false;
	blnParamCheck=objParams.validateParams(request);
	if(blnParamCheck==false){
		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
		objMsgBean.setStrCode("DSPARAM-0000");
		objMsgBean.setStrMsg(objParams.getStrErrors());
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}

%>

<%
	SMemReqBoxDelegate objSReqBoxDelegate = null;
	SMemReqInfoDelegate objReqInfo = null;				// �䱸���� Delegate
	RequestBoxDelegate objReqBoxDelegate = null;

	ResultSetHelper objRs = null;								// �䱸���� ResultSet
	ResultSetHelper objOrgRs = null;

	ResultSetHelper objRsAuditYear = null;
	ResultSetHelper objRsReqOrgan = null;
	ResultSetHelper objDaeRs=null;
	ResultSetHelper objSubmtRs=null;

	try{
		objSReqBoxDelegate = new SMemReqBoxDelegate();
		objReqBoxDelegate = new RequestBoxDelegate();

		objReqInfo = new SMemReqInfoDelegate();

		strSelectedAuditYear = objParams.getParamValue("AuditYear"); // ����⵵
		strSelectedReqOrganID = objParams.getParamValue("ReqOrganID"); // �䱸���

		objDaeRs = new ResultSetHelper(objReqBoxDelegate.getOrganDaesu(strOrganId));
		List lst = (List)objReqBoxDelegate.getSubmtOrganList(objUserInfo.getOrganID());
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

		objRs = new ResultSetHelper(objReqInfo.getRecordDaeListByReqOrgID(objParams,objhashdata));
		objRsAuditYear = new ResultSetHelper(objReqInfo.getAuditYearDaeList(lst,strSubmtOrganId,strStartdate,strEnddate,CodeConstants.REQ_STT_SUBMT));
		objRsReqOrgan = new ResultSetHelper(objReqInfo.getReqOrganDaeList(objParams,objhashdata));

	} catch(AppException objAppEx) {
		objAppEx.printStackTrace();
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		objMsgBean.setStrCode(objAppEx.getStrErrCode());
		objMsgBean.setStrMsg(objAppEx.getMessage());
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}

	int intTotalRecordCount=objRs.getTotalRecordCount();
	int intCurrentPageNum=objRs.getPageNumber();
	int intTotalPage=objRs.getTotalPageCount();
%>
<jsp:include page="/inc/header.jsp" flush="true"/>
<link href="/css2/style.css" rel="stylesheet" type="text/css">
<!-- hgyoo 1. css �߰� -->
<style type="text/css">
	.tooltip_text, .tooltip_close{
		cursor: pointer;
	}
	div.tooltip {
		
		position:absolute;
	}
</style>
<script language="javascript">

/* hgyoo 2. ��ũ��Ʈ �߰� */
$(document).ready(function(){
	//alert ('jQuery running');
	
	/* �⺻ ������ ���� */
	var defaults = {
		w : 170, /*���̾� �ʺ�*/
		padding: 0,
		bgColor: '#F6F6F6',
		borderColor: '#333'
	};
	
	var options = $.extend(defaults, options);
	
	/* ���̾� â �ݱ� */
	$(".tooltip_close").click(function(){
		$(this).parents(".tooltip").css({display:'none'});
	});
	
	/* ���콺 ������ */
	$('span.tooltip_text').hover(
		function(over){

			var top = $(this).offset().top;
			var left = $(this).offset().left;
			
			$(".tooltip").css({display:'none'});
			
			$(this).next(".tooltip").css({
				display:'',
				top:  top + 20 + 'px',
				left: left + 'px',
				background : options.bgColor,
				padding: options.padding,
				paddingRight: options.padding+1,
				width: (options.w+options.padding)
			});
			
			
		},
		/* ���콺 �ƿ��� */			   
		function(out){
			//$(this).html(currentText);
			//$('#link-text').pa
		}
	);
});

	/** ���Ĺ�� �ٲٱ� */
	function changeSortQuery(sortField, sortMethod) {
		var f = document.listForm;
		f.ReqInfoSortField.value=sortField;
	  	f.ReqInfoSortMtd.value=sortMethod;
		f.DAESUCH.value = "N";
	  	f.submit();
	}

	//�䱸 �󼼺��� �̵�
	function gotoDetail(strID,strReqBoxID){
		var f = document.listForm;
		f.ReqID.value = strID;
		f.ReqBoxID.value = strReqBoxID;
		f.action = "SSubReqVList.jsp";
		f.submit();
	}

	/** ����¡ �ٷΰ��� */
	function goPage(strPage){
		var f = document.listForm;
		f.ReqInfoPage.value = strPage;
		f.DAESUCH.value = "N";
		f.submit();
	}

  /**�⵵�� ����ȸ�θ� ��ȸ�ϱ� */
  function gotoHeadQuery() {
	  var f = document.listForm;
	  f.ReqInfoQryField.value="";
	  f.ReqInfoQryTerm.value="";
	  f.ReqInfoSortField.value="";
	  f.ReqInfoSortMtd.value="";
	  f.ReqInfoPage.value="";
	  f.DAESUCH.value = "N";
	  f.submit();
  }

  /** �䱸�� �� ����� �̵� */
  function gotoReqBoxInfoView(strReqBoxStt, strReqBoxID) {
  	var strMoveURL;
  	if (strReqBoxStt == "<%= CodeConstants.REQ_BOX_STT_006 %>") { // �ۼ���
  		strMoveURL = "/reqsubmit/10_mem/20_reqboxsh/10_make/SMakeReqBoxVList.jsp?ReqBoxID="+strReqBoxID;
  	} else if (strReqBoxStt == "<%= CodeConstants.REQ_BOX_STT_007 %>") { // ����Ϸ�
  		strMoveURL = "/reqsubmit/10_mem/20_reqboxsh/30_makeend/SMakeEndBoxVList.jsp?ReqBoxID="+strReqBoxID;
  	}
  	location.href=strMoveURL;
  }

	function doRefresh() {
		var f = document.listForm;
		f.DAESUCH.value = "N";
		f.target = "";
		f.submit();
	}

	function changeDaesu(){
		form = document.listForm;
		form.target = '';
		form.DAESUCH.value = "Y";
		form.submit();
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
    </div>
    <SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>
    <SCRIPT language="JavaScript" src="/js/reqsubmit/reqinfo.js"></SCRIPT>
    <div id="rightCon">
<form name="listForm" method="post" action="<%=request.getRequestURI()%>">
          <%
          	String strReqInfoSortField=objParams.getParamValue("ReqInfoSortField");
			String strReqInfoSortMtd=objParams.getParamValue("ReqInfoSortMtd");
			String strReqInfoPagNum=objParams.getParamValue("ReqInfoPage");
		  %>
		  	  <input type="hidden" name="ReqInfoSortField" value="<%=strReqInfoSortField%>"><!--�䱸���� ��������ʵ� -->
			  <input type="hidden" name="ReqInfoSortMtd" value="<%=strReqInfoSortMtd%>"><!--�䱸���� ������ɹ��-->
			  <input type="hidden" name="ReqInfoPage" value="<%=strReqInfoPagNum%>"><!--�䱸���� ������ ��ȣ -->
			  <input type="hidden" name="ReqID" value=""><!--�䱸���� ID-->
			  <input type="hidden" name="ReqBoxID" value="">
			  <input type="hidden" name="ReturnUrl" value="<%=request.getRequestURI()%>"><!--�ǵ��ƿ� URL -->
			  <input type="hidden" name="DAESUCH" value="">
      <!-- pgTit -->
      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=MenuConstants.REQ_INFO_LIST_SUBMT_DONE%>��</h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.getReqBoxGeneral(request)%> > <%=MenuConstants.REQ_INFO_LIST%> > <%=MenuConstants.REQ_INFO_LIST_SUBMT_DONE%></div>
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
              <option selected="selected" value="">:::: ��ü �䱸��� ::::</option>
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
            </select> �䱸 ���
            <a href="javascript:gotoHeadQuery();"><img src="/images2/btn/bt_search2.gif" width="50" height="22" /></a> </div>
        </div>
        <!-- /�˻�����-->

        <!-- �������� ���� -->

        <!-- list -->

        <span class="list_total">&bull;&nbsp;��ü�ڷ�� : <%=intTotalRecordCount%>�� (<%=intCurrentPageNum%> / <%=intTotalPage%> page)</span>


        <!-- 20150702 ���� �� �ں��� <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01"> -->
        <!-- 20150702 ���� �� �ں��� -->
        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01" style="word-break:break-all">
        <!-- 20150702 ���� �� �ں��� -->
          <thead>
            <tr>
              <th scope="col" style="width:15px;">
				<input name="" type="checkbox" value="" class="borderNo" />
			 </th>
              <th scope="col" style="width:20px;"><a>NO</a></th>
              <th scope="col" style="width:250px;"><%=SortingUtil.getSortLink("changeSortQuery","REQ_CONT",strReqInfoSortField,strReqInfoSortMtd,"�䱸����")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","REQ_ORGAN_NM", strReqInfoSortField, strReqInfoSortMtd, "�䱸���")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","REQ_BOX_NM",strReqInfoSortField,strReqInfoSortMtd,"�䱸��")%></th>
              <th scope="col"><a>�亯</a></th>
               <th scope="col"><a>÷��</a></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","LAST_REQ_DT",strReqInfoSortField,strReqInfoSortMtd,"�䱸�Ͻ�")%></a></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","LAST_ANS_DT",strReqInfoSortField,strReqInfoSortMtd,"�亯�Ͻ�")%></th>
            </tr>
          </thead>
          <tbody>
			<%
				int intRecordNumber=intTotalRecordCount - ((intCurrentPageNum -1) * Integer.parseInt((String)objParams.getParamValue("ReqInfoPageSize")));
				String strReqInfoID="";
				while(objRs.next()) {
					strReqInfoID=(String)objRs.getObject("REQ_ID");
			 %>
            <tr>
              <td ><input name="ReqInfoIDs" type="checkbox" value="<%= strReqInfoID %>"  class="borderNo" /></td>
              <td><%= intRecordNumber %></td>
              <td><%= StringUtil.getNotifyImg((String)objRs.getObject("LAST_ANS_DT"), (String)objRs.getObject("REQ_STT")) %><a href="JavaScript:gotoDetail('<%= strReqInfoID %>','<%= (String)objRs.getObject("REQ_BOX_ID") %>');" hint="<%= StringUtil.substring((String)objRs.getObject("REQ_DTL_CONT"), 80) %> ..."><%= (String)objRs.getObject("REQ_CONT") %></a></td>
              <td>
			  <%
					String strOldOrganNm = (String)objRs.getObject("REQ_ORGAN_NM");
					String strOldOrganNm4Len = strOldOrganNm.substring(0, 4);
					if("��ȸ�ǿ�".equalsIgnoreCase(strOldOrganNm4Len)) {
						out.println(strOldOrganNm.substring(5, strOldOrganNm.length()));
					} else {
						out.println(strOldOrganNm);
					}
			  %>
			  </td>
              <td><a href="javascript:gotoReqBoxInfoView('<%= (String)objRs.getObject("REQ_BOX_STT") %>', '<%= (String)objRs.getObject("REQ_BOX_ID") %>')"><img src="/image/reqsubmit/icon_secretariat.gif" border="0" alt="<%=objRs.getObject("REQ_BOX_NM")%> �ٷΰ���"></a></td>
              <!-- <td><%=this.makeAnsInfoHtml2((String)objRs.getObject("ANS_ID"),(String)objRs.getObject("ANS_MTD"),(String)objRs.getObject("ANS_OPIN"),(String)objRs.getObject("SUBMT_FLAG"),objUserInfo.isRequester(),"","_blank","",(String)objRs.getObject("REQ_CONT"),(String)objRs.getObject("SUBMT_ORGAN_NM"))%></td> -->
              <!-- hgyoo 3.html TD�߰� ���� -->
              <td>
				<span class="tooltip_text"><%=this.makeAnsInfoImg((String)objRs.getObject("ANS_ID"),(String)objRs.getObject("ANS_MTD"),(String)objRs.getObject("ANS_OPIN"),(String)objRs.getObject("SUBMT_FLAG"),objUserInfo.isRequester(),"","_blank","")%></span> 
				<div class="tooltip" style="display:none;">
					<table width=100% height=100%>
					  <tr>
					   <td width=100% height=5% style="align:right">
						<img src="/images/bt-close.gif" style="cursor:hand" align="absmiddle" border="0" class="tooltip_close">
					   </td>
					  </tr>
					  <tr> 
					   <td  bgcolor="#FFFFFF" align="left" >
					   <%=this.makeAnsInfoHtml3(
							   (String)objRs.getObject("ANS_ID")
							   ,(String)objRs.getObject("ANS_MTD")
							   ,(String)objRs.getObject("ANS_OPIN")
							   ,(String)objRs.getObject("SUBMT_FLAG")
							   ,objUserInfo.isRequester()
							   ,""
							   ,"_blank"
							   ,""
							   ,StringUtil.substring((String)objRs.getObject("REQ_CONT"),35)
							   ,(String)objRs.getObject("SUBMT_ORGAN_NM")
							   )
							%></td>
					  </tr>
					 </table>
				</div>
			  </td>
			  <!-- hgyoo 3.html TD�߰� ���� -->   
              <td><%=makeAttachedFileLink((String)objRs.getObject("ANS_ESTYLE_FILE_PATH"))%></td>
              <td><%= StringUtil.getDate2((String)objRs.getObject("LAST_REQ_DT")) %></td>
              <td><%= StringUtil.getDate2((String)objRs.getObject("LAST_ANS_DT")) %></td>
            </tr>
				<%
						intRecordNumber --;
					}//endwhile
				%>
          </tbody>
        </table>

        <!-- /list -->
		<%=objPaging.pagingTrans(PageCount.getLinkedString(
							new Integer(intTotalRecordCount).toString(),
							new Integer(intCurrentPageNum).toString(),
							objParams.getParamValue("ReqInfoPageSize")))%>
        <!-- ����¡-->
         <!-- /����¡-->
        <!--  <p class="warning">* �䱸���� �߼��ϰ� �Ǹ� �ش� ���� ��� ��ǥ ����ڿ��� ���� �߼۵Ǹ�, ����ڰ� ���� ���� �ۼ� �� �䱸�Կ� �״�� �����ְ� �˴ϴ�.  </p>
          <p class="warning">* �䱸�� �߼� ��ư�� �̿��Ͻñ� ���ؼ��� ����ȸ�� ������ �ֽñ� �ٶ��ϴ�.  </p>  -->



        <!-- ����Ʈ ��ư-->
        <div id="btn_all" >        <!-- ����Ʈ �� �˻� -->
        <div class="list_ser" >
		<%
			String strReqInfoQryField=(String)objParams.getParamValue("ReqInfoQryField");
		%>
          <select name="ReqInfoQryField" class="selectBox5"  style="width:70px;" >
            <option <%=(strReqInfoQryField.equalsIgnoreCase("req_cont"))? " selected ": ""%>value="req_cont">�䱸����</option>
			<option <%=(strReqInfoQryField.equalsIgnoreCase("req_dtl_cont"))? " selected ": ""%>value="req_dtl_cont">�䱸����</option>
            <option <%=(strReqInfoQryField.equalsIgnoreCase("regr_nm"))? " selected ": ""%>value="regr_nm">�����</option>
          </select>
          <input name="ReqInfoQryTerm" onKeyDown="return ch()" onMouseDown="return ch()"
		 class="li_input"  style="width:100px" value="<%=objParams.getParamValue("ReqInfoQryTerm")%>"/>
          <img src="/images2/btn/bt_list_search.gif"  onMouseOver="menuOn(this);" onMouseOut="menuOut(this);" onClick="document.listForm.submit();"/> </div>
        <!-- /����Ʈ �� �˻� -->
		<%
			 if(intTotalRecordCount>0){
		%>
		<span class="right"> <span class="list_bt"><a href="javascript:addBinder(listForm);">���δ����</a></span> </span>
		<%
			 }//endif ���ε��Ұ����־������..
		%>
		</div>

        <!-- /����Ʈ ��ư-->

        <!-- /�������� ���� -->
      </div>
      <!-- /contents -->

    </div>
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
  <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>

<%!
	//hgyoo 4. jsp �Լ� ����
	public static String makeAnsInfoHtml3(String strAnsIDs,String strAnsMtds,String strAnsOpins,String strSubmtFlags, boolean blnIsRequester,String strKeywords,String strLinkTarget,String strSummary,String strReqCont,String strSubmtorganNm){
		if(strLinkTarget.equals("0")){
			strLinkTarget="_blank";
		}else if(strLinkTarget.equals("1")){
			strLinkTarget="_self";
		}
		String strMsgSummary=StringUtil.getEmptyIfNull(strSummary,"PDF����");
		String strTop="";		//��¿� ��� ���ڿ�<a><talbe>
		String strMiddle="";	//��¿� �߰� <tr></tr>+
		String strBottom="";	//��¿� �ϴ� ���ڿ�..</table></a>
		if(strAnsIDs==null || strAnsIDs.trim().equals("")){
			return "";//�亯���� ������.
		}
		if(strAnsOpins!=null){
			strAnsOpins=strAnsOpins.replaceAll("'"," ");
			strAnsOpins=strAnsOpins.replaceAll("\""," ");
		}else{
			strAnsOpins="";
		}
		StringTokenizer strTokenAnsIDs=new StringTokenizer(strAnsIDs,",");
		StringTokenizer strTokenAnsMtds=new StringTokenizer(strAnsMtds,",");
		StringTokenizer strTokenAnsOpins=new StringTokenizer(strAnsOpins,",");
		StringTokenizer strTokenSubmtFlags=new StringTokenizer(strSubmtFlags,",");
		StringBuffer strBufReturn=new StringBuffer();
		String strAnsID=null;
		String strAnsMtd=null; 
		String strAnsOpin=null;
		String strSubmtFlag="Y";
		int intAnsCount=0;
		
		while(strTokenAnsIDs.hasMoreElements()&& strTokenAnsMtds.hasMoreElements() && strTokenSubmtFlags.hasMoreElements() ){
			strAnsID=strTokenAnsIDs.nextToken();
			strAnsMtd=strTokenAnsMtds.nextToken();
			strSubmtFlag=strTokenSubmtFlags.nextToken();
			try{
				if(strTokenAnsOpins.hasMoreElements()){
					strAnsOpin=strTokenAnsOpins.nextToken();
				}else{
					strAnsOpin="";
				}
			}catch(NoSuchElementException ex){
				strAnsOpin="";
			}
			strAnsOpin=StringUtil.getEmptyIfNull(strAnsOpin);
			strAnsOpin=strAnsOpin.replace('\n',' ');
			strAnsOpin=strAnsOpin.replace('\r',' ');
			//�䱸��(true)�̸鼭 �亯�Ϸ�(Y) �̰ų� ������(false)�̸� �亯���� ���̰��ϱ�.
			if((blnIsRequester && strSubmtFlag.equalsIgnoreCase("Y")) || blnIsRequester==false){
				//<tr>����
				if(strAnsMtd.equals(CodeConstants.ANS_MTD_ELEC)){
					strBufReturn.append("<img src='/image/reqsubmit/bt_EDoc.gif' width='73' height='16' border='0' alt='" + strAnsOpin + "'>");
					if(StringUtil.isAssigned(strKeywords)){
						strBufReturn.append("<a href='/reqsubmit/common/ReqFileOpenHL.jsp?ansID=" + strAnsID + "&keyword=" +  strKeywords+ "&DOC=PDF' target='" + strLinkTarget + "'>");						
					}else{
						strBufReturn.append("<a href='/reqsubmit/common/ReqFileOpen2.jsp?paramAnsId=" + strAnsID + "&DOC=PDF&REQNM=" + strReqCont + "&REQSEQ=" + (intAnsCount+1) + "&SubmtOrganNm="+strSubmtorganNm+"' target='_self'>");
					}
					/** ���ŵ� 2004.05.13
					if(intAnsCount>0){//ó���ѹ��� ��๮ �����شٰ���.
						strMsgSummary="PDF����";
					}
					 */
					strBufReturn.append("<img src='/image/common/icon_pdf.gif' width='16' height='16' border='0' alt='" + strMsgSummary + "'>");
					strBufReturn.append("</a>");
					strBufReturn.append("&nbsp;<a href='/reqsubmit/common/ReqFileOpen2.jsp?paramAnsId=" + strAnsID + "&DOC=DOC&REQNM=" + strReqCont + "&REQSEQ=" + (intAnsCount+1) + "&SubmtOrganNm="+strSubmtorganNm+"' target='_self'>");
					strBufReturn.append("<img src='/image/common/icon_file.gif' border='0' alt='��������'>");
					strBufReturn.append("</a>");
					strBufReturn.append("<br>");
				}else if(strAnsMtd.equals(CodeConstants.ANS_MTD_ETCS)){
					strBufReturn.append("<img src='/image/reqsubmit/bt_NotEDoc.gif' width='73' height='16' border='0' alt='" + strAnsOpin + "'>");
					strBufReturn.append("<br>");					
				}else if(strAnsMtd.equals("004")){
					strBufReturn.append("<img src='/image/reqsubmit/bt_offLineSubmit.gif' width='73' height='16' border='0' alt='���������� ���� ����'>");
					strBufReturn.append("<br>");					
				}else {
					strBufReturn.append("<img src='/image/reqsubmit/bt_NotPertinentOrg.gif' width='73' height='16' border='0' alt='" + strAnsOpin + "'>");
					strBufReturn.append("<br>");					
				}
				//</tr>�� 
				intAnsCount++; //�亯���� ī��Ʈ �ø�.
			}
		}
		
		strMiddle=strBufReturn.toString();//�߰����ڿ� �ޱ�.
		
	
		
		//�亯���� ��µ� ������ ������ ���.
		if(intAnsCount>0){
			return  strMiddle;
		}else{
			return "";//�亯���� ������.
		}
	}

	//hgyoo 4. jsp �Լ� ����
	public static String makeAnsInfoImg(String strAnsIDs
			,String strAnsMtds
			,String strAnsOpins
			,String strSubmtFlags
			, boolean blnIsRequester
			,String strKeywords
			,String strLinkTarget
			,String strSummary){
		
		if(strAnsIDs==null || strAnsIDs.trim().equals("")){
			return "<img src='/image/reqsubmit/icon_noAnswer.gif' border='0'>";//�亯���� ������.
		}		
		
		
		StringTokenizer strTokenAnsIDs=new StringTokenizer(strAnsIDs,",");
		StringTokenizer strTokenAnsMtds=new StringTokenizer(strAnsMtds,",");
		StringTokenizer strTokenAnsOpins=new StringTokenizer(strAnsOpins,",");
		StringTokenizer strTokenSubmtFlags=new StringTokenizer(strSubmtFlags,",");
		StringBuffer strBufReturn=new StringBuffer();
		String strAnsID=null;
		String strAnsMtd=null; 
		String strAnsOpin=null;
		String strSubmtFlag="Y";
		int intAnsCount=0;
		
		while(strTokenAnsIDs.hasMoreElements()&& strTokenAnsMtds.hasMoreElements() && strTokenSubmtFlags.hasMoreElements() ){	
			strAnsID=strTokenAnsIDs.nextToken();
			strAnsMtd=strTokenAnsMtds.nextToken();
			strSubmtFlag=strTokenSubmtFlags.nextToken();
			try{
				if(strTokenAnsOpins.hasMoreElements()){
					strAnsOpin=strTokenAnsOpins.nextToken();
				}else{
					strAnsOpin="";
				}
			}catch(NoSuchElementException ex){
				strAnsOpin="";
			}
			//�䱸��(true)�̸鼭 �亯�Ϸ�(Y) �̰ų� ������(false)�̸� �亯���� ���̰��ϱ�.
			if((blnIsRequester && strSubmtFlag.equalsIgnoreCase("Y")) || blnIsRequester==false){
	
				intAnsCount++; //�亯���� ī��Ʈ �ø�.
			}
		}
				
		
		//�亯���� ��µ� ������ ������ ���.
		if(intAnsCount>0){
			return "<img src='/image/reqsubmit/icon_answer.gif' border='0'>";
		}else{
			return "<img src='/image/reqsubmit/icon_noAnswer.gif' border='0'>";//�亯���� ������.
		}
	}
	/* ������� */

	public String getCurrentTime() {
        Calendar oCalendar = Calendar.getInstance();
		String serverDate = oCalendar.get(Calendar.YEAR) + "/" +(oCalendar.get(Calendar.MONTH) + 1)+"/"+ oCalendar.get(Calendar.DAY_OF_MONTH)+"  "+oCalendar.get(Calendar.HOUR_OF_DAY)+":"+oCalendar.get(Calendar.MINUTE)+":"+oCalendar.get(Calendar.SECOND)+":"+oCalendar.get(Calendar.MILLISECOND);
		 return serverDate;
     }

	 public static String makeAnsInfoHtml2(String strAnsIDs,String strAnsMtds,String strAnsOpins,String strSubmtFlags, boolean blnIsRequester,String strKeywords,String strLinkTarget,String strSummary,String strReqCont, String strSubmtOrganNm){
		if(strLinkTarget.equals("0")){
			strLinkTarget="_blank";
		}else if(strLinkTarget.equals("1")){
			strLinkTarget="_self";
		}
		String strMsgSummary=StringUtil.getEmptyIfNull(strSummary,"PDF����");
		String strTop="";		//��¿� ��� ���ڿ�<a><talbe>
		String strMiddle="";	//��¿� �߰� <tr></tr>+
		String strBottom="";	//��¿� �ϴ� ���ڿ�..</table></a>
		if(strAnsIDs==null || strAnsIDs.trim().equals("")){
			return "<img src=\"/image/reqsubmit/icon_noAnswer.gif\" border=\"0\" onMouseOver=\"drs('','')\">";//�亯���� ������.
		}
		if(strAnsOpins!=null){
			strAnsOpins=strAnsOpins.replaceAll("'"," ");
			strAnsOpins=strAnsOpins.replaceAll("\""," ");
		}else{
			strAnsOpins="";
		}
		StringTokenizer strTokenAnsIDs=new StringTokenizer(strAnsIDs,",");
		StringTokenizer strTokenAnsMtds=new StringTokenizer(strAnsMtds,",");
		StringTokenizer strTokenAnsOpins=new StringTokenizer(strAnsOpins,",");
		StringTokenizer strTokenSubmtFlags=new StringTokenizer(strSubmtFlags,",");
		StringBuffer strBufReturn=new StringBuffer();
		String strAnsID=null;
		String strAnsMtd=null; 
		String strAnsOpin=null;
		String strSubmtFlag="Y";
		int intAnsCount=0;
		
		while(strTokenAnsIDs.hasMoreElements()&& strTokenAnsMtds.hasMoreElements() && strTokenSubmtFlags.hasMoreElements() ){
			strAnsID=strTokenAnsIDs.nextToken();
			strAnsMtd=strTokenAnsMtds.nextToken();
			strSubmtFlag=strTokenSubmtFlags.nextToken();
			try{
				if(strTokenAnsOpins.hasMoreElements()){
					strAnsOpin=strTokenAnsOpins.nextToken();
				}else{
					strAnsOpin="";
				}
			}catch(NoSuchElementException ex){
				strAnsOpin="";
			}
			strAnsOpin=StringUtil.getEmptyIfNull(strAnsOpin);
			strAnsOpin=strAnsOpin.replace('\n',' ');
			strAnsOpin=strAnsOpin.replace('\r',' ');
			//�䱸��(true)�̸鼭 �亯�Ϸ�(Y) �̰ų� ������(false)�̸� �亯���� ���̰��ϱ�.
			if((blnIsRequester && strSubmtFlag.equalsIgnoreCase("Y")) || blnIsRequester==false){
				//<tr>����
				strBufReturn.append("<tr>");
				if(strAnsMtd.equals(CodeConstants.ANS_MTD_ELEC)){
					strBufReturn.append("<td width=\\'18\\' height=\\'18\\' align=\\'left\\' valign=\\'top\\'>");
					strBufReturn.append("<img src=\\'/image/reqsubmit/bt_EDoc.gif\\' width=\\'73\\' height=\\'16\\' border=\\'0\\' alt=\\'" + strAnsOpin + "\\'>");
					strBufReturn.append("</td>");
					strBufReturn.append("<td width=\\'37%\\' height=\\'18\\' valign=\\'top\\'>");
					if(StringUtil.isAssigned(strKeywords)){
						strBufReturn.append("<a href=\\'/reqsubmit/common/ReqFileOpenHL.jsp?ansID=" + strAnsID + "&keyword=" +  strKeywords+ "&DOC=PDF\\' target=\\'" + strLinkTarget + "\\'>");						
					}else{
						strBufReturn.append("<a href=\\'/reqsubmit/common/ReqFileOpen2.jsp?paramAnsId=" + strAnsID + "&DOC=PDF&REQNM=" + strReqCont + "&REQSEQ=" + (intAnsCount+1) + "&SubmtOrganNm="+strSubmtOrganNm+"\\' target=\\'" + strLinkTarget + "\\'>");
					}
					/** ���ŵ� 2004.05.13
					if(intAnsCount>0){//ó���ѹ��� ��๮ �����شٰ���.
						strMsgSummary="PDF����";
					}
					 */
					strBufReturn.append("<img src=\\'/image/common/icon_pdf.gif\\' width=\\'16\\' height=\\'16\\' border=\\'0\\' alt=\\'" + strMsgSummary + "\\'>");
					strBufReturn.append("</a>");
					strBufReturn.append("&nbsp;<a href=\\'/reqsubmit/common/ReqFileOpen2.jsp?paramAnsId=" + strAnsID + "&DOC=DOC&REQNM=" + strReqCont + "&REQSEQ=" + (intAnsCount+1) + "&SubmtOrganNm="+strSubmtOrganNm+"\\' target=\\'_self\\'>");
					strBufReturn.append("<img src=\\'/image/common/icon_file.gif\\' border=\\'0\\' alt=\\'��������\\'>");
					strBufReturn.append("</a>");
					strBufReturn.append("</td>");
				}else if(strAnsMtd.equals(CodeConstants.ANS_MTD_ETCS)){
					strBufReturn.append("<td colspan=\\'2\\' width=\\'18\\' height=\\'18\\' align=\\'left\\' valign=\\'top\\'>");
					strBufReturn.append("<img src=\\'/image/reqsubmit/bt_NotEDoc.gif\\' width=\\'73\\' height=\\'16\\' border=\\'0\\' alt=\\'" + strAnsOpin + "\\'>");
					strBufReturn.append("</td>");					
				}else if(strAnsMtd.equals("004")){
					strBufReturn.append("<td colspan=\\'2\\' width=\\'18\\' height=\\'18\\' align=\\'left\\' valign=\\'top\\'>");
					strBufReturn.append("<img src=\\'/image/reqsubmit/bt_offLineSubmit.gif\\' width=\\'73\\' height=\\'16\\' border=\\'0\\' alt=\\'���������� ���� ����\\'>");
					strBufReturn.append("</td>");					
				}else {
					strBufReturn.append("<td colspan=\\'2\\' width=\\'18\\' height=\\'18\\' align=\\'left\\' valign=\\'top\\'>");
					strBufReturn.append("<img src=\\'/image/reqsubmit/bt_NotPertinentOrg.gif\\' width=\\'73\\' height=\\'16\\' border=\\'0\\' alt=\\'" + strAnsOpin + "\\'>");
					strBufReturn.append("</td>");					
				}
				strBufReturn.append("</tr>");
				//</tr>�� 
				intAnsCount++; //�亯���� ī��Ʈ �ø�.
			}
		}
		
		strMiddle=strBufReturn.toString();//�߰����ڿ� �ޱ�.
		
		int intHeight=19 * intAnsCount;//76=19* 4
		//�� ���̺� ����
		strBufReturn=new StringBuffer();
		strBufReturn.append("<A href=\"#\" onMouseOver=\"drs('");
		strBufReturn.append("<table width=\\'132\\' height=\\'" + intHeight + "\\' border=\\'0\\' cellpadding=\\'3\\' cellspacing=\\'1\\' bgcolor=\\'9C9C9C\\'>");
		strBufReturn.append("<tr><td align=\\'left\\' valign=\\'top\\' bgcolor=\\'ffffff\\'>");
		strBufReturn.append("<table width=\\'100%\\' border=\\'0\\' cellspacing=\\'0\\' cellpadding=\\'0\\')>");
		strTop=strBufReturn.toString();
		
		//�Ʒ� ���̺�ݱ�
		strBufReturn=new StringBuffer();
		strBufReturn.append("</table></td></tr></table>");
		strBufReturn.append("', '7')\"><img src=\"/image/reqsubmit/icon_answer.gif\" border=\"0\"></A>");//�亯Ȯ�ξ�����.
		strBottom=strBufReturn.toString();
		
		//�亯���� ��µ� ������ ������ ���.
		if(intAnsCount>0){
			return strTop + strMiddle + strBottom;
		}else{
			return "<img src=\"/image/reqsubmit/icon_noAnswer.gif\" border=\"0\" onMouseOver=\"drs('','')\">";//�亯���� ������.
		}
	}

%>