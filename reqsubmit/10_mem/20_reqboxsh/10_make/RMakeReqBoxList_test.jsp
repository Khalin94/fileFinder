<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.bf.config.*"%>
<%@ page import="kr.co.kcc.pf.util.PageCount"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RMemReqBoxListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.MemRequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.RequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.cmtsubmt.*" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	UserInfoDelegate objUserInfo =null;
	CDInfoDelegate objCdinfo =null;
%>

<%@ include file="../../../common/RUserCodeInfoInc.jsp" %>

<%
	/*************************************************************************************************/
	/** 					파라미터 체크 Part 														  */
	/*************************************************************************************************/
	/**선택된 감사년도와 선택된 위원회ID*/
	String strSelectedAuditYear= null; /**선택된 감사년도*/
	String strSelectedCmtOrganID=null; /**선택된 위원회ID*/
	String strRltdDuty=null; 			 /**선택된 업무구분 */
	/**요구함 목록조회용 파라미터 설정.*/
	RMemReqBoxListForm objParams=new RMemReqBoxListForm();
	/**요구기관 설정 :: 소속 기관.*/	
	objParams.setParamValue("ReqOrganID", objUserInfo.getOrganID());
	/**요구함 상태: 작성중 요구함.*/
	objParams.setParamValue("ReqBoxStt",CodeConstants.REQ_BOX_STT_003);
	boolean blnParamCheck=false;
	/**전달된 파리미터 체크 */
	blnParamCheck=objParams.validateParams(request);
	if(blnParamCheck==false){
		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
		objMsgBean.setStrCode("DSPARAM-0000");
		objMsgBean.setStrMsg(objParams.getStrErrors());
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}//endif

	strSelectedAuditYear= objParams.getParamValue("AuditYear"); /**선택된 감사년도*/
	strSelectedCmtOrganID=objParams.getParamValue("CmtOrganID") ; /**선택된 위원회ID*/
	String strDaesuInfo = StringUtil.getEmptyIfNull(request.getParameter("DaeSu"));
	String strDaeSuCh = StringUtil.getEmptyIfNull(request.getParameter("DAESUCH"));


	strRltdDuty=objParams.getParamValue("RltdDuty") ; 			 /**선택된 업무구분 */

	/*************************************************************************************************/
	/** 					데이터 호출 Part 														  */
	/*************************************************************************************************/
	
	/*** Delegate 과 데이터 Container객체 선언 */
	MemRequestBoxDelegate objReqBox=null; 		/**요구함 Delegate*/
	RequestBoxDelegate objReqBoxDelegate = null;
	
	// 2005-08-29 kogaeng ADD
	// 요구일정자동생성을 체크하기 위해서 추가되는 Delegate
	CmtSubmtReqBoxDelegate objBean2 = null;
	 
	ResultSetHelper objRs=null;				/**요구함 목록 */
	ResultSetHelper objCmtRs=null;			/** 연도별 위원회 */
	ResultSetHelper objDaeRs=null;
	ResultSetHelper objRltdDutyRs=null;   /** 업무구분 리스트 출력용 RsHelper */
	String strDaesu = null;
	String strStartdate = null;
	String strEnddate = null;
	try{
		/**요구함 정보 대리자 New */
		objReqBox=new MemRequestBoxDelegate();
		objReqBoxDelegate = new RequestBoxDelegate();
		
		// 2005-08-29 kogaeng ADD
		// 요구일정자동생성을 체크하기 위해서 추가되는 Delegate
		objBean2 = new CmtSubmtReqBoxDelegate();
		
		
		
		objDaeRs = new ResultSetHelper(objReqBoxDelegate.getOrganDaesu(objUserInfo.getOrganID()));
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

		objCmtRs=new ResultSetHelper(objReqBox.getReqrPerYearCMTDaeList(objUserInfo.getOrganID(), CodeConstants.REQ_BOX_STT_003,strStartdate,strEnddate));   


		/** 파라미터로 받은 정보가 없을 경우 리스트에서 가져옴.*/
		//if(objCmtRs.next() && !StringUtil.isAssigned(strSelectedAuditYear) && !StringUtil.isAssigned(strSelectedCmtOrganID)){
		if(objCmtRs.next() && strDaeSuCh.equals("Y")){				
			strSelectedAuditYear=(String)objCmtRs.getObject("AUDIT_YEAR");
			//strSelectedCmtOrganID=(String)objCmtRs.getObject("CMT_ORGAN_ID");
			objParams.setParamValue("AuditYear",strSelectedAuditYear);
			objParams.setParamValue("CmtOrganID",strSelectedCmtOrganID); 					
		}
	
		/*
		if(objCmtRs.next() && (objCmtRs.getRecordSize()==1)){//위원회리스트가 1이면.. 삭제되어도 첫번째것으로..
			objParams.setParamValue("CmtOrganID",(String)objCmtRs.getObject("CMT_ORGAN_ID"));
		}
		*/
		objRs=new ResultSetHelper(objReqBox.getRecordDaeList(objParams,objhashdata));
		objRltdDutyRs=new ResultSetHelper(objCdinfo.getRelatedDutyList());
	} catch(AppException objAppEx) {
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		objMsgBean.setStrCode(objAppEx.getStrErrCode());
		objMsgBean.setStrMsg(objAppEx.getMessage());
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

<html>
<head>
<title><%=MenuConstants.getReqBoxGeneral(request)%> > <%=MenuConstants.REQ_BOX_MAKE%></title>
<link href="/css/System.css" rel="stylesheet" type="text/css">
<script language="javascript" src="/js/reqsubmit/common.js"></script>
<script language="javascript">
 <%
 	//콤보 박스에 자료 넣기위해 Array에 테이터 넣어주는 부분.
    out.println("var varSelectedYear='" + strSelectedAuditYear + "';");
    out.println("var varSelectedCmt='" + strSelectedCmtOrganID + "';");
	//out.println("var arrPerYearCmt=new Array(" + objCmtRs.getTotalRecordCount() + ");");
	out.println("var arrPerYearCmt=new Array(" + (objCmtRs.getTotalRecordCount()+1) + ");");
	Vector vectorYear=new Vector();
	String strTmpYear="";
	String strOldYear="";

	out.println("arrPerYearCmt[0]=new Array('"+strSelectedAuditYear+"','','::: 전체 위원회 요구함 목록 :::');");
	
	objCmtRs.first();
	for(int i=0;objCmtRs.next();i++){
	  	strTmpYear=(String)objCmtRs.getObject("AUDIT_YEAR");
	  	/**기타위원회명 달리 표현하기 2004.06.04*/
	  	String strTmpCmtOrganNm=(String)objCmtRs.getObject("CMT_ORGAN_NM");
	  	String strTmpCmtOrganID=(String)objCmtRs.getObject("CMT_ORGAN_ID");
	  	if(objUserInfo.getIsMyCmtOrganID(strTmpCmtOrganID)==false){
	  	   strTmpCmtOrganNm=StringUtil.getOtherCmtOrganNm(strTmpCmtOrganNm);
	  	}
	  	
	    out.println("arrPerYearCmt[" +(i+1)+ "]=new Array('" 
			+ strTmpYear	+ "','" + strTmpCmtOrganID + "','" + strTmpCmtOrganNm + "');");
		if(!strTmpYear.equals(strOldYear)){
			vectorYear.add(strTmpYear);
		}
		strOldYear=strTmpYear;	
	 }
	 out.println("var arrYear=new Array(" + vectorYear.size() + ");");
	 for(int i=0;i<vectorYear.size();i++){
	   out.println("arrYear[" + i + "]= new Array('" + (String)vectorYear.get(i)+ "');");
	 }
  %>

  var IsClick=false;
   
  /** 위원회 연도 초기화 */
  function init(){
	var field=formName.AuditYear;
	for(var i=0;i<arrYear.length;i++){
	   var tmpOpt=new Option();
	   tmpOpt.text=arrYear[i];
	   tmpOpt.value=tmpOpt.text;
	   if(varSelectedYear==tmpOpt.text){
	     tmpOpt.selected=true;
	   }
	   field.add(tmpOpt);
	}
	makePerYearCmtList(field.options[field.selectedIndex].value);
  }//end of func
  
  /** 연도별 위원회 리스트 초기화 */
  function makePerYearCmtList(strYear){
       	var field=formName.CmtOrganID;
       	field.length=0;
	for(var i=0;i<arrPerYearCmt.length;i++){
	   var strTmpYear=arrPerYearCmt[i][0];
	   if(strYear==strTmpYear){
		   var tmpOpt=new Option();
		   tmpOpt.value=arrPerYearCmt[i][1];
		   tmpOpt.text=arrPerYearCmt[i][2];
		   if(varSelectedCmt==tmpOpt.value){
		     tmpOpt.selected=true;
		   }
		   field.add(tmpOpt);	
	   }
	}
  }//end of func
  
  /** 연도 변화에 따른 위원회 리스트 변화 */
  function changeCmtList(){
    makePerYearCmtList(formName.AuditYear.options[formName.AuditYear.selectedIndex].value);
  }//end of func
  
  /** 정렬방법 바꾸기 */
  function changeSortQuery(sortField,sortMethod){
  	formName.ReqBoxSortField.value=sortField;
  	formName.ReqBoxSortMtd.value=sortMethod;
	formName.DAESUCH.value = "N";
  	formName.target = '';
  	formName.submit();
  }

  function changeDaesu(){
	formName.target = '';
	formName.DAESUCH.value = "Y";
  	formName.submit();
  }
  
  //요구함상세보기로 가기.
  function gotoDetail(strID){
  	/*
  	formName.action="./RMakeReqBoxVList.jsp?ReqBoxID="+strID;
  	formName.target = "";
  	formName.submit();
	*/
	location.href="./RMakeReqBoxVList.jsp?ReqBoxID="+strID+"&AuditYear="+formName.AuditYear.value+"&CmtOrganID="+formName.CmtOrganID.value;
  }
  
  /** 페이징 바로가기 */
  function goPage(strPage){
  	formName.ReqBoxPage.value=strPage;
	formName.DAESUCH.value = "N";
  	formName.target = '';
  	formName.submit();
  }
  
  /**년도와 위원회로만 조회하기 */
  function gotoHeadQuery(){
  	formName.ReqBoxQryField.value="";
  	formName.ReqBoxQryTerm.value="";
  	formName.ReqBoxSortField.value="";
  	formName.ReqBoxSortMtd.value="";
  	formName.ReqBoxPage.value="";
	formName.DAESUCH.value = "N";
  	formName.target = '';
  	formName.submit();
  }
  
	// 2005-07-13 요구서 일괄 발송
	function sendReqDoc() {
		if(!IsClick){
			if(document.formName.CmtOrganID.value == "") {
				alert("요구서 발송을 위해서는 우선 위원회를 선택해 주시기 바랍니다.");
				document.formName.CmtOrganID.focus();
				return;
			}
		
			if(getCheckCount(document.formName, "ReqBoxID") < 1) {
				alert("발송하실 하나 이상의 요구함을 선택해 주세요.");
				return;
			}
		}else{
			alert("프로세스가 작동중입니다. 잠시 기다려주십시오.");
			return false;
		}

	  	if(confirm("선택하신 요구함을 해당 제출기관으로 일괄 발송하시겠습니까?\n\r\n\r***** 확인바랍니다 *****\n\r해당기관의 대표 담당자가 없는 경우는 발송되지 않습니다.")) {
			IsClick = true;  //버튼 처리를 수행중..
			ButtonProcessing();  //처리상태를 표시하는 메소드 호출
			//var winl = (screen.width - 304) / 2;
			//var winh = (screen.height - 118) / 2;
			//document.all.loadingDiv.style.left = winl;
			//document.all.loadingDiv.style.top = winh;
			//document.all.loadingDiv.style.display = '';
			document.formName.action = "/reqsubmit/common/ReqDocSendProcMultiTest.jsp";
			document.formName.target = 'processingFrame';
			//window.open('/blank.html', 'popwin', 'width=300, height=200, left='+winl+', top='+winh);
	  		document.formName.submit();
	  	}
	}

	
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
	

	// 2005-07-13 요구서 일괄 발송
	function sendReqDoc1() {
		if(!IsClick){
			if(document.formName.CmtOrganID.value == "") {
				alert("요구서 발송을 위해서는 우선 위원회를 선택해 주시기 바랍니다.");
				document.formName.CmtOrganID.focus();
				return;
			}
		
			if(getCheckCount(document.formName, "ReqBoxID") < 1) {
				alert("발송하실 하나 이상의 요구함을 선택해 주세요.");
				return;
			}
		}else{
			alert("프로세스가 작동중입니다. 잠시 기다려주십시오.");
			return false;
		}
		
	  	if(confirm("선택하신 요구함을 해당 제출기관으로 일괄 발송하시겠습니까?\n\r\n\r***** 확인바랍니다 *****\n\r해당기관의 대표 담당자가 없는 경우는 발송되지 않습니다.")) {
			IsClick = true;  //버튼 처리를 수행중..
			ButtonProcessing();  //처리상태를 표시하는 메소드 호출
			//var winl = (screen.width - 304) / 2;
			//var winh = (screen.height - 118) / 2;
			//document.all.loadingDiv.style.left = winl;
			//document.all.loadingDiv.style.top = winh;
			//document.all.loadingDiv.style.display = '';
			document.formName.action = "/reqsubmit/common/ReqDocSendProcMultiTest.jsp";
			document.formName.target = 'processingFrame';
			//window.open('/blank.html', 'popwin', 'width=300, height=200, left='+winl+', top='+winh);
	  		document.formName.submit();
	  	}else{
			 return ;
		}
	}
	
	function AllInOne(){
		var w = 800;
		var h = 700;
		var winl = (screen.width - w) / 2;
		var winh = (screen.height - h) / 2;
		var url = "/reqsubmit/common/ReqInfoWriteAllInOne.jsp";	window.open(url,'New','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=no,width='+w+',height='+h+',left='+winl+',top='+winh);
	}
	
	// 2005-07-18 선택된 요구함 일괄 삭제
	function doDelete() {
		if(!IsClick){
			if(getCheckCount(document.formName, "ReqBoxID") < 1) {
				alert("삭제하실 하나 이상의 요구함을 선택해 주세요.");
				return;
			}
		}else{
			alert("프로세스가 작동중입니다. 잠시 기다려주십시오.");
			return false;
		}
	  	
	  	if(confirm("선택하신 요구함을 일괄 삭제하시겠습니까?\n\r포함된 모든 요구 내용도 일괄 삭제됩니다.")) {
			IsClick = true;  //버튼 처리를 수행중..
			ButtonProcessing();  //처리상태를 표시하는 메소드 호출

			//var winl = (screen.width - 300) / 2;
			//var winh = (screen.height - 240) / 2;
			//document.all.loadingDiv.style.left = winl;
			//document.all.loadingDiv.style.top = winh;
			//document.all.loadingDiv.style.display = '';
			document.formName.action = "/reqsubmit/10_mem/20_reqboxsh/10_make/ReqBoxDelProcMulti.jsp";
			document.formName.target = 'processingFrame';	
			//window.open('/blank.html', 'popwin', 'width=300, height=240, left='+winl+', top='+winh);
	  		document.formName.submit();
	  	}
	}
	
	// 2005-08-26 kogaeng ADD
	// 위원회 명의 요구서 일괄 발송
	function sendCmtReqDoc() {
		if(!IsClick){
			if(document.formName.CmtOrganID.value == "") {
				alert("요구서 발송을 위해서는 우선 위원회를 선택해 주시기 바랍니다.");
				document.formName.CmtOrganID.focus();
				return;
			}
			
			if(getCheckCount(document.formName, "ReqBoxID") < 1) {
				alert("위원회 명의로 발송할 요구함을 하나 이상 선택해 주세요.");
				return;
			}
			<% if(objBean2.checkCmtOrganMakeAutoSche(strSelectedCmtOrganID) && objUserInfo.getIsMyCmtOrganID(strSelectedCmtOrganID)) { %>

			<%}else{%>
				alert("소속 상임위원회가 아닌 경우에는 발송하실 수 없습니다.");
				return;
			<%}%>
		}else{
			alert("프로세스가 작동중입니다. 잠시 기다려주십시오.");
			return false;
		}	  			
	  	
		if(confirm("선택하신 요구함을 해당 위원회 명의로 발송하시겠습니까?\n\r\n\r[확인사항]\n\r1. 소속 상임위원회가 아닌 경우에는 발송하실 수 없습니다.\n\r2. 등록된 요구가 없는 경우 발송하실 수 없습니다.")) {
			IsClick = true;  //버튼 처리를 수행중..
			ButtonProcessing();  //처리상태를 표시하는 메소드 호출

			//var winl = (screen.width - 304) / 2;
			//var winh = (screen.height - 118) / 2;
			//document.all.loadingDiv.style.left = winl;
			//document.all.loadingDiv.style.top = winh;
			//document.all.loadingDiv.style.display = '';
			document.formName.action = "/reqsubmit/common/CmtReqDocSendAllInOneMulti.jsp";
			document.formName.target = 'processingFrame';
			//window.open('/blank.html', 'popwin', 'width=300, height=200, left='+winl+', top='+winh);
	  		document.formName.submit();
		}
	}
</script>
</head>
<%
	// 2005-08-09 kogaeng ADD
	// 요구함 작성 메뉴 때문에 불가피하게 추가
	String strAddScript = "";
	String strAutoPopup = StringUtil.getEmptyIfNull(request.getParameter("AutoPopup"));
	if("Y".equalsIgnoreCase(strAutoPopup)) strAddScript = "AllInOne();";
%>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0"  onload="<%= strAddScript %>init()">
<iframe name='processingFrame' height='0' width='0'></iframe>
<DIV ID="loadingDiv" style="display:none;position:absolute;">
	<img src="/image/reqsubmit/loading.jpg" border="0"> </td>
</DIV>

<%@ include file="../../../common/MenuTopReqsubmit.jsp" %>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr align="left" valign="top">
    <td width="186" height="470" background="/image/common/bg_leftMenu.gif">
	<%@ include file="../../../common/MenuLeftReqsubmit.jsp" %></td>
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
<form name="formName" method="<%=nads.lib.reqsubmit.EnvConstants.FORM_METHOD%>" action="<%=request.getRequestURI()%>">
		  <%//정렬 정보 받기.
			String strReqBoxSortField=objParams.getParamValue("ReqBoxSortField");
			String strReqBoxSortMtd=objParams.getParamValue("ReqBoxSortMtd");
		  %>
			<input type="hidden" name="ReqBoxSortField" value="<%=strReqBoxSortField%>"><!--요구함목록정렬필드 -->
			<input type="hidden" name="ReqBoxSortMtd" value="<%=strReqBoxSortMtd%>"><!--요구함목록정령방법-->
			<input type="hidden" name="ReqBoxPage" value="<%=intCurrentPageNum%>"><!--페이지 번호 -->
			
			<!-- 2005-07-18 요구서 발송을 위한 기본 정보 -->
			<input type="hidden" name="ReqDocType" value="<%= CodeConstants.REQ_DOC_TYPE_001 %>">
			<input type="hidden" name="ReqTp" value="<%= CodeConstants.REQ_DOC_FORM_001 %>">
			<input type="hidden" name="SmsUse" value="<%= CodeConstants.NTC_MTD_BOTH %>">
			<input type="hidden" name="ReqOrganID" value="<%= objUserInfo.getOrganID() %>">
			<input type="hidden" name="SndrID" value="<%= objUserInfo.getUserID() %>">
			<input type="hidden" name="DAESUCH" value="">
			
              <tr> 
                <td height="23" align="left" valign="top"></td>
              </tr>
              <tr> 
                <td height="23" align="left" valign="top"><table width="100%" height="23" border="0" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="25%" background="/image/reqsubmit/bg_reqsubmit_tit.gif">
                      		<!-------------------- 타이틀을 입력해 주세요 ------------------------>
                      		<span class="title"><%=MenuConstants.REQ_BOX_MAKE%></span>
                      </td>
                      <td width="16%" align="left" background="/image/common/bg_titLine.gif">&nbsp;</td>
                      <td width="59%" align="right" background="/image/common/bg_titLine.gif" class="text_s">
                      		<!-------------------- 현재 위치 정보를 기술한답니다. ------------------------>
                      		<img src="/image/common/icon_navi.gif" width="3" height="5" align="absmiddle"> 
                        <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.getReqBoxGeneral(request)%> > <B><%=MenuConstants.REQ_BOX_MAKE%></B>
                      </td>
                    </tr>
                  </table></td>
              </tr>
              <tr> 
                <td height="30" align="left" class="text_s">
                		<!-------------------- 현재 페이지에 대한 설명 기술 ------------------------>
                		아직 제출기관으로 요구서가 발송되지 않은, 현재 작성 중인 요구함 목록을 확인할 수 있습니다. 
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
                			<td width="559">
                				<table border="0" cellspacing="0" cellpadding="0">
                					<tr>
                						<td valign="top">
			                				<img src="/image/reqsubmit/icon_reqsubmit_soti.gif" width="9" height="9" align="absmiddle">
											<select name="DaeSu" class="select_reqsubmit" onChange="changeDaesu()">
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
			                				<select name="AuditYear" onChange="changeCmtList()" class="select_reqsubmit"></select>
			                				<select name="CmtOrganID" class="select_reqsubmit" onChange="this.form.submit()"></select>                						
											<select name="RltdDuty"  class="select_reqsubmit" onChange="this.form.submit()">
												<option value="">업무구분(전체)</option>
											<%
											   /**업무구분 리스트 출력 */
											   while(objRltdDutyRs!=null && objRltdDutyRs.next()){
											   		String strCode=(String)objRltdDutyRs.getObject("MSORT_CD");
											   		out.println("<option value=\"" + strCode + "\" " + StringUtil.getSelectedStr(strRltdDuty,strCode) + ">" + objRltdDutyRs.getObject("CD_NM") + "</option>");
											   }
											%>													
											</select>
			                				
                						</td>
                						<td valign="bottom">&nbsp;&nbsp;
			                				<img src="/image/button/bt_inquiry.gif" height="20"  style="cursor:hand" onClick="gotoHeadQuery();">                						
                						</td>
                					</tr>
                				</table>
				            </td>
				            <td width="200" align="right" valign="bottom"  class="text_s">
				            	<!------------------------- COUNT (PAGE) ------------------------------------>
				            	&nbsp;&nbsp;<img src="/image/common/icon_nemo_gray.gif" width="3" height="6" align="absmiddle">
				            	전체 자료 수 : <%=intTotalRecordCount%>개 (<%=intCurrentPageNum%> / <%=intTotalPage%> Page)&nbsp;&nbsp;
				            </td>
				       </tr>
				   </table>
                </td>
              </tr>
              <tr> 
                <td align="left" valign="top" class="soti_reqsubmit">
                <!------------------------- TAB에 해당하는 테이블(목록이든 등록폼이든 상세정보든) 출력 시~~~작 ------------------------->
					<table width="759" border="0" cellspacing="0" cellpadding="0">
                    	<tr> 
                      		<td height="2" class="td_reqsubmit"></td>
	                    </tr>
	                    <tr align="center" class="td_top">
	                    	<td>
	                    		<table width="759" border="0" cellspacing="0" cellpadding="0">
									<tr class="td_top">
										<td height="22" width="30" align="center"><input type="checkbox" name="checkAll" onClick="javascript:checkAllOrNot(document.formName)"></td>
										<td width="300" align="center"><%=SortingUtil.getSortLink("changeSortQuery","REQ_BOX_NM",strReqBoxSortField,strReqBoxSortMtd,"요구함명")%></td>
										<td width="160" align="center"><%=SortingUtil.getSortLink("changeSortQuery","SUBMT_ORGAN_NM",strReqBoxSortField,strReqBoxSortMtd,"제출기관")%></td>
										<td width="80" align="center"><%=SortingUtil.getSortLink("changeSortQuery","RLTD_DUTY",strReqBoxSortField,strReqBoxSortMtd,"업무구분")%></td>
										<td width="70" align="center"><%=SortingUtil.getSortLink("changeSortQuery","REQ_BOX_STT",strReqBoxSortField,strReqBoxSortMtd,"진행상태")%></td>
										<td width="40" align="center">개수</td>
										<td width="80" align="center"><%=SortingUtil.getSortLink("changeSortQuery","REG_DT",strReqBoxSortField,strReqBoxSortMtd,"등록일자")%></td>
									</tr>
	                    		</table>
	                    	</td>
	                    </tr>
                	    <tr> 
                    	  	<td height="1" class="td_reqsubmit"></td>
                    	</tr>
						<%
						  int intRecordNumber = intTotalRecordCount - ((intCurrentPageNum -1) * Integer.parseInt((String)objParams.getParamValue("ReqBoxPageSize")));						  
						  if(objRs.getRecordSize() > 0){
						  	String strReqBoxID = "";
							int intMakeGrdID = 0;
						  	while(objRs.next()){
						  		strReqBoxID = (String)objRs.getObject("REQ_BOX_ID");
								intMakeGrdID = Integer.parseInt(StringUtil.getEmptyIfNull((String)objRs.getObject("MAKE_GRD_ID"), "0"));
								String strBgColor = "";
								if((intMakeGrdID % 2) == 0) strBgColor = "#f4f4f4";
						 %>								
						<tr bgcolor="" onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''">
							<td>
								<table width="759" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td height="22" width="30" align="center" bgcolor="<%= strBgColor %>"><input type="checkbox" name="ReqBoxID" value="<%=strReqBoxID%>"></td>
										<td width="310" class="td_lmagin"><a href="javascript:gotoDetail('<%=strReqBoxID%>')"><%=(String)objRs.getObject("REQ_BOX_NM")%></a></td>
										<td width="160" align="left"><%=(String)objRs.getObject("SUBMT_ORGAN_NM")%></td>
										<td width="80" align="center"><%=objCdinfo.getRelatedDuty((String)objRs.getObject("RLTD_DUTY"))%></td>
										<td width="70" align="center"><%=CodeConstants.getReqBoxStatus((String)objRs.getObject("REQ_BOX_STT"),true)%></td>
										<td width="40" align="center"><%=objRs.getObject("REQ_CNT")%></td>
										<td width="70" align="right" style="padding-top:2px;padding-bottom:2px;padding-right:2px"><%= StringUtil.getDate2((String)objRs.getObject("REG_DT"))%></td>
									</tr>
								</table>
							</td>
						</tr>
    	                <tr class="tbl-line"> 
                      		<td height="1"></td>
                    	</tr>       	
						<%
							    intRecordNumber --;
							}//endwhile
						}else{
						%>
						<tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''">
							<td align="center"  height="40">등록된 <%=MenuConstants.REQ_BOX_MAKE%>이 없습니다.</td>
						</tr>
    	                <tr class="tbl-line"> 
                      		<td height="1"></td>
                    	</tr>       							
						<%
						}//end if 목록 출력 끝.
						%>
    	                <tr class="tbl-line"> 
                      		<td height="1"></td>
                    	</tr>       							
	                </table>
				<!------------------------- TAB에 해당하는 테이블(목록이든 등록폼이든 상세정보든) 출력 끝 ------------------------->
               </td>
              </tr>
              <tr> 
                <td height="35" align="center">
                	<!-----------------------------------------  페이징 네비게이션 ---------------------------------------->
                	<%= PageCount.getLinkedString(
							new Integer(intTotalRecordCount).toString(),
							new Integer(intCurrentPageNum).toString(),
							objParams.getParamValue("ReqBoxPageSize"))
					%>
                </td>
              </tr>
              <tr height="3">
              	<td height="3" align="left" valign="top" background="/image/common/line_table.gif"></td>
              </tr>
              <!------------------ 검색(조회) 폼 <tr></tr> --------------------------->
              <tr> 
                <td height="40" align="left" valign="top">
					<BR>
					<img src="/image/common/icon_exclam_mark.gif" border="0"> 요구서를 발송하게 되면 해당 제출 기관 대표 담당자에게 지정 발송되며, 담당자가 없는 경우는 작성 중 요구함에 그대로 남아있게 됩니다.<BR>
					<img src="/image/common/icon_exclam_mark.gif" border="0"> 요구서 발송 버튼을 이용하시기 위해서는 위원회를 선택해 주시기 바랍니다.
					<!-- img src="/image/common/icon_exclam_mark.gif" border="0"> 전자문서 시스템을 이용하실 경우는 요구함별로 개별 발송해 주시기 바랍니다. -->
                	<table width="100%" border="0" cellspacing="0" cellpadding="0">
                    	<tr> 
                      		<td width="456" height="40">
                      			<!-- 버튼이 필요하다면 여기에 추가하심 됩니다용 -->
                      			<img src="/image/button/bt_makeReqBox.gif" height="20"  style="cursor:hand" onClick="javascript:AllInOne();" alt="새로운 요구함 작성을 시작합니다.">

								<img src="/image/button/bt_delReqBox.gif" border="0" style="cursor:hand" onClick="javascript:doDelete()" alt="선택한 요구함을 일괄 삭제합니다.">

                      			<!-- 2005-08-08 kogaeng EDIT -->
								<!-- 법사위의 경우 보여서는 안된다 -->
								<% 
									if(!objUserInfo.getIsMyCmtOrganID("GI00004757")) {
								%>
										<img src="/image/button/bt_sendReq2.gif" border="0" onClick="javascript:sendReqDoc()" style="cursor:hand">
								<%
									} else {
										if(!"".equalsIgnoreCase(strSelectedCmtOrganID) && !"GI00004757".equalsIgnoreCase(strSelectedCmtOrganID)) { 
								%>
		                      				<img src="/image/button/bt_sendReq2.gif" border="0" onClick="javascript:sendReqDoc()" style="cursor:hand">
								<% 
										} 
									}
								%>
															
									<img src="/image/button/bt_sendReqDocCmtTitle2.gif" border="0" onClick="javascript:sendCmtReqDoc()" style="cursor:hand">												
                      		</td>
							<td width="303" align="right" valign="middle">
							<%
								String strReqBoxQryField=objParams.getParamValue("ReqBoxQryField");
							%>
								<select name="ReqBoxQryField" class="select">
									<option <%=(strReqBoxQryField.equalsIgnoreCase("req_box_nm"))? " selected ": ""%>value="req_box_nm">요구함명</option>
									<option <%=(strReqBoxQryField.equalsIgnoreCase("req_box_dsc"))? " selected ": ""%>value="req_box_dsc">요구함설명</option>
									<option <%=(strReqBoxQryField.equalsIgnoreCase("submt_organ_nm"))? " selected ": ""%>value="submt_organ_nm">제출기관</option>
								</select>
								<input type="text" class="textfield" name="ReqBoxQryTerm" value="<%=objParams.getParamValue("ReqBoxQryTerm")%>">
								<img src="/image/common/bt_search_table.gif" height="18" align="absmiddle" onClick="formName.submit();" style="cursor:hand">
							</td>
                    	</tr>
                  	</table>
               </td>
              </tr>              
</form>
          </table>
          </td>
        </tr>
        <tr>
        	<td height="35">&nbsp;</td>
        </tr>
    </table>
    <!--------------------------------------- 여기까지  MAIN WORK AREA 실제 코딩의 끝입니다. ----------------------------->      
    </td>
  </tr>
</table>
<%@ include file="../../../../common/Bottom.jsp" %>
</body>
</html>              
