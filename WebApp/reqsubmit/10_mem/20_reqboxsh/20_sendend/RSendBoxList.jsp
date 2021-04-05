<%@ page language="java" contentType="text/html;charset=EUC-KR" %>

<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.bf.config.*"%>
<%@ page import="kr.co.kcc.pf.util.PageCount"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RMemReqBoxListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.MemRequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.RequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.cmtsubmt.*" %>
<%@ page import="nads.dsdm.app.common.page.PagingDelegate" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%
	UserInfoDelegate objUserInfo =null;
	CDInfoDelegate objCdinfo =null;
%>

<%@ include file="../../../common/RUserCodeInfoInc.jsp" %>
<%
	/*** PagingDelegate */
	PagingDelegate objPaging=new PagingDelegate(); 		/*����¡ ��ȯ Delegate*/
%>
<%
	/*************************************************************************************************/
	/** 					�Ķ���� üũ Part 														  */
	/*************************************************************************************************/
	/**���õ� ����⵵�� ���õ� ����ȸID*/
	String strSelectedAuditYear= null; /**���õ� ����⵵*/
	String strSelectedCmtOrganID=null; /**���õ� ����ȸID*/
	String strRltdDuty=null; 			 /**���õ� �������� */
	String strDaeSuCh = null;

	/**�䱸�� �����ȸ�� �Ķ���� ����.*/
	RMemReqBoxListForm objParams=new RMemReqBoxListForm();
	/**�䱸��� ���� :: �Ҽ� ���.*/
	objParams.setParamValue("ReqOrganID", objUserInfo.getOrganID());
	/**�䱸�� ����: �ۼ��� �䱸��.*/
	objParams.setParamValue("ReqBoxStt",CodeConstants.REQ_BOX_STT_006);

	if((objParams.getParamValue("ReqBoxSortField")).equals("reg_dt")){
		objParams.setParamValue("ReqBoxSortField","LAST_REQ_DOC_SND_DT");
	}
	boolean blnParamCheck=false;
	/**���޵� �ĸ����� üũ */
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

	strSelectedAuditYear= objParams.getParamValue("AuditYear"); /**���õ� ����⵵*/
	strSelectedCmtOrganID=objParams.getParamValue("CmtOrganID") ; /**���õ� ����ȸID*/

	strRltdDuty=objParams.getParamValue("RltdDuty") ; 			 /**���õ� �������� */
	String strDaesuInfo = StringUtil.getEmptyIfNull(request.getParameter("DaeSu"));
	strDaeSuCh = StringUtil.getEmptyIfNull(request.getParameter("DAESUCH"));

	/*************************************************************************************************/
	/** 					������ ȣ�� Part 														  */
	/*************************************************************************************************/

	/*** Delegate �� ������ Container��ü ���� */
	MemRequestBoxDelegate objReqBox=null; 		/**�䱸�� Delegate*/
	RequestBoxDelegate objReqBoxDelegate = null;

	// 2005-08-29 kogaeng ADD
	// �䱸�����ڵ������� üũ�ϱ� ���ؼ� �߰��Ǵ� Delegate
	CmtSubmtReqBoxDelegate objBean2 = null;

	ResultSetHelper objRs=null;				/**�䱸�� ��� */
	ResultSetHelper objCmtRs=null;			/** ������ ����ȸ */
	ResultSetHelper objRltdDutyRs=null;   /** �������� ����Ʈ ��¿� RsHelper */
	ResultSetHelper objDaeRs=null;
	ResultSetHelper objYearRs=null;

	String strDaesu = null;
	String strStartdate = null;
	String strEnddate = null;

	try{
		/**�䱸�� ���� �븮�� New */
		objReqBox=new MemRequestBoxDelegate();
		objReqBoxDelegate = new RequestBoxDelegate();

		objBean2 = new CmtSubmtReqBoxDelegate();

		objDaeRs = new ResultSetHelper(objReqBoxDelegate.getOrganDaesu(objUserInfo.getOrganID()));
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

		System.out.println("TIMEMMMM1 : "+this.getCurrentTime());
		objCmtRs=new ResultSetHelper(objReqBox.getReqrPerYearCMTDaeList(objUserInfo.getOrganID(), CodeConstants.REQ_BOX_STT_006,strStartdate,strEnddate,strSelectedAuditYear));
		objYearRs = new ResultSetHelper(objReqBox.getReqrPerYearDaeList(objUserInfo.getOrganID(), CodeConstants.REQ_BOX_STT_006,strStartdate,strEnddate));
		System.out.println("TIMEMMMM2 : "+this.getCurrentTime());

		objhashdata.put("START_DATE",strStartdate);
	    objhashdata.put("END_DATE",strEnddate);

		objRs=new ResultSetHelper(objReqBox.getRecordDaeList(objParams,objhashdata));
		System.out.println("TIMEMMMM3 : "+this.getCurrentTime());
		objRltdDutyRs=new ResultSetHelper(objCdinfo.getRelatedDutyList());
		System.out.println("TIMEMMMM4 : "+this.getCurrentTime());
	} catch(AppException objAppEx) {
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		objMsgBean.setStrCode(objAppEx.getStrErrCode());
		objMsgBean.setStrMsg(objAppEx.getMessage());
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}

	/*************************************************************************************************/
	/** 					������ �� �Ҵ�  Part 														  */
	/*************************************************************************************************/

	/**�䱸���� �����ȸ�� ��� ��ȯ.*/
	int intTotalRecordCount=objRs.getTotalRecordCount();
	int intCurrentPageNum=objRs.getPageNumber();
	int intTotalPage=objRs.getTotalPageCount();
        System.out.println("kangthis count intTotalRecordCount => " + intTotalRecordCount); 
        System.out.println("kangthis count intCurrentPageNum => " + intCurrentPageNum); 
        System.out.println("kangthis count intTotalPage => " + intTotalPage); 
%>
<jsp:include page="/inc/header.jsp" flush="true"/>
<link href="/css2/style.css" rel="stylesheet" type="text/css">

<!-- 2018-09-20 hgyoo ȭ�� �ε�â ���� -->
<style>
	/* The Modal (background) */
	.modal {
	    display: none; /* Hidden by default */
	    position: fixed; /* Stay in place */
	    z-index: 1; /* Sit on top */
	    left: 0;
	    top: 0;
	    width: 100%; /* Full width */
	    height: 100%; /* Full height */
	    /*overflow: auto;*/ /* Enable scroll if needed */
	    /* background-color: rgb(0,0,0); */ /* Fallback color */
	    /* background-color: rgba(0,0,0,0.4); */ /* Black w/ opacity */
	}
	
	/* Modal Content/Box */
	.modal-content {
	    background-color: #fefefe;
	    margin: 18% auto; /* 15% from the top and centered */
	    padding: 20px;
	    border: 1px solid #888;
	    width: 25%; /* Could be more or less, depending on screen size */                          
	}
</style>
<!-- 2018-09-20 hgyoo ȭ�� �ε�â ���� -->

<script language="javascript" src="/js/reqsubmit/common.js"></script>
<script language="javascript">


  /** ���Ĺ�� �ٲٱ� */
  function changeSortQuery(sortField,sortMethod){
  	formName.ReqBoxSortField.value=sortField;
  	formName.ReqBoxSortMtd.value=sortMethod;
	formName.DAESUCH.value = "N";
  	formName.submit();
  }

  //�䱸�Ի󼼺���� ����.
  //function gotoDetail(strID, strCmtOrganID) {
  function gotoDetail(strID) {
  	formName.ReqBoxID.value = strID;
  	//formName.CmtOrganID.value = strCmtOrganID;
  	formName.action="./RSendBoxVList.jsp";
  	formName.submit();
  }

  /** ����¡ �ٷΰ��� */
  function goPage(strPage){
  	formName.ReqBoxPage.value=strPage;
	formName.DAESUCH.value = "N";
  	formName.submit();
  }

  /**�⵵�� ����ȸ�θ� ��ȸ�ϱ� */
  function gotoHeadQuery(){
  	formName.ReqBoxQryField.value="";
  	formName.ReqBoxQryTerm.value="";
  	formName.ReqBoxSortField.value="";
  	formName.ReqBoxSortMtd.value="";
  	formName.ReqBoxPage.value="";
	formName.DAESUCH.value = "N";
  	formName.submit();
  }
  
  
	//2018-09-20 hgyoo ȭ�� �ε�â ����
	function ButtonProcessing()
	{    
		var modal_base = document.getElementById("modal_base");	
		modal_base.style.display = "block";
	}  
	
	//2018-09-19 hgyoo
	function notProcessing(){
		var modal_base = document.getElementById("modal_base");      
	    modal_base.style.display  = "none";
	}

	// 2005-07-18 ���õ� �䱸�� �ϰ� ����
	function doDelete() {
	  	if(getCheckCount(document.formName, "ReqBoxIDs") < 1) {
	  		alert("�����Ͻ� �ϳ� �̻��� �䱸���� ������ �ּ���.");
	  		return;
	  	}
	  	if(confirm("�����Ͻ� �䱸���� �ϰ� �����Ͻðڽ��ϱ�?\n\r\n\r1. ���Ե� ��� �䱸 ���뵵 �ϰ� �����˴ϴ�.\n\r2. �߼۵� �ش� ������������ �䱸�Գ����� �����˴ϴ�.\n\r3. �亯�� ���� ���� �䱸���� �������� �ʽ��ϴ�.")) {
	  		var w = 300;
	  		var h = 200;
			var winl = (screen.width - w) / 2;
			var winh = (screen.height - h) / 2;
			//document.all.loadingDiv.style.left = winl;
			//document.all.loadingDiv.style.top = winh;
			//document.all.loadingDiv.style.display = '';
			
			//ButtonProcessing();  //ó�����¸� ǥ���ϴ� �޼ҵ� ȣ��
            var innHtml = '<div id="loading_layer"><b>ó�����Դϴ�. ��ø� ��ٷ��ּ���...</b><br><img src="/image/reqsubmit/processing.gif" ></div>'
			$('body').prepend(innHtml);
			
			document.formName.action = "RSendBoxDelProc.jsp";
			document.formName.target = 'processingFrame';
			//window.open('/blank.html', 'popwin', 'width='+w+', height='+h+', left='+winl+', top='+winh);
	  		document.formName.submit();
	  	}
	}

	function changeDaesu(){
		formName.DAESUCH.value = "Y";
		formName.submit();
	}

	function doListRefresh() {
		var f = document.formName;
		f.target = "";
		f.submit();
	}
</script>
</head>

<body>
<iframe name='processingFrame' height='0' width='0'></iframe>
<div id="modal_base" class="modal">
	<DIV id="processingDiv" class="modal-content" >
		<img src="/image/reqsubmit/processing.gif" border="0">
	</DIV>
</div>
<DIV ID="loadingDiv" style="display:none;position:absolute;">
	<img src="/image/reqsubmit/loading.jpg" border="0"> </td>
</DIV>
<div id="wrap">
  <jsp:include page="/inc/top.jsp" flush="true"/>
  <jsp:include page="/inc/top_menu02.jsp" flush="true"/>
  <div id="container">
    <div id="leftCon">
      <jsp:include page="/inc/log_info.jsp" flush="true"/>
      <jsp:include page="/inc/left_menu02.jsp" flush="true"/>
    </div>
    <div id="rightCon">
<form name="formName" method="get" action="<%=request.getRequestURI()%>">
<%//���� ���� �ޱ�.
String strReqBoxSortField=objParams.getParamValue("ReqBoxSortField");
String strReqBoxSortMtd=objParams.getParamValue("ReqBoxSortMtd");
%>
<input type="hidden" name="ReqBoxSortField" value="<%=strReqBoxSortField%>"><!--�䱸�Ը�������ʵ� -->
<input type="hidden" name="ReqBoxSortMtd" value="<%=strReqBoxSortMtd%>"><!--�䱸�Ը�����ɹ��-->
<input type="hidden" name="ReqBoxPage" value="<%=intCurrentPageNum%>"><!--������ ��ȣ -->
<input type="hidden" name="ReqBoxID" value=""><!--�䱸�Թ�ȣ �Ϲ������δ� ���ȵ�-->
<input type="hidden" name="DAESUCH" value="">

      <!-- pgTit -->

      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=MenuConstants.REQ_BOX_SEND_END%></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.getReqBoxGeneral(request)%> > <%=MenuConstants.REQ_BOX_SEND_END%></div>
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
            <select onChange="javascript:doListRefresh()" name="AuditYear">
            <option value="">��ü</option>
			<%
					if(objYearRs != null && objYearRs.getTotalRecordCount() > 0){
						while(objYearRs.next()){
					%>
						<option value="<%=objYearRs.getObject("AUDIT_YEAR")%>" <%if(((String)objYearRs.getObject("AUDIT_YEAR")).equals(strSelectedAuditYear)){%>selected<%}%>><%=objYearRs.getObject("AUDIT_YEAR")%></option>
					<%
						}
					}
				%>
            </select>
            <select onChange="javascript:doListRefresh()" name="CmtOrganID">
				<option value="">:::: ��ü����ȸ :::</option>
			<%
				if(objCmtRs != null && objCmtRs.getTotalRecordCount() > 0){
					while(objCmtRs.next()){
				%>
					<option value="<%=objCmtRs.getObject("ORGAN_ID")%>" <%if(((String)objCmtRs.getObject("ORGAN_ID")).equals(strSelectedCmtOrganID)){%>selected<%}%>><%=objCmtRs.getObject("ORGAN_NM")%></option>
				<%
					}
				}
			%>
            </select>
            <select onChange="this.form.submit()" name="RltdDuty">
				 <option value="">��������(��ü)</option>
				<%
				   /**�������� ����Ʈ ��� */
				   while(objRltdDutyRs!=null && objRltdDutyRs.next()){
						String strCode=(String)objRltdDutyRs.getObject("MSORT_CD");
						out.println("<option value=\"" + strCode + "\" " + StringUtil.getSelectedStr(strRltdDuty,strCode) + ">" + objRltdDutyRs.getObject("CD_NM") + "</option>");
				   }
				%>
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
			<th scope="col"><input name="checkAll" type="checkbox" class="borderNo" onClick="javascript:checkAllOrNot(document.formName)" /></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","REQ_BOX_NM",strReqBoxSortField,strReqBoxSortMtd,"�䱸�Ը�")%></th>
			  <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","REGR_NM",strReqBoxSortField,strReqBoxSortMtd,"�����")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","SUBMT_ORGAN_NM",strReqBoxSortField,strReqBoxSortMtd,"������")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","RLTD_DUTY",strReqBoxSortField,strReqBoxSortMtd,"��������")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","REQ_BOX_STT",strReqBoxSortField,strReqBoxSortMtd,"�������")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","",strReqBoxSortField,strReqBoxSortMtd,"����/�䱸")%></th>
               <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","LAST_REQ_DOC_SND_DT", strReqBoxSortField,strReqBoxSortMtd,"�߼��Ͻ�")%></th>
            </tr>
          </thead>
          <tbody>
		<%
		  int intRecordNumber=intTotalRecordCount - ((intCurrentPageNum -1) * Integer.parseInt((String)objParams.getParamValue("ReqBoxPageSize")));
		  //int intRecordNumber=intTotalRecordCount;
		  if(objRs.getRecordSize()>0){
			String strReqBoxID="";
			while(objRs.next()){
			 strReqBoxID=(String)objRs.getObject("REQ_BOX_ID");
		 %>
            <tr>
			  <td><input name="ReqBoxIDs" type="checkbox" class="borderNo" value="<%= strReqBoxID %>" /></td>
              <!--<td><a href="javascript:gotoDetail('<%=strReqBoxID%>', '<%= objRs.getObject("CMT_ORGAN_ID") %>')"><%=(String)objRs.getObject("REQ_BOX_NM")%></a></td>-->
              <td><a href="javascript:gotoDetail('<%=strReqBoxID%>')"><%=(String)objRs.getObject("REQ_BOX_NM")%></a></td>
			  <td><%=(String)objRs.getObject("REGR_NM")%></td>
              <td><%=(String)objRs.getObject("SUBMT_ORGAN_NM")%></td>
              <td><%=objCdinfo.getRelatedDuty((String)objRs.getObject("RLTD_DUTY"))%></td>
              <td><%=CodeConstants.getReqBoxStatus((String)objRs.getObject("REQ_BOX_STT"),true)%></td>
              <td><%=objRs.getObject("SUBMT_CNT")%>/<%=objRs.getObject("REQ_CNT")%></td>
              <td><%=StringUtil.getDate2((String)objRs.getObject("LAST_REQ_DOC_SND_DT"))%></td>
            </tr>
				<%
						intRecordNumber --;
					}//endwhile
				} else {
				%>
			<tr>
				<td colspan="7" align="center">��ϵ� <%=MenuConstants.REQ_BOX_SEND_END%>�� �����ϴ�.</td>
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
							objParams.getParamValue("ReqBoxPageSize")))%>
        <!-- ����¡-->
         <!-- /����¡-->
        <!--  <p class="warning">* �䱸���� �߼��ϰ� �Ǹ� �ش� ���� ��� ��ǥ ����ڿ��� ���� �߼۵Ǹ�, ����ڰ� ���� ���� �ۼ� �� �䱸�Կ� �״�� �����ְ� �˴ϴ�.  </p>
          <p class="warning">* �䱸�� �߼� ��ư�� �̿��Ͻñ� ���ؼ��� ����ȸ�� ������ �ֽñ� �ٶ��ϴ�.  </p>  -->



        <!-- ����Ʈ ��ư-->
        <div id="btn_all" >        <!-- ����Ʈ �� �˻� -->
        <div class="list_ser" >
		<%
			String strReqBoxQryField=objParams.getParamValue("ReqBoxQryField");
		%>
          <select name="ReqBoxQryField" class="selectBox5"  style="width:70px;" >
           <option <%=(strReqBoxQryField.equalsIgnoreCase("req_box_nm"))? " selected ": ""%>value="req_box_nm">�䱸�Ը�</option>
			<option <%=(strReqBoxQryField.equalsIgnoreCase("req_box_dsc"))? " selected ": ""%>value="req_box_dsc">�䱸�Լ���</option>
            <option <%=(strReqBoxQryField.equalsIgnoreCase("regr_nm"))? " selected ": ""%>value="regr_nm">�����</option>
			<option <%=(strReqBoxQryField.equalsIgnoreCase("submt_organ_nm"))? " selected ": ""%>value="submt_organ_nm">������</option>
          </select>
          <input name="ReqBoxQryTerm" onKeyDown="return ch()" onMouseDown="return ch()"
		 class="li_input"  style="width:100px" value="<%=objParams.getParamValue("ReqBoxQryTerm")%>"/>
          <img src="/images2/btn/bt_list_search.gif"  onMouseOver="menuOn(this);" onMouseOut="menuOut(this);" onClick="formName.submit();"/> </div>
        <!-- /����Ʈ �� �˻� -->

		</div>

        <!-- /����Ʈ ��ư-->
		<div id="btn_all"  class="t_right">
			 <span class="list_bt"><a href="javascript:doDelete()">�䱸�� ����</a></span>
		 </div>
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
<%
	System.out.println("TIMEMMMM5 : "+this.getCurrentTime());
%>
<%!
	public String getCurrentTime() {
        Calendar oCalendar = Calendar.getInstance();
		String serverDate = oCalendar.get(Calendar.YEAR) + "/" +(oCalendar.get(Calendar.MONTH) + 1)+"/"+ oCalendar.get(Calendar.DAY_OF_MONTH)+"  "+oCalendar.get(Calendar.HOUR_OF_DAY)+":"+oCalendar.get(Calendar.MINUTE)+":"+oCalendar.get(Calendar.SECOND)+":"+oCalendar.get(Calendar.MILLISECOND);
		 return serverDate;
     }

%>