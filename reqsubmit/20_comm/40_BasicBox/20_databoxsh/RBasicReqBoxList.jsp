<%@ page language="java" contentType="text/html;charset=EUC-KR" %>

<%@ page import="java.util.*"%>
<%@ page import="java.util.List.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.bf.config.*"%>
<%@ page import="kr.co.kcc.pf.util.PageCount"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RPreReqBoxListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.prereqbox.PreRequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.prereqbox.SPreReqBoxDelegate" %>
<%@ page import="nads.dsdm.app.common.page.PagingDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%
	/*** PagingDelegate */
	PagingDelegate objPaging=new PagingDelegate(); 		/*페이징 변환 Delegate*/
%>
<%
 UserInfoDelegate objUserInfo =null;
 CDInfoDelegate objCdinfo =null;
%>
<%@ include file="../../../common/RUserCodeInfoInc.jsp" %>

<%!
	private static String getLocationTitle(String strTitle, String strLocation) {
		float fTitle =strTitle.length() * 1.8f;
		float fLocation=strLocation.length() * 1.2f;
		float fMiddle=100-(fLocation+fTitle);
		StringBuffer strReturnStr = new StringBuffer();
        strReturnStr.append("<table width="+"100%"+" height="+"23"+" border="+"0"+" cellpadding="+"0"+" cellspacing="+"0"+"> ");
        strReturnStr.append("<tr> ");
        strReturnStr.append("<td width="+fTitle+"%"+" background="+"/image/reqsubmit/bg_reqsubmit_tit.gif"+">");
        strReturnStr.append("<span class="+"title"+">"+strTitle+"</span>");
        strReturnStr.append("</td>");
        strReturnStr.append("<td width="+fMiddle+"%"+" align="+"left"+" background="+"/image/common/bg_titLine.gif"+">&nbsp;</td>");
        strReturnStr.append("<td width="+fLocation+"%"+" align="+"right"+" background="+"/image/common/bg_titLine.gif"+" class="+"text_s"+">");
        strReturnStr.append("<img src="+"/image/common/icon_navi.gif"+" width="+"3"+" height="+"5"+" align="+"absmiddle"+">&nbsp;"+strLocation+"</td>");
        strReturnStr.append("</tr>");
        strReturnStr.append("</table>");
		return strReturnStr.toString();
	}
%>


<%
 /*************************************************************************************************/
 /** 					파라미터 체크 Part 														  */
 /*************************************************************************************************/
  //로그인 사용자 정보를 가져온다. 권한없음 경우 관람만 가능하다.
  String strReqSubmitFlag = objUserInfo.getReqSubmitFlag();

  /**선택된 감사년도와 선택된 위원회ID*/
  String strSelectedAuditYear= null; /**선택된 감사년도*/
  String strSelectedCmtOrganID=null; /**선택된 위원회ID*/
  String strRltdDuty=null; 			 /**선택된 업무구분 */

  /**요구함 목록조회용 파라미터 설정.*/
  RPreReqBoxListForm objParams=new RPreReqBoxListForm();
  /**요구기관 설정 :: 소속 기관.*/

  /** 위원회 행정직원 일때만 화면에 출력함.*/

  if(objUserInfo.getOrganGBNCode().equals("003")){
  objParams.setParamValue("CmtOrganID",strSelectedCmtOrganID);
  }else{
  objParams.setParamValue("CmtOrganID",objUserInfo.getOrganID());
  }
  //해당위원회가 존재하지 않을 경우
  if(objUserInfo.getCurrentCMTList().isEmpty()){
  	objParams.setParamValue("CmtOrganID","XXXXXXXXXX");
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
  }//endif


  strSelectedAuditYear= objParams.getParamValue("AuditYear"); /**선택된 감사년도*/
  strSelectedCmtOrganID=objParams.getParamValue("CmtOrganID") ; /**선택된 위원회ID*/
  strRltdDuty=objParams.getParamValue("RltdDuty") ; 			 /**선택된 업무구분 */
  String strID = objUserInfo.getOrganID();
%>

<%
 /*************************************************************************************************/
 /** 					데이터 호출 Part 														  */
 /*************************************************************************************************/

 /*** Delegate 과 데이터 Container객체 선언 */
 PreRequestBoxDelegate objReqBox=null; 		/**요구함 Delegate*/

 SPreReqBoxDelegate selfDelegate = null; // 요구-제출부분 실시간으로 현황 보여준다 -by yan

 ResultSetHelper objRs=null;				/**요구함 목록 */
 ResultSetHelper objCmtRs=null;			/** 연도별 위원회 */
 ResultSetHelper objRltdDutyRs=null;   /** 업무구분 리스트 출력용 RsHelper */
 try{
   /**요구함 정보 대리자 New */
   objReqBox=new PreRequestBoxDelegate();
   selfDelegate = new SPreReqBoxDelegate(); //-by yan

	//해당위원회가 존재하지 않은 경우
	if(objUserInfo.getCurrentCMTList().isEmpty()){
		List lst = objUserInfo.getCurrentCMTList();
		Hashtable objHash = new Hashtable();
		objHash.put("ORGAN_ID", "XXXXXXXXXX");
		objHash.put("ORGAN_NM", "XXXXXXXXXX");
		lst.add(objHash);

		objCmtRs=new ResultSetHelper(objReqBox.getReqrPerYearCMTList(lst,null));
	} else {
		/*
		out.println("이용자의 위원회 목록 존재<BR>");
		List objList = objUserInfo.getCurrentCMTList();
		for(int z=0; z<objList.size(); z++) {
			Hashtable objHash = (Hashtable)objList.get(z);
			out.println(objHash.get("ORGAN_ID"));
			out.println(" : " + objHash.get("ORGAN_NM")+"<BR>");
			z++;
		}
		if (1==1) return;
		*/
	 	objCmtRs=new ResultSetHelper(objReqBox.getReqrPerYearCMTList(objUserInfo.getCurrentCMTList(),null));
 	} //endif

   //objCmtRs=new ResultSetHelper(objReqBox.getReqrPerYearCMTList(objUserInfo.getOrganID(),null));
   //objCmtRs=new ResultSetHelper(objReqBox.getReqrPerYearCMTList(objUserInfo.getCurrentCMTList(),null));

   /** 파라미터로 받은 정보가 없을 경우 리스트에서 가져옴.*/
   //if(objCmtRs.next() && !StringUtil.isAssigned(strSelectedAuditYear) && !StringUtil.isAssigned(strSelectedCmtOrganID)){

	if(objCmtRs.next() && !StringUtil.isAssigned(strSelectedAuditYear)){
 		strSelectedAuditYear = (String)objCmtRs.getObject("AUDIT_YEAR");
 		strSelectedCmtOrganID=(String)objCmtRs.getObject("CMT_ORGAN_ID");
	    objParams.setParamValueIfNull("AuditYear",strSelectedAuditYear);
	    objParams.setParamValueIfNull("CmtOrganID",strSelectedCmtOrganID);
   }

   objRs=new ResultSetHelper(objReqBox.getRecordList(objParams)); //요구함 목록
   objRltdDutyRs=new ResultSetHelper(objCdinfo.getRelatedDutyList());
 }catch(AppException objAppEx){
 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
	System.out.println("SysErrorCode:" + objAppEx.getStrErrCode());
  	objMsgBean.setStrCode("SYS-00010");//AppException에러.
  	objMsgBean.setStrMsg(objAppEx.getMessage());
  	//out.println("Error:" + objAppEx.getMessage());
  	%>
	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%
  	return;
 }
%>

<%
 /*************************************************************************************************/
 /** 					데이터 값 할당  Part 														  */
 /*************************************************************************************************/

 /**요구정보 목록조회된 결과 반환.*/
 int intTotalRecordCount=objRs.getTotalRecordCount();
 int intCurrentPageNum=objRs.getPageNumber();
 int intTotalPage=objRs.getTotalPageCount();
%>
<jsp:include page="/inc/header.jsp" flush="true"/>
<link href="/css2/style.css" rel="stylesheet" type="text/css">
<script language="javascript">
<!--
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
	  	/**기타위원회명 달리 표현하기 2004.06.04*/
	  	String strTmpCmtOrganNm=(String)objCmtRs.getObject("CMT_ORGAN_NM");
	  	String strTmpCmtOrganID=(String)objCmtRs.getObject("CMT_ORGAN_ID");
	  	if(objUserInfo.getIsMyCmtOrganID(strTmpCmtOrganID)==false){
	  	   strTmpCmtOrganNm=StringUtil.getOtherCmtOrganNm(strTmpCmtOrganNm);
	  	}
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
  	formName.submit();
  }
  //요구함상세보기로 가기.
  function gotoDetail(strID){
  	formName.ReqBoxID.value=strID;
  	formName.action="./RBasicReqBoxVList.jsp";
  	formName.submit();
  }
  /** 페지징 바로가기 */
  function goPage(strPage){
  	formName.ReqBoxPage.value=strPage;
  	formName.submit();
  }
  /**년도와 위원회로만 조회하기 */
  function gotoHeadQuery(){
  	formName.ReqBoxQryField.value="";
  	formName.ReqBoxQryTerm.value="";
  	formName.ReqBoxSortField.value="";
  	formName.ReqBoxSortMtd.value="";
  	formName.ReqBoxPage.value="";
  	formName.submit();
  }
 -->
</script>
</head>

<body onload="init()">
<div id="wrap">
  <jsp:include page="/inc/top.jsp" flush="true"/>
  <jsp:include page="/inc/top_menu02.jsp" flush="true"/>
  <div id="container">
    <div id="leftCon">
      <jsp:include page="/inc/log_info.jsp" flush="true"/>
      <jsp:include page="/inc/left_menu02.jsp" flush="true"/>
    </div>
    <div id="rightCon">
<form name="formName" method="get" action="<%=request.getRequestURI()%>">
		  <%//정렬 정보 받기.
			String strReqBoxSortField=objParams.getParamValue("ReqBoxSortField");
			String strReqBoxSortMtd=objParams.getParamValue("ReqBoxSortMtd");
		  %>
			<input type="hidden" name="ReqBoxSortField" value="<%=strReqBoxSortField%>"><!--요구함목록정렬필드 -->
			<input type="hidden" name="ReqBoxSortMtd" value="<%=strReqBoxSortMtd%>"><!--요구함목록정령방법-->
			<input type="hidden" name="ReqBoxPage" value="<%=intCurrentPageNum%>"><!--페이지 번호 -->

			<input type="hidden" name="ReqBoxID" value=""><!--요구함번호 일반적으로는 사용안됨-->

      <!-- pgTit -->
	            <%
                // 서브에 맨처음 나오는 타이틀명과 위치를 표시하는 테이블 바를 조정해주는 부분 -modify 06.29
                  String strTitle = MenuConstants.REQ_BOX_PRE;
				  String strLocation = MenuConstants.GOTO_HOME+" > "+MenuConstants.REQ_SUBMIT_MAIN_MENU+" > "+MenuConstants.REQUEST_BOX_COMM+" > "+MenuConstants.REQUEST_BOX_PRE+" > <B>"+MenuConstants.REQ_BOX_PRE+"</B>";
				%>
      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=strTitle%></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> <%=strLocation%></div>
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
            <select name="AuditYear" onChange="changeCmtList()"></select>
			<select name="CmtOrganID"></select>
			<select name="RltdDuty">
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
              <th scope="col" style="width:15px;"><%=SortingUtil.getSortLink("changeSortQuery","",strReqBoxSortField,strReqBoxSortMtd,"NO")%></th>
              <th scope="col" style="width:250px;"><%=SortingUtil.getSortLink("changeSortQuery","REQ_BOX_NM",strReqBoxSortField,strReqBoxSortMtd,"요구함명")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","SUBMT_ORGAN_NM",strReqBoxSortField,strReqBoxSortMtd,"제출기관")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","RLTD_DUTY",strReqBoxSortField,strReqBoxSortMtd,"업무구분")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","",strReqBoxSortField,strReqBoxSortMtd,"제출/요구")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","REG_DT",strReqBoxSortField,strReqBoxSortMtd,"등록일")%></th>
            </tr>
          </thead>
          <tbody>
		<%
		  int intRecordNumber=intTotalRecordCount;
		  if(objRs.getRecordSize()>0){
			String strReqBoxID="";
			while(objRs.next()){
			 strReqBoxID=(String)objRs.getObject("REQ_BOX_ID");

			 Hashtable countHash = (Hashtable)selfDelegate.getReqBoxRelateCount(strReqBoxID);
		 %>
            <tr>
              <td><%= intRecordNumber %></td>
              <td><a href="javascript:gotoDetail('<%=strReqBoxID%>')"><%=(String)objRs.getObject("REQ_BOX_NM")%></a></td>
              <td><%=(String)objRs.getObject("SUBMT_ORGAN_NM")%>
			  </td>
              <td><%=objCdinfo.getRelatedDuty((String)objRs.getObject("RLTD_DUTY"))%></td>
              <td><%=(String)objRs.getObject("SUBMT_CNT")%> / <%=(String)objRs.getObject("REQ_CNT")%></td>
              <td><%=StringUtil.getDate((String)objRs.getObject("REG_DT"))%></td>
            </tr>
			<%
					intRecordNumber --;
				}//endwhile
			}else{
			%>
			<tr>
				<td colspan="6" align="center">등록된 기초 요구 자료함이 없습니다.</td>
            </tr>
			<%
			}//end if 목록 출력 끝.
			%>
          </tbody>
        </table>

        <!-- /list -->
		<%=objPaging.pagingTrans(PageCount.getLinkedString(
							new Integer(intTotalRecordCount).toString(),
							new Integer(intCurrentPageNum).toString(),
							objParams.getParamValue("ReqBoxPageSize")))%>
        <!-- 페이징-->
         <!-- /페이징-->
        <!--  <p class="warning">* 요구서를 발송하게 되면 해당 제출 기관 대표 담당자에게 지정 발송되며, 담당자가 없는 경우는 작성 중 요구함에 그대로 남아있게 됩니다.  </p>
          <p class="warning">* 요구서 발송 버튼을 이용하시기 위해서는 위원회를 선택해 주시기 바랍니다.  </p>  -->



        <!-- 리스트 버튼-->
        <div id="btn_all" >        <!-- 리스트 내 검색 -->
        <div class="list_ser" >
		<%
			String strReqBoxQryField=objParams.getParamValue("ReqBoxQryField");
		%>
          <select name="ReqBoxQryField" class="selectBox5"  style="width:70px;" >
            <option <%=(strReqBoxQryField.equalsIgnoreCase("req_box_nm"))? " selected ": ""%>value="req_box_nm">요구함명</option>
			<option <%=(strReqBoxQryField.equalsIgnoreCase("req_box_nm"))? " selected ": ""%>value="req_box_dsc">요구함설명</option>
			<option <%=(strReqBoxQryField.equalsIgnoreCase("submt_organ_nm"))? " selected ": ""%>value="req_box_nm">제출기관</option>
          </select>
          <input name="ReqBoxQryTerm" onKeyDown="return ch()" onMouseDown="return ch()"
		 class="li_input"  style="width:100px" value="<%=objParams.getParamValue("ReqBoxQryTerm")%>"/>
          <img src="/images2/btn/bt_list_search.gif"  onMouseOver="menuOn(this);" onMouseOut="menuOut(this);" onClick="formName.submit();"/> </div>
        <!-- /리스트 내 검색 -->

		<span class="right">
		<%
		//권한 없음
		if(!strReqSubmitFlag.equals("004")){
		 /** 등록자와  로그인자가 같을때만 화면에 출력함.*/
		 if(objUserInfo.getOrganGBNCode().equals("004")){
		 %>
			<span class="list_bt"><a href="../10_databoxmk/RNewPreBoxMake.jsp">요구함 작성</a></span>
		<% }//end if-getOrganGBNCode()
		}// end if  권한 없음  %>
		</span>
		</div>

        <!-- /리스트 버튼-->

        <!-- /각페이지 내용 -->
      </div>
      <!-- /contents -->

    </div>
  </div>
</form>
<jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>