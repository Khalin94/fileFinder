<%@ page language="java" contentType="text/html;charset=EUC-KR" %>

<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.bf.config.*"%>
<%@ page import="kr.co.kcc.pf.util.PageCount"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RPreReqBoxVListForm" %>
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
<%@ include file="../../../common/RUserCodeInfoInc.jsp" %>

<%
  //로그인 사용자 정보를 가져온다. 권한없음 경우 관람만 가능하다.
  String strReqSubmitFlag = objUserInfo.getReqSubmitFlag();

  String strSelectedAuditYear= null; /**선택된 감사년도*/

  /**일반 요구함 상세보기 파라미터 설정.*/
  RPreReqBoxVListForm objParams =new RPreReqBoxVListForm();
  objParams.setParamValue("ReqStt",CodeConstants.REQ_STT_NOT);/**미제출 요구정보목록.*/

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

 strSelectedAuditYear= objParams.getParamValue("AuditYear"); /**선택된 감사년도*/

 /*** Delegate 과 데이터 Container객체 선언 */
 PreRequestBoxDelegate objReqBox=null; 		/**요구함 Delegate*/
 PreRequestInfoDelegate  objReqInfo=null;	/** 요구정보 Delegate */
 ResultSetSingleHelper objRsSH=null;		/** 요구함 상세보기 정보 */
 ResultSetHelper objRs=null;				/**요구 목록 */
 ResultSetSingleHelper objRsInfo=null; //요구함 삭제 버튼을 보여주는 범위


 String strReqBoxID=null; // by yan
 try{
   /**요구함 정보 대리자 New */
   objReqBox=new PreRequestBoxDelegate();
   /**요구함 이용 권한 체크 */

   boolean blnHashAuth=objReqBox.checkReqBoxAuth((String)objParams.getParamValue("ReqBoxID"),objUserInfo.getOrganID()).booleanValue();
   //boolean blnHashAuth=objReqBox.checkReqBoxAuth((String)objParams.getParamValue("ReqBoxID"),(String)objParams.getParamValue("CmtOrganID")).booleanValue();
   if(!blnHashAuth){
      objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	  objMsgBean.setStrCode("DSAUTH-0001");
  	  objMsgBean.setStrMsg("해당 요구함을 볼 권한이 없습니다.");
  	  //out.println("해당 요구함을 볼 권한이 없습니다.");

  	%>
  	<!--jsp:forward page="/common/message/ViewMsg.jsp"/-->
  	<%
    out.print("<script>alert('해당요구함을 볼 권한이 없습니다.');history.back();</script>");
      return;
  }else{


    // 요구함 정보
    objRsSH=new ResultSetSingleHelper(objReqBox.getRecord((String)objParams.getParamValue("ReqBoxID")));

    //요구함 수정 추가사항 -by yan
    strReqBoxID=(String)objParams.getParamValue("ReqBoxID");


   // 요구 정보 대리자 New
    objReqInfo=new PreRequestInfoDelegate();
    objRs=new ResultSetHelper(objReqInfo.getRecordList(objParams));

    //요구함 삭제 버튼 보여주는 유무
    Hashtable objHashRsInfo=objReqInfo.getAnsCnt((String)objParams.getParamValue("ReqBoxID"));
    objRsInfo= new ResultSetSingleHelper(objHashRsInfo);

  }//권한 endif
 }catch(AppException objAppEx){
 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
	System.out.println("SysErrorCode:" + objAppEx.getStrErrCode());
  	objMsgBean.setStrCode("SYS-00010");//AppException에러.
  	objMsgBean.setStrMsg(objAppEx.getMessage());
  	//out.println("<br>Error!!!" + objAppEx.getMessage());
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%
  	return;
 }
%>
<%

 //요구정보 목록조회된 결과 반환.
 int intTotalRecordCount=objRs.getTotalRecordCount();
 int intCurrentPageNum=objRs.getPageNumber();
 int intTotalPage=objRs.getTotalPageCount();

%>
<jsp:include page="/inc/header.jsp" flush="true"/>
<link href="/css2/style.css" rel="stylesheet" type="text/css">
<script language="javascript">

  /**요구함 수정페이지로 가기.*/
  function gotoEdit(){
  	document.formName.target = "";
	document.formName.action="./RBasicReqBoxEdit.jsp";
  	document.formName.submit();
  }

  /**요구함 정보 삭제 */
  function gotoDel(){
	document.formName.target = "";
  	if(<%=objRs.getRecordSize()%>>0){
  		if(confirm("등록된 요구정보가 있습니다. \n\n 요구함 삭제를 수행하시면 등록된 요구정보가 같이 삭제됩니다.\n\n 삭제하시겠습니까?")==true){
	  		document.formName.action="./RBasicReqBoxDelProc.jsp";
  			document.formName.submit();
  		}//endif
  	}else{
  		if(confirm("등록된 요구함을 삭제 하시겠습니까?")==true){
	  		document.formName.action="./RBasicReqBoxDelProc.jsp";
  			document.formName.submit();
  		}//endif
  	}//endif
  }

  /** 정렬방법 바꾸기 */
  function changeSortQuery(sortField,sortMethod){
  	document.formName.ReqInfoSortField.value=sortField;
  	document.formName.ReqInfoSortMtd.value=sortMethod;
	document.formName.target = "";
  	document.formName.submit();
  }

  /** 목록으로 가기 */
  function gotoList(){
   	document.formName.action="./RBasicReqBoxList.jsp";
	document.formName.target = "";
  	document.formName.submit();
  }

  /** 페지징 바로가기 */
  function goPage(strPage){
  	document.formName.ReqInfoPage.value=strPage;
	document.formName.target = "";
  	document.formName.submit();
  }

   /** 요구등록페이지로 가기. */
  function gotoRegReqInfo(){
  	document.formName.action="./RBasicReqInfoWrite.jsp";
	document.formName.target = "";
  	document.formName.submit();
  }

  //요구정보 상세보기로 가기.
  function gotoDetail(strID){
  	document.formName.ReqInfoID.value=strID;
  	document.formName.action="./RBasicReqInfoVList.jsp";
    document.formName.target = "";
  	document.formName.submit();
  }

  //사전 요구 가져오기로 가기.
  function bringPre(){
  	NewWindow('RBasicReqInfoAppointList.jsp?ReqBoxID=<%=objRsSH.getObject("REQ_BOX_ID")%>&CmtOrganID=<%=objRsSH.getObject("CMT_ORGAN_ID")%>&SubmtOrganID=<%=objRsSH.getObject("SUBMT_ORGAN_ID")%>&CmtOrganNM=<%=objRsSH.getObject("CMT_ORGAN_NM")%>&SubmtOrganNM=<%=objRsSH.getObject("SUBMT_ORGAN_NM")%>&AuditYear=<%=objRsSH.getObject("AUDIT_YEAR")%>&RltdDuty=<%=objRsSH.getObject("RLTD_DUTY")%>&ReturnUrl=<%=request.getRequestURI()%>','', '660', '560');
  }


   /** 일반 요구정보 일괄 삭제 */
  function delPreReqInfos(formName){
     //요구 목록 내용 체크 확인.
  	if(hashCheckedReqInfoIDs(formName)==false) return false;
  	if(confirm("선택하신 요구정보를 삭제하시겠습니까?\n\n선택하신 요구내용중 본인이 작성한 요구내용만 삭제됩니다.")){
  		document.formName.action="./RBasicReqInfoDelArrProc.jsp";
		document.formName.target = "";
  		document.formName.submit();
  	}else{
  		return false;
  	}
  }

    /** 요구함 복사 */
  function copyPreReqBox(){
  	if(confirm("해당요구함을 복사하시겠습니까?")){
  	NewWindow('/reqsubmit/common/PreReqBoxCopyList.jsp?ReqBoxID='+ formName.ReqBoxID.value+'&CmtOrganID=<%=objRsSH.getObject("CMT_ORGAN_ID")%>&CmtOrganNM=<%=objRsSH.getObject("CMT_ORGAN_NM")%>','', '530', '410');
  	}
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
	<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>
    </div>
    <div id="rightCon">
<form name="formName" method="<%=nads.lib.reqsubmit.EnvConstants.FORM_METHOD%>" action="<%=request.getRequestURI()%>"><!--요구함 신규정보 전달 -->
				<%//요구함 정렬 정보 받기.
				  String strReqBoxSortField=objParams.getParamValue("ReqBoxSortField");
				  String strReqBoxSortMtd=objParams.getParamValue("ReqBoxSortMtd");
				  //요구함 페이지 번호 받기.
			      String strReqBoxPagNum=objParams.getParamValue("ReqBoxPage");
				  //요구함 조회정보 받기.
				  String strReqBoxQryField=objParams.getParamValue("ReqBoxQryField");
				  String strReqBoxQryTerm=objParams.getParamValue("ReqBoxQryTerm");
				  //요구 정보 정렬 정보 받기.
				  String strReqInfoSortField=objParams.getParamValue("ReqInfoSortField");
				  String strReqInfoSortMtd=objParams.getParamValue("ReqInfoSortMtd");
				  //요구함 정보 페이지 번호 받기.
				  String strReqInfoPagNum=objParams.getParamValue("ReqInfoPage");
				  //요구조회히든태그없애기위해.
				  objParams.getFormElement("ReqInfoQryField").setFormTagType(nads.lib.reqsubmit.form.FormElement.FORM_TAG_TYPE_SESSION);
				  objParams.getFormElement("ReqInfoQryTerm").setFormTagType(nads.lib.reqsubmit.form.FormElement.FORM_TAG_TYPE_SESSION);
		    	 %>
		         <%=objParams.getHiddenFormTags()%>
		         <input type="hidden" name="ReqBoxNm" value="<%=objRsSH.getObject("REQ_BOX_NM")%>"><!--되돌아올 URL -->
			     <input type="hidden" name="ReturnUrl" value="<%=request.getRequestURI()%>"><!--되돌아올 URL -->

      <!-- pgTit -->

      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=MenuConstants.REQ_BOX_PRE%></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.REQUEST_BOX_PRE%> > <%=MenuConstants.REQ_BOX_PRE%></div>
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

        <!-- 상단 버튼 시작-->
         <div class="top_btn">
			<samp>
		<%
		//권한 없음
		if(!strReqSubmitFlag.equals("004")){
		  if(objUserInfo.getOrganGBNCode().equals("004") ){
		%>

			<%//요구함 삭제 버튼:기초자료요구함에서는 요구함 요구에 답변이 있는 경우에는 요구함 삭제가 이루어지지 않는다.
				if(objRsInfo.next()){
					String strAnsCnt = (String)objRsInfo.getObject("ANS_CNT_TOTAL");
					if(strAnsCnt.equals("0") || strAnsCnt.equals("")){
			%>
		<!-- 요구함 수정 -->
			 <span class="btn"><a href="#" onclick="javascript:gotoEdit()">요구함 수정</a></span>
			 <span class="btn"><a href="#" onclick="javascript:gotoDel()">요구함 삭제</a></span>
			<%
					}
				}
			%>
			<!-- 요구함 복사 -->
			 <span class="btn"><a href="javascript:copyPreReqBox(formName)">요구함 복사</a></span>
			<%
			 }//end if
			} //end if 권한없음에 관련
			%>
			<!-- 요구함 목록 -->
			 <span class="btn"><a href="javascript:gotoList()">요구함 목록</a></span>
			 </samp>
		 </div>

        <!-- /상단 버튼 끝-->

        <table border="0" cellspacing="0" cellpadding="0" width="680" class="list02">
		<%
			//요구함 진행 상태.
			String strReqBoxStt=(String)objRsSH.getObject("REQ_BOX_STT");

		%>
            <tr>
                <th height="25">&bull; 위원회 </th>
                <td height="25" colspan="3"><strong><%=objRsSH.getObject("CMT_ORGAN_NM")%></strong></td>
            </tr>
            <tr>
                <th height="25">&bull; 요구함명 </th>
                <td height="25" colspan="3"><%=objRsSH.getObject("REQ_BOX_NM")%></td>
            </tr>
            <tr>
                <th height="25">&bull; 업무구분 </th>
                <td height="25"><%=objCdinfo.getRelatedDuty((String)objRsSH.getObject("RLTD_DUTY"))%></td>
                <th height="25">&bull; 제출기관 </th>
                <td height="25"><%=(String)objRsSH.getObject("SUBMT_ORGAN_NM")%></td>

            </tr>
            <tr>
                <th height="25" width="120">&bull; 제출기한 </th>
                <td height="25" width="220"><%=StringUtil.getDate((String)objRsSH.getObject("SUBMT_DLN"))%></td>
                <th height="25" width="120">&bull;&nbsp;등록일자 </th>
                <td height="25" width="220"><%=StringUtil.getDate((String)objRsSH.getObject("REG_DT"))%></td>
            </tr>
            <tr>
                <th height="25">&bull; 요구함설명 </th>
                <td height="25" colspan="3">
				<%=StringUtil.getDescString((String)objRsSH.getObject("REQ_BOX_DSC"))%>
				</td>
            </tr>
        </table><br><br>
        <!-- /list view -->
        <!--<p class="warning mt10">* 요구서 발송 : 의원실(또는 소속기관) 명의로 해당 제출기관에 요구서를 발송합니다.</p>  -->


        <!-- list -->
        <span class="list01_tl">요구목록 <span class="list_total">&bull;&nbsp;전체자료수 : <%= intTotalRecordCount %>개 </span></span>

			<table width="100%" style="padding:0;">
			   <tr>
				<td>&nbsp;</td>
			   </tr>
			 </table>


        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
          <thead>
            <tr>
			<%if(objUserInfo.getOrganGBNCode().equals("004")){%>
               <th scope="col">
			  <input type="checkbox" name="checkAll" value="" onClick="checkAllOrNot(document.formName);" class="borderNo"/>
			  </th>
			  <% } %>
              <th scope="col"><a>NO</a></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","REQ_CONT",strReqInfoSortField,strReqInfoSortMtd,"요구제목")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","OPEN_CL",strReqInfoSortField,strReqInfoSortMtd,"공개등급")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","REQ_STT",strReqInfoSortField,strReqInfoSortMtd,"제출상태")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","REG_DT",strReqInfoSortField,strReqInfoSortMtd,"등록일자")%></th>
            </tr>
          </thead>
          <tbody>
		<%
			int intRecordNumber= intTotalRecordCount - ((intCurrentPageNum -1) * Integer.parseInt((String)objParams.getParamValue("ReqInfoPageSize")));
			if(objRs.getRecordSize()>0){
				String strReqInfoID="";
				while(objRs.next()){
				strReqInfoID=(String)objRs.getObject("REQ_ID");
		 %>
            <tr>
			<% if(objRs.getObject("LAST_ANS_DT")== null){
				if(objUserInfo.getOrganGBNCode().equals("004")){
			%>
			  <td><input type="checkbox" name="ReqInfoIDs" value="<%= strReqInfoID %>" class="borderNo"/></td>
			  <%			}%>
              <td><%=intRecordNumber%></td>
              <td style="text-align:left;"><a href="JavaScript:gotoDetail('<%=strReqInfoID%>');"><%=StringUtil.substring((String)objRs.getObject("REQ_CONT"),35)%></a></td>

              <td><%=CodeConstants.getOpenClass((String)objRs.getObject("OPEN_CL"))%></td>
              <td><%=CodeConstants.getRequestStatus((String)objRs.getObject("REQ_STT"))%></td>
              <td><%=StringUtil.getDate((String)objRs.getObject("REG_DT"))%></td>
			  <% }else {
					if(objUserInfo.getOrganGBNCode().equals("004")){%>
              <td><input type="checkbox" name="ReqInfoIDs" value="<%= strReqInfoID %>" class="borderNo" disabled/></td>
			  <%			}%>
			  <td><%=intRecordNumber%></td>
              <td><a href="JavaScript:gotoDetail('<%=strReqInfoID%>');"><%=StringUtil.substring((String)objRs.getObject("REQ_CONT"),35)%></a></td>
			  <td><%=CodeConstants.getOpenClass((String)objRs.getObject("OPEN_CL"))%></td>
			  <td><%=CodeConstants.getRequestStatus((String)objRs.getObject("REQ_STT"))%></td>
			  <td><%=StringUtil.getDate((String)objRs.getObject("REG_DT"))%></td>
			  <% }%>
            </tr>
		<%

				intRecordNumber --;
			}//endwhile

		}else{
		%>
            <tr>
				<td colspan="6" align="center"> 등록된 요구정보가 없습니다.</td>
            </tr>
		<%
		}//end if 목록 출력 끝.
		%>

          </tbody>
        </table>

				<%=objPaging.pagingTrans(PageCount.getLinkedString(
							new Integer(intTotalRecordCount).toString(),
							new Integer(intCurrentPageNum).toString(),
							objParams.getParamValue("ReqInfoPageSize")))%>


		<div id="btn_all" >        <!-- 리스트 내 검색 -->
        <div class="list_ser" >
		<%
			String strReqInfoQryField=(String)objParams.getParamValue("ReqInfoQryField");
		%>
          <select name="ReqInfoQryField" class="selectBox5"  style="width:70px;" >
			  <option <%=(strReqInfoQryField.equalsIgnoreCase("req_cont"))? " selected ": ""%>value="req_cont">요구제목</option>
			  <option <%=(strReqInfoQryField.equalsIgnoreCase("req_dtl_cont"))? " selected ": ""%>value="req_dtl_cont">요구내용</option>
          </select>
          <input name="ReqInfoQryTerm" onKeyDown="return ch()" onMouseDown="return ch()"
		 class="li_input"  style="width:100px" value="<%=objParams.getParamValue("ReqInfoQryTerm")%>"/>
          <img src="/images2/btn/bt_list_search.gif"  onMouseOver="menuOn(this);" onMouseOut="menuOut(this);" onClick="formName.submit();"/> </div>
        <!-- /리스트 내 검색 -->

			<span class="right">
				<%
				  if(objUserInfo.getOrganGBNCode().equals("004")){
				%>
				<span class="list_bt"><a href="javascript:gotoRegReqInfo()">요구등록</a></span>
				<span class="list_bt"><a href="javascript:bringPre()">사전요구가져오기</a></span>
				<%
					if(objRs.getRecordSize()>0 ){/**요구목록이있을경우만 출력*/
				%>
				<span class="list_bt"><a href="javascript:delPreReqInfos(formName);">요구삭제</a></span>
				<%
					}//endif
				%>
				<%
				 }//endif - first
				%>
			</span>
		</div>
        <!-- /각페이지 내용 -->
      </div>
</form>
      <!-- /contents -->

    </div>
  </div>
  <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>