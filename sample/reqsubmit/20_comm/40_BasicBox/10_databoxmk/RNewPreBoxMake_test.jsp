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
* Name		  : RNewPreBoxMake.jsp
* Summary	  : 신규 요구함 등록.
* Description : 요구함 등록 화면 제공.
* 				※※ 체크 ※※
*				 아직 에러처리후 포워딩 페이지로 넘기지 않음.
******************************************************************************/
%>
<%
 UserInfoDelegate objUserInfo =null;
 CDInfoDelegate objCdinfo =null;
%>

<%@ include file="../../../common/RUserCodeInfoInc.jsp" %>
<%
 /** 편의 제공용 SELECT Box Param */ 
 String strCmtOrganID=StringUtil.getEmptyIfNull((String)request.getParameter("CmtOrganID"));/**위원회 목록 */
 String strRltdDuty=StringUtil.getEmptyIfNull((String)request.getParameter("RltdDuty"));/** 업무구분 */
 String strNatCnt=StringUtil.getEmptyIfNull((String)request.getParameter("NatCnt"));	/** 회수 */
 //업무구분가 선택된것이 없으면 기본적인 선택이 되게함. 현재는 국정감사코드.
 if(strRltdDuty.equals("")){
 	strRltdDuty=CDInfoDelegate.SELECTED_RLTD_DUTY;
 }
 String strSubmtOrganID=StringUtil.getEmptyIfNull((String)request.getParameter("SubmtOrganID"));/** 제출기관ID */
 
%>
<%

 /******** 데이터 담을 컨테이너 설정 *********/
 ResultSetHelper objCmtRs=null;        /** 소속 위원회 리스트 출력용 RsHelper */
 ResultSetHelper objSubmtOrganRs=null; /** 제출기관 리스트 출력용 RsHelper */
 ResultSetHelper objRltdDutyRs=null;   /** 관련기관 리스트 출력용 RsHelper */
 try{
   /********* 대리자 정보 설정 *********/
   OrganInfoDelegate objOrganInfo=new OrganInfoDelegate();   /** 기관정보 출력용 대리자 */
   
   /********* 값가져오기 **************/
   objCmtRs=new ResultSetHelper(objUserInfo.getCurrentCMTList());   /** 소속 위원회 */
   objSubmtOrganRs=new ResultSetHelper(objOrganInfo.getSubmtOrganList(objUserInfo.getOrganID()));/**제출기관리스트*/
   objRltdDutyRs=new ResultSetHelper(objCdinfo.getRelatedDutyList());
 }catch(AppException objAppEx){ 
 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  	objMsgBean.setStrCode(objAppEx.getStrErrCode());
  	objMsgBean.setStrMsg(objAppEx.getMessage());
  	//out.println("<br>Error!!!" + objAppEx.getMessage());
  	%>
  	<!--jsp:forward page="/common/message/ViewMsg.jsp"/-->
  	<%  	
  	return; 
 }

%>

<!DOCTYPE HTML PUBLIC "-//w3c//dtd html 4.0 transitional//en">
<html>
<head>
<title><%=MenuConstants.REQUEST_BOX_PRE%> > <%=MenuConstants.REQ_BOX_WRITE%> </title>
<link href="/css/System.css" rel="stylesheet" type="text/css">
<script language=Javascript src="/js/reqsubmit/common.js"></script>
<script language=Javascript src="/js/nads_lib.js"></script>
<script language=Javascript src="/js/datepicker.js"></script>
<script language="JavaScript">
  <%
 	//콤보 박스에 자료 넣기위해 Array에 테이터 넣어주는 부분.
    out.println("var form;");
    out.println("var varSelectedSubmt='" + strSubmtOrganID + "';");
	out.println("var arrCmtSubmtOrgans=new Array(" + objSubmtOrganRs.getRecordSize() + ");");
	for(int i=0;objSubmtOrganRs.next();i++){
	    out.println("arrCmtSubmtOrgans[" + i + "]=new Array('" 
			+ (String)objSubmtOrganRs.getObject("CMT_ORGAN_ID")	+ "','" + objSubmtOrganRs.getObject("SUBMT_ORGAN_ID") + "','" + objSubmtOrganRs.getObject("SUBMT_ORGAN_NM") + "');");
	}//endfor
  %>
   
  /** 위원회 연도 초기화 */
  function init(){
	var field=formName.CmtOrganID;
	makeSubmtOrganList(field.options[field.selectedIndex].value);
  }//end of func
  /** 연도별 위원회 리스트 초기화 */
  function makeSubmtOrganList(strOrganID){
       	var field=formName.SubmtOrganID;
       	field.length=0;
	for(var i=0;i<arrCmtSubmtOrgans.length;i++){
	   var strTmpCmt=arrCmtSubmtOrgans[i][0];
	   if(strOrganID==strTmpCmt){
		   var tmpOpt=new Option();
		   tmpOpt.value=arrCmtSubmtOrgans[i][1];
		   tmpOpt.text=arrCmtSubmtOrgans[i][2];
		   if(varSelectedSubmt==tmpOpt.text){
		     tmpOpt.selected=true;
		   }
		   field.add(tmpOpt);	
	   }
	}
  }//end of func
  /** 위원회 ID 변화에 따른 제출기관 리스트 변화 */
  function changeSubmtOrganList(){
    makeSubmtOrganList(formName.CmtOrganID.options[formName.CmtOrganID.selectedIndex].value);
  }//end of func	
  

    /** 폼데이터 체크 */
  function checkFormData() {
  	var alertStr = "";
	if(formName.elements['NatCnt'].value==""){
		alertStr = alertStr + "- 회기\n";
	}
	
	if(formName.elements['SubmtDln'].value==""){
		alertStr = alertStr + "- 제출기한\n";
	}
	
	if (alertStr.length != 0) {
		alertStr = "[아래의 필수 입력 항목을 입력해 주시기 바랍니다]\n\n"+alertStr;
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
	formName.submit();
  }//endfunc
  
  // 2004-07-21
  function gotoPreReqBoxList() {
  	var str1 = document.formName.NatCnt.value;
  	var str2 = document.formName.SubmtDln.value;
  	if (str1.length != 0 && str2.length != 0) {
  		if (confirm("입력하신 요구함을 생성하시겠습니까?\n취소를 누르시면 등록하지 않습니다.")) {
  			checkFormData();
  			return;
  		}
  	}
  	document.formName.action = "/reqsubmit/20_comm/40_BasicBox/20_databoxsh/RBasicReqBoxList.jsp";
  	document.formName.submit();
  }
  
  
</script>
<head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0"  onLoad="init()">
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
          <form name="formName" method="get" action="./RNewPreBoxMakeProc.jsp"><!--요구함 신규정보 전달 -->
              <tr> 
                <td height="23" align="left" valign="top"></td>
              </tr>
              <tr> 
                <td height="23" align="left" valign="top"><table width="100%" height="23" border="0" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="9%" background="/image/reqsubmit/bg_reqsubmit_tit.gif">
                      		<!-------------------- 타이틀을 입력해 주세요 ------------------------>
                      		<span class="title"><%=MenuConstants.REQ_BOX_WRITE%></span>
                      </td>
                      <td width="16%" align="left" background="/image/common/bg_titLine.gif">&nbsp;</td>
                      <td width="59%" align="right" background="/image/common/bg_titLine.gif" class="text_s">
                      		<!-------------------- 현재 위치 정보를 기술한답니다. ------------------------>
                      		<img src="/image/common/icon_navi.gif" width="3" height="5" align="absmiddle"> 
                        <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.REQUEST_BOX_COMM%> > <%=MenuConstants.REQUEST_BOX_PRE%> > <B><%=MenuConstants.REQ_BOX_WRITE%></B>
                      </td>
                    </tr>
                  </table></td>
              </tr>
              <tr> 
                <td height="30" align="left" class="text_s">
                		<!-------------------- 현재 페이지에 대한 설명 기술 ------------------------>
                		제출 기관에게 보낼 질문을 담을 요구함을  등록하는 화면입니다.  
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
                    <tr> 
                      <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        위원회 </td>
                      <td height="25" colspan="3" class="td_lmagin">
                        
						<select name="CmtOrganID" onChange="changeSubmtOrganList()"  class="select_reqsubmit">
						<%
						   /** 소속위원회 리스트 출력 */
						   while(objCmtRs.next()){
						       String strOrganID=(String)objCmtRs.getObject("ORGAN_ID");
						   	   out.println("<option value=\"" + strOrganID + "\" " + StringUtil.getSelectedStr(strCmtOrganID,strOrganID) + ">" + objCmtRs.getObject("ORGAN_NM") + "</option>");
						   }//endwhile
						%>
						</select>                      
                      </td>
                    </tr>
                    <tr height="1" class="tbl-line"> 
                      <td height="1"></td>
                      <td height="1" colspan="3"></td>
                    </tr>
                    <tr> 
                      <td height="25" class="td_gray1" width="149"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        회 기</td>
                      <td height="25" colspan="3" class="td_lmagin">
	                      제 <input type="text" size="3" maxlength="3" name="NatCnt" class="textfield" onKeyUp="CheckNumeric(this);" value="<%=strNatCnt%>"> 회 국회
                      </td>
                    </tr>
                    <tr height="1" class="tbl-line"> 
                      <td height="1"></td>
                      <td height="1" colspan="3"></td>
                    </tr>
                    <tr> 
                      <td height="25" class="td_gray1" width="149"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        업무구분</td>
                      <td height="25" class="td_lmagin" width="191">
						<select name="RltdDuty"  class="select_reqsubmit">
						 <%
						   /**업무구분 리스트 출력 */
						   while(objRltdDutyRs.next()){
						   		String strCode=(String)objRltdDutyRs.getObject("MSORT_CD");
						   		out.println("<option value=\"" + strCode + "\" " + StringUtil.getSelectedStr(strRltdDuty,strCode) + ">" + objRltdDutyRs.getObject("CD_NM") + "</option>");
						   }
						%>													
						</select>
                      </td>
                      <td height="25" class="td_gray1" width="149"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        제출기관</td>
                        <td height="25" class="td_lmagin" width="191">
							<select name="SubmtOrganID" class="select_reqsubmit">	
																
							</select>
						</td>
                    </tr>
                    <tr height="1" class="tbl-line"> 
                      <td height="1"></td>
                      <td height="1" colspan="3"></td>
                    </tr>
                    <tr> 
                      <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        제출기한</td>
                      <td height="25" colspan="3" class="td_lmagin">
						<input type="text" class="textfield" name="SubmtDln" size="10" maxlength="8" value=""  OnClick="this.select()" OnKeyPress="if ((event.keyCode&lt;48)||(event.keyCode&gt;57)) event.returnValue=false;" OnBlur="javascript:SetFormatDate(this);">
						<input type="button" value="..." style="cursor:hand" OnClick="javascript:show_calendar('formName.SubmtDln');">
                      </td>
                    </tr>
                    <tr height="1" class="tbl-line"> 
                      <td height="1"></td>
                      <td height="1" colspan="3"></td>
                    </tr>
                    <tr> 
                      <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        요구함 설명</td>
                      <td height="25" colspan="3" class="td_lmagin" style="padding-top:5px;padding-bottom:5px">
                      	<textarea rows="3" cols="70" 
                      		name="ReqBoxDsc"  
                      			class="textfield" 
                      				style="WIDTH: 90% ; height: 80"
                      					onKeyDown="javascript:updateChar(document.formName, 'ReqBoxDsc', '660')" onKeyUp="javascript:updateChar(document.formName, 'ReqBoxDsc', '660')" onFocus="javascript:updateChar(document.formName, 'ReqBoxDsc', '660')" onClick="javascript:updateChar(document.formName, 'ReqBoxDsc', '660')"></textarea><br>
                      	
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
               			<img src="/image/button/bt_reqBoxList.gif" height="20" border="0" onClick="gotoPreReqBoxList()" style="cursor:hand">
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
