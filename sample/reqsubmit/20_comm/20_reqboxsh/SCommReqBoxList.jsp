<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.pf.util.PageCount"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.params.requestbox.SCommReqBoxListFormNew" %>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.SCommRequestBoxDelegate" %>
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
	/*************************************************************************************************/
	/** 	name : SCommReqBoxList.jsp																  */
	/** 		   위원회 요구함 목록을 출력한다.													  */
	/** 		   요구일정이 있는 소속 위원회의 목록을 출력한다.										  */
	/*************************************************************************************************/

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

	/**위원회목록조회용 파라미터 설정.*/
	SCommReqBoxListFormNew objParams=new SCommReqBoxListFormNew();
	//요구기관 설정 :: 소속 기관.
	objParams.setParamValue("SubmtOrganID",strOrganId);
	//위원회 요구일정진행상태 : 접수완료
	objParams.setParamValue("IngStt",CodeConstants.REQ_ING_STT_002);
	//요구함 상태 : 발송완료
	objParams.setParamValue("ReqBoxStt",CodeConstants.REQ_BOX_STT_006);

	boolean blnParamCheck=false;
	/**전달된 파리미터 체크 */
	blnParamCheck=objParams.validateParams(request);
	if(blnParamCheck==false) {
	  	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
	  	objMsgBean.setStrCode("DSPARAM-0000");
	  	objMsgBean.setStrMsg(objParams.getStrErrors());
                System.out.println("kangthis logs 111");
%>
  		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
  		return;
	}//endif

	strSelectedAuditYear= objParams.getParamValue("AuditYear"); 	/**선택된 감사년도*/
	strSelectedCmtOrganID=objParams.getParamValue("CmtOrganID") ; /**선택된 위원회ID*/

	//해당위원회가 없을경우.. 에러메세지 출력..
	if(objUserInfo.getCurrentCMTList().isEmpty()){
	  	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
	  	objMsgBean.setStrCode("DSDATA-0021");
                System.out.println("kangthis logs 222" + objUserInfo.getCurrentCMTList());
                System.out.println("kangthis logs 222");
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
  		return;
	}//endif

	//요구함 객체 ※Delegate 선언※.
	SCommRequestBoxDelegate objReqBox = null;
	RequestBoxDelegate objReqBoxDelegate = null;

	ResultSetHelper objCmtRs=null;			/** 연도별 위원회 */
	ResultSetHelper objRs=null;			/** 위원회 요구함 목록 */
	ResultSetSingleHelper objRsSH = null;			/** 요구함 상세보기 정보 */
	ResultSetHelper objDaeRs=null;
	ResultSetHelper objSubmtRs=null;
	ResultSetHelper objYearRs=null;

	try {
	 	objReqBox=new SCommRequestBoxDelegate();
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

	 	objCmtRs = new ResultSetHelper(objReqBox.getCmtOrganDaeList(objParams,objhashdata));
		objYearRs =  new ResultSetHelper(objReqBox.getAuditYearDaeList(lst,strSubmtOrganId,strStartdate,strEnddate,CodeConstants.REQ_BOX_STT_006));
		objRs=new ResultSetHelper(objReqBox.getRecordDaeList(objParams,objhashdata));
	} catch(AppException objAppEx) {
	 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
	  	objMsgBean.setStrCode(objAppEx.getStrErrCode());
	  	objMsgBean.setStrMsg(objAppEx.getMessage());
                System.out.println("kangthis logs 333");
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
  		return;
	}

	//요구함 목록조회된 결과 반환.
	int intTotalRecordCount=objRs.getTotalRecordCount();
	int intCurrentPageNum=objRs.getPageNumber();
	int intTotalPage=objRs.getTotalPageCount();
%>
<jsp:include page="/inc/header.jsp" flush="true"/>
<link href="/css2/style.css" rel="stylesheet" type="text/css">
<script language="javascript">

  /** 정렬방법 바꾸기 */
  function changeSortQuery(sortField,sortMethod){
  	listqry.ReqBoxSortField.value=sortField;
  	listqry.ReqBoxSortMtd.value=sortMethod;
	listqry.DAESUCH.value = "N";
  	listqry.submit();
  }

  //요구함상세보기로 가기.
  function gotoDetail(strID){
  	listqry.ReqBoxID.value=strID;
  	listqry.action="./SCommReqBoxVList.jsp";
  	listqry.submit();
  }

  /** 페이징 바로가기 */
  function goPage(strPage){
  	listqry.ReqBoxPage.value=strPage;
	listqry.DAESUCH.value = "N";
  	listqry.submit();
  }

  /**년도와 위원회로만 조회하기 */
  function gotoHeadQuery(){
  	listqry.ReqBoxQryField.value="";
  	listqry.ReqBoxQryTerm.value="";
  	listqry.ReqBoxSortField.value="";
  	listqry.ReqBoxSortMtd.value="";
  	listqry.ReqBoxPage.value="";
	listqry.DAESUCH.value = "N";
  	listqry.submit();
  }

  function changeDaesu(){
	form = document.listqry;
	form.target = '';
	form.DAESUCH.value = "Y";
	form.submit();
 }

 function doRefresh() {
	var f = document.listqry;
	f.DAESUCH.value = "N";
	f.target = "";
	f.submit();
}
</script>
</head>

<body>
<div id="wrap">
<SCRIPT language="JavaScript" src="/js2/reqsubmit/tooltip.js"></SCRIPT>
<script language="javascript">balloonHint("balloonHint")</script>
  <jsp:include page="/inc/top.jsp" flush="true"/>
  <jsp:include page="/inc/top_menu02.jsp" flush="true"/>
  <div id="container">
    <div id="leftCon">
<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="/js/reqsubmit/reqinfo.js"></SCRIPT>
      <jsp:include page="/inc/log_info.jsp" flush="true"/>
      <jsp:include page="/inc/left_menu02.jsp" flush="true"/>
    </div>
    <div id="rightCon">
<form name="listqry" method="post" action="<%=request.getRequestURI()%>">
<%//정렬 정보 받기.
	String strReqBoxSortField=objParams.getParamValue("ReqBoxSortField");
	String strReqBoxSortMtd=objParams.getParamValue("ReqBoxSortMtd");
%>
<input type="hidden" name="ReqBoxSortField" value="<%=strReqBoxSortField%>"><!--요구함목록정렬필드 -->
<input type="hidden" name="ReqBoxSortMtd" value="<%=strReqBoxSortMtd%>">	<!--요구함목록정령방법-->
<input type="hidden" name="ReqBoxPage" value="<%=intCurrentPageNum%>">			<!--페이지 번호 -->
<input type="hidden" name="ReqBoxID" value="">		<!--요구함 ID -->
<input type="hidden" name="CommOrganID" value="">	<!--위원회기관 ID -->
<input type="hidden" name="IngStt" value="">		<!--요구일정 진행상 -->
<input type="hidden" name="DAESUCH" value="">
      <!-- pgTit -->
      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=MenuConstants.REQ_BOX_MAKE%></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> <%=MenuConstants.GOTO_HOME%> > <%= MenuConstants.REQ_SUBMIT_MAIN_MENU %> > <%= MenuConstants.REQUEST_BOX_COMM %> > <%=MenuConstants.REQ_BOX_MAKE%></div>
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
				<option value="">:::: 전체위원회 :::</option>
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


        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
          <thead>
            <tr>
              <th scope="col" style="width:15px;"><a>NO</a></th>
              <th scope="col" style="width:250px;"><%=SortingUtil.getSortLink("changeSortQuery","REQ_BOX_NM",strReqBoxSortField,strReqBoxSortMtd,"요구함명")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","REQ_ORGAN_NM", strReqBoxSortField, strReqBoxSortMtd, "소관위원회")%><BR><%=SortingUtil.getSortLink("changeSortQuery","OLD_REQ_ORGAN_NM", strReqBoxSortField, strReqBoxSortMtd, "(의원실)")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","RLTD_DUTY", strReqBoxSortField, strReqBoxSortMtd, "업무구분")%></th>
              <th scope="col"><a>답변/요구</a></th>
               <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","LAST_REQ_DOC_SND_DT", strReqBoxSortField, strReqBoxSortMtd, "수신일")%></th>
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
				String strReqBoxID="";
			  	String strCommOrganID="";
				String strFstQryDt = "";

			  	while(objRs.next()){
			  		strReqBoxID=(String)objRs.getObject("REQ_BOX_ID");
			  	 	strCommOrganID=(String)objRs.getObject("CMT_ORGAN_ID");
					strFstQryDt = (String)objRs.getObject("FST_QRY_DT");
					objRsSH = new ResultSetSingleHelper(objReqBox.getOldOrganName(strReqBoxID));

			 %>
            <tr>
              <td><%= intRecordNumber %></td>
              <td><%if(strFstQryDt.equals("")||strFstQryDt == null){%><b><%}%><a href="javascript:gotoDetail('<%=strReqBoxID%>')"><%=(String)objRs.getObject("REQ_BOX_NM")%></a><%if(strFstQryDt.equals("")||strFstQryDt == null){%><b><%}%>
			  </td>
              <td><%=objRs.getObject("REQ_ORGAN_NM")%><BR>(<%=objRsSH.getObject("OLD_REQ_ORGAN_NM")%>)
			  </td>
              <td><%=objCdinfo.getRelatedDuty((String)objRs.getObject("RLTD_DUTY"))%>
			  </td>
              <td><%=(String)objRs.getObject("SUBMT_CNT")%> / <%=(String)objRs.getObject("REQ_CNT")%>
			  </td>
              <td><%=StringUtil.getDate2((String)objRs.getObject("LAST_REQ_DOC_SND_DT"))%>
			  </td>
            </tr>
				<%
						intRecordNumber --;
					}//endwhile
				%>
			<input type="hidden" name="RecordNumber" value="<%=intRecordNumber%>">
				<%
					}else{
				%>
			<tr>
				<td colspan="6" height="40" align="center">등록된 요구함이 없습니다.</td>
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
							objParams.getParamValue("ReqBoxPageSize")))%>
        <!-- 페이징-->
         <!-- /페이징-->
        <!--  <p class="warning">* 요구서를 발송하게 되면 해당 제출 기관 대표 담당자에게 지정 발송되며, 담당자가 없는 경우는 작성 중 요구함에 그대로 남아있게 됩니다.  </p>
          <p class="warning">* 요구서 발송 버튼을 이용하시기 위해서는 위원회를 선택해 주시기 바랍니다.  </p>  -->



        <!-- 리스트 버튼-->
        <div id="btn_all" >        <!-- 리스트 내 검색 -->
        <div class="list_ser" >
		<%
			String strReqBoxQryField=objParams.getParamValue("ReqBoxQryField");
		%>
          <select name="ReqBoxQryField" class="selectBox5"  style="width:70px;" >
           <option <%=(strReqBoxQryField.equalsIgnoreCase("req_box_nm"))? " selected ": ""%>value="req_box_nm">요구함명</option>
			<option <%=(strReqBoxQryField.equalsIgnoreCase("req_box_dsc"))? " selected ": ""%>value="req_box_dsc">요구함설명</option>
			<option <%=(strReqBoxQryField.equalsIgnoreCase("req_organ_nm"))? " selected ": ""%>value="req_organ_nm">요구기관</option>
          </select>
          <input name="ReqBoxQryTerm" onKeyDown="return ch()" onMouseDown="return ch()"
		 class="li_input"  style="width:100px" value="<%=objParams.getParamValue("ReqBoxQryTerm")%>"/>
          <img src="/images2/btn/bt_list_search.gif"  onMouseOver="menuOn(this);" onMouseOut="menuOut(this);" onClick="listqry.submit();"/> </div>
        <!-- /리스트 내 검색 -->
		</div>

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
