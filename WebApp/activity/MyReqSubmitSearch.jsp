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
<%@ page import="nads.dsdm.app.common.page.PagingDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.MemRequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.RequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.cmtsubmt.*" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<jsp:include page="/inc/header.jsp" flush="true"/>
<link href="/css2/style.css" rel="stylesheet" type="text/css">
</head>
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
	/** 					파라미터 체크 Part 														  */
	/*************************************************************************************************/
	/**선택된 감사년도와 선택된 위원회ID*/
	String strSelectedAuditYear= null; /**선택된 감사년도*/
	String strSelectedCmtOrganID=null; /**선택된 위원회ID*/
	String strRltdDuty=null;	/**선택된 업무구분 */
	String strDaeSuCh = null;
	String strCmtGubun = objUserInfo.getOrganGBNCode();	/**(작성중 요구함 조회시 필요)*/
	String strBoxTp = null;			/**선택된 전자비전자구분(제출완료 요구함 조회시 필요)*/
	String strReqBoxStt = null;		/**선택된 진행상태*/
	String strReqBoxStt2 = null;	/**선택된 진행상태2[요구제출자료검색 용도(디폴트세팅 문제로 별도의 진행상태 변수를 사용한다.)]*/

	/**요구함 목록조회용 파라미터 설정.*/
	RMemReqBoxListForm objParams=new RMemReqBoxListForm();

	/**요구기관 설정 :: 소속 기관.*/
//	objParams.setParamValue("ReqOrganID", objUserInfo.getOrganID());

	// 모든 요구함 상태를 보여주기 위해 요구함 상태 파라미터를 설정하지 않음

	/**요구함 상태: 작성중 요구함.*/
//	objParams.setParamValue("ReqBoxStt",CodeConstants.REQ_BOX_STT_003);

	/**요구함 상태: 발송완료 요구함.*/
//	objParams.setParamValue("ReqBoxStt",CodeConstants.REQ_BOX_STT_006);
//	if(!StringUtil.isAssigned(objParams.getParamValue("ReqBoxSortField"))) objParams.setParamValue("ReqBoxSortField", "LAST_REQ_DOC_SND_DT");

	/**요구함 상태: 제출완료 요구함.*/
//	objParams.setParamValue("ReqBoxStt",CodeConstants.REQ_BOX_STT_007);
//	if((objParams.getParamValue("ReqBoxSortField")).equals("reg_dt")) objParams.setParamValue("ReqBoxSortField","LAST_ANS_DOC_SND_DT");

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
	strBoxTp=objParams.getParamValue("BoxTp") ;		/**선택된 전자비전자구분(제출완료 요구함 조회시 필요)*/
	strReqBoxStt=objParams.getParamValue("ReqBoxStt") ;	/**선택된 진행상태*/

	strRltdDuty=objParams.getParamValue("RltdDuty") ; 			 /**선택된 업무구분 */
	String strDaesuInfo = StringUtil.getEmptyIfNull(request.getParameter("DaeSu"));
	strDaeSuCh = StringUtil.getEmptyIfNull(request.getParameter("DAESUCH"));

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
	ResultSetHelper objRltdDutyRs=null;   /** 업무구분 리스트 출력용 RsHelper */
	ResultSetHelper objDaeRs=null;
	ResultSetHelper objYearRs=null;

	String strDaesu = null;
	String strStartdate = null;
	String strEnddate = null;
	String strStrDay = null;
	String strEndDay = null;

	String strStartdateReq = null;
	String strEnddateReq = null;
	String strStrDayReq = null;
	String strEndDayReq = null;

	String strSearchKeyword = null;
	strSearchKeyword = StringUtil.getEmptyIfNull(request.getParameter("SearchKeyword"));


	// 세션에서 검색에 필요한 키값 가져오기
	HttpSession objSession = request.getSession();

	// 요구자, 제출자 구분값
	String REQ_SUBMT_FLAG = (String)objSession.getAttribute("REQ_SUBMT_FLAG").toString();	// 요구자 : 001, 제출자 : 002
	String INOUT_GBN = (String)objSession.getAttribute("INOUT_GBN").toString();			// 요구자 : I, 제출자 : X

	// ORGAN_ID
	String ORGAN_ID = (String)objSession.getAttribute("ORGAN_ID").toString();

	// ORGAN_KIND : 의원실(003), 위원회(004)
	String ORGAN_KIND = (String)objSession.getAttribute("ORGAN_KIND").toString();



	// 제출기관, 요구기관

	String ans_organ_select = StringUtil.getEmptyIfNull(request.getParameter("ans_organ_select"));
	String ans_organ_select_id = StringUtil.getEmptyIfNull(request.getParameter("ans_organ_select_id"));
	if("".equals(ans_organ_select))	ans_organ_select_id = ""; // 기관명을 지우고 검색하면, 기관ID 값도 삭제

	String req_organ_select = StringUtil.getEmptyIfNull(request.getParameter("req_organ_select"));
	String req_organ_select_id = StringUtil.getEmptyIfNull(request.getParameter("req_organ_select_id"));
	if("".equals(req_organ_select))	req_organ_select_id = ""; // 기관명을 지우고 검색하면, 기관ID 값도 삭제


	// 소속위원회

	String CmtOrganID = StringUtil.getEmptyIfNull(request.getParameter("CmtOrganID"));


	// 등록자

	String REGR_NM = StringUtil.getEmptyIfNull(request.getParameter("REGR_NM"));


	try{
		/**요구함 정보 대리자 New */
		objReqBox=new MemRequestBoxDelegate();
		objReqBoxDelegate = new RequestBoxDelegate();

		objBean2 = new CmtSubmtReqBoxDelegate();

		objDaeRs = new ResultSetHelper(objReqBoxDelegate.getOrganDaesu(objUserInfo.getOrganID()));

		// 진행상태[요구제출자료검색 페이지용]
		strReqBoxStt2	= StringUtil.getEmptyIfNull(request.getParameter("ReqBoxStt2"));

		strStrDay		= StringUtil.getEmptyIfNull(request.getParameter("StartDate"));
		strEndDay		= StringUtil.getEmptyIfNull(request.getParameter("EndDate"));
		strStartdate	= strStrDay.replaceAll("-","");
		strEnddate		= strEndDay.replaceAll("-","");
		strDaesu		= "";

		strStrDayReq		= StringUtil.getEmptyIfNull(request.getParameter("StartDateReq"));
		strEndDayReq		= StringUtil.getEmptyIfNull(request.getParameter("EndDateReq"));
		strStartdateReq		= strStrDayReq.replaceAll("-","");
		strEnddateReq		= strEndDayReq.replaceAll("-","");


		if("".equals(strStartdate) || "".equals(strEnddate)) {
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
		}
	    Hashtable objhashdata = new Hashtable();
		System.out.println("TIMEMMMM1 : "+this.getCurrentTime());

		// 연도별 위원회 ResultSet : 작성중 요구함
//		objCmtRs=new ResultSetHelper(objReqBox.getReqrPerYearCMTDaeList(objUserInfo.getOrganID(), CodeConstants.REQ_BOX_STT_003,strStartdate,strEnddate,strSelectedAuditYear));
//		objYearRs = new ResultSetHelper(objReqBox.getReqrPerYearDaeList(objUserInfo.getOrganID(), CodeConstants.REQ_BOX_STT_003,strStartdate,strEnddate));

		// 연도별 위원회 ResultSet : 발송완료 요구함
//		objCmtRs=new ResultSetHelper(objReqBox.getReqrPerYearCMTDaeList(objUserInfo.getOrganID(), CodeConstants.REQ_BOX_STT_006,strStartdate,strEnddate,strSelectedAuditYear));
//		objYearRs = new ResultSetHelper(objReqBox.getReqrPerYearDaeList(objUserInfo.getOrganID(), CodeConstants.REQ_BOX_STT_006,strStartdate,strEnddate));

		// 연도별 위원회 ResultSet : 제출완료 요구함
//		objCmtRs=new ResultSetHelper(objReqBox.getReqrPerYearCMTDaeList(objUserInfo.getOrganID(), CodeConstants.REQ_BOX_STT_007,strStartdate,strEnddate,strSelectedAuditYear));
//		objYearRs = new ResultSetHelper(objReqBox.getReqrPerYearDaeList(objUserInfo.getOrganID(), CodeConstants.REQ_BOX_STT_007,strStartdate,strEnddate));

		// 연도별 위원회 ResultSet : 작성중 + 발송완료 + 제출완료 요구함
		objCmtRs=new ResultSetHelper(objReqBox.getReqrPerYearCMTDaeList2(objUserInfo.getOrganID(), strStartdate,strEnddate,strSelectedAuditYear));
		objYearRs = new ResultSetHelper(objReqBox.getReqrPerYearDaeList2(objUserInfo.getOrganID(), strStartdate,strEnddate));

		System.out.println("TIMEMMMM2 : "+this.getCurrentTime());



//		대 검색
		objhashdata.put("START_DATE",strStartdate);
	    objhashdata.put("END_DATE",strEnddate);

//		요청일 검색
		objhashdata.put("START_DATE_REQ",strStartdateReq);
	    objhashdata.put("END_DATE_REQ",strEnddateReq);

//		검색어(요구함명)
		objhashdata.put("SEARCH_KEYWORD",strSearchKeyword);

//		소속위원회
		objhashdata.put("CmtOrganID",CmtOrganID);

//		요구함 등록자
		objhashdata.put("REGR_NM",REGR_NM);

//		진행상태
		objhashdata.put("REQBOXSTT2",strReqBoxStt2);

//		전자/비전자
		objhashdata.put("BOXTP",strBoxTp);
//      제출 요구 기관
		objhashdata.put("ans_organ_select_id",ans_organ_select_id);
        objhashdata.put("req_organ_select_id",req_organ_select_id);

		// 계정타입

		String strRegType = "";

		System.out.println("REQ_SUBMT_FLAG : "+REQ_SUBMT_FLAG);
		System.out.println("ORGAN_KIND : "+ORGAN_KIND);

		// 요구자
		if("001".equals(REQ_SUBMT_FLAG)){
			// 의원실
			if("003".equals(ORGAN_KIND)){
//				objParams.setParamValue("req_organ_id",ORGAN_ID);
//				objParams.setParamValue("SUBMT_ORGAN_ID",null);
//				objParams.setParamValue("CMT_ORGAN_ID",null);
				strRegType = "001";
			// 위원회
			}else{
//				objParams.setParamValue("req_organ_id",null);
//				objParams.setParamValue("SUBMT_ORGAN_ID",null);
//				objParams.setParamValue("CMT_ORGAN_ID",ORGAN_ID);
				strRegType = "003";
			}
		// 제출자
		}else{
//			objParams.setParamValue("req_organ_id",null);
//			objParams.setParamValue("SUBMT_ORGAN_ID",ORGAN_ID);
//			objParams.setParamValue("CMT_ORGAN_ID",null);
			strRegType = "002";
		}

//		objParams.setParamValue("ReqOrganID",null);

//		계정타입
		objhashdata.put("REGTYPE",strRegType);

//		사용자 기관ID
		objhashdata.put("ORGAN_ID",ORGAN_ID);

		System.out.println("-------------------------------------------------------------------------------------");
		// 요구함 리스트 ResultSet
		objRs=new ResultSetHelper(objReqBox.getRecordDaeList2(objParams,objhashdata));
		System.out.println("-------------------------------------------------------------------------------------");
        System.out.println("strRegType"+strRegType);
        System.out.println("req_organ_select_id"+ans_organ_select_id);
		System.out.println("-------------------------------------------------------------------------------------");
		// 업무구분 리스트 출력용 ResultSet
		objRltdDutyRs=new ResultSetHelper(objCdinfo.getRelatedDutyList());
		System.out.println("TIMEMMMM4 : "+this.getCurrentTime());

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
<script language=Javascript src="/js/datepicker.js"></script>
<script language="javascript" src="/js/reqsubmit/common.js"></script>
<script language="javascript">

  var IsClick=false;	// 작성중 요구함 조회시 필요

  /** 정렬방법 바꾸기 */
  function changeSortQuery(sortField,sortMethod){
  	formName.ReqBoxSortField.value=sortField;
  	formName.ReqBoxSortMtd.value=sortMethod;
	formName.DAESUCH.value = "N";
	formName.target = '';	// 작성중 요구함 조회시 필요
    formName.action = "<%=request.getRequestURI()%>";
  	formName.submit();
  }

  //작성중 요구함상세보기로 가기.
  function gotoDetail(strID){
	/*
  	formName.action="./RMakeReqBoxVList.jsp?ReqBoxID="+strID;
  	formName.target = "";
  	formName.submit();
	*/

	var strIDArr = strID.split("/");
	var strID = strIDArr[0];
	var strStt = strIDArr[1];

	var REQ_SUBMT_FLAG = '<%=REQ_SUBMT_FLAG %>';
	var ORGAN_KIND = '<%=ORGAN_KIND %>';

	if(!IsClick){

		// 요구자
		if(REQ_SUBMT_FLAG == '001'){

			// 의원실
			if(ORGAN_KIND == '003'){

				switch(strStt){

					case '003': location.href="/reqsubmit/10_mem/20_reqboxsh/10_make/RMakeReqBoxVList.jsp?ReqBoxID="+strID+"&CmtOrganID="+formName.CmtOrganID.value; break;	// 작성중
					case '006': location.href="/reqsubmit/10_mem/20_reqboxsh/20_sendend/RSendBoxVList.jsp?ReqBoxID="+strID+"&CmtOrganID="+formName.CmtOrganID.value; break;	// 발송완료
					case '007': location.href="/reqsubmit/10_mem/20_reqboxsh/30_makeend/RMakeEndVList.jsp?ReqBoxID="+strID+"&CmtOrganID="+formName.CmtOrganID.value; break;	// 제출완료

				}

			// 위원회
			}else{

				switch(strStt){

					case '002': location.href="/reqsubmit/20_comm/20_reqboxsh/20_accend/RAccBoxVList.jsp?ReqBoxID="+strID+"&CmtOrganID="+formName.CmtOrganID.value; break;	// 접수완료
					case '006': location.href="/reqsubmit/20_comm/20_reqboxsh/30_sendend/RSendBoxVList.jsp?ReqBoxID="+strID+"&CmtOrganID="+formName.CmtOrganID.value; break;	// 발송완료
					case '007': location.href="/reqsubmit/20_comm/20_reqboxsh/40_subend/RSubEndBoxVList.jsp?ReqBoxID="+strID+"&CmtOrganID="+formName.CmtOrganID.value; break;	// 제출완료

				}

			}

		// 제출자
		}else{

				switch(strStt){

					case '006': location.href="/reqsubmit/10_mem/20_reqboxsh/10_make/SMakeReqBoxVList.jsp?ReqBoxID="+strID+"&CmtOrganID="+formName.CmtOrganID.value; break;	// 작성중
					case '007': location.href="/reqsubmit/10_mem/20_reqboxsh/30_makeend/SMakeEndBoxVList.jsp?ReqBoxID="+strID+"&CmtOrganID="+formName.CmtOrganID.value; break;	// 작성완료

				}

		}


	}else{
		alert("프로세스가 작동중입니다. 잠시 기다려주십시오.");
		return;
	}

  }

  //발송완료 요구함상세보기로 가기.
/*
  function gotoDetail(strID, strCmtOrganID) {
  	formName.ReqBoxID.value = strID;
  	formName.CmtOrganID.value = strCmtOrganID;
  	formName.action="./RSendBoxVList.jsp";
  	formName.submit();
  }
*/
  //제출완료 요구함상세보기로 가기.
/*
  function gotoDetail(strID){
  	formName.ReqBoxID.value=strID;
  	formName.action="./RMakeEndVList.jsp";
  	formName.submit();
  }
*/
  /** 페이징 바로가기 */
  function goPage(strPage){
  	formName.ReqBoxPage.value=strPage;
	formName.DAESUCH.value = "N";
	formName.target = '';	// 작성중 요구함 조회시 필요
    formName.action = "<%=request.getRequestURI()%>";
  	formName.submit();
  }

  /**년도와 위원회로만 조회하기 */
  function gotoHeadQuery(){
//  	formName.ReqBoxQryField.value="";
//  	formName.ReqBoxQryTerm.value="";
  	formName.ReqBoxSortField.value="";
  	formName.ReqBoxSortMtd.value="";
  	formName.ReqBoxPage.value="";
	formName.DAESUCH.value = "N";
	formName.target = '';	// 작성중 요구함 조회시 필요
    formName.action = "<%=request.getRequestURI()%>";
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

			//if(document.formName.CmtOrganID.value == "GI00004773"){
			//	alert("임기만료로 인하여 요구서를 보내실 수 없습니다 \n 향후 위원회의 위원이 구성되면 요구서를 보내실 수 있습니다.");
			//	return;
			//}
			if(getCheckCount(document.formName, "ReqBoxID") < 1) {
				alert("위원회 명의로 발송할 요구함을 하나 이상 선택해 주세요.");
				return;
			}
			<% if(objBean2.checkCmtOrganMakeAutoSche(strSelectedCmtOrganID) && objUserInfo.getIsMyCmtOrganID(strSelectedCmtOrganID)) { %>

			<%}else{
				if("GI00007001".equals(strSelectedCmtOrganID)|| "GI00007002".equals(strSelectedCmtOrganID)){

				}else{
			%>
				alert("소속 상임위원회가 아닌 경우에는 발송하실 수 없습니다.");
				return;
			<%
				}
			}
			%>
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

/*
	// 발송완료
	// 2005-07-18 선택된 요구함 일괄 삭제
	function doDelete() {
	  	if(getCheckCount(document.formName, "ReqBoxIDs") < 1) {
	  		alert("삭제하실 하나 이상의 요구함을 선택해 주세요.");
	  		return;
	  	}
	  	if(confirm("선택하신 요구함을 일괄 삭제하시겠습니까?\n\r\n\r1. 포함된 모든 요구 내용도 일괄 삭제됩니다.\n\r2. 답변이 진행 중인 요구함은 삭제되지 않습니다.")) {
	  		var w = 300;
	  		var h = 200;
			var winl = (screen.width - w) / 2;
			var winh = (screen.height - h) / 2;
			//document.all.loadingDiv.style.left = winl;
			//document.all.loadingDiv.style.top = winh;
			//document.all.loadingDiv.style.display = '';
			document.formName.action = "RSendBoxDelProc.jsp";
			document.formName.target = 'popwin';
			window.open('/blank.html', 'popwin', 'width='+w+', height='+h+', left='+winl+', top='+winh);
	  		document.formName.submit();
	  	}
	}
*/
	function changeDaesu(){
		formName.StartDateReq.value="";
		formName.EndDateReq.value="";
		formName.DAESUCH.value = "Y";
        formName.target = "";
        formName.action = "<%=request.getRequestURI()%>";
		formName.submit();
	}

	function doListRefresh() {
		var f = document.formName;
		f.target = "";
        f.action = "<%=request.getRequestURI()%>";
		f.submit();
	}

	// 요구기관 검색
	function findreq(){
		var http = "./ISearch_Reqlist.jsp";
		window.open(http,"ISearch_Reqlist","resizable=yes,menubar=no,status=yes,titlebar=yes,scrollbars=yes,location=no,toolbar=no,height=600,width=530" );
	}

	// 제출기관 검색
    function findans(){
		var http = "./ISearch_Anslist.jsp";
		window.open(http,"ISearch_Anslist","resizable=yes,menubar=no,status=yes,titlebar=yes,scrollbars=yes,location=no,toolbar=no,height=600,width=530" );
	}
	function getExcelData() {
		var f = document.formName;
		//f.target = "processingFrame";
        f.method = "post";
        f.ReqBoxPageSize.value="100000";
		f.action = "MyReqSubmitSearch_Excel.jsp";
		f.target = "_self";
		f.submit();
        f.ReqBoxPageSize.value="";
	}
</script>
<%//System.out.close();%>
<%
	// 2005-08-09 kogaeng ADD
	// 요구함 작성 메뉴 때문에 불가피하게 추가
	String strAddScript = "";
	String strAutoPopup = StringUtil.getEmptyIfNull(request.getParameter("AutoPopup"));
	if("Y".equalsIgnoreCase(strAutoPopup)) strAddScript = "AllInOne();";
%>
<body onload="<%= strAddScript %>">
<iframe name='processingFrame' height='0' width='0'></iframe>
<DIV ID="loadingDiv" style="display:none;position:absolute;">
	<img src="/image/reqsubmit/loading.jpg" border="0"> </td>
</DIV>
<div id="wrap">
<%
	System.out.println("TIMEMMMM4.4 : "+this.getCurrentTime());
%>
  <jsp:include page="/inc/top.jsp" flush="true"/>
  <jsp:include page="/inc/top_menu01.jsp" flush="true"/>
<%
	System.out.println("TIMEMMMM4.5 : "+this.getCurrentTime());
%>
  <div id="container">
    <div id="leftCon">
      <jsp:include page="/inc/log_info.jsp" flush="true"/>
      <jsp:include page="/inc/left_menu01.jsp" flush="true"/>
    </div>
    <div id="rightCon">
      <!-- pgTit -->
		<form name="formName" method="<%=nads.lib.reqsubmit.EnvConstants.FORM_METHOD%>" action="<%=request.getRequestURI()%>">
        <input type="hidden" name="ReqBoxPageSize" value=""/>
<%//정렬 정보 받기.
			String strReqBoxSortField=objParams.getParamValue("ReqBoxSortField");
			String strReqBoxSortMtd=objParams.getParamValue("ReqBoxSortMtd");
%>
		<input type="hidden" name="ReqBoxSortField" value="<%=strReqBoxSortField%>"><!--요구함목록정렬필드 -->
		<input type="hidden" name="ReqBoxSortMtd" value="<%=strReqBoxSortMtd%>"><!--요구함목록정령방법-->
		<input type="hidden" name="ReqBoxPage" value="<%=intCurrentPageNum%>"><!--페이지 번호 -->
		<!-- 2005-07-18 요구서 발송을 위한 기본 정보 시작(작성중)-->
		<input type="hidden" name="ReqDocType" value="<%= CodeConstants.REQ_DOC_TYPE_001 %>">
		<input type="hidden" name="ReqTp" value="<%= CodeConstants.REQ_DOC_FORM_001 %>">
		<input type="hidden" name="SmsUse" value="<%= CodeConstants.NTC_MTD_BOTH %>">
		<!--
		<input type="hidden" name="ReqOrganID" value="<%= objUserInfo.getOrganID() %>">
		-->
		<input type="hidden" name="SndrID" value="<%= objUserInfo.getUserID() %>">
		<!-- 2005-07-18 요구서 발송을 위한 기본 정보 끝(작성중)-->
		<input type="hidden" name="ReqBoxID" value=""><!--요구함번호 일반적으로는 사용안됨(발송완료,제출완료)-->
		<input type="hidden" name="DAESUCH" value="">
      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3>요구제출자료검색</h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> > 나의 페이지 > 나의 자료요구제출 > 요구제출자료검색</div>
        <p><!--문구--></p>
      </div>
      <!-- /pgTit -->

      <!-- contents -->

      <div id="contents">

        <!-- 검색조건 없는 경우 아래 div 삭제 나 주석으로 막으세요.-->
        <div class="schBox">
          <p>요구제출자료검색조건</p>
          <span class="line"><img src="/images2/foundation/search_line.gif" width="172" height="3" /></span>
          <div class="box03">

			<table width="100%" border="0" align="center" cellpadding="2" cellspacing="0" >
				<tr>
					<td height="40" colspan="6" align="center" valign="top" style="border-bottom: solid 1px  #cfdde2;">
						<strong><img src="/images2/common/bullet01.gif" width="3" height="3"  />&nbsp;통합검색</strong>&nbsp;<input type="text" name="SearchKeyword" value="<%=strSearchKeyword%>" size="50" style="height:20px;"><a href="javascript:gotoHeadQuery();"><img src="/images2/btn/bt_search2.gif" width="50" height="22"  /></a>
					</td>
				</tr>
				<tr><td height="5" colspan="6"></td></tr>
				<tr>
					<td width="15%" height="25" >
						<strong><img src="/images2/common/bullet01.gif" width="3" height="3" />&nbsp;국회구분</strong></td>
					<td width="35%">
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
					</td>
					<td width="15%">
						<strong><img src="/images2/common/bullet01.gif" width="3" height="3" />&nbsp;요청일</strong></td>
					<td width="35%" colspan="3">
						<!--
						<select onChange="javascript:doListRefresh()" name="AuditYear">
						  <option selected="selected" value="">전체</option>
						<%
							if(objYearRs != null && objYearRs.getTotalRecordCount() > 0){
								while(objYearRs.next()){
							%>
								<option value="<%=objYearRs.getObject("AUDIT_YEAR")%>" <%if(((String)objYearRs.getObject("AUDIT_YEAR")).equals(strSelectedAuditYear)){%>selected<%}%>><%=objYearRs.getObject("AUDIT_YEAR")%></option>
							<%
								}
							}
						%>
						</select>
						-->
   					    <input type="text" class="textfield" name="StartDateReq" size="10" maxlength="8" value="<%=strStrDayReq%>"  readonly" >
                        <a href="#" OnClick="javascript:show_calendar('formName.StartDateReq');"><img src="/images2/btn/bt_calender.gif" width="17" height="13" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"/></a> ~
					    <input type="text" class="textfield" name="EndDateReq" size="10" maxlength="8" value="<%=strEndDayReq%>" readonly">
					    <a href="#" OnClick="javascript:show_calendar('formName.EndDateReq');"><img src="/images2/btn/bt_calender.gif" width="17" height="13" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"/></a>
					</td>
				</tr>
				<tr>
					<td height="25">
						<strong><img src="/images2/common/bullet01.gif" width="3" height="3" />&nbsp;요구함 등록자</strong>
					</td>
					<td>
						<input type="text" size="20" name="REGR_NM" value="<%=REGR_NM %>">
					</td>
					<%if("001".equals(REQ_SUBMT_FLAG) && "I".equals(INOUT_GBN)){ // 요구자%>
					<td>
						<strong><img src="/images2/common/bullet01.gif" width="3" height="3" />&nbsp;제출기관</strong>
					</td>
					<td>
						<input type="text" size="20" name="ans_organ_select" value="<%=ans_organ_select %>"><a href="javascript:findans();"><img src="/images2/btn/bt_search2.gif" width="50" height="22"  /></a>
						<input type="hidden" name="ans_organ_select_id" value="<%=ans_organ_select_id%>">
					</td>
					<%}else{ // 제출자%>
					<td>
						<strong><img src="/images2/common/bullet01.gif" width="3" height="3" />&nbsp;요구기관</strong>
					</td>
					<td>
						<input type="text" size="20" name="req_organ_select" value="<%=req_organ_select %>"><a href="javascript:findreq();"><img src="/images2/btn/bt_search2.gif" width="50" height="22"  /></a>
						<input type="hidden" name="req_organ_select_id" value="<%=req_organ_select_id%>">
					</td>
					<%} %>
				</tr>
				<tr>
					<%if("001".equals(REQ_SUBMT_FLAG) && "I".equals(INOUT_GBN)){ //요구자 %>
					<td height="25">
						<strong><img src="/images2/common/bullet01.gif" width="3" height="3"  />&nbsp;진행상태</strong>
					</td>
					<td>
						<select onChange="this.form.submit()" name="ReqBoxStt2">
							<option value="" <%if(strReqBoxStt2.equals("")){%>selected<%}%>>전체</option>
							<%if("003".equals(ORGAN_KIND)){ //의원실 %>
							<option value="003" <%if(strReqBoxStt2.equals("003")){%>selected<%}%>>작성중</option>
							<%}else{ //위원회 %>
							<option value="002" <%if(strReqBoxStt2.equals("002")){%>selected<%}%>>접수완료</option>
							<%} %>
							<option value="006" <%if(strReqBoxStt2.equals("006")){%>selected<%}%>>발송완료</option>
							<option value="007" <%if(strReqBoxStt2.equals("007")){%>selected<%}%>>제출완료</option>
						</select>
					</td>
					<%}else{ //제출자 %>
					<td >
						<strong><img src="/images2/common/bullet01.gif" width="3" height="3" />&nbsp;진행상태</strong>
					</td>
					<td>
						<select onChange="this.form.submit()" name="ReqBoxStt2">
							<option value="" <%if(strReqBoxStt2.equals("")){%>selected<%}%>>전체</option>
							<option value="006" <%if(strReqBoxStt2.equals("006")){%>selected<%}%>>작성중</option>
							<option value="007" <%if(strReqBoxStt2.equals("007")){%>selected<%}%>>작성완료</option>
						</select>
					</td>
					<%} %>
					<td>
						<strong><img src="/images2/common/bullet01.gif" width="3" height="3" />&nbsp;소속위원회</strong>
					</td>
					<td>
						<select onChange="javascript:doListRefresh()" name="CmtOrganID">
							<option selected="selected" value="">:::: 전체위원회 :::</option>
						<%
							if(objCmtRs != null && objCmtRs.getTotalRecordCount() > 0){
								while(objCmtRs.next()){
							%>
								<option value="<%=objCmtRs.getObject("ORGAN_ID")%>" <%if(((String)objCmtRs.getObject("ORGAN_ID")).equals(strSelectedCmtOrganID)){%>selected<%}%>><%=objCmtRs.getObject("ORGAN_NM")%></option>
							<%
								}
							}
						%>
						</select>
					</td>
				</tr>
				<tr>
					<td height="25">
						<strong><img src="/images2/common/bullet01.gif" width="3" height="3" />&nbsp;업무구분</strong>
					</td>
					<td>
						<select onChange="this.form.submit()" name="RltdDuty">
							<option selected="selected" value="">업무구분(전체)</option>
							<%
							   /**업무구분 리스트 출력 */
							   while(objRltdDutyRs!=null && objRltdDutyRs.next()){
									String strCode=(String)objRltdDutyRs.getObject("MSORT_CD");
									out.println("<option value=\"" + strCode + "\" " + StringUtil.getSelectedStr(strRltdDuty,strCode) + ">" + objRltdDutyRs.getObject("CD_NM") + "</option>");
							   }
							%>
						</select>
					</td>
					<td>
						<strong><img src="/images2/common/bullet01.gif" width="3" height="3"  />&nbsp;문서유형</strong>
					</td>
					<td colspan="3">
						<select onChange="this.form.submit()" name="BoxTp">
							<option value="" <%if(strBoxTp.equals("")){%>selected<%}%>>전자/비전자</option>
							<option value="001" <%if(strBoxTp.equals("001")){%>selected<%}%>>전자</option>
							<option value="005" <%if(strBoxTp.equals("005")){%>selected<%}%>>비전자</option>
						</select>
					</td>
				</tr>
			</table>

            </div>
			&nbsp;<br>
			<font color="blue">자료요구기관에서<br>
			본인이 등록한 자료만 검색할 경우에는 '요구함등록자'  항목에 본인 성명을 입력한 후 조회하시면 됩니다.</font>
			
        </div>
        <!-- /검색조건-->

        <!-- 각페이지 내용 -->

        <!-- list -->


        <span><img src="../image/button/bt_excelDownload.gif" height="20"  style="cursor:hand" OnClick="javascript:getExcelData();"><span class="list_total">&bull;&nbsp;전체자료수 : <%=intTotalRecordCount%>개 (<%=intCurrentPageNum%>/<%=intTotalPage%> page)</span></span>


        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">

          <thead>
            <tr>
              <th scope="col" style="width:15px;"><a>No</a></th>
              <th scope="col" style="width:230px; "><%=SortingUtil.getSortLink("changeSortQuery","REQ_BOX_NM",strReqBoxSortField,strReqBoxSortMtd,"요구함명")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","SUBMT_ORGAN_NM",strReqBoxSortField,strReqBoxSortMtd,"제출기관")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","RLTD_DUTY",strReqBoxSortField,strReqBoxSortMtd,"업무구분")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","REQ_BOX_STT",strReqBoxSortField,strReqBoxSortMtd,"진행상태")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","",strReqBoxSortField,strReqBoxSortMtd,"개수")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","REG_DT",strReqBoxSortField,strReqBoxSortMtd,"등록일시")%></th>
			  <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","LAST_ANS_DOC_SND_DT",strReqBoxSortField,strReqBoxSortMtd,"답변일시")%></th>
            </tr>
          </thead>

          <tbody>
			<%
			  int intRecordNumber=intTotalRecordCount - ((intCurrentPageNum -1) * Integer.parseInt((String)objParams.getParamValue("ReqBoxPageSize")));
			  //int intRecordNumber=intTotalRecordCount;
			  if(objRs.getRecordSize()>0){
				String strReqBoxID="";
				String strReqBoxSttParam="";
				int intMakeGrdID = 0;
				while(objRs.next()){
					 strReqBoxID=(String)objRs.getObject("REQ_BOX_ID");
					 strReqBoxSttParam=(String)objRs.getObject("REQ_BOX_STT");
					 intMakeGrdID = Integer.parseInt(StringUtil.getEmptyIfNull((String)objRs.getObject("MAKE_GRD_ID"), "0"));
					 String strBgColor = "";
					 if((intMakeGrdID % 2) == 0) strBgColor = "#f4f4f4";
			 %>
            <tr>
              <td><%= intRecordNumber %></td>
              <td width="260px"><a href="javascript:gotoDetail('<%=strReqBoxID%>/<%=strReqBoxSttParam %>')"><%=(String)objRs.getObject("REQ_BOX_NM")%></a></td>
              <td><%=(String)objRs.getObject("SUBMT_ORGAN_NM")%></td>
              <td><%=objCdinfo.getRelatedDuty((String)objRs.getObject("RLTD_DUTY"))%></td>
              <td>
			  <%if("001".equals(REQ_SUBMT_FLAG) && "I".equals(INOUT_GBN)){ // 요구자 %>
			  <%=CodeConstants.getReqBoxStatus((String)objRs.getObject("REQ_BOX_STT"),true)%>
			  <%}else{ // 제출자 %>
        	  <%=CodeConstants.getReqBoxStatus((String)objRs.getObject("REQ_BOX_STT"),false)%>
			  <%} %>
			  </td>
              <td><%=objRs.getObject("SUBMT_CNT")%>/<%=objRs.getObject("REQ_CNT")%></td>
              <td><%= StringUtil.getDate2((String)objRs.getObject("REG_DT"))%></td>
			  <td><%= StringUtil.getDate2((String)objRs.getObject("LAST_ANS_DOC_SND_DT"))%></td>
            </tr>
			<%
						intRecordNumber --;
					}//endwhile
				}else{
			%>
			<tr>
              <td colspan="7">등록된 <%=MenuConstants.REQ_BOX_MAKE%>이 없습니다.</td>
            </tr>
			<%
			}//end if 목록 출력 끝.
			%>
          </tbody>

        </table>

        <!-- /list -->


        <!-- 페이징-->
		<table  align="center">
              <tr>
                <td height="35" align="center">
                	<!-----------------------------------------  페이징 네비게이션 ---------------------------------------->
                	<%//= PageCount.getLinkedString(
						//	new Integer(intTotalRecordCount).toString(),
						//	new Integer(intCurrentPageNum).toString(),
						//	objParams.getParamValue("ReqBoxPageSize"))
//							"1")
					%>
					<!-----------------------------------------  페이징 네비게이션 ---------------------------------------->
					<%=objPaging.pagingTrans(PageCount.getLinkedString(
							new Integer(intTotalRecordCount).toString(),
							new Integer(intCurrentPageNum).toString(),
							objParams.getParamValue("ReqBoxPageSize"))
							) %>
                </td>
              </tr>
		</table>
        <!-- /페이징-->


        <!-- 리스트 버튼-->
        <!--div id="btn_all" >
        <div class="list_ser" >
			<%
				String strReqBoxQryField=objParams.getParamValue("ReqBoxQryField");
			%>
          <select name="ReqBoxQryField" class="selectBox5"  style="width:70px;" >
            <option <%=(strReqBoxQryField.equalsIgnoreCase("req_box_nm"))? " selected ": ""%>value="req_box_nm">요구함명</option>
			<option <%=(strReqBoxQryField.equalsIgnoreCase("req_box_dsc"))? " selected ": ""%>value="req_box_dsc">요구함설명</option>
			<option <%=(strReqBoxQryField.equalsIgnoreCase("submt_organ_nm"))? " selected ": ""%>value="submt_organ_nm">제출기관</option>
          </select>
          <input name="ReqBoxQryTerm" onKeyDown="return ch()" onMouseDown="return ch()"
		 class="li_input"  style="width:100px" value="<%=objParams.getParamValue("ReqBoxQryTerm")%>"/>
          <img src="/images2/btn/bt_list_search.gif"  onMouseOver="menuOn(this);" onMouseOut="menuOut(this);" onClick="formName.submit();"/> </div>
			<span class="right">
			<span class="list_bt"><a href="javascript:AllInOne();"">요구함작성</a></span>
			<span class="list_bt"><a href="javascript:doDelete()">요구함삭제</a></span>
			<%
				if(!objUserInfo.getIsMyCmtOrganID("GI00004757")) {
			%>
					<%if(strCmtGubun.equals("004")){%>
					<%}else{%>
					<span class="list_bt"><a href="javascript:sendReqDoc()">의원실 명의 요구서 발송</a></span>
					<%}%>
			<%
				} else {
					if(!"".equalsIgnoreCase(strSelectedCmtOrganID) && !"GI00004757".equalsIgnoreCase(strSelectedCmtOrganID)) {
			%>

					<%if(strCmtGubun.equals("004")){%>
					<%}else{%>
					<span class="list_bt"><a href="javascript:sendCmtReqDoc()">위원회명의 요구서발송</a></span>
					<%}%>
		<%
				}
			}
		%>
			<span class="list_bt">
			<a href="javascript:sendCmtReqDoc()">위원회 명의 요구서 발송</a></span>
			</span>
		</div>
      </div-->
      <!-- /contents -->

    </div>
</form>
  </div>
  <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>
<%
	System.out.println("TIMEMMMM5 : "+this.getCurrentTime());
%>
<%!
	public String getCurrentTime() {
        Calendar oCalendar = Calendar.getInstance();
		String serverDate = oCalendar.get(Calendar.YEAR) + "/" +(oCalendar.get(Calendar.MONTH) + 1)+"/"+ oCalendar.get(Calendar.DAY_OF_MONTH)+"  "+oCalendar.get(Calendar.HOUR_OF_DAY)+":"+oCalendar.get(Calendar.MINUTE)+":"+oCalendar.get(Calendar.SECOND)+":"+oCalendar.get(Calendar.MILLISECOND);
		 return serverDate;
     }

%>