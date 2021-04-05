<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RCommReqBoxVListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.CommRequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.CommRequestInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.cmtmanager.CmtManagerConfirmDelegate" %>
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
  /**일반 요구함 상세보기 파라미터 설정.*/
  RCommReqBoxVListForm objParams =new RCommReqBoxVListForm();

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
  //로그인 사용자 정보를 가져온다. 권한없음 경우 관람만 가능하다.
  String strReqSubmitFlag = objUserInfo.getReqSubmitFlag();
  int FLAG = -1;
  CmtManagerConfirmDelegate cmtmanagerCn = new CmtManagerConfirmDelegate();
 /*** Delegate 과 데이터 Container객체 선언 */
 CommRequestBoxDelegate objReqBox=null; 		/**요구함 Delegate*/
 CommRequestInfoDelegate  objReqInfo=null;		/** 요구정보 Delegate */
 ResultSetSingleHelper objRsSH=null;			/** 요구함 상세보기 정보 */
 ResultSetSingleHelper objRsRI=null;			/** 요구 상세보기 정보 */
 ResultSetSingleHelper objRsCS=null;			/** 요구 상세보기 정보 */
 String strRefReqID ="";

 try{
   /**요구함 정보 대리자 New */
   objReqBox=new CommRequestBoxDelegate();
   /**요구함 이용 권한 체크 */

   boolean blnHashAuth=objReqBox.checkReqBoxAuth((String)objParams.getParamValue("ReqBoxID"),objUserInfo.getCurrentCMTList()).booleanValue();
   System.out.println("blnHashAuth : "+blnHashAuth);
   if(!blnHashAuth){
      objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	  objMsgBean.setStrCode("DSAUTH-0001");
  	  objMsgBean.setStrMsg("해당 요구함을 볼 권한이 없습니다.");
  	  out.println("해당 요구함을 볼 권한이 없습니다.");
  	%>
  	<jsp:forward page="/common/message/ViewMsg3.jsp"/>
  	<%
      return;
  }else{
   /** 요구함 정보 */
    System.out.println("11111");
    objRsSH=new ResultSetSingleHelper(objReqBox.getRecord((String)objParams.getParamValue("ReqBoxID")));
	System.out.println("22222"+(String)objParams.getParamValue("CommReqID"));
   /**요구 정보 대리자 New */
    objReqInfo=new CommRequestInfoDelegate();
	objRsRI=new ResultSetSingleHelper(objReqInfo.getRecord((String)objParams.getParamValue("CommReqID")));
	System.out.println("3333");
	strRefReqID = (String)objRsRI.getObject("REF_REQ_ID");
	System.out.println("4444");
    objRsCS=new ResultSetSingleHelper(objReqInfo.getCmtSubmt((String)objParams.getParamValue("CommReqID"),strRefReqID));
	System.out.println("5555");
	FLAG = cmtmanagerCn.getFLAG((String)objParams.getParamValue("CmtOrganID"));
	System.out.println("66666");
  }/**권한 endif*/
 }catch(AppException objAppEx){
 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  	objMsgBean.setStrCode(objAppEx.getStrErrCode());
  	objMsgBean.setStrMsg(objAppEx.getMessage());
  	out.println("<br>Error!!!" + objAppEx.getMessage());
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%
  	return;
 }
 String strIngStt = (String)objRsSH.getObject("ING_STT");
 String strCmt = (String)objRsCS.getObject("CMT_SUBMT_REQ_ID");

 // 2005-08-09 kogaeng ADD
 // 정확한 요구함 찾아가게 하기 위한 요구함 상태 정보 설정 및 전달
 String strReqBoxStt = (String)objRsSH.getObject("REQ_BOX_STT");
%>
<jsp:include page="/inc/header.jsp" flush="true"/>
<link href="/css2/style.css" rel="stylesheet" type="text/css">
<script language="javascript">
//공개등급 수정페이지로 가기
function openCLUp(){
	form = document.formName;
	form.action="/reqsubmit/20_comm/20_reqboxsh/ROpenCLProc.jsp";
	form.target="";
	form.submit();
}
  /**요구정보 수정페이지로 가기.*/
  function gotoEdit(){
  	formName.action="/reqsubmit/20_comm/20_reqboxsh/RCommReqInfoEdit.jsp";
	formName.target="";
  	formName.submit();
  }

  /**요구함 보기*/
  function gotoReqBox(){
  	form = document.formName;
  	form.action="./RAccBoxVList.jsp";
	form.target="";
  	form.submit();
  }

  /**요구삭제페이지로 가기.*/
  function gotoDelete(){
  	formName.action="/reqsubmit/20_comm/20_reqboxsh/RCommReqDelProc.jsp";
	formName.target="";
  	formName.submit();
  }

  function showDelMoreInfoDiv() {
	  document.all.delMoreInfoDiv.style.display = '';
  }

  function FinalSubmit() {
	  var f = document.formName;
	<%if(!"".equalsIgnoreCase(strCmt)){%>
		if (f.elements['Rsn'].value == "") {
			f.elements['Rsn'].value = "수정 사유 없음";
			//return;
		}
	<% } %>
	  f.action = "/reqsubmit/20_comm/20_reqboxsh/RCommReqDelProc.jsp";
	  f.target = "";
	  if (confirm("요구 정보를 삭제하시겠습니까?")) f.submit();
  }

  function hiddenDelMoreInfoDiv() {
	  document.all.delMoreInfoDiv.style.display = 'none';
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
		<input type="hidden" name="CommReqBoxSortField" value="<%=objParams.getParamValue("CommReqBoxSortField")%>"><!--요구함목록정렬필드 -->
		<input type="hidden" name="CommReqBoxSortMtd" value="<%=objParams.getParamValue("CommReqBoxSortMtd")%>"><!--요구함목록정령방법-->
		<input type="hidden" name="CommReqBoxPage" value="<%=objParams.getParamValue("CommReqBoxPage")%>"><!--요구함 페이지 번호 -->
		<input type="hidden" name="CommReqBoxQryField" value="<%=objParams.getParamValue("CommReqBoxQryField")%>"><!--요구함 조회필드 -->
		<input type="hidden" name="CommReqBoxQryTerm" value="<%=objParams.getParamValue("CommReqBoxQryTerm")%>"><!--요구함 조회어 -->
	    <input type="hidden" name="ReqBoxID" value="<%=objParams.getParamValue("ReqBoxID")%>">
	    <input type="hidden" name="CmtOrganID" value="<%=objParams.getParamValue("CmtOrganID")%>">
		<input type="hidden" name="CommReqID" value="<%=(String)objParams.getParamValue("CommReqID")%>"><!--요구정보 ID-->
		<input type="hidden" name="RefReqID" value="<%=strRefReqID%>">
		<input type="hidden" name="CommReqInfoSortField" value="<%=strCommReqInfoSortField%>"><!--요구정보 목록정렬필드 -->
		<input type="hidden" name="CommReqInfoSortMtd" value="<%=strCommReqInfoSortMtd%>"><!--요구정보 목록정령방법-->
		<input type="hidden" name="CommReqInfoPage" value="<%=strCommReqInfoPagNum%>"><!--요구정보 페이지 번호 -->
		<input type="hidden" name="CommReqID" value="<%=objRsRI.getObject("REQ_ID")%>"><!--요구정보 ID-->
		<input type="hidden" name="ReturnURL" value="<%=request.getRequestURI()%>">
		<input type="hidden" name="AuditYear" value="<%=objParams.getParamValue("AuditYear")%>">
		<input type="hidden" name="IngStt" value="<%=strIngStt%>">
		<input type="hidden" name="RltdDuty" value="<%=objParams.getParamValue("RltdDuty")%>">

		<input type="hidden" name="ReqBoxStt" value="<%= strReqBoxStt %>">

      <!-- pgTit -->

      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%= (FLAG > 1)?MenuConstants.COMM_MNG_CHECK:MenuConstants.COMM_REQ_BOX_MAKE_END %> <span class="sub_stl" >- 요구상세보기</span></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.REQUEST_BOX_COMM%> > <%= (FLAG > 1)?MenuConstants.COMM_MNG_CHECK:MenuConstants.COMM_REQ_BOX_MAKE_END %></div>

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
		if(!objRsSH.next()){
	%>
            <tr>
                <td height="25" colspan="4"><strong>요구함 정보가 없습니다.</strong></td>
            </tr>
		<%
			}else{
		%>
            <tr>
                <th height="25">&bull; 요구함명 </th>
                <td height="25" colspan="3">- <%=objRsSH.getObject("REQ_BOX_NM")%>
				</td>
            </tr>
            <tr>
                <th height="25">&bull; 업무구분 </th>
                <td height="25" colspan="3"><%=objCdinfo.getRelatedDuty((String)objRsSH.getObject("RLTD_DUTY"))%> </td>
            </tr>
            <tr>
                <th height="25">&bull; 요구기관 </th>
                <td height="25"><%=objRsSH.getObject("CMT_ORGAN_NM")%></td>
                <th height="25">&bull;&nbsp;제출기관</th>
                <td height="25"><%=(String)objRsSH.getObject("SUBMT_ORGAN_NM")%></td>
            </tr>
            <tr>
                <th height="25">&bull; 접수시작 </th>
                <td height="25">
				<%=StringUtil.getDate((String)objRsSH.getObject("ACPT_BGN_DT"))%>
				</td>
				<th height="25">&bull;&nbsp;접수마감</th>
                <td height="25"><%=StringUtil.getDate((String)objRsSH.getObject("ACPT_END_DT"))%></td>
            </tr>
	<%
		}/** 요구함 정보 가 있으면. */
	%>
        </table>
<br><br>

        <span class="list02_tl">요구 정보 </span>
        <table border="0" cellspacing="0" cellpadding="0" width="680" class="list02">
		<%
			if(!objRsRI.next()){
		%>
            <tr>
                <td height="25" colspan="4"><strong>요구함 정보가 없습니다.</strong></td>
            </tr>
		<%
			}else{
		%>
            <tr>
                <th height="25">&bull; 요구제목 </th>
                <td height="25" colspan="3">- <%=objRsRI.getObject("REQ_CONT")%>
				</td>
            </tr>
            <tr>
                <th height="25">&bull; 요구내용 </th>
                <td height="25" colspan="3"><%=StringUtil.getDescString((String)objRsRI.getObject("REQ_DTL_CONT"))%> </td>
            </tr>
            <tr>
                <th height="25">&bull; 공개등급 </th>
                <td height="25"><%=CodeConstants.getOpenClass((String)objRsRI.getObject("OPEN_CL"))%></td>
                <th height="25">&bull;&nbsp;등록일시</th>
                <td height="25"><%=StringUtil.getDate((String)objRsSH.getObject("ACPT_BGN_DT"))%></td>
            </tr>
            <tr>
                <th height="25">&bull; 첨부파일 </th>
                <td height="25" colspan="3">
				<%=StringUtil.makeAttachedFileLink((String)objRsRI.getObject("ANS_ESTYLE_FILE_PATH"),(String)objRsRI.getObject("REQ_ID"))%>
				</td>
           </tr>
            <tr>
                <th height="25">&bull; 신청기관 </th>
                <td height="25"><%=objRsRI.getObject("OLD_REQ_ORGAN_NM")%></td>
                <th height="25">&bull;&nbsp;신청자</th>
                <td height="25"><%=objRsRI.getObject("REGR_NM")%></td>
            </tr>
	<%
		}/** 요구 정보 가 있으면. */
	%>
        </table>
        <!-- /list view -->
<!--        <p class="warning mt10">* 요구서 발송 : 의원실(또는 소속기관) 명의로 해당 제출기관에 요구서를 발송합니다.</p>
-->
        <!-- 리스트 버튼
         <div id="btn_all"class="t_right">
			 <span class="list_bt"><a href="#">추가 답변 요구</a></span>
		 </div>

        <!-- /리스트 버튼-->

        <!-- list -->
<!--
checkbox
<input name="" type="checkbox" value="" class="borderNo" />
-->

        <!-- /list===============================
        <span class="list01_tl">요구 목록
		<span class="list_total">&bull;&nbsp;전체자료수 :  개 ( /  Page) </span>
		</span>
<!--
checkbox

       <!-- 리스트 버튼
        <div id="btn_all" >
		<!-- 리스트 내 검색

       <!-- /리스트 내 검색  -->
			<span class="right">
		<%
		String strDelete = "";
		if(strCmt.equalsIgnoreCase("")){
			strDelete = "gotoDelete()";
		} else {
			strDelete = "javascript:showDelMoreInfoDiv()";
		}

		/**위원회에서 신규등록한 요구에 한함-> 기준??*/
		//요구함보기 버튼...
		/** 위원회 행정직원 일때만 화면에 출력함.*/
		if(objUserInfo.getOrganGBNCode().equals("004")  && !strReqSubmitFlag.equals("004")){
			if(objRsSH.getObject("REQ_BOX_STT").equals("002") || objRsSH.getObject("REQ_BOX_STT").equals("005")){
			%>
				<span class="list_bt"><a href="javascript:gotoEdit()">요구수정</a></span>
				<span class="list_bt"><a href="#" onclick="<%=strDelete%>">요구삭제</a></span>
				<%}
			}
			%>
				<span class="list_bt"><a href="javascript:viewReqHistory('<%=(String)request.getParameter("CommReqID")%>')">요구 이력 보기</a></span>
				<span class="list_bt"><a href="javascript:gotoReqBox()">요구함 보기</a></span>
			</span>
		</div>

<div id="delMoreInfoDiv" style="display:none;">
        <p><!-- 상위 목록과 하위 목록의 간격을 위해 추가함.--></p>

        <span class="list02_tl">요구 삭제 사유 및 통보방법 </span>
        <table border="0" cellspacing="0" cellpadding="0" width="680" class="list02">
            <tr>
                <th height="25">&bull; 문자전송 여부 </th>
                <td height="25" colspan="3"><input type="checkbox" name="NtcMtd" value="002">사용
				</td>
            </tr>
            <tr>
                <th height="25">&bull; 사유 </th>
                <td height="25" colspan="3"><textarea rows="3" cols="10" name="Rsn" class="textfield" style="WIDTH: 90% ; height: 30"></textarea> </td>
            </tr>
        </table>

	<span class="right">

				<span class="list_bt"><a href="FinalSubmit()">삭제</a></span>

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