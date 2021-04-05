<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.bf.config.*"%>
<%@ page import="kr.co.kcc.pf.util.PageCount"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RMemReqBoxVListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.MemRequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.MemRequestInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.cmtsubmt.CmtSubmtReqBoxDelegate" %>

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
	
	/**일반 요구함 상세보기 파라미터 설정.*/
	RMemReqBoxVListForm objParams =new RMemReqBoxVListForm();  
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
	} //endif

	/*************************************************************************************************/
	/** 					데이터 호출 Part 														  */
	/*************************************************************************************************/
	 
	String strAuditYear = (String)objParams.getParamValue("AuditYear") == null ? "2008" : (String)objParams.getParamValue("AuditYear");
	String strCmtGubun = objUserInfo.getOrganGBNCode();
	strAuditYear = StringUtil.getEmptyIfNull(strAuditYear);
	/*** Delegate 과 데이터 Container객체 선언 */
	MemRequestBoxDelegate objReqBox=null; 		/**요구함 Delegate*/
	MemRequestInfoDelegate  objReqInfo=null;	/** 요구정보 Delegate */
	ResultSetSingleHelper objRsSH=null;		/** 요구함 상세보기 정보 */
	ResultSetHelper objRs=null;				/**요구 목록 */
	CmtSubmtReqBoxDelegate objCmtSubmt = null;
 
	try{
		/**요구함 정보 대리자 New */
		objReqBox=new MemRequestBoxDelegate();
		objCmtSubmt = new CmtSubmtReqBoxDelegate();
		   
		/**요구함 이용 권한 체크 */
		boolean blnHashAuth=objReqBox.checkReqBoxAuth((String)objParams.getParamValue("ReqBoxID"),objUserInfo.getOrganID()).booleanValue();
		if(!blnHashAuth){
		    objMsgBean.setMsgType(MessageBean.TYPE_WARN);
		  	objMsgBean.setStrCode("DSAUTH-0001");
		  	objMsgBean.setStrMsg("해당 요구함을 볼 권한이 없습니다.");
		  	//out.println("해당 요구함을 볼 권한이 없습니다.");
%>
			<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
			return;
		} else {
			/** 요구함 정보 */
			objRsSH=new ResultSetSingleHelper(objReqBox.getRecord((String)objParams.getParamValue("ReqBoxID")));
			
			/**요구 정보 대리자 New */    
			objReqInfo=new MemRequestInfoDelegate();
			objRs=new ResultSetHelper(objReqInfo.getRecordList(objParams));

			if(strAuditYear.equals("")){
				strAuditYear = ((String)objRsSH.getObject("REG_DT")).substring(0,4);
			}
		}/**권한 endif*/
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
<title><%=MenuConstants.REQ_BOX_MAKE%> > <%=MenuConstants.REQ_BOX_DETAIL_VIEW%></title>
<link href="/css/System.css" rel="stylesheet" type="text/css">
<script language="javascript">
  /** 정렬방법 바꾸기 */
  function changeSortQuery(sortField,sortMethod){
  	formName.ReqInfoSortField.value=sortField;
  	formName.ReqInfoSortMtd.value=sortMethod;
  	formName.target = '';
  	formName.submit();
  }
  /**요구 상세보기로 가기.*/
  function gotoDetail(strID){
  	formName.ReqInfoID.value=strID;
  	formName.action="./RMakeReqInfoVList.jsp";
  	formName.target = '';
  	formName.submit();
  }
  
  /** 목록으로 가기 */
  function gotoList(){
  	formName.action="./RMakeReqBoxList.jsp";
  	formName.target = '';
  	formName.submit();
  }
  
  /** 페이징 바로가기 */
  function goPage(strPage){
  	formName.ReqInfoPage.value=strPage;
  	formName.target = '';
  	formName.submit();
  }
  
  /** 요구등록페이지로 가기. */
  function gotoRegReqInfo(){
  	formName.action="./RMakeReqInfoWrite.jsp";
  	formName.target = '';
  	formName.submit();
  }
  
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


	function sendReqDocByCmtTitle() {		
		
		if(!IsClick){
			
		}else{
			alert("프로세스가 작동중입니다. 잠시 기다려주십시오.");
			return false;
		}
		if(confirm("해당 요구 내용을 위원회로 신청하신 후 위원회 명의로 발송하시겠습니까?")) {
			IsClick = true;  //버튼 처리를 수행중..
			ButtonProcessing();  //처리상태를 표시하는 메소드 호출

			formName.method = "POST";
			formName.target = "processingFrame";
			formName.action = "/reqsubmit/common/CmtReqDocSendAllInOne.jsp";
			//var winl = (screen.width - 304) / 2;
			//var winh = (screen.height - 118) / 2;
			//document.all.loadingDiv.style.left = winl;
			//document.all.loadingDiv.style.top = winh;
			//document.all.loadingDiv.style.display = '';
			//window.open('about:blank', 'popwin', 'width=100px, height=100px, left=1500px, top=1500px');
			formName.submit();
		}
	}

	function sendReqDocNew(strReqDocType, strReqBoxID) {
		if(!IsClick){
			NewWindowFixSize('/reqsubmit/common/ReqDocSend.jsp?ReqBoxID='+strReqBoxID+'&ReqDocType='+strReqDocType, '', '460', '340');
		}else{
			alert("프로세스가 작동중입니다. 잠시 기다려주십시오.");
			return false;
		}
  	//var popModal = window.showModalDialog('RMakeReqDocSend.jsp?ReqDocType="+strReqDocType+"&ReqBoxID=' + strReqBoxID, 
  	//															'', 'dialogWidth:450px;dialogHeight:500px; center:yes; help:no; status:no; scroll:no; resizable:yes');
  	//window.open('/reqsubmit/common/ReqDocSend.jsp?ReqBoxID='+strReqBoxID+'&ReqDocType='+strReqDocType, '', 'width=450,height=320, scrollbars=no, resizable=no, toolbar=no, menubar=no, location=no, directories=no, status=no');
  	
  }

	function copyReqBox(ReqBoxID) {
		NewWindow('/reqsubmit/common/MemReqBoxCopyList.jsp?ReqBoxID='+ReqBoxID,'', '640', '450');
	}
</script>
<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="/js/reqsubmit/reqboxview.js"></SCRIPT>
</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
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
<SCRIPT language="JavaScript" src="/js/reqsubmit/tooltip.js"></SCRIPT>
<script language="javascript">balloonHint("balloonHint")</script>

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
<form name="formName" method="<%=nads.lib.reqsubmit.EnvConstants.FORM_METHOD%>" action="<%=request.getRequestURI()%>"><!--요구함 신규정보 전달 -->
			<%//요구함 정렬 정보 받기.
				String strReqBoxSortField=objParams.getParamValue("ReqBoxSortField");
				String strReqBoxSortMtd=objParams.getParamValue("ReqBoxSortMtd");
				//요구함 페이지 번호 받기.
				String strReqBoxPagNum=objParams.getParamValue("ReqBoxPage");
				//요구함 조회정보 받기.
				String strReqBoxQryField=objParams.getParamValue("ReqBoxQryField");
				String strReqBoxQryTerm=objParams.getParamValue("ReqBoxQryTerm");
				//요구 정보 정렬 정보 받기.
				String strReqInfoSortField=objParams.getParamValue("ReqInfoSortField");
				String strReqInfoSortMtd=objParams.getParamValue("ReqInfoSortMtd");
				//요구함 정보 페이지 번호 받기.
				String strReqInfoPagNum=objParams.getParamValue("ReqInfoPage");
				//요구조회히든태그없애기위해.
				objParams.getFormElement("ReqInfoQryField").setFormTagType(nads.lib.reqsubmit.form.FormElement.FORM_TAG_TYPE_SESSION);
				objParams.getFormElement("ReqInfoQryTerm").setFormTagType(nads.lib.reqsubmit.form.FormElement.FORM_TAG_TYPE_SESSION);
		    %>
		    <!-- %= objParams.getHiddenFormTags()% -->
			
			<input type="hidden" name="ReqBoxPage" value="<%= strReqBoxPagNum %>">
			<input type="hidden" name="ReqBoxPageSize" value="<%= (String)objParams.getParamValue("ReqBoxPageSize") %>">
			<input type="hidden" name="ReqBoxQryField" value="<%= (String)objParams.getParamValue("ReqBoxQryField") %>">
			<input type="hidden" name="ReqBoxQryTerm" value="<%= (String)objParams.getParamValue("ReqBoxQryTerm") %>">
			<input type="hidden" name="ReqBoxSortField" value="<%= (String)objParams.getParamValue("ReqBoxSortField") %>">
			<input type="hidden" name="ReqBoxSortMtd" value="<%= (String)objParams.getParamValue("ReqBoxSortMtd") %>">
			<input type="hidden" name="ReqInfoPage" value="<%= (String)objParams.getParamValue("ReqInfoPage") %>">
			<input type="hidden" name="ReqInfoPageSize" value="<%= (String)objParams.getParamValue("ReqInfoPageSize") %>">
			<input type="hidden" name="ReqInfoSortField" value="<%= (String)objParams.getParamValue("ReqInfoSortField") %>">
			<input type="hidden" name="ReqInfoSortMtd" value="<%= (String)objParams.getParamValue("ReqInfoSortMtd") %>">
			<input type="hidden" name="AuditYear" value="<%= strAuditYear %>">
			<input type="hidden" name="RltdDuty" value="<%= (String)objParams.getParamValue("RltdDuty") %>">
			
			<input type="hidden" name="ReturnUrl" value="<%=request.getRequestURI()%>"><!--되돌아올 URL -->
			<input type="hidden" name="ReqDocType" value="<%= CodeConstants.REQ_DOC_TYPE_001 %>"><!-- ReqDocType -->
			<input type="hidden" name="CmtOrganID" value="<%= objRsSH.getObject("CMT_ORGAN_ID") %>">
			<input type="hidden" name="ReqBoxID" value="<%= (String)objParams.getParamValue("ReqBoxID") %>">
			<input type="hidden" name="ReqInfoID" value="">
			<input type="hidden" name="ReqBoxIDs">
			<input type="hidden" name="SubmtDln" value="<%= StringUtil.getDate((String)objRsSH.getObject("SUBMT_DLN")) %>">
			<input type="hidden" name="ReqBoxNm" value="<%=objRsSH.getObject("REQ_BOX_NM")%>">
			<input type="hidden" name="ReqOrganNm" value="<%=objRsSH.getObject("REQ_ORGAN_NM")%>">
			<input type="hidden" name="RegrNm" value="<%=objRsSH.getObject("REGR_NM")%>">
			<input type="hidden" name="ReqOrganId" value="<%=objRsSH.getObject("REQ_ORGAN_ID")%>">
			
			<%
				int int1st = String.valueOf(objRsSH.getObject("REQ_BOX_NM")).indexOf("제");
				int int2nd = String.valueOf(objRsSH.getObject("REQ_BOX_NM")).indexOf("회");
				String strNatCnt = String.valueOf(objRsSH.getObject("REQ_BOX_NM")).substring(int1st+1, int2nd);
			%>
			<input type="hidden" name="NatCnt" value="<%= strNatCnt %>">
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
                		제출기관에게 보낼 요구함 정보를 확인하는 화면입니다.
                </td>
              </tr>
              <tr> 
                <td height="5" align="left" class="soti_reqsubmit"></td>
              </tr>
              <tr> 
                <td height="30" align="left" class="soti_reqsubmit">
                	<!-------------------- TAB 에 해당하는 제목을 기술하는 곳이지요. ------------------------>
                	<img src="/image/reqsubmit/icon_reqsubmit_soti.gif" width="9" height="9" align="absmiddle"> 
                  요구함 정보
                </td>
              </tr>
              <tr> 
                <td align="left" valign="top" class="soti_reqsubmit">
                <!------------------------- TAB에 해당하는 테이블(목록이든 등록폼이든 상세정보든) 출력 시~~~작 ------------------------->
                <table width="680" border="0" cellspacing="0" cellpadding="0">
                    <tr class="td_reqsubmit"> 
                      <td height="2" colspan="4"></td>
                    </tr>
                    <%
					  //요구함 진행 상태.
					  String strReqBoxStt=(String)objRsSH.getObject("REQ_BOX_STT");                    
					%>
					
					<tr> 
                      <td width="100" height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        요구함명 </td>
                      <td width="580" height="25" colspan="3" class="td_lmagin">
                      	<B><%=objRsSH.getObject("REQ_BOX_NM")%></B>
                      </td>
                    </tr>
                    <tr height="1" class="tbl-line"> 
                      <td height="1" colspan="4"></td>
                    </tr>

					<%
						// 2004-07-08 사무처, 예정처일 경우에는 위원회라는건 보이지마
						if (CodeConstants.ORGAN_GBN_ASM.equalsIgnoreCase(objUserInfo.getOrganGBNCode()) || CodeConstants.ORGAN_GBN_BUD.equalsIgnoreCase(objUserInfo.getOrganGBNCode())) {
						} else {
					%>
                    <tr> 
                      <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        소관 위원회 </td>
                      <td height="25" colspan="3" class="td_lmagin">
                      	<%=objRsSH.getObject("CMT_ORGAN_NM")%>
                      </td>
                    </tr>
                    <tr height="1" class="tbl-line"> 
                      <td height="1" colspan="4"></td>
                    </tr>              
                    <% } %>

					<tr> 
                      <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        발송정보</td>
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
                      		<tr>
                      			<td width="20" height="20" align="center" rowspan="2"><img src="/image/reqsubmit/icon_assembly.gif" border="0"></td>
                      			<td>&nbsp;<%=(String)objRsSH.getObject("REQ_ORGAN_NM")%>&nbsp;&nbsp;</td>
                      			<td width="50" align="center" rowspan="2"><img src="/image/reqsubmit/arrow1.gif" border="0"></td>
                      			<td width="20" height="20" align="center" rowspan="2"><img src="/image/reqsubmit/icon_cube.gif" border="0"></td>
                      			<td>&nbsp;<%=(String)objRsSH.getObject("SUBMT_ORGAN_NM")%></td>
                      		</tr>
                      		<tr>
                      			<td>&nbsp;<%=(String)objRsSH.getObject("REGR_NM")%>&nbsp;&nbsp;</td>
                      			<td width="350">&nbsp;(발송되지 않았으므로, 답변 대상자 정보가 없습니다.)</td>
                      		</tr>
                      	</table>
                      </td>
                    </tr>
                    <tr height="1" class="tbl-line"> 
                      <td height="1"></td>
                      <td height="1" colspan="3"></td>
                    </tr>
                    
                    <tr> 
                      <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        요구함 이력</td>
                      <td height="50" colspan="3" class="td_lmagin">
                      	<table border="0" cellpadding="0" cellspacing="0">
                      		<tr>
                      			<td width="110" height="20">&nbsp;<img src="/image/reqsubmit/icon_box.gif" border="0"> 요구함생성일시 : </td>
                      			<td width="150">&nbsp;<%=StringUtil.getDate2((String)objRsSH.getObject("REG_DT"))%></td>
                      		</tr>
							<tr>
                      			<td height="20">&nbsp;<img src="/image/reqsubmit/icon_box.gif" border="0"> 제출기한 : </td>
                      			<td>&nbsp;<%=StringUtil.getDate((String)objRsSH.getObject("SUBMT_DLN"))%> 24:00</td>
                      		</tr>
                      	</table>
                      </td>
                    </tr>
                    <tr height="1" class="tbl-line"> 
                      <td height="1"></td>
                      <td height="1" colspan="3"></td>
                    </tr>
                    
                    <tr> 
                      <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        요구함설명 </td>
                      <td height="25" colspan="3" class="td_lmagin">
                      	<%=StringUtil.getDescString((String)objRsSH.getObject("REQ_BOX_DSC"))%>
                      </td>
                    </tr>
                    <tr height="2" class="tbl-line"> 
                      <td height="2" colspan="4"></td>
                    </tr>
                </table>
				<!------------------------- TAB에 해당하는 테이블(목록이든 등록폼이든 상세정보든) 출력 끝 ------------------------->                   
                </td>
              </tr>
              <tr>
               	<!-- 스페이스한칸 -->
               	<td>&nbsp;</td>
               	<!-- 스페이스한칸 -->
              </tr>
              <tr>
               	<td>
               	<!----------------------- 저장 취소등 Form관련 버튼 시작 ------------------------->
               	 <table>
               	   <tr>
               		 <td>
						<DIV style="height:25px;color:brown">
						<img src="/image/common/icon_exclam_mark.gif" border="0"> <B>요구서 발송 </B> : 의원실(또는 소속기관) 명의로 해당 제출기관에 요구서를 발송합니다.
						</DIV>
						<% 
							if(objCmtSubmt.checkCmtOrganMakeAutoSche((String)objRsSH.getObject("CMT_ORGAN_ID")) && objUserInfo.getIsMyCmtOrganID((String)objRsSH.getObject("CMT_ORGAN_ID"))) {
							//if(objUserInfo.getIsMyCmtOrganID((String)objRsSH.getObject("CMT_ORGAN_ID")) && ("GI00004757".equalsIgnoreCase((String)objRsSH.getObject("CMT_ORGAN_ID")) || "GI00004773".equalsIgnoreCase((String)objRsSH.getObject("CMT_ORGAN_ID"))) && objCmtSubmt.checkCmtOrganMakeAutoSche((String)objRsSH.getObject("CMT_ORGAN_ID")) == true) { 
						%> 
						<DIV style="height:25px;color:brown">
						<img src="/image/common/icon_exclam_mark.gif" border="0"> <B>위원회 명의 요구서 발송</B> : 위원회로 작성한 요구 내용을 자동 신청 합니다. 위원회 접수완료 요구함 에서 해당 내용을 확인하세요.
						</DIV>
						<% } %>

						<%
							//결재대기중(상신),기안대기중  상태에서는 요구함 수정,삭제,요구함 발송 버튼이 Disable되어있어야함.
						  	//즉 작성중과 반려상태에석만 가능함.
							if(strReqBoxStt.equals(CodeConstants.REQ_BOX_STT_003) || strReqBoxStt.equals(CodeConstants.REQ_BOX_STT_005) || strReqBoxStt.equals(CodeConstants.REQ_BOX_STT_009)){
	
								/** 등록자와  로그인자가 같을때만 화면에 출력함.*/
								if(objUserInfo.getUserID().equals((String)objRsSH.getObject("REGR_ID"))){
						%>
									<!-- 요구함 수정 BUTTON -->
									<img src="/image/button/bt_modifyReqBox.gif" border="0" onClick="javascript:gotoMemEditPage()" style="cursor:hand">
									<!-- 요구함 삭제 BUTTON -->
									<img src="/image/button/bt_delReqBox.gif"  border="0" onClick="javascript:gotoMemDeletePage(<%=objRs.getTotalRecordCount()%>)" style="cursor:hand">
						<%
							 	} // 등록자와  로그인자가 같을때만 화면에 출력함.
						%>
									<!-- 요구함 복사 -->
									<a href="javascript:copyReqBox('<%=objRsSH.getObject("REQ_BOX_ID")%>')" onfocus="this.blur()">
										<img src="/image/button/bt_copyReqBox.gif" border="0" style="cursor:hand" alt="현재 요구함의 복사본 요구함이 생성됩니다.">
									</a>
									
									<!-- 요구함 목록 -->
									<img src="/image/button/bt_reqBoxList.gif"  border="0" onClick="javascript:gotoList()" style="cursor:hand">
						<%
								if(intTotalRecordCount>0){
						%>
									<!-- 요구함 발송 BUTTON -->
									<!-- 2005-08-08 kogaeng EDIT -->
									<!-- 법사위의 경우 보여서는 안된다 -->
									<% if(objUserInfo.getIsMyCmtOrganID("GI00004757") && "GI00004757".equalsIgnoreCase((String)objRsSH.getObject("CMT_ORGAN_ID"))) { %>
									<% } else { %>
										<%if(strCmtGubun.equals("004")){%>
										<img src="/image/button/bt_sendReq2_bak.gif"  border="0" onClick="javascript:sendReqDocNew('<%= CodeConstants.REQ_DOC_TYPE_001 %>', '<%= (String)objParams.getParamValue("ReqBoxID") %>')" style="cursor:hand" alt="작성된 요구함을 제출기관으로 발송합니다.">
										<%}else{%>
										<img src="/image/button/bt_sendReq2.gif"  border="0" onClick="javascript:sendReqDocNew('<%= CodeConstants.REQ_DOC_TYPE_001 %>', '<%= (String)objParams.getParamValue("ReqBoxID") %>')" style="cursor:hand" alt="작성된 요구함을 제출기관으로 발송합니다.">
										<%}%>										
									<% } %>

									<!-- 2005-01-15 법제사법위원회(organ_id : GI00004757) 의 경우 위원회의 접수완료 요구함으로 이동시킨다. -->
						<% 
									if(objCmtSubmt.checkCmtOrganMakeAutoSche((String)objRsSH.getObject("CMT_ORGAN_ID")) && objUserInfo.getIsMyCmtOrganID((String)objRsSH.getObject("CMT_ORGAN_ID"))) {
						%> 
										<img src="/image/button/bt_sendReqDocCmtTitle2.gif"   border="0" onClick="sendReqDocByCmtTitle()" style="cursor:hand" alt="작성된 요구함을 제출기관으로 발송합니다.">
						<% 
									} 
						%>
						<!-- 2004-12-08 -->
						<!-- 작성한 요구함을 자동 위원회 제출 후 위원회 명의로 발송 -->
						<!-- 로그인한 이용자가 소속된 위원회 이어야 하며, 그 위원회가 '예산결산특별위원회' 인 경우에만 해당 기능을 제공한다. -->
						<% //if(objUserInfo.getIsMyCmtOrganID((String)objRsSH.getObject("CMT_ORGAN_ID")) && "GI00004773".equalsIgnoreCase((String)objRsSH.getObject("CMT_ORGAN_ID")) && objCmtSubmt.checkCmtOrganMakeAutoSche((String)objRsSH.getObject("CMT_ORGAN_ID")) == true) { %> 
							<!-- img src="/image/button/bt_sendReqDocCmtTitle.gif" onClick="javascript:sendReqDocByCmtTitle()" alt="작성된 요구함을 위원회의 이름으로 제출기관으로 발송합니다." style="cursor:hand" -->
						<% //} %>
						<%
								}//딸린식구가있어야 보임.
							
							} // endif

							/*조회결과 있을때 출력 시작.*/
							if(objRs.getRecordSize()>0){
						%>						
								<img src="/image/button/bt_previewReq2.gif" border="0" 
						<%
							String strReqTp = "";
							if (CodeConstants.ORGAN_GBN_CMT.equalsIgnoreCase(objUserInfo.getOrganGBNCode())) strReqTp = CodeConstants.PRE_REQ_DOC_FORM_901;
							else strReqTp = CodeConstants.PRE_REQ_DOC_FORM_101;
						%>
								onClick="PreReqDocView(formName,'<%= (String)objParams.getParamValue("ReqBoxID") %>', '<%= strReqTp %>')" 
									style="cursor:hand" alt="제출기관에 보낼 요구서(PDF)를 확인합니다.">
						<%
							}//endif 요구서 미리보기 번튼 제어 끝.
						%>
						
               		 </td>
               	   </tr>
               	</table>   
               	<!----------------------- 저장 취소등 Form관련 버튼 끝 ------------------------->               	   
                </td>
              </tr> 
              <tr>
               	<!-- 스페이스한칸 -->
               	<td>&nbsp;</td>
               	<!-- 스페이스한칸 -->
              </tr>
              <tr> 
                <td height="30" class="soti_reqsubmit">
                	<!-------------------- TAB 에 해당하는 제목을 기술하는 곳이지요. ------------------------>
                	<table border="0" cellpadding="0" cellspacing="0" width="759">
                		<tr>
                			<td width="400" class="soti_reqsubmit">
                			   <img src="/image/reqsubmit/icon_reqsubmit_soti.gif" width="9" height="9" align="absmiddle"> 
                  				요구 목록
				            </td>
				            <td width="359" align="right" valign="bottom" class="text_s">
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
										<td height="22" width="15" align="center"><input type="checkbox" name="checkAll" onClick="checkAllOrNot(document.formName);"></td>
										<td width="24" align="center">NO</td>
										<%
										int intTmpWidth1=490;
										if(objUserInfo.getOrganGBNCode().equals("003")){//의원실소속
										  intTmpWidth1=intTmpWidth1-50;
										}//endif의원실소속확인
										%>
										<td width="<%=intTmpWidth1%>" align="center"><%=SortingUtil.getSortLink("changeSortQuery","REQ_CONT",strReqInfoSortField,strReqInfoSortMtd,"요구제목")%></td>
										<td width="80" align="center"><%=SortingUtil.getSortLink("changeSortQuery","OPEN_CL",strReqInfoSortField,strReqInfoSortMtd,"공개등급")%></td>
										<td width="70" align="center"><%=SortingUtil.getSortLink("changeSortQuery","REQ_STT",strReqInfoSortField,strReqInfoSortMtd,"상태")%></td>
										<%
										if(objUserInfo.getOrganGBNCode().equals("003")){//의원실소속
										%>
										<td width="50" align="center"><%=SortingUtil.getSortLink("changeSortQuery","CMT_REQ_APP_FLAG",strReqInfoSortField,strReqInfoSortMtd,"위원회")%></td>
										<%
										}//endif의원실소속확인
										%>
										<td width="80" align="center"><%=SortingUtil.getSortLink("changeSortQuery","REG_DT",strReqInfoSortField,strReqInfoSortMtd,"등록일시")%></td>
									</tr>
	                    		</table>
	                    	</td>
	                    </tr>
                	    <tr> 
                    	  	<td height="1" class="td_reqsubmit"></td>
                    	</tr>
						<%
							int intRecordNumber= intTotalRecordCount - ((intCurrentPageNum -1) * Integer.parseInt((String)objParams.getParamValue("ReqInfoPageSize")));						  
						  	String strReqInfoID = "";
						  	String strCmtApplyValue = "Y";
						  	
						  	while(objRs.next()) {
						  		strReqInfoID = (String)objRs.getObject("REQ_ID");
						   	 	/** 위원회신청가능한지(Y) 아닌지 "" 결정*/
						   	 	if(CodeConstants.isDuplatedApplyToCmtReq((String)objRs.getObject("CMT_REQ_APP_FLAG"))) strCmtApplyValue = "";
								else strCmtApplyValue="Y";
						 %>								
						<tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''">
							<td>
								<table width="759" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td height="22" width="15" align="center"><input type="checkbox" name="ReqInfoIDs" value="<%=strReqInfoID%>"></td>
										<td width="24" align="center"><%=intRecordNumber%></td>
										<%
										int intTmpWidth2=490;
										if(objUserInfo.getOrganGBNCode().equals("003")){//의원실소속
										  intTmpWidth2=intTmpWidth2-50;
										}//endif의원실소속확인
										%>
										<td width="<%=intTmpWidth2%>" class="td_lmagin"><%=StringUtil.getNotifyImg((String)objRs.getObject("REG_DT"))%><a href="JavaScript:gotoDetail('<%=strReqInfoID%>');" hint="<%= StringUtil.substring((String)objRs.getObject("REQ_DTL_CONT"), 40)+" ..."	 %>"><%=StringUtil.substring((String)objRs.getObject("REQ_CONT"),35)%></a></td>
										<td width="80" align="center"><%=CodeConstants.getOpenClass((String)objRs.getObject("OPEN_CL"))%></td>
										<td width="70" align="center"><%=CodeConstants.getRequestStatus((String)objRs.getObject("REQ_STT"))%></td>
										<%
										if(objUserInfo.getOrganGBNCode().equals("003")){//의원실소속
										%>
										<td width="60" align="center"><%=CodeConstants.getCmtRequestAppoint((String)objRs.getObject("CMT_REQ_APP_FLAG"))%></td>
										<%
										}//endif의원실소속확인
										%>										
										<td width="70" align="right" style="padding-top:2px;padding-bottom:2px;padding-right:4px"><%=StringUtil.getDate2((String)objRs.getObject("REG_DT"))%></td>
									</tr>
								</table>
								<input type="hidden" name="ReqID" value="<%= strReqInfoID %>">
								<input type="hidden" name="CmtApplys" value="<%=strCmtApplyValue%>">
								
							</td>
						</tr>
    	                <tr class="tbl-line"> 
                      		<td height="1"></td>
                    	</tr>       	
						<%
							    intRecordNumber --;
							}//endwhile
						%>
						<%
						/*조회결과 없을때 출력 시작.*/
						if(objRs.getRecordSize()<1){
						%>
						<tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''">
						    <td align="center" height="22">등록된 요구정보가 없습니다.</td>
						</tr>
    	                <tr class="tbl-line"> 
                      		<td height="1"></td>
                    	</tr>       	
						<%
						}/*조회결과 없을때 출력 끝.*/
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
							objParams.getParamValue("ReqInfoPageSize"))
					%>
                </td>
              </tr>
              <tr height="3">
              	<td height="3" align="left" valign="top" background="/image/common/line_table.gif"></td>
              </tr>                                          
              <!------------------ 검색(조회) 폼 <tr></tr> --------------------------->
              <tr> 
                <td height="40" align="left" valign="top">
                	<table width="100%" border="0" cellspacing="0" cellpadding="0">
                    	<tr> 
                      		<td width="456" height="40">
                      			<!-- 버튼이 필요하다면 여기에 추가하심 됩니다용 -->
                 		   <%//결재대기중(상신),기안대기중  상태에서는 요구함 수정,삭제,요구함 발송 버튼이 Disable되어있어야함.
					          //즉 작성중과 반려상태에석만 가능함.
					         if(strReqBoxStt.equals(CodeConstants.REQ_BOX_STT_003) || strReqBoxStt.equals(CodeConstants.REQ_BOX_STT_005) || strReqBoxStt.equals(CodeConstants.REQ_BOX_STT_009) ){
					       %>
                      			<img src="/image/button/bt_registerReq.gif" height="20"  style="cursor:hand" onClick="gotoRegReqInfo();">
                      			<%
                      			if(objRs.getRecordSize()>0){/**요구목록이있을경우만 출력*/
                      			%>
                      			<img src="/image/button/bt_moveReq.gif" height="20"  style="cursor:hand" onClick="moveMemReqInfo(formName);" alt="현재 요구를 선택한 요구함으로 이동시킵니다.">
                      			<%
                      			}//endif
                    			%>
                  		   <%
                      		}//endif 요구항 상태 체크 끝.
                      	   %>
                 		   <%//결재대기중(상신),기안대기중  상태에서는 요구함 수정,삭제,요구함 발송 버튼이 Disable되어있어야함.
					          //즉 작성중과 반려상태에석만 가능함.
					         if(strReqBoxStt.equals(CodeConstants.REQ_BOX_STT_003) || strReqBoxStt.equals(CodeConstants.REQ_BOX_STT_005) || strReqBoxStt.equals(CodeConstants.REQ_BOX_STT_009)){
                      			if(objRs.getRecordSize()>0){/**요구목록이있을경우만 출력*/
                  			%>
                      			<img src="/image/button/bt_delReq.gif" height="20"  style="cursor:hand" onClick="delMemReqInfos(formName);">
                      			<!-- 위원회 제출 신청 -->
                      			<% if(!objCmtSubmt.checkCmtOrganMakeAutoSche((String)objRsSH.getObject("CMT_ORGAN_ID")) || !objUserInfo.getIsMyCmtOrganID((String)objRsSH.getObject("CMT_ORGAN_ID"))) { %>
								<!--
       							<img src="/image/button/bt_formalReqSelsct.gif" height="20"  style="cursor:hand" onClick="ApplyCmt(document.formName);"  alt="선택된 요구정보를 위원회명의로 제출기관에게 보내기위해 신청함에 추가합니다.">
								-->
       							<% } %>
                   			<%
                      			}//endif
                      		}//endif 요구항 상태 체크 끝.
                      	   %>
                      	   
                   			<%
                   				if(objRs.getRecordSize()>0){/**요구목록이있을경우만 출력*/
                   			%>
                   				<img src="/image/button/bt_copyReq.gif" height="20"  style="cursor:hand" onClick="copyMemReqInfo(document.formName);" alt="현재 요구의 복사본을 선택한 요구함에 생성합니다.">
                   				
                   			<%
                   				}//endif
                   			%>
                      		</td>
							<td width="303" align="right" valign="middle">
							<%
								String strReqInfoQryField=(String)objParams.getParamValue("ReqInfoQryField");
							%>
								<select name="ReqInfoQryField" class="select">
									<option <%=(strReqInfoQryField.equalsIgnoreCase("req_cont"))? " selected ": ""%>value="req_cont">요구제목</option>
									<option <%=(strReqInfoQryField.equalsIgnoreCase("req_dtl_cont"))? " selected ": ""%>value="req_dtl_cont">요구내용</option>
								</select>
								<input type="text" class="textfield" name="ReqInfoQryTerm" value="<%=objParams.getParamValue("ReqInfoQryTerm")%>">
								<img src="/image/common/bt_search_table.gif" height="18" align="absmiddle" onClick="gotoReqInfoSearch(formName);" style="cursor:hand">
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
