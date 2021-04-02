<%@ page language="java" contentType="text/html;charset=EUC-KR" %>

<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.pf.util.PageCount"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.params.requestinfo.SPreReqInfoListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.prereqinfo.SPreReqInfoDelegate" %>
<%@ page import="nads.dsdm.app.common.page.PagingDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%!
	public  List checkEmptyCmtList(List objLists){
		if(objLists==null || objLists.size()<=0){
			List objReturnList=new ArrayList();
			Hashtable objTmpHash=new Hashtable();
			String strNowDate="";
			java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy");
			strNowDate = sdf.format(new java.util.Date());
			objTmpHash.put("AUDIT_YEAR",strNowDate);
			objTmpHash.put("REQ_ORGAN_ID","");
			objTmpHash.put("REQ_ORGAN_NM","��ü");
			objReturnList.add(objTmpHash);
			return objReturnList;
		}else{
			return objLists;
		}
	}//�ӽù����Դϴ�
%>
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
	String strSelectedAuditYear= null; // ����⵵
	String strReqOrgID = null; // �䱸��� ID





	SPreReqInfoListForm objParams = new SPreReqInfoListForm();


	objParams.setParamValue("ReqStt", CodeConstants.REQ_STT_NOT); // �䱸��������
	objParams.setParamValue("SubmtOrganID", objUserInfo.getOrganID()); // ������ ID
	objParams.setParamValue("ReqInfoSortField", "req_stt"); // ���ļ���. �䱸 ���� ����
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
	}//endif

	strSelectedAuditYear = objParams.getParamValue("AuditYear"); // ����⵵
	strReqOrgID = objParams.getParamValue("ReqOrgID"); // �䱸���
%>

<%
	SPreReqInfoDelegate objReqInfo = null;				// �䱸���� Delegate
	ResultSetHelper objRs = null;								// �䱸���� ResultSet
	ResultSetHelper objOrgRs = null;
	try{
		objReqInfo = new SPreReqInfoDelegate();
		objRs = new ResultSetHelper(objReqInfo.getRecordListByReqOrgID(objParams));
		//objOrgRs = new ResultSetHelper(objReqInfo.getReqOrgList(objUserInfo.getOrganID()));
		objOrgRs = new ResultSetHelper(checkEmptyCmtList(objReqInfo.getReqOrgList(objUserInfo.getOrganID())));
		if(objOrgRs.next() && !StringUtil.isAssigned(strSelectedAuditYear) && !StringUtil.isAssigned(strReqOrgID)){
 		//if(objOrgRs.next() && !StringUtil.isAssigned(strSelectedAuditYear) ){
 			strSelectedAuditYear = (String)objOrgRs.getObject("AUDIT_YEAR");
 			//strReqOrgID = (String)objOrgRs.getObject("REQ_ORGAN_ID");
	    	objParams.setParamValueIfNull("AuditYear", strSelectedAuditYear);
	    	//objParams.setParamValueIfNull("ReqOrgID", strReqOrgID);
   		}
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
<script language="javascript">
    var varSelectedYear = '<%= strSelectedAuditYear %>';
    var varReqOrg = '<%= strReqOrgID %>';
	var arrPerYearReqOrg = new Array(<%= objOrgRs.getTotalRecordCount()+1 %>);
<%
	Vector vectorYear=new Vector();
	String strTmpYear = "";
	String strOldYear = "";
	objOrgRs.first();
	out.println("arrPerYearReqOrg[0] = new Array('"
			+ strSelectedAuditYear + "','',':::::::::::: ��ü �䱸 ��� ::::::::::::');");
	for(int i=1;objOrgRs.next();i++) {
		strTmpYear = (String)objOrgRs.getObject("AUDIT_YEAR");
	    out.println("arrPerYearReqOrg[" + i + "] = new Array('"
			+ strTmpYear	+ "','" + objOrgRs.getObject("REQ_ORGAN_ID") + "','" + objOrgRs.getObject("REQ_ORGAN_NM") + "');");
		if(!strTmpYear.equals(strOldYear)){
			vectorYear.add(strTmpYear);
		}
		strOldYear=strTmpYear;
	}
	out.println("var arrYear = new Array(" + vectorYear.size() + ");");
	for(int i=0;i<vectorYear.size();i++){
		out.println("arrYear[" + i + "]= new Array('" + (String)vectorYear.get(i)+ "');");
	}
%>

	function init(){
		var f = document.listForm;
		var field=f.AuditYear;
		for(var i=0; i<arrYear.length; i++) {
	   		var tmpOpt = new Option();
	   		tmpOpt.text = arrYear[i];
	   		tmpOpt.value = tmpOpt.text;
	   		if(varSelectedYear == tmpOpt.text) {
	     		tmpOpt.selected = true;
	   		}
	   		field.add(tmpOpt);
		}
		makePerYearReqOrgList(field.options[field.selectedIndex].value);
  	}

  	function makePerYearReqOrgList(strYear) {
		var f = document.listForm;
    	var field = f.ReqOrgID;
       	field.length=0;
		for(var i=0; i<arrPerYearReqOrg.length; i++) {
			var strTmpYear = arrPerYearReqOrg[i][0];
		   	if(strYear == strTmpYear){
				var tmpOpt = new Option();
			   	tmpOpt.value = arrPerYearReqOrg[i][1];
			   	tmpOpt.text = arrPerYearReqOrg[i][2];
			   	if(varReqOrg == tmpOpt.value){
		    		tmpOpt.selected=true;
			   	}
			   	field.add(tmpOpt);
	   		}
		}
  	}

  	function changeReqOrgList() {
  		var f = document.listForm;
    	makePerYearReqOrgList(f.AuditYear.options[f.AuditYear.selectedIndex].value);
  	}

	/** ���Ĺ�� �ٲٱ� */
	function changeSortQuery(sortField, sortMethod) {
		var f = document.listForm;
		f.ReqInfoSortField.value=sortField;
	  	f.ReqInfoSortMtd.value=sortMethod;
	  	f.submit();
	}

	//�䱸�󼼺���� ����.
	function gotoDetail(strID){
		var f = document.listForm;
		f.ReqID.value = strID;
		f.action = "SNonPreInfoVList.jsp";
		f.submit();
	}

	//�䱸�Ի󼼺���� ����.
  	function gotoDetail_Box(strID){
  		var f = document.listForm;
  		f.ReqBoxID.value=strID;
  		f.action="/reqsubmit/20_comm/40_BasicBox/20_databoxsh/SBasicReqBoxVList.jsp?SubmtOrganID=<%=objParams.getParamValue("SubmtOrganID")%>";
  		f.submit();
  	}



	/** ����¡ �ٷΰ��� */
	function goPage(strPage){
		var f = document.listForm;
		f.ReqInfoPage.value = strPage;
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
	  f.submit();
  }
</script>
<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>
</head>

<body>
<div id="wrap">
  <jsp:include page="/inc/top.jsp" flush="true"/>
  <jsp:include page="/inc/top_menu02.jsp" flush="true"/>
<SCRIPT language="JavaScript" src="/js2/reqsubmit/tooltip.js"></SCRIPT>
<script language="javascript">balloonHint("balloonHint")</script>
  <div id="container">
    <div id="leftCon">
      <jsp:include page="/inc/log_info.jsp" flush="true"/>
      <jsp:include page="/inc/left_menu02.jsp" flush="true"/>
	<SCRIPT language="JavaScript" src="/js/reqsubmit/reqinfo.js"></SCRIPT>
    </div>
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
			  <input type="hidden" name="ReqBoxID" value=""><!--�䱸���� ID-->
			  <input type="hidden" name="ReturnUrl" value="<%=request.getRequestURI()%>"><!--�ǵ��ƿ� URL -->

       <!-- pgTit -->

      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%= MenuConstants.REQ_INFO_LIST_SUBMT_NONE %></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.REQUEST_BOX_COMM%> > <%=MenuConstants.REQUEST_BOX_PRE%> > <%=MenuConstants.REQ_INFO_LIST%> > <%= MenuConstants.REQ_INFO_LIST_SUBMT_NONE %></div>
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
            <select onChange="changeReqOrgList()" name="AuditYear">
            </select>
            <select name="ReqOrgID">
            </select>
            <a href="javascript:gotoHeadQuery();"><img src="/images2/btn/bt_search2.gif" width="50" height="22" /></a> </div>
        </div>
        <!-- /�˻�����-->

        <!-- �������� ���� -->

        <!-- list -->

        <span class="list_total">&bull;&nbsp;��ü�ڷ�� : <%=intTotalRecordCount%>�� (<%=intCurrentPageNum%> / <%=intTotalPage%> page)</span>

   <!------------------------- TAB�� �ش��ϴ� ���̺�(����̵� ������̵� ��������) ��� ��~~~�� ------------------------->

        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
          <thead>
            <tr>
              <th scope="col" style="width:15px;">
				<input name="checkAll" type="checkbox" value=""  class="borderNo" onClick="checkAllOrNot(document.listForm);" /></td>
			  </th>
              <th scope="col" style="width:15px;"><a>NO</a></th>
              <th scope="col" style="width:250px;"><%=SortingUtil.getSortLink("changeSortQuery","REQ_CONT",strReqInfoSortField,strReqInfoSortMtd,"�䱸����")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","REQ_BOX_NM",strReqInfoSortField,strReqInfoSortMtd,"�䱸�Ը�")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","REQ_STT",strReqInfoSortField,strReqInfoSortMtd,"����")%></th>
               <th scope="col"><a>�亯</a></th>
               <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","REG_DT",strReqInfoSortField,strReqInfoSortMtd,"�����䱸����")%></th>
            </tr>
          </thead>
          <tbody>
		<%
			int intRecordNumber= intTotalRecordCount;
			String strReqInfoID="";
			String strReqBoxID="";
			if(objRs.getRecordSize()>0){
			while(objRs.next()) {
				strReqInfoID=(String)objRs.getObject("REQ_ID");
				strReqBoxID=(String)objRs.getObject("REQ_BOX_ID");
				//System.out.println("@@@@@@@"+strReqBoxID);
		 %>
            <tr>
              <td><input name="ReqIDs" type="checkbox" value="<%= strReqInfoID %>"  class="borderNo" /></td>
              <td><%= intRecordNumber %></td>
              <td>
			 <%= StringUtil.getNotifyImg((String)objRs.getObject("REG_DT"), (String)objRs.getObject("REQ_STT")) %><a href="JavaScript:gotoDetail('<%= strReqInfoID %>');"><%= StringUtil.substring((String)objRs.getObject("REQ_CONT"), 30) %></a>
			  </td>
              <td>
              <a href="javascript:gotoDetail_Box('<%=strReqBoxID%>');"><%=StringUtil.getReqBoxNmList((String)objRs.getObject("REQ_BOX_NM"))%></a></td>
              <td><%= CodeConstants.getRequestStatus(String.valueOf(objRs.getObject("REQ_STT"))) %></td>
              <td><%= nads.lib.reqsubmit.util.DBAccessUtil.makeAnsInfoHtml((String)objRs.getObject("ANS_ID"),(String)objRs.getObject("ANS_MTD"), StringUtil.ReplaceString((String)objRs.getObject("ANS_OPIN"), "'", ""),(String)objRs.getObject("SUBMT_FLAG"),objUserInfo.isRequester()) %></td>
			  <td><%= StringUtil.getDate((String)objRs.getObject("REG_DT")) %></td>
            </tr>
				<%
						intRecordNumber --;
					}//endwhile
				} else {
				%>
			<tr>
				<td colspan="7" align="center">��ϵ� �䱸������ �����ϴ�.</td>
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
							objParams.getParamValue("ReqInfoPageSize")))
					%>
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
          </select>
          <input name="ReqInfoQryTerm" onKeyDown="return ch()" onMouseDown="return ch()"
		 class="li_input"  style="width:100px" value="<%=objParams.getParamValue("ReqInfoQryTerm")%>"/>
          <img src="/images2/btn/bt_list_search.gif"  onMouseOver="menuOn(this);" onMouseOut="menuOut(this);" onClick="document.listForm.submit();"/> </div>
        <!-- /����Ʈ �� �˻� -->
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
<script>
    init();
</script>