<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.params.cmtsubmt.CmtSubmtReqBoxVListForm" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.cmtsubmt.CmtSubmtReqBoxDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	/******************************************************************************
	* Name		  : RCommReqInfoWrite.jsp
	* Summary	  : 신청함에 입력될 요구내용 작성.
	* Description : 요구정보입력은 큰화면에서 입력 가능하게 해야하고,
	*				답변양식 파일을 첨부할수 있는 기능을 제공해야함.
	* 				아참.. 큰화면을 어찌 준비해야할지..
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
	
	/**일반 신청함 상세보기 파라미터 설정.*/
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

	/*************************************************************************************************/
	/** 					데이터 호출 Part 														  */
	/*************************************************************************************************/
	
	/*** Delegate 과 데이터 Container객체 선언 */
	CmtSubmtReqBoxDelegate objReqBox=null; 		/**신청함 Delegate*/
	ResultSetSingleHelper objRsSH=null;		/** 신청함 상세보기 정보 */
	ResultSetHelper objSubmtOrganRs=null; /** 제출기관 리스트 출력용 RsHelper */ 
	try{
		/**신청함 정보 대리자 New */
		objReqBox=new CmtSubmtReqBoxDelegate();
		OrganInfoDelegate objOrganInfo=new OrganInfoDelegate();   /** 기관정보 출력용 대리자 */
		/**신청함 이용 권한 체크 */
		boolean blnHashAuth=objReqBox.checkReqBoxAuth((String)objParams.getParamValue("ReqBoxID"),objUserInfo.getOrganID()).booleanValue();
		if(!blnHashAuth){
			objMsgBean.setMsgType(MessageBean.TYPE_WARN);
			objMsgBean.setStrCode("DSAUTH-0001");
			objMsgBean.setStrMsg("해당 신청함을 볼 권한이 없습니다.");
%>
			<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
			return;
		}else{
			/** 신청함 정보 */
			objRsSH=new ResultSetSingleHelper(objReqBox.getRecord((String)objParams.getParamValue("ReqBoxID")));
			objSubmtOrganRs=new ResultSetHelper(objOrganInfo.getSubmtOrganListOnly((String)objRsSH.getObject("CMT_ORGAN_ID")));/**제출기관리스트*/
		}/**권한 endif*/
	}catch(AppException objAppEx){
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		System.out.println("SysErrorCode:" + objAppEx.getStrErrCode());
		objMsgBean.setStrCode("SYS-00010");//AppException에러.
		objMsgBean.setStrMsg(objAppEx.getMessage());
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%  	
		return;
	}

	String strSubmtOrganID=(String)objRsSH.getObject("SUBMT_ORGAN_ID");
%>

<html>
<head>
<title><%=MenuConstants.getReqBoxGeneral(request)%> > <%=MenuConstants.REQ_BOK_COMM_REQ%> </title>
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
	if(formName.elements['ReqDtlCont'].value.length><%=nads.lib.reqsubmit.EnvConstants.MAX_REQ_DTL_CONT_SIZE%>){
		alert("요구 내용은 <%=nads.lib.reqsubmit.EnvConstants.MAX_REQ_DTL_CONT_SIZE%>글자 이내로 작성해주세요!!");
		formName.elements['ReqDtlCont'].focus();
		return false;
	}	
	formName.submit();
  }//endfunc
  
  // 2004-07-19
  function gotoCommReqBoxList() {
  	var str1 = document.formName.SubmtOrganID.value;
  	var str2 = document.formName.ReqCont.value;
  	var str3 = document.formName.ReqDtlCont.value;
  	
  	if (str1.length != 0 && str2.length != 0 && str3.length != 0) {
  		if (confirm("입력하신 요구 정보를 등록하시겠습니까?\n취소를 원하시면 아니오를 선택해 주세요")) document.formName.action = "./RCommReqInfoWriteProc.jsp";
  		else document.formName.action = "./RCommReqVList.jsp";
  	} else {
  		document.formName.action = "./RCommReqVList.jsp";
  	}
  	document.formName.submit();
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
          <form name="formName" method="post" encType="multipart/form-data" action="./RCommReqInfoWriteProc.jsp"><!--요구 신규정보 전달 -->
            <!--요구정보 페이지 번호(페이징고려해서 우선 1페이지로) -->          
            <% objParams.setParamValue("ReqInfoPage","1");%>
            <%=objParams.getHiddenFormTags()%>
              <tr> 
                <td height="23" align="left" valign="top"></td>
              </tr>
              <tr> 
                <td height="23" align="left" valign="top"><table width="100%" height="23" border="0" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="35%" background="/image/reqsubmit/bg_reqsubmit_tit.gif">
                      		<!-------------------- 타이틀을 입력해 주세요 ------------------------>
                      		<span class="title"><%=MenuConstants.REQ_BOK_COMM_REQ%></span><strong>-<%=MenuConstants.REQ_INFO_WRITE%></strong>
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
                		제출기관에게 보낼 요구제목을 등록하는 화면입니다.
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
                      <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        신청함명</td>
                      <td height="25" colspan="3" class="td_lmagin"><B><%=objRsSH.getObject("CMT_SUBMT_REQ_BOX_NM")%></B></td>
                    </tr>
                    <tr height="1" class="tbl-line"> 
                      <td height="1"></td>
                      <td height="1" colspan="3"></td>
                    </tr>
                    
                    <tr> 
                      <td height="25" width="149" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        위원회 </td>
                      <td height="25" colspan="3" class="td_lmagin">
                      <%=objRsSH.getObject("CMT_ORGAN_NM")%>
                      </td>
                    </tr>
                    <tr height="1" class="tbl-line"> 
                      <td height="1"></td>
                      <td height="1" colspan="3"></td>
                    </tr>
                    
                    <tr> 
                      <td height="25" width="149" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        업무구분</td>
                      <td height="25" class="td_lmagin" width="191">
                      <%=objCdinfo.getRelatedDuty((String)objRsSH.getObject("RLTD_DUTY"))%>
                      </td>
                      <td width="149" height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        제출기관 </td>
					  <td height="25" width="191" class="td_lmagin">
						<select name="SubmtOrganID"  class="select">
						<%
						   /** 제출기관 리스트 출력 */
						   while(objSubmtOrganRs.next()){
						       String strOrganID=(String)objSubmtOrganRs.getObject("SUBMT_ORGAN_ID");
						   	   out.println("<option value=\"" + strOrganID + "\" " + StringUtil.getSelectedStr(strSubmtOrganID,strOrganID) + ">" + objSubmtOrganRs.getObject("SUBMT_ORGAN_NM") + "</option>");
						   }//endwhile
						%>
						</select>                      					  
						<%=(String)objRsSH.getObject("SUBMT_ORGAN_NM")%>
					  </td>
                    </tr>
                    <tr height="1" class="tbl-line"> 
                      <td height="1"></td>
                      <td height="1" colspan="3"></td>
                    </tr>
                    <tr> 
                      <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        요구제목</td>
                      <td height="25" colspan="3" class="td_lmagin" style="padding-top:4px;padding-bottom:4px">
                      	<input type="text" name="ReqCont" class="textfield" size="85" maxlength="1000">			
                      	<br>
						&nbsp;<font class="soti_reqsubmit">* 한글은 500자, 영문은 1000자 까지만 입력 가능합니다.</font>			
                      </td>
                    </tr>
                    <tr height="1" class="tbl-line"> 
                      <td height="1"></td>
                      <td height="1" colspan="3"></td>
                    </tr>
                    <tr> 
                      <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        요구내용</td>
                      <td height="25" colspan="3"  class="td_box">
                      	<textarea rows="5" cols="70" name="ReqDtlCont"  
                      		class="textfield" style="WIDTH: 95%; height:180"  
                      		onKeyDown="javascript:updateChar2(document.formName, 'ReqDtlCont', '4000')" onKeyUp="javascript:updateChar2(document.formName, 'ReqDtlCont', '4000')" onFocus="javascript:updateChar2(document.formName, 'ReqDtlCont', '4000')" onClick="javascript:updateChar2(document.formName, 'ReqDtlCont', '4000')"></textarea><br>
                      	<table border="0">
						<tr><td width="30" align="right"><B><div id ="textlimit"> </div></B></td>
						<td width="570"> bytes (4000 bytes 까지만 입력됩니다) </td></tr>
						</table>
						<BR>
						<font class="soti_reqsubmit">* 한글은 2000자, 영문은 4000자에 해당합니다.</font>
                      </td>
                    </tr>
                    <tr height="1" class="tbl-line"> 
                      <td height="1"></td>
                      <td height="1" colspan="3"></td>
                   </tr>
                   <tr> 
                      <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        공개등급</td>
                      <td height="25" colspan="3" class="td_lmagin">
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
                   <tr height="1" class="tbl-line"> 
                      <td height="1"></td>
                      <td height="1" colspan="3"></td>
                   </tr>                   
                   <tr> 
                      <td height="25" width="149" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        제출양식파일</td>
                      <td height="25" colspan="3" class="td_lmagin">
                      	<input type="file" name="AnsEstyleFilePath" size="70"  class="textfield">
					  </td>
                   </tr>
                   <tr height="2" class="tbl-line"> 
                      <td height="2"></td>
                      <td height="2" colspan="3"></td>
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
               			<img src="/image/button/bt_viewAppBox.gif" height="20" border="0" onClick="gotoCommReqBoxList()" style="cursor:hand">
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
