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
<%@ page import="nads.lib.reqsubmit.params.requestinfo.RPreReqInfoVListForm" %>
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
<%@ include file="../../../common/RUserCodeInfoInc.jsp" %>

<%
 /*************************************************************************************************/
 /** 					파라미터 체크 Part 														  */
 /*************************************************************************************************/
  //로그인 사용자 정보를 가져온다. 권한없음 경우 관람만 가능하다.
  String strReqSubmitFlag = objUserInfo.getReqSubmitFlag();


  /**일반 요구 상세보기 파라미터 설정.*/
  RPreReqInfoVListForm objParams =new RPreReqInfoVListForm();
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
 ResultSetSingleHelper objInfoRsSH=null;		/**요구 정보 상세보기 */

 ResultSetHelper objRs=null;				/** 답변정보 목록 출력*/

 try{
   /**요구 정보 대리자 New */
    objReqInfo=new PreRequestInfoDelegate();
   /**요구정보 이용 권한 체크 */
   //권한 체크에 대해서 생각해봐야한다..아직 안됐다....-by yan 2004.04.08

   //boolean blnHashAuth=objReqInfo.checkReqInfoAuth((String)objParams.getParamValue("ReqInfoID"),objUserInfo.getOrganID()).booleanValue();
   boolean blnHashAuth=objReqInfo.checkReqInfoAuth((String)objParams.getParamValue("ReqInfoID"),(String)objParams.getParamValue("CmtOrganID")).booleanValue();
   //out.println("info: "+blnHashAuth);
   if(!blnHashAuth){
      objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	  objMsgBean.setStrCode("DSAUTH-0001");
  	  objMsgBean.setStrMsg("해당 요구함을 볼 권한이 없습니다.");
  	  //out.println("해당 요구함을 볼 권한이 없습니다.");
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%
      return;
  }else{

    objInfoRsSH=new ResultSetSingleHelper(objReqInfo.getRecord((String)objParams.getParamValue("ReqInfoID")));

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
<link href="/css/System.css" rel="stylesheet" type="text/css">
<script language="javascript">
<!--

  /**답변정보 상세보기로 가기.*/
  function gotoDetail(strID){
  window.open('/reqsubmit/common/SAnsInfoView.jsp?returnURL=POPUP&ReqBoxID=<%=objParams.getParamValue("ReqBoxID")%>&ReqID=<%=objParams.getParamValue("ReqInfoID")%>&AnsID='+strID, '', 'width=500,height=400, scrollbars=no, resizable=yes, toolbar=no, menubar=no, location=no, directories=no, status=no');
  }

  /**요구정보 수정페이지로 가기.*/
  function gotoEditPage(){
  	formName.action="./RBasicReqInfoEdit.jsp";
  	formName.submit();
  }
  /**요구 정보 삭제 */
  function gotoDeletePage(){
  	if(confirm('선택하신 요구정보를 삭제하시겠습니까?')){
	  	formName.action="./RBasicReqInfoDelProc.jsp";
  		formName.submit();
  	}
  }
  /** 요구함 보기  */
  function gotoBoxView(){
  	formName.action="./RBasicReqBoxVList.jsp?ReqBoxID=<%=objParams.getParamValue("ReqBoxID")%>&CmtOrganID=<%=objParams.getParamValue("CmtOrganID")%>";
  	formName.submit();
  }

 //-->
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
	<SCRIPT language="JavaScript" src="/js/reqsubmit/reqinfo.js"></SCRIPT>
	<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>
    </div>
    <div id="rightCon">
          <form name="formName" method="post" action="<%=request.getRequestURI()%>"><!--요구함 신규정보 전달 -->
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
			//요구 정보 페이지 번호 받기.
			String strReqInfoPagNum=objParams.getParamValue("ReqInfoPage");
		    %>

			<input type="hidden" name="ReqBoxID" value="<%=objParams.getParamValue("ReqBoxID")%>">
			<input type="hidden" name="CmtOrganID" value="<%=objParams.getParamValue("CmtOrganID")%>">
			<input type="hidden" name="ReqBoxSortField" value="<%=strReqBoxSortField%>"><!--요구함목록정렬필드 -->
			<input type="hidden" name="ReqBoxSortMtd" value="<%=strReqBoxSortMtd%>"><!--요구함목록정령방법-->
			<input type="hidden" name="ReqBoxPage" value="<%=strReqBoxPagNum%>"><!--요구함 페이지 번호 -->
			<%if(StringUtil.isAssigned(strReqBoxQryField)){%>
			<input type="hidden" name="ReqBoxQryField" value=""><!--요구함 조회필드 -->
			<input type="hidden" name="ReqBoxQryTerm" value=""><!--요구함 조회필드 -->
			<%}//요구함 조회어가 있는 경우만 출력해서 사용함.%>
			<input type="hidden" name="ReqInfoSortField" value="<%=strReqInfoSortField%>"><!--요구정보 목록정렬필드 -->
			<input type="hidden" name="ReqInfoSortMtd" value="<%=strReqInfoSortMtd%>"><!--요구정보 목록정령방법-->
			<input type="hidden" name="ReqInfoPage" value="<%=strReqInfoPagNum%>"><!--요구정보 페이지 번호 -->
			<input type="hidden" name="ReqInfoID" value="<%=objParams.getParamValue("ReqInfoID")%>"><!--요구정보 ID-->

			<input type="hidden" name="Rsn" value=""><!--추가요구 -->
			<input type="hidden" name="ReturnUrl" value="<%=request.getRequestURI()%>"><!--되돌아올 URL -->

      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=MenuConstants.REQ_BOX_PRE%><span class="sub_stl" >- <%=MenuConstants.REQ_INFO_DETAIL_VIEW%></span></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> > <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.REQUEST_BOX_COMM%> > <%=MenuConstants.REQUEST_BOX_PRE%> > <b><%=MenuConstants.REQ_BOX_PRE%></b></div>
        <p>제출기관에게 보낼 요구함의 요구내용을 확인하는 화면입니다. </p>
      </div>

      <div id="contents">

        <!-- 검색조건 없는 경우 아래 div 삭제 나 주석으로 막으세요.-->
        <!-- /검색조건-->


        <!-- 각페이지 내용 -->
         <!-- list view-->

        <span class="list02_tl">요구 정보 </span>
                <!------------------------- TAB에 해당하는 테이블(목록이든 등록폼이든 상세정보든) 출력 시~~~작 ------------------------->
                <table border="0" cellspacing="0" cellpadding="0" width="680" class="list02">
                    <tr>
                      <th height="25">&bull; 위원회 </th>
                      <td height="25" colspan="3">
                      	<%=objInfoRsSH.getObject("CMT_ORGAN_NM")%>
                      </td>
                    </tr>
                    <tr>
                      <th height="25">&bull; 요구함명 </th>
                      <td height="25" colspan="3">
                      	<%=objInfoRsSH.getObject("REQ_BOX_NM")%>
                      </td>
                    </tr>
                    <tr>
                      <th height="25">&bull; 제출기관 </th>
                      <td width="191" height="25">
                      	<%=(String)objInfoRsSH.getObject("SUBMT_ORGAN_NM")%>
                      </td>
                      <th height="25">&bull; 요구기관 </th>
                      <td width="191" height="25">
                      	<%=(String)objInfoRsSH.getObject("REQ_ORGAN_NM")%>
                      </td>
                    </tr>
                    <tr>
                      <th height="25">&bull; 요구내용 </th>
                      <td height="25" colspan="3">
                      	<%=StringUtil.getDescString((String)objInfoRsSH.getObject("REQ_CONT"))%>
                      	<%= nads.dsdm.app.reqsubmit.delegate.requestinfo.RequestInfoDelegate.getAppendRequestInfo((List)objInfoRsSH.getObject("TBDS_REQ_LOG")) %>
                      </td>
                    </tr>
                    <tr>
                      <th height="25">&bull; 요구상세내용 </th>
                      <td height="25" colspan="3">
                      	<%=StringUtil.getDescString((String)objInfoRsSH.getObject("REQ_DTL_CONT"))%>
                      </td>
                    </tr>
                    <tr>
                      <th height="25">&bull; 공개등급 </th>
                      <td height="25">
                      	<%=CodeConstants.getOpenClass((String)objInfoRsSH.getObject("OPEN_CL"))%>
                      </td>
                      <th height="25">&bull; 첨부파일</th>
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
               	    <%
					  //요구함 진행 상태.
					  String strReqBoxStt=(String)objInfoRsSH.getObject("REQ_BOX_STT");
					%>


         <div id="btn_all"class="t_right">
            <%
         //권한 없음 001
         if(!strReqSubmitFlag.equals("004")){ %>
            <%
              if(objUserInfo.getOrganGBNCode().equals("004")){
                /** 등록자와  로그인자가 같을때만 화면에 출력함.*/
                //if(objUserInfo.getUserID().equals((String)objInfoRsSH.getObject("REGR_ID"))){
                 String strReqStt1 = (String)objInfoRsSH.getObject("REQ_STT");
                 if(strReqStt1.equals("001")){
              %>
            <span class="list_bt"><a href="javascript:gotoEditPage()">요구수정</a></span>
                <%}%>
                <%if( objInfoRsSH.getObject("ANS_CNT").equals("0")){ %>
            <span class="list_bt"><a href="javascript:gotoDeletePage()">요구삭제</a></span>
                <% } %>

                    <%//추가답변요구
                    if(((String)objInfoRsSH.getObject("REQ_STT")).equals(CodeConstants.REQ_STT_SUBMT)){//제출완료된것에 한해서 추가요구가능
                    %>
            <span class="list_bt"><a href="javascript:requestAddAnswer()">추가 답변 요구</a></span>
                    <%
                     }//endif 추가요구
                    %>
              <%
                //}//endif
             }//endif - 위원회에서만 보이도록..
            %>
         <%} //end if 001 권한없음에 관련 %>

            <!-- 요구함 보기 -->
			 <span class="list_bt"><a href="javascript:gotoBoxView()">요구함보기</a></span>
		 </div>



              <%
              	String strReqStt = (String)objInfoRsSH.getObject("REQ_STT");
              	if(strReqStt.equals("002")||strReqStt.equals("003")){

              %>
        <span class="list01_tl">답변목록
		<span class="list_total">&bull;&nbsp;전체자료수 : <%= objRs.getRecordSize() %>개 </span>
		</span>

        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
          <thead>
            <tr>
              <th scope="col">NO</th>
              <th scope="col" style="width:40%; ">제출의견</th>
              <th scope="col">작성자</th>
              <th scope="col">공개</th>
              <th scope="col">답 변</th>
              <th scope="col">답 변 일</th>
            </tr>
          </thead>
          <tbody>
			<%
				int intRecordNumber= 1;
				if(objRs.getRecordSize() < 1) {
			%>
            <tr>
				<td colspan="6" align="center"> 등록된 답변이 없습니다.</td>
            </tr>
			<%
				}
				String strAnsInfoID="";
                while(objRs.next()){
                    strAnsInfoID=(String)objRs.getObject("ANS_ID");
			%>
            <tr>
              <td><%=intRecordNumber%></td>
              <td style="text-align:left;"><a href="javascript:gotoDetail('<%=strAnsInfoID%>');"><%=StringUtil.substring((String)objRs.getObject("ANS_OPIN"),35)%></a></td>
              <td><%=(String)objRs.getObject("ANSWER_NM")%></td>
              <td><%=CodeConstants.getOpenClass(((String)objRs.getObject("OPEN_CL")))%></td>
              <td align="center"><%=nads.lib.reqsubmit.util.DBAccessUtil.makeAnsInfoHtml(strAnsInfoID,(String)objRs.getObject("ANS_MTD"))%></td>
              <td align="center"><%=StringUtil.getDate((String)objRs.getObject("ANS_DT"))%></td>
            </tr>
			<%
				intRecordNumber++;
			} //endwhile
			%>
          </tbody>
        </table>
	        <!-- /list -->


        <!-- /각페이지 내용 -->
      </div>


              <%
              	}
              %>

</form>
      <!-- /contents -->

    </div>
  </div>
  <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>