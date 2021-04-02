<%@ page language="java" contentType="text/html;charset=EUC-KR" %>

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
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.MemRequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.SMemReqInfoDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	UserInfoDelegate objUserInfo =null;
	CDInfoDelegate objCdinfo =null;
	System.out.println("###########################################################################");
%>

<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>

<%
	// 2004-05-11 추가된 파라미터
	// 답변 등록이 모두 완료되면 자동으로 답변서 발송 창을 띄운다.
	String strStartAnsDocSend = StringUtil.getEmptyIfNull(request.getParameter("startAnsDocSend"));
	
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
	
	// 현재 요구함의 요구에 등록된 답변 개수
	int intTotalAnsCount = 0;

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
  	  		objMsgBean.setStrMsg("해당 요구자료를 볼 권한이 없습니다.");
  	  		out.println("해당 요구자료를 볼 권한이 없습니다.");
		    return;
		} else {
	    	// 요구함 등록 정보를 SELECT 한다.
			System.out.println("~~~~~~~~~~~~~~~~~~~~~~~~~~~");
	    	objRsSH = new ResultSetSingleHelper(selfDelegate.getRecord(strReqBoxID, objUserInfo.getUserID()));

			System.out.println("~~~~~~~~~~~~~~~~~~~~~~~~~~~ : "+objRsSH.getObject("REQ_BOX_NM"));
	    	
	    	// 요구 목록을 SELECT 한다.
	    	objRs = new ResultSetHelper(reqInfoDelegate.getRecordList(objParams));
	    	
	    	// 현재 요구함의 등록된 요구별 답변 개수는??
	    	intTotalAnsCount = selfDelegate.checkReqInfoAnsIsNull(strReqBoxID);
	    	 
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

<html>
<head>
<title><%=MenuConstants.getReqBoxGeneral(request)%> > <%=MenuConstants.REQ_BOX_MAKE%></title>
<link href="/css/System.css" rel="stylesheet" type="text/css">
<script language="javascript" src="/js/reqsubmit/common.js"></script>
<script language="javascript">
	var IsClick=false;

	
	var strPopup;
	var strGubun = -1;

	function ButtonProcessing()
	{
		try{			
			if(strGubun < 0){
				var oPopup = window.createPopup();
				var  oPopBody  =  oPopup.document.body;
				oPopBody.style.backgroundColor  =  "white";
				oPopBody.style.border  =  "solid  #dddddd 1px";



				// "처리중입니다"라는 메시지와 로딩이미지가 표시되도록 한다.
				oPopBody.innerHTML  = "<table width='100%' height='100%' border='1'><tr><td align='center' style='font-size:9pt;'><b>처리중입니다. 잠시만 기다려주세요...<b><br><img src='/image/reqsubmit/processing.gif'></td></tr></table>";



				var leftX = document.body.clientWidth/2 -130;
				var topY = (document.body.clientHeight/1.7) - (oPopBody.offsetHeight/2);

				oPopup.show(leftX,  topY,  270,  130,  document.body);



				// createPopup()를 이용해 팝업페이지를 만드는 경우 
				// 기본적으로 해당 팝업에서 onblur이벤트가 발생하면 그 팝업페이지는 닫히게 됩니다.

				// 해당 팝업페이지에서 onblur이벤트가 발생할때마다  메소드를 재호출하여

				// 팝업페이지가 항상 표시되게 합니다.
				oPopBody.attachEvent("onblur", ButtonProcessing);
				strPopup = oPopup;
			}
			strGubun = -1;
		} 
		catch(e) {}
	}

	function notProcessing(){
		if(strPopup.isOpen){
			strPopup.hide();
			strGubun = 1;
		}		
	}

	var f;	
	
	// 요구서 보기
	function goReqDocView() {
		NewWindow('/reqsubmit/common/ReqDocView.jsp?ReqBoxId=<%= strReqBoxID%>&ReqTp=001', '', '800', '600');
		//window.open("/reqsubmit/common/ReqDocView.jsp?ReqBoxId=<%= strReqBoxID%>&ReqTp=001", "",	"resizable=no,menubar=no,status=yes,titlebar=yes,scrollbars=no,location=no,toolbar=no,height=600,width=800" );
	}
	
	// 답변서 발송
	function sendAnsDoc() {
		var f = document.viewForm;
		f.action = "/reqsubmit/common/AnsDocSend.jsp?ReqBoxID=<%= strReqBoxID %>";
		f.target = "popwin";
		NewWindow('/blank.html', 'popwin', '470', '300');
		f.submit();
		//window.open('/reqsubmit/common/AnsDocSend.jsp?ReqBoxID=<%= strReqBoxID%>', '', 'width=450,height=300, scrollbars=no, resizable=yes, toolbar=no, menubar=no, location=no, directories=no, status=no');
	}
	
	// 요구 목록 조회
	function goReqBoxList() {
		f = document.viewForm;
		f.action = "SMakeOpReqBoxList.jsp";
		f.target = "";
		f.submit();
	}
	
	// 정렬방법 바꾸기
	function changeSortQuery(sortField, sortMethod){
		f = document.viewForm;
  		f.ReqInfoSortField.value = sortField;
  		f.ReqInfoSortMtd.value = sortMethod;
  		f.target = "";
  		f.submit();
  	}
  
  	// 요구 상세보기로 가기 */
  	function gotoDetail(strID){
  		f = document.viewForm;
  		f.ReqID.value = strID;
  		f.action="SMakeOpReqInfoVList.jsp";
  		f.target = "";
  		f.submit();
  	}


  
  	// 페이징 바로가기
  	function goPage(strPage){
  		f = document.viewForm;
  		f.ReqInfoPage.value = strPage;
  		f.target = "";
  		f.submit();
  	}
  	
  	// 답변서 발송을 할 때 등록된 답변이 하나라도 없으면 발송을 못한다는 메세지를 보여준다.
  	function alertSendAnsDocMessage() {
  		alert("답변이 등록되지 않은 요구가 있습니다.\n확인 후 다시 시도해 주시기 바랍니다.");
  	}
  	
  	/**
  	 * 2005-10-20 kogaeng ADD
  	 * 체크박스를 하나만 선택하게 하는 스크립트
  	 */
  	function checkBoxValidate(cb, strID) {
		if(<%= intTotalRecordCount %> == 1) {
			if(cb == 0) {
				document.viewForm.ReqInfoID.checked = true;
				document.viewForm.ReqID.value = strID;
				return;
			}
		}
		for (j = 0; j < <%= intTotalRecordCount %>; j++) {
			if (eval("document.viewForm.ReqInfoID[" + j + "].checked") == true) {
				document.viewForm.ReqInfoID[j].checked = false;
				if (j == cb) {
					document.viewForm.ReqInfoID[j].checked = true;
					document.viewForm.ReqID.value = strID;
				} else {
					document.viewForm.ReqInfoID[j].checked = false;
					document.viewForm.ReqID.value = "";
				}
			}
		}
	}
  	
  	// 답변 작성 화면으로 이동
  	function goSbmtReqForm() {
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
  		f = document.viewForm;
		f.target = "newpopup";		  
		f.action = "/reqsubmit/common/SAnsInfoWrite.jsp";
		var winl = (screen.width - 550) / 2;
		var winh = (screen.height - 350) / 2;
		window.open("/blank.html","newpopup","resizable=yes,menubar=no,status=no,titlebar=no, scrollbars=yes,location=no,toolbar=no,height=350,width=520, left="+winl+", top="+winh);
		f.submit();
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
  		f = document.viewForm;
		f.target = "newpopup";		  
		f.action = "/reqsubmit/common/ViewReqHistory.jsp?ReqInfoID="+document.viewForm.ReqID.value;
		var winl = (screen.width - 540) / 2;
		var winh = (screen.height - 450) / 2;
		window.open("/blank.html","newpopup","resizable=yes,menubar=no,status=no,titlebar=no, scrollbars=yes,location=no,toolbar=no,height=450,width=540, left="+winl+", top="+winh);
		f.submit();
		/*
  		var popModal = window.showModalDialog('/reqsubmit/common/ViewReqHistory.jsp?ReqInfoID='+document.viewForm.ReqID.value, 
  																'', 'dialogWidth:540px;dialogHeight:450px; center:yes; help:no; status:no; scroll:yes; resizable:yes');
  		*/
	}

	// 답변 작성 화면으로 이동
  	function offlineSubmit() {  		
  		f = document.viewForm;
		f.target = "newpopup";		  
		f.action = "/reqsubmit/common/OffLineDocSend.jsp";
		var winl = (screen.width - 550) / 2;
		var winh = (screen.height - 350) / 2;
		window.open("/blank.html","newpopup","resizable=yes,menubar=no,status=no,titlebar=no, scrollbars=yes,location=no,toolbar=no,height=350,width=520, left="+winl+", top="+winh);
		f.submit();
  	}

  	
	function doDelete() {
		if(!IsClick){
			
		}else{
			alert("프로세스가 작동중입니다. 잠시 기다려주십시오.");
			return false;
		}
	  	
	  	if(confirm("선택하신 요구함을 삭제하시겠습니까?\n\r포함된 모든 요구 내용도 일괄 삭제됩니다.")) {
			IsClick = true;  //버튼 처리를 수행중..
			ButtonProcessing();  //처리상태를 표시하는 메소드 호출

			//var winl = (screen.width - 300) / 2;
			//var winh = (screen.height - 240) / 2;
			//document.all.loadingDiv.style.left = winl;
			//document.all.loadingDiv.style.top = winh;
			//document.all.loadingDiv.style.display = '';
			document.viewForm.action = "/reqsubmit/10_mem/20_reqboxsh/15_make/ReqBoxOpDelProc.jsp";
			document.viewForm.target = 'processingFrame';	
			//window.open('/blank.html', 'popwin', 'width=300, height=240, left='+winl+', top='+winh);
	  		document.viewForm.submit();
	  	}
	}
  	
</script>

</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0"
<% if("Y".equalsIgnoreCase(strStartAnsDocSend)) { %>
onLoad="javascript:sendAnsDoc()" 
<% } %>
> 
<iframe name='processingFrame' height='0' width='0'></iframe>
<DIV ID="loadingDiv" style="display:none;position:absolute;">
	<img src="/image/reqsubmit/loading.jpg" border="0"> </td>
</DIV>
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

<%@ include file="/reqsubmit/common/MenuTopReqsubmit.jsp" %>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr align="left" valign="top">
    <td width="186" height="470" background="/image/common/bg_leftMenu.gif">
		<%@ include file="/reqsubmit/common/MenuLeftReqsubmit.jsp" %>
		<SCRIPT language="JavaScript" src="/js/reqsubmit/reqinfo.js"></SCRIPT>
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
                      <td width="34%" background="/image/reqsubmit/bg_reqsubmit_tit.gif">
                      		<!-------------------- 타이틀을 입력해 주세요 ------------------------>
                      		<span class="title"><%=MenuConstants.REQ_BOX_MAKE%></span> <strong>- <%= MenuConstants.REQ_BOX_DETAIL_VIEW %></strong>
                      </td>
                      <td width="16%" align="left" background="/image/common/bg_titLine.gif">&nbsp;</td>
                      <td width="50%" align="right" background="/image/common/bg_titLine.gif" class="text_s">
                      		<!-------------------- 현재 위치 정보를 기술한답니다. ------------------------>
                      		<img src="/image/common/icon_navi.gif" width="3" height="5" align="absmiddle"> 
                        <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > 국회의원 비전자 자료 요구 > <B><%=MenuConstants.REQ_BOX_MAKE%></B>
                      </td>
                    </tr>
                  </table></td>
              </tr>
              <tr> 
                <td height="30" align="left" class="text_s">
                		<!-------------------- 현재 페이지에 대한 설명 기술 ------------------------>
                		국회(의원실, 사무처, 예산정책처, 전문위원 등)로부터 발송된 요구자료의 상세 정보 및 등록된 요구 목록을 확인하실 수 있습니다.
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
				                	 요구자료 등록 정보
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
					<input type="hidden" name="ReqID" value=""> <!-- 요구 ID -->
					<input type="hidden" name="ReqInfoSortField" value="<%= strReqInfoSortField %>"><!--요구정보 목록정렬필드 -->
					<input type="hidden" name="ReqInfoSortMtd" value="<%= strReqInfoSortMtd %>"><!--요구정보 목록정렬방법-->
					<input type="hidden" name="ReqInfoPage" value="<%= strReqInfoPagNum %>"><!-- 요구정보 페이지 번호 -->
					<input type="hidden" name="createdocflag" value="OPLSUBMT">
					<input type="hidden" name="ReturnURL" value="/reqsubmit/10_mem/20_reqboxsh/15_make/SMakeOpReqBoxList.jsp">
					
					
					<table width="680" border="0" cellspacing="0" cellpadding="0">
                    	<tr class="td_reqsubmit"> 
                      		<td width="110" height="2"></td>
                      		<td width="570" height="2" colspan="3"></td>
                    	</tr>
                    	<tr> 
                      		<td height="25" class="td_gray1">
                      			<img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 요구자료
                      		</td>
                      		<td height="25" colspan="3" class="td_lmagin"><B><%= objRsSH.getObject("REQ_BOX_NM") %></B>
                      			<%
                      				// 2004-06-15 ADD
                      				String strElcDocNo = (String)objRsSH.getObject("DOC_NO");
                      				if (StringUtil.isAssigned(strElcDocNo)) {
                      					out.println(" (전자결재번호 : "+strElcDocNo+")");
                      				}
                      			%>
                      		</td>
                    	</tr>
                    	<tr height="1" class="tbl-line"> 
                      		<td height="1" colspan="4"></td>
                    	</tr>
                    	<tr height="1" bgcolor="white"> 
                      		<td height="1" colspan="4"></td>
                    	</tr>
                    	<tr height="1" class="tbl-line"> 
                      		<td height="1" colspan="4"></td>
                    	</tr>
                    	
                    	<tr> 
                      		<td width="110" height="25" class="td_gray1">
                      			<img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 소관 위원회
                      		</td>
                      		<td width="230" height="25" class="td_lmagin"><%= objRsSH.getObject("CMT_ORGAN_NM") %></td>
                      		<td width="110" height="25" class="td_gray1">
                      			<img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 업무구분 
                      		</td>
                      		<td width="230" class="td_lmagin"><%= objCdinfo.getRelatedDuty((String)objRsSH.getObject("RLTD_DUTY")) %></td>
                    	</tr>
                    	<tr height="1" class="tbl-line"> 
                      		<td height="1" colspan="4"></td>
                    	</tr>
                    	
                    	<tr> 
                      		<td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 발송정보</td>
							<td colspan="3" class="td_lmagin" style="padding-top:5px;padding-bottom:5px">
								<table border="0" cellpadding="0" cellspacing="0">
									<!--tr>
										<td colspan="2" align="center" height="20">
											<table border="0" cellpadding="0" cellspacing="0" style="border:1px solid #c0c0c0">
												<tr><td height="18" align="center" width="120" bgcolor="#f4f4f4">요구기관</td>
												</tr>
											</table>
										</td>
										<td></td>
										<td colspan="2" align="left">
											<table border="0" cellpadding="0" cellspacing="0" style="border:1px solid #c0c0c0">
												<tr><td height="18" align="center" width="120" bgcolor="#f4f4f4">제출기관</td>
												</tr>
											</table>
										</td>
									</tr>
									<tr>
										<td colspan="5" height="2"></td>
									</tr -->
									<%										
										String tempoplmtd = "";
										if(((String)objRsSH.getObject("OPL_MTD")).equals("001")){
											tempoplmtd = "전화";
										}else if(((String)objRsSH.getObject("OPL_MTD")).equals("002")){
											tempoplmtd = "e-메일";
										}else if(((String)objRsSH.getObject("OPL_MTD")).equals("003")){
											tempoplmtd = "팩스";
										}else if(((String)objRsSH.getObject("OPL_MTD")).equals("004")){
											tempoplmtd = "구두";
										}else if(((String)objRsSH.getObject("OPL_MTD")).equals("005")){
											tempoplmtd = "기타";
										}else{
											tempoplmtd = "기타";
										}
									%>
									<tr>
		                      			<td width="20" height="20" align="center" rowspan="2"><img src="/image/reqsubmit/icon_assembly.gif" border="0"></td>
		                      			<td>&nbsp;<%=(String)objRsSH.getObject("REQ_ORGAN_NM")%>&nbsp;&nbsp;</td>
		                      			<td width="50" align="center" rowspan="2"><img src="/image/reqsubmit/arrow1.gif" border="0"><br><font color="blue">(<%=tempoplmtd%>)</font></td>
		                      			<td width="20" height="20" align="center" rowspan="2"><img src="/image/reqsubmit/icon_cube.gif" border="0"></td>
		                      			<td>&nbsp;<%=(String)objRsSH.getObject("SUBMT_ORGAN_NM")%></td>
	                      			</tr>
	                      			<tr>
	                      				<td>&nbsp;<%=(String)objRsSH.getObject("REGR_NM")%> (<a href="mailto:<%=(String)objRsSH.getObject("REGR_EMAIL")%>"><%=(String)objRsSH.getObject("REGR_EMAIL")%></a> / <%=(String)objRsSH.getObject("REGR_CPHONE")%>)</td>
	                      				<td>&nbsp;<%=(String)objRsSH.getObject("RCVR_NM")%> </td>
	                      			</tr>
                      			</table>
                      		</td>
                    	</tr>
                    	<tr height="1" class="tbl-line"> 
                      		<td height="1" colspan="4"></td>
                    	</tr>
                    	
                    	<tr> 
                      		<td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 요구자료 이력</td>
                      		<td colspan="3" class="td_lmagin" style="padding-top:5px;padding-bottom:5px">
                      			<table border="0" cellpadding="0" cellspacing="0">
                      				<tr>
                      					<td height="20">&nbsp;<img src="/image/reqsubmit/icon_box.gif" border="0"> 요구자료 생성일 </td>
                      					<td width="5" align="center">:</td>
                      					<td width="150">&nbsp;<%=StringUtil.getDate2((String)objRsSH.getObject("REG_DT"))%></td>
                      				</tr>
                      				<tr>
                      					<td height="20">&nbsp;<img src="/image/reqsubmit/icon_box.gif" border="0"> 비전자요구 수신일 </td>
                      					<td width="5" align="center">:</td>
                      					<td>&nbsp;<%=StringUtil.getDate2((String)objRsSH.getObject("LAST_REQ_DOC_SND_DT"))%></td>
                      				</tr>
									<tr>
                      					<td height="20">&nbsp;<img src="/image/reqsubmit/icon_box.gif" border="0"> 제출기관 조회일</td>
                      					<td width="5" align="center">:</td>
                      					<td>&nbsp;<%=StringUtil.getDate2((String)objRsSH.getObject("FST_QRY_DT"))%></td>
                      				</tr>
									<tr>
                      					<td height="20">&nbsp;<img src="/image/reqsubmit/icon_box.gif" border="0"> <B>제출기한</B></td>
                      					<td width="5" align="center">:</td>
                      					<td>&nbsp;<B><%=StringUtil.getDate((String)objRsSH.getObject("SUBMT_DLN"))%> 24:00 </B></td>
                      				</tr>
                      			</table>
                      		</td>
                    	</tr>
                    	<tr height="1" class="tbl-line"> 
                      		<td height="1" colspan="4"></td>
                    	</tr>
                    	
                    	<tr> 
                      		<td height="40" class="td_gray1">
                      			<img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 요구자료설명
                      		</td>
                      		<td height="40" colspan="3" class="td_lmagin"><%= objRsSH.getObject("REQ_BOX_DSC") %></td>
                    	</tr>
                    	<tr height="1" class="tbl-line"> 
                      		<td height="1" colspan="4"></td>
                    	</tr>
                    	
                    </table>
					<table border="0" cellpadding="0" cellspacing="0">
						<tr><td height="30">
                    &nbsp;
					
                    	</td></tr>
                    </table>
                    <!-- 답변서 발송 -->
                    <%
                    	String strAnsDocURL = null;
						String strAnsDocPreviewScriptURL = null;
		              	if (intTotalAnsCount == 0) { 
		               		strAnsDocURL = "javascript:sendAnsDoc()";
							strAnsDocPreviewScriptURL = "javascript:PreAnsDocView(viewForm,'"+strReqBoxID+"')";
						} else {
		               		strAnsDocURL = "javascript:alertSendAnsDocMessage()";
		               		strAnsDocPreviewScriptURL = "javascript:alertSendAnsDocMessage()";
						}
						//strAnsDocPreviewScriptURL = "javascript:PreAnsDocView(viewForm,'"+strReqBoxID+"')";
                    %>
                    <!-- 요구함 목록 -->										
                    <img src="/image/reqsubmit/searchlist2.gif" border="0" onClick="javascript:goReqBoxList()" style="cursor:hand"> <img src="/image/button/bt_delReqBox.gif" border="0" onClick="javascript:doDelete('<%= (String)objParams.getParamValue("ReqBoxID") %>')" style="cursor:hand">                  
                    <!-- 요구서 보기 -->
                    <img src="/image/button/bt_previewReq2.gif" border="0" 
						onClick="PreReqDocView(viewForm,'<%= (String)objParams.getParamValue("ReqBoxID") %>', '<%= CodeConstants.PRE_REQ_DOC_FORM_101 %>')" 
									style="cursor:hand" alt="제출기관에 보낼 요구서(PDF)를 확인합니다.">
                    <img src="/image/button/bt_previewSubmit2.gif" border="0" style="cursor:hand" onClick="<%= strAnsDocPreviewScriptURL %>" alt="요구기관으로 제출할 답변서(PDF)를 미리 확인합니다.">
                    <img src="/image/button/bt_sendAnswer2.gif" border="0" onClick="<%= strAnsDocURL %>" style="cursor:hand" alt="제출이 완료된 요구자료를 요구기관으로 발송합니다.">					
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
				                	 요구 목록
				            </td>
				            <td width="459" align="right" valign="bottom" class="text_s">
				            	<!------------------------- COUNT (PAGE) ------------------------------------>
				            	<img src="/image/common/icon_nemo_gray.gif" border="0">&nbsp;&nbsp;전체 자료 수 : <%= intTotalRecordCount %> 개 (<%= intCurrentPageNum %> / <%= intTotalPage %> Page)
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
                      		<td height="2" colspan="8" class="td_reqsubmit"></td>
	                    </tr>
    	                <tr align="center" class="td_top"> 
    	                	<td width="20" align="center"></td>
            	          	<td width="44" height="22">NO</td>
	                	    <td width="415"><%= SortingUtil.getSortLink("changeSortQuery", "REQ_CONT", strReqInfoSortField, strReqInfoSortMtd, "요구제목") %></td>
                    	  	<td width="80"><%= SortingUtil.getSortLink("changeSortQuery", "REQ_STT", strReqInfoSortField, strReqInfoSortMtd, "상태") %></td>
	                      	<td width="80"><%= SortingUtil.getSortLink("changeSortQuery", "OPEN_CL", strReqInfoSortField, strReqInfoSortMtd, "공개등급") %></td>
    	                  	<td width="50">답변</td>
							<td width="50">첨부</td>
        	              	<td width="70"><%=SortingUtil.getSortLink("changeSortQuery", "REG_DT", strReqInfoSortField, strReqInfoSortMtd, "등록일자")%></td>
            	        </tr>
                	    <tr> 
                    	  	<td height="1" colspan="8" class="td_reqsubmit"></td>
                    	</tr>
                    	<%
                    		int intRecordNumber= (intCurrentPageNum -1) * Integer.parseInt((String)objParams.getParamValue("ReqInfoPageSize")) +1;
							String strReqInfoID = "";
							while(objRs.next()){
								strReqInfoID = (String)objRs.getObject("REQ_ID");
						%>
						<tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''"> 
							<td width="20" align="center"><input type="checkbox" name="ReqInfoID" value="<%= strReqInfoID %>" onClick="javascript:checkBoxValidate(<%= (intRecordNumber-1) %>, '<%= strReqInfoID %>')"></td>
							<td width="44" height="22" align="center"><%= intRecordNumber %></td>
							<td width="415" class="td_lmagin"><a href="javascript:gotoDetail('<%= objRs.getObject("REQ_ID") %>')" hint="<%= StringUtil.substring((String)objRs.getObject("REQ_DTL_CONT"), 80) %>"><%= objRs.getObject("REQ_CONT") %></a></td>
							<td width="80" align="center"><%= CodeConstants.getRequestStatus((String)objRs.getObject("REQ_STT")) %></td>
							<td width="80" align="center"><%= CodeConstants.getOpenClass((String)objRs.getObject("OPEN_CL")) %></td>
							<td width="50" align="center"><%= nads.lib.reqsubmit.util.DBAccessUtil.makeAnsInfoHtml((String)objRs.getObject("ANS_ID"), (String)objRs.getObject("ANS_MTD"), (String)objRs.getObject("ANS_OPIN"), (String)objRs.getObject("SUBMT_FLAG"), objUserInfo.isRequester()) %></td>
							<td width="50" align="center"><%=makeAttachedFileLink((String)objRs.getObject("ans_estyle_file_path"))%></td>
							<td width="70" align="right" style="padding-top:2px;padding-bottom:2px"><%= StringUtil.getDate2((String)objRs.getObject("REG_DT")) %></td>
						</tr>
						<tr class="tbl-line"> 
                    	  	<td height="1" colspan="8"></td>
                    	</tr>
                    	<%
                    			intRecordNumber++;
							} //endwhile
                    	%>
	                    <tr class="tbl-line"> 
                    	  	<td height="1" colspan="8"></td>
                    	</tr>
                    </table>
	               	<!------------------------------------------------- 요구 목록 테이블 끝 ------------------------------------------------->
	               	
	               	<table border="0" cellpadding="0" cellspacing="0">
						<tr><td height="30">
		                    <img src="/image/common/icon_exclam_mark.gif" border="0"> 추가하실 답변작성이 있는 경우, 하단의 <b>추가답변 작성</b> 버튼을 클릭하여 주시기 바랍니다.
		               	</td></tr>
		            </table>
	               	
                </td>
              </tr>
              
              <!------------------ 검색(조회) 폼 <tr></tr> --------------------------->
              <tr> 
                <td height="40" align="left" valign="top">
                	<table width="100%" border="0" cellspacing="0" cellpadding="0">
                    	<tr> 
                      		<td width="300" height="40">
                      			<!-- 버튼이 필요하다면 여기에 추가하심 됩니다용 -->
			                    <!-- 답변 작성 -->
				               	<img src="/image/reqsubmit/addsubmtreg.gif" border="0" style="cursor:hand" onClick="javascript:goSbmtReqForm()">
				               	<!-- 요구 이력 조회 -->
								<img src="/image/button/bt_viewReqHistory.gif"  height="20" border="0" onClick="viewReqHistory()" style="cursor:hand"  alt="현재 요구의 처리과정을 일자별로 조회합니다.">
                      		</td>
                      		<td width="459" align="right" valign="middle">
                      			&nbsp;
                          	</td>
                    	</tr>
                  	</table>
               </td>
              </tr>
              
              <tr> 
                <td height="35" align="center">
                	<!-----------------------------------------  페이징 네비게이션 ---------------------------------------->
                	<%= PageCount.getLinkedString(
							new Integer(intTotalRecordCount).toString(),
							new Integer(intCurrentPageNum).toString(),
							objParams.getParamValue("ReqInfoPageSize"))
					%>
                </td>
              </tr>
              
            </table>
</form>
			<p><br/></p>

            </td>
        </tr>
      </table></td>
  </tr>
</table>

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

<%@ include file="/common/Bottom.jsp" %>


</body>
</html>