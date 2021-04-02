<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.pf.util.PageCount"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.params.requestbox.SCommReqBoxListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.SCommRequestBoxDelegate" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	UserInfoDelegate objUserInfo =null;
	CDInfoDelegate objCdinfo =null;
%>
<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>

<% 
	/*************************************************************************************************/
	/** 	name : SCommReqBoxList.jsp																  */
	/** 		   위원회 요구함 목록을 출력한다.													  */
	/** 		   요구일정이 있는 소속 위원회의 목록을 출력한다.										  */
	/*************************************************************************************************/
	 
	/**선택된 감사년도와 선택된 위원회ID*/
	String strSelectedAuditYear= null; /**선택된 감사년도*/
	String strSelectedCmtOrganID=null; /**선택된 위원회ID*/
	
	/**위원회목록조회용 파라미터 설정.*/
	SCommReqBoxListForm objParams=new SCommReqBoxListForm();

	//요구기관 설정 :: 소속 기관.
	objParams.setParamValue("SubmtOrganID",objUserInfo.getOrganID());
	//위원회 요구일정진행상태 : 접수완료
	objParams.setParamValue("IngStt",CodeConstants.REQ_ING_STT_002);
	//요구함 상태 : 발송완료
	objParams.setParamValue("ReqBoxStt",CodeConstants.REQ_BOX_STT_006);
	
	boolean blnParamCheck=false;
	/**전달된 파리미터 체크 */
	blnParamCheck=objParams.validateParams(request);
	if(blnParamCheck==false) {
	  	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
	  	objMsgBean.setStrCode("DSPARAM-0000");
	  	objMsgBean.setStrMsg(objParams.getStrErrors());
%>
  		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
  		return;
	}//endif
  
	strSelectedAuditYear= objParams.getParamValue("AuditYear"); 	/**선택된 감사년도*/
	strSelectedCmtOrganID=objParams.getParamValue("CmtOrganID") ; /**선택된 위원회ID*/

	//해당위원회가 없을경우.. 에러메세지 출력..
	if(objUserInfo.getCurrentCMTList().isEmpty()){
	  	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
	  	objMsgBean.setStrCode("DSDATA-0021");
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
  		return;
	}//endif

	//요구함 객체 ※Delegate 선언※.
	SCommRequestBoxDelegate objReqBox = null;
	ResultSetHelper objCmtRs=null;			/** 연도별 위원회 */
	ResultSetHelper objRs=null;			/** 위원회 요구함 목록 */
	ResultSetSingleHelper objRsSH = null;			/** 요구함 상세보기 정보 */
	System.out.println("222");
	try {
	 	objReqBox=new SCommRequestBoxDelegate();
	 	objCmtRs = new ResultSetHelper(objReqBox.getReqrPerYearCMTList(objUserInfo.getCurrentCMTList(), CodeConstants.REQ_ING_STT_002,CodeConstants.REQ_BOX_STT_006));   
		//상태에 따라 목록 List출력..
		//if(objCmtRs.next() && !StringUtil.isAssigned(strSelectedAuditYear) && !StringUtil.isAssigned(strSelectedCmtOrganID)){
		if(objCmtRs.next() && !StringUtil.isAssigned(strSelectedAuditYear)){
	 		strSelectedAuditYear=(String)objCmtRs.getObject("AUDIT_YEAR");
	 		//strSelectedCmtOrganID=(String)objCmtRs.getObject("CMT_ORGAN_ID");
		    objParams.setParamValueIfNull("AuditYear",strSelectedAuditYear);
		    objParams.setParamValueIfNull("CmtOrganID",strSelectedCmtOrganID);
		}
   
		objRs=new ResultSetHelper(objReqBox.getRecordList2(objParams));
		System.out.println("333");
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
<title><%=MenuConstants.REQUEST_BOX_COMM%> > <%=MenuConstants.COMM_REQ_BOX_MAKE%></title>
<link href="/css/System.css" rel="stylesheet" type="text/css">
<script language="javascript">
 <%
 	//콤보 박스에 자료 넣기위해 Array에 테이터 넣어주는 부분.
    out.println("var varSelectedYear='" + strSelectedAuditYear + "';");
    out.println("var varSelectedCmt='" + strSelectedCmtOrganID + "';");
	out.println("var arrPerYearCmt=new Array(" + objCmtRs.getTotalRecordCount() + ");");
	out.println("var arrPerYearCmt=new Array(" + (objCmtRs.getTotalRecordCount()+1) + ");");
	Vector vectorYear=new Vector();
	String strTmpYear="";
	String strOldYear="";
	
	out.println("arrPerYearCmt[0]=new Array('"+strSelectedAuditYear+"','','::: 전체 위원회 요구함 목록 :::');");
	
	objCmtRs.first();
	for(int i=0;objCmtRs.next();i++){
	  	strTmpYear=(String)objCmtRs.getObject("AUDIT_YEAR");
	    out.println("arrPerYearCmt[" +(i+1) + "]=new Array('" 
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
  	listqry.ReqBoxSortField.value=sortField;
  	listqry.ReqBoxSortMtd.value=sortMethod;
  	listqry.submit();
  }
  
  //요구함상세보기로 가기.
  function gotoDetail(strID){
  	listqry.ReqBoxID.value=strID;
  	listqry.action="./SCommReqBoxVList.jsp";
  	listqry.submit();
  }
  
  /** 페이징 바로가기 */
  function goPage(strPage){
  	listqry.ReqBoxPage.value=strPage;
  	listqry.submit();
  }
  
  /**년도와 위원회로만 조회하기 */
  function gotoHeadQuery(){
  	listqry.ReqBoxQryField.value="";
  	listqry.ReqBoxQryTerm.value="";
  	listqry.ReqBoxSortField.value="";
  	listqry.ReqBoxSortMtd.value="";
  	listqry.ReqBoxPage.value="";
  	listqry.submit();
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
				String strReqBoxSortField=objParams.getParamValue("ReqBoxSortField");
				String strReqBoxSortMtd=objParams.getParamValue("ReqBoxSortMtd");
			%>
			<input type="hidden" name="ReqBoxSortField" value="<%=strReqBoxSortField%>"><!--요구함목록정렬필드 -->
			<input type="hidden" name="ReqBoxSortMtd" value="<%=strReqBoxSortMtd%>">	<!--요구함목록정령방법-->
			<input type="hidden" name="ReqBoxPage" value="<%=intCurrentPageNum%>">			<!--페이지 번호 -->
			<input type="hidden" name="ReqBoxID" value="">		<!--요구함 ID -->							
			<input type="hidden" name="CommOrganID" value="">	<!--위원회기관 ID -->
			<input type="hidden" name="IngStt" value="">		<!--요구일정 진행상 -->
        <tr> 
        	<td align="left" valign="top">
        	<table width="100%" border="0" cellpadding="0" cellspacing="0">
            <tr>
				<td colspan="3" height="23px">
			</tr>
            <tr> 
            	<td width="25%" background="/image/reqsubmit/bg_reqsubmit_tit.gif" height="23">
                	<!-------------------- 타이틀을 입력해 주세요 ------------------------>
                	<span class="title"><%=MenuConstants.REQ_BOX_MAKE%></span> <strong>- 요구함 목록</strong>
                </td>
                <td width="16%" align="left" background="/image/common/bg_titLine.gif">&nbsp;</td>
                <td width="59%" align="right" background="/image/common/bg_titLine.gif" class="text_s">
				<!-------------------- 현재 위치 정보를 기술한답니다. ------------------------>
					<img src="/image/common/icon_navi.gif" width="3" height="5" align="absmiddle"> 
                    <%=MenuConstants.GOTO_HOME%> > <%= MenuConstants.REQ_SUBMIT_MAIN_MENU %> > <%= MenuConstants.REQUEST_BOX_COMM %> > <B><%=MenuConstants.REQ_BOX_MAKE%></B>
                </td>
			</tr>
			</table></td>
		</tr>
		<tr> 
			<td height="30" align="left" class="text_s">
            <!-------------------- 현재 페이지에 대한 설명 기술 ------------------------>
            답변 작성중인 요구함 목록을 확인하실 수 있습니다.
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
													<select name="AuditYear" onChange="changeCmtList()" class="select_reqsubmit"></select> 년도 
													<select name="CmtOrganID" class="select_reqsubmit" onChange="this.form.submit()"></select> 요구함 목록 
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
	          	<td width="39" height="22" align="center">NO</td>
        	  	<td width="320"><%=SortingUtil.getSortLink("changeSortQuery","REQ_BOX_NM",strReqBoxSortField,strReqBoxSortMtd,"요구함명")%></td>
               	<td width="170"><%=SortingUtil.getSortLink("changeSortQuery","REQ_ORGAN_NM", strReqBoxSortField, strReqBoxSortMtd, "소관위원회")%><BR>(의원실)</td>
               	<td width="80"><%=SortingUtil.getSortLink("changeSortQuery","RLTD_DUTY", strReqBoxSortField, strReqBoxSortMtd, "업무구분")%></td>
             	<td width="80" align="center">답변/요구</td>
               	<td width="70" align="center"><%=SortingUtil.getSortLink("changeSortQuery","LAST_REQ_DOC_SND_DT", strReqBoxSortField, strReqBoxSortMtd, "수신일시")%></td>
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
			if(objRs.getRecordSize()>0){
				String strReqBoxID="";
			  	String strCommOrganID="";
			  		
			  	while(objRs.next()){
			  		strReqBoxID=(String)objRs.getObject("REQ_BOX_ID");
			  	 	strCommOrganID=(String)objRs.getObject("CMT_ORGAN_ID");
					objRsSH = new ResultSetSingleHelper(objReqBox.getOldOrganName(strReqBoxID));
					
			 %>
            <tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''"> 					 
              	<td width="39" align="center" height="20"><%= intRecordNumber %></td>
    	      	<td width="320" class="td_lmagin"><a href="javascript:gotoDetail('<%=strReqBoxID%>')"><%=(String)objRs.getObject("REQ_BOX_NM")%></a></td>
          		<td width="170" class="td_lmagin"><%=objRs.getObject("REQ_ORGAN_NM")%><BR>(<%=objRsSH.getObject("OLD_REQ_ORGAN_NM")%>)</td>
          		<td width="80" class="td_lmagin"><%=objCdinfo.getRelatedDuty((String)objRs.getObject("RLTD_DUTY"))%></td>
              	<td width="80" class="td_lmagin" align="center"><%=(String)objRs.getObject("SUBMT_CNT")%> / <%=(String)objRs.getObject("REQ_CNT")%></td>
              	<td width="70" class="td_lmagin" align="right" style="padding-top:2px;padding-bottom:2px"><%=StringUtil.getDate2((String)objRs.getObject("LAST_REQ_DOC_SND_DT"))%></td>
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
            <tr class="tbl-line"> 
          		<td height="1" colspan="6"></td>
        	</tr>
			<%
				} // end if
			%>
            <tr class="tbl-line"> 
          		<td height="1" colspan="6"></td>
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
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
        	<tr> 
          		<td width="256" height="40">
          		<!-- 버튼이 필요하다면 여기에 추가하심 됩니다용 -->
          		</td>
          		<td width="503" align="right" valign="middle">
          		<%
				String strReqBoxQryField=objParams.getParamValue("ReqBoxQryField");
				%>
				<select name="ReqBoxQryField"  class="select">
					<option <%=(strReqBoxQryField.equalsIgnoreCase("req_box_nm"))? " selected ": ""%>value="req_box_nm">요구함명</option>
					<option <%=(strReqBoxQryField.equalsIgnoreCase("req_box_dsc"))? " selected ": ""%>value="req_box_dsc">요구함설명</option>
					<option <%=(strReqBoxQryField.equalsIgnoreCase("req_organ_nm"))? " selected ": ""%>value="req_organ_nm">요구기관</option>
				</select>
				<input type="text" name="ReqBoxQryTerm" value="<%=objParams.getParamValue("ReqBoxQryTerm")%>"  class="textfield" style="WIDTH:180px">
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