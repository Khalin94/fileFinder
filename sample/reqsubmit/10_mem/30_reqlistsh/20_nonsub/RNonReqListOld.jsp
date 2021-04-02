<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.bf.config.*"%>
<%@ page import="kr.co.kcc.pf.util.PageCount"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.params.requestinfo.RMemReqInfoListForm" %>
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
	/**선택된 감사년도와 선택된 위원회ID*/
	String strSelectedAuditYear= null; /**선택된 감사년도*/
	String strSelectedCmtOrganID=null; /**선택된 위원회ID*/
	String strRltdDuty=null; 			 /**선택된 업무구분 */
	String strCmtReqAppFlag=null;	/** 선택된 위원회 제출신청 */
	
	/**일반 요구함 상세보기 파라미터 설정.*/
	RMemReqInfoListForm objParams =new RMemReqInfoListForm();  
	objParams.setParamValue("ReqStt",CodeConstants.REQ_STT_NOT);/**미제출 요구정보목록.*/
	objParams.setParamValue("ReqOrganID",objUserInfo.getOrganID());/**요구기관ID*/
	objParams.setParamValue("ReqInfoSortField","last_req_dt");/**최종요구일자이 Default*/
	objParams.setParamValue("IsRequester",String.valueOf(objUserInfo.isRequester()));//요구답변자여부설정
	  
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
	}//endif
  
	strSelectedAuditYear= objParams.getParamValue("AuditYear"); /**선택된 감사년도*/
	strSelectedCmtOrganID=objParams.getParamValue("CmtOrganID") ; /**선택된 위원회ID*/
	strRltdDuty=objParams.getParamValue("RltdDuty") ; 			 /**선택된 업무구분 */
	strCmtReqAppFlag=objParams.getParamValue("CmtReqAppFlag");	/** 선택된 위원회 제출신청 */

	/*************************************************************************************************/
	/** 					데이터 호출 Part 														  */
	/*************************************************************************************************/
	
	/*** Delegate 과 데이터 Container객체 선언 */
	MemRequestBoxDelegate objReqBox=null; 		/**요구함 Delegate*/
	MemRequestInfoDelegate  objReqInfo=null;	/** 요구정보 Delegate */
	CmtSubmtReqBoxDelegate objCmtSubmt = null;
	 
	ResultSetHelper objRs=null;				/**요구 목록 */
	ResultSetHelper objCmtRs=null;			/** 연도별 위원회 */
	ResultSetHelper objRltdDutyRs=null;   /** 업무구분 리스트 출력용 RsHelper */
	try{
		/**요구함 정보 대리자 New */
		objReqBox=new MemRequestBoxDelegate();
		objCmtRs=new ResultSetHelper(objReqBox.getReqrPerYearCMTList(objUserInfo.getOrganID(),null));   
		objCmtSubmt = new CmtSubmtReqBoxDelegate();
		
		/** 파라미터로 받은 정보가 없을 경우 리스트에서 가져옴.*/
		//if(objCmtRs.next() && !StringUtil.isAssigned(strSelectedAuditYear) && !StringUtil.isAssigned(strSelectedCmtOrganID)){
		if(objCmtRs.next() && !StringUtil.isAssigned(strSelectedAuditYear)){
			strSelectedAuditYear=(String)objCmtRs.getObject("AUDIT_YEAR");
			//strSelectedCmtOrganID=(String)objCmtRs.getObject("CMT_ORGAN_ID");
			objParams.setParamValueIfNull("AuditYear",strSelectedAuditYear);
			objParams.setParamValueIfNull("CmtOrganID",strSelectedCmtOrganID); 		
		}
		
		/**요구 정보 대리자 New */    
		objReqInfo=new MemRequestInfoDelegate();
		objRs=new ResultSetHelper(objReqInfo.getRecordList(objParams));
		objRltdDutyRs=new ResultSetHelper(objCdinfo.getRelatedDutyList());
	}catch(AppException objAppEx){
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		objMsgBean.setStrCode(objAppEx.getStrErrCode());
		objMsgBean.setStrMsg(objAppEx.getMessage());
		//out.println("<br>Error!!!" + objAppEx.getMessage());
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%  	
		return;
	}

	/**요구정보 목록조회된 결과 반환.*/
	int intTotalRecordCount=objRs.getTotalRecordCount();
	int intCurrentPageNum=objRs.getPageNumber();
	int intTotalPage=objRs.getTotalPageCount();	
%>

<html>
<head>
<title><%=MenuConstants.getReqBoxGeneral(request)%> > <%=MenuConstants.REQ_INFO_LIST%></title>
<link href="/css/System.css" rel="stylesheet" type="text/css">
<script language="javascript">
<%
 	//콤보 박스에 자료 넣기위해 Array에 테이터 넣어주는 부분.
    out.println("var varSelectedYear='" + strSelectedAuditYear + "';");
    out.println("var varSelectedCmt='" + strSelectedCmtOrganID + "';");
	out.println("var arrPerYearCmt=new Array(" + (objCmtRs.getTotalRecordCount()+1) + ");");
	Vector vectorYear=new Vector();
	String strTmpYear="";
	String strOldYear="";

	out.println("arrPerYearCmt[0]=new Array('"+strSelectedAuditYear+"','','::: 전체 위원회 요구 목록 :::');");

	objCmtRs.first();
	for(int i=0;objCmtRs.next();i++){
	//for(int i=0; i<objCmtRs.getTotalRecordCount(); i++) {
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
  	formName.ReqInfoSortField.value=sortField;
  	formName.ReqInfoSortMtd.value=sortMethod;
  	formName.submit();
  }
  
  //요구함상세보기로 가기.
  function gotoDetail(strID){
  	formName.ReqInfoID.value=strID;
  	formName.action="./RNonReqVList.jsp";
  	formName.submit();
  }
  
  /** 페이징 바로가기 */
  function goPage(strPage){
  	formName.ReqInfoPage.value=strPage;
  	formName.submit();
  }  
  
  /**년도와 위원회로만 조회하기 */
  function gotoHeadQuery(){
  	formName.ReqInfoQryField.value="";
  	formName.ReqInfoQryTerm.value="";
  	formName.ReqInfoSortField.value="";
  	formName.ReqInfoSortMtd.value="";
  	formName.ReqInfoPage.value="";
  	formName.submit();
  }
</script>
<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0"  onload="init()">

<SCRIPT language="JavaScript" src="/js/reqsubmit/tooltip.js"></SCRIPT>
<div id="balloonHint" style="display:none;height:60px"> 
<table border="0" cellspacing="0" cellpadding="4"> 
	<tr>
		<td bgcolor="#EBF2F5" width="30" height="20" align="center" style="border-left:1px solid #808080;border-top:1px solid #808080;border-bottom:2px solid #808080;"><font style="font-size:11px;font-family:verdana,돋움;font-weight:bold">요구<BR>상세<BR>내용</font></td>
		<td style="border-left:1px solid #808080;border-top:1px solid #808080;border-bottom:2px solid #808080;border-right:2px solid #808080;text-align:justify;word-break:break-all;" width="220">
			<font style="font-size:11px;font-family:verdana,돋움">{{hint}}</font>
		</td>
	</tr> 
</table> 
</div> 
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
          <form name="formName" method="get" action="<%=request.getRequestURI()%>">
          <%
			//요구 정보 정렬 정보 받기.
			String strReqInfoSortField=objParams.getParamValue("ReqInfoSortField");
			String strReqInfoSortMtd=objParams.getParamValue("ReqInfoSortMtd");
			//요구 정보 페이지 번호 받기.
			String strReqInfoPagNum=objParams.getParamValue("ReqInfoPage");
		  %>
			  <input type="hidden" name="ReqInfoSortField" value="<%=strReqInfoSortField%>"><!--요구정보 목록정렬필드 -->
			  <input type="hidden" name="ReqInfoSortMtd" value="<%=strReqInfoSortMtd%>"><!--요구정보 목록정령방법-->
			  <input type="hidden" name="ReqInfoPage" value="<%=strReqInfoPagNum%>"><!--요구정보 페이지 번호 -->
			  <input type="hidden" name="ReqInfoID" value=""><!--요구정보 ID-->
			  <input type="hidden" name="ReturnUrl" value="<%=request.getRequestURI()%>"><!--되돌아올 URL -->			  
              <tr> 
                <td height="23" align="left" valign="top"></td>
              </tr>
              <tr> 
                <td height="23" align="left" valign="top"><table width="100%" height="23" border="0" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="25%" background="/image/reqsubmit/bg_reqsubmit_tit.gif">
                      		<!-------------------- 타이틀을 입력해 주세요 ------------------------>
                      		<span class="title"><%=MenuConstants.REQ_INFO_LIST_SUBMT_NONE%></span>
                      </td>
                      <td width="16%" align="left" background="/image/common/bg_titLine.gif">&nbsp;</td>
                      <td width="59%" align="right" background="/image/common/bg_titLine.gif" class="text_s">
                      		<!-------------------- 현재 위치 정보를 기술한답니다. ------------------------>
                      		<img src="/image/common/icon_navi.gif" width="3" height="5" align="absmiddle"> 
                        <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.getReqBoxGeneral(request)%> > <%=MenuConstants.REQ_INFO_LIST%> > <B><%=MenuConstants.REQ_INFO_LIST_SUBMT_NONE%></B>
                      </td>
                    </tr>
                  </table></td>
              </tr>
              <tr> 
                <td height="30" align="left" class="text_s">
                		<!-------------------- 현재 페이지에 대한 설명 기술 ------------------------>
                		제출기관에서의 제출이 진행 중인 요구 목록입니다.
                </td>
              </tr>
              <tr> 
                <td height="2"></td>
              </tr>
              
              <!---------------------------------------------------------------------- 재정의된 조회 조건 라인 시작 ------------------------------------------------------------------------>
              <tr>
              	<td width="759">
              		<table border="0" cellpadding="0" cellspacing="0">
              			<tr>
              				<td width="6" height="53"><img src="/image/reqsubmit/searchTableLeft.jpg" border="0"></td>
              				<td width="746" height="53" background="/image/reqsubmit/searchTableBg.jpg">
              					<table border="0" cellpadding="0" cellspacing="0" width="746">
              						<tr>
              							<td width="200" height="24"><img src="/image/reqsubmit/searchTableTop.jpg" border="0"></td>
              							<td width="546" align="right" valign="bottom">
              								<!------------------------- COUNT (PAGE) ------------------------------------>
							            	&nbsp;&nbsp;<img src="/image/common/icon_nemo_gray.gif" width="3" height="6" align="absmiddle">
							            	전체 자료 수 : <%=intTotalRecordCount%>개 (<%=intCurrentPageNum%> / <%=intTotalPage%> Page)&nbsp;&nbsp;
              							</td>
              						</tr>
									<tr>
										<td height="29" colspan="2">
											<table border="0" cellpadding="0" cellspacing="0">
												<tr><td style="padding-left:25px">
													<select name="AuditYear" onChange="changeCmtList()" class="select_reqsubmit"></select>
					                				<select name="CmtOrganID" class="select_reqsubmit" onChange="this.form.submit()"></select>                						
													<select name="RltdDuty"  class="select_reqsubmit">
														<option value="">업무구분(전체)</option>
													<%
													   /**업무구분 리스트 출력 */
													   while(objRltdDutyRs!=null && objRltdDutyRs.next()){
													   		String strCode=(String)objRltdDutyRs.getObject("MSORT_CD");
													   		out.println("<option value=\"" + strCode + "\" " + StringUtil.getSelectedStr(strRltdDuty,strCode) + ">" + objRltdDutyRs.getObject("CD_NM") + "</option>");
													   }
													%>													
													</select>
													<%
														if(objUserInfo.getOrganGBNCode().equals("003")){//의원실소속
													%>
													<select name="CmtReqAppFlag"  class="select_reqsubmit">
													   <option value="">위원회신청(전체)</option>
													   <option <%=(strCmtReqAppFlag.equalsIgnoreCase(CodeConstants.CMT_REQ_APP_FLAG_MEM))? " selected ": ""%>value="<%=CodeConstants.CMT_REQ_APP_FLAG_MEM%>"><%=CodeConstants.CMT_REQ_APP_FLAG_MEM_NM%></option>
													   <option <%=(strCmtReqAppFlag.equalsIgnoreCase(CodeConstants.CMT_REQ_APP_FLAG_ING))? " selected ": ""%>value="<%=CodeConstants.CMT_REQ_APP_FLAG_ING%>"><%=CodeConstants.getCmtRequestAppoint(CodeConstants.CMT_REQ_APP_FLAG_ING)%></option>
													   <option <%=(strCmtReqAppFlag.equalsIgnoreCase(CodeConstants.CMT_REQ_APP_FLAG_CMT))? " selected ": ""%>value="<%=CodeConstants.CMT_REQ_APP_FLAG_CMT%>"><%=CodeConstants.getCmtRequestAppoint(CodeConstants.CMT_REQ_APP_FLAG_CMT)%></option>
													</select>
													<%
														}//endif의원실소속확인
													%>
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
                      		<td height="2" class="td_reqsubmit"></td>
	                    </tr>
	                    <tr align="center" class="td_top">
	                    	<td>
	                    		<table width="759" border="0" cellspacing="0" cellpadding="0">
									<tr class="td_top">
									    <%
											int intTmpWidth1= 529;
											if(objUserInfo.getOrganGBNCode().equals("003")){//의원실소속
										%>
										<td  width="15" align="center"><input type="checkbox" name="checkAll" onClick="checkAllOrNot(document.formName);"></td>									
										<%
												intTmpWidth1=intTmpWidth1-20;
											}//endif의원실소속확인
										%>
										<td height="22" width="35" align="center">NO</td>
										<td width="<%=intTmpWidth1%>" align="center"><%=SortingUtil.getSortLink("changeSortQuery","REQ_CONT",strReqInfoSortField,strReqInfoSortMtd,"요구제목")%></td>
										<td width="60" align="center"><%=SortingUtil.getSortLink("changeSortQuery","REQ_BOX_NM",strReqInfoSortField,strReqInfoSortMtd,"요구함")%></td>
										<td width="70" align="center"><%=SortingUtil.getSortLink("changeSortQuery","SUBMT_DLN",strReqInfoSortField,strReqInfoSortMtd,"제출기한")%></td>
										<td width="70" align="center"><%=SortingUtil.getSortLink("changeSortQuery","LAST_REQ_DT",strReqInfoSortField,strReqInfoSortMtd,"요구일시")%></td>
									</tr>
	                    		</table>
	                    	</td>
	                    </tr>
                	    <tr> 
                    	  	<td height="1" class="td_reqsubmit"></td>
                    	</tr>
						<%
						  int intRecordNumber=intTotalRecordCount - ((intCurrentPageNum -1) * Integer.parseInt((String)objParams.getParamValue("ReqInfoPageSize")));
						  String strReqInfoID="";
						  String strCmtApplyValue="Y";						  
						  while(objRs.next()){
						   	 strReqInfoID=(String)objRs.getObject("REQ_ID");
						   	 /** 위원회신청가능한지(Y) 아닌지 "" 결정*/
							if(CodeConstants.isDuplatedApplyToCmtReq((String)objRs.getObject("CMT_REQ_APP_FLAG"))){
								strCmtApplyValue="";
							}else{
								strCmtApplyValue="Y";
							}						   	 
						 %>								
						<tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''">
							<td>
								<table width="759" border="0" cellspacing="0" cellpadding="0">
									<tr>
									    <%
											int intTmpWidth2 = 529;
											if(objUserInfo.getOrganGBNCode().equals("003")){//의원실소속
										%>									
										<td width="15" align="center"><input type="checkbox" name="ReqInfoIDs" value="<%=strReqInfoID%>"></td>									
										<%
												intTmpWidth2=intTmpWidth2-20;
											}
										%>										
										<td height="22" width="35" align="center"><%=intRecordNumber%></td>
										<td width="<%=intTmpWidth2%>" class="td_lmagin">&nbsp;&nbsp;<%=StringUtil.getNotifyImg((String)objRs.getObject("REG_DT"),(String)objRs.getObject("REQ_STT"))%><a href="JavaScript:gotoDetail('<%=strReqInfoID%>');" hint="<%= StringUtil.substring((String)objRs.getObject("REQ_DTL_CONT"), 100) %> ..."><%=(String)objRs.getObject("REQ_CONT")%></a></td>
										<td width="60" align="center"><a href="<%=nads.dsdm.app.reqsubmit.delegate.requestinfo.RequestInfoDelegate.getGotoMemReqBoxURLReqr((String)objRs.getObject("REQ_BOX_STT"))%>?ReqBoxID=<%=objRs.getObject("REQ_BOX_ID")%>" hint="<%= StringUtil.ReplaceString((String)objRs.getObject("REQ_BOX_NM"), "'", "") %> 요구함 으로 이동"><img src="/image/reqsubmit/icon_secretariat.gif" border="0" alt="<%=objRs.getObject("REQ_BOX_NM")%> 바로가기"></a></td>
										<td width="70" align="right" style="padding-top:2px;pading-bottom:2px;padding-right:2px"><%=StringUtil.getDate((String)objRs.getObject("SUBMT_DLN"))%> 24:00 </td>
										<td width="70" align="right" style="padding-top:2px;pading-bottom:2px;padding-right:2px"><%=StringUtil.getDate2((String)objRs.getObject("LAST_REQ_DT"))%> </td>
										<input type="hidden" name="CmtApplys" value="<%=strCmtApplyValue%>">
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
						%>
						<%
						/*조회결과 없을때 출력 시작.*/
						if(objRs.getRecordSize()<1){
						%>
						<tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''">
						    <td align="center" height="35" >등록된 요구정보가 없습니다.</td>
						</tr>
						<%
							}
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
                      		<td width="256" height="40">
                      			<!-- 버튼이 필요하다면 여기에 추가하심 됩니다용 -->
								<%
									// 2005-08-30 kogaeng EDIT
									// 갖은 조건들을 하나로 정리한다.
                      			 	if(objRs.getRecordSize() > 0 && objUserInfo.getOrganGBNCode().equals("003") && objUserInfo.getIsMyCmtOrganID(strSelectedCmtOrganID) && !objCmtSubmt.checkCmtOrganMakeAutoSche(strSelectedCmtOrganID)){
								%>
									<!-- 위원회 제출 신청 -->
                      				<img src="/image/button/bt_formalReqSelsct.gif" height="20"  style="cursor:hand" onClick="ApplyCmt(document.formName);"  alt="선택된 요구정보를 위원회명의로 제출기관에게 보내기위해 신청함에 추가합니다.">
                      			<%
                      				}
								%>
                      		</td>
							<td width="503" align="right" valign="middle">
							<%
								String strReqInfoQryField=(String)objParams.getParamValue("ReqInfoQryField");
							%>
								<select name="ReqInfoQryField" class="select">
									<option <%=(strReqInfoQryField.equalsIgnoreCase("req_cont"))? " selected ": ""%>value="req_cont">요구제목</option>
									<option <%=(strReqInfoQryField.equalsIgnoreCase("req_dtl_cont"))? " selected ": ""%>value="req_dtl_cont">요구내용</option>
									<option <%=(strReqInfoQryField.equalsIgnoreCase("req_box_nm"))? " selected ": ""%>value="req_box_nm">요구함명</option>
									<option <%=(strReqInfoQryField.equalsIgnoreCase("submt_organ_nm"))? " selected ": ""%>value="submt_organ_nm">제출기관</option>
								</select>
								<input type="text" class="textfield" name="ReqInfoQryTerm" value="<%=objParams.getParamValue("ReqInfoQryTerm")%>">
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
                	