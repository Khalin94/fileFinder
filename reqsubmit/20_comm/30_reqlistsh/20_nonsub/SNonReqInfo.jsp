<%@ page language="java" contentType="text/html;charset=EUC-KR" %>

<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="java.util.*" %>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RCommReqBoxVListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.CommRequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.CommRequestInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.CommAnsInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.SMemReqBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.SCommRequestBoxDelegate" %>
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
	/**일반 요구함 상세보기 파라미터 설정.*/
	RCommReqBoxVListForm objParams =new RCommReqBoxVListForm();

	boolean blnParamCheck=false;
	/**전달된 파리미터 체크 */
	blnParamCheck=objParams.validateParams(request);
	if(blnParamCheck==false){
		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
		objMsgBean.setStrCode("DSPARAM-0000");
		objMsgBean.setStrMsg(objParams.getStrErrors());
		out.println("ParamError:" + objParams.getStrErrors());
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}//endif
%>

<%
	//로그인 사용자 정보를 가져온다. 권한없음 경우 관람만 가능하다.
	String strReqSubmitFlag = objUserInfo.getReqSubmitFlag();

	/*** Delegate 과 데이터 Container객체 선언 */
	CommRequestBoxDelegate objReqBox=null; 		/**요구함 Delegate*/
	SMemReqBoxDelegate selfDelegate = null;
	CommRequestInfoDelegate  objReqInfo=null;		/** 요구정보 Delegate */
	CommAnsInfoDelegate objAnsInfo = new CommAnsInfoDelegate();
	ResultSetSingleHelper objRsSH=null;			/** 요구함 상세보기 정보 */
	ResultSetSingleHelper objRsRI=null;			/** 요구 상세보기 정보 */
	ResultSetHelper objRs = null;					/** 답변 목록 */

	SCommRequestBoxDelegate objReqBox2 = null; 		/**요구함 Delegate*/
	ResultSetSingleHelper objRsSH2 = null;			/** 요구함 상세보기 정보 */
	ResultSetHelper objRs2 = null;					/**요구 목록 */

	String strReqID = (String)objParams.getParamValue("CommReqID");
	int intTotalAnsCount = 0;

	try {
		/**요구함 정보 대리자 New */
		objReqBox=new CommRequestBoxDelegate();
		objReqBox2 = new SCommRequestBoxDelegate();

		objRsSH2 = new ResultSetSingleHelper(objReqBox2.getRecord((String)objParams.getParamValue("ReqBoxID"), objUserInfo.getUserID()));
		/** 요구 정보 대리자 New */
		//objRs2 = new ResultSetHelper((Hashtable)objReqBox2.getReqRecordList(objParams));
		/** 요구함 정보 */
		objRsSH=new ResultSetSingleHelper(objReqBox.getRecord((String)objParams.getParamValue("ReqBoxID")));
		/**요구 정보 대리자 New */
		objReqInfo=new CommRequestInfoDelegate();
		objRsRI=new ResultSetSingleHelper(objReqInfo.getRecord((String)objParams.getParamValue("CommReqID")));
		objRs = new ResultSetHelper(objAnsInfo.getRecordList((String)objParams.getParamValue("CommReqID")));
		selfDelegate = new SMemReqBoxDelegate();
		intTotalAnsCount = selfDelegate.checkReqInfoAnsIsNull((String)objParams.getParamValue("ReqBoxID"));


	} catch(AppException objAppEx) {
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
<jsp:include page="/inc/header.jsp" flush="true"/>
<link href="/css2/style.css" rel="stylesheet" type="text/css">
<script language="javascript">
  	// 답변 작성 화면으로 이동
  	function gotoNewAns111() {
  		f = document.formName;
  		f.action = "/reqsubmit/20_comm/20_reqboxsh/SCommAnsInfoWrite.jsp";
  		f.submit();
  	}

	// 답변 작성 화면으로 이동
  	function gotoNewAnsTest() {
  		f = document.formName;
		f.target = "newpopup";
		f.action = "/reqsubmit/common/SAnsInfoWrite_hyo.jsp";
		var winl = (screen.width - 600) / 2;
		var winh = (screen.height - 600) / 2;
		window.open("/blank.html","newpopup","resizable=yes,menubar=no,status=no,titlebar=no, scrollbars=yes,location=no,toolbar=no,height=600,width=618, left="+winl+", top="+winh);
		f.submit();
  	}

  	// 답변 작성 화면으로 이동
  	function gotoNewAns() {
  		f = document.formName;
		f.target = "newpopup";
		f.action = "/reqsubmit/common/SAnsInfoWrite.jsp";
		var winl = (screen.width - 600) / 2;
		var winh = (screen.height - 600) / 2;
		window.open("/blank.html","newpopup","resizable=yes,menubar=no,status=no,titlebar=no, scrollbars=yes,location=no,toolbar=no,height=600,width=618, left="+winl+", top="+winh);
		f.submit();
  	}
  	// 답변 작성 화면으로 이동
  	function gotoNewAns_old() {
  		f = document.formName;
		f.target = "newpopup";
		f.action = "/reqsubmit/common/SAnsInfoWrite_old.jsp";
		var winl = (screen.width - 550) / 2;
		var winh = (screen.height - 350) / 2;
		window.open("/blank.html","newpopup","resizable=yes,menubar=no,status=no,titlebar=no, scrollbars=yes,location=no,toolbar=no,height=350,width=520, left="+winl+", top="+winh);
		f.submit();
  	}
  	// 답변 상세보기로 가기
  	function gotoDetail(strAnsID){
  		f = document.formName;
  		f.target = "popwin";
  		f.action="/reqsubmit/common/SAnsInfoView.jsp?AnsID="+strAnsID;
  		NewWindow('/blank.html', 'popwin', '618', '590');
  		//window.open('about:blank', 'popwin', 'width=520,height=400, scrollbars=no, resizable=yes, toolbar=no, menubar=no, location=no, directories=no, status=no');
  		f.submit();
  	}
  	// 제출된 요구목록으로 가기
  	function gotoList(){
  		f = document.formName;
  		f.action="SNonReqList.jsp";
  		f.target = "";
  		f.submit();
 	}

	function sbmtReq() {
		f = document.formName;
		f.target = "";
		f.action = "/reqsubmit/common/SReqSubmtDoneProc.jsp";
		if (confirm("현재 요구에 대한 답변 제출을 완료하시겠습니까?")) f.submit();
	}

	function selectDelete() {
  		var f = document.formName;
  		f.ReqID.value = "<%= strReqID %>";
  		f.target = "";
  		if (getCheckCount(f, "AnsID") < 1) {
  			alert("하나 이상의 체크박스를 선택해 주세요");
  			return;
  		}
  		f.action = "/reqsubmit/common/SAnsInfoDelProc.jsp";
  		if (confirm("선택하신 답변들을 삭제하시겠습니까?\n해당 답변들을 삭제하면 포함된 파일들도 일괄 삭제됩니다.")) f.submit();
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
	<SCRIPT language="JavaScript" src="/js/reqinfo.js"></SCRIPT>
	<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>
    </div>
    <div id="rightCon">
<form name="formName" method="post" action="<%=request.getRequestURI()%>">

		<%  //요구 정보 정렬 정보 받기.
			String strCommReqInfoSortField=objParams.getParamValue("CommReqInfoSortField");
			String strCommReqInfoSortMtd=objParams.getParamValue("CommReqInfoSortMtd");
			//요구함 정보 페이지 번호 받기.
			String strCommReqInfoPagNum=objParams.getParamValue("CommReqInfoPageNum");
		%>
			<input type="hidden" name="CommReqInfoSortField" value="<%=strCommReqInfoSortField%>"><!--요구정보 목록정렬필드 -->
			<input type="hidden" name="CommReqInfoSortMtd" value="<%=strCommReqInfoSortMtd%>"><!--요구정보 목록정령방법-->
			<input type="hidden" name="CommReqInfoPage" value="<%=strCommReqInfoPagNum%>"><!--요구정보 페이지 번호 -->
			<input type="hidden" name="ReqBoxID" value="<%=objRsRI.getObject("REQ_BOX_ID")%>"><!--요구정보 페이지 번호 -->
			<input type="hidden" name="ReqID" value="<%=objRsRI.getObject("REQ_ID")%>"><!--요구정보 페이지 번호 -->
			<input type="hidden" name="ReqStt" value="<%=objRsRI.getObject("REQ_STT")%>"><!--요구정보 페이지 번호 -->
			<input type="hidden" name="WinType" value="SELF">
			<input type="text" name="ReqOpenCL" value="<%= objRsRI.getObject("OPEN_CL") %>">

			<input type="hidden" name="WriteURL" value="<%=request.getRequestURI()%>?ReqBoxID=<%=objRsRI.getObject("REQ_BOX_ID")%>&CommReqID=<%=objRsRI.getObject("REQ_ID")%>&AuditYear=<%=objParams.getParamValue("AuditYear")%>">
			<input type="hidden" name="AuditYear" value="<%=objParams.getParamValue("AuditYear")%>">
			<input type="hidden" name="CmtOrganID" value="<%=objParams.getParamValue("CmtOrganID")%>">
		    <input type="hidden" name="ReturnURL" value="<%=request.getRequestURI()%>?ReqBoxID=<%=objRsRI.getObject("REQ_BOX_ID")%>&CommReqID=<%=objRsRI.getObject("REQ_ID")%>&AuditYear=<%=objParams.getParamValue("AuditYear")%>">
      <!-- pgTit -->
      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=MenuConstants.REQ_INFO_LIST_SUBMT_NONE%><span class="sub_stl" >- 요구상세보기</span></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%= MenuConstants.REQUEST_BOX_COMM %> > <%=MenuConstants.REQ_INFO_LIST%> > <%=MenuConstants.REQ_INFO_LIST_SUBMT_NONE%></div>
        <p><!--문구--></p>
      </div>
      <!-- /pgTit -->

      <!-- contents -->

      <div id="contents">

        <!-- 검색조건 없는 경우 아래 div 삭제 나 주석으로 막으세요.-->
        <!-- /검색조건-->


        <!-- 각페이지 내용 -->
         <!-- list view-->

        <span class="list02_tl">요구 정보 </span>
        <div class="top_btn"><samp>
			 <span class="btn"><a href="javascript:viewReqHistory('<%=objRsRI.getObject("REQ_ID")%>')">요구 이력 보기</a></span>
			 <span class="btn"><a href="javascript:gotoList()">요구 목록</a></span>
		</samp></div>

        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list02">
			<%
				if(!objRsRI.next()){
			%>
			<tr>
              <th scope="col">&bull;&nbsp;요구 정보 가 없습니다. </th>
			 </tr>
			<%
				}else{
			%>
            <tr>
              <th scope="col">&bull;&nbsp;요구제목 </th>
				  <td colspan="3"><strong><%=objRsRI.getObject("REQ_CONT")%></strong> </td>
            </tr>

            <tr>
              <th scope="col">&bull;&nbsp;요구내용 </th>
			  <td colspan="3"><%=StringUtil.getDescString((String)objRsRI.getObject("REQ_DTL_CONT"))%><br>
       			<%= nads.dsdm.app.reqsubmit.delegate.requestinfo.RequestInfoDelegate.getAppendRequestInfo((List)objRsRI.getObject("TBDS_REQ_LOG")) %></td>
            </tr>
            <tr>
              <th scope="col">&bull;&nbsp;요구함명  </th>
			  <td colspan="3"><%=objRsRI.getObject("REQ_BOX_NM")%></td>
            </tr>
            <tr>
              <th width="18%" scope="col">&bull;&nbsp;소관위원회 </th>
			  <td width="32%"> <%= objRsRI.getObject("CMT_ORGAN_NM") %></td>
              <th width="18%" height="25" >&bull; 제출 여부</th>
              <td width="32%" height="25"><%= CodeConstants.getRequestStatus(objRsRI.getObject("REQ_STT").toString()) %></td>
            </tr>
            <tr>
              <th scope="col">&bull;&nbsp;요구기관  </th>
			  <td><%= objRsRI.getObject("REQ_ORGAN_NM") %> (<%=objRsRI.getObject("REGR_NM")%>)</td>
              <th scope="col">&bull; 제출기관</th>
		  		<td><%= objRsRI.getObject("SUBMT_ORGAN_NM") %></td>
            </tr>
            <tr>
              <th scope="col">&bull;&nbsp;제출기한  </th>
			  <td><strong><%= StringUtil.getDate((String)objRsRI.getObject("SUBMT_DLN")) %> 24:00</strong></td>
              <th scope="col">&bull;&nbsp;요구일자  </th>
			  <td><strong><%= StringUtil.getDate2((String)objRsRI.getObject("LAST_REQ_DT")) %></strong></td>
            </tr>
            <tr>
                <th height="25">&bull; 공개등급</th>
		  		<td height="25"><%= CodeConstants.getOpenClass((String)objRsRI.getObject("OPEN_CL")) %></td>
                <th height="25">&bull; 첨부파일</th>
		  		<td height="25"><%= StringUtil.makeAttachedFileLink((String)objRsRI.getObject("ANS_ESTYLE_FILE_PATH"), (String)objRsRI.getObject("REQ_ID")) %></td>
			</tr>
			<%
				}/** 요구 정보 가 있으면. */
			%>
        </table>
        <!-- /list view -->
		<!-- 답변서 발송 -->
        <!-- 리스트 버튼-->
<!--
요구 이력 보기, 요구 목록
-->
        <div id="btn_all"><div  class="t_right">
		</div></div>
        <!-- /리스트 버튼-->
        <!-- list -->
        <span class="list01_tl">답변 목록 <span class="list_total">&bull;&nbsp;전체자료수 :  <%= objRs.getRecordSize()%>개 </span></span>
        <table width="100%" style="padding:0;">
            <tr>
                <td>&nbsp;</td>
            </tr>
        </table>
        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
          <thead>
            <tr>
			 <th style="width:15px;">
				<input name="checkAll" type="checkbox" value="" class="borderNo" onClick="javascript:checkAllOrNot(this.form)"/>
			 </th>
			  <th scope="col" style="width:15px;"><a>NO</a></th>
              <th scope="col" style="width:250px;"><a>제출 의견</a></th>
              <th scope="col"><a>작성자</a></th>
              <th scope="col"><a>공개</a></th>
              <th scope="col"><a>답변</a></th>
			  <th scope="col"><a>답변일</a></th>
            </tr>
          </thead>
          <tbody>
			<%
				int intRecordNumber=1;
				String strAnsInfoID="";
				if (objRs.getRecordSize() > 0) {
					while(objRs.next()){
						 strAnsInfoID = (String)objRs.getObject("ANS_ID");
			 %>
            <tr>
			  <td>
				 <input name="AnsID" type="checkbox" value="<%= strAnsInfoID %>" class="borderNo"/>
			  </td>
              <td><%= intRecordNumber %></td>
              <td><a href="JavaScript:gotoDetail('<%=strAnsInfoID%>');"><%=StringUtil.substring((String)objRs.getObject("ANS_OPIN"),35)%></a></td>
              <td><%=(String)objRs.getObject("USER_NM")%></td>
              <td><%=CodeConstants.getOpenClass(((String)objRs.getObject("OPEN_CL")))%></td>
			  <td><%=nads.lib.reqsubmit.util.DBAccessUtil.makeAnsInfoHtml(strAnsInfoID,(String)objRs.getObject("ANS_MTD"))%></td>
			  <td><%=StringUtil.getDate2((String)objRs.getObject("ANS_DT"))%></td>
            </tr>
	<%
				intRecordNumber++;
			} //endwhile
		} else {
	%>
			<tr>
			  <td colspan="7" align="center">등록된 답변이 없습니다.</td>
            </tr>
	<%
		}
	%>
          </tbody>
        </table>
        <!-- /list -->

       <!-- 리스트 버튼-->
        <span class="right">

		<%
		/**위원회에서 신규등록한 요구에 한함-> 기준??*/
		//권한 없음
		// 답변 작성, 요구 이력 보기, 요구 목록, 즉시 제출
		if(!strReqSubmitFlag.equals("004")){
		%>
			<span class="list_bt"><a href="javascript:gotoNewAns_old()" onfocus="this.blur()">답변작성</a></span>
		<% } %>
			<span class="list_bt"><a href="javascript:gotoNewAns()">대용량파일등록</a></span>
			<!-- <span class="list_bt"><a href="javascript:gotoNewAnsTest()">대용량파일등록테스트</a></span> -->
			<span class="list_bt"><a href="javascript:selectDelete()">선택삭제</a></span>
	 <%
		if(!strReqSubmitFlag.equals("004") && !CodeConstants.REQ_STT_SUBMT.equalsIgnoreCase((String)objRsRI.getObject("REQ_STT")) && objRs.getRecordSize() > 0) {
	%>
			<span class="list_bt"><a href="javascript:sbmtReq()" onfocus="this.blur()">즉시제출</a></span>
	<%
		}
	%>
<!--
			<span class="list_bt"><a href="#">요구삭제</a></span>
			<span class="list_bt"><a href="#">요구복사</a></span>
-->
			</span>
        <!-- /리스트 버튼-->
        <!-- /각페이지 내용 -->
      <!-- /contents -->

    </div>
  </div>
</form>
<form method="post" action="" name="dupCheckForm" style="margin:0px">
	<input type="hidden" name="queryText" value="<%= StringUtil.ReplaceString((String)objRsRI.getObject("REQ_CONT"), "'", "") %>">
	<input type="hidden" name="ReqBoxID" value="<%=objRsRI.getObject("REQ_BOX_ID")%>">
	<input type="hidden" name="ReqID" value="<%=objRsRI.getObject("REQ_ID")%>">
	<input type="hidden" name="ReturnURL" value="<%=request.getRequestURI()%>?ReqBoxID=<%=objRsRI.getObject("REQ_BOX_ID")%>&CommReqID=<%=objRsRI.getObject("REQ_ID")%>&AuditYear=<%=objParams.getParamValue("AuditYear")%>">
</form>
  <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>