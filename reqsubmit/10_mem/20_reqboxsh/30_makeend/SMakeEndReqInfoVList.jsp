<%@ page language="java" contentType="text/html;charset=EUC-KR" %>

<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.lib.reqsubmit.params.requestinfo.SMemReqInfoVListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.SMemReqInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.answerinfo.AnsInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.MemRequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.SMemReqBoxDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
    UserInfoDelegate objUserInfo = null;
    CDInfoDelegate objCdinfo = null;
%>

<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>

<%
    MemRequestBoxDelegate reqDelegate = null;
    SMemReqInfoDelegate selfDelegate = null;
    AnsInfoDelegate ansDelegate = null;
	//추가답변 후 제출여부 2016.02.17 ksw
    SMemReqBoxDelegate sReqDelegate = new SMemReqBoxDelegate();
	SMemReqInfoVListForm objParams = new SMemReqInfoVListForm();

    boolean blnParamCheck=false;
    blnParamCheck = objParams.validateParams(request);
    if(blnParamCheck==false) {
          objMsgBean.setMsgType(MessageBean.TYPE_WARN);
          objMsgBean.setStrCode("DSPARAM-0000");
          objMsgBean.setStrMsg(objParams.getStrErrors());
          out.println("ParamError:" + objParams.getStrErrors());
          return;
      }//endif

    // 넘어온 파라미터를 설정해서 필요할 ?? 쓰도록 하자
    // 요구함 관련
    String strReqBoxID = objParams.getParamValue("ReqBoxID");
    String strReqID = objParams.getParamValue("ReqID");

    String strReqBoxSortField = objParams.getParamValue("ReqBoxSortField");
    String strReqBoxSortMtd = objParams.getParamValue("ReqBoxSortMtd");
    String strReqBoxPagNum = objParams.getParamValue("ReqBoxPage");
    String strReqBoxQryField = objParams.getParamValue("ReqBoxQryField");
    String strReqBoxQryTerm = objParams.getParamValue("ReqBoxQryTerm");

    // 요구 목록 관련
    String strReqInfoSortField = objParams.getParamValue("ReqInfoSortField");
    String strReqInfoSortMtd = objParams.getParamValue("ReqInfoSortMtd");
    String strReqInfoQryField = objParams.getParamValue("ReqInfoQryField");
    String strReqInfoQryTerm = objParams.getParamValue("ReqInfoQryTerm");
    String strReqInfoPagNum = objParams.getParamValue("ReqInfoPage");

    String strReqStt = null; // 요구 제출 여부 정보

    // 답변 개수 및 페이징 관련
    int intTotalRecordCount = 0;

    ResultSetSingleHelper objRsSH = null;
    ResultSetHelper objRs = null;

    try{
           reqDelegate = new MemRequestBoxDelegate();
           selfDelegate = new SMemReqInfoDelegate();
           ansDelegate = new AnsInfoDelegate();

           boolean blnHashAuth = reqDelegate.checkReqBoxAuth(strReqBoxID, objUserInfo.getOrganID()).booleanValue();

           if(!blnHashAuth) {
               objMsgBean.setMsgType(MessageBean.TYPE_WARN);
                objMsgBean.setStrCode("DSAUTH-0001");
                objMsgBean.setStrMsg("해당 요구함을 볼 권한이 없습니다.");
                out.println("해당 요구함을 볼 권한이 없습니다.");
            return;
        } else {
            // 요구 등록 정보를 SELECT 한다.
            objRsSH = new ResultSetSingleHelper(selfDelegate.getRecord2(strReqID));
            // 요구 제출 여부 정보를 쒜팅!
            strReqStt = (String)objRsSH.getObject("REQ_STT");
            // 답변 목록을 SELECT 한다.
            objRs = new ResultSetHelper(ansDelegate.getRecordList_view(objParams));
            intTotalRecordCount = objRs.getTotalRecordCount();
        }
    } catch(AppException e) {
        objMsgBean.setMsgType(MessageBean.TYPE_ERR);
          objMsgBean.setStrCode(e.getStrErrCode());
          objMsgBean.setStrMsg(e.getMessage());
          out.println("<br>Error!!!" + e.getMessage());
          return;
     }

    String UserID = objUserInfo.getUserID();
    String ANSW_PERM_CD = (String)objRsSH.getObject("ANSW_PERM_CD");
%>
<jsp:include page="/inc/header.jsp" flush="true"/>
<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>

<script language="javascript">
    var f;
    var ANSW_PERM_CD = '<%=ANSW_PERM_CD %>';

    // 제출 완료
    function sbmtReq() {
        f = document.viewForm;
        f.target = "";
        f.action = "/reqsubmit/common/SReqSubmtDoneProc.jsp";
        if (confirm("현재 요구에 대한 답변 제출을 완료하시겠습니까?")) f.submit();
    }

    // 요구함 보기
    function goReqBoxView() {
        f = document.viewForm;
        f.action = "SMakeEndBoxVList.jsp";
        f.target = "";
        f.submit();
    }

    // 요구함 목록 조회
    function goReqBoxList() {
        f = document.viewForm;
        f.action = "SMakeEndBoxList.jsp";
        f.target = "";
        f.submit();
    }

      // 답변 상세보기로 가기
      function gotoDetail(AnID,AnsrID,AnswPermCD,strSeq){
        f = document.viewForm;
        f.target = "popwin";
        f.AnsrID.value = AnsrID;
        f.AnswPermCD.value = AnswPermCD;
		f.AnsSEQ.value = strSeq;
        f.action="/reqsubmit/common/SAnsInfoView2.jsp?AnsrID="+AnsrID+"&AnsID="+AnID+"&AnswPermCD="+AnswPermCD;
        NewWindow('/blank.html', 'popwin', '618', '590');
        f.submit();
          //var add_sub = window.showModalDialog('SMakeAnsInfoView.jsp?returnURL=POPUP&ReqBoxID=<%= strReqBoxID %>&ReqID=<%= strReqID %>&AnsID='+strID, '', 'dialogWidth:500px;dialogHeight:300px; center:yes; help:no; status:no; scroll:no; resizable:yes');
          //window.open('/reqsubmit/common/SAnsInfoView.jsp?returnURL=POPUP&ReqBoxID=<%= strReqBoxID %>&ReqID=<%= strReqID %>&AnsID='+strID, '', 'width=500,height=400, scrollbars=no, resizable=yes, toolbar=no, menubar=no, location=no, directories=no, status=no');
      }

      // 추가답변등록 화면으로 이동
      function goSbmtReqForm() {
          //f = document.viewForm;
          //f.ReqID.value = "<%= strReqID %>";
          //f.AddAnsFlag.value = "Y";
          //f.action = "/reqsubmit/10_mem/20_reqboxsh/10_make/SMakeAnsInfoWrite.jsp";
        //f.target = "";
         //f.submit();

        /*if(ANSW_PERM_CD == '222'){    // 답변 승인시

            // 추가답변등록 취소
            alert("해당 요구에 대한 답변을 요구자가 승인하여 추가답변을 등록할 수 없습니다.");

        }else{        // 답변 미승인시*/

            f = document.viewForm;
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

    // 답변수정 : 의정자료유통시스템기능개선사업_2011
    function gotoEditForm() {

        // 체크박스 선택 체크
        var f = document.viewForm;
        if (getCheckCount(f, "AnsID") != 1) {
              alert("하나의 체크박스를 선택해 주세요");
              return;
          }

        // 체크박스 값 설정(답변아이디-답변자아이디-답변열람여부)
        var obj = f.AnsID;
        var strID = "";    // 체크된 답변아이디
        var Ansr_id = "";    // 체크된 답변자아이디
        var ANSW_INQ_YN = f.AnswInqYn.value; // 요구자 답변 열람 여부 FLAG

        if(obj.length==undefined){    // 답변 목록이 1개일 때 체크했을 경우
            strID = obj.value;
            var arr = new Array();
            arr = strID.split("$$");
            strID = arr[0];
            Ansr_id = arr[1];
            ANSW_INQ_YN = arr[2];
        }else{        // 답변 목록이 1개이상일 때 체크했을 경우
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
//        if(ANSW_INQ_YN == 'Y'){    // 열람시
        if(ANSW_PERM_CD == '222' && (ANSW_INQ_YN == 'Y')){    // 답변 승인시
            // 답변 수정 실행 취소
//            alert("해당 답변을 요청자가 열람하여 수정할 수 없습니다.");
            alert("해당 요구에 대한 답변을 요구자가 승인하여 답변을 수정할 수 없습니다.");
        }else{    // 미열람시
            // 답변 수정 실행
            // 수정폼으로 전송
            var f2 = document.viewForm2;
            f2.ReqOpenCL.value = f.ReqOpenCL.value;
            f2.target = "popwin";
			f2.action="/reqsubmit/common/SAnsInfoEdit.jsp?AnsID="+strID+"&AnsrId="+Ansr_id;
            NewWindow('/blank.html', 'popwin', '580', '580');
            f2.submit();
        }

    }

      // 선택삭제 : 의정자료유통시스템기능개선사업_2011
      function selectDelete() {

          // 체크박스 선택 체크
        var f = document.viewForm;
          if (getCheckCount(f, "AnsID") < 1) {
              alert("하나 이상의 체크박스를 선택해 주세요");
              return;
          }

        // 체크박스 값 설정(답변아이디-답변자아이디-답변열람여부)
        var obj = f.AnsID;
        var strID = "";    // 체크된 답변아이디
        var Ansr_id = "";    // 체크된 답변자아이디
        var ANSW_INQ_YN = f.AnswInqYn.value; // 요구자 답변 열람 여부 FLAG

        var AnsID = new Array(); // 답변아이디 배열
        var ArrAnsr_id = new Array(); // 답변자아이디 배열

        if(obj.length==undefined){    // 답변 목록이 1개일 때 체크했을 경우
            strID = obj.value;
            var arr = new Array();
            arr = strID.split("$$");
            strID = arr[0];
            Ansr_id = arr[1];
            ANSW_INQ_YN = arr[2];
            f.AnsID.value = strID;    // 파라미터용 답변아이디 재설정
            if(ANSW_PERM_CD == '222' && (ANSW_INQ_YN == 'Y')){    // 답변 승인시
                // 답변 삭제 실행 취소
                alert("해당 요구에 대한 답변을 요구자가 승인하여 답변을 삭제할 수 없습니다.");
                return;
            }
        }else{        // 답변 목록이 1개이상일 때 체크했을 경우
            var j=0;
            var k=0;
            var paraID = "";    // 파라미터용 답변아이디
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
//                    if(ANSW_INQ_YN == 'Y'){    // 열람시
                    if(ANSW_PERM_CD == '222' && (ANSW_INQ_YN == 'Y')){    // 답변 승인시
                        // 답변 삭제 실행 취소
//                        alert("선택하신 답변 중에 요청자가 열람한 답변이 있습니다.\n확인 후 미열람한 답변만 삭제해 주시기 바랍니다.");
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
            f.AnsID2.value = paraID;    // 파라미터용 답변아이디 재설정
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
    function delAnsDoc(AnsID,Ansr_id,ANSW_INQ_YN) {    // AnsID : 답변아이디, Ansr_id : 답변자아이디, ANSW_INQ_YN : 요구자 답변열람여부 FLAG

        // 답변자 체크
        var UserID = '<%= UserID %>';
        if(UserID != Ansr_id){
            alert("답변자 본인만 답변을 삭제할 수 있습니다.");
            return;
        }

        // 요청자가 답변을 열람했는지 여부 조회
//        if(ANSW_INQ_YN == 'Y'){    // 열람시
        if(ANSW_PERM_CD == '222' && (ANSW_INQ_YN == 'Y')){    // 답변 승인시
            // 답변 삭제 실행 취소
//            alert("해당 답변을 요청자가 열람하여 삭제할 수 없습니다.");
            alert("해당 요구에 대한 답변을 요구자가 승인하여 답변을 삭제할 수 없습니다.");
        }else{    // 미열람시
            // 답변 삭제 실행
            var f = document.viewForm;
            f.AnsID2.value = AnsID;
            f.target = "";
            f.action = "/reqsubmit/common/SAnsInfoDelProc2.jsp";
            if (confirm("해당 답변을 삭제하시겠습니까?\n해당 답변을 삭제하면 포함된 파일들도 일괄 삭제됩니다.")) f.submit();
        }

    }

	// 답변서 발송
	function sendAnsDoc() {
		var f = document.viewForm;
		//제출상태 테스트
		var AnswPermCD = f.AnswPermCD.value;
		f.action = "/reqsubmit/common/AnsDocSend.jsp?ReqBoxID=<%= strReqBoxID %>";
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
	System.out.println("kangthis logs SMakeEndReqInfoVList.jsp intNotSubmitReqCnt => " + intNotSubmitReqCnt);	

	if(intNotSubmitReqCnt > 0) {
		out.println(" onLoad='javascript:checkSendAnsDoc()'");
	}
%>
>
<div id="wrap">
<SCRIPT language="JavaScript" src="/js/reqsubmit/reqinfo.js"></SCRIPT>
  <jsp:include page="/inc/top.jsp" flush="true"/>
  <jsp:include page="/inc/top_menu02.jsp" flush="true"/>
  <div id="container">
    <div id="leftCon">
      <jsp:include page="/inc/log_info.jsp" flush="true"/>
      <jsp:include page="/inc/left_menu02.jsp" flush="true"/>
    </div>
    <div id="rightCon">
      <!-- pgTit -->
      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%= MenuConstants.REQ_BOX_MAKE_END %> <span class="sub_stl" >- <%= MenuConstants.REQ_INFO_DETAIL_VIEW %></span></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> > <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.getReqBoxGeneral(request)%> > <%=MenuConstants.REQ_BOX_MAKE_END %></div>
        <p><!--문구--></p>
      </div>
      <!-- /pgTit -->

      <!-- contents -->

      <div id="contents">
<form name="viewForm" method="post" action="" style="margin:0px">
                    <!-- 요구함 등록 정보 관련 -->
                    <input type="hidden" name="ReqBoxID" value="<%= strReqBoxID %>">
                    <input type="hidden" name="ReqBoxSortField" value="<%= strReqBoxSortField %>"><!--요구함목록정렬필드 -->
                    <input type="hidden" name="ReqBoxSortMtd" value="<%= strReqBoxSortMtd %>"><!--요구함목록정렬방법-->
                    <input type="hidden" name="ReqBoxPage" value="<%= strReqBoxPagNum %>"><!--요구함 페이지 번호 -->
                    <% if(StringUtil.isAssigned(strReqBoxQryTerm)) { %>
                    <input type="hidden" name="ReqBoxQryField" value="<%= strReqBoxQryField %>"><!--요구함 조회필드 -->
                    <input type="hidden" name="ReqBoxQryTerm" value="<%= strReqBoxQryTerm %>"><!--요구함 조회필드 -->
                    <% } //요구함 조회어가 있는 경우만 출력해서 사용함 %>

                    <!-- 요구 목록 관련 -->
                    <input type="hidden" name="ReqID" value="<%= strReqID %>"> <!-- 요구 ID -->
                    <input type="hidden" name="ReqInfoSortField" value="<%= strReqInfoSortField %>"><!--요구정보 목록정렬필드 -->
                    <input type="hidden" name="ReqInfoSortMtd" value="<%= strReqInfoSortMtd %>"><!--요구정보 목록정렬방법-->
                    <% if(StringUtil.isAssigned(strReqInfoQryTerm)) { %>
                    <input type="hidden" name="ReqInfoQryField" value="<%= strReqInfoQryField %>"><!--요구정보 조회필드 -->
                    <input type="hidden" name="ReqInfoQryTerm" value="<%= strReqInfoQryTerm %>"><!-- 요구정보 조회어 -->
                    <% } %>
                    <input type="hidden" name="ReqInfoPage" value="<%= strReqInfoPagNum %>"><!-- 요구정보 페이지 번호 -->
                    <input type="hidden" name="ReqStt" value="<%= strReqStt %>">
                    <input type="hidden" name="ReqOpenCL" value="<%= objRsSH.getObject("OPEN_CL") %>">

                    <!-- 삭제 후 반환될 URL을 선택하기 위한 Parameter 설정 -->
                    <input type="hidden" name="WinType" value="SELF">
                    <input type="hidden" name="ReturnURL" value="<%= request.getRequestURI() %>?ReqBoxID=<%= strReqBoxID %>&ReqID=<%= strReqID %>">
                    <input type="hidden" name="AddAnsFlag" value="">
					<input type="hidden" name="AnsSEQ" value="">

                    <!-- 개별 답변 삭제를 위한 Parameter 설정 -->
                    <input type="hidden" name="AnsID2" value="">
                    <input type="hidden" name="AnsrID" value="<%=objRs.getObject("ANSR_ID")%>">
                    <input type="hidden" name="AnswPermCD" value="<%=ANSW_PERM_CD%>">
        <!-- 검색조건 없는 경우 아래 div 삭제 나 주석으로 막으세요.-->
        <!-- /검색조건-->


        <!-- 각페이지 내용 -->
         <!-- list view-->

        <span class="list02_tl">요구 등록 정보 </span>
        <div class="top_btn"><samp>
            <span class="btn"><a href="javascript:viewReqHistory('<%= strReqID %>')">요구 이력 보기</a></span>
            <span class="btn"><a href="javascript:goReqBoxView()">요구함 보기</a></span>
            <span class="btn"><a href="javascript:goReqBoxList()">요구함 목록</a></span>
        </samp></div>

        <table border="0" cellspacing="0" cellpadding="0" width="680" class="list02">
            <tr>
                <th height="25">&bull; 요구제목 </th>
                <td height="25" colspan="3"><strong><%= objRsSH.getObject("REQ_CONT") %></strong></td>
            </tr>
            <tr>
                <th height="25">&bull; 요구내용 </th>
                <td height="25" colspan="3">
                <%= StringUtil.getDescString((String)objRsSH.getObject("REQ_DTL_CONT")) %>
                                  <%= nads.dsdm.app.reqsubmit.delegate.requestinfo.RequestInfoDelegate.getAppendRequestInfo((List)objRsSH.getObject("TBDS_REQ_LOG")) %>
                </td>
            </tr>
            <tr>
                <th height="25">&bull; 요구함명 </th>
                <td height="25" colspan="3"><%= objRsSH.getObject("REQ_BOX_NM") %> </td>
            </tr>
            <tr>
                <th height="25" width="18%">&bull; 요구기관 </th>
                <td height="25" width="32%"><%= objRsSH.getObject("REQ_ORGAN_NM") %> (<%= objRsSH.getObject("USER_NM") %>)</td>
                <th height="25" width="18%">&bull;&nbsp;제출기관</th>
                <td height="25" width="32%"><%= objRsSH.getObject("SUBMT_ORGAN_NM") %></td>
            </tr>
            <tr>
                <th height="25">&bull; 공개등급 </th>
                <td height="25">
                    <%= CodeConstants.getOpenClass((String)objRsSH.getObject("OPEN_CL")) %>
                </td>
                <th height="25">&bull;&nbsp;첨부파일 </th>
                <td height="25">
                    <%= StringUtil.makeAttachedFileLink((String)objRsSH.getObject("ANS_ESTYLE_FILE_PATH"), (String)objRsSH.getObject("REQ_ID")) %>
                </td>
            </tr>
            <tr>
                <th height="25">&bull; 요구일자 </th>
                <td height="25"><%= StringUtil.getDate2((String)objRsSH.getObject("LAST_REQ_DT")) %></td>
                <th height="25">&bull;&nbsp;제출일자</th>
                <td height="25"><%= StringUtil.getDate2((String)objRsSH.getObject("LAST_ANS_DT")) %></td>
            </tr>
            <tr>
                <th height="25">&bull; 제출기한 </th>
                <td height="25"><%= StringUtil.getDate((String)objRsSH.getObject("SUBMT_DLN")) %> 24:00</td>
                <th height="25">&bull;&nbsp;제출 여부</th>
                <td height="25"><%= CodeConstants.getRequestStatus(strReqStt) %></td>
            </tr>
            <tr>
                <th height="25">&bull; 답변 승인상태 </th>
                <td height="25"><%= CodeConstants.getAnsApprStt(ANSW_PERM_CD) %></td>
                <th height="25">&nbsp;</th>
                <td height="25">&nbsp;</td>
            </tr>
        </table>
        <!-- /list view -->
<!--        <p class="warning mt10">* 요구서 발송 : 의원실(또는 소속기관) 명의로 해당 제출기관에 요구서를 발송합니다.</p> -->
			<p class="warning mt10">* 추가답변 등록시에는 반드시 답변서발송을 진행해야 답변완료가 됩니다.<br> * 답변서 발송을 위하여 F5를 누른후 답변서 발송을 진행하세요.</p>
        <!-- 리스트 버튼
즉시 제출
요구 이력 보기
요구함 보기
요구함 목록
        -->
        <div id="btn_all"><div  class="t_right">
        <!-- 제출 완료 -->
        <% if (!CodeConstants.REQ_STT_SUBMT.equalsIgnoreCase(strReqStt)) { // 제출완료가 아닌 경우만 보여주세요 %>
             <div class="mi_btn"><a href="javascript:sbmtReq()"><span>즉시 제출</span></a></div>
        <% } %>
        </div></div>

        <!-- /리스트 버튼-->

        <!-- list -->
        <span class="list01_tl">답변목록 <span class="list_total">&bull;&nbsp;전체자료수 :  <%= intTotalRecordCount %>개 </span></span>
        <table>
            <tr>
                <td>&nbsp;</td>
            </tr>
        </table>
        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
          <thead>
            <tr>
              <th scope="col" width="10">
                <%// if (!CodeConstants.REQ_STT_SUBMT.equalsIgnoreCase(strReqStt)) { // 제출완료가 아닌 경우만 보여주세요 %>
                <input name="" type="checkbox" value="" class="borderNo" onClick="javascript:revCheck(this.form, 'AnsID')"/>
              <% //}  else { %>
                <!--    NO    -->
              <% //} %>
              </th>
              <th scope="col" style="width:250px;"><a>제출 의견</a></th>
              <th scope="col" style="width:50px; "><a>작성자</a></th>
              <th scope="col" style="width:50px; "><a>&nbsp;</a></th>
              <th scope="col"><a>답변</a></th>
              <th scope="col" >&nbsp;</th>
              <th scope="col"><a>작성일</a></th>
            </tr>
          </thead>
          <tbody>
<%
    int intRecordNumber= 1;
    while(objRs.next()){
%>
            <tr>
              <td>
                <%// if (!CodeConstants.REQ_STT_SUBMT.equalsIgnoreCase(strReqStt)) { // 제출완료가 아닌 경우만 보여주세요 %>
                <%
                    String testkey = objRs.getObject("ANS_ID")+"$$"+objRs.getObject("ANSR_ID")+"$$"+objRs.getObject("ANSW_INQ_YN");
                    String testkey2 = objRs.getObject("ANS_ID")+"$$"+objRs.getObject("ANSR_ID")+"$$"+ANSW_PERM_CD;
                %>
                    <input type="checkbox" name="AnsID" value="<%=testkey%>">
                    <input name="OpenCL" type="hidden" value="<%= (String)objRs.getObject("OPEN_CL") %>" />
					<input name="AnswInqYn" type="hidden" value="<%= (String)objRs.getObject("ANSW_INQ_YN") %>" />
					<input name="AnsrId" type="hidden" value="<%= (String)objRs.getObject("ANSR_ID") %>" />
                <%// } else { %>
                    <%//= intRecordNumber+1 %>
                <%// } %>
              </td>
              <td style="text-align:left;"><a href="javascript:gotoDetail('<%=objRs.getObject("ANS_ID")%>','<%=objRs.getObject("ANSR_ID")%>','<%=ANSW_PERM_CD%>','<%=intRecordNumber%>')"><%= objRs.getObject("ANS_OPIN") %></a></td>
              <td><%= objRs.getObject("USER_NM") %></td>
              <td>&nbsp;</td>
              <td><%=this.makeAnsInfoHtml2((String)objRs.getObject("ANS_ID"), (String)objRs.getObject("ANS_MTD"),(String)objRsSH.getObject("REQ_CONT"),intRecordNumber+"",(String)objRsSH.getObject("SUBMT_ORGAN_NM")) %></td>
              <td><span class="list_bt"><a href="javascript:delAnsDoc('<%= objRs.getObject("ANS_ID") %>','<%= objRs.getObject("ANSR_ID") %>','<%= objRs.getObject("ANSW_INQ_YN") %>');">삭제</a></span></td>
              <td><%= StringUtil.getDate2((String)objRs.getObject("ANS_DT")) %></td>
            </tr>
        <%
                intRecordNumber++;
            } //endwhile
        %>

<!--
    자료가 없을 경우
            <tr>
             <td colspan="6"  align ="center"> 등록된 요구정보가 없습니다. </td>
            </tr>
-->
          </tbody>
        </table>

        <!-- /list -->


        <!-- 페이징
        <span class="paging" > <span class="list_num_on"><a href="#">1</a></span> <span class="list_num"><a href="#">2</a></span> <span class="list_num"><a href="#">3</a></span> <span class="list_num"><a href="#">4</a></span> <span class="list_num"><a href="#">5</a></span> </span>

         /페이징-->


       <!-- 리스트 버튼 -->
        <div id="btn_all" >
        <!-- 리스트 내 검색 -->
<!--
        <div class="list_ser" >
<!--
          <select name="select" class="selectBox5"  style="width:70px;" >
            <option value="">요구제목</option>
            <option value="">요구내용</option>
          </select>
          <input name="iptName" onKeyDown="return ch()" onMouseDown="return ch()"
         class="li_input"  style="width:100px"/>
          <img src="/images2/btn/bt_list_search.gif"  onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"/> </div>


-->
        <!-- /리스트 내 검색  -->
        <!-- 제출완료 상태라 하더라도 버튼은 일단 모두 보여주고, 버튼 클릭시 해당 답변에 대한 요구자의 답변 열람 여부를 체크하여 액션을 취할 지 결정한다. -->
            <span class="right">
<%// if (!CodeConstants.REQ_STT_SUBMT.equalsIgnoreCase(strReqStt)) { // 제출완료가 아닌 경우만 보여주세요 %>
                <span class="list_bt"><a href="javascript:goSbmtReqForm()">추가답변등록</a></span>
                <span class="list_bt"><a href="javascript:gotoEditForm()">답변수정</a></span>
                <span class="list_bt"><a href="javascript:selectDelete()">선택삭제</a></span>
<%// } %>
            </span>
        </div>

       <!--  /리스트 버튼-->
        <!-- /각페이지 내용
      </div>
      <!-- /contents -->

    </div>
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
