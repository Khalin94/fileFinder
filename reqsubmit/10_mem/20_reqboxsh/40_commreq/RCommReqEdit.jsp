<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.params.cmtsubmt.CmtSubmtReqBoxVListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.cmtsubmt.CmtSubmtReqBoxDelegate" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%
/******************************************************************************
* Name		  : RCommReqEdit.jsp
* Summary	  : 신청함 수정 화면 제공.
* Description : 신청함을 개별적으로 직접 수정할 수 있는 화면을 제공한다.
* 				
*				
******************************************************************************/
%>
<%
 UserInfoDelegate objUserInfo =null;
 CDInfoDelegate objCdinfo =null;
%>
<%@ include file="../../../common/RUserCodeInfoInc.jsp" %>
<%
 /*************************************************************************************************/
 /** 					파라미터 체크 Part 														  */
 /*************************************************************************************************/

  /**일반 요구함 상세보기 파라미터 설정.*/
  CmtSubmtReqBoxVListForm objParams =new CmtSubmtReqBoxVListForm();  
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
 
 /******* 편의 제공용 SELECT Box Param */ 
 String strCmtOrganID=null;/**위원회 ID */
 String strRltdDuty=null;/** 업무구분 */
 
%>

<%
 /*************************************************************************************************/
 /** 					데이터 호출 Part 														  */
 /*************************************************************************************************/

 /******** 데이터 담을 컨테이너 설정 ********/
 ResultSetHelper objCmtRs=null;        /** 소속 위원회 리스트 출력용 RsHelper */
 ResultSetSingleHelper objRsSH=null;	/** 상세정보 */
 ResultSetHelper objRltdDutyRs=null;   /** 업무구분 리스트 출력용 RsHelper */
 
 try{
   /********* 대리자 정보 설정 *********/
   CmtSubmtReqBoxDelegate objReqBox=new CmtSubmtReqBoxDelegate();
   
   /********* 값가져오기 **************/
   objCmtRs=new ResultSetHelper(objUserInfo.getCurrentCMTList());   /** 소속 위원회 */
   objRltdDutyRs=new ResultSetHelper(objCdinfo.getRelatedDutyList()); /** 업무 구분 가져오기 */      
   objRsSH=new  ResultSetSingleHelper(objReqBox.getRecord(objParams.getParamValue("ReqBoxID")));
   
 }catch(Exception objEx){ 
 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  	objMsgBean.setStrCode("SYS-00010");//AppException에러.
  	objMsgBean.setStrMsg(objEx.getMessage());
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%  	
  	return; 
 }

%>

<%
 /*************************************************************************************************/
 /** 					데이터 값 할당  Part 														  */
 /*************************************************************************************************/

 strCmtOrganID=StringUtil.getEmptyIfNull((String)objRsSH.getObject("CMT_ORGAN_ID"));/**위원회 ID */
 strRltdDuty=StringUtil.getEmptyIfNull((String)objRsSH.getObject("RLTD_DUTY"));	/**업무구분ID */
 
%>

<html>
<head>
<title><%=MenuConstants.REQ_BOK_COMM_REQ%>  </title>
<link href="/css/System.css" rel="stylesheet" type="text/css">
<script language="JavaScript">  
  /** 폼데이터 체크 */
  function checkFormData(){
	if(formName.elements['ReqBoxNm'].value==""){
		alert("신청함명을  입력하세요!!");
		formName.elements['ReqBoxNm'].focus();
		return false;
	}
	formName.submit();
  }
  
	function gotoList() {
		var f = document.formName;
		f.method = "get";
		f.action = "/reqsubmit/10_mem/20_reqboxsh/40_commreq/RCommReqList.jsp";
		f.target = "";
		f.submit();
	}
</script>
<head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
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
<form name="formName" method="post" action="./RCommReqEditProc.jsp">
          	 <%=objParams.getHiddenFormTags()%>
          	 <input type="hidden" name="AuditYear" value="<%=(String)objRsSH.getObject("AUDIT_YEAR")%>"><!--중복체크용 -->
              <tr> 
                <td height="23" align="left" valign="top"></td>
              </tr>
              <tr> 
                <td height="23" align="left" valign="top"><table width="100%" height="23" border="0" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="35%" background="/image/reqsubmit/bg_reqsubmit_tit.gif">
                      		<!-------------------- 타이틀을 입력해 주세요 ------------------------>
                      		<span class="title"><%=MenuConstants.REQ_BOK_COMM_REQ%></span> <strong>- 신청함 수정</strong>
                      </td>
                      <td width="16%" align="left" background="/image/common/bg_titLine.gif">&nbsp;</td>
                      <td width="49%" align="right" background="/image/common/bg_titLine.gif" class="text_s">
                      		<!-------------------- 현재 위치 정보를 기술한답니다. ------------------------>
                      		<img src="/image/common/icon_navi.gif" width="3" height="5" align="absmiddle"> 
                        <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.getReqBoxGeneral(request)%> > <B><%=MenuConstants.REQ_BOK_COMM_REQ%></B>
                      </td>
                    </tr>
                  </table></td>
              </tr>
              <tr> 
                <td height="30" align="left" class="text_s">
                		<!-------------------- 현재 페이지에 대한 설명 기술 ------------------------>
                		위원회에 제출할 요구제목을 담을 신청함을 수정하는 화면입니다.  
                </td>
              </tr>
              <tr> 
                <td height="5" align="left" class="soti_reqsubmit"></td>
              </tr>
              <tr> 
                <td height="30" align="left" class="soti_reqsubmit">
                	<!-------------------- TAB 에 해당하는 제목을 기술하는 곳이지요. ------------------------>
                	<img src="/image/reqsubmit/icon_reqsubmit_soti.gif" width="9" height="9" align="absmiddle"> 
                  신청함 정보
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
						<select name="CmtOrganIDX"   class="select">
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
                      <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        신청함명</td>
                      <td height="25" colspan="3" class="td_lmagin">
	                      <input type="text" size="70" maxlength="100" name="ReqBoxNm" class="textfield" value="<%=(String)objRsSH.getObject("CMT_SUBMT_REQ_BOX_NM")%>">
                      </td>
                    </tr>
                    <tr height="1" class="tbl-line"> 
                      <td height="1"></td>
                      <td height="1" colspan="3"></td>
                    </tr>
                    <tr> 
                      <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        업무구분</td>
                      <td height="25" class="td_lmagin" colspan="3">
						<select name="RltdDuty"  class="select">
						<%
						   /**업무구분 리스트 출력 */
						   while(objRltdDutyRs.next()){
						   		String strCode=(String)objRltdDutyRs.getObject("MSORT_CD");
						   		out.println("<option value=\"" + strCode + "\" " + StringUtil.getSelectedStr(strRltdDuty,strCode) + ">" + objRltdDutyRs.getObject("CD_NM") + "</option>");
						   }
						%>													
						</select>
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
               			<img src="/image/button/bt_appBoxList.gif"  height="20" border="0" onClick="javascript:gotoList()" style="cursor:hand">
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
