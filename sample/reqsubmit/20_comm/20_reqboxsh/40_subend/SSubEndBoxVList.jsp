<%@ page language="java" contentType="text/html;charset=EUC-KR" %>

<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.pf.util.PageCount"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.params.requestbox.SCommReqBoxVListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.SCommRequestBoxDelegate" %>

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
	/**일반 요구함 상세보기 파라미터 설정.*/
	SCommReqBoxVListForm  objParams =new SCommReqBoxVListForm();
	objParams.setParamValue("IsRequester",String.valueOf(objUserInfo.isRequester()));//요구답변자여부설정

	boolean blnParamCheck = false;
	/**전달된 파리미터 체크 */
	blnParamCheck = objParams.validateParams(request);
	if(blnParamCheck==false) {
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
	SCommRequestBoxDelegate objReqBox=null; 		/**요구함 Delegate*/
	ResultSetSingleHelper objRsSH=null;			/** 요구함 상세보기 정보 */
	ResultSetHelper objRs=null;					/**요구 목록 */

	try {
		/**요구함 정보 대리자 New */
		objReqBox=new SCommRequestBoxDelegate();
		/**요구함 이용 권한 체크 */

		/** 요구함 정보 */
		objRsSH=new ResultSetSingleHelper(objReqBox.getRecord((String)objParams.getParamValue("ReqBoxID"), (String)objUserInfo.getUserID()));
		/** 요구 정보 */
		objRs=new ResultSetHelper((Hashtable)objReqBox.getReqRecordList(objParams));

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
	System.out.println("SSSSS1");
	String strYear = (String)objParams.getParamValue("AuditYear") == null?"2008":(String)objParams.getParamValue("AuditYear");
	if(strYear.equals("")){
		strYear = "2008";
	}
	int intAuditYear = Integer.parseInt(strYear);
	System.out.println("SSSSS2");

	/**요구정보 목록조회된 결과 반환.*/
	int intTotalRecordCount=objRs.getTotalRecordCount();
	int intCurrentPageNum=objRs.getPageNumber();
	int intTotalPage=objRs.getTotalPageCount();
%>

<jsp:include page="/inc/header.jsp" flush="true"/>
<style type="text/css">
	.tooltip_text, .tooltip_close{
		cursor: pointer;
	}
	div.tooltip {
		
		position:absolute;
	}
</style>
<script language="javascript">

  /** 요구함목록으로 가기 */
  function gotoList(){
  	form=document.formName;
  	form.action="./SSubEndBoxList.jsp";
  	form.target = "";
  	form.submit();
  }

  /** 요구상세보기로 가기 */
  function gotoDetail(str1, str2){
  	var f = document.formName;
  	f.action="./SSubEndReqInfo.jsp";
	f.ReqBoxID.value = str1;
	f.ReqID.value = str2;
  	f.target = "";
  	f.submit();
  }

  function gotoSend(){
  	form=document.formName;
  	form.action="./SCommAnsInfoWrite.jsp";
  	form.target = "";
  	form.submit();
  }

  /** 정렬방법 바꾸기 */
  function changeSortQuery(sortField,sortMethod){
  	form=document.formName;
  	form.ReqInfoSortField.value=sortField;
  	form.ReqInfoSortMtd.value=sortMethod;
  	form.target = "";
  	form.submit();
  }

  /** 페이징 바로가기 */
  function goPage(strPage){
  	form=document.formName;
        //var test = form.ReqInfoPage.value;
  	//alert(test);
  	//form.CommReqInfoPage.value=strPage;
  	form.ReqInfoPage.value=strPage;
  	form.target = "";
        form.action ="<%=request.getRequestURI()%>";
  	form.submit();
  }

	/**
  	 * 2005-10-20 kogaeng ADD
  	 * 체크박스를 하나만 선택하게 하는 스크립트
  	 */
  	function checkBoxValidate(cb) {
		if(<%= intTotalRecordCount %> == 1) {
			/*if(cb == 0) {
				document.formName.ReqInfoID.checked = true;
				document.formName.ReqID.value = document.formName.ReqInfoID.value;
				return;
			}*/
            return;
		}
		for (j = 0; j < <%= objRs.getRecordSize() %>; j++) {
			if (eval("document.formName.ReqInfoID[" + j + "].checked") == true) {
				document.formName.ReqInfoID[j].checked = false;
				if (j == cb) {
					document.formName.ReqInfoID[j].checked = true;
					document.formName.ReqID.value = document.formName.ReqInfoID[j].value;
				} else {
					document.formName.ReqInfoID[j].checked = false;
					document.formName.ReqID.value = "";
				}
			}
		}
	}

	/** 요구 이력보기 */
	function viewReqHistoryInList() {
		var cnt = 0;
		if(<%= intTotalRecordCount %> == 1) {
			if(eval("document.formName.ReqInfoID.checked") == true) {
                cnt = 1;
                document.formName.ReqID.value = document.formName.ReqInfoID.value;
            }
		} else {
			for (j = 0; j < <%= objRs.getRecordSize() %>; j++) {
				if (eval("document.formName.ReqInfoID[" + j + "].checked") == true) {
					document.formName.ReqID.value = document.formName.ReqInfoID[j].value;
					cnt++;
				}
			}
		}

  		if(cnt == 0) {
  			alert("요구를 선택하신 후에 버튼을 다시 클릭해 주세요");
  			return;
  		}
  		var popModal = window.showModalDialog('/reqsubmit/common/ViewReqHistory.jsp?ReqInfoID='+document.formName.ReqID.value,
  																'', 'dialogWidth:540px;dialogHeight:450px; center:yes; help:no; status:no; scroll:yes; resizable:yes');
	}

</script>
<script type="text/javascript">
	$(document).ready(function(){
		//alert ('jQuery running');
		
		/* 기본 설정값 세팅 */
		var defaults = {
			w : 170, /*레이어 너비*/
			padding: 0,
			bgColor: '#F6F6F6',
			borderColor: '#333'
		};
		
		var options = $.extend(defaults, options);
		
		/* 레이어 창 닫기 */
		$(".tooltip_close").click(function(){
			$(this).parents(".tooltip").css({display:'none'});
		});
		
		/* 마우스 오버시 */
		$('span.tooltip_text').hover(
			function(over){

				var top = $(this).offset().top;
				var left = $(this).offset().left;
				
				$(".tooltip").css({display:'none'});
				
				$(this).next(".tooltip").css({
					display:'',
					top:  top + 20 + 'px',
					left: left + 'px',
					background : options.bgColor,
					padding: options.padding,
					paddingRight: options.padding+1,
					width: (options.w+options.padding)
				});
				
				
			},
			/* 마우스 아웃시 */			   
			function(out){
				//$(this).html(currentText);
				//$('#link-text').pa
			}
		);
		
		


		
	});
	
	function test(){
		//$("button").next().css()
		//$("button").css({top});
	}
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<div id="wrap">
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
			String strReqBoxSortField=objParams.getParamValue("ReqBoxSortField");
			String strReqBoxSortMtd=objParams.getParamValue("ReqBoxSortMtd");
			//요구함 페이지 번호 받기.
			String strReqBoxPagNum=objParams.getParamValue("ReqBoxPageNum");
			//요구함 조회정보 받기.
			String strReqBoxQryField=objParams.getParamValue("ReqBoxQryField");
			String strReqBoxQryTerm=objParams.getParamValue("ReqBoxQryTerm");

			//요구 정보 정렬 정보 받기.
			String strReqInfoSortField=objParams.getParamValue("ReqInfoSortField");
			String strReqInfoSortMtd=objParams.getParamValue("ReqInfoSortMtd");
			//요구함 정보 페이지 번호 받기.
			String strReqInfoPagNum=objParams.getParamValue("ReqInfoPageNum");
		%>
	    <input type="hidden" name="ReqBoxID" value="<%=objParams.getParamValue("ReqBoxID")%>">
	    <input type="hidden" name="CmtOrganID" value="<%=objParams.getParamValue("CmtOrganID")%>">
		<input type="hidden" name="AuditYear" value="<%=objParams.getParamValue("AuditYear")%>">
		<input type="hidden" name="ReqBoxSortField" value="<%=strReqBoxSortField%>"><!--요구함목록정렬필드 -->
		<input type="hidden" name="ReqBoxSortMtd" value="<%=strReqBoxSortMtd%>"><!--요구함목록정령방법-->
		<input type="hidden" name="ReqBoxPage" value="<%=strReqBoxPagNum%>"><!--요구함 페이지 번호 -->
		<input type="hidden" name="ReqInfoSortField" value="<%=strReqInfoSortField%>"><!--요구정보 목록정렬필드 -->
		<input type="hidden" name="ReqInfoSortMtd" value="<%=strReqInfoSortMtd%>"><!--요구정보 목록정령방법-->
		<input type="hidden" name="ReqInfoPage" value="<%=strReqInfoPagNum%>"><!--요구정보 페이지 번호 -->
		<input type="hidden" name="ReqID" value=""><!--요구정보 ID-->
      <!-- pgTit -->
      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=MenuConstants.COMM_REQ_BOX_SUBMT_END%><span class="sub_stl" >- <%=MenuConstants.REQ_BOX_DETAIL_VIEW%></span></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.REQUEST_BOX_COMM%> > <%=MenuConstants.COMM_REQ_BOX_SUBMT_END%></div>
        <p><!--문구--></p>
      </div>
      <!-- /pgTit -->

      <!-- contents -->

      <div id="contents">

        <!-- 검색조건 없는 경우 아래 div 삭제 나 주석으로 막으세요.-->
        <!-- /검색조건-->


        <!-- 각페이지 내용 -->
         <!-- list view-->

        <span class="list02_tl">요구함 정보</span>
        <div class="top_btn"><samp>
			 <span class="btn"><a href="javascript:gotoList();">요구함 목록</a></span>
		</samp></div>

        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list02">
		<%
			//요구함 진행 상태.
			String strIngStt=(String)objRsSH.getObject("ING_STT");
		%>
            <tr>
              <th width="100px;" >&bull;&nbsp;요구함명 </th>
				  <td colspan="3"><%= objRsSH.getObject("REQ_BOX_NM") %>
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
              <th>&bull;&nbsp;소관 위원회 </th>
			  <td><%= objRsSH.getObject("CMT_ORGAN_NM") %></td>
            </tr>
            <tr>
              <th>&bull;&nbsp;업무구분  </th>
			  <td><%= objCdinfo.getRelatedDuty((String)objRsSH.getObject("RLTD_DUTY")) %></td>
            </tr>
             <tr>
              <th>&bull;&nbsp;발송정보 </th>
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
						 <td class="fonts"><%=(String)objRsSH.getObject("REGR_NM")%> (<a href="mailto:<%=(String)objRsSH.getObject("REGR_EMAIL")%>"><%=(String)objRsSH.getObject("REGR_EMAIL")%></a> / <%=(String)objRsSH.getObject("REGR_CPHONE")%>)</td>
						 <td class="fonts"><%=(String)objRsSH.getObject("RCVR_NM")%></td>
					 </tr>
				 </table>
			</td>

            </tr>
                <tr>

              <th>&bull;&nbsp;요구함이력 </th>  <td colspan="3">



              <ul class="list_in">
              <li><span class="tl">&bull;&nbsp;요구함생성일시 :</span> <%=StringUtil.getDate2((String)objRsSH.getObject("REG_DT"))%></li>
              <li><span class="tl">&bull;&nbsp;요구서 수신일 :</span> <%=StringUtil.getDate2((String)objRsSH.getObject("LAST_REQ_DOC_SND_DT"))%></li>
              <li><span class="tl">&bull;&nbsp;제출기관 조회일 :</span> <%=StringUtil.getDate2((String)objRsSH.getObject("FST_QRY_DT"))%></li>
              <li><span class="tl"><strong>&bull;&nbsp;제출기한 :</span> <%=StringUtil.getDate((String)objRsSH.getObject("SUBMT_DLN"))%> 24:00</strong></li>
              <li><span class="tl"><strong>&bull;&nbsp;답변서 발송일시 :</span> <%=StringUtil.getDate2((String)objRsSH.getObject("LAST_ANS_DOC_SND_DT"))%></strong></li>

              </ul>
              </td>

            </tr>
                <tr>
              <th>&bull;&nbsp;요구함설명 </th>   <td colspan="3"><%= objRsSH.getObject("REQ_BOX_DSC") %></td>
            </tr>
        </table>
        <!-- /list view -->
        <!-- 리스트 버튼-->
<!--
요구함 목록, 바인딩, 요구서 보기, 답변서 미리 보기, 답변서 발송, 오프라인 제출
-->
        <div id="btn_all"><div  class="t_right">
		<%
		//접수중 요구함(접수완료-행정직원,요구함목록)
		//접수완료 요구함((요구서보기,결재및발송,(요구함삭제)-행정직원,요구함목록)-버튼모양다르게)
		//발송완료요구함(요구서보기-행정직원,요구함목록)
		//제출완료요구함(요구서보기,제출문서보기-행정직원,요구함목록)
		    if(!strReqSubmitFlag.equals("004")){
			    if(CodeConstants.DOC_VIEW_YEAR <= intAuditYear){
			    %>
    			<div class="mi_btn" style="float:right"><a href="javascript:ReqDocOpenView('<%=objParams.getParamValue("ReqBoxID")%>','002')"><span>요구서 보기</span></a></div>
	    		<div class="mi_btn" style="float:right"><a href="javascript:AnsDocOpenView('<%=objParams.getParamValue("ReqBoxID")%>');"><span>답변서 보기</span></a></div>
			    <%
				}
			}
			%>
		</div></div>

        <!-- /리스트 버튼-->

        <!-- list -->
        <span class="list01_tl">요구 목록 <span class="list_total">&bull;&nbsp;전체자료수 : <%= intTotalRecordCount %>개 (<%= intCurrentPageNum %>/<%= intTotalPage %> page)</span></span>

        <table width="100%" style="padding:0;">
            <tr>
                <td>&nbsp;</td>
            </tr>
        </table>
        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
          <thead>
            <tr>
              <th style="width:10px;"><a>NO</a></th>
              <th style="width:250px;"><%=SortingUtil.getSortLink("changeSortQuery","REQ_CONT",strReqInfoSortField,strReqInfoSortMtd,"요구제목")%></th>
              <th><%= SortingUtil.getSortLink("changeSortQuery", "REQ_STT", strReqInfoSortField, strReqInfoSortMtd, "상태") %></th>
              <th><%= SortingUtil.getSortLink("changeSortQuery", "OPEN_CL", strReqInfoSortField, strReqInfoSortMtd, "공개등급") %></th>
              <th><a>답변</a></th>
              <th><a>첨부</a></th>
              <th><%=SortingUtil.getSortLink("changeSortQuery","LAST_ANS_DT",strReqInfoSortField,strReqInfoSortMtd,"최종답변일시")%></th>
            </tr>
          </thead>
          <tbody>
		<%

			int intRecordNumber= intTotalRecordCount - ((intCurrentPageNum -1) * Integer.parseInt((String)objParams.getParamValue("ReqInfoPageSize")));
			int strNumber = intRecordNumber;
			String strReqInfoID="";

			if(objRs.getRecordSize()>0){
				while(objRs.next()){
					 strReqInfoID=(String)objRs.getObject("REQ_ID");
		 %>
            <tr>
              <td><input name="ReqInfoID" type="checkbox" value="<%= strReqInfoID %>"  class="borderNo" onClick="javascript:checkBoxValidate(<%= (intRecordNumber-strNumber) %>)" /></td>
              <td><a href="javascript:gotoDetail('<%=objRsSH.getObject("REQ_BOX_ID")%>','<%=objRs.getObject("REQ_ID")%>')"><%=objRs.getObject("REQ_CONT")%></a></td>
              <td><%=CodeConstants.getRequestStatus((String)objRs.getObject("REQ_STT")) %></td>
              <td><%=CodeConstants.getOpenClass((String)objRs.getObject("OPEN_CL")) %></td>  
			  <td>
			  <span class="tooltip_text"><%=this.makeAnsInfoImg((String)objRs.getObject("ANS_ID"),(String)objRs.getObject("ANS_MTD"),(String)objRs.getObject("ANS_OPIN"),(String)objRs.getObject("SUBMT_FLAG"),objUserInfo.isRequester(),"","_blank","")%></span> 
				<div class="tooltip" style="display:none;">
					<table width=100% height=100%>
					  <tr>
					   <td width=100% height=5% style="align:right">
						<img src="/images/bt-close.gif" style="cursor:hand" align="absmiddle" border="0" class="tooltip_close">
					   </td>
					  </tr>
					  <tr> 
					   <td  bgcolor="#FFFFFF" align="left" ><%=this.makeAnsInfoHtml2((String)objRs.getObject("ANS_ID"),(String)objRs.getObject("ANS_MTD"),(String)objRs.getObject("ANS_OPIN"),(String)objRs.getObject("SUBMT_FLAG"),objUserInfo.isRequester(),"","_blank","")%></td>
					  </tr>
					 </table>
				</div>
			  </td>
              <td><%=makeAttachedFileLink((String)objRs.getObject("ANS_ESTYLE_FILE_PATH"))%></td>
              <td><%=StringUtil.getDate2((String)objRs.getObject("LAST_ANS_DT"))%></td>
            </tr>
				<%
						intRecordNumber++;
					} //endwhile
				} else {
				%>
					<tr>
						<td colspan="7" height="35" align="center">등록된 요구정보가 없습니다.</td>
					</tr>
				<%
				}//endif
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
							objParams.getParamValue("ReqInfoPageSize")))
						%>

       <!-- /페이징-->


       <!-- 리스트 버튼-->
        <div id="btn_all" >        <!-- 리스트 내 검색 -->
        <div class="list_ser" >
		<%
			String strReqInfoQryField=(String)objParams.getParamValue("ReqInfoQryField");
		%>
          <select name="ReqInfoQryField" class="selectBox5"  style="width:70px;" >
			<option <%=(strReqInfoQryField.equalsIgnoreCase("req_cont"))? " selected ": ""%>value="req_cont">요구 제목</option>
			<option <%=(strReqInfoQryField.equalsIgnoreCase("req_dtl_cont"))? " selected ": ""%>value="req_dtl_cont">요구내용</option>
          </select>
          <input name="iptName" onKeyDown="return ch()" onMouseDown="return ch()" value="<%=objParams.getParamValue("ReqInfoQryTerm")%>"
		 class="li_input"  style="width:100px"/>
          <img src="/images2/btn/bt_list_search.gif"  onMouseOver="menuOn(this);" onMouseOut="menuOut(this);" onClick="formName.submit()"/> </div>
        <!-- /리스트 내 검색 -->
			<span class="right">
			<span class="list_bt"><a href="javascript:viewReqHistoryInList()">요구이력보기</a></span>
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
  </div>
  <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>
<%!

	public static String makeAnsInfoHtml2(String strAnsIDs,String strAnsMtds,String strAnsOpins,String strSubmtFlags, boolean blnIsRequester,String strKeywords,String strLinkTarget,String strSummary){
		if(strLinkTarget.equals("0")){
			strLinkTarget="_blank";
		}else if(strLinkTarget.equals("1")){
			strLinkTarget="_self";
		}
		String strMsgSummary=StringUtil.getEmptyIfNull(strSummary,"PDF문서");
		String strTop="";		//출력용 상단 문자열<a><talbe>
		String strMiddle="";	//출력용 중간 <tr></tr>+
		String strBottom="";	//출력용 하단 문자열..</table></a>
		if(strAnsIDs==null || strAnsIDs.trim().equals("")){
			return "";//답변없음 아이콘.
		}
		if(strAnsOpins!=null){
			strAnsOpins=strAnsOpins.replaceAll("'"," ");
			strAnsOpins=strAnsOpins.replaceAll("\""," ");
		}else{
			strAnsOpins="";
		}
		StringTokenizer strTokenAnsIDs=new StringTokenizer(strAnsIDs,",");
		StringTokenizer strTokenAnsMtds=new StringTokenizer(strAnsMtds,",");
		StringTokenizer strTokenAnsOpins=new StringTokenizer(strAnsOpins,",");
		StringTokenizer strTokenSubmtFlags=new StringTokenizer(strSubmtFlags,",");
		StringBuffer strBufReturn=new StringBuffer();
		String strAnsID=null;
		String strAnsMtd=null; 
		String strAnsOpin=null;
		String strSubmtFlag="Y";
		int intAnsCount=0;
		
		while(strTokenAnsIDs.hasMoreElements()&& strTokenAnsMtds.hasMoreElements() && strTokenSubmtFlags.hasMoreElements() ){
			strAnsID=strTokenAnsIDs.nextToken();
			strAnsMtd=strTokenAnsMtds.nextToken();
			strSubmtFlag=strTokenSubmtFlags.nextToken();
			try{
				if(strTokenAnsOpins.hasMoreElements()){
					strAnsOpin=strTokenAnsOpins.nextToken();
				}else{
					strAnsOpin="";
				}
			}catch(NoSuchElementException ex){
				strAnsOpin="";
			}
			strAnsOpin=StringUtil.getEmptyIfNull(strAnsOpin);
			strAnsOpin=strAnsOpin.replace('\n',' ');
			strAnsOpin=strAnsOpin.replace('\r',' ');
			//요구자(true)이면서 답변완료(Y) 이거나 제출자(false)이면 답변내용 보이게하기.
			if((blnIsRequester && strSubmtFlag.equalsIgnoreCase("Y")) || blnIsRequester==false){
				//<tr>시작
				if(strAnsMtd.equals(CodeConstants.ANS_MTD_ELEC)){
					strBufReturn.append("<img src='/image/reqsubmit/bt_EDoc.gif' width='73' height='16' border='0' alt='" + strAnsOpin + "'>");
					if(StringUtil.isAssigned(strKeywords)){
						strBufReturn.append("<a href='/reqsubmit/common/ReqFileOpenHL.jsp?ansID=" + strAnsID + "&keyword=" +  strKeywords+ "&DOC=PDF' target='" + strLinkTarget + "'>");						
					}else{
						strBufReturn.append("<a href='/reqsubmit/common/ReqFileOpen.jsp?paramAnsId=" + strAnsID + "&DOC=PDF' target='" + strLinkTarget + "'>");
					}
					/** 제거됨 2004.05.13
					if(intAnsCount>0){//처음한번만 요약문 보여준다고함.
						strMsgSummary="PDF문서";
					}
					 */
					strBufReturn.append("<img src='/image/common/icon_pdf.gif' width='16' height='16' border='0' alt='" + strMsgSummary + "'>");
					strBufReturn.append("</a>");
					strBufReturn.append("&nbsp;<a href='/reqsubmit/common/ReqFileOpen.jsp?paramAnsId=" + strAnsID + "&DOC=DOC' target='_self'>");
					strBufReturn.append("<img src='/image/common/icon_file.gif' border='0' alt='원본문서'>");
					strBufReturn.append("</a>");
					strBufReturn.append("<br>");
				}else if(strAnsMtd.equals(CodeConstants.ANS_MTD_ETCS)){
					strBufReturn.append("<img src='/image/reqsubmit/bt_NotEDoc.gif' width='73' height='16' border='0' alt='" + strAnsOpin + "'>");
					strBufReturn.append("<br>");					
				}else if(strAnsMtd.equals("004")){
					strBufReturn.append("<img src='/image/reqsubmit/bt_offLineSubmit.gif' width='73' height='16' border='0' alt='오프라인을 통한 제출'>");
					strBufReturn.append("<br>");					
				}else {
					strBufReturn.append("<img src='/image/reqsubmit/bt_NotPertinentOrg.gif' width='73' height='16' border='0' alt='" + strAnsOpin + "'>");
					strBufReturn.append("<br>");					
				}
				//</tr>끝 
				intAnsCount++; //답변개수 카운트 올림.
			}
		}
		
		strMiddle=strBufReturn.toString();//중간문자열 받기.
		
		
		//답변으로 출력될 내용이 있으면 출력.
		if(intAnsCount>0){
			return  strMiddle;
		}else{
			return "";//답변없음 아이콘.
		}
	}

	public static String makeAnsInfoImg(String strAnsIDs,String strAnsMtds,String strAnsOpins,String strSubmtFlags, boolean blnIsRequester,String strKeywords,String strLinkTarget,String strSummary){
		
		if(strAnsIDs==null || strAnsIDs.trim().equals("")){
			return "<img src='/image/reqsubmit/icon_noAnswer.gif' border='0'>";//답변없음 아이콘.
		}		
				
		StringTokenizer strTokenAnsIDs=new StringTokenizer(strAnsIDs,",");
		StringTokenizer strTokenAnsMtds=new StringTokenizer(strAnsMtds,",");
		StringTokenizer strTokenAnsOpins=new StringTokenizer(strAnsOpins,",");
		StringTokenizer strTokenSubmtFlags=new StringTokenizer(strSubmtFlags,",");
		StringBuffer strBufReturn=new StringBuffer();
		String strAnsID=null;
		String strAnsMtd=null; 
		String strAnsOpin=null;
		String strSubmtFlag="Y";
		int intAnsCount=0;
		
		while(strTokenAnsIDs.hasMoreElements()&& strTokenAnsMtds.hasMoreElements() && strTokenSubmtFlags.hasMoreElements() ){	
			strAnsID=strTokenAnsIDs.nextToken();
			strAnsMtd=strTokenAnsMtds.nextToken();
			strSubmtFlag=strTokenSubmtFlags.nextToken();
			try{
				if(strTokenAnsOpins.hasMoreElements()){
					strAnsOpin=strTokenAnsOpins.nextToken();
				}else{
					strAnsOpin="";
				}
			}catch(NoSuchElementException ex){
				strAnsOpin="";
			}
			//요구자(true)이면서 답변완료(Y) 이거나 제출자(false)이면 답변내용 보이게하기.
			if((blnIsRequester && strSubmtFlag.equalsIgnoreCase("Y")) || blnIsRequester==false){
				intAnsCount++; //답변개수 카운트 올림.
			}
		}				
		
		//답변으로 출력될 내용이 있으면 출력.
		if(intAnsCount>0){
			return "<img src='/image/reqsubmit/icon_answer.gif' border='0'>";
		}else{
			return "<img src='/image/reqsubmit/icon_noAnswer.gif' border='0'>";//답변없음 아이콘.
		}
	}

%>
