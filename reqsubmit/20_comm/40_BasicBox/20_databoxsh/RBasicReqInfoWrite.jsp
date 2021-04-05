<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RPreReqBoxVListForm" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.prereqbox.PreRequestBoxDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
/******************************************************************************
* Name		  : RBasicReqInfoWrite.jsp
* Summary	  : 요구 등록 페이지 제공.
* Description : 요구정보입력은 큰화면에서 입력 가능하게 해야하고,
*				답변양식 파일을 첨부할수 있는 기능을 제공해야함.
*
*
******************************************************************************/
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
 /*************************************************************************************************/
 /** 					데이터 호출 Part 														  */
 /*************************************************************************************************/

 /*** Delegate 과 데이터 Container객체 선언 */
 PreRequestBoxDelegate objReqBox=null; 		/**요구함 Delegate*/
 ResultSetSingleHelper objRsSH=null;		/** 요구함 상세보기 정보 */
 try{
   /**요구함 정보 대리자 New */
   objReqBox=new PreRequestBoxDelegate();
   /**요구함 이용 권한 체크 */
   boolean blnHashAuth=objReqBox.checkReqBoxAuth((String)objParams.getParamValue("ReqBoxID"),objUserInfo.getOrganID()).booleanValue();
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
    /** 요구함 정보 */
    objRsSH=new ResultSetSingleHelper(objReqBox.getRecord((String)objParams.getParamValue("ReqBoxID")));
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
<%
 /*************************************************************************************************/
 /** 					데이터 값 할당  Part 														  */
 /*************************************************************************************************/

%>
<jsp:include page="/inc/header.jsp" flush="true"/>
<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>
<script language="JavaScript">

  /** 폼데이터 체크 */
  function checkFormData(){
	if(formName.elements['ReqCont'].value==""){
		alert("요구제목을  입력하세요!!");
		formName.elements['ReqCont'].focus();
		return false;
	}

	if(formName.elements['ReqDtlCont'].value.length><%=nads.lib.reqsubmit.EnvConstants.MAX_REQ_DTL_CONT_SIZE%>){
		alert("요구 내용은 <%=nads.lib.reqsubmit.EnvConstants.MAX_REQ_DTL_CONT_SIZE%>글자 이내로 작성해주세요!!");
		formName.elements['ReqDtlCont'].focus();
		return false;
	}


	/* 요구중복체크 */
	checkDupReqInfo(formName2);

  }//endfunc


  /** 요구함 보기  */
  function gotoBoxView(){
  	formName.action="./RBasicReqBoxVList.jsp?ReqBoxID=<%=objParams.getParamValue("ReqBoxID")%>&CmtOrganID=<%=objParams.getParamValue("CmtOrganID")%>";
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
          <form name="formName2" method="post" action="">
             <input type="hidden" name="ReqBoxID">
             <input type="hidden" name="ReqCont">
             <input type="hidden" name="ReqDtlCont">

         </form>
          <form name="formName" method="post" encType="multipart/form-data" action="./RBasicReqInfoWriteProc.jsp"><!--요구 신규정보 전달 -->
            <!--요구정보 페이지 번호(페이징고려해서 우선 1페이지로) -->
            <% objParams.setParamValue("ReqInfoPage","1");%>
            <%=objParams.getHiddenFormTags()%>
             <input type="hidden" name="CmtOrganID">
             <input type="hidden" name="ReqBoxID">
      <!-- pgTit -->

      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=MenuConstants.REQ_BOX_WRITE%><span class="sub_stl" >-<%=MenuConstants.REQ_INFO_WRITE%></span></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" />  <%=MenuConstants.REQUEST_BOX_COMM%> > <%=MenuConstants.REQUEST_BOX_PRE%> > <%=MenuConstants.REQ_BOX_PRE%></div>
        <p><!--문구--></p>
      </div>
      <!-- /pgTit -->

      <!-- contents -->

      <div id="contents">

        <!-- 검색조건 없는 경우 아래 div 삭제 나 주석으로 막으세요.--><!-- /검색조건-->

        <!-- 각페이지 내용 -->

        <!-- list -->
		<span class="list02_tl">요구 정보 </span>
        <table border="0" cellspacing="0" cellpadding="0" class="list02">
            <tbody>
                <tr>
                    <th height="25">&bull;&nbsp;위원회 </th>
                    <td height="25" colspan="3">
					<%=objRsSH.getObject("CMT_ORGAN_NM")%>
					</td>
                </tr>
                <tr>
                    <th height="25" width="149">&bull;&nbsp;요구함명</th>
                    <td height="25" colspan="3"><%=objRsSH.getObject("REQ_BOX_NM")%></td>
                </tr>
                <tr>
                    <th height="25" width="149">&bull;&nbsp;업무구분</th>
                    <td height="25" width="191">
					<%=objCdinfo.getRelatedDuty((String)objRsSH.getObject("RLTD_DUTY"))%>
					</td>
                    <th height="25" width="149">&bull;&nbsp;제출기관</th>
                    <td height="25" width="191">
					<%=(String)objRsSH.getObject("SUBMT_ORGAN_NM")%>
					</td>
                </tr>
                <tr>
                    <th height="25">&bull;&nbsp;요구제목</th>
                    <td height="25" colspan="3">
						<input maxlength="100" size="85" name="ReqCont" />
					</td>
                </tr>
                <tr>
                    <th height="25">&bull;&nbsp;요구내용</th>
                    <td colspan="3">
						<textarea
						onKeyDown="javascript:updateChar2(document.formName, 'ReqDtlCont', '660')"
						onKeyUp="javascript:updateChar2(document.formName, 'ReqDtlCont', '660')"
						onFocus="javascript:updateChar2(document.formName, 'ReqDtlCont', '660')"
						onClick="javascript:updateChar2(document.formName, 'ReqDtlCont', '660')"
						rows="3" cols="70" name="ReqDtlCont" style="height:100px;" wrap="hard" ></textarea>
                        <br />                        <table width="100%" border="0" cellspacing="0" cellpadding="0" class=" list_none">
                            <tr>
                                <td width="6%"><strong>
                                    <div id="textlimit" style="float:let;height:15px;width:30px;"></div>
                                    </strong></td>
                                <td width="94%" height="25">
									<span class="fonts" >bytes (660 bytes 까지만 입력됩니다) </span>
			<!--  기존 시스템 역시 javascript 부분이 없어서 오류 발생.  -->
								</td>
                                </tr>
                        </table></td>
                </tr>
                <tr>
                    <th height="25">&bull;&nbsp;공개등급</th>
                    <td height="25" colspan="3">
					<select name="OpenCL" class="selectBox5"  style="width:auto;" >
				<%
					List objOpenClassList=CodeConstants.getOpenClassList();
					String strOpenClass=CodeConstants.OPN_CL_OPEN;//공개원칙.
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
                    <th height="25">&bull;&nbsp;제출양식파일</th>
                    <td height="25" colspan="3">
						<input size="55" type="file" name="AnsEstyleFilePath"  style="width:90%;"/>
					</td>
                </tr>
                </tbody>
        </table>
        <!-- /list -->








        <!-- 리스트 버튼-->
        <div id="btn_all"  class="t_right">
				<span class="list_bt"><a href="#" onClick="checkFormData()" >저장</a></span>
				<span class="list_bt"><a href="#" onClick="formName.reset()">취소</a></span>
				<span class="list_bt"><a href="#" onClick="gotoBoxView()">요구함보기</a></span>
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