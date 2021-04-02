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
<%@ page import="nads.lib.reqsubmit.params.requestinfo.RMemReqInfoListViewForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.MemRequestInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.answerinfo.MemAnswerInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.cmtsubmt.CmtSubmtReqBoxDelegate" %>

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

	/**일반 요구함 상세보기 파라미터 설정.*/
	RMemReqInfoListViewForm objParams =new RMemReqInfoListViewForm();
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

	/*************************************************************************************************/
	/** 					데이터 호출 Part 														  */
	/*************************************************************************************************/

	/*** Delegate 과 데이터 Container객체 선언 */
	MemRequestInfoDelegate  objReqInfo=null;	/** 요구정보 Delegate */
	CmtSubmtReqBoxDelegate objCmtSubmt = null;

	ResultSetSingleHelper objInfoRsSH=null;	/**요구 정보 상세보기 */
	ResultSetHelper objRs=null;				/** 답변정보 목록 출력*/

	try {
		/**요구함 정보 대리자 New */
		objReqInfo=new MemRequestInfoDelegate();
		objCmtSubmt = new CmtSubmtReqBoxDelegate();

		/**요구함 이용 권한 체크 */
		boolean blnHashAuth=objReqInfo.checkReqInfoAuth((String)objParams.getParamValue("ReqInfoID"),objUserInfo.getOrganID()).booleanValue();
		if(!blnHashAuth){
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
			objRs = new ResultSetHelper(new MemAnswerInfoDelegate().getRecordList((String)objParams.getParamValue("ReqInfoID"), "Y"));/**제출만 Y */

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
%>
<jsp:include page="/inc/header.jsp" flush="true"/>
<script language="javascript">
  /**요구정보 수정페이지로 가기.*/
  function gotoEditPage(){
  	if(confirm("요구정보 공개등급을 수정하시겠습니까?")){
	  	formName.action="/reqsubmit/common/ChangeReqInfoOpenCLProc2.jsp";
  		formName.submit();
  	}
  }

  /** 목록으로 가기 */
  function gotoList(){
  	formName.action="./RNonReqList.jsp";
  	formName.submit();
  }
</script>
<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>
</head>

<body>
<div id="wrap">
<div id="balloonHint" style="display:none">
<table border="0" cellspacing="0" cellpadding="4">
<tr><td class="td_top" style="border-left:1px solid #808080;border-top:1px solid #808080;border-bottom:2px solid #808080;border-right:2px solid #808080"><font style="font-size:11px;font-family:verdana,돋움">{{hint}}</font></td></tr>
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
			<input type="hidden" name="AuditYear" value="<%=objParams.getParamValue("AuditYear")%>">
			<input type="hidden" name="CmtOrganID" value="<%=objParams.getParamValue("CmtOrganID")%>">
			<input type="hidden" name="RltdDuty" value="<%=objParams.getParamValue("RltdDuty")%>">
			<input type="hidden" name="CmtReqAppFlag" value="<%=objParams.getParamValue("CmtReqAppFlag")%>">
			<input type="hidden" name="ReqInfoSortField" value="<%=objParams.getParamValue("ReqInfoSortField")%>"><!--요구정보 목록정렬필드 -->
			<input type="hidden" name="ReqInfoSortMtd" value="<%=objParams.getParamValue("ReqInfoSortMtd")%>"><!--요구정보 목록정령방법-->
			<input type="hidden" name="ReqInfoQryField" value="<%=objParams.getParamValue("ReqInfoQryField")%>"><!--요구정보 조회 필드-->
			<input type="hidden" name="ReqInfoQryTerm" value="<%=objParams.getParamValue("ReqInfoQryTerm")%>"><!--요구정보 조회어-->
			<input type="hidden" name="ReqInfoPage" value="<%=objParams.getParamValue("ReqInfoPage")%>"><!--요구정보 페이지 번호 -->
			<input type="hidden" name="ReqInfoID" value="<%=objParams.getParamValue("ReqInfoID")%>"><!--요구정보 ID-->
			<input type="hidden" name="AnsInfoID" value=""><!--답변정보ID -->
			<input type="hidden" name="AnsID" value=""><!--답변정보ID -->
			<input type="hidden" name="ReturnUrl" value="<%=request.getRequestURI()%>"><!--되돌아올 URL -->
			<input type="hidden" name="CmtReqAppFlag" value="<%=objParams.getParamValue("CmtReqAppFlag")%>">

      <!-- pgTit -->

      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=MenuConstants.REQ_INFO_LIST_SUBMT_NONE%> <span class="sub_stl" >- <%=MenuConstants.REQ_INFO_DETAIL_VIEW%></span></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> > <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.getReqBoxGeneral(request)%> > <%=MenuConstants.REQ_INFO_LIST_SUBMT_NONE%></div>
        <p><!--문구--></p>
      </div>
      <!-- /pgTit -->

      <!-- contents -->

      <div id="contents">
        <!-- 검색조건 없는 경우 아래 div 삭제 나 주석으로 막으세요.-->
        <!-- /검색조건-->


        <!-- 각페이지 내용 -->
         <!-- list view-->

        <span class="list02_tl">요구정보 </span>

        <!-- 상단 버튼

		-->
         <div class="top_btn">
			<samp>
		<!-- 제출 완료 -->
		<%
		  //요구함 진행 상태.
		  String strReqBoxStt=(String)objInfoRsSH.getObject("REQ_BOX_STT");
		%>
		<%
			//요구함상태가 결재중이면 이동 수정 삭제가 불가능해짐.
			if(!strReqBoxStt.equals(CodeConstants.REQ_BOX_STT_004) && objUserInfo.getUserID().equals((String)objInfoRsSH.getObject("REGR_ID"))) {
		%>
			 <span class="btn"><a href="#" onclick="gotoEditPage()">공개 설정 저장</a></span>
		<%
			} // end if check status
		%>
			 <span class="btn"><a href="#" onclick="viewReqHistory('<%=objParams.getParamValue("ReqInfoID")%>')">요구 이력 보기</a></span>
			 <span class="btn"><a href="#" onclick="gotoList()">요구 목록</a></span>
			 </samp>
		 </div>

        <!-- /상단 버튼-->

        <table border="0" cellspacing="0" cellpadding="0" width="680" class="list02">

            <tr>
                <th height="25">&bull; 요구제목 </th>
                <td height="25" colspan="3"><strong><%=StringUtil.getDescString((String)objInfoRsSH.getObject("REQ_CONT"))%></strong></td>
            </tr>
            <tr>
                <th height="25">&bull; 요구내용 </th>
                <td height="25" colspan="3"><%=StringUtil.getDescString((String)objInfoRsSH.getObject("REQ_DTL_CONT"))%>
                <%=nads.dsdm.app.reqsubmit.delegate.requestinfo.RequestInfoDelegate.getAppendRequestInfo((List)objInfoRsSH.getObject("TBDS_REQ_LOG"))%>
				</td>
            </tr>
		<%
			// 2004-07-08 사무처, 예정처일 경우에는 위원회라는건 보이지마
			if (CodeConstants.ORGAN_GBN_ASM.equalsIgnoreCase(objUserInfo.getOrganGBNCode()) || CodeConstants.ORGAN_GBN_BUD.equalsIgnoreCase(objUserInfo.getOrganGBNCode())) {
			} else {
		%>
            <tr>
                <th height="25">&bull; 소관 위원회 </th>
                <td height="25" colspan="3"><%=objInfoRsSH.getObject("CMT_ORGAN_NM")%></td>
            </tr>
		 <% } %>
            <tr>
                <th height="25">&bull; 요구함명 </th>
                <td height="25" colspan="3"><%=objInfoRsSH.getObject("REQ_BOX_NM")%></td>
            </tr>
            <tr>
                <th height="25" width="18%">&bull; 요구기관 </th>
                <td height="25" width="32%"><%=(String)objInfoRsSH.getObject("REQ_ORGAN_NM")%> (<%=(String)objInfoRsSH.getObject("REGR_NM")%>)</td>
                <th height="25" width="18%">&bull;&nbsp;제출기관</th>
                <td height="25" width="32%"><%=(String)objInfoRsSH.getObject("SUBMT_ORGAN_NM")%></td>
            </tr>
            <tr>
                <th height="25">&bull; 공개등급 </th>
                <td height="25">
					<select name="OpenCL" class="select_reqsubmit">
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
                <th height="25">&bull;&nbsp;제출양식파일 </th>
                <td height="25">
					<%=StringUtil.makeAttachedFileLink((String)objInfoRsSH.getObject("ANS_ESTYLE_FILE_PATH"),(String)objInfoRsSH.getObject("REQ_ID"))%>
				</td>
            </tr>
            <tr>
                <th height="25">&bull; 제출기한 </th>
                <td height="25"><%= StringUtil.getDate((String)objInfoRsSH.getObject("SUBMT_DLN")) %> 24:00</td>
                <th height="25">&bull;&nbsp;요구일시</th>
                <td height="25"><%=StringUtil.getDate2((String)objInfoRsSH.getObject("REG_DT"))%></td>
            </tr>
            <tr>
                <th height="25">&bull; 답변 제출상태 </th>
                <td height="25"><%=CodeConstants.getRequestStatus((String)objInfoRsSH.getObject("REQ_STT"))%></td>
                <th height="25">&bull;&nbsp;위원회 제출상태</th>
                <td height="25"><%=CodeConstants.getCmtRequestAppoint((String)objInfoRsSH.getObject("CMT_REQ_APP_FLAG"))%></td>
            </tr>
        </table>
        <!-- /list view -->
<!--        <p class="warning mt10">* 요구서 발송 : 의원실(또는 소속기관) 명의로 해당 제출기관에 요구서를 발송합니다.</p>
-->
        <!-- 중단 버튼 -->
         <div id="btn_all">
			<div  class="t_right">
		<!-- 제출 완료 -->
		<%
			//요구함상태가 결재중이면 이동 수정 삭제가 불가능해짐.
			if(!strReqBoxStt.equals(CodeConstants.REQ_BOX_STT_004) && objUserInfo.getUserID().equals((String)objInfoRsSH.getObject("REGR_ID"))) {
				if(((String)objInfoRsSH.getObject("CMT_REQ_APP_FLAG")).equals(CodeConstants.CMT_REQ_APP_FLAG_MEM) && objUserInfo.getIsMyCmtOrganID((String)objInfoRsSH.getObject("CMT_ORGAN_ID")) && !objCmtSubmt.checkCmtOrganMakeAutoSche((String)objInfoRsSH.getObject("CMT_ORGAN_ID"))) {
					// 2004-07-08 사무처, 예정처일 경우에는 위원회라는건 보이지마
					if (CodeConstants.ORGAN_GBN_ASM.equalsIgnoreCase(objUserInfo.getOrganGBNCode()) || CodeConstants.ORGAN_GBN_BUD.equalsIgnoreCase(objUserInfo.getOrganGBNCode())) {
					} else {
		%>
			 <div class="mi_btn"><a href="#" onclick="appointCmtReq()"><span>위원회 제출 신청</span></a></div>
		<%
					}
				}

			} // end if check status
		%>

			</div>
		 </div>

        <!-- /중단 버튼-->

        <!-- list -->
  <%
		// 2005-10-04 kogaeng ADD
		// 추가답변인 경우 기존에 등록된 답변의 목록을 보인다.
		if(CodeConstants.REQ_STT_ADD.equals((String)objInfoRsSH.getObject("REQ_STT"))) {
  %>
        <span class="list01_tl">답변목록 <span class="list_total">&bull;&nbsp;전체자료수 :  <%=objRs.getRecordSize()%>개 </span></span>
<!--
checkbox
<input name="" type="checkbox" value="" class="borderNo" />
-->
        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
          <thead>
            <tr>
              <th scope="col">NO</th>
              <th scope="col">제출 의견</th>
              <th scope="col">작성자</th>
              <th scope="col">공개여부</th>
              <th scope="col">답변</th>
              <th scope="col">답변일자</th>
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
                <td height="22" width="19" align="center"><%=intRecordNumber%></td>
                <td width="370" class="td_lmagin"><a href="JavaScript:gotoAnsInfoView('<%=strAnsInfoID%>');"><%=StringUtil.substring((String)objRs.getObject("ANS_OPIN"),35)%></a></td>
                <td width="100" align="center"><%=(String)objRs.getObject("ANSWER_NM")%></td>
                <td width="80" align="center"><%=CodeConstants.getOpenClass(((String)objRs.getObject("OPEN_CL")))%></td>
                <td width="120" align="center"><%=nads.lib.reqsubmit.util.DBAccessUtil.makeAnsInfoHtml(strAnsInfoID,(String)objRs.getObject("ANS_MTD"))%></td>
                <td width="70" align="right" style="padding-top:2px;padding-bottom:2px"><%=StringUtil.getDate2((String)objRs.getObject("ANS_DT"))%></td>
            </tr>
	<%
			intRecordNumber ++;
		}//endwhile
	%>

<!--
	자료가 없을 경우
			<tr>
			 <td colspan="6"  align ="center"> 등록된 요구정보가 없습니다. </td>
            </tr>
-->
          </tbody>
        </table>
	 <%
			}
	  %>

        <!-- /list -->

        <!-- 페이징
        <span class="paging" > <span class="list_num_on"><a href="#">1</a></span> <span class="list_num"><a href="#">2</a></span> <span class="list_num"><a href="#">3</a></span> <span class="list_num"><a href="#">4</a></span> <span class="list_num"><a href="#">5</a></span> </span>

         /페이징-->


       <!-- 리스트 버튼
        <div id="btn_all" >
		<!-- 리스트 내 검색 -->
<!--
		<div class="list_ser" >
          <select name="select" class="selectBox5"  style="width:70px;" >
            <option value="">요구제목</option>
            <option value="">요구내용</option>
          </select>
          <input name="iptName" onKeyDown="return ch()" onMouseDown="return ch()"
		 class="li_input"  style="width:100px"/>
          <img src="/images2/btn/bt_list_search.gif"  onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"/> </div>
-->
        <!-- /리스트 내 검색
			<span class="right">
				<span class="list_bt"><a href="#">요구복사</a></span>
				<span class="list_bt"><a href="#">요구이동</a></span>
				<span class="list_bt"><a href="#">요구삭제</a></span>
				<span class="list_bt"><a href="#">요구복사</a></span>
			</span>
		</div>

         /리스트 버튼-->
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