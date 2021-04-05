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
<%@ page import="nads.lib.reqsubmit.params.requestinfo.SMemReqInfoViewForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.SMemReqInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.answerinfo.AnsInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.SCommRequestBoxDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	UserInfoDelegate objUserInfo =null;
 	CDInfoDelegate objCdinfo =null;
%>

<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>

<%
	SMemReqInfoViewForm objParams = new SMemReqInfoViewForm();
	SMemReqInfoDelegate objReqInfo = new SMemReqInfoDelegate();
	AnsInfoDelegate objAnsInfo = new AnsInfoDelegate();

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

	String strReqSubmitFlag = objUserInfo.getReqSubmitFlag();
 	ResultSetSingleHelper objInfoRsSH = null;	/**요구 정보 상세보기 */
	ResultSetHelper objRs = null;				/** 답변정보 목록 출력*/
	String strReqID = (String)objParams.getParamValue("ReqID");
	SCommRequestBoxDelegate objReqBox2 = null; 		/**요구함 Delegate*/
	ResultSetSingleHelper objRsSH2 = null;			/** 요구함 상세보기 정보 */

	// 2004-06-04
	String strAuditYear = (String)objParams.getParamValue("strAuditYear");
	String strReqBoxID = (String)objParams.getParamValue("ReqBoxID");
	String strReqOrganID = (String)objParams.getParamValue("ReqOrganID");
	System.out.println("strReqBoxID :"+strReqBoxID);
 	try{
		objReqBox2 = new SCommRequestBoxDelegate();
		objRsSH2 = new ResultSetSingleHelper(objReqBox2.getRecord(strReqBoxID, objUserInfo.getUserID()));

  		objInfoRsSH = new ResultSetSingleHelper(objReqInfo.getRecord(strReqID));
		objRs = new ResultSetHelper(objAnsInfo.getRecordList(strReqID));
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
<script language="javascript">

	/**답변정보 상세보기로 가기.*/
	function gotoDetail(strID){
		var f = document.formName;
		f.target = "popup";
		f.action = "/reqsubmit/common/SAnsInfoView.jsp?AnsID="+strID;
		f.WinType.value = "POPUP";
		NewWindow('/blank.html', 'popup', '520', '400');
		f.submit();
	}

	/** 목록으로 가기 */
	function gotoList(){
		var f = document.formName;
  		f.action="SNonReqList.jsp";
  		f.target = "";
  		f.submit();
	}

	// 추가 답변 작성 화면으로 이동
	function gotoAddAnsInfoWrite() {
		f = document.formName;
  		f.ReqID.value = "<%= strReqID %>";
		f.target = "newpopup";
		f.action = "/reqsubmit/common/SAnsInfoWrite.jsp?AddAnsFlag=Y";
        var winl = (screen.width - 600) / 2;
		var winh = (screen.height - 600) / 2;
		window.open("/blank.html","newpopup","resizable=yes,menubar=no,status=no,titlebar=no, scrollbars=yes,location=no,toolbar=no,height=530,width=595, left="+winl+", top="+winh);
		f.submit();
	}
	
	// 답변 작성 화면으로 이동
  	function goSbmtReqForm() {
  		f = document.formName;
  		f.ReqID.value = "<%= strReqID %>";
		f.target = "newpopup";
		f.action = "/reqsubmit/common/SAnsInfoWrite.jsp";
        var winl = (screen.width - 600) / 2;
		var winh = (screen.height - 600) / 2;
		window.open("/blank.html","newpopup","resizable=yes,menubar=no,status=no,titlebar=no, scrollbars=yes,location=no,toolbar=no,height=530,width=595, left="+winl+", top="+winh);
		f.submit();
  	}
	function goSbmtReqForm_old() {
  		f = document.formName;
  		f.ReqID.value = "<%= strReqID %>";
		f.target = "newpopup";
		f.action = "/reqsubmit/common/SAnsInfoWrite_old.jsp";
		var winl = (screen.width - 550) / 2;
		var winh = (screen.height - 350) / 2;
		window.open("/blank.html","newpopup","resizable=yes,menubar=no,status=no,titlebar=no, scrollbars=yes,location=no,toolbar=no,height=350,width=520, left="+winl+", top="+winh);
		f.submit();
  	}
  	// 선택 답변 삭제
  	function selectDelete() {
  		var f = document.formName;
  		f.ReqID.value = "<%= strReqID %>";
  		f.target = "";
  		if (getCheckCount(f, "AnsID") < 1) {
  			alert("하나 이상의 체크박스를 선택해 주세요");
  			return;
  		}
  		f.action = "/reqsubmit/common/SAnsInfoDelProc.jsp";
  		if (confirm("선택하신 답변들을 삭제하시겠습니까?\n해당 답변들을 삭제하면 포함된 파일들도 일괄 삭제됩니다.")) f.submit();
  	}

	function sbmtReq() {
		f = document.formName;
		f.target = "";
		f.action = "/reqsubmit/common/SReqSubmtDoneProc.jsp";
		if (confirm("현재 요구에 대한 답변 제출을 완료하시겠습니까?")) f.submit();
	}

</script>
<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>
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
<form name="formName" method="post" action="<%=request.getRequestURI()%>"><!--요구함 신규정보 전달 -->
			<%
				//요구 정보 정렬 정보 받기.
				String strReqInfoSortField=objParams.getParamValue("ReqInfoSortField");
				String strReqInfoSortMtd=objParams.getParamValue("ReqInfoSortMtd");
				//요구 정보 페이지 번호 받기.
				String strReqInfoPagNum=objParams.getParamValue("ReqInfoPage");
		    %>
		    <input type="hidden" name="ReqBoxID" value="<%= objInfoRsSH.getObject("REQ_BOX_ID") %>">
		    <input type="hidden" name="ReqID" value="<%= strReqID %>">

		    <!-- 2004-06-04 요구기관ID 및 감사년도 파라미터 설정 -->
		    <input type="hidden" name="ReqOrganID" value="<%= strReqOrganID %>">
		    <input type="hidden" name="AuditYear" value="<%= strAuditYear %>">

			<input type="hidden" name="ReqInfoSortField" value="<%=objParams.getParamValue("ReqInfoSortField")%>"><!--요구정보 목록정렬필드 -->
			<input type="hidden" name="ReqInfoSortMtd" value="<%=objParams.getParamValue("ReqInfoSortMtd")%>"><!--요구정보 목록정령방법-->
			<input type="hidden" name="ReqInfoQryField" value="<%=objParams.getParamValue("ReqInfoQryField")%>"><!--요구정보 조회 필드-->
			<input type="hidden" name="ReqInfoQryTerm" value="<%=objParams.getParamValue("ReqInfoQryTerm")%>"><!--요구정보 조회어-->
			<input type="hidden" name="ReqInfoPage" value="<%=objParams.getParamValue("ReqInfoPage")%>"><!--요구정보 페이지 번호 -->
			<input type="hidden" name="ReqInfoID" value="<%=objParams.getParamValue("ReqID")%>"><!--요구정보 ID-->
			<input type="hidden" name="AnsInfoID" value=""><!--답변정보ID -->
			<input type="hidden" name="ReqStt" value="<%=objInfoRsSH.getObject("REQ_STT")%>">
			<input type="hidden" name="ReqOpenCL" value="<%=objInfoRsSH.getObject("OPEN_CL")%>">

			<input type="hidden" name="WinType" value="SELF">

			<!-- 2004-06-08 kogaeng 깜빡하고 ReturnURL을 빠뜨렸었다. -->
			<input type="hidden" name="ReturnURL" value="<%=request.getRequestURI()%>?ReqBoxID=<%= objInfoRsSH.getObject("REQ_BOX_ID") %>&ReqID=<%= strReqID %>">
      <!-- pgTit -->
      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%= MenuConstants.REQ_INFO_LIST_SUBMT_NONE %><span class="sub_stl" >- <%=MenuConstants.REQ_INFO_DETAIL_VIEW%></span></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.getReqBoxGeneral(request)%> > <%=MenuConstants.REQ_INFO_LIST_SUBMT_NONE%></div>
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
			 <span class="btn"><a href="javascript:viewReqHistory('<%= strReqID %>')">요구이력보기</a></span>
			 <span class="btn"><a href="javascript:gotoList()">요구목록</a></span>
		</samp></div>

        <table border="0" cellspacing="0" cellpadding="0" width="680" class="list02">

            <tr>
                <th height="25">&bull; 요구제목 </th>
                <td height="25" colspan="3"><strong><%=StringUtil.getDescString((String)objInfoRsSH.getObject("REQ_CONT"))%></strong></td>
            </tr>
            <tr>
                <th height="25">&bull; 요구내용 </th>
                <td height="25" colspan="3">- <%=StringUtil.getDescString((String)objInfoRsSH.getObject("REQ_DTL_CONT"))%>
				<%= nads.dsdm.app.reqsubmit.delegate.requestinfo.RequestInfoDelegate.getAppendRequestInfo((List)objInfoRsSH.getObject("TBDS_REQ_LOG")) %>
				</td>
            </tr>
            <tr>
                <th height="25">&bull; 요구함명 </th>
                <td height="25" colspan="3"><%=objInfoRsSH.getObject("REQ_BOX_NM")%> </td>
            </tr>
            <tr>
                <th height="25" width="18%">&bull; 요구기관 </th>
                <td height="25" width="32%"><%=(String)objInfoRsSH.getObject("REQ_ORGAN_NM")%> (<%=(String)objInfoRsSH.getObject("USER_NM")%>) </td>
                <th height="25" width="18%">&bull;&nbsp;제출기관 </th>
                <td height="25" width="32%"><%=(String)objInfoRsSH.getObject("SUBMT_ORGAN_NM")%> </td>
            </tr>
            <tr>
                <th height="25">&bull; 공개등급 </th>
                <td height="25">
				<%= CodeConstants.getOpenClass((String)objInfoRsSH.getObject("OPEN_CL")) %>
				</td>
                <th height="25">&bull;&nbsp;첨부파일</th>
                <td height="25"> <span class="list_bts"><%=StringUtil.makeAttachedFileLink((String)objInfoRsSH.getObject("ANS_ESTYLE_FILE_PATH"),(String)objInfoRsSH.getObject("REQ_ID"))%></span></td>
            </tr>
            <tr>
                <th height="25">&bull; 제출기한</th>
                <td height="25"><%= StringUtil.getDate((String)objInfoRsSH.getObject("SUBMT_DLN")) %> 24:00 </td>
                <th height="25">&bull;&nbsp;요구일시 </th>
                <td height="25"><%=StringUtil.getDate2((String)objInfoRsSH.getObject("REG_DT"))%> </td>
            </tr>
        </table>
        <!-- /list view -->
        <!--<p class="warning mt10">* 요구서 발송 : 의원실(또는 소속기관) 명의로 해당 제출기관에 요구서를 발송합니다.</p>  -->
        <!-- 리스트 버튼  요구이력보기, 요구목록-->
         <div id="btn_all"><div  class="t_right">
		 </div></div>
        <!-- /리스트 버튼-->

        <!-- list -->
        <span class="list01_tl">답변목록 <span class="list_total">&bull;&nbsp;전체자료수 : <%= objRs.getRecordSize() %>개 </span></span>
        <table>
			<tr>
				<td>&nbsp;</td>
			</tr>
		</table>



        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
          <thead>
            <tr>
              <th scope="col" style="width:15px;">
			  <input type="checkbox" name="checkAll" value="" onClick="javascript:checkAllOrNot(this.form)" class="borderNo"/>
			  </th>
              <th scope="col" style="width:15px;"><a>NO</a></th>
              <th scope="col" style="width:40%; "><a>제출의견</a></th>
              <th scope="col"><a>작성자</a></th>
              <th scope="col"><a>공개</a></th>
               <th scope="col"><a>답변</a></th>
              <th scope="col"><a>답변일자</a></th>
            </tr>
          </thead>
          <tbody>
			<%
				int intRecordNumber=1;
				String strAnsInfoID="";
				if (objRs.getRecordSize() > 0) {
					while(objRs.next()) {
						strAnsInfoID=(String)objRs.getObject("ANS_ID");
			 %>
            <tr>
			  <td><input type="checkbox" name="AnsID" value="<%= strAnsInfoID %>" class="borderNo"/></td>
              <td><%=intRecordNumber%></td>
              <td style="text-align:left;"><a href="JavaScript:gotoDetail('<%=strAnsInfoID%>');"><%=StringUtil.substring((String)objRs.getObject("ANS_OPIN"),35)%></a></td>
              <td><%=(String)objRs.getObject("USER_NM")%></td>
              <td><%=CodeConstants.getOpenClass(((String)objRs.getObject("OPEN_CL")))%></td>
              <td><%=nads.lib.reqsubmit.util.DBAccessUtil.makeAnsInfoHtml(strAnsInfoID,(String)objRs.getObject("ANS_MTD"))%></td>
              <td><%=StringUtil.getDate2((String)objRs.getObject("ANS_DT"))%></td>

            </tr>
			<%
						intRecordNumber ++;
					} // endwhile
				} else {
			%>
            <tr>
				<td colspan="7" align="center"> 등록된 답변이 없습니다.</td>
            </tr>
			<%
				}
//추가 답변 등록			%>

          </tbody>
        </table>
         <div id="btn_all"class="t_right">
<%
	String strReqStt = (String)objInfoRsSH.getObject("REQ_STT");
	if (CodeConstants.REQ_STT_NOT.equalsIgnoreCase(strReqStt)) {
%>
			 <span class="list_bt"><a href="javascript:goSbmtReqForm_old()" onfocus="this.blur()">답변작성</a></span>
<% } else { %>
			<span class="list_bt"><a href="javascript:gotoAddAnsInfoWrite()" onfocus="this.blur()">추가답변등록</a></span>
<%
	}
%>
			<span class="list_bt"><a href="javascript:goSbmtReqForm()">대용량파일등록</a></span>
			<span class="list_bt"><a href="javascript:selectDelete()" onfocus="this.blur()">선택삭제</a></span>
<%
	if(!strReqSubmitFlag.equals("004") && !CodeConstants.REQ_STT_SUBMT.equalsIgnoreCase((String)objInfoRsSH.getObject("REQ_STT")) && objRs.getRecordSize() > 0) {
%>
			<span class="list_bt"><a href="javascript:sbmtReq()" onfocus="this.blur()">즉시제출</a></span>
<%
	}
%>
		</div>

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
