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
<%@ page import="nads.lib.reqsubmit.params.requestinfo.SPreReqInfoViewForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.prereqinfo.SPreReqInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.answerinfo.AnsInfoDelegate" %>
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
	SPreReqInfoViewForm objParams = new SPreReqInfoViewForm();
	SPreReqInfoDelegate objReqInfo = new SPreReqInfoDelegate();
	//로그인 사용자 정보를 가져온다. 권한없음 경우 관람만 가능하다.
	String strReqSubmitFlag = objUserInfo.getReqSubmitFlag();

  	boolean blnParamCheck = false;
  	blnParamCheck = objParams.validateParams(request);
  	if(blnParamCheck == false){
  		System.out.println("Param Check Error ");
  		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  		objMsgBean.setStrCode("DSPARAM-0000");
  		objMsgBean.setStrMsg(objParams.getStrErrors());
%>
  		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
  		return;
  	}

    String strReqID = (String)objParams.getParamValue("ReqID");

 	ResultSetSingleHelper objInfoRsSH = null;	/**요구 정보 상세보기 */


 	try{
  		objInfoRsSH = new ResultSetSingleHelper(objReqInfo.getRecord((String)objParams.getParamValue("ReqID")));
	} catch(AppException objAppEx) {
		System.out.println("AppException : "+objAppEx.getMessage());
  		objAppEx.printStackTrace();
 		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  		objMsgBean.setStrCode(objAppEx.getStrErrCode());
  		objMsgBean.setStrMsg(objAppEx.getMessage());
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
  		return;
	}
%>
<jsp:include page="/inc/header.jsp" flush="true"/>
<link href="/css2/style.css" rel="stylesheet" type="text/css">
<script language="javascript">
  /**답변정보 상세보기로 가기.*/
  function gotoDetail(strID){
  	//window.open("/reqsubmit/common/SAnsInfoView.jsp?AnsID="+strID, "", "width=400px, height=300px");
  	window.open('/reqsubmit/common/SAnsInfoView.jsp?returnURL=POPUP&AnsID='+strID, '', 'width=500,height=400, scrollbars=no, resizable=yes, toolbar=no, menubar=no, location=no, directories=no, status=no');
  }

  /** 목록으로 가기 */
  function gotoList(){
    document.location.href="SNonPreInfoList.jsp";
//  formName.action="SNonPreInfoList.jsp";
//  formName.submit();
  }

  /** 요구 이력보기 */
  function viewReqHistory() {
  	alert('요구이력보기');
  }

  	// 추가 답변 작성 화면으로 이동
	function gotoAddAnsInfoWrite() {
/*		팝업으로 변경함
        f = document.formName;
		f.action = "/reqsubmit/20_comm/40_BasicBox/20_databoxsh/SBasicAnsInfoWrite.jsp";
		f.target = "";
		f.submit();
*/
  		f = document.formName;
		f.target = "newpopup";
		f.action = "/reqsubmit/common/SAnsInfoWrite.jsp";
		var winl = (screen.width - 600) / 2;
		var winh = (screen.height - 600) / 2;
		window.open("/blank.html","newpopup","resizable=yes,menubar=no,status=no,titlebar=no, scrollbars=yes,location=no,toolbar=no,height=600,width=618, left="+winl+", top="+winh);
		f.submit();
	}



</script>
<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<div id="wrap">
  <jsp:include page="/inc/top.jsp" flush="true"/>
  <jsp:include page="/inc/top_menu02.jsp" flush="true"/>
  <div id="container">
    <div id="leftCon">
      <jsp:include page="/inc/log_info.jsp" flush="true"/>
      <jsp:include page="/inc/left_menu02.jsp" flush="true"/>
    </div>
    <div id="rightCon">
<form name="formName" method="post" action="<%=request.getRequestURI()%>"><!--요구함 신규정보 전달 -->
			<%
			//요구 정보 정렬 정보 받기.
			String strReqInfoSortField=objParams.getParamValue("ReqInfoSortField");
			String strReqInfoSortMtd=objParams.getParamValue("ReqInfoSortMtd");
			//요구 정보 페이지 번호 받기.
			String strReqInfoPagNum=objParams.getParamValue("ReqInfoPage");
		    %>
		    <input type="hidden" name="ReqBoxID" value="<%= objInfoRsSH.getObject("REQ_BOX_ID") %>">
			<input type="hidden" name="ReqInfoSortField" value="<%=objParams.getParamValue("ReqInfoSortField")%>"><!--요구정보 목록정렬필드 -->
			<input type="hidden" name="ReqInfoSortMtd" value="<%=objParams.getParamValue("ReqInfoSortMtd")%>"><!--요구정보 목록정령방법-->
			<input type="hidden" name="ReqInfoQryField" value="<%=objParams.getParamValue("ReqInfoQryField")%>"><!--요구정보 조회 필드-->
			<input type="hidden" name="ReqInfoQryTerm" value="<%=objParams.getParamValue("ReqInfoQryTerm")%>"><!--요구정보 조회어-->
			<input type="hidden" name="ReqInfoPage" value="<%=objParams.getParamValue("ReqInfoPage")%>"><!--요구정보 페이지 번호 -->
			<input type="hidden" name="ReqInfoID" value="<%=objParams.getParamValue("ReqID")%>"><!--요구정보 ID-->
			<input type="hidden" name="AnsInfoID" value=""><!--답변정보ID -->
			<input type="hidden" name="ReqID" value="<%= strReqID %>">
			<input type="hidden" name="AddAnsFlag" value="">
			<input type="hidden" name="ReturnURL" value="<%= request.getRequestURI() %>?ReqBoxID=<%= objInfoRsSH.getObject("REQ_BOX_ID") %>&ReqID=<%= strReqID %>">

      <!-- pgTit -->

      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%= MenuConstants.REQ_INFO_LIST_SUBMT_NONE %><span class="sub_stl" >- <%=MenuConstants.REQ_INFO_DETAIL_VIEW%></span></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.REQUEST_BOX_COMM%> > <%=MenuConstants.REQUEST_BOX_PRE%> > <%=MenuConstants.REQ_INFO_LIST_SUBMT_NONE%></div>
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
        <div class="top_btn"><samp>
			 <span class="btn"><a href="javascript:viewReqHistory('<%=objParams.getParamValue("ReqID")%>')">요구 이력 보기</a></span>
			 <span class="btn"><a href="javascript:gotoList()">요구 목록</a></span>
		</samp></div>


        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list02">
            <tr>
              <th scope="col" width="100px;">&bull;&nbsp;요구함명 </th>
			  <td colspan="3"><%=objInfoRsSH.getObject("REQ_BOX_NM")%></td>
            </tr>
            <tr>
              <th scope="col">&bull;&nbsp;제출기관 </th>
			  <td><%=(String)objInfoRsSH.getObject("SUBMT_ORGAN_NM")%></td>
            </tr>
            <tr>
              <th scope="col">&bull;&nbsp;요구기관  </th>
			  <td><%=(String)objInfoRsSH.getObject("REQ_ORGAN_NM")%></td>
            </tr>
            <tr>
              <th scope="col">&bull;&nbsp;요구제목  </th>
			  <td><%=StringUtil.getDescString((String)objInfoRsSH.getObject("REQ_CONT"))%></td>
            </tr>
            <tr>
              <th scope="col">&bull;&nbsp;요구내용  </th>
			  <td><%=StringUtil.getDescString((String)objInfoRsSH.getObject("REQ_DTL_CONT"))%></td>
            </tr>
            <tr>
              <th scope="col">&bull;&nbsp;공개등급  </th>
			  <td><%= CodeConstants.getOpenClass((String)objInfoRsSH.getObject("OPEN_CL")) %></td>
            </tr>
            <tr>
              <th scope="col">&bull;&nbsp;제출양식파일  </th>
			  <td><%=StringUtil.makeAttachedFileLink((String)objInfoRsSH.getObject("ANS_ESTYLE_FILE_PATH"),(String)objInfoRsSH.getObject("REQ_ID"))%></td>
            </tr>
            <tr>
              <th scope="col">&bull;&nbsp;등록자  </th>
			  <td><%=(String)objInfoRsSH.getObject("REGR_NM")%></td>
            </tr>
            <tr>
              <th scope="col">&bull;&nbsp;요구일자  </th>
			  <td><%=StringUtil.getDate((String)objInfoRsSH.getObject("REG_DT"))%></td>
            </tr>
        </table>
        <!-- /list view -->

		<!-- 답변서 발송 -->
        <!-- 리스트 버튼-->
<!--
답변 작성, 요구 이력 보기, 요구 목록
-->
        <div id="btn_all"><div  class="t_right">
			 <div class="mi_btn"><a href="javascript:gotoAddAnsInfoWrite()" onfocus="this.blur()"><span>답변 작성</span></a></div>
		</div></div>
      </div>
      <!-- /contents -->
    </div>
</form>
  </div>
  <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>