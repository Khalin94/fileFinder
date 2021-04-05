<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	/******************************************************************************
		* Name		  : RNewBoxMake.jsp
		* Summary	  : 신규 요구함 등록.
		* Description : 요구함 등록 화면 제공.
	******************************************************************************/
%>
<%
 UserInfoDelegate objUserInfo =null;
 CDInfoDelegate objCdinfo =null;
%>
<%@ include file="../../common/RUserCodeInfoInc.jsp" %>
<%
	// 2004-07-08
	// 예산정책처 관리를 위해서 기관구분 코드를 설정한다.
	String strOrgGbnCode = objUserInfo.getOrganGBNCode();
	
	/** 편의 제공용 SELECT Box Param */ 
	String strCmtOrganID = StringUtil.getEmptyIfNull((String)request.getParameter("CmtOrganID"));/**위원회 목록 */
 	String strRltdDuty = StringUtil.getEmptyIfNull((String)request.getParameter("RltdDutyX"));/** 업무구분 */
 	String strNatCnt = StringUtil.getEmptyIfNull((String)request.getParameter("NatCnt"));	/** 회수 */
 	String strSubmtDln = StringUtil.getEmptyIfNull((String)request.getParameter("SubmtDln"));/** 제출기관 */
 	String strReqBoxDsc = StringUtil.getEmptyIfNull((String)request.getParameter("ReqBoxDsc"));/** 요구함설명 */
 
	/**업무구분가 선택된것이 없으면 기본적인 선택이 되게함. 현재는 국정감사코드.*/
 	if(strRltdDuty.equals("")){
 		strRltdDuty=CDInfoDelegate.SELECTED_RLTD_DUTY;
	}
 	String strSubmtOrganID=StringUtil.getEmptyIfNull((String)request.getParameter("SubmtOrganIDX"));/** 제출기관ID */
%>
<%

 /******** 데이터 담을 컨테이너 설정 *********/
 ResultSetHelper objCmtRs=null;        /** 소속 위원회 리스트 출력용 RsHelper */
 ResultSetHelper objSubmtOrganRs=null; /** 제출기관 리스트 출력용 RsHelper */
 ResultSetHelper objRltdDutyRs=null;   /** 관련업무 리스트 출력용 RsHelper */
 try{
   /********* 대리자 정보 설정 *********/
   OrganInfoDelegate objOrganInfo=new OrganInfoDelegate();   /** 기관정보 출력용 대리자 */
   if(strCmtOrganID.equals("")){
	   /********* 값가져오기 **************/
	   objCmtRs=new ResultSetHelper(objUserInfo.getCurrentCMTList());   /** 소속 위원회 */
	   if(objCmtRs.next()){
	   	strCmtOrganID=(String)objCmtRs.getObject("ORGAN_ID");
	   }
   }
   
   objCmtRs=new ResultSetHelper(objOrganInfo.getCmtOrganList());   /** 전체 위원회 */
   
   // 2004-07-08 사무처, 예정처의 GbnCode에 따라서 전체 제출기관 목록을 가져와야 하므로
   //objSubmtOrganRs = new ResultSetHelper(objOrganInfo.getSubmtOrganList(strCmtOrganID));/**제출기관리스트*/
   String strTmpOrgGbnCode = strOrgGbnCode;
   if (CodeConstants.ORGAN_GBN_MEM.equalsIgnoreCase(strOrgGbnCode)) strTmpOrgGbnCode = CodeConstants.ORGAN_GBN_CMT;
   objSubmtOrganRs = new ResultSetHelper(objOrganInfo.getSubmtOrganList(strCmtOrganID, strTmpOrgGbnCode)); // 제출기관리스트*/
   
   objRltdDutyRs=new ResultSetHelper(objCdinfo.getRelatedDutyList());
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

<!DOCTYPE HTML PUBLIC "-//w3c//dtd html 4.0 transitional//en">
<html>
<head>
<title><%=MenuConstants.getReqBoxGeneral(request)%> > <%=MenuConstants.REQ_BOX_WRITE%> <% //nads.lib.reqsubmit.EnvConstants.UNIX_TEMP_SAVE_PATH%></title>
<link href="/css/System.css" rel="stylesheet" type="text/css">
<script language=Javascript src="/js/reqsubmit/common.js"></script>
<script language=Javascript src="/js/nads_lib.js"></script>
<script language=Javascript src="/js/datepicker.js"></script>
<script language="JavaScript">
  /** 제출기관리스트 출력. */
  function changeSubmtOrganList(){
    
  	formName.action="<%=request.getRequestURI()%>";
  	formName.submit();
  }
  
  /** 폼데이터 체크 */
  function checkFormData() {
	var alertStr = "";
  	if(formName.CmtOrganID.value == "") {
		alertStr = "- 위원회\n"
  	}
  	if(formName.SubmtOrganID.value == "") {
		alertStr = alertStr + "- 제출기관\n";
  	}  
	if(formName.elements['NatCnt'].value==""){
		alertStr = alertStr + "- 회기\n";
	}
	if(formName.elements['SubmtDln'].value==""){
		alertStr = alertStr + "- 제출기한\n";
	}

	if (alertStr.length != 0) {
		alertStr = "[아래의 항목의 입력이 누락되었습니다. 확인바랍니다]\n\n" + alertStr;
		alert(alertStr);
		return;
	}

	if(formName.elements['ReqBoxDsc'].value.length>250){
		alert("요구함설명은 250글자 이내로 작성해주세요!!");
		formName.elements['ReqBoxDsc'].focus();
		return false;		
	}
	if(formName.elements['SubmtDln'].value<="<%=StringUtil.getSysDate()%>"){
		alert("제출기한은 오늘(<%=StringUtil.getSysDate()%>)이후의 날짜를 선택하셔야합니다");
		formName.elements['SubmtDln'].focus();
		return false;
	}
	
	formName.action="./RNewBoxMakeProc.jsp";
	formName.submit();
  }//endfunc
  
  /** 제출기관 조회 팝업 */
  function popupSearchSubmitOrgan(){
    var varWidth=320;
    var varHeight=250;
    var winl = (screen.width - varWidth) / 2;
	var wint = (screen.height - varHeight) / 2;
  	window.open("/reqsubmit/common/SearchSubmtOrganList.jsp",'','width=' + varWidth + ',height=' + varHeight + ',top='+wint+',left='+winl+',scrollbars=yes, resizable=no, toolbar=no, menubar=no, location=no, directories=no, status=yes');
  }
  
  // 2004-07-16
  // FORM RESET
  function formReset() {
  	document.formName.NatCnt.value = "";
  	document.formName.SubmtDln.value = "";
  	document.formName.ReqBoxDsc.value = "";
  }
  
   // 2004-07-19
  function gotoReqBoxList() {
  	var str1 = document.formName.NatCnt.value;
  	var str2 = document.formName.SubmtDln.value;
  	var str3 = document.formName.SubmtOrganID.value;
	
	if (str1.length != 0 && str2.length != 0 && str3.length != 0) {
  		if (confirm("입력하신 요구함을 생성하시겠습니까?\n취소하실 경우 취소를 선택해 주세요")) {
  			checkFormData();
  		} else {
  			location.href='/reqsubmit/10_mem/20_reqboxsh/10_make/RMakeReqBoxList.jsp';
  		}
  	} else {
		location.href='/reqsubmit/10_mem/20_reqboxsh/10_make/RMakeReqBoxList.jsp';
	}
  }
</script>
<head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="formName.NatCnt.focus()">
<%@ include file="../../common/MenuTopReqsubmit.jsp" %>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr align="left" valign="top">
    <td width="186" height="470" background="/image/common/bg_leftMenu.gif">
	<%@ include file="../../common/MenuLeftReqsubmit.jsp" %></td>
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
          <form name="formName" method="post" action="<%=request.getRequestURI()%>"><!--요구함 신규정보 전달 -->
              <input type="hidden" name="SubmtOrganIDX" value="">
              <tr> 
                <td height="23" align="left" valign="top"></td>
              </tr>
              <tr> 
                <td height="23" align="left" valign="top"><table width="100%" height="23" border="0" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="25%" background="/image/reqsubmit/bg_reqsubmit_tit.gif">
                      		<!-------------------- 타이틀을 입력해 주세요 ------------------------>
                      		<span class="title"><%=MenuConstants.REQ_BOX_WRITE%></span>
                      </td>
                      <td width="16%" align="left" background="/image/common/bg_titLine.gif">&nbsp;</td>
                      <td width="59%" align="right" background="/image/common/bg_titLine.gif" class="text_s">
                      		<!-------------------- 현재 위치 정보를 기술한답니다. ------------------------>
                      		<img src="/image/common/icon_navi.gif" width="3" height="5" align="absmiddle"> 
                        <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.getReqBoxGeneral(request)%> > <B><%=MenuConstants.REQ_BOX_WRITE%></B>
                      </td>
                    </tr>
                  </table></td>
              </tr>
              <tr> 
                <td height="30" align="left" class="text_s">
                		<!-------------------- 현재 페이지에 대한 설명 기술 ------------------------>
                		제출 기관에게 보낼 요구정보를 담을 요구함을  등록하는 화면입니다.  
                </td>
              </tr>
              <tr> 
                <td height="5" align="left" class="soti_reqsubmit"></td>
              </tr>
              <tr> 
                <td height="30" align="left" class="soti_reqsubmit">
                	<!-------------------- TAB 에 해당하는 제목을 기술하는 곳이지요. ------------------------>
                	<img src="/image/reqsubmit/icon_reqsubmit_soti.gif" width="9" height="9" align="absmiddle"> 
                  요구함 정보
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
					<%
						// 2004-07-08 사무처, 예산정책처 특별 관리를 위한 설정 시~작~
						if ((CodeConstants.ORGAN_GBN_ASM.equalsIgnoreCase(strOrgGbnCode)) || (CodeConstants.ORGAN_GBN_BUD.equalsIgnoreCase(strOrgGbnCode))) {
							out.println("<input type='hidden' name='CmtOrganID' value='"+objUserInfo.getOrganID()+"'>");
						} else {
					%>
                    <tr> 
                      <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        위원회 </td>
                      <td height="25" colspan="3" class="td_lmagin">
						<select name="CmtOrganID" onChange="changeSubmtOrganList()"  class="select">
							<option value="" selected>::: 선택해 주세요 :::</option>
						<%
						   /** 전체 위원회 리스트 출력 */
						   while(objCmtRs.next()){
						       String strOrganID=(String)objCmtRs.getObject("CMT_ORGAN_ID");
						   	   out.println("<option value=\"" + strOrganID + "\" " + StringUtil.getSelectedStr(strCmtOrganID,strOrganID) + ">" + objCmtRs.getObject("CMT_ORGAN_NM") + "</option>");
						   }//endwhile
						%>
						  <% //위원회설정되지 않은 기관들 보여줌. %>
						  <option value="<%=CodeConstants.NO_CMT_ORGAN_ID%>" <%=StringUtil.getSelectedStr(strCmtOrganID,CodeConstants.NO_CMT_ORGAN_ID)%>><%=CodeConstants.NO_CMT_ORGAN_NM%></option>
						</select>  
                      </td>
                    </tr>
                    <tr height="1" class="tbl-line"> 
                      <td height="1"></td>
                      <td height="1" colspan="3"></td>
                    </tr>
					<% } %>                    
                    <tr> 
                      <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        회기</td>
                      <td height="25" colspan="3" class="td_lmagin">
	                      제<input type="text" size="3" maxlength="3" name="NatCnt" class="textfield" onKeyUp="CheckNumeric(this);" value="<%=strNatCnt%>">회국회
                      </td>
                    </tr>
                    <tr height="1" class="tbl-line"> 
                      <td height="1"></td>
                      <td height="1" colspan="3"></td>
                    </tr>
                    <tr> 
                      <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        업무구분</td>
                      <td height="25" class="td_lmagin" width="191">
						<select name="RltdDutyX"  class="select">
						<%
						   /**업무구분 리스트 출력 */
						   while(objRltdDutyRs.next()){
						   		String strCode=(String)objRltdDutyRs.getObject("MSORT_CD");
						   		out.println("<option value=\"" + strCode + "\" " + StringUtil.getSelectedStr(strRltdDuty,strCode) + ">" + objRltdDutyRs.getObject("CD_NM") + "</option>");
						   }
						%>													
						</select>
                      </td>                      
                      <td height="25" width="149" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        제출기한</td>
                      <td height="25" width="191"  class="td_lmagin">
						<input type="text" class="textfield" name="SubmtDln" size="10" maxlength="8" value="<%=strSubmtDln%>"  OnClick="this.select()" OnKeyPress="if ((event.keyCode&lt;48)||(event.keyCode&gt;57)) event.returnValue=false;" OnBlur="javascript:SetFormatDate(this);">
						<input type="button" value="..." style="cursor:hand" OnClick="javascript:show_calendar('formName.SubmtDln');">
                      </td>
                    </tr>
                    <tr height="1" class="tbl-line"> 
                      <td height="1"></td>
                      <td height="1" colspan="3"></td>
                    </tr>
                    <tr> 
                      <td height="25" class="td_gray1" width="149">
							<img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                              <a href="javascript:popupSearchSubmitOrgan()">제출기관</a></td>
						<td height="25" colspan="3" class="td_lmagin"><table border="0" cellspacing="0" cellpadding="0"><tr><td>
							<select name="SubmtOrganID" class="select">		
								<%
									// 2004-07-08 사무처, 예산정책처 특별 관리를 위한 설정 시~작~
									if ((CodeConstants.ORGAN_GBN_ASM.equalsIgnoreCase(strOrgGbnCode)) || (CodeConstants.ORGAN_GBN_BUD.equalsIgnoreCase(strOrgGbnCode))) {
									} else {
							%>
								<option value="" selected>::: 위원회를 먼저 선택해 주세요 :::</option>
							<% } %>
						<%
						   /**제출기관 리스트 출력 */
						   while(objSubmtOrganRs.next()){
						   		String strSubmitOrganID=(String)objSubmtOrganRs.getObject("SUBMT_ORGAN_ID");
						   		String strSubmitOrganNM=(String)objSubmtOrganRs.getObject("SUBMT_ORGAN_NM");
						   		out.println("<option value=\"" + strSubmitOrganID + "\" " + StringUtil.getSelectedStr(strSubmtOrganID,strSubmitOrganID) + ">" + strSubmitOrganNM.trim() + "</option>");
						   }
						%>																							
								</select>
							<td>&nbsp;&nbsp;<img src="/image/button/bt_inquiry_small.gif" onClick="popupSearchSubmitOrgan()" style="cursor:hand"></td></tr></table>
						</td>
                    </tr>
                    <tr height="1" class="tbl-line"> 
                      <td height="1"></td>
                      <td height="1" colspan="3"></td>
                    </tr>
                    <tr> 
                      <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        요구함설명</td>
                      <td height="25" colspan="3" class="td_box">
                      	<textarea rows="3" cols="70" name="ReqBoxDsc"  class="textfield" style="WIDTH: 90%; height: 80" onKeyDown="javascript:updateChar2(document.formName, 'ReqBoxDsc', '250')" onKeyUp="javascript:updateChar2(document.formName, 'ReqBoxDsc', '250')" onfocus="javascript:updateChar2(document.formName, 'ReqBoxDsc', '250')"  onClick="javascript:updateChar2(document.formName, 'ReqBoxDsc', '250')"><%=strReqBoxDsc%></textarea><br>
						<table border="0">
						<tr><td width="30" align="right"><B><div id ="textlimit"> </div></B></td>
						<td width="570"> bytes (250 bytes 까지만 입력됩니다) </td></tr>
						</table>
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
               			<img src="/image/button/bt_cancel.gif"  height="20" border="0" onClick="javascript:formReset()" style="cursor:hand">
               			<img src="/image/button/bt_reqBoxList.gif" height="20" border="0" onClick="javascript:gotoReqBoxList()" style="cursor:hand">
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
<%@ include file="../../../common/Bottom.jsp" %>
</body>
</html>              
