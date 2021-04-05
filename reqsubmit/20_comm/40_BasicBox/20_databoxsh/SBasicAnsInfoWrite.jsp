<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.lib.reqsubmit.params.requestinfo.SPreReqInfoVListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.prereqinfo.SPreReqInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.prereqbox.PreRequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.prereqbox.SPreReqBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.SMemReqInfoDelegate" %>
<%@ page import="kr.co.kcc.pf.ejb.EJBExtendException" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	UserInfoDelegate objUserInfo =null;
	CDInfoDelegate objCdinfo =null;
%>

<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>

<%
/**********************************************************************
 * 기본적으로 항상 각 페이지별로 해야하는 작업. 이용자 로그인 정보를 확인한다.
 * 즉, 세션이 생성되어져 있는지를 확인한다.
 * 그리고, 현재 화면을 구성하기 위해서 해당하는 요구의 간략 정보를 출력한다.
 * 해당 간략 정보를 출력하기 위해서 요구ID를 파라미터로 받아서 해당하는 함수를 호출한다.
 * 그 하단에는 요구의 답변을 등록하는 등록 폼을 생성한다.
 * 등록 폼은 답변 유형에 따라서 각기 다른 형태로 폼을 제공하여야 한다.
 * 답변 유형에 따라서 처리되는 프로세스의 내용도 고려되어야 하는 것을 잊지 말자!!
 * 멀티 파일 업로드 컴퍼넌트를 이용해서 답변을 등록하는 것! 폼의 타입을 잘 지정해 주자.
 * 자 그럼 열심히 (__)
 *
 **********************************************************************
 */

	PreRequestBoxDelegate reqDelegate = null;
	SPreReqInfoDelegate selfDelegate = null;
	SPreReqBoxDelegate selfDelegateBox =null; //요구함 권한 임시방편 -by yan
	SMemReqInfoDelegate objSReqInfo = null;

	SPreReqInfoVListForm objParams = new SPreReqInfoVListForm();

	boolean blnParamCheck=false;
	blnParamCheck = objParams.validateParams(request);
	if(blnParamCheck==false) {
  		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  		objMsgBean.setStrCode("DSPARAM-0000");
  		objMsgBean.setStrMsg(objParams.getStrErrors());
  		out.println("ParamError:" + objParams.getStrErrors());
	  	return;
  	}//endif

	// 넘어온 파라미터를 설정해서 필요할 떄 쓰도록 하자
	// 요구함 관련
	String strReqBoxID = objParams.getParamValue("ReqBoxID");
	String strReqID = objParams.getParamValue("ReqID");

	String strReqBoxSortField = StringUtil.getEmptyIfNull((String)objParams.getParamValue("ReqBoxSortField"));
	String strReqBoxSortMtd = StringUtil.getEmptyIfNull((String)objParams.getParamValue("ReqBoxSortMtd"));
	String strReqBoxPagNum = StringUtil.getEmptyIfNull((String)objParams.getParamValue("ReqBoxPage"));
	String strReqBoxQryField = StringUtil.getEmptyIfNull((String)objParams.getParamValue("ReqBoxQryField"));
	String strReqBoxQryTerm = StringUtil.getEmptyIfNull((String)objParams.getParamValue("ReqBoxQryTerm"));

	// 요구 목록 관련
	String strReqInfoSortField = objParams.getParamValue("ReqInfoSortField");
	String strReqInfoSortMtd = objParams.getParamValue("ReqInfoSortMtd");
	String strReqInfoQryField = objParams.getParamValue("ReqInfoQryField");
	String strReqInfoQryTerm = objParams.getParamValue("ReqInfoQryTerm");
	String strReqInfoPagNum = objParams.getParamValue("ReqInfoPage");

	// 2004-06-04 이용자 인증서 USER DN
	String strUserDN = null;

	// 2004-05-04 추가된 파라미터 : 폼을 수정하기 힘들어서 그냥 이렇게 쓴다. -ㅅ-
	String strReturnURL = StringUtil.getEmptyIfNull(request.getParameter("ReturnURL"));

	// 2004-05-08 추가된 파라미터 : 추가답변여부
	String strAddAnsFlag = StringUtil.getEmptyIfNull(request.getParameter("AddAnsFlag"), "N");

	if ("".equalsIgnoreCase(StringUtil.getEmptyIfNull(strReqID))) { // 요구ID가 NULL이면 안된다. 절대로~~
		throw new EJBExtendException("요구 ID가 없음 안돼유~~~");
	}

	if ("".equalsIgnoreCase(StringUtil.getEmptyIfNull(strReqBoxID))) { // 요구함 ID가 NULL이면 안된다. 절대로~~
		throw new EJBExtendException("요구함 ID가 없음 안돼유~~~");
	}

	ResultSetSingleHelper objRsSH = null;

	try{
	   	reqDelegate = new PreRequestBoxDelegate();
	   	selfDelegate = new SPreReqInfoDelegate();
	   	selfDelegateBox = new SPreReqBoxDelegate();
		objSReqInfo = new SMemReqInfoDelegate();

	   	//boolean blnHashAuth = selfDelegateBox.checkReqBoxAuth(strReqBoxID, objUserInfo.getOrganID()).booleanValue();
	   	boolean blnHashAuth = reqDelegate.checkReqBoxAuth(strReqBoxID, objUserInfo.getOrganID()).booleanValue();

	   	if(!blnHashAuth) {
	   		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	  		objMsgBean.setStrCode("DSAUTH-0001");
  	  		objMsgBean.setStrMsg("해당 요구함을 볼 권한이 없습니다.");
  	  		out.println("해당 요구함을 볼 권한이 없습니다.");
		    return;
		} else {
	    	// 요구 등록 정보를 SELECT 한다.
	    	objRsSH = new ResultSetSingleHelper(selfDelegate.getRecord(strReqID));

			// 2004-06-04 이용자의 인증서 USER DN 값을 가져와서 세팅한다.
	    	//strUserDN = objSReqInfo.getUserDN(objUserInfo.getUserID());
	    	HttpSession objPrivateSession = request.getSession();
			strUserDN = StringUtil.getEmptyIfNull((String)objPrivateSession.getAttribute("UserDN"));
		}
	} catch(AppException e) {
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  		objMsgBean.setStrCode(e.getStrErrCode());
  		objMsgBean.setStrMsg(e.getMessage());
  		out.println("<br>Error!!!" + e.getMessage());
	  	return;
 	}
%>
<jsp:include page="/inc/header.jsp" flush="true"/>
<link href="/css/System.css" rel="stylesheet" type="text/css">
<script src="/js/reqsubmit/common.js"></script>
<script language="javascript">
<!--
// 어처구니 없는 함수임에 분명하다.
// 당장에는 별다른 대책이 없어서 우선 이렇게 둔다.
// 보다 획기적인 개선안이 하루빨리 떠오르길 바라며... -ㅅ-
function changeInputForm(value) {
	var str = "";
	if (value == "<%= CodeConstants.ANS_MTD_ELEC %>") { // 전자파일의 경우
        document.getElementById("inputDiv1").style.display = "block";
        document.getElementById("inputDiv2").style.display = "block";
        document.getElementById("inputDiv3").style.display = "none";
        document.getElementById("inputDiv4").style.display = "none";
	} else if (value == "<%= CodeConstants.ANS_MTD_ETCS%>") { // 비전자파일의 경우
        document.getElementById("inputDiv1").style.display = "none";
        document.getElementById("inputDiv2").style.display = "none";
        document.getElementById("inputDiv3").style.display = "block";
        document.getElementById("inputDiv4").style.display = "block";
	} else { // 해당 기관 아님의 경우
        document.getElementById("inputDiv1").style.display = "none";
        document.getElementById("inputDiv2").style.display = "none";
        document.getElementById("inputDiv3").style.display = "none";
        document.getElementById("inputDiv4").style.display = "none";
	}
}

// 답변 유형에 따라서 입력 폼이 달라지므로 유형별 필수입력값에 대한 강요를 하자.. 넣어주시어요~

function checkSubmit() {
	var f = document.inputForm;
	var ansType = f.AnsType.value;

	if (ansType == "<%= CodeConstants.ANS_MTD_ELEC %>") { // 전자파일인가요?
		if (f.OriginFile.value == "") {
			alert("원본 문서 파일을 선택해 주세요");
			f.OriginFile.focus();
			return;
		} else if (f.PdfFile.value == "") {
			alert("PDF 파일을 선택해 주세요");
			f.PdfFile.focus();
			return;
		} else if (f.AnsOpin.value == "") {
			f.AnsOpin.value = "제출 의견 없음";
		}

		var pdfFileName = f.PdfFile.value;
		var orgFileName = f.OriginFile.value;

		var pdfDot = pdfFileName.lastIndexOf('.');
		var orgDot = orgFileName.lastIndexOf('.');

		var pdfExt = pdfFileName.substring(pdfDot+1);
		var orgExt = orgFileName.substring(orgDot+1);

		if (orgExt.toUpperCase() != "PDF") {
			f.OriginFile.value == "";
			//orgFileName == pdfFileName;
		}

		if (pdfExt.toUpperCase() != "PDF") {
			alert("PDF 파일을 선택해 주세요");
			f.PdfFile.focus();
			return;
		}

	} else if (ansType == "<%= CodeConstants.ANS_MTD_ETCS%>") { // 비전자파일인가요?
		if (f.MatType.value == "") {
			alert("매체유형을 선택해 주세요");
			f.MatType.focus();
			return;
		} else if (f.SendWay.value == "") {
			alert("발송방법을 선택해 주세요");
			f.SendWay.focus();
			return;
		} else if (f.AnsOpin.value == "") {
			f.AnsOpin.value = "제출 의견 없음";
		}
	} else if (ansType == "<%= CodeConstants.ANS_MTD_NONE %>") { // 해당기관이 아닌가요?
		if (f.AnsOpin.value == "") {
			f.AnsOpin.value = "제출 의견 없음";
		}
	}

	if (getByteLength(f.AnsOpin.value) > 500) {
		alert("한글, 영문을 포함 500자 이내로 입력해 주세요. 단, 한글은 2자로 처리됩니다.");
		f.AnsOpin.focus();
		return;
	}

	if (confirm("입력하신 답변 자료를 등록하시겠습니까?")) {
		if (ansType == "<%= CodeConstants.ANS_MTD_ELEC %>") {
			f.action = "/reqsubmit/common/SAnsInfoWriteProcPopup.jsp";
			f.target="hiddenPop";
			document.returnSubmitForm.AnsOpin.value = f.AnsOpin.value;
			NewWindow2('/blank.html', 'hiddenPop', '320', '240', 'OUT');
			document.all.loadingDiv.style.display = '';
			f.submit();
		} else {
			var f2 = document.returnSubmitForm;
			f2.PdfFile.value = f.PdfFile.value;
			f2.OriginFile.value = f.OriginFile.value;
			f2.PdfFilePath.value = f.PdfFile.value;
			f2.DocFilePath.value = f.OriginFile.value;
			f2.MatType.value = f.MatType.value;
			f2.SendWay.value = f.SendWay.value;
			f2.AnsOpin.value = f.AnsOpin.value;
			f2.AnsType.value = f.AnsType.value;
			f2.OpenCL.value = f.OpenCL.value;
			f2.action = "/reqsubmit/common/SAnsInfoWriteProc.jsp";
			document.all.loadingDiv.style.display = '';
			f2.submit();
		}
	}

} // end checkSubmit()



function gotoReqInfoView() {
	var f = document.inputForm;
	f.action = "<%= strReturnURL.substring(0, StringUtil.getLastIndex(strReturnURL, "?")) %>";
	f.target = "";
	f.submit();
}
//-->
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
      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <%
            if ("Y".equalsIgnoreCase(strAddAnsFlag)) out.println("<h3>추가 답변 작성</h3>");
            else out.println("<h3>"+MenuConstants.REQ_BOX_PRE+"<span class='sub_stl'>- 답변 작성</span></h3>");
        %>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.REQUEST_BOX_COMM%> > <%=MenuConstants.REQUEST_BOX_PRE%> >
        <%
							if ("Y".equalsIgnoreCase(strAddAnsFlag)) out.println("추가 답변 작성");
							else out.println("답변 작성");
						    %>
        </div>
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
            <tr>
                <th height="25">&bull;&nbsp; 요구함명</th>
                <td height="25" colspan="3"><%= objRsSH.getObject("REQ_BOX_NM") %></td>
            </tr>
            <tr>
                <th height="25">&bull;&nbsp; 요구제목</th>
                <td height="25" colspan="3"><%= StringUtil.getDescString((String)objRsSH.getObject("REQ_CONT")) %></td>
            </tr>
            <tr>
                <th height="25">&bull;&nbsp; 요구내용</th>
                <td height="25" colspan="3"><%= StringUtil.getDescString((String)objRsSH.getObject("REQ_DTL_CONT")) %></td>
            </tr>
            <tr>
                <th height="25">&bull;&nbsp; 최종요구일자</th>
                <td width="191" height="25"><%= StringUtil.getDate((String)objRsSH.getObject("REG_DT")) %></td>
                <th height="25">&bull;&nbsp; 요구기관</th>
                <td width="191"><%= objRsSH.getObject("REQ_ORGAN_NM") %></td>
            </tr>
            <tr>
                <th height="25">&bull;&nbsp; 공개등급</th>
                <td width="181" height="25"><%= CodeConstants.getOpenClass((String)objRsSH.getObject("OPEN_CL")) %></td>
                <th height="25">&bull;&nbsp; 제출양식파일</th>
                <td width="242">
                    <%= StringUtil.makeAttachedFileLink((String)objRsSH.getObject("ANS_ESTYLE_FILE_PATH"), (String)objRsSH.getObject("REQ_ID")) %>
                </td>
            </tr>
        </table>
    <!------------------------- TAB에 해당하는 테이블(목록이든 등록폼이든 상세정보든) 출력 끝 ------------------------->
        <div id="btn_all"  class="t_right">
            <span class="list_bt"><a href="#" onClick="javascript:gotoReqInfoView()" >이전화면</a></span>
        </div>

    <!------------------------- 또 TAB을 두고 싶으시면 위의 소스들을 복사해서 이 곳에 붙여넣기 해서 수정하세요 ------------------------->
    <!----- [주의] TAB <tr> 과 그 밑에 내용을 구성하는 <tr>을 잘 구분해서 잘 챙겨 주시어요. 나으리.. -------->
    <span class="list02_tl">답변 제출 </span>
    <!------------------------- 답변 제출 정보 입력 폼 시작 ------------------------->
<form name="inputForm" method="post" enctype="multipart/form-data" style="margin:0px">
    <input type="hidden" name="ReqBoxID" value="<%= strReqBoxID %>">
    <input type="hidden" name="ReqID" value="<%= strReqID %>">
    <input type="hidden" name="RegrID" value="<%= objUserInfo.getUserID() %>">
    <input type="hidden" name="MsgDigest" value="">

    <input type="hidden" name="ReqBoxSortField" value="<%= strReqBoxSortField %>">
    <input type="hidden" name="ReqBoxSortMtd" value="<%= strReqBoxSortMtd %>">
    <input type="hidden" name="ReqBoxPagNum" value="<%= strReqBoxPagNum %>">
    <input type="hidden" name="ReqBoxQryField" value="<%= strReqBoxQryField %>">
    <input type="hidden" name="ReqBoxQryTerm" value="<%= strReqBoxQryTerm %>">

    <input type="hidden" name="ReqInfoSortField" value="<%= strReqInfoSortField %>">
    <input type="hidden" name="ReqInfoSortMtd" value="<%= strReqInfoSortMtd %>">
    <input type="hidden" name="ReqInfoQryField" value="<%= strReqInfoQryField %>">
    <input type="hidden" name="ReqInfoQryTerm" value="<%= strReqInfoQryTerm %>">
    <input type="hidden" name="ReqInfoPagNum" value="<%= strReqInfoPagNum %>">
    <input type="hidden" name="ReturnURL" value="<%= strReturnURL %>">
    <% // 공개 등급 : 원래는 선택이었으나 답변은 모두 공개로 하기로 했으므로 고정 처리 %>
    <input type="hidden" name="OpenCL" value="<%= CodeConstants.OPN_CL_OPEN %>">
    <input type="hidden" name="AddAnsFlag" value="<%= strAddAnsFlag %>">
    <input type="hidden" name="UserDN" value="<%= strUserDN %>">

    <table border="0" cellspacing="0" cellpadding="0" class="list02">
        <tr>
          <th height="25">&bull;&nbsp; 답변 유형</td>
          <td height="25"><select name="AnsType" onChange="javascript:changeInputForm(this.value)" class="select">
                    <option value="<%= CodeConstants.ANS_MTD_ELEC %>"><%= CodeConstants.getAnswerMethod(CodeConstants.ANS_MTD_ELEC) %></option>
                    <option value="<%= CodeConstants.ANS_MTD_ETCS %>"><%= CodeConstants.getAnswerMethod(CodeConstants.ANS_MTD_ETCS) %></option>
                    <option value="<%= CodeConstants.ANS_MTD_NONE %>"><%= CodeConstants.getAnswerMethod(CodeConstants.ANS_MTD_NONE) %></option>
                </select></td>
        </tr>
        <tr id="inputDiv1" style="position:relative; left:0px;top:0px;width:700; z-index:1; border-width:0px; border-style:none;">
            <th height="25">&bull;&nbsp; 원본 파일</th>
            <td height="25"><input type="file" class="textfield" name="OriginFile" size="40"></td>
        </tr>
        <tr id="inputDiv2">
            <th height="25">&bull;&nbsp; PDF 파일</th>
            <td height="25"><input type="file" class="textfield" name="PdfFile" size="40"></td>
        </tr>
        <tr id="inputDiv3" style="display:none">
            <th height="25">&bull;&nbsp; 매체유형</th>
	    	<td width="560" class="td_lmagin">
                <select name="MatType" class='select'><option value=''>::: 선택해 주세요 :::</option>
                <%
                    List matList = (List)objCdinfo.getNotElecMediumList();
                    if (matList.size() == 0) {
                        out.println("<option value=''>등록된 매체가 없습니다.</option>");
                    } else {
                        for(int i=0; i<matList.size(); i++) {
                            Hashtable hash = (Hashtable)matList.get(i);
                            String code = (String)hash.get("MSORT_CD");
                            String codeValue = (String)hash.get("CD_NM");
                            out.println("<option value='"+code+"'>"+codeValue+"</option>");
                        }
                    }
                %>
                </select>
    		</td>
		</tr>
		<tr id="inputDiv4" style="display:none">
    		<th height="25">&bull;&nbsp; 발송 방법</th>
	    	<td class="td_lmagin"><select name="SendWay" class='select'>
            <option value=''>::: 선택해 주세요 :::</option>
            <%
                List swList = (List)objCdinfo.getSendWayList();
                if (swList.size() == 0) {
                    out.println("<option value=''>등록된 발송방법이 없습니다.</option>");
                } else {
                    for(int i=0; i<swList.size(); i++) {
                        Hashtable hash = (Hashtable)swList.get(i);
                        String code = (String)hash.get("MSORT_CD");
                        String codeValue = (String)hash.get("CD_NM");
                        out.println("<option value='"+code+"'>"+codeValue+"</option>");
                    }
                }
            %>
        </tr>
        <tr>
            <th height="25">&bull;&nbsp; 제출 의견</th>
            <td width="560"  height="25" style="padding-top:5px;padding-bottom:5px"><textarea name="AnsOpin" wrap="hard" class="textfield" style="WIDTH: 90% ; height: 80"></textarea></td>
        </tr>
    </table>
    <p>
</form>
        <div id="btn_all"  class="t_right">
            <span class="list_bt"><a href="#" onClick="javascript:checkSubmit()" >저장</a></span>
            <span class="list_bt"><a href="#" onClick="javascript:document.inputForm.reset()" >취소</a></span>
        </div>
        <p><br></p>
        <p><br></p>
    <!------------------------- 답변 제출 정보 입력 폼 끝 ------------------------->
    </td>
 </tr>
 <tr>
    <td height="35">&nbsp;</td>
 </tr>
</table></td>
</tr>
</table></td>
</tr>
</table>

<!-- 전자문서 의 경우 Msg Digest를 생성하고 결과값을 받아서 String만 보내면 되고, 나머지는 그냥 String뿐이니깐... -->
<FORM method="post" style="margin:0px" name="returnSubmitForm">
	<input type="hidden" name="ReqBoxID" value="<%= strReqBoxID %>">
	<input type="hidden" name="ReqID" value="<%= strReqID %>">
	<input type="hidden" name="RegrID" value="<%= objUserInfo.getUserID() %>">
	<input type="hidden" name="MsgDigest" value="">
	<input type="hidden" name="ReturnURL" value="<%= strReturnURL %>">
	<input type="hidden" name="returnURL" value="<%= strReturnURL %>">

	<input type="hidden" name="ReqBoxSortField" value="<%= strReqBoxSortField %>">
	<input type="hidden" name="ReqBoxSortMtd" value="<%= strReqBoxSortMtd %>">
	<input type="hidden" name="ReqBoxPagNum" value="<%= strReqBoxPagNum %>">
	<input type="hidden" name="ReqBoxQryField" value="<%= strReqBoxQryField %>">
	<input type="hidden" name="ReqBoxQryTerm" value="<%= strReqBoxQryTerm %>">

	<input type="hidden" name="ReqInfoSortField" value="<%= strReqInfoSortField %>">
	<input type="hidden" name="ReqInfoSortMtd" value="<%= strReqInfoSortMtd %>">
	<input type="hidden" name="ReqInfoQryField" value="<%= strReqInfoQryField %>">
	<input type="hidden" name="ReqInfoQryTerm" value="<%= strReqInfoQryTerm %>">
	<input type="hidden" name="ReqInfoPagNum" value="<%= strReqInfoPagNum %>">

	<% // 공개 등급 : 원래는 선택이었으나 답변은 모두 공개로 하기로 했으므로 고정 처리 %>
	<input type="hidden" name="OpenCL" value="<%= CodeConstants.OPN_CL_OPEN %>">
	<input type="hidden" name="AddAnsFlag" value="<%= strAddAnsFlag %>">

	<input type="hidden" name="AnsType" value="">
	<input type="hidden" name="PdfFile" value="">
	<input type="hidden" name="OriginFile" value="">
	<input type="hidden" name="PdfFilePath" value="">
	<input type="hidden" name="DocFilePath" value="">
	<input type="hidden" name="MatType" value="">
	<input type="hidden" name="SendWay" value="">
	<input type="hidden" name="AnsOpin" value="">
	<input type="hidden" name="PdfFileName" value="">
	<input type="hidden" name="OriginFileName" value="">
	<input type="hidden" name="AnsFileID" value="">

	<input type="hidden" name="user_dn" value="<%= strUserDN %>">
	<input type="hidden" name="UserDN" value="<%= strUserDN %>">

</FORM>

<DIV ID="loadingDiv" style="width:220;height:180;display:none;position:absolute;left:450;top:500">
	<img src="/image/reqsubmit/loading.gif" border="0"> </td>
</DIV>

</body>
</html>