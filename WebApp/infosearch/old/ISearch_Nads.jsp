<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="com.verity.search.*" %>
<%@ page import="com.verity.k2.*" %>
<%@ page import="com.verity.net.MbEncoder" %>
<%@ page import="nads.dsdm.app.infosearch.common.IsSelectDelegate" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="nads.lib.message.MessageBean"%>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<jsp:include page="/inc/header.jsp" flush="true"/>

<%@ include file="/common/CheckSession.jsp" %>
<%@ include file="utils.jsp" %>
<%@ page errorPage = "bad.jsp" %>
<%
	Hashtable objHtSelectSysdate;
	IsSelectDelegate objCMDsysdate = new IsSelectDelegate();

	try {

		objHtSelectSysdate = objCMDsysdate.selectSysdate();

	} catch (AppException objAppEx) {

		// 에러 발생 메세지 페이지로 이동한다.
	 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
	  	objMsgBean.setStrCode(objAppEx.getStrErrCode());
	  	objMsgBean.setStrMsg(objAppEx.getMessage());
		System.out.println(objAppEx.getStrErrCode());
%>
	  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}

	String serverSpec = "10.201.12.139:9930"; //검색서버
	String default_query = "";//기본쿼리생성
	String realqueryText = "";//최종쿼리생성
	String deptText_last = "";//기관쿼리생성
	String yearText_last = "";//연도쿼리생성
	String reqText_last = "";//요구 및 제출 검색조건 생성
	String reqans_organText_last = "";//요구 및 제출 검색조건 생성

//검색에 필요한 parameter 설정

//문자파라미터


	//요구 및 제출자 구분(orgna_kind=001 사무처/002=예산정책처/003=의원실/004위원회/005도서관/006제출기관)

 	boolean IS_REQUESTER=false;

	 if(session.getAttribute("IS_REQUESTER").equals("true")){
	 	IS_REQUESTER=true;
	 }

	//요구자면 요구기관ID 제출자면 제출기관 ID
	String ORGAN_ID=(String)session.getAttribute("ORGAN_ID");

	String ORGAN_KIND=(String)session.getAttribute("ORGAN_KIND");

	String SRCH_DISPLAY_KIND = (String)session.getAttribute("SRCH_DISPLAY_KIND");

	String SRCH_RECORD_CNT = (String)session.getAttribute("SRCH_RECORD_CNT");

	String audit_year_from = StringUtil.getEmptyIfNull(request.getParameter("audit_year_from"));
	if(audit_year_from==null || audit_year_from.equals("")) audit_year_from = (String)objHtSelectSysdate.get("YYYY");

	String audit_year_to = StringUtil.getEmptyIfNull(request.getParameter("audit_year_to"));
	if(audit_year_to==null || audit_year_to.equals("")) audit_year_to = (String)objHtSelectSysdate.get("YYYY");


	String deptText = StringUtil.getEmptyIfNull(request.getParameter("deptText"));
	if(deptText==null) deptText = "";

	String query = StringUtil.getEmptyIfNull(request.getParameter("query"));
	if(query==null) query = "";

	String deptText00 = StringUtil.getEmptyIfNull(request.getParameter("deptText00"));
	if(deptText00==null) deptText00 = "";


	String MENU_CD = StringUtil.getEmptyIfNull(request.getParameter("MENU_CD"));
	if(MENU_CD==null || MENU_CD.equals("")) MENU_CD = "01";

	String ans_text = StringUtil.getEmptyIfNull(request.getParameter("ans_text"));
	if(ans_text==null) ans_text = "";

	String req_text = StringUtil.getEmptyIfNull(request.getParameter("req_text"));
	if(req_text==null) req_text = "";

	String andor = StringUtil.getEmptyIfNull(request.getParameter("andor"));
	if(andor==null || andor.equals("")) andor = "AND";

	String req_select = StringUtil.getEmptyIfNull(request.getParameter("req_select"));
	if(req_select==null || req_select.equals("")) req_select = "00";

	String ans_select = StringUtil.getEmptyIfNull(request.getParameter("ans_select"));
	if(ans_select==null || ans_select.equals("")) ans_select = "00";

	String req_organ_select = StringUtil.getEmptyIfNull(request.getParameter("req_organ_select"));
	if(req_organ_select==null || req_organ_select.equals("")) req_organ_select = "00";

	String ans_organ_select = StringUtil.getEmptyIfNull(request.getParameter("ans_organ_select"));
	if(ans_organ_select==null || ans_organ_select.equals("")) ans_organ_select = "00";

	String GROUPNAME = StringUtil.getEmptyIfNull(request.getParameter("GROUPNAME"));
	if(GROUPNAME==null) GROUPNAME = "";

	String sortField = StringUtil.getEmptyIfNull(request.getParameter("sortField"));
	if(sortField==null || sortField.equals("")) sortField = "LAST_ANS_DT";

	String sortMethod = StringUtil.getEmptyIfNull(request.getParameter("sortMethod"));
	if(sortMethod==null || sortMethod.equals("")) sortMethod = " desc ";

	String currCommittee = StringUtil.getEmptyIfNull(request.getParameter("currCommittee"));
	if(currCommittee==null || currCommittee.equals("")) currCommittee = "전체 위원회";

	System.out.println(audit_year_from);
	System.out.println(audit_year_to);
	System.out.println(deptText);
	System.out.println(query);
	System.out.println(deptText00);
	System.out.println(MENU_CD);
	System.out.println(ans_text);
	System.out.println(req_text);
	System.out.println(andor);
	System.out.println(req_select);
	System.out.println(ans_select);
	System.out.println(req_organ_select);
	System.out.println(ans_organ_select);
	System.out.println(GROUPNAME);
	System.out.println(sortField);
	System.out.println(sortMethod);
	System.out.println(currCommittee);

	int docStart = 1;
	if(request.getParameter("docStart")!=null) docStart = Integer.parseInt(request.getParameter("docStart"));

	int docPage = Integer.parseInt(SRCH_RECORD_CNT.trim());
	if(request.getParameter("docPage")!=null) docPage = Integer.parseInt(request.getParameter("docPage"));

	int maxDocs = 4000;
	if(request.getParameter("maxDocs") != null) maxDocs = Integer.parseInt(request.getParameter("maxDocs"));

	IsSelectDelegate objCMD = new IsSelectDelegate();
	IsSelectDelegate objCMDUnder = new IsSelectDelegate();
	IsSelectDelegate objCMDreq = new IsSelectDelegate();
	IsSelectDelegate objCMDans = new IsSelectDelegate();
	ArrayList objArrselectCommittee_Nads;
	ArrayList objArrselectCommitteeUnder_Nads;
	ArrayList objArrselectReq_Organ;
	ArrayList objArrselectAns_Organ;

	try {
		//제출기관(위원회하부)-네비게이션
		objArrselectCommittee_Nads = objCMD.selectCommittee_Nads();
	}
	catch (AppException objAppEx) {
		// 에러 발생 메세지 페이지로 이동한다.
	 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
	  	objMsgBean.setStrCode(objAppEx.getStrErrCode());
	  	objMsgBean.setStrMsg(objAppEx.getMessage());
		System.out.println(objAppEx.getStrErrCode());

%>
	  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}

	try {
		//제출기관(제출기관하부)-네비게이션
		objArrselectCommitteeUnder_Nads = objCMDUnder.selectCommitteeUnder_Nads(deptText);
	}
	catch (AppException objAppEx) {

		// 에러 발생 메세지 페이지로 이동한다.
	 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
	  	objMsgBean.setStrCode(objAppEx.getStrErrCode());
	  	objMsgBean.setStrMsg(objAppEx.getMessage());
		System.out.println(objAppEx.getStrErrCode());
%>
	  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}

	try {
		//요구기관(위원회+법제실+예산정책처+의원실)
		objArrselectReq_Organ = objCMDreq.selectReq_Organ();
	}
	catch (AppException objAppEx) {

		// 에러 발생 메세지 페이지로 이동한다.
	 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
	  	objMsgBean.setStrCode(objAppEx.getStrErrCode());
	  	objMsgBean.setStrMsg(objAppEx.getMessage());
		System.out.println(objAppEx.getStrErrCode());
%>
	  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}

	try {
		//제출기관(제출기간+법제실+예산정책처)
		objArrselectAns_Organ = objCMDans.selectAns_Organ();
	}
	catch (AppException objAppEx) {

		// 에러 발생 메세지 페이지로 이동한다.
	 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
	  	objMsgBean.setStrCode(objAppEx.getStrErrCode());
	  	objMsgBean.setStrMsg(objAppEx.getMessage());
		System.out.println(objAppEx.getStrErrCode());
%>
	  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}
	//요구기관 및 제출기관 검색조건 생성

		if (!req_organ_select.equals("00") & !ans_organ_select.equals("00") ) {//

			if (req_organ_select.equals("003") | req_organ_select.equals("004")) {//
			reqans_organText_last =" AND ("+req_organ_select+"<IN>Z_REQ_ORGAN_KIND ) "+" AND ("+ans_organ_select+"<IN>Z_SUBMT_ORGAN_ID ) ";
			}else {
			reqans_organText_last =" AND ("+req_organ_select+"<IN>Z_REQ_ORGAN_ID ) "+" AND ("+ans_organ_select+"<IN>Z_SUBMT_ORGAN_ID ) ";
			}

		}else if (!req_organ_select.equals("00")){

			if (req_organ_select.equals("003") | req_organ_select.equals("004")) {//
			reqans_organText_last =" AND ("+req_organ_select+"<IN>Z_REQ_ORGAN_KIND ) ";
			}else {
			reqans_organText_last =" AND ("+req_organ_select+"<IN>Z_REQ_ORGAN_ID ) ";
			}

		}else if (!ans_organ_select.equals("00")){

			reqans_organText_last =" AND ("+ans_organ_select+"<IN>Z_SUBMT_ORGAN_ID ) ";

		}


	if (IS_REQUESTER) {//ORGAN_KIND

		//기본검색조건 생성
		if (query.equals("")) {//

			if (ORGAN_KIND.equals("004")) {//

			//default_query=" (001<IN>Z_OPEN_CL<OR>"+ORGAN_ID+"<IN>Z_CMT_ORGAN_ID) ";
			default_query=" (001<IN>Z_OPEN_CL) ";
			}else{
			default_query=" (001<IN>Z_OPEN_CL<OR>"+ORGAN_ID+"<IN>Z_REQ_ORGAN_ID) ";
			}


		}else{
		default_query=" ( "+query+" <IN> Z_INX_FILE_PATH) "+" AND (001<IN>Z_OPEN_CL<OR>"+ORGAN_ID+"<IN>Z_REQ_ORGAN_ID) ";
		}

	}else{

	//기본검색조건 생성
	if (query.equals("")) {//
	default_query=" ( "+ORGAN_ID+"<IN>Z_SUBMT_ORGAN_ID) ";
	}else{
	default_query=" ( "+query+" <IN> Z_INX_FILE_PATH ) "+" AND ("+ORGAN_ID+"<IN>Z_SUBMT_ORGAN_ID) ";
	}



	}


	//년도검색조건 생성
	yearText_last=" AND AUDIT_YEAR >= "+audit_year_from+" AND AUDIT_YEAR <= "+audit_year_to ;


	//요구 및 제출 검색조건 생성
	if (!ans_text.equals("") & !req_text.equals("") ) {//

		if (req_select.equals("01") & ans_select.equals("01") ) {//

			reqText_last =" AND ("+ans_text+"<IN>Z_REGR_NM " +andor+" "+req_text+"<IN>Z_REQ_CONT)";

		}else if(req_select.equals("01") & ans_select.equals("02")){

			reqText_last =" AND ("+ans_text+"<IN>Z_ANSR_NM " +andor+" "+req_text+"<IN>Z_REQ_CONT)";

		}else if(req_select.equals("01") & ans_select.equals("00")){

			reqText_last =" AND ("+req_text+"<IN>Z_REQ_CONT)";

		}else if(req_select.equals("02") & ans_select.equals("01")){

			reqText_last =" AND ("+ans_text+"<IN>Z_REGR_NM " +andor+" "+req_text+"<IN>Z_REQ_DTL_CONT)";

		}else if(req_select.equals("02") & ans_select.equals("02")){

			reqText_last =" AND ("+ans_text+"<IN>Z_ANSR_NM " +andor+" "+req_text+"<IN>Z_REQ_DTL_CONT)";

		}else if(req_select.equals("02") & ans_select.equals("00")){

			reqText_last =" AND ("+req_text+"<IN>Z_REQ_DTL_CONT)";

		}else if(req_select.equals("03") & ans_select.equals("01")){

			reqText_last =" AND ("+ans_text+"<IN>Z_REGR_NM " +andor+" "+req_text+"<IN>Z_ANS_OPIN)";

		}else if(req_select.equals("03") & ans_select.equals("02")){

			reqText_last =" AND ("+ans_text+"<IN>Z_ANSR_NM " +andor+" "+req_text+"<IN>Z_ANS_OPIN)";

		}else if(req_select.equals("03") & ans_select.equals("00")){

			reqText_last =" AND ("+req_text+"<IN>Z_ANS_OPIN)";

		}else if(req_select.equals("00") & ans_select.equals("00")){

			reqText_last =" AND ( ("+ans_text+"<IN>Z_ANSR_NM <OR> "+ans_text+"<IN>Z_REGR_NM) "
			+andor+" ( "+req_text+"<IN>Z_ANS_OPIN <OR> "+req_text+"<IN>Z_REQ_DTL_CONT <OR>"+req_text+"<IN>Z_REQ_CONT) ) ";

		}else if(req_select.equals("00") & ans_select.equals("01")){

			reqText_last =" AND ("+ans_text+"<IN>Z_REGR_NM )";

		}else if(req_select.equals("00") & ans_select.equals("02")){

			reqText_last =" AND ("+ans_text+"<IN>Z_ANSR_NM )";

		}


	}else if(!ans_text.equals("")){

		if (ans_select.equals("01") ) {//

			reqText_last =" AND ("+ans_text+"<IN>Z_REGR_NM ) ";

		}else if(ans_select.equals("02")){

			reqText_last =" AND ("+ans_text+"<IN>Z_ANSR_NM ) ";

		}else if(ans_select.equals("00")){

			reqText_last =" AND ("+ans_text+"<IN>Z_ANSR_NM <OR> "+ans_text+"<IN>Z_REGR_NM) ";
		}


	}else if(!req_text.equals("")){

		if (req_select.equals("01") ) {//

			reqText_last =" AND ("+req_text+"<IN>Z_REQ_CONT ) ";

		}else if(req_select.equals("02")){

			reqText_last =" AND ("+req_text+"<IN>Z_REQ_DTL_CONT ) ";

		}else if(req_select.equals("03")){

			reqText_last =" AND ("+req_text+"<IN>Z_ANS_OPIN ) ";

		}else if(req_select.equals("00")){

			reqText_last =" AND ("+req_text+"<IN>Z_ANS_OPIN <OR> "+req_text+"<IN>Z_REQ_DTL_CONT <OR>"+req_text+"<IN>Z_REQ_CONT) ";

		}

	}
	//out.println("<br>reqText_last="+replace(replace(toMulti(reqText_last), "<", "&lt;"),">","&gt")+"<br>");

	//위원회및 소속기관 검색조건 생성
	if (!deptText.equals("")) {//위원회정보 있을경우

		if (deptText00.equals("")) {//제출기관정보가 없다면 위원회에 속한 모든 정보출력

		deptText_last = " AND "+toMulti(deptText)+"<IN>Z_CMT_ORGAN_ID";

		} else {//제출기관 정보가 있다면 해당 제출기관에 속한 정보만 출력

		deptText_last = " AND "+toMulti(deptText)+"<IN>Z_CMT_ORGAN_ID AND "+toMulti(deptText00)+"<IN>Z_SUBMT_ORGAN_ID" ;

		}

	}


	//위원회및 소속기관 검색조건생성-최종쿼리

	if (deptText.equals("")) {//위원회정보도 없으므로  위원회에 속한 모든정보 출력
		realqueryText ="";

	} else {//위원회정보가 있다면 해당위원회에 속한정보만 출력
		realqueryText =toMulti(deptText_last);

	}

	Result result = null;
%>

<script language="JavaScript">
function GotoPage(form, docStart){

		var str1=document.PageForm.query.value
		var str2=document.PageForm.req_text.value
		var str3=document.PageForm.ans_text.value

		for (var i=0; i < str1.length; i++) {
			if (str1.charAt(i) == "%" |str1.charAt(i) == ">" |str1.charAt(i) == "<" |str1.charAt(i) == ">" |str1.charAt(i) == "(" |str1.charAt(i) == ")" |str1.charAt(i) == "+" |str1.charAt(i) == "," |str1.charAt(i) == "[") {
			alert("허용되지않은 문자입니다.");
			document.PageForm.query.value="";
			document.PageForm.query.focus();
			return ;
            }
         }



		for (var i=0; i < str2.length; i++) {
			if (str2.charAt(i) == "%" |str2.charAt(i) == ">" |str2.charAt(i) == "<" |str2.charAt(i) == ">" |str2.charAt(i) == "(" |str2.charAt(i) == ")" |str2.charAt(i) == "+" |str2.charAt(i) == "," |str2.charAt(i) == "[") {
			alert("허용되지않은 문자입니다.");
			document.PageForm.req_text.value="";
			document.PageForm.req_text.focus();
			return ;
            }
         }

		for (var i=0; i < str3.length; i++) {
			if (str3.charAt(i) == "%" |str3.charAt(i) == ">" |str3.charAt(i) == "<" |str3.charAt(i) == ">" |str3.charAt(i) == "(" |str3.charAt(i) == ")" |str3.charAt(i) == "+" |str3.charAt(i) == "," |str3.charAt(i) == "[") {
			alert("허용되지않은 문자입니다.");
			document.PageForm.ans_text.value="";
			document.PageForm.ans_text.focus();
			return ;
            }
         }



	if(document.PageForm.query.value == '')
	{
	document.PageForm.action="./ISearch_Nads.jsp";
	}

	form.docStart.value = docStart * form.docPage.value + 1;
	form.submit();
	return;
}

function GotoCommittee(form,deptText,deptText00,GROUPNAME,currCommittee){

		var str1=document.PageForm.query.value
		var str2=document.PageForm.req_text.value
		var str3=document.PageForm.ans_text.value

		for (var i=0; i < str1.length; i++) {
			if (str1.charAt(i) == "%" |str1.charAt(i) == ">" |str1.charAt(i) == "<" |str1.charAt(i) == ">" |str1.charAt(i) == "(" |str1.charAt(i) == ")" |str1.charAt(i) == "+" |str1.charAt(i) == "," |str1.charAt(i) == "[") {
			alert("허용되지않은 문자입니다.");
			document.PageForm.query.value="";
			document.PageForm.query.focus();
			return ;
            }
         }

		for (var i=0; i < str2.length; i++) {
			if (str2.charAt(i) == "%" |str2.charAt(i) == ">" |str2.charAt(i) == "<" |str2.charAt(i) == ">" |str2.charAt(i) == "(" |str2.charAt(i) == ")" |str2.charAt(i) == "+" |str2.charAt(i) == "," |str2.charAt(i) == "[") {
			alert("허용되지않은 문자입니다.");
			document.PageForm.req_text.value="";
			document.PageForm.req_text.focus();
			return ;
            }
         }

		for (var i=0; i < str3.length; i++) {
			if (str3.charAt(i) == "%" |str3.charAt(i) == ">" |str3.charAt(i) == "<" |str3.charAt(i) == ">" |str3.charAt(i) == "(" |str3.charAt(i) == ")" |str3.charAt(i) == "+" |str3.charAt(i) == "," |str3.charAt(i) == "[") {
			alert("허용되지않은 문자입니다.");
			document.PageForm.ans_text.value="";
			document.PageForm.ans_text.focus();
			return ;
            }
         }

	if(document.PageForm.query.value == '')
	{
	document.PageForm.action="./ISearch_Nads.jsp";
	}

	form.deptText.value = deptText;
	form.deptText00.value = deptText00;
	form.GROUPNAME.value = GROUPNAME;
	form.currCommittee.value = currCommittee;
	form.submit();
	return;
}



function search(sortField,sortMethod)
{
	if(document.PageForm.query.value == '')
	{
	document.PageForm.action="./ISearch_Nads.jsp";
	}

	if(document.PageForm.audit_year_from.value > document.PageForm.audit_year_to.value)
	{
		alert("시작년도가 종료년도보다 큽니다.");
		document.PageForm.audit_year_from.focus();
		return ;
	}

		var str1=document.PageForm.query.value
		var str2=document.PageForm.req_text.value
		var str3=document.PageForm.ans_text.value

		for (var i=0; i < str1.length; i++) {
			if (str1.charAt(i) == "%" |str1.charAt(i) == ">" |str1.charAt(i) == "<" |str1.charAt(i) == ">" |str1.charAt(i) == "(" |str1.charAt(i) == ")" |str1.charAt(i) == "+" |str1.charAt(i) == "," |str1.charAt(i) == "[") {
			alert("허용되지않은 문자입니다.");
			document.PageForm.query.value="";
			document.PageForm.query.focus();
			return ;
            }
         }

		for (var i=0; i < str2.length; i++) {
			if (str2.charAt(i) == "%" |str2.charAt(i) == ">" |str2.charAt(i) == "<" |str2.charAt(i) == ">" |str2.charAt(i) == "(" |str2.charAt(i) == ")" |str2.charAt(i) == "+" |str2.charAt(i) == "," |str2.charAt(i) == "[") {
			alert("허용되지않은 문자입니다.");
			document.PageForm.req_text.value="";
			document.PageForm.req_text.focus();
			return ;
            }
         }

		for (var i=0; i < str3.length; i++) {
			if (str3.charAt(i) == "%" |str3.charAt(i) == ">" |str3.charAt(i) == "<" |str3.charAt(i) == ">" |str3.charAt(i) == "(" |str3.charAt(i) == ")" |str3.charAt(i) == "+" |str3.charAt(i) == "," |str3.charAt(i) == "[") {
			alert("허용되지않은 문자입니다.");
			document.PageForm.ans_text.value="";
			document.PageForm.ans_text.focus();
			return ;
            }
         }

	document.PageForm.docStart.value = 1;
	document.PageForm.sortField.value = sortField;
	document.PageForm.sortMethod.value = sortMethod;
	document.PageForm.submit();


}

 function gotoDetailView(ReqInfoID){

    var http = "/reqsubmit/common/ISearchNadsVList.jsp?ReqInfoID=" + ReqInfoID;

	window.open(http,"DetailView","resizable=no,menubar=no,status=yes,titlebar=yes,scrollbars=yes,location=no,toolbar=no,height=600,width=800" );
}
 function findans(){

    var http = "ISearch_Anslist.jsp";

	window.open(http,"ISearch_Anslist","resizable=yes,menubar=no,status=yes,titlebar=yes,scrollbars=yes,location=no,toolbar=no,height=600,width=530" );
}

 function findreq(){

    var http = "ISearch_Reqlist.jsp";

	window.open(http,"ISearch_Reqlist","resizable=yes,menubar=no,status=yes,titlebar=yes,scrollbars=yes,location=no,toolbar=no,height=600,width=530" );
}


// 공백검사

function chkSpace(strValue) {
var flag=true;
	if (strValue!=" ") {
		for (var i=0; i < strValue.length; i++) {
			if (strValue.charAt(i) != " ") {
			flag=false;
            break;
            }
         }
     }
	         return flag;
}

</script>
</head>

<body>
<div id="wrap">
<jsp:include page="/inc/top.jsp" flush="true"/>
<jsp:include page="/inc/top_menu03.jsp" flush="true"/>
<div id="container">
    <div id="leftCon">
        <jsp:include page="/inc/log_info.jsp" flush="true"/>
        <jsp:include page="/inc/left_menu03.jsp" flush="true"/>
    </div>

    <div id="rightCon">
        <!-- pgTit -->
        <div id="pgTit" style="background:url(/images2/foundation/stl_bg_search.jpg) no-repeat left top;">
            <h3>요구제출자료 검색 <!-- <span class="sub_stl" >- 상세보기</span> --></h3>
            <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> > 정보검색 > 요구제출자료 검색</div>
            <p><!--문구--></p>
        </div>
        <!-- /pgTit -->
        <!-- contents -->
        <div id="contents">
		<form  method=post name=PageForm action=./history/InsertUserHistoryProc.jsp >
            <!-- 각페이지 내용 -->
            <div class="serP">
                <!-- 검색창 -->
                <div class="schBox">

						<span class="line"><img src="/images2/foundation/search_line02.gif" width="172" height="3" /></span>
                        <div class="box">
							<table width="90%" cellpadding="0" cellspacing="0" class="list_none">
								<tr>
									<td  align="left"><strong>&bull;&nbsp;연도</strong></td>
									<td  align="left">
										<!-- 기존의 검색 셀렉트와 버튼만 넣으세요-->
										<!-- 년도 -->
										<select name="audit_year_from">
										<% for(int i=Integer.parseInt((String)objHtSelectSysdate.get("YYYY")); i > 2001 ;  i--){%>
										<option value="<%=i%>"  <%if (i==Integer.parseInt(audit_year_from)) {%> selected <%}%>><%=i%></option>
										<%}%>
										</select>~
										<select name="audit_year_to">
										<% for(int i=Integer.parseInt((String)objHtSelectSysdate.get("YYYY")); i > 2001 ;  i--){%>
										<option value="<%=i%>"  <%if (i==Integer.parseInt(audit_year_to)) {%> selected <%}%>><%=i%></option>
										<%}%>
										</select>
									</td>
								</tr>
								<tr>
									<td align="left"><strong>&bull;&nbsp;요구기관</strong></td>
									<td align="left">
										<!-- 요구기관-->
										<select name="req_organ_select" onchange="search('<%=sortField%>','<%=sortMethod%>')" style="width:360px;">
										<option value="00"  <%if (req_organ_select.equals("00")) {%> selected <%}%>>전체</option>
										<option value="004"  <%if (req_organ_select.equals("004")) {%> selected <%}%>>위원회전체</option>
										<option value="003"  <%if (req_organ_select.equals("003")) {%> selected <%}%>>의원실전체</option>
										<% for(int i=0; i < objArrselectReq_Organ.size(); i++){

											Hashtable objHashBSorts = (Hashtable)objArrselectReq_Organ.get(i);
										%>

										<option value="<%=objHashBSorts.get("ORGAN_ID")%>"  <%if ((toMulti(req_organ_select)).equals(objHashBSorts.get("ORGAN_ID"))) {%> selected <%}%>><%=objHashBSorts.get("ORGAN_NM")%></option>
										<%}%>
										</select>
										<a href="JavaScript:findreq();"><img src="/images2/btn/bt_search2.gif" width="50" height="22" /></a>
									</td>
								</tr>
								<tr>
									<td align="left"><strong>&bull;&nbsp;제출기관</strong></td>
									<td align="left">
										<!-- 제출기관 -->
										<select name="ans_organ_select" onchange="search('<%=sortField%>','<%=sortMethod%>')" style="width:400">
										<option value="00"  <%if (ans_organ_select.equals("00")) {%> selected <%}%>>전체</option>
										<% for(int i=0; i < objArrselectAns_Organ.size(); i++){

											Hashtable objHashBSorts = (Hashtable)objArrselectAns_Organ.get(i);
										%>

										<option value="<%=objHashBSorts.get("ORGAN_ID")%>"  <%if ((toMulti(ans_organ_select)).equals(objHashBSorts.get("ORGAN_ID"))) {%> selected <%}%>><%=objHashBSorts.get("ORGAN_NM")%></option>
										<%}%>
										</select>
										<a href="JavaScript:findans();"><img src="/images2/btn/bt_search2.gif" width="50" height="22" /></a>
									</td>
								</tr>
								<tr>
									<td align="left"><strong>&bull;&nbsp;내용</strong></td>
									<td align="left">
										<!-- 내용-->
										<select name="req_select" class="select">
										<option value="00"  <%if (req_select.equals("00")) {%> selected  <%}%>>전체</option>
										<option value="01"  <%if (req_select.equals("01")) {%> selected  <%}%>>요구제목</option>
										<option value="02"  <%if (req_select.equals("02")) {%> selected  <%}%>>요구상세내용</option>
										<option value="03"  <%if (req_select.equals("03")) {%> selected  <%}%>>제출내용</option>
										</select>&nbsp;
										<input name="req_text" type="text" class="textfield" style="WIDTH: 150px" value="<%=toMulti(req_text)%>" maxlength=128>
										&nbsp;<select name="andor" class="select">
										<option value="AND"  <%if (andor.equals("AND")) {%> selected  <%}%>>AND</option>
										<option value="OR"  <%if (andor.equals("OR")) {%> selected  <%}%>>OR</option>
										</select>
									</td>
								</tr>
								<tr>
									<td align="left"><strong>&bull;&nbsp;작성자</strong></td>
									<td align="left">
										<!-- 작성자 -->
										<select name="ans_select" class="select">
										<option value="00"  <%if (ans_select.equals("00")) {%> selected  <%}%>>전체</option>
										<option value="01"  <%if (ans_select.equals("01")) {%> selected  <%}%>>요구자</option>
										<option value="02"  <%if (ans_select.equals("02")) {%> selected  <%}%>>제출자</option>
										</select>
										<input name="ans_text" type="text" class="textfield" style="WIDTH: 150px" value="<%=toMulti(ans_text)%>" maxlength=128>
										<input type=hidden name=deptText value="<%=toMulti(deptText)%>">
										<input type=hidden name=deptText00 value="<%=toMulti(deptText00)%>">
										<input type=hidden name=maxDocs VALUE="<%=maxDocs%>">
										<input type=hidden name=docStart VALUE="<%=docStart%>">
										<input type=hidden name=docPage VALUE="<%=docPage%>">
										<input type=hidden name=MENU_CD VALUE="<%=MENU_CD%>">
										<input type=hidden name=GROUPNAME VALUE="<%=GROUPNAME%>">
										<input type=hidden name=sortField VALUE="<%=sortField%>">
										<input type=hidden name=sortMethod VALUE="<%=sortMethod%>">
										<input type=hidden name=currCommittee VALUE="<%=currCommittee%>">
									</td>
								</tr>
								<tr>
									<td align="left"><strong>&bull;&nbsp;첨부파일(내용)포함</strong></td>
									<td align="left">
										<!-- 첨부파일-->
										<input type=text name=query value="<%=toMulti(query)%>" maxlength=32>
									</td>
								</tr>
								<tr>
									<td colspan="2" align="center"></td>
                                </tr>
							</table>
							<!-- 검색 버튼-->
                            <div style="text-align:center;">
							<a href="JavaScript:search('<%=sortField%>','<%=sortMethod%>');"><img src="../images2/btn/bt_search02.gif" width="68" height="28" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"></a>&nbsp;<a href="ISearch_Nads.jsp"><img src="../images2/btn/bt_start.gif" width="81" height="28" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"/></a>
                            </div>
						</div>
                </div>
                    <!-- /검색창  -->
				<span class="list02_tl">
					<%
						if (!deptText.equals("")) {

							try{
								VSearch vs = new VSearch();
								vs.setServerSpec(serverSpec);
								vs.setCharMap("utf8");
								vs.setQueryParser("3soft");
								vs.setUrlStringsMode(true);
								vs.addCollection("nads");
								vs.setMaxDocCount(1);

								int phitCount = 0;
								String cnt_string="";

								cnt_string = default_query+" AND "+deptText+"<IN>Z_CMT_ORGAN_ID"+yearText_last+reqText_last+reqans_organText_last ;

								//vs.setQueryText(toAscii(cnt_string));
								vs.setQueryText(MbEncoder.encode(cnt_string, "utf8"));
								result = vs.getResult();
								phitCount = result.docsFound;

								out.println("위원회별 검색 건수 - "+currCommittee+"<span style='color:#ea5e11'>("+phitCount+")</span>");
								}
								catch(Exception e){
									throw new RuntimeException(e.getMessage()+e.getClass());
								}
						}else{
							try{
								VSearch vs = new VSearch();
								vs.setServerSpec(serverSpec);
								vs.setCharMap("utf8");
								vs.setQueryParser("3soft");
								vs.setUrlStringsMode(true);
								vs.addCollection("nads");
								vs.setMaxDocCount(1);

								int phitCount = 0;
								String cnt_string="";

								cnt_string = default_query+yearText_last+reqText_last+reqans_organText_last ;

								//vs.setQueryText(toAscii(cnt_string));
                                vs.setQueryText(MbEncoder.encode(cnt_string, "utf8"));
								result = vs.getResult();
								phitCount = result.docsFound;

								out.println("위원회별 검색 건수 - "+currCommittee+"<span style='color:#ea5e11'>("+phitCount+")</span>");
								}
								catch(Exception e){
									throw new RuntimeException(e.getMessage()+e.getClass());
								}
						}
					%>
				</span>
                <script language="JavaScript" src="/js2/reqsubmit/tooltip.js"></script>
                <script language="JavaScript" src="/js/reqsubmit/reqinfo.js"></script>
				<table border="0" cellspacing="0" cellpadding="3" width="719" class="list02">
				<!--카테고리 시작 -->
				<%
					if (deptText.equals("")) {


					try {
						//VSearch vs = new VSearch();

						//3.x 이상에만 있는 method


						//vs.setServerSpec("10.201.60.2:9930");
						//vs.setCharMap("ksc");
						//vs.setUrlStringsMode(true);
						//vs.addCollection("nads");
						//vs.setMaxDocCount(1);

						//int phitCount = 0;
						//String cnt_string="";
						int j=0;
						for(int i=0; i < objArrselectCommittee_Nads.size(); i++){
						Hashtable objHashBSorts = (Hashtable)objArrselectCommittee_Nads.get(i);
						j=i%4;
						//out.println("<br>j="+j+" i="+i+" ::"+objHashBSorts.get("ORGAN_NM"));

						//cnt_string = default_query+" AND "+objHashBSorts.get("ORGAN_ID")+"<IN>Z_CMT_ORGAN_ID"+yearText_last+reqText_last+reqans_organText_last ;

						//out.println("<br>cnt_string="+replace(replace(toMulti(cnt_string), "<", "&lt;"),">","&gt")+"<br>");
						//vs.setQueryText(toAscii(cnt_string));
						//result = vs.getResult();
						//phitCount = result.docsFound;
				%>


					<%	if (j==3){ %>
									  <td  height="22" valign="top"><a href="JavaScript:GotoCommittee(document.PageForm,'<%=objHashBSorts.get("ORGAN_ID")%>','','<%=objHashBSorts.get("ORGAN_NM")%>','<%=objHashBSorts.get("ORGAN_NM")%>')"><%=objHashBSorts.get("ORGAN_NM")%></a></td>
									<tr>
									</tr>

					<%	}else{ %>
									  <td  height="22" valign="top"><a href="JavaScript:GotoCommittee(document.PageForm,'<%=objHashBSorts.get("ORGAN_ID")%>','','<%=objHashBSorts.get("ORGAN_NM")%>','<%=objHashBSorts.get("ORGAN_NM")%>')"><%=objHashBSorts.get("ORGAN_NM")%></a></td>
					<%}%>

				<%	}
                        if (j>0){
                            if (j++<3){
                                out.println("<td  height='22' valign='top'></td>");
                                if (j++<3){
                                    out.println("<td  height='22' valign='top'></td>");
                                }
                            }
                        }
					} catch(Exception e) {
						throw new RuntimeException(e.getMessage()+e.getClass());
					}




					} else {

					try {

						//VSearch vs = new VSearch();

						//3.x 이상에만 있는 method


						//vs.setServerSpec("10.201.60.2:9930");
						//vs.setCharMap("ksc");
						//vs.setUrlStringsMode(true);
						//vs.addCollection("nads");

						//vs.setMaxDocCount(1);
						int phitCount = 0;
						String cnt_string="";
						int j=0;

						if(objArrselectCommitteeUnder_Nads.size() == 0){
						 out.println("<td  height='22' align='center'>하부기관이 없습니다.</td>");
						 }
						for(int i=0; i < objArrselectCommitteeUnder_Nads.size(); i++){
						Hashtable objHashBSorts = (Hashtable)objArrselectCommitteeUnder_Nads.get(i);

						j=i%4;


							//if (deptText.equals("")) {

							//cnt_string =default_query+" AND "+objHashBSorts.get("ORGAN_ID")+"<IN>Z_SUBMT_ORGAN_ID"+yearText_last+reqText_last+reqans_organText_last ;

							//}else{

							//cnt_string = default_query+" AND "+deptText+"<IN>Z_CMT_ORGAN_ID AND "+objHashBSorts.get("ORGAN_ID")+"<IN>Z_SUBMT_ORGAN_ID"+yearText_last+reqText_last+reqans_organText_last ;
							//}

						//out.println("<br>cnt_string="+replace(replace(toMulti(cnt_string), "<", "&lt;"),">","&gt")+"<br>");
						//vs.setQueryText(toAscii(cnt_string));
						//result = vs.getResult();
						//phitCount = result.docsFound;
				%>
					<%	if (j==3){ %>
									  <td  height="22" valign="top"><a href="JavaScript:GotoCommittee(document.PageForm,'<%=deptText%>','<%=objHashBSorts.get("ORGAN_ID")%>','<%=objHashBSorts.get("ORGAN_NM")%>','<%=currCommittee%>')"><%=objHashBSorts.get("ORGAN_NM")%></a></td>
									<tr>
									</tr>
					<%	}else{ %>
									  <td  height="22" valign="top"><a href="JavaScript:GotoCommittee(document.PageForm,'<%=deptText%>','<%=objHashBSorts.get("ORGAN_ID")%>','<%=objHashBSorts.get("ORGAN_NM")%>','<%=currCommittee%>')"><%=objHashBSorts.get("ORGAN_NM")%></a></td>
					<%}%>


				<%	}
                        if (j>0){
                            if (j++<3){
                                out.println("<td  height='22' valign='top'></td>");
                                if (j++<3){
                                    out.println("<td  height='22' valign='top'></td>");
                                }
                            }
                        }
                    }
					catch(Exception e) {
						throw new RuntimeException(e.getMessage()+e.getClass());
					}
				%>
				<%}%>
				<!--검색결과 시작 -->

				<%
					try {
						VSearch vs = new VSearch();

						vs.setServerSpec(serverSpec);
						vs.setCharMap("utf8");
						vs.setQueryParser("3soft");
						vs.setUrlStringsMode(true);
						vs.addCollection("nads");

						vs.addField("VDKPBSUMMARY");
						vs.addField("REQ_ID");
						vs.addField("CMT_ORGAN_NM");
						vs.addField("REQ_ORGAN_NM");
						vs.addField("SUBMT_ORGAN_NM");
						vs.addField("LAST_ANS_DT");
						vs.addField("ANS_ID");
						vs.addField("AUDIT_YEAR");
						vs.addField("OPEN_CL");
						vs.addField("REQ_ORGAN_ID");
						vs.addField("CMT_ORGAN_ID");
						vs.addField("SUBMT_ORGAN_ID");
						vs.addField("ANS_MTD");
						vs.addField("REQ_CONT");
						vs.addField("ANS_OPIN");
						vs.addField("REGR_NM");
						vs.addField("ANSR_NM");
						vs.addField("SUBMT_FLAG");
				//		vs.addField("VdkVgwKey");
				//		vs.addField("k2dockey");
				//		vs.addField("INX_FILE_PATH");

						vs.setMaxDocCount(maxDocs);
						vs.setDocsStart(docStart);
						vs.setDocsCount(docPage);

						String SortSpec="";
						SortSpec=sortField+sortMethod;

						vs.setSortSpec(SortSpec+" REQ_CONT ACE");
						vs.setDateFormat("${yyyy}-${mm}-${dd}");

						realqueryText=default_query+realqueryText+yearText_last+reqText_last+reqans_organText_last;
						//vs.setQueryText(toAscii(realqueryText));
						vs.setQueryText(MbEncoder.encode(realqueryText, "utf8"));
						result = vs.getResult();
						//out.println("realqueryText=>"+realqueryText+"<br>");
					}
					catch(Exception e) {
						throw new RuntimeException(e.getMessage()+e.getClass()+"<br>|"+replace(replace(toMulti(realqueryText), "<", "&lt;"),">","&gt")+"|"+sortField+sortMethod);
					}

					//검색 결과 Print
					int hitCount = result.docsFound;
				%>
				<!--검색결과 끝 -->
				<!--카테고리 끝 -->
				</table>
				<br /><br />
				<span class="list01_tl">요구 목록 <span class="list_total">&bull;&nbsp;전체자료수 : <%=hitCount%>개</span></span><br />
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
					<thead>
						<tr align="center">
							<th scope="col">NO</th>
							<th scope="col"><a href="javascript:search('REQ_CONT','<%if(sortMethod.equals(" asc ")){out.println(" desc ");}else{out.println(" asc ");}%>');">요구 제목<%if(sortField.equals("REQ_CONT")){if(sortMethod.equals(" asc ")){out.println(" ▼ ");}else{out.println(" ▲ ");}}%></a></th>
							<th scope="col">답변</th>
							<th scope="col"><a href="javascript:search('REQ_ORGAN_NM','<%if(sortMethod.equals(" asc ")){out.println(" desc ");}else{out.println(" asc ");}%>');">요구기관<%if(sortField.equals("REQ_ORGAN_NM")){if(sortMethod.equals(" asc ")){out.println(" ▼ ");}else{out.println(" ▲ ");}}%></a></th>
							<th scope="col"><a href="javascript:search('SUBMT_ORGAN_NM','<%if(sortMethod.equals(" asc ")){out.println(" desc ");}else{out.println(" asc ");}%>');">제출기관<%if(sortField.equals("SUBMT_ORGAN_NM")){if(sortMethod.equals(" asc ")){out.println(" ▼ ");}else{out.println(" ▲ ");}}%></a></th>
							<th scope="col"><a href="javascript:search('LAST_ANS_DT','<%if(sortMethod.equals(" asc ")){out.println(" desc ");}else{out.println(" asc ");}%>');">제출일자<%if(sortField.equals("LAST_ANS_DT")){if(sortMethod.equals(" asc ")){out.println(" ▼ ");}else{out.println(" ▲ ");}} %></a></th>
						</tr>
					</thead>
				<%

					if (hitCount !=0) {
						String VDKPBSUMMARY = "";
						Enumeration enum1 = result.documents().elements();
						while(enum1.hasMoreElements()){
							Document doc = (Document)enum1.nextElement();
							VDKPBSUMMARY = replace(doc.field("VDKPBSUMMARY"),"\"", "'");//VDKSUMMARY에 "가 있을경우 '로 변환(alt테그에서 문제됨)
							//VDKPBSUMMARY = replace(VDKPBSUMMARY,"\"", "'");
				%>
									<tr  align="center">
									  <td height="22"><%=doc.rank%></td>
									  <td height="22" align="left"  width=350><a href="javascript:gotoDetailView('<%=doc.field("REQ_ID")%>');"><%=doc.field("REQ_CONT")%></a><!--<img src="../image/infosearch/icon_infosearch_soti.gif" width="9" height="9" alt="<%=VDKPBSUMMARY%>">--></td>
									  <td><%=nads.lib.reqsubmit.util.DBAccessUtil.makeAnsInfoHtml(doc.field("ANS_ID"),doc.field("ANS_MTD"),doc.field("ANS_OPIN"),doc.field("SUBMT_FLAG"),IS_REQUESTER,query,SRCH_DISPLAY_KIND.trim(),VDKPBSUMMARY)%><br></td>
									  <td height="22" align="left" ><%=doc.field("REQ_ORGAN_NM")%></td>
									  <td height="22" align="left" ><%=doc.field("SUBMT_ORGAN_NM")%></td>
									  <td height="22" width=80><%=doc.field("LAST_ANS_DT")%></td>
									</tr>
				<!--                    <tr class="tbl-line">
									  <td>ANS_ID=|<%=doc.field("ANS_ID")%>|ANS_MTD=|<%=doc.field("ANS_MTD")%>|ANS_OPIN=|<%=doc.field("ANS_OPIN")%>|SUBMT_FLAG=|<%=doc.field("SUBMT_FLAG")%>|</td>
									</tr>
				-->
				<%
						}
					}else{
				%>
					<tr>
						<td colspan="6">검색된 결과가 없습니다.</td>
					</tr>

				<%
					}
				%>

				</table>
				<table width="100%" >
					<tr>
						<td height="35" align="center" valign="middle">
				<!-- Page Navigation -->
				<%
					if (hitCount > docPage) {
						int Total, Start, Page;
						int CurPage, StartPage, EndPage, TotalPage;
						int i;

						Total = hitCount;
						if (hitCount > maxDocs) Total = maxDocs-1;
						Start = docStart;
						Page = docPage;

						CurPage = Start / Page;
						StartPage = ( Start / ( 10 * Page ) ) * 10;
						if((Total % Page)==0)
						{
						TotalPage = (Total / Page) -1;
						}else{
						TotalPage = Total / Page;
						}

						EndPage = StartPage + 9 > TotalPage ? TotalPage : StartPage + 9;

				%>

				<%
						if (StartPage != 0) {
							out.println("<a href=\'JavaScript:GotoPage(document.PageForm, 0)\'>[First]</a>&nbsp;");
							out.println("<a href=\'JavaScript:GotoPage(document.PageForm, " + (StartPage-10) + ")\'><img src='/image/button/bt_prev.gif' border='0'></a>&nbsp;");
						}


						for (i = StartPage ; i <= EndPage ; i++) {
							if( i == CurPage ){
								out.println("<strong>["+(i+1)+"]</strong>&nbsp;");;
							}
							else {
								out.println("<a href=\'JavaScript:GotoPage(document.PageForm, " + i + ")'>" +"["+ (i+1)+"]&nbsp;</a> ");
							}
						}

						if (TotalPage > EndPage) {
							EndPage = EndPage + 1;
							out.println("&nbsp;<a href=\'JavaScript:GotoPage(document.PageForm, " + EndPage + ")'><img src='/image/button/bt_next.gif' border='0'></a>");
							out.println("&nbsp;<a href=\'JavaScript:GotoPage(document.PageForm, " + TotalPage + ")'>[End]</a>");
						}
					}
				%>
						</td>
					</tr>

				</table>
			 </div>

                <!-- /각페이지 내용 -->
			</form>
            </div>
            <!-- /contents -->

        </div>
    </div>

</div>
    <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>