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


<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	UserInfoDelegate objUserInfo =null;
	CDInfoDelegate objCdinfo =null;
%>
<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>

<% 
	/*************************************************************************************************/
	/** 	name : RCommReqBoxList.jsp																  */
	/** 		   위원회 요구함 목록을 출력한다.													  */
	/** 		   요구일정이 있는 소속 위원회의 목록을 출력한다.										  */
	/*************************************************************************************************/
 
	/**선택된 감사년도와 선택된 위원회ID*/
	String strSelectedAuditYear= null; /**선택된 감사년도*/
  	String strSelectedCmtOrganID=null; /**선택된 위원회ID*/
  	String strRltdDuty=null; 			 /**선택된 업무구분 */
	String strCmtOpenCl = "";
	String strReqSubmitFlag = objUserInfo.getReqSubmitFlag(); 

  
	/**위원회목록조회용 파라미터 설정.*/
	RCommReqBoxListForm objParams=new RCommReqBoxListForm();
	//요구기관 설정 :: 소속 기관.
	objParams.setParamValue("ReqOrganID",objUserInfo.getOrganID());
	//위원회 요구일정진행상태 : 접수완료
	objParams.setParamValue("IngStt",CodeConstants.REQ_ING_STT_002);
	//요구함 상태 : 제출완료
	objParams.setParamValue("ReqBoxStt",CodeConstants.REQ_BOX_STT_007);
	if((objParams.getParamValue("CommReqBoxSortField")).equals("REG_DT")){
		objParams.setParamValue("CommReqBoxSortField","LAST_ANS_DOC_SND_DT");
	}
 
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
  
	strSelectedAuditYear= objParams.getParamValue("AuditYear"); 	/**선택된 감사년도*/
	strSelectedCmtOrganID=objParams.getParamValue("CmtOrganID") ; /**선택된 위원회ID*/
	strRltdDuty=objParams.getParamValue("RltdDuty") ; 
	System.out.println("strSelectedAuditYear1 : "+objParams.getParamValue("AuditYear"));
	System.out.println("strSelectedCmtOrganID1 : "+objParams.getParamValue("CmtOrganID"));

	//요구함 객체 ※Delegate 선언※.
	CommRequestBoxDelegate objReqBox = null;
	CmtManagerConfirmDelegate cmtmanagerCn = new CmtManagerConfirmDelegate();
	ResultSetHelper objCmtRs=null;			/** 연도별 위원회 */
	ResultSetHelper objRs=null;			/** 위원회 요구함 목록 */
	ResultSetHelper objRltdDutyRs=null;   /** 업무구분 리스트 출력용 RsHelper */
	ResultSetHelper objReqOrganRS = null;				/** 위원회별 의원실 목록 */	

	String strReqOrganID = "";
 
	try {
		objReqBox=new CommRequestBoxDelegate();
 		if(objUserInfo.getOrganGBNCode().equals("004") && !strReqSubmitFlag.equals("004")){
			
		}else{
			if((StringUtil.getEmptyIfNull(objParams.getParamValue("ReqOrganIDZ"))).equals("")){
				String strSelfOrganID = (String)objUserInfo.getOrganID();
				objParams.setParamValue("ReqOrganIDZ",strSelfOrganID);
			}				
		}
		// 의원실 소속이고
		// 의원실 기관 ID가 전달되지 않은 상황이라면 
		// 세션에 있는 소속 의원실 ID를 세팅해서 조회하도록 한다.
		strReqOrganID = objParams.getParamValue("ReqOrganIDZ");
	
		if(!StringUtil.isAssigned(objParams.getParamValue("CommReqBoxSortField"))) {
			objParams.setParamValue("CommReqBoxSortField", "LAST_REQ_DOC_SND_DT");
		}
 	
		//해당위원회가 없을경우.. 
		if(objUserInfo.getCurrentCMTList().isEmpty()){
			List lst = objUserInfo.getCurrentCMTList();
			Hashtable objHash = new Hashtable();
			objHash.put("ORGAN_ID", "XXXXXXXXXX"); 	
			objHash.put("ORGAN_NM", "XXXXXXXXXX"); 	
			lst.add(objHash);

			objCmtRs=new ResultSetHelper(objReqBox.getReqrPerYearCMTList(lst,CodeConstants.REQ_ING_STT_001,CodeConstants.REQ_BOX_STT_001));   
		} else { 
			objCmtRs=new ResultSetHelper(objReqBox.getReqrPerYearCMTList(objUserInfo.getCurrentCMTList(),CodeConstants.REQ_ING_STT_002,CodeConstants.REQ_BOX_STT_007));   
		}
 		
 		//상태에 따라 목록 List출력..
		//CodeConstants.REQ_ING_STT_001 :: (String)request.getParameter("IngStt")

		if(objCmtRs.next() && !StringUtil.isAssigned(strSelectedAuditYear) && !StringUtil.isAssigned(strSelectedCmtOrganID)){
			System.out.println("HERE?");
	 		strSelectedAuditYear=(String)objCmtRs.getObject("AUDIT_YEAR");
	 		strSelectedCmtOrganID=(String)objCmtRs.getObject("CMT_ORGAN_ID");
		    objParams.setParamValueIfNull("AuditYear",strSelectedAuditYear);
		    objParams.setParamValueIfNull("CmtOrganID",strSelectedCmtOrganID); 		
			if(!StringUtil.isAssigned(strSelectedCmtOrganID)){
				objParams.setParamValue("CmtOrganID",objUserInfo.getOrganID());
			}   
   		}
		
		System.out.println("strSelectedAuditYear2 : "+objParams.getParamValue("AuditYear"));
		System.out.println("strSelectedCmtOrganID2 : "+objParams.getParamValue("CmtOrganID"));
   		objRs=new ResultSetHelper(objReqBox.getRecordList(objParams));
   		objRltdDutyRs=new ResultSetHelper(objCdinfo.getRelatedDutyList());
   
   		objReqOrganRS = new ResultSetHelper(objReqBox.getCmtReqOrganList(strSelectedCmtOrganID));
		strCmtOpenCl = cmtmanagerCn.getOpenCl((String)objParams.getParamValue("CmtOrganID")) == null ? "" : cmtmanagerCn.getOpenCl((String)objParams.getParamValue("CmtOrganID"));
      
	} catch(AppException objAppEx) {
	 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
	  	objMsgBean.setStrCode(objAppEx.getStrErrCode());
	  	objMsgBean.setStrMsg(objAppEx.getMessage());
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%  	
		return;
	}
 
	 //요구함 목록조회된 결과 반환.
	 int intTotalRecordCount=objRs.getTotalRecordCount();
	 int intCurrentPageNum=objRs.getPageNumber();
	 int intTotalPage=objRs.getTotalPageCount();
%>

<html>
<head>
<title><%=MenuConstants.REQUEST_BOX_COMM%> > <%=MenuConstants.COMM_REQ_BOX_SUBMT_END%></title>
<link href="/css/System.css" rel="stylesheet" type="text/css">
<script language="javascript">
<%
	//콤보 박스에 자료 넣기위해 Array에 테이터 넣어주는 부분.
    out.println("var varSelectedYear='" + strSelectedAuditYear + "';");
    out.println("var varSelectedCmt='" + strSelectedCmtOrganID + "';");
	out.println("var arrPerYearCmt=new Array(" + objCmtRs.getTotalRecordCount() + ");");
	Vector vectorYear=new Vector();
	String strTmpYear="";
	String strOldYear="";
	objCmtRs.first();
	for(int i=0;objCmtRs.next();i++){
	  	strTmpYear=(String)objCmtRs.getObject("AUDIT_YEAR");
	    out.println("arrPerYearCmt[" + i + "]=new Array('" 
			+ strTmpYear	+ "','" + objCmtRs.getObject("CMT_ORGAN_ID") + "','" + objCmtRs.getObject("CMT_ORGAN_NM") + "');");
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
   
	/** 위원회 연도 초기화 */
	function init(){
		var field=listqry.AuditYear;
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
  	}
	
	/** 연도별 위원회 리스트 초기화 */
	function makePerYearCmtList(strYear){
    	var field=listqry.CmtOrganID;
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
  	}
  	
	/** 연도 변화에 따른 위원회 리스트 변화 */
	function changeCmtList(){
    	makePerYearCmtList(listqry.AuditYear.options[listqry.AuditYear.selectedIndex].value);
  	}
  	
	/** 정렬방법 바꾸기 */
	function changeSortQuery(sortField,sortMethod){
  		listqry.CommReqBoxSortField.value=sortField;
  		listqry.CommReqBoxSortMtd.value=sortMethod;
  		listqry.submit();
  	}
  
  	//요구함상세보기로 가기.
  	function gotoDetail(strID){
  		listqry.ReqBoxID.value=strID;
  		listqry.action="./RSubEndBoxVList.jsp";
  		listqry.submit();
  	}
  
  	/** 페이징 바로가기 */
	function goPage(strPage){
  		listqry.CommReqBoxPage.value=strPage;
		listqry.target = '';
  		listqry.submit();
  	}
  
  	/**년도와 위원회로만 조회하기 */
  	function gotoHeadQuery(){
  		listqry.CommReqBoxQryField.value="";
  		listqry.CommReqBoxQryTerm.value="";
  		listqry.CommReqBoxSortField.value="";
  		listqry.CommReqBoxSortMtd.value="";
  		listqry.CommReqBoxPage.value="";
  		listqry.submit();
  	}
  	
	// 조회 옵션에 따른 Form submit 만 수행
	function doListRefresh() {
		var f = document.listqry;
		f.target = "";
		f.submit();
	}  
</script>
</head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onload="init()">
<%@ include file="/reqsubmit/common/MenuTopReqsubmit.jsp" %>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
<tr align="left" valign="top">
	<td width="186" height="470" background="/image/common/bg_leftMenu.gif">
	<%@ include file="/reqsubmit/common/MenuLeftReqsubmit.jsp" %></td>
<!------- 2004-06-02 디자인 수정으로 인해 변경된 부분 시작 ------->
	<td width="100%">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
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
			<form name="listqry" method="post" action="<%=request.getRequestURI()%>">
			<%//정렬 정보 받기.
				String strCommReqBoxSortField=objParams.getParamValue("CommReqBoxSortField");
				String strCommReqBoxSortMtd=objParams.getParamValue("CommReqBoxSortMtd");
			%>
			<input type="hidden" name="CommReqBoxSortField" value="<%=strCommReqBoxSortField%>"><!--요구함목록정렬필드 -->
			<input type="hidden" name="CommReqBoxSortMtd" value="<%=strCommReqBoxSortMtd%>">	<!--요구함목록정령방법-->
			<input type="hidden" name="CommReqBoxPage" value="<%=intCurrentPageNum%>">			<!--페이지 번호 -->
			<input type="hidden" name="ReqBoxID" value="">		<!--요구함 ID -->							
			<input type="hidden" name="CommOrganID" value="">	<!--위원회기관 ID -->
			<input type="hidden" name="IngStt" value="">		<!--요구일정 진행상 -->
			<input type="hidden" name="OpenCl" value="<%=strCmtOpenCl%>">

        <tr> 
        	<td align="left" valign="top">
        	<table width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td colspan="3" height="23px">
			</tr>
            <tr> 
            	<td width="30%" background="/image/reqsubmit/bg_reqsubmit_tit.gif" height="23">
                	<!-------------------- 타이틀을 입력해 주세요 ------------------------>
                	<span class="title"><%=MenuConstants.COMM_REQ_BOX_SUBMT_END%></span> <strong>- 요구함 목록</strong>
                </td>
                <td width="15%" align="left" background="/image/common/bg_titLine.gif">&nbsp;</td>
                <td width="55%" align="right" background="/image/common/bg_titLine.gif" class="text_s">
				<!-------------------- 현재 위치 정보를 기술한답니다. ------------------------>
					<img src="/image/common/icon_navi.gif" width="3" height="5" align="absmiddle"> 
                    <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.REQUEST_BOX_COMM%> > <B><%=MenuConstants.COMM_REQ_BOX_SUBMT_END%></B>
                </td>
			</tr>
			</table></td>
		</tr>
		<tr> 
			<td height="30" align="left" class="text_s">
            <!-------------------- 현재 페이지에 대한 설명 기술 ------------------------>
            제출기관으로부터 답변제출완료된 요구함 목록을 확인하실 수 있습니다.
			</td>
		</tr>
		
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
              							<td width="200" height="24"><img src="/image/reqsubmit/searchTableTop2.jpg" border="0"></td>
              							<td width="546" align="right" valign="bottom">
              								&nbsp;&nbsp;<img src="/image/common/icon_nemo_gray.gif" width="3" height="6" align="absmiddle">
											전체 자료 수 : <%=intTotalRecordCount%>개 (<%=intCurrentPageNum%> / <%=intTotalPage%> Page)
              							</td>
              						</tr>
									<tr>
										<td height="29" colspan="2">
											<table border="0" cellpadding="0" cellspacing="0">
												<tr><td style="padding-left:25px">
													<select name="AuditYear" onChange="changeCmtList()" class="select_reqsubmit" onChange="javascript:doListRefresh()"></select>
					                				<select name="CmtOrganID" class="select_reqsubmit" onChange="javascript:doListRefresh()"></select>
					                				<select name="ReqOrganIDZ" class="select_reqsubmit" onChange="javascript:doListRefresh()">
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
													</select>
													<select name="RltdDuty"  class="select_reqsubmit" onChange="javascript:doListRefresh()">
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
												<td>&nbsp;&nbsp;<img src="/image/button/bt_inquiry.gif" height="20"  style="cursor:hand" onClick="gotoHeadQuery();"></td>
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
			<table width="759" border="0" cellspacing="0" cellpadding="0">
        	<tr> 
          		<td height="2" colspan="6" class="td_reqsubmit"></td>
            </tr>
            <tr align="center" class="td_top"> 
	          	<td width="34" align="center" height="22">NO</td>
        	  	<td width="330"><%=SortingUtil.getSortLink("changeSortQuery","REQ_BOX_NM",strCommReqBoxSortField,strCommReqBoxSortMtd,"요구함명")%></td>
              	<td width="175"><%=SortingUtil.getSortLink("changeSortQuery","SUBMT_ORGAN_NM",strCommReqBoxSortField,strCommReqBoxSortMtd,"제출기관")%></td>
             	<td width="80" align="center">제출/요구</td>
             	<td width="70"><%=SortingUtil.getSortLink("changeSortQuery","LAST_REQ_DOC_SND_DT",strCommReqBoxSortField,strCommReqBoxSortMtd, "발송일시")%></td>				
              	<td width="70" align="center"><%=SortingUtil.getSortLink("changeSortQuery","LAST_ANS_DOC_SND_DT",strCommReqBoxSortField,strCommReqBoxSortMtd, "제출일시")%></td>
	        </tr>
    	    <tr> 
        	  	<td height="1" colspan="6" class="td_reqsubmit"></td>
        	</tr>
  			<%
			String strRecordNumber = request.getParameter("RecordNumber");
			int intRecordNumber=0;
			if(intCurrentPageNum == 1){
				intRecordNumber= intTotalRecordCount;
			} else {
				intRecordNumber= java.lang.Integer.parseInt(strRecordNumber);
			}
			intRecordNumber = intTotalRecordCount - ((intCurrentPageNum -1) * Integer.parseInt((String)objParams.getParamValue("CommReqBoxPageSize")));
			if(objRs.getRecordSize()>0){
				String strReqBoxID="";
			  	String strCommOrganID="";
			  		
			  	while(objRs.next()){
			  		strReqBoxID=(String)objRs.getObject("REQ_BOX_ID");
			  	 	strCommOrganID=(String)objRs.getObject("CMT_ORGAN_ID");
			 %>
            <tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''"> 
              	<td width="34" align="center" height="20"><%= intRecordNumber %></td>
    	      	<td width="330" class="td_lmagin"><a href="javascript:gotoDetail('<%=strReqBoxID%>')"><%=(String)objRs.getObject("REQ_BOX_NM")%></a></td>
        	  	<td width="175" class="td_lmagin"><%=(String)objRs.getObject("SUBMT_ORGAN_NM")%></td>
          		<td width="80" class="td_lmagin" align="center"><%=objRs.getObject("SUBMT_CNT")%> / <%=objRs.getObject("REQ_CNT")%></td>
          		<td width="70" class="td_lmagin" align="right"><%= StringUtil.getDate2((String)objRs.getObject("LAST_REQ_DOC_SND_DT"))%></td>        	  	
              	<td width="70" class="td_lmagin" align="right" style="padding-top:2px;padding-bottom:2px"><%=StringUtil.getDate2((String)objRs.getObject("LAST_ANS_DOC_SND_DT"))%></td>
            </tr>
            <tr class="tbl-line"> 
          		<td height="1" colspan="6"></td>
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
				<td colspan="6" height="40" align="center">등록된 요구함이 없습니다.</td>
			</tr>
			<%
				} // end if
			%>
            <tr class="tbl-line"> 
          		<td height="2" colspan="6"></td>
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
					objParams.getParamValue("CommReqBoxPageSize"))
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
          		<td width="256" height="40">
          		<!-- 버튼이 필요하다면 여기에 추가하심 됩니다용 -->
          		</td>
          		<td width="503" align="right" valign="middle">
          		<%
				String strCommReqBoxQryField=objParams.getParamValue("CommReqBoxQryField");
				%>
				<select name="CommReqBoxQryField"  class="select">
					<option <%=(strCommReqBoxQryField.equalsIgnoreCase("req_box_nm"))? " selected ": ""%>value="req_box_nm">요구함명</option>
					<option <%=(strCommReqBoxQryField.equalsIgnoreCase("req_box_dsc"))? " selected ": ""%>value="req_box_dsc">요구함설명</option>
					<option <%=(strCommReqBoxQryField.equalsIgnoreCase("submt_organ_nm"))? " selected ": ""%>value="submt_organ_nm">제출기관</option>
				</select>
				<input type="text" name="CommReqBoxQryTerm" value="<%=objParams.getParamValue("CommReqBoxQryTerm")%>"  class="textfield" style="WIDTH:180px">
				<img src="/image/common/bt_search_table.gif" width="51" height="18" align="absmiddle" onClick="listqry.submit()" style="cursor:hand">
				</td>	
        	</tr>
			</table>
			</td>
		</tr>
              
        <!------------------------- 또 TAB을 두고 싶으시면 위의 소스들을 복사해서 이 곳에 붙여넣기 해서 수정하세요 ------------------------->
        <!----- [주의] TAB <tr> 과 그 밑에 내용을 구성하는 <tr>을 잘 구분해서 잘 챙겨 주시어요. 나으리.. -------->
        <tr>
        	<td height="35px"></td>
        </tr>
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