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
	PagingDelegate objPaging=new PagingDelegate(); 		/*페이징 변환 Delegate*/
%>
<%
	/*************************************************************************************************/
	/** 					파라미터 체크 Part 														  */
	/*************************************************************************************************/
	/**선택된 감사년도와 선택된 위원회ID*/
	String strSelectedAuditYear= null; /**선택된 감사년도*/
	String strSelectedCmtOrganID=null; /**선택된 위원회ID*/
	String strRltdDuty=null; 			 /**선택된 업무구분 */
	String strDaeSuCh = null;

	/**요구함 목록조회용 파라미터 설정.*/
	RMemReqBoxListForm objParams=new RMemReqBoxListForm();
	/**요구기관 설정 :: 소속 기관.*/
	objParams.setParamValue("ReqOrganID", objUserInfo.getOrganID());
	/**요구함 상태: 작성중 요구함.*/
	objParams.setParamValue("ReqBoxStt",CodeConstants.REQ_BOX_STT_006);

	if((objParams.getParamValue("ReqBoxSortField")).equals("reg_dt")){
		objParams.setParamValue("ReqBoxSortField","LAST_REQ_DOC_SND_DT");
	}
	boolean blnParamCheck=false;
	/**전달된 파리미터 체크 */
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

	strSelectedAuditYear= objParams.getParamValue("AuditYear"); /**선택된 감사년도*/
	strSelectedCmtOrganID=objParams.getParamValue("CmtOrganID") ; /**선택된 위원회ID*/

	strRltdDuty=objParams.getParamValue("RltdDuty") ; 			 /**선택된 업무구분 */
	String strDaesuInfo = StringUtil.getEmptyIfNull(request.getParameter("DaeSu"));
	strDaeSuCh = StringUtil.getEmptyIfNull(request.getParameter("DAESUCH"));

	/*************************************************************************************************/
	/** 					데이터 호출 Part 														  */
	/*************************************************************************************************/

	/*** Delegate 과 데이터 Container객체 선언 */
	MemRequestBoxDelegate objReqBox=null; 		/**요구함 Delegate*/
	RequestBoxDelegate objReqBoxDelegate = null;

	// 2005-08-29 kogaeng ADD
	// 요구일정자동생성을 체크하기 위해서 추가되는 Delegate
	CmtSubmtReqBoxDelegate objBean2 = null;

	ResultSetHelper objRs=null;				/**요구함 목록 */
	ResultSetHelper objCmtRs=null;			/** 연도별 위원회 */
	ResultSetHelper objRltdDutyRs=null;   /** 업무구분 리스트 출력용 RsHelper */
	ResultSetHelper objDaeRs=null;
	ResultSetHelper objYearRs=null;

	String strDaesu = null;
	String strStartdate = null;
	String strEnddate = null;

	try{
		/**요구함 정보 대리자 New */
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
	/** 					데이터 값 할당  Part 														  */
	/*************************************************************************************************/

	/**요구정보 목록조회된 결과 반환.*/
	int intTotalRecordCount=objRs.getTotalRecordCount();
	int intCurrentPageNum=objRs.getPageNumber();
	int intTotalPage=objRs.getTotalPageCount();
        System.out.println("kangthis count intTotalRecordCount => " + intTotalRecordCount); 
        System.out.println("kangthis count intCurrentPageNum => " + intCurrentPageNum); 
        System.out.println("kangthis count intTotalPage => " + intTotalPage); 
%>
<jsp:include page="/inc/header.jsp" flush="true"/>
<link href="/css2/style.css" rel="stylesheet" type="text/css">

<!-- 2018-09-20 hgyoo 화면 로딩창 수정 -->
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
<!-- 2018-09-20 hgyoo 화면 로딩창 수정 -->

<script language="javascript" src="/js/reqsubmit/common.js"></script>
<script language="javascript">


  /** 정렬방법 바꾸기 */
  function changeSortQuery(sortField,sortMethod){
  	formName.ReqBoxSortField.value=sortField;
  	formName.ReqBoxSortMtd.value=sortMethod;
	formName.DAESUCH.value = "N";
  	formName.submit();
  }

  //요구함상세보기로 가기.
  //function gotoDetail(strID, strCmtOrganID) {
  function gotoDetail(strID) {
  	formName.ReqBoxID.value = strID;
  	//formName.CmtOrganID.value = strCmtOrganID;
  	formName.action="./RSendBoxVList.jsp";
  	formName.submit();
  }

  /** 페이징 바로가기 */
  function goPage(strPage){
  	formName.ReqBoxPage.value=strPage;
	formName.DAESUCH.value = "N";
  	formName.submit();
  }

  /**년도와 위원회로만 조회하기 */
  function gotoHeadQuery(){
  	formName.ReqBoxQryField.value="";
  	formName.ReqBoxQryTerm.value="";
  	formName.ReqBoxSortField.value="";
  	formName.ReqBoxSortMtd.value="";
  	formName.ReqBoxPage.value="";
	formName.DAESUCH.value = "N";
  	formName.submit();
  }
  
  
	//2018-09-20 hgyoo 화면 로딩창 수정
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

	// 2005-07-18 선택된 요구함 일괄 삭제
	function doDelete() {
	  	if(getCheckCount(document.formName, "ReqBoxIDs") < 1) {
	  		alert("삭제하실 하나 이상의 요구함을 선택해 주세요.");
	  		return;
	  	}
	  	if(confirm("선택하신 요구함을 일괄 삭제하시겠습니까?\n\r\n\r1. 포함된 모든 요구 내용도 일괄 삭제됩니다.\n\r2. 발송된 해당 제출기관에서도 요구함내용이 삭제됩니다.\n\r3. 답변이 진행 중인 요구함은 삭제되지 않습니다.")) {
	  		var w = 300;
	  		var h = 200;
			var winl = (screen.width - w) / 2;
			var winh = (screen.height - h) / 2;
			//document.all.loadingDiv.style.left = winl;
			//document.all.loadingDiv.style.top = winh;
			//document.all.loadingDiv.style.display = '';
			
			//ButtonProcessing();  //처리상태를 표시하는 메소드 호출
            var innHtml = '<div id="loading_layer"><b>처리중입니다. 잠시만 기다려주세요...</b><br><img src="/image/reqsubmit/processing.gif" ></div>'
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
<%//정렬 정보 받기.
String strReqBoxSortField=objParams.getParamValue("ReqBoxSortField");
String strReqBoxSortMtd=objParams.getParamValue("ReqBoxSortMtd");
%>
<input type="hidden" name="ReqBoxSortField" value="<%=strReqBoxSortField%>"><!--요구함목록정렬필드 -->
<input type="hidden" name="ReqBoxSortMtd" value="<%=strReqBoxSortMtd%>"><!--요구함목록정령방법-->
<input type="hidden" name="ReqBoxPage" value="<%=intCurrentPageNum%>"><!--페이지 번호 -->
<input type="hidden" name="ReqBoxID" value=""><!--요구함번호 일반적으로는 사용안됨-->
<input type="hidden" name="DAESUCH" value="">

      <!-- pgTit -->

      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=MenuConstants.REQ_BOX_SEND_END%></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.getReqBoxGeneral(request)%> > <%=MenuConstants.REQ_BOX_SEND_END%></div>
        <p><!--문구--></p>
      </div>
      <!-- /pgTit -->

      <!-- contents -->

      <div id="contents">

        <!-- 검색조건 없는 경우 아래 div 삭제 나 주석으로 막으세요.-->
        <div class="schBox">
          <p>요구함조회조건</p>
          <span class="line"><img src="/images2/foundation/search_line.gif" width="172" height="3" /></span>
          <div class="box">
            <!-- 기존의 검색 셀렉트와 버튼만 넣으세요-->
            <select onChange="changeDaesu()" name="DaeSu">
			<%
					if(objDaeRs != null){
						while(objDaeRs.next()){
							String str = objDaeRs.getObject("DAE_NUM")+"^"+objDaeRs.getObject("START_DATE")+"^"+objDaeRs.getObject("END_DATE");
				%>
				<option value="<%=objDaeRs.getObject("DAE_NUM")%>^<%=objDaeRs.getObject("START_DATE")%>^<%=objDaeRs.getObject("END_DATE")%>" <%if(str.equals(strDaesuInfo)){%>selected<%}%>><%=objDaeRs.getObject("DAE_NUM")%>대</option>
				<%
					}
					}
				%>
            </select>
            <select onChange="javascript:doListRefresh()" name="AuditYear">
            <option value="">전체</option>
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
				<option value="">:::: 전체위원회 :::</option>
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
				 <option value="">업무구분(전체)</option>
				<%
				   /**업무구분 리스트 출력 */
				   while(objRltdDutyRs!=null && objRltdDutyRs.next()){
						String strCode=(String)objRltdDutyRs.getObject("MSORT_CD");
						out.println("<option value=\"" + strCode + "\" " + StringUtil.getSelectedStr(strRltdDuty,strCode) + ">" + objRltdDutyRs.getObject("CD_NM") + "</option>");
				   }
				%>
            </select>
            <a href="javascript:gotoHeadQuery();"><img src="/images2/btn/bt_search2.gif" width="50" height="22" /></a> </div>
        </div>
        <!-- /검색조건-->

        <!-- 각페이지 내용 -->

        <!-- list -->

        <span class="list_total">&bull;&nbsp;전체자료수 : <%=intTotalRecordCount%>개 (<%=intCurrentPageNum%> / <%=intTotalPage%> page)</span>
 <!------------------------- TAB에 해당하는 테이블(목록이든 등록폼이든 상세정보든) 출력 시~~~작 ------------------------->

        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
          <thead>
            <tr>
			<th scope="col"><input name="checkAll" type="checkbox" class="borderNo" onClick="javascript:checkAllOrNot(document.formName)" /></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","REQ_BOX_NM",strReqBoxSortField,strReqBoxSortMtd,"요구함명")%></th>
			  <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","REGR_NM",strReqBoxSortField,strReqBoxSortMtd,"등록자")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","SUBMT_ORGAN_NM",strReqBoxSortField,strReqBoxSortMtd,"제출기관")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","RLTD_DUTY",strReqBoxSortField,strReqBoxSortMtd,"업무구분")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","REQ_BOX_STT",strReqBoxSortField,strReqBoxSortMtd,"진행상태")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","",strReqBoxSortField,strReqBoxSortMtd,"제출/요구")%></th>
               <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","LAST_REQ_DOC_SND_DT", strReqBoxSortField,strReqBoxSortMtd,"발송일시")%></th>
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
				<td colspan="7" align="center">등록된 <%=MenuConstants.REQ_BOX_SEND_END%>이 없습니다.</td>
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
        <!-- 페이징-->
         <!-- /페이징-->
        <!--  <p class="warning">* 요구서를 발송하게 되면 해당 제출 기관 대표 담당자에게 지정 발송되며, 담당자가 없는 경우는 작성 중 요구함에 그대로 남아있게 됩니다.  </p>
          <p class="warning">* 요구서 발송 버튼을 이용하시기 위해서는 위원회를 선택해 주시기 바랍니다.  </p>  -->



        <!-- 리스트 버튼-->
        <div id="btn_all" >        <!-- 리스트 내 검색 -->
        <div class="list_ser" >
		<%
			String strReqBoxQryField=objParams.getParamValue("ReqBoxQryField");
		%>
          <select name="ReqBoxQryField" class="selectBox5"  style="width:70px;" >
           <option <%=(strReqBoxQryField.equalsIgnoreCase("req_box_nm"))? " selected ": ""%>value="req_box_nm">요구함명</option>
			<option <%=(strReqBoxQryField.equalsIgnoreCase("req_box_dsc"))? " selected ": ""%>value="req_box_dsc">요구함설명</option>
            <option <%=(strReqBoxQryField.equalsIgnoreCase("regr_nm"))? " selected ": ""%>value="regr_nm">등록자</option>
			<option <%=(strReqBoxQryField.equalsIgnoreCase("submt_organ_nm"))? " selected ": ""%>value="submt_organ_nm">제출기관</option>
          </select>
          <input name="ReqBoxQryTerm" onKeyDown="return ch()" onMouseDown="return ch()"
		 class="li_input"  style="width:100px" value="<%=objParams.getParamValue("ReqBoxQryTerm")%>"/>
          <img src="/images2/btn/bt_list_search.gif"  onMouseOver="menuOn(this);" onMouseOut="menuOut(this);" onClick="formName.submit();"/> </div>
        <!-- /리스트 내 검색 -->

		</div>

        <!-- /리스트 버튼-->
		<div id="btn_all"  class="t_right">
			 <span class="list_bt"><a href="javascript:doDelete()">요구함 삭제</a></span>
		 </div>
        <!-- /각페이지 내용 -->
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
