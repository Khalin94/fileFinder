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
	}

	//로그인 사용자 정보를 가져온다. 권한없음 경우 관람만 가능하다.
	String strReqSubmitFlag = objUserInfo.getReqSubmitFlag();
	String strOrganID = objUserInfo.getOrganID();

	/*** Delegate 과 데이터 Container객체 선언 */
	CommRequestBoxDelegate objReqBox=null; 		/**요구함 Delegate*/
	CommRequestInfoDelegate  objReqInfo=null;		/** 요구정보 Delegate */
	CommAnsInfoDelegate objAnsInfo = new CommAnsInfoDelegate();
	ResultSetSingleHelper objRsSH=null;			/** 요구함 상세보기 정보 */
	ResultSetSingleHelper objRsRI=null;			/** 요구 상세보기 정보 */
	ResultSetHelper objRs = null;					/** 답변 목록 */

	try {
		/**요구함 정보 대리자 New */
		objReqBox=new CommRequestBoxDelegate();
		/** 요구함 정보 */
		objRsSH=new ResultSetSingleHelper(objReqBox.getRecord((String)objParams.getParamValue("ReqBoxID")));
		/**요구함 이용 권한 체크 */
   		boolean blnHashAuth=objReqBox.checkReqBoxAuth((String)objParams.getParamValue("ReqBoxID"),objUserInfo.getCurrentCMTList()).booleanValue();
		if(!blnHashAuth){
			System.out.println("$$$$$$$2 : "+strOrganID+" 1 "+objRsSH.getObject("OLD_REQ_ORGAN_ID"));
			if(!strOrganID.equals((String)objRsSH.getObject("OLD_REQ_ORGAN_ID")))
{
				objMsgBean.setMsgType(MessageBean.TYPE_WARN);
				objMsgBean.setStrCode("DSAUTH-0001");
				objMsgBean.setStrMsg("해당 요구함을 볼 권한이 없습니다.");
				//out.println("해당 요구함을 볼 권한이 없습니다.");
	%>
				<jsp:forward page="/common/message/ViewMsg3.jsp"/>
	<%
				return;
			}else{
				/**요구 정보 대리자 New */
				objReqInfo=new CommRequestInfoDelegate();
				objRsRI=new ResultSetSingleHelper(objReqInfo.getRecord((String)request.getParameter("CommReqID")));
				// 답변 목록을 SELECT 한다.
				objRs = new ResultSetHelper(objAnsInfo.getRecordList((String)request.getParameter("CommReqID"),"Y"));
			}
		}
else{
			objReqInfo=new CommRequestInfoDelegate();
			objRsRI=new ResultSetSingleHelper(objReqInfo.getRecord((String)request.getParameter("CommReqID")));
			// 답변 목록을 SELECT 한다.
			objRs = new ResultSetHelper(objAnsInfo.getRecordList((String)request.getParameter("CommReqID"),"Y"));
		}


	} catch(AppException objAppEx) {
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
<script language="javascript">
	// 답변 상세보기로 가기
  	function gotoDetail(strID){
  		//window.open('/reqsubmit/common/SAnsInfoView.jsp?returnURL=POPUP&AnsID='+strID, '', 'width=520,height=400, scrollbars=no, resizable=yes, toolbar=no, menubar=no, location=no, directories=no, status=no');
  		NewWindow('/reqsubmit/common/SAnsInfoView.jsp?returnURL=POPUP&AnsID='+strID, '', 520, 400);
  	}
	//요구함 상세보기
  	function gotoReqBox(){
  	  	form = document.formName;
  		form.action="./RSubEndBoxVList.jsp";
  		form.submit();
  	}
	/**답변승인상태 수정하기.*/
	function gotoEditPage2(){
		if(confirm("요구정보 답변승인상태를 수정하시겠습니까?")){
			formName.action="/reqsubmit/common/ChangeReqInfoAnsApprSttProc.jsp";
			formName.submit();
		}
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
		<input type="hidden" name="ReqBoxID" value="<%=objParams.getParamValue("ReqBoxID")%>">
		<input type="hidden" name="CmtOrganID" value="<%=objParams.getParamValue("CmtOrganID")%>">
		<input type="hidden" name="CommReqInfoSortField" value="<%=strCommReqInfoSortField%>"><!--요구정보 목록정렬필드 -->
		<input type="hidden" name="CommReqInfoSortMtd" value="<%=strCommReqInfoSortMtd%>"><!--요구정보 목록정령방법-->
		<input type="hidden" name="CommReqInfoPage" value="<%=strCommReqInfoPagNum%>"><!--요구정보 페이지 번호 -->
		<input type="hidden" name="AuditYear" value="<%=objParams.getParamValue("AuditYear")%>">
		<input type="hidden" name="CommReqID" value="<%=(String)request.getParameter("CommReqID")%>"><!--요구정보 ID-->
		<input type="hidden" name="RltdDuty" value="<%=objParams.getParamValue("RltdDuty")%>">
		<input type="hidden" name="CommReqBoxSortField" value="<%=objParams.getParamValue("CommReqBoxSortField")%>"><!--요구함목록정렬필드 -->
		<input type="hidden" name="CommReqBoxSortMtd" value="<%=objParams.getParamValue("CommReqBoxSortMtd")%>"><!--요구함목록정령방법-->
		<input type="hidden" name="CommReqBoxPage" value="<%=objParams.getParamValue("CommReqBoxPage")%>"><!--요구함 페이지 번호 -->
		<input type="hidden" name="CommReqBoxQryField" value="<%=objParams.getParamValue("CommReqBoxQryField")%>"><!--요구함 조회필드 -->
		<input type="hidden" name="CommReqBoxQryTerm" value="<%=objParams.getParamValue("CommReqBoxQryTerm")%>"><!--요구함 조회어 -->
		<input type="hidden" name="ReqInfoID" value="<%=(String)request.getParameter("CommReqID")%>"><!--요구정보 ID-->
		<input type="hidden" name="Rsn" value="">
		<input type="hidden" name="ReturnUrl" value="<%=request.getRequestURI()%>?ReqBoxID=<%=(String)objParams.getParamValue("ReqBoxID")%>&ReqID=<%=(String)request.getParameter("CommReqID")%>&AuditYear=<%=objParams.getParamValue("AuditYear")%>">

      <!-- pgTit -->

      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=MenuConstants.COMM_REQ_BOX_SUBMT_END%><span class="sub_stl" >- 요구상세보기</span></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> > <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.REQUEST_BOX_COMM%> > <%=MenuConstants.COMM_REQ_BOX_SUBMT_END%></div>
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

        <!-- 상단 버튼 시작-->
         <div class="top_btn">
			<samp>
		<%
			/**위원회에서 신규등록한 요구에 한함-> 기준??*/
			if(objUserInfo.getOrganGBNCode().equals("004") && !strReqSubmitFlag.equals("004")){
				if(((String)objRsRI.getObject("REQ_STT")).equals(CodeConstants.REQ_STT_SUBMT)){//제출완료된것에 한해서 추가요구가능
		%>
			<span class="btn"><a href="javascript:requestAddAnswer()">추가 답변 요구</a></span>
			<%	 }
			} %>
			 <span class="btn"><a href="javascript:viewReqHistory('<%=(String)request.getParameter("CommReqID")%>')">요구 이력 보기</a></span>
			 <span class="btn"><a href="javascript:gotoReqBox()">요구함 보기</a></span>
			 </samp>
		 </div>

        <!-- /상단 버튼 끝-->

        <table border="0" cellspacing="0" cellpadding="0" width="680" class="list02">
            <tr>
                <th height="25">&bull; 요구제목 </th>
                <td height="25" colspan="3"><strong><%=objRsRI.getObject("REQ_CONT")%></strong>
				</td>
            </tr>
            <tr>
                <th height="25">&bull; 요구내용 </th>
                <td height="25" colspan="3">- <%=StringUtil.getDescString((String)objRsRI.getObject("REQ_DTL_CONT"))%>
               	<%=nads.dsdm.app.reqsubmit.delegate.requestinfo.RequestInfoDelegate.getAppendRequestInfo((List)objRsRI.getObject("TBDS_REQ_LOG"))%> </td>
            </tr>
		<%
			//요구함 진행 상태.
			String strIngStt=(String)objRsSH.getObject("ING_STT");
		%>
			<tr>
				<th height="25">&bull; 요구함명 </th>
				<td height="25" colspan="3"><%=objRsSH.getObject("REQ_BOX_NM")%></td>
			</tr>
			<tr>
				<th height="25">&bull; 업무구분 </th>
				<td height="25" colspan="3"><%=objCdinfo.getRelatedDuty((String)objRsSH.getObject("RLTD_DUTY"))%></td>
			</tr>
			<tr>
				<th height="25" width="18%">&bull; 요구기관 </th>
				<td height="25" width="32%"><%=objRsSH.getObject("CMT_ORGAN_NM")%></td>
				<th height="25" width="18%">&bull; 제출기관 </th>
				<td height="25" width="32%"><%=(String)objRsSH.getObject("SUBMT_ORGAN_NM")%></td>
			</tr>
			<tr>
				<th height="25">&bull; 접수시작 </th>
				<td height="25"><%=StringUtil.getDate((String)objRsSH.getObject("ACPT_BGN_DT"))%></td>
				<th height="25">&bull; 접수마감 </th>
				<td height="25"><%=StringUtil.getDate((String)objRsSH.getObject("ACPT_END_DT"))%></td>
			</tr>
			<tr>
				<th height="25">&bull; 제출기한 </th>
				<td height="25"><%= StringUtil.getDate((String)objRsSH.getObject("SUBMT_DLN")) %> 24:00</td>
				<th height="25">&bull; 등록일시 </th>
				<td height="25"><%= StringUtil.getDate2((String)objRsSH.getObject("REG_DT"))%></td>
			</tr>
			<tr>
				<th height="25">&bull; 공개등급 </th>
				<td height="25"><%=CodeConstants.getOpenClass((String)objRsRI.getObject("OPEN_CL"))%></td>
				<th height="25">&bull; 첨부파일 </th>
				<td height="25"><%=StringUtil.makeAttachedFileLink((String)objRsRI.getObject("ANS_ESTYLE_FILE_PATH"),(String)objRsRI.getObject("REQ_ID"))%></td>
			</tr>
			<tr>
				<th height="25">&bull; 신청기관 </th>
				<td height="25"><%=objRsRI.getObject("OLD_REQ_ORGAN_NM")%></td>
				<th height="25">&bull; 신청자 </th>
				<td height="25"><%=objRsRI.getObject("REGR_NM")%></td>
			</tr>
            <tr>
                <th height="25">&bull; 답변 승인상태 </th>
                <td height="25">
					<select name="ANSW_PERM_CD" class="select_reqsubmit">
					<%
						List objAnsApprSttList=CodeConstants.getAnsApprSttList();
						String strAnsApprStt=(String)objRsRI.getObject("ANSW_PERM_CD");
						for(int i=0;i<objAnsApprSttList.size();i++){
							String strCode=(String)((Hashtable)objAnsApprSttList.get(i)).get("Code");
							String strValue=(String)((Hashtable)objAnsApprSttList.get(i)).get("Value");
							out.println("<option value=\"" + strCode + "\"" + StringUtil.getSelectedStr(strAnsApprStt,strCode) + ">" + strValue + "</option>");
						}
					%>
					</select>
				</td>
                <th height="25">&nbsp;</th>
                <td height="25">&nbsp;</td>
            </tr>
        </table>
        <!-- /list view -->
        <!--<p class="warning mt10">* 요구서 발송 : 의원실(또는 소속기관) 명의로 해당 제출기관에 요구서를 발송합니다.</p>  -->
        <!-- 중단 버튼 시작-->
         <div id="btn_all">
			<div  class="t_right">
		<%
			/**위원회에서 신규등록한 요구에 한함-> 기준??*/
			if(objUserInfo.getOrganGBNCode().equals("004") && !strReqSubmitFlag.equals("004")){
		%>
			<div class="mi_btn"><a href="javascript:gotoEditPage2()"><span>답변승인상태저장</span></a></div>
			<%} %>
			 </div>
		 </div>

        <!-- /리스트 버튼-->

        <!-- list -->
        <span class="list01_tl">답변 목록
<!--		<span class="list_total">&bull;&nbsp;전체자료수 : <%//= intTotalRecordCount %>개 </span>-->
		</span>




        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
          <thead>
		  	<%
				if(objRs.getRecordSize() < 1){
			%>
		  	<tr>
				<td height="25" class="td_gray1">답변정보 가 없습니다.</td>
			</tr>
			<%
				}else{
			%>
			<tr>
              <th scope="col"><a>NO</a></th>
              <th scope="col"><a>제출 의견</a></th>
              <th scope="col"><a>답변</a></th>
              <th scope="col"><a>제출자</a></th>
              <th scope="col"><a>제출일</a></th>
            </tr>
          </thead>
          <tbody>
		<%
			int intABC = 1;
			while(objRs.next()){
		%>
            <tr>
              <td><%=intABC%></td>
              <td style="text-align:left;"><a href="javascript:gotoDetail('<%= objRs.getObject("ANS_ID") %>')"><%= objRs.getObject("ANS_OPIN") %></a></td>
              <td><%=this.makeAnsInfoHtml2((String)objRs.getObject("ANS_ID"), (String)objRs.getObject("ANS_MTD"),(String)objRsRI.getObject("REQ_CONT"),intABC+"",(String)objRsSH.getObject("SUBMT_ORGAN_NM")) %></td>
              <td><%= objRs.getObject("ANSR_NM") %></td> <td><%= StringUtil.getDate2((String)objRs.getObject("ANS_DT")) %></td>
            </tr>
			<%
				intABC++;
				} //endwhile
			}
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