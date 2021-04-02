<%@ page language="java" contentType="text/html; charset=EUC-KR" %>

<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.pf.util.PageCount"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.lib.reqsubmit.params.requestbox.SMemReqBoxListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.SMemReqBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.MemRequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.RequestBoxDelegate" %>


<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	UserInfoDelegate objUserInfo =null;
	CDInfoDelegate objCdinfo =null;
%>

<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>

<%
	String strSelectedAuditYear= null;
	String strSelectedReqOrganID = null;
	String strDaesuInfo = StringUtil.getEmptyIfNull(request.getParameter("DaeSu"));
	String strDaeSuCh = StringUtil.getEmptyIfNull(request.getParameter("DAESUCH"));
	String strSubmtOrganId = StringUtil.getEmptyIfNull(request.getParameter("submtOrganId2"));
	String strOrganId = null;

	if(strSubmtOrganId.equals("")){
		strOrganId = objUserInfo.getOrganID();
	}else{
		strOrganId = strSubmtOrganId;
	}

	
	String strDaesu = null;
	String strStartdate = null;
	String strEnddate = null;
	
	SMemReqBoxDelegate selfDelegate = null;
	MemRequestBoxDelegate objReqBox=null;
	RequestBoxDelegate objReqBoxDelegate = null;
	SMemReqBoxListForm paramForm = new SMemReqBoxListForm();
	paramForm.setParamValue("SubmtOrganID", strSubmtOrganId); // '제출기관' 이므로
	paramForm.setParamValue("ReqBoxStt", CodeConstants.REQ_BOX_STT_006); // '제출기관의 작성 중' 이므로 	

	if(((String)paramForm.getParamValue("ReqBoxSortField")).equals("last_req_doc_snd_dt")){
		paramForm.setParamValue("ReqBoxSortField", "REG_DT");
	}

	boolean blnCheckParam = false;
	blnCheckParam = paramForm.validateParams(request);

	if(!blnCheckParam) {
		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
		objMsgBean.setStrCode("DSPARAM-0000");
		objMsgBean.setStrMsg(paramForm.getStrErrors());
		out.println("ParamError:" + paramForm.getStrErrors());
	  	return;
	}
	
	ResultSetHelper rsHelper = null;
	ResultSetHelper objRsAuditYear = null;
	ResultSetHelper objRsReqOrgan = null;
	ResultSetHelper objDaeRs=null;
	ResultSetHelper objSubmtRs=null;

	try {
		objReqBoxDelegate = new RequestBoxDelegate();
		strSelectedAuditYear = paramForm.getParamValue("AuditYear");
		strSelectedReqOrganID = paramForm.getParamValue("ReqOrganID");

		objDaeRs = new ResultSetHelper(objReqBoxDelegate.getOrganDaesu(strOrganId));
		List lst = objReqBoxDelegate.getSubmtOrganList(objUserInfo.getOrganID());
		objSubmtRs = new ResultSetHelper(lst);
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
		objhashdata.put("SUBMTORGANIDZ",lst);
		
		selfDelegate = new SMemReqBoxDelegate();
		objReqBox=new MemRequestBoxDelegate();
		
		Hashtable objaaa = (Hashtable)selfDelegate.getOpRecordDaeList(paramForm,objhashdata);
		
		rsHelper = new ResultSetHelper(objaaa);
		objRsAuditYear = new ResultSetHelper(selfDelegate.getAuditYearDaeList(lst,strSubmtOrganId,strStartdate,strEnddate,CodeConstants.REQ_BOX_STT_006));
		objRsReqOrgan = new ResultSetHelper(selfDelegate.getReqOrganDaeList(paramForm,objhashdata));
		
	} catch(AppException e) {
		e.printStackTrace();
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		objMsgBean.setStrCode(e.getStrErrCode());
		objMsgBean.setStrMsg(e.getMessage());
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
  		return;
 	} 
 
	// 요구함 목록조회된 결과 반환.
	int intTotalRecordCount = rsHelper.getTotalRecordCount();
	int intCurrentPageNum = rsHelper.getPageNumber();
	int intTotalPage = rsHelper.getTotalPageCount();

%>

<html>
<head>
<title><%=MenuConstants.getReqBoxGeneral(request)%> > <%=MenuConstants.REQ_BOX_MAKE%></title>
<link href="/css/System.css" rel="stylesheet" type="text/css">
<script language="javascript" src="/js/reqsubmit/common.js"></script>

<script language="javascript">

	var form;
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
	/** 정렬방법 바꾸기 */
	function changeSortQuery(sortField, sortMethod){
		form = document.listqry;
  		form.ReqBoxSortField.value = sortField;
  		form.ReqBoxSortMtd.value = sortMethod;
		form.DAESUCH.value = "N";
		form.target="";
		form.action="SMakeOpReqBoxList.jsp";
  		form.submit();
  	}
  
  	/** 요구함 상세보기로 가기 */
  	function gotoDetail(strID){
  		//form = document.listqry;
  		//form.ReqBoxID.value = strID;
		//form.target="";
  		//form.action="SMakeOpReqBoxVList.jsp";
  		//form.submit();

		if(!IsClick){
			location.href="./SMakeOpReqBoxVList.jsp?ReqBoxID="+strID+"&AuditYear="+listqry.AuditYear.value;	
		}else{
			alert("프로세스가 작동중입니다. 잠시 기다려주십시오.");
			return;
		}
  	}
  
  	/** 페이징 바로가기 */
  	function goPage(strPage){
  		form = document.listqry;
  		form.ReqBoxPage.value=strPage;
		form.DAESUCH.value = "N";
		form.target="";
		form.action="SMakeOpReqBoxList.jsp";
  		form.submit();
  	}

	function doRefresh() {
		var f = document.listqry;
		f.DAESUCH.value = "N";
		f.target = "";
		f.action="SMakeOpReqBoxList.jsp";
		f.submit();
	}

	function changeDaesu(){
		form = document.listqry;
		form.target = '';
		form.DAESUCH.value = "Y";
		form.action="SMakeOpReqBoxList.jsp";
		form.submit();
	}

	function AllInOne(){
		
		var w = 800;
		var h = 700;
		var winl = (screen.width - w) / 2;
		var winh = (screen.height - h) / 2;
		var url = "/reqsubmit/common/AnsInfoWriteAllInOne.jsp";	window.open(url,'New','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=no,width='+w+',height='+h+',left='+winl+',top='+winh);
	}

	// 답변서 발송
	function sendAnsDoc(str) {
		var f = document.listqry;
		f.action = "/reqsubmit/common/AnsOpDocSend.jsp?ReqBoxID="+str;
		f.target = "popwin";
		NewWindow('/blank.html', 'popwin', '470', '300');
		f.submit();		
	}

	// 2005-07-18 선택된 요구함 일괄 삭제
	function doDelete() {
		if(!IsClick){
			if(getCheckCount(document.listqry, "ReqBoxID") < 1) {
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
			document.listqry.action = "/reqsubmit/10_mem/20_reqboxsh/15_make/ReqBoxOpDelProcMulti.jsp";
			document.listqry.target = 'processingFrame';	
			//window.open('/blank.html', 'popwin', 'width=300, height=240, left='+winl+', top='+winh);
	  		document.listqry.submit();
	  	}
	}
</script>

</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<iframe name='processingFrame' height='0' width='0'></iframe>
<DIV ID="loadingDiv" style="display:none;position:absolute;">
	<img src="/image/reqsubmit/loading.jpg" border="0"> </td>
</DIV>
<%@ include file="/reqsubmit/common/MenuTopReqsubmit.jsp" %>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr align="left" valign="top">
    <td width="186" height="470" background="/image/common/bg_leftMenu.gif">
	<%@ include file="/reqsubmit/common/MenuLeftReqsubmit.jsp" %></td>

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
                      <td width="25%" background="/image/reqsubmit/bg_reqsubmit_tit.gif">
                      		<!-------------------- 타이틀을 입력해 주세요 ------------------------>
                      		<span class="title"><%= MenuConstants.REQ_BOX_MAKE %></span> 
                      </td>
                      <td width="16%" align="left" background="/image/common/bg_titLine.gif">&nbsp;</td>
                      <td width="59%" align="right" background="/image/common/bg_titLine.gif" class="text_s">
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
						국회 의원실로 부터 오프라인(전화,메일,팩스,구두 등)으로 요청된 자료를 제출하실 수 있습니다.
                </td>
              </tr>
			  <tr align="center"> 
                <td height="30" align="center" class="text_s">
                		<!-------------------- 현재 페이지에 대한 설명 기술 ------------------------>    
						<img src="/image/reqsubmit/reqreg2.gif" style="cursor:hand" onClick="javascript:AllInOne();" alt="오프라인요구 제출자료를 등록합니다." align="absmiddle">
                </td>
              </tr>

<form name="listqry" method="post" action="<%=request.getRequestURI()%>" style="margin:0px">   
			<input type="hidden" name="DAESUCH" value="">
              <!---------------------------------------------------------------------- 재정의된 조회 조건 라인 시작 ------------------------------------------------------------------------>
              <tr> 
                <td height="2"></td>
              </tr>
              <tr>
              	<td width="759">
              		<table border="0" cellpadding="0" cellspacing="0">
              			<tr>
              				<td width="6" height="53"><img src="/image/reqsubmit/searchTableLeft.jpg" border="0"></td>
              				<td width="746" height="53" background="/image/reqsubmit/searchTableBg.jpg">
              					<table border="0" cellpadding="0" cellspacing="0" width="746">
              						<tr>
              							<td width="200" height="24"><img src="/image/reqsubmit/searchTableTop3.jpg" border="0"></td>
              							<td width="546" align="right" valign="bottom">
              								&nbsp;&nbsp;<img src="/image/common/icon_nemo_gray.gif" width="3" height="6" align="absmiddle">
											전체 자료 수 : <%=intTotalRecordCount%>개 (<%=intCurrentPageNum%> / <%=intTotalPage%> Page)
              							</td>
              						</tr>
									<tr>
										<td height="29" colspan="2">
											<table border="0" cellpadding="0" cellspacing="0">
												<tr><td style="padding-left:25px">
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
													<select name="AuditYear" class="select_reqsubmit" onChange="javascript:doRefresh()">
														<option value="">전체</option>
								                		<%								                			
										             		if(objRsAuditYear != null && objRsAuditYear.getTotalRecordCount() > 0) {
																String strSelected1 = "";
																while(objRsAuditYear.next()) {
																	if(strSelectedAuditYear.equals((String)objRsAuditYear.getObject("AUDIT_YEAR"))) strSelected1 = " selected";
																	else strSelected1 = "";
																	out.println("<option value="+(String)objRsAuditYear.getObject("AUDIT_YEAR")+strSelected1+">"+(String)objRsAuditYear.getObject("AUDIT_YEAR")+"</option>");
																}						             			
										             		}										             		
										             	%>
								                	</select> 년도
				                					<%
														if(objSubmtRs.getTotalRecordCount() < 2){
													%>
													<%
														}else{													
													%>
														<select name="submtOrganId2" class="select_reqsubmit" onChange="javascript:doRefresh()">
															<option value="">전체</option>
															<%
																while(objSubmtRs.next()){
															%>
																<option value="<%=objSubmtRs.getObject("ORGAN_ID")%>" 
																<%
																 if(strSubmtOrganId.equals(objSubmtRs.getObject("ORGAN_ID"))){
																%>
																	selected
																<%
																}%>
																><%=objSubmtRs.getObject("ORGAN_NM")%></option>
															<%}%>
														</select>
													<%
														}	
													%>
								                	<select name="ReqOrganID" class="select_reqsubmit" onChange="javascript:doRefresh()">
								                		<option value="">:::: 전체 요구기관 ::::</option>
								                		<%
								                			if(objRsReqOrgan.getTotalRecordCount() < 1) {
									                			out.println("<option value=''>::: 요구기관이 없습니다 :::</option>");
										             		}
										             		String strSelected2 = "";
										             		while(objRsReqOrgan.next()) {
											             		if(strSelectedReqOrganID.equalsIgnoreCase((String)objRsReqOrgan.getObject("REQ_ORGAN_ID"))) strSelected2 = " selected";
										             			else strSelected2 = "";
										             			out.println("<option value="+(String)objRsReqOrgan.getObject("REQ_ORGAN_ID")+strSelected2+">"+(String)objRsReqOrgan.getObject("REQ_ORGAN_NM")+"</option>");
										             		}
										             	%>
								                	</select> 목록보기													
												</td>
												<td>&nbsp;&nbsp;</td>
												</tr>
											</table>
										</td>
									</tr>
              					</table>
              				</td>
              				<td width="7" height="53"><img src="/image/reqsubmit/searchTableRight.jpg" border="0"></td>
              			</tr>
              		</table>
              	</td>
              </tr>
              <tr> 
                <td height="5"></td>
              </tr>
              <!---------------------------------------------------------------------- 재정의된 조회 조건 라인 끝 ------------------------------------------------------------------------>
              
              
              <tr> 
                <td align="left" valign="top" class="soti_reqsubmit">
                <!------------------------- TAB에 해당하는 테이블(목록이든 등록폼이든 상세정보든) 출력 시~~~작 ------------------------->
<%
	// 정렬 정보 받기.
	String strReqBoxSortField = paramForm.getParamValue("ReqBoxSortField");
	String strReqBoxSortMtd = paramForm.getParamValue("ReqBoxSortMtd");
%>
					<input type="hidden" name="ReqBoxSortField" value="<%= strReqBoxSortField %>">
					<input type="hidden" name="ReqBoxSortMtd" value="<%= strReqBoxSortMtd %>">
					<input type="hidden" name="ReqBoxPage" value="<%= intCurrentPageNum %>">					
					<input type="hidden" name="ReturnURL" value="/reqsubmit/10_mem/20_reqboxsh/15_make/SMakeOpReqBoxList.jsp">
					
					<table width="759" border="0" cellspacing="0" cellpadding="0">
                    	<tr> 
                      		<td height="2" colspan="6" class="td_reqsubmit"></td>
	                    </tr>
    	                <tr align="center" class="td_top"> 
            	          	<td width="39" height="22" align="center"><input type="checkbox" name="checkAll" onClick="javascript:checkAllOrNot(document.listqry)"></td>
							<td width="80" height="22"><%=SortingUtil.getSortLink("changeSortQuery", "RLTD_DUTY", strReqBoxSortField, strReqBoxSortMtd, "업무구분")%></td>
	                	    <td width="340" height="22"><%=SortingUtil.getSortLink("changeSortQuery", "REQ_BOX_NM", strReqBoxSortField, strReqBoxSortMtd, "요구자료")%></td>
                    	  	<td width="120" height="22"><%=SortingUtil.getSortLink("changeSortQuery", "REQ_ORGAN_NM", strReqBoxSortField, strReqBoxSortMtd, "요구기관")%></td>
	                      	
    	                  	<td width="70" height="22"><%=SortingUtil.getSortLink("changeSortQuery", "REG_DT", strReqBoxSortField, strReqBoxSortMtd, "등록일시")%></td>
        	              	<td width="80" height="22">답변발송</td>
            	        </tr>
                	    <tr> 
                    	  	<td height="1" colspan="6" class="td_reqsubmit"></td>
                    	</tr>
                    	<%
                    		int intRecordNumber = intTotalRecordCount - ((intCurrentPageNum -1) * Integer.parseInt((String)paramForm.getParamValue("ReqBoxPageSize")));
							if(rsHelper.getRecordSize() > 0) {
								String strReqBoxID = "";
								String strFstQryDt = "";
							  	while(rsHelper.next()) {
							  		strReqBoxID = (String)rsHelper.getObject("REQ_BOX_ID");
									strFstQryDt = (String)rsHelper.getObject("FST_QRY_DT");
							  		//Hashtable countHash = (Hashtable)selfDelegate.getReqBoxRelateCount(strReqBoxID);
						%>
	                    <tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''"> 
        	              	<td width="39" align="center"><input type="checkbox" name="ReqBoxID" value="<%=strReqBoxID%>"></td>
							<td width="80" align="center"><%= objCdinfo.getRelatedDuty((String)rsHelper.getObject("RLTD_DUTY")) %></td>
            	          	<td width="340" class="td_lmagin" style="padding-left:5px"><%if(strFstQryDt.equals("")||strFstQryDt == null){%><b><%}%><a href="javascript:gotoDetail('<%=strReqBoxID%>')"><%= (String)rsHelper.getObject("REQ_BOX_NM") %></a><%if(strFstQryDt.equals("")||strFstQryDt == null){%></b><%}%></td>
                	      	<td width="150" class="td_lmagin"><%= (String)rsHelper.getObject("REQ_ORGAN_NM") %></td>
                    	  	
                      		<td width="70" align="right" style="padding-top:2px;padding-bottom:2px"><%= StringUtil.getDate2((String)rsHelper.getObject("REG_DT")) %></td>
	                      	<td width="80" align="center"><img src="/image/reqsubmit/bt_sendAnswer7.gif" style="cursor:hand" onclick="javascript:sendAnsDoc('<%=strReqBoxID%>')"></td>
    	                </tr>
    	                <tr class="tbl-line"> 
                      		<td height="1" colspan="6"></td>
                    	</tr>
                    	<%
                    				intRecordNumber--;
								} // endofwhile
							} else {
						%>
						<tr>
							<td colspan="6" height="40" align="center">등록된 요구자료가 없습니다.</td>
						</tr>
						<%
							} // end if
						%>
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
							paramForm.getParamValue("ReqBoxPageSize"))
					%>
                </td>
              </tr>
              
              <!---------------------------------------------- 회색 라인이 필요해!!!!!!!! --------------------------------------------->
              <tr>
              	<td height="3" background="/image/common/line_table.gif"></td>
              </tr>
                            
              <!------------------ 검색(조회) 폼 <tr></tr> --------------------------->
              <tr> 
                <td height="40" align="left" valign="top">
                	<table width="100%" border="0" cellspacing="0" cellpadding="0">
                    	<tr> 
                      		<td width="256" height="40">
                      			<!-- 버튼이 필요하다면 여기에 추가하심 됩니다용 -->
								<img src="/image/reqsubmit/reqreg.gif" style="cursor:hand" onClick="javascript:AllInOne();" alt="오프라인요구 제출자료를 등록합니다." align="absmiddle">
								&nbsp;&nbsp;
								<img src="/image/reqsubmit/reqdel.gif" style="cursor:hand" onClick="javascript:doDelete();" alt="오프라인요구 제출자료를 삭제합니다." align="absmiddle">
                      			
                      		</td>
                      		<td width="503" align="right" valign="middle">
                      			<!----------- 검색 폼 ----------->								
                      			<% String strReqBoxQryField = paramForm.getParamValue("ReqBoxQryField"); %>
                      			<select name="ReqBoxQryField" class="select">
									<option <%=(strReqBoxQryField.equalsIgnoreCase("req_box_nm"))? " selected ": ""%>value="req_box_nm">요구자료</option>
								</select>
                          		<input type="text" name="ReqBoxQryTerm" value="<%= paramForm.getParamValue("ReqBoxQryTerm") %>" class="textfield" style="WIDTH:180px" >
                          		<img src="/image/common/bt_search_table.gif" width="51" height="18" align="absmiddle" onClick="listqry.submit()" style="cursor:hand">
                          	</td>
                    	</tr>
                  	</table>
               </td>
              </tr>
              
            	<!------------------------- 또 TAB을 두고 싶으시면 위의 소스들을 복사해서 이 곳에 붙여넣기 해서 수정하세요 ------------------------->
            	<!----- [주의] TAB <tr> 과 그 밑에 내용을 구성하는 <tr>을 잘 구분해서 잘 챙겨 주시어요. 나으리.. -------->
</form>

            </table>
            </td>
        </tr>
      </table></td>
  </tr>
</table>
<%@ include file="/common/Bottom.jsp" %>
</body>
</html>
