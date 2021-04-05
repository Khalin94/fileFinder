<%@ page language="java" contentType="text/html;charset=EUC-KR" %>

<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.pf.util.PageCount"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RCommReqBoxVListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.cmtmanager.CmtManagerDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.cmtmanager.CmtManagerConfirmDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.CommRequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.CommRequestInfoDelegate" %>
<%@ page import="nads.dsdm.app.common.page.PagingDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%
System.out.println("dfdfdf");
	/*** PagingDelegate */
	PagingDelegate objPaging=new PagingDelegate(); 		/*페이징 변환 Delegate*/
%>
<%
	UserInfoDelegate objUserInfo = null;
	CDInfoDelegate objCdinfo = null;
%>

<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>

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
  /**** Debug용 **** 에러메시지 있으면 출력해줘잉...****************/
  //out.println( objParams.getValuesForDebug());
  /****************************************************************/
%>

<%
  //로그인 사용자 정보를 가져온다. 권한없음 경우 관람만 가능하다.
 String strReqSubmitFlag = objUserInfo.getReqSubmitFlag();
 String strUserId = objUserInfo.getUserID();
 String strOrganID = objUserInfo.getOrganID();
 String strCmtOpenCl = request.getParameter("OpenCl");
 String strReqBoxId = (String)objParams.getParamValue("ReqBoxID");



 String MenOrganID = "";
 String REQBOXID = "";
 int resultInt1 = -1;
 int resultInt2 = -1;
 int resultInt3 = -1;
 int resultCount = -1;
 int FLAG = -1;

 String strOpenCl = "";
 String strListMsg = "";
 String strOldReqOrganId = "";
 boolean strflag2 = true;


 /*** Delegate 과 데이터 Container객체 선언 */
 CmtManagerConfirmDelegate cmtmanagerCn = new CmtManagerConfirmDelegate();
 CommRequestBoxDelegate objReqBox=null; 		/**요구함 Delegate*/
 CommRequestInfoDelegate  objReqInfo=null;		/** 요구정보 Delegate */
 ResultSetSingleHelper objRsSH=null;			/** 요구함 상세보기 정보 */
 ResultSetHelper objRs=null;					/**요구 목록 */
 ResultSetHelper objRsHST=null;					/** 간사 이력정보*/
 String strAuitYear = "";

 try{
   /**요구함 정보 대리자 New */
   objReqBox=new CommRequestBoxDelegate();
   CmtManagerDelegate cmtmanager = new CmtManagerDelegate();
   resultCount = cmtmanager.searchUserId(strUserId, strOrganID);
   /** 요구함 정보 */
   objRsSH=new ResultSetSingleHelper(objReqBox.getRecord((String)objParams.getParamValue("ReqBoxID")));
    //요구함이 없는 경우 뒤로 빽...
    System.out.println("123123123123123123"+(String)objRsSH.getObject("REG_DT"));
    String testRegdt = (String)objRsSH.getObject("REG_DT");
    if (testRegdt==null||testRegdt.equals("")){
        out.println("<script>alert('요구함이 존재하지 않습니다.');history.back();</script>");
        return;
    }
   /**요구함 이용 권한 체크 */
   if((objParams.getParamValue("AuditYear")) == null || (objParams.getParamValue("AuditYear")).equals("")){
        System.out.println("regdt : " + ((String)objRsSH.getObject("REG_DT")));
		strAuitYear = ((String)objRsSH.getObject("REG_DT")).substring(0,4);
   }

   boolean blnHashAuth=objReqBox.checkReqBoxAuth((String)objParams.getParamValue("ReqBoxID"),objUserInfo.getCurrentCMTList()).booleanValue();
   if(!blnHashAuth){
	  if(!strOrganID.equals((String)objRsSH.getObject("OLD_REQ_ORGAN_ID")))
{
      objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	  objMsgBean.setStrCode("DSAUTH-0001");
  	  objMsgBean.setStrMsg("해당 요구함을 볼 권한이 없습니다.");
  	  out.println("해당 요구함을 볼 권한이 없습니다.");

  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%
      return;
	  }
  }else{

   /**요구 정보 대리자 New */
    objReqInfo=new CommRequestInfoDelegate();
    objRs=new ResultSetHelper((Hashtable)objReqInfo.getRecordList(objParams));

	if(objRs != null){
		if(objRs.next()){
			strOpenCl = (String)objRs.getObject("OPEN_CL");
		}
		objRs.first();
	}
	if(objRs != null){
		if(objRs.next()){
			strOldReqOrganId = (String)objRs.getObject("OLD_REQ_ORGAN_ID");
		}
		objRs.first();
	}
	if(strCmtOpenCl == null || strCmtOpenCl.equals("") || strCmtOpenCl.equals("N")){
		strCmtOpenCl = cmtmanagerCn.getOpenCl(strOldReqOrganId) == null ? "" : cmtmanagerCn.getOpenCl(strOldReqOrganId);
	}
    if(objUserInfo.getOrganGBNCode().equals("004")  && !strReqSubmitFlag.equals("004")){
		strListMsg = "등록된 요구정보가 없습니다.";
	}else{
		if(strCmtOpenCl.equals("Y")){
			if(strOpenCl.equals("002")){
					if(strOldReqOrganId.equals(strOrganID)){
						 strListMsg = "등록된 요구정보가 없습니다.";
					}else{
						objParams.setParamValue("ReqBoxID","XXXXXXXXXX");
						objRs=new ResultSetHelper((Hashtable)objReqInfo.getRecordList(objParams));
						strListMsg = "비공개 요구목록 입니다.";
						strflag2 = false;
					}
			}
		}else{
			strListMsg = "등록된 요구정보가 없습니다.";
		}
	}
	objParams.setParamValue("ReqBoxID",strReqBoxId);


	String strflag = StringUtil.getEmptyIfNull(request.getParameter("gansa"));
	REQBOXID = StringUtil.getEmptyIfNull(request.getParameter("ReqBoxID"));
	if(strflag.equals("OK")){
		MenOrganID = cmtmanager.getMenOrganId(strUserId);
		resultInt1 = cmtmanagerCn.getCount(MenOrganID,REQBOXID);
		if(resultInt1 == 0){
			resultInt2 = cmtmanagerCn.getCountNo(REQBOXID);
		}
	}
	FLAG = cmtmanagerCn.getFLAG((String)objParams.getParamValue("CmtOrganID"));
  }/**권한 endif*/
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
 /**요구정보 목록조회된 결과 반환.*/
 int intTotalRecordCount=objRs.getTotalRecordCount();
 int intCurrentPageNum=objRs.getPageNumber();
 int intTotalPage=objRs.getTotalPageCount();
%>
<jsp:include page="/inc/header.jsp" flush="true"/>
<link href="/css2/style.css" rel="stylesheet" type="text/css">
<%if(resultInt2 == 1 && resultInt1 == 0){
		cmtmanagerCn.UpdateBoxCode(MenOrganID,REQBOXID,resultInt2,resultInt1,strUserId);
		out.println("<script>");
		out.println("alert('양당 간사가 모두 승인하였습니다. 간사 승인완료 요구함 으로 이동합니다.');");
		out.println("</script>");
		out.println("<meta http-equiv='refresh'content='0;url=/reqsubmit/20_comm/20_reqboxsh/25_accend/RAccBoxConfirmList.jsp'/>");
		return;
  }else{
		resultInt3 = cmtmanagerCn.UpdateBoxCode(MenOrganID,REQBOXID,resultInt2,resultInt1,strUserId);
		objRsHST = new ResultSetHelper(cmtmanagerCn.getCmtManagerHistoy(REQBOXID));
		if(resultInt3 > 0){
			out.println("<script>");
			out.println("alert('승인작업이 성공적으로 완료되었습니다.');");
			out.println("</script>");
		}
  }%>
<script language="javascript">
  //이미확인한경우.
  <%if(resultInt1 > 0){%>
	alert("이미 요구함에 대해 확인을 하셨습니다.");
  <%}%>

  //요구함 수정으로 가기.
  function gotoEdit(strReqBoxID){
    form=document.formName;
  	form.ReqBoxID.value=strReqBoxID;
  	form.action="/reqsubmit/20_comm/20_reqboxsh/RCommReqBoxEdit.jsp?IngStt=002&ReqBoxStt=002";
  	form.target = "";
  	form.submit();
  }

  //요구함 삭제로 가기.
  function gotoDelete(strReqBoxID){
    form=document.formName;
  	form.ReqBoxID.value=strReqBoxID;

  	if(<%=objRs.getRecordSize()%> >0){
	if(confirm("등록된 요구정보가 있습니다. \n\n요구함이 삭제되면 등록된 요구정보도 함께 삭제 됩니다. \n\n그래도 삭제하시겠습니까? ")){
	  		var winl = (screen.width - 300) / 2;
			var winh = (screen.height - 240) / 2;
			form.target = "popwin";
			form.action = "/reqsubmit/20_comm/20_reqboxsh/RCommReqBoxDelProc2.jsp";
			window.open('/blank.html', 'popwin', 'width=300, height=240, left='+winl+', top='+winh);
			form.submit();
	 	}
  	 	return;
  	} else {
		if(confirm(" 요구함을 삭제하시겠습니까? ")){
		  	var winl = (screen.width - 300) / 2;
			var winh = (screen.height - 240) / 2;
			form.target = "popwin";
			form.action = "/reqsubmit/20_comm/20_reqboxsh/RCommReqBoxDelProc2.jsp";
			window.open('/blank.html', 'popwin', 'width=300, height=240, left='+winl+', top='+winh);
			form.submit();
		}
		return;
  	}
  }

  //요구 상세보기로 가기.
  function gotoDetail(strReqBoxID, strCommReqID){
    form=document.formName;
  	form.ReqBoxID.value=strReqBoxID;
  	form.CommReqID.value=strCommReqID;
  	form.action="./RAccReqInfo.jsp";
  	form.target = "";
  	form.submit();
  }

  /** 목록으로 가기 */
  function gotoList(){
  	form=document.formName;
  	form.action="./RAccBoxList.jsp";
  	form.target = "";
  	form.submit();
  }

  /** 정렬방법 바꾸기 */
  function changeSortQuery(sortField,sortMethod){
  	form=document.formName;
  	form.CommReqInfoSortField.value=sortField;
  	form.CommReqInfoSortMtd.value=sortMethod;
  	form.target = "";
 	form.submit();
  }

  /** 요구등록페이지로 가기. */
  function gotoReqInfo(){
  	form = document.formName;
  	form.action="/reqsubmit/20_comm/20_reqboxsh/RCommReqInfoWrite.jsp?IngStt=002";
  	form.target = "";
  	form.submit();
  }

  /** 페이징 바로가기 */
  function goPage(strPage){
  	form=document.formName;
  	form.CommReqInfoPage.value=strPage;
  	form.target = "";
  	form.submit();
  }

  /** 간사 확인 */
  function GansaOk(){
	form=document.formName;
	if(confirm("요구함에 대해 간사 승인을 하시겠습니까?")){
		form.gansa.value="OK"
		form.target = "";
		form.submit();
		form.gansa.value=""
  	}else{
  		return false;
  	}
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
	<SCRIPT language="JavaScript" src="/js/reqinfo.js"></SCRIPT>
	<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>
	<SCRIPT language="JavaScript" src="/js/reqsubmit/reqboxview.js"></SCRIPT>
    </div>
    <div id="rightCon">
<form name="formName" method="post" action="<%=request.getRequestURI()%>">

		<%  //요구함 정렬 정보 받기.
			String strCommReqBoxSortField=objParams.getParamValue("CommReqBoxSortField");
			String strCommReqBoxSortMtd=objParams.getParamValue("CommReqBoxSortMtd");
			//요구함 페이지 번호 받기.
			String strCommReqBoxPagNum=objParams.getParamValue("CommReqBoxPageNum");
			//요구함 조회정보 받기.
			String strCommReqBoxQryField=objParams.getParamValue("CommReqBoxQryField");
			String strCommReqBoxQryTerm=objParams.getParamValue("CommReqBoxQryTerm");

			//요구 정보 정렬 정보 받기.
			String strCommReqInfoSortField=objParams.getParamValue("CommReqInfoSortField");
			String strCommReqInfoSortMtd=objParams.getParamValue("CommReqInfoSortMtd");
			//요구함 정보 페이지 번호 받기.
			String strCommReqInfoPagNum=objParams.getParamValue("CommReqInfoPageNum");
		%>
	    <input type="hidden" name="ReqBoxID" value="<%=objParams.getParamValue("ReqBoxID")%>">
	    <input type="hidden" name="CmtOrganID" value="<%=objParams.getParamValue("CmtOrganID")%>">
   		<input type="hidden" name="AuditYear" value="<%=strAuitYear%>">
	    <input type="hidden" name="IngStt" value="">
	    <input type="hidden" name="ReqBoxNm" value="<%=objRsSH.getObject("REQ_BOX_NM")%>">
		<input type="hidden" name="CommReqBoxSortField" value="<%=strCommReqBoxSortField%>"><!--요구함목록정렬필드 -->
		<input type="hidden" name="CommReqBoxSortMtd" value="<%=strCommReqBoxSortMtd%>"><!--요구함목록정령방법-->
		<input type="hidden" name="CommReqBoxPage" value="<%=strCommReqBoxPagNum%>"><!--요구함 페이지 번호 -->
		<input type="hidden" name="CommReqBoxQryField" value="<%=strCommReqBoxQryField%>">
		<input type="hidden" name="CommReqBoxQryTerm" value="<%=strCommReqBoxQryTerm%>">
		<input type="hidden" name="CommReqInfoSortField" value="<%=strCommReqInfoSortField%>"><!--요구정보 목록정렬필드 -->
		<input type="hidden" name="CommReqInfoSortMtd" value="<%=strCommReqInfoSortMtd%>"><!--요구정보 목록정령방법-->
		<input type="hidden" name="CommReqInfoPage" value="<%=strCommReqInfoPagNum%>"><!--요구정보 페이지 번호 -->
		<input type="hidden" name="CommReqID" value=""><!--요구정보 ID-->
		<input type="hidden" name="ReturnURL" value="<%=request.getRequestURI()%>">
		<input type="hidden" name="DelURL" value="/reqsubmit/20_comm/20_reqboxsh/20_accend/RAccBoxList.jsp">
		<input type="hidden" name="RltdDuty" value="<%=objParams.getParamValue("RltdDuty")%>">
		<input type="hidden" name="gansa">

      <!-- pgTit -->

      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%= (FLAG > 1)?MenuConstants.COMM_MNG_CHECK:MenuConstants.COMM_REQ_BOX_MAKE_END %> <span class="sub_stl" >- 요구함 상세보기</span></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.REQUEST_BOX_COMM%> > <%= (FLAG > 1)?MenuConstants.COMM_MNG_CHECK:MenuConstants.COMM_REQ_BOX_MAKE_END %></div>
        <p>제출기관에게 보낼 요구함 정보를 확인하는 화면입니다.</p>
      </div>
      <!-- /pgTit -->

      <!-- contents -->

      <div id="contents">


        <!-- 검색조건 없는 경우 아래 div 삭제 나 주석으로 막으세요.-->
        <!-- /검색조건-->


        <!-- 각페이지 내용 -->
         <!-- list view-->

        <span class="list02_tl">요구함 정보 </span>
        <table border="0" cellspacing="0" cellpadding="0" width="680" class="list02">
<%
	//요구함 진행 상태.
	String strIngStt=(String)objRsSH.getObject("ING_STT");
%>
            <tr>
                <th height="25">&bull; 요구함명 </th>
                <td height="25" colspan="3"><strong><%=objRsSH.getObject("REQ_BOX_NM")%></strong></td>
            </tr>
            <tr>
                <th height="25">&bull; 접수 요구 일정 </th>
                <td height="25" colspan="3">- <%=StringUtil.getDate((String)objRsSH.getObject("ACPT_BGN_DT"))%> 부터 <%=StringUtil.getDate((String)objRsSH.getObject("ACPT_END_DT"))%> 까지의 요구 일정 기간에 접수되었습니다.
				</td>
            </tr>
            <tr>
                <th height="25">&bull; 업무구분 </th>
                <td height="25" colspan="3"><%=objCdinfo.getRelatedDuty((String)objRsSH.getObject("RLTD_DUTY"))%> </td>
            </tr>
            <tr>
                <th height="25">&bull; 소관 위원회 </th>
                <td height="25"><%=objRsSH.getObject("CMT_ORGAN_NM")%></td>
                <th height="25">&bull;&nbsp;제출기관</th>
                <td height="25"> <span class="list_bts"><%=(String)objRsSH.getObject("SUBMT_ORGAN_NM")%></span></td>
            </tr>
            <tr>
                <th height="25">&bull; 제출기한 </th>
                <td height="25" colspan="3">
				<%=StringUtil.getDate((String)objRsSH.getObject("SUBMT_DLN"))%> 까지 답변 제출을 요청합니다.
				</td>
            </tr>
            <tr>
                <th height="25">&bull; 요구함설명 </th>
                <td height="25" colspan="3">
					<%=StringUtil.getDescString((String)objRsSH.getObject("REQ_BOX_DSC"))%>
				</td>
            </tr>
        </table>
        <!-- /list view -->
<!--        <p class="warning mt10">* 요구서 발송 : 의원실(또는 소속기관) 명의로 해당 제출기관에 요구서를 발송합니다.</p>
-->
        <!-- 리스트 버튼
         <div id="btn_all"class="t_right">
			 <span class="list_bt"><a href="requestAddAnswer()">추가 답변 요구</a></span>
		 </div>

        <!-- /리스트 버튼-->

        <!-- list -->
		<%
			// 2005-08-08 kogaeng ADD
			// 간사 기능 사용중일 때만 보여달라
			if(FLAG > 1) {
		%>
        <span class="list01_tl">간사확인 정보
		<!--<span class="list_total">&bull;&nbsp;전체자료수 :  <%=objRs.getRecordSize()%>개 </span>-->
		</span>
<!--
checkbox
<input name="" type="checkbox" value="" class="borderNo" />
-->
        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
          <thead>
            <tr>
              <th scope="col">구분</th>
              <th scope="col">확인자정보</th>
              <th scope="col">확인시간</th>
              <th scope="col">기술사항</th>
            </tr>
          </thead>
          <tbody>
		<%if(objRsHST.getRecordSize() != 0){%>
				<%while(objRsHST.next()){%>
            <tr>
              <td><%
								if(!StringUtil.isAssigned((String)objRsHST.getObject("DESCRIPTION"))) out.println("[승인]");
								else out.println("[반려]");
							%></td>
              <td><%=objRsHST.getObject("ORGAN_NM")%>(<%=objRsHST.getObject("USER_NM")%>)</td>
              <td><%=objRsHST.getObject("REG_DATE")%></td>

              <td><%=objRsHST.getObject("DESCRIPTION")%></td>
            </tr>
			<%}%>
		<%}else{%>
			<tr height="20">
				<td align="center" colspan="4">&nbsp</td>
			</tr>
		<%}%>
		<% } // 간사기능 조정 if %>

<!----------------------- 저장 취소등 Form관련 버튼 시작 ------------------------->
		 <div id="btn_all"class="t_right">
		<%
			// 2005-07-26 kogaeng Edit
			if(FLAG > 1 && resultCount > 0) {
		%>
			 <span class="list_bt"><a href="#" onclick="GansaOk()">간사 승인</a></span>
		<%}%>
			<span class="list_bt"><a href="#" onclick="gotoList()">요구함 목록</a></span>
		<%
		/** 위원회 행정직원 일때만 화면에 출력함.*/
		if(objUserInfo.getOrganGBNCode().equals("004") && !strReqSubmitFlag.equals("004")){
		%>
		<% if (objRsSH.getObject("REQ_BOX_STT").equals("011") || objRsSH.getObject("REQ_BOX_STT").equals("005") || objRsSH.getObject("REQ_BOX_STT").equals("009")) { %>
		<!-- 요구서 발송 -->
			<span class="list_bt"><a href="#" onclick="sendReqDoc('<%=CodeConstants.REQ_DOC_TYPE_002%>', '<%=objParams.getParamValue("ReqBoxID")%>')">요구서 발송</a></span>
		<% } %>

		<%	if(objRsSH.getObject("REQ_BOX_STT").equals("002") || objRsSH.getObject("REQ_BOX_STT").equals("005")){ %>
		<!-- 요구함 수정 -->
			<span class="list_bt"><a href="#" onclick="gotoEdit('<%=objRsSH.getObject("REQ_BOX_ID")%>')">요구함 수정</a></span>
			<!-- 요구함 삭제 -->
			<span class="list_bt"><a href="#" onclick="gotoDelete('<%=objRsSH.getObject("REQ_BOX_ID")%>')">요구함 삭제</a></span>
		<%
		 } else {
		%>
			<span class="list_bt"><a href="#" onclick="ReqDocOpenView('<%=objRsSH.getObject("REQ_BOX_ID")%>','002')">요구서 보기</a></span>
		<%} %>

		<%if(intTotalRecordCount > 0){%>
				<!-- 요구함 미리 보기 -->
			<span class="list_bt"><a href="#" onclick="PreReqDocView(formName,'<%=objRsSH.getObject("REQ_BOX_ID")%>','002');">요구함 미리 보기</a></span>
		<%if(FLAG < 2 && objRsSH.getObject("REQ_BOX_STT").equals("002")){%>
			<!-- 요구서 발송 -->
			<span class="list_bt"><a href="#" onclick="sendReqDoc('<%=CodeConstants.REQ_DOC_TYPE_002%>', '<%=objParams.getParamValue("ReqBoxID")%>')">요구서 발송</a></span>
			<%}%>

		<% } %>

	 <% }else{
		if(strOldReqOrganId.equals(strOrganID)){%>
			<span class="list_bt"><a href="#" onclick="PreReqDocView(formName,'<%=objRsSH.getObject("REQ_BOX_ID")%>','002');">요구서 미리보기</a></span>
	<%	}
	}%>
		 </div>
			<BLOCKQUOTE></BLOCKQUOTE>
<!--
	자료가 없을 경우
			<tr>
			 <td colspan="6"  align ="center"> 등록된 요구정보가 없습니다. </td>
            </tr>
-->
          </tbody>
        </table>

        <!-- /list===============================-->
        <span class="list01_tl">요구 목록
		<span class="list_total">&bull;&nbsp;전체자료수 :  <%=intTotalRecordCount%>개 (<%=intCurrentPageNum%> / <%=intTotalPage%> Page) </span>
		</span>
		<table>
			<tr>
				<td>&nbsp;</td>
			</tr>
		</table>
<!--
checkbox
<input name="" type="checkbox" value="" class="borderNo" />
-->
        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
          <thead>
            <tr>
              <th scope="col" style="width:10px;">NO</th>
              <th scope="col" style="width:250px;"><%=SortingUtil.getSortLink("changeSortQuery","REQ_CONT",strCommReqInfoSortField,strCommReqInfoSortMtd,"요구제목")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","OLD_REQ_ORGAN_NM",strCommReqInfoSortField,strCommReqInfoSortMtd,"신청기관")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","OPEN_CL",strCommReqInfoSortField,strCommReqInfoSortMtd,"공개등급")%></th>
		      <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","REG_DT",strCommReqInfoSortField,strCommReqInfoSortMtd,"신청일시")%></th>
            </tr>
          </thead>
          <tbody>
	<%
	int intRecordNumber= intTotalRecordCount - ((intCurrentPageNum -1) * Integer.parseInt((String)objParams.getParamValue("CommReqInfoPageSize")));
	String strReqInfoID="";
	if(objRs.getRecordSize()>0){
		while(objRs.next()){
			strReqInfoID=(String)objRs.getObject("REQ_ID");
	%>
            <tr>
              <td><%=intRecordNumber%></td>
			  <td><%= StringUtil.getNotifyImg((String)objRs.getObject("REG_DT"), (String)objRs.getObject("REQ_STT")) %><a href="javascript:gotoDetail('<%=objRsSH.getObject("REQ_BOX_ID")%>','<%=objRs.getObject("REQ_ID")%>')" hint="<%= StringUtil.substring((String)objRs.getObject("REQ_DTL_CONT"), 80) %>"><%=objRs.getObject("REQ_CONT")%></a></td>
			  <td><%=objRs.getObject("OLD_REQ_ORGAN_NM")%></td>
			  <td><%=CodeConstants.getOpenClass((String)objRs.getObject("OPEN_CL"))%></td>
			  <td><%=StringUtil.getDate2((String)objRs.getObject("REG_DT"))%></td>
            </tr>
	<%
		intRecordNumber--;
		}//endwhile
	} else {
	%>
			<tr height="20">
				<td colspan="5" align="center"><%=strListMsg%></td>
			</tr>

	<%
		}//endif
	%>
<!----------------------- 저장 취소등 Form관련 버튼 시작 ------------------------->

			<BLOCKQUOTE></BLOCKQUOTE>
<!--
	자료가 없을 경우
			<tr>
			 <td colspan="6"  align ="center"> 등록된 요구정보가 없습니다. </td>
            </tr>
-->
          </tbody>
        </table>

			<%=objPaging.pagingTrans(PageCount.getLinkedString(
				new Integer(intTotalRecordCount).toString(),
				new Integer(intCurrentPageNum).toString(),
				objParams.getParamValue("CommReqInfoPageSize"))
			)%>

       <!-- 리스트 버튼
        <div id="btn_all" >
		<!-- 리스트 내 검색 -->

		<div class="list_ser" >
		<%
		String strCommReqInfoQryField=(String)objParams.getParamValue("CommReqInfoQryField");
		%>
          <select name="CommReqInfoQryField" class="selectBox5"  style="width:70px;" >
			  <option <%=(strCommReqInfoQryField.equalsIgnoreCase("req_cont"))? " selected ": ""%>value="req_cont">요구제목</option>
			  <option <%=(strCommReqInfoQryField.equalsIgnoreCase("req_dtl_cont"))? " selected ": ""%>value="req_dtl_cont">요구내용</option>
			  <option <%=(strCommReqInfoQryField.equalsIgnoreCase("old_req_organ_nm"))? " selected ": ""%>value="old_req_organ_nm">요구기관</option>
          </select>
          <input name="CommReqInfoQryTerm" onKeyDown="return ch()" onMouseDown="return ch()"
		 class="li_input"  style="width:100px" value="<%=objParams.getParamValue("CommReqInfoQryTerm")%>"/>
          <img src="/images2/btn/bt_list_search.gif"  onMouseOver="menuOn(this);" onMouseOut="menuOut(this);" onClick="formName.submit()"/> </div>

        <!-- /리스트 내 검색  -->
			<span class="right">
					<%
					/** 위원회 행정직원 일때만 화면에 출력함.*/
					if(objUserInfo.getOrganGBNCode().equals("004")  && !strReqSubmitFlag.equals("004")){
						//if(objRsSH.getObject("REQ_BOX_STT").equals("002") || objRsSH.getObject("REQ_BOX_STT").equals("005")){
						%>
				<span class="list_bt"><a href="javascript:gotoReqInfo()">요구 등록</a></span>
						<% //}
				 	} %>
			</span>
		</div>

        <!-- /리스트 버튼-->
        <!-- /각페이지 내용
      </div>
      <!-- /contents -->

    </div>
  </div>
</form>
  <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>