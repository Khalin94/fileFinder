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
<%@ page import="nads.lib.reqsubmit.params.requestinfo.SMemReqInfoVListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.SMemReqInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.answerinfo.AnsInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.MemRequestBoxDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<% 
	UserInfoDelegate objUserInfo = null;
	CDInfoDelegate objCdinfo = null;
%>

<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>

<%
	MemRequestBoxDelegate reqDelegate = null;
	SMemReqInfoDelegate selfDelegate = null;
	AnsInfoDelegate ansDelegate = null;
	
	SMemReqInfoVListForm objParams = new SMemReqInfoVListForm();  
	
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
	   	reqDelegate = new MemRequestBoxDelegate();
	   	selfDelegate = new SMemReqInfoDelegate();
	   	ansDelegate = new AnsInfoDelegate();

	   	boolean blnHashAuth = reqDelegate.checkReqBoxAuth(strReqBoxID, objUserInfo.getOrganID()).booleanValue();

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

<html>
<head>
<title>국회의원 비전자 자료 요구 > <%=MenuConstants.REQ_BOX_MAKE_END %></title>
<link href="/css/System.css" rel="stylesheet" type="text/css">
<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>

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
		f.action = "SMakeEndBoxVList.jsp";
		f.target = "";
		f.submit();
	}

	// 요구함 목록 조회
	function goReqBoxList() {
		f = document.viewForm;
		f.action = "SMakeEndBoxList.jsp";
		f.target = "";
		f.submit();
	}

  	// 답변 상세보기로 가기
  	function gotoDetail(strID){
  		f = document.viewForm;
  		//f.AnsID.value = strID;
		f.target = "popwin";
  		f.action="/reqsubmit/common/SAnsInfoView.jsp?AnsID="+strID;
		NewWindow('/blank.html', 'popwin', '520', '320');
  		f.submit();
  		//var add_sub = window.showModalDialog('SMakeAnsInfoView.jsp?returnURL=POPUP&ReqBoxID=<%= strReqBoxID %>&ReqID=<%= strReqID %>&AnsID='+strID, '', 'dialogWidth:500px;dialogHeight:300px; center:yes; help:no; status:no; scroll:no; resizable:yes');
  		//window.open('/reqsubmit/common/SAnsInfoView.jsp?returnURL=POPUP&ReqBoxID=<%= strReqBoxID %>&ReqID=<%= strReqID %>&AnsID='+strID, '', 'width=500,height=400, scrollbars=no, resizable=yes, toolbar=no, menubar=no, location=no, directories=no, status=no');
  	}

  	// 답변 작성 화면으로 이동
  	function goSbmtReqForm() {
  		//f = document.viewForm;
  		//f.ReqID.value = "<%= strReqID %>";
  		//f.AddAnsFlag.value = "Y";
  		//f.action = "/reqsubmit/10_mem/20_reqboxsh/10_make/SMakeAnsInfoWrite.jsp";
		//f.target = "";
 		//f.submit();

		f = document.viewForm;
  		f.ReqID.value = "<%= strReqID %>";
		f.AddAnsFlag.value = "Y";
		f.target = "newpopup";		  
		f.action = "/reqsubmit/common/SAnsInfoWrite.jsp";
		var winl = (screen.width - 550) / 2;
		var winh = (screen.height - 350) / 2;
		window.open("/blank.html","newpopup","resizable=yes,menubar=no,status=no,titlebar=no, scrollbars=yes,location=no,toolbar=no,height=350,width=520, left="+winl+", top="+winh);
		f.submit();
  	}

  	// 선택 답변 삭제
  	function selectDelete() {
  		var f = document.viewForm;
  		if (getCheckCount(f, "AnsID") < 1) {
  			alert("하나 이상의 체크박스를 선택해 주세요");
  			return;
  		}
  		f.action = "SMakeAnsInfoDelProc.jsp";
		f.target = "";
  		if (confirm("선택하신 답변들을 삭제하시겠습니까?\n해당 답변들을 삭제하면 포함된 파일들도 일괄 삭제됩니다.")) f.submit();
  	}
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">

<SCRIPT language="JavaScript" src="/js/reqsubmit/reqinfo.js"></SCRIPT>

<%@ include file="/reqsubmit/common/MenuTopReqsubmit.jsp" %>

<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr align="left" valign="top">
    <td width="186" height="470" background="/image/common/bg_leftMenu.gif">
		<%@ include file="/reqsubmit/common/MenuLeftReqsubmit.jsp" %>
	</td>
<!------- 2004-06-02 디자인 수정으로 인해 변경된 부분 시작 ------->
<td width="100%"><table width="100%" border="0" cellspacing="0" cellpadding="0">
         <tr height="24" valign="top"> 
          <td height="24" colspan="2" align="left"><table width="789" height="24" border="0" cellpadding="0" cellspacing="0" bgcolor="DEEFCC">
              <tr>
                <td height="24"></td>
              </tr>
            </table></td>
        </tr>
<!------- 2004-06-02 디자인 수정으로 인해 변경된 부분 끝 ------->
        <tr valign="top"> 
          <td width="30" align="left"><img src="/image/common/bg_leftBody.gif" width="30" height="1"></td>
          <td align="left">
          <table width="759" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td height="23" align="left" valign="top"></td>
              </tr>
              <tr> 
                <td height="23" align="left" valign="top"><table width="100%" height="23" border="0" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="44%" background="/image/reqsubmit/bg_reqsubmit_tit.gif">
                      		<!-------------------- 타이틀을 입력해 주세요 ------------------------>
                      		<span class="title"><%= MenuConstants.REQ_BOX_MAKE_END %></span> <strong>- <%= MenuConstants.REQ_INFO_DETAIL_VIEW %></strong>
                      </td>
                      <td width="6%" align="left" background="/image/common/bg_titLine.gif">&nbsp;</td>
                      <td width="50%" align="right" background="/image/common/bg_titLine.gif" class="text_s">
                      		<!-------------------- 현재 위치 정보를 기술한답니다. ------------------------>
                      		<img src="/image/common/icon_navi.gif" width="3" height="5" align="absmiddle"> 
                        <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > 국회의원 비전자 자료 요구 > <B><%=MenuConstants.REQ_BOX_MAKE_END %></B>
                      </td>
                    </tr>
                  </table></td>
              </tr>
              <tr> 
                <td height="30" align="left" class="text_s">
                		<!-------------------- 현재 페이지에 대한 설명 기술 ------------------------>
                		제출 완료된 요구함의 요구내용 및 등록된 답변 목록에 대한 상세 정보를 조회하실 수 있습니다.
                </td>
              </tr>
              <tr> 
                <td height="5" align="left" class="soti_reqsubmit"></td>
              </tr>
              <tr> 
                <td height="30" class="soti_reqsubmit">
                	<!-------------------- TAB 에 해당하는 제목을 기술하는 곳이지요. ------------------------>
                	<table border="0" cellpadding="0" cellspacing="0" width="759">
                		<tr>
                			<td width="400" class="soti_reqsubmit">
                				<img src="/image/reqsubmit/icon_reqsubmit_soti.gif" width="9" height="9" align="absmiddle">
				                	 요구 등록 정보
				            </td>
				            <td width="359" align="right" valign="bottom">
				            	<!------------------------- COUNT (PAGE) ------------------------------------>
				            	<!--------------- 상세보기에서는 필요없겠죠.. 넣구 싶은 항목이 있음 여기 넣으세요... ------------------->
				            </td>
				       </tr>
				   </table>
                </td>
              </tr>
              <tr> 
                <td align="left" valign="top" class="soti_reqsubmit">
                <!------------------------- TAB에 해당하는 테이블(목록이든 등록폼이든 상세정보든) 출력 시~~~작 ------------------------->
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
					<input type="hidden" name="ReqStt" value="<%= strReqStt %>">
					
					<!-- 삭제 후 반환될 URL을 선택하기 위한 Parameter 설정 -->
					<input type="hidden" name="WinType" value="SELF">
					<input type="hidden" name="ReturnURL" value="<%= request.getRequestURI() %>?ReqBoxID=<%= strReqBoxID %>&ReqID=<%= strReqID %>">
					<input type="hidden" name="AddAnsFlag" value="">
										
					<table width="680" border="0" cellspacing="0" cellpadding="0">
                    	<tr class="td_reqsubmit"> 
                      		<td height="2" colspan="4"></td>
                    	</tr>
                    	
                    	<tr> 
                      		<td width="110" height="25" class="td_gray1">
                      			<img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 요구제목
                      		</td>
                      		<td width="570" height="25" colspan="3" class="td_lmagin"><B><%= objRsSH.getObject("REQ_CONT") %></B></td>
                    	</tr>
                    	<tr height="1" class="tbl-line"> 
                      		<td height="1"></td>
                      		<td height="1" colspan="3"></td>
                    	</tr>
                    	<tr> 
                      		<td height="25" class="td_gray1">
                      			<img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 요구내용
                      		</td>
                      		<td height="25" colspan="3" class="td_lmagin" style="padding-top:5px;padding-bottom:5px">
                      			<%= StringUtil.getDescString((String)objRsSH.getObject("REQ_DTL_CONT")) %>
                      			<%= nads.dsdm.app.reqsubmit.delegate.requestinfo.RequestInfoDelegate.getAppendRequestInfo((List)objRsSH.getObject("TBDS_REQ_LOG")) %>
                      		</td>
                    	</tr>
                    	<tr height="1" bgcolor="#d0d0d0"> 
                      		<td height="1" colspan="4"></td>
                    	</tr>
                    	<tr height="1" bgcolor="#ffffff"> 
                      		<td height="1" colspan="4"></td>
                    	</tr>
                    	<tr height="1" bgcolor="#d0d0d0"> 
                      		<td height="1" colspan="4"></td>
                    	</tr>
                    	                    	
                    	<tr> 
                      		<td height="25" class="td_gray1">
                      			<img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 요구함명
                      		</td>
                      		<td colspan="3" class="td_lmagin"><%= objRsSH.getObject("REQ_BOX_NM") %></td>
                    	</tr>
                    	<tr height="1" class="tbl-line"> 
                      		<td height="1"></td>
                      		<td height="1" colspan="3"></td>
                    	</tr>
                    	<tr> 
                      		<td width="110" height="25" class="td_gray1">
                      			<img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 요구기관
                      		</td>
                      		<td width="230" class="td_lmagin"><%= objRsSH.getObject("REQ_ORGAN_NM") %> (<%= objRsSH.getObject("USER_NM") %>)</td>
                      		<td width="110" class="td_gray1">
                      			<img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 제출기관
                      		</td>
                      		<td width="230" class="td_lmagin"><%= objRsSH.getObject("SUBMT_ORGAN_NM") %></td>
                    	</tr>
                    	<tr height="1" class="tbl-line"> 
                      		<td height="1"></td>
                      		<td height="1" colspan="3"></td>
                    	</tr>
                    	
                    	<tr> 
                      		<td height="25" class="td_gray1">
                      			<img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 공개등급
                      		</td>
                      		<td class="td_lmagin"><%= CodeConstants.getOpenClass((String)objRsSH.getObject("OPEN_CL")) %></td>
                      		<td class="td_gray1">
                      			<img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 첨부파일
                      		</td>
                      		<td width="242" class="td_lmagin">
                      			<%= StringUtil.makeAttachedFileLink((String)objRsSH.getObject("ANS_ESTYLE_FILE_PATH"), (String)objRsSH.getObject("REQ_ID")) %>
                      		</td>
                    	</tr>
                    	<tr height="1" class="tbl-line"> 
                      		<td height="1"></td>
                      		<td height="1" colspan="3"></td>
                    	</tr>
                    	<tr> 
                      		<td height="25" class="td_gray1">
                      			<img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 요구일자
                      		</td>
                      		<td class="td_lmagin"><%= StringUtil.getDate2((String)objRsSH.getObject("LAST_REQ_DT")) %></td>
                      		<td class="td_gray1">
                      			<img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 제출일자
                      		</td>
                      		<td class="td_lmagin"><%= StringUtil.getDate2((String)objRsSH.getObject("LAST_ANS_DT")) %></td>
                    	</tr>
                    	<tr height="1" class="tbl-line"> 
                      		<td height="1"></td>
                      		<td height="1" colspan="3"></td>
                    	</tr>
                    	<tr> 
                    		<td height="25" class="td_gray1">
                      			<img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 제출기한 
                      		</td>
                      		<td class="td_lmagin"><%= StringUtil.getDate((String)objRsSH.getObject("SUBMT_DLN")) %> 24:00</td>
                      		<td height="25" class="td_gray1">
                      			<img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 제출 여부
                      		</td>
                      		<td class="td_lmagin"><%= CodeConstants.getRequestStatus(strReqStt) %></td>
                    	</tr>
                    	<tr height="1" class="tbl-line"> 
                      		<td height="1"></td>
                      		<td height="1" colspan="3"></td>
                    	</tr>
                    	<tr height="1" class="tbl-line"> 
                      		<td height="1"></td>
                      		<td height="1" colspan="3"></td>
                    	</tr>
         	
                    </table>
                    <p>
                    <!-- 제출 완료 -->
                    <% if (!CodeConstants.REQ_STT_SUBMT.equalsIgnoreCase(strReqStt)) { // 제출완료가 아닌 경우만 보여주세요 %>
	                    <img src="/image/button/bt_reqEnd.gif" border="0" onClick="javascript:sbmtReq()" style="cursor:hand"  alt="답변이 등록된 요구를 즉시 요구기관으로 제출합니다.">
	                <% } %>
					<!-- 요구 이력 조회 -->
					<img src="/image/button/bt_viewReqHistory.gif"  height="20" border="0" onClick="viewReqHistory('<%= strReqID %>')" style="cursor:hand"  alt="현재 요구의 처리과정을 일자별로 조회합니다.">
                    <!-- 요구함 보기 -->
                    <img src="/image/button/bt_viewReqBox.gif" border="0" onClick="javascript:goReqBoxView()" style="cursor:hand">
                    <!-- 요구함 목록 -->
                    <img src="/image/reqsubmit/searchlist2.gif" border="0" onClick="javascript:goReqBoxList()" style="cursor:hand">

				<!------------------------- TAB에 해당하는 테이블(목록이든 등록폼이든 상세정보든) 출력 끝 ------------------------->
               </td>
              </tr>
                         
            	<!------------------------- 또 TAB을 두고 싶으시면 위의 소스들을 복사해서 이 곳에 붙여넣기 해서 수정하세요 ------------------------->
            	<!----- [주의] TAB <tr> 과 그 밑에 내용을 구성하는 <tr>을 잘 구분해서 잘 챙겨 주시어요. 나으리.. -------->
          	
            	<tr>
            		<td class="soti_reqsubmit" height="15"></td>
	           	</tr>
            	<tr> 
                <td height="30" class="soti_reqsubmit">
                	<!-------------------- TAB 에 해당하는 제목을 기술하는 곳이지요. ------------------------>
                	<table border="0" cellpadding="0" cellspacing="0" width="759">
                		<tr>
                			<td width="300" class="soti_reqsubmit">
                				<img src="/image/reqsubmit/icon_reqsubmit_soti.gif" width="9" height="9" align="absmiddle">
				                	 답변 목록
				            </td>
				            <td width="459" align="right" valign="bottom">
				            	<!------------------------- COUNT (PAGE) ------------------------------------>
				            	전체 자료 수 : <%= intTotalRecordCount %> 개
				            </td>
				       </tr>
				   </table>
                </td>
              </tr>
              <tr> 
                <td align="left" valign="top" class="soti_reqsubmit">
                	<!------------------------------------------------- 요구 목록 테이블 시작 ------------------------------------------------->
                	<table width="759" border="0" cellspacing="0" cellpadding="0">
                    	<tr> 
                      		<td height="2" colspan="7" class="td_reqsubmit"></td>
	                    </tr>
    	                <tr align="center" class="td_top"> 
            	          	<td width="64" height="22">
            	          		<% if (!CodeConstants.REQ_STT_SUBMT.equalsIgnoreCase(strReqStt)) { // 제출완료가 아닌 경우만 보여주세요 %>
	            	          		<input type="checkbox" name="" value="" onClick="javascript:revCheck(this.form, 'AnsID')">
	            	          	<% }  else { %>
									NO
								<% } %>
            	          	</td>
	                	    <td width="345">제출 의견</td>
                    	  	<td width="80">작성자</td>
    	                  	<td width="60">공개여부</td>
        	              	<td width="150">답변</td>
	                      	<td width="70">작성일</td>
            	        </tr>
                	    <tr> 
                    	  	<td height="1" colspan="7" class="td_reqsubmit"></td>
                    	</tr>
                    	<%
                    		int intRecordNumber= 0;
							while(objRs.next()){
						%>
						<tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''"> 
							<td width="64" height="22" align="center">
								<% if (!CodeConstants.REQ_STT_SUBMT.equalsIgnoreCase(strReqStt)) { // 제출완료가 아닌 경우만 보여주세요 %>
									<input type="checkbox" name="AnsID" value="<%= objRs.getObject("ANS_ID") %>">
								<% } else { %>
									<%= intRecordNumber+1 %>
								<% } %>
							</td>
							<td width="345" class="td_lmagin"><a href="javascript:gotoDetail('<%= objRs.getObject("ANS_ID") %>')"><%= objRs.getObject("ANS_OPIN") %></a></td>
							<td width="80" align="center"><%= objRs.getObject("USER_NM") %></td>
							<td width="60" align="center"><%= CodeConstants.getOpenClass((String)objRs.getObject("OPEN_CL")) %></td>
							<td width="150" align="center"><%=nads.lib.reqsubmit.util.DBAccessUtil.makeAnsInfoHtml((String)objRs.getObject("ANS_ID"), (String)objRs.getObject("ANS_MTD")) %></td>
							<td width="70" align="right" style="padding-top:2px;padding-bottom:2px"><%= StringUtil.getDate2((String)objRs.getObject("ANS_DT")) %></td>
						</tr>
						<tr class="tbl-line"> 
                    	  	<td height="1" colspan="7"></td>
                    	</tr>
                    	<%
                    			intRecordNumber++;
							} //endwhile
                    	%>
                    	<tr class="tbl-line"> 
                    	  	<td height="1" colspan="7"></td>
                    	</tr>
                    </table>
	               	<!------------------------------------------------- 요구 목록 테이블 끝 ------------------------------------------------->
                </td>
              </tr>
              
              <!------------------ BUTTON <tr></tr> --------------------------->
              <tr> 
                <td height="40" align="left" valign="top">
                	<table width="100%" border="0" cellspacing="0" cellpadding="0">
                    	<tr> 
                      		<td width="300" height="40">
                      			<!-- 버튼이 필요하다면 여기에 추가하심 됩니다용 -->
                      			<% if (!CodeConstants.REQ_STT_SUBMT.equalsIgnoreCase(strReqStt)) { // 제출완료가 아닌 경우만 보여주세요 %>
                      				<img src="/image/button/bt_registerAddAnswer2.gif" border="0" onClick="javascript:goSbmtReqForm()" style="cursor:hand"  alt="추가답변요구에 대한 답변을 작성합니다.">
	                      			<img src="/image/button/bt_delSelect.gif" border="0" onClick="javascript:selectDelete()" style="cursor:hand">
                      			<% } %>
                      		</td>
                      		<td width="459" align="right" valign="middle">
                          	</td>
                    	</tr>
                  	</table>
               </td>
              </tr>
              
              <tr>
              	<td height="35"></td>
              </tr>

            </table>
</form>

            </td>
        </tr>
              

      </table></td>
  </tr>
</table>
<%@ include file="/common/Bottom.jsp" %>
</body>
</html>
