<%@ page language="java" contentType="text/html;charset=EUC-KR" %>

<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.pf.util.PageCount"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RCommSubReqListFormNew" %>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.CommRequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.CommRequestInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.RequestBoxDelegate" %>
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
	//해당위원회가 없을경우.. 에러메세지 출력..
	if(objUserInfo.getCurrentCMTList().isEmpty()){
	  	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
	  	objMsgBean.setStrCode("DSDATA-0021");
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}

	/*************************************************************************************************/
	/** 					파라미터 체크 Part 														  */
	/*************************************************************************************************/
	//로그인 사용자 정보를 가져온다. 권한없음 경우 관람만 가능하다.
	String strReqSubmitFlag = objUserInfo.getReqSubmitFlag();

	/**선택된 감사년도와 선택된 위원회ID*/
	String strSelectedAuditYear= null; /**선택된 감사년도*/
	String strSelectedCmtOrganID=null; /**선택된 위원회ID*/
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

	/**일반 요구함 상세보기 파라미터 설정.*/
	RCommSubReqListFormNew objParams =new RCommSubReqListFormNew();
	objParams.setParamValue("ReqStt",CodeConstants.REQ_STT_NOT);/**제출된요구정보목록.*/
	objParams.setParamValue("SmtOrganID",strOrganId);/**요구기관ID*/
	objParams.setParamValue("CommReqInfoSortField","last_ans_dt");/**최종답변일이 Default*/
	objParams.setParamValue("IsRequester",String.valueOf(objUserInfo.isRequester()));//요구답변자여부설정

	boolean blnParamCheck = false;
	/**전달된 파리미터 체크 */
	blnParamCheck = objParams.validateParams(request);
	if(blnParamCheck == false) {
	  	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
	  	objMsgBean.setStrCode("DSPARAM-0000");
	  	objMsgBean.setStrMsg(objParams.getStrErrors());
	  	//out.println("ParamError:" + objParams.getStrErrors());
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}

	strSelectedAuditYear= objParams.getParamValue("AuditYear"); /**선택된 감사년도*/
	strSelectedCmtOrganID=objParams.getParamValue("CmtOrganID") ; /**선택된 위원회ID*/

	/*************************************************************************************************/
	/** 					데이터 호출 Part 														  */
	/*************************************************************************************************/

	/*** Delegate 과 데이터 Container객체 선언 */
	CommRequestBoxDelegate objReqBox = null; 		/**요구함 Delegate*/
	CommRequestInfoDelegate  objReqInfo = null;	/** 요구정보 Delegate */
	RequestBoxDelegate objReqBoxDelegate = null;

	ResultSetHelper objRs=null;				/**요구 목록 */
	ResultSetHelper objCmtRs=null;			/** 연도별 위원회 */
	ResultSetHelper objDaeRs=null;
	ResultSetHelper objSubmtRs=null;
	ResultSetHelper objYearRs=null;

	try{
		/**요구함 정보 대리자 New */
		objReqBox=new CommRequestBoxDelegate();
		objReqBoxDelegate = new RequestBoxDelegate();
		objDaeRs = new ResultSetHelper(objReqBoxDelegate.getOrganDaesu(strOrganId));
		List lst = (List)objReqBoxDelegate.getSubmtOrganList(objUserInfo.getOrganID());
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

		objReqInfo = new CommRequestInfoDelegate();

		objCmtRs = new ResultSetHelper(objReqInfo.getCmtOrganDaeList(objParams,objhashdata));
		objYearRs =  new ResultSetHelper(objReqInfo.getAuditYearDaeList(lst,strSubmtOrganId,strStartdate,strEnddate,CodeConstants.REQ_STT_NOT));

		/**요구 정보 대리자 New */

		objRs = new ResultSetHelper(objReqInfo.getRecordSubList(objParams,objhashdata));
	} catch(AppException objAppEx) {
	 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
	  	objMsgBean.setStrCode(objAppEx.getStrErrCode());
	  	objMsgBean.setStrMsg(objAppEx.getMessage());
	  	//out.println("<br>Error!!!" + objAppEx.getMessage());
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}

	/**요구정보 목록조회된 결과 반환.*/
	int intTotalRecordCount = objRs.getTotalRecordCount();
	int intCurrentPageNum = objRs.getPageNumber();
	int intTotalPage = objRs.getTotalPageCount();
%>
<jsp:include page="/inc/header.jsp" flush="true"/>
<link href="/css2/style.css" rel="stylesheet" type="text/css">
<script language="javascript">

  /** 정렬방법 바꾸기 */
  function changeSortQuery(sortField,sortMethod){
  	formName.CommReqInfoSortField.value=sortField;
  	formName.CommReqInfoSortMtd.value=sortMethod;
	formName.DAESUCH.value = "N";
  	formName.submit();
  }

  //요구상세보기로 가기.
  function gotoDetail(strBoxID, strID){
  	formName.ReqBoxID.value=strBoxID;
  	formName.CommReqID.value=strID;
  	formName.action="./SNonReqInfo.jsp";
  	formName.submit();
  }

  /** 페이징 바로가기 */
  function goPage(strPage){
  	formName.CommReqInfoPage.value=strPage;
	formName.DAESUCH.value = "N";
  	formName.submit();
  }

  /**년도와 위원회로만 조회하기 */
  function gotoHeadQuery(){
  	formName.CommReqInfoQryField.value="";
  	formName.CommReqInfoQryTerm.value="";
  	formName.CommReqInfoSortField.value="";
  	formName.CommReqInfoSortMtd.value="";
  	formName.CommReqInfoPage.value="";
	formName.DAESUCH.value = "N";
  	formName.submit();
  }

  /** 요구함 상세 보기로 이동 */
  function gotoReqBoxInfoView(strReqBoxStt, strReqBoxID) {
	formName.ReqBoxID.value = strReqBoxID;
  	if (strReqBoxStt == "<%= CodeConstants.REQ_BOX_STT_006 %>") { // 발송완료
  		formName.action= "/reqsubmit/20_comm/20_reqboxsh/SCommReqBoxVList.jsp";
  	} else if (strReqBoxStt == "<%= CodeConstants.REQ_BOX_STT_007 %>") { // 제출완료
  		formName.action= "/reqsubmit/20_comm/20_reqboxsh/40_subend/SSubEndBoxVList.jsp";
  	}
	formName.target = "_self";
  	formName.submit();
  }

  function changeDaesu(){
	formName.target = '';
    formName.AuditYear.value = "";
    formName.CmtOrganID.value = "";
	formName.DAESUCH.value = "Y";
	formName.submit();
 }

 function doRefresh() {
	formName.DAESUCH.value = "N";
	formName.target = "";
	formName.submit();
}
</script>
</head>

<body>
<div id="wrap">
  <jsp:include page="/inc/top.jsp" flush="true"/>
  <jsp:include page="/inc/top_menu02.jsp" flush="true"/>
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
  <div id="container">
    <div id="leftCon">
      <jsp:include page="/inc/log_info.jsp" flush="true"/>
      <jsp:include page="/inc/left_menu02.jsp" flush="true"/>
	<SCRIPT language="JavaScript" src="/js/reqsubmit/reqinfo.js"></SCRIPT>
	<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>
    </div>
    <div id="rightCon">
<form name="formName" method="post" action="<%=request.getRequestURI()%>">
<%
//요구 정보 정렬 정보 받기.
String strCommReqInfoSortField=objParams.getParamValue("CommReqInfoSortField");
String strCommReqInfoSortMtd=objParams.getParamValue("CommReqInfoSortMtd");
//요구 정보 페이지 번호 받기.
String strCommReqInfoPagNum=objParams.getParamValue("CommReqInfoPage");
%>
  <input type="hidden" name="CommReqInfoSortField" value="<%=strCommReqInfoSortField%>"><!--요구정보 목록정렬필드 -->
  <input type="hidden" name="CommReqInfoSortMtd" value="<%=strCommReqInfoSortMtd%>"><!--요구정보 목록정령방법-->
  <input type="hidden" name="CommReqInfoPage" value="<%=strCommReqInfoPagNum%>"><!--요구정보 페이지 번호 -->
  <input type="hidden" name="ReqBoxID" value=""><!--요구정보 ID-->
  <input type="hidden" name="CommReqID" value=""><!--요구정보 ID-->
  <input type="hidden" name="DAESUCH" value="">
      <!-- pgTit -->
      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=MenuConstants.REQ_INFO_LIST_SUBMT_NONE%></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%= MenuConstants.REQUEST_BOX_COMM %> > <%=MenuConstants.REQ_INFO_LIST%> > <%=MenuConstants.REQ_INFO_LIST_SUBMT_NONE%></div>
        <p><!--문구--></p>
      </div>
      <!-- /pgTit -->

      <!-- contents -->

      <div id="contents">
        <!-- 검색조건 없는 경우 아래 div 삭제 나 주석으로 막으세요.-->
        <div class="schBox">
          <p>요구함조회조건</p>
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
             <option value="">전체</option>
			<%
				if(objYearRs != null && objYearRs.getTotalRecordCount() > 0){
					while(objYearRs.next()){
				%>
					<option value="<%=objYearRs.getObject("AUDIT_YEAR")%>" <%if(((String)objYearRs.getObject("AUDIT_YEAR")).equals(strSelectedAuditYear)){%>selected<%}%>><%=objYearRs.getObject("AUDIT_YEAR")%>
					</option>
				<%
					}
				}
			%>
            </select>
			<%
				if(objSubmtRs.getTotalRecordCount() < 2){
			%>
			<%
				}else{
			%>
            <select onChange="javascript:doRefresh()" name="submtOrganId2">
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
            <select onChange="javascript:doRefresh()" name="CmtOrganID">
              <option selected="selected" value="">:::: 전체위원회 ::::</option>
              <%
			if(objCmtRs != null && objCmtRs.getTotalRecordCount() > 0){
				while(objCmtRs.next()){
			%>
				<option value="<%=objCmtRs.getObject("ORGAN_ID")%>" <%if(((String)objCmtRs.getObject("ORGAN_ID")).equals(strSelectedCmtOrganID)){%>selected<%}%>><%=objCmtRs.getObject("ORGAN_NM")%>
				</option>
			<%
				}
			}
		%>
            </select>
            <a href="javascript:gotoHeadQuery();"><img src="/images2/btn/bt_search2.gif" width="50" height="22" /></a> </div>
        </div>
        <!-- /검색조건-->

        <!-- 각페이지 내용 -->

        <!-- list -->

        <span class="list_total">&bull;&nbsp;전체자료수 : <%=intTotalRecordCount%>개 (<%=intCurrentPageNum%> / <%=intTotalPage%> page)</span>

<!------------------------- TAB에 해당하는 테이블(목록이든 등록폼이든 상세정보든) 출력 시~~~작 ------------------------->

        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
          <thead>
            <tr>
              <th scope="col"><a>NO</a></th>
              <th scope="col" style="width:250px;"><%=SortingUtil.getSortLink("changeSortQuery","REQ_CONT",strCommReqInfoSortField,strCommReqInfoSortMtd,"요구제목")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","REQ_ORGAN_NM",strCommReqInfoSortField,strCommReqInfoSortMtd,"요구기관")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","REQ_BOX_NM",strCommReqInfoSortField,strCommReqInfoSortMtd,"요구함")%></th>
              <th scope="col"><a>답변</a></th>
              <th scope="col"><a>첨부</a></th>
			  <th scope="col"><%= SortingUtil.getSortLink("changeSortQuery","SUBMT_DLN", strCommReqInfoSortField, strCommReqInfoSortMtd, "제출기한") %></th>
			  <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","LAST_REQ_DT",strCommReqInfoSortField,strCommReqInfoSortMtd,"요구일시")%></th>
            </tr>
          </thead>
          <tbody>
		<%
		  String strRecordNumber = request.getParameter("RecordNumber");
		  int intRecordNumber=0;
		  if(intCurrentPageNum == 1){
			  intRecordNumber= intTotalRecordCount;
		  } else {
			  intRecordNumber= java.lang.Integer.parseInt(strRecordNumber);
		  }
		  if(objRs.getRecordSize()>0){
			  String strCommReqID="";
			  String strReqBoxID="";
			  String strReqBoxStt="";
			  String strURL="";
			  while(objRs.next()){
				 strReqBoxID=(String)objRs.getObject("REQ_BOX_ID");
				 strCommReqID=(String)objRs.getObject("REQ_ID");
				 strReqBoxStt = (String)objRs.getObject("REQ_BOX_STT");
		 %>
            <tr>
              <td><%= intRecordNumber %></td>
              <td><%= StringUtil.getNotifyImg((String)objRs.getObject("REG_DT"), (String)objRs.getObject("REQ_STT")) %><a href="JavaScript:gotoDetail('<%=strReqBoxID%>','<%=strCommReqID%>');" hint="<%=StringUtil.substring((String)objRs.getObject("REQ_DTL_CONT"), 80)%>"><%=StringUtil.substring((String)objRs.getObject("REQ_CONT"),30)%></a>
			  </td>
              <td><%=objRs.getObject("REQ_ORGAN_NM")%>
			  </td>
              <td><a href="JavaScript:gotoReqBoxInfoView('<%=strReqBoxStt%>','<%=strReqBoxID%>');"><img src="/image/reqsubmit/icon_secretariat.gif" border="0" alt="<%=objRs.getObject("REQ_BOX_NM")%> 바로가기"></a></td>
              <td><%= nads.lib.reqsubmit.util.DBAccessUtil.makeAnsInfoHtml((String)objRs.getObject("ANS_ID"),(String)objRs.getObject("ANS_MTD"), StringUtil.ReplaceString((String)objRs.getObject("ANS_OPIN"), "'", ""),(String)objRs.getObject("SUBMT_FLAG"),objUserInfo.isRequester()) %></td>
              <td><%=makeAttachedFileLink((String)objRs.getObject("ANS_ESTYLE_FILE_PATH"))%></td>
			  <td><%=StringUtil.getDate((String)objRs.getObject("SUBMT_DLN"))%> 24:00</td>
			  <td><%=StringUtil.getDate2((String)objRs.getObject("LAST_REQ_DT"))%></td>
            </tr>
				<%
						intRecordNumber --;
					}//endwhile
				%>
				<input type="hidden" name="RecordNumber" value="<%=intRecordNumber%>">
				<%
				} else {
				%>
			<tr>
				<td colspan="8" align="center">등록된 요구자료가 없습니다.</td>
			</tr>
				<%
					} // end if
				%>
          </tbody>
        </table>

        <!-- /list -->
					<%=objPaging.pagingTrans(PageCount.getLinkedString(
							new Integer(intTotalRecordCount).toString(),
							new Integer(intCurrentPageNum).toString(),
							objParams.getParamValue("CommReqInfoPageSize")))
					%>
        <!-- 페이징-->
         <!-- /페이징-->
        <!--  <p class="warning">* 요구서를 발송하게 되면 해당 제출 기관 대표 담당자에게 지정 발송되며, 담당자가 없는 경우는 작성 중 요구함에 그대로 남아있게 됩니다.  </p>
          <p class="warning">* 요구서 발송 버튼을 이용하시기 위해서는 위원회를 선택해 주시기 바랍니다.  </p>  -->



        <!-- 리스트 버튼-->
        <div id="btn_all" >        <!-- 리스트 내 검색 -->
        <div class="list_ser" >
		<%
			String strCommReqInfoQryField=(String)objParams.getParamValue("CommReqInfoQryField");
		%>
          <select name="CommReqInfoQryField" class="selectBox5"  style="width:70px;" >
           <option <%=(strCommReqInfoQryField.equalsIgnoreCase("req_cont"))? " selected ": ""%>value="req_cont">요구제목</option>
			<option <%=(strCommReqInfoQryField.equalsIgnoreCase("req_dtl_cont"))? " selected ": ""%>value="req_dtl_cont">요구내용</option>
			<option <%=(strCommReqInfoQryField.equalsIgnoreCase("req_box_nm"))? " selected ": ""%>value="req_box_nm">요구함명</option>
          </select>
          <input name="CommReqInfoQryTerm" onKeyDown="return ch()" onMouseDown="return ch()"
		 class="li_input"  style="width:100px" value="<%=objParams.getParamValue("CommReqInfoQryTerm")%>"/>
          <img src="/images2/btn/bt_list_search.gif"  onMouseOver="menuOn(this);" onMouseOut="menuOut(this);" onClick="formName.submit()"/> </div>
        <!-- /리스트 내 검색 -->
		</div>

        <!-- /리스트 버튼-->

        <!-- /각페이지 내용 -->
      </div>
      <!-- /contents -->
</form>
    </div>
  </div>
<%!
	public String makeAttachedFileLink(String strFileName){
		String strReturnURL = null;
		if(!StringUtil.isAssigned(strFileName)){
			//파일경로가 없으면 기본 파일경로로 대치함.
			strReturnURL = "";
			//strFileName=nads.lib.reqsubmit.EnvConstants.getConstFilePath();
		} else {
			strReturnURL = "<a href=\"/reqsubmit/common/AttachStyleFileDownload.jsp?path=" + strFileName+ "\"><img src=\"/image/common/icon_etc.gif\" border=\"0\"></a>";
		}
		return strReturnURL;
	}

%>
  <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>