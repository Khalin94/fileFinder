<%@ page language="java" contentType="text/html;charset=EUC-KR" %>

<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="java.util.*" %>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RCommSubReqListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.CommRequestInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.CommAnsInfoDelegate" %>
<%@ page import="nads.dsdm.app.common.page.PagingDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.SMemReqBoxDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	UserInfoDelegate objUserInfo =null;
	CDInfoDelegate objCdinfo =null;
%>
<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>
<%
	/*** PagingDelegate */
	PagingDelegate objPaging=new PagingDelegate(); 		/*페이징 변환 Delegate*/
%>
<%
	/**일반 요구함 상세보기 파라미터 설정.*/
	RCommSubReqListForm objParams =new RCommSubReqListForm();
	SMemReqBoxDelegate sReqDelegate = new SMemReqBoxDelegate();
	objParams.setParamValue("IsRequester",String.valueOf(objUserInfo.isRequester()));//요구답변자여부설정

	boolean blnParamCheck=false;
	/**전달된 파리미터 체크 */
	blnParamCheck=objParams.validateParams(request);
	if(blnParamCheck==false) {
	  	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
	  	objMsgBean.setStrCode("DSPARAM-0000");
	  	objMsgBean.setStrMsg(objParams.getStrErrors());
	  	out.println("ParamError:" + objParams.getStrErrors());
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}

	//로그인 사용자 정보를 가져온다. 권한없음 경우 관람만 가능하다.
	String strReqSubmitFlag = objUserInfo.getReqSubmitFlag();

	/*** Delegate 과 데이터 Container객체 선언 */
	CommRequestInfoDelegate objReqInfo=null;		/** 요구정보 Delegate */
	CommAnsInfoDelegate objAnsInfo = new CommAnsInfoDelegate();
	ResultSetSingleHelper objRsRI=null;			/** 요구 상세보기 정보 */
	ResultSetHelper objRs = null;					/** 답변 목록 */
	String strReqStt = null;
	String strReqID = objParams.getParamValue("ReqID");
	String strReqBoxID = (String)request.getParameter("ReqBoxID");    	
	try {
		/**요구 정보 대리자 New */
		objReqInfo=new CommRequestInfoDelegate();
		objRsRI=new ResultSetSingleHelper(objReqInfo.getRecord((String)objParams.getParamValue("ReqID")));
		// 답변 목록을 SELECT 한다.
		strReqStt = (String)objRsRI.getObject("REQ_STT");
		objRs = new ResultSetHelper(objAnsInfo.getRecordList((String)objParams.getParamValue("ReqID")));

	} catch(AppException objAppEx) {
	 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
	  	objMsgBean.setStrCode(objAppEx.getStrErrCode());
	  	objMsgBean.setStrMsg(objAppEx.getMessage());
	  	out.println("<br>Error!!!" + objAppEx.getMessage());
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}

	String UserID = objUserInfo.getUserID();
	String ANSW_PERM_CD = (String)objRsRI.getObject("ANSW_PERM_CD");
%>
<jsp:include page="/inc/header.jsp" flush="true"/>
<link href="/css2/style.css" rel="stylesheet" type="text/css">
<script language="javascript">

	var f;
	var ANSW_PERM_CD = '<%=ANSW_PERM_CD %>';

  	// 답변 상세보기로 가기
  	function gotoDetail(strID){
//  		NewWindow('/reqsubmit/common/SAnsInfoView.jsp?returnURL=POPUP&AnsID='+strID, '', 520, 400);
  		//window.open('/reqsubmit/common/SAnsInfoView.jsp?returnURL=POPUP&AnsID='+strID, '', 'width=520,height=400, scrollbars=no, resizable=yes, toolbar=no, menubar=no, location=no, directories=no, status=no');

 		f = document.formName;
  		//f.AnsID.value = strID;
		f.target = "popwin";
  		f.action="/reqsubmit/common/SAnsInfoView2.jsp?AnsID="+strID;
		NewWindow('/blank.html', 'popwin', '618', '590');
  		f.submit();
  	}

  	// 제출된 요구목록으로 가기
  	function gotoList(){
  		f = document.formName;
        f.target = "";
  		f.action="SCommSubReqList.jsp";
  		f.submit();
 	}

	// 추가 답변 작성 화면으로 이동
	function gotoAddAnsInfoWrite() {
		f = document.formName;
		f.action = "/reqsubmit/20_comm/20_reqboxsh/SCommAnsInfoWrite.jsp";
		f.target = "";
		f.submit();
	}

	// 추가 답변 작성 화면으로 이동
  	function goSbmtReqForm() {
//		f = document.formName;
//		f.action = "/reqsubmit/20_comm/20_reqboxsh/SCommAnsInfoWrite.jsp";
//		f.target = "";
//		f.submit();

		/*if(ANSW_PERM_CD == '222'){	// 답변 승인시

			// 추가답변등록 취소
			alert("해당 요구에 대한 답변을 요구자가 승인하여 추가답변을 등록할 수 없습니다.");

		}else{		// 답변 미승인시*/

			f = document.formName;
			f.ReqID.value = "<%= strReqID %>";
			f.AddAnsFlag.value = "Y";
			f.target = "newpopup";
			f.action = "/reqsubmit/common/SAnsInfoWrite.jsp";
			var winl = (screen.width - 600) / 2;
			var winh = (screen.height - 600) / 2;
			window.open("/blank.html","newpopup","resizable=no,menubar=no,status=no,titlebar=no, scrollbars=no,location=no,toolbar=no,height=600,width=595, left="+winl+", top="+winh);
			f.submit();

		//}
	}
	// 추가 답변 작성 화면으로 이동
  	function goSbmtReqForm_old() {

		/*if(ANSW_PERM_CD == '222'){	// 답변 승인시

			// 추가답변등록 취소
			alert("해당 요구에 대한 답변을 요구자가 승인하여 추가답변을 등록할 수 없습니다.");

		}else{		// 답변 미승인시*/

			f = document.formName;
			f.ReqID.value = "<%= strReqID %>";
			f.AddAnsFlag.value = "Y";
			f.target = "newpopup";
			f.action = "/reqsubmit/common/SAnsInfoWrite_old.jsp";
			var winl = (screen.width - 550) / 2;
			var winh = (screen.height - 350) / 2;
			window.open("/blank.html","newpopup","resizable=yes,menubar=no,status=no,titlebar=no,	scrollbars=yes,location=no,toolbar=no,height=350,width=520, left="+winl+", top="+winh);
			f.submit();

		//}
	}
	// 답변수정 : 의정자료유통시스템기능개선사업_2011
	function gotoEditForm() {

		// 체크박스 선택 체크
		var f = document.formName;
		if (getCheckCount(f, "AnsID") != 1) {
  			alert("하나의 체크박스를 선택해 주세요");
  			return;
  		}

		// 체크박스 값 설정(답변아이디-답변자아이디-답변열람여부)
		var obj = f.AnsID;
		var strID = "";	// 체크된 답변아이디
		var Ansr_id = "";	// 체크된 답변자아이디
		var ANSW_INQ_YN = f.AnswInqYn.value; // 요구자 답변 열람 여부 FLAG

		if(obj.length==undefined){	// 답변 목록이 1개일 때 체크했을 경우
			strID = obj.value;
			var arr = new Array();
			arr = strID.split("$$");
			strID = arr[0];
			Ansr_id = arr[1];
			ANSW_INQ_YN = arr[2];
		}else{		// 답변 목록이 1개이상일 때 체크했을 경우
			for(i=0; i<obj.length; i++){
				if(obj[i].checked){
					strID = obj[i].value;
					var arr = new Array();
					arr = strID.split("$$");
					strID = arr[0];
					Ansr_id = arr[1];
					ANSW_INQ_YN = arr[2];
				}
			}
		}

		// 답변자 체크
		var UserID = '<%= UserID %>';
		if(UserID != Ansr_id){
			alert("답변자 본인만 답변을 수정할 수 있습니다.");
			return;
		}

		// 요청자가 답변을 열람했는지 여부 조회
//		if(ANSW_INQ_YN == 'Y'){	// 열람시
		if(ANSW_PERM_CD == '222' && (ANSW_INQ_YN == 'Y')){	// 답변 승인시
			// 답변 수정 실행 취소
//			alert("해당 답변을 요청자가 열람하여 수정할 수 없습니다.");
			alert("해당 요구에 대한 답변을 요구자가 승인하여 답변을 수정할 수 없습니다.");
		}else{	// 미열람시
			// 답변 수정 실행
			// 수정폼으로 전송
			var f2 = document.viewForm2;
			f2.ReqOpenCL.value = f.ReqOpenCL.value;
			f2.target = "popwin";
			f2.action="/reqsubmit/common/SAnsInfoEdit_old.jsp?AnsID="+strID;
			NewWindow('/blank.html', 'popwin', '520', '380');
			f2.submit();
		}

	}

  	// 선택삭제 : 의정자료유통시스템기능개선사업_2011
  	function selectDelete() {

  		// 체크박스 선택 체크
		var f = document.formName;
  		if (getCheckCount(f, "AnsID") < 1) {
  			alert("하나 이상의 체크박스를 선택해 주세요");
  			return;
  		}

		// 체크박스 값 설정(답변아이디-답변자아이디-답변열람여부)
		var obj = f.AnsID;
		var strID = "";	// 체크된 답변아이디
		var Ansr_id = "";	// 체크된 답변자아이디
		var ANSW_INQ_YN = f.AnswInqYn.value; // 요구자 답변 열람 여부 FLAG

		var AnsID = new Array(); // 답변아이디 배열
		var ArrAnsr_id = new Array(); // 답변자아이디 배열

		if(obj.length==undefined){	// 답변 목록이 1개일 때 체크했을 경우
			strID = obj.value;
			var arr = new Array();
			arr = strID.split("$$");
			strID = arr[0];
			Ansr_id = arr[1];
			ANSW_INQ_YN = arr[2];
			f.AnsID.value = strID;	// 파라미터용 답변아이디 재설정
		}else{		// 답변 목록이 1개이상일 때 체크했을 경우
			var j=0;
			var k=0;
			var paraID = "";	// 파라미터용 답변아이디
			for(i=0; i<obj.length; i++){
				if(obj[i].checked){
					strID = obj[i].value;
					var arr = new Array();
					arr = strID.split("$$");
					strID = arr[0];
					Ansr_id = arr[1];
					ANSW_INQ_YN = arr[2];

					AnsID[j] = strID;
					j++;

					ArrAnsr_id[k] = Ansr_id;
					k++;

					// 요청자가 답변을 열람했는지 여부 조회
//					if(ANSW_INQ_YN == 'Y'){	// 열람시
				}
			}
			for(l=0; l<AnsID.length; l++){
				if(l == AnsID.length-1){
					paraID = paraID + AnsID[l];
				}else{
					paraID = paraID + AnsID[l] + ",";
				}
			}
			f.AnsID.value = paraID;	// 파라미터용 답변아이디 재설정
		}
        if(ANSW_PERM_CD == '222' && (ANSW_INQ_YN == 'Y')){	// 답변 승인시
            // 답변 삭제 실행 취소
//						alert("선택하신 답변 중에 요청자가 열람한 답변이 있습니다.\n확인 후 미열람한 답변만 삭제해 주시기 바랍니다.");
            alert("해당 요구에 대한 답변을 요구자가 승인하여 답변을 삭제할 수 없습니다.");
            return;
        }
		// 답변자 체크
		var UserID = '<%= UserID %>';
		for(m=0; m<ArrAnsr_id.length; m++){
			if(UserID != ArrAnsr_id[m]){
				alert("로그인 사용자와 답변자가 다른 답변이 존재합니다.\n확인 후 본인이 작성한 답변만 삭제해 주시기 바랍니다.");
				return;
			}
		}
		// 답변 삭제 실행
		if (confirm("선택하신 답변들을 삭제하시겠습니까?\n해당 답변들을 삭제하면 포함된 파일들도 일괄 삭제됩니다.")) {
	    	f.action = "/reqsubmit/common/SAnsInfoDelProc3.jsp";
    		f.target = "";
            f.submit();
        }

  	}

	// 답변목록에서 답변 삭제 : 의정자료유통시스템기능개선사업_2011
	function delAnsDoc(AnsID,Ansr_id,ANSW_INQ_YN) {	// AnsID : 답변아이디, Ansr_id : 답변자아이디, ANSW_INQ_YN : 요구자 답변열람여부 FLAG

		// 답변자 체크
		var UserID = '<%= UserID %>';
		if(UserID != Ansr_id){
			alert("답변자 본인만 답변을 수정할 수 있습니다.");
			return;
		}

		// 요청자가 답변을 열람했는지 여부 조회
//		if(ANSW_INQ_YN == 'Y'){	// 열람시
		if(ANSW_PERM_CD == '222' && (ANSW_INQ_YN == 'Y')){	// 답변 승인시
			// 답변 삭제 실행 취소
//			alert("해당 답변을 요청자가 열람하여 삭제할 수 없습니다.");
			alert("해당 요구에 대한 답변을 요구자가 승인하여 답변을 삭제할 수 없습니다.");
		}else{	// 미열람시
			// 답변 삭제 실행
			var f = document.formName;
			f.AnsID2.value = AnsID;
			f.target = "";
			f.action = "/reqsubmit/common/SAnsInfoDelProc2.jsp";
			if (confirm("해당 답변을 삭제하시겠습니까?\n해당 답변을 삭제하면 포함된 파일들도 일괄 삭제됩니다.")) f.submit();
		}

	}

	// 답변서 발송
	function sendAnsDoc() {
		var f = document.formName;
		//제출상태 테스트
		var AnswPermCD = f.AnswPermCD.value;
		f.action = "/reqsubmit/common/AnsDocSend.jsp?ReqBoxID=<%= strReqBoxID %>";
		//f.ReturnURL.value = "/reqsubmit/20_comm/30_reqlistsh/SCommSubReqInfo.jsp?ReqBoxID=<%= strReqBoxID %>";
		f.ReturnURL.value = "/reqsubmit/20_comm/20_reqboxsh/40_subend/SCommReqBoxList.jsp?ReqBoxID=<%= strReqBoxID %>";		
		f.target = "popwin";
		NewWindow('/blank.html', 'popwin', '470', '300');
		f.submit();
	}
 
	// 자동 답변서 발송 확인
	function checkSendAnsDoc() {
		if(confirm("모든 요구에 대한 답변을 등록하셨습니다. 답변서 발송을 진행하시겠습니까?")) sendAnsDoc();
	}

</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0"
<%
	int intNotSubmitReqCnt = sReqDelegate.getReqCntNotSubmit1(strReqBoxID);	
	System.out.println("kangthis logs SCommSubReqInfo.jsp intNotSubmitReqCnt => " + intNotSubmitReqCnt);	

	if(intNotSubmitReqCnt > 0) {
		out.println(" onLoad='javascript:checkSendAnsDoc()'");
	}
%>
>
<div id="wrap">
  <jsp:include page="/inc/top.jsp" flush="true"/>
  <jsp:include page="/inc/top_menu02.jsp" flush="true"/>
  <div id="container">
    <div id="leftCon">
      <jsp:include page="/inc/log_info.jsp" flush="true"/>
      <jsp:include page="/inc/left_menu02.jsp" flush="true"/>
	<SCRIPT language="JavaScript" src="/js/reqsubmit/reqinfo.js"></SCRIPT>
	<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>
    </div>
    <div id="rightCon">
<form name="formName" method="post" action="<%=request.getRequestURI()%>">

<%  //요구 정보 정렬 정보 받기.
	String strCommReqInfoSortField=objParams.getParamValue("CommReqInfoSortField");
	String strCommReqInfoSortMtd=objParams.getParamValue("CommReqInfoSortMtd");
	//요구함 정보 페이지 번호 받기.
	String strCommReqInfoPagNum=objParams.getParamValue("CommReqInfoPageNum");
%>
	<input type="hidden" name="CommReqInfoSortField" value="<%=strCommReqInfoSortField%>"><!--요구정보 목록정렬필드 -->
	<input type="hidden" name="CommReqInfoSortMtd" value="<%=strCommReqInfoSortMtd%>"><!--요구정보 목록정령방법-->
	<input type="hidden" name="CommReqInfoPage" value="<%=strCommReqInfoPagNum%>"><!--요구정보 페이지 번호 -->
	<input type="hidden" name="WinType" value="SELF">
	<input type="hidden" name="ReturnURL" value="<%=request.getRequestURI()%>?ReqBoxID=<%=objRsRI.getObject("REQ_BOX_ID")%>&ReqID=<%=(String)objParams.getParamValue("ReqID")%>&AuditYear=<%=objParams.getParamValue("AuditYear")%>">
	<input type="hidden" name="AddAnsFlag" value="Y">
	<input type="hidden" name="ReqBoxID" value="<%=objRsRI.getObject("REQ_BOX_ID") %>">
	<input type="hidden" name="ReqID" value="<%= (String)objParams.getParamValue("ReqID") %>">
	<input type="hidden" name="AuditYear" value="<%=objParams.getParamValue("AuditYear")%>">
	<input type="hidden" name="CmtOrganID" value="<%=objParams.getParamValue("CmtOrganID")%>">
	<input type="hidden" name="ReqOpenCL" value="<%= objRsRI.getObject("OPEN_CL") %>">
	<input type="hidden" name="AnswPermCD" value="<%=ANSW_PERM_CD%>">

	<!-- 개별 답변 삭제를 위한 Parameter 설정 -->
	<input type="hidden" name="AnsID2" value="">
      <!-- pgTit -->
      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=MenuConstants.REQ_INFO_LIST_SUBMT_DONE%><span class="sub_stl" >- 요구상세보기</span></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.REQUEST_BOX_COMM%> > <%=MenuConstants.REQ_INFO_LIST_SUBMT_DONE%></div>
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
			 <span class="btn"><a href="javascript:viewReqHistory('<%=(String)objParams.getParamValue("ReqID")%>')">요구 이력 보기</a></span>
			 <span class="btn"><a href="javascript:gotoList()">요구목록</a></span>
		</samp></div>
        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list02">
			<%
				if(!objRsRI.next()){
			%>
			<tr>
              <th scope="col">&bull;&nbsp;요구 정보 가 없습니다. </th>
			 </tr>
			<%
				}else{
			%>
            <tr>
              <th scope="col">&bull;&nbsp;요구제목 </th>
				  <td colspan="3"><%=objRsRI.getObject("REQ_CONT")%>
				</td>

            </tr>

            <tr>
              <th scope="col">&bull;&nbsp;요구내용 </th>
			  <td colspan="3">- <%=StringUtil.getDescString((String)objRsRI.getObject("REQ_DTL_CONT")) %><br>
			  	<%= nads.dsdm.app.reqsubmit.delegate.requestinfo.RequestInfoDelegate.getAppendRequestInfo((List)objRsRI.getObject("TBDS_REQ_LOG")) %></td>
            </tr>
            <tr>
              <th scope="col">&bull;&nbsp;요구함명  </th>
			  <td colspan="3"><%=objRsRI.getObject("REQ_BOX_NM")%></td>
            </tr>
            <tr>
                <th width="18%" scope="col">&bull;&nbsp;소관위원회 </th>
			    <td width="32%"><%= (String)objRsRI.getObject("CMT_ORGAN_NM") %></td>
                <th width="18%" scope="col">&bull;&nbsp;공개등급 </th>
				<td width="32%" ><%=CodeConstants.getOpenClass((String)objRsRI.getObject("OPEN_CL"))%></td>
            </tr>
            <tr>
              <th scope="col">&bull;&nbsp;요구기관  </th>
			  <td><%=objRsRI.getObject("REQ_ORGAN_NM")%> (<%=objRsRI.getObject("REGR_NM")%>)</td>
              <th scope="col">&bull;&nbsp;제출기관  </th>
			  <td><%=objRsRI.getObject("SUBMT_ORGAN_NM")%></td>
            </tr>
            <tr>
              <th scope="col">&bull;&nbsp;요구일시  </th>
			  <td><%= StringUtil.getDate2((String)objRsRI.getObject("LAST_REQ_DT")) %></td>
              <th scope="col">&bull;&nbsp;제출일시  </th>
			  <td><%= StringUtil.getDate2((String)objRsRI.getObject("LAST_ANS_DT")) %></td>
            </tr>
            <tr>
              <th scope="col">&bull;&nbsp;제출기한  </th>
			  <td><%= StringUtil.getDate((String)objRsRI.getObject("SUBMT_DLN")) %> 24:00</td>
              <th scope="col">&bull;&nbsp;첨부파일  </th>
			  <td><%=StringUtil.makeAttachedFileLink((String)objRsRI.getObject("ANS_ESTYLE_FILE_PATH"),(String)objRsRI.getObject("REQ_ID"))%></td>
            </tr>
            <tr>
                <th height="25">&bull; 답변 승인상태 </th>
                <td height="25"><%= CodeConstants.getAnsApprStt(ANSW_PERM_CD) %></td>
                <th height="25">&nbsp;</th>
                <td height="25">&nbsp;</td>
            </tr>
			<%
				}/** 요구 정보 가 있으면. */
			%>
        </table>
        <!-- /list view -->
		<!-- 답변서 발송 -->
		            <p class="warning mt10">* 추가답변 등록시에는 반드시 답변서발송을 진행해야 답변완료가 됩니다.<br> * 답변서 발송을 위하여 F5를 누른후 답변서 발송을 진행하세요.</p>
        <!-- 리스트 버튼-->
<!--
요구 이력 보기, 요구 목록
-->
        <div id="btn_all"><div  class="t_right">
        </div></div>
        <!-- /리스트 버튼-->

        <!-- list -->
        <span class="list01_tl">답변 목록 <span class="list_total">&bull;&nbsp;전체자료수 :  <%=objRs.getRecordSize()%>개 </span></span>
        <table width="100%" style="padding:0;">
            <tr>
                <td>&nbsp;</td>
            </tr>
        </table>
        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
          <thead>
            <tr>
			  <th scope="col"><input name="" type="checkbox" value="" class="borderNo" onClick="javascript:revCheck(this.form, 'AnsID')"/></th>
              <th scope="col"><a>제출 의견</a></th>
              <th scope="col"><a>답변</a></th>
			  <th scope="col">&nbsp;</th>
              <th scope="col""><a>제출자</a></th>
              <th scope="col"><a>답변일자</a></th>
            </tr>
          </thead>
          <tbody>
	<%
		int intCnt = 1;
		while(objRs.next()){
            String testkey = objRs.getObject("ANS_ID")+"$$"+objRs.getObject("ANSR_ID")+"$$"+objRs.getObject("ANSW_INQ_YN");
            String testkey2 = objRs.getObject("ANS_ID")+"$$"+objRs.getObject("ANSR_ID")+"$$"+ANSW_PERM_CD;
	%>
            <tr>
<%// if (!CodeConstants.REQ_STT_SUBMT.equalsIgnoreCase(strReqStt)) { // 제출완료가 아닌 경우만 보여주세요 %>
              <td> 
				<input type="checkbox" name="AnsID" value="<%=testkey%>">
				<input name="AnswInqYn" type="hidden" value="<%= (String)objRs.getObject("ANSW_INQ_YN") %>">
			  </td>
<%// } %>
			<!--
			  <td><%=intCnt%></td>
			-->
              <td><a href="javascript:gotoDetail('<%=objRs.getObject("ANS_ID")%>','<%=objRs.getObject("ANSR_ID")%>','<%=ANSW_PERM_CD%>')"><%= objRs.getObject("ANS_OPIN") %></a></td>
              <td style="text-align:left;"><%= objRs.getObject("ANSR_NM") %></td>
              <td align="center"><%=nads.lib.reqsubmit.util.DBAccessUtil.makeAnsInfoHtml((String)objRs.getObject("ANS_ID"), (String)objRs.getObject("ANS_MTD")) %></td>
			  <td><span class="list_bt"><a href="javascript:delAnsDoc('<%= objRs.getObject("ANS_ID") %>','<%= objRs.getObject("ANSR_ID") %>','<%= objRs.getObject("ANSW_INQ_YN") %>');">삭제</a></span></td>
              <td><%= StringUtil.getDate2((String)objRs.getObject("ANS_DT")) %></td>
            </tr>
<%
		intCnt++;
	} //endwhile
%>
          </tbody>
        </table>
        <!-- /list -->

       <!-- 리스트 버튼-->
       <span class="right">
            <span class="list_bt"><a href="javascript:goSbmtReqForm_old()">추가답변등록</a></span>
			<span class="list_bt"><a href="javascript:goSbmtReqForm()">대용량파일등록</a></span>
            <span class="list_bt"><a href="javascript:gotoEditForm()">답변수정</a></span>
            <!--span class="list_bt"><a href="javascript:selectDelete()">선택삭제</a></span-->
        </span>
        <!-- /리스트 버튼-->
        <!-- /각페이지 내용 -->
      </div>
      <!-- /contents -->

    </div>
    </div>
    </form>
    <form name="viewForm2" method="post" action="" style="margin:0px">
        <!-- 답변 수정을 위한 Parameter 설정 -->
        <input type="hidden" name="ReqBoxID" value="<%=objRsRI.getObject("REQ_BOX_ID") %>">
        <input type="hidden" name="ReqID" value="<%= (String)objParams.getParamValue("ReqID") %>">
        <input type="hidden" name="AnsID">
        <input type="hidden" name="WinType" value="POPUP" %>
        <input type="hidden" name="ReturnURL" value="<%=request.getRequestURI()%>?ReqBoxID=<%=objRsRI.getObject("REQ_BOX_ID")%>&ReqID=<%=(String)objParams.getParamValue("ReqID")%>&AuditYear=<%=objParams.getParamValue("AuditYear")%>">
        <input type="hidden" name="ReqOpenCL" value="">
    </form>
<jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>