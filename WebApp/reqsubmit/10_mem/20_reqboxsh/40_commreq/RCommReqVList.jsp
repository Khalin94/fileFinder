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
<%@ page import="nads.lib.reqsubmit.params.cmtsubmt.CmtSubmtReqBoxVListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.cmtsubmt.CmtSubmtReqBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.cmtsubmt.CmtSubmtReqInfoDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

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
	objParams.setParamValue("IsRequester",String.valueOf(objUserInfo.isRequester()));//요구답변자여부설정
	
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
	  
	String strAuditYear = request.getParameter("AuditYear");


	/*************************************************************************************************/
	/** 					데이터 호출 Part 														  */
	/*************************************************************************************************/

	/*** Delegate 과 데이터 Container객체 선언 */
	CmtSubmtReqBoxDelegate objReqBox=null; 		/**요구함 Delegate*/
	CmtSubmtReqInfoDelegate  objReqInfo=null;	/** 요구정보 Delegate */
	ResultSetSingleHelper objRsSH=null;		/** 요구함 상세보기 정보 */
	ResultSetHelper objRs=null;				/**요구 목록 */

	try{
		/**요구함 정보 대리자 New */
		objReqBox=new CmtSubmtReqBoxDelegate();
		/**요구함 이용 권한 체크 */
		boolean blnHashAuth=objReqBox.checkReqBoxAuth((String)objParams.getParamValue("ReqBoxID"),objUserInfo.getOrganID()).booleanValue();
		if(!blnHashAuth){
			objMsgBean.setMsgType(MessageBean.TYPE_WARN);
			objMsgBean.setStrCode("DSAUTH-0001");
			objMsgBean.setStrMsg("해당 신청함을 볼 권한이 없습니다.");
%>
			<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
			return;
		} else {
			/** 요구함 정보 */
			objRsSH=new ResultSetSingleHelper(objReqBox.getRecord((String)objParams.getParamValue("ReqBoxID")));
			/**요구 정보 대리자 New */    
			objReqInfo=new CmtSubmtReqInfoDelegate();
			objRs=new ResultSetHelper(objReqInfo.getRecordList(objParams)); 
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

	/*************************************************************************************************/
	/** 					데이터 값 할당  Part 														  */
	/*************************************************************************************************/

	/**요구정보 목록조회된 결과 반환.*/
	int intTotalRecordCount=objRs.getTotalRecordCount();
	int intCurrentPageNum=objRs.getPageNumber();
	int intTotalPage=objRs.getTotalPageCount();	
%>

<html>
<head>
<title><%=MenuConstants.REQ_BOK_COMM_REQ%> > <%=MenuConstants.REQ_BOX_COMM_REQ_DETAIL_VIEW%></title>
<link href="/css/System.css" rel="stylesheet" type="text/css">

<script language="javascript">
  /** 정렬방법 바꾸기 */
  function changeSortQuery(sortField,sortMethod){
  	formName.ReqInfoSortField.value=sortField;
  	formName.ReqInfoSortMtd.value=sortMethod;
  	formName.submit();
  }
  /**요구 상세보기로 가기.*/
  function gotoDetail(strID){
  	formName.ReqInfoID.value=strID;
  	formName.action="./RCommReqInfoView.jsp";
  	formName.submit();
  }
  
  /** 목록으로 가기 */
  function gotoList(){
  	formName.action="./RCommReqList.jsp";
  	formName.submit();
  }
  /** 페이징 바로가기 */
  function goPage(strPage){
  	formName.ReqInfoPage.value=strPage;
  	formName.submit();
  }
  /** 요구등록페이지로 가기. */
  function gotoRegReqInfo(){
  	formName.action="./RCommReqInfoWrite.jsp";
  	formName.submit();
  }

  /** 위원회 제출신청 상정 */
  function sendCommReqReqDoc(strReqDocID,strCmtOrganID){
    if(confirm('위원회 제출신청서를 발송하시겠습니까?')){
    	var strPath="";
       if(confirm('전자결재를 통해 제출신청서를 발송하시겠습니까?\n취소를 선택하시면 즉시 제출신청이 완료됩니다.')){
	  	 strPath='/reqsubmit/10_mem/20_reqboxsh/40_commreq/RCommPopUpApply.jsp?ReqBoxID=' + strReqDocID + '&CmtOrganID=' + strCmtOrganID;
  	   }else{
  	     strPath='/reqsubmit/10_mem/20_reqboxsh/40_commreq/RCommPopUpApply.jsp?ReqBoxID=' + strReqDocID + '&CmtOrganID=' + strCmtOrganID + '&RightNow=Yes';
  	   }
  	   //window.open(strPath, '', 'width=300,height=200, scrollbars=no, resizable=yes, toolbar=no, menubar=no, location=no, directories=no, status=no');
  	   NewWindow(strPath, '', '300', '200');
  	}
  }
  /** 위원회 제출신청완료 */
  function commitCommReqReqDoc(strReqDocID,strCmtOrganID){
    if(confirm('위원회 제출신청서를 위원회에 올리시겠습니까??')){
       var strPath="";
  	   strPath='/reqsubmit/10_mem/20_reqboxsh/40_commreq/RCommPopUpCommit.jsp?ReqBoxID=' + strReqDocID + '&CmtOrganID=' + strCmtOrganID;
  	   window.open(strPath, '', 'width=300,height=200, scrollbars=no, resizable=yes, toolbar=no, menubar=no, location=no, directories=no, status=no');
  	}  
  }
  
  /** 위원회 제출 신청함 삭제 */
  function gotoCommReqDeletePage(){
  	if(confirm("등록된 요구 정보가 있습니다. 일괄 삭제하시겠습니까?")){
  		document.formName.action="./RCommReqDelProc.jsp";
	  	var blnCheckBoxFlag = false;  
		blnCheckBoxFlag = !blnCheckBoxFlag;
	 	for(i=0; i<document.formName.length; i++) {
	 		if(document.formName[i].type=='checkbox') {
		 		document.formName[i].checked = blnCheckBoxFlag;
			}
		}	
		document.formName.submit();
	}	
  }
</script>
<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="/js/reqsubmit/reqboxview.js"></SCRIPT>
</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">

<div id="balloonHint" style="display:none;height:100px"> 
<table border="0" cellspacing="0" cellpadding="4"> 
	<tr>
		<td bgcolor="#EBF2F5" width="30" height="20" align="center" style="border-left:1px solid #808080;border-top:1px solid #808080;border-bottom:2px solid #808080;"><font style="font-size:11px;font-family:verdana,돋움;font-weight:bold">요구<BR>상세<BR>내용</font></td>
		<td style="border-left:1px solid #808080;border-top:1px solid #808080;border-bottom:2px solid #808080;border-right:2px solid #808080;text-align:justify;word-break:break-all;" width="220">
			<font style="font-size:11px;font-family:verdana,돋움">{{hint}}</font>
		</td>
	</tr> 
</table> 
</div> 
<SCRIPT language="JavaScript" src="/js2/reqsubmit/tooltip.js"></SCRIPT>
<script language="javascript">balloonHint("balloonHint")</script>

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
          <form name="formName" method="<%=nads.lib.reqsubmit.EnvConstants.FORM_METHOD%>" action="<%=request.getRequestURI()%>"><!--요구함 신규정보 전달 -->
			<%//요구함 정렬 정보 받기.
			String strReqBoxSortField=objParams.getParamValue("ReqBoxSortField");
			String strReqBoxSortMtd=objParams.getParamValue("ReqBoxSortMtd");
			//요구함 페이지 번호 받기.
			String strReqBoxPagNum=objParams.getParamValue("ReqBoxPage");
			//요구함 조회정보 받기.
			String strReqBoxQryField=objParams.getParamValue("ReqBoxQryField");
			String strReqBoxQryTerm=objParams.getParamValue("ReqBoxQryTerm");
			//요구 정보 정렬 정보 받기.
			String strReqInfoSortField=objParams.getParamValue("ReqInfoSortField");
			String strReqInfoSortMtd=objParams.getParamValue("ReqInfoSortMtd");
			//요구함 정보 페이지 번호 받기.
			String strReqInfoPagNum=objParams.getParamValue("ReqInfoPage");					
		    %>
		    <% 
		    	/**요소 검색어 필드는 중복이기에 출력안함.*/
		    	objParams.getFormElement("ReqInfoQryTerm").setFormTagType(nads.lib.reqsubmit.form.FormElement.FORM_TAG_TYPE_SESSION);
		    	objParams.getFormElement("ReqInfoQryField").setFormTagType(nads.lib.reqsubmit.form.FormElement.FORM_TAG_TYPE_SESSION);
		    %>
		    <%=objParams.getHiddenFormTags()%>
			<input type="hidden" name="ReturnUrl" value="<%=request.getRequestURI()%>"><!--되돌아올 URL -->
              <tr> 
                <td height="23" align="left" valign="top"></td>
              </tr>
              <tr> 
                <td height="23" align="left" valign="top"><table width="100%" height="23" border="0" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="35%" background="/image/reqsubmit/bg_reqsubmit_tit.gif">
                      		<!-------------------- 타이틀을 입력해 주세요 ------------------------>
                      		<span class="title"><%=MenuConstants.REQ_BOK_COMM_REQ%></span><strong>- 신청함 상세보기</strong>
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
                		신청함 상세 정보를 확인하는 화면입니다.
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
                      <td height="2" colspan="4"></td>
                    </tr>
                    <%
					  //요구함 진행 상태.
					  String strReqBoxStt=(String)objRsSH.getObject("STT");                    
					%>

					<tr> 
                      <td width="100" height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        신청함명 </td>
                      <td width="580" colspan="3" class="td_lmagin">
                      	<B><%=objRsSH.getObject("CMT_SUBMT_REQ_BOX_NM")%></B>
                      </td>
                    </tr>
                    <tr height="1" class="tbl-line"> 
                      <td height="1" colspan="4"></td>
                    </tr>
					
                    <tr> 
                      <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        소관 위원회 </td>
                      <td colspan="3" class="td_lmagin">
                      	<%=objRsSH.getObject("CMT_ORGAN_NM")%>
                      </td>
                    </tr>
                    <tr height="1" class="tbl-line"> 
                      <td height="1" colspan="4"></td>
                    </tr>              
                    
                    <tr> 
                      <td height="25" width="100" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        신청횟수 </td>
                      <td height="25" width="240" class="td_lmagin">
                      	<%=(String)objRsSH.getObject("CNT")%> 번째
                      </td>
                      <td width="100" height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        진행상태 </td>
                      <td height="25" width="240" class="td_lmagin">
                      	<%=CodeConstants.getCmtSubmtReqBoxStt((String)objRsSH.getObject("STT"))%>
                      </td> 
                    </tr>
                    <tr height="1" class="tbl-line"> 
                      <td height="1" colspan="4"></td>
                    </tr>
                    <tr> 
                      <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        업무구분 </td>
                      <td height="25" class="td_lmagin">
                      	<%=objCdinfo.getRelatedDuty((String)objRsSH.getObject("RLTD_DUTY"))%> 
                      </td>
                      <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        신청기관 </td>
                      <td height="25" class="td_lmagin">
                      	<%=(String)objRsSH.getObject("REQ_ORGAN_NM")%>
                      </td> 
                    </tr>
                    <tr height="1" class="tbl-line"> 
                      <td height="1" colspan="4"></td>
                    </tr>
                    <tr> 
                      <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        신청자 </td>
                      <td height="25" class="td_lmagin">
                      	<%=(String)objRsSH.getObject("CMT_SUBMT_REQR_NM")%>
                      </td>
                      <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        등록일자 </td>
                      <td height="25" class="td_lmagin">
                      	<%=StringUtil.getDate2((String)objRsSH.getObject("CMT_SUBMT_REQ_DT"))%>
                      </td> 
                    </tr>
                    <tr height="1" class="tbl-line"> 
                      <td height="1" colspan="4"></td>
                    </tr>
                    <%
                    /** 전자 결재된경우만 출력함.*/
                    if(StringUtil.isAssigned((String)objRsSH.getObject("APRV_DT"))){
                    %>
                    <tr height="1" class="tbl-line"> 
                      <td height="1" colspan="4"></td>
                    </tr>
                    <tr> 
                      <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        결재번호 </td>
                      <td height="25" class="td_lmagin">
                      	<%=(String)objRsSH.getObject("APRV_DOC_NO")%>
                      </td>
                      <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        결재일자 </td>
                      <td height="25" class="td_lmagin">
                      	<%=StringUtil.getDate((String)objRsSH.getObject("APRV_DT"))%>
                      </td> 
                    </tr>
                    <tr height="1" class="tbl-line"> 
                      <td height="1" colspan="4"></td>
                    </tr>                    
                    <%
                    }//endif
                    %>
                    <tr height="1" class="tbl-line"> 
                      <td height="1" colspan="4"></td>
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
						<%
							// 2005-09-26 kogaeng EDIT
							// 작성중(001), 상신대기(002), 위원회요구삭제(009)
							if(strReqBoxStt.equals(CodeConstants.CMT_SUBMT_REQ_BOX_STT_001) || strReqBoxStt.equals(CodeConstants.CMT_SUBMT_REQ_BOX_STT_002) || strReqBoxStt.equals(CodeConstants.CMT_SUBMT_REQ_BOX_STT_009)){
						%>
						  <%
							/** 등록자와  로그인자가 같을때만 화면에 출력함.*/
							if(objUserInfo.getUserID().equals((String)objRsSH.getObject("CMT_SUBMT_REQR_ID"))){
						  %>
						 <!-- 만약 버튼이 정상적으로 보이지 않는 경우, stylesheet파일(*.css) 파일을 업데이트 하시오!!!!!!!! -->
						<!-- 요구함 수정 BUTTON -->
						<img src="/image/button/bt_modifyAppBox.gif" border="0" onClick="javascript:gotoCommReqEditPage()" style="cursor:hand">
							<%
							  if(intTotalRecordCount > 0){//딸린식구가 없을때 삭제.
							%>
						<!-- 요구함 삭제 BUTTON -->
						<img src="/image/button/bt_deleteAppBox.gif"  border="0" onClick="javascript:gotoCommReqDeletePage()" style="cursor:hand">
							<%
							  }//endif 딸린식구.
							%>
						  <%
							}//endif
						  %>												
							<%
								// 2005-09-26 kogaeng EDIT
								// 작성중(001), 상신대기(002), 위원회요구삭제(009)
								if(intTotalRecordCount>0 && (strReqBoxStt.equals(CodeConstants.CMT_SUBMT_REQ_BOX_STT_001) || strReqBoxStt.equals(CodeConstants.CMT_SUBMT_REQ_BOX_STT_002) || strReqBoxStt.equals(CodeConstants.CMT_SUBMT_REQ_BOX_STT_009)) ){//딸린식구가 있을때 보내기. 작성중,상신대기일때만..
							%>
						<!-- 신청서 전재결재 연동  BUTTON -->

<SCRIPT language="VBScript">
Sub sendCommReqReqDoc2(strReqDocID, strCmtOrganID)
	dim a 
	dim strPath
		'a = MsgBox ("위원회 제출신청서를 발송하시겠습니까?"+chr(13)&chr(10)+"예를 클릭하시면 전자결재를 통해서"+chr(13)&chr(10)+"아니오를 클릭하시면 즉시 발송되며"+chr(13)&chr(10)+"취소를 클릭하시면 발송이 취소됩니다.", 3, "위원회 제출 신청")
		a = MsgBox("위원회제출신청서를 전자결재를 통하여 발송하시겠습니까?", 3, "위원회 제출 신청")
		if a = 6 Then
			'document.location.href="http://www.yahoo.co.kr"
			strPath="/reqsubmit/10_mem/20_reqboxsh/40_commreq/RCommPopUpApply.jsp?ReqBoxID="+strReqDocID+"&CmtOrganID="+strCmtOrganID+"&AuditYear=<%= strAuditYear %>"
			window.open strPath, "", "width=300px, height=300px"
		Elseif a = 7 Then
			'document.location.href="http://www.naver.com"
			strPath = "/reqsubmit/10_mem/20_reqboxsh/40_commreq/RCommPopUpApply.jsp?ReqBoxID="+strReqDocID+"&CmtOrganID="+strCmtOrganID+"&RightNow=Yes&AuditYear=<%= strAuditYear %>"
			window.open strPath, "", "width=300px, height=300px"
		Elseif a = 2 Then
		Else
		End if
End Sub
</SCRIPT>

<script language="javascript">
	function aaa(strReqDocID, strCmtOrganID) {
		if(confirm("위원회에 제출 신청서를 발송 하시겠습니까?")) {
			var strPath = "/reqsubmit/10_mem/20_reqboxsh/40_commreq/RCommPopUpApply.jsp?ReqBoxID="+strReqDocID+"&CmtOrganID="+strCmtOrganID+"&RightNow=Yes&AuditYear=<%= strAuditYear %>";
			NewWindow(strPath, '', 300, 300);
		}
	}
</script>

						<img src="/image/button/bt_applyCommitteeSubmit.gif"  border="0" onClick="aaa('<%= (String)objParams.getParamValue("ReqBoxID") %>','<%=(String)objRsSH.getObject("CMT_ORGAN_ID")%>')" style="cursor:hand">
							<%
							  }//endif 딸린식구.
							%>
					    <%	
							}//end if
						%>
						<!-- 2005-05-30 예결위 소속 의원실을 대상으로 잠정적으로 기능을 막아 둔다 -->
						<%
							//if(objUserInfo.getIsMyCmtOrganID("GI00004773")) {
							if(objReqBox.checkCmtOrganMakeAutoSche((String)objRsSH.getObject("CMT_ORGAN_ID")) 
							&& objUserInfo.getIsMyCmtOrganID((String)objRsSH.getObject("CMT_ORGAN_ID")) 
							&& strReqBoxStt.equals(CodeConstants.CMT_SUBMT_REQ_BOX_STT_003) 
							&& objUserInfo.getUserID().equals((String)objRsSH.getObject("CMT_SUBMT_REQR_ID"))) {
						%>
						<img src="/image/button/bt_commitCommitteeSubmit.gif"  border="0" onClick="javascript:commitCommReqReqDoc('<%= (String)objParams.getParamValue("ReqBoxID") %>','<%=(String)objRsSH.getObject("CMT_ORGAN_ID")%>')" style="cursor:hand">
						<%
						 	}
						%>						
						<!-- 신청함 목록 -->
						<img src="/image/button/bt_appBoxList.gif"  border="0" onClick="javascript:gotoList()" style="cursor:hand">
               		 </td>
               	   </tr>
               	</table>   
               	<!----------------------- 저장 취소등 Form관련 버튼 끝 ------------------------->               	   
                </td>
              </tr> 
              <tr>
               	<!-- 스페이스한칸 -->
               	<td>&nbsp;</td>
               	<!-- 스페이스한칸 -->
              </tr>
              <tr> 
                <td height="30" class="soti_reqsubmit">
                	<!-------------------- TAB 에 해당하는 제목을 기술하는 곳이지요. ------------------------>
                	<table border="0" cellpadding="0" cellspacing="0" width="759">
                		<tr>
                			<td width="400" class="soti_reqsubmit">
                			   <img src="/image/reqsubmit/icon_reqsubmit_soti.gif" width="9" height="9" align="absmiddle"> 
                  				요구 목록
				            </td>
				            <td width="359" align="right" valign="bottom" class="text_s">
				            	<!------------------------- COUNT (PAGE) ------------------------------------>
				            	&nbsp;&nbsp;<img src="/image/common/icon_nemo_gray.gif" width="3" height="6" align="absmiddle">
				            	전체 자료 수 : <%=intTotalRecordCount%>개 (<%=intCurrentPageNum%> / <%=intTotalPage%> Page)&nbsp;&nbsp;
				            </td>
				       </tr>
				   </table>
                </td>
              </tr>
              <tr> 
                <td align="left" valign="top" class="soti_reqsubmit">
                <!------------------------- TAB에 해당하는 테이블(목록이든 등록폼이든 상세정보든) 출력 시~~~작 ------------------------->
					<table width="759" border="0" cellspacing="0" cellpadding="0">
                    	<tr> 
                      		<td height="2" class="td_reqsubmit"></td>
	                    </tr>
	                    <tr align="center" class="td_top">
	                    	<td>
	                    		<table width="759" border="0" cellspacing="0" cellpadding="0">
									<tr class="td_top">
										<td height="22" width="10" align="center"><input type="checkbox" name="checkAll" onClick="checkAllOrNot(document.formName);"></td>
										<td width="19" align="center">NO</td>
										<td width="400" align="center"><%=SortingUtil.getSortLink("changeSortQuery","REQ_CONT",strReqInfoSortField,strReqInfoSortMtd,"요구제목")%></td>
										<td width="170" align="center"><%=SortingUtil.getSortLink("changeSortQuery","SUBMT_ORGAN_NM",strReqInfoSortField,strReqInfoSortMtd,"제출기관")%></td>
										<td width="80" align="center"><%=SortingUtil.getSortLink("changeSortQuery","OPEN_CL",strReqInfoSortField,strReqInfoSortMtd,"공개등급")%></td>
										<td width="80" align="center"><%=SortingUtil.getSortLink("changeSortQuery","REG_DT",strReqInfoSortField,strReqInfoSortMtd,"등록일자")%></td>
									</tr>
	                    		</table>
	                    	</td>
	                    </tr>
                	    <tr> 
                    	  	<td height="1" class="td_reqsubmit"></td>
                    	</tr>
						<%
						  int intRecordNumber=intTotalRecordCount - ((intCurrentPageNum -1) * Integer.parseInt((String)objParams.getParamValue("ReqInfoPageSize")));						
						  //int intRecordNumber= (intCurrentPageNum -1) * Integer.parseInt((String)objParams.getParamValue("ReqInfoPageSize")) +1;
						  String strReqInfoID="";
						  while(objRs.next()){
						   	 strReqInfoID=(String)objRs.getObject("CMT_SUBMT_REQ_ID");
						 %>								
						<tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''">
							<td>
								<table width="759" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td height="22" width="10" align="center"><input type="checkbox" name="ReqInfoIDs" value="<%=strReqInfoID%>"></td>
										<td width="29" align="center"><%=intRecordNumber%></td>
										<td width="400" class="td_lmagin"><a href="JavaScript:gotoDetail('<%=strReqInfoID%>');" hint="<%= (String)objRs.getObject("REQ_DTL_CONT") %>"><%=StringUtil.substring((String)objRs.getObject("REQ_CONT"),35)%></a></td>
										<td width="170" align="left"><%=(String)objRs.getObject("SUBMT_ORGAN_NM")%></td>
										<td width="80" align="center"><%=CodeConstants.getOpenClass((String)objRs.getObject("OPEN_CL"))%></td>
										<td width="70" align="right" style="padding-top:2px;padding-bottom:2px;padding-right:4px"><%=StringUtil.getDate2((String)objRs.getObject("REG_DT"))%></td>
									</tr>
								</table>
							</td>
						</tr>
    	                <tr class="tbl-line"> 
                      		<td height="1"></td>
                    	</tr>       	
						<%
							    intRecordNumber --;
							}//endwhile
						%>
						<%
						/*조회결과 없을때 출력 시작.*/
						if(objRs.getRecordSize()<1){
						%>
						<tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''">
						    <td align="center" height="22">등록된 요구정보가 없습니다.</td>
						</tr>
    	                <tr class="tbl-line"> 
                      		<td height="1"></td>
                    	</tr>       	
						<%
						}/*조회결과 없을때 출력 끝.*/
						%>													
    	                <tr class="tbl-line"> 
                      		<td height="1"></td>
                    	</tr>       	
	                </table>
				<!------------------------- TAB에 해당하는 테이블(목록이든 등록폼이든 상세정보든) 출력 끝 ------------------------->
				</td>
			  </tr>
              <tr> 
                <td height="35" align="center">
                	<!-----------------------------------------  페이징 네비게이션 ---------------------------------------->
                	<%= PageCount.getLinkedString(
							new Integer(intTotalRecordCount).toString(),
							new Integer(intCurrentPageNum).toString(),
							objParams.getParamValue("ReqInfoPageSize"))
					%>
                </td>
              </tr>
              <tr height="3">
              	<td height="3" align="left" valign="top" background="/image/common/line_table.gif"></td>
              </tr>                                          
              <!------------------ 검색(조회) 폼 <tr></tr> --------------------------->
              <tr> 
                <td height="40" align="left" valign="top">
                	<table width="100%" border="0" cellspacing="0" cellpadding="0">
                    	<tr> 
                      		<td width="356" height="40">
                      			<!-- 버튼이 필요하다면 여기에 추가하심 됩니다용 -->
						<%//신청함상태가 작성줄일때만 삭제가능.
						if(strReqBoxStt.equals(CodeConstants.CMT_SUBMT_REQ_BOX_STT_001) || strReqBoxStt.equals(CodeConstants.CMT_SUBMT_REQ_BOX_STT_002) ){
						%>                      			
                      			<img src="/image/button/bt_registerReq.gif" height="20"  style="cursor:hand" onClick="gotoRegReqInfo();">
                      			<%
                      			if(objRs.getRecordSize()<=0){/**요구목록이있을경우만 출력*/
                      			%>
                      			<img src="/image/button/bt_delReq.gif" height="20"  style="cursor:hand" onClick="delCommReqInfos(formName);">                      			
                      			<%
                      			}//endif 
                      			%>
                      	<%
                      	}//endif
                      	%>
                      		</td>
							<td width="403" align="right" valign="middle">
							<%
								String strReqInfoQryField=(String)objParams.getParamValue("ReqInfoQryField");
							%>
								<select name="ReqInfoQryField" class="select">
									<option <%=(strReqInfoQryField.equalsIgnoreCase("req_cont"))? " selected ": ""%>value="req_cont">요구제목</option>
									<option <%=(strReqInfoQryField.equalsIgnoreCase("req_dtl_cont"))? " selected ": ""%>value="req_dtl_cont">요구내용</option>
									<option <%=(strReqInfoQryField.equalsIgnoreCase("submt_organ_nm"))? " selected ": ""%>value="submt_organ_nm">제출기관</option>
								</select>
								<input type="text" class="textfield" name="ReqInfoQryTerm" value="<%=objParams.getParamValue("ReqInfoQryTerm")%>">
								<img src="/image/common/bt_search_table.gif" height="18" align="absmiddle" onClick="formName.submit();" style="cursor:hand">
							</td>
                    	</tr>
                  	</table>
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
