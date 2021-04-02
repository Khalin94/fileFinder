<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="java.util.Hashtable"%>
<%@ page import="java.util.Vector"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.govSubmtData.SGovSubmtDataDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.UserInfoDelegate"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.CDInfoDelegate"%>
<%@ page import="nads.lib.reqsubmit.util.DBUtil" %>


<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
 UserInfoDelegate objUserInfo =null;
 CDInfoDelegate objCdinfo =null;
%>
<%@ include file="../common/RUserCodeInfoInc.jsp" %>
<%
/******************************************************************************
* Name		  : SGovSubDataInsert.jsp
* Summary	  : 정부제출자료함 등록.
* Description : 정부제출자료함 등록 화면 제공.
******************************************************************************/
 Hashtable objHash = null;

 String strReqOrganID = null; // 담당기관 ID

 // 담당기관 코드  ( 1 법제실..)
 String strMSortCd = StringUtil.toHan(StringUtil.getEmptyIfNull((String)request.getParameter("strMSortCd")));
 // 담당기관명
 String strReqOrganNm = StringUtil.toMulti(StringUtil.getEmptyIfNull((String)request.getParameter("strReqOrganNm")));
 // 제출기관 ID
 String strOrganId = StringUtil.getEmptyIfNull((String)request.getParameter("strOrganId"));
 // 정부제출자료구분코드 000 전체 001 예산안 ..
 String strGbnCode = StringUtil.getEmptyIfNull((String)request.getParameter("strGbnCode"));

 if(strGbnCode == "000" || strGbnCode.equals("000")){
	strGbnCode = "001";
 }
 // 검색어
 String strAnsSubmtQryTerm = StringUtil.getEmptyIfNull((String)request.getParameter("strAnsSubmtQryTerm"));
 // 검색어 필드
 String strAnsSubmtQryField = StringUtil.getEmptyIfNull((String)request.getParameter("strAnsSubmtQryField"));
 // 검색필드
 String strGovSubmtDataSortField = StringUtil.getEmptyIfNull((String)request.getParameter("strGovSubmtDataSortField"));
 // 검색 순차(내림차순 오름차순)
 String strGovSubmtDataSortMtd = StringUtil.getEmptyIfNull((String)request.getParameter("strGovSubmtDataSortMtd"));
 // 페이지수
 String strGovSubmtDataPageNum = StringUtil.getEmptyIfNull((String)request.getParameter("strGovSubmtDataPageNum"));

 //System.out.println("[SGovSubDataInsert.jsp] strMSortCd = " + strMSortCd);
 //System.out.println("[SGovSubDataInsert.jsp] strGbnCode = " + strGbnCode);
 //System.out.println("[SGovSubDataInsert.jsp] strReqOrganNm = " + strReqOrganNm);
 //System.out.println("[SGovSubDataInsert.jsp] strOrganId = " + strOrganId);
 //System.out.println("[SGovSubDataInsert.jsp] strGovSubmtDataSortField = " + strGovSubmtDataSortField);
 //System.out.println("[SGovSubDataInsert.jsp] strGovSubmtDataSortMtd = " + strGovSubmtDataSortMtd);
 //System.out.println("[SGovSubDataInsert.jsp] strGovSubmtDataPageNum = " + strGovSubmtDataPageNum);
 //System.out.println("[SGovSubDataInsert.jsp] strAnsSubmtQryTerm  = " + strAnsSubmtQryTerm);
 //System.out.println("[SGovSubDataInsert.jsp] strAnsSubmtQryField  = " + strAnsSubmtQryField);

 if(strMSortCd == "" ||  strMSortCd.equals("")){
	 strMSortCd  = "1";  //담당기관 ( 디폴트값 = 법제실 )
 }
 //System.out.println(" 설정된 담당기관 코드 : strMSortCd = "  + strMSortCd );

 UserInfoDelegate objUser = new UserInfoDelegate(request);

 strOrganId = objUser.getOrganID();
 String strUserID = objUser.getUserID();
 String	strUserNm = objUser.getUserName() ;

 //System.out.println("user 기관 ID ( strOrganId ) = " + strOrganId);
 //System.out.println("user ID = " + strUserID);
 //System.out.println("user nm = " + strUserNm);

 SGovSubmtDataDelegate obGovSmdata = new SGovSubmtDataDelegate();
 objHash = obGovSmdata.getChargeUserInfo(strOrganId);

 String strOrganNm  =  (String)((Vector)objHash.get("ORGAN_NM") ).elementAt(0);
 boolean blnUserInfo = false;

%>
<%
	try{
		 blnUserInfo = objUserInfo.isRequester();
	}catch(Exception e){
    }
%>
<jsp:include page="/inc/header.jsp" flush="true"/>
<script language=Javascript src="/js/nads_lib.js"></script>
<script language=Javascript src="/js/datepicker.js"></script>
<script language="JavaScript">
<!--
 <%
    Hashtable objFirstSortHash =  obGovSmdata.getSubmtMSortData();
 	//정부제출자료 담당기관 콤보 박스에 자료 넣기위해 Array에 테이터 넣어주는 부분.
	Integer intFieldCnt = (Integer)objFirstSortHash.get("FETCH_COUNT");
    out.println("var form;");
	out.println("var arrCmtSubmtOrgans=new Array(" + intFieldCnt.intValue() + ");");
	for(int i=0; i < intFieldCnt.intValue();i++){
	    out.println("arrCmtSubmtOrgans[" + i + "]=new Array('" +
						(String)( (Vector)objFirstSortHash.get("ORGAN_KIND") ).elementAt(i)	+ "','" +
						(String)( (Vector)objFirstSortHash.get("ORGAN_ID") ).elementAt(i) + "','" +
						(String)( (Vector)objFirstSortHash.get("ORGAN_NM") ).elementAt(i) + "');" );
	}//endfor
 %>

  /** 정부제출기관 구분에 따른 첨부파일 등록 변화*/
  function makeHtmlInsertForm(GovSubmtDataType){

			var str = "";
			str = str +	"<table border=\"0\" width=\"520\">";
			str = str + "<tr>";
			str = str + " <td height=\"25\" class=\"td_gray1\"><img src=\"/image/common/icon_nemo_gray.gif\" width=\"3\" height=\"6\"> PDF </td> ";
			str = str + " <td height=\"25\" colspan=\"3\" class=\"td_lmagin\">" ;
			str = str + "	<input type=\"file\" name=\"PDFFilePath\" size=\"50\"  class=\"textfield\">";
			str = str + " </td>";
		    str = str + "</tr>";
			str = str + "<tr height=\"1\" class=\"tbl-line\">";
	 	    str = str + "<td height=\"1\"></td>";
			str = str + "<td height=\"1\" colspan=\"3\"></td>";
 			str = str + "</tr>";

			str = str + "<tr>";
			str = str + "<td height=\"25\" class=\"td_gray1\"><img src=\"/image/common/icon_nemo_gray.gif\" width=\"3\" height=\"6\">" ;
			str = str + " 원본문서 </td>";
			str = str + " <td height=\"25\" colspan=\"3\" class=\"td_lmagin\">";
			str = str + "<input type=\"file\" name=\"OrginalFilePath\" size=\"50\"  class=\"textfield\">";

			str = str + " </td>";
			str = str + " </tr>";
			str = str + " <tr height=\"1\" class=\"tbl-line\"> ";
			str = str + " <td height=\"1\"></td>";
			str = str + "<td height=\"1\" colspan=\"3\"></td>";
			str = str + "</tr>  ";
			str = str + " <tr> ";
			str = str + " <td height=\"25\" class=\"td_gray1\"><img src=\"/image/common/icon_nemo_gray.gif\" width=\"3\" ";
			str = str + " height=\"6\">";
			str = str + " 목차파일 </td>";
			str = str + "<td height=\"25\" colspan=\"3\" class=\"td_lmagin\">";
			str = str + "<input type=\"file\" name=\"TOCFilePath\" size=\"50\"  class=\"textfield\">";
			str = str + "</td>";
			str = str + " </tr>";
			str = str + "<tr height=\"1\" class=\"tbl-line\"> ";
			str = str + "  <td height=\"1\"></td>";
			str = str + "  <td height=\"1\" colspan=\"3\"></td>";
			str = str + " </tr>";
			str = str + "</table>";

			document.all.inputDiv.innerHTML = str;

	}

  /** 위원회 ID 변화에 따른 제출기관 리스트 변화 */
  function changeSubmtOrganList(value){
	//  alert(value);
	var da= formName.GovSubmtDataType.options[formName.GovSubmtDataType.selectedIndex].value
    //makeHtmlInsertForm(	da);
	//alert(formName.GovSubmtDataType.options[formName.GovSubmtDataType.selectedIndex].value);
  }//end of func


  // 답변 유형에 따라서 입력 폼이 달라지므로 유형별 필수입력값에 대한 강요를 하자.. 넣어주시어요~
  function checkSubmit() {
	var f = document.formName;
	var ansType = f.GovSubmtDataType.value;

	if(document.formName.SubmtCont.value == ""){
		alert(" 제출내용을  입력하세요!!");
		formName.elements['SubmtCont'].focus();
		return false;
	}

	//if(document.formName.SubmtCont.value.length>200){

	if(getByteLength(document.formName.SubmtCont.value)>200){
		alert("요구함설명은 200글자 이내로 작성해주세요!!");
		formName.SubmtCont.focus();
		return false;
	}


	//if (ansType != "<%= CodeConstants.GVO_SUBMT_DATA_RESULT_GBN %>") { // 전자파일인가요?
	//if(ansType == "001"	 || ansType =="002" || ansType == "005"	){
 	if(ansType == "001"	 || ansType =="002" || ansType == "003"	){//예산안 ,결산안, 기금결산
		if (f.PDFFilePath.value == "") {
			alert("PDF 파일을 선택해 주세요");
			f.PDFFilePath.focus();
			return;
		}else if(f.OrginalFilePath.value == "") {
			alert("원본 문서 파일을 선택해 주세요");
			f.OrginalFilePath.focus();
			return;
		}

		if(CheckUploadFile(f) != false){
			setReqOrganCD();
			formName.action="/reqsubmit/40_govsubdatabox/SGovSubDataInsertProc.jsp";
			formName.submit();
	   }
	}else{

		if(f.PDFFilePath.value == "" & f.OrginalFilePath.value == "") {
			alert("PDF 파일이나 원본 파일을 선택해 주세요");
			f.PDFFilePath.focus();
			return;
		}else{
			// PDF 확장자 검색


			setReqOrganCD();
			formName.action="/reqsubmit/40_govsubdatabox/SGovSubDataInsertProc.jsp";
			formName.submit();
		}
	}



 }//endfunc

/* 담당기관이 위원회인지 확인할수잇는 코드값설정*/
	function setReqOrganCD(){

		var selectOrganId = document.formName.strReqOrganId.options[document.formName.strReqOrganId.selectedIndex].value;
		for(var i=0;i<arrCmtSubmtOrgans.length;i++){
		   var strTmpCmt=arrCmtSubmtOrgans[i][0]; //요구기관코드
		   var tmpOpt=new Option();
		   tmpOpt.value=arrCmtSubmtOrgans[i][1]; // 요구기관ID
		   tmpOpt.text=arrCmtSubmtOrgans[i][2]; // 요구기관명

		   if(arrCmtSubmtOrgans[i][1] == selectOrganId){
				document.formName.strReqOrganCd.value = strTmpCmt;
				break;
		   }
		}
	}


	function gotoList(formName,strGovSubmtDataPageNum,strGbnCode,strAnsSubmtQryField,strAnsSubmtQryTerm){
  		var varAction = formName.action;
  		var varTarget = formName.target;
		formName.action="/reqsubmit/40_govsubdatabox/SGovSubDataBoxList.jsp?strGovSubmtDataPageNum=" + strGovSubmtDataPageNum + "&strGbnCode=" + strGbnCode +"&strAnsSubmtQryField=" + strAnsSubmtQryField +"&strAnsSubmtQryTerm="+strAnsSubmtQryTerm;
		formName.submit();
		formName.target = varTarget;
		formName.action = varAction;
    }


	function CheckUploadFile(form)
	{
		var str=form.PDFFilePath.value;
		if(str=="") {
			alert("선택한 PDF 파일이 없습니다.");
			return false;
		}
		var strExt=str.substring(str.length-3);//확장자 얻기.
		strExt=strExt.toUpperCase();
		if(!(strExt=="PDF")){
			alert("PDF 문서만 등록할 수 있습니다.");
			return false;
		}
	}

	function getByteLength(s){
	   var len = 0;
	   if ( s == null ) return 0;
	   for(var i=0;i<s.length;i++){
		  var c = escape(s.charAt(i));
		  if ( c.length == 1 ) len ++;
		  else if ( c.indexOf("%u") != -1 ) len += 2;
		  else if ( c.indexOf("%") != -1 ) len += c.length/3;
	   }
		return len;
	}

//-->

</script>
</head>

<body>
<div id="wrap">
  <jsp:include page="/inc/top.jsp" flush="true"/>
  <jsp:include page="/inc/top_menu02.jsp" flush="true"/>
  <div id="container">
    <div id="leftCon">
      <jsp:include page="/inc/log_info.jsp" flush="true"/>
      <jsp:include page="/inc/left_menu02.jsp" flush="true"/>
    </div>
    <div id="rightCon">
<form name="formName" method="post" encType="multipart/form-data"  action="file:///C|/Documents%20and%20Settings/chiro1/My%20Documents/%B9%DE%C0%BA%20%C6%C4%C0%CF/./SGovSubDataInsertProc.jsp">
      <!-- pgTit -->
      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
<%
	if(blnUserInfo){	 // 요구자
%>
        <h3><%=MenuConstants.GOV_SUBMT_REQ_DATA_BOX%></h3>
        <div class="navi">
			<img src="/images2/foundation/home.gif" width="13" height="11" />
			<%String strLocation2 =  MenuConstants.GOTO_HOME + " > " + MenuConstants.REQ_SUBMIT_MAIN_MENU + " > " + MenuConstants.GOV_SUBMT_REQ_DATA_BOX + " > " + MenuConstants.GOV_SUBMT_DATA_INSERT;
					out.println(strLocation2);
			%>

<%
   }else{         // 제출자
%>

		<h3><%out.println(MenuConstants.GOV_SUBMT_DATA_BOX);%></h3>
        <div class="navi">
			<img src="/images2/foundation/home.gif" width="13" height="11" /> <%
					String strLocation2 =  MenuConstants.GOTO_HOME + " > " + MenuConstants.REQ_SUBMIT_MAIN_MENU + " > " + MenuConstants.GOV_SUBMT_DATA_BOX + " > " + MenuConstants.GOV_SUBMT_DATA_INSERT;
					out.println(strLocation2);
	}
%>
		</div>

        <p><!--문구--></p>
      </div>
      <!-- /pgTit -->

      <!-- contents -->

      <div id="contents">

        <!-- 검색조건 없는 경우 아래 div 삭제 나 주석으로 막으세요.--><!-- /검색조건-->

        <!-- 각페이지 내용 -->

        <!-- list -->

        <table border="0" cellspacing="0" cellpadding="0" class="list02">
            <tbody>
                <tr>
                    <th height="25">&bull;&nbsp;적용 년도 </th>
                    <td height="25" colspan="3">
						<select onChange="changeSubmtOrganList()" name="strYear">
						   <%
							  java.text.SimpleDateFormat dateFormat=new java.text.SimpleDateFormat("yyyy");
								int nCurYear=Integer.parseInt(dateFormat.format(new java.util.Date()));
								for(int i=nCurYear-5; i<=nCurYear + 10;i++){
									out.print("<option value='" + i + "' ");
									if(i==nCurYear){
										out.print(" selected ");
									}
									out.println(">" + i + "</option>");
								}
						%>
						</select>
					</td>
                </tr>
                <tr>
                    <th height="25">&bull;&nbsp;구분 </th>
                    <td height="25" colspan="3">
						<select onChange="changeSubmtOrganList(this.value)" name="GovSubmtDataType">
						<%
							Hashtable objGbnCodeList = obGovSmdata.getGovSubmtDataGBNCodeList();
							int intSize = objGbnCodeList.size();
							Integer objInt =(Integer)objGbnCodeList.get("FETCH_COUNT");
							int intCount = objInt.intValue();
							String strGndCodeName = null;
							String strGbnCodeData = null;

							for( int i = 0 ; i < intCount ; i ++){
								 strGbnCodeData = (String)((Vector)objGbnCodeList.get("MSORT_CD")).elementAt(i);
								 //System.out.println(" strGbnCodeData = " + strGbnCodeData);
								 strGndCodeName = (String)((Vector)objGbnCodeList.get("CD_NM")).elementAt(i);
								 //System.out.println(" strGndCodeName = " + strGndCodeName);
						%>
								<option
						<%
							/*
								if(strGbnCodeData == strGbnCode || strGbnCodeData.equals(strGbnCode)){
									out.print(" selected ");
									strGbnCode = strGbnCodeData;
								}
							*/
								if( i == 0){
									out.print(" selected ");
								}
						%>
										  value="<%=strGbnCodeData%>"><%=strGndCodeName%></option>
						<%
							} //FOR
						%>
						</select>
					</td>
                </tr>
                <tr>
                    <th height="25" width="149">&bull;&nbsp;담당기관</th>
                    <td height="25" colspan="3">
						<select onChange="changeSubmtOrganList()" name="strReqOrganId" style="width:200px;">
					<%

						//Integer intFirstSortFieldCnt = (Integer)objFirstSortHash.get("FETCH_COUNT");
						 //int intFirstCount= intFirstSortFieldCnt.intValue();
						// 담당기관 중분류
						String strFistMsortCd = null;
						String strFistMsortNm = null;

						for(int i=0; i < intFieldCnt.intValue() ; i++){
						  strFistMsortCd =(String)((Vector)objFirstSortHash.get("RNUM")).elementAt(i);
						  strReqOrganID =(String)((Vector)objFirstSortHash.get("ORGAN_ID")).elementAt(i);
						  strFistMsortNm =(String)((Vector)objFirstSortHash.get("ORGAN_NM")).elementAt(i);

							out.println("<option value=\"" + strReqOrganID + "\" " +  StringUtil.getSelectedStr(strMSortCd,strFistMsortCd) + ">" + strFistMsortNm + "</option>");
						}
					 %>
						</select>
					</td>
                </tr>
				<tr>
				    <th height="25">&bull;&nbsp;제출기관 </th>
                    <td height="25" colspan="3"><%=strOrganNm%></td>
				</tr>
				<tr>
				    <th height="25">&bull;&nbsp;등록자 </th>
                    <td height="25" colspan="3"> <%=strUserNm%> </td>
				</tr>
                <tr>
                    <th height="25">&bull;&nbsp;요구함 설명</th>
                    <td colspan="3">
						<textarea rows="3" cols="70" name="SubmtCont" style="height:100px;"></textarea>
					</td>
                </tr>
				<tr>
				    <th height="25" rowspan="2" width="100">&bull;&nbsp;첨부파일 </th>
				    <th height="25" width="70">&bull;&nbsp;PDF </th>
                    <td height="25" colspan="2">
						<input type="file" name="PDFFilePath" size="35" class="textfield">
					</td>
				</tr>
				<tr>
				    <th height="25" width="70">&bull;&nbsp;원본파일 </th>
					<td height="25" colspan="2">
						<input type="file" name="OrginalFilePath" size="35" class="textfield">
					</td>
				</tr>
              </tbody>
        </table>
        <!-- /list -->








        <!-- 리스트 버튼-->
        <div id="btn_all"  class="t_right">
			<span class="list_bt"><a href="javascript:checkSubmit()">저장</a></span>
			<span class="list_bt"><a href="javascript:formName.reset()">취소</a></span>
			<span class="list_bt"><a href="javascript:gotoList(formName,'<%=strGovSubmtDataPageNum%>' ,'<%=strGbnCode%>','<%=strAnsSubmtQryField%>','<%=strAnsSubmtQryTerm%>')">목록</a></span>
			</span>
		</div>
  <input type="hidden" name="strMSortCd" value="<%=strMSortCd%>"> <!--  담당기관 코드 -->
  <!--담당기관 ID (strReqOrganId) 는 select 버턴처리 -->
   <input type="hidden" name="strReqOrganCd" value=""><!--담당기관 코드-->
  <input type="hidden" name="strReqOrganNm" value=""><!--담당기관명 -->
  <input type="hidden" name="RegrID" value="<%=strUserID%>"><!--UerID -->
  <input type="hidden" name="strOrganId" value="<%=strOrganId%>">  <!--제출기관 id-->
  <input type="hidden" name="strOrganNm" value="<%=strOrganNm%>">  <!--제출기관 명-->
  <input type="hidden" name="strUserNm" value="<%=strUserNm%>"> <!--등록자-->
  <input type="hidden" name="strGbnCode" value="<%=strGbnCode%>"> <!--정부제출코드 설정-->
  <input type="hidden" name="strAnsSubmtQryTerm" value="<%=strAnsSubmtQryTerm%>"> <!--검색어 -->
  <input type="hidden" name="strAnsSubmtQryField" value="<%=strAnsSubmtQryField%>"> <!--검색필드 001 이면 전체 -->
  <input type="hidden" name="strGovSubmtDataSortField" value="<%=strGovSubmtDataSortField%>">  <!--정렬 필드 -->
  <input type="hidden" name="strGovSubmtDataSortMtd" value="<%=strGovSubmtDataSortMtd%>">  <!--정렬 방향 -->
  <input type="hidden" name="strGovSubmtDataPageNum" value="<%=strGovSubmtDataPageNum%>">  <!-- 페이지수 -->
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