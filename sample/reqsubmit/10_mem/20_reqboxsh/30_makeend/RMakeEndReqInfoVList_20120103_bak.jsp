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
  RMemReqInfoVListForm objParams =new RMemReqInfoVListForm();
  boolean blnParamCheck=false;
  /**전달된 파리미터 체크 */
  blnParamCheck=objParams.validateParams(request);
  if(blnParamCheck==false){
  	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	objMsgBean.setStrCode("DSPARAM-0000");
  	objMsgBean.setStrMsg(objParams.getStrErrors());
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
 MemRequestInfoDelegate  objReqInfo=null;	/** 요구정보 Delegate */
 ResultSetSingleHelper objInfoRsSH=null;	/**요구 정보 상세보기 */
 ResultSetHelper objRs=null;				/** 답변정보 목록 출력*/
 CmtSubmtReqBoxDelegate objCmtSubmt = null;

 try{
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
  }else{
    objInfoRsSH=new ResultSetSingleHelper(objReqInfo.getRecord2((String)objParams.getParamValue("ReqInfoID")));
    objRs=new ResultSetHelper(new MemAnswerInfoDelegate().getRecordList((String)objParams.getParamValue("ReqInfoID"),"Y"));/**제출만 Y */
  }/**권한 endif*/
 }catch(AppException objAppEx){
 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  	objMsgBean.setStrCode(objAppEx.getStrErrCode());
  	objMsgBean.setStrMsg(objAppEx.getMessage());
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
	  	formName.action="/reqsubmit/common/ChangeReqInfoOpenCLProc.jsp";
  		formName.submit();
  	}
  }
  /** 목록으로 가기 */
  function gotoList(){
  	formName.action="./RMakeEndVList.jsp";
  	formName.submit();
  }
  /** 공식요구지정 */
  function appointCmtReq(){
  	if(confirm("요구제목을 위원회에 제출신청하시겠습니까?")){
	  	formName.action="/reqsubmit/10_mem/20_reqboxsh/40_commreq/RCommReqInfoApplySingleProc.jsp";
	  	formName.submit();
  	}
  }
  /**답변승인상태 수정하기.*/
  function gotoEditPage2(){
  	if(confirm("요구정보 답변승인상태를 수정하시겠습니까?")){
	  	formName.action="/reqsubmit/common/ChangeReqInfoAnsApprSttProc.jsp";
  		formName.submit();
  	}
  }
</script>
<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>
</head>

<body>
<div id="wrap">
<SCRIPT language="JavaScript" src="/js/reqsubmit/reqinfo.js"></SCRIPT>
  <jsp:include page="/inc/top.jsp" flush="true"/>
  <jsp:include page="/inc/top_menu02.jsp" flush="true"/>
  <div id="container">
    <div id="leftCon">
      <jsp:include page="/inc/log_info.jsp" flush="true"/>
      <jsp:include page="/inc/left_menu02.jsp" flush="true"/>
    </div>
    <div id="rightCon">
      <!-- pgTit -->
      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=MenuConstants.REQ_BOX_MAKE_END%> <span class="sub_stl" >- <%=MenuConstants.REQ_INFO_DETAIL_VIEW%></span></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> > <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.getReqBoxGeneral(request)%> > <%=MenuConstants.REQ_BOX_MAKE_END%></div>
        <p>제출기관에게 보낼 요구함의 요구제목을 확인하는 화면입니다. </p>
      </div>
      <!-- /pgTit -->

      <!-- contents -->

      <div id="contents">
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
			<input type="hidden" name="AnsID" value=""><!--답변정보ID -->
			<input type="hidden" name="WinType" value="SELF">
			<input type="hidden" name="ReturnUrl" value="<%=request.getRequestURI()%>"><!--되돌아올 URL -->
			<input type="hidden" name="Rsn" value=""><!--추가요구 -->

        <!-- 검색조건 없는 경우 아래 div 삭제 나 주석으로 막으세요.-->
        <!-- /검색조건-->


        <!-- 각페이지 내용 -->
         <!-- list view-->

        <span class="list02_tl">요구정보 </span>
        <table border="0" cellspacing="0" cellpadding="0" width="680" class="list02">

            <tr>
                <th height="25">&bull; 요구제목 </th>
                <td height="25" colspan="3"><strong><%=StringUtil.getDescString((String)objInfoRsSH.getObject("REQ_CONT"))%></strong></td>
            </tr>
            <tr>
                <th height="25">&bull; 요구내용 </th>
                <td height="25" colspan="3">- <%=StringUtil.getDescString((String)objInfoRsSH.getObject("REQ_DTL_CONT"))%>
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
                <td height="25" colspan="3"><%=objInfoRsSH.getObject("CMT_ORGAN_NM")%> </td>
            </tr>
		 <% } %>
            <tr>
                <th height="25">&bull; 요구함명 </th>
                <td height="25" colspan="3"><%=objInfoRsSH.getObject("REQ_BOX_NM")%></td>
            </tr>
            <tr>
                <th height="25">&bull; 요구기관 </th>
                <td height="25"><%=(String)objInfoRsSH.getObject("REQ_ORGAN_NM")%></td>
                <th height="25">&bull;&nbsp;제출기관</th>
                <td height="25"> <span class="list_bts"><%=(String)objInfoRsSH.getObject("SUBMT_ORGAN_NM")%></span></td>
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
                <th height="25" width="149">&bull;&nbsp;첨부파일 </th>
                <td height="25">
					<%=StringUtil.makeAttachedFileLink((String)objInfoRsSH.getObject("ANS_ESTYLE_FILE_PATH"),(String)objInfoRsSH.getObject("REQ_ID"))%>
				</td>
            </tr>
            <tr>
                <th height="25">&bull; 등록자 </th>
                <td height="25"><%=(String)objInfoRsSH.getObject("REGR_NM")%></td>
                <th height="25" width="149">&bull;&nbsp;등록일시</th>
                <td height="25"><%=StringUtil.getDate2((String)objInfoRsSH.getObject("REG_DT"))%></td>
            </tr>
            <tr>
                <th height="25">&bull; 답변 제출여부 </th>
                <td height="25"><%=CodeConstants.getRequestStatus((String)objInfoRsSH.getObject("REQ_STT"))%></td>
                <th height="25" width="149">&bull;&nbsp;위원회 제출여부</th>
                <td height="25"><%=CodeConstants.getCmtRequestAppoint((String)objInfoRsSH.getObject("CMT_REQ_APP_FLAG"))%></td>
            </tr>
            <tr>
                <th height="25">&bull; 답변 승인상태 </th>
                <td height="25">
					<select name="ANSW_PERM_CD" class="select_reqsubmit">
					<%
						List objAnsApprSttList=CodeConstants.getAnsApprSttList();
						String strAnsApprStt=(String)objInfoRsSH.getObject("ANSW_PERM_CD");
						for(int i=0;i<objAnsApprSttList.size();i++){
							String strCode=(String)((Hashtable)objAnsApprSttList.get(i)).get("Code");
							String strValue=(String)((Hashtable)objAnsApprSttList.get(i)).get("Value");
							out.println("<option value=\"" + strCode + "\"" + StringUtil.getSelectedStr(strAnsApprStt,strCode) + ">" + strValue + "</option>");
						}
					%>
					</select>
				</td>
                <th height="25" width="149">&nbsp;</th>
                <td height="25">&nbsp;</td>
            </tr>
        </table>
        <!-- /list view -->
<!--        <p class="warning mt10">* 요구서 발송 : 의원실(또는 소속기관) 명의로 해당 제출기관에 요구서를 발송합니다.</p>
-->
        <!-- 리스트 버튼-->
         <div id="btn_all"class="t_right">
		<!-- 제출 완료 -->
		<%
		  //요구함 진행 상태.
		  String strReqBoxStt=(String)objInfoRsSH.getObject("REQ_BOX_STT");
		%>
		<%
			//요구함상태가 결재중이면 이동 수정 삭제가 불가능해짐.
			if(!strReqBoxStt.equals(CodeConstants.REQ_BOX_STT_004)) {
				/** 등록자와  로그인자가 같을때만 화면에 출력함.*/
				if(((String)objInfoRsSH.getObject("REQ_STT")).equals(CodeConstants.REQ_STT_SUBMT)) {
		%>
			 <span class="list_bt"><a href="javascript:requestAddAnswer()">추가 답변 요구</a></span>
		<%
				}//endif 추가요구
		%>
			 <span class="list_bt"><a href="javascript:gotoEditPage2()">답변승인상태저장</a></span>
             <span class="list_bt"><a href="javascript:gotoEditPage()">공개 설정 저장</a></span>
		<%
			}//endif
		%>
		<%
			// 2005-08-22 kogaeng ADD
			// 2005-08-29 kogaeng EDIT
			// 조건 1 : 만들어진 요구함의 소관 위원회 소속 의원실 이어야 한다.
			// 조건 2 : 소속 기관이 의원실이어야 한다.
			// 조건 3 : 요구 일정 자동 생성을 사용하지 않아야 한다.
			if(objUserInfo.getIsMyCmtOrganID((String)objInfoRsSH.getObject("CMT_ORGAN_ID")) && ((String)objInfoRsSH.getObject("CMT_REQ_APP_FLAG")).equals(CodeConstants.CMT_REQ_APP_FLAG_MEM) && !objCmtSubmt.checkCmtOrganMakeAutoSche((String)objInfoRsSH.getObject("CMT_ORGAN_ID"))) {
		%>
			 <span class="list_bt"><a href="javascript:appointCmtReq()">위원회 제출 신청</a></span>
		<%
			}
		%>
			 <span class="list_bt"><a href="javascript:viewReqHistory('<%=objParams.getParamValue("ReqInfoID")%>')">요구 이력 보기</a></span>
			 <span class="list_bt"><a href="javascript:gotoList()">요구함 상세 보기</a></span>
		 </div>

        <!-- /리스트 버튼-->

        <!-- list -->
        <span class="list01_tl">답변목록 <span class="list_total">&bull;&nbsp;전체자료수 :  <%=objRs.getRecordSize()%>개 </span></span>
		<table>
			<tr>
				<td>&nbsp;</td>
			</tr>
		</table>
<!--
checkbox
<input name="" type="checkbox" value="" class="borderNo" />
-->
        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
          <thead>
            <tr>
              <th scope="col" style="width:10px; ">NO</th>
              <th scope="col" style="width:250px; ">제출 의견</th>
              <th scope="col" style="width:50px; ">작성자</th>
              <th scope="col" >공개여부</th>
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
              <td><%=intRecordNumber%></td>
              <td style="text-align:left;"><a href="JavaScript:gotoAnsInfoView('<%=strAnsInfoID%>');"><%=StringUtil.substring((String)objRs.getObject("ANS_OPIN"),35)%></a></td>
              <td style="text-align:center;"><%=(String)objRs.getObject("ANSWER_NM")%></td>

              <td><%=CodeConstants.getOpenClass(((String)objRs.getObject("OPEN_CL")))%></td>
              <td><%=nads.lib.reqsubmit.util.DBAccessUtil.makeAnsInfoHtml(strAnsInfoID,(String)objRs.getObject("ANS_MTD"))%></td>
              <td><%=StringUtil.getDate2((String)objRs.getObject("ANS_DT"))%></td>
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