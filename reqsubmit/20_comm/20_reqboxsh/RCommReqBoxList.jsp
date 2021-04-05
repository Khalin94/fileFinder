<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.pf.util.PageCount"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RCommReqBoxListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.CommRequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.common.page.PagingDelegate" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%
	/*** PagingDelegate */
	PagingDelegate objPaging=new PagingDelegate(); 		/*페이징 변환 Delegate*/
%>
<%
	UserInfoDelegate objUserInfo =null;
	CDInfoDelegate objCdinfo =null;
%>
<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>

<%
	/*************************************************************************************************/
	/** 	name : RCommReqBoxList.jsp																  */
	/** 		   위원회 요구함 목록을 출력한다.													  */
	/** 		   요구일정이 있는 소속 위원회의 목록을 출력한다.										  */
	/*************************************************************************************************/

  	/**선택된 감사년도와 선택된 위원회ID*/
	String strSelectedAuditYear= null; /**선택된 감사년도*/
	String strSelectedCmtOrganID=null; /**선택된 위원회ID*/
	String strReqScheID="";			 /**위원회 요구일정ID*/
	String strRltdDuty=null; 			 /**선택된 업무구분 */

  	//로그인 사용자 정보를 가져온다. 권한없음 경우 관람만 가능하다.
 	String strReqSubmitFlag = objUserInfo.getReqSubmitFlag();

 	/**위원회목록조회용 파라미터 설정.*/
 	RCommReqBoxListForm objParams=new RCommReqBoxListForm();
 	//요구기관 설정 :: 소속 기관.
 	objParams.setParamValue("ReqOrganID",objUserInfo.getOrganID());
 	//위원회 요구일정진행상태 : 접수중
 	objParams.setParamValue("IngStt",CodeConstants.REQ_ING_STT_001);
 	//요구함 상태 : 접수중
 	objParams.setParamValue("ReqBoxStt",CodeConstants.REQ_BOX_STT_001);
 	/** 위원회 행정직원 일때만 화면에 출력함.*/
 	if(objUserInfo.getOrganGBNCode().equals("004")){
  		objParams.setParamValue("CmtOrganID",objUserInfo.getOrganID());
	}

 	//해당위원회가 없을경우.. 에러메세지 출력..
 	if(objUserInfo.getCurrentCMTList().isEmpty()){
		objParams.setParamValue("CmtOrganID","XXXXXXXXXX");
 	}//endif

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

  	strSelectedAuditYear= objParams.getParamValue("AuditYear"); 	/**선택된 감사년도*/
  	strSelectedCmtOrganID=objParams.getParamValue("CmtOrganID") ; /**선택된 위원회ID*/
  	strRltdDuty=objParams.getParamValue("RltdDuty") ; 			 /**선택된 업무구분 */

 	//요구함 객체 ※Delegate 선언※.
 	CommRequestBoxDelegate objReqBox = null;
 	ResultSetHelper objCmtRs=null;					/** 연도별 위원회 */
 	ResultSetHelper objRs=null;					/** 위원회 요구함 목록 */
 	ResultSetHelper objRltdDutyRs=null;    		/** 업무구분 리스트 출력용 RsHelper */
 	ResultSetSingleHelper objRsInfo=null;
 	ResultSetHelper objReqOrganRS = null;				/** 위원회별 의원실 목록 */

 	String strReqOrganID = objParams.getParamValue("ReqOrganIDZ");

 	try{
 		objReqBox=new CommRequestBoxDelegate();
		//해당위원회가 없을경우..
		if(objUserInfo.getCurrentCMTList().isEmpty()){
			List lst = objUserInfo.getCurrentCMTList();
			Hashtable objHash = new Hashtable();
			objHash.put("ORGAN_ID", "XXXXXXXXXX");
			objHash.put("ORGAN_NM", "XXXXXXXXXX");
			lst.add(objHash);

			objCmtRs=new ResultSetHelper(objReqBox.getReqrPerYearCMTList(lst,CodeConstants.REQ_ING_STT_001,CodeConstants.REQ_BOX_STT_001));
		} else {
	 		objCmtRs=new ResultSetHelper(objReqBox.getReqrPerYearCMTList(objUserInfo.getCurrentCMTList(),CodeConstants.REQ_ING_STT_001,CodeConstants.REQ_BOX_STT_001));
 		} //endif

 		//상태에 따라 목록 List출력..
   		/** 파라미터로 받은 정보가 없을 경우 리스트에서 가져옴.*/
  		 if(objCmtRs.next() && !StringUtil.isAssigned(strSelectedAuditYear) && !StringUtil.isAssigned(strSelectedCmtOrganID)){
 			strSelectedAuditYear=(String)objCmtRs.getObject("AUDIT_YEAR");
 			strSelectedCmtOrganID=(String)objCmtRs.getObject("CMT_ORGAN_ID");
	 	   objParams.setParamValueIfNull("AuditYear",strSelectedAuditYear);
		    objParams.setParamValueIfNull("CmtOrganID",strSelectedCmtOrganID);
			if(!StringUtil.isAssigned(strSelectedCmtOrganID)){
				objParams.setParamValue("CmtOrganID",objUserInfo.getOrganID());
			}
   		} else if(!StringUtil.isAssigned(strSelectedAuditYear)) {
   			strSelectedAuditYear=(String)objCmtRs.getObject("AUDIT_YEAR");
	    	objParams.setParamValueIfNull("AuditYear",strSelectedAuditYear);
   		}

   		objRltdDutyRs=new ResultSetHelper(objCdinfo.getRelatedDutyList());
   		//요구함 목록
   		objRs=new ResultSetHelper(objReqBox.getRecordList(objParams));
   		//위원회일정ID
   		strReqScheID=objReqBox.getReqScheID(strSelectedAuditYear,strSelectedCmtOrganID,CodeConstants.REQ_ING_STT_001,CodeConstants.REQ_BOX_STT_001);

		/** 2005-10-13 kogaeng ADD : 의원실 목록 조회 */
		objReqOrganRS = new ResultSetHelper(objReqBox.getCmtReqOrganList(strSelectedCmtOrganID));

 	} catch(AppException objAppEx) {
 		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  		objMsgBean.setStrCode(objAppEx.getStrErrCode());
  		objMsgBean.setStrMsg(objAppEx.getMessage());
%>
  		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
  		return;
 	}

 	String strRsCmt = (String)objCmtRs.getObject("CMT_ORGAN_ID");

	//요구함 목록조회된 결과 반환.
 	int intTotalRecordCount=objRs.getTotalRecordCount();
 	int intCurrentPageNum=objRs.getPageNumber();
 	int intTotalPage=objRs.getTotalPageCount();
%>

<jsp:include page="/inc/header.jsp" flush="true"/>
<link href="/css2/style.css" rel="stylesheet" type="text/css">
<script language="javascript" src="/js/reqsubmit/common.js"></script>
<script language="javascript">
<%
 	//콤보 박스에 자료 넣기위해 Array에 테이터 넣어주는 부분.
    out.println("var varSelectedYear='" + strSelectedAuditYear + "';");
    out.println("var varSelectedCmt='" + strSelectedCmtOrganID + "';");
    out.println("var arrPerYearCmt=new Array(" + objCmtRs.getTotalRecordCount() + ");");
	Vector vectorYear=new Vector();
	String strTmpYear="";
	String strOldYear="";
	objCmtRs.first();
	for(int i=0;objCmtRs.next();i++){
	  	strTmpYear=(String)objCmtRs.getObject("AUDIT_YEAR");
	    out.println("arrPerYearCmt[" + i + "]=new Array('"
			+ strTmpYear	+ "','" + objCmtRs.getObject("CMT_ORGAN_ID") + "','" + objCmtRs.getObject("CMT_ORGAN_NM") + "');");
		if(!strTmpYear.equals(strOldYear)){
			vectorYear.add(strTmpYear);
		}
		strOldYear=strTmpYear;
	 }
	 out.println("var arrYear=new Array(" + vectorYear.size() + ");");
	 for(int i=0;i<vectorYear.size();i++){
	   out.println("arrYear[" + i + "]= new Array('" + (String)vectorYear.get(i)+ "');");
	 }
%>

	/** 위원회 연도 초기화 */
	function init() {
		var field=listqry.AuditYear;
		for(var i=0;i<arrYear.length;i++) {
			var tmpOpt=new Option();
		   	tmpOpt.text=arrYear[i];
			tmpOpt.value=tmpOpt.text;
			if(varSelectedYear==tmpOpt.text) {
				tmpOpt.selected=true;
			}
			field.add(tmpOpt);
		}
		makePerYearCmtList(field.options[field.selectedIndex].value);
  	}

	/** 연도별 위원회 리스트 초기화 */
	function makePerYearCmtList(strYear) {
    	var field=listqry.CmtOrganID;
       	field.length=0;
		for(var i=0;i<arrPerYearCmt.length;i++) {
			var strTmpYear=arrPerYearCmt[i][0];
			if(strYear==strTmpYear) {
				var tmpOpt=new Option();
				tmpOpt.value=arrPerYearCmt[i][1];
				tmpOpt.text=arrPerYearCmt[i][2];
				if(varSelectedCmt==tmpOpt.value){
					tmpOpt.selected=true;
				}
				field.add(tmpOpt);
			}
		}
	}

	/** 연도 변화에 따른 위원회 리스트 변화 */
	function changeCmtList(){
		makePerYearCmtList(listqry.AuditYear.options[listqry.AuditYear.selectedIndex].value);
	}

	/** 정렬방법 바꾸기 */
	function changeSortQuery(sortField,sortMethod){
  		listqry.CommReqBoxSortField.value=sortField;
	  	listqry.CommReqBoxSortMtd.value=sortMethod;
	  	listqry.target = "";
  		listqry.submit();
	}

	//요구함상세보기로 가기.
	function gotoDetail(strID){
  		//listqry.ReqBoxID.value=strID;
	  	listqry.action="./RCommReqBoxVList.jsp?ReqBoxID="+strID;
	  	listqry.target = "";
  		listqry.submit();
	}

  	/** 페이징 바로가기 */
	function goPage(strPage){
  		listqry.CommReqBoxPage.value=strPage;
  		listqry.target = "";
  		listqry.submit();
	}

	/** 요구함 생성 바로가기 */
	function gotoMake(strReqScheID){
    	form=document.listqry;
		if(<%= strRsCmt.equals("")%>){
    		alert("위원회 요구 일정이 없습니다. \n위원회 요구일정을 먼저 작성하십시요.");
	    } else {
		  	form.ReqScheID.value=strReqScheID;
	  		form.action="./RCommNewBoxMake.jsp";
	  		listqry.target = "";
		  	form.submit();
		}
	}

	/**년도와 위원회로만 조회하기 */
	function gotoHeadQuery(){
  		listqry.CommReqBoxQryField.value="";
	  	listqry.CommReqBoxQryTerm.value="";
  		listqry.CommReqBoxSortField.value="";
	  	listqry.CommReqBoxSortMtd.value="";
  		listqry.CommReqBoxPage.value="";
  		listqry.target = "";
	  	listqry.submit();
	}

	function doDelete() {
		if(getCheckCount(document.listqry, "ReqBoxID") < 1) {
			alert("삭제하실 하나 이상의 요구함을 선택해 주시기 바랍니다.");
			return;
		}
		if(confirm("요구함을 삭제하시면 포함된 요구 내용들도 일괄 삭제됩니다.\n\r\n\r선택하신 요구함을 일괄 삭제하시겠습니까?")) {
			var winl = (screen.width - 300) / 2;
			var winh = (screen.height - 240) / 2;
			document.listqry.target = "popwin";
			document.listqry.action = "/reqsubmit/20_comm/20_reqboxsh/RCommReqBoxDelProc2.jsp";
			window.open('/blank.html', 'popwin', 'width=300, height=240, left='+winl+', top='+winh);
			document.listqry.submit();
		}
	}

	// 조회 옵션에 따른 Form submit 만 수행
	function doListRefresh() {
		var f = document.listqry;
		f.target = "";
		f.submit();
	}
</script>
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
    </div>
    <div id="rightCon">

		<form name="listqry" method="post" action="<%=request.getRequestURI()%>">
			<%//정렬 정보 받기.
				String strCommReqBoxSortField=objParams.getParamValue("CommReqBoxSortField");
				String strCommReqBoxSortMtd=objParams.getParamValue("CommReqBoxSortMtd");
			%>
			<input type="hidden" name="CommReqBoxSortField" value="<%=strCommReqBoxSortField%>"><!--요구함목록정렬필드 -->
			<input type="hidden" name="CommReqBoxSortMtd" value="<%=strCommReqBoxSortMtd%>">	<!--요구함목록정령방법-->
			<input type="hidden" name="CommReqBoxPage" value="<%=intCurrentPageNum%>">			<!--페이지 번호 -->
			<input type="hidden" name="ReqScheID" value="">		<!--위원회 일정ID -->
			<input type="hidden" name="DelURL" value="<%= request.getRequestURI() %>">
      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=MenuConstants.COMM_REQ_BOX_MAKE%><span class="sub_stl" >- 요구함 목록</span></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.REQUEST_BOX_COMM%> > <B><%=MenuConstants.COMM_REQ_BOX_MAKE%></B></div>
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
            <select name="AuditYear" onChange="changeCmtList()" class="select_reqsubmit" onChange="javascript:doListRefresh()"></select>
            <select name="CmtOrganID" class="select_reqsubmit" onChange="javascript:doListRefresh()"></select>
            <select name="ReqOrganIDZ" class="select_reqsubmit" onChange="javascript:doListRefresh()">
                <option value="">:::: 의원실별 조회 ::::</option>
                <%
                    if(StringUtil.isAssigned(strSelectedCmtOrganID)) {
                        String strSelected = "";
                        if(strSelectedCmtOrganID.equalsIgnoreCase(strReqOrganID)) strSelected = " selected";
                        else strSelected = "";
                %>
                        <option value="<%= strSelectedCmtOrganID %>" <%= strSelected %>>:::: 위원회 자체 생성 ::::</option>
                <%
                        if(objReqOrganRS.getTotalRecordCount() > 0) {
                            while(objReqOrganRS.next()) {
                                if(strReqOrganID.equalsIgnoreCase((String)objReqOrganRS.getObject("ORGAN_ID"))) {
                                    strSelected = " selected";
                                } else {
                                    strSelected = "";
                                }
                                out.println("<option value='"+(String)objReqOrganRS.getObject("ORGAN_ID")+"' "+strSelected+">"+(String)objReqOrganRS.getObject("ORGAN_NM")+"</option>");
                            }
                        }
                    } else {
                        out.println("<option value=''>:::: 위원회를 먼저 선택해 주세요 ::::</option>");
                    }
                %>
            </select>
            <select name="RltdDuty"  class="select_reqsubmit" onChange="javascript:doListRefresh()">
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
        <span class="list_total">&bull;&nbsp;전체자료수 : <%=intTotalRecordCount%>개 (<%=intCurrentPageNum%> / <%=intTotalPage%> page)</span>

        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
          <thead>
            <tr>
	          	<th scope="col" width="25" height="22" align="center"><input type="checkbox" name=""></th>
        	  	<th scope="col" width="320" height="22"><%=SortingUtil.getSortLink("changeSortQuery","REQ_BOX_NM",strCommReqBoxSortField,strCommReqBoxSortMtd,"요구함명")%></th>
              	<th scope="col" width="170" height="22"><%=SortingUtil.getSortLink("changeSortQuery","SUBMT_ORGAN_NM",strCommReqBoxSortField,strCommReqBoxSortMtd,"제출기관")%></th>
              	<th scope="col" width="70" height="22"><%=SortingUtil.getSortLink("changeSortQuery","RLTD_DUTY",strCommReqBoxSortField,strCommReqBoxSortMtd,"업무구분")%></th>
              	<th scope="col" width="40" height="22"><a>개수</a></th>
              	<th scope="col" width="70" height="22"><%=SortingUtil.getSortLink("changeSortQuery","ACPT_END_DT",strCommReqBoxSortField,strCommReqBoxSortMtd,"마감일시")%></th>
              	<th scope="col" width="70" height="22"><%=SortingUtil.getSortLink("changeSortQuery","REG_DT",strCommReqBoxSortField,strCommReqBoxSortMtd,"등록일시")%></th>
	        </tr>
          </thead>
          <tbody>
			<%
			String strRecordNumber = request.getParameter("RecordNumber");
			int intRecordNumber=0;
			if(intCurrentPageNum == 1){
				intRecordNumber= intTotalRecordCount;
			} else {
				intRecordNumber= java.lang.Integer.parseInt(strRecordNumber);
			}
			if(objRs.getRecordSize()>0){
				String strReqBoxID="";
			  	while(objRs.next()){
			  		strReqBoxID=(String)objRs.getObject("REQ_BOX_ID");
					if(!objUserInfo.getOrganGBNCode().equals("004")){
						objRsInfo = new ResultSetSingleHelper(objReqBox.getReqCount(strReqBoxID,objUserInfo.getOrganID()));
					}
			 %>
            <tr>
              	<td width="25" height="20" align="center"><input type="checkbox" name="ReqBoxID" value="<%=strReqBoxID%>"></td>
    	      	<td width="320" class="td_lmagin"><a href="javascript:gotoDetail('<%=strReqBoxID%>')"><%=(String)objRs.getObject("REQ_BOX_NM")%></a></td>
        	  	<td width="170" class="td_lmagin"><%=(String)objRs.getObject("SUBMT_ORGAN_NM")%></td>
 				<td width="70" class="td_lmagin"><%=objCdinfo.getRelatedDuty((String)objRs.getObject("RLTD_DUTY"))%></td>
          		<td width="40" class="td_lmagin">
          		<% if(!objUserInfo.getOrganGBNCode().equals("004")){%>
				<%=objRsInfo.getObject("ORGAN_REQ_CONT")%> / <%}%> <%=objRs.getObject("REQ_CNT")%></td>
          		<td width="70" class="td_lmagin" align="right" style="padding-top:2px;padding-bottom:2px"><%=StringUtil.getDate((String)objRs.getObject("ACPT_END_DT"))%> 24:00</td>
              	<td width="70" class="td_lmagin" align="right" style="padding-top:2px;padding-bottom:2px"><%=StringUtil.getDate2((String)objRs.getObject("REG_DT"))%></td>
            </tr>
			<%
				    intRecordNumber--;
				}//endofwhile
			%>
			<input type="hidden" name="RecordNumber" value="<%=intRecordNumber%>">
			<%
			}else{
			%>
			<tr>
				<td colspan="7" height="40" align="center">등록된 요구함이 없습니다.</td>
			</tr>
			<%
			} // end if
			%>
            </tbody>
       		</table>

			<!-----------------------------------------  페이징 네비게이션 ---------------------------------------->
            <%=objPaging.pagingTrans(PageCount.getLinkedString(
                    new Integer(intTotalRecordCount).toString(),
                    new Integer(intCurrentPageNum).toString(),
                    objParams.getParamValue("CommReqBoxPageSize")))
			%>
    <%
        if(objUserInfo.getOrganGBNCode().equals("004")) {
    %>
    <p class="warning">* 마감일자는 요구 일정 마감일자를 의미하며, 사용자에 의해서 '요구마감' 작업이 수행되어져야 해당 일정의 요구마감이 반영됩니다.</p>
    <p class="warning">* 위원회 자체에서 요구함을 생성할 경우에는 '접수완료 요구함'의 요구함 작성을 통해서 진행해 주시기 바랍니다.</p>
    <%
        }
    %>
        <!-- 리스트 버튼-->
        <div id="btn_all" >        <!-- 리스트 내 검색 -->
        <div class="list_ser" >
		<%
			String strCommReqBoxQryField=objParams.getParamValue("CommReqBoxQryField");
		%>
          <select name="CommReqBoxQryField" class="selectBox5"  style="width:70px;" >
            <option <%=(strCommReqBoxQryField.equalsIgnoreCase("req_box_nm"))? " selected ": ""%>value="req_box_nm">요구함명</option>
			<option <%=(strCommReqBoxQryField.equalsIgnoreCase("req_box_dsc"))? " selected ": ""%>value="req_box_dsc">요구함설명</option>
			<option <%=(strCommReqBoxQryField.equalsIgnoreCase("submt_organ_nm"))? " selected ": ""%>value="submt_organ_nm">제출기관</option>
          </select>
          <input name="CommReqBoxQryTerm" onKeyDown="return ch()" onMouseDown="return ch()"
		 class="li_input"  style="width:100px" value="<%=objParams.getParamValue("CommReqBoxQryTerm")%>"/>
          <img src="/images2/btn/bt_list_search.gif"  onMouseOver="menuOn(this);" onMouseOut="menuOut(this);" onClick="listqry.submit()"/> </div>
        <!-- /리스트 내 검색 -->
	<%
        // 2005-08-08 kogaeng EDIT 접수중요구함에서는 굳이 '요구함 작성' 버튼이 필요없다.
        //권한 없음
        if(!strReqSubmitFlag.equals("004")){
            /** 위원회 행정직원 일때만 화면에 출력함.*/
            if(objUserInfo.getOrganGBNCode().equals("004") && !strRsCmt.equals("")){
    %>
		<span class="right"><span class="list_bt"><a href="javascript:doDelete()">요구함 삭제</a></span></span>
	<%
		} }
	 %>

		</div>

        <!-- /리스트 버튼-->

        <!-- /각페이지 내용 -->
      </div>
        <!------------------------- 또 TAB을 두고 싶으시면 위의 소스들을 복사해서 이 곳에 붙여넣기 해서 수정하세요 ------------------------->
        <!----- [주의] TAB <tr> 과 그 밑에 내용을 구성하는 <tr>을 잘 구분해서 잘 챙겨 주시어요. 나으리.. -------->
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