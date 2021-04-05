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
		//out.println("ParamError:" + objParams.getStrErrors());
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
	ResultSetSingleHelper objInfoRsSH=null;		/**요구 정보 상세보기 */

	try{
		/**요구 정보 대리자 New */
		objReqInfo=new MemRequestInfoDelegate();
		/**요구정보 이용 권한 체크 */
		boolean blnHashAuth=objReqInfo.checkReqInfoAuth((String)objParams.getParamValue("ReqInfoID"),objUserInfo.getOrganID()).booleanValue();
		if(!blnHashAuth){
			objMsgBean.setMsgType(MessageBean.TYPE_WARN);
			objMsgBean.setStrCode("DSAUTH-0001");
			objMsgBean.setStrMsg("해당 요구함을 볼 권한이 없습니다.");
			//out.println("해당 요구함을 볼 권한이 없습니다.");
%>
			<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
			return;
		}else{
			objInfoRsSH=new ResultSetSingleHelper(objReqInfo.getRecord((String)objParams.getParamValue("ReqInfoID")));
		}/**권한 endif*/
	}catch(AppException objAppEx){
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
<script language="javascript" src="/js/reqsubmit/common.js"></script>
<script language="JavaScript">

  /** 폼데이터 체크 */
  function checkFormData(){
	if(formName.elements['ReqCont'].value==""){
		alert("요구제목을  입력하세요!!");
		formName.elements['ReqCont'].focus();
		return false;
	}
	if(formName.elements['ReqDtlCont'].value.length>2000){
		alert("요구 내용은 1000글자 이내로 작성해주세요!!");
		formName.elements['ReqDtlCont'].focus();
		return false;
	}
	formName.submit();
  }//endfunc

  /** 요구 정보로 가기 */
  function gotoList(){
    formName.encType="";
    formName.ReqCont.value="";
    formName.ReqDtlCont.value="";
    formName.AnsEstyleFilePath.value="";
  	formName.action="./RMakeReqInfoVList.jsp";
  	formName.submit();
  }


	/**
	 * 2005-09-13 kogaeng ADD
	 */
	function updateChar2() {
		var length_limit = 2000;
		var aaaElem = document.formName.ReqDtlCont;
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
<form name="formName" method="post" encType="multipart/form-data" action="./RMakeReqInfoEditProc.jsp"><!--요구 수정정보 전달 -->
<!--요구정보 페이지 번호(페이징고려해서 우선 1페이지로) -->
<% objParams.setParamValue("ReqInfoPage","1");%>
<%=objParams.getHiddenFormTags()%>

      <!-- pgTit -->

      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=MenuConstants.REQ_BOX_MAKE%><span class="sub_stl" >- <%=MenuConstants.REQ_INFO_EDIT%></span></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> >  <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.getReqBoxGeneral(request)%> > <%=MenuConstants.REQ_BOX_MAKE%> </div>
        <p><!--문구--></p>
      </div>
      <!-- /pgTit -->

      <!-- contents -->

      <div id="contents">

        <!-- 검색조건 없는 경우 아래 div 삭제 나 주석으로 막으세요.--><!-- /검색조건-->

        <!-- 각페이지 내용 -->

        <!-- list -->
		<span class="list02_tl"> 요구 정보 </span>
        <table border="0" cellspacing="0" cellpadding="0" class="list02">
            <tbody>
                <tr>
                    <th height="25">&bull;&nbsp;요구함명 </th>
                    <td height="25" colspan="3">
						<%=objInfoRsSH.getObject("REQ_BOX_NM")%>
					</td>
                </tr>
			<%
				// 2004-07-08 사무처, 예정처일 경우에는 위원회라는건 보이지마
				if (CodeConstants.ORGAN_GBN_ASM.equalsIgnoreCase(objUserInfo.getOrganGBNCode()) || CodeConstants.ORGAN_GBN_BUD.equalsIgnoreCase(objUserInfo.getOrganGBNCode())) {
				} else {
			%>
                <tr>
                    <th height="25">&bull;&nbsp;소관 위원회 </th>
                    <td height="25" colspan="3">
					<%=objInfoRsSH.getObject("CMT_ORGAN_NM")%>
					</td>
                </tr>
			<% } %>
                <tr>
                    <th height="25" width="149">&bull;&nbsp;회 기</th>
                    <td height="25" colspan="3">제
                        <input onKeyUp="CheckNumeric(this);" maxlength="3" size="3" name="NatCnt" />
                        회 국회 </td>
                </tr>
                <tr>
                    <th height="25" width="149">&bull;&nbsp;업무구분</th>
                    <td height="25" width="149">
					<%=objCdinfo.getRelatedDuty((String)objInfoRsSH.getObject("RLTD_DUTY"))%>
					</td>
                    <th height="25" width="70">&bull;&nbsp;제출기관</th>
                    <td height="25">
					<%=(String)objInfoRsSH.getObject("SUBMT_ORGAN_NM")%>
					</td>
                </tr>
                <tr>
                    <th height="25" width="149">&bull;&nbsp;요구제목</th>
                    <td height="25" colspan="3">
					<input type="text" name="ReqCont" size="70" maxlength="1000" value="<%=(String)objInfoRsSH.getObject("REQ_CONT")%>">
					<br>
					<p>* 한글은 100자, 영문은 200자 까지만 입력 가능합니다.</p>
					</td>
                </tr>
                <tr>
                    <th height="25">&bull;&nbsp;요구함 설명</th>
                    <td colspan="3">
						<textarea rows="8" cols="70" name="ReqDtlCont" style="height:100px;"
							onKeyDown="javascript:updateChar2()"
                      		onKeyUp="javascript:updateChar2()"
                      		onFocus="javascript:updateChar2()"
                      		onClick="javascript:updateChar2()"><%=(String)objInfoRsSH.getObject("REQ_DTL_CONT")%></textarea>
                        <br />
							<table width="100%" border="0" cellspacing="0" cellpadding="0" class=" list_none">
								<tr>
									<td width="6%" valign="top" align="right" style="pading:0;">
											<div id ="textlimit">
												<script>document.write(calcLength(document.formName.ReqDtlCont.value));</script>
											</div>
									</td>
									<td width="94%" height="25" align="left">
									<span class="fonts" >bytes (2000 bytes 까지만 입력됩니다) </span>
									<br><p>* 한글은 100자, 영문은 200자 까지만 입력 가능합니다.</p>
									</td>
                                </tr>
                        </table>
					</td>
                </tr>
                <tr>
                    <th height="25">&bull;&nbsp;공개등급 </th>
						<td height="25" colspan="3">
							<select onChange="changeSubmtOrganList()" name="OpenCL">
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
					<th height="25" width="149">&bull;&nbsp;제출양식파일</th>
					<td height="25" colspan="3">
					<input type="file" name="AnsEstyleFilePath" size="70">
						<%
                      	if(StringUtil.isAssigned((String)objInfoRsSH.getObject("ANS_ESTYLE_FILE_PATH"))){
                      		out.println("<input type=\"checkbox\" name=\"DeleteFile\" value=\"OK\">파일삭제:");
                      		out.println(StringUtil.makeAttachedFileLink((String)objInfoRsSH.getObject("ANS_ESTYLE_FILE_PATH"),(String)objInfoRsSH.getObject("REQ_ID")));
                      		out.println("<br>※제출양식파일을 선택하시면 이전의 파일을 선택하신 파일로 대치합니다");
                      	}//endif
                      	%>
					</td>
				</tr>
                </tbody>
        </table>
        <!-- /list -->


        <!-- 리스트 버튼-->
        <div id="btn_all"  class="t_right">
			<span class="list_bt"><a href="javascript:checkFormData()">저장</a></span>
			<span class="list_bt"><a href="javascript:formName.reset()">취소</a></span>
			<span class="list_bt"><a href="javascript:gotoList()">요구보기</a></span>
		</div>

         <!-- /리스트 버튼-->

        <!-- /각페이지 내용 -->
      </div>
      <!-- /contents -->

    </div>
  </div>
</form>
  <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>