<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.CommRequestBoxDelegate" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%
/******************************************************************************
* Name		  : RCommNewBoxMake
* Summary	  : 위원회 요구함 신규 등록.
* Description : 요구함 등록 화면 제공.
* ※※ 체크 ※※
* 1. 위원회요구함등록권한이 있는지 여부 체크
* 2. 위원회 요구일정 등록시 자동으로 제출기관 단위의 위원회 요구함 생성(권대리님께 문의)
* 3. 요구함명의 selectBox에 들어갈 값은 제출기관으로 위원회요구일정 등록시 선택한 제출기관
*    을 제외한 해당기관 소속 제출기관이 들어간다.
*    요구일정 등록시 제출기관을 전체선택했을 시에는 요구함명의 selectBox에는 없음이란 값이 들어간다.
*    -- 요구일정 정보 출력 SQL에 ROWNUM 삭제
*	 -- 제출기관 selectBox 로직 수정
******************************************************************************/
%>
<%
 UserInfoDelegate objUserInfo =null;
 CDInfoDelegate objCdinfo =null;
%>
<%@ include file="../../common/RUserCodeInfoInc.jsp" %>

<%
 String strRltdDuty=StringUtil.getEmptyIfNull((String)request.getParameter("RltdDuty"));/** 업무구분 */
 String strNatCnt=StringUtil.getEmptyIfNull((String)request.getParameter("NatCnt"));	/** 회수 */
 //업무구분가 선택된것이 없으면 기본적인 선택이 되게함. 현재는 국정감사코드.
 if(strRltdDuty.equals("")){
 	strRltdDuty=CDInfoDelegate.SELECTED_RLTD_DUTY;
 }
 String strIngStt = (String)request.getParameter("IngStt");

 /******** 데이터 담을 컨테이너 설정 *********/
 ResultSetSingleHelper objRsSH=null;	/** 요구일정 정보 출력용  ResultSetSingleHelper*/
 ResultSetHelper objSubmtOrganRs=null;  /** 제출기관 리스트 출력용 ResultSetHelper */
 ResultSetHelper objRltdDutyRs=null;   /** 관련기관 리스트 출력용 RsHelper */

 try{
   /********* 대리자 정보 설정 *********/
	CommRequestBoxDelegate objReqBox=new CommRequestBoxDelegate(); 		/**요구함 Delegate*/
	OrganInfoDelegate objOrganInfo=new OrganInfoDelegate();   /** 기관정보 출력용 대리자 */

   /********* 값가져오기 **************/
    objRsSH=new ResultSetSingleHelper(objReqBox.getScheRecord((String)request.getParameter("ReqScheID")));
	objSubmtOrganRs=new ResultSetHelper(objOrganInfo.getSubmtOrganList(objUserInfo.getOrganID()));/**제출기관리스트*/
    objRltdDutyRs=new ResultSetHelper(objCdinfo.getRelatedDutyList());
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
<link href="/css/System.css" rel="stylesheet" type="text/css">
<script language=Javascript src="/js/reqsubmit/common.js"></script>
<script language=Javascript src="/js/nads_lib.js"></script>
<script language=Javascript src="/js/datepicker.js"></script>
<script language="JavaScript">
   /** 폼데이터 체크 */
  function checkFormData(){
  	var alertStr = "";
	if(formName.elements['NatCnt'].value==""){
		alertStr = alertStr + "- 회기\n";
	}
	if(formName.elements['SubmtDln'].value==""){
		alertStr = alertStr + "- 제출기한\n";
	}

	if (alertStr.length != 0) {
		alertStr = "[아래의 항목은 필수입력 항목입니다. 확인 바랍니다]\n\n" + alertStr;
		alert(alertStr);
		return;
	}

	if(formName.elements['SubmtDln'].value<="<%=StringUtil.getSysDate()%>"){
		alert("제출기한은 오늘(<%=StringUtil.getSysDate()%>)이후의 날짜를 선택하셔야합니다");
		formName.elements['SubmtDln'].focus();
		return false;
	}
	if(formName.elements['SubmtDln'].value <="<%=StringUtil.getDate((String)objRsSH.getObject("ACPT_END_DT"))%>"){
		alert("제출기한은 접수기간 이후의 날짜를 선택하셔야합니다.");
		formName.elements['SubmtDln'].focus();
		return false;
	}
	if (getByteLength(formName.elements['ReqBoxDsc'].value) > 250) {
		alert("요구함 설명은 한글, 영문을 포함 250자 이내로 입력해 주세요. 단, 한글은 2자로 처리됩니다.");
		formName.elements['ReqBoxDsc'].focus();
		return false;
	}
	formName.submit();
  }//endfunc

  function gotoReqBoxList() {
  	formName.action = "./RCommReqBoxList.jsp";
  	formName.submit();
  }
</script>
</head>
<SCRIPT language="JavaScript" src="/js/reqinfo.js"></SCRIPT>
  <jsp:include page="/inc/top.jsp" flush="true"/>
  <jsp:include page="/inc/top_menu02.jsp" flush="true"/>
  <div id="container">
    <div id="leftCon">
      <jsp:include page="/inc/log_info.jsp" flush="true"/>
      <jsp:include page="/inc/left_menu02.jsp" flush="true"/>
    </div>
    <div id="rightCon">
		<form name="formName" method="post" action="./RCommNewBoxMakeProc.jsp"><!--요구함 신규정보 전달 -->
		<input type="hidden" name="ReqOrganID" value="<%=objRsSH.getObject("CMT_ORGAN_ID")%>">
		<input type="hidden" name="CmtOrganID" value="<%=objRsSH.getObject("CMT_ORGAN_ID")%>">
		<input type="hidden" name="AuditYear" value="<%=objRsSH.getObject("AUDIT_YEAR")%>">
		<input type="hidden" name="ReqScheID" value="<%=objRsSH.getObject("REQ_SCHE_ID")%>">
		<input type="hidden" name="IngStt" value="<%=objRsSH.getObject("ING_STT")%>">
		<input type="hidden" name="ReqBoxStt" value="<%=objRsSH.getObject("ING_STT")%>">

        <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=MenuConstants.REQ_BOX_WRITE%></h3>
        <div class="navi">
            <img src="/images2/foundation/home.gif" width="13" height="11" /> <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.REQUEST_BOX_COMM%> >
				<% if("002".equalsIgnoreCase(strIngStt)){ %>
				<B><%=MenuConstants.COMM_REQ_BOX_MAKE_END%></B>
				<% } else { %>
				<B><%=MenuConstants.COMM_REQ_BOX_MAKE%></B>
				<% } %>
        </div>
        <p><!--문구--></p>
        </div>
        <!-- /pgTit -->
        <!-- contents -->
      <div id="contents">
        <span class="list02_tl">요구일정 정보 </span>
        <table cellspacing="0" cellpadding="0" class="list02">
			<tr>
				<th height="25">&bull;&nbsp;위원회 </th>
				<td height="25" colspan="3"><%=objRsSH.getObject("CMT_ORGAN_NM")%></td>
			</tr>
			<tr>
				<th height="25">&bull;&nbsp;요구 일정</th>
				<td height="25" colspan="3">
				<%=objRsSH.getObject("AUDIT_YEAR")%> 년 &nbsp; <%=objRsSH.getObject("CMT_ORGAN_NM")%>
				&nbsp;<%=objRsSH.getObject("ORDER_INFO")%> &nbsp;차 &nbsp;요구
				</td>
			</tr>
			<tr>
				<th height="25">&bull;&nbsp;접수 시작</th>
				<td height="25"><%=StringUtil.getDate((String)objRsSH.getObject("ACPT_BGN_DT"))%></td>
				<th height="25">&bull;&nbsp;접수 마감</th>
				<td height="25"><%=StringUtil.getDate((String)objRsSH.getObject("ACPT_END_DT"))%></td>
			</tr>
			<tr>
				<th height="25">&bull;&nbsp;회기</th>
				<td height="25">
				제<input type="text" size="3" maxlength="3" name="NatCnt" class="textfield" value="<%=objRsSH.getObject("NAT_CNT")%>" readonly>회 국회</td>
            	<th height="25">&bull;&nbsp;업무구분</th>
              	<td height="25">
				<select name="RltdDuty" class="select">
				<%
				   /**업무구분 리스트 출력 */
				   while(objRltdDutyRs.next()){
				   		String strCode=(String)objRltdDutyRs.getObject("MSORT_CD");
				   		out.println("<option value=\"" + strCode + "\" " + StringUtil.getSelectedStr(strRltdDuty,strCode) + ">" + objRltdDutyRs.getObject("CD_NM") + "</option>");
				   }
				%>
				</select>
              	</td>
            </tr>
			<tr>
				<th height="25">&bull;&nbsp;제출기관</th>
				<td height="25"><select name="SmtOrganID" class="select">
				<% while(objSubmtOrganRs.next()){ %>
				<option value ="<%=objSubmtOrganRs.getObject("SUBMT_ORGAN_ID")%>"><%=objSubmtOrganRs.getObject("SUBMT_ORGAN_NM")%></option>
				<%
				}
				%>
				</select>
				</td>
				<th height="25">&bull;&nbsp;제출기한</th>
				<td height="25">
				<input type="text" class="textfield" name="SubmtDln" size="10" maxlength="8" value=""  OnClick="this.select()" OnKeyPress="if ((event.keyCode&lt;48)||(event.keyCode&gt;57)) event.returnValue=false;" OnBlur="javascript:SetFormatDate(this);">
                <img src="/images2/btn/bt_calender.gif" width="17" height="13" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);" style="cursor:hand" OnClick="javascript:show_calendar('formName.SubmtDln');"/>
				</td>
            </tr>
            <tr>
				<th height="25">&bull;&nbsp;요구함 설명</th>
				<td height="25" colspan="3">
              	<textarea rows="3" cols="70" name="ReqBoxDsc" class="textfield" style="WIDTH: 90% ; height: 80"></textarea>
				</td>
            </tr>
			</table>
        <div id="btn_all"class="t_right">
            <span class="list_bt"><a href="#" onClick="javascript:checkFormData();">저장</a></span>
            <span class="list_bt"><a href="#" onClick="formName.reset()">취소</a></span>
            <span class="list_bt"><a href="#" OnClick="javascript:gotoReqBoxList()">요구함목록</a></span>
        </div>
        </form>
      </div>
    </div>
  </div>
  <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>