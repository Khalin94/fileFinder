<%@ page language="java" contentType="text/html;charset=euc-kr" %>

<%@ page import="java.util.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="kr.co.kcc.pf.util.PageCount"%>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.MemRequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.commreqsch.CommMakeBoxDelegate" %>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.params.cmtreqsch.CmtReqSchForm" %>
<%@ page import="nads.dsdm.app.common.page.PagingDelegate" %>
<jsp:include page="/inc/header.jsp" flush="true"/>

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
	CmtReqSchForm objForm = new CmtReqSchForm();

	boolean blnParamCheck = false;
	/**전달된 파리미터 체크 */
	blnParamCheck = objForm.validateParams(request);
	if(blnParamCheck == false){
		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
		objMsgBean.setStrCode("DSPARAM-0000");
		objMsgBean.setStrMsg(objForm.getStrErrors());
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}

	//로그인한 사용자ID를 가져온다.
	String strUserID   = objUserInfo.getUserID();
    String strOrganID = objUserInfo.getOrganID();
    String strKind       = objUserInfo.getOrganGBNCode();
    String strReqSubmitFlag = objUserInfo.getReqSubmitFlag();
    String strIngSttYes = "N";

    //요구년도 ※Delegate 선언※.
    CommMakeBoxDelegate objCommReq = new  CommMakeBoxDelegate();

	//위원실 또는 제출기관 사용자일때 해당 위원회를 찾는다.
    String strSelectedCmtOrganId = StringUtil.getEmptyIfNull(objForm.getParamValue("CmtOrganID"));
    MemRequestBoxDelegate objReqBox = new MemRequestBoxDelegate();
	List objList = objReqBox.getReqrPerYearCMTList(objUserInfo.getOrganID(), CodeConstants.REQ_BOX_STT_003);
    ResultSetHelper objCmtRs = new ResultSetHelper(objList);
	ResultSetHelper objCmtRs2 = new ResultSetHelper(objCommReq.getCmtList(objUserInfo.getOrganID()));
	if (!strKind.equals("004")) {
	    if(StringUtil.isAssigned(strSelectedCmtOrganId)) {
	    	strOrganID = strSelectedCmtOrganId;
	    } else {
			int i=0;
     		while(objCmtRs.next()) {
     			if(i==0) {
					strOrganID = (String)objCmtRs.getObject("CMT_ORGAN_ID");
					//out.println(strOrganID + " : " + (String)objCmtRs.getObject("CMT_ORGAN_NM"));
				}
				i++;
    	 	}
    	}
	}

	ArrayList objCommYear = new ArrayList();
    objCommYear = objCommReq.getCommYearSch(strOrganID);

   	String strYear    = null ;
    String strOrganNm = null ;
   	String strStrDay    = null;
    String strEndDay  = null;

   	strYear    = StringUtil.getEmptyIfNull(objForm.getParamValue("year_cd"));
    strOrganNm = StringUtil.getEmptyIfNull(objForm.getParamValue("organnm"));

   	strStrDay    = StringUtil.getEmptyIfNull(objForm.getParamValue("StartDate"));
    strEndDay  = StringUtil.getEmptyIfNull(objForm.getParamValue("EndDate"));

    if (objCommYear != null) {
		for(int i=0; i < objCommYear.size(); i++){
			Hashtable objAUDIT_YEAR2 = (Hashtable)objCommYear.get(i);
			if(StringUtil.getEmptyIfNull(strYear).equals("")){
				strYear = StringUtil.getEmptyIfNull((String)objAUDIT_YEAR2.get("AUDIT_YEAR"));		//년도
			}//end if

			if(StringUtil.getEmptyIfNull(strOrganNm).equals("")){
				strOrganNm = StringUtil.getEmptyIfNull((String)objAUDIT_YEAR2.get("ORGAN_NM"));		//위원회명
			}//end if
		}
	}

	Calendar now = Calendar.getInstance();
    SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");

	//if (!StringUtil.isAssigned(strYear)) strYear = String.valueOf(now.get(Calendar.YEAR));
	strYear = String.valueOf(now.get(Calendar.YEAR));

    int yyyy = now.get(Calendar.YEAR);
    int MM = now.get(Calendar.MONTH);
    int dd = now.get(Calendar.DATE);


    //초기 조회 정보를 세팅해준다.
    if (!StringUtil.isAssigned(strStrDay)) {
    	String strMonth = String.valueOf(now.get(Calendar.MONTH)-2);
    	if(strMonth.length() == 1) strMonth = "0"+strMonth;
   		strStrDay = strYear+"-"+strMonth+"-01";
        //날짜가 거지같이 나와서 수정
        now.set(yyyy, MM - 3, dd);
        strStrDay = df.format(now.getTime());
        System.out.println("strStrDay"+df.format(now.getTime()));
   		objForm.setParamValue("StartDate", StringUtil.ReplaceString(strStrDay, "-", ""));
	}

    if (!StringUtil.isAssigned(strEndDay)) {
	    String strMonth = String.valueOf(now.get(Calendar.MONTH)+3);
    	if(strMonth.length() == 1) strMonth = "0"+strMonth;
		strEndDay = strYear+"-"+strMonth+"-"+((String.valueOf(now.get(Calendar.DATE)).length() == 1)?"0"+String.valueOf(now.get(Calendar.DATE)):String.valueOf(now.get(Calendar.DATE)));
        //날짜가 거지같이 나와서 수정
        now.set(yyyy, MM + 3, dd);
        strEndDay = df.format(now.getTime());
        System.out.println("strEndDay"+df.format(now.getTime()));
		objForm.setParamValue("EndDate", StringUtil.ReplaceString(strEndDay, "-", ""));
	}

	//진행중인 요구일정이 있는지 확인한다.
	int intResult;
	ArrayList objCommStt = (ArrayList)objCommReq.selectComm_IngStt(strOrganID);
	intResult = objCommStt.size();
  	if (intResult > 0 ){
		strIngSttYes = "Y";
%>
  	   	<input type=hidden name=IngSttYes VALUE="<%=strIngSttYes%>">
<%
	}

    //위원회 목록 조회
    if(strKind.equals("004")) {
    	objForm.setParamValue("CmtOrganID", strOrganID);
    } else {
    	if(StringUtil.isAssigned(strSelectedCmtOrganId)) {
	    	objForm.setParamValue("CmtOrganID", strSelectedCmtOrganId);
	    } else {
	    	objForm.setParamValue("CmtOrganID", strOrganID);
	    }
    }
	ResultSetHelper objRS = new ResultSetHelper(objCommReq.getCommSchFromToList(objForm));

	int intTotalRecordCount = objRS.getTotalRecordCount();
	int intCurrentPageNum = objRS.getPageNumber();
	int intTotalPage = objRS.getTotalPageCount();
%>

<link href="/css2/style.css" rel="stylesheet" type="text/css">
<script language=Javascript src="/js/calendar.js"></script>
<script language=Javascript src="/js/datepicker.js"></script>
<script language="javascript">
function fUsrAction(mode, strStrDay, strEndDay, strOrganId, strOrganNm) {
  switch(mode) {
    case "list" :
         if (!fCheckField()) return false;
      	 form1.submit();
         break;

  }
}

function fUsrActionChk(mode, strYear, strOrganId, strOrganNm) {
  switch(mode) {

    case "insertY" :
         if (!fCheckFieldIns()) return false;
         break;

    case "insertN" :
        form1.action="RCommSchWrite.jsp";
        form1.submit();
  }
}


function fCheckField() {
  with (form1) {
    if (StartDate.value == '' || EndDate.value == '') {
      alert('조회 시작일과 종료일을 모두 선택하세요');
      StartDate.focus();
      return false;
    }

    if ((StartDate.value).replace("-","").replace("-","") > (EndDate.value).replace("-","").replace("-","") ) {
      alert('조회  시작일이 종료일 보다 큽니다.');
      StartDate.focus();
      return false;
    }
  }
  return true;
}

function fCheckFieldIns() {
  with (form1) {
    if (IngSttYes.value == 'Y') {
      alert('접수중인 요구일정이 이미 존재합니다.');
      return false;
    }
  }
  return true;
}

function chgCmtOrgan(str) {
	document.form1.submit();
}

/** 페이징 바로가기 */
  function goPage(strPage){
  	form1.CmtSchPage.value=strPage;
  	form1.submit();
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
    </div>
    <div id="rightCon">
<form name="form1" method="post" action="<%=request.getRequestURI()%>">
			<input type="hidden" name="organid" VALUE="<%=strOrganID%>">
			<input type="hidden" name="organnm" VALUE="<%=strOrganNm%>">
			<input type="hidden" name="year_cd" VALUE="<%=strYear%>">
            <input type="hidden" name="strYear" VALUE="<%=strYear%>">
            <input type="hidden" name="strOrganId" VALUE="<%=strOrganID%>">
            <input type="hidden" name="strOrganNm" VALUE="<%=strOrganNm%>">
			<input type="hidden" name="CmtSchPage" value="<%=intCurrentPageNum%>"><!--페이지 번호 -->

      <!-- pgTit -->

      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=MenuConstants.REQ_BOX_SCH%></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.REQUEST_BOX_COMM%> > <%=MenuConstants.REQ_BOX_SCH %></div>
        <p><!--문구--></p>
      </div>
      <!-- /pgTit -->

      <!-- contents -->

      <div id="contents">

        <!-- 검색조건 없는 경우 아래 div 삭제 나 주석으로 막으세요.-->
        <div class="schBox">
         <!-- <p>요구함조회조건</p>  -->
          <span class="line"><img src="/images2/foundation/search_line.gif" width="172" height="3" /></span>
			  <div class="box">
				<!-- 기존의 검색 셀렉트와 버튼만 넣으세요-->
				<!-- 기존의 검색 셀렉트와 버튼만 넣으세요-->
			<%
				if (strKind.equals("003")) {
			%>
				&bull;&nbsp;위원회 :
				<select onChange="javascript:chgCmtOrgan(this.value)" name="CmtOrganID">
				<%
					String strSelected = "";
					while(objCmtRs2.next()) {
						String strCmtOrganID = (String)objCmtRs2.getObject("ORGAN_ID");
						String strCmtOrganNm = (String)objCmtRs2.getObject("ORGAN_NM");
						if(strCmtOrganID.equalsIgnoreCase(strSelectedCmtOrganId)) strSelected = " selected";
						else strSelected = "";
				%>
					<option value="<%= strCmtOrganID %>"<%= strSelected %>><%= strCmtOrganNm %></option>
				<% } %>
				</select>
			<%
				}
			%>
				&nbsp;
				&bull;&nbsp;시작일 :
<!--				<input OnKeyPress="if ((event.keyCode&lt;48)||(event.keyCode&gt;57)) event.returnValue=false;" OnClick="this.select()" readonly="readonly" maxlength="8" size="10" name="StartDate" value="<%=strStrDay%>"/>
				<a href="#" onClick="javascript:Calendar(form1.StartDate);"><img src="/images2/btn/bt_calender.gif" width="17" height="13" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"/></a>~
				<input onKeyPress="if ((event.keyCode&lt;48)||(event.keyCode&gt;57)) event.returnValue=false;" onClick="this.select()" readonly="readonly" maxlength="8" size="10" name="EndDate" value="<%=strEndDay%>" />
				<a href="#" onClick="javascript:Calendar(form1.EndDate);"><img src="/images2/btn/bt_calender.gif" width="17" height="13" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"  /></a><img src="/images2/btn/bt_search2.gif" width="50" height="22" OnClick="javascript:fUsrAction('list',form1.StartDate.value,form1.EndDate.value, form1.organid.value);" />
	-->			

				<input type="text" class="textfield" name="StartDate" size="10" maxlength="8" value="<%=strStrDay%>"  readonly" >
                <a href="#" OnClick="javascript:show_calendar('form1.StartDate');"><img src="/images2/btn/bt_calender.gif" width="17" height="13" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"/></a> ~
			    <input type="text" class="textfield" name="EndDate" size="10" maxlength="8" value="<%=strEndDay%>" readonly">
			    <a href="#" OnClick="javascript:show_calendar('form1.EndDate');"><img src="/images2/btn/bt_calender.gif" width="17" height="13" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"/></a>

				</div>
        </div>
        <!-- /검색조건-->

        <!-- 각페이지 내용 -->

        <!-- list -->

        <span class="list_total">&bull;&nbsp;전체 일정수 : <%= intTotalRecordCount %>개 (<%=intCurrentPageNum%>/<%=intTotalPage%>  page)</span>


        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
          <thead>
            <tr>
				<th scope="col"><a href="#">NO<a/></td>
				<th scope="col" style="width:200px; "><a href="#">요구일정</a></th>
				<th scope="col" ><a href="#">회기</a></th>
				<th scope="col" ><a href="#">진행상태</a></th>
				<th scope="col" ><a href="#">시작일</a></th>
				<th scope="col"><a href="#">마감일</a></th>
            </tr>
          </thead>
          <tbody>
		<%
			int intRecordNumber = intTotalRecordCount - ((intCurrentPageNum -1) * Integer.parseInt((String)objForm.getParamValue("CmtSchPageSize")));
			if(objRS.getRecordSize() > 0) {
				while(objRS.next()){
						String strReqSchId  = (String)objRS.getObject("REQ_SCHE_ID");
						String strOrderInfo   = (String)objRS.getObject("ORDER_INFO");
						String strNatCnt      = (String)objRS.getObject("NAT_CNT");
						String strReqNm      = (String)objRS.getObject("REQNM");
						String strCdNm        = (String)objRS.getObject("CD_NM");
						String strAcptBgnDt = (String)objRS.getObject("ACPT_BGN_DT");
						String strAcptEndDt = (String)objRS.getObject("ACPT_END_DT");
						String strIngStt        = (String)objRS.getObject("ING_STT");
						strAcptBgnDt = strAcptBgnDt.substring(0, 4) + "-" + strAcptBgnDt.substring(4, 6) + "-" + strAcptBgnDt.substring(6, 8);
						strAcptEndDt = strAcptEndDt.substring(0, 4) + "-" + strAcptEndDt.substring(4, 6) + "-" + strAcptEndDt.substring(6, 8);
		%>
            <tr>
              <td ><%= intRecordNumber %></td>
              <td style="text-align:left; "><a href="RCommSchVList.jsp?ReqSchId=<%=strReqSchId%>"><%=strReqNm%></a></td>
              <td><%=strNatCnt%></td>
              <td><%=strCdNm%></td>
              <td><%=strAcptBgnDt%></td>
              <td><%=strAcptEndDt%></td>
            </tr>
		<%
					intRecordNumber --;
				}//end while
			} else {
		%>
			<tr>
				<td align="center" colspan="6">등록된 요구 일정이 없습니다.</td>
			</tr>
		<%
			}//end if 목록 출력 끝.
		%>
          </tbody>
        </table>

        <!-- /list -->



        <!-- 페이징-->
			<%=objPaging.pagingTrans(PageCount.getLinkedString(
				new Integer(intTotalRecordCount).toString(),
				new Integer(intCurrentPageNum).toString(),
				objForm.getParamValue("CmtSchPageSize")))
			%>

         <!-- /페이징-->
        <!--  <p class="warning">* 요구서를 발송하게 되면 해당 제출 기관 대표 담당자에게 지정 발송되며, 담당자가 없는 경우는 작성 중 요구함에 그대로 남아있게 됩니다.  </p>
          <p class="warning">* 요구서 발송 버튼을 이용하시기 위해서는 위원회를 선택해 주시기 바랍니다.  </p>  -->



        <!-- 리스트 버튼
        <div id="btn_all" >        <!-- 리스트 내 검색
        <div class="list_ser" >
          <select name="select" class="selectBox5"  style="width:70px;" >
            <option value="">요구함명</option>
            <option value="">요구함설명</option>
            <option value="">요구기관</option>
          </select>
          <input name="iptName" onKeyDown="return ch()" onMouseDown="return ch()"
		 class="li_input"  style="width:100px"/>
          <img src="/images2/btn/bt_list_search.gif"  onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"/> </div>
        <!-- /리스트 내 검색 --> <!-- /리스트 버튼-->
<%
     if (strKind.equals("004") & !strReqSubmitFlag.equals("004")) {
%>
			<span class="right">
				<%
					 if (strIngSttYes.equals("Y")) {
				%>
				<span class="list_bt"><a href="#" onclick="javascript:fUsrActionChk('insertY',form1.year_cd.value, form1.organid.value, form1.organnm.value);">요구일정등록</a></span>
				<%
					} else {
				%>
				<span class="list_bt"><a href="#" onclick="javascript:fUsrActionChk('insertN',form1.year_cd.value, form1.organid.value, form1.organnm.value);">요구일정등록</a></span>
				<%
					}
				%>
			</span>
<%	}	%>
		</div>

         <!-- /리스트 버튼-->

        <!-- /각페이지 내용 -->

</form>
      </div>
      <!-- /contents -->

    </div>
  </div>
  <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>