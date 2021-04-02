<%@ page language="java" contentType="text/html;charset=EUC-KR" %>

<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.pf.util.PageCount"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RCommReqBoxVListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.CommRequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.CommRequestInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.cmtmanager.CmtManagerConfirmDelegate" %>
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
	}

	//로그인 사용자 정보를 가져온다. 권한없음 경우 관람만 가능하다.
	String strReqSubmitFlag = objUserInfo.getReqSubmitFlag();

	/*** Delegate 과 데이터 Container객체 선언 */
	CommRequestBoxDelegate objReqBox=null; 		/**요구함 Delegate*/
	CommRequestInfoDelegate  objReqInfo=null;		/** 요구정보 Delegate */
	ResultSetSingleHelper objRsSH=null;			/** 요구함 상세보기 정보 */
	ResultSetHelper objRs=null;					/**요구 목록 */
	String strOrganID = objUserInfo.getOrganID();
	String strCmtOpenCl = request.getParameter("OpenCl");
	String strOpenCl = "";
	String strListMsg = "";
	String strOldReqOrganId = "";
	String strReqBoxId = (String)objParams.getParamValue("ReqBoxID");
	CmtManagerConfirmDelegate cmtmanagerCn = new CmtManagerConfirmDelegate();
	boolean strflag = true;

	try{
		/**요구함 정보 대리자 New */
		objReqBox=new CommRequestBoxDelegate();

		/** 요구함 정보 */
		objRsSH=new ResultSetSingleHelper(objReqBox.getRecord((String)objParams.getParamValue("ReqBoxID"), CodeConstants.REQ_BOX_STT_006));

		System.out.println("$$$$$$$");

		/**요구함 이용 권한 체크 */
		boolean blnHashAuth=objReqBox.checkReqBoxAuth((String)objParams.getParamValue("ReqBoxID"),objUserInfo.getCurrentCMTList()).booleanValue();
		if(!blnHashAuth) {
			System.out.println("$$$$$$$2 : "+strOrganID+" 1 "+objRsSH.getObject("OLD_REQ_ORGAN_ID"));
			if(!strOrganID.equals((String)objRsSH.getObject("OLD_REQ_ORGAN_ID")))
{
				System.out.println("$$$$$$$3");
				objMsgBean.setMsgType(MessageBean.TYPE_WARN);
				objMsgBean.setStrCode("DSAUTH-0001");
				objMsgBean.setStrMsg("해당 요구함을 볼 권한이 없습니다.");
				out.println("해당 요구함을 볼 권한이 없습니다.");
	%>
				<jsp:forward page="/common/message/ViewMsg3.jsp"/>
	<%
				return;
			}
		}
		/**요구 정보 대리자 New */
		objReqInfo=new CommRequestInfoDelegate();
		objRs=new ResultSetHelper((Hashtable)objReqInfo.getRecordList(objParams));

		if(objRs.getRecordSize()>0){
			while(objRs.next()){
				if(objRs.getObject("ANS_ID") != null && !objRs.getObject("ANS_ID").equals("")){
					existFlag = "Y";
				}
			}
			objRs.first();
		}

		if(objRs != null){
			if(objRs.next()){
				strOpenCl = (String)objRs.getObject("OPEN_CL");
			}
			objRs.first();
		}

		if(objRs != null){
			if(objRs.next()){
				strOldReqOrganId = (String)objRs.getObject("OLD_REQ_ORGAN_ID");
			}
			objRs.first();
		}
		if(strCmtOpenCl == null || strCmtOpenCl.equals("") || strCmtOpenCl.equals("N")){
			strCmtOpenCl = cmtmanagerCn.getOpenCl(strOldReqOrganId) == null ? "" : cmtmanagerCn.getOpenCl(strOldReqOrganId);
		}

		if(objUserInfo.getOrganGBNCode().equals("004")  && !strReqSubmitFlag.equals("004")){
			strListMsg = "등록된 요구정보가 없습니다.";
		}else{
			if(strCmtOpenCl.equals("Y")){
				if(strOpenCl.equals("002")){
						if(strOldReqOrganId.equals(strOrganID)){
							 strListMsg = "등록된 요구정보가 없습니다.";
						}else{
							objParams.setParamValue("ReqBoxID","XXXXXXXXXX");
							objRs=new ResultSetHelper((Hashtable)objReqInfo.getRecordList(objParams));
							strListMsg = "비공개 요구목록 입니다.";
							strflag = false;
						}
				}
			}else{
				strListMsg = "등록된 요구정보가 없습니다.";
			}
		}
		objParams.setParamValue("ReqBoxID",strReqBoxId);


	} catch(AppException objAppEx) {
 		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  		objMsgBean.setStrCode(objAppEx.getStrErrCode());
  		objMsgBean.setStrMsg(objAppEx.getMessage());
  		out.println("<br>Error!!!" + objAppEx.getMessage());
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
  function gotoDetail(strReqBoxID, strCommReqID){
    form=document.formName;
  	form.ReqBoxID.value=strReqBoxID;
  	form.CommReqID.value=strCommReqID;
  	form.action="./RSendReqInfo.jsp";
  	form.target = "";
  	form.submit();
  }

  /** 목록으로 가기 */
  function gotoList(){
  	form=document.formName;
  	form.action="./RSendBoxList.jsp";
  	form.target = "";
  	form.submit();
  }

  /** 정렬방법 바꾸기 */
  function changeSortQuery(sortField,sortMethod){
  	form=document.formName;
  	form.CommReqInfoSortField.value=sortField;
  	form.CommReqInfoSortMtd.value=sortMethod;
  	form.target = "";
  	form.submit();
  }

  /** 페이징 바로가기 */
  function goPage(strPage){
  	form=document.formName;
  	form.CommReqInfoPage.value=strPage;
  	form.target = "";
  	form.submit();
  }

  // 2004-09-20
  function PluralReqDocView(strReqBoxID) {
  	var f = document.formName;
  	f.action = "/reqsubmit/common/PluralReqDocView.jsp?ReqBoxID="+strReqBoxID;
  	f.target = "popwin";
	NewWindow('/blank.html', 'popwin', '320', '250');
	f.submit();
  }

	function deleteReqBox(strBoxID){
  		var f = document.formName;
  		var winl = (screen.width - 300) / 2;
		var winh = (screen.height - 240) / 2;
		if(confirm("해당요구함을 삭제 하시겠습니까?")){
			f.action ="/reqsubmit/20_comm/20_reqboxsh/RSendBoxDelProc.jsp";
			f.target = "";
			//window.open('/blank.html', 'popwin', 'width=300, height=240, left='+winl+', top='+winh);
			f.submit();
		}
	}
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
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
	<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>
    </div>
    <div id="rightCon">
<form name="formName" method="post" action="<%=request.getRequestURI()%>">

		<%  //요구함 정렬 정보 받기.
			String strCommReqBoxSortField=objParams.getParamValue("CommReqBoxSortField");
			String strCommReqBoxSortMtd=objParams.getParamValue("CommReqBoxSortMtd");
			//요구함 페이지 번호 받기.
			String strCommReqBoxPagNum=objParams.getParamValue("CommReqBoxPageNum");
			//요구함 조회정보 받기.
			String strCommReqBoxQryField=objParams.getParamValue("CommReqBoxQryField");
			String strCommReqBoxQryTerm=objParams.getParamValue("CommReqBoxQryTerm");

			//요구 정보 정렬 정보 받기.
			String strCommReqInfoSortField=objParams.getParamValue("CommReqInfoSortField");
			String strCommReqInfoSortMtd=objParams.getParamValue("CommReqInfoSortMtd");
			//요구함 정보 페이지 번호 받기.
			String strCommReqInfoPagNum=objParams.getParamValue("CommReqInfoPageNum");
		%>
	    <input type="hidden" name="ReqBoxID" value="<%=objParams.getParamValue("ReqBoxID")%>">
	    <input type="hidden" name="CmtOrganID" value="<%=objParams.getParamValue("CmtOrganID")%>">
   		<input type="hidden" name="AuditYear" value="<%=objParams.getParamValue("AuditYear")%>">
	    <input type="hidden" name="IngStt" value="">
		<input type="hidden" name="CommReqBoxSortField" value="<%=strCommReqBoxSortField%>"><!--요구함목록정렬필드 -->
		<input type="hidden" name="CommReqBoxSortMtd" value="<%=strCommReqBoxSortMtd%>"><!--요구함목록정령방법-->
		<input type="hidden" name="CommReqBoxPage" value="<%=strCommReqBoxPagNum%>"><!--요구함 페이지 번호 -->
		<input type="hidden" name="CommReqBoxQryField" value="<%=strCommReqBoxQryField%>">
		<input type="hidden" name="CommReqBoxQryTerm" value="<%=strCommReqBoxQryTerm%>">
		<input type="hidden" name="CommReqInfoSortField" value="<%=strCommReqInfoSortField%>"><!--요구정보 목록정렬필드 -->
		<input type="hidden" name="CommReqInfoSortMtd" value="<%=strCommReqInfoSortMtd%>"><!--요구정보 목록정령방법-->
		<input type="hidden" name="CommReqInfoPage" value="<%=strCommReqInfoPagNum%>"><!--요구정보 페이지 번호 -->
		<input type="hidden" name="CommReqID" value=""><!--요구정보 ID-->
		<input type="hidden" name="RltdDuty" value="<%=objParams.getParamValue("RltdDuty")%>">

      <!-- pgTit -->

      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=MenuConstants.REQ_BOX_SEND_END%><span class="sub_stl" >- 요구함 상세보기</span></h3>
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

        <span class="list02_tl">요구함 정보 </span>

        <!-- 상단 버튼 시작-->
         <div class="top_btn">
			<samp>
		<%if(objUserInfo.getOrganGBNCode().equals("004") && !strReqSubmitFlag.equals("004") && existFlag.equals("N")) {%>
			 <span class="btn"><a href="javascript:deleteReqBox(<%=objRsSH.getObject("REQ_BOX_ID")%>)">요구함 삭제</a></span>
		<%}%>
			 <span class="btn"><a href="javascript:gotoList()">요구함 목록</a></span>
			</samp>
		 </div>

        <!-- /상단 버튼 끝-->

        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list02">
            <tr>
              <th width="100px;" scope="col">&bull;&nbsp;요구함명 </th>
				  <td colspan="3"><%=objRsSH.getObject("REQ_BOX_NM")%>
				<%
   				// 2004-06-17 ADD
   				String strElcDocNo = (String)objRsSH.getObject("DOC_NO");
				if (StringUtil.isAssigned(strElcDocNo)) {
                    out.println(" (전자결재번호 : "+strElcDocNo+")");
   				}
       			%>
				</td>
            </tr>
            <tr>
              <th scope="col">&bull;&nbsp;업무구분 </th>
			  <td><%=objCdinfo.getRelatedDuty((String)objRsSH.getObject("RLTD_DUTY"))%></td>
            </tr>
             <tr>
              <th scope="col">&bull;&nbsp;발송정보 </th>
			  <td colspan="3">
				 <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list_none">
					 <tr>
						 <td width="17" rowspan="2"><img src="/images2/common/icon_assembly.gif" width="16" height="13" /></td>
						 <td><%=objRsSH.getObject("CMT_ORGAN_NM")%></td>
						 <td rowspan="2"><img src="/images2/common/arrow01.gif" width="26" height="14" /></td>
						 <td width="15" rowspan="2"><img src="/images2/common/icon_cube.gif" width="11" height="15" /></td>
						 <td><%=(String)objRsSH.getObject("SUBMT_ORGAN_NM")%></td>
					 </tr>
					 <tr>
						<td>&nbsp;<%=(String)objRsSH.getObject("REGR_NM")%>&nbsp;&nbsp;</td>
						<td width="350">&nbsp;<%=(String)objRsSH.getObject("RCVR_NM")%> (<a href="mailto:<%=(String)objRsSH.getObject("RCVR_EMAIL")%>"><%=(String)objRsSH.getObject("RCVR_EMAIL")%></a>) (<%=(String)objRsSH.getObject("RCVR_OFFICE_TEL")%>/<%=(String)objRsSH.getObject("RCVR_CPHONE")%>)</td>
					 </tr>
				 </table>
			</td>

            </tr>
                <tr>

              <th scope="col">&bull;&nbsp;요구함이력 </th>  <td colspan="3">
              <ul class="list_in">
              <li><span class="tl">&bull;&nbsp;접수기간 :</span> <%=StringUtil.getDate((String)objRsSH.getObject("ACPT_BGN_DT"))%> ~ <%=StringUtil.getDate((String)objRsSH.getObject("ACPT_END_DT"))%></li>
              <li><span class="tl">&bull;&nbsp;요구함생성일시 :</span> <%=StringUtil.getDate2((String)objRsSH.getObject("REG_DT"))%></li>
              <li><span class="tl">&bull;&nbsp;요구서발송일시 :</span> <%=StringUtil.getDate2((String)objRsSH.getObject("LAST_REQ_DOC_SND_DT"))%></li>
              <li><span class="tl">&bull;&nbsp;제출기관조회일시 :</span> <strong><%=StringUtil.getDate2((String)objRsSH.getObject("FST_QRY_DT"))%></strong></li>
              <li><span class="tl">&bull;&nbsp;제출기한 :</span> <strong><%=StringUtil.getDate((String)objRsSH.getObject("SUBMT_DLN"))%> 24:00</strong></li>
              </ul>
              </td>
            </tr>
                <tr>
              <th scope="col">&bull;&nbsp;요구함설명 </th>   <td colspan="3"><%=StringUtil.getDescString((String)objRsSH.getObject("REQ_BOX_DSC"))%></td>
            </tr>
        </table><br><br>
        <!-- /list view -->
		<div id="btn_all"><div  class="t_right">
        <%
			/** 위원회 행정직원 일때만 화면에 출력함.*/
			if(objUserInfo.getOrganGBNCode().equals("004") && !strReqSubmitFlag.equals("004")) {
		%>
			 <div class="mi_btn"><a href="javascript:ReqDocOpenView('<%=objParams.getParamValue("ReqBoxID")%>','002')"><span>요구서 보기</span></a></div>
		<%}else{%>

				<!-- 요구서 보기 -->
		<%if(strOldReqOrganId.equals(strOrganID)){%>
		 <div class="mi_btn"><a href="javascript:ReqDocOpenView('<%=objParams.getParamValue("ReqBoxID")%>','002')"><span>요구서 보기</span></a></div>
		 <%
			}
		}
		%>
        </div></div>
        <!-- list -->
        <span class="list01_tl">요구 목록 <span class="list_total">&bull;&nbsp;전체자료수 : <%= intTotalRecordCount %>개 (<%= intCurrentPageNum %>/<%= intTotalPage %> page)</span></span>
        <table>
			<tr>
				<td>&nbsp;</td>
			</tr>
		</table>
   <!------------------------- TAB에 해당하는 테이블(목록이든 등록폼이든 상세정보든) 출력 시~~~작 ------------------------->
        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
          <thead>
            <tr>
			  <th scope="col" style="width:10px;"><a>NO</a></th>
              <th scope="col" style="width:250px;"><%=SortingUtil.getSortLink("changeSortQuery","REQ_CONT",strCommReqInfoSortField,strCommReqInfoSortMtd,"요구제목")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","OLD_REQ_ORGAN_NM",strCommReqInfoSortField,strCommReqInfoSortMtd,"요구기관")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","OPEN_CL",strCommReqInfoSortField,strCommReqInfoSortMtd,"공개등급")%></th>
              <th scope="col"><a>답변</a></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","REG_DT",strCommReqInfoSortField,strCommReqInfoSortMtd,"신청일시")%></th>
            </tr>
          </thead>
          <tbody>
	<%
	int intRecordNumber= intTotalRecordCount - ((intCurrentPageNum -1) * Integer.parseInt((String)objParams.getParamValue("CommReqInfoPageSize")));
	String strReqInfoID="";

	if(objRs.getRecordSize()>0){
		while(objRs.next()){
			strReqInfoID=(String)objRs.getObject("REQ_ID");
	%>
            <tr>
              <td><%=intRecordNumber%></td>
              <td><a href="javascript:gotoDetail('<%=objRsSH.getObject("REQ_BOX_ID")%>','<%=objRs.getObject("REQ_ID")%>')" hint="<%= StringUtil.substring((String)objRs.getObject("REQ_DTL_CONT"), 80) %>"><%=objRs.getObject("REQ_CONT")%></a></td>
              <td><%=objRs.getObject("OLD_REQ_ORGAN_NM")%></td>
              <td><%=CodeConstants.getOpenClass((String)objRs.getObject("OPEN_CL"))%></td>                  <td><%=nads.lib.reqsubmit.util.DBAccessUtil.makeAnsInfoHtml((String)objRs.getObject("ANS_ID"),(String)objRs.getObject("ANS_MTD"),(String)objRs.getObject("ANS_OPIN"),(String)objRs.getObject("SUBMT_FLAG"),objUserInfo.isRequester())%></td>
              <td><%=StringUtil.getDate2((String)objRs.getObject("REG_DT"))%></td>
            </tr>
		<%
				intRecordNumber++;
			} //endwhile
		} else {
		%>
	        <tr>
              <td colspan="6" align=""><%=strListMsg%></td>
            </tr>
		<%
		}//endif
		%>
          </tbody>
        </table>
        <!-- /list -->

        <!-- 페이징-->
						<%//= PageCount.getLinkedString(
							//	new Integer(intTotalRecordCount).toString(),
							//	new Integer(intCurrentPageNum).toString(),
							//	objParams.getParamValue("ReqInfoPageSize"))
						%>

						<%=objPaging.pagingTrans(PageCount.getLinkedString(
								new Integer(intTotalRecordCount).toString(),
								new Integer(intCurrentPageNum).toString(),
								objParams.getParamValue("CommReqInfoPageSize")))
						%>

       <!-- /페이징-->


       <!-- 리스트 버튼-->
        <div id="btn_all" >        <!-- 리스트 내 검색 -->
        <div class="list_ser" >
			<%
				String strCommReqInfoQryField=(String)objParams.getParamValue("CommReqInfoQryField");
			%>
          <select name="CommReqInfoQryField" class="selectBox5"  style="width:70px;" >
			<option <%=(strCommReqInfoQryField.equalsIgnoreCase("req_cont"))? " selected ": ""%>value="req_cont">요구제목</option>
			<option <%=(strCommReqInfoQryField.equalsIgnoreCase("req_dtl_cont"))? " selected ": ""%>value="req_dtl_cont">요구내용</option>
			<option <%=(strCommReqInfoQryField.equalsIgnoreCase("old_req_organ_nm"))? " selected ": ""%>value="old_req_organ_nm">요구기관</option>
          </select>
          <input name="CommReqInfoQryTerm" onKeyDown="return ch()" onMouseDown="return ch()" value="<%=objParams.getParamValue("CommReqInfoQryTerm")%>"
		 class="li_input"  style="width:100px"/>
          <img src="/images2/btn/bt_list_search.gif"  onMouseOver="menuOn(this);" onMouseOut="menuOut(this);" onClick="formName.submit()"/> </div>
        <!-- /리스트 내 검색 -->
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