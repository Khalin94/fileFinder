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
		}
	} catch(AppException e) {
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  		objMsgBean.setStrCode(e.getStrErrCode());
  		objMsgBean.setStrMsg(e.getMessage());
  		out.println("<br>Error!!!" + e.getMessage());
	  	return;
 	}
%>
 
 <html>
<head>
<title><%=MenuConstants.REQUEST_BOX_GENERAL%> > <%=MenuConstants.REQ_BOX_MAKE%></title>
<link href="/css/System.css" rel="stylesheet" type="text/css">

<script language="javascript">
<!--
// 어처구니 없는 함수임에 분명하다.
// 당장에는 별다른 대책이 없어서 우선 이렇게 둔다.
// 보다 획기적인 개선안이 하루빨리 떠오르길 바라며... -ㅅ-
function changeInputForm(value) {
	var str = "";
	if (value == "<%= CodeConstants.ANS_MTD_ELEC %>") { // 전자파일의 경우
		str = "";
		str = str + "<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"680\">\n";
		str = str + "<tr>\n";
		str = str + "<td width=\"149\" height=\"25\" class=\"td_gray1\"><img src='/image/common/icon_nemo_gray.gif'> 원본 파일 </td>\n";
		str = str + "<td width=\"531\" height=\"25\" class=\"td_lmagin\"><input type=\"file\" class=\"textfield\" name=\"originFile\" size=\"60\"></td></tr>\n";
		str = str + "<tr height=\"1\" class=\"tbl-line\"><td height=\"1\"></td><td height=\"1\"></td></tr>\n";
		str = str + "<tr>\n";
		str = str + "<td width=\"149\" height=\"25\" class=\"td_gray1\"><img src='/image/common/icon_nemo_gray.gif'> PDF 파일 </td>\n";
		str = str + "<td width=\"531\" height=\"25\" class=\"td_lmagin\"><input type=\"file\" class=\"textfield\" name=\"pdfFile\" size=\"60\"></td></tr>\n";
		str = str + "<tr height=\"1\" class=\"tbl-line\"><td height=\"1\"></td><td height=\"1\"></td></tr>\n";
		str = str + "</table>\n";
		str = str + "<input type=hidden name=matType value=''>\n";
		str = str + "<input type=hidden name=sendWay value=''>\n";
		
		document.all.inputDiv.innerHTML = str;

	} else if (value == "<%= CodeConstants.ANS_MTD_ETCS%>") { // 비전자파일의 경우
	
		str = "";
		str = str + "<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width='680'>\n";
		str = str + "<tr>\n";
		str = str + "<td width=\"149\" height=\"25\" class=\"td_gray1\"><img src='/image/common/icon_nemo_gray.gif'> 매체유형</td>\n";
		str = str + "<td width=\"531\" class=\"td_lmagin\"><select name=\"matType\" class='select'><option value=''>::: 선택해 주세요 :::</option>";
		<%
			List matList = (List)objCdinfo.getNotElecMediumList();
			if (matList.size() == 0) {
				out.println("str = str + \"<option value=''>등록된 매체가 없습니다.</option>\";");	
			} else {
				for(int i=0; i<matList.size(); i++) {
					Hashtable hash = (Hashtable)matList.get(i);
					String code = (String)hash.get("MSORT_CD");
					String codeValue = (String)hash.get("CD_NM");
					out.println("str = str + \"<option value='"+code+"'>"+codeValue+"</option>\";");	
				}
			}
		%>
		str = str + "</select>\n";
		str = str + "</td>\n";
		str = str + "</tr>\n";
		str = str + "<tr height=\"1\" class=\"tbl-line\"><td height=\"1\"></td><td height=\"1\"></td></tr>\n";
		str = str + "<tr>\n";
		str = str + "<td width='149' height=\"25\" class=\"td_gray1\"><img src='/image/common/icon_nemo_gray.gif'> 발송 방법</td>\n";
		str = str + "<td class=\"td_lmagin\" width='531'><select name=\"sendWay\" class='select'><option value=''>::: 선택해 주세요 :::</option>";
		<%
			List swList = (List)objCdinfo.getSendWayList();
			if (swList.size() == 0) {
				out.println("str = str + \"<option value=''>등록된 발송방법이 없습니다.</option>\";");	
			} else {
				for(int i=0; i<swList.size(); i++) {
					Hashtable hash = (Hashtable)swList.get(i);
					String code = (String)hash.get("MSORT_CD");
					String codeValue = (String)hash.get("CD_NM");
					out.println("str = str + \"<option value='"+code+"'>"+codeValue+"</option>\";");	
				}
			}
		%>
		str = str + "</tr>\n";
		str = str + "<tr height=\"1\" class=\"tbl-line\"><td height=\"1\"></td><td height=\"1\"></td></tr>\n";
		str = str + "</table>\n";
		str = str + "<input type=hidden name=originFile value=''>\n";
		str = str + "<input type=hidden name=pdfFile value=''>\n";
		
		document.all.inputDiv.innerHTML = str;
	} else { // 해당 기관 아님의 경우
		str = "";
		str = str + "<input type=hidden name=matType value=''>\n";
		str = str + "<input type=hidden name=sendWay value=''>\n";
		str = str + "<input type=hidden name=originFile value=''>\n";
		str = str + "<input type=hidden name=sendWay value=''>\n";
		document.all.inputDiv.innerHTML = str;
	}
}

// 답변 유형에 따라서 입력 폼이 달라지므로 유형별 필수입력값에 대한 강요를 하자.. 넣어주시어요~
function checkSubmit() {
	var f = document.inputForm;
	var ansType = f.ansType.value;
	
	if (ansType == "<%= CodeConstants.ANS_MTD_ELEC %>") { // 전자파일인가요?
		if (f.originFile.value == "") {
			alert("원본 문서 파일을 선택해 주세요");
			f.originFile.focus();
			return;
		} else if (f.pdfFile.value == "") {
			alert("PDF 파일을 선택해 주세요");
			f.pdfFile.focus();
			return;
		} else if (f.ansOpinion.value == "") {
			alert("제출 의견을 입력해 주세요");
			f.ansOpinion.focus();
			return;
		}
		
		var pdfFileName = f.pdfFile.value;
		var orgFileName = f.originFile.value;
		
		var pdfDot = pdfFileName.lastIndexOf('.');
		var orgDot = orgFileName.lastIndexOf('.');
		
		var pdfExt = pdfFileName.substring(pdfDot+1);
		var orgExt = orgFileName.substring(orgDot+1);
		
		if (orgExt == "pdf" || orgExt== "PDF") {
			f.originFile.value == "";
			//orgFileName == pdfFileName;
		}
		
		if (pdfExt != "pdf" && pdfExt != "PDF") {
			alert("PDF 파일을 선택해 주세요");
			f.pdfFile.focus();
			return;
		}
		
	} else if (ansType == "<%= CodeConstants.ANS_MTD_ETCS%>") { // 비전자파일인가요?
		if (f.matType.value == "") {
			alert("매체유형을 선택해 주세요");
			f.matType.focus();
			return;
		} else if (f.sendWay.value == "") {
			alert("발송방법을 선택해 주세요");
			f.sendWay.focus();
			return;
		} else if (f.ansOpinion.value == "") {
			alert("제출의견을 입력해 주세요");
			f.ansOpinion.focus();
			return;
		}
	} else if (ansType == "<%= CodeConstants.ANS_MTD_NONE %>") { // 해당기관이 아닌가요?
		if (f.ansOpinion.value == "") {
			alert("제출의견을 입력해 주세요");
			f.ansOpinion.focus();
			return;
		}
	}
	
	f.action = "SMakeAnsInfoRegistProc.jsp";
	if (confirm("선택하신 답변 자료를 등록하시겠습니까?")) {
		//document.all.loadingDIV.style.display = '';
		f.submit();
	}	
} // end checkSubmit()

function gotoReqInfoView() {
	var f = document.inputForm;
	f.action = "SMakeReqInfoVList.jsp";
	f.submit();
}
//-->
</script>

</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<%@ include file="/reqsubmit/common/MenuTopReqsubmit.jsp" %>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr align="left" valign="top">
    <td width="186" height="470" background="/image/common/bg_leftMenu.gif">
	<%@ include file="/reqsubmit/common/MenuLeftReqsubmit.jsp" %></td>
<!------- 2004-06-02 디자인 수정으로 인해 변경된 부분 시작 ------->
<td width="100%"><table width="100%" border="0" cellspacing="0" cellpadding="0">
         <tr height="24" valign="top"> 
          <td height="24" colspan="2" align="left"><table width="789" height="24" border="0" cellpadding="0" cellspacing="0" bgcolor="DEEFCC">
              <tr>
                <td height="24"></td>
              </tr>
            </table></td>
        </tr>
<!------- 2004-06-02 디자인 수정으로 인해 변경된 부분 끝 ------->
        <tr valign="top"> 
          <td width="30" align="left"><img src="/image/common/bg_leftBody.gif" width="30" height="1"></td>
          <td align="left"><table width="759" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td height="23" align="left" valign="top"></td>
              </tr>
              <tr> 
                <td height="23" align="left" valign="top"><table width="100%" height="23" border="0" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="25%" background="/image/reqsubmit/bg_reqsubmit_tit.gif">
                      		<!-------------------- 타이틀을 입력해 주세요 ------------------------>
                      		<span class="title">작성 중 요구함</span> <strong>- 답변 제출</strong>
                      </td>
                      <td width="16%" align="left" background="/image/common/bg_titLine.gif">&nbsp;</td>
                      <td width="59%" align="right" background="/image/common/bg_titLine.gif" class="text_s">
                      		<!-------------------- 현재 위치 정보를 기술한답니다. ------------------------>
                      		<img src="/image/common/icon_navi.gif" width="3" height="5" align="absmiddle"> 
                        <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.REQUEST_BOX_GENERAL%> > <B><%=MenuConstants.REQ_BOX_MAKE%></B>
                      </td>
                    </tr>
                  </table></td>
              </tr>
              <tr> 
                <td height="30" align="left" class="text_s">
                		<!-------------------- 현재 페이지에 대한 설명 기술 ------------------------>
                		요구 기관의 요구에 대한 답변을 제출하실 수 있습니다.
                </td>
              </tr>
              <tr> 
                <td height="5" align="left" class="soti_reqsubmit"></td>
              </tr>
              <tr> 
                <td height="30" align="left" class="soti_reqsubmit">
                	<!-------------------- TAB 에 해당하는 제목을 기술하는 곳이지요. ------------------------>
                	<img src="/image/reqsubmit/icon_reqsubmit_soti.gif" width="9" height="9" align="absmiddle"> 
                  요구 정보
                </td>
              </tr>
              <tr> 
                <td align="left" valign="top" class="soti_reqsubmit">

                <!------------------------- TAB에 해당하는 테이블(목록이든 등록폼이든 상세정보든) 출력 시~~~작 ------------------------->
					<table width="680" border="0" cellspacing="0" cellpadding="0">
                    	<tr class="td_reqsubmit"> 
                      		<td width="149" height="2"></td>
                      		<td height="2" colspan="3"></td>
                    	</tr>
                    	<tr> 
                      		<td height="25" class="td_gray1">
                      			<img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 요구함명
                      		</td>
                      		<td height="25" colspan="3" class="td_lmagin"><%= objRsSH.getObject("REQ_BOX_NM") %></td>
                    	</tr>
                    	<tr height="1" class="tbl-line"> 
                      		<td height="1"></td>
                      		<td height="1" colspan="3"></td>
                    	</tr>
                    	<tr> 
                      		<td height="25" class="td_gray1">
                      			<img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 요구 제목
                      		</td>
                      		<td height="25" colspan="3" class="td_lmagin"><%= objRsSH.getObject("REQ_CONT") %></td>
                    	</tr>
                    	<tr height="1" class="tbl-line"> 
                      		<td height="1"></td>
                      		<td height="1" colspan="3"></td>
                    	</tr>
                    	<tr> 
                      		<td height="25" class="td_gray1">
                      			<img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 요구 내용
                      		</td>
                      		<td height="25" colspan="3" class="td_lmagin"><%= objRsSH.getObject("REQ_DTL_CONT") %></td>
                    	</tr>
                    	<tr height="1" class="tbl-line"> 
                      		<td height="1"></td>
                      		<td height="1" colspan="3"></td>
                    	</tr>
                    	<tr> 
                      		<td height="25" class="td_gray1">
                      			<img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 최종요구일자
                      		</td>
                      		<td width="181" height="25" class="td_lmagin"><%= StringUtil.getDate((String)objRsSH.getObject("LAST_ANS_DT")) %></td>
                      		<td width="108" height="25" class="td_gray1">
                      			<img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 요구기관
                      		</td>
                      		<td width="242" class="td_lmagin"><%= objRsSH.getObject("REQ_ORGAN_NM") %></td>
                    	</tr>
                    	<tr height="1" class="tbl-line"> 
                      		<td height="1"></td>
                      		<td height="1" colspan="3"></td>
                    	</tr>
                    	<tr> 
                      		<td height="25" class="td_gray1">
                      			<img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 공개등급
                      		</td>
                      		<td width="181" height="25" class="td_lmagin"><%= CodeConstants.getOpenClass((String)objRsSH.getObject("OPEN_CL")) %></td>
                      		<td width="108" height="25" class="td_gray1">
                      			<img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 제출양식파일
                      		</td>
                      		<td width="242" class="td_lmagin">
                      			<%= StringUtil.makeAttachedFileLink((String)objRsSH.getObject("ANS_ESTYLE_FILE_PATH"), (String)objRsSH.getObject("REQ_ID")) %>
                      		</td>
                    	</tr>
                    	<tr height="1" class="tbl-line"> 
                      		<td height="1"></td>
                      		<td height="1" colspan="3"></td>
                    	</tr>
                    	<tr height="1" class="tbl-line"> 
                      		<td height="1"></td>
                      		<td height="1" colspan="3"></td>
                    	</tr>
                    	
                    </table>
				<!------------------------- TAB에 해당하는 테이블(목록이든 등록폼이든 상세정보든) 출력 끝 ------------------------->
               </td>
              </tr>
              <tr>
                <td height="40" align="left" class="soti_reqsubmit">
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td height="40" align="left">&nbsp;<input type="button" value="요구 상세 보기" onClick="javascript:gotoReqInfoView()">
                        <div align="right"></div></td>
                    </tr>
               </table>
               </td>
              </tr>
            	<!------------------------- 또 TAB을 두고 싶으시면 위의 소스들을 복사해서 이 곳에 붙여넣기 해서 수정하세요 ------------------------->
            	<!----- [주의] TAB <tr> 과 그 밑에 내용을 구성하는 <tr>을 잘 구분해서 잘 챙겨 주시어요. 나으리.. -------->
            	<tr> 
                <td height="30" align="left" class="soti_reqsubmit">
                	<!-------------------- TAB 에 해당하는 제목을 기술하는 곳이지요. ------------------------>
                	<img src="/image/reqsubmit/icon_reqsubmit_soti.gif" width="9" height="9" align="absmiddle"> 
                  답변 제출</td>
              </tr>
              <tr> 
                <td height="203" align="left" valign="top" class="soti_reqsubmit">
                <!------------------------- 답변 제출 정보 입력 폼 시작 ------------------------->
<form name="inputForm" method="post" action="" enctype="multipart/form-data" style="margin:0px">

				<input type="hidden" name="ReqBoxID" value="<%= strReqBoxID %>">
				<input type="hidden" name="ReqID" value="<%= strReqID %>">
				<input type="hidden" name="ansrID" value="<%= objUserInfo.getUserID() %>">
				
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
				
				
				
			
                <table width="680" border="0" cellspacing="0" cellpadding="0">
                    <tr class="td_reqsubmit"> 
                      <td width="149" height="2"></td>
                      <td width="531" height="2"></td>
                    </tr>
                    <tr> 
                      <td width="149" height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        답변 유형</td>
                      <td width="531" height="25" class="td_lmagin"><select name="ansType" onChange="javascript:changeInputForm(this.value)" class="select">
								<option value="<%= CodeConstants.ANS_MTD_ELEC %>"><%= CodeConstants.getAnswerMethod(CodeConstants.ANS_MTD_ELEC) %></option>
								<option value="<%= CodeConstants.ANS_MTD_ETCS %>"><%= CodeConstants.getAnswerMethod(CodeConstants.ANS_MTD_ETCS) %></option>
								<option value="<%= CodeConstants.ANS_MTD_NONE %>"><%= CodeConstants.getAnswerMethod(CodeConstants.ANS_MTD_NONE) %></option>
							</select></td>
                    </tr>
                    <tr height="1" class="tbl-line"> 
                      <td height="1"></td>
                      <td height="1"></td>
                    </tr>
                    <tr> 
                      <td width="149" height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        공개 여부</td>
                      <td width="531" height="25" class="td_lmagin"><input type="radio" name="openCL" value="<%= CodeConstants.OPN_CL_OPEN %>" checked> <%= CodeConstants.getOpenClass(CodeConstants.OPN_CL_OPEN) %>
                      &nbsp;&nbsp;<input type="radio" name="openCL" value="<%= CodeConstants.OPN_CL_CLOSE %>"> <%= CodeConstants.getOpenClass(CodeConstants.OPN_CL_CLOSE) %></td>
                    </tr>
                    <tr height="1" class="tbl-line"> 
                      <td height="1"></td>
                      <td height="1"></td>
                    </tr>
                    </table>
            <DIV id="inputDiv" style="position:relative; left:0px;top:0px;width:700; z-index:1; border-width:0px; border-style:none;">
		            <table width="680" border="0" cellpadding="0" cellspacing="0">
            		<tr> 
                      <td width="149" height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        원본 파일</td>
                      <td width="531" height="25" class="td_lmagin"><input type="file" class="textfield" name="originFile" size="60"></td>
                    </tr>
                    <tr height="1" class="tbl-line"> 
                      <td height="1"></td>
                      <td height="1"></td>
                    </tr>
                    <tr> 
                      <td width="149" height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        PDF 파일</td>
                      <td width="531" height="25" class="td_lmagin"><input type="file" class="textfield" name="pdfFile" size="60"></td>
                    </tr>
                    <tr height="1" class="tbl-line"> 
                      <td height="1"></td>
                      <td height="1"></td>
                    </tr>
        		    </table>
            </DIV>
            		<table width="680" border="0" cellpadding="0" cellspacing="0">
            			<tr>
            				<td width="149"  height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 제출 의견</td>
            				<td width="531"  height="25" class="td_lmagin"><textarea name="ansOpinion" wrap="hard" class="textfield" style="WIDTH: 90% ; height: 80"></textarea></td>
            			</tr>
            			<tr height="1" class="tbl-line">
            				<td height="1"></td>
            				<td height="1"></td>
            			</tr>
            		</table>
					<p>
	               <table width="680" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td height="40" align="left">&nbsp;<img src="/image/button/bt_save.gif" border="0" onClick="javascript:checkSubmit()" style="cursor:hand"> </td>
                    </tr>
	               </table>
</form>
            		<p><br></p>
            		<p><br></p>
                <!------------------------- 답변 제출 정보 입력 폼 끝 ------------------------->
               	</td>
             </tr>
              
            </table></td>
        </tr>
        <tr>
        	<td height="35">&nbsp;</td>
        </tr>
      </table></td>
  </tr>
</table>
<%@ include file="/common/bottom.jsp" %>
</body>
</html>
