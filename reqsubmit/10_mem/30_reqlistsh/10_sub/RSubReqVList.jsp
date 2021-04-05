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
<%@ page import="nads.dsdm.app.reqsubmit.delegate.answerinfo.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.cmtsubmt.CmtSubmtReqBoxDelegate" %>
<%@ page import="nads.dsdm.app.common.page.PagingDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.SMemReqBoxDelegate" %>

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
	//추가답변 후 제출여부확인
    SMemReqBoxDelegate sReqDelegate = new SMemReqBoxDelegate();
    //요구함클릭시 ANSW_INQ_YN을 변경 2016.02.17 ksw
  	AnsInfoDelegate objSMAIDelegate = new AnsInfoDelegate();
	
	String strBoxId = (String)request.getParameter("ReqBoxId");
	System.out.println("kangthis logs RSubReqVList.jsp strBoxId => " + strBoxId);
	
	//답변완료된 후에 추가답변 있는지 여부 확인
	int intNotSubmitAnsCnt = sReqDelegate.getAnsCntNotSubmit(strBoxId);
	System.out.println("kangthis logs RMakeEndVList.jsp(strBoxId) => " + strBoxId);
	System.out.println("kangthis logs RMakeEndVList.jsp(intNotSubmitAnsCnt) => " + intNotSubmitAnsCnt);
	if (intNotSubmitAnsCnt > 0) {
			int intUpdateResult = objSMAIDelegate.setRecordToAnsInfo_view1(strBoxId);	
	}

	try{
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
		}else{
			objInfoRsSH=new ResultSetSingleHelper(objReqInfo.getRecord2((String)objParams.getParamValue("ReqInfoID")));
			objRs=new ResultSetHelper(new MemAnswerInfoDelegate().getRecordList((String)objParams.getParamValue("ReqInfoID"),"Y"));/**제출만 Y */
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
	  	formName.action="/reqsubmit/common/ChangeReqInfoOpenCLProc.jsp";
  		formName.submit();
  	}
  }
  /** 목록으로 가기 */
  function gotoList(){
  	formName.action="./RSubReqList.jsp";
  	formName.submit();
  }
  /**답변승인상태 수정하기.*/
  function gotoEditPage2(){
  	if(confirm("요구정보 답변승인상태를 수정하시겠습니까?")){
	  	formName.action="/reqsubmit/common/ChangeReqInfoAnsApprSttProc.jsp";
  		formName.submit();
  	}
  }

   function gotoAnsInfoView2(strID,strSeq){  	
	
	  var tmpAction=formName.action;
	
	  var tmpTarget=formName.target;
	
	  var w = 500;
	
	  var h = 400;
	
	  var winl = (screen.width - w) / 2;
	
	  var wint = (screen.height - h) / 2;
	
	
	  formName.AnsID.value = strID;  
	  formName.AnsSEQ.value = strSeq;  
	
	  formName.action="/reqsubmit/common/SAnsInfoView.jsp";  	
	
	  formName.target="popwin";  	
	
	  window.open('about:blank', 'popwin', 
'width='+w+',height='+h+', left='+winl+', top='+wint+', scrollbars=no, resizable=yes, toolbar=no, menubar=no, location=no, directories=no, status=no');
	  formName.submit(); 
	  formName.action=tmpAction;
	
	  formName.target=tmpTarget;
 
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
      <!-- pgTit -->
      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=MenuConstants.REQ_INFO_LIST_SUBMT_DONE%> <span class="sub_stl" >- <%=MenuConstants.REQ_INFO_DETAIL_VIEW%></span></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> > <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.getReqBoxGeneral(request)%> > <%=MenuConstants.REQ_INFO_LIST_SUBMT_DONE%></div>
        <p><!--문구--></p>
      </div>
      <!-- /pgTit -->

      <!-- contents -->

      <div id="contents">
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
		<input type="hidden" name="AnsSEQ" value="">
		<input type="hidden" name="WinType" value="SELF"><!--답변정보ID -->
		<input type="hidden" name="ReturnUrl" value="<%=request.getRequestURI()%>"><!--되돌아올 URL -->
		<input type="hidden" name="Rsn" value=""><!--추가요구 -->
		<input type="hidden" name="CmtReqAppFlag" value="<%=objParams.getParamValue("CmtReqAppFlag")%>">

        <!-- 검색조건 없는 경우 아래 div 삭제 나 주석으로 막으세요.-->
        <!-- /검색조건-->


        <!-- 각페이지 내용 -->
         <!-- list view-->

        <span class="list02_tl">요구 정보 </span>

        <!-- 상단 버튼-->
         <div class="top_btn">
			<samp>
		<!-- 제출 완료 -->
		 <%
		  //요구함 진행 상태.
		  String strReqBoxStt=(String)objInfoRsSH.getObject("REQ_BOX_STT");
		%>
		<%
			//요구함상태가 결재중이면 이동 수정 삭제가 불가능해짐.
			if(!strReqBoxStt.equals(CodeConstants.REQ_BOX_STT_004)) {

				/** 등록자와  로그인자가 같을때만 화면에 출력함.*/
				//if(objUserInfo.getUserID().equals((String)objInfoRsSH.getObject("REGR_ID"))) {
					if(objUserInfo.getIsMyCmtOrganID((String)objInfoRsSH.getObject("CMT_ORGAN_ID")) && ((String)objInfoRsSH.getObject("CMT_REQ_APP_FLAG")).equals(CodeConstants.CMT_REQ_APP_FLAG_MEM) && !objCmtSubmt.checkCmtOrganMakeAutoSche((String)objInfoRsSH.getObject("CMT_ORGAN_ID"))) { //의원실에서만든것만이면..

						// 2004-07-08 사무처, 예정처일 경우에는 위원회라는건 보이지마
						if (CodeConstants.ORGAN_GBN_ASM.equalsIgnoreCase(objUserInfo.getOrganGBNCode()) || CodeConstants.ORGAN_GBN_BUD.equalsIgnoreCase(objUserInfo.getOrganGBNCode())) {
						} else {
		%>

			            <span class="btn"><a href="appointCmtReq()">추가 답변 요구</a></span>
		<%
						}
					} /*제출신청이나 공식지정된것아닌 의원실 순수의 것만보이자..*/

					if(objInfoRsSH.getObject("REQ_STT").equals(CodeConstants.REQ_STT_SUBMT)){//제출완료된것에 한해서 추가요구가능
		%>
			            <span class="btn"><a href="#" onclick="requestAddAnswer()">추가 답변 요구</a></span>
		<%
					} //endif 추가요구
		%>
		<%
				//} // end if check regr_id
			} // end if check status
		%>
			 <span class="btn"><a href="#" onclick="viewReqHistory('<%=objParams.getParamValue("ReqInfoID")%>')">요구 이력 조회</a></span>
			 <span class="btn"><a href="#" onclick="gotoList()">요구목록</a></span>
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
                <td height="25" colspan="3"><%=objInfoRsSH.getObject("CMT_ORGAN_NM")%></td>
            </tr>
		 <% } %>
            <tr>
                <th height="25">&bull; 요구함명 </th>
                <td height="25" colspan="3">
					<a href="<%=nads.dsdm.app.reqsubmit.delegate.requestinfo.RequestInfoDelegate.getGotoMemReqBoxURLReqr((String)objInfoRsSH.getObject("REQ_BOX_STT"))%>?ReqBoxID=<%=objInfoRsSH.getObject("REQ_BOX_ID")%>" hint="<%=objInfoRsSH.getObject("REQ_BOX_NM")%> 요구함으로 이동"><%=objInfoRsSH.getObject("REQ_BOX_NM")%>
				</td>
            </tr>
            <tr>
                <th height="25" width="18%">&bull; 요구기관 </th>
                <td height="25" width="32%">
					<%=(String)objInfoRsSH.getObject("REQ_ORGAN_NM")%> (<%=(String)objInfoRsSH.getObject("REGR_NM")%>)
				</td>
                <th height="25" width="18%">&bull;&nbsp;제출기관</th>
                <td height="25" width="32%"> <span class="list_bts"><%=(String)objInfoRsSH.getObject("SUBMT_ORGAN_NM")%></span></td>
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
                <th height="25">&bull; 등록일시 </th>
                <td height="25"><%=StringUtil.getDate2((String)objInfoRsSH.getObject("REG_DT"))%></td>
                <th height="25">&bull;&nbsp;답변일시</th>
                <td height="25"><%= StringUtil.getDate2((String)objInfoRsSH.getObject("LAST_ANS_DT"))%></td>
            </tr>
            <tr>
                <th height="25">&bull; 답변 제출상태 </th>
                <td height="25"><%=CodeConstants.getRequestStatus((String)objInfoRsSH.getObject("REQ_STT"))%></td>
                <th height="25">&bull;&nbsp;위원회 제출상태</th>
                <td height="25"><%=CodeConstants.getCmtRequestAppoint((String)objInfoRsSH.getObject("CMT_REQ_APP_FLAG"))%></td>
            </tr>
            <tr>
                <th height="25">&bull; 답변 승인상태 </th>
                <td height="25">
                    <%if(objInfoRsSH.getObject("REQ_STT").equals(CodeConstants.REQ_STT_SUBMT)){%>
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
                    <%} else {%>
                        <%
                            List objAnsApprSttList=CodeConstants.getAnsApprSttList();
                            String strAnsApprStt=(String)objInfoRsSH.getObject("ANSW_PERM_CD");
                            String strValue="";
                            for(int i=0;i<objAnsApprSttList.size();i++){
                                String strCode=(String)((Hashtable)objAnsApprSttList.get(i)).get("Code");

                                if (strAnsApprStt.equals(strCode)) {
                                    strValue=(String)((Hashtable)objAnsApprSttList.get(i)).get("Value");
                                }
                            }
                        %>
                        <%=strValue%><input type="hidden" name="ANSW_PERM_CD" value="<%=(String)objInfoRsSH.getObject("ANSW_PERM_CD")%>">
                    <%}%>
				</td>
                <th height="25">&nbsp;</th>
                <td height="25">&nbsp;</td>
            </tr>
        </table><br><br>

         <div id="btn_all">
			<div  class="t_right">
		<%
			//요구함상태가 결재중이면 이동 수정 삭제가 불가능해짐.
			if(!strReqBoxStt.equals(CodeConstants.REQ_BOX_STT_004)) {
		%>
	    		<div class="mi_btn"><a href="#" onclick="gotoEditPage()"><span>설정 저장</span></a></div>
		<%

			} // end if check status
		%>
			</div>
		 </div>

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
              <th scope="col" style="width:10px;"><a>NO</a></th>
              <th scope="col" style="width:250px;"><a>제출 의견</a></th>
              <th scope="col" style="width:50px;"><a>작성자</a></th>
              <th scope="col"><a>공개여부</a></th>
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
              <td><a href="JavaScript:gotoAnsInfoView2('<%=strAnsInfoID%>','<%=intRecordNumber%>');"><%=StringUtil.substring((String)objRs.getObject("ANS_OPIN"),35)%></a>
			  </td>
              <td><%=(String)objRs.getObject("ANSWER_NM")%></td>
              <td><%=CodeConstants.getOpenClass(((String)objRs.getObject("OPEN_CL")))%></td>
              <td><%=this.makeAnsInfoHtml2(strAnsInfoID,(String)objRs.getObject("ANS_MTD"),(String)objInfoRsSH.getObject("REQ_CONT"),intRecordNumber+"",(String)objInfoRsSH.getObject("SUBMT_ORGAN_NM"))%></td>
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

<%!
	public static String makeAnsInfoHtml2(String strAnsID,String strAnsMtd,String strReqCont,String strSeq,String strSubmt){
		StringBuffer strBufReturn=new StringBuffer();
		strBufReturn.append("<table width=\"100%\" border=\"0\"><tr>");
		if(strAnsMtd.equals(CodeConstants.ANS_MTD_ELEC)){
			strBufReturn.append("<td width='18' height='18' align='left' valign='top'>");
			strBufReturn.append("<img src='/image/reqsubmit/bt_EDoc.gif' width='73' height='16' border='0' >");
			strBufReturn.append("</td>");
			strBufReturn.append("<td width='37%' height='18' valign='top'>");
			strBufReturn.append("<a href='/reqsubmit/common/ReqFileOpen2.jsp?paramAnsId=" + strAnsID + "&DOC=PDF&REQNM=" + strReqCont + "&REQSEQ=" + strSeq + "&SubmtOrganNm="+strSubmt+"' target='_self'>");
			strBufReturn.append("<img src='/image/common/icon_pdf.gif' width='16' height='16' border='0' alt='PDF문서'>");
			strBufReturn.append("</a>");
			strBufReturn.append("&nbsp;<a href='/reqsubmit/common/ReqFileOpen2.jsp?paramAnsId=" + strAnsID + "&DOC=DOC&REQNM=" + strReqCont + "&REQSEQ=" + strSeq + "&SubmtOrganNm="+strSubmt+"' target='_self'>");
			strBufReturn.append("<img src='/image/common/icon_file.gif' border='0' alt='원본문서'>");
			strBufReturn.append("</a>");
			strBufReturn.append("</td>");
		}else if(strAnsMtd.equals(CodeConstants.ANS_MTD_ETCS)){
			strBufReturn.append("<td colspan='2' width='18' height='18' align='left' valign='top'>");
			strBufReturn.append("<img src='/image/reqsubmit/bt_NotEDoc.gif' width='73' height='16' border='0' >");
			strBufReturn.append("</td>");					
		}else if(strAnsMtd.equals("004")){
			strBufReturn.append("<td colspan=\\'2\\' width=\\'18\\' height=\\'18\\' align=\\'left\\' valign=\\'top\\'>");
			strBufReturn.append("<img src=\\'/image/reqsubmit/bt_offLineSubmit.gif\\' width=\\'73\\' height=\\'16\\' border=\\'0\\' alt=\\'오프라인을 통한 제출\\'>");
			strBufReturn.append("</td>");					
		}else {
			strBufReturn.append("<td colspan='2' width='18' height='18' align='left' valign='top'>");
			strBufReturn.append("<img src='/image/reqsubmit/bt_NotPertinentOrg.gif' width='73' height='16' border='0'>");
			strBufReturn.append("</td>");					
		}
		strBufReturn.append("</tr></table>");
		return strBufReturn.toString();
	}
%>