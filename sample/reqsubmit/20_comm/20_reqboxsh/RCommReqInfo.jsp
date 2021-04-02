<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RCommReqBoxVListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.CommRequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.CommRequestInfoDelegate" %>
<%@ page import="nads.dsdm.app.common.page.PagingDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%
	/*** PagingDelegate */
	PagingDelegate objPaging=new PagingDelegate(); 		/*페이징 변환 Delegate*/
%>
<%
 UserInfoDelegate objUserInfo =null;
 CDInfoDelegate objCdinfo =null;
%>

<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>

<%
  /**일반 요구함 상세보기 파라미터 설정.*/
  RCommReqBoxVListForm objParams =new RCommReqBoxVListForm();

  boolean blnParamCheck=false;
  /**전달된 파리미터 체크 */
  blnParamCheck=objParams.validateParams(request);
  if(blnParamCheck==false){
  	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	objMsgBean.setStrCode("DSPARAM-0000");
  	objMsgBean.setStrMsg(objParams.getStrErrors());
  	out.println("ParamError:" + objParams.getStrErrors());
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%
  	return;
  }//endif
%>
<%
 //로그인 사용자 정보를 가져온다. 권한없음 경우 관람만 가능하다.
 String strReqSubmitFlag = objUserInfo.getReqSubmitFlag();

 /*** Delegate 과 데이터 Container객체 선언 */
 CommRequestBoxDelegate objReqBox=null; 		/**요구함 Delegate*/
 CommRequestInfoDelegate  objReqInfo=null;		/** 요구정보 Delegate */
 ResultSetSingleHelper objRsSH=null;			/** 요구함 상세보기 정보 */
 ResultSetSingleHelper objRsRI=null;			/** 요구 상세보기 정보 */
 ResultSetSingleHelper objRsInfo=null;

 String strReqBoxID = (String)objParams.getParamValue("ReqBoxID");
 String strReqID = (String)objParams.getParamValue("CommReqID");

 try{
   /**요구함 정보 대리자 New */
   objReqBox=new CommRequestBoxDelegate();
   /**요구함 이용 권한 체크 */

   boolean blnHashAuth=objReqBox.checkReqBoxAuth((String)objParams.getParamValue("ReqBoxID"),objUserInfo.getCurrentCMTList()).booleanValue();
   if(!blnHashAuth){
      objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	  objMsgBean.setStrCode("DSAUTH-0001");
  	  objMsgBean.setStrMsg("해당 요구함을 볼 권한이 없습니다.");
  	  out.println("해당 요구함을 볼 권한이 없습니다.");
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%
      return;
  }else{
   /** 요구함 정보 */
    objRsSH=new ResultSetSingleHelper(objReqBox.getRecord(strReqBoxID));
   /**요구 정보 대리자 New */
    objReqInfo=new CommRequestInfoDelegate();
	objRsRI=new ResultSetSingleHelper(objReqInfo.getRecord(strReqID));
	String strRefReqID = (String)objRsRI.getObject("REF_REQ_ID");
	objRsInfo=new ResultSetSingleHelper(objReqInfo.getCmtSubmt(strReqID,strRefReqID));
  }/**권한 endif*/
 }catch(AppException objAppEx){
 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  	objMsgBean.setStrCode(objAppEx.getStrErrCode());
  	objMsgBean.setStrMsg(objAppEx.getMessage());
  	//out.println("<br>Error!!!" + objAppEx.getMessage());
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%
  	return;
 }

 String strIngStt=(String)objRsSH.getObject("ING_STT");
 String strCmtSubmt = (String)objRsInfo.getObject("CMT_SUBMT_REQ_ID");
%>
<jsp:include page="/inc/header.jsp" flush="true"/>
<link href="/css2/style.css" rel="stylesheet" type="text/css">
<script language="javascript">
  /**요구정보 수정페이지로 가기.*/
  function gotoEdit(){
  	formName.action="./RCommReqInfoEdit.jsp";
	formName.target="";
  	formName.submit();
  }

  /**요구함 상세보기 페이지로 가기.*/
  function gotoView(){
	formName.action="./RCommReqBoxVList.jsp";
	formName.target="";
  	formName.submit();
  }

  /**요구삭제페이지로 가기.*/
  function gotoDelete(){
  	formName.action="./RCommReqDelProc.jsp";
	formName.target="";
  	formName.submit();
  }

  function showDelMoreInfoDiv() {
	  document.all.delMoreInfoDiv.style.display = '';
  }

  function FinalSubmit() {
	  var f = document.formName;
	<%if(!"".equalsIgnoreCase(strCmtSubmt)){%>
		if (f.elements['Rsn'].value == "") {
			f.elements['Rsn'].value = "수정 사유 없음";
			//return;
		}
	<% } %>
	  f.action = "./RCommReqDelProc.jsp";
	  f.target = "";
	  if (confirm("요구 정보를 삭제하시겠습니까?")) f.submit();
  }

  function hiddenDelMoreInfoDiv() {
	  document.all.delMoreInfoDiv.style.display = 'none';
  }
</script>
</head>
<body>
<div id="wrap">
<SCRIPT language="JavaScript" src="/js/reqinfo.js"></SCRIPT>
  <jsp:include page="/inc/top.jsp" flush="true"/>
  <jsp:include page="/inc/top_menu02.jsp" flush="true"/>
  <div id="container">
    <div id="leftCon">
      <jsp:include page="/inc/log_info.jsp" flush="true"/>
      <jsp:include page="/inc/left_menu02.jsp" flush="true"/>
<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>
    </div>
    <div id="rightCon">
<form name="formName" method="post" action="<%=request.getRequestURI()%>" style="margin:0px">
			<%  //요구 정보 정렬 정보 받기.
			String strCommReqInfoSortField=objParams.getParamValue("CommReqInfoSortField");
			String strCommReqInfoSortMtd=objParams.getParamValue("CommReqInfoSortMtd");
			//요구함 정보 페이지 번호 받기.
			String strCommReqInfoPagNum=objParams.getParamValue("CommReqInfoPageNum");
		%>
		    <input type="hidden" name="ReqBoxID" value="<%=objParams.getParamValue("ReqBoxID")%>">
		    <input type="hidden" name="CmtOrganID" value="<%=objParams.getParamValue("CmtOrganID")%>">
		    <input type="hidden" name="AuditYear" value="<%=objParams.getParamValue("AuditYear")%>">
			<input type="hidden" name="CommReqInfoSortField" value="<%=strCommReqInfoSortField%>"><!--요구정보 목록정렬필드 -->
			<input type="hidden" name="CommReqInfoSortMtd" value="<%=strCommReqInfoSortMtd%>"><!--요구정보 목록정령방법-->
			<input type="hidden" name="CommReqInfoPage" value="<%=strCommReqInfoPagNum%>"><!--요구정보 페이지 번호 -->
			<input type="hidden" name="CommReqID" value="<%=strReqID%>"><!--요구정보 ID-->
			<input type="hidden" name="RefReqID" value="<%=objRsRI.getObject("REF_REQ_ID")%>">
            <input type="hidden" name="ReturnURL" value="<%=request.getRequestURI()%>">
			<input type="hidden" name="IngStt" value="<%=strIngStt%>">
			<input type="hidden" name="RltdDuty" value="<%=objParams.getParamValue("RltdDuty")%>">
			<input type="hidden" name="CommReqBoxSortField" value="<%=objParams.getParamValue("CommReqBoxSortField")%>"><!--요구함목록정렬필드 -->
			<input type="hidden" name="CommReqBoxSortMtd" value="<%=objParams.getParamValue("CommReqBoxSortMtd")%>"><!--요구함목록정령방법-->
			<input type="hidden" name="CommReqBoxPage" value="<%=objParams.getParamValue("CommReqBoxPage")%>"><!--요구함 페이지 번호 -->
			<input type="hidden" name="CommReqBoxQryField" value="<%=objParams.getParamValue("CommReqBoxQryField")%>"><!--요구함 조회필드 -->
			<input type="hidden" name="CommReqBoxQryTerm" value="<%=objParams.getParamValue("CommReqBoxQryTerm")%>"><!--요구함 조회어 -->
      <!-- pgTit -->

      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=MenuConstants.COMM_REQ_BOX_MAKE%> <span class="sub_stl" >- 요구상세보기</span></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.REQUEST_BOX_COMM%> > <B><%=MenuConstants.COMM_REQ_BOX_MAKE%></B></div>
        <p><!--문구--></p>
      </div>
      <!-- /pgTit -->
      <!-- contents -->
      <div id="contents">
        <!-- 검색조건 없는 경우 아래 div 삭제 나 주석으로 막으세요.-->
        <!-- /검색조건-->
        <!-- 각페이지 내용 -->
         <!-- list view-->
        <span class="list02_tl">요구함 정보 </span>
            <!------------------------- TAB에 해당하는 테이블(목록이든 등록폼이든 상세정보든) 출력 시~~~작 ------------------------->
			<table border="0" cellspacing="0" cellpadding="0" width="680" class="list02">
			<%
				if(!objRsSH.next()){
			%>
			<tr>
				<td height="25" colspan="4">요구함 정보 가 없습니다.</td>
			</tr>
			<%
				}else{
			%>
			<tr>
				<th height="25">&bull; 요구함명 </th>
				<td height="25" colspan="3"><%=objRsSH.getObject("REQ_BOX_NM")%>
				</td>
			</tr>
			<tr>
				<th height="25">&bull; 업무구분 </th>
				<td height="25" colspan="3">
               	<%=objCdinfo.getRelatedDuty((String)objRsSH.getObject("RLTD_DUTY"))%>
				</td>
			</tr>
            <tr>
              	<th height="25">&bull; 요구기관</th>
              	<td width="240" height="25"><%=objRsSH.getObject("CMT_ORGAN_NM")%></td>
              	<th height="25">&bull;&nbsp;제출기관 </th>
              	<td width="240" height="25">
              	<%=(String)objRsSH.getObject("SUBMT_ORGAN_NM")%>
              	</td>
            </tr>
            <tr>
              	<th height="25">&bull;&nbsp;접수시작 </th>
              	<td height="25">
              	<%=StringUtil.getDate((String)objRsSH.getObject("ACPT_BGN_DT"))%>
              	</td>
              	<th height="25">&bull;&nbsp;접수마감 </th>
              	<td height="25">
              	<%=StringUtil.getDate((String)objRsSH.getObject("ACPT_END_DT"))%>
              	</td>
            </tr>
			<%
			}/** 요구함 정보 가 있으면. */
			%>
			<!------------------------- TAB에 해당하는 테이블(목록이든 등록폼이든 상세정보든) 출력 끝 ------------------------->
			</table>
        <br><br>
        <span class="list02_tl">요구 정보 </span>
        <%
        String strDelete = "";
        if(strCmtSubmt.equalsIgnoreCase("")){
            strDelete = "gotoDelete()";
        } else {
            strDelete = "javascript:showDelMoreInfoDiv()";
        }
        %>
        <div class="top_btn"><samp>
            <%
            /**위원회에서 신규등록한 요구에 한함-> 기준??*/
            if(objUserInfo.getOrganGBNCode().equals("004") && !strReqSubmitFlag.equals("004")){
            %>
            <span class="btn"><a href="javascript:gotoEdit();">요구수정</a></span>
            <span class="btn"><a href="#" onClick="<%=strDelete%>">요구삭제</a></span>
            <%
            }
            %>
            <span class="btn"><a href="#" onClick="viewReqHistory('<%=strReqID%>')">요구 이력 보기</a></span>
            <span class="btn"><a href="#" onClick="gotoView()">요구함 보기</a></span>
        </samp></div>
        <table border="0" cellspacing="0" cellpadding="0" width="680" class="list02">
			<%
				if(!objRsRI.next()){
			%>
			<tr>
				<td height="25">요구 정보 가 없습니다.</td>
			</tr>
			<%
				}else{
			%>
			<tr>
				<th height="25">&bull; 요구제목</th>
				<td width="580" height="25" colspan="3"><B><%=objRsRI.getObject("REQ_CONT")%></B></td>
			</tr>
			<tr>
				<th height="25">&bull; 요구내용</th>
				<td height="25" colspan="3" style="padding-top:4px;padding-bottom:4px">
				<%=StringUtil.getDescString((String)objRsRI.getObject("REQ_DTL_CONT"))%>
				</td>
			</tr>
             <tr>
              	<th height="25">&bull; 공개등급</th>
              	<td width="240" height="25">
           	   	<%=CodeConstants.getOpenClass((String)objRsRI.getObject("OPEN_CL"))%>
              	</td>
              	<th height="25">&bull; 등록일자</th>
              	<td width="240" height="25">
              	<%=StringUtil.getDate((String)objRsSH.getObject("ACPT_BGN_DT"))%>
              	</td>
            </tr>
			<tr>
				<th height="25">&bull; 제출양식파일</th>
				<td height="25" colspan="3">
				<%=StringUtil.makeAttachedFileLink((String)objRsRI.getObject("ANS_ESTYLE_FILE_PATH"),(String)objRsRI.getObject("REQ_ID"))%>
				</td>
			</tr>
             <tr>
              	<th height="25">&bull; 신청기관</th>
              	<td height="25">
              	<%=objRsRI.getObject("OLD_REQ_ORGAN_NM")%>
              	</td>
              	<th height="25">&bull; 신청자</th>
              	<td height="25">
              	<%=objRsRI.getObject("REGR_NM")%>
              	</td>
            </tr>
			<%
			}/** 요구 정보 가 있으면. */
			%>
			</table>
            <div id="btn_all"><div  class="t_right">
            </div></div>
			<div id="delMoreInfoDiv" style="display:none;width:680;top:300;left:600;">
				<table width="680" height="151" border="0" cellpadding="0" cellspacing="0">
				<tr>
					 <td height="30" align="left" class="soti_reqsubmit" colspan="2">
					 <img src="/image/reqsubmit/icon_reqsubmit_soti.gif" width="9" height="9" align="absmiddle">
			         요구 삭제 사유 및 통보방법</td>
				</tr>
				<tr>
					<td width="149" height="2" class="td_reqsubmit"></td>
			        <td width="531" height="2" class="td_reqsubmit"></td>
				</tr>
				<tr>
					<td height="25"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6">
			        문자전송 여부</td>
			        <td valign="middle" class="td_box"><input type="checkbox" name="NtcMtd" value="002">
			        사용</td>
				</tr>
			    <tr>
			      <td height="1" class="tbl-line"></td>
			      <td height="1" class="tbl-line"></td>
			    </tr>
			    <tr>
			      <td><img src="/image/common/icon_nemo_gray.gif" width="3" height="6">
			      사유</td>
			      <td valign="middle" class="td_box">
			      <textarea rows="3" cols="10" name="Rsn" class="textfield" style="WIDTH: 90% ; height: 30"></textarea>
			      </td>
			    </tr>
			    <tr height="1">
			      <td height="2" class="tbl-line"></td>
			      <td height="2" class="tbl-line"></td>
			    </tr>
				<tr align="left" valign="middle" height="1">
			    	<td height="40" colspan="2"><img src="/image/button/bt_delete.gif" width="43" height="20" onClick="javascript:FinalSubmit()"></td>
			    </tr>
				</table>
				<p>
			</div>
        <!-- /리스트 버튼-->
        <!-- /각페이지 내용
      </div>
      <!-- /contents -->

    </div>
  </div>
</form>
  <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>