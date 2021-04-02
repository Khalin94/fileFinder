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
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.CommRequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.CommRequestInfoDelegate" %>
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

<%@ include file="../../common/RUserCodeInfoInc.jsp" %>

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
 CommRequestInfoDelegate  objReqInfo=null;		/** 요구정보 Delegate */
 ResultSetSingleHelper objRsSH=null;			/** 요구함 상세보기 정보 */
 ResultSetHelper objRs=null;					/**요구 목록 */
 try{
   /**요구함 정보 대리자 New */
   objReqBox=new CommRequestBoxDelegate();
   /**요구함 이용 권한 체크 */
   boolean blnHashAuth=objReqBox.checkReqBoxAuth((String)objParams.getParamValue("ReqBoxID"),objUserInfo.getCurrentCMTList()).booleanValue();
   if(!blnHashAuth){
      objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	  objMsgBean.setStrCode("DSAUTH-0001");
  	  objMsgBean.setStrMsg("해당 요구함을 볼 권한이 없습니다.");
  	  out.println("해당 요구함을 볼 권한이 없습니다.");
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%
      return;
  }else{

   /** 요구함 정보 */
    objRsSH=new ResultSetSingleHelper(objReqBox.getRecord((String)objParams.getParamValue("ReqBoxID")));

	/** 위원회 행정직원 일때만 화면에 출력함.*/
	if(!objUserInfo.getOrganGBNCode().equals("004")){
		objParams.setParamValue("OldReqOrganID",objUserInfo.getOrganID());
	}
    /**요구 정보 대리자 New */
    objReqInfo=new CommRequestInfoDelegate();
    objRs=new ResultSetHelper((Hashtable)objReqInfo.getRecordList(objParams));
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
<link href="/css/System.css" rel="stylesheet" type="text/css">
<script language=Javascript src="/js/reqsubmit/common.js"></script>
<script language=Javascript src="/js/nads_lib.js"></script>
<script language=Javascript src="/js/datepicker.js"></script>
<script language=Javascript src="/js/calendar.js"></script>
<script language="javascript">
  //요구함 수정으로 가기.
  function gotoEdit(strReqBoxID){
    form=document.formName;
  	form.ReqBoxID.value=strReqBoxID;
  	form.action="./RCommReqBoxEdit.jsp?IngStt=001&ReqBoxStt=001";
  	form.target = "";
  	form.submit();
  }

  //요구함 삭제로 가기.
  function gotoDelete(strReqBoxID){
    form=document.formName;
  	form.ReqBoxID.value=strReqBoxID;

  	if(<%=objRs.getRecordSize()%> >0){
		if(confirm("등록된 요구정보가 있습니다. \n요구함 삭제를 수행하시면 등록된 요구정보와 같이 삭제됩니다. \n삭제하시겠습니까? ")){
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

  //요구상세보기로 가기.
  function gotoDetail(strReqBoxID, strCommReqID){
    form=document.formName;
  	form.ReqBoxID.value=strReqBoxID;
  	form.CommReqID.value=strCommReqID;
  	form.action="./RCommReqInfo.jsp";
  	form.target = "";
  	form.submit();
  }

  /** 목록으로 가기 */
  function gotoList(){
  	form=document.formName;
  	form.action="./RCommReqBoxList.jsp";
  	form.target = "";
  	form.submit();
  }

  /** 요구등록페이지로 가기. */
  function gotoReqInfo(){
  	form = document.formName;
  	form.action="./RCommReqInfoWrite.jsp";
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
</script>
</head>
<body>
<DIV ID="loadingDiv" style="display:none;position:absolute;">
	<img src="/image/reqsubmit/loading.jpg" border="0"> </td>
</DIV>
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
	    <input type="hidden" name="CmtOrganID" value="<%=objRsSH.getObject("CMT_ORGAN_ID")%>">
	    <input type="hidden" name="IngStt" value="">
	    <input type="hidden" name="ReqBoxNm" value="<%=objRsSH.getObject("REQ_BOX_NM")%>">
	    <input type="hidden" name="AuditYear" value="<%=objParams.getParamValue("AuditYear")%>">
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
		<input type="hidden" name="DelURL" value="/reqsubmit/20_comm/20_reqboxsh/RCommReqBoxList.jsp">
		<input type="hidden" name="RltdDuty" value="<%=objParams.getParamValue("RltdDuty")%>">

      <!-- pgTit -->
      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=MenuConstants.COMM_REQ_BOX_MAKE%><span class="sub_stl" >- <%=MenuConstants.REQ_BOX_DETAIL_VIEW%></span></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.REQUEST_BOX_COMM%> > <B><%=MenuConstants.COMM_REQ_BOX_MAKE%></B></div>
        <p><!--문구--></p>
      </div>
      <!-- /pgTit -->
      <!-- contents -->
      <div id="contents">
        <!-- 검색조건 없는 경우 아래 div 삭제 나 주석으로 막으세요.-->
        <!-- /검색조건-->
        <!-- 각페이지 내용 -->
         <!-- list view-->
        <span class="list02_tl">요구함 정보 </span>
         <div class="top_btn"><samp>
            <%
            //접수중 요구함(접수완료-행정직원,요구함목록)
            //접수완료 요구함((요구서보기,결재및발송,(요구함삭제)-행정직원,요구함목록)-버튼모양다르게)
            //발송완료요구함(요구서보기-행정직원,요구함목록)
            //제출완료요구함(요구서보기,제출문서보기-행정직원,요구함목록)

            /** 위원회 행정직원 일때만 화면에 출력함.*/
            if(objUserInfo.getOrganGBNCode().equals("004") && !strReqSubmitFlag.equals("004")){
            %>
			 <span class="btn"><a href="#" onClick="gotoEdit('<%=objRsSH.getObject("REQ_BOX_ID")%>')">요구함 수정</a></span>
			 <span class="btn"><a href="#" onClick="gotoDelete('<%=objRsSH.getObject("REQ_BOX_ID")%>')">요구함 삭제</a></span>
             <% }%>
			 <span class="btn"><a href="#" onClick="gotoList()">요구함 목록</a></span>
		 </samp></div>
			<!------------------------- TAB에 해당하는 테이블(목록이든 등록폼이든 상세정보든) 출력 시~~~작 ------------------------->
			<table width="100%" border="0" cellspacing="0" cellpadding="0" class="list02">
			<%
				//요구함 진행 상태.
				String strIngStt=(String)objRsSH.getObject("ING_STT");
			%>
			<tr>
				<th scope="col">&bull;&nbsp;요구함명 </th>
				<td height="25" colspan="3"><B><%=objRsSH.getObject("REQ_BOX_NM")%></B></td>
			</tr>
            <tr>
            	<th scope="col">&bull;&nbsp;접수 요구 일정</th>
				<td width="570" height="25" colspan="3"><%=StringUtil.getDate((String)objRsSH.getObject("ACPT_BGN_DT"))%> 부터 <%=StringUtil.getDate((String)objRsSH.getObject("ACPT_END_DT"))%> 까지의 요구 일정 기간에 접수되었습니다.
				</td>
            </tr>
			<tr>
				<th scope="col">&bull;&nbsp;업무구분 </th>
				<td height="25" colspan="3">
               	<%=objCdinfo.getRelatedDuty((String)objRsSH.getObject("RLTD_DUTY"))%>
				</td>
			</tr>
            <tr>
              	<th scope="col">&bull;&nbsp;소관 위원회 </th>
              	<td width="230" height="25">
           	   	<%=objRsSH.getObject("CMT_ORGAN_NM")%>
              	</td>
              	<th scope="col">&bull;&nbsp;제출기관 </th>
              	<td width="230" height="25">
              	<%=(String)objRsSH.getObject("SUBMT_ORGAN_NM")%>
              	</td>
            </tr>
            <tr>
              	<th scope="col">&bull;&nbsp;제출기한 </th>
              	<td height="25" colspan="3">
              	<%=StringUtil.getDate((String)objRsSH.getObject("SUBMT_DLN"))%> 까지 답변 제출을 요청합니다.
              	</td>
	        </tr>
			<tr>
				<th scope="col">&bull;&nbsp;요구함설명 </th>
			  	<td height="25" colspan="3">
			  	<%=StringUtil.getDescString((String)objRsSH.getObject("REQ_BOX_DSC"))%>
			  	</td>
			</tr>
			</table>
			<!------------------------- TAB에 해당하는 테이블(목록이든 등록폼이든 상세정보든) 출력 끝 ------------------------->

         <div id="btn_all"><div  class="t_right">
            <% if(objUserInfo.getOrganGBNCode().equals("004") && !strReqSubmitFlag.equals("004") && intTotalRecordCount > 0){ %>
			<div class="mi_btn"><a href="#" onClick="PreReqDocView(formName,'<%=objRsSH.getObject("REQ_BOX_ID")%>','002');"><span>요구서 미리 보기</span></a></div>
            <%}%>
		</div></div>

        <!-- list -->
        <span class="list01_tl">요구 목록 <span class="list_total">&bull;&nbsp;전체자료수 : <%= intTotalRecordCount %>개 (<%= intCurrentPageNum %>/<%= intTotalPage %> page)</span></span>
		<table>
			<tr>
				<td>&nbsp;</td>
			</tr>
		</table>

        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
            <thead>
				<tr>
					<th scope="col"><a>NO</a></th>
					<th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","REQ_CONT",strCommReqInfoSortField,strCommReqInfoSortMtd,"요구제목")%></th>
					<th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","OLD_REQ_ORGAN_NM",strCommReqInfoSortField,strCommReqInfoSortMtd,"신청기관")%></th>
					<th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","OPEN_CL",strCommReqInfoSortField,strCommReqInfoSortMtd,"공개등급")%></th>
					<th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","REG_DT",strCommReqInfoSortField,strCommReqInfoSortMtd,"신청일")%></th>
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
						<td align="center" height="20"><%=intRecordNumber%></td>
						<td>&nbsp;&nbsp;<%= StringUtil.getNotifyImg((String)objRs.getObject("REG_DT"), (String)objRs.getObject("REQ_STT")) %><a href="javascript:gotoDetail('<%=objRsSH.getObject("REQ_BOX_ID")%>','<%=objRs.getObject("REQ_ID")%>')" hint="<%= StringUtil.substring((String)objRs.getObject("REQ_DTL_CONT"), 80) %>"><%=objRs.getObject("REQ_CONT")%></a></td>
						<td align="center"><%=objRs.getObject("OLD_REQ_ORGAN_NM")%></td>
						<td align="center"><%=CodeConstants.getOpenClass((String)objRs.getObject("OPEN_CL"))%></td>
						<td width="65" align="right" style="padding-top:2px;padding-bottom:2px"><%=StringUtil.getDate2((String)objRs.getObject("REG_DT"))%></td>
					</tr>
					<%
				    intRecordNumber--;
					}//endwhile
				} else {
				%>
					<tr>
						<td colspan="5" height="35" align="center">등록된 요구정보가 없습니다.</td>
					</tr>
				<%
				}//endif
				%>
            </tbody>
			</table>

                <!-----------------------------------------  페이징 네비게이션 ---------------------------------------->
                <%=objPaging.pagingTrans(PageCount.getLinkedString(
                    new Integer(intTotalRecordCount).toString(),
                    new Integer(intCurrentPageNum).toString(),
                    objParams.getParamValue("CommReqInfoPageSize")))%>

        <div id="btn_all" >        <!-- 리스트 내 검색 -->
        <div class="list_ser" >
					<%
					String strCommReqInfoQryField=(String)objParams.getParamValue("CommReqInfoQryField");
					%>
					<select name="CommReqInfoQryField" class="select">
					<option <%=(strCommReqInfoQryField.equalsIgnoreCase("req_cont"))? " selected ": ""%>value="req_cont">요구 제목</option>
					<option <%=(strCommReqInfoQryField.equalsIgnoreCase("req_dtl_cont"))? " selected ": ""%>value="req_dtl_cont">요구내용</option>
					<option <%=(strCommReqInfoQryField.equalsIgnoreCase("old_req_organ_nm"))? " selected ": ""%>value="old_req_organ_nm">제출기관</option>
					</select>
					<input type="text" name="CommReqInfoQryTerm" value="<%=objParams.getParamValue("CommReqInfoQryTerm")%>"><img src="/images2/btn/bt_list_search.gif"  onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"  onClick="formName.submit()"/></div>
                    <!-- 버튼이 필요하다면 여기에 추가하심 됩니다용 -->
					<%
					/** 위원회 행정직원 일때만 화면에 출력함.*/
					if(objUserInfo.getOrganGBNCode().equals("004") && !strReqSubmitFlag.equals("004")){
					%>
                    <span class="right">
                    <span class="list_bt" onClick="gotoReqInfo();return false;"><a href="#">요구등록</a></span>
                    </span>
					<% } %>
        </div>
        </div>
        </div>
        </form>
    </div>
  <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>