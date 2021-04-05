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
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.RequestInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.answerinfo.MemAnswerInfoDelegate" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%
	/*
	 세션에 값을 설정했다는 가정하에 출력.
		select usr.user_id,usr.user_nm,organ.organ_id,organ.organ_nm,ORGAN_KIND,REQ_SUBMT_FLAG
		from tbdm_user_Info usr,tbdm_brg_dept dept, tbdm_organ organ
		where usr.user_id=dept.user_id
		and dept.organ_id=organ.organ_id
		and usr.user_id='tester1'
		and org_posi_gbn=1;

	HttpSession objSession=request.getSession();
	//요구자
	objSession.setAttribute("USER_ID","tester1");
	objSession.setAttribute("ORGAN_ID","NI00000001");
	objSession.setAttribute("ORGAN_KIND","003");
	objSession.setAttribute("REQ_SUBMT_FLAG","001");
	objSession.setAttribute("IS_REQUESTER",Boolean.toString(true));
	//제출자

	objSession.setAttribute("USER_ID","tester2");
	objSession.setAttribute("ORGAN_ID","A000000047");
	objSession.setAttribute("ORGAN_KIND","006");
	objSession.setAttribute("REQ_SUBMT_FLAG","002");
	objSession.setAttribute("IS_REQUESTER",Boolean.toString(false));
	*/

%>
<%
 /** 요구 제출자 구분..*/
 boolean blnIsRequester=true;//요구자
 if(request.getSession().getAttribute("IS_REQUESTER").equals("false")){
 	blnIsRequester=false;
 }
 //로그인이용자 기관정보.
 String strOrganID=(String)request.getSession().getAttribute("ORGAN_ID");
%>

<%
 /*************************************************************************************************/
 /** 					파라미터 체크 Part 														  */
 /*************************************************************************************************/

  /**요구정보 상세보기 파라미터 체크.*/
  String strReqInfoIDParam=(String)request.getParameter("ReqInfoID");
  boolean blnParamCheck=false;
  if(StringUtil.isAssigned(strReqInfoIDParam)){
  	blnParamCheck=true;
  }
  if(blnParamCheck==false){
  	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	objMsgBean.setStrCode("DSPARAM-0000");
  	objMsgBean.setStrMsg("요구ID전달 실패");
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
 ResultSetSingleHelper objInfoRsSH=null;	/**요구 정보 상세보기 */
 ResultSetHelper objRs=null;				/** 답변정보 목록 출력*/
 try{
   /**요구 정보 대리자 New */
   objReqInfo=new RequestInfoDelegate();

   /**요구함 이용 권한 체크 */
   System.out.println("111");
   boolean blnHashAuth=objReqInfo.checkReqInfoAuth(strReqInfoIDParam,strOrganID).booleanValue();
   System.out.println("222");

   objInfoRsSH=new ResultSetSingleHelper(objReqInfo.getRecord(strReqInfoIDParam));
   System.out.println("333");

   if(!objInfoRsSH.next()){
      objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	  objMsgBean.setStrCode("DSDATA-0030");
  	  objMsgBean.setStrMsg("요청하신 요구정보가 DB에 존재하지 않습니다.");
	  System.out.println("HERE NOT FOUND!");
	  	%>
	  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
	  	<%
      return;
   }
   if(objInfoRsSH.getObject("OPEN_CL").equals(CodeConstants.OPN_CL_OPEN)){
   	 if(blnHashAuth==false && blnIsRequester){
   	 	blnHashAuth=true;
   	 }
   }
   if(!blnHashAuth){
      objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	  objMsgBean.setStrCode("DSAUTH-0001");
  	  objMsgBean.setStrMsg("해당 요구정보를 볼 권한이 없습니다.");
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%
      return;
   }


   /** 답변 목록 출력 */
   objRs=new ResultSetHelper(new MemAnswerInfoDelegate().getRecordList(strReqInfoIDParam,((blnIsRequester)? "Y":"N")));
 }catch(AppException objAppEx){
 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  	objMsgBean.setStrCode(objAppEx.getStrErrCode());
  	objMsgBean.setStrMsg(objAppEx.getMessage());
  	out.println("<br>Error!!!" + objAppEx.getMessage());
  	%>

  	<%
  	return;
 }
%>

<jsp:include page="/inc/header.jsp" flush="true"/>
</head>
<body>
<div class="popup">
    <p>검색결과상세보기</p>

    <table width="100%" cellpadding="0" cellspacing="0">
        <tr>
            <td width="100%" style="padding:10px;">
				<span class="fonts">검색된 결과중 선택된 요구정보의 상세정보를 확인합니다. </span>
				<br />
				<br />
				<span class="list02_tl">요구정보</span>
				<table border="0" cellspacing="0" cellpadding="0" class="list02">
					<tr>
						<th height="25">&bull;&nbsp;&nbsp;위원회 </th>
						<td height="25" colspan="3"><%=objInfoRsSH.getObject("CMT_ORGAN_NM")%> </td>
					</tr>
					<tr>
						<th height="25">&bull;&nbsp;&nbsp;요구함명 </th>
						<td height="25" colspan="3"><%=objInfoRsSH.getObject("REQ_BOX_NM")%> </td>
					</tr>
					<tr>
						<th height="25">&bull;&nbsp;&nbsp;제출기관 </th>
						<td height="25"><%=(String)objInfoRsSH.getObject("SUBMT_ORGAN_NM")%> </td>
						<th height="25">&bull;&nbsp;&nbsp;요구기관 </th>
						<td height="25"><%=(String)objInfoRsSH.getObject("REQ_ORGAN_NM")%> </td>
					</tr>
					<tr>
						<th height="25">&bull;&nbsp;&nbsp;요구내용 </th>
						<td height="25" colspan="3"><%=StringUtil.getDescString((String)objInfoRsSH.getObject("REQ_CONT"))%></td>
					</tr>
					<tr>
						<th height="25">&bull;&nbsp;&nbsp;요구상세내용 </th>
						<td height="25" colspan="3"><%=StringUtil.getDescString((String)objInfoRsSH.getObject("REQ_DTL_CONT"))%></td>
					</tr>
					<tr>
						<th height="25">&bull;&nbsp;&nbsp;공개등급 </th>
						<td height="25"><%=CodeConstants.getOpenClass((String)objInfoRsSH.getObject("OPEN_CL"))%> </td>
						<th height="25">&bull;&nbsp;&nbsp;제출양식파일 </th>
						<td height="25"><%=StringUtil.makeAttachedFileLink((String)objInfoRsSH.getObject("ANS_ESTYLE_FILE_PATH"),(String)objInfoRsSH.getObject("REQ_ID"))%></td>
					</tr>
					<tr>
						<th height="25">&bull;&nbsp;&nbsp;등록자 </th>
						<td height="25"><%=(String)objInfoRsSH.getObject("REGR_NM")%> </td>
						<th height="25">&bull;&nbsp;&nbsp;등록일자 </th>
						<td height="25"><%=StringUtil.getDate((String)objInfoRsSH.getObject("REG_DT"))%> </td>
					</tr>
				</table>

				<!-- /list --> <br />
				<br />

				<!-- list -->
				<span class="list01_tl">답변 목록 <!--<span class="list_total">&bull;&nbsp;전체자료수 : 20개 (1/2 page)</span>--></span>
				<table border="0" cellspacing="0" cellpadding="0" class="list01">
					<thead>
						<tr>

							<th scope="col">NO</th>
							<th style="width:350px; " scope="col">제출의견</th>
							<th scope="col">작성자</th>
							<th scope="col">공개</th>
							<th scope="col">답변</th>

							<th scope="col">답변일</th>

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
							<td><%=intRecordNumber%></td>
							<td style="text-align:left;"><a href="#"><%=StringUtil.substring((String)objRs.getObject("ANS_OPIN"),35)%></a></td>
							<td><%=(String)objRs.getObject("ANSWER_NM")%></td>

							<td><%=CodeConstants.getOpenClass(((String)objRs.getObject("OPEN_CL")))%></td>
							<td><%=nads.lib.reqsubmit.util.DBAccessUtil.makeAnsInfoHtml(strAnsInfoID,(String)objRs.getObject("ANS_MTD"))%></td>
							<td><%=StringUtil.getDate((String)objRs.getObject("ANS_DT"))%></td>

						</tr>
						<%
							    intRecordNumber ++;
							}//endwhile
						%>
					</tbody>
				</table>

			<!-- /list -->

			</td>
		</tr>
	</table>
    <p style= "height:2px;padding:0;"></p>
    <!-- 리스트 버튼-->
    <div id="btn_all"  class="t_right"><span class="list_bt"><a href="#" onClick="self.close()">창닫기</a></span>&nbsp;&nbsp; </div>

    <!-- /리스트 버튼-->
</div>
</body>
</html>