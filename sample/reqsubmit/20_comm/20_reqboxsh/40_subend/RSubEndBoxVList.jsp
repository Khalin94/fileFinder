<%@ page language="java" contentType="text/html;charset=EUC-KR" %>

<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.pf.util.PageCount"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RCommReqBoxVListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.CommRequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.CommRequestInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.cmtmanager.CmtManagerConfirmDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.answerinfo.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.SMemReqBoxDelegate" %>

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
	RCommReqBoxVListForm objParams =new RCommReqBoxVListForm();
	AnsInfoDelegate objSMAIDelegate = new AnsInfoDelegate();
    //추가답변 후 제출여부확인
    SMemReqBoxDelegate sReqDelegate = new SMemReqBoxDelegate();
	objParams.setParamValue("IsRequester",String.valueOf(objUserInfo.isRequester()));//요구답변자여부설정

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
	}
	//플래그값 변경을 위한 추가 2016.02.22 ksw
	String strBoxId = request.getParameter("ReqBoxID");
	//답변완료된 후에 추가답변 있는지 여부 확인
	int intNotSubmitAnsCnt = sReqDelegate.getAnsCntNotSubmit(strBoxId);
	System.out.println("kangthis logs RSubEndBoxVList.jsp(strBoxId) => " + strBoxId);
	System.out.println("kangthis logs RSubEndBoxVList.jsp(intNotSubmitAnsCnt) => " + intNotSubmitAnsCnt);
	if (intNotSubmitAnsCnt > 0) {
		int intUpdateResult = objSMAIDelegate.setRecordToAnsInfo_view1(strBoxId);		
	}

	//로그인 사용자 정보를 가져온다. 권한없음 경우 관람만 가능하다.
	String strReqSubmitFlag = objUserInfo.getReqSubmitFlag();

	/*** Delegate 과 데이터 Container객체 선언 */
	CommRequestBoxDelegate objReqBox=null; 		/**요구함 Delegate*/
	CommRequestInfoDelegate  objReqInfo=null;		/** 요구정보 Delegate */
	ResultSetSingleHelper objRsSH=null;			/** 요구함 상세보기 정보 */
	ResultSetHelper objRs=null;					/**요구 목록 */
	boolean strflag2 = true;
	String strOpenCl = "";
	String strListMsg = "";
	String strOrganID = objUserInfo.getOrganID();
	String strOldReqOrganId = "";
	String strCmtOpenCl = request.getParameter("OpenCl");
    String strReqBoxId = (String)objParams.getParamValue("ReqBoxID");
	String strTempBoxID = strReqBoxId.substring(0,1);
	String strREQBOXSTT = CodeConstants.REQ_BOX_STT_007;
	System.out.println("strTempBoxID : "+strTempBoxID);
	boolean tempflag = false;
	String[] strEx = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "0"};

	for(int i = 0; i < strEx.length ; i++){
		if(strEx[i].equals(strTempBoxID)){
			tempflag = true;
		}
	}

	if(tempflag == false){
		strREQBOXSTT = "TOT";
	}

	CmtManagerConfirmDelegate cmtmanagerCn = new CmtManagerConfirmDelegate();
	try {
		/**요구함 정보 대리자 New */
		objReqBox=new CommRequestBoxDelegate();

		/**요구함 이용 권한 체크 */
		objRsSH=new ResultSetSingleHelper(objReqBox.getRecord((String)objParams.getParamValue("ReqBoxID"), strREQBOXSTT));

		boolean blnHashAuth=objReqBox.checkReqBoxAuth((String)objParams.getParamValue("ReqBoxID"),objUserInfo.getCurrentCMTList()).booleanValue();
		if(!blnHashAuth) {
			if(!strOrganID.equals((String)objRsSH.getObject("OLD_REQ_ORGAN_ID")))
{
			objMsgBean.setMsgType(MessageBean.TYPE_WARN);
			objMsgBean.setStrCode("DSAUTH-0001");
			objMsgBean.setStrMsg("해당 요구함을 볼 권한이 없습니다.");
			//out.println("해당 요구함을 볼 권한이 없습니다.");
%>
			<jsp:forward page="/common/message/ViewMsg3.jsp"/>
<%
			return;
			}
		}

		/** 요구함 정보 */

		/**요구 정보 대리자 New */
		objReqInfo=new CommRequestInfoDelegate();
		objRs=new ResultSetHelper((Hashtable)objReqInfo.getRecordList(objParams));

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
							strflag2 = false;
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
		//out.println("<br>Error!!!" + objAppEx.getMessage());
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}

	//int intAuditYear = Integer.parseInt((String)objParams.getParamValue("AuditYear"));

	/**요구정보 목록조회된 결과 반환.*/
	int intTotalRecordCount=objRs.getTotalRecordCount();
	int intCurrentPageNum=objRs.getPageNumber();
	int intTotalPage=objRs.getTotalPageCount();
%>
<jsp:include page="/inc/header.jsp" flush="true"/>
<link href="/css2/style.css" rel="stylesheet" type="text/css">
<style type="text/css">
	.tooltip_text, .tooltip_close{
		cursor: pointer;
	}
	div.tooltip {
		
		position:absolute;
	}
</style>
<script language="javascript">
  //요구상세보기로 가기.
  function gotoDetail(strReqBoxID, strCommReqID){
    form=document.formName;
  	form.ReqBoxID.value=strReqBoxID;
  	form.CommReqID.value=strCommReqID;
  	form.action="./RSubEndReqInfo.jsp";
  	form.submit();
  }

  /** 목록으로 가기 */
  function gotoList(){
  	form=document.formName;
  	form.action="./RSubEndBoxList.jsp";
  	form.submit();
  }

  /** 정렬방법 바꾸기 */
  function changeSortQuery(sortField,sortMethod){
  	form=document.formName;
  	form.CommReqInfoSortField.value=sortField;
  	form.CommReqInfoSortMtd.value=sortMethod;
  	form.submit();
  }

  /** 페이징 바로가기 */
  function goPage(strPage){
  	form=document.formName;
  	form.CommReqInfoPage.value=strPage;
  	form.submit();
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

<body>
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
	<SCRIPT language="JavaScript" src="/js/reqsubmit/reqboxview.js"></SCRIPT>
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
        <h3><%=MenuConstants.COMM_REQ_BOX_SUBMT_END%><span class="sub_stl" >- 요구함 상세보기</span></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> > <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.REQUEST_BOX_COMM%> > <%=MenuConstants.COMM_REQ_BOX_SUBMT_END%></div>
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

        <table border="0" cellspacing="0" cellpadding="0" width="680" class="list02">
		<%
			//요구함 진행 상태.
			String strIngStt=(String)objRsSH.getObject("ING_STT");
		%>
            <tr>
                <th width="100px;" height="25">&bull; 요구함명 </th>
                <td height="25" colspan="3"><strong><%=objRsSH.getObject("REQ_BOX_NM")%></strong>
				<%
   				// 2004-06-17 kogaeng ADD
   				String strElcDocNo = (String)objRsSH.getObject("DOC_NO");
				if (StringUtil.isAssigned(strElcDocNo)) {
                    out.println(" (전자결재번호 : "+strElcDocNo+")");
   				}
       			%>
				</td>
            </tr>
            <tr>
                <th height="25">&bull; 업무구분 </th>
                <td height="25" colspan="3">- <%=objCdinfo.getRelatedDuty((String)objRsSH.getObject("RLTD_DUTY"))%></td>
            </tr>
             <tr>
              <th scope="col">&bull;&nbsp;제출정보 </th>
			  <td colspan="3">
				 <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list_none">
					 <tr>
						 <td width="17" rowspan="2"><img src="/images2/common/icon_assembly.gif" width="16" height="13" /></td>
						 <td><%=(String)objRsSH.getObject("SUBMT_ORGAN_NM")%></td>
						 <td rowspan="2"><img src="/images2/common/arrow01.gif" width="26" height="14" /></td>
						 <td width="15" rowspan="2"><img src="/images2/common/icon_cube.gif" width="11" height="15" /></td>
						 <td><%=objRsSH.getObject("CMT_ORGAN_NM")%></td>
					 </tr>
					 <tr>
						 <td class="fonts"><%=(String)objRsSH.getObject("RCVR_NM")%> (<a href="mailto:<%=(String)objRsSH.getObject("RCVR_EMAIL")%>"><%=(String)objRsSH.getObject("RCVR_EMAIL")%></a>) <%if(tempflag){%>(<%=(String)objRsSH.getObject("RCVR_OFFICE_TEL")%>/<%=(String)objRsSH.getObject("RCVR_CPHONE")%>)<%}%></td>
						 <td class="fonts"><%=(String)objRsSH.getObject("REGR_NM")%></td>
					 </tr>
				 </table>
			</td>
            </tr>
             <tr>
              <th scope="col">&bull;&nbsp;요구함이력 </th>
			  <td colspan="3">
              <ul class="list_in">
              <li><span class="tl">&bull;&nbsp;접수기간 :</span> <%=StringUtil.getDate((String)objRsSH.getObject("ACPT_BGN_DT"))%> ~ <%=StringUtil.getDate((String)objRsSH.getObject("ACPT_END_DT"))%></li>
              <li><span class="tl">&bull;&nbsp;요구함생성일시 :</span> <%=StringUtil.getDate2((String)objRsSH.getObject("REG_DT"))%></li>
              <li><span class="tl">&bull;&nbsp;요구서발송일시 :</span> <%=StringUtil.getDate2((String)objRsSH.getObject("LAST_REQ_DOC_SND_DT"))%></li>
              <li><span class="tl">&bull;&nbsp;제출기관조회일시 :</span> <%=StringUtil.getDate2((String)objRsSH.getObject("FST_QRY_DT"))%></li>
              <li><span class="tl">&bull;&nbsp;제출기한 :</span> <strong><%=StringUtil.getDate((String)objRsSH.getObject("SUBMT_DLN"))%> 24:00</strong></li>
			  <li><span class="tl">&bull;&nbsp;답변서제출일시 :</span> <strong><%=StringUtil.getDate2((String)objRsSH.getObject("LAST_ANS_DOC_SND_DT"))%></strong></li>
              </ul>
              </td>
            </tr>
            <tr>
                <th height="25">&bull; 요구함설명 </th>
                <td height="25" colspan="3"><%=StringUtil.getDescString((String)objRsSH.getObject("REQ_BOX_DSC"))%>
				</td>
            </tr>
        </table><br><br>
        <!-- /list view -->
        <!--<p class="warning mt10">* 요구서 발송 : 의원실(또는 소속기관) 명의로 해당 제출기관에 요구서를 발송합니다.</p>  -->

        <div id="btn_all"><div  class="t_right">
        <%
            /** 위원회 행정직원 일때만 화면에 출력함.*/
            //if(objUserInfo.getOrganGBNCode().equals("004") && !strReqSubmitFlag.equals("004")){
            //	if(CodeConstants.DOC_VIEW_YEAR <= intAuditYear){
        %>
				<%if(objUserInfo.getOrganGBNCode().equals("004") && !strReqSubmitFlag.equals("004")){%>
			 <div class="mi_btn"><a href="javascript:ReqDocOpenView('<%=objParams.getParamValue("ReqBoxID")%>','002')"><span>요구서 보기</span></a></div>
			 <div class="mi_btn"><a href="javascript:AnsDocOpenView('<%=objParams.getParamValue("ReqBoxID")%>')"><span>답변서 보기</span></a></div>
				<%}else{%>
				<%if(strOldReqOrganId.equals(strOrganID)){%>
			 <div class="mi_btn"><a href="javascript:ReqDocOpenView('<%=objParams.getParamValue("ReqBoxID")%>','002')"><span>요구서 보기</span></a></div>
			 <div class="mi_btn"><a href="javascript:AnsDocOpenView('<%=objParams.getParamValue("ReqBoxID")%>')"><span>답변서 보기</span></a></div>
				<%}}%>
		<%
			//	}
			//}
		%>
        </div></div>

        <!-- list -->
        <span class="list01_tl">요구 목록 <span class="list_total">&bull;&nbsp;전체자료수 : <%= intTotalRecordCount %>개 (<%= intCurrentPageNum %>/<%= intTotalPage %> page) </span></span>
			<table width="100%" style="padding:0;">
			   <tr>
				<td>&nbsp;</td>
			   </tr>
			  </table>




        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
          <thead>
			</tr>
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
			int intRecordNumber=0;
			if(intCurrentPageNum == 1){
				intRecordNumber= 1;
			} else {
				intRecordNumber=  ((intCurrentPageNum-1) * Integer.parseInt((String)objParams.getParamValue("CommReqInfoPageSize")))+1;
			}
			String strReqInfoID="";

			if(objRs.getRecordSize()>0){
				while(objRs.next()){
					 strReqInfoID=(String)objRs.getObject("REQ_ID");
			 %>
            <tr>
              <td><%=intRecordNumber%></td>
              <td style="text-align:left;"><a href="javascript:gotoDetail('<%=objRsSH.getObject("REQ_BOX_ID")%>','<%=objRs.getObject("REQ_ID")%>')" hint="<%= StringUtil.substring((String)objRs.getObject("REQ_DTL_CONT"), 80) %>"><%=objRs.getObject("REQ_CONT")%></a></td>
              <td><%=objRs.getObject("OLD_REQ_ORGAN_NM")%></td>
              <td><%=CodeConstants.getOpenClass((String)objRs.getObject("OPEN_CL"))%></td> <td>
			  <span class="tooltip_text"><%=this.makeAnsInfoImg((String)objRs.getObject("ANS_ID"),(String)objRs.getObject("ANS_MTD"),(String)objRs.getObject("ANS_OPIN"),(String)objRs.getObject("SUBMT_FLAG"),objUserInfo.isRequester(),"","_blank","")%></span> 
				<div class="tooltip" style="display:none;">
					<table width=100% height=100%>
					  <tr>
					   <td width=100% height=5% style="align:right">
						<img src="/images/bt-close.gif" style="cursor:hand" align="absmiddle" border="0" class="tooltip_close">
					   </td>
					  </tr>
					  <tr> 
					   <td  bgcolor="#FFFFFF" align="left" ><%=this.makeAnsInfoHtml2((String)objRs.getObject("ANS_ID"),(String)objRs.getObject("ANS_MTD"),(String)objRs.getObject("ANS_OPIN"),(String)objRs.getObject("SUBMT_FLAG"),objUserInfo.isRequester(),"","_blank","",StringUtil.substring((String)objRs.getObject("REQ_CONT"),35),(String)objRsSH.getObject("SUBMT_ORGAN_NM"))%></td>
					  </tr>
					 </table>
				</div>
			  </td>
              <td><%=StringUtil.getDate2((String)objRs.getObject("REG_DT"))%></td>

            </tr>
			  <%
				    intRecordNumber++;
					}//endwhile
				} else {
				%>
			<tr>
				<td colspan="6" height="35" align="center"><%=strListMsg%></td>
			</tr>
				<%
				}//endif
				%>

          </tbody>
        </table>

		<%=objPaging.pagingTrans(PageCount.getLinkedString(
						new Integer(intTotalRecordCount).toString(),
						new Integer(intCurrentPageNum).toString(),
						objParams.getParamValue("CommReqInfoPageSize")))%>

		<!-- 리스트 버튼-->
        <div id="btn_all" >        <!-- 리스트 내 검색 -->
        <div class="list_ser" >
	<%
	String strCommReqInfoQryField=(String)objParams.getParamValue("CommReqInfoQryField");
	%>
          <select name="CommReqInfoQryField" class="selectBox5"  style="width:70px;" >
            <option <%=(strCommReqInfoQryField.equalsIgnoreCase("req_cont"))? " selected ": ""%>value="req_cont">요구 제목</option>
			<option <%=(strCommReqInfoQryField.equalsIgnoreCase("req_dtl_cont"))? " selected ": ""%>value="req_dtl_cont">요구내용</option>
			<option <%=(strCommReqInfoQryField.equalsIgnoreCase("old_req_organ_nm"))? " selected ": ""%>value="old_req_organ_nm">요구기관</option>
          </select>
          <input name="CommReqInfoQryTerm" onKeyDown="return ch()" onMouseDown="return ch()"
		 class="li_input"  style="width:100px" value="<%=objParams.getParamValue("CommReqInfoQryTerm")%>"/>
          <img src="/images2/btn/bt_list_search.gif"  onMouseOver="menuOn(this);" onMouseOut="menuOut(this);" onClick="formName.submit();"/> </div>
        <!-- /리스트 내 검색 -->
			<span class="right">
		<%
		/** 위원회 행정직원 일때만 화면에 출력함.*/
		if(objUserInfo.getOrganGBNCode().equals("004") && !strReqSubmitFlag.equals("004")){
		%>
				<span class="list_bt"><a href="javascript:submtBindingJob(formName,'<%=objRsSH.getObject("REQ_BOX_ID")%>')">바인딩</a></span>
		<% } %>
			</span>
		</div>
        <!-- /list -->


        <!-- /각페이지 내용 -->
      </div>
</form>
      <!-- /contents -->

    </div>
  </div>
  <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>

<%!

	public static String makeAnsInfoHtml2(String strAnsIDs,String strAnsMtds,String strAnsOpins,String strSubmtFlags, boolean blnIsRequester,String strKeywords,String strLinkTarget,String strSummary,String strReqCont,String strSubmtorganNm){
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
						strBufReturn.append("<a href='/reqsubmit/common/ReqFileOpen2.jsp?paramAnsId=" + strAnsID + "&DOC=PDF&REQNM=" + strReqCont + "&REQSEQ=" + (intAnsCount+1) + "&SubmtOrganNm="+strSubmtorganNm+"' target='_self'>");
					}
					/** 제거됨 2004.05.13
					if(intAnsCount>0){//처음한번만 요약문 보여준다고함.
						strMsgSummary="PDF문서";
					}
					 */
					strBufReturn.append("<img src='/image/common/icon_pdf.gif' width='16' height='16' border='0' alt='" + strMsgSummary + "'>");
					strBufReturn.append("</a>");
					strBufReturn.append("&nbsp;<a href='/reqsubmit/common/ReqFileOpen2.jsp?paramAnsId=" + strAnsID + "&DOC=DOC&REQNM=" + strReqCont + "&REQSEQ=" + (intAnsCount+1) + "&SubmtOrganNm="+strSubmtorganNm+"' target='_self'>");
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
