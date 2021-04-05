<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RCommReqBoxVListForm" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.CommRequestBoxDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%
/******************************************************************************
* Name		  : RMakeReqInfoWrite.jsp
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
<%@ include file="../../common/RUserCodeInfoInc.jsp" %>
<%
 /*************************************************************************************************/
 /** 					파라미터 체크 Part 														  */
 /*************************************************************************************************/

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
%>

<%
 /*************************************************************************************************/
 /** 					데이터 호출 Part 														  */
 /*************************************************************************************************/

 /*** Delegate 과 데이터 Container객체 선언 */
 CommRequestBoxDelegate objReqBox=null; 		/**요구함 Delegate*/
 ResultSetSingleHelper objRsSH=null;		/** 요구함 상세보기 정보 */
 String strIngStt = (String)request.getParameter("IngStt");
 try{
   /**요구함 정보 대리자 New */
   objReqBox=new CommRequestBoxDelegate();
   /**요구함 이용 권한 체크 */

   boolean blnHashAuth=objReqBox.checkReqBoxAuth((String)objParams.getParamValue("ReqBoxID"),objUserInfo.getCurrentCMTList()).booleanValue();
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
  	objMsgBean.setStrCode(objAppEx.getStrErrCode());
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
<link href="/css/System.css" rel="stylesheet" type="text/css">
<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>
<script language="JavaScript">

  /** 폼데이터 체크 */
  function checkFormData(){
	if(formName.elements['ReqCont'].value==""){
		alert("요구제목을  입력하세요!!");
		formName.elements['ReqCont'].focus();
		return false;
	}
	if (getByteLength(formName.elements['ReqDtlCont'].value) > <%=nads.lib.reqsubmit.EnvConstants.MAX_REQ_DTL_CONT_SIZE%>) {
		alert("요구내용은 한글, 영문을 포함 <%=nads.lib.reqsubmit.EnvConstants.MAX_REQ_DTL_CONT_SIZE%>자 이내로 입력해 주세요. 단, 한글은 2자로 처리됩니다.");
		formName.elements['ReqDtlCont'].focus();
		return false;
	}
	/* 요구중복체크 */
	checkDupReqInfo(formName2);

  }//endfunc

  /**요구함 상세보기 페이지로 가기.*/
  function gotoView(){
	<% if("002".equalsIgnoreCase(strIngStt)){ %>
	formName.action="/reqsubmit/20_comm/20_reqboxsh/20_accend/RAccBoxVList.jsp";
  	<% } else { %>
	formName.action="./RCommReqBoxVList.jsp";
  	<% } %>
  	var str1 = document.formName.ReqCont.value;
  	var str2 = document.formName.ReqDtlCont.value;

  	if (str1.length != 0 && str2.length != 0) {
  		if (confirm("입력하신 요구를 등록하시겠습니까? 취소를 누르시면 등록하지 않습니다.")) {
			formName.action = "./RCommReqInfoWriteProc.jsp";
  			checkFormData();
			return;
  		}
	}
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
          <%/*요구 중복체크용 히든폼*/%>
          <form name="formName2" method="post" action="">
             <input type="hidden" name="ReqBoxID">
             <input type="hidden" name="ReqCont">
             <input type="hidden" name="ReqDtlCont">
          </form>
          <form name="formName" method="post" encType="multipart/form-data" action="./RCommReqInfoWriteProc.jsp"><!--요구 신규정보 전달 -->
			<input type="hidden" name="ReqBoxID" value="<%=objParams.getParamValue("ReqBoxID")%>">
			<input type="hidden" name="CommReqBoxSortField" value="<%=objParams.getParamValue("ReqBoxSortField")%>"><!--요구함목록정렬필드 -->
			<input type="hidden" name="CommReqBoxSortMtd" value="<%=objParams.getParamValue("CommReqBoxSortMtd")%>"><!--요구함목록정령방법-->
			<input type="hidden" name="CommReqBoxPage" value="<%=objParams.getParamValue("CommReqBoxPage")%>"><!--요구함 페이지 번호 -->
			<input type="hidden" name="CommReqInfoQryField" value="<%=objParams.getParamValue("CommReqInfoQryField")%>"><!--요구함 조회필드 -->
			<input type="hidden" name="CommReqInfoQryTerm" value="<%=objParams.getParamValue("CommReqInfoQryTerm")%>"><!--요구함 조회필드 -->
			<input type="hidden" name="CommReqInfoSortField" value="<%=objParams.getParamValue("CommReqInfoSortField")%>"><!--요구정보 목록정렬필드 -->
			<input type="hidden" name="CommReqInfoSortMtd" value="<%=objParams.getParamValue("CommReqInfoSortMtd")%>"><!--요구정보 목록정령방법-->
			<input type="hidden" name="CommReqInfoPage" value="1"><!--요구정보 페이지 번호(페이징고려해서 우선 1페이지로) -->
			<%
			String strURL = (String)request.getParameter("ReturnURL");
			if(strURL == null){
				if("002".equalsIgnoreCase(strIngStt)){
					strURL = "/reqsubmit/20_comm/20_reqboxsh/20_accend/RAccBoxVList.jsp";
				} else {
					strURL = "./RCommReqBoxVList.jsp";
				}
			}
			%>
			<input type="hidden" name="ReturnURL" value="<%=strURL%>">
        <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3>
        <% if("002".equalsIgnoreCase(strIngStt)){ %>
        <B><%=MenuConstants.COMM_REQ_BOX_MAKE_END%></B>
        <% } else { %>
        <B><%=MenuConstants.COMM_REQ_BOX_MAKE%></B>
        <% } %>
        <span class="sub_stl" >-<%=MenuConstants.REQ_INFO_WRITE%></span>
        </h3>

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
        <span class="list02_tl">요구 정보 </span>
                <table cellspacing="0" cellpadding="0" class="list02">
                    <tr>
                      <th height="25">&bull;&nbsp;위원회 </th>
                      <td height="25" colspan="3">
                      <%=objRsSH.getObject("CMT_ORGAN_NM")%>
                      </td>
                    </tr>
                    <tr>
                      <th height="25">&bull;&nbsp;요구함명</th>
                      <td height="25" colspan="3">
                      <%=objRsSH.getObject("REQ_BOX_NM")%>
                      </td>
                    </tr>
                    <tr>
                      <th height="25">&bull;&nbsp;업무구분</th>
                      <td height="25">
                      <%=objCdinfo.getRelatedDuty((String)objRsSH.getObject("RLTD_DUTY"))%>
                      </td>
                      <th height="25">&bull;&nbsp;제출기관 </th>
					  <td height="25">
						<%=(String)objRsSH.getObject("SUBMT_ORGAN_NM")%>
					  </td>
                    </tr>
                    <tr>
                      <th height="25">&bull;&nbsp;요구제목</th>
                      <td height="25" colspan="3">
                      <input type="text" size="90" maxlength="100" name="ReqCont" class="textfield">
                      </td>
                    </tr>
                    <tr>
                      <th height="25">&bull;&nbsp;요구내용</th>
                      <td height="25" colspan="3">
                      	<textarea rows="3" cols="70" name="ReqDtlCont" class="textfield" style="WIDTH: 90% ; height: 120"></textarea>
                      </td>
                    </tr>
                    <tr>
                      <th height="25">&bull;&nbsp;공개등급</th>
                      <td height="25" colspan="3">
                      <select name="OpenCL"  class="select_reqsubmit">
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
                      	<input type="file" name="AnsEstyleFilePath" size="70"  class="textfield">
					  </td>
                   </tr>
                </table>

        <div id="btn_all"class="t_right">
            <span class="list_bt"><a href="#" onClick="javascript:checkFormData();">저장</a></span>
            <span class="list_bt"><a href="#" onClick="formName.reset()">취소</a></span>
            <span class="list_bt"><a href="#" OnClick="javascript:gotoView()">요구함보기</a></span>
        </div>
        </form>
      </div>
    </div>
  </div>
  <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>
