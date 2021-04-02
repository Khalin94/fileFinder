<%@ page language="java" contentType="text/html;charset=EUC-KR" %>

<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
/******************************************************************************
* Name		  : RNewPreBoxMake.jsp
* Summary	  : 신규 요구함 등록.
* Description : 요구함 등록 화면 제공.
* 				※※ 체크 ※※
*				 아직 에러처리후 포워딩 페이지로 넘기지 않음.
******************************************************************************/
%>
<%
 UserInfoDelegate objUserInfo =null;
 CDInfoDelegate objCdinfo =null;
%>

<%@ include file="../../../common/RUserCodeInfoInc.jsp" %>
<%
 /** 편의 제공용 SELECT Box Param */
 String strCmtOrganID=StringUtil.getEmptyIfNull((String)request.getParameter("CmtOrganID"));/**위원회 목록 */
 String strRltdDuty=StringUtil.getEmptyIfNull((String)request.getParameter("RltdDuty"));/** 업무구분 */
 String strNatCnt=StringUtil.getEmptyIfNull((String)request.getParameter("NatCnt"));	/** 회수 */
 //업무구분가 선택된것이 없으면 기본적인 선택이 되게함. 현재는 국정감사코드.
 if(strRltdDuty.equals("")){
 	strRltdDuty=CDInfoDelegate.SELECTED_RLTD_DUTY;
 }
 String strSubmtOrganID=StringUtil.getEmptyIfNull((String)request.getParameter("SubmtOrganID"));/** 제출기관ID */

%>
<%

 /******** 데이터 담을 컨테이너 설정 *********/
 ResultSetHelper objCmtRs=null;        /** 소속 위원회 리스트 출력용 RsHelper */
 ResultSetHelper objSubmtOrganRs=null; /** 제출기관 리스트 출력용 RsHelper */
 ResultSetHelper objRltdDutyRs=null;   /** 관련기관 리스트 출력용 RsHelper */
 try{
   /********* 대리자 정보 설정 *********/
   OrganInfoDelegate objOrganInfo=new OrganInfoDelegate();   /** 기관정보 출력용 대리자 */

   /********* 값가져오기 **************/
   objCmtRs=new ResultSetHelper(objUserInfo.getCurrentCMTList());   /** 소속 위원회 */
   objSubmtOrganRs=new ResultSetHelper(objOrganInfo.getSubmtOrganList(objUserInfo.getOrganID()));/**제출기관리스트*/
   objRltdDutyRs=new ResultSetHelper(objCdinfo.getRelatedDutyList());
 }catch(AppException objAppEx){
 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  	objMsgBean.setStrCode(objAppEx.getStrErrCode());
  	objMsgBean.setStrMsg(objAppEx.getMessage());
  	//out.println("<br>Error!!!" + objAppEx.getMessage());
  	%>
  	<!--jsp:forward page="/common/message/ViewMsg.jsp"/-->
  	<%
  	return;
 }

%>

<jsp:include page="/inc/header.jsp" flush="true"/>
<script language=Javascript src="/js/reqsubmit/common.js"></script>
<script language=Javascript src="/js/nads_lib.js"></script>
<script language=Javascript src="/js/datepicker.js"></script>
<script language="JavaScript">
  <%
 	//콤보 박스에 자료 넣기위해 Array에 테이터 넣어주는 부분.
    out.println("var form;");
    out.println("var varSelectedSubmt='" + strSubmtOrganID + "';");
	out.println("var arrCmtSubmtOrgans=new Array(" + objSubmtOrganRs.getRecordSize() + ");");
	for(int i=0;objSubmtOrganRs.next();i++){
	    out.println("arrCmtSubmtOrgans[" + i + "]=new Array('"
			+ (String)objSubmtOrganRs.getObject("CMT_ORGAN_ID")	+ "','" + objSubmtOrganRs.getObject("SUBMT_ORGAN_ID") + "','" + objSubmtOrganRs.getObject("SUBMT_ORGAN_NM") + "');");
	}//endfor
  %>

  /** 위원회 연도 초기화 */
  function init(){
	var field=formName.CmtOrganID;
	makeSubmtOrganList(field.options[field.selectedIndex].value);
  }//end of func
  /** 연도별 위원회 리스트 초기화 */
  function makeSubmtOrganList(strOrganID){
       	var field=formName.SubmtOrganID;
       	field.length=0;
	for(var i=0;i<arrCmtSubmtOrgans.length;i++){
	   var strTmpCmt=arrCmtSubmtOrgans[i][0];
	   if(strOrganID==strTmpCmt){
		   var tmpOpt=new Option();
		   tmpOpt.value=arrCmtSubmtOrgans[i][1];
		   tmpOpt.text=arrCmtSubmtOrgans[i][2];
		   if(varSelectedSubmt==tmpOpt.text){
		     tmpOpt.selected=true;
		   }
		   field.add(tmpOpt);
	   }
	}
  }//end of func
  /** 위원회 ID 변화에 따른 제출기관 리스트 변화 */
  function changeSubmtOrganList(){
    makeSubmtOrganList(formName.CmtOrganID.options[formName.CmtOrganID.selectedIndex].value);
  }//end of func


    /** 폼데이터 체크 */
  function checkFormData() {
  	var alertStr = "";
	if(formName.elements['NatCnt'].value==""){
		alertStr = alertStr + "- 회기\n";
	}

	if(formName.elements['SubmtDln'].value==""){
		alertStr = alertStr + "- 제출기한\n";
	}

	if (alertStr.length != 0) {
		alertStr = "[아래의 필수 입력 항목을 입력해 주시기 바랍니다]\n\n"+alertStr;
		alert(alertStr);
		return;
	}

	if(formName.elements['ReqBoxDsc'].value.length>250){
		alert("요구함설명은 250글자 이내로 작성해주세요!!");
		formName.elements['ReqBoxDsc'].focus();
		return false;
	}

	if(formName.elements['SubmtDln'].value<="<%=StringUtil.getSysDate()%>"){
		alert("제출기한은 오늘(<%=StringUtil.getSysDate()%>)이후의 날짜를 선택하셔야합니다");
		formName.elements['SubmtDln'].focus();
		return false;
	}
	formName.submit();
  }//endfunc

  // 2004-07-21
  function gotoPreReqBoxList() {
  	var str1 = document.formName.NatCnt.value;
  	var str2 = document.formName.SubmtDln.value;
  	if (str1.length != 0 && str2.length != 0) {
  		if (confirm("입력하신 요구함을 생성하시겠습니까?\n취소를 누르시면 등록하지 않습니다.")) {
  			checkFormData();
  			return;
  		}
  	}
  	document.formName.action = "/reqsubmit/20_comm/40_BasicBox/20_databoxsh/RBasicReqBoxList.jsp";
  	document.formName.submit();
  }


</script>

</head>

<body onLoad="init()">
<div id="wrap">
  <jsp:include page="/inc/top.jsp" flush="true"/>
  <jsp:include page="/inc/top_menu02.jsp" flush="true"/>
  <div id="container">
    <div id="leftCon">
      <jsp:include page="/inc/log_info.jsp" flush="true"/>
      <jsp:include page="/inc/left_menu02.jsp" flush="true"/>
    </div>

	<div id="rightCon">
<form name="formName" method="get" action="./RNewPreBoxMakeProc.jsp"><!--요구함 신규정보 전달 -->

      <!-- pgTit -->

      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=MenuConstants.REQ_BOX_WRITE%></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" />  <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.REQUEST_BOX_COMM%> > <%=MenuConstants.REQUEST_BOX_PRE%> > <%=MenuConstants.REQ_BOX_WRITE%></div>
        <p><!--문구--></p>
      </div>
      <!-- /pgTit -->

      <!-- contents -->

      <div id="contents">

        <!-- 검색조건 없는 경우 아래 div 삭제 나 주석으로 막으세요.--><!-- /검색조건-->

        <!-- 각페이지 내용 -->

        <!-- list -->
        <table border="0" cellspacing="0" cellpadding="0" class="list02">
            <tbody>
                <tr>
                    <th height="25">&bull;&nbsp;위원회 </th>
                    <td height="25" colspan="3">
					<select name="CmtOrganID" onChange="changeSubmtOrganList()">
						<%
						   /** 소속위원회 리스트 출력 */
						   while(objCmtRs.next()){
						       String strOrganID=(String)objCmtRs.getObject("ORGAN_ID");
						   	   out.println("<option value=\"" + strOrganID + "\" " + StringUtil.getSelectedStr(strCmtOrganID,strOrganID) + ">" + objCmtRs.getObject("ORGAN_NM") + "</option>");
						   }//endwhile
						%>
						</select>
					</td>
                </tr>
                <tr>
                    <th height="25" width="149">&bull;&nbsp;회 기</th>
                    <td height="25" colspan="3">제
                        <input onKeyUp="CheckNumeric(this);" maxlength="3" size="3" name="NatCnt" value="<%=strNatCnt%>"/>
                        회 국회 </td>
                </tr>
                <tr>
                    <th height="25" width="149">&bull;&nbsp;업무구분</th>
                    <td height="25" width="191">
					<select name="RltdDuty">
						 <%
						   /**업무구분 리스트 출력 */
						   while(objRltdDutyRs.next()){
						   		String strCode=(String)objRltdDutyRs.getObject("MSORT_CD");
						   		out.println("<option value=\"" + strCode + "\" " + StringUtil.getSelectedStr(strRltdDuty,strCode) + ">" + objRltdDutyRs.getObject("CD_NM") + "</option>");
						   }
						%>
						</select>
					</td>
                    <th height="25" width="149">&bull;&nbsp;제출기관</th>
                    <td height="25" width="191">
					<select name="SubmtOrganID" class="select_reqsubmit">

							</select>
					</td>
                </tr>
                <tr>
                    <th height="25">&bull;&nbsp;제출기한</th>
                    <td height="25" colspan="3">
						<input onBlur="javascript:SetFormatDate(this);" OnKeyPress="if ((event.keyCode&lt;48)||(event.keyCode&gt;57)) event.returnValue=false;" maxlength="8" size="10" name="SubmtDln" />
                        <a href="#" OnClick="javascript:show_calendar('formName.SubmtDln');"><img src="/images2/btn/bt_calender.gif" width="17" height="13" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"/></a>
					</td>
                </tr>
                <tr>
                    <th height="25" rowspan="2">&bull;&nbsp;요구함 설명</th>
                    <td colspan="3">
						<textarea
						onKeyDown="javascript:updateChar2(document.formName, 'ReqBoxDsc', '660')" onKeyUp="javascript:updateChar2(document.formName, 'ReqBoxDsc', '660')" onFocus="javascript:updateChar2(document.formName, 'ReqBoxDsc', '660')" onClick="javascript:updateChar2(document.formName, 'ReqBoxDsc', '660')" rows="3" cols="70" name="ReqBoxDsc" style="height:100px;"></textarea>
                        <br />                        <table width="100%" border="0" cellspacing="0" cellpadding="0" class=" list_none">
                            <tr>
                                <td width="6%"><strong>
                                    <div id="textlimit" style="float:let;height:15px;width:30px;"></div>
                                    </strong></td>
                                <td width="94%" height="25">
									<span class="fonts" >bytes (*250 bytes 까지만 입력됩니다) </span>
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
				<span class="list_bt"><a href="#" onClick="gotoPreReqBoxList()">요구함목록</a></span>
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