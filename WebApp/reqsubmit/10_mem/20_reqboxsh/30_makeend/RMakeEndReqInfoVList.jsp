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
<%@ page import="nads.lib.reqsubmit.params.requestinfo.RMemReqInfoVListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.MemRequestInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.answerinfo.MemAnswerInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.cmtsubmt.CmtSubmtReqBoxDelegate" %>

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
  RMemReqInfoVListForm objParams =new RMemReqInfoVListForm();
  boolean blnParamCheck=false;
  /**전달된 파리미터 체크 */
  blnParamCheck=objParams.validateParams(request);
  if(blnParamCheck==false){
  	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	objMsgBean.setStrCode("DSPARAM-0000");
  	objMsgBean.setStrMsg(objParams.getStrErrors());
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
 MemRequestInfoDelegate  objReqInfo=null;	/** 요구정보 Delegate */
 ResultSetSingleHelper objInfoRsSH=null;	/**요구 정보 상세보기 */
 ResultSetHelper objRs=null;				/** 답변정보 목록 출력*/
 CmtSubmtReqBoxDelegate objCmtSubmt = null;

 try{
   /**요구 정보 대리자 New */
    objReqInfo=new MemRequestInfoDelegate();
    objCmtSubmt = new CmtSubmtReqBoxDelegate();

   /**요구정보 이용 권한 체크 */
   boolean blnHashAuth=objReqInfo.checkReqInfoAuth((String)objParams.getParamValue("ReqInfoID"),objUserInfo.getOrganID()).booleanValue();
   if(!blnHashAuth){
      objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	  objMsgBean.setStrCode("DSAUTH-0001");
  	  objMsgBean.setStrMsg("해당 요구정보를 볼 권한이 없습니다.");
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%
      return;
  }else{
    objInfoRsSH=new ResultSetSingleHelper(objReqInfo.getRecord2((String)objParams.getParamValue("ReqInfoID")));
    objRs=new ResultSetHelper(new MemAnswerInfoDelegate().getRecordList((String)objParams.getParamValue("ReqInfoID"),"Y"));/**제출만 Y */
  }/**권한 endif*/
 }catch(AppException objAppEx){
 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  	objMsgBean.setStrCode(objAppEx.getStrErrCode());
  	objMsgBean.setStrMsg(objAppEx.getMessage());
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%
  	return;
 }
%>
<jsp:include page="/inc/header.jsp" flush="true"/>
<script language="javascript">
  /** 목록으로 가기 */
  function gotoList(){
  	formName.action="./RMakeEndVList.jsp";
  	formName.submit();
  }
  /** 공식요구지정 */
  function appointCmtReq(){
  	if(confirm("요구제목을 위원회에 제출신청하시겠습니까?")){
	  	formName.action="/reqsubmit/10_mem/20_reqboxsh/40_commreq/RCommReqInfoApplySingleProc.jsp";
	  	formName.submit();
  	}
  }
  /**요구정보 수정페이지로 가기.*/
  function gotoEditPage(){
  	if(confirm("요구정보 설정을 수정하시겠습니까?")){
	  	formName.action="/reqsubmit/common/ChangeReqInfoOpenCLProc.jsp";
  		formName.submit();
  	}
  }
  /**답변승인상태 수정하기.*/
  function gotoEditPage2(){
  	if(confirm("요구정보 답변승인상태를 수정하시겠습니까?")){
	  	formName.action="/reqsubmit/common/ChangeReqInfoAnsApprSttProc.jsp";
  		formName.submit();
  	}
  }

  function gotoAnsInfoView2(strID,strSeq){  	
	
	  var tmpAction=formName.action;
	
	  var tmpTarget=formName.target;
	
	  var w = 500;
	
	  var h = 400;
	
	  var winl = (screen.width - w) / 2;
	
	  var wint = (screen.height - h) / 2;
	
	
	  formName.AnsID.value = strID;  
	  formName.AnsSEQ.value = strSeq;  
	
	  formName.action="/reqsubmit/common/SAnsInfoView.jsp";  	
	
	  formName.target="popwin";  	
	
	  window.open('about:blank', 'popwin', 
'width='+w+',height='+h+', left='+winl+', top='+wint+', scrollbars=no, resizable=yes, toolbar=no, menubar=no, location=no, directories=no, status=no');
	  formName.submit(); 
	  formName.action=tmpAction;
	
	  formName.target=tmpTarget;
 
}

// 파일일괄다운로드 관련 추가 20170417 ksw
  function ansDownloadAll(formName)
	{
	  if(hashCheckedAnsInfoIDs(formName)==false){   		 	
			return false;   		 
		}		 
		if(confirm("선택하신 답변을 일괄다운로드 하시겠습니까 ? \n답변파일은 기관에서 업로드한 원본파일을 다운받게 됩니다.")==true){
			var varTarget = formName.target;
			var varAction = formName.action;		   

			formName.action="/reqsubmit/10_mem/20_reqboxsh/30_makeend/AnsZipDownload.jsp";
			formName.submit();	
			formName.target = varTarget;
			formName.action = varAction; 
		}
	}
  
  /** 답변목록 체크박스에서 답변이 선택되었는지 여부 확인 */  
  function hashCheckedAnsInfoIDs(formName){	
  	var blnFlag=false;  	
  	if(formName.AnsInfoIDs.length==undefined){  	  
  		if(formName.AnsInfoIDs.checked==true){  	  	
  			blnFlag=true;  	  
  		}  	
  	}else{  	  
  		var intLen=formName.AnsInfoIDs.length;  	  
  		for(var i=0;i<intLen;i++){  	    
  			if(formName.AnsInfoIDs[i].checked==true){  	      
  				blnFlag=true;break;  	    
  			}  	  
  		}  	
  	}  	
  	if(blnFlag==false){  		
  		alert(" 선택하신 답변정보가 없습니다 \n 하나 이상의 답변정보를 선택해 주세요");  		
  		return false;  	
  	}  	
  	return true;  	  
  }

</script>
<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>
</head>

<body>
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
        <h3><%=MenuConstants.REQ_BOX_MAKE_END%> <span class="sub_stl" >- <%=MenuConstants.REQ_INFO_DETAIL_VIEW%></span></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> > <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.getReqBoxGeneral(request)%> > <%=MenuConstants.REQ_BOX_MAKE_END%></div>
        <p><!--문구--></p>
      </div>
      <!-- /pgTit -->

      <!-- contents -->

      <div id="contents">
<form name="formName" method="post" action="<%=request.getRequestURI()%>"><!--요구함 신규정보 전달 -->
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
			//요구 정보 페이지 번호 받기.
			String strReqInfoPagNum=objParams.getParamValue("ReqInfoPage");
		    %>
		    <input type="hidden" name="AuditYear" value="<%=objParams.getParamValue("AuditYear")%>">
		    <input type="hidden" name="CmtOrganID" value="<%=objParams.getParamValue("CmtOrganID")%>">
			<input type="hidden" name="ReqBoxID" value="<%=objParams.getParamValue("ReqBoxID")%>">
			<input type="hidden" name="ReqBoxSortField" value="<%=strReqBoxSortField%>"><!--요구함목록정렬필드 -->
			<input type="hidden" name="ReqBoxSortMtd" value="<%=strReqBoxSortMtd%>"><!--요구함목록정령방법-->
			<input type="hidden" name="ReqBoxPage" value="<%=strReqBoxPagNum%>"><!--요구함 페이지 번호 -->
			<%if(StringUtil.isAssigned(strReqBoxQryField)){%>
			<input type="hidden" name="ReqBoxQryField" value=""><!--요구함 조회필드 -->
			<input type="hidden" name="ReqBoxQryTerm" value=""><!--요구함 조회필드 -->
			<%}//요구함 조회어가 있는 경우만 출력해서 사용함.%>
			<input type="hidden" name="ReqInfoSortField" value="<%=strReqInfoSortField%>"><!--요구정보 목록정렬필드 -->
			<input type="hidden" name="ReqInfoSortMtd" value="<%=strReqInfoSortMtd%>"><!--요구정보 목록정령방법-->
			<input type="hidden" name="ReqInfoPage" value="<%=strReqInfoPagNum%>"><!--요구정보 페이지 번호 -->
			<input type="hidden" name="ReqInfoID" value="<%=objParams.getParamValue("ReqInfoID")%>"><!--요구정보 ID-->
			<input type="hidden" name="AnsInfoID" value=""><!--답변정보ID -->
			<input type="hidden" name="AnsID" value=""><!--답변정보ID -->
			<input type="hidden" name="AnsSEQ" value="">
			<input type="hidden" name="WinType" value="SELF">
			<input type="hidden" name="ReturnUrl" value="<%=request.getRequestURI()%>"><!--되돌아올 URL -->
			<input type="hidden" name="Rsn" value=""><!--추가요구 -->

        <!-- 검색조건 없는 경우 아래 div 삭제 나 주석으로 막으세요.-->
        <!-- /검색조건-->


        <!-- 각페이지 내용 -->
         <!-- list view-->

        <span class="list02_tl">요구정보 </span>

        <!-- 상단 버튼-->
         <div class="top_btn">
			<samp>
		<!-- 제출 완료 -->
		<%
		  //요구함 진행 상태.
		  String strReqBoxStt=(String)objInfoRsSH.getObject("REQ_BOX_STT");
		%>
		<%
			//요구함상태가 결재중이면 이동 수정 삭제가 불가능해짐.
			if(!strReqBoxStt.equals(CodeConstants.REQ_BOX_STT_004)) {
				/** 등록자와  로그인자가 같을때만 화면에 출력함.*/
				if(((String)objInfoRsSH.getObject("REQ_STT")).equals(CodeConstants.REQ_STT_SUBMT)) {
		%>
			 <span class="btn"><a href="javascript:requestAddAnswer()">추가 답변 요구</a></span>
		<%
				}//endif 추가요구
			}//endif
		%>
			 <span class="btn"><a href="javascript:viewReqHistory('<%=objParams.getParamValue("ReqInfoID")%>')">요구 이력 보기</a></span>
			 <span class="btn"><a href="javascript:gotoList()">요구함 상세 보기</a></span>
			</samp>
		 </div>

        <!-- /상단 버튼-->

        <table border="0" cellspacing="0" cellpadding="0" width="680" class="list02">

            <tr>
                <th height="25">&bull; 요구제목 </th>
                <td height="25" colspan="3"><strong><%=StringUtil.getDescString((String)objInfoRsSH.getObject("REQ_CONT"))%></strong></td>
            </tr>
            <tr>
                <th height="25">&bull; 요구내용 </th>
                <td height="25" colspan="3">- <%=StringUtil.getDescString((String)objInfoRsSH.getObject("REQ_DTL_CONT"))%>
                      	<%=nads.dsdm.app.reqsubmit.delegate.requestinfo.RequestInfoDelegate.getAppendRequestInfo((List)objInfoRsSH.getObject("TBDS_REQ_LOG"))%>
				</td>
            </tr>
		<%
			// 2004-07-08 사무처, 예정처일 경우에는 위원회라는건 보이지마
			if (CodeConstants.ORGAN_GBN_ASM.equalsIgnoreCase(objUserInfo.getOrganGBNCode()) || CodeConstants.ORGAN_GBN_BUD.equalsIgnoreCase(objUserInfo.getOrganGBNCode())) {
			} else {
		%>
            <tr>
                <th height="25">&bull; 소관 위원회 </th>
                <td height="25" colspan="3"><%=objInfoRsSH.getObject("CMT_ORGAN_NM")%> </td>
            </tr>
		 <% } %>
            <tr>
                <th height="25">&bull; 요구함명 </th>
                <td height="25" colspan="3"><%=objInfoRsSH.getObject("REQ_BOX_NM")%></td>
            </tr>
            <tr>
                <th height="25" width="18%">&bull; 요구기관 </th>
                <td height="25" width="32%"><%=(String)objInfoRsSH.getObject("REQ_ORGAN_NM")%></td>
                <th height="25" width="18%">&bull;&nbsp;제출기관</th>
                <td height="25" width="32%"><%=(String)objInfoRsSH.getObject("SUBMT_ORGAN_NM")%></td>
            </tr>
            <tr>
                <th height="25">&bull; 공개등급 </th>
                <td height="25">
					<select name="OpenCL" class="select_reqsubmit">
						<%
							List objOpenClassList=CodeConstants.getOpenClassList();
							String strOpenClass=(String)objInfoRsSH.getObject("OPEN_CL");
							for(int i=0;i<objOpenClassList.size();i++){
								String strCode=(String)((Hashtable)objOpenClassList.get(i)).get("Code");
								String strValue=(String)((Hashtable)objOpenClassList.get(i)).get("Value");
								out.println("<option value=\"" + strCode + "\"" + StringUtil.getSelectedStr(strOpenClass,strCode) + ">" + strValue + "</option>");
								}
						%>
						</select>
				</td>
                <th height="25">&bull;&nbsp;첨부파일 </th>
                <td height="25">
					<%=StringUtil.makeAttachedFileLink((String)objInfoRsSH.getObject("ANS_ESTYLE_FILE_PATH"),(String)objInfoRsSH.getObject("REQ_ID"))%>
				</td>
            </tr>
            <tr>
                <th height="25">&bull; 등록자 </th>
                <td height="25"><%=(String)objInfoRsSH.getObject("REGR_NM")%></td>
                <th height="25">&bull;&nbsp;등록일시</th>
                <td height="25"><%=StringUtil.getDate2((String)objInfoRsSH.getObject("REG_DT"))%></td>
            </tr>
            <tr>
                <th height="25">&bull; 답변 제출여부 </th>
                <td height="25"><%=CodeConstants.getRequestStatus((String)objInfoRsSH.getObject("REQ_STT"))%></td>
                <th height="25">&bull;&nbsp;위원회 제출여부</th>
                <td height="25"><%=CodeConstants.getCmtRequestAppoint((String)objInfoRsSH.getObject("CMT_REQ_APP_FLAG"))%></td>
            </tr>
            <tr>
                <th height="25">&bull; 답변 승인상태 </th>
                <td height="25">
					<%if(objInfoRsSH.getObject("REQ_STT").equals(CodeConstants.REQ_STT_SUBMT)){%>
                        <select name="ANSW_PERM_CD" class="select_reqsubmit">
                        <%
                            List objAnsApprSttList=CodeConstants.getAnsApprSttList();
                            String strAnsApprStt=(String)objInfoRsSH.getObject("ANSW_PERM_CD");
                            for(int i=0;i<objAnsApprSttList.size();i++){
                                String strCode=(String)((Hashtable)objAnsApprSttList.get(i)).get("Code");
                                String strValue=(String)((Hashtable)objAnsApprSttList.get(i)).get("Value");
                                out.println("<option value=\"" + strCode + "\"" + StringUtil.getSelectedStr(strAnsApprStt,strCode) + ">" + strValue + "</option>");
                            }
                        %>
                        </select>
                    <%} else {%>
                        <%
                            List objAnsApprSttList=CodeConstants.getAnsApprSttList();
                            String strAnsApprStt=(String)objInfoRsSH.getObject("ANSW_PERM_CD");
                            String strValue="";
                            for(int i=0;i<objAnsApprSttList.size();i++){
                                String strCode=(String)((Hashtable)objAnsApprSttList.get(i)).get("Code");

                                if (strAnsApprStt.equals(strCode)) {
                                    strValue=(String)((Hashtable)objAnsApprSttList.get(i)).get("Value");
                                }
                            }
                        %>
                        <%=strValue%><input type="hidden" name="ANSW_PERM_CD" value="<%=(String)objInfoRsSH.getObject("ANSW_PERM_CD")%>">
                    <%}%>
				</td>
                <th height="25">&nbsp;</th>
                <td height="25">&nbsp;</td>
            </tr>
        </table>
        <!-- /list view -->
        <p class="warning mt10">* 답변승인상태가 '미승인' 일경우 제출된 답변 자료의 추가, 수정, 삭제 가능하며, '승인'일 경우 답변제출이 완료 됨을 의미함.</p><br/>
        <!-- 중단 버튼-->
         <div id="btn_all">
			<div  class="t_right">
		<!-- 제출 완료 -->
		<%
			if(!strReqBoxStt.equals(CodeConstants.REQ_BOX_STT_004)) {
		%>
			 <!--div class="mi_btn"><a href="javascript:gotoEditPage2()"><span>답변승인상태저장</span></a></div-->
             <div class="mi_btn"><a href="javascript:gotoEditPage()"><span>설정 저장</span></a></div>
		<%
			}//endif
		%>
		<%
			// 2005-08-22 kogaeng ADD
			// 2005-08-29 kogaeng EDIT
			// 조건 1 : 만들어진 요구함의 소관 위원회 소속 의원실 이어야 한다.
			// 조건 2 : 소속 기관이 의원실이어야 한다.
			// 조건 3 : 요구 일정 자동 생성을 사용하지 않아야 한다.
			if(objUserInfo.getIsMyCmtOrganID((String)objInfoRsSH.getObject("CMT_ORGAN_ID")) && ((String)objInfoRsSH.getObject("CMT_REQ_APP_FLAG")).equals(CodeConstants.CMT_REQ_APP_FLAG_MEM) && !objCmtSubmt.checkCmtOrganMakeAutoSche((String)objInfoRsSH.getObject("CMT_ORGAN_ID"))) {
		%>
			 <div class="mi_btn"><a href="javascript:appointCmtReq()"><span>위원회 제출 신청</span></a></div>
		<%
			}
		%>
			</div>
		 </div><br><br>

        <!-- /중단 버튼 끝-->

        <!-- list -->
        <span class="list01_tl">답변목록 <span class="list_total">&bull;&nbsp;전체자료수 :  <%=objRs.getRecordSize()%>개 </span></span>
		<table>
			<tr>
				<td>&nbsp;</td>
			</tr>
		</table>
<!--
checkbox
<input name="" type="checkbox" value="" class="borderNo" />
-->
        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
          <thead>
            <tr>
              <th scope="col" style="width:15px"><input name="checkAll" type="checkbox" class="borderNo" onClick="checkAllOrNot(document.formName);" /></th>
              <th scope="col" style="width:10px; "><a>NO</a></th>
              <th scope="col" style="width:250px; "><a>제출 의견</a></th>
              <th scope="col" style="width:50px; "><a>작성자</a></th>
              <th scope="col" ><a>공개여부</a></th>
              <th scope="col"><a>답변</a></th>
              <th scope="col"><a>답변일자</a></th>
            </tr>
          </thead>
          <tbody>
			<%
			  int intRecordNumber=1;
			  String strAnsInfoID="";
			  while(objRs.next()){
				 strAnsInfoID=(String)objRs.getObject("ANS_ID");
			 %>
            <tr>
              <td><input name="AnsInfoIDs" type="checkbox" value="<%= strAnsInfoID %>"  class="borderNo" /></td>
              <td><%=intRecordNumber%></td>
              <td style="text-align:left;"><a href="JavaScript:gotoAnsInfoView2('<%=strAnsInfoID%>','<%=intRecordNumber%>');"><%=StringUtil.substring((String)objRs.getObject("ANS_OPIN"),35)%></a></td>
              <td style="text-align:center;"><%=(String)objRs.getObject("ANSWER_NM")%></td>

              <td><%=CodeConstants.getOpenClass(((String)objRs.getObject("OPEN_CL")))%></td>
              <td><%=this.makeAnsInfoHtml2(strAnsInfoID,(String)objRs.getObject("ANS_MTD"),(String)objInfoRsSH.getObject("REQ_CONT"),intRecordNumber+"",(String)objInfoRsSH.getObject("SUBMT_ORGAN_NM"))%></td>
              <td><%=StringUtil.getDate2((String)objRs.getObject("ANS_DT"))%></td>
            </tr>
		<%
				intRecordNumber ++;
			}//endwhile
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


       <!-- 리스트 버튼
        <div id="btn_all" >
		<!-- 리스트 내 검색 -->
<!--
		<div class="list_ser" >
          <select name="select" class="selectBox5"  style="width:70px;" >
            <option value="">요구제목</option>
            <option value="">요구내용</option>
          </select>
          <input name="iptName" onKeyDown="return ch()" onMouseDown="return ch()"
		 class="li_input"  style="width:100px"/>
          <img src="/images2/btn/bt_list_search.gif"  onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"/> </div>
-->
        <!-- /리스트 내 검색
			<span class="right">
				<span class="list_bt"><a href="#">요구복사</a></span>
				<span class="list_bt"><a href="#">요구이동</a></span>
				<span class="list_bt"><a href="#">요구삭제</a></span>
				<span class="list_bt"><a href="#">요구복사</a></span>
			</span>
		</div>

         /리스트 버튼-->
        <!-- /각페이지 내용
      </div>
      <!-- /contents -->
	  <div id="btn_all" >
		<span class="right">
			<span class="list_bt"><a href="#" onClick="ansDownloadAll(document.formName);">파일일괄다운로드</a></span>
		</span>
	  </div>

    </div>
  </div>
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