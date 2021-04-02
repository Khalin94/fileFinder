<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.bf.config.*"%>
<%@ page import="kr.co.kcc.pf.util.PageCount"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.params.requestinfo.RPreReqInfoListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.prereqbox.PreRequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.prereqinfo.PreRequestInfoDelegate" %>

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
<%@ include file="../../../../common/RUserCodeInfoInc.jsp" %>

<%
 /*************************************************************************************************/
 /** 					파라미터 체크 Part 														  */
 /*************************************************************************************************/
  /**선택된 감사년도와 선택된 위원회ID*/
  String strSelectedAuditYear= null; /**선택된 감사년도*/
  String strSelectedCmtOrganID=null; /**선택된 위원회ID*/
  String strRltdDuty=null; 			 /**선택된 업무구분 */
  /**일반 요구함 상세보기 파라미터 설정.*/
  RPreReqInfoListForm objParams =new RPreReqInfoListForm();
  objParams.setParamValue("ReqStt",CodeConstants.REQ_STT_NOT);/**미제출 요구정보목록.*/
   /** 위원회 행정직원 일때만 화면에 출력함.*/

  if(objUserInfo.getOrganGBNCode().equals("003")){
  objParams.setParamValue("CmtOrganID",strSelectedCmtOrganID);
  }else{
  objParams.setParamValue("CmtOrganID",objUserInfo.getOrganID());
  }
   //해당위원회가 존재하지 않을 경우
  if(objUserInfo.getCurrentCMTList().isEmpty()){
  	objParams.setParamValue("CmtOrganID","XXXXXXXXXX");
  }
  //objParams.setParamValue("ReqOrganID",objUserInfo.getOrganID());/**요구기관ID*/
  //objParams.setParamValue("CmtOrganID",objUserInfo.getOrganID());
  objParams.setParamValue("ReqInfoSortField","last_req_dt");/**최종요구일이 Default*/
  objParams.setParamValue("IsRequester",String.valueOf(objUserInfo.isRequester()));//요구답변자여부설정

  boolean blnParamCheck=false;
  /**전달된 파리미터 체크 */
  blnParamCheck=objParams.validateParams(request);
  if(blnParamCheck==false){
  	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	objMsgBean.setStrCode("DSPARAM-0000");
  	objMsgBean.setStrMsg(objParams.getStrErrors());
  	//out.println("ParamError:" + objParams.getStrErrors());
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%
  	return;
  }//endif

  strSelectedAuditYear= objParams.getParamValue("AuditYear"); /**선택된 감사년도*/
  strSelectedCmtOrganID=objParams.getParamValue("CmtOrganID") ; /**선택된 위원회ID*/
  strRltdDuty=objParams.getParamValue("RltdDuty") ; 			 /**선택된 업무구분 */
%>

<%
 /*************************************************************************************************/
 /** 					데이터 호출 Part 														  */
 /*************************************************************************************************/

 /*** Delegate 과 데이터 Container객체 선언 */
 PreRequestBoxDelegate objReqBox=null; 		/**요구함 Delegate*/
 PreRequestInfoDelegate  objReqInfo=null;	/** 요구정보 Delegate */

 ResultSetHelper objRs=null;				/**요구 목록 */
 ResultSetHelper objCmtRs=null;			/** 연도별 위원회 */
 ResultSetHelper objRltdDutyRs=null;   /** 업무구분 리스트 출력용 RsHelper */
 try{
   /**요구함 정보 대리자 New */
   objReqBox=new PreRequestBoxDelegate();


	//해당위원회가 존재하지 않은 경우
	if(objUserInfo.getCurrentCMTList().isEmpty()){
		List lst = objUserInfo.getCurrentCMTList();
		Hashtable objHash = new Hashtable();
		objHash.put("ORGAN_ID", "XXXXXXXXXX");
		objHash.put("ORGAN_NM", "XXXXXXXXXX");
		lst.add(objHash);

		objCmtRs=new ResultSetHelper(objReqBox.getReqrPerYearCMTList(lst,null));
	} else {
	 	objCmtRs=new ResultSetHelper(objReqBox.getReqrPerYearCMTList(objUserInfo.getCurrentCMTList(),null));
 	} //endif

   //objCmtRs=new ResultSetHelper(objReqBox.getReqrPerYearCMTList(objUserInfo.getOrganID(),null));
   //objCmtRs=new ResultSetHelper(objReqBox.getReqrPerYearCMTList(objUserInfo.getCurrentCMTList(),null));
    /** 파라미터로 받은 정보가 없을 경우 리스트에서 가져옴.*/
    if(objCmtRs.next() && !StringUtil.isAssigned(strSelectedAuditYear) ){
    //if(objCmtRs.next() && !StringUtil.isAssigned(strSelectedAuditYear) && !StringUtil.isAssigned(strSelectedCmtOrganID)){
        strSelectedAuditYear=(String)objCmtRs.getObject("AUDIT_YEAR");
 		strSelectedCmtOrganID=(String)objCmtRs.getObject("CMT_ORGAN_ID");
	    objParams.setParamValueIfNull("AuditYear",strSelectedAuditYear);
	    objParams.setParamValueIfNull("CmtOrganID",strSelectedCmtOrganID);
    }

   /**요구 정보 대리자 New */
   objReqInfo=new PreRequestInfoDelegate();
   objRs=new ResultSetHelper(objReqInfo.getRecordList(objParams));
   objRltdDutyRs=new ResultSetHelper(objCdinfo.getRelatedDutyList());
 }catch(AppException objAppEx){
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

<%
 /*************************************************************************************************/
 /** 					데이터 값 할당  Part 														  */
 /*************************************************************************************************/

 /**요구정보 목록조회된 결과 반환.*/
 int intTotalRecordCount=objRs.getTotalRecordCount();
 int intCurrentPageNum=objRs.getPageNumber();
 int intTotalPage=objRs.getTotalPageCount();


%>
<jsp:include page="/inc/header.jsp" flush="true"/>
<link href="/css2/style.css" rel="stylesheet" type="text/css">
<script language="javascript">
<!--
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
  function init(){
	var field=formName.AuditYear;
	for(var i=0;i<arrYear.length;i++){
	   var tmpOpt=new Option();
	   tmpOpt.text=arrYear[i];
	   tmpOpt.value=tmpOpt.text;
	   if(varSelectedYear==tmpOpt.text){
	     tmpOpt.selected=true;
	   }
	   field.add(tmpOpt);
	}
	makePerYearCmtList(field.options[field.selectedIndex].value);
  }//end of func
  /** 연도별 위원회 리스트 초기화 */
  function makePerYearCmtList(strYear){
       	var field=formName.CmtOrganID;
       	field.length=0;
	for(var i=0;i<arrPerYearCmt.length;i++){
	   var strTmpYear=arrPerYearCmt[i][0];
	   if(strYear==strTmpYear){
		   var tmpOpt=new Option();
		   tmpOpt.value=arrPerYearCmt[i][1];
		   tmpOpt.text=arrPerYearCmt[i][2];
		   if(varSelectedCmt==tmpOpt.value){
		     tmpOpt.selected=true;
		   }
		   field.add(tmpOpt);
	   }
	}
  }//end of func
  /** 연도 변화에 따른 위원회 리스트 변화 */
  function changeCmtList(){
    makePerYearCmtList(formName.AuditYear.options[formName.AuditYear.selectedIndex].value);
  }//end of func
  /** 정렬방법 바꾸기 */
  function changeSortQuery(sortField,sortMethod){
  	formName.ReqInfoSortField.value=sortField;
  	formName.ReqInfoSortMtd.value=sortMethod;
  	formName.submit();
  }
  //요구상세보기로 가기.
  function gotoDetail(strID){
  	formName.ReqInfoID.value=strID;
  	formName.action="./RNonPreReqInfoVList.jsp";
  	formName.submit();
  }
  //요구함상세보기로 가기.
  function gotoDetail_Box(strID){
  	formName.ReqBoxID.value=strID;

  	formName.action="/reqsubmit/20_comm/40_BasicBox/20_databoxsh/RBasicReqBoxVList.jsp?ReqBoxID=<%=objParams.getParamValue("ReqBoxID")%>&CmtOrganID=<%=objParams.getParamValue("CmtOrganID")%>";
  	formName.submit();
  }
   /** 페지징 바로가기 */
  function goPage(strPage){
  	formName.ReqInfoPage.value=strPage;
  	formName.submit();
  }
  /**년도와 위원회로만 조회하기 */
  function gotoHeadQuery(){
  	formName.ReqInfoQryField.value="";
  	formName.ReqInfoQryTerm.value="";
  	formName.ReqInfoSortField.value="";
  	formName.ReqInfoSortMtd.value="";
  	formName.ReqInfoPage.value="";
  	formName.submit();
  }

 //-->
</script>
<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>
</head>

<body onload="init()">
<div id="wrap">
  <jsp:include page="/inc/top.jsp" flush="true"/>
  <jsp:include page="/inc/top_menu02.jsp" flush="true"/>
  <div id="container">
    <div id="leftCon">
      <jsp:include page="/inc/log_info.jsp" flush="true"/>
      <jsp:include page="/inc/left_menu02.jsp" flush="true"/>
    </div>
    <div id="rightCon">
 <form name="formName" method="post" action="<%=request.getRequestURI()%>">
          <%
			//요구 정보 정렬 정보 받기.
			String strReqInfoSortField=objParams.getParamValue("ReqInfoSortField");
			String strReqInfoSortMtd=objParams.getParamValue("ReqInfoSortMtd");
			//요구 정보 페이지 번호 받기.
			String strReqInfoPagNum=objParams.getParamValue("ReqInfoPage");
		  %>
			  <input type="hidden" name="ReqInfoSortField" value="<%=strReqInfoSortField%>"><!--요구정보 목록정렬필드 -->
			  <input type="hidden" name="ReqInfoSortMtd" value="<%=strReqInfoSortMtd%>"><!--요구정보 목록정령방법-->
			  <input type="hidden" name="ReqInfoPage" value="<%=strReqInfoPagNum%>"><!--요구정보 페이지 번호 -->
			   <input type="hidden" name="ReqBoxID" value=""><!--요구함정보 ID-->
			  <input type="hidden" name="ReqInfoID" value=""><!--요구정보 ID-->
			  <input type="hidden" name="ReturnUrl" value="<%=request.getRequestURI()%>"><!--되돌아올 URL -->
      <!-- pgTit -->

      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=MenuConstants.REQ_INFO_LIST_SUBMT_NONE%></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.REQUEST_BOX_COMM%> > <%=MenuConstants.REQUEST_BOX_PRE%> > <%=MenuConstants.REQ_INFO_LIST%> > <B><%=MenuConstants.REQ_INFO_LIST_SUBMT_NONE%></div>
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
           <select name="AuditYear" onChange="changeCmtList()"></select>
			<select name="CmtOrganID" ></select>
			<select name="RltdDuty">
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


        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
          <thead>
            <tr>
              <th scope="col" style="width:15px;"></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","",strReqInfoSortField,strReqInfoSortMtd,"NO")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","REQ_CONT",strReqInfoSortField,strReqInfoSortMtd,"요구제목")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","REQ_BOX_NM",strReqInfoSortField,strReqInfoSortMtd,"요구함명")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","SUBMT_DLN",strReqInfoSortField,strReqInfoSortMtd,"제출기한")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","REG_DT",strReqInfoSortField,strReqInfoSortMtd,"최종요구일자")%></th>
            </tr>
          </thead>
          <tbody>
			<%

			  int intRecordNumber=intTotalRecordCount - ((intCurrentPageNum -1) * Integer.parseInt((String)objParams.getParamValue("ReqInfoPageSize")));

			  String strReqInfoID="";
			  String strReqBoxID="";
			  String strCmtApplyValue="Y";
			  if(objRs.getRecordSize()>0){
			  while(objRs.next()){
				 strReqInfoID=(String)objRs.getObject("REQ_ID");
				 strReqBoxID=(String)objRs.getObject("REQ_BOX_ID");


				 /** 위원회신청가능한지(Y) 아닌지 "" 결정*/
				if(CodeConstants.isDuplatedApplyToCmtReq((String)objRs.getObject("CMT_REQ_APP_FLAG"))){
					strCmtApplyValue="";
				}else{
					strCmtApplyValue="Y";
				}
			 %>
            <tr>
              <td ></td>
			  <td><%= intRecordNumber %></td>
              <td><%=StringUtil.getNotifyImg((String)objRs.getObject("REG_DT"),(String)objRs.getObject("REQ_STT"))%><a href="JavaScript:gotoDetail('<%=strReqInfoID%>');"><%=StringUtil.substring((String)objRs.getObject("REQ_CONT"),35)%></a></td>
              <td><a href="javascript:gotoDetail_Box('<%=strReqBoxID%>')"><%=StringUtil.getReqBoxNmList((String)objRs.getObject("REQ_BOX_NM")==null?"":(String)objRs.getObject("REQ_BOX_NM"))%></a></td>
              <td><%=StringUtil.getDate((String)objRs.getObject("SUBMT_DLN"))%></td>
              <td><%=StringUtil.getDate((String)objRs.getObject("REG_DT"))%></td>
			  <input type="hidden" name="CmtApplys" value="<%=strCmtApplyValue%>">
            </tr>
			<%
				   intRecordNumber --;
				}//endwhile
			}else{
			%>
			<tr>
				<td colspan="6" align="center">등록된 요구정보가 없습니다.</td>
            </tr>
			<%
			}//end if 목록 출력 끝.
			%>
          </tbody>
        </table>

        <!-- /list -->
		<%=objPaging.pagingTrans(PageCount.getLinkedString(
							new Integer(intTotalRecordCount).toString(),
							new Integer(intCurrentPageNum).toString(),
							objParams.getParamValue("ReqInfoPageSize")))%>
        <!-- 페이징-->
         <!-- /페이징-->
        <!--  <p class="warning">* 요구서를 발송하게 되면 해당 제출 기관 대표 담당자에게 지정 발송되며, 담당자가 없는 경우는 작성 중 요구함에 그대로 남아있게 됩니다.  </p>
          <p class="warning">* 요구서 발송 버튼을 이용하시기 위해서는 위원회를 선택해 주시기 바랍니다.  </p>  -->



        <!-- 리스트 버튼-->
        <div id="btn_all" >        <!-- 리스트 내 검색 -->
        <div class="list_ser" >
		<%
			String strReqInfoQryField=(String)objParams.getParamValue("ReqInfoQryField");
		%>
          <select name="ReqInfoQryField" class="selectBox5"  style="width:70px;" >
           <option <%=(strReqInfoQryField.equalsIgnoreCase("req_cont"))? " selected ": ""%>value="req_cont">요구제목</option>
			<option <%=(strReqInfoQryField.equalsIgnoreCase("req_dtl_cont"))? " selected ": ""%>value="req_dtl_cont">요구내용</option>
			<option <%=(strReqInfoQryField.equalsIgnoreCase("req_box_nm"))? " selected ": ""%>value="req_box_nm">요구함명</option>
			<option <%=(strReqInfoQryField.equalsIgnoreCase("submt_organ_nm"))? " selected ": ""%>value="submt_organ_nm">제출기관</option>
          </select>
          <input name="ReqInfoQryTerm" onKeyDown="return ch()" onMouseDown="return ch()"
		 class="li_input"  style="width:100px" value="<%=objParams.getParamValue("ReqInfoQryTerm")%>"/>
          <img src="/images2/btn/bt_list_search.gif"  onMouseOver="menuOn(this);" onMouseOut="menuOut(this);" onClick="formName.submit();"/> </div>
        <!-- /리스트 내 검색 -->
<!--
		<span class="right"> <span class="list_bt"><a href="addBinder(document.formName);">바인더담기</a></span> </span>
-->
		</div>

        <!-- /리스트 버튼-->

        <!-- /각페이지 내용 -->
      </div>
      <!-- /contents -->

    </div>
  </div>
<jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>