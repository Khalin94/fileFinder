<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RMemReqBoxVListForm" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.MemRequestBoxDelegate" %>

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
	UserInfoDelegate objUserInfo =null;
	CDInfoDelegate objCdinfo =null;
%>
<%@ include file="../../../common/RUserCodeInfoInc.jsp" %>
<%
	/*************************************************************************************************/
	/** 					파라미터 체크 Part 														  */
	/*************************************************************************************************/

	/**일반 요구함 상세보기 파라미터 설정.*/
	RMemReqBoxVListForm objParams =new RMemReqBoxVListForm();
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
	MemRequestBoxDelegate objReqBox=null; 		/**요구함 Delegate*/
	ResultSetSingleHelper objRsSH=null;		/** 요구함 상세보기 정보 */
	try {
		/**요구함 정보 대리자 New */
		objReqBox=new MemRequestBoxDelegate();
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
		} else {
			/** 요구함 정보 */
			objRsSH=new ResultSetSingleHelper(objReqBox.getRecord((String)objParams.getParamValue("ReqBoxID")));
		}/**권한 endif*/
	} catch(AppException objAppEx) {
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

<html>
<head>
<title><%=MenuConstants.getReqBoxGeneral(request)%> > <%=MenuConstants.REQ_BOX_WRITE%> </title>
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
	if(formName.elements['ReqDtlCont'].value.length>2000){
		alert("요구 내용은 1000글자 이내로 작성해주세요!!");
		formName.elements['ReqDtlCont'].focus();
		return false;
	}

	/* 요구중복체크 */
	checkDupReqInfo(formName2);
  }//endfunc

  /** 요구함으로 가기 */
  function gotoList(){
    var str1 = document.formName.ReqCont.value;
    var str2 = document.formName.ReqDtlCont.value;

    if (str1.length != 0 && str2.length != 0) {
    	if (confirm("입력하신 요구 내용을 저장하시겠습니까?\n목록으로 이동하시려면 취소를 선택해 주세요")) {
    		document.formName.action="./RMakeReqInfoWriteProc.jsp";
    	} else {
    		document.formName.action="./RMakeReqBoxVList.jsp";
    	}
    } else {
    	document.formName.action="./RMakeReqBoxVList.jsp";
    }
    document.formName.submit();
  }


	/**
	 * 2005-09-13 kogaeng ADD
	 */
	function updateChar2() {
		var length_limit = 2000;
		var aaaElem = document.formName.ReqDtlCont;
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
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" >
<%@ include file="../../../common/MenuTopReqsubmit.jsp" %>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr align="left" valign="top">
    <td width="186" height="470" background="/image/common/bg_leftMenu.gif">
	<%@ include file="../../../common/MenuLeftReqsubmit.jsp" %></td>
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
          <td align="left">
          <table width="759" border="0" cellspacing="0" cellpadding="0">
          <%/*요구 중복체크용 힘든폼*/%>
<form name="formName2" method="post" action="">
             <input type="hidden" name="ReqBoxID">
             <input type="hidden" name="ReqCont">
             <input type="hidden" name="ReqDtlCont">
</form>
<form name="formName" method="post" encType="multipart/form-data" action="./RMakeReqInfoWriteProc.jsp"><!--요구 신규정보 전달 -->
            <!--요구정보 페이지 번호(페이징고려해서 우선 1페이지로) -->
            <% objParams.setParamValue("ReqInfoPage","1");%>
            <%=objParams.getHiddenFormTags()%>
              <tr>
                <td height="23" align="left" valign="top"></td>
              </tr>
              <tr>
			  <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
				<h3><%=MenuConstants.REQ_BOX_MAKE%><span class="sub_stl" >- <%=MenuConstants.REQ_INFO_WRITE%></span> </h3>
				<div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.getReqBoxGeneral(request)%> > <B><%=MenuConstants.REQ_BOX_MAKE%></B> </div>
				<p><!--문구--></p>
			  </div>
                <td height="5" align="left" class="soti_reqsubmit"></td>
              </tr>
              <span class="list02_tl">요구등록 </span>
              <tr>
                <td align="left" valign="top" class="soti_reqsubmit">
                <!------------------------- TAB에 해당하는 테이블(목록이든 등록폼이든 상세정보든) 출력 시~~~작 ------------------------->
                <table border="0" cellspacing="0" cellpadding="0" class="list02">
					<tr>
						<th height="25">&bull; 요구함명</th>
						<td height="25" colspan="3"><strong><%=objRsSH.getObject("REQ_BOX_NM")%></strong></td>
					</tr>
					<%
						// 2004-07-08 사무처, 예정처일 경우에는 위원회라는건 보이지마
						if (CodeConstants.ORGAN_GBN_ASM.equalsIgnoreCase(objUserInfo.getOrganGBNCode()) || CodeConstants.ORGAN_GBN_BUD.equalsIgnoreCase(objUserInfo.getOrganGBNCode())) {
						} else {
					%>
					<tr>
						<th height="25">&bull; 소관 위원회 </th>
						<td height="25" colspan="3"><%=objRsSH.getObject("CMT_ORGAN_NM")%></td>
					</tr>
                    <% } %>
					<tr>
						<th height="25" width="140">&bull; 업무구분</th>
						<td height="25" width="200"><%=objCdinfo.getRelatedDuty((String)objRsSH.getObject("RLTD_DUTY"))%> </td>
						<th height="25" width="140">&bull; 제출기관 </th>
						<td height="25" width="200"><%=(String)objRsSH.getObject("SUBMT_ORGAN_NM")%> </td>
					</tr>
					<tr>
						<th height="25">&bull; 요구제목</th>
						<td height="25" colspan="3">
							<input type="text" name="ReqCont" size="70" maxlength="1000" class="textfield">
							<br />
							<br />
							* 한글은 100자, 영문은 200자   까지만 입력 가능합니다. </td>
					</tr>
					<tr>
						<th height="25">&bull; 요구내용</th>
						<td height="25" colspan="3">
							<textarea onKeyDown="javascript:updateChar2()" onFocus="javascript:updateChar2()" onKeyUp="javascript:updateChar2()" onClick="javascript:updateChar2()" rows="5" cols="70" name="ReqDtlCont"></textarea>
							<br />
							<table border="0">
								<tbody>
									<tr>
										<td width="40" align="right"><strong>
											<div id="textlimit"></div>
										</strong></td>
										<td width="560">bytes (2000 bytes 까지만 입력됩니다) </td>
									</tr>
								</tbody>
							</table>
							<br />
							* 한글은 1000자, 영문은 2000자에 해당합니다. </td>
					</tr>
					<tr>
						<th height="25">&bull; 공개등급</th>
						<td height="25" colspan="3">
							<select name="OpenCL"  class="select">
							<%
								List objOpenClassList=CodeConstants.getOpenClassList();
								String strOpenClass=CodeConstants.OPN_CL_CLOSE;//비공개원칙.
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
						<th height="25">&bull; 제출양식파일</th>
						<td height="25" colspan="3"><input type="file" name="AnsEstyleFilePath" size="70"  class="textfield"></td>
					</tr>
                </table>
				<!------------------------- TAB에 해당하는 테이블(목록이든 등록폼이든 상세정보든) 출력 끝 ------------------------->
                </td>
              </tr>
              <tr>
               	<!-- 스페이스한칸 -->
               	<td>&nbsp;</td>
               	<!-- 스페이스한칸 -->
              </tr>
              <tr>
               	<td>
               	<!----------------------- 저장 취소등 Form관련 버튼 시작 ------------------------->
               	 <table>
               	   <tr>
               		 <td>
               			<img src="/image/button/bt_save.gif"  height="20" border="0" onClick="checkFormData()" style="cursor:hand">
               			<img src="/image/button/bt_cancel.gif"  height="20" border="0" onClick="formName.reset()" style="cursor:hand">
               			<img src="/image/button/bt_viewReqBox.gif"  height="20" border="0" onClick="gotoList()" style="cursor:hand">
               		 </td>
               	   </tr>
               	</table>
               	<!----------------------- 저장 취소등 Form관련 버튼 끝 ------------------------->
                </td>
              </tr>
          </form>
          </table>
          </td>
        </tr>
        <tr>
        	<td height="35">&nbsp;</td>
        </tr>
    </table>
    <!--------------------------------------- 여기까지  MAIN WORK AREA 실제 코딩의 끝입니다. ----------------------------->
    </td>
  </tr>
</table>
<%@ include file="../../../../common/Bottom.jsp" %>
</body>
</html>
