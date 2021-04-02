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
<%@ page import="nads.lib.reqsubmit.params.requestbox.RMemReqBoxVListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.MemRequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.MemRequestInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.SendReqBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.cmtsubmt.CmtSubmtReqBoxDelegate" %>
<%@ page import="nads.dsdm.app.common.page.PagingDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%
	/*** PagingDelegate */
	PagingDelegate objPaging=new PagingDelegate(); 		/*페이징 변환 Delegate*/
%>
<%
	UserInfoDelegate objUserInfo =null;
	CDInfoDelegate objCdinfo =null;
	String existFlag = "N";
%>

<%@ include file="../../../common/RUserCodeInfoInc.jsp" %>

<%
	/*************************************************************************************************/
	/** 					파라미터 체크 Part 														  */
	/*************************************************************************************************/

	/**일반 요구함 상세보기 파라미터 설정.*/
	RMemReqBoxVListForm objParams =new RMemReqBoxVListForm();
	objParams.setParamValue("IsRequester",String.valueOf(objUserInfo.isRequester()));//요구답변자여부설정
	boolean blnParamCheck=false;
	/**전달된 파리미터 체크 */
	blnParamCheck=objParams.validateParams(request);

	if(blnParamCheck==false) {
		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
		objMsgBean.setStrCode("DSPARAM-0000");
		objMsgBean.setStrMsg(objParams.getStrErrors());
		//out.println("ParamError:" + objParams.getStrErrors());
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}//endif

	/*************************************************************************************************/
	/** 					데이터 호출 Part 														  */
	/*************************************************************************************************/

	/*** Delegate 과 데이터 Container객체 선언 */
	MemRequestBoxDelegate objReqBox=null; 		/**요구함 Delegate*/
	MemRequestInfoDelegate  objReqInfo=null;	/** 요구정보 Delegate */
	SendReqBoxDelegate objSendBean = null;
	CmtSubmtReqBoxDelegate objCmtSubmt = null;

	ResultSetSingleHelper objRsSH=null;		/** 요구함 상세보기 정보 */
	ResultSetHelper objRs=null;				/**요구 목록 */

	try {
		/**요구함 정보 대리자 New */
		objReqBox=new MemRequestBoxDelegate();
		objSendBean = new SendReqBoxDelegate();
		objCmtSubmt = new CmtSubmtReqBoxDelegate();

		/**요구함 이용 권한 체크 */
		boolean blnHashAuth=objReqBox.checkReqBoxAuth((String)objParams.getParamValue("ReqBoxID"),objUserInfo.getOrganID()).booleanValue();
		if(!blnHashAuth){
			objMsgBean.setMsgType(MessageBean.TYPE_WARN);
			objMsgBean.setStrCode("DSAUTH-0001");
			objMsgBean.setStrMsg("해당 요구함을 볼 권한이 없습니다.");
			//out.println("해당 요구함을 볼 권한이 없습니다.");
%>
			<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
			return;
		} else {
			/** 요구함 정보 */
			objRsSH=new ResultSetSingleHelper(objReqBox.getRecord((String)objParams.getParamValue("ReqBoxID"), CodeConstants.REQ_BOX_STT_006));
			/**요구 정보 대리자 New */
			objReqInfo=new MemRequestInfoDelegate();
			objRs=new ResultSetHelper(objReqInfo.getRecordList(objParams));
		}/**권한 endif*/

		/*
		 * 2005-07-26 kogaeng ADD
		 * 요구함의 요구들에 답변들이 존재하는지를 체크하는 함수를 활용
		 * true가 반환되면 삭제가 가능하다라는 얘기. true ==> N
		 * false가 반환되면 삭제할 수 없다라는 것이니 false ==> Y
		 */
		if(objSendBean.checkDelReqBoxPermit((String)objParams.getParamValue("ReqBoxID"))) existFlag = "N";
		else existFlag = "Y";

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

	/*************************************************************************************************/
	/** 					데이터 값 할당  Part 														  */
	/*************************************************************************************************/

	/**요구정보 목록조회된 결과 반환.*/
	int intTotalRecordCount=objRs.getTotalRecordCount();
	int intCurrentPageNum=objRs.getPageNumber();
	int intTotalPage=objRs.getTotalPageCount();
%>
<jsp:include page="/inc/header.jsp" flush="true"/>
<link href="/css2/style.css" rel="stylesheet" type="text/css">
<script language="javascript">
  /** 정렬방법 바꾸기 */
  function changeSortQuery(sortField,sortMethod){
  	formName.ReqInfoSortField.value=sortField;
  	formName.ReqInfoSortMtd.value=sortMethod;
  	formName.target = '';
  	formName.submit();
  }

  /**요구상세보기로 가기.*/
  function gotoDetail(strID){
  	formName.ReqInfoID.value=strID;
  	formName.action="./RSendReqInfoVList.jsp";
  	formName.target = '';
  	formName.submit();
  }

  /** 목록으로 가기 */
  function gotoList(){
  	formName.action="./RSendBoxList.jsp";
  	formName.target = '';
  	formName.submit();
  }

  /** 페이징 바로가기 */
  function goPage(strPage){
  	formName.ReqInfoPage.value=strPage;
  	formName.target = '';
  	formName.submit();
  }

  function deleteReqBox(strBoxID){
  	var f = document.formName;
	if(confirm("해당요구함을 삭제 하시겠습니까?")){
		f.ReqBoxIDs.value = strBoxID;
		f.action ="RSendBoxDelProc.jsp";
		f.target = "popwin";
		window.open('/blank.html', 'popwin', 'width=40, height=40, left=2000, top=2000');
		var winl = (screen.width - 304) / 2;
		var winh = (screen.height - 118) / 2;
		document.all.loadingDiv.style.left = winl;
		document.all.loadingDiv.style.top = winh;
		document.all.loadingDiv.style.display = '';
		f.submit();
	}
  }

	function copyReqBox(ReqBoxID) {
		if(confirm("해당요구함을 복사하시겠습니까?")){
  			NewWindow('/reqsubmit/common/MemReqBoxCopyList.jsp?ReqBoxID='+ReqBoxID,'', '640', '450');
	  	}
	}
</script>
<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="/js/reqsubmit/reqboxview.js"></SCRIPT>
</head>

<body>
<DIV ID="loadingDiv" style="display:none;position:absolute;">
	<img src="/image/reqsubmit/loading.jpg" border="0"> </td>
</DIV>
<div id="wrap">
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
  <jsp:include page="/inc/top.jsp" flush="true"/>
  <jsp:include page="/inc/top_menu02.jsp" flush="true"/>
  <div id="container">
    <div id="leftCon">
      <jsp:include page="/inc/log_info.jsp" flush="true"/>
      <jsp:include page="/inc/left_menu02.jsp" flush="true"/>
	<SCRIPT language="JavaScript" src="/js/reqsubmit/reqinfo.js"></SCRIPT>
    </div>
    <div id="rightCon">
<form name="formName" method="<%=nads.lib.reqsubmit.EnvConstants.FORM_METHOD%>" action="<%=request.getRequestURI()%>"><!--요구함 신규정보 전달 -->
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
	//요구함 정보 페이지 번호 받기.
	String strReqInfoPagNum=objParams.getParamValue("ReqInfoPage");
	//요구조회히든태그없애기위해.
	objParams.getFormElement("ReqInfoQryField").setFormTagType(nads.lib.reqsubmit.form.FormElement.FORM_TAG_TYPE_SESSION);
	objParams.getFormElement("ReqInfoQryTerm").setFormTagType(nads.lib.reqsubmit.form.FormElement.FORM_TAG_TYPE_SESSION);
	%>
	<%=objParams.getHiddenFormTags()%>

<!-- 2005-09-27 kogaeng ADD -->
<input type="hidden" name="ReturnUrl" value="<%=request.getRequestURI()%>"><!--되돌아올 URL -->

      <!-- pgTit -->
      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=MenuConstants.REQ_BOX_SEND_END%><span class="sub_stl" >- <%=MenuConstants.REQ_BOX_DETAIL_VIEW%></span></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.getReqBoxGeneral(request)%> > <%=MenuConstants.REQ_BOX_SEND_END%></div>
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

		<!-- 상단 버튼-->
		<!--요구함 목록, 바인딩, 요구서 보기, 답변서 미리 보기, 답변서 발송, 오프라인 제출-->
        <div class="top_btn">
		 <samp>
		<%
			String strJscript = "";
			if(existFlag.equals("N")) strJscript = "javascript:deleteReqBox('"+objRsSH.getObject("REQ_BOX_ID")+"')";
			else strJscript = "alert('제출기관에서 답변 작성을 진행 중이므로 삭제를 하실 수 없습니다.')";
		%>
			 <span class="btn"><a href="<%= strJscript %>">요구함 삭제</a></span>
			 <span class="btn"><a href="javascript:copyReqBox('<%=objRsSH.getObject("REQ_BOX_ID")%>')">요구함 복사</a></span>
			 <span class="btn"><a href="javascript:gotoList()">요구함 목록</a></span>
		  </samp>
		 </div>

        <!-- /상단 버튼-->


        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list02">

            <tr>

              <th scope="col">&bull;&nbsp;요구함명 </th>
				  <td colspan="3"><%=objRsSH.getObject("REQ_BOX_NM")%></td>
            </tr>
<%
	// 2004-07-08 사무처, 예정처일 경우에는 위원회라는건 보이지마
	if (CodeConstants.ORGAN_GBN_ASM.equalsIgnoreCase(objUserInfo.getOrganGBNCode()) || CodeConstants.ORGAN_GBN_BUD.equalsIgnoreCase(objUserInfo.getOrganGBNCode())) {
	} else {

	//요구함 진행 상태.
	String strReqBoxStt=(String)objRsSH.getObject("REQ_BOX_STT");
%>
            <tr>
              <th scope="col">&bull;&nbsp;소관 위원회 </th>
			  <td><%=objRsSH.getObject("CMT_ORGAN_NM")%>
				<%
					// 2004-06-17 kogaeng modified
					String strElcDocNo = (String)objRsSH.getObject("DOC_NO");
					if (StringUtil.isAssigned(strElcDocNo)) out.println(" (전자문서번호 : "+strElcDocNo+")");
				%>
				</td>
            </tr>
<% } %>
             <tr>
              <th scope="col">&bull;&nbsp;발송정보 </th>
			  <td colspan="3">
				 <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list_none">
					 <tr>
						 <td width="17" rowspan="2"><img src="/images2/common/icon_assembly.gif" width="16" height="13" /></td>
						 <td><%=(String)objRsSH.getObject("REQ_ORGAN_NM")%></td>
						 <td rowspan="2"><img src="/images2/common/arrow01.gif" width="26" height="14" /></td>
						 <td width="15" rowspan="2"><img src="/images2/common/icon_cube.gif" width="11" height="15" /></td>
						 <td><%=(String)objRsSH.getObject("SUBMT_ORGAN_NM")%></td>
					 </tr>
					 <tr>
						 <td class="fonts"><%=(String)objRsSH.getObject("REGR_NM")%></td>
						 <td class="fonts"><%=(String)objRsSH.getObject("RCVR_NM")%> (<a href="mailto:<%=(String)objRsSH.getObject("RCVR_EMAIL")%>"><%=(String)objRsSH.getObject("RCVR_EMAIL")%></a>)
						 <br>(<%=(String)objRsSH.getObject("RCVR_OFFICE_TEL")%>/<%=(String)objRsSH.getObject("RCVR_CPHONE")%>)</td>
					 </tr>
				 </table>
			</td>

            </tr>
            <tr>
              <th scope="col" rowspan="2">&bull;&nbsp;요구함이력 </th>  <td colspan="3">
              <ul class="list_in">
              <li><span class="tl">&bull;&nbsp;요구함생성일시 :</span> <%=StringUtil.getDate2((String)objRsSH.getObject("REG_DT"))%></li>
              <li><span class="tl">&bull;&nbsp;요구서발송일시 :</span> <%=StringUtil.getDate2((String)objRsSH.getObject("LAST_REQ_DOC_SND_DT"))%></li>
              </ul>
              </td>
            </tr>
              <tr>
			  <td colspan="3">
              <ul class="list_in">
              <li><span class="tl">&bull;&nbsp;제출기관조회일시 :</span> <%=StringUtil.getDate2((String)objRsSH.getObject("FST_QRY_DT"))%></li>
              <li><span class="tl">&bull;&nbsp;제출기한 :</span>
			  <%=StringUtil.getDate((String)objRsSH.getObject("SUBMT_DLN"))%> 24:00</li>

              </ul>
              </td>
            </tr>
                <tr>
              <th scope="col">&bull;&nbsp;요구함설명 </th>   <td colspan="3"><%=StringUtil.getDescString((String)objRsSH.getObject("REQ_BOX_DSC"))%></td>
            </tr>
        </table>
        <!-- /list view -->
        <p class="warning mt10">요구함 삭제는 제출기관에서 등록된 요구에 대한 답변을 작성하지 않은 경우에만 가능합니다.</p>
		<p class="warning mt10">요구함 복사를 통해 생성된 요구함은 작성중 요구함에서 확인하실 수 있습니다.</p><br><br>
		<!-- 답변서 발송 -->
        <div id="btn_all"><div  class="t_right">
          <div class="mi_btn"><a href="javascript:ReqDocOpenView('<%= (String)objParams.getParamValue("ReqBoxID") %>')"><span>요구서 보기</span></a></div>
        </div></div>


        <!-- list -->
        <span class="list01_tl">요구 목록 <span class="list_total">&bull;&nbsp;전체자료수 : <%= intTotalRecordCount %>개 (<%= intCurrentPageNum %>/<%= intTotalPage %> page)</span></span>
		<table>
			<tr>
				<td>&nbsp;</td>
			</tr>
		</table>
        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
          <thead>
            <tr>
			  <th scope="col"><input name="checkAll" type="checkbox" class="borderNo" onClick="checkAllOrNot(document.formName);"/></th>
              <th scope="col"><a>NO</a></th>
			<%
			int intTmpWidth1=490;
			if(objUserInfo.getOrganGBNCode().equals("003")){//의원실소속
			  intTmpWidth1=intTmpWidth1-50;
			}//endif의원실소속확인
			%>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","REQ_CONT",strReqInfoSortField,strReqInfoSortMtd,"요구제목")%></th>
              <th scope="col" style="width:40%; "><%=SortingUtil.getSortLink("changeSortQuery","OPEN_CL",strReqInfoSortField,strReqInfoSortMtd,"공개등급")%></th>
			<%
			if(objUserInfo.getOrganGBNCode().equals("003")){//의원실소속
			%>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","CMT_REQ_APP_FLAG",strReqInfoSortField,strReqInfoSortMtd,"위원회")%></th>
			<%
			}//endif의원실소속확인
			%>
              <th scope="col"><a>답변</a></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","REG_DT",strReqInfoSortField,strReqInfoSortMtd,"등록일시")%></th>
            </tr>
          </thead>
          <tbody>
		<%
		  int intRecordNumber=intTotalRecordCount - ((intCurrentPageNum -1) * Integer.parseInt((String)objParams.getParamValue("ReqInfoPageSize")));
		  String strReqInfoID="";
		  String strCmtApplyValue = "Y";
		  while(objRs.next()){
			 strReqInfoID=(String)objRs.getObject("REQ_ID");
			 /** 위원회신청가능한지(Y) 아닌지 "" 결정*/
			if(CodeConstants.isDuplatedApplyToCmtReq((String)objRs.getObject("CMT_REQ_APP_FLAG"))) strCmtApplyValue = "";
			else strCmtApplyValue="Y";
		 %>
            <tr>
              <td><input name="ReqInfoIDs" type="checkbox" value="<%=strReqInfoID%>"  class="borderNo"/></td>
              <td><%= intRecordNumber %></td>
			<%
			int intTmpWidth2=500;
			if(objUserInfo.getOrganGBNCode().equals("003")){//의원실소속
			  intTmpWidth2=intTmpWidth2-50;
			}//endif의원실소속확인
			%>
              <td style="text-align:left;"><%=StringUtil.getNotifyImg((String)objRs.getObject("REG_DT"),(String)objRs.getObject("REQ_STT"))%><a href="JavaScript:gotoDetail('<%=strReqInfoID%>');" hint="<%= (String)objRs.getObject("REQ_DTL_CONT") %>"><%=StringUtil.substring((String)objRs.getObject("REQ_CONT"),35)%></a></td>
              <td><%=CodeConstants.getOpenClass((String)objRs.getObject("OPEN_CL"))%></td>
			<%
			if(objUserInfo.getOrganGBNCode().equals("003")){//의원실소속
			%>
              <td><%=CodeConstants.getCmtRequestAppoint((String)objRs.getObject("CMT_REQ_APP_FLAG"))%></td>
			<%
			}//endif의원실소속확인
			%>
			<td><%=nads.lib.reqsubmit.util.DBAccessUtil.makeAnsInfoHtml((String)objRs.getObject("ANS_ID"),(String)objRs.getObject("ANS_MTD"),(String)objRs.getObject("ANS_OPIN"),(String)objRs.getObject("SUBMT_FLAG"),objUserInfo.isRequester())%></td>
              <td><%= StringUtil.getDate2((String)objRs.getObject("REG_DT")) %></td>
            </tr>
			<input type="hidden" name="ReqID" value="<%= strReqInfoID %>">
			<input type="hidden" name="CmtApplys" value="<%=strCmtApplyValue%>">
<%
		intRecordNumber--;
	} //endwhile
%>
	<%
	/*조회결과 없을때 출력 시작.*/
	if(objRs.getRecordSize()<1){
	%>
	<tr>
	 <td colspan="7" align="center">등록된 요구정보가 없습니다.</td>
            </tr>
	<%
	}/*조회결과 없을때 출력 끝.*/
	%>
          </tbody>
        </table>
        <!-- /list -->

        <!-- 페이징-->
					<!--	<%= PageCount.getLinkedString(
								new Integer(intTotalRecordCount).toString(),
								new Integer(intCurrentPageNum).toString(),
								objParams.getParamValue("ReqInfoPageSize"))
						%>
						-->
						<%=objPaging.pagingTrans(PageCount.getLinkedString(
							new Integer(intTotalRecordCount).toString(),
							new Integer(intCurrentPageNum).toString(),
							objParams.getParamValue("ReqInfoPageSize")))%>

       <!-- /페이징-->


       <!-- 리스트 버튼-->
        <div id="btn_all" >        <!-- 리스트 내 검색 -->
        <div class="list_ser" >
		<%
			String strReqInfoQryField=(String)objParams.getParamValue("ReqInfoQryField");
		%>
          <select name="ReqInfoQryField" class="selectBox5"  style="width:70px;" >
           <option <%=(strReqInfoQryField.equalsIgnoreCase("req_cont"))? " selected ": ""%>value="req_cont">요구제목</option>
			<option <%=(strReqInfoQryField.equalsIgnoreCase("req_dtl_cont"))? " selected ": ""%>value="req_dtl_cont">요구내용</option>
          </select>
          <input name="ReqInfoQryTerm" onKeyDown="return ch()" onMouseDown="return ch()" alue="<%=objParams.getParamValue("ReqInfoQryTerm")%>"
		 class="li_input"  style="width:100px"/>
          <img src="/images2/btn/bt_list_search.gif"  onMouseOver="menuOn(this);" onMouseOut="menuOut(this);" onClick="gotoReqInfoSearch(formName);"/></div>
        <!-- /리스트 내 검색
		-->
			<span class="right">
			<span class="list_bt" onclick="javascript:copyMemReqInfo(formName);return false;"><a href="#">요구 복사</a></span>
		
<!--
			<span class="list_bt"><a href="#">요구삭제</a></span>
			<span class="list_bt"><a href="#">요구복사</a></span>
-->
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