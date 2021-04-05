<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="com.verity.search.*" %>
<%@ page import="com.verity.k2.*" %>
<%@ page import="com.verity.net.MbEncoder" %>
<%@ page import="nads.dsdm.app.infosearch.common.IsSelectDelegate" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
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

		// ���� �߻� �޼��� �������� �̵��Ѵ�.
	 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
	  	objMsgBean.setStrCode(objAppEx.getStrErrCode());
	  	objMsgBean.setStrMsg(objAppEx.getMessage());
		System.out.println(objAppEx.getStrErrCode());
%>
	  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}
	IsSelectDelegate objCMDselectSubmit_Ans_Organ = new IsSelectDelegate();
	IsSelectDelegate objCMDselectSubmit_Submit_Gubun = new IsSelectDelegate();
	ArrayList objArrselectSubmit_Ans_Organ;
	ArrayList objArrselectSubmit_Gubun;


	String default_query = "";//�⺻��������
	String yearText_last = "";//������������
	String SUBMT_DATA_GBN_last = "";//������������
	String REQ_SUB_last = "";//���Ǳ����������
	String ans_organ_select_last = "";//��������������
	String deptText_last = "";//�����������

	String realqueryText = "";//������������
	String ErrStr = "";//�����޼��� ����׿�


    //�����Ķ����
	String SRCH_DISPLAY_KIND = (String)session.getAttribute("SRCH_DISPLAY_KIND");

	String SRCH_RECORD_CNT = (String)session.getAttribute("SRCH_RECORD_CNT");

	String audit_year_from = StringUtil.getEmptyIfNull(request.getParameter("audit_year_from"));
	if(audit_year_from==null || audit_year_from.equals("")) audit_year_from = (String)objHtSelectSysdate.get("YYYY");

	String audit_year_to = StringUtil.getEmptyIfNull(request.getParameter("audit_year_to"));
	if(audit_year_to==null || audit_year_to.equals("")) audit_year_to = (String)objHtSelectSysdate.get("YYYY");


	String deptText = StringUtil.getEmptyIfNull(request.getParameter("deptText"));
	if(deptText==null) deptText = "";
	String deptText00 = StringUtil.getEmptyIfNull(request.getParameter("deptText00"));
	if(deptText00==null) deptText00 = "";
	String GROUPNAME = StringUtil.getEmptyIfNull(request.getParameter("GROUPNAME"));
	if(GROUPNAME==null) GROUPNAME = "";

	String query = StringUtil.getEmptyIfNull(request.getParameter("query"));
	if(query==null) query = "";

	String MENU_CD = StringUtil.getEmptyIfNull(request.getParameter("MENU_CD"));
	if(MENU_CD==null || MENU_CD.equals("")) MENU_CD = "05";

	String submt_organ_id = StringUtil.getEmptyIfNull(request.getParameter("submt_organ_id"));
	if(submt_organ_id==null) submt_organ_id = "";

	String SUBMT_DATA_GBN = StringUtil.getEmptyIfNull(request.getParameter("SUBMT_DATA_GBN"));
	if(SUBMT_DATA_GBN==null || SUBMT_DATA_GBN.equals("")) SUBMT_DATA_GBN = "000";

	String sortField = StringUtil.getEmptyIfNull(request.getParameter("sortField"));
	if(sortField==null || sortField.equals("")) sortField = "REG_DT";

	String sortMethod = StringUtil.getEmptyIfNull(request.getParameter("sortMethod"));
	if(sortMethod==null || sortMethod.equals("")) sortMethod = " desc ";

	String currCommittee = StringUtil.getEmptyIfNull(request.getParameter("currCommittee"));
	if(currCommittee==null || currCommittee.equals("")) currCommittee = "��ü ����ȸ";


		try {//ȸ���ڷ� �����-�䱸���

			objArrselectSubmit_Ans_Organ = objCMDselectSubmit_Ans_Organ.selectSubmit_Ans_Organ();

		} catch (AppException objAppEx) {

			// ���� �߻� �޼��� �������� �̵��Ѵ�.
		 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		  	objMsgBean.setStrCode(objAppEx.getStrErrCode());
		  	objMsgBean.setStrMsg(objAppEx.getMessage());
			System.out.println(objAppEx.getStrErrCode());
	%>
		  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
	<%
			return;
		}

		try {//�������� ����/���/����

			objArrselectSubmit_Gubun = objCMDselectSubmit_Submit_Gubun.selectGubun();

		} catch (AppException objAppEx) {

			// ���� �߻� �޼��� �������� �̵��Ѵ�.
		 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		  	objMsgBean.setStrCode(objAppEx.getStrErrCode());
		  	objMsgBean.setStrMsg(objAppEx.getMessage());
			System.out.println(objAppEx.getStrErrCode());
	%>
		  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
	<%
			return;
		}

	IsSelectDelegate objCMD = new IsSelectDelegate();
	IsSelectDelegate objCMDUnder = new IsSelectDelegate();
	ArrayList objArrselectCommittee_Nads;
	ArrayList objArrselectCommitteeUnder_Nads;
	try {//������(����ȸ�Ϻ�)-�׺���̼�

		objArrselectCommittee_Nads = objCMD.selectCommittee_Nads();

	} catch (AppException objAppEx) {

		// ���� �߻� �޼��� �������� �̵��Ѵ�.
	 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
	  	objMsgBean.setStrCode(objAppEx.getStrErrCode());
	  	objMsgBean.setStrMsg(objAppEx.getMessage());
		System.out.println(objAppEx.getStrErrCode());
%>
	  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}

	try {//������(�������Ϻ�)-�׺���̼�

		objArrselectCommitteeUnder_Nads = objCMDUnder.selectCommitteeUnder_Nads(deptText);

	} catch (AppException objAppEx) {

		// ���� �߻� �޼��� �������� �̵��Ѵ�.
	 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
	  	objMsgBean.setStrCode(objAppEx.getStrErrCode());
	  	objMsgBean.setStrMsg(objAppEx.getMessage());
		System.out.println(objAppEx.getStrErrCode());
%>
	  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}

	//������ �ʱⰪ����


	String REQ_SUB = StringUtil.getEmptyIfNull(request.getParameter("REQ_SUB"));
	if(REQ_SUB==null || REQ_SUB.equals("")) REQ_SUB = "000";

	String ans_organ_select = StringUtil.getEmptyIfNull(request.getParameter("ans_organ_select"));
	if(ans_organ_select==null || ans_organ_select.equals("")) ans_organ_select = "00";


//�����Ķ����
    String serverSpec = "10.201.12.139:9931";

	int docStart = 1;
	if(request.getParameter("docStart")!=null) docStart = Integer.parseInt(request.getParameter("docStart"));

	int docPage = Integer.parseInt(SRCH_RECORD_CNT.trim());
	if(request.getParameter("docPage")!=null) docPage = Integer.parseInt(request.getParameter("docPage"));

	int maxDocs = 4000;
	if(request.getParameter("maxDocs") != null) maxDocs = Integer.parseInt(request.getParameter("maxDocs"));

	IsSelectDelegate objCMDans = new IsSelectDelegate();
	ArrayList objArrselectAns_Organ;

	try {//������(����Ⱓ+������+������åó)

		objArrselectAns_Organ = objCMDans.selectAns_Organ();

	} catch (AppException objAppEx) {

		// ���� �߻� �޼��� �������� �̵��Ѵ�.
	 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
	  	objMsgBean.setStrCode(objAppEx.getStrErrCode());
	  	objMsgBean.setStrMsg(objAppEx.getMessage());
		System.out.println(objAppEx.getStrErrCode());
%>
	  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}

	//�⺻�˻����� ����
	if (query.equals("")) {//
	default_query="";
	}else{
	default_query=" ( "+query+" <IN> Z_INX_FILE_PATH ) "+" AND ";
	}

	//���� �˻����� ����

	if (SUBMT_DATA_GBN.equals("000")) {//
	SUBMT_DATA_GBN_last="";
	}else{
	SUBMT_DATA_GBN_last=SUBMT_DATA_GBN+" <IN> Z_SUBMT_DATA_GBN ";
	}

	//�⵵ �˻����� ����
	if (SUBMT_DATA_GBN.equals("000")) {//
	yearText_last=" SUBMT_YEAR >= "+audit_year_from+" AND SUBMT_YEAR <= "+audit_year_to ;
	}else{
	yearText_last=" AND SUBMT_YEAR >= "+audit_year_from+" AND SUBMT_YEAR <= "+audit_year_to ;
	}

	//���Ǳ�� �˻����� ����

		if (REQ_SUB.equals("000")) {//
		REQ_SUB_last="";
		}else{
		REQ_SUB_last=" AND "+REQ_SUB+" <IN> Z_DLBRT_ORGAN_ID ";
		}


	//������ �˻����� ����

	if (ans_organ_select.equals("00")) {//
	ans_organ_select_last="";
	}else{
	ans_organ_select_last=" AND "+ans_organ_select+" <IN> Z_SUBMT_ORGAN_ID ";
	}



	//����ȸ�� �Ҽӱ�� �˻����� ����
	if (!deptText.equals("")) {//����ȸ���� �������

		if (deptText00.equals("")) {//������������ ���ٸ� ����ȸ�� ���� ��� �������

		deptText_last = " AND "+toMulti(deptText)+"<IN>Z_CMT_ORGAN_ID";

		} else {//������ ������ �ִٸ� �ش� �������� ���� ������ ���

		deptText_last = " AND "+toMulti(deptText)+"<IN>Z_CMT_ORGAN_ID AND "+toMulti(deptText00)+"<IN>Z_SUBMT_ORGAN_ID" ;

		}

	}

	//����ȸ�� �Ҽӱ�� �˻����ǻ���-��������

	if (deptText.equals("")) {//����ȸ������ �����Ƿ�  ����ȸ�� ���� ������� ���
		realqueryText ="";

	} else {//����ȸ������ �ִٸ� �ش�����ȸ�� ���������� ���
		realqueryText =toMulti(deptText_last);

	}


	Result result = null;
%>

<script language="JavaScript">

 function findans(){

    var http = "ISearch_Anslist.jsp";

	window.open(http,"ISearch_Anslist","resizable=yes,menubar=no,status=yes,titlebar=yes,scrollbars=yes,location=no,toolbar=no,height=600,width=530" );
}

function GotoPage(form, docStart){

		var str1=document.PageForm.query.value

		for (var i=0; i < str1.length; i++) {
			if (str1.charAt(i) == "%" |str1.charAt(i) == ">" |str1.charAt(i) == "<" |str1.charAt(i) == ">" |str1.charAt(i) == "(" |str1.charAt(i) == ")" |str1.charAt(i) == "+" |str1.charAt(i) == "," |str1.charAt(i) == "[") {
			alert("���������� �����Դϴ�.");
			document.PageForm.query.value="";
			document.PageForm.query.focus();
			return ;
            }
         }

	if(document.PageForm.query.value == '')
	{
	document.PageForm.action="./ISearch_Submit.jsp";
	}

	form.docStart.value = docStart * form.docPage.value + 1;
	form.submit();
	return;
}

function GotoCommittee(form,deptText,deptText00,GROUPNAME,currCommittee){

		var str1=document.PageForm.query.value

		for (var i=0; i < str1.length; i++) {
			if (str1.charAt(i) == "%" |str1.charAt(i) == ">" |str1.charAt(i) == "<" |str1.charAt(i) == ">" |str1.charAt(i) == "(" |str1.charAt(i) == ")" |str1.charAt(i) == "+" |str1.charAt(i) == "," |str1.charAt(i) == "[") {
			alert("���������� �����Դϴ�.");
			document.PageForm.query.value="";
			document.PageForm.query.focus();
			return ;
            }
         }

	if(document.PageForm.query.value == '')
	{
	document.PageForm.action="./ISearch_Submit.jsp";
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
	document.PageForm.action="./ISearch_Submit.jsp";
	}

		var str1=document.PageForm.query.value

		for (var i=0; i < str1.length; i++) {
			if (str1.charAt(i) == "%" |str1.charAt(i) == ">" |str1.charAt(i) == "<" |str1.charAt(i) == ">" |str1.charAt(i) == "(" |str1.charAt(i) == ")" |str1.charAt(i) == "+" |str1.charAt(i) == "," |str1.charAt(i) == "[") {
			alert("���������� �����Դϴ�.");
			document.PageForm.query.value="";
			document.PageForm.query.focus();
			return ;
            }
         }

	document.PageForm.docStart.value = 1;
	document.PageForm.sortField.value = sortField;
	document.PageForm.sortMethod.value = sortMethod;
	document.PageForm.submit();


}

function OnEnter(sortField,sortMethod)
{
	if(document.PageForm.query.value == '')
	{
	document.PageForm.action="./ISearch_Submit.jsp";
	}

		var str1=document.PageForm.query.value

		for (var i=0; i < str1.length; i++) {
			if (str1.charAt(i) == "%" |str1.charAt(i) == ">" |str1.charAt(i) == "<" |str1.charAt(i) == ">" |str1.charAt(i) == "(" |str1.charAt(i) == ")" |str1.charAt(i) == "+" |str1.charAt(i) == "," |str1.charAt(i) == "[") {
			alert("���������� �����Դϴ�.");
			document.PageForm.query.value="";
			document.PageForm.query.focus();
			return false;
            }
         }

	document.PageForm.docStart.value = 1;
	document.PageForm.sortField.value = sortField;
	document.PageForm.sortMethod.value = sortMethod;
	document.PageForm.submit();


}


function gotoDetailView(strOrganId,strSubmtOrganNm,strReqOrganId,strReqOrganNm,strGbnCode,strGovSubmtDataId){
    var http = "/reqsubmit/40_govsubdatabox/InfoSearchSGovSubDataDetailView.jsp?strOrganId=" + strOrganId + "&strSubmtOrganNm=" + strSubmtOrganNm + "&strReqOrganId=" + strReqOrganId + "&strGbnCode=" + strGbnCode + "&strReqOrganNm=" + strReqOrganNm + "&strGovSubmtDataId=" + strGovSubmtDataId;
	window.open(http,"DetailView", "resizable=no,menubar=no,status=yes,titlebar=yes,scrollbars=no,location=no,toolbar=no,height=600,width=800");
}

 function PdfFileOpen(strGovID,GPDF,query){

    var http = "/reqsubmit/common/ReqFileOpen.jsp?paramAnsId=" + strGovID + "&DOC=" + GPDF + "&keyword=" + query;
	window.open(http,"PdfView","resizable=no,menubar=no,status=yes,titlebar=yes,scrollbars=no,location=no,toolbar=no,height=600,width=800" );
}

// ����˻�

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
            <h3>ȸ���ڷ� �˻� <!-- <span class="sub_stl" >- �󼼺���</span> --></h3>
            <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> > �����˻� > ȸ���ڷ� �˻�</div>
            <p><!--����--></p>
        </div>
        <!-- /pgTit -->

        <!-- contents -->
        <div id="contents">
            <form  method=post name=PageForm action=./history/InsertUserHistoryProc.jsp >
            <!-- �������� ���� -->
            <div class="serP">
                <!-- �˻�â -->
                <div class="schBox">
						<span class="line"><img src="/images2/foundation/search_line02.gif" width="172" height="3" /></span>
                        <div class="box">
							<table width="90%" cellpadding="0" cellspacing="0" class="list_none">
								<tr>
									<td align="left" width="100" height="25"><strong>&bull;&nbsp;����</strong></td>
									<td align="left">
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
									<td align="left" width="100" height="25"><strong>&bull;&nbsp;����</strong></td>
									<td align="left">
									<select name="SUBMT_DATA_GBN" onchange="search('<%=sortField%>','<%=sortMethod%>')">
									  <option value="000" <%if (SUBMT_DATA_GBN.equals("000")) {%> selected <%}%>>��ü</option>
									  <% for(int i=0; i < objArrselectSubmit_Gubun.size(); i++){
									      Hashtable objHashBSorts = (Hashtable)objArrselectSubmit_Gubun.get(i);
									  %>
									  <option value="<%=objHashBSorts.get("MSORT_CD")%>"  <%if ((toMulti(SUBMT_DATA_GBN)).equals(objHashBSorts.get("MSORT_CD"))) {%> selected <%}%>><%=objHashBSorts.get("CD_NM")%></option>
									  <%}%>
									</select>
									</td>
								</tr>
								<tr>
									<td align="left" width="100" height="25"><strong>&bull;&nbsp;�����</strong></td>
									<td align="left">
									<select name="REQ_SUB" onchange="search('<%=sortField%>','<%=sortMethod%>')">
									  <option value="000" <%if (REQ_SUB.equals("000")) {%> selected <%}%>>��ü</option>
									  <% for(int i=0; i < objArrselectSubmit_Ans_Organ.size(); i++){
									   	  Hashtable objHashBSorts = (Hashtable)objArrselectSubmit_Ans_Organ.get(i);
									  %>
									  <option value="<%=objHashBSorts.get("ORGAN_ID")%>"  <%if ((toMulti(REQ_SUB)).equals(objHashBSorts.get("ORGAN_ID"))) {%> selected <%}%>><%=objHashBSorts.get("ORGAN_NM")%></option>
									  <%}%>
									</select>
									</td>
								</tr>
								<tr>
									<td align="left" width="100" height="25"><strong>&bull;&nbsp;������</strong></td>
									<td align="left">
									<select name="ans_organ_select" onchange="search('<%=sortField%>','<%=sortMethod%>')">
									  <option value="00"  <%if (ans_organ_select.equals("00")) {%> selected <%}%>>��ü</option>
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
									<td align="left"><strong>&bull;&nbsp;Ű����</strong></td>
									<td align="left">
									<input name="query" type="text" class="textfield" style="WIDTH: 368px"  value="<%=toMulti(query)%>" maxlength=32 onKeyDown="JavaScript: if(event.keyCode == 13) {return OnEnter();};">
										<input type="hidden" name=maxDocs VALUE="<%=maxDocs%>">
										<input type="hidden" name=docStart VALUE="<%=docStart%>">
										<input type="hidden" name=docPage VALUE="<%=docPage%>">
										<input type="hidden" name=MENU_CD VALUE="<%=MENU_CD%>">
										<input type="hidden" name="strOrganId" > <!--������ id -->
										<input type="hidden" name="strSubmtOrganNm" > <!--�������� -->
										<input type="hidden" name="strReqOrganId" > <!--����� id -->
										<input type="hidden" name="strReqOrganNm" > <!--������� -->
										<input type="hidden" name="strGbnCode" > <!--ȸ���ڷ� �ڵ� -->
										<input type="hidden" name="strGovSubmtDataId" > <!--ȸ���ڷ� id -->
										<input type="hidden" name=sortField VALUE="<%=sortField%>">
										<input type="hidden" name=sortMethod VALUE="<%=sortMethod%>">
										<input type="hidden" name=GROUPNAME VALUE="<%=GROUPNAME%>">
										<input type="hidden" name=deptText value="<%=toMulti(deptText)%>">
										<input type="hidden" name=deptText00 value="<%=toMulti(deptText00)%>">
										<input type="hidden" name=currCommittee VALUE="<%=currCommittee%>">
									</td>
								</tr>
								<tr>
									<td colspan="2" align="center"></td>
                                </tr>
							</table>
							<!-- �˻� ��ư-->
                            <div style="text-align:center;">
							<a href="JavaScript:search('<%=sortField%>','<%=sortMethod%>');"><img src="../images2/btn/bt_search02.gif" width="68" height="28" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"></a>&nbsp;<a href="ISearch_Submit.jsp"><img src="../images2/btn/bt_start.gif" width="81" height="28" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"/></a>
                            </div>
						</div>
                </div>


                <!-- /�˻�â  -->
				<span class="list02_tl">����ȸ�� �˻� �Ǽ� - <%=currCommittee%> </span>
                <table border="0" cellspacing="0" cellpadding="3" width="719" class="list02">
                    <!--ī�װ� ���� -->
					<%String temp=default_query+SUBMT_DATA_GBN_last+yearText_last+REQ_SUB_last+ans_organ_select_last;%>

                    <tbody>

					<%
						if (deptText.equals("")) {


						try {
							VSearch vs = new VSearch();

							vs.setServerSpec(serverSpec);
							vs.setCharMap("utf8");
							vs.setQueryParser("3soft");
							vs.setUrlStringsMode(true);
							vs.addCollection("submit");
							vs.setMaxDocCount(1);
							vs.disableConnectionPooling(true);

							int phitCount = 0;
							String cnt_string="";
							int j=0;
							for(int i=0; i < objArrselectCommittee_Nads.size(); i++){
							Hashtable objHashBSorts = (Hashtable)objArrselectCommittee_Nads.get(i);
							j=i%4;
							//out.println("<br>j="+j+" i="+i+" ::"+objHashBSorts.get("ORGAN_NM"));

							cnt_string = default_query+objHashBSorts.get("ORGAN_ID")+"<IN>Z_CMT_ORGAN_ID"+" AND "+SUBMT_DATA_GBN_last+yearText_last+REQ_SUB_last+ans_organ_select_last;
							ErrStr=cnt_string;
							//out.println("<br>cnt_string="+replace(replace(toMulti(cnt_string), "<", "&lt;"),">","&gt")+"<br>");
							//vs.setQueryText(toAscii(cnt_string));
							vs.setQueryText(MbEncoder.encode(cnt_string, "utf8"));
							result = vs.getResult();
							phitCount = result.docsFound;
					%>


						<%	if (j==3){ %>
										  <td  height="22"><a href="JavaScript:GotoCommittee(document.PageForm,'<%=objHashBSorts.get("ORGAN_ID")%>','','<%=objHashBSorts.get("ORGAN_NM")%>','<%=objHashBSorts.get("ORGAN_NM")%>')"><%=objHashBSorts.get("ORGAN_NM")%></a>(<%=phitCount%>)</td>
										<tr>
										</tr>

						<%	}else{ %>
										  <td  height="22"><a href="JavaScript:GotoCommittee(document.PageForm,'<%=objHashBSorts.get("ORGAN_ID")%>','','<%=objHashBSorts.get("ORGAN_NM")%>','<%=objHashBSorts.get("ORGAN_NM")%>')"><%=objHashBSorts.get("ORGAN_NM")%></a>(<%=phitCount%>)</td>
						<%}%>

					<%	}

						} catch(Exception e) {
							throw new RuntimeException(e.getMessage()+e.getClass()+"<br>cnt1|"+replace(replace(toMulti(ErrStr), "<", "&lt;"),">","&gt")+"|");
						}




						} else {

						try {

							VSearch vs = new VSearch();

							vs.setServerSpec(serverSpec);
							vs.setCharMap("utf8");
							vs.setQueryParser("3soft");
							vs.setUrlStringsMode(true);
							vs.addCollection("submit");
							vs.setMaxDocCount(1);
							vs.disableConnectionPooling(true);
							vs.setSortSpec("REG_DT desc");

							int phitCount = 0;
							String cnt_string="";
							int j=0;

							if(objArrselectCommitteeUnder_Nads.size() == 0){
							 out.println("<td  height='22' align='center'>�Ϻα���� �����ϴ�.</td>");
							 }
							for(int i=0; i < objArrselectCommitteeUnder_Nads.size(); i++){
							Hashtable objHashBSorts = (Hashtable)objArrselectCommitteeUnder_Nads.get(i);

							j=i%4;


								if (deptText.equals("")) {

								cnt_string =default_query+objHashBSorts.get("ORGAN_ID")+"<IN>Z_CMT_ORGAN_ID"+" AND "+SUBMT_DATA_GBN_last+yearText_last+REQ_SUB_last+ans_organ_select_last;

								}else{

								cnt_string = default_query+deptText+"<IN>Z_CMT_ORGAN_ID AND "+objHashBSorts.get("ORGAN_ID")+"<IN>Z_SUBMT_ORGAN_ID"+" AND "+SUBMT_DATA_GBN_last+yearText_last+REQ_SUB_last+ans_organ_select_last;
								}
							ErrStr=cnt_string;
							//out.println("<br>cnt_string="+replace(replace(toMulti(cnt_string), "<", "&lt;"),">","&gt")+"<br>");
							//vs.setQueryText(toAscii(cnt_string));
							vs.setQueryText(MbEncoder.encode(cnt_string, "utf8"));
							result = vs.getResult();
							phitCount = result.docsFound;
					%>
						<%	if (j==3){ %>
										  <td  height="22"><a href="JavaScript:GotoCommittee(document.PageForm,'<%=deptText%>','<%=objHashBSorts.get("ORGAN_ID")%>','<%=objHashBSorts.get("ORGAN_NM")%>','<%=currCommittee%>')"><%=objHashBSorts.get("ORGAN_NM")%></a>(<%=phitCount%>)</td>
										<tr>
										</tr>
						<%	}else{ %>
										  <td  height="22"><a href="JavaScript:GotoCommittee(document.PageForm,'<%=deptText%>','<%=objHashBSorts.get("ORGAN_ID")%>','<%=objHashBSorts.get("ORGAN_NM")%>','<%=currCommittee%>')"><%=objHashBSorts.get("ORGAN_NM")%></a>(<%=phitCount%>)</td>
						<%}%>


					<%	}
						} catch(Exception e) {
							throw new RuntimeException(e.getMessage()+e.getClass()+"<br>cnt2|"+replace(replace(toMulti(ErrStr), "<", "&lt;"),">","&gt")+"|");
						}
					%>
					<%}%>

					<!--ī�װ� �� -->

                        <tr></tr>
					</tbody>
				</table>

				<!--�˻���� ���� -->
				<%
					try {
						VSearch vs = new VSearch();

						vs.setServerSpec(serverSpec);
						vs.setCharMap("utf8");
						vs.setQueryParser("3soft");
						vs.setUrlStringsMode(true);
						vs.addCollection("submit");
						vs.disableConnectionPooling(true);

						vs.addField("VDKPBSUMMARY");
						vs.addField("SUBMT_DATA_ID");
						vs.addField("REG_DT");
						vs.addField("APD_PDF_FILE_PATH");
						vs.addField("APD_ORG_FILE_PATH");
						vs.addField("APD_TOC_FILE_PATH");
						vs.addField("REGR_ID");
						vs.addField("ILKMS_REG_FLAG");
						vs.addField("ILKMS_REG_DT");
						vs.addField("INX_FILE_PATH");
						vs.addField("DLBRT_ORGAN_ID");
						vs.addField("SUBMT_ORGAN_ID");
						vs.addField("DLBRT_ORGAN_NM");
						vs.addField("SUBMT_ORGAN_NM");
						vs.addField("SUBMT_DATA_GBN");
						vs.addField("SUBMT_YEAR");
						vs.addField("DATA_NM");
						vs.addField("DLBRT_HIGH_ORGAN_ID");

						vs.setMaxDocCount(maxDocs);
						vs.setDocsStart(docStart);
						vs.setDocsCount(docPage);
						vs.setSortSpec(sortField+sortMethod);
						vs.setDateFormat("${yyyy}-${mm}-${dd}");

						realqueryText=default_query+SUBMT_DATA_GBN_last+yearText_last+REQ_SUB_last+ans_organ_select_last+realqueryText;

						//vs.setQueryText(toAscii(realqueryText));
						//out.println("realqueryText=>"+realqueryText);
						vs.setQueryText(MbEncoder.encode(realqueryText, "utf8"));

						result = vs.getResult();
					}
					catch(Exception e) {
						throw new RuntimeException(e.getMessage()+e.getClass()+"<br>realqueryText|"+replace(replace(toMulti(realqueryText), "<", "&lt;"),">","&gt")+"|");
					}

					//�˻� ��� Print
					int hitCount = result.docsFound;
				%>
				<!--�˻���� �� -->
				<!--<br>�˻��� ����:<b><%=replace(replace(toMulti(realqueryText), "<", "&lt;"),">","&gt")%></b>-->
				<br /><br />
				<span class="list01_tl">�˻���� <span class="list_total">&bull;&nbsp;��ü�ڷ�� : <%=hitCount%>��</span></span>
				<br />
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
					<thead>
					<tr align="center">
						<th scope="col">NO</th>
						<th scope="col"><a href="javascript:search('SUBMT_ORGAN_NM','<%if(sortMethod.equals(" asc ")){out.println(" desc ");}else{out.println(" asc ");}%>');">������<%if(sortField.equals("SUBMT_ORGAN_NM")){if(sortMethod.equals(" asc ")){out.println(" �� ");}else{out.println(" �� ");}}%></a></th>
						<th scope="col"><a href="javascript:search('DLBRT_ORGAN_NM','<%if(sortMethod.equals(" asc ")){out.println(" desc ");}else{out.println(" asc ");}%>');">����� <%if(sortField.equals("DLBRT_ORGAN_NM")){if(sortMethod.equals(" asc ")){out.println(" �� ");}else{out.println(" �� ");}}%></a></th>
						<th scope="col"><a href="javascript:search('DATA_NM','<%if(sortMethod.equals(" asc ")){out.println(" desc ");}else{out.println(" asc ");}%>');">���⳻��<%if(sortField.equals("DATA_NM")){if(sortMethod.equals(" asc ")){out.println(" �� ");}else{out.println(" �� ");}}%></a></th>
						<th scope="col">����</th>
						<th scope="col"><a href="javascript:search('REG_DT','<%if(sortMethod.equals(" asc ")){out.println(" desc ");}else{out.println(" asc ");}%>');">�����<%if(sortField.equals("REG_DT")){if(sortMethod.equals(" asc ")){out.println(" �� ");}else{out.println(" �� ");}}%></a></th>
                    </tr>
					</thead>
					<%
						if (hitCount !=0) {
							String VDKPBSUMMARY = "";
							Enumeration enum1 = result.documents().elements();
							while(enum1.hasMoreElements()){
								Document doc = (Document)enum1.nextElement();
								VDKPBSUMMARY = replace(doc.field("VDKPBSUMMARY"),"\"", "'");//VDKSUMMARY�� "�� ������� '�� ��ȯ(alt�ױ׿��� ������)
					%>
					<tr  align="center" >
						<td><%=doc.rank%></td>
						<td><%=doc.field("SUBMT_ORGAN_NM")%></td>
						<td><%=doc.field("DLBRT_ORGAN_NM")%></td>
						<td style="text-align:left;"><a href="javascript:gotoDetailView('<%=doc.field("SUBMT_ORGAN_ID")%>','<%=doc.field("SUBMT_ORGAN_NM")%>','<%=doc.field("DLBRT_ORGAN_ID")%>','<%=doc.field("DLBRT_ORGAN_NM")%>','<%=doc.field("SUBMT_DATA_GBN")%>','<%=doc.field("SUBMT_DATA_ID")%>');"><%=doc.field("DATA_NM")%></a></td>
						<td><a href="javascript:PdfFileOpen('<%=doc.field("SUBMT_DATA_ID")%>','GPDF','<%=query%>');"><img src="/image/common/icon_pdf.gif" border="0" alt="<%=doc.field("VDKPBSUMMARY")%>"></a></td>
						<td><%=doc.field("REG_DT")%></td>
					</tr>
					<%
							}
						}else{
					%>
                    <tr>
						<td colspan="6">�˻��� ����� �����ϴ�.</td>
                    </tr>
					<%
						}
					%>

				</table>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td height="35" align="center" valign="middle"><div align="center">
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
					<tr>
						<td height="35" align="left" valign="top">&nbsp;</td>
					</tr>
				</table>
                <!-- /�������� ���� -->
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