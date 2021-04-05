<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.pf.util.PageCount"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RCommReqBoxListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.CommRequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.cmtmanager.CmtManagerConfirmDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.RequestBoxDelegate" %>
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
    /*************************************************************************************************/
    /**     name : RCommReqBoxList.jsp                                                                  */
    /**            위원회 요구함 목록을 출력한다.                                                      */
    /**            요구일정이 있는 소속 위원회의 목록을 출력한다.                                          */
    /*************************************************************************************************/
    //로그인 사용자 정보를 가져온다. 권한없음 경우 관람만 가능하다.
    String strReqSubmitFlag = objUserInfo.getReqSubmitFlag();
    /**선택된 감사년도와 선택된 위원회ID*/
    String strSelectedAuditYear= null; /**선택된 감사년도*/
    String strSelectedCmtOrganID=null; /**선택된 위원회ID*/
    String strReqScheID="";             /**위원회 요구일정ID*/
    String strRltdDuty=null;              /**선택된 업무구분 */
    String strUserId = objUserInfo.getUserID();
    String strDaeSuCh = null;
    String strDaesuInfo = StringUtil.getEmptyIfNull(request.getParameter("DaeSu"));
    strDaeSuCh = StringUtil.getEmptyIfNull(request.getParameter("DAESUCH"));
    String strDaesu = null;
    String strStartdate = null;
    String strEnddate = null;
    int FLAG = -1;

    /**위원회목록조회용 파라미터 설정.*/
    RCommReqBoxListForm objParams=new RCommReqBoxListForm();
    //요구기관 설정 :: 소속 기관.
    objParams.setParamValue("ReqOrganID",objUserInfo.getOrganID());
    //위원회 요구일정진행상태 : 접수완료
    objParams.setParamValue("IngStt",CodeConstants.REQ_ING_STT_002);
    //요구함 상태 : 접수완료
    objParams.setParamValue("ReqBoxStt",CodeConstants.REQ_BOX_STT_002);
    /** 위원회 행정직원 일때만 화면에 출력함.*/
    if(objUserInfo.getOrganGBNCode().equals("004") && (objParams.getParamValue("CmtOrganID")).equals("")){
        objParams.setParamValue("CmtOrganID",objUserInfo.getOrganID());
    }
    //해당위원회가 없을경우.. 에러메세지 출력..
    if(objUserInfo.getCurrentCMTList().isEmpty()){
        objParams.setParamValue("CmtOrganID","XXXXXXXXXX");
    }
    String strReqOrganID = "";
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
    }
    strSelectedAuditYear= objParams.getParamValue("AuditYear");     /**선택된 감사년도*/
    strSelectedCmtOrganID=objParams.getParamValue("CmtOrganID");    /**선택된 위원회ID*/
    strRltdDuty=objParams.getParamValue("RltdDuty") ;
    //요구함 객체 ※Delegate 선언※.
    CommRequestBoxDelegate objReqBox = null;
    ResultSetHelper objCmtRs=null;            /** 연도별 위원회 */
    ResultSetHelper objDaeRs=null;
    ResultSetHelper objRs=null;            /** 위원회 요구함 목록 */
    ResultSetHelper objRltdDutyRs=null;   /** 업무구분 리스트 출력용 RsHelper */
    ResultSetHelper objYearRs=null;
    CmtManagerConfirmDelegate cmtmanagerCn = new CmtManagerConfirmDelegate();
    RequestBoxDelegate objReqBoxDelegate = null;
    ResultSetHelper objReqOrganRS = null;                /** 위원회별 의원실 목록 */
    String strCmtOpenCl = "";
    ArrayList listdata2 = null;
    Hashtable obOrganNm = null;

    try{

        strReqOrganID = StringUtil.getEmptyIfNull(objParams.getParamValue("ReqOrganIDZ"));

        if(objUserInfo.getOrganGBNCode().equals("004") && !strReqSubmitFlag.equals("004")){


        }else{

            String strSelfOrganID = (String)objUserInfo.getOrganID();
            if((strSelectedCmtOrganID.equals("") && strReqOrganID.equals("00")) || strSelectedCmtOrganID.equals("") && strReqOrganID.equals("")){
                objParams.setParamValue("ReqOrganIDZ",strSelfOrganID);

            }else if(!strSelectedCmtOrganID.equals("") && strReqOrganID.equals("00")){

                //objParams.setParamValue("ReqOrganIDZ",strSelfOrganID);
            }


        }

         objReqBox=new CommRequestBoxDelegate();
        objReqBoxDelegate = new RequestBoxDelegate();
        obOrganNm = (Hashtable)objReqBoxDelegate.getEndDate(objUserInfo.getOrganID());
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

        Hashtable objhashdata = null;

        List lst = null;
        if(objUserInfo.getOrganGBNCode().equals("004")){

            lst = objUserInfo.getCurrentCMTList();
            for(int i = 0 ; i < lst.size();i++){
                objhashdata = new Hashtable();
                objhashdata = (Hashtable)lst.get(i);
                List lst2 = (List)objReqBox.getDaeCMTList((String)objhashdata.get("ORGAN_ID"));
                Hashtable objhashdata2 = null;
                if(lst2.size() > 0){
                    for(int j = 0; j < lst2.size(); j++){
                        objhashdata2 = new Hashtable();
                        Hashtable temp = (Hashtable)lst2.get(j);
                        if(((String)temp.get("ORGAN_ID")) != null){
                            objhashdata2.put("ORGAN_ID",(String)temp.get("ORGAN_ID"));
                            objhashdata2.put("ORGAN_NM",(String)temp.get("ORGAN_NM"));
                            lst.add(objhashdata2);
                        }
                    }
                }
            }
            objCmtRs=new ResultSetHelper(lst);

            objYearRs = new ResultSetHelper(objReqBox.getDaeCmtYearList(lst,CodeConstants.REQ_BOX_STT_002,strStartdate,strEnddate));

        }else{

            lst = objReqBox.getDaeCMTListNew(CodeConstants.REQ_BOX_STT_002,strStartdate,strEnddate,strSelectedAuditYear,(String)objUserInfo.getOrganID());
            if(lst.size() == 0){
                lst = objUserInfo.getCurrentCMTList();
            }
            objCmtRs = new ResultSetHelper(lst);

            objYearRs = new ResultSetHelper(objReqBox.getDaeYearList(CodeConstants.REQ_BOX_STT_002,strStartdate,strEnddate,(String)objUserInfo.getOrganID()));
        }
        Hashtable objhashdata2 = new Hashtable();
        objhashdata2.put("START_DATE",strStartdate);
        objhashdata2.put("END_DATE",strEnddate);

        objhashdata2.put("CMTORGANIDZ",lst);


        objParams.setParamValue("AuditYear",strSelectedAuditYear);

           objRltdDutyRs=new ResultSetHelper(objCdinfo.getRelatedDutyList());
           //요구함 목록
        objRs=new ResultSetHelper(objReqBox.getRecordDaeList(objParams,objhashdata2));
           //위원회일정ID
           strReqScheID = objReqBox.getReqScheID(strSelectedAuditYear, strSelectedCmtOrganID, CodeConstants.REQ_ING_STT_002, CodeConstants.REQ_BOX_STT_002);
        FLAG = cmtmanagerCn.getFLAG((String)objParams.getParamValue("CmtOrganID"));
        //위원회요구자료공개비공개여부2006-09-20
        strCmtOpenCl = cmtmanagerCn.getOpenCl((String)objParams.getParamValue("CmtOrganID")) == null ? "" : cmtmanagerCn.getOpenCl((String)objParams.getParamValue("CmtOrganID"));
        objReqOrganRS = new ResultSetHelper(objReqBox.getCmtReqOrganList2(objParams,objhashdata2));
    } catch(AppException objAppEx) {
         objMsgBean.setMsgType(MessageBean.TYPE_ERR);
          objMsgBean.setStrCode(objAppEx.getStrErrCode());
          objMsgBean.setStrMsg(objAppEx.getMessage());
%>
        <jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
        return;
    }
    String strRsCmt = "";
    if(objCmtRs.next()){
        strRsCmt = (String)objCmtRs.getObject("ORGAN_ID")==null?"":(String)objCmtRs.getObject("ORGAN_ID");
    }
    objCmtRs.first();
    //요구함 목록조회된 결과 반환.
    int intTotalRecordCount=objRs.getTotalRecordCount();
    int intCurrentPageNum=objRs.getPageNumber();
    int intTotalPage=objRs.getTotalPageCount();
%>
<jsp:include page="/inc/header.jsp" flush="true"/>
<link href="/css2/style.css" rel="stylesheet" type="text/css">

<!-- 2018-09-20 hgyoo 화면 로딩창 수정 -->
<style>
	/* The Modal (background) */
	.modal {
	    display: none; /* Hidden by default */
	    position: fixed; /* Stay in place */
	    z-index: 1; /* Sit on top */
	    left: 0;
	    top: 0;
	    width: 100%; /* Full width */
	    height: 100%; /* Full height */
	    /*overflow: auto;*/ /* Enable scroll if needed */
	    /* background-color: rgb(0,0,0); */ /* Fallback color */
	    /* background-color: rgba(0,0,0,0.4); */ /* Black w/ opacity */
	}
	
	/* Modal Content/Box */
	.modal-content {
	    background-color: #fefefe;
	    margin: 18% auto; /* 15% from the top and centered */
	    padding: 20px;
	    border: 1px solid #888;
	    width: 25%; /* Could be more or less, depending on screen size */                          
	}
</style>
<!-- 2018-09-20 hgyoo 화면 로딩창 수정 -->
<script language="javascript" src="/js/reqsubmit/common.js"></script>
<script language="javascript">

  /** 정렬방법 바꾸기 */
  function changeSortQuery(sortField,sortMethod){
      listqry.CommReqBoxSortField.value=sortField;
      listqry.CommReqBoxSortMtd.value=sortMethod;
    listqry.DAESUCH.value = "N";
      listqry.target = "";
      listqry.submit();
  }
  //요구함상세보기로 가기.
  function gotoDetail(strID){
      listqry.action="./RAccBoxVList.jsp?ReqBoxID="+strID;
      listqry.target = "";
      listqry.submit();
  }
  /** 페이징 바로가기 */
  function goPage(strPage){
      listqry.CommReqBoxPage.value=strPage;
    listqry.DAESUCH.value = "N";
      listqry.target = "";
      listqry.submit();
  }
  /** 요구함 생성 바로가기 */
  function gotoMake(strReqScheID,strIngStt){
    form=document.listqry;
    if(<%= strRsCmt.equals("")%>){
        alert("위원회 요구 일정이 없습니다.");
    } else {
          form.ReqScheID.value=strReqScheID;
          form.action="/reqsubmit/20_comm/20_reqboxsh/RCommNewBoxMake.jsp?IngStt="+strIngStt;
          listqry.target = "";
          form.submit();
      }
  }
  /**년도와 위원회로만 조회하기 */
  function gotoHeadQuery(){
      listqry.CommReqBoxQryField.value="";
      listqry.CommReqBoxQryTerm.value="";
      listqry.CommReqBoxSortField.value="";
      listqry.CommReqBoxSortMtd.value="";
      listqry.CommReqBoxPage.value="";
    listqry.DAESUCH.value = "N";
      listqry.target = "";
      listqry.submit();
  }
  var IsClick=false;
    // 2005-10-04 통합 요구함 등록 화면
    function openReqBoxPopup(){
        if(!IsClick){
            var f = document.listqry;
            var url = "/reqsubmit/common/ReqInfoWriteAllInOne.jsp?ReqBoxTp=002";
            f.action = url;
            f.target = "POPUP";
            NewWindow('/blank.html', 'POPUP', 800, 800);
            f.submit();
        }else{
            alert("프로세스가 작동중입니다. 잠시 기다려주십시오.");
            return false;
        }
    }
    var strPopup;
    var strGubun = -1;
    
  //2018-09-20 hgyoo 화면 로딩창 수정
    function ButtonProcessing()
    {
       /*  try{
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
        catch(e) {} */
        
        var modal_base = document.getElementById("modal_base");    
	  	var processingDiv = document.getElementById("processingDiv");
	  	
	  	//width:220;height:180;display:none;position:absolute;left:450;top:500
	  	
	  	modal_base.style.display = "block";             
	  	
	  	
    }
       
  //2018-09-19 hgyoo
    function notProcessing(){
        /* if(strPopup.isOpen){
            strPopup.hide();
            strGubun = 1;
        } */
        var modal_base = document.getElementById("modal_base");
        
        modal_base.style.display  = "none";
        
    }
    // 2005-07-13 요구서 일괄 발송
    //2018-09-19 hgyoo 요구서 일괄 발송 
    function sendReqDoc() {
        if(!IsClick){
            if(getCheckCount(document.listqry, "ReqBoxID") < 1) {
                alert("발송하실 하나 이상의 요구함을 선택해 주세요.");
                return;
            }
        }else{
            alert("프로세스가 작동중입니다. 잠시 기다려주십시오.");
            return false;
        }

          if(confirm("선택하신 요구함을 해당 제출기관으로 일괄 발송하시겠습니까?\n\r\n\r***** 확인바랍니다 *****\n\r해당기관의 대표 담당자가 없는 경우는 발송되지 않습니다.")) {
            IsClick = true;  //버튼 처리를 수행중..
            
            //ButtonProcessing();  //처리상태를 표시하는 메소드 호출
			var innHtml = '<div id="loading_layer"><b>처리중입니다. 잠시만 기다려주세요...</b><br><img src="/image/reqsubmit/processing.gif" ></div>'
			$('body').prepend(innHtml);
            
            document.listqry.action = "/reqsubmit/common/ReqDocSendProcMultiTest.jsp?ReqOrganID=<%= objUserInfo.getOrganID() %>";
            document.listqry.target = 'processingFrame';
                      
            document.listqry.submit();
          }
    }
    // 2005-10-06 kogaeng ADD
    //2018-09-20 hgyoo 화면 로딩창 수정
    function doDelete() {
        if(!IsClick){
            if(getCheckCount(document.listqry, "ReqBoxID") < 1) {
                alert("삭제하실 하나 이상의 요구함을 선택해 주시기 바랍니다.");
                return;
            }
        }else{
            alert("프로세스가 작동중입니다. 잠시 기다려주십시오.");
            return false;
        }
        if(confirm("요구함을 삭제하시면 포함된 요구 내용들도 일괄 삭제됩니다.\n\r\n\r선택하신 요구함을 일괄 삭제하시겠습니까?")) {
            IsClick = true;  //버튼 처리를 수행중..
            //ButtonProcessing();  //처리상태를 표시하는 메소드 호출
			var innHtml = '<div id="loading_layer"><b>처리중입니다. 잠시만 기다려주세요...</b><br><img src="/image/reqsubmit/processing.gif" ></div>'
			$('body').prepend(innHtml);

            //var winl = (screen.width - 300) / 2;
            //var winh = (screen.height - 240) / 2;
            document.listqry.target = "processingFrame";
            document.listqry.action = "/reqsubmit/20_comm/20_reqboxsh/RCommReqBoxDelProc.jsp";
            //window.open('/blank.html', 'popwin', 'width=300, height=240, left='+winl+', top='+winh);
            document.listqry.submit();
        }
    }
    // 조회 옵션에 따른 Form submit 만 수행
    function doListRefresh() {
        var f = document.listqry;
        f.DAESUCH.value = "N";
        f.target = "";
        f.submit();
    }
    function changeDaesu(){
        listqry.DAESUCH.value = "Y";
        listqry.submit();
    }
</script>
</head>

<body>
<iframe name='processingFrame' height='0' width='0'></iframe>
<div id="modal_base" class="modal">
	<DIV id="processingDiv" class="modal-content" >
		<img src="/image/reqsubmit/processing.gif" border="0">
	</DIV>
</div>

<DIV ID="loadingDiv" style="display:none;position:absolute;">
    <img src="/image/reqsubmit/loading.jpg" border="0">
</DIV>
<div id="wrap">
  <jsp:include page="/inc/top.jsp" flush="true"/>
  <jsp:include page="/inc/top_menu02.jsp" flush="true"/>
  <div id="container">
    <div id="leftCon">
      <jsp:include page="/inc/log_info.jsp" flush="true"/>
      <jsp:include page="/inc/left_menu02.jsp" flush="true"/>
    </div>
    <div id="rightCon">
<form name="listqry" method="post" action="<%=request.getRequestURI()%>">
        <%//정렬 정보 받기.
            String strCommReqBoxSortField=objParams.getParamValue("CommReqBoxSortField");
            String strCommReqBoxSortMtd=objParams.getParamValue("CommReqBoxSortMtd");
        %>
        <input type="hidden" name="CommReqBoxSortField" value="<%=strCommReqBoxSortField%>"><!--요구함목록정렬필드 -->
        <input type="hidden" name="CommReqBoxSortMtd" value="<%=strCommReqBoxSortMtd%>">    <!--요구함목록정령방법-->
        <input type="hidden" name="CommReqBoxPage" value="<%=intCurrentPageNum%>">            <!--페이지 번호 -->
        <input type="hidden" name="ReqScheID" value="<%= strReqScheID %>">        <!--위원회 일정ID -->
        <!-- 2005-07-18 요구서 발송을 위한 기본 정보 -->
        <input type="hidden" name="ReqDocType" value="<%= CodeConstants.REQ_DOC_TYPE_002 %>">
        <input type="hidden" name="ReqTp" value="<%= CodeConstants.REQ_DOC_FORM_010 %>">
        <input type="hidden" name="SmsUse" value="<%= CodeConstants.NTC_MTD_BOTH %>">
        <input type="hidden" name="SndrID" value="<%= objUserInfo.getUserID() %>">
        <input type="hidden" name="DelURL" value="<%= request.getRequestURI() %>">
        <input type="hidden" name="ReqOrganID" value="<%= objUserInfo.getOrganID() %>">
        <input type="hidden" name="OpenCl" value="<%=strCmtOpenCl%>">
        <input type="hidden" name="DAESUCH" value="">

      <!-- pgTit -->

      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%= (FLAG > 1)?MenuConstants.COMM_MNG_CHECK:MenuConstants.COMM_REQ_BOX_MAKE_END %> <span class="sub_stl" >- 요구함 목록</span></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" />                     <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.REQUEST_BOX_COMM%> > <%= (FLAG > 1)?MenuConstants.COMM_MNG_CHECK:MenuConstants.COMM_REQ_BOX_MAKE_END %></div>
        <p><!--문구--></p>
      </div>
      <!-- /pgTit -->

      <!-- contents -->

      <div id="contents">

        <!-- 검색조건 없는 경우 아래 div 삭제 나 주석으로 막으세요.-->
        <div class="schBox">
          <p>요구함조회조건</p>
          <span class="line"><img src="/images2/foundation/search_line.gif" width="172" height="3" /></span>
          <div class="box">
            <!-- 기존의 검색 셀렉트와 버튼만 넣으세요-->
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
            <select onChange="javascript:doListRefresh()" name="AuditYear">
             <option value="">전체</option>
        <%
            if(objYearRs != null && objYearRs.getTotalRecordCount() > 0){
                while(objYearRs.next()){
            %>
                <option value="<%=objYearRs.getObject("AUDIT_YEAR")%>" <%if(((String)objYearRs.getObject("AUDIT_YEAR")).equals(strSelectedAuditYear)){%>selected<%}%>><%=objYearRs.getObject("AUDIT_YEAR")%>
            </option>
            <%
                }
            }
        %>
            </select>
            <select onChange="javascript:doListRefresh()" name="CmtOrganID">
              <option value="">:::: 전체위원회 :::</option>
        <%
            if(objCmtRs != null && objCmtRs.getTotalRecordCount() > 0){
                while(objCmtRs.next()){
            %>
                <option value="<%=objCmtRs.getObject("ORGAN_ID")%>" <%if(((String)objCmtRs.getObject("ORGAN_ID")).equals(strSelectedCmtOrganID)){%>selected<%}%>><%=objCmtRs.getObject("ORGAN_NM")%>
        </option>
            <%
                }
            }
        %>
            </select>
            <select onChange="javascript:doListRefresh()" name="ReqOrganIDZ">
              <%
            if((strSelectedCmtOrganID.equals("") && strReqOrganID.equals("00")) || strSelectedCmtOrganID.equals("") && strReqOrganID.equals("")){

        %>
            <option value="00"><%=obOrganNm.get("ORGAN_NM")%></option>
        <%}else{%>
            <option value="00">:::: 의원실별 조회 ::::</option>
            <%
                if(StringUtil.isAssigned(strSelectedCmtOrganID)) {
                    String strSelected = "";
                    if(strSelectedCmtOrganID.equalsIgnoreCase(strReqOrganID)) strSelected = " selected";
                    else strSelected = "";
            %>
                    <option value="<%= strSelectedCmtOrganID %>" <%= strSelected %>>:::: 위원회 자체 생성 ::::</option>
            <%
                    if(objReqOrganRS.getTotalRecordCount() > 0) {
                        while(objReqOrganRS.next()) {
                            if(strReqOrganID.equalsIgnoreCase((String)objReqOrganRS.getObject("ORGAN_ID"))) {
                                strSelected = " selected";
                            } else {
                                strSelected = "";
                            }
                            out.println("<option value='"+(String)objReqOrganRS.getObject("ORGAN_ID")+"' "+strSelected+">"+(String)objReqOrganRS.getObject("ORGAN_NM")+"</option>");
                        }
                    }
                } else {
                    out.println("<option value=''>:::: 위원회를 먼저 선택해 주세요 ::::</option>");
                }
            %>

        <%}%>
            </select>
            <select onChange="javascript:doListRefresh()" name="RltdDuty">
               <option value="">업무구분(전체)</option>
            <%
               /**업무구분 리스트 출력 */
               while(objRltdDutyRs!=null && objRltdDutyRs.next()){
                    String strCode=(String)objRltdDutyRs.getObject("MSORT_CD");
                    out.println("<option value=\"" + strCode + "\" " + StringUtil.getSelectedStr(strRltdDuty,strCode) + ">" + objRltdDutyRs.getObject("CD_NM") + "</option>");
               }
            %>
            </select>
            <a href="javascript:gotoHeadQuery();"><img src="/images2/btn/bt_search2.gif" width="50" height="22" /></a> </div>
        </div>
        <!-- /검색조건-->

        <!-- 각페이지 내용 -->

        <!-- list -->

        <span class="list_total">&bull;&nbsp;전체자료수 : <%=intTotalRecordCount%>개 (<%=intCurrentPageNum%> / <%=intTotalPage%> page)</span>


        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
          <thead>
            <tr>
              <th scope="col" style="width:15px;">
                <input name="checkAll" type="checkbox" value="" class="borderNo" onClick="javascript:checkAllOrNot(document.listqry)"/>
             </th>
              <th scope="col" style="width:250px;"><%=SortingUtil.getSortLink("changeSortQuery","REQ_BOX_NM",strCommReqBoxSortField,strCommReqBoxSortMtd,"요구함명")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","SUBMT_ORGAN_NM",strCommReqBoxSortField,strCommReqBoxSortMtd,"제출기관")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","RLTD_DUTY",strCommReqBoxSortField,strCommReqBoxSortMtd,"업무구분")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","",strCommReqBoxSortField,strCommReqBoxSortMtd,"요구")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","SUBMT_DLN",strCommReqBoxSortField,strCommReqBoxSortMtd,"제출기한")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","REG_DT",strCommReqBoxSortField,strCommReqBoxSortMtd,"등록일시")%></th>
            </tr>
          </thead>
          <tbody>
    <%
        String strRecordNumber = request.getParameter("RecordNumber");
        int intRecordNumber=0;
        if(intCurrentPageNum == 1){
            intRecordNumber= intTotalRecordCount;
        } else {
            intRecordNumber= intTotalRecordCount - ((intCurrentPageNum - 1) * 15);
        }
        if(objRs.getRecordSize()>0){
            String strReqBoxID="";
            String strCommOrganID="";

            while(objRs.next()){
                strReqBoxID=(String)objRs.getObject("REQ_BOX_ID");
                strCommOrganID=(String)objRs.getObject("CMT_ORGAN_ID");
     %>
            <tr>
              <td><input name="ReqBoxID" type="checkbox" class="borderNo" value="<%=strReqBoxID%>"&nbsp;<%= intRecordNumber %> /></td>
              <td><a href="javascript:gotoDetail('<%=strReqBoxID%>')"><%=(String)objRs.getObject("REQ_BOX_NM")%></a></td>
              <td><%=(String)objRs.getObject("SUBMT_ORGAN_NM")%></td>
              <td><%=objCdinfo.getRelatedDuty((String)objRs.getObject("RLTD_DUTY"))%></td>
              <td><%=objRs.getObject("REQ_CNT")%></td>
              <td><%= StringUtil.getDate((String)objRs.getObject("SUBMT_DLN")) %> 24:00</td>
              <td><%= StringUtil.getDate2((String)objRs.getObject("REG_DT")) %></td>
            </tr>
            <%
                    intRecordNumber--;
                }//endofwhile
            %>
            <input type="hidden" name="RecordNumber" value="<%=intRecordNumber%>">
        <%
            }else{
        %>
            <tr>
                <td colspan="7" align="center">등록된 요구함이 없습니다.</td>
            </tr>
        <%}%>
          </tbody>
        </table>

        <!-- /list -->
        <%=objPaging.pagingTrans(PageCount.getLinkedString(
                    new Integer(intTotalRecordCount).toString(),
                    new Integer(intCurrentPageNum).toString(),
                    objParams.getParamValue("CommReqBoxPageSize")))%>
        <!-- 페이징-->
         <!-- /페이징-->
        <!--  <p class="warning">* 요구서를 발송하게 되면 해당 제출 기관 대표 담당자에게 지정 발송되며, 담당자가 없는 경우는 작성 중 요구함에 그대로 남아있게 됩니다.  </p>
          <p class="warning">* 요구서 발송 버튼을 이용하시기 위해서는 위원회를 선택해 주시기 바랍니다.  </p>  -->

    <% if(objUserInfo.getOrganGBNCode().equals("004") && !strRsCmt.equals("")) { %>
          <p class="warning">* 요구서를 발송하게 되면 해당 제출 기관 대표 담당자에게 지정 발송되며, 담당자가 없는 경우는 작성 중 요구함에 그대로 남아있게 됩니다. </p>
    <% } %>


        <!-- 리스트 버튼-->
        <div id="btn_all" >        <!-- 리스트 내 검색 -->
        <div class="list_ser" >
        <%
        String strCommReqBoxQryField=objParams.getParamValue("CommReqBoxQryField");
        %>
          <select name="CommReqBoxQryField" class="selectBox5"  style="width:70px;" >
            <option <%=(strCommReqBoxQryField.equalsIgnoreCase("req_box_nm"))? " selected ": ""%>value="req_box_nm">요구함명</option>
            <option <%=(strCommReqBoxQryField.equalsIgnoreCase("req_box_dsc"))? " selected ": ""%>value="req_box_dsc">요구함설명</option>
            <option <%=(strCommReqBoxQryField.equalsIgnoreCase("submt_organ_nm"))? " selected ": ""%>value="submt_organ_nm">제출기관</option>
          </select>
          <input name="CommReqBoxQryTerm" onKeyDown="return ch()" onMouseDown="return ch()"
         class="li_input"  style="width:100px" value="<%=objParams.getParamValue("CommReqBoxQryTerm")%>" />
          <img src="/images2/btn/bt_list_search.gif"  onMouseOver="menuOn(this);" onMouseOut="menuOut(this);" onClick="listqry.submit()"/> </div>
        <!-- /리스트 내 검색 -->
            <span class="right">
    <%
        //권한 없음
        if(!strReqSubmitFlag.equals("004")){
            /** 위원회 행정직원 일때만 화면에 출력함.*/
            if(objUserInfo.getOrganGBNCode().equals("004") && !strRsCmt.equals("")){
    %>
               <!-- <span class="list_bt"><a href="#" onclick="openReqBoxPopup();">요구함 작성</a></span>-->
                <span class="list_bt"><a href="#" onclick="doDelete();">요구함 삭제</a></span>
    <% }    } %>
    <!-- 2005-08-18 kogaeng ADD -->
    <% if(FLAG < 2 && objUserInfo.getOrganGBNCode().equals("004") && !strRsCmt.equals("")) { %>
                <span class="list_bt"><a href="#" onclick="sendReqDoc()">요구서 발송</a></span>
    <% } %>
            </span>

        </div>

        <!-- /리스트 버튼-->

        <!-- /각페이지 내용 -->
      </div>
      <!-- /contents -->

    </div>
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
  <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>