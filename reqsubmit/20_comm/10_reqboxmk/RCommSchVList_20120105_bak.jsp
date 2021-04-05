<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="kr.co.kcc.pf.util.PageCount" %>
<%@ page import="kr.co.kcc.bf.config.*" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RMemReqBoxListForm" %>
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
    /**요구함 목록조회용 파라미터 설정.*/
    RMemReqBoxListForm objParams=new RMemReqBoxListForm();

     //로그인한 사용자ID를 가져온다.
 	String strUserID   = objUserInfo.getUserID();
    String strReqSubmitFlag = objUserInfo.getReqSubmitFlag();
	//추후 세션으로 변경할 값.
	String strReqSchId   		   = StringUtil.getNVLNULL(request.getParameter("ReqSchId"));		//TBDS_REQUEST_SCHEDULE테이블 SEQ
	String strReqBoxQryTerm   = StringUtil.getNVLNULL(request.getParameter("ReqBoxQryTerm"));		//TBDS_REQUEST_SCHEDULE테이블 SEQ
    String strKind       = objUserInfo.getOrganGBNCode();

	//※Delegate 선언※.
    nads.dsdm.app.reqsubmit.delegate.commreqsch.CommMakeBoxDelegate objCommReq = new  nads.dsdm.app.reqsubmit.delegate.commreqsch.CommMakeBoxDelegate();

	Hashtable objHashDetail = new Hashtable();
	objHashDetail = objCommReq.selectSchDetail(strReqSchId);

	String strReqScheId = (String)objHashDetail.get("REQ_SCHE_ID");    	//SEQ
	String strOrganNm 	= (String)objHashDetail.get("ORGAN_NM");      	//위원회명
	String strReqNm 		= (String)objHashDetail.get("REQNM");   				//요구명
	String strAcptBgnDt 	= (String)objHashDetail.get("ACPT_BGN_DT");    	//접수시작일
	String strAcptEndDt 	= (String)objHashDetail.get("ACPT_END_DT");    	//접수마감일
	String strIngStt 		= (String)objHashDetail.get("ING_STT");    		  	//진행상태코드
	String strRegDt		= (String)objHashDetail.get("REG_DT");    		  	//등록일자
	String strSubmtDln 	= (String)objHashDetail.get("SUBMT_DLN");    		//제출마감일
	String strAuditYear 	= (String)objHashDetail.get("AUDIT_YEAR");    		//요구년도
    String strOrderInfo 	= (String)objHashDetail.get("ORDER_INFO");     	//차수
    String strCdNm 		= (String)objHashDetail.get("CD_NM");     			//진행상태명
    String strCmtOrganId= (String)objHashDetail.get("CMT_ORGAN_ID");    //위원회 id
    String strNatCnt        = (String)objHashDetail.get("NAT_CNT");    //회기

    //년도 Format 변화
	strAcptBgnDt 	= strAcptBgnDt.substring(0,4) +"-"+ strAcptBgnDt.substring(4,6) +"-"+ strAcptBgnDt.substring(6,8) ;    	//접수시작일
	strAcptEndDt 	= strAcptEndDt.substring(0,4) +"-"+ strAcptEndDt.substring(4,6) +"-"+ strAcptEndDt.substring(6,8) ;    	//접수마감일
	strSubmtDln 	= strSubmtDln.substring(0,4) +"-"+ strSubmtDln.substring(4,6) +"-"+ strSubmtDln.substring(6,8) ;    		//제출마감일

	//Page Count
	String strCurrentPage = StringUtil.getNVL(request.getParameter("strCurrentPage"), "1");	//현재 페이지
	String strCountPerPage;																										//한페이지 ROW갯수

	//#### Page ####
	// 시스템 전체적으로 페이지당 row의 갯수는 property로 정하여 사용한다.
	// 만일 특정페이지에서만 row의 갯수를 변경하고 싶으면 아래 catch문을 활용한다.
	try {
		Config objConfig = PropertyConfig.getInstance();
		strCountPerPage = objConfig.get("page.rowcount");
	}
	catch (ConfigException objConfigEx) {
		strCountPerPage = StringUtil.getNVL(request.getParameter("strCountPerPage"), "10");
	}

//    strCountPerPage = "10";

	ArrayList objCommList = new ArrayList();

	try{
	//위원회 요구함목록 조회페이징적용 메소드 호출
		if ( strReqBoxQryTerm == null || strReqBoxQryTerm.equals("")) {
			objCommList = objCommReq.selectCommDataListPerPage(strCmtOrganId, strReqScheId, strCurrentPage, strCountPerPage);
		}else{
			objCommList = objCommReq.selectCommDataListPerPageQry(strCmtOrganId, strReqScheId, strCurrentPage, strCountPerPage, strReqBoxQryTerm);
		}
	} catch (AppException objAppEx) {
		// 에러 발생 메세지 페이지로 이동한다.
		out.println(objAppEx.getStrErrCode() + "<br>");
		out.println("메세지 페이지로 이동하여야 한다.<br>");
		return;
	}

	String strTotalCount = (String)((Hashtable)objCommList.get(0)).get("TOTAL_COUNT");


	//요구함속에 요구가 있는지 확인
    Hashtable objHashCnt = new Hashtable();
	objHashCnt = objCommReq.selectSchReqIdCnt(strReqScheId);
	//요구목록 갯수
	String strReqCnt = (String)objHashCnt.get("CNT");


	//현재 차수보다 상위 요구일정 차수가 있는지 확인한다.
  	Hashtable objHashNatCnt = new Hashtable();
	objHashNatCnt = objCommReq.selectSchNatCnt(strAuditYear, strCmtOrganId, strOrderInfo);
	int intNatCnt = objHashNatCnt.size();

	//out.print("intNatCnt : " + intNatCnt + "<br>");
%>

<jsp:include page="/inc/header.jsp" flush="true"/>
<link href="/css2/style.css" rel="stylesheet" type="text/css">
<script language="javascript">
	function fUsrAction(mode, strReqScheId, strOrganNm, strOrderInfo, strAcptBgnDt, strAcptEndDt, strSubmtDln, strAuditYear, strCmtOrganId, strNatCnt, strReqSchId) {
	  switch(mode) {
	    //요구일정 생성
	    case "insert" :
			location.href="RCommSchWrite.jsp?strYear="+strYear+"&strOrganId="+strOrganId+"&strOrganNm="+strOrganNm;
	        break;

	    //요구일정 수정
	    case "update" :
			location.href="RCommSchUpdate.jsp?strReqScheId="+strReqScheId+"&strOrganNm="+strOrganNm+"&strOrderInfo="+strOrderInfo+"&strAcptBgnDt="+strAcptBgnDt+"&strAcptEndDt="+strAcptEndDt+"&strSubmtDln="+strSubmtDln+"&strAuditYear="+strAuditYear+"&strCmtOrganId="+strCmtOrganId+"&strNatCnt="+strNatCnt+"&strReqSchId="+strReqSchId ;
	        break;
	  }
	}

	function fUsrAction2(mode, strReqScheId) {
	  switch(mode) {

	    //요구일정 삭제
	    case "delet" :
            if (!fCheckField()) return false;
		    if (!confirm("선택한 요구일정을 삭제하시겠습니까?")) {
	            return false;
	        };
			location.href="RCommSchDProc.jsp?cmd=delet&ReqScheId=" + strReqScheId;
	        break;

	    //요구마감
	    case "reqend" :
            if (!fCheckField2()) return false;
		    if (!confirm("요구 접수를 마감을 하시겠습니까?  요구일정의 요구함도 접수완료됩니다.")) {
	            return false;
	        };
			location.href="RCommSchDProc.jsp?cmd=updat&ReqScheId=" + strReqScheId;
	        break;

	    //요구마감
	    case "reqendback" :
		    if (!confirm("요구 접수를 마감을 취소 하시겠습니까? ")) {
	            return false;
	        };
			location.href="RCommSchDProc.jsp?cmd=updateback&ReqScheId=" + strReqScheId;
	        break;

	  }
	}

	function fCheckField() {
	  with (form1) {
	    if (ReqCnt.value != '0') {
	      alert('요구함  또는 요구목록이 존재합니다.  먼저 요구함에 등록되어있는 요구목록과 요구함을 삭제 하세요!');
	      return false;
	    }
	  }
	  return true;
	}

	function fCheckField2() {
	  with (form1) {
	    if (ReqBoxCnt.value == 0) {
	      alert('마감할 요구함 또는 요구목록이 존재하지 않습니다. 먼저 요구함과 요구 목록을 등록하세요!');
	      return false;
	    }
	  }
	  return true;
	}

	function fUsrActionBack(mode, strYear) {
	  switch(mode) {
	    //요구일정
	    case "back" :
			location.href="RNewBoxMake.jsp?year_cd=" + strYear;
	        break;
	  }
	}

	function fUsrActionMake(mode, strReqScheId) {
	  switch(mode) {
	    //요구함 생성
	    case "make" :
			location.href="../20_reqboxsh/RCommNewBoxMake.jsp?ReqScheID=" + strReqScheId;
	        break;
	  }
	}

	function fUsrActionList(mode, strReqBoxID) {
	  switch(mode) {
	    //요구목록리스트

	    //   001	접수중
	    case "001" :
			location.href="../20_reqboxsh/RCommReqBoxVList.jsp?ReqBoxID=" + strReqBoxID;
	        break;

	    //   002	접수완료
	    case "002" :
			location.href="../20_reqboxsh/20_accend/RAccBoxVList.jsp?ReqBoxID=" + strReqBoxID;
	        break;

	    //   004	결재대기중
	    case "004" :
			location.href="../20_reqboxsh/20_accend/RAccBoxVList.jsp?ReqBoxID=" + strReqBoxID;
	        break;

	    //   005	반려
	    case "005" :
			location.href="../20_reqboxsh/20_accend/RAccBoxVList.jsp?ReqBoxID=" + strReqBoxID;
	        break;


	    //   006	발송완료/작성중
	    case "006" :
			location.href="../20_reqboxsh/30_sendend/RSendBoxVList.jsp?ReqBoxID=" + strReqBoxID;
	        break;

	    //   007	제출완료/작성완료
	    case "007" :
			location.href="../20_reqboxsh/40_subend/RSubEndBoxVList.jsp?ReqBoxID=" + strReqBoxID;
	        break;

	    //   009	상신대기
	    case "009" :
			location.href="../20_reqboxsh/20_accend/RAccBoxVList.jsp?ReqBoxID=" + strReqBoxID;
	        break;
	  }
	}

	function fUsrActionSort(mode, strReqSchId, strOrderInfo) {
	  switch(mode) {
	    //정렬
	    case "sort" :
			location.href="../20_reqboxsh/RCommReqBoxVList.jsp?ReqBoxID=" + strReqBoxID;
		  	form1.submit();
	        break;
	  }
	}

	/** 정렬방법 바꾸기 */
	function changeSortQuery(sortField,sortMethod){
  		form1.CommReqBoxSortField.value=sortField;
	  	form1.CommReqBoxSortMtd.value=sortMethod;
	  	form1.submit();
	}

	function goPage(varPageNo) {
		document.form1.strCurrentPage.value = varPageNo;
		document.form1.submit();
	}

</script>
</head>

<body>
<div id="wrap">
<SCRIPT language="JavaScript" src="/js/reqinfo.js"></SCRIPT>
  <jsp:include page="/inc/top.jsp" flush="true"/>
  <jsp:include page="/inc/top_menu02.jsp" flush="true"/>
  <div id="container">
    <div id="leftCon">
      <jsp:include page="/inc/log_info.jsp" flush="true"/>
      <jsp:include page="/inc/left_menu02.jsp" flush="true"/>
    </div>
    <div id="rightCon">
<form name="form1" method="post" action="RCommSchVList.jsp">
	<input type=hidden name=ReqScheId VALUE="<%=strReqScheId%>">
	<input type=hidden name=OrganNm VALUE="<%=strOrganNm%>">
	<input type=hidden name=OrderInfo VALUE="<%=strOrderInfo%>">
	<input type=hidden name=AcptBgnDt VALUE="<%=strAcptBgnDt%>">
	<input type=hidden name=AcptEndDt VALUE="<%=strAcptEndDt%>">
	<input type=hidden name=SubmtDln VALUE="<%=strSubmtDln%>">
	<input type=hidden name=AuditYear VALUE="<%=strAuditYear%>">
	<input type=hidden name=CmtOrganId VALUE="<%=strCmtOrganId%>">
	<input type=hidden name=ReqCnt VALUE="<%=strReqCnt%>">
	<input type=hidden name=NatCnt VALUE="<%=strNatCnt%>">

	<input type=hidden name=strcmd VALUE="delete">

	<%//정렬 정보 받기.
		String strCommReqBoxSortField=objParams.getParamValue("CommReqBoxSortField");
		String strCommReqBoxSortMtd=objParams.getParamValue("CommReqBoxSortMtd");
	%>

	<input type="hidden" name="CommReqBoxSortField" value="<%=strCommReqBoxSortField%>"><!--요구함목록정렬필드 -->
	<input type="hidden" name="CommReqBoxSortMtd" value="<%=strCommReqBoxSortMtd%>"><!--요구함목록정령방법-->
	<input type="hidden" name="ReqBoxPage" value="<%=strCurrentPage%>"><!--페이지 번호 -->

	<input type=hidden name=ReqSchId VALUE="<%=strReqScheId%>">
	<input type=hidden name=strCurrentPage value="<%=strCurrentPage%>"> <!--페이징 파라미터-->

      <!-- pgTit -->

         <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=strOrganNm%>
		<!-- 페이지 제목 길이가 크기때문에 상세 일정 제목 생략
		&nbsp;<%=strReqNm%>일정상세--></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.REQUEST_BOX_COMM%> > <%=MenuConstants.REQ_BOX_SCH %></div>
        <p>해당 요구일정의 요구함 정보 목록을 확인하는 화면입니다. </p>
      </div>
      <!-- /pgTit -->

      <!-- contents -->

      <div id="contents">

        <!-- 검색조건 없는 경우 아래 div 삭제 나 주석으로 막으세요.-->
        <!-- /검색조건-->


        <!-- 각페이지 내용 -->
         <!-- list view-->

        <span class="list02_tl">요구일정 정보 </span>
        <table cellspacing="0" cellpadding="0" class="list02">


                        <tr>
                            <th height="25">&bull;&nbsp;진행상태 </th>
                            <td height="25"><%=strCdNm%> </td>
                            <th height="25" width="149">&bull;&nbsp;회기 </th>
                            <td height="25">제 [<%=strNatCnt%>]회 국회 </td>
                    </tr>
                        <tr>
                            <th height="25">&bull;&nbsp;접수시작 </th>
                            <td height="25"><%=strAcptBgnDt%> </td>
                            <th height="25" width="149">&bull;&nbsp;접수마감 </th>
                            <td height="25"><%=strAcptEndDt%> </td>
                        </tr>
                        <tr>
                            <th height="25">&bull;&nbsp;제출마감 </th>
                            <td height="25" colspan="3"><%=strSubmtDln%> </td>

            </tr>
        </table>
        <!-- /list view -->
        <!--<p class="warning mt10">* 요구서 발송 : 의원실(또는 소속기관) 명의로 해당 제출기관에 요구서를 발송합니다.</p>  -->
<!-- 리스트 버튼
요구마감
요구마감 취소
요구일정 수정
요구일정 삭제
목록

-->
         <div id="btn_all"class="t_right">
<%
     if (strKind.equals("004") & !strReqSubmitFlag.equals("004")) {
%>
	<% if(strIngStt.equals("001")) { %>
	<!--요구마감 버튼 -->
			 <span class="list_bt"><a href="#" onclick="javascript:fUsrAction2('reqend',form1.ReqScheId.value);">요구마감</a></span>
	<%}%>
	<% if(strIngStt.equals("002")) { %>
		<% if ( intNatCnt == 0 ) { %>
		 <!--요구마감취소 버튼 -->
			 <span class="list_bt"><a href="#" onclick="fUsrAction2('reqendback',form1.ReqScheId.value);">요구마감 취소</a></span>
		<%}%>
	<%}%>
	<% if(strIngStt.equals("001")) { %>
	 <!--수정 버튼 -->
			<span class="list_bt"><a href="#"
			onclick="fUsrAction('update', form1.ReqScheId.value, form1.OrganNm.value,form1.OrderInfo.value, form1.AcptBgnDt.value, form1.AcptEndDt.value,  form1.SubmtDln.value, form1.AuditYear.value,  form1.CmtOrganId.value, form1.NatCnt.value, form1.ReqScheId.value);">요구일정 수정</a></span>
			<span class="list_bt"><a href="#" onclick="fUsrAction2('delet',form1.ReqScheId.value)">요구일정 삭제</a></span>
	<%}%>
			<span class="list_bt"><a href="#" onclick="fUsrActionBack('back',form1.AuditYear.value);">목록</a></span>
<%}else{%>
		<span class="list_bt"><a href="#" onclick="fUsrActionBack('back',form1.AuditYear.value);" >목록</a></span>
<%}%>
		 </div><!-- /리스트 버튼-->
      <!-- list -->
        <span class="list01_tl">요구함목록<span class="list_total">&bull;&nbsp;전체자료수 : <%=objCommList.size()-1%>개</span></span>
		<input type=hidden name=ReqBoxCnt VALUE=" <%=objCommList.size()-1%>">
		<br>
        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
          <thead>
            <tr>

              <th scope="col"><a href="#">NO</a></th>
              <th scope="col" style="width:70%; "><a href="#">요구함명</a></th>
              <th scope="col"><a href="#">진행상태</a></th>
              <th scope="col"><a href="#">등록일시</a></th>

            </tr>
          </thead>
          <tbody>
	<%
		if(objCommList.size()-1 != 0){
			int N = objCommList.size()-1;
			for (int i = 1; i < objCommList.size(); i++) {
				Hashtable objHashCommList = (Hashtable)objCommList.get(i);

				String strReqBoxID   = (String)objHashCommList.get("REQ_BOX_ID");
				String strReqBoxNm = (String)objHashCommList.get("REQ_BOX_NM");
				String strReqBoxStt  = (String)objHashCommList.get("REQ_BOX_STT");
				String strCdNM         = (String)objHashCommList.get("CD_NM");
				String strReqRegDt   = nads.lib.reqsubmit.util.StringUtil.getDate2((String)objHashCommList.get("REG_DT"));
				//strReqRegDt = strReqRegDt.substring(0, 4) + "-" + strReqRegDt.substring(4, 6) + "-" + strReqRegDt.substring(6, 8);
	%>
            <tr>

              <td><%=N%></td>
              <td style="text-align:center;"><a href="javascript:fUsrActionList('<%=strReqBoxStt%>','<%=strReqBoxID%>')"><%=strReqBoxNm%></a></td>
              <td><%=strCdNM%></td>
              <td><%=strReqRegDt%></td>
            </tr>
	<%
				N = N - 1;
			  }//end for
		}else{
	%>
			<tr>
              <td colspan="4" align="center">등록된 요구함이 없습니다.</td>
            </tr>
	<%
		}//end if 목록 출력 끝.
	%>
          </tbody>
        </table>

        <!-- /list -->

        <!-- 페이징-->

			<%=objPaging.pagingTrans(PageCount.getLinkedString(
				strTotalCount , strCurrentPage, strCountPerPage
				)
			)%>

        <!-- /페이징-->


       <!-- 리스트 버튼-->
        <div id="btn_all" >        <!-- 리스트 내 검색 -->
        <div class="list_ser" >
          <select name="ReqBoxQryField" class="selectBox5"  style="width:70px;" >
            <option value="req_box_nm">요구함명</option>
          </select>
          <input name="ReqBoxQryTerm" onKeyDown="return ch()" onMouseDown="return ch()"
		 class="li_input"  style="width:100px" value=""/>
          <img src="/images2/btn/bt_list_search.gif"  onMouseOver="menuOn(this);" onMouseOut="menuOut(this);" onClick="form1.submit();"/> </div>
        <!-- /리스트 내 검색 -->
			<span class="right">
<%
     if (strKind.equals("004") & !strReqSubmitFlag.equals("004")) {
%>
	<% if(strIngStt.equals("001")) { %>
				<span class="list_bt"><a href="javascript:fUsrActionMake('make', form1.ReqScheId.value);">요구함 작성</a></span>
	<%}else{%>
	<%}%>
<%}%>
			</span>
		</div>

        <!-- /리스트 버튼-->

        <!-- /각페이지 내용 -->
      </div>
    </div>
  </div>
</form>
  <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>