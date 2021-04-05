<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.lib.reqsubmit.params.requestinfo.SPreReqInfoVListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.prereqinfo.SPreReqInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.prereqinfo.SPreAnsInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.prereqbox.PreRequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.prereqbox.SPreReqBoxDelegate" %>


<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	UserInfoDelegate objUserInfo = null;
	CDInfoDelegate objCdinfo = null;
%>

<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>

<%
  //로그인 사용자 정보를 가져온다. 권한없음 경우 관람만 가능하다.
  String strReqSubmitFlag = objUserInfo.getReqSubmitFlag();


	PreRequestBoxDelegate reqDelegate = null;
	SPreReqInfoDelegate selfDelegate = null;
	SPreAnsInfoDelegate ansDelegate = null;
	SPreReqBoxDelegate selfDelegateBox = null; //요구함 권한을 넘어가기 위한 임시방편

	SPreReqInfoVListForm objParams = new SPreReqInfoVListForm();

	boolean blnParamCheck=false;
	blnParamCheck = objParams.validateParams(request);
	if(blnParamCheck==false) {
  		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  		objMsgBean.setStrCode("DSPARAM-0000");
  		objMsgBean.setStrMsg(objParams.getStrErrors());
  		out.println("ParamError:" + objParams.getStrErrors());
	  	return;
  	}//endif

	// 넘어온 파라미터를 설정해서 필요할 떄 쓰도록 하자
	// 요구함 관련
	String strReqBoxID = objParams.getParamValue("ReqBoxID");
	String strReqID = objParams.getParamValue("ReqID");

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

	String strReqStt = null; // 요구 제출 여부 정보

	// 답변 개수 및 페이징 관련
	int intTotalRecordCount = 0;

	ResultSetSingleHelper objRsSH = null;
	ResultSetHelper objRs = null;

	try{
	   	reqDelegate = new PreRequestBoxDelegate();
	   	selfDelegate = new SPreReqInfoDelegate();
	   	ansDelegate = new SPreAnsInfoDelegate();
	   	selfDelegateBox = new SPreReqBoxDelegate();

	   	boolean blnHashAuth = reqDelegate.checkReqBoxAuth(strReqBoxID, objUserInfo.getOrganID()).booleanValue();
	    //boolean blnHashAuth = selfDelegateBox.checkReqBoxAuth(strReqBoxID, objUserInfo.getOrganID()).booleanValue();
	   	if(!blnHashAuth) {
	   		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	  		objMsgBean.setStrCode("DSAUTH-0001");
  	  		objMsgBean.setStrMsg("해당 요구함을 볼 권한이 없습니다.");
  	  		out.println("해당 요구함을 볼 권한이 없습니다.");
		    return;
		} else {
	    	// 요구 등록 정보를 SELECT 한다.
	    	objRsSH = new ResultSetSingleHelper(selfDelegate.getRecord(strReqID));
	    	// 요구 제출 여부 정보를 쒜팅!
	    	strReqStt = (String)objRsSH.getObject("REQ_STT");

	    	// 답변 목록을 SELECT 한다.
	    	objRs = new ResultSetHelper(ansDelegate.getRecordList(objParams));

			intTotalRecordCount = objRs.getTotalRecordCount();
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
<link href="/css/System.css" rel="stylesheet" type="text/css">
<script language="javascript">
	var f;
	// 제출 완료
	function sbmtReq() {
		f = document.viewForm;
		f.target = "";
		f.action = "/reqsubmit/common/SReqSubmtDoneProc.jsp";
		if (confirm("현재 요구에 대한 답변 제출을 완료하시겠습니까?")) f.submit();
	}

	// 요구함 보기
	function goReqBoxView() {
		f = document.viewForm;
		f.target = "";
		f.action = "SBasicReqBoxVList.jsp";
		f.submit();
	}

	// 요구함 목록 조회
	function goReqBoxList() {
		f = document.viewForm;
		f.target = "";
		f.action = "SBasicReqBoxList.jsp";
		f.submit();
	}

  	// 답변 상세보기로 가기
  	function gotoDetail(strID){
  		f = document.viewForm;
  		f.target = "popwin";
		f.action = "/reqsubmit/common/SAnsInfoView.jsp?returnURL=POPUP&ReqBoxID=<%= strReqBoxID %>&ReqID=<%= strReqID %>&AnsID="+strID;
		NewWindow('/blank.html', 'popwin', '520', '400');
		f.submit();
  		//var add_sub = window.showModalDialog('SAnsInfoView.jsp?returnURL=POPUP&ReqBoxID=<%= strReqBoxID %>&ReqID=<%= strReqID %>&AnsID='+strID, '', 'dialogWidth:500px;dialogHeight:300px; center:yes; help:no; status:no; scroll:no; resizable:yes');
  		//window.open(', '', 'width=520 height=400, scrollbars=no, resizable=yes, toolbar=no, menubar=no, location=no, directories=no, status=no');
  	}

  	// 답변 작성 화면으로 이동
  	function goSbmtReqForm() {
  		f = document.viewForm;
  		f.ReqID.value = "<%= strReqID %>";
		f.target = "newpopup";
		f.action = "/reqsubmit/common/SAnsInfoWrite.jsp";
		window.open("/blank.html","newpopup","resizable=yes,menubar=no,status=no,titlebar=no, scrollbars=yes,location=no,toolbar=no,height=540,width=620");
		f.submit();
  	}

  	// 선택 답변 삭제
  	function selectDelete() {
  		var f = document.viewForm;
  		if (getCheckCount(f, "AnsID") < 1) {
  			alert("하나 이상의 체크박스를 선택해 주세요");
  			return;
  		}
		f.target = "";
  		f.action = "/reqsubmit/common/SAnsInfoDelProc.jsp";
 		if (confirm("선택하신 답변들을 삭제하시겠습니까?\n해당 답변들을 삭제하면 포함된 파일들도 일괄 삭제됩니다.")) f.submit();
  	}

  	// 요구 중복 조회
  	function checkOverlapReq() {
  		var f = document.viewForm;
  		f.target = "popwin";
  		f.action = "/reqsubmit/common/SReqOverlapCheck.jsp?queryText=<%= objRsSH.getObject("REQ_CONT") %>&ReqID=<%= strReqID %>&ReqBoxID=<%= strReqBoxID %>";
		NewWindow('/blank.html', 'popwin', '500', '400');
		f.submit();
  		//window.open('/reqsubmit/common/SReqOverlapCheck.jsp?queryText=<%= objRsSH.getObject("REQ_CONT") %>&ReqID=<%= strReqID %>&ReqBoxID=<%= strReqBoxID %>', '', 'width=500, height=400, scrollbars=no, resizable=yes, toolbar=no, menubar=no, location=no, directories=no, status=no');
  	}
</script>

</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
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

<div id="wrap">
  <jsp:include page="/inc/top.jsp" flush="true"/>
  <jsp:include page="/inc/top_menu02.jsp" flush="true"/>
  <div id="container">
    <div id="leftCon">
      <jsp:include page="/inc/log_info.jsp" flush="true"/>
      <jsp:include page="/inc/left_menu02.jsp" flush="true"/>
      <SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>
	  <SCRIPT language="JavaScript" src="/js/reqsubmit/reqinfo.js"></SCRIPT>
    </div>
    <div id="rightCon">
      <!-- pgTit -->
      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3>기초 자료 요구함<span class="sub_stl" >- 요구 상세 보기</span></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.REQUEST_BOX_COMM%> > <%=MenuConstants.REQUEST_BOX_PRE%> > <B><%=MenuConstants.REQ_BOX_PRE%></B></div>
        <p><!--문구--></p>
      </div>
      <!-- /pgTit -->

      <!-- contents -->

      <div id="contents">

        <!-- 검색조건 없는 경우 아래 div 삭제 나 주석으로 막으세요.-->
        <!-- /검색조건-->


        <!-- 각페이지 내용 -->
         <!-- list view-->

        <span class="list02_tl">요구함 등록 정보 </span>
        <div class="top_btn"><samp>
            <%
            if(!strReqSubmitFlag.equals("004")){ %>
            <!-- 즉시 제출  -->
            <% if (!CodeConstants.REQ_STT_SUBMT.equalsIgnoreCase(strReqStt)  ) { // 제출완료가 아닌 경우만 보여주세요 %>
                <span class="btn"><a href="#" onClick="javascript:checkOverlapReq()">중복 조회</a></span>
            <% }//end if StrReqStt
            } %>
            <span class="btn"><a href="#" onClick="javascript:goReqBoxView()">요구함 보기</a></span>
            <span class="btn"><a href="#" onClick="javascript:goReqBoxList()">요구함 목록</a></span>
        </samp></div>


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
					<input type="hidden" name="ReqID" value="<%= strReqID %>"> <!-- 요구 ID -->
					<input type="hidden" name="ReqInfoSortField" value="<%= strReqInfoSortField %>"><!--요구정보 목록정렬필드 -->
					<input type="hidden" name="ReqInfoSortMtd" value="<%= strReqInfoSortMtd %>"><!--요구정보 목록정렬방법-->
					<% if(StringUtil.isAssigned(strReqInfoQryTerm)) { %>
					<input type="hidden" name="ReqInfoQryField" value="<%= strReqInfoQryField %>"><!--요구정보 조회필드 -->
					<input type="hidden" name="ReqInfoQryTerm" value="<%= strReqInfoQryTerm %>"><!-- 요구정보 조회어 -->
					<% } %>
					<input type="hidden" name="ReqInfoPage" value="<%= strReqInfoPagNum %>"><!-- 요구정보 페이지 번호 -->

					<!-- 삭제 후 반환될 URL을 선택하기 위한 Parameter 설정 -->
					<input type="hidden" name="WinType" value="SELF">
					<input type="hidden" name="ReqStt" value="<%= strReqStt %>">
					<input type="hidden" name="ReturnURL" value="<%= request.getRequestURI() %>?ReqBoxID=<%= strReqBoxID %>&ReqID=<%= strReqID %>">

					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="list02">
                    	<tr>
                      		<th scope="col">&bull;&nbsp; 위원회</th>
                      		<td height="25" colspan="3"><%= objRsSH.getObject("CMT_ORGAN_NM") %></td>
                    	</tr>
                    	<tr>
                      		<th scope="col">&bull;&nbsp; 요구함명</th>
                      		<td height="25" colspan="3"><%= objRsSH.getObject("REQ_BOX_NM") %></td>
                    	</tr>
                    	<tr>
                      		<th scope="col">&bull;&nbsp; 제출기관</th>
                      		<td width="191" height="25"><%= objRsSH.getObject("SUBMT_ORGAN_NM") %></td>
                      		<th scope="col">&bull;&nbsp; 요구기관</th>
                      		<td width="191"><%= objRsSH.getObject("REQ_ORGAN_NM") %></td>
                    	</tr>
                    	<tr>
                      		<th scope="col">&bull;&nbsp; 요구 제목</th>
                      		<td height="25" colspan="3"><%= objRsSH.getObject("REQ_CONT") %></td>
                    	</tr>
                    	<tr>
                      		<th scope="col">&bull;&nbsp; 요구 내용</th>
                      		<td height="25" colspan="3"><%= StringUtil.getDescString((String)objRsSH.getObject("REQ_DTL_CONT")) %>
                    		<%= nads.dsdm.app.reqsubmit.delegate.requestinfo.RequestInfoDelegate.getAppendRequestInfo((List)objRsSH.getObject("TBDS_REQ_LOG")) %>
                    		</td>
                    	</tr>
                    	<tr>
                      		<th scope="col">&bull;&nbsp; 공개등급</th>
                      		<td width="181" height="25"><%= CodeConstants.getOpenClass((String)objRsSH.getObject("OPEN_CL")) %></td>
                      		<th scope="col">&bull;&nbsp;제출양식파일</th>
                      		<td width="242">
                      			<%= StringUtil.makeAttachedFileLink((String)objRsSH.getObject("ANS_ESTYLE_FILE_PATH"), (String)objRsSH.getObject("REQ_ID")) %>
                      		</td>
                    	</tr>
                    	<tr>
                      		<th scope="col">&bull;&nbsp; 등록자</th>
                      		<td width="181" height="25"><%=(String)objRsSH.getObject("REGR_NM") %></td>
                      		<th scope="col">&bull;&nbsp; 등록일자</th>
                      		<td width="242"><%= StringUtil.getDate((String)objRsSH.getObject("LAST_REQ_DT")) %></td>
                    	</tr>
                    	<tr>
                      		<th scope="col">&bull;&nbsp; 제출여부</th>
                      		<td height="25" colspan="3"><%= CodeConstants.getRequestStatus(strReqStt) %></td>
                    	</tr>
                    </table>
                    <div id="btn_all"><div  class="t_right">
                        <%
                        if(!strReqSubmitFlag.equals("004")){ %>
                        <!-- 즉시 제출  -->
                        <% if (!CodeConstants.REQ_STT_SUBMT.equalsIgnoreCase(strReqStt)  ) { // 제출완료가 아닌 경우만 보여주세요 %>
                            <% if (intTotalRecordCount > 0) { %>
                            <div class="mi_btn"><a href="#" onClick="javascript:sbmtReq()"><span>즉시 제출</span></a></div>
                            <%  }// end if intTotalRecordCount %>
                        <% }//end if StrReqStt
                        } %>
                    </div></div>

                    <span class="list01_tl">답변 목록 <span class="list_total">&bull;&nbsp;전체자료수 : <%= intTotalRecordCount %>개</span></span>
                    <table>
                        <tr><td>&nbsp;</td></tr>
                    </table>

                	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
                        <thead>
    	                <tr>
            	          	<th scope="col" width="64" height="22">
            	          		<% if (!CodeConstants.REQ_STT_SUBMT.equalsIgnoreCase(strReqStt)) { // 제출완료가 아닌 경우만 보여주세요 %>
	            	          		<input type="checkbox" name="checkAll" value="" onClick="checkAllOrNot(document.viewForm)">
	            	          		<!--input type="checkbox" name="checkAll" value="" onClick="javascript:checkAllOrNot(viewForm)"-->
	            	          	<% } %>
            	          	</th>
	                	    <th scope="col" width="335"><a>제출 의견</a></th>
                    	  	<th scope="col" width="80"><a>작성자</a></th>
    	                  	<th scope="col" width="60"><a>공개여부</a></th>
        	              	<th scope="col" width="150"><a>답변</a></th>
	                      	<th scope="col" width="80"><a>작성일</a></th>
            	        </tr>
                        </thead>
                        <tbody>
                    	<%
                    		int intRecordNumber= 0;
                    		if(objRs.getRecordSize()>0){
							while(objRs.next()){
						%>
						<tr>
							<td height="22" align="center">
								<% if (!CodeConstants.REQ_STT_SUBMT.equalsIgnoreCase(strReqStt)) { // 제출완료가 아닌 경우만 보여주세요 %>
									<input type="checkbox" name="AnsID" value="<%= objRs.getObject("ANS_ID") %>">
								<% } else { %>
									<%= intRecordNumber+1 %>
								<% } %>
							</td>
							<td><a href="javascript:gotoDetail('<%= objRs.getObject("ANS_ID") %>')"><%= objRs.getObject("ANS_OPIN") %></a></td>
							<td align="center"><%= objRs.getObject("USER_NM") %></td>
							<td align="center"><%= CodeConstants.getOpenClass((String)objRs.getObject("OPEN_CL")) %></td>
							<td align="center"><%=nads.lib.reqsubmit.util.DBAccessUtil.makeAnsInfoHtml((String)objRs.getObject("ANS_ID"), (String)objRs.getObject("ANS_MTD")) %></td>
							<td align="center"><%= StringUtil.getDate((String)objRs.getObject("ANS_DT")) %></td>
						</tr>
                    	<%
                    			intRecordNumber++;
							} //endwhile
                    	}else{
		  				%>
			      			<tr>
								<td height="22" colspan="6" align="center">등록된 답변정보가 없습니다.</td>
				  			</tr>

		  				<%
						}//end if 목록 출력 끝.
		  				%>
                    </table>
	               	<!------------------------------------------------- 요구 목록 테이블 끝 ------------------------------------------------->
            <%
            //권한 없음
            if(!strReqSubmitFlag.equals("004")){ %>
            <% if (!CodeConstants.REQ_STT_SUBMT.equalsIgnoreCase(strReqStt)) { // 제출완료가 아닌 경우만 보여주세요 %>
            <div id="btn_all" >        <!-- 리스트 내 검색 -->
                <span class="right">
                    <span class="list_bt"><a href="#" onclick="javascript:goSbmtReqForm()">답변작성</a></span>
                    <span class="list_bt"><a href="#" onClick="javascript:selectDelete()">선택삭제</a></span>
                </span>
            </div>
            <% }
             } //end if 권한없음에 관련 %>

        <!-- /리스트 버튼-->
        <!-- /각페이지 내용 -->
      </div>
      <!-- /contents -->

    </div>
  </div>
  </form>
  <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>