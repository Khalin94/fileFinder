<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.util.HashtableUtil" %>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RPreReqBoxVListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.prereqbox.PreRequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.prereqinfo.PreRequestInfoDelegate" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%
/******************************************************************************
* Name		  : RBasicReqBoxEidt.jsp
* Summary	  : 요구함 정보 화면.
* Description : 요구함 수정 화면 제공.
/******************************************************************************/
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

  //로그인 사용자 정보를 가져온다. 권한없음 경우 관람만 가능하다.
  String strReqSubmitFlag = objUserInfo.getReqSubmitFlag();

  /**일반 요구함 상세보기 파라미터 설정.*/
  RPreReqBoxVListForm objParams =new RPreReqBoxVListForm();
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
   PreRequestBoxDelegate objReqBox=new  PreRequestBoxDelegate(); /**요구함 정보 대리자 New */

   /********* 값가져오기 **************/
   Hashtable objReqBoxHash=objReqBox.getRecord((String)objParams.getParamValue("ReqBoxID"));
   objRsSH=new  ResultSetSingleHelper(objReqBoxHash);	/** 특정 요구함 정보 가지고 오기.*/
   if(!StringUtil.isAssigned(strCmtOrganID)){
   	  strCmtOrganID=HashtableUtil.getEmptyIfNull(objReqBoxHash,"CMT_ORGAN_ID");

   	  /** 위원회명이 기타 위원회이면 원래 제출기관이 소속된 위원회를 찾아줌 2004.05.14 ==>변경 2004.06.04 */
   	  //if(strCmtOrganID.equals(CodeConstants.ETC_CMT_ORGAN_ID)){
   	  //   strCmtOrganID=objOrganInfo.getCmtOrganID(HashtableUtil.getEmptyIfNull(objReqBoxHash,"SUBMT_ORGAN_ID"));
   	  //}//endif
   }

   //objCmtRs=new ResultSetHelper(objOrganInfo.getCmtOrganList());    /** 전체 위원회 */
   objCmtRs=new ResultSetHelper(objUserInfo.getCurrentCMTList());   /** 소속 위원회 */
   objSubmtOrganRs=new ResultSetHelper(objOrganInfo.getSubmtOrganList(strCmtOrganID));/**제출기관리스트*/
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
  	if(formName.CmtOrganIDX.value==""){
  	    alert("위원회를 선택하세요");
  	    return false;
  	}
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
	formName.action="./RBasicReqBoxEditProc.jsp";
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
    formName.CmtOrganIDX.value="";
    formName.ReqBoxDsc.value="";
    formName.SubmtDln.value="";
  	formName.action="./RBasicReqBoxVList.jsp";
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
          <form name="formName" method="post" action="<%=request.getRequestURI()%>"><!--요구함 수정정보 전달 -->
          	 <%=objParams.getHiddenFormTags()%>
          	 <input type="hidden" name="SubmtOrganIDX" value="">

      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=MenuConstants.REQ_BOX_EDIT%></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" />  <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.REQUEST_BOX_COMM%> > <%=MenuConstants.REQUEST_BOX_PRE%> > <%=MenuConstants.REQ_BOX_PRE%></div>
        <p><!--문구--></p>
      </div>
      <!-- /pgTit -->
      <!-- contents -->
      <div id="contents">
      <span class="list02_tl">요구함 정보 </span>
                <!------------------------- TAB에 해당하는 테이블(목록이든 등록폼이든 상세정보든) 출력 시~~~작 ------------------------->
        <table border="0" cellspacing="0" cellpadding="0" class="list02">
                    <tr>
                      <th height="25">&bull;&nbsp;위원회 </th>
                      <td colspan="3">
						<select name="CmtOrganIDX" onChange="changeSubmtOrganList()"  class="select">
						<%

						   while(objCmtRs.next()){
						       String strOrganID=(String)objCmtRs.getObject("ORGAN_ID");
						   	   out.println("<option value=\"" + strOrganID + "\" " + StringUtil.getSelectedStr(strCmtOrganID,strOrganID) + ">" + objCmtRs.getObject("ORGAN_NM") + "</option>");
						   }//endwhile
						%>

						</select>
                      </td>
                    </tr>
                    <tr>
                      <th height="25">&bull;&nbsp;요구함명</th>
                      <td height="25" colspan="3">
	                      <%=(String)objRsSH.getObject("REQ_BOX_NM")%>
                      </td>
                    </tr>
                    <tr>
                      <th height="25">&bull;&nbsp;회기</th>
                      <td height="25">
	                      제<input type="text" size="3" maxlength="3" name="NatCnt" class="textfield" onKeyUp="CheckNumeric(this);" value="<%=strNatCnt%>">회국회
                      </td>
                      <th height="25">&bull;&nbsp;회차</th>
                      <td height="25">
	                      <input type="text" size="3" maxlength="3" name="ReqBoxCnt" class="textfield" onKeyUp="CheckNumeric(this);" value="<%=strReqBoxCnt%>">
                      </td>
                    </tr>
                    <tr>
                      <th height="25">&bull;&nbsp;업무구분</th>
                      <td height="25" width="191">
						<select name="RltdDutyX"  class="select">
						<%
						   /**업무구분 리스트 출력 */
						   while(objRltdDutyRs.next()){
						   		String strCode=(String)objRltdDutyRs.getObject("MSORT_CD");
						   		out.println("<option value=\"" + strCode + "\" " + StringUtil.getSelectedStr(strRltdDuty,strCode) + ">" + objRltdDutyRs.getObject("CD_NM") + "</option>");
						   }
						%>
						</select>
                      </td>
                      <th height="25">&bull;&nbsp;제출기한</th>
                      <td height="25" colspan="3">
						<input type="text" class="textfield" name="SubmtDln" size="10" maxlength="8" value="<%=strSubmtDln%>"  OnClick="this.select()" OnKeyPress="if ((event.keyCode&lt;48)||(event.keyCode&gt;57)) event.returnValue=false;" OnBlur="javascript:SetFormatDate(this);">
						<a href="#" OnClick="javascript:show_calendar('formName.SubmtDln');"><img src="/images2/btn/bt_calender.gif" width="17" height="13" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"/></a>
                      </td>
                    </tr>
                    <tr>
                      <th height="25">&bull;&nbsp;제출기관</th>
						<td height="25" colspan="3">
                            <select name="SubmtOrganID" class="select">
						<%
						   /**제출기관 리스트 출력 */
						   while(objSubmtOrganRs.next()){
						   		String strSubmitOrganID=(String)objSubmtOrganRs.getObject("SUBMT_ORGAN_ID");
						   		String strSubmitOrganNM=(String)objSubmtOrganRs.getObject("SUBMT_ORGAN_NM");
						   		out.println("<option value=\"" + strSubmitOrganID + "\" " + StringUtil.getSelectedStr(strSubmtOrganID,strSubmitOrganID) + ">" + strSubmitOrganNM.trim() + "</option>");
						   }
						%>
								</select>
						</td>
                    </tr>
                    <tr>
                      <th height="25">&bull;&nbsp;요구함설명</th>
                      <td height="25" colspan="3">
                      	<textarea rows="3" cols="70" name="ReqBoxDsc" class="textfield" style="WIDTH: 90% ; height: 80"><%=strReqBoxDsc%></textarea>
                      </td>
                    </tr>
                </table>
				<!------------------------- TAB에 해당하는 테이블(목록이든 등록폼이든 상세정보든) 출력 끝 ------------------------->
        <div id="btn_all"  class="t_right">
                <%
                //권한 없음
                if(!strReqSubmitFlag.equals("004")){
                %>
				<span class="list_bt"><a href="#" onClick="checkFormData()">저장</a></span>
				<span class="list_bt"><a href="#" onClick="formName.reset()">취소</a></span>
                <%} //end if 권한없음에 관련 %>
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