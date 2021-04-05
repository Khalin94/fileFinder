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
<%@ page import="nads.lib.reqsubmit.params.requestinfo.RPreReqInfoVListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.prereqinfo.PreRequestInfoDelegate" %>
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
  RPreReqInfoVListForm objParams =new RPreReqInfoVListForm();
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
 PreRequestInfoDelegate  objReqInfo=null;	/** 요구정보 Delegate */
 ResultSetSingleHelper objInfoRsSH=null;		/**요구 정보 상세보기 */
 try{
   /**요구 정보 대리자 New */
    objReqInfo=new PreRequestInfoDelegate();
   /**요구정보 이용 권한 체크 */
   boolean blnHashAuth=objReqInfo.checkReqInfoAuth((String)objParams.getParamValue("ReqInfoID"),objUserInfo.getOrganID()).booleanValue();
   if(!blnHashAuth){
      objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	  objMsgBean.setStrCode("DSAUTH-0001");
  	  objMsgBean.setStrMsg("해당 요구함을 볼 권한이 없습니다.");
  	  //out.println("해당 요구함을 볼 권한이 없습니다.");
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%
      return;
  }else{
    objInfoRsSH=new ResultSetSingleHelper(objReqInfo.getRecord((String)objParams.getParamValue("ReqInfoID")));
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
%>

<%
 /*************************************************************************************************/
 /** 					데이터 값 할당  Part 														  */
 /*************************************************************************************************/


%>
<jsp:include page="/inc/header.jsp" flush="true"/>
<head>
<title><%=MenuConstants.REQUEST_BOX_PRE%> > <%=MenuConstants.REQ_BOX_WRITE%> </title>
<link href="/css/System.css" rel="stylesheet" type="text/css">
<script language="JavaScript">

  /** 폼데이터 체크 */
  function checkFormData(){
	if(formName.elements['ReqCont'].value==""){
		alert("요구내용을  입력하세요!!");
		formName.elements['ReqBoxNm'].focus();
		return false;
	}
	if(formName.elements['ReqDtlCont'].value.length><%=nads.lib.reqsubmit.EnvConstants.MAX_REQ_DTL_CONT_SIZE%>){
		alert("요구 내용은 <%=nads.lib.reqsubmit.EnvConstants.MAX_REQ_DTL_CONT_SIZE%>글자 이내로 작성해주세요!!");
		formName.elements['ReqDtlCont'].focus();
		return false;
	}
	formName.submit();
  }//endfunc


   /** 요구 보기  */
  function gotoInfoView(){
  	formName.action="./RBasicReqInfoVList.jsp?ReqInfoID=<%=objParams.getParamValue("ReqInfoID")%>&CmtOrganID=<%=objParams.getParamValue("CmtOrganID")%>";
  	formName.submit();
  }
</script>
<head>
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
          <form name="formName" method="post" encType="multipart/form-data" action="./RBasicReqInfoEditProc.jsp"><!--요구 수정정보 전달 -->
			<input type="hidden" name="ReqBoxID" value="<%=objParams.getParamValue("ReqBoxID")%>">
			<input type="hidden" name="CmtOrganID" value="<%=objParams.getParamValue("CmtOrganID")%>">
			<input type="hidden" name="ReqBoxSortField" value="<%=objParams.getParamValue("ReqBoxSortField")%>"><!--요구함목록정렬필드 -->
			<input type="hidden" name="ReqBoxSortMtd" value="<%=objParams.getParamValue("ReqBoxSortMtd")%>"><!--요구함목록정령방법-->
			<input type="hidden" name="ReqBoxPage" value="<%=objParams.getParamValue("ReqBoxPage")%>"><!--요구함 페이지 번호 -->
			<input type="hidden" name="ReqBoxQryField" value="<%=objParams.getParamValue("ReqBoxQryField")%>"><!--요구함 조회필드 -->
			<input type="hidden" name="ReqBoxQryTerm" value="<%=objParams.getParamValue("ReqBoxQryTerm")%>"><!--요구함 조회필드 -->
			<input type="hidden" name="ReqInfoSortField" value="<%=objParams.getParamValue("ReqInfoSortField")%>"><!--요구정보 목록정렬필드 -->
			<input type="hidden" name="ReqInfoSortMtd" value="<%=objParams.getParamValue("ReqInfoSortMtd")%>"><!--요구정보 목록정령방법-->
			<input type="hidden" name="ReqInfoPage" value="1"><!--요구정보 페이지 번호(페이징고려해서 우선 1페이지로) -->
			<input type="hidden" name="ReqInfoID" value="<%=objParams.getParamValue("ReqInfoID")%>">


    <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=MenuConstants.REQ_BOX_PRE%><span class="sub_stl" >- <%=MenuConstants.REQ_INFO_EDIT%></span></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" />  <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.REQUEST_BOX_COMM%> > <%=MenuConstants.REQUEST_BOX_PRE%> > <B><%=MenuConstants.REQ_BOX_PRE%></B></div>
        <p><!--문구--></p>
      </div>
      <!-- /pgTit -->
      <!-- contents -->
      <div id="contents">
      <span class="list02_tl">요구함 정보 </span>

                <table border="0" cellspacing="0" cellpadding="0" width="680" class="list02">
                    <tr>
                      <th height="25">&bull; 위원회 </th>
                      <td height="25" colspan="3">
                      <%=objInfoRsSH.getObject("CMT_ORGAN_NM")%>
                      </td>
                    </tr>
                    <tr>
                      <th height="25">&bull; 요구함명</th>
                      <td height="25" colspan="3">
                      <%=objInfoRsSH.getObject("REQ_BOX_NM")%>
                      </td>
                    </tr>
                    <tr>
                      <th height="25" width="18%">&bull; 업무구분</th>
                      <td height="25" width="32%"><%=objCdinfo.getRelatedDuty((String)objInfoRsSH.getObject("RLTD_DUTY"))%></td>
                      <th height="25" width="18%">&bull; 제출기관 </th>
					  <td height="25" width="32%">
						<%=(String)objInfoRsSH.getObject("SUBMT_ORGAN_NM")%>
					  </td>
                    </tr>
                    <tr>
                      <th height="25">&bull; 요구제목</th>
                      <td height="25" colspan="3">
                      	<textarea rows="5" cols="70" name="ReqCont" style="WIDTH: 90% ; height: 80"><%=(String)objInfoRsSH.getObject("REQ_CONT")%></textarea>
                      </td>
                    </tr>
                    <tr>
                      <th height="25">&bull; 요구내용</th>
                      <td height="25" colspan="3">
                      	<textarea rows="5" cols="70" name="ReqDtlCont" style="WIDTH: 90% ; height: 120"><%=(String)objInfoRsSH.getObject("REQ_DTL_CONT")%></textarea>
                      </td>
                    </tr>
                   <tr>
                      <th height="25">&bull; 공개등급</th>
                      <td height="25" colspan="3">
                      <select name="OpenCL"  class="select_reqsubmit">
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
                   </tr>
                   <tr>
                      <th height="25">&bull; 제출양식파일</th>
                      <td height="25" colspan="3">
                      	<input type="file" name="AnsEstyleFilePath" size="70"  class="textfield">
                      	<%
                      	if(StringUtil.isAssigned((String)objInfoRsSH.getObject("ANS_ESTYLE_FILE_PATH"))){
                      		out.println("<input type=\"checkbox\" name=\"DeleteFile\" value=\"OK\">파일삭제:");
                      		out.println(StringUtil.makeAttachedFileLink((String)objInfoRsSH.getObject("ANS_ESTYLE_FILE_PATH"),(String)objInfoRsSH.getObject("REQ_ID")));
                      		out.println("<br>※제출양식파일을 선택하시면 이전의 파일을 선택하신 파일로 대치합니다");
                      	}//endif
                      	%>

					  </td>
                   </tr>
                </table>
				<!------------------------- TAB에 해당하는 테이블(목록이든 등록폼이든 상세정보든) 출력 끝 ------------------------->

        <div id="btn_all"  class="t_right">
				<span class="list_bt"><a href="#" onClick="checkFormData()">저장</a></span>
				<span class="list_bt"><a href="#" onClick="formName.reset()">취소</a></span>
				<span class="list_bt"><a href="#" onClick="gotoInfoView()">요구보기</a></span>
			</span>
		</div>

         <!-- /리스트 버튼-->
        <!-- /각페이지 내용 -->
      </div>
      <!-- /contents -->

    </div>
</form>
  </div>
  <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>