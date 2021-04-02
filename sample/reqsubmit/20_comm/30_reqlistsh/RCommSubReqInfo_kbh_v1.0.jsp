<%@ page language="java" contentType="text/html;charset=EUC-KR" %>

<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="java.util.*"%>
<%@ page import="nads.lib.message.MessageBean"%>
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

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
 UserInfoDelegate objUserInfo =null;
 CDInfoDelegate objCdinfo =null;
%>
<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>

<%
  /**일반 요구함 상세보기 파라미터 설정.*/
  RCommReqBoxVListForm objParams =new RCommReqBoxVListForm();
  objParams.setParamValue("IsRequester",String.valueOf(objUserInfo.isRequester()));//요구답변자여부설정

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
 CommAnsInfoDelegate objAnsInfo = new CommAnsInfoDelegate();
 ResultSetSingleHelper objRsSH=null;			/** 요구함 상세보기 정보 */
 ResultSetSingleHelper objRsRI=null;			/** 요구 상세보기 정보 */
 ResultSetHelper objRs = null;					/** 답변 목록 */

 try{
   /**요구함 정보 대리자 New */
   objReqBox=new CommRequestBoxDelegate();
   /** 요구함 정보 */
    objRsSH=new ResultSetSingleHelper(objReqBox.getRecord((String)objParams.getParamValue("ReqBoxID")));
   /**요구 정보 대리자 New */
    objReqInfo=new CommRequestInfoDelegate();
	objRsRI=new ResultSetSingleHelper(objReqInfo.getRecord((String)request.getParameter("ReqInfoID")));
   	// 답변 목록을 SELECT 한다.
   	objRs = new ResultSetHelper(objAnsInfo.getRecordList((String)request.getParameter("ReqInfoID")));
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
<jsp:include page="/inc/header.jsp" flush="true"/>
<script language="javascript">
	// 답변 상세보기로 가기
  	function gotoDetail(strID){
  		//window.open('/reqsubmit/common/SAnsInfoView.jsp?returnURL=POPUP&AnsID='+strID, '', 'width=520,height=400, scrollbars=no, resizable=yes, toolbar=no, menubar=no, location=no, directories=no, status=no');
  		NewWindow('/reqsubmit/common/SAnsInfoView.jsp?returnURL=POPUP&AnsID='+strID, '', 520, 400);
  	}

  	// 제출된 요구목록으로 가기
  	function gotoList(){
  		f = document.formName;
  		f.action="RCommSubReqList.jsp";
  		f.submit();
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
	<SCRIPT language="JavaScript" src="/js/reqsubmit/reqinfo.js"></SCRIPT>
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
		    <input type="hidden" name="CmtOrganID" value="<%=objParams.getParamValue("CmtOrganID")%>">
		    <input type="hidden" name="ReqInfoID" value="<%=(String)request.getParameter("ReqInfoID")%>">
		    <input type="hidden" name="AuditYear" value="<%=objParams.getParamValue("AuditYear")%>">
			<input type="hidden" name="RltdDuty" value="<%=objParams.getParamValue("RltdDuty")%>">
			<input type="hidden" name="ReturnUrl" value="<%=request.getRequestURI()%>?ReqBoxID=<%=(String)objParams.getParamValue("ReqBoxID")%>&ReqID=<%=(String)request.getParameter("ReqInfoID")%>&AuditYear=<%=objParams.getParamValue("AuditYear")%>">
			<input type="hidden" name="Rsn" value="">

      <!-- pgTit -->

      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=MenuConstants.REQ_INFO_LIST_SUBMT_DONE%><span class="sub_stl" >- 요구상세보기</span></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> > <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.REQUEST_BOX_COMM%> > <%=MenuConstants.REQ_INFO_LIST_SUBMT_DONE%></div>
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
        <table border="0" cellspacing="0" cellpadding="0" width="680" class="list02">
		<%
			if(!objRsRI.next()){
		%>
			<tr>
				<td height="45" colspan="4">요구 정보 가 없습니다.</td>
			</tr>
		<%
			}else{
		%>
            <tr>
                <th height="25">&bull; 요구제목 </th>
                <td height="25" colspan="3"><strong><%=objRsRI.getObject("REQ_CONT")%></strong></td>
            </tr>
            <tr>
                <th height="25">&bull; 요구내용 </th>
                <td height="25" colspan="3">- <%=StringUtil.getDescString((String)objRsRI.getObject("REQ_DTL_CONT"))%>
               	<%=nads.dsdm.app.reqsubmit.delegate.requestinfo.RequestInfoDelegate.getAppendRequestInfo((List)objRsRI.getObject("TBDS_REQ_LOG"))%>     </td>
            </tr>
            <%
				if(!objRsSH.next()){
			%>
			<tr>
				<td height="25" colspan="4">요구함 정보 가 없습니다.</td>
			</tr>
			<%
				}else{
			%>
            <tr>
			<%
				//요구함 진행 상태.
				String strIngStt=(String)objRsSH.getObject("ING_STT");
			%>
                <th height="25">&bull; 요구함명 </th>
                <td height="25" colspan="3"><%=objRsSH.getObject("REQ_BOX_NM")%> </td>
            </tr>
            <tr>
                <th height="25" width="120">&bull; 요구기관 </th>
                <td height="25" width="220"><%=objRsSH.getObject("CMT_ORGAN_NM")%> (<%=(String)objInfoRsSH.getObject("USER_NM")%>) </td>
                <th height="25" width="120">&bull;&nbsp;제출기관 </th>
                <td height="25" width="220"><%=(String)objRsSH.getObject("SUBMT_ORGAN_NM")%></td>
            </tr>
            <tr>
                <th height="25">&bull; 접수시작 </th>
                <td height="25">
				<%=StringUtil.getDate((String)objRsSH.getObject("ACPT_BGN_DT"))%>
				</td>
                <th height="25">&bull;&nbsp;접수마감</th>
                <td height="25"> <span class="list_bts"><%=StringUtil.getDate((String)objRsSH.getObject("ACPT_END_DT"))%></span></td>
            </tr>
			<%
			}/** 요구함 정보 가 있으면. */
			%>
            <tr>
                <th height="25">&bull; 요구일시 </th>
                <td height="25">
				<%=StringUtil.getDate2((String)objRsRI.getObject("LAST_REQ_DT"))%>
				</td>
                <th height="25">&bull;&nbsp;답변일시</th>
                <td height="25"> <span class="list_bts"><%=StringUtil.getDate2((String)objRsRI.getObject("LAST_ANS_DT"))%></span></td>
            </tr>
            <tr>
                <th height="25">&bull; 공개등급 </th>
                <td height="25">
				<%=CodeConstants.getOpenClass((String)objRsRI.getObject("OPEN_CL"))%>
				</td>
                <th height="25">&bull;&nbsp;업무구분</th>
                <td height="25"> <span class="list_bts"><%=objCdinfo.getRelatedDuty((String)objRsSH.getObject("RLTD_DUTY"))%></span></td>
            </tr>
            <tr>
                <th height="25">&bull; 제출파일양식 </th>
                <td height="25" colspan="3">
				<%=StringUtil.makeAttachedFileLink((String)objRsRI.getObject("ANS_ESTYLE_FILE_PATH"),(String)objRsRI.getObject("REQ_ID"))%>
				</td>
            </tr>
            <tr>
                <th height="25">&bull; 신청기관 </th>
                <td height="25">
				<%=objRsRI.getObject("OLD_REQ_ORGAN_NM")%>
				</td>
                <th height="25">&bull;&nbsp;신청자</th>
                <td height="25"> <span class="list_bts"><%=objRsRI.getObject("REGR_NM")%></span></td>
            </tr>
        </table>
        <!-- /list view -->
        <!--<p class="warning mt10">* 요구서 발송 : 의원실(또는 소속기관) 명의로 해당 제출기관에 요구서를 발송합니다.</p>  -->
        <!-- 리스트 버튼-->
         <div id="btn_all"class="t_right">
			 <span class="list_bt"><a href="viewReqHistory('<%= strReqID %>')">요구 이력 보기</a></span>
			 <span class="list_bt"><a href="gotoList()">요구목록</a></span>
<!--			 <span class="list_bt"><a href="#">요구이력보기</a></span>
			 <span class="list_bt"><a href="#">요구목록</a></span>
-->
		 </div>

        <!-- /리스트 버튼-->

        <!-- list -->
        <span class="list01_tl">답변목록 <span class="list_total">&bull;&nbsp;전체자료수 : <%= objRs.getRecordSize() %>개 </span></span>




        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
          <thead>
            <tr>
               <th scope="col">
			  <input type="checkbox" name="checkAll" value="" onClick="javascript:checkAllOrNot(this.form)" class="borderNo"/>
			  </th>
              <th scope="col">NO</th>
              <th scope="col" style="width:40%; ">제출의견</th>
              <th scope="col">작성자</th>
              <th scope="col">공개</th>
               <th scope="col">답변</th>
              <th scope="col">답변일자</th>
            </tr>
          </thead>
          <tbody>
			<%
				int intRecordNumber=1;
				String strAnsInfoID="";
				if (objRs.getRecordSize() > 0) {
					while(objRs.next()) {
						strAnsInfoID=(String)objRs.getObject("ANS_ID");
			 %>
            <tr>
			  <td><input type="checkbox" name="AnsID" value="<%= strAnsInfoID %>" class="borderNo"/></td>
              <td><%=intRecordNumber%></td>
              <td style="text-align:left;"><a href="JavaScript:gotoDetail('<%=strAnsInfoID%>');"><%=StringUtil.substring((String)objRs.getObject("ANS_OPIN"),35)%></a></td>

              <td><%=(String)objRs.getObject("USER_NM")%></td>
              <td><%=CodeConstants.getOpenClass(((String)objRs.getObject("OPEN_CL")))%></td>
              <td><%=nads.lib.reqsubmit.util.DBAccessUtil.makeAnsInfoHtml(strAnsInfoID,(String)objRs.getObject("ANS_MTD"))%></td>
              <td><%=StringUtil.getDate2((String)objRs.getObject("ANS_DT"))%></td>

            </tr>
			<%
						intRecordNumber ++;
					} // endwhile
				} else {
			%>
            <tr>
				<td colspan="6" align="center"> 등록된 답변이 없습니다.</td>
            </tr>
			<%
				}
//추가 답변 등록			%>

          </tbody>
        </table>
		<%
			if(CodeConstants.REQ_STT_ADD.equals((String)objInfoRsSH.getObject("REQ_STT"))) {
		%>
         <div id="btn_all"class="t_right">
			 <span class="list_bt"><a href="javascript:goSbmtReqForm()" onfocus="this.blur()">추가 답변 등록</a></span>
		</div>
		<%
			}
		%>

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