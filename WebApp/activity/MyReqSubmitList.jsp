<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.bf.config.*"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.params.requestinfo.MyPageReqInfoListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.commreqsch.CommMakeBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.RequestInfoDelegate" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<jsp:include page="/inc/header.jsp" flush="true"/>
</head>
<%@ include file="/common/CheckSession.jsp" %>
<%
 UserInfoDelegate objUserInfo =null;
 CDInfoDelegate objCdinfo =null;
%>
<%@ include file="../reqsubmit/common/RUserCodeInfoInc.jsp" %>
<%
 /*************************************************************************************************/
 /** 					파라미터 체크 Part 														  */
 /*************************************************************************************************/

  /**일반 요구목록 파람 설정.*/
  MyPageReqInfoListForm objParams =new MyPageReqInfoListForm();

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
 RequestInfoDelegate  objReqInfo=null;	/** 요구정보 Delegate */
 CommMakeBoxDelegate  objSche=null; /**위원회 일정 */
 ResultSetHelper objRs=null;				/**요구 목록 */
 ResultSetHelper objScheRs=null;			/** 연도별 위원회 */
 try{
   /** 위원회 일정 */
   objSche=new CommMakeBoxDelegate();
   try{
    objScheRs=new ResultSetHelper(objSche.getCmtScheduleList(objUserInfo.getCurrentCMTList()));
   }catch(Exception e){
    /*
 	objMsgBean.setMsgType(MessageBean.TYPE_INFO);
  	objMsgBean.setStrCode("DSDATA-0021");
  	objMsgBean.setStrMsg("소속기관을 감사하는 위원회가 지정되어있지 않습니다. 관리자에게 문의하세요");
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%
  	return;
  	*/
   }

   /**요구 정보 대리자 New */
   objReqInfo=new RequestInfoDelegate();
   objRs=new ResultSetHelper(objReqInfo.getRecordListWithCmt(objParams));

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
      <!-- pgTit -->
      <div id="pgTit" style="background:url(/images2/foundation/stl_bg_my.jpg) no-repeat left top;">
        <h3>나의페이지 <!-- <span class="sub_stl" >- 상세보기</span> --></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> > 나의페이지 > 나의 자료 요구제출 > 요구목록</div>
			<p><!--문구--></p>
      </div>
      <!-- /pgTit -->

      <!-- contents -->

      <div id="contents">

        <!-- 각페이지 내용 -->

        <div class="myP">

          <!-- 검색창 -->

          <!-- /검색창  -->
<%
   if(objScheRs!=null && objScheRs.getRecordSize()>0){//위윈회 일정이 있을 경우만 보여줌.
%>
         <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
            <thead>
              <tr>
                <th scope="col">NO</th>
                <th scope="col" style="width:300px; ">위원회</th>
                <th scope="col">요구일정</th>
                <th scope="col">제출시작일</th>
                <th scope="col">제출마감일</th>
              </tr>
            </thead>
            <tbody>
			<%
			  int intRecordNumber=objScheRs.getRecordSize();
			  while(objScheRs.next()){
			 %>
              <tr>
                <td><%=intRecordNumber%></td>
                <td style="text-align:left;"><%=objScheRs.getObject("ORGAN_NM")%></td>
                <td><%=StringUtil.substring((String)objScheRs.getObject("REQNM"),30)%></td>
                <td><%=StringUtil.getDate((String)objScheRs.getObject("ACPT_BGN_DT"))%></td>
                <td><%=StringUtil.getDate((String)objScheRs.getObject("ACPT_END_DT"))%></td>
              </tr>
			  	<%
						intRecordNumber --;
					}//endwhile
				%>
            </tbody>
          </table>
<%
  }//endif 위원회 일정 유무 체크 끝.
%>

          <!-- list -->
          <span class="list01_tl">
		  <form name="formName" method="<%=nads.lib.reqsubmit.EnvConstants.FORM_METHOD%>" action="<%=request.getRequestURI()%>">
          <select onChange="formName.submit()" name="ReqBoxTp" class="select_mypage">
            <option selected="selected" value="">전체</option>
				<%
                   if(!objUserInfo.getOrganGBNCode().equals("004")){//위원회가 아니면 보임.
                  %>
                  	<OPTION value="<%=CodeConstants.REQ_BOX_TP_MEM%>" <%=StringUtil.getSelectedStr(objParams.getParamValue("ReqBoxTp"),CodeConstants.REQ_BOX_TP_MEM)%>><%=MenuConstants.getReqBoxGeneral(request)%></OPTION>
                  <%
                   }//endif 위원회 아님 보임.
                   %>
                  <%
                   if(objUserInfo.getOrganGBNCode().equals("003") || objUserInfo.getOrganGBNCode().equals("004") || objUserInfo.isRequester()==false){// 의원실,위원회 제출기관은 보임.
                  %>
                  	<OPTION value="<%=CodeConstants.REQ_BOX_TP_CMT%>" <%=StringUtil.getSelectedStr(objParams.getParamValue("ReqBoxTp"),CodeConstants.REQ_BOX_TP_CMT)%>><%=MenuConstants.REQUEST_BOX_COMM%></OPTION>
                  	<OPTION value="<%=CodeConstants.REQ_BOX_TP_PRE%>" <%=StringUtil.getSelectedStr(objParams.getParamValue("ReqBoxTp"),CodeConstants.REQ_BOX_TP_PRE)%>><%=MenuConstants.REQUEST_BOX_PRE%></OPTION>
                  <%
                   }//endif 의원실, 위원회만 보임.
                  %>
          </select>요구 목록

<!--   개발 내용이 없음 건수 및 페이지 수량
		  <span class="list_total">&bull;&nbsp;전체자료수 : 20개 (1/2 page)</span></span>
-->

          <span class="list_total"></span></span>
          <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
            <thead>
              <tr>
                <th scope="col">NO</th>
                <th scope="col" style="width:300px; ">요구제목</th>
                <th scope="col">
				<%
					if (CodeConstants.ORGAN_GBN_ASM.equalsIgnoreCase((String)objUserInfo.getOrganGBNCode()) || CodeConstants.ORGAN_GBN_BUD.equalsIgnoreCase((String)objUserInfo.getOrganGBNCode())) {
						out.println("요구기관");
					} else {
						out.println("위원회");
					}
				%>
				</th>
                <th scope="col"><%=(objParams.isRequester())? "제출기관":"요구기관"%></th>
                <th scope="col">답변</th>
                <th scope="col"><%=(objParams.isRequester())? "최종답변일":"최종요구일"%><img src="/images2/btn/bt_td.gif" width="11" height="11" alt="" /></th>
              </tr>
            </thead>
            <tbody>
	<%
	   if(objRs.getRecordSize()>0){//요구목록이 있는 경우.
	%>
				<%
				  int intRecordNumber=objRs.getRecordSize();
				  while(objRs.next()){
				 %>
              <tr>
                <td><%=intRecordNumber%></td>
                <td style="text-align:left;"><a href="<%=RequestInfoDelegate.getGotoLink(objParams.isRequester(),objRs.getObject("REQ_BOX_ID"),objRs.getObject("REQ_BOX_TP"),objRs.getObject("REQ_ID"),objRs.getObject("AUDIT_YEAR"),objRs.getObject("CMT_ORGAN_ID"),objRs.getObject("REQ_ORGAN_ID"))%>">
				<%=StringUtil.substring((String)objRs.getObject("REQ_CONT"),25)%>
				</a></td>
                <td><%=objRs.getObject("CMT_ORGAN_NM")%></td>
                <td><%=(objParams.isRequester())? objRs.getObject("SUBMT_ORGAN_NM"): objRs.getObject("REQ_ORGAN_NM")%></td>
                <td><%=nads.lib.reqsubmit.util.DBAccessUtil.makeAnsInfoHtml((String)objRs.getObject("ANS_ID"),(String)objRs.getObject("ANS_MTD"),(String)objRs.getObject("ANS_OPIN"),(String)objRs.getObject("SUBMT_FLAG"),objUserInfo.isRequester())%></td>
                <td><%=StringUtil.getDate((String)((objParams.isRequester())? objRs.getObject("LAST_ANS_DT"):objRs.getObject("LAST_REQ_DT")))%></td>
              </tr>
			  			<%
							    intRecordNumber --;
							}//endwhile
						%>
						<%
							}else{//요구목록 없으면..
						%>
						<tr>
                <td>등록된 요구정보가 없습니다.</td>
              </tr>
						<%
						   }//endif 요구목록 유무 체크 끝.
						%>
			 </tbody>

          </table>
          <!-- /list -->
          <!-- /각페이지 내용 -->
        </div>
        <!-- /contents -->
        </form>
      </div>
    </div>
  </div>
  <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>