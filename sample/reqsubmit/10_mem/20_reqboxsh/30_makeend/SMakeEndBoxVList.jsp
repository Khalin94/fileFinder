<%@ page language="java" contentType="text/html;charset=EUC-KR" %>

<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.pf.util.PageCount"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.lib.reqsubmit.params.requestbox.SMemReqBoxVListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.SMemReqBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.SMemReqInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.MemRequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.common.page.PagingDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%
    /*** PagingDelegate */
    PagingDelegate objPaging=new PagingDelegate();         /*페이징 변환 Delegate*/
%>
<%
    UserInfoDelegate objUserInfo =null;
    CDInfoDelegate objCdinfo =null;
%>

<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>

<%
    SMemReqBoxDelegate selfDelegate = null;
    MemRequestBoxDelegate reqDelegate = null;
    SMemReqInfoDelegate reqInfoDelegate = null;

    SMemReqBoxVListForm objParams = new SMemReqBoxVListForm();
    //SReqInfoListForm objParams = new SReqInfoListForm();
    // 요구자 제출자 여부를 Form에 추가한다

      objParams.setParamValue("IsRequester", String.valueOf(objUserInfo.isRequester()));

    boolean blnParamCheck=false;
    blnParamCheck = objParams.validateParams(request);
    if(blnParamCheck==false) {
          objMsgBean.setMsgType(MessageBean.TYPE_WARN);
          objMsgBean.setStrCode("DSPARAM-0000");
          objMsgBean.setStrMsg(objParams.getStrErrors());
          out.println("ParamError:" + objParams.getStrErrors());
          return;
      }//endif

    // 넘어온 파라미터를 설정해서 필요할 ?? 쓰도록 하자
    // 요구함 관련
    String strReqBoxID = objParams.getParamValue("ReqBoxID");
    String strReqBoxSortField = objParams.getParamValue("ReqBoxSortField");
    String strReqBoxSortMtd = objParams.getParamValue("ReqBoxSortMtd");
    String strReqBoxPagNum = objParams.getParamValue("ReqBoxPage");
    String strReqBoxQryField = objParams.getParamValue("ReqBoxQryField");
    String strReqBoxQryTerm = objParams.getParamValue("ReqBoxQryTerm");

    // 요구 목록 관련
    String strReqInfoSortField = objParams.getParamValue("ReqInfoSortField");
    String strReqInfoSortMtd = objParams.getParamValue("ReqInfoSortMtd");
    String strReqInfoQryField = objParams.getParamValue("ReqInfoQryField");
    String strReqInfoQryTerm = objParams.getParamValue("ReqInfoQryTerm");
    String strReqInfoPagNum = objParams.getParamValue("ReqInfoPage");

    // 요구 개수 및 페이징 관련
    int intTotalRecordCount = 0;
    int intCurrentPageNum = 0;
    int intTotalPage = 0;

    ResultSetSingleHelper objRsSH = null;
    ResultSetHelper objRs = null;

    try{
        selfDelegate = new SMemReqBoxDelegate();
           reqDelegate = new MemRequestBoxDelegate();
           reqInfoDelegate = new SMemReqInfoDelegate();

           boolean blnHashAuth = reqDelegate.checkReqBoxAuth(strReqBoxID, objUserInfo.getOrganID()).booleanValue();

           if(!blnHashAuth) {
               objMsgBean.setMsgType(MessageBean.TYPE_WARN);
                objMsgBean.setStrCode("DSAUTH-0001");
                objMsgBean.setStrMsg("해당 요구함을 볼 권한이 없습니다.");
                out.println("해당 요구함을 볼 권한이 없습니다.");
            return;
        } else {
            // 요구함 등록 정보를 SELECT 한다.
            objRsSH = new ResultSetSingleHelper(selfDelegate.getRecord(strReqBoxID));
            // 요구 목록을 SELECT 한다.
            objRs = new ResultSetHelper(reqInfoDelegate.getRecordList(objParams));

             /**요구정보 목록조회된 결과 반환.*/
            intTotalRecordCount = objRs.getTotalRecordCount();
             intCurrentPageNum = objRs.getPageNumber();
             intTotalPage = objRs.getTotalPageCount();
        }
    } catch(AppException e) {
        objMsgBean.setMsgType(MessageBean.TYPE_ERR);
          objMsgBean.setStrCode(e.getStrErrCode());
          objMsgBean.setStrMsg(e.getMessage());
          out.println("<br>Error!!!" + e.getMessage());
          return;
     }
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
<script language="javascript" src="/js/reqsubmit/common.js"></script>
<script language="javascript">
    var f;
    // 요구서 보기
    function goReqDocView() {
        NewWindow('/reqsubmit/common/ReqDocView.jsp?ReqBoxId=<%= strReqBoxID %>&ReqTp=<%= CodeConstants.REQ_ORGAN_PERSON %>', '', '800', '600');
        //window.open("/reqsubmit/common/ReqDocView.jsp?ReqBoxId=<%= strReqBoxID %>&ReqTp=<%= CodeConstants.REQ_ORGAN_PERSON %>", "", "resizable=no,menubar=no,status=yes,titlebar=yes,scrollbars=no,location=no,toolbar=no,height=600,width=800" );
    }

    /** 답변서 보기 */
    function viewAnsDoc(){
          window.open("/reqsubmit/common/AnsDocView.jsp?ReqBoxId=<%= (String)objParams.getParamValue("ReqBoxID") %>", "",
    "resizable=no,menubar=no,status=yes,titlebar=yes,scrollbars=no,location=no,toolbar=no,height=600,width=800" );
    }

    // 요구 목록 조회
    function goReqBoxList() {
        f = document.viewForm;
        f.target = "";
        f.action = "SMakeEndBoxList.jsp";
        f.submit();
    }

    // 정렬방법 바꾸기
    function changeSortQuery(sortField, sortMethod){
        f = document.viewForm;
        f.target = "";
         f.ReqInfoSortField.value = sortField;
          f.ReqInfoSortMtd.value = sortMethod;
          f.submit();
      }

      // 요구 상세보기로 가기 */
      function gotoDetail(strID){
          f = document.viewForm;
          f.ReqID.value = strID;
        f.target = "";
         f.action="SMakeEndReqInfoVList.jsp";
          f.submit();
      }

      // 페이징 바로가기
      function goPage(strPage){
          f = document.viewForm;
          f.ReqInfoPage.value = strPage;
        f.target = "";
          f.submit();
      }

      /**
       * 2005-10-20 kogaeng ADD
       * 체크박스를 하나만 선택하게 하는 스크립트
       */
      function checkBoxValidate(cb) {
        if(<%= intTotalRecordCount %> == 1) {
            if(cb == 0) {
                document.viewForm.ReqInfoID.checked = true;
                document.viewForm.ReqID.value = document.viewForm.ReqInfoID.value;
                return;
            }
        }
        for (j = 0; j < <%= intTotalRecordCount %>; j++) {
            if (eval("document.viewForm.ReqInfoID[" + j + "].checked") == true) {
                document.viewForm.ReqInfoID[j].checked = false;
                if (j == cb) {
                    document.viewForm.ReqInfoID[j].checked = true;
                    document.viewForm.ReqID.value = document.viewForm.ReqInfoID[j].value;
                } else {
                    document.viewForm.ReqInfoID[j].checked = false;
                    document.viewForm.ReqID.value = "";
                }
            }
        }
    }


      /** 요구 이력보기 */
    function viewReqHistory() {
        var cnt = 0;
        if(<%= intTotalRecordCount %> == 1) {
            if(eval("document.viewForm.ReqInfoID.checked") == true) cnt = 1;
        } else {
            for (j = 0; j < <%= intTotalRecordCount %>; j++) {
                if (eval("document.viewForm.ReqInfoID[" + j + "].checked") == true) {
                    document.viewForm.ReqID.value = document.viewForm.ReqInfoID[j].value;
                    cnt++;
                }
            }
        }

          if(cnt == 0) {
              alert("요구를 선택하신 후에 버튼을 다시 클릭해 주세요");
              return;
          }
          var popModal = window.showModalDialog('/reqsubmit/common/ViewReqHistory.jsp?ReqInfoID='+document.viewForm.ReqID.value,
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

<body>
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
           <!-- pgTit -->
         <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3>
<%= MenuConstants.REQ_BOX_MAKE_END %>

 <span class="sub_stl" >- <%= MenuConstants.REQ_BOX_DETAIL_VIEW %></span></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> >  <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.getReqBoxGeneral(request)%> > <%=MenuConstants.REQ_BOX_MAKE_END%></div>
        <p><!--문구--></p>
      </div>
      <!-- /pgTit -->


      <!-- contents -->

      <div id="contents">
<form name="viewForm" method="post" action="" style="margin:0px">
                    <!-- 요구함 등록 정보 관련 -->
                    <input type="hidden" name="ReqBoxID" value="<%= strReqBoxID %>">
                    <input type="hidden" name="ReqBoxSortField" value="<%= strReqBoxSortField %>"><!--요구함목록정렬필드 -->
                    <input type="hidden" name="ReqBoxSortMtd" value="<%= strReqBoxSortMtd %>"><!--요구함목록정렬방법-->
                    <input type="hidden" name="ReqBoxPage" value="<%= strReqBoxPagNum %>"><!--요구함 페이지 번호 -->
                    <% if(StringUtil.isAssigned(strReqBoxQryTerm)) { %>
                    <input type="hidden" name="ReqBoxQryField" value="<%= strReqBoxQryField %>"><!--요구함 조회필드 -->
                    <input type="hidden" name="ReqBoxQryTerm" value="<%= strReqBoxQryTerm %>"><!--요구함 조회필드 -->
                    <% } //요구함 조회어가 있는 경우만 출력해서 사용함 %>

                    <!-- 요구 목록 관련 -->
                    <input type="hidden" name="ReqID" value=""> <!-- 요구 ID -->
                    <input type="hidden" name="ReqInfoSortField" value="<%= strReqInfoSortField %>"><!--요구정보 목록정렬필드 -->
                    <input type="hidden" name="ReqInfoSortMtd" value="<%= strReqInfoSortMtd %>"><!--요구정보 목록정렬방법-->
                    <input type="hidden" name="ReqInfoPage" value="<%= strReqInfoPagNum %>"><!-- 요구정보 페이지 번호 -->
        <!-- 검색조건 없는 경우 아래 div 삭제 나 주석으로 막으세요.-->
        <!-- /검색조건-->


        <!-- 각페이지 내용 -->
         <!-- list view-->

        <span class="list02_tl">요구함 등록 정보 </span>
        <div class="top_btn"><samp>
            <span class="btn"><a href="javascript:goReqBoxList()">요구함 목록</a></span>
        </samp></div>

        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list02">

            <tr>

              <th scope="col" width="100">&bull;&nbsp;요구함명 </th>
              <td colspan="3"><%= objRsSH.getObject("REQ_BOX_NM") %>
              <%
                // 2004-06-15 ADD
                String strElcDocNo = (String)objRsSH.getObject("DOC_NO");
                if (StringUtil.isAssigned(strElcDocNo)) {
                    out.println(" (전자결재번호 : "+strElcDocNo+")");
                }
            %>
              </td>

            </tr>

            <tr>

              <th scope="col">&bull;&nbsp;소관 위원회 </th>   <td><%= objRsSH.getObject("CMT_ORGAN_NM") %></td>

            </tr>
            <tr>

              <th scope="col">&bull;&nbsp;업무구분 </th>   <td><%= objCdinfo.getRelatedDuty((String)objRsSH.getObject("RLTD_DUTY")) %></td>

            </tr>
             <tr>

              <th scope="col">&bull;&nbsp;발송정보 </th>   <td colspan="3">
 <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list_none">
     <tr>
         <td width="17" rowspan="2"><img src="/images2/common/icon_assembly.gif" width="16" height="13" /></td>
         <td><%=(String)objRsSH.getObject("REQ_ORGAN_NM")%></td>
         <td rowspan="2"><img src="/images2/common/arrow01.gif" width="26" height="14" /></td>
         <td width="15" rowspan="2"><img src="/images2/common/icon_cube.gif" width="11" height="15" /></td>
         <td><%=(String)objRsSH.getObject("SUBMT_ORGAN_NM")%></td>
     </tr>
     <tr>
         <td class="fonts">
         <%=(String)objRsSH.getObject("REGR_NM")%> (<a href="mailto:<%=(String)objRsSH.getObject("REGR_EMAIL")%>"><%=(String)objRsSH.getObject("REGR_EMAIL")%></a> / <%=(String)objRsSH.getObject("REGR_CPHONE")%>)
         </td>
         <td class="fonts"><%=(String)objRsSH.getObject("RCVR_NM")%></td>
     </tr>
 </table>
</td>

            </tr>
                <tr>
              <th scope="col" rowspan="2">&bull;&nbsp;요구함이력 </th>
              <td colspan="3">
              <ul class="list_in">
              <li><span class="tl">&bull;&nbsp;요구함 생성일시 :</span> <%=StringUtil.getDate2((String)objRsSH.getObject("REG_DT"))%></li>
             <li><span class="tl">&bull;&nbsp;요구서 수신일 :</span> <%=StringUtil.getDate2((String)objRsSH.getObject("LAST_REQ_DOC_SND_DT"))%></li>
              </ul>
              </td>
            </tr>
            </tr>
            <tr>
              <td colspan="3">
              <ul class="list_in">
              <li><span class="tl">&bull;&nbsp;제출기관 조회일시 :</span> <%=StringUtil.getDate2((String)objRsSH.getObject("FST_QRY_DT"))%></li>
              <li><span class="tl">&bull;&nbsp;제출기한 :</span> <%=StringUtil.getDate((String)objRsSH.getObject("SUBMT_DLN"))%> 24:00</li>
              <li><span class="tl">&bull;&nbsp;최종제출일자 :</span> <%= StringUtil.getDate2(String.valueOf(objRsSH.getObject("LAST_ANS_DOC_SND_DT"))) %></li>
              </ul>
              </td>
            </tr>
                <tr>

              <th scope="col">&bull;&nbsp;제출/요구 </th>   <td colspan="3"><%= objRsSH.getObject("SUBMT_CNT") %> / <%= objRsSH.getObject("REQ_CNT") %> </td>

            </tr>
            </tr>
                <tr>

              <th scope="col">&bull;&nbsp;요구함설명 </th>   <td colspan="3"><%= objRsSH.getObject("REQ_BOX_DSC") %> </td>

            </tr>





        </table>

        <!-- /list view -->
        <p class="warning mt10">* 요구함 삭제는 제출기관에서 등록된 요구에 대한 답변을 작성하지 않은 경우에만 가능합니다. </p>
 <p class="warning ">요구함 복사를 통해 생성된 요구함은 작성중 요구함에서 확인하실 수 있습니다. </p>
        <!-- 리스트 버튼-->
<!--
요구함 목록, 요구서 보기, 답변서 보기
-->
        <div id="btn_all"><div  class="t_right">
            <div class="mi_btn" style="float:right"><a href="javascript:goReqDocView()"><span>요구서 보기</span></a></div>
            <div class="mi_btn" style="float:right"><a href="javascript:viewAnsDoc()"><span>답변서 보기</span></a></div>
        </div></div>

        <!-- /리스트 버튼-->

        <!-- list -->
        <span class="list01_tl">요구 목록 <span class="list_total">&bull;&nbsp;전체자료수 : <%= intTotalRecordCount %>개 (<%= intCurrentPageNum %> / <%= intTotalPage %> page)</span></span>

        <table width="100%" style="padding:0;">
            <tr>
                <td>&nbsp;</td>
            </tr>
        </table>


        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
          <thead>
            <tr>
              <th scope="col" style="width:15px; ">
                <input name="" type="checkbox" value="" class="borderNo" />
              </th>
              <th scope="col" style="width:15px; "><a>NO</a></th>
              <th scope="col" style="width:250px;" ><%= SortingUtil.getSortLink("changeSortQuery", "REQ_CONT", strReqInfoSortField, strReqInfoSortMtd, "요구제목") %></th>
              <th scope="col"><%= SortingUtil.getSortLink("changeSortQuery", "REQ_STT", strReqInfoSortField, strReqInfoSortMtd, "상태") %></th>
              <th scope="col"><%= SortingUtil.getSortLink("changeSortQuery", "OPEN_CL", strReqInfoSortField, strReqInfoSortMtd, "공개등급") %></th>
              <th scope="col"><a>답변</a></th>
              <th scope="col"><a>첨부</a></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery", "REG_DT", strReqInfoSortField, strReqInfoSortMtd, "등록일자")%></th>

            </tr>
          </thead>
          <tbody>
        <%
            int intRecordNumber= (intCurrentPageNum -1) * Integer.parseInt((String)objParams.getParamValue("ReqInfoPageSize")) +1;
            String strReqInfoID = "";
            while(objRs.next()){
                strReqInfoID = (String)objRs.getObject("REQ_ID");
        %>
            <tr>
              <td>
                <input name="ReqInfoID" type="checkbox" value="<%= strReqInfoID %>"  class="borderNo" onClick="javascript:checkBoxValidate(<%= (intRecordNumber-1) %>)"/>
              </td>
              <td><%= intRecordNumber %></td>
              <td style="text-align:left;"><a href="javascript:gotoDetail('<%= strReqInfoID %>')" hint="<%= StringUtil.substring((String)objRs.getObject("REQ_DTL_CONT"), 80) %> ..."><%= objRs.getObject("REQ_CONT") %></a>
              </td>
              <td><%= CodeConstants.getRequestStatus((String)objRs.getObject("REQ_STT")) %></td>
              <td><%= CodeConstants.getOpenClass((String)objRs.getObject("OPEN_CL")) %></td>
              <td><span class="tooltip_text"><%=this.makeAnsInfoImg((String)objRs.getObject("ANS_ID"),(String)objRs.getObject("ANS_MTD"),(String)objRs.getObject("ANS_OPIN"),(String)objRs.getObject("SUBMT_FLAG"),objUserInfo.isRequester(),"","_blank","")%></span> 
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
				</div></td>
              <td><%=makeAttachedFileLink((String)objRs.getObject("ANS_ESTYLE_FILE_PATH"))%></td>
              <td><%= StringUtil.getDate2((String)objRs.getObject("REG_DT")) %></td>
            </tr>
        <%
                intRecordNumber++;
            } //endwhile
        %>
          </tbody>
        </table>

        <!-- /list -->
                    <%=objPaging.pagingTrans(PageCount.getLinkedString(
                            new Integer(intTotalRecordCount).toString(),
                            new Integer(intCurrentPageNum).toString(),
                            objParams.getParamValue("ReqInfoPageSize")))%>
        <!-- 페이징-->
        <!-- /페이징-->


       <!-- 리스트 버튼-->
        <div id="btn_all" >        <!-- 리스트 내 검색 -->
        <div class="list_ser" >
          <select name="ReqInfoQryField" class="selectBox5"  style="width:70px;" >
           <option <%=(strReqInfoQryField.equalsIgnoreCase("req_cont"))? " selected ": ""%> value="req_cont">요구제목</option>
           <option <%=(strReqInfoQryField.equalsIgnoreCase("req_dtl_cont"))? " selected ": ""%> value="req_dtl_cont">요구내용</option>
          </select>
          <input name="ReqInfoQryTerm" onKeyDown="return ch()" onMouseDown="return ch()"
         class="li_input"  style="width:100px" value="<%= strReqInfoQryTerm %>"/>
          <img src="/images2/btn/bt_list_search.gif"  onMouseOver="menuOn(this);" onMouseOut="menuOut(this);" onClick="javascript:viewForm.submit()"/> </div>
        <!-- /리스트 내 검색 --> <span class="right"> <span class="list_bt"><a href="#" onclick="javascript:viewReqHistory()">요구이력보기</a></span></span> </div>

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