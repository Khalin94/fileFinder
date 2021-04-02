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
	PagingDelegate objPaging=new PagingDelegate(); 		/*페이징 변환 Delegate*/
%>
<%

  //로그인 사용자 정보를 가져온다. 권한없음 경우 관람만 가능하다.
  String strReqSubmitFlag = objUserInfo.getReqSubmitFlag();


	SPreReqBoxDelegate selfDelegate = null;
	PreRequestBoxDelegate reqDelegate = null;
	SPreReqInfoDelegate reqInfoDelegate = null;

	SPreReqBoxVListForm objParams = new SPreReqBoxVListForm();
	//SReqInfoListForm objParams = new SReqInfoListForm();
	// 요구자 제출자 여부를 Form에 추가한다
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

	// 넘어온 파라미터를 설정해서 필요할 떄 쓰도록 하자
	// 요구함 관련
	String strReqBoxID = objParams.getParamValue("ReqBoxID");
	String strReqBoxSortField = objParams.getParamValue("ReqBoxSortField");
	String strReqBoxSortMtd = objParams.getParamValue("ReqBoxSortMtd");
	String strReqBoxPagNum = objParams.getParamValue("ReqBoxPage");
	String strReqBoxQryField = objParams.getParamValue("ReqBoxQryField");
	String strReqBoxQryTerm = objParams.getParamValue("ReqBoxQryTerm");

	// 요구 목록 관련
	String strReqInfoSortField = objParams.getParamValue("ReqInfoSortField");
	String strReqInfoSortMtd = objParams.getParamValue("ReqInfoSortMtd");
	String strReqInfoQryField = objParams.getParamValue("ReqInfoQryField");
	String strReqInfoQryTerm = objParams.getParamValue("ReqInfoQryTerm");
	String strReqInfoPagNum = objParams.getParamValue("ReqInfoPage");



	// 요구 개수 및 페이징 관련
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
  	  		objMsgBean.setStrMsg("해당 요구함을 볼 권한이 없습니다.");
  	  		out.println("해당 요구함을 볼 권한이 없습니다.");
		    return;
		} else {
	    	// 요구함 등록 정보를 SELECT 한다.
	    	objRsSH = new ResultSetSingleHelper(selfDelegate.getRecord(strReqBoxID));

	    	// 요구 목록을 SELECT 한다.
	    	objRs = new ResultSetHelper(reqInfoDelegate.getRecordList(objParams));

	    	 /**요구정보 목록조회된 결과 반환.*/
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
	// 요구 목록 조회
	function goReqBoxList() {
		f = document.viewForm;
		f.action = "SBasicReqBoxList.jsp";
		f.submit();
	}

	// 정렬방법 바꾸기
	function changeSortQuery(sortField, sortMethod){
		f = document.viewForm;
  		f.ReqInfoSortField.value = sortField;
  		f.ReqInfoSortMtd.value = sortMethod;
  		f.submit();
  	}

  	// 요구 상세보기로 가기 */
  	function gotoDetail(strID){
  		f = document.viewForm;
  		f.ReqID.value = strID;
  		f.action="SBasicReqInfoVList.jsp";
  		f.submit();
  	}

  	// 페이징 바로가기
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
		<td bgcolor="#EBF2F5" width="30" height="20" align="center" style="border-left:1px solid #808080;border-top:1px solid #808080;border-bottom:2px solid #808080;"><font style="font-size:11px;font-family:verdana,돋움;font-weight:bold">요구<BR>상세<BR>내용</font></td>
		<td style="border-left:1px solid #808080;border-top:1px solid #808080;border-bottom:2px solid #808080;border-right:2px solid #808080;text-align:justify;word-break:break-all;" width="220">
			<font style="font-size:11px;font-family:verdana,돋움">{{hint}}</font>
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
        <h3>기초 자료 요구함<span class="sub_stl" >- 요구함 상세 보기</span></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.REQUEST_BOX_COMM%>
                         > <%=MenuConstants.REQUEST_BOX_PRE%> > <%=MenuConstants.REQ_BOX_PRE%></div>
        <p><!--문구--></p>
      </div>
      <!-- /pgTit -->

      <!-- contents -->

      <div id="contents">

        <!-- 검색조건 없는 경우 아래 div 삭제 나 주석으로 막으세요.-->
        <!-- /검색조건-->


        <!-- 각페이지 내용 -->
         <!-- list view-->

        <span class="list02_tl">요구함 등록 정보 </span>

<form name="viewForm" method="post" action="" style="margin:0px">
					<!-- 요구함 등록 정보 관련 -->
					<input type="hidden" name="ReqBoxID" value="<%= strReqBoxID %>">
					<input type="hidden" name="ReqBoxSortField" value="<%= strReqBoxSortField %>"><!--요구함목록정렬필드 -->
					<input type="hidden" name="ReqBoxSortMtd" value="<%= strReqBoxSortMtd %>"><!--요구함목록정렬방법-->
					<input type="hidden" name="ReqBoxPage" value="<%= strReqBoxPagNum %>"><!--요구함 페이지 번호 -->
					<% if(StringUtil.isAssigned(strReqBoxQryTerm)) { %>
					<input type="hidden" name="ReqBoxQryField" value="<%= strReqBoxQryField %>"><!--요구함 조회필드 -->
					<input type="hidden" name="ReqBoxQryTerm" value="<%= strReqBoxQryTerm %>"><!--요구함 조회필드 -->
					<% } //요구함 조회어가 있는 경우만 출력해서 사용함 %>

					<!-- 요구 목록 관련 -->
					<input type="hidden" name="ReqID" value=""> <!-- 요구 ID -->
					<input type="hidden" name="ReqInfoSortField" value="<%= strReqInfoSortField %>"><!--요구정보 목록정렬필드 -->
					<input type="hidden" name="ReqInfoSortMtd" value="<%= strReqInfoSortMtd %>"><!--요구정보 목록정렬방법-->
					<input type="hidden" name="ReqInfoQryField" value="<%= strReqInfoQryField %>"><!--요구정보 조회필드 -->
					<input type="hidden" name="ReqInfoQryTerm" value="<%= strReqInfoQryTerm %>"><!-- 요구정보 조회어 -->
					<input type="hidden" name="ReqInfoPage" value="<%= strReqInfoPagNum %>"><!-- 요구정보 페이지 번호 -->
					<input type="hidden" name="ReturnUrl" value="<%=request.getRequestURI()%>"><!--되돌아올 URL -->


        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list02">

            <tr>

              <th width="100px;" scope="col">&bull;&nbsp;요구함명 </th>
				  <td colspan="3"><%= objRsSH.getObject("REQ_BOX_NM") %></td>
            </tr>
            <tr>
              <th scope="col">&bull;&nbsp;업무구분 </th>
			  <td><%= objCdinfo.getRelatedDuty((String)objRsSH.getObject("RLTD_DUTY")) %></td>
            </tr>
            <tr>
              <th scope="col">&bull;&nbsp;요구기관  </th>
			  <td><%= objRsSH.getObject("REQ_ORGAN_NM") %></td>
            </tr>
            <tr>
              <th scope="col">&bull;&nbsp;요구담당자  </th>
			  <td><%= objRsSH.getObject("USER_NM") %></td>
            </tr>
            <tr>
              <th scope="col">&bull;&nbsp;수신일자  </th>
			  <td><%= StringUtil.getDate(String.valueOf(objRsSH.getObject("REG_DT"))) %></td>
            </tr>
            <tr>
              <th scope="col">&bull;&nbsp;제출완료일자  </th>
			  <td><%= StringUtil.getDate(String.valueOf(objRsSH.getObject("SUBMT_DLN"))) %></td>
            </tr>
             <tr>
              <th scope="col">&bull;&nbsp;요구함설명 </th>   <td colspan="3"><%= StringUtil.getDescString((String)objRsSH.getObject("REQ_BOX_DSC")) %></td>
            </tr>
        </table>
        <!-- /list view -->
        <!-- 리스트 버튼-->
        <br/>
        <!-- /리스트 버튼-->
        <!-- list -->
        <span class="list01_tl">요구 목록 <span class="list_total">&bull;&nbsp;전체자료수 : <%= intTotalRecordCount %>개 (<%= intCurrentPageNum %>/<%= intTotalPage %> page)</span></span>
        <table width="100%" style="padding:0;">
            <tr>
                <td>&nbsp;</td>
            </tr>
        </table>
<!------------------------------------------------- 요구 목록 테이블 시작 ------------------------------------------------->

        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
          <thead>
            <tr>
			  <th scope="col"><a>NO</a></th>
              <th scope="col"><%= SortingUtil.getSortLink("changeSortQuery", "REQ_CONT", strReqInfoSortField, strReqInfoSortMtd, "요구제목") %></th>
              <th scope="col"><%= SortingUtil.getSortLink("changeSortQuery", "REQ_STT", strReqInfoSortField, strReqInfoSortMtd, "상태") %></th>
              <th scope="col"><%= SortingUtil.getSortLink("changeSortQuery", "OPEN_CL", strReqInfoSortField, strReqInfoSortMtd, "공개범위") %></th>
              <th scope="col"><a>답변</a></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery", "LAST_ANS_DT", strReqInfoSortField, strReqInfoSortMtd, "최종답변일")%></th>
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
				<td colspan="6" align="center">요청한 요구정보가 없습니다.</td>
			</tr>
	<%
		}//end if 목록 출력 끝.
	%>
          </tbody>
        </table>
        <!-- /list -->

        <!-- 페이징-->
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

       <!-- /페이징-->


       <!-- 리스트 버튼-->
        <div id="btn_all" >        <!-- 리스트 내 검색 -->
        <div class="list_ser" >
          <select name="ReqInfoQryField" class="selectBox5"  style="width:70px;" >
            <option <%=(strReqInfoQryField.equalsIgnoreCase("req_cont"))? " selected ": ""%> value="req_cont">요구제목</option>
			<option <%=(strReqInfoQryField.equalsIgnoreCase("req_dtl_cont"))? " selected ": ""%> value="req_dtl_cont">요구내용</option>
          </select>
          <input name="ReqInfoQryTerm" onKeyDown="return ch()" onMouseDown="return ch()" value="<%= strReqInfoQryTerm %>"
		 class="li_input"  style="width:100px"/>
          <img src="/images2/btn/bt_list_search.gif"  onMouseOver="menuOn(this);" onMouseOut="menuOut(this);" onClick="viewForm.submit()"/> </div>
        <!-- /리스트 내 검색 -->
<!--
			<span class="list_bt"><a href="#">요구삭제</a></span>
			<span class="list_bt"><a href="#">요구복사</a></span>
-->
			</span>
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