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
<%@ page import="nads.lib.reqsubmit.params.requestinfo.RPreReqInfoListViewForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.prereqinfo.PreRequestInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.answerinfo.PreAnswerInfoDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
 UserInfoDelegate objUserInfo =null;
 CDInfoDelegate objCdinfo =null;
%>
<%@ include file="../../../../common/RUserCodeInfoInc.jsp" %>

<%
 /*************************************************************************************************/
 /** 					파라미터 체크 Part 														  */
 /*************************************************************************************************/
  //로그인 사용자 정보를 가져온다. 권한없음 경우 관람만 가능하다.
  String strReqSubmitFlag = objUserInfo.getReqSubmitFlag();


  /**일반 요구함 상세보기 파라미터 설정.*/
  RPreReqInfoListViewForm objParams =new RPreReqInfoListViewForm();
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
%>
<%
 /*************************************************************************************************/
 /** 					데이터 호출 Part 														  */
 /*************************************************************************************************/

 /*** Delegate 과 데이터 Container객체 선언 */
 PreRequestInfoDelegate  objReqInfo=null;	/** 요구정보 Delegate */
 ResultSetSingleHelper objInfoRsSH=null;	/**요구 정보 상세보기 */
 ResultSetHelper objRs=null;				/** 답변정보 목록 출력*/
 try{
   /**요구함 정보 대리자 New */
   objReqInfo=new PreRequestInfoDelegate();
    //임시방편 권한 문제에 봉착하였다..생각하자 음....어찌 권한을 해결할것인가??? -by yan 2004.04.08
   /**요구함 이용 권한 체크 */
   boolean blnHashAuth=objReqInfo.checkReqInfoAuth((String)objParams.getParamValue("ReqInfoID"),(String)objParams.getParamValue("CmtOrganID")).booleanValue();

   if(!blnHashAuth){
      objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	  objMsgBean.setStrCode("DSAUTH-0001");
  	  objMsgBean.setStrMsg("해당 요구정보를 볼 권한이 없습니다.");
  	  //out.println("해당 요구정보를 볼 권한이 없습니다.");
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%
      return;
  }else{

    objInfoRsSH=new ResultSetSingleHelper(objReqInfo.getRecord((String)objParams.getParamValue("ReqInfoID")));

    //out.println("ReqInfoID");
    objRs=new ResultSetHelper(new PreAnswerInfoDelegate().getRecordList((String)objParams.getParamValue("ReqInfoID"),"Y"));/**제출만 Y */
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
 /*************************************************************************************************/
 /** 					데이터 값 할당  Part 														  */
 /*************************************************************************************************/


%>
<jsp:include page="/inc/header.jsp" flush="true"/>
<script language="javascript">

  /** 목록으로 가기 */
  function gotoList(){
  	formName.action="./RNonPreReqInfoList.jsp";
  	formName.submit();
  }
  /** 요구 이력보기 */
  function viewReqHistory() {
  	alert('요구이력보기');
  }
  /** 공식요구지정 */
  function appointCmtReq(){
  	alert('공식요구지정');
  }


</script>
<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>
</head>

<body>
<div id="wrap">
  <jsp:include page="/inc/top.jsp" flush="true"/>
  <jsp:include page="/inc/top_menu02.jsp" flush="true"/>
  <div id="container">
    <div id="leftCon">
      <jsp:include page="/inc/log_info.jsp" flush="true"/>
      <jsp:include page="/inc/left_menu02.jsp" flush="true"/>
    </div>
    <div id="rightCon">
<form name="formName" method="get" action="<%=request.getRequestURI()%>"><!--요구함 신규정보 전달 -->
			<%
			//요구 정보 정렬 정보 받기.
			String strReqInfoSortField=objParams.getParamValue("ReqInfoSortField");
			String strReqInfoSortMtd=objParams.getParamValue("ReqInfoSortMtd");
			//요구 정보 페이지 번호 받기.
			String strReqInfoPagNum=objParams.getParamValue("ReqInfoPage");
		    %>
			<input type="hidden" name="ReqInfoSortField" value="<%=objParams.getParamValue("ReqInfoSortField")%>"><!--요구정보 목록정렬필드 -->
			<input type="hidden" name="ReqInfoSortMtd" value="<%=objParams.getParamValue("ReqInfoSortMtd")%>"><!--요구정보 목록정령방법-->
			<input type="hidden" name="ReqInfoQryField" value="<%=objParams.getParamValue("ReqInfoQryField")%>"><!--요구정보 조회 필드-->
			<input type="hidden" name="ReqInfoQryTerm" value="<%=objParams.getParamValue("ReqInfoQryTerm")%>"><!--요구정보 조회어-->
			<input type="hidden" name="ReqInfoPage" value="<%=objParams.getParamValue("ReqInfoPage")%>"><!--요구정보 페이지 번호 -->
			<input type="hidden" name="ReqInfoID" value="<%=objParams.getParamValue("ReqInfoID")%>"><!--요구정보 ID-->
			<input type="hidden" name="AnsInfoID" value=""><!--답변정보ID -->

      <!-- pgTit -->

      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=MenuConstants.REQ_INFO_LIST_SUBMT_NONE%><span class="sub_stl" >- <%=MenuConstants.REQ_INFO_DETAIL_VIEW%></span></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> >   <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%>  > <%=MenuConstants.REQUEST_BOX_COMM%> > <%=MenuConstants.REQUEST_BOX_PRE%> > <%=MenuConstants.REQ_INFO_LIST_SUBMT_NONE%></div>
        <p>제출기관에서 답변한 요구 정보 목록을 확인하는 화면입니다. </p>
      </div>
      <!-- /pgTit -->

      <!-- contents -->

      <div id="contents">

        <!-- 검색조건 없는 경우 아래 div 삭제 나 주석으로 막으세요.-->
        <!-- /검색조건-->


        <!-- 각페이지 내용 -->
         <!-- list view-->

        <span class="list02_tl">요구 정보 </span>
        <table border="0" cellspacing="0" cellpadding="0" width="680" class="list02">

            <tr>
                <th height="25">&bull; 위원회 </th>
                <td height="25" colspan="3"><strong><%=objInfoRsSH.getObject("CMT_ORGAN_NM")%></strong></td>
            </tr>
            <tr>
                <th height="25">&bull; 요구함명 </th>
                <td height="25" colspan="3"><%=objInfoRsSH.getObject("REQ_BOX_NM")%></td>
            </tr>
            <tr>
                <th height="25">&bull; 제출기관 </th>
                <td height="25" ><%=(String)objInfoRsSH.getObject("SUBMT_ORGAN_NM")%></td>
                <th height="25" width="120">&bull; 요구기관 </th>
                <td height="25" width="220"><%=(String)objInfoRsSH.getObject("REQ_ORGAN_NM")%></td>
            </tr>
            <tr>
                <th height="25">&bull; 요구제목 </th>
                <td height="25" colspan="3">
				<%=StringUtil.getDescString((String)objInfoRsSH.getObject("REQ_CONT"))%>
				</td>
            </tr>
            <tr>
                <th height="25">&bull; 요구내용 </th>
                <td height="25" colspan="3">
				<%=StringUtil.getDescString((String)objInfoRsSH.getObject("REQ_DTL_CONT"))%>
				</td>
            </tr>
            <tr>
                <th height="25">&bull; 공개등급 </th>
                <td height="25">
				<%=CodeConstants.getOpenClass((String)objInfoRsSH.getObject("OPEN_CL"))%>
				</td>
				<th height="25">&bull; 첨부파일 </th>
                <td height="25">
				<%=StringUtil.makeAttachedFileLink((String)objInfoRsSH.getObject("ANS_ESTYLE_FILE_PATH"),(String)objInfoRsSH.getObject("REQ_ID"))%>
				</td>
            </tr>
            <tr>
                <th height="25">&bull; 등록자 </th>
                <td height="25">
				<%=(String)objInfoRsSH.getObject("REGR_NM")%>
				</td>
				<th height="25">&bull; 등록일자 </th>
                <td height="25">
				<%=StringUtil.getDate((String)objInfoRsSH.getObject("REG_DT"))%>
				</td>
            </tr>
        </table>
        <!-- /list view -->
        <!--<p class="warning mt10">* 요구서 발송 : 의원실(또는 소속기관) 명의로 해당 제출기관에 요구서를 발송합니다.</p>  -->
        <!-- 리스트 버튼-->
         <div id="btn_all"class="t_right">
		<%
		//권한 없음
		 if(!strReqSubmitFlag.equals("004")){

			//요구함상태가 결재중이면 이동 수정 삭제가 불가능해짐.
            String strReqBoxStt = (String)objInfoRsSH.getObject("REQ_BOX_STT");
			if(!strReqBoxStt.equals(CodeConstants.REQ_BOX_STT_004)){
		%>
		  <%
			/** 등록자와  로그인자가 같을때만 화면에 출력함.*/
			//if(objUserInfo.getUserID().equals((String)objInfoRsSH.getObject("REGR_ID"))){
				if(objUserInfo.getOrganGBNCode().equals("004")){
		  %>
			 <span class="list_bt"><a href="javascript:viewReqHistory('<%=objParams.getParamValue("ReqInfoID")%>')">요구이력보기</a></span>
			  <%      }

		  } // 권한없음에 관련 %>
			 <span class="list_bt"><a href="javascript:gotoList()">요구목록</a></span>
			  <%
				//}//endif
			  %>
			<%
			}//end if


			%>

<!--			 <span class="list_bt"><a href="#">요구이력보기</a></span>
			 <span class="list_bt"><a href="#">요구목록</a></span>
-->
		 </div>

        <!-- /리스트 버튼-->

        <!-- list -->

        <!-- /list -->


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