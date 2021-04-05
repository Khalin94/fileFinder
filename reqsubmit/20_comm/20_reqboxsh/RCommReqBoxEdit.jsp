<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.CommRequestBoxDelegate" %>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RCommReqBoxVListForm" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%
/******************************************************************************
* Name		  : RCommReqBoxEdit
* Summary	  : 위원회 요구함 정보수정.
* Description : 요구함 수정 화면 제공.
******************************************************************************/
%>
<%
 UserInfoDelegate objUserInfo =null;
 CDInfoDelegate objCdinfo =null;
%>
<%@ include file="../../common/RUserCodeInfoInc.jsp" %>

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
  }//endif

 String strIngStt = (String)request.getParameter("IngStt");
	String strReqBoxStt = (String)request.getParameter("ReqBoxStt");

 String strRltdDuty=null;/** 업무구분 */
 String strSubmtOrganID=null;/** 제출기관ID */

 /******** 데이터 담을 컨테이너 설정 *********/
 ResultSetHelper objSubmtOrganRs=null;  /** 제출기관 리스트 출력용 ResultSetHelper */
 ResultSetHelper objRltdDutyRs=null;   /** 관련기관 리스트 출력용 RsHelper */
 ResultSetSingleHelper objRsSH=null;	/** 요구함 상세보기 정보 */

 try{
   /********* 대리자 정보 설정 *********/
	CommRequestBoxDelegate objReqBox=new CommRequestBoxDelegate(); 		/**요구함 Delegate*/
	OrganInfoDelegate objOrganInfo=new OrganInfoDelegate();   			/** 기관정보 출력용 대리자 */

   /********* 값가져오기 **************/
	objRsSH=new  ResultSetSingleHelper(objReqBox.getRecord((String)objParams.getParamValue("ReqBoxID")));	/** 특정 요구함 정보 가지고 오기.*/
	objSubmtOrganRs=new ResultSetHelper(objOrganInfo.getSubmtOrganList((String)objParams.getParamValue("CmtOrganID")));/**제출기관리스트*/
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

 strRltdDuty=(String)objRsSH.getObject("RLTD_DUTY");/** 업무구분 */
 strSubmtOrganID=(String)objRsSH.getObject("SUBMT_ORGAN_ID");/** 제출기관ID */
 String strSubmtDln=(String)objRsSH.getObject("SUBMT_DLN");/** 제출기한 */
%>
<jsp:include page="/inc/header.jsp" flush="true"/>
<script language=Javascript src="/js/reqsubmit/common.js"></script>
<script language=Javascript src="/js/nads_lib.js"></script>
<script language=Javascript src="/js/datepicker.js"></script>
<script language="JavaScript">

  /** 폼데이터 체크 */
  function checkFormData(){
	if (getByteLength(formName.elements['ReqBoxDsc'].value) > 250) {
		alert("요구함 설명은 한글, 영문을 포함 250자 이내로 입력해 주세요. 단, 한글은 2자로 처리됩니다.");
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
	formName.submit();
  }//endfunc

  /**요구함 상세보기 페이지로 가기.*/
  function gotoView(){
	<% if("002".equalsIgnoreCase(strReqBoxStt)) { %>
	  	formName.action="/reqsubmit/20_comm/20_reqboxsh/20_accend/RAccBoxVList.jsp";
	<% } else if ("011".equalsIgnoreCase(strReqBoxStt)) { %>
		formName.action="/reqsubmit/20_comm/20_reqboxsh/25_accend/RAccBoxConfirmVList.jsp";
  	<% } else { %>
	  	formName.action="./RCommReqBoxVList.jsp";
  	<%}%>
  	formName.submit();
  }
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
<head>

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
		<form name="formName" method="post" action="./RCommReqBoxEditProc.jsp"><!--요구함 신규정보 전달 -->
		<%=objParams.getHiddenFormTags()%>

        <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3>
        <% if("002".equalsIgnoreCase(strIngStt)){
            out.print(MenuConstants.COMM_REQ_BOX_MAKE_END);
        }else{
            out.print(MenuConstants.REQ_BOX_MAKE);
        }%>
        <span class="sub_stl" >-<%=MenuConstants.REQ_BOX_EDIT%></span></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" />  <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.REQUEST_BOX_COMM%> >
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
        <span class="list02_tl">요구함 정보</span>
			<table border="0" cellspacing="0" cellpadding="0" class="list02">
            <tbody>
			<tr>
				<th height="25">&bull;&nbsp;위원회 </th>
				<td height="25" colspan="3"><%=objRsSH.getObject("CMT_ORGAN_NM")%></td>
			</tr>
			<tr>
				<th height="25">&bull;&nbsp;위원회 </th>
				<td height="25">
				제<input type="text" size="3" maxlength="3" name="NatCnt" onKeyUp="CheckNumeric(this);" value="<%=objRsSH.getObject("NAT_CNT")%>">회 국회</td>
				<th height="25" width="149">&bull;&nbsp;회차</th>
				<td height="25"><input type="text" size="3" maxlength="3" name="ReqBoxCnt" onKeyUp="CheckNumeric(this);" value="<%=objRsSH.getObject("REQ_BOX_CNT")%>"></td>
            </tr>
			<tr>
				<th height="25" width="149">&bull;&nbsp;업무구분</th>
              	<td height="25" width="191" colspan="3">
				<select name="RltdDutyX" class="select">
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
				<th height="25">&bull;&nbsp;제출기관</a></th>
				<td height="25" width="191">
				<select name="SubmtOrganID" class="select">
				<%	 while(objSubmtOrganRs.next()){
						String strOrgan=(String)objSubmtOrganRs.getObject("SUBMT_ORGAN_ID");
						out.println("strOrgan : " + strOrgan);
						out.println("<option value=\"" + strOrgan + "\" " + StringUtil.getSelectedStr(strSubmtOrganID,strOrgan) + ">" + objSubmtOrganRs.getObject("SUBMT_ORGAN_NM") + "</option>");
				}
				%>
				</select>
				</td>
				<th height="25">&bull;&nbsp;제출기한</th>
				<td height="25" width="191">
				<input type="text" class="textfield" name="SubmtDln" size="10" maxlength="8"  value="<%=strSubmtDln%>" OnClick="this.select()" OnKeyPress="if ((event.keyCode&lt;48)||(event.keyCode&gt;57)) event.returnValue=false;" OnBlur="javascript:SetFormatDate(this);">
				<input type="button" value="..." style="cursor:hand" OnClick="javascript:show_calendar('formName.SubmtDln');">
				</td>
            </tr>
            <tr>
				<th height="25">&bull;&nbsp;요구함설명</th>
				<td colspan="3">
                <textarea rows="3" cols="70" name="ReqBoxDsc" class="textfield" style="WIDTH: 90% ; height: 80"
                      		onKeyDown="javascript:updateChar2()"
                      		onKeyUp="javascript:updateChar2()"
                      		onfocus="javascript:updateChar2()"><%=objRsSH.getObject("REQ_BOX_DSC")%></textarea>
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
			<!------------------------- TAB에 해당하는 테이블(목록이든 등록폼이든 상세정보든) 출력 끝 ------------------------->
			</td>
		</tr>
		<tr>
	   	<!-- 스페이스한칸 -->
		   	<td>&nbsp;</td>
	   	<!-- 스페이스한칸 -->
		</tr>



        </table>
        <!-- /list -->

        <!-- 리스트 버튼-->
        <div id="btn_all"  class="t_right">
				<span class="list_bt"><a href="#" onClick="checkFormData()" >저장</a></span>
				<span class="list_bt"><a href="#" onClick="formName.reset()">취소</a></span>
				<span class="list_bt"><a href="#" onClick="gotoView()">요구함보기</a></span>
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