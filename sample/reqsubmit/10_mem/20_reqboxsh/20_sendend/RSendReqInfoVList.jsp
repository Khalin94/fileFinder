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
<%@ page import="nads.lib.reqsubmit.params.requestinfo.RMemReqInfoVListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.MemRequestInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.answerinfo.MemAnswerInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.cmtsubmt.CmtSubmtReqBoxDelegate" %>
<%@ page import="nads.dsdm.app.common.page.PagingDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%
	/*** PagingDelegate */
	PagingDelegate objPaging=new PagingDelegate(); 		/*페이징 변환 Delegate*/
%>
<%
	UserInfoDelegate objUserInfo = null;
	CDInfoDelegate objCdinfo = null;
%>

<%@ include file="../../../common/RUserCodeInfoInc.jsp" %>

<%
	/*************************************************************************************************/
	/** 					파라미터 체크 Part 														  */
	/*************************************************************************************************/

	/**일반 요구함 상세보기 파라미터 설정.*/
	RMemReqInfoVListForm objParams =new RMemReqInfoVListForm();
	boolean blnParamCheck=false;
	/**전달된 파리미터 체크 */
	blnParamCheck=objParams.validateParams(request);
	if(blnParamCheck==false) {
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
	ResultSetSingleHelper objInfoRsSH=null;	/**요구 정보 상세보기 */
	ResultSetHelper objRs=null;				/** 답변정보 목록 출력*/
	CmtSubmtReqBoxDelegate objCmtSubmt = null;

	try {
		/**요구 정보 대리자 New */
		objReqInfo=new MemRequestInfoDelegate();
		objCmtSubmt = new CmtSubmtReqBoxDelegate();

		/**요구함 이용 권한 체크 */
		boolean blnHashAuth=objReqInfo.checkReqInfoAuth((String)objParams.getParamValue("ReqInfoID"),objUserInfo.getOrganID()).booleanValue();
		if(!blnHashAuth) {
			objMsgBean.setMsgType(MessageBean.TYPE_WARN);
			objMsgBean.setStrCode("DSAUTH-0001");
			objMsgBean.setStrMsg("해당 요구정보를 볼 권한이 없습니다.");
			//out.println("해당 요구정보를 볼 권한이 없습니다.");
%>
			<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
			return;
		} else {
			objInfoRsSH=new ResultSetSingleHelper(objReqInfo.getRecord((String)objParams.getParamValue("ReqInfoID")));
			objRs=new ResultSetHelper(new MemAnswerInfoDelegate().getRecordList((String)objParams.getParamValue("ReqInfoID"),"Y"));/**제출만 Y */
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
<jsp:include page="/inc/header.jsp" flush="true"/>
<link href="/css2/style.css" rel="stylesheet" type="text/css">
<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>
<script language="javascript">
	/**요구정보 수정페이지로 가기.*/
	function gotoEditPage(){
  		if(confirm("요구정보 공개등급을 수정하시겠습니까?")){
	  		// (2015.06.18) formName.action="/reqsubmit/common/ChangeReqInfoOpenCLProc.jsp"; 
                        formName.action="/reqsubmit/common/ChangeReqInfoOpenCLProc2.jsp";
  			formName.submit();
  		}
  	}

	/** 목록으로 가기 */
	function gotoList(){
  		formName.action="./RSendBoxVList.jsp";
  		formName.submit();
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
    </div>
    <div id="rightCon">
<form name="formName" method="get" action="<%=request.getRequestURI()%>"><!--요구함 신규정보 전달 -->
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
		    <input type="hidden" name="AuditYear" value="<%=objParams.getParamValue("AuditYear")%>">
		    <input type="hidden" name="CmtOrganID" value="<%=objParams.getParamValue("CmtOrganID")%>">
			<input type="hidden" name="ReqBoxID" value="<%=objParams.getParamValue("ReqBoxID")%>">
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
			<input type="hidden" name="AnsInfoID" value=""><!--답변정보ID -->
			<input type="hidden" name="AnsID" value=""><!--답변정보ID: 답변상세보기용 -->
			<input type="hidden" name="ReturnUrl" value="<%=request.getRequestURI()%>"><!--되돌아올 URL -->

      <!-- pgTit -->

		<div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=MenuConstants.REQ_BOX_SEND_END%><span class="sub_stl" >- <%=MenuConstants.REQ_INFO_DETAIL_VIEW%></span></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.getReqBoxGeneral(request)%> > <%=MenuConstants.REQ_BOX_SEND_END%></div>
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
<!--요구함 목록, 바인딩, 요구서 보기, 답변서 미리 보기, 답변서 발송, 오프라인 제출-->
         <div class="top_btn">
		  <samp>
		<%
		  //요구함 진행 상태.
		  String strReqBoxStt=(String)objInfoRsSH.getObject("REQ_BOX_STT");
		%>
		<%
			//요구함상태가 결재중이면 이동 수정 삭제가 불가능해짐.
			if(!strReqBoxStt.equals(CodeConstants.REQ_BOX_STT_004)) {
				/** 등록자와  로그인자가 같을때만 화면에 출력함.*/
				if(objUserInfo.getUserID().equals((String)objInfoRsSH.getObject("REGR_ID"))) {
		%>
			 <span class="btn"><a href="javascript:gotoEditPage()">공개 설정 저장</a></span>

		<%
				}//endif
			}//end if

		%>

			 <span class="btn"><a href="#" onclick="javascript:viewReqHistory('<%=objParams.getParamValue("ReqInfoID")%>')">요구 이력 보기</a></span>
			 <span class="btn"><a href="javascript:gotoList()">요구함 보기</a></span>
		  </samp>
		 </div>

        <!-- /상단 버튼-->

        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list02">

            <tr>

              <th width="120" scope="col">&bull;&nbsp;요구제목 </th>
				  <td colspan="3"><%=StringUtil.getDescString((String)objInfoRsSH.getObject("REQ_CONT"))%></td>
            </tr>
            <tr>
              <th scope="col">&bull;&nbsp;요구내용 </th>
			  <td><%=StringUtil.getDescString((String)objInfoRsSH.getObject("REQ_DTL_CONT"))%>
               	  <%=nads.dsdm.app.reqsubmit.delegate.requestinfo.RequestInfoDelegate.getAppendRequestInfo((List)objInfoRsSH.getObject("TBDS_REQ_LOG"))%>
			  </td>
            </tr>
		<%
			// 2004-07-08 사무처, 예정처일 경우에는 위원회라는건 보이지마
			if (CodeConstants.ORGAN_GBN_ASM.equalsIgnoreCase(objUserInfo.getOrganGBNCode()) || CodeConstants.ORGAN_GBN_BUD.equalsIgnoreCase(objUserInfo.getOrganGBNCode())) {
			} else {
		%>
            <tr>
              <th scope="col">&bull;&nbsp;요구함명  </th>
			  <td><%=objInfoRsSH.getObject("REQ_BOX_NM")%></td>
            </tr>
		<% } %>
            <tr>
              <th scope="col">&bull;&nbsp;요구기관  </th>
			  <td><%=(String)objInfoRsSH.getObject("REQ_ORGAN_NM")%></td>
            </tr>
            <tr>
              <th scope="col">&bull;&nbsp;제출기관  </th>
			  <td><%=(String)objInfoRsSH.getObject("SUBMT_ORGAN_NM")%></td>
            </tr>
            <tr>
              <th scope="col">&bull;&nbsp;공개등급  </th>
			  <td>
				<select name="OpenCL" class="select">
				<%
					List objOpenClassList=CodeConstants.getOpenClassList();
					String strOpenClass=(String)objInfoRsSH.getObject("OPEN_CL");
					for(int i=0;i<objOpenClassList.size();i++){
						String strCode=(String)((Hashtable)objOpenClassList.get(i)).get("Code");
						String strValue=(String)((Hashtable)objOpenClassList.get(i)).get("Value");
						out.println("<option value=\"" + strCode + "\"" + StringUtil.getSelectedStr(strOpenClass,strCode) + ">" + strValue + "</option>");
						}
				%>
				</select>
			  </td>
            </tr>
            <tr>
              <th scope="col">&bull;&nbsp;첨부파일  </th>
			  <td><%=StringUtil.makeAttachedFileLink((String)objInfoRsSH.getObject("ANS_ESTYLE_FILE_PATH"),(String)objInfoRsSH.getObject("REQ_ID"))%></td>
            </tr>
            <tr>
              <th scope="col">&bull;&nbsp;등록자  </th>
			  <td><%=(String)objInfoRsSH.getObject("REGR_NM")%></td>
            </tr>
            <tr>
              <th scope="col">&bull;&nbsp;등록일시  </th>
			  <td><%=StringUtil.getDate2((String)objInfoRsSH.getObject("REG_DT"))%></td>
            </tr>
            <tr>
              <th scope="col">&bull;&nbsp;답변 제출여부  </th>
			  <td><%=CodeConstants.getRequestStatus((String)objInfoRsSH.getObject("REQ_STT"))%></td>
            </tr>
            <tr>
              <th scope="col">&bull;&nbsp;위원회 제출여부  </th>
			  <td><%=CodeConstants.getCmtRequestAppoint((String)objInfoRsSH.getObject("CMT_REQ_APP_FLAG"))%></td>
            </tr>
        </table>
        <!-- /list view -->
        <!-- 중단 버튼-->
<!--
요구함 목록, 바인딩, 요구서 보기, 답변서 미리 보기, 답변서 발송, 오프라인 제출
<div id="btn_all"  class="t_right">
 <div class="mi_btn"><a href="#"><span>의원실 명의 요구서 발송</span></a></div>
-->
         <div id="btn_all">
			<div  class="t_right">
		<%
			//요구함상태가 결재중이면 이동 수정 삭제가 불가능해짐.
			if(!strReqBoxStt.equals(CodeConstants.REQ_BOX_STT_004)) {
				/** 등록자와  로그인자가 같을때만 화면에 출력함.*/
				if(objUserInfo.getUserID().equals((String)objInfoRsSH.getObject("REGR_ID"))) {
		%>
		<%
					if(((String)objInfoRsSH.getObject("REQ_STT")).equals(CodeConstants.REQ_STT_SUBMT)) { //제출완료된것에 한해서 추가요구가능
		%>
			 <div class="mi_btn"><a href="javascript:requestAddAnswer()"><span>추가 답변 요구</span></a></div>
		<%
					}//endif 추가요구
				}//endif
			}//end if

		%>
		<%
			// 2005-08-22 kogaeng ADD
			// 2005-08-29 kogaeng EDIT
			// 조건 1 : 만들어진 요구함의 소관 위원회 소속 의원실 이어야 한다.
			// 조건 2 : 소속 기관이 의원실이어야 한다.
			// 조건 3 : 요구 일정 자동 생성을 사용하지 않아야 한다.
			if(objUserInfo.getIsMyCmtOrganID((String)objInfoRsSH.getObject("CMT_ORGAN_ID")) && ((String)objInfoRsSH.getObject("CMT_REQ_APP_FLAG")).equals(CodeConstants.CMT_REQ_APP_FLAG_MEM) && !objCmtSubmt.checkCmtOrganMakeAutoSche((String)objInfoRsSH.getObject("CMT_ORGAN_ID"))) {
		%>
			  <div class="mi_btn"><a href="javascript:appointCmtReq()"><span>위원회 제출 신청</span></a></div>
		<%
			}
		%>
			</div>
		 </div><br><br>

        <!-- /중단 버튼-->
        <!-- list -->
        <span class="list01_tl">답변 목록 <span class="list_total">&bull;&nbsp;전체자료수 : <%=objRs.getRecordSize()%>개</span></span>
        <table>
			<tr><td>&nbsp;</td></tr>
		</table>



        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
          <thead>
            <tr>
			  <th scope="col"><a>NO</a></th>
              <th scope="col"><a>제출의견</a></th>
              <th scope="col"><a>작성자</a></th>
              <th scope="col"><a>공개</a></th>
              <th scope="col"><a>답변</a></th>
              <th scope="col"><a>답변일자</a></th>
            </tr>
          </thead>
          <tbody>
		<%
		  int intRecordNumber=1;
		  String strAnsInfoID="";
		  while(objRs.next()){
			 strAnsInfoID=(String)objRs.getObject("ANS_ID");
		 %>
            <tr>
              <td><%=intRecordNumber%></td>
              <td><a href="JavaScript:gotoAnsInfoView('<%=strAnsInfoID%>');"><%=StringUtil.substring((String)objRs.getObject("ANS_OPIN"),35)%></a></td>
              <td><%=(String)objRs.getObject("ANSWER_NM")%></td>
              <td><%=CodeConstants.getOpenClass(((String)objRs.getObject("OPEN_CL")))%></td>
              <td><%=nads.lib.reqsubmit.util.DBAccessUtil.makeAnsInfoHtml(strAnsInfoID,(String)objRs.getObject("ANS_MTD"))%></td>
              <td><%=StringUtil.getDate((String)objRs.getObject("ANS_DT"))%></td>
            </tr>
		<%
				intRecordNumber++;
			} //endwhile
		%>
	<%
	/*조회결과 없을때 출력 시작.*/
	if(objRs.getRecordSize()<1){
	%>
			<tr>
				<td colspan="6" align="cneter">제출된 답변정보가 없습니다.</td>
			</tr>
	<%
		}/*조회결과 없을때 출력 끝.*/
	%>
          </tbody>
        </table>
        <!-- /각페이지 내용 -->
      </div>
      <!-- /contents -->

    </div>
</form>
  </div>
  <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>
