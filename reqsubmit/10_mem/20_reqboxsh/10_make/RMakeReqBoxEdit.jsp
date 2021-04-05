<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.util.HashtableUtil" %>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RMemReqBoxVListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.MemRequestBoxDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	/******************************************************************************
	* Name		  : RMakeReqBoxEidt.jsp
	* Summary	  : 요구함 정보 화면.
	* Description : 요구함 수정 화면 제공.
	/******************************************************************************/

	UserInfoDelegate objUserInfo =null;
	CDInfoDelegate objCdinfo =null;
%>

<%@ include file="../../../common/RUserCodeInfoInc.jsp" %>

<%
	/*************************************************************************************************/
	/** 					파라미터 체크 Part 														  */
	/*************************************************************************************************/

	// 2004-07-08
	// 예산정책처 관리를 위해서 기관구분 코드를 설정한다.
	String strOrgGbnCode = objUserInfo.getOrganGBNCode();

	/**일반 요구함 상세보기 파라미터 설정.*/
	RMemReqBoxVListForm objParams =new RMemReqBoxVListForm();
	boolean blnParamCheck=false;
	/**전달된 파리미터 체크 */
	blnParamCheck=objParams.validateParams(request);
	if(blnParamCheck==false){
		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
		objMsgBean.setStrCode("DSPARAM-0000");
		objMsgBean.setStrMsg(objParams.getStrErrors());
		// out.println("ParamError:" + objParams.getStrErrors());
	%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
	<%
		return;
	} //endif
%>
<%
 /******* 편의 제공용 SELECT Box Param */
 String strCmtOrganID=StringUtil.getEmptyIfNull((String)request.getParameter("CmtOrganIDX"));/**위원회 목록 */
 String strRltdDuty=StringUtil.getEmptyIfNull((String)request.getParameter("RltdDutyX"));/** 업무구분 */
 String strNatCnt=StringUtil.getEmptyIfNull((String)request.getParameter("NatCnt"));	/** 회수 */
 String strReqBoxCnt=StringUtil.getEmptyIfNull((String)request.getParameter("ReqBoxCnt"));	/** 회차 */
 String strSubmtDln=StringUtil.getEmptyIfNull((String)request.getParameter("SubmtDln"));/** 제출기한 */
 String strReqBoxDsc=StringUtil.getEmptyIfNull((String)request.getParameter("ReqBoxDsc"));/** 요구함설명 */
 String strSubmtOrganID=StringUtil.getEmptyIfNull((String)request.getParameter("SubmtOrganIDX"));/** 제출기관ID */
 if(!StringUtil.isAssigned(strSubmtOrganID)){
   strSubmtOrganID=StringUtil.getEmptyIfNull((String)request.getParameter("SubmtOrganID"));/** 제출기관ID */
 }
%>

<%
 /*************************************************************************************************/
 /** 					데이터 호출 Part 														  */
 /*************************************************************************************************/

 /******** 데이터 담을 컨테이너 설정 ********/
 ResultSetHelper objCmtRs=null;        /** 소속 위원회 리스트 출력용 RsHelper */
 ResultSetHelper objSubmtOrganRs=null; /** 제출기관 리스트 출력용 RsHelper */
 ResultSetHelper objRltdDutyRs=null;   /** 관련기관 리스트 출력용 RsHelper */
 ResultSetSingleHelper objRsSH=null;	/** 요구함 상세보기 정보 */
 try{
   /********* 대리자 정보 설정 *********/
   OrganInfoDelegate objOrganInfo=new OrganInfoDelegate();   /** 기관정보 출력용 대리자 */
   MemRequestBoxDelegate objReqBox=new  MemRequestBoxDelegate(); /**요구함 정보 대리자 New */

   /********* 값가져오기 **************/
   Hashtable objReqBoxHash = (Hashtable)objReqBox.getRecord((String)objParams.getParamValue("ReqBoxID"));
   objRsSH=new  ResultSetSingleHelper(objReqBoxHash);	/** 특정 요구함 정보 가지고 오기.*/
   if(!StringUtil.isAssigned(strCmtOrganID)){
   	  strCmtOrganID=HashtableUtil.getEmptyIfNull(objReqBoxHash,"CMT_ORGAN_ID");

   	  /** 위원회명이 기타 위원회이면 원래 제출기관이 소속된 위원회를 찾아줌 2004.05.14 ==>변경 2004.06.04 */
   	  //if(strCmtOrganID.equals(CodeConstants.ETC_CMT_ORGAN_ID)){
   	  //   strCmtOrganID=objOrganInfo.getCmtOrganID(HashtableUtil.getEmptyIfNull(objReqBoxHash,"SUBMT_ORGAN_ID"));
   	  //}//endif
   }
   objCmtRs=new ResultSetHelper(objOrganInfo.getCmtOrganList());    /** 전체 위원회 */

   // 2004-07-08 사무처, 예정처의 GbnCode에 따라서 전체 제출기관 목록을 가져와야 하므로
   //objSubmtOrganRs = new ResultSetHelper(objOrganInfo.getSubmtOrganList(strCmtOrganID));/**제출기관리스트*/
   objSubmtOrganRs = new ResultSetHelper(objOrganInfo.getSubmtOrganList(strCmtOrganID, strOrgGbnCode)); // 제출기관리스트*/

   objRltdDutyRs=new ResultSetHelper(objCdinfo.getRelatedDutyList()); /** 업무 구분 가져오기 */
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
<%
 /*************************************************************************************************/
 /** 					데이터 값 확인   Part 													  */
 /*************************************************************************************************/

 if(!objRsSH.next()){
 	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	objMsgBean.setStrCode("DSDATA-0001");
  	objMsgBean.setStrMsg("요청하신 정보가 시스템에 존재하지 않습니다.");
  	//out.println("<br>Error!!!" + "요청하신 정보가 시스템에 존재하지 않습니다.");
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
 strRltdDuty=StringUtil.getEmptyIfNull(strRltdDuty,(String)objRsSH.getObject("RLTD_DUTY"));/** 업무구분 */
 strNatCnt=StringUtil.getEmptyIfNull(strNatCnt,(String)objRsSH.getObject("NAT_CNT"));	/** 회수 */
 strReqBoxCnt=StringUtil.getEmptyIfNull(strReqBoxCnt,(String)objRsSH.getObject("REQ_BOX_CNT"));	/** 회차 */
 strSubmtDln=StringUtil.getEmptyIfNull(strSubmtDln,StringUtil.getDate((String)objRsSH.getObject("SUBMT_DLN")));/** 제출기한 */
 strReqBoxDsc=StringUtil.getEmptyIfNull(strReqBoxDsc,(String)objRsSH.getObject("REQ_BOX_DSC"));/** 요구함설명 */
 strSubmtOrganID=StringUtil.getEmptyIfNull(strSubmtOrganID,(String)objRsSH.getObject("SUBMT_ORGAN_ID"));/** 제출기관ID */

%>
<jsp:include page="/inc/header.jsp" flush="true"/>
<script language=Javascript src="/js/reqsubmit/common.js"></script>
<script language=Javascript src="/js/nads_lib.js"></script>
<script language=Javascript src="/js/datepicker.js"></script>
<script language="JavaScript">
  /** 제출기관리스트 출력. */
  function changeSubmtOrganList(){
  	formName.action="<%=request.getRequestURI()%>";
  	formName.submit();
  }

  /** 폼데이터 체크 */
  function checkFormData(){
<%
	// 2004-07-08 사무처, 예산정책처 특별 관리를 위한 설정 시~작~
	if ((CodeConstants.ORGAN_GBN_ASM.equalsIgnoreCase(strOrgGbnCode)) || (CodeConstants.ORGAN_GBN_BUD.equalsIgnoreCase(strOrgGbnCode))) {
	} else {
%>
  	if(formName.CmtOrganIDX.value==""){
  	    alert("위원회를 선택하세요");
  	    return false;
  	}
<% } %>
  	if(formName.SubmtOrganID.value==""){
  	    alert("제출기관을 선택하세요");
  	    return false;
  	}
	if(formName.elements['NatCnt'].value==""){
		alert("회기를  입력하세요!!");
		formName.elements['NatCnt'].focus();
		return false;
	}
	if(formName.elements['ReqBoxCnt'].value==""){
		alert("회차를  입력하세요!!");
		formName.elements['ReqBoxCnt'].focus();
		return false;
	}
	if(formName.elements['ReqBoxDsc'].value.length>250){
		alert("요구함설명은 250글자 이내로 작성해주세요!!");
		formName.elements['ReqBoxDsc'].focus();
		return false;
	}
	if(formName.elements['SubmtDln'].value==""){
		alert("제출기한을 입력(선택)하세요!!");
		formName.elements['SubmtDln'].focus();
		return false;
	}
	if(formName.elements['SubmtDln'].value<="<%=StringUtil.getSysDate()%>"){
		alert("제출기한은 오늘(<%=StringUtil.getSysDate()%>)이후의 날짜를 선택하셔야합니다");
		formName.elements['SubmtDln'].focus();
		return false;
	}
	formName.action="./RMakeReqBoxEditProc.jsp";
	formName.submit();
  }//endfunc

  /** 제출기관 조회 팝업 */
  function popupSearchSubmitOrgan(){
    var varWidth=320;
    var varHeight=250;
    var winl = (screen.width - varWidth) / 2;
	var wint = (screen.height - varHeight) / 2;
  	window.open("/reqsubmit/common/SearchSubmtOrganList.jsp",'','width=' + varWidth + ',height=' + varHeight + ',top='+wint+',left='+winl+',scrollbars=yes, resizable=no, toolbar=no, menubar=no, location=no, directories=no, status=yes');
  }
  /** 요구함으로 가기 */
  function gotoList(){
    //formName.CmtOrganIDX.value="";
    formName.ReqBoxDsc.value="";
    formName.SubmtDln.value="";
  	formName.action="./RMakeReqBoxVList.jsp";
  	formName.submit();
  }

	/**
	 * 2005-09-13 kogaeng ADD
	 */
	function updateChar2() {
		var length_limit = 250;
		var aaaElem = document.formName.ReqBoxDsc;
		var aaaLength = calcLength(aaaElem.value);
		document.getElementById("textlimit").innerHTML = aaaLength;
		if (aaaLength > length_limit) {
			alert("최대 " + length_limit + "byte이므로 초과된 글자수는 자동으로 삭제됩니다.");
			aaaElem.value = aaaElem.value.replace(/\r\n$/, "");
			aaaElem.value = assertLength(aaaElem.value, length_limit);
		}
	}

	function calcLength(message) {
		var nbytes = 0;

		for (i=0; i<message.length; i++) {
			var ch = message.charAt(i);
			if(escape(ch).length > 4) {
				nbytes += 2;
			} else if (ch == '\n') {
				if (message.charAt(i-1) != '\r') {
					nbytes += 1;
				}
			} else if (ch == '<' || ch == '>') {
				nbytes += 4;
			} else {
				nbytes += 1;
			}
		}
		return nbytes;
	}

	function assertLength(message, maximum) {
		var inc = 0;
		var nbytes = 0;
		var msg = "";
		var msglen = message.length;

		for (i=0; i<msglen; i++) {
			var ch = message.charAt(i);
			if (escape(ch).length > 4) {
				inc = 2;
			} else if (ch == '\n') {
				if (message.charAt(i-1) != '\r') {
					inc = 1;
				}
			} else if (ch == '<' || ch == '>') {
				inc = 4;
			} else {
				inc = 1;
			}
			if ((nbytes + inc) > maximum) {
				break;
			}
			nbytes += inc;
			msg += ch;
		}
		document.getElementById("textlimit").innerHTML = nbytes;
		return msg;
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
          <form name="formName" method="post" action="<%=request.getRequestURI()%>"><!--요구함 수정정보 전달 -->
          	 <%=objParams.getHiddenFormTags()%>
          	 <input type="hidden" name="SubmtOrganIDX" value="">
      <!-- pgTit -->

      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=MenuConstants.REQ_BOX_MAKE%><span class="sub_stl" >-<%=MenuConstants.REQ_BOX_EDIT%></span></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" />  <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.getReqBoxGeneral(request)%> > <%=MenuConstants.REQ_BOX_MAKE%></div>
        <p><!--문구--></p>
      </div>
      <!-- /pgTit -->

      <!-- contents -->

      <div id="contents">

        <!-- 검색조건 없는 경우 아래 div 삭제 나 주석으로 막으세요.--><!-- /검색조건-->

        <!-- 각페이지 내용 -->

        <!-- list -->
		<span class="list02_tl">요구함 정보</span>
        <table border="0" cellspacing="0" cellpadding="0" class="list02">
            <tbody>
                <tr>
                    <th height="25">&bull;&nbsp;요구함명 </th>
                    <td height="25" colspan="3">
					<input value="<%=(String)objRsSH.getObject("REQ_BOX_NM")%>" size="45" name="ReqBoxNm" />
					</td>
                </tr>
<%
	// 2004-07-08 사무처, 예산정책처 특별 관리를 위한 설정 시~작~
	if ((CodeConstants.ORGAN_GBN_ASM.equalsIgnoreCase(strOrgGbnCode)) || (CodeConstants.ORGAN_GBN_BUD.equalsIgnoreCase(strOrgGbnCode))) {
		out.println("<input type='hidden' name='CmtOrganIDX' value='"+(String)objRsSH.getObject("CMT_ORGAN_ID")+"'>");
	} else {
%>
                <tr>
                    <th height="25" width="149">&bull;&nbsp;소관 위원회</th>
                    <td height="25" colspan="3">
					<select name="CmtOrganIDX" onChange="changeSubmtOrganList()" class="select"  style="width:auto;" >
						<%
						   /** 전체 위원회 리스트 출력 */
						   while(objCmtRs.next()){
							   String strOrganID=(String)objCmtRs.getObject("CMT_ORGAN_ID");
							   out.println("<option value=\"" + strOrganID + "\" " + StringUtil.getSelectedStr(strCmtOrganID,strOrganID) + ">" + objCmtRs.getObject("CMT_ORGAN_NM") + "</option>");
						   }//endwhile
						%>
						  <% //위원회설정되지 않은 기관들 보여줌. %>
						  <option value="<%=CodeConstants.NO_CMT_ORGAN_ID%>" <%=StringUtil.getSelectedStr(strCmtOrganID,CodeConstants.NO_CMT_ORGAN_ID)%>><%=CodeConstants.NO_CMT_ORGAN_NM%></option>
					</select>
					</td>
                </tr>
<% } %>
                <tr>
                    <th height="25" width="149">&bull;&nbsp;회기</th>
                    <td height="25" width="191">
					제<input size="3" maxlength="3" name="NatCnt" name="ReqBoxNm" onKeyUp="CheckNumeric(this);" value="<%=strNatCnt%>"/>회 국회
					</td>
                    <th height="25" width="149">&bull;&nbsp;회차</th>
                    <td height="25" width="191">
					<input size="3" maxlength="3" name="ReqBoxCnt" onKeyUp="CheckNumeric(this);" value="<%=strReqBoxCnt%>"/>
					</td>
                </tr>
                <tr>
                    <th height="25" width="149">&bull;&nbsp;업무구분</th>
                    <td height="25" width="191">
						<select name="RltdDutyX" class="select"  style="width:auto;" >
						<%
						   /**업무구분 리스트 출력 */
						   while(objRltdDutyRs.next()){
						   		String strCode=(String)objRltdDutyRs.getObject("MSORT_CD");
						   		out.println("<option value=\"" + strCode + "\" " + StringUtil.getSelectedStr(strRltdDuty,strCode) + ">" + objRltdDutyRs.getObject("CD_NM") + "</option>");
						   }
						%>
						</select>
					</td>
                    <th height="25" width="149">&bull;&nbsp;제출기한</th>
                    <td height="25" width="191">
					<input name="SubmtDln" size="10" maxlength="8" value="<%=strSubmtDln%>"  OnClick="this.select()" OnKeyPress="if ((event.keyCode&lt;48)||(event.keyCode&gt;57)) event.returnValue=false;" OnBlur="javascript:SetFormatDate(this);"/>
					<a href="#" OnClick="javascript:show_calendar('formName.SubmtDln');"><img src="/images2/btn/bt_calender.gif" width="17" height="13" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"/></a>
					</td>
                </tr>
				<tr>
                    <th height="25">&bull;&nbsp;
					<a href="javascript:popupSearchSubmitOrgan()">제출기관</a>
					</th>
                    <td height="25" colspan="3">
						<select name="SubmtOrganID" class="select">
						<%
								// 2004-07-08 사무처, 예산정책처 특별 관리를 위한 설정 시~작~
								if ((CodeConstants.ORGAN_GBN_ASM.equalsIgnoreCase(strOrgGbnCode)) || (CodeConstants.ORGAN_GBN_BUD.equalsIgnoreCase(strOrgGbnCode))) {
								} else {
						%>
							<option value="" selected>::: 위원회를 먼저 선택해 주세요 :::</option>
						<% } %>
						<%
						   /**제출기관 리스트 출력 */
						   while(objSubmtOrganRs.next()){
						   		String strSubmitOrganID=(String)objSubmtOrganRs.getObject("SUBMT_ORGAN_ID");
						   		String strSubmitOrganNM=(String)objSubmtOrganRs.getObject("SUBMT_ORGAN_NM");
						   		out.println("<option value=\"" + strSubmitOrganID + "\" " + StringUtil.getSelectedStr(strSubmtOrganID,strSubmitOrganID) + ">" + strSubmitOrganNM.trim() + "</option>");
						   }
						%>
						</select>
						<span class="list_bts right"><a href="#" onClick="popupSearchSubmitOrgan()">조회</a></span>
					</td>
                </tr>
                <tr>
                    <th height="25">&bull;&nbsp;요구함설명</th>
                    <td colspan="3">
						<!--
						<textarea
						onKeyDown="javascript:updateChar2()"
                      	onKeyUp="javascript:updateChar2()"
                      	onfocus="javascript:updateChar2()"
						rows="3" cols="70" name="ReqBoxDsc" style="height:100px;" wrap="hard">
						<%//=strReqBoxDsc%>
						</textarea>
						-->
						<textarea rows="3" cols="70" name="ReqBoxDsc" class="textfield" style="WIDTH: 90% ; height: 80"
                      		onKeyDown="javascript:updateChar2()"
                      		onKeyUp="javascript:updateChar2()"
                      		onfocus="javascript:updateChar2()"><%=strReqBoxDsc%></textarea>
                        <br />
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class=" list_none">
                            <tr>
                                <td width="6%"><strong>
                                    <div id="textlimit" style="float:let;height:15px;width:30px;">
										<script>document.write(calcLength(document.formName.ReqBoxDsc.value));</script>
									</div>
                                    </strong></td>
                                <td width="94%" height="25">
									<span class="fonts" >bytes (250 bytes 까지만 입력됩니다) </span>
			<!--  기존 시스템 역시 javascript 부분이 없어서 오류 발생.  -->
								</td>
                                </tr>
                        </table></td>
                </tr>
                </tbody>
        </table>
        <!-- /list -->

        <!-- 리스트 버튼-->
        <div id="btn_all"  class="t_right">
				<span class="list_bt"><a href="#" onClick="checkFormData()" >저장</a></span>
				<span class="list_bt"><a href="#" onClick="formName.reset()">취소</a></span>
				<span class="list_bt"><a href="#" onClick="gotoList()">요구함보기</a></span>
			</span>
		</div>

         <!-- /리스트 버튼-->

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