<%@ page language="java" contentType="text/html;charset=EUC-KR" %>

<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RCommReqBoxVListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.CommRequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.CommRequestInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.CommAnsInfoDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

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
  	//out.println("ParamError:" + objParams.getStrErrors());
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%
  	return;
  }//endif
%>
<%
 /*** Delegate 과 데이터 Container객체 선언 */
 CommRequestBoxDelegate objReqBox=null; 		/**요구함 Delegate*/
 CommRequestInfoDelegate  objReqInfo=null;		/** 요구정보 Delegate */
 CommAnsInfoDelegate objAnsInfo = new CommAnsInfoDelegate();
 ResultSetSingleHelper objRsSH=null;			/** 요구함 상세보기 정보 */
 ResultSetSingleHelper objRsRI=null;			/** 요구 상세보기 정보 */
 ResultSetHelper objRs = null;					/** 답변 목록 */
 String strOrganID = objUserInfo.getOrganID();

 try{
   /**요구함 정보 대리자 New */
   objReqBox=new CommRequestBoxDelegate();
   /**요구함 이용 권한 체크 */
   objRsSH=new ResultSetSingleHelper(objReqBox.getRecord((String)objParams.getParamValue("ReqBoxID")));

   boolean blnHashAuth=objReqBox.checkReqBoxAuth((String)objParams.getParamValue("ReqBoxID"),objUserInfo.getCurrentCMTList()).booleanValue();
   if(!blnHashAuth){
		System.out.println("$$$$$$$2 : "+strOrganID+" 1 "+objRsSH.getObject("OLD_REQ_ORGAN_ID"));
		if(!strOrganID.equals((String)objRsSH.getObject("OLD_REQ_ORGAN_ID")))
{
			System.out.println("$$$$$$$3");
	%>
			<jsp:forward page="/common/message/ViewMsg3.jsp"/>
	<%
			return;
		}else{

	   /** 요구함 정보 */

	   /**요구 정보 대리자 New */
		objReqInfo=new CommRequestInfoDelegate();
		objRsRI=new ResultSetSingleHelper(objReqInfo.getRecord((String)request.getParameter("CommReqID")));
		System.out.println("11111111111");
		// 답변 목록을 SELECT 한다.
		objRs = new ResultSetHelper(objAnsInfo.getRecordList((String)request.getParameter("CommReqID"),"Y"));
	  }/**권한 endif*/
   }else{
		/**요구 정보 대리자 New */
		objReqInfo=new CommRequestInfoDelegate();
		objRsRI=new ResultSetSingleHelper(objReqInfo.getRecord((String)request.getParameter("CommReqID")));
		System.out.println("11111111111");
		// 답변 목록을 SELECT 한다.
		objRs = new ResultSetHelper(objAnsInfo.getRecordList((String)request.getParameter("CommReqID"),"Y"));
   }

 }catch(AppException objAppEx){
 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  	objMsgBean.setStrCode(objAppEx.getStrErrCode());
  	objMsgBean.setStrMsg(objAppEx.getMessage());
  	out.println("<br>Error!!!" + objAppEx.getMessage());
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%
  	return;
 }
%>
<jsp:include page="/inc/header.jsp" flush="true"/>
<script language="javascript">
  	//공개등급 수정페이지로 가기
  	function openCLUp(){
  		form = document.formName;
  		form.action="/reqsubmit/20_comm/20_reqboxsh/ROpenCLProc.jsp";
  		form.submit();
  	}

	// 답변 상세보기로 가기
  	function gotoDetail(strID){
  		window.open('/reqsubmit/common/SAnsInfoView.jsp?returnURL=POPUP&AnsID='+strID, '', 'width=520,height=400, scrollbars=no, resizable=yes, toolbar=no, menubar=no, location=no, directories=no, status=no');
  	}

  	function gotoReqBox(){
  	  	form = document.formName;
  		form.action="./RSendBoxVList.jsp";
  		form.submit();
  	}
</script>
</head>

<body>
<div id="wrap">
  <jsp:include page="/inc/top.jsp" flush="true"/>
  <jsp:include page="/inc/top_menu02.jsp" flush="true"/>
  <div id="container">
    <div id="leftCon">
      <jsp:include page="/inc/log_info.jsp" flush="true"/>
      <jsp:include page="/inc/left_menu02.jsp" flush="true"/>
	<SCRIPT language="JavaScript" src="/js/reqinfo.js"></SCRIPT>
   	<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>
    </div>
    <div id="rightCon">
<form name="formName" method="post" action="">
	<%
		//요구 정보 정렬 정보 받기.
		String strCommReqInfoSortField=objParams.getParamValue("CommReqInfoSortField");
		String strCommReqInfoSortMtd=objParams.getParamValue("CommReqInfoSortMtd");
		//요구함 정보 페이지 번호 받기.
		String strCommReqInfoPagNum=objParams.getParamValue("CommReqInfoPageNum");
	%>
		<input type="hidden" name="CommReqBoxSortField" value="<%=objParams.getParamValue("CommReqBoxSortField")%>"><!--요구함목록정렬필드 -->
		<input type="hidden" name="CommReqBoxSortMtd" value="<%=objParams.getParamValue("CommReqBoxSortMtd")%>"><!--요구함목록정령방법-->
		<input type="hidden" name="CommReqBoxPage" value="<%=objParams.getParamValue("CommReqBoxPage")%>"><!--요구함 페이지 번호 -->
		<input type="hidden" name="CommReqBoxQryField" value="<%=objParams.getParamValue("CommReqBoxQryField")%>"><!--요구함 조회필드 -->
		<input type="hidden" name="CommReqBoxQryTerm" value="<%=objParams.getParamValue("CommReqBoxQryTerm")%>"><!--요구함 조회어 -->
		<input type="hidden" name="ReqBoxID" value="<%=objParams.getParamValue("ReqBoxID")%>">
		<input type="hidden" name="CmtOrganID" value="<%=objParams.getParamValue("CmtOrganID")%>">
		<input type="hidden" name="CommReqInfoSortField" value="<%=strCommReqInfoSortField%>"><!--요구정보 목록정렬필드 -->
		<input type="hidden" name="CommReqInfoSortMtd" value="<%=strCommReqInfoSortMtd%>"><!--요구정보 목록정령방법-->
		<input type="hidden" name="CommReqInfoPage" value="<%=strCommReqInfoPagNum%>"><!--요구정보 페이지 번호 -->
		<input type="hidden" name="CommReqID" value="<%= (String)request.getParameter("CommReqID") %>"><!--요구정보 ID-->
		<input type="hidden" name="ReturnURL" value="<%=request.getRequestURI()%>">
		<input type="hidden" name="AuditYear" value="<%=objParams.getParamValue("AuditYear")%>">
		<input type="hidden" name="RltdDuty" value="<%=objParams.getParamValue("RltdDuty")%>">

      <!-- pgTit -->

             <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=MenuConstants.REQ_BOX_SEND_END%><span class="sub_stl" >- 요구상세보기</span></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.REQUEST_BOX_COMM%> > <%=MenuConstants.REQ_BOX_SEND_END%></div>
        <p><!--문구--></p>
      </div>
      <!-- /pgTit -->

      <!-- contents -->

      <div id="contents">

        <!-- 검색조건 없는 경우 아래 div 삭제 나 주석으로 막으세요.-->
        <!-- /검색조건-->


        <!-- 각페이지 내용 -->
         <!-- list view-->

        <span class="list02_tl">요구 정보 </span>

        <!-- 상단 버튼 시작-->
         <div class="top_btn">
			<samp>
			 <span class="btn"><a href="javascript:viewReqHistory('<%=(String)request.getParameter("CommReqID")%>')">요구 이력 보기</a></span>
			 <span class="btn"><a href="javascript:gotoReqBox();">요구함 보기</a></span>
			 </samp>
		 </div>

        <!-- /상단 버튼 끝-->

        <table border="0" cellspacing="0" cellpadding="0" width="680" class="list02">

            <tr>
                <th height="25">&bull; 요구제목 </th>
                <td height="25" colspan="3"><strong><%=objRsRI.getObject("REQ_CONT")%></strong></td>
            </tr>
            <tr>
                <th height="25">&bull; 요구내용 </th>
                <td height="25" colspan="3">- <%=StringUtil.getDescString((String)objRsRI.getObject("REQ_DTL_CONT"))%> </td>
            </tr>
			<%
				//요구함 진행 상태.
				String strIngStt=(String)objRsSH.getObject("ING_STT");
			%>
            <tr>
                <th height="25">&bull; 요구함명 </th>
                <td height="25" colspan="3"><%=objRsSH.getObject("REQ_BOX_NM")%> </td>
            </tr>
            <tr>
                <th height="25">&bull; 업무구분 </th>
                <td height="25" colspan="3"><%=objCdinfo.getRelatedDuty((String)objRsSH.getObject("RLTD_DUTY"))%> </td>
            </tr>
            <tr>
                <th height="25" width="18%">&bull; 요구기관 </th>
                <td height="25" width="32%"><%=objRsSH.getObject("CMT_ORGAN_NM")%> </td>
                <th height="25" width="18%">&bull;&nbsp;제출기관 </th>
                <td height="25" width="32%"><%=(String)objRsSH.getObject("SUBMT_ORGAN_NM")%> </td>
            </tr>
            <tr>
                <th height="25">&bull; 접수시작 </th>
                <td height="25"><%=StringUtil.getDate((String)objRsSH.getObject("ACPT_BGN_DT"))%></td>
                <th height="25">&bull;&nbsp;접수마감 </th>
                <td height="25"><%=StringUtil.getDate((String)objRsSH.getObject("ACPT_END_DT"))%></td>
            </tr>
			 <tr>
                <th height="25">&bull; 등록일시 </th>
                <td height="25"><%=StringUtil.getDate2((String)objRsSH.getObject("REG_DT"))%></td>
                <th height="25">&bull;&nbsp;제출기한 </th>
                <td height="25"><%=StringUtil.getDate((String)objRsSH.getObject("SUBMT_DLN"))%> 24:00</td>
            </tr>
            <tr>
                <th height="25">&bull; 공개등급 </th>
				<%
				if(objUserInfo.getOrganGBNCode().equals("004")){
				%>
                <td height="25" colspan="3">
					<select name="OpenCL">
						<%
							List objOpenClassList=CodeConstants.getOpenClassList();
							String strOpenClass=(String)objRsRI.getObject("OPEN_CL");
							for(int i=0;i<objOpenClassList.size();i++){
								String strCode=(String)((Hashtable)objOpenClassList.get(i)).get("Code");
								String strValue=(String)((Hashtable)objOpenClassList.get(i)).get("Value");
								out.println("<option value=\"" + strCode + "\"" + StringUtil.getSelectedStr(strOpenClass,strCode) + ">" + strValue + "</option>");
								}
						%>
					</select>
                    <img src="/image/button/bt_save.gif" height="20" style="cursor:hand" onClick="openCLUp();">
				</td>
    			<% } else { %>
				<td height="25" colspan="3">
					<%=CodeConstants.getOpenClass((String)objRsRI.getObject("OPEN_CL"))%>
				</td>
    			<% } %>
            </tr>
            <tr>
                <th height="25">&bull; 제출양식파일 </th>
                <td height="25" colspan="3"><%=StringUtil.makeAttachedFileLink((String)objRsRI.getObject("ANS_ESTYLE_FILE_PATH"),(String)objRsRI.getObject("REQ_ID"))%> </td>
            </tr>
            <tr>
                <th height="25">&bull;&nbsp;신청기관</th>
                <td height="25"><%=objRsRI.getObject("OLD_REQ_ORGAN_NM")%> </td>
                <th height="25">&bull;&nbsp;신청자</th>
                <td height="25"><%=objRsRI.getObject("REGR_NM")%></td>
            </tr>
        </table><br><br>
        <!-- /list view -->
      <!--  <p class="warning mt10">* 요구서 발송 : 의원실(또는 소속기관) 명의로 해당 제출기관에 요구서를 발송합니다.</p>


        <!-- list -->
        <span class="list01_tl">답변목록 <span class="list_total"></span></span>




        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
          <thead>
            <tr>
              <th scope="col" style="width:40%; "><a>제출의견</a></th>
              <th scope="col"><a>답변</a></th>
              <th scope="col"><a>제출자</a></th>
               <th scope="col"><a>제출일</a></th>
            </tr>
          </thead>
          <tbody>
			<%
				if(objRs.getRecordSize() < 1) {
			%>
			<tr>
				<td colspan="4" align="center">제출된 답변정보 가 없습니다.</td>
			</tr>
			<%
				} else {
					while(objRs.next()){
			%>
            <tr>
              <td style="text-align:left;"><a href="javascript:gotoDetail('<%= objRs.getObject("ANS_ID") %>')"><%= objRs.getObject("ANS_OPIN") %></a></td>
              <td><%=nads.lib.reqsubmit.util.DBAccessUtil.makeAnsInfoHtml((String)objRs.getObject("ANS_ID"), (String)objRs.getObject("ANS_MTD")) %></td>
              <td><%= objRs.getObject("ANSR_NM") %></td>
              <td><%= StringUtil.getDate((String)objRs.getObject("ANS_DT")) %></td>
            </tr>
			<%
					} //endwhile
				}
			%>
          </tbody>
        </table>

        <!-- /list -->

        <!-- 페이징
        <span class="paging" > <span class="list_num_on"><a href="#">1</a></span> <span class="list_num"><a href="#">2</a></span> <span class="list_num"><a href="#">3</a></span> <span class="list_num"><a href="#">4</a></span> <span class="list_num"><a href="#">5</a></span> </span>

        <!-- /페이징-->


       <!-- 리스트 버튼
        <div id="btn_all" >        <!-- 리스트 내 검색
        <div class="list_ser" >
          <select name="select" class="selectBox5"  style="width:70px;" >
            <option value="">요구제목</option>
            <option value="">요구내용</option>
          </select>
          <input name="iptName" onKeyDown="return ch()" onMouseDown="return ch()"
		 class="li_input"  style="width:100px"/>
          <img src="/images2/btn/bt_list_search.gif"  onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"/> </div>
        <!-- /리스트 내 검색  <span class="right"> <span class="list_bt"><a href="#">버튼</a></span> </span> </div>

        <!-- /리스트 버튼-->
        <!-- /각페이지 내용 -->
      </div>
      <!-- /contents -->

    </div>
  </div>
  <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>