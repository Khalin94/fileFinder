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
<%@ page import="nads.lib.reqsubmit.util.FileUtil" %>
<%@ page import="nads.lib.reqsubmit.params.requestinfo.RMemReqInfoVListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.MemRequestInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.cmtsubmt.CmtSubmtReqBoxDelegate" %>
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
	/*************************************************************************************************/
	/** 					파라미터 체크 Part 														  */
	/*************************************************************************************************/

	/**일반 요구 상세보기 파라미터 설정.*/
	RMemReqInfoVListForm objParams =new RMemReqInfoVListForm();
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

	/*************************************************************************************************/
	/** 					데이터 호출 Part 														  */
	/*************************************************************************************************/

	/*** Delegate 과 데이터 Container객체 선언 */
	MemRequestInfoDelegate  objReqInfo=null;	/** 요구정보 Delegate */
	ResultSetSingleHelper objInfoRsSH=null;		/**요구 정보 상세보기 */
	CmtSubmtReqBoxDelegate objCmtSubmt = null;

	try {
		/**요구 정보 대리자 New */
		objReqInfo=new MemRequestInfoDelegate();
		objCmtSubmt = new CmtSubmtReqBoxDelegate();

		/**요구정보 이용 권한 체크 */
		boolean blnHashAuth=objReqInfo.checkReqInfoAuth((String)objParams.getParamValue("ReqInfoID"),objUserInfo.getOrganID()).booleanValue();
		if(!blnHashAuth){
			objMsgBean.setMsgType(MessageBean.TYPE_WARN);
			objMsgBean.setStrCode("DSAUTH-0001");
			objMsgBean.setStrMsg("해당 요구정보를 볼 권한이 없습니다.");
%>
			<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
			return;
		} else {
			objInfoRsSH=new ResultSetSingleHelper(objReqInfo.getRecord((String)objParams.getParamValue("ReqInfoID")));
		}/**권한 endif*/
	} catch(AppException objAppEx) {
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
<jsp:include page="/inc/header.jsp" flush="true"/>
<link href="/css2/style.css" rel="stylesheet" type="text/css">
<script language="javascript">
<!--

  /**답변정보 상세보기로 가기.*/
  function gotoDetail(strID){
  	formName.ReqInfoID.value=strID;
  	formName.action="../../../common/AnsInfoView.jsp";
  	formName.target="_blank";
  	formName.submit();
  }
  /**요구정보 수정페이지로 가기.*/
  function gotoEditPage(){
  	formName.action="./RMakeReqInfoEdit.jsp";
  	formName.submit();
  }
  /**요구 정보 삭제 */
  function gotoDeletePage(){
  	if(confirm('선택하신 요구정보를 삭제하시겠습니까?')){
	  	formName.action="./RMakeReqInfoDelProc.jsp";
  		formName.submit();
  	}
  }
  /** 목록으로 가기 */
  function gotoList(){
  	formName.action="./RMakeReqBoxVList.jsp";
  	formName.submit();
  }

  function popUpWindow(){
     NewWindow('./RMakeReqInfoFileOpen.jsp?ReqInfoID=<%=(String)objParams.getParamValue("ReqInfoID")%>', '', '810', '610');
  }
 //-->
</script>
<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="/js/reqsubmit/reqboxview.js"></SCRIPT>
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
	//요구 정보 페이지 번호 받기.
	String strReqInfoPagNum=objParams.getParamValue("ReqInfoPage");
	%>
	 <%=objParams.getHiddenFormTags()%>
	<input type="hidden" name="ReturnUrl" value="<%=request.getRequestURI()%>"><!--되돌아올 URL -->
      <!-- pgTit -->
      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=MenuConstants.REQ_BOX_MAKE%><span class="sub_stl" >- <%=MenuConstants.REQ_INFO_DETAIL_VIEW%></span></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.getReqBoxGeneral(request)%> > <%=MenuConstants.REQ_BOX_MAKE%></div>
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
<!-- 상단 버튼-->
<!--
요구함 목록, 바인딩, 요구서 보기, 답변서 미리 보기, 답변서 발송, 오프라인 제출
-->
		<%
		  //요구함 진행 상태.
		  String strReqBoxStt=(String)objInfoRsSH.getObject("REQ_BOX_STT");
		%>
         <div class="top_btn">
		  <samp>
<!--
요구 수정
요구 삭제
요구 이동
요구 복사
위원회 제출 신청
요구 이력 보기
요구함 보기

-->
		<%
			//결재대기중(상신),기안대기중  상태에서는 요구함 수정,삭제,요구함 발송 버튼이 Disable되어있어야함.
			//즉 작성중과 반려상태에석만 가능함.
			if(strReqBoxStt.equals(CodeConstants.REQ_BOX_STT_003) || strReqBoxStt.equals(CodeConstants.REQ_BOX_STT_005) || strReqBoxStt.equals(CodeConstants.REQ_BOX_STT_009)){
				/** 등록자와  로그인자가 같을때만 화면에 출력함.*/
				if(objUserInfo.getUserID().equals((String)objInfoRsSH.getObject("REGR_ID"))){
		%>
			 <span class="btn"><a href="javascript:gotoEditPage()">요구 수정</a></span>
			 <span class="btn"><a href="javascript:gotoDeletePage()">요구 삭제</a></span>
			 <span class="btn"><a href="javascript:moveSingleMemReqInfo(document.formName,'/reqsubmit/10_mem/20_reqboxsh/10_make/RMakeReqBoxVList.jsp')">요구 이동</a></span>
		<%
				}//endif
			}//end if
		%>
			 <span class="btn"><a href="javascript:copySingleMemReqInfo(document.formName)">요구 복사</a></span>
		<%
			// 2005-08-22 kogaeng ADD
			// 2005-08-29 kogaeng EDIT
			// 조건 1 : 만들어진 요구함의 소관 위원회 소속 의원실 이어야 한다.
			// 조건 2 : 소속 기관이 의원실이어야 한다.
			// 조건 3 : 요구 일정 자동 생성을 사용하지 않아야 한다.
			if(objUserInfo.getIsMyCmtOrganID((String)objInfoRsSH.getObject("CMT_ORGAN_ID")) && ((String)objInfoRsSH.getObject("CMT_REQ_APP_FLAG")).equals(CodeConstants.CMT_REQ_APP_FLAG_MEM) && !objCmtSubmt.checkCmtOrganMakeAutoSche((String)objInfoRsSH.getObject("CMT_ORGAN_ID"))) {
		%>
			 <span class="btn"><a href="javascript:appointCmtReq()">위원회 제출 신청</a></span>
		<%
			}
		%>
			 <span class="btn"><a href="javascript:viewReqHistory('<%=objParams.getParamValue("ReqInfoID")%>')">요구 이력 보기</a></span>
			 <span class="btn"><a href="javascript:gotoList()">요구함 보기</a></span>
			  </samp>
		 </div>
<!-- 상단 버튼 끝-->
        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list02">

            <tr>

              <th height="25" scope="col" width="120">&bull;&nbsp;요구제목 </th>
				  <td colspan="3"><%=StringUtil.getDescString((String)objInfoRsSH.getObject("REQ_CONT"))%></td>
            </tr>
            <tr>
              <th height="25"  scope="col" width="120">&bull;&nbsp;요구내용</th>
			  <td><%=StringUtil.getDescString((String)objInfoRsSH.getObject("REQ_DTL_CONT"))%></td>
            </tr>
		<%
			// 2004-07-08 사무처, 예정처일 경우에는 위원회라는건 보이지마
			if (CodeConstants.ORGAN_GBN_ASM.equalsIgnoreCase(objUserInfo.getOrganGBNCode()) || CodeConstants.ORGAN_GBN_BUD.equalsIgnoreCase(objUserInfo.getOrganGBNCode())) {
			} else {
		%>
            <tr>
              <th height="25"  scope="col" width="120">&bull;&nbsp;소관 위원회  </th>
			  <td><%=objInfoRsSH.getObject("CMT_ORGAN_NM")%></td>
            </tr>
		 <% } %>
            <tr>
              <th height="25"  scope="col" width="120">&bull;&nbsp;요구함명  </th>
			  <td><%=objInfoRsSH.getObject("REQ_BOX_NM")%></td>
            </tr>
            <tr>
              <th height="25"  scope="col" width="120">&bull;&nbsp;요구기관  </th>
			  <td><%=(String)objInfoRsSH.getObject("REQ_ORGAN_NM")%></td>
            </tr>
            <tr>
              <th height="25"  scope="col" width="120">&bull;&nbsp;제출기관  </th>
			  <td><%=(String)objInfoRsSH.getObject("SUBMT_ORGAN_NM")%></td>
            </tr>
            <tr>
              <th height="25"  scope="col" width="120">&bull;&nbsp;공개등급  </th>
			  <td><%=CodeConstants.getOpenClass((String)objInfoRsSH.getObject("OPEN_CL"))%></td>
            </tr>
            <tr>
              <th height="25"  scope="col" width="120">&bull;&nbsp;첨부파일  </th>
				  <td><%
							String strFileExt = FileUtil.getFileExtension((String)objInfoRsSH.getObject("ANS_ESTYLE_FILE_PATH"));
							String strReqFilePath = StringUtil.makeAttachedFileLink((String)objInfoRsSH.getObject("ANS_ESTYLE_FILE_PATH"), (String)objInfoRsSH.getObject("REQ_ID"));
							if (StringUtil.isAssigned(strReqFilePath)) {
								out.println(strReqFilePath);
							}
						%>
				</td>
            </tr>
            <tr>
              <th height="25"  scope="col" width="120">&bull;&nbsp;등록자  </th>
			  <td><%=(String)objInfoRsSH.getObject("REGR_NM")%></td>
            </tr>
            <tr>
              <th height="25"  scope="col" width="120">&bull;&nbsp;등록일시  </th>
			  <td><%=StringUtil.getDate2((String)objInfoRsSH.getObject("REG_DT"))%></td>
            </tr>
            <tr>
              <th height="25"  scope="col" width="120">&bull;&nbsp;답변 제출여부  </th>
			  <td><%=CodeConstants.getRequestStatus((String)objInfoRsSH.getObject("REQ_STT"))%></td>
            </tr>
            <tr>
              <th height="25"  scope="col" width="120">&bull;&nbsp;위원회 제출여부  </th>
			  <td><%=CodeConstants.getCmtRequestAppoint((String)objInfoRsSH.getObject("CMT_REQ_APP_FLAG"))%></td>
            </tr>
        </table>
        <!-- /list view -->
<div id="btn_all"  class="t_right">

		<%
			// 2005-08-22 kogaeng ADD
			// 2005-08-29 kogaeng EDIT
			// 조건 1 : 만들어진 요구함의 소관 위원회 소속 의원실 이어야 한다.
			// 조건 2 : 소속 기관이 의원실이어야 한다.
			// 조건 3 : 요구 일정 자동 생성을 사용하지 않아야 한다.
			if(objUserInfo.getIsMyCmtOrganID((String)objInfoRsSH.getObject("CMT_ORGAN_ID")) && ((String)objInfoRsSH.getObject("CMT_REQ_APP_FLAG")).equals(CodeConstants.CMT_REQ_APP_FLAG_MEM) && !objCmtSubmt.checkCmtOrganMakeAutoSche((String)objInfoRsSH.getObject("CMT_ORGAN_ID"))) {
		%>
			 <span class="mi_btn"><a href="javascript:appointCmtReq()">위원회 제출 신청</a></span>
		<%
			}
		%>

		 </div>

      </div>
      <!-- /contents -->
    </div>
</form>
  </div>
  <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>