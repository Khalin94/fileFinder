<%@ page language="java" contentType="text/html;charset=EUC-KR" %>

<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.pf.util.PageCount"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.lib.reqsubmit.params.requestbox.SMemReqBoxListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.SMemReqBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.MemRequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.RequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.common.page.PagingDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<jsp:include page="/inc/header.jsp" flush="true"/>

<link href="/css2/style.css" rel="stylesheet" type="text/css">

</head>

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
	String strSelectedAuditYear= null;
	String strSelectedReqOrganID = null;
	String strDaesuInfo = StringUtil.getEmptyIfNull(request.getParameter("DaeSu"));
	String strDaeSuCh = StringUtil.getEmptyIfNull(request.getParameter("DAESUCH"));
	String strSubmtOrganId = StringUtil.getEmptyIfNull(request.getParameter("submtOrganId2"));
	String strOrganId = null;

	if(strSubmtOrganId.equals("")){
		strOrganId = objUserInfo.getOrganID();
	}else{
		strOrganId = strSubmtOrganId;
	}


	String strDaesu = null;
	String strStartdate = null;
	String strEnddate = null;

	SMemReqBoxDelegate selfDelegate = null;
	MemRequestBoxDelegate objReqBox=null;
	RequestBoxDelegate objReqBoxDelegate = null;
	SMemReqBoxListForm paramForm = new SMemReqBoxListForm();
	paramForm.setParamValue("SubmtOrganID", strSubmtOrganId); // '제출기관' 이므로
	paramForm.setParamValue("ReqBoxStt", CodeConstants.REQ_BOX_STT_006); // '제출기관의 작성 중' 이므로

	// 비전자 관련 설정 시작
	//paramForm.setParamValue("ReqBoxTp", "005");

	if(((String)paramForm.getParamValue("ReqBoxSortField")).equals("last_req_doc_snd_dt")){
		paramForm.setParamValue("ReqBoxSortField", "last_req_doc_snd_dt");
	}
	// 비전자 관련 설정 끝

	boolean blnCheckParam = false;
	blnCheckParam = paramForm.validateParams(request);

	if(!blnCheckParam) {
		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
		objMsgBean.setStrCode("DSPARAM-0000");
		objMsgBean.setStrMsg(paramForm.getStrErrors());
		out.println("ParamError:" + paramForm.getStrErrors());
	  	return;
	}

	ResultSetHelper rsHelper = null;
	ResultSetHelper objRsAuditYear = null;
	ResultSetHelper objRsReqOrgan = null;
	ResultSetHelper objDaeRs=null;
	ResultSetHelper objSubmtRs=null;

	try {
		objReqBoxDelegate = new RequestBoxDelegate();
		strSelectedAuditYear = paramForm.getParamValue("AuditYear");
		strSelectedReqOrganID = paramForm.getParamValue("ReqOrganID");

		objDaeRs = new ResultSetHelper(objReqBoxDelegate.getOrganDaesu(strOrganId));
		List lst = objReqBoxDelegate.getSubmtOrganList(objUserInfo.getOrganID());
		objSubmtRs = new ResultSetHelper(lst);
		if(strDaesuInfo.equals("")){
			if(objDaeRs != null){
				if(objDaeRs.next()){
					strDaesu = (String)objDaeRs.getObject("DAE_NUM");
					strStartdate = (String)objDaeRs.getObject("START_DATE");
					strEnddate = (String)objDaeRs.getObject("END_DATE");
					objDaeRs.first();
				}
			}
		}else{
			String[] strDaesuInfos = StringUtil.split("^",strDaesuInfo);
			strDaesu = strDaesuInfos[0];
			strStartdate = strDaesuInfos[1];
			strEnddate = strDaesuInfos[2];

		}


		Hashtable objhashdata = new Hashtable();

		objhashdata.put("START_DATE",strStartdate);
		objhashdata.put("END_DATE",strEnddate);
		objhashdata.put("SUBMTORGANIDZ",lst);

		selfDelegate = new SMemReqBoxDelegate();
		objReqBox=new MemRequestBoxDelegate();

		//전자+비전자
		Hashtable objaaa = (Hashtable)selfDelegate.getSOpRecordDaeList(paramForm,objhashdata);

		rsHelper = new ResultSetHelper(objaaa);
		objRsAuditYear = new ResultSetHelper(selfDelegate.getAuditYearDaeList(lst,strSubmtOrganId,strStartdate,strEnddate,CodeConstants.REQ_BOX_STT_006));
		objRsReqOrgan = new ResultSetHelper(selfDelegate.getReqOrganDaeList(paramForm,objhashdata));

	} catch(AppException e) {
		e.printStackTrace();
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		objMsgBean.setStrCode(e.getStrErrCode());
		objMsgBean.setStrMsg(e.getMessage());
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
  		return;
 	}

	// 요구함 목록조회된 결과 반환.
	int intTotalRecordCount = rsHelper.getTotalRecordCount();
	int intCurrentPageNum = rsHelper.getPageNumber();
	int intTotalPage = rsHelper.getTotalPageCount();

%>

<script language="javascript">

	var form;

	/** 정렬방법 바꾸기 */
	function changeSortQuery(sortField, sortMethod){
		form = document.listqry;
  		form.ReqBoxSortField.value = sortField;
  		form.ReqBoxSortMtd.value = sortMethod;
		form.DAESUCH.value = "N";
  		form.submit();
  	}

  	/** 요구함 상세보기로 가기 */
  	function gotoDetail(strID, strReqBoxTP){
  		form = document.listqry;
  		form.ReqBoxID.value = strID;
		if(strReqBoxTP == '전자'){
			form.action="SMakeReqBoxVList.jsp";
		}else if(strReqBoxTP == '비전자'){
			form.action="../15_make/SMakeOpReqBoxVList.jsp";
		}
  		form.submit();
  	}

  	/** 페이징 바로가기 */
  	function goPage(strPage){
  		form = document.listqry;
  		form.ReqBoxPage.value=strPage;
		form.DAESUCH.value = "N";
  		form.submit();
  	}

	function doRefresh() {
		var f = document.listqry;
		f.DAESUCH.value = "N";
		f.target = "";
		f.submit();
	}

	function changeDaesu(){
		form = document.listqry;
		form.target = '';
		form.DAESUCH.value = "Y";
		form.submit();
	}

    // 손성제 2012.2.13
    // 변경된 업로드 컴포넌트 에러시 AllInOne-> AllInOne_old//AllInOne_old-> AllInOne 변경
    // 신버전 파일 업로드
	function AllInOne(){

		var w = 800;
		var h = 700;
		var winl = (screen.width - w) / 2;
		var winh = (screen.height - h) / 2;
		var url = "/reqsubmit/common/AnsInfoWriteAllInOne.jsp";	window.open(url,'New','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=no,width='+w+',height='+h+',left='+winl+',top='+winh);
	}
    // 구버전 파일 업로드
	function AllInOne_old(){

	    var w = 800;
		var h = 700;
		var winl = (screen.width - w) / 2;
		var winh = (screen.height - h) / 2;
		var url = "/reqsubmit/common/AnsInfoWriteAllInOne_old.jsp";	window.open(url,'New','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=no,width='+w+',height='+h+',left='+winl+',top='+winh);
	}
	function AllInOne2(){
		var w = 800;
		var h = 700;
		var winl = (screen.width - w) / 2;
		var winh = (screen.height - h) / 2;
		var url = "/reqsubmit/common/ReqInfoWriteAllInOne.jsp";	window.open(url,'New','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=no,width='+w+',height='+h+',left='+winl+',top='+winh);
	}
	// 답변서 발송
	function sendAnsDoc(str) {
		var f = document.listqry;
		f.action = "/reqsubmit/common/AnsOpDocSend.jsp?ReqBoxID="+str;
		f.target = "popwin";
		NewWindow('/blank.html', 'popwin', '470', '300');
		f.submit();
	}

	// 답변서 발송을 할 때 등록된 답변이 하나라도 없으면 발송을 못한다는 메세지를 보여준다.
  	function alertSendAnsDocMessage() {
  		alert("답변이 등록되지 않은 요구가 있습니다.\n확인 후 다시 시도해 주시기 바랍니다.");
  	}
</script>
<%
	// 2005-08-09 kogaeng ADD
	// 요구함 작성 메뉴 때문에 불가피하게 추가
	String strAddScript = "";
	String strAutoPopup = StringUtil.getEmptyIfNull(request.getParameter("AutoPopup"));
	if("Y".equalsIgnoreCase(strAutoPopup)) strAddScript = "AllInOne_old();";
%>



<body onload="<%= strAddScript %>">
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
      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3>작성중요구함</h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> > 자료요구 > 국회 자료 요구 > 요구함조회 > 작성중요구함</div>
        <p><!--문구--></p>
      </div>
      <!-- /pgTit -->

      <!-- contents -->

<form name="listqry" method="post" action="<%=request.getRequestURI()%>" style="margin:0px">
			<input type="hidden" name="DAESUCH" value="">
      <div id="contents">

        <!-- 검색조건 없는 경우 아래 div 삭제 나 주석으로 막으세요.-->
        <div class="schBox">
          <p>요구자료조회</p>
          <span class="line"><img src="/images2/foundation/search_line.gif" width="172" height="3" /></span>
          <div class="box">
            <!-- 기존의 검색 셀렉트와 버튼만 넣으세요-->
            <select onChange="changeDaesu()" name="DaeSu">
				 <%
					if(objDaeRs != null){
						while(objDaeRs.next()){
							String str = objDaeRs.getObject("DAE_NUM")+"^"+objDaeRs.getObject("START_DATE")+"^"+objDaeRs.getObject("END_DATE");
				%>
						<option value="<%=objDaeRs.getObject("DAE_NUM")%>^<%=objDaeRs.getObject("START_DATE")%>^<%=objDaeRs.getObject("END_DATE")%>" <%if(str.equals(strDaesuInfo)){%>selected<%}%>><%=objDaeRs.getObject("DAE_NUM")%>대</option>
				<%
						}
					}
				%>
            </select>
            <select onChange="javascript:doRefresh()" name="AuditYear">
              <option selected="selected" value="">전체</option>
				  <%
					if(objRsAuditYear != null && objRsAuditYear.getTotalRecordCount() > 0) {
						String strSelected1 = "";
						while(objRsAuditYear.next()) {
							if(strSelectedAuditYear.equals((String)objRsAuditYear.getObject("AUDIT_YEAR"))) strSelected1 = " selected";
							else strSelected1 = "";
							out.println("<option value="+(String)objRsAuditYear.getObject("AUDIT_YEAR")+strSelected1+">"+(String)objRsAuditYear.getObject("AUDIT_YEAR")+"</option>");
						}
					}
				%>
            </select>&nbsp;년도
            <%
				if(objSubmtRs.getTotalRecordCount() < 2){
			%>
			<%
				}else{
			%>
            <select onChange="javascript:doRefresh()" name="submtOrganId2">
              <option value="">전체</option>
			  <%
				while(objSubmtRs.next()){
			  %>
			  <option value="<%=objSubmtRs.getObject("ORGAN_ID")%>"
			<%
			 if(strSubmtOrganId.equals(objSubmtRs.getObject("ORGAN_ID"))){
			%>
				selected
			<%
			}%>
			><%=objSubmtRs.getObject("ORGAN_NM")%></option>
			<%}%>
            </select>
			<%
				}
			%>
            <select onChange="javascript:doRefresh()" name="ReqOrganID">
              <option value="">:::: 전체 요구기관 ::::</option>
              <%
				if(objRsReqOrgan.getTotalRecordCount() < 1) {
					out.println("<option value=''>::: 요구기관이 없습니다 :::</option>");
				}
				String strSelected2 = "";
				while(objRsReqOrgan.next()) {
					if(strSelectedReqOrganID.equalsIgnoreCase((String)objRsReqOrgan.getObject("REQ_ORGAN_ID"))) strSelected2 = " selected";
					else strSelected2 = "";
					out.println("<option value="+(String)objRsReqOrgan.getObject("REQ_ORGAN_ID")+strSelected2+">"+(String)objRsReqOrgan.getObject("REQ_ORGAN_NM")+"</option>");
				}
			%>
            </select>요구함 목록

<!-- 해당 내용이 없음.
            <select onChange="this.form.submit()" name="RltdDuty">
              <option selected="selected" value="">업무구분(전체)</option>
              <option value="006">법안</option>
              <option value="003">예산안</option>
              <option value="004">결산</option>
              <option value="005">기금</option>
              <option value="001">국정감사</option>
              <option value="002">국정조사</option>
              <option value="007">기타(임시회 등)</option>
            </select>
            <a href="#"><img src="/images2/btn/bt_search2.gif" width="50" height="22" /></a> </div>
-->

        </div>
        <!-- /검색조건-->

        <!-- 각페이지 내용 -->

        <!-- list -->

        <span class="list_total">&bull;&nbsp;전체자료수 : <%=intTotalRecordCount%>개 (<%=intCurrentPageNum%> / <%=intTotalPage%> Page)</span>

<%
	// 정렬 정보 받기.
	String strReqBoxSortField = paramForm.getParamValue("ReqBoxSortField");
	String strReqBoxSortMtd = paramForm.getParamValue("ReqBoxSortMtd");
%>
					<input type="hidden" name="ReqBoxSortField" value="<%= strReqBoxSortField %>">
					<input type="hidden" name="ReqBoxSortMtd" value="<%= strReqBoxSortMtd %>">
					<input type="hidden" name="ReqBoxPage" value="<%= intCurrentPageNum %>">
					<input type="hidden" name="ReqBoxID" value="<%= "" %>">


        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
          <thead>
            <tr>
			  <th scope="col"><a>No<a/>
			  </th>
              <th scope="col">
				<%=SortingUtil.getSortLink("changeSortQuery", "REQ_BOX_TP", strReqBoxSortField, strReqBoxSortMtd, "전자구분")%>
			  </th>
              <th scope="col" style="width:230px; ">
				<%=SortingUtil.getSortLink("changeSortQuery", "REQ_BOX_NM", strReqBoxSortField, strReqBoxSortMtd, "요구함명")%>
			  </th>
              <th scope="col">
				<%=SortingUtil.getSortLink("changeSortQuery", "REQ_ORGAN_NM", strReqBoxSortField, strReqBoxSortMtd, "요구기관")%>
			  </th>
              <th scope="col">
				<%=SortingUtil.getSortLink("changeSortQuery", "RLTD_DUTY", strReqBoxSortField, strReqBoxSortMtd, "업무구분")%>
			  </th>
              <th scope="col">
				<%=SortingUtil.getSortLink("changeSortQuery", "LAST_REQ_DOC_SND_DT", strReqBoxSortField, strReqBoxSortMtd, "수신일시")%>/
				<%=SortingUtil.getSortLink("changeSortQuery", "REG_DT", strReqBoxSortField, strReqBoxSortMtd, "등록일시")%>
			  </th>
              <th scope="col"><a>답변/요구</a></th>
			  <th scope="col"><a>답변발송</a></th>
            </tr>
          </thead>
          <tbody>
			  <%
					int intRecordNumber = intTotalRecordCount - ((intCurrentPageNum -1) * Integer.parseInt((String)paramForm.getParamValue("ReqBoxPageSize")));
					if(rsHelper.getRecordSize() > 0) {
						String strReqBoxID = "";
						String strFstQryDt = "";
						while(rsHelper.next()) {
							strReqBoxID = (String)rsHelper.getObject("REQ_BOX_ID");
							strFstQryDt = (String)rsHelper.getObject("FST_QRY_DT");
							//Hashtable countHash = (Hashtable)selfDelegate.getReqBoxRelateCount(strReqBoxID);

							// 전자, 비전자 문서구분 필드
							String strReqBoxTP = "";
							if("001".equals((String)rsHelper.getObject("REQ_BOX_TP"))){
								strReqBoxTP = "전자";
							}else if("005".equals((String)rsHelper.getObject("REQ_BOX_TP"))){
								strReqBoxTP = "비전자";
							}

							// 답변발송 버튼
							int intTotalAnsCount = selfDelegate.checkReqInfoAnsIsNull(strReqBoxID);
							String strAnsDocURL = "";
							if (intTotalAnsCount == 0) {
								strAnsDocURL = "javascript:sendAnsDoc('"+strReqBoxID+"')";
							} else {
								strAnsDocURL = "javascript:alertSendAnsDocMessage()";
							}
				%>
            <tr>
              <td style="text-align:center;">
				<%= intRecordNumber %></a>
			  </td>
              <td><%=strReqBoxTP %></td>
              <td><%if(strFstQryDt.equals("")||strFstQryDt == null){%><b><%}%><a href="javascript:gotoDetail('<%=strReqBoxID%>','<%=strReqBoxTP %>')"><%= (String)rsHelper.getObject("REQ_BOX_NM") %></a><%if(strFstQryDt.equals("")||strFstQryDt == null){%></b><%}%>
			  </td>
              <td><%= (String)rsHelper.getObject("REQ_ORGAN_NM") %></td>
              <td><%= objCdinfo.getRelatedDuty((String)rsHelper.getObject("RLTD_DUTY")) %></td>
              <td>
					<%if("001".equals((String)rsHelper.getObject("REQ_BOX_TP"))){ %>
						<%= StringUtil.getDate2((String)rsHelper.getObject("LAST_REQ_DOC_SND_DT")) %>
					<%}else if("005".equals((String)rsHelper.getObject("REQ_BOX_TP"))){ %>
						<%= StringUtil.getDate2((String)rsHelper.getObject("REG_DT")) %>
					<%} %>
			  </td>
              <td>
				<%= (String)rsHelper.getObject("SUBMT_CNT") %> / <%= (String)rsHelper.getObject("REQ_CNT") %>
			  </td>
			  <td>
      			  <%if("005".equals((String)rsHelper.getObject("REQ_BOX_TP"))){ %>
						<img src="/image/reqsubmit/bt_sendAnswer7.gif" style="cursor:hand" onclick="<%=strAnsDocURL%>">
				  <%} %>
			  </td>
			  <td></td>
            </tr>
				<%
                    				intRecordNumber--;
								} // endofwhile
							} else {
				%>
				<tr>
					<td colspan="7" height="40" align="center">등록된 요구함이 없습니다.</td>
				</tr>
				<%
						} // end if
				%>
          </tbody>
        </table>
		<br/>
		<span style="color:red;">* 전자문서 : 수신일시 참고<br/>* 비전자문서 : 등록일시 참고</span>
		 <div class="t_right">
			 <span class="list_bt"><a href="javascript:AllInOne_old();")">비전자문서 요구자료등록</a></span>
		 </div>

        <!-- /list -->



        <!-- 페이징-->
<!--
			<a href="#">
					<%= PageCount.getLinkedString(
						new Integer(intTotalRecordCount).toString(),
						new Integer(intCurrentPageNum).toString(),
						paramForm.getParamValue("ReqBoxPageSize"))
					%>
			</a>
-->
		<table  align="center">
              <tr>
                <td height="35" align="center">
                	<!-----------------------------------------  페이징 네비게이션 ---------------------------------------->



					<%=objPaging.pagingTrans(PageCount.getLinkedString(
							new Integer(intTotalRecordCount).toString(),
							new Integer(intCurrentPageNum).toString(),
							paramForm.getParamValue("ReqBoxPageSize"))) %>

                </td>
              </tr>
		</table>

          <p class="warning">* 요구서를 발송하게 되면 해당 제출 기관 대표 담당자에게 지정 발송되며, 담당자가 없는 경우는 작성 중 요구함에 그대로 남아있게 됩니다.  </p>
          <p class="warning">* 요구서 발송 버튼을 이용하시기 위해서는 위원회를 선택해 주시기 바랍니다.  </p>



        <!-- 리스트 버튼-->
        <div id="btn_all" >        <!-- 리스트 내 검색 -->
        <div class="list_ser" >
		<% String strReqBoxQryField = paramForm.getParamValue("ReqBoxQryField"); %>
        <select name="ReqBoxQryField" class="selectBox5"  style="width:70px;" >
            <option <%=(strReqBoxQryField.equalsIgnoreCase("req_box_nm"))? " selected ": ""%>value="req_box_nm">요구함명</option>
            <option <%=(strReqBoxQryField.equalsIgnoreCase("regr_nm"))? " selected ": ""%>value="regr_nm">등록자</option>
        </select>
        <input name="ReqBoxQryTerm" value="<%= paramForm.getParamValue("ReqBoxQryTerm") %>" class="li_input"  style="width:100px"/>

		<img src="/images2/btn/bt_list_search.gif"  onClick="listqry.submit()"/> </div>

        <!-- /리스트 내 검색 --><!-- <span class="right"> <span class="list_bt"><a href="#">요구함작성</a></span> <span class="list_bt"><a href="#">요구함삭제</a></span> <span class="list_bt"><a href="#">위원회명의 요구서발송</a></span></span> </div>
-->
        <!-- /리스트 버튼-->

        <!-- /각페이지 내용 -->
        </div>
</form>
      <!-- /contents -->
    </div>
    </div>
  </div>
  <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>