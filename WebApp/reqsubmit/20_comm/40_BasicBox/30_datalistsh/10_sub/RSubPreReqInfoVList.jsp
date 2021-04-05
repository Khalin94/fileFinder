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


  /**답변정보 상세보기로 가기.*/

  function gotoDetail(strID){
  	formName.AnsInfoID.value=strID;

  	window.open('/reqsubmit/common/SAnsInfoView.jsp?returnURL=POPUP&AnsID='+strID, '', 'width=500,height=400, scrollbars=no, resizable=yes, toolbar=no, menubar=no, location=no, directories=no, status=no');

  }


  /**요구정보 수정페이지로 가기.*/
  function gotoEditPage(){
  	alert('요구등급수정해라..');
  }
  /** 목록으로 가기 */
  function gotoList(){
  	formName.action="./RSubPreReqInfoList.jsp";
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
	<input type="hidden" name="CmtOrganID" value="<%=objParams.getParamValue("CmtOrganID")%>">
	<input type="hidden" name="AnsInfoID" value=""><!--답변정보ID -->
	<input type="hidden" name="ReturnUrl" value="<%=request.getRequestURI()%>"><!--되돌아올 URL -->
	<input type="hidden" name="Rsn" value=""><!--추가요구 -->

      <!-- pgTit -->

      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=MenuConstants.REQ_INFO_LIST_SUBMT_DONE%><span class="sub_stl" >- <%=MenuConstants.REQ_INFO_DETAIL_VIEW%></span></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> >   <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.REQUEST_BOX_COMM%>
                        > <%=MenuConstants.REQUEST_BOX_PRE%> > <%=MenuConstants.REQ_INFO_LIST_SUBMT_DONE%></div>
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
		<% //권한 없음
		  if(!strReqSubmitFlag.equals("004")){
		%>
		  <%
			/** 등록자와  로그인자가 같을때만 화면에 출력함.*/
			//if(objUserInfo.getUserID().equals((String)objInfoRsSH.getObject("REGR_ID"))){
				if(objUserInfo.getOrganGBNCode().equals("004")){ //위원회에서만 보이도록
		  %>
			 <span class="btn"><a href="javascript:viewReqHistory('<%=objParams.getParamValue("ReqInfoID")%>')">요구 이력 보기</a></span>
		<%
		  if(((String)objInfoRsSH.getObject("REQ_STT")).equals(CodeConstants.REQ_STT_SUBMT)){//제출완료된것에 한해서 추가요구가능
		%>
			 <span class="btn"><a href="javascript:requestAddAnswer()">추가 답변 요구</a></span>
			<%
			  }//endif 추가요구
			%>


		  <%     }//위원회에서만 보이도록 %>
		<%
		}//end if 권한 없음
		%>
			 <span class="btn"><a href="javascript:gotoList()">요구목록</a></span>
		  <%
			//}//endif
		  %>
<!--			 <span class="list_bt"><a href="#">요구이력보기</a></span>
			 <span class="list_bt"><a href="#">요구목록</a></span>
-->
		</samp></div>
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
                <td height="25" colspan="3"><%=(String)objInfoRsSH.getObject("SUBMT_ORGAN_NM")%></td>
            </tr>
            <tr>
                <th height="25">&bull; 요구기관 </th>
                <td height="25" colspan="3"><%=(String)objInfoRsSH.getObject("REQ_ORGAN_NM")%></td>
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
                <th height="25" width="18%">&bull; 공개등급 </th>
                <td height="25" width="32%"><%=CodeConstants.getOpenClass((String)objInfoRsSH.getObject("OPEN_CL"))%></td>
				<th height="25" width="18%">&bull; 첨부파일 </th>
                <td height="25" width="32%">
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
        <div id="btn_all"><div  class="t_right">
        </div></div>
        <!-- /리스트 버튼-->

        <!-- list -->
        <span class="list01_tl">답변목록 <span class="list_total">&bull;&nbsp;전체자료수 : <%=objRs.getRecordSize()%>개 </span></span>
        <table width="100%" style="padding:0;">
            <tr>
                <td>&nbsp;</td>
            </tr>
        </table>
        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
          <thead>
            <tr>
              <th scope="col"><a>NO</a></th>
              <th scope="col" style="width:40%; "><a>제출의견</a></th>
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
			  if(objRs.getRecordSize()>0){
			  while(objRs.next()){
				 strAnsInfoID=(String)objRs.getObject("ANS_ID");
			 %>
            <tr>
              <td><%=intRecordNumber%></td>
              <td style="text-align:left;"><a href="JavaScript:gotoDetail('<%=strAnsInfoID%>');"><%=StringUtil.substring((String)objRs.getObject("ANS_OPIN"),35)%></a></td>
              <td><%=(String)objRs.getObject("ANSWER_NM")%></td>
              <td><%=CodeConstants.getOpenClass(((String)objRs.getObject("OPEN_CL")))%></td>
              <td><<%=nads.lib.reqsubmit.util.DBAccessUtil.makeAnsInfoHtml(strAnsInfoID,(String)objRs.getObject("ANS_MTD"))%></td>
              <td><%=StringUtil.getDate((String)objRs.getObject("ANS_DT"))%></td>
            </tr>
			<%
					intRecordNumber ++;
				}//endwhile
			}else{
			%>
            <tr>
				<td colspan="6" align="center"> 등록된 답변정보가 없습니다.</td>
            </tr>
			<%
			}//end if 목록 출력 끝.
			%>

          </tbody>
        </table>
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