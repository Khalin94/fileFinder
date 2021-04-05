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
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.SMemReqBoxDelegate" %>

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
	SMemReqBoxDelegate sReqDelegate = new SMemReqBoxDelegate();

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

	// 2004-06-04
	String strAuditYear = (String)objParams.getParamValue("strAuditYear");
	String strReqBoxID = (String)objParams.getParamValue("ReqBoxID");
	String strReqOrganID = (String)objParams.getParamValue("ReqOrganID");

 	ResultSetSingleHelper objInfoRsSH = null;	/**요구 정보 상세보기 */
 	ResultSetHelper objRs = null;				/** 답변정보 목록 출력*/

 	try{
  		objInfoRsSH = new ResultSetSingleHelper(objReqInfo.getRecord2((String)objParams.getParamValue("ReqID")));
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

	String UserID = objUserInfo.getUserID();
	String ANSW_PERM_CD = (String)objInfoRsSH.getObject("ANSW_PERM_CD");
%>
<jsp:include page="/inc/header.jsp" flush="true"/>
<script language="javascript">
	var f;
	var ANSW_PERM_CD = '<%=ANSW_PERM_CD %>';

	// 제출 완료
	function sbmtReq() {
		f = document.formName;
		f.target = "";
		f.action = "/reqsubmit/10_mem/20_reqboxsh/10_make/SMakeReqSubmtDoneProc.jsp";
		if (confirm("현재 요구에 대한 답변 제출을 완료하시겠습니까?")) f.submit();
	}

  	// 답변 상세보기로 가기
  	function gotoDetail(AnID,AnsrID,AnswPermCD,strSeq){
        f = document.formName;
        f.target = "popwin";
		f.AnsSEQ.value = strSeq;
        f.action="/reqsubmit/common/SAnsInfoView2.jsp?AnsrID="+AnsrID+"&AnsID="+AnID+"&AnswPermCD="+AnswPermCD;
        NewWindow('/blank.html', 'popwin', '618', '590');
        f.submit();
          //var add_sub = window.showModalDialog('SMakeAnsInfoView.jsp?returnURL=POPUP&ReqBoxID=<%= strReqBoxID %>&ReqID=<%= strReqID %>&AnsID='+strID, '', 'dialogWidth:500px;dialogHeight:300px; center:yes; help:no; status:no; scroll:no; resizable:yes');
          //window.open('/reqsubmit/common/SAnsInfoView.jsp?returnURL=POPUP&ReqBoxID=<%= strReqBoxID %>&ReqID=<%= strReqID %>&AnsID='+strID, '', 'width=500,height=400, scrollbars=no, resizable=yes, toolbar=no, menubar=no, location=no, directories=no, status=no');
      }

  	/** 목록으로 가기 */
  	function gotoList(){
  		formName.action="SSubReqList.jsp";
	  	formName.target = "";
  		formName.submit();
	}

	// 추가 답변 작성 화면으로 이동
  	function goSbmtReqForm() {

		/*if(ANSW_PERM_CD == '222'){	// 답변 승인시

			// 추가답변등록 취소
			alert("해당 요구에 대한 답변을 요구자가 승인하여 추가답변을 등록할 수 없습니다.");

		}else{		// 답변 미승인시*/

			f = document.formName;
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
			//f2.action="/reqsubmit/common/SAnsInfoEdit.jsp?AnsID="+strID;
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
					if(ANSW_PERM_CD == '222' && (ANSW_INQ_YN == 'Y')){	// 답변 승인시
						// 답변 삭제 실행 취소
//						alert("선택하신 답변 중에 요청자가 열람한 답변이 있습니다.\n확인 후 미열람한 답변만 삭제해 주시기 바랍니다.");
						alert("해당 요구에 대한 답변을 요구자가 승인하여 답변을 삭제할 수 없습니다.");
						return;
					}
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

		// 답변자 체크
		var UserID = '<%= UserID %>';
		for(m=0; m<ArrAnsr_id.length; m++){
			if(UserID != ArrAnsr_id[m]){
				alert("로그인 사용자와 답변자가 다른 답변이 존재합니다.\n확인 후 본인이 작성한 답변만 삭제해 주시기 바랍니다.");
				return;
			}
		}


		// 답변 삭제 실행
		f.action = "/reqsubmit/common/SAnsInfoDelProc3.jsp";
		f.target = "";
		if (confirm("선택하신 답변들을 삭제하시겠습니까?\n해당 답변들을 삭제하면 포함된 파일들도 일괄 삭제됩니다.")) f.submit();

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
		var AnswPermCD = f.AnswPermCD.value;
		f.action = "/reqsubmit/common/AnsDocSend.jsp?ReqBoxID=<%= strReqBoxID %>";
		//f.ReturnURL.value = "/reqsubmit/10_mem/30_reqlistsh/10_sub/SSubReqList.jsp?ReqBoxID=<%= strReqBoxID %>";
		f.ReturnURL.value = "/reqsubmit/10_mem/20_reqboxsh/30_makeend/SMakeEndBoxList.jsp?ReqBoxID=<%= strReqBoxID %>";
		f.target = "popwin";
		NewWindow('/blank.html', 'popwin', '470', '300');
		f.submit();
	}
 
	// 자동 답변서 발송 확인
	function checkSendAnsDoc() {
		if(confirm("모든 요구에 대한 답변을 등록하셨습니다. 답변서 발송을 진행하시겠습니까?")) sendAnsDoc();
	}

</script>
<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>
</head>

<body
<%
	int intNotSubmitReqCnt = sReqDelegate.getReqCntNotSubmit1(strReqBoxID);	
	System.out.println("kangthis logs SSubReqVList.jsp intNotSubmitReqCnt => " + intNotSubmitReqCnt);	

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
			<input type="hidden" name="ReqOpenCL" value="<%= objInfoRsSH.getObject("OPEN_CL") %>">

			<input type="hidden" name="AnsInfoID" value=""><!--답변정보ID -->
			<input type="hidden" name="AnsID" value=""><!--답변정보ID -->
			<input type="hidden" name="AnsSEQ" value="">
			<input type="hidden" name="WinType" value="SELF">
			<input type="hidden" name="ReturnURL" value="<%= request.getRequestURI() %>?ReqBoxID=<%= objInfoRsSH.getObject("REQ_BOX_ID") %>&ReqID=<%= strReqID %>">
			<input type="hidden" name="AddAnsFlag" value="Y">

			<!-- 개별 답변 삭제를 위한 Parameter 설정 -->
			<input type="hidden" name="AnsID2" value="">
			<input type="hidden" name="AnswPermCD" value="<%=ANSW_PERM_CD%>">
      <!-- pgTit -->
      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=MenuConstants.REQ_INFO_LIST_SUBMT_DONE%><span class="sub_stl" >- <%=MenuConstants.REQ_INFO_DETAIL_VIEW%></span></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> > <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.getReqBoxGeneral(request)%> > <%=MenuConstants.REQ_INFO_LIST_SUBMT_DONE%></div>
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
			 <span class="btn"><a href="javascript:viewReqHistory('<%= strReqID %>')">요구 이력 보기</a></span>
			 <span class="btn"><a href="javascript:gotoList()">요구목록</a></span>
		</samp></div>

        <table border="0" cellspacing="0" cellpadding="0" width="680" class="list02">

            <tr>
                <th height="25">&bull; 요구제목 </th>
                <td height="25" colspan="3"><strong><%=StringUtil.getDescString((String)objInfoRsSH.getObject("REQ_CONT"))%></strong></td>
            </tr>
            <tr>
                <th height="25">&bull; 요구내용 </th>
                <td height="25" colspan="3">- <%=StringUtil.getDescString((String)objInfoRsSH.getObject("REQ_DTL_CONT"))%> </td>
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
                <td height="25"><%=StringUtil.makeAttachedFileLink((String)objInfoRsSH.getObject("ANS_ESTYLE_FILE_PATH"),(String)objInfoRsSH.getObject("REQ_ID"))%></td>
            </tr>
            <tr>
                <th height="25">&bull; 요구일시</th>
                <td height="25"><%= StringUtil.getDate2((String)objInfoRsSH.getObject("LAST_REQ_DT")) %> </td>
                <th height="25">&bull;&nbsp;답변일시 </th>
                <td height="25"><%= StringUtil.getDate2((String)objInfoRsSH.getObject("LAST_ANS_DT"))%> </td>
            </tr>
            <tr>
                <th height="25">&bull; 답변 승인상태 </th>
                <td height="25"><%= CodeConstants.getAnsApprStt(ANSW_PERM_CD) %></td>
                <th height="25">&nbsp;</th>
                <td height="25">&nbsp;</td>
            </tr>
        </table>
        <!-- /list view -->
        <!--<p class="warning mt10">* 요구서 발송 : 의원실(또는 소속기관) 명의로 해당 제출기관에 요구서를 발송합니다.</p>  -->
		    <p class="warning mt10">* 추가답변 등록시에는 반드시 답변서발송을 진행해야 답변완료가 됩니다.<br> * 답변서 발송을 위하여 F5를 누른후 답변서 발송을 진행하세요.</p>
        <!-- 리스트 버튼-->
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

              <th scope="col"><input name="" type="checkbox" value="" class="borderNo" onClick="javascript:revCheck(this.form, 'AnsID')"/></th>
              <th scope="col" style="width:40%; "><a>제출의견</a></th>
              <th scope="col"><a>작성자</a></th>
              <th scope="col"><a>공개</a></th>
              <th scope="col"><a>답변</a></th>
			  <th scope="col">&nbsp;</th>
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
                    String testkey = objRs.getObject("ANS_ID")+"$$"+objRs.getObject("ANSR_ID")+"$$"+objRs.getObject("ANSW_INQ_YN");
                    String testkey2 = objRs.getObject("ANS_ID")+"$$"+objRs.getObject("ANSR_ID")+"$$"+ANSW_PERM_CD;
			 %>
            <tr>
              <td>
				<input type="checkbox" name="AnsID" value="<%=testkey%>"><%//=intRecordNumber%>
				<input name="AnswInqYn" type="hidden" value="<%= (String)objRs.getObject("ANSW_INQ_YN") %>" >
			  </td>
              <td style="text-align:left;"><a href="JavaScript:gotoDetail('<%=objRs.getObject("ANS_ID")%>','<%=objRs.getObject("ANSR_ID")%>','<%=ANSW_PERM_CD%>','<%=intRecordNumber%>');"><%=StringUtil.substring((String)objRs.getObject("ANS_OPIN"),35)%></a></td>
              <td><%=(String)objRs.getObject("USER_NM")%></td>
              <td><%=CodeConstants.getOpenClass(((String)objRs.getObject("OPEN_CL")))%></td>
              <td><%=this.makeAnsInfoHtml2((String)objRs.getObject("ANS_ID"), (String)objRs.getObject("ANS_MTD"),(String)objInfoRsSH.getObject("REQ_CONT"),intRecordNumber+"",(String)objInfoRsSH.getObject("SUBMT_ORGAN_NM")) %></td>
			  <td><span class="list_bt"><a href="javascript:delAnsDoc('<%= objRs.getObject("ANS_ID") %>','<%= objRs.getObject("ANSR_ID") %>','<%= objRs.getObject("ANSW_INQ_YN") %>');">삭제</a></span></td>
              <td><%=StringUtil.getDate2((String)objRs.getObject("ANS_DT"))%></td>

            </tr>
			<%
						intRecordNumber ++;
					} // endwhile
				} else {
			%>
            <tr>
				<td colspan="6" align="center"> 등록된 답변이 없습니다.</td>
            </tr>
			<%
				}
//추가 답변 등록			%>

          </tbody>
        </table>
		<!-- 제출완료 상태라 하더라도 버튼은 일단 모두 보여주고, 버튼 클릭시 해당 답변에 대한 요구자의 답변 열람 여부를 체크하여 액션을 취할 지 결정한다. -->
		<%
			//if(CodeConstants.REQ_STT_ADD.equals((String)objInfoRsSH.getObject("REQ_STT"))) {
		%>
         <div id="btn_all"class="t_right">
			 <span class="list_bt"><a href="javascript:goSbmtReqForm_old()" onfocus="this.blur()">추가답변등록</a></span>
			 <span class="list_bt"><a href="javascript:goSbmtReqForm()">대용량파일등록</a></span>
			 <span class="list_bt"><a href="javascript:gotoEditForm()">답변수정</a></span>
    		 <!--span class="list_bt"><a href="javascript:selectDelete()">선택삭제</a></span-->
		 </div>
		<%
			//}
		%>

        <!-- /list -->


        <!-- /각페이지 내용 -->
      </div>
</form>

<form name="viewForm2" method="post" action="" style="margin:0px">
                    <!-- 답변 수정을 위한 Parameter 설정 -->
					<input type="hidden" name="ReqBoxID" value="<%= strReqBoxID %>">
					<input type="hidden" name="ReqID" value="<%= strReqID %>">
					<input type="hidden" name="AnsID">
					<input type="hidden" name="WinType" value="POPUP" %>
					<input type="hidden" name="ReturnURL" value="<%= request.getRequestURI() %>?ReqBoxID=<%= strReqBoxID %>&ReqID=<%= strReqID %>">
					<input type="hidden" name="ReqOpenCL" value="">
</form>
      <!-- /contents -->

    </div>
  </div>
  <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>

<%!
	public static String makeAnsInfoHtml2(String strAnsID,String strAnsMtd,String strReqCont,String strSeq,String strSubmt){

		StringBuffer strBufReturn=new StringBuffer();

		strBufReturn.append("<table width=\"100%\" border=\"0\"><tr>");

		if(strAnsMtd.equals(CodeConstants.ANS_MTD_ELEC)){

			strBufReturn.append("<td width='18' height='18' align='left' valign='top'>");

			strBufReturn.append("<img src='/image/reqsubmit/bt_EDoc.gif' width='73' height='16' border='0' >");

			strBufReturn.append("</td>");

			strBufReturn.append("<td width='37%' height='18' valign='top'>");

			strBufReturn.append("<a href='/reqsubmit/common/ReqFileOpen2.jsp?paramAnsId=" + strAnsID + "&DOC=PDF&REQNM=" + strReqCont + "&REQSEQ=" + strSeq + "&SubmtOrganNm="+strSubmt+"' target='_self'>");

			strBufReturn.append("<img src='/image/common/icon_pdf.gif' width='16' height='16' border='0' alt='PDF문서'>");

			strBufReturn.append("</a>");

			strBufReturn.append("&nbsp;<a href='/reqsubmit/common/ReqFileOpen2.jsp?paramAnsId=" + strAnsID + "&DOC=DOC&REQNM=" + strReqCont + "&REQSEQ=" + strSeq + "&SubmtOrganNm="+strSubmt+"' target='_self'>");

			strBufReturn.append("<img src='/image/common/icon_file.gif' border='0' alt='원본문서'>");

			strBufReturn.append("</a>");

			strBufReturn.append("</td>");

		}else if(strAnsMtd.equals(CodeConstants.ANS_MTD_ETCS)){

			strBufReturn.append("<td colspan='2' width='18' height='18' align='left' valign='top'>");

			strBufReturn.append("<img src='/image/reqsubmit/bt_NotEDoc.gif' width='73' height='16' border='0' >");

			strBufReturn.append("</td>");					

		}else if(strAnsMtd.equals("004")){
			strBufReturn.append("<td colspan=\\'2\\' width=\\'18\\' height=\\'18\\' align=\\'left\\' valign=\\'top\\'>");
			strBufReturn.append("<img src=\\'/image/reqsubmit/bt_offLineSubmit.gif\\' width=\\'73\\' height=\\'16\\' border=\\'0\\' alt=\\'오프라인을 통한 제출\\'>");
			strBufReturn.append("</td>");					
		}else {

			strBufReturn.append("<td colspan='2' width='18' height='18' align='left' valign='top'>");

			strBufReturn.append("<img src='/image/reqsubmit/bt_NotPertinentOrg.gif' width='73' height='16' border='0'>");

			strBufReturn.append("</td>");					

		}

		strBufReturn.append("</tr></table>");

		return strBufReturn.toString();

	}
%>
