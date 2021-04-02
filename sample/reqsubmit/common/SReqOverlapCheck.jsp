<%@ page language="java" contentType="text/html; charset=euc-kr" session="true" %>
<%@ page import="java.util.* "%>
<%@ page import="java.io.*" %>
<%@ page import="com.verity.search.*" %>
<%@ page import="com.verity.k2.*" %>
<%@ page import="com.verity.net.MbEncoder" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.message.MessageBean"%>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	UserInfoDelegate objUserInfo =null;
	CDInfoDelegate objCdinfo =null;
%>
<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>
<%@ include file="/reqsubmit/common/utils.jsp" %>

<%
	String strQueryText = toMulti(request.getParameter("queryText")); // 완전히 구성되지 않은 순수한 검색질의내용
	strQueryText = StringUtil.ReplaceString(strQueryText, "(", "");
	strQueryText = StringUtil.ReplaceString(strQueryText, ")", "");
	String strReturnQueryText = request.getParameter("returnQueryText"); // 검색엔진에서 요구하는 형식의 질의문
	String strReqID = request.getParameter("ReqID");
	String strReqBoxID = request.getParameter("ReqBoxID");
	String strReturnURL = StringUtil.getEmptyIfNull(request.getParameter("ReturnURL"));

	int intDocStart = 1; // 시작페이지
	int intDocPage = 10; // 페이징 수
	int intMaxDocs = 4000; // 최대 검색 개수
	Result result = null; // 검색결과를 받을 OBJECT
	int intHitCount = 0; // 검색결과 건수

	String SEARCH_SERVER_IP = "10.201.12.139";
	String SEARCH_SERVER_PORT = "9930";

	if(StringUtil.isAssigned(request.getParameter("docStart"))) intDocStart = Integer.parseInt(request.getParameter("docStart"));
	if(StringUtil.isAssigned(request.getParameter("docPage"))) intDocPage = Integer.parseInt(request.getParameter("docPage"));
	if(StringUtil.isAssigned(request.getParameter("maxDocs"))) intMaxDocs = Integer.parseInt(request.getParameter("maxDocs"));

	if (!StringUtil.isAssigned(strQueryText) && !StringUtil.isAssigned(strReturnQueryText)) {
		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  		objMsgBean.setStrCode("");
  		objMsgBean.setStrMsg("검색 질의문(QueryText)이 없습니다. 필수 입력값입니다.");
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
	  	return;
	}

	try {
		if (StringUtil.isAssigned(strQueryText) && !StringUtil.isAssigned(strReturnQueryText)) {
			// 검색어 Query String 생성
			String[] arrQueryText = StringUtil.split(" ", strQueryText);
			if (arrQueryText.length > 0) {
				for(int i=0; i<arrQueryText.length; i++) {
					if (i == 0) {
						strReturnQueryText = "("+arrQueryText[i]+")";
					} else {
						strReturnQueryText = "("+strReturnQueryText+"<AND>"+arrQueryText[i]+")";
					}
				}
			} else {
				System.out.println("문자열 배열이 안 만들어지네...");
			}
		}

		// 검색엔진 FIELD SETTING
		VSearch vs = new VSearch();

		vs.setServerSpec(SEARCH_SERVER_IP+":"+SEARCH_SERVER_PORT);
		vs.setCharMap("utf8");
		vs.setQueryParser("3soft");
		vs.setUrlStringsMode(true);
		vs.addCollection("nads");

		vs.addField("VDKPBSUMMARY");
		vs.addField("VdkVgwKey");
		vs.addField("k2dockey");

		vs.addField("REQ_ID");
		vs.addField("CMT_ORGAN_NM");
		vs.addField("REQ_ORGAN_NM");
		vs.addField("SUBMT_ORGAN_NM");
		vs.addField("LAST_ANS_DT");
		vs.addField("ANS_ID");
		//vs.addField("INX_FILE_PATH");
		vs.addField("AUDIT_YEAR");
		vs.addField("OPEN_CL");
		vs.addField("REQ_ORGAN_ID");
		vs.addField("CMT_ORGAN_ID");
		vs.addField("SUBMT_ORGAN_ID");
		vs.addField("ANS_MTD");
		vs.addField("REQ_CONT");
		vs.addField("REQ_DTL_CONT");
		vs.addField("ANS_OPIN");
		vs.addField("REQR_NM");
		vs.addField("ANSR_NM");
		vs.addField("SUBMT_FLAG");

		vs.setMaxDocCount(intMaxDocs);
		vs.setSortSpec("score desc");
		vs.setDocsStart(intDocStart);
		vs.setDocsCount(intDocPage);
		vs.setDateFormat("${yyyy}-${mm}-${dd}");
		//vs.setQueryText(toAscii(strReturnQueryText));
		vs.setQueryText(MbEncoder.encode(strReturnQueryText, "utf8"));

		result = vs.getResult();

		intHitCount = result.docsFound;
	}
	catch(Exception e) {
		System.out.println(e.getMessage());
		e.printStackTrace();
		throw new RuntimeException(e.getMessage()+e.getClass());
	}
%>

<jsp:include page="/inc/header.jsp" flush="true"/>
<script language="JavaScript">
	function GotoPage(form, docStart) {
		form.docStart.value = docStart * form.docPage.value + 1;
		form.submit();
		return;
	}

	function overlapConfirm(strReqID) {
		var f = document.PageForm;
		f.action = "/reqsubmit/common/SReqOverlapCheckProc.jsp";
		if (confirm("선택하신 요구를 중복 요구로 지정하시겠습니까?")) {
			document.all.loadingDiv.style.display = '';
			f.ReqID.value = strReqID;
			//location.href="/reqsubmit/common/SReqOverlapCheckProc.jsp?ReqID="+strReqID;
			f.submit();
		}
	}

	// 마우스가 올라갈 때 테두리를 만들고 싶으신가요? 이 스크립트를 함 써보시죠. 열라 짜증나고 불편합니다.
	function makeBorder(seq, bool) {
		var oTD = eval("document.all.idx" + seq);
		var len = oTD.length;
		var borderStyle = "1 solid #808080";

		if (bool){
			for(var i =0; i < len; i++){
				oTD[i].style.borderTop = borderStyle;
				oTD[i].style.borderBottom = borderStyle;
				oTD[i].style.backgroundColor = "";
				oTD[i].style.cursor = "default";
			}
			oTD[0].style.borderLeft = borderStyle;
			oTD[0].style.backgroundColor = "#C9EBFF";
			oTD[len-1].style.borderRight = borderStyle;

			// 오른쪽 콤보박스 이미지를 보여준다.
			//window.document.getElementById("sub"+seq).style.display = '';
		}else{
			for(var i =0; i < len; i++){
				oTD[i].style.border = "";
				oTD[i].style.backgroundColor = "#ffffff";
			}
			oTD[0].style.backgroundColor = "#f4f4f4";
			oTD[0].style.color = "";
			// 오른쪽 콤보박스 이미지를 보여준다.
			//window.document.getElementById("sub"+seq).style.display = 'none';
		}
	}
</script>

<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>
<!--
<SCRIPT language="JavaScript" src="/js/reqsubmit/reqinfo.js"></SCRIPT>
-->
</head>

<body>
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
<SCRIPT language="JavaScript" src="/js2/reqsubmit/tooltip.js"></SCRIPT>
<script language="javascript">balloonHint("balloonHint")</script>
<SCRIPT language="JavaScript" src="/js/reqsubmit/reqinfo.js"></SCRIPT>
<div class="popup">
    <p>요구 중복 조회</p>

    <table width="100%" cellpadding="0" cellspacing="0">
        <tr>
            <td width="100%" style="padding:10px;">  <!-- list -->
        <!-- <span class="list01_tl">요구 목록 <span class="list_total">&bull;&nbsp;전체자료수 : 2개 </span></span> -->




        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="popup_lis">
          <thead>
            <tr>
			  <td colspan="6"> &nbsp;* 해당 요구를 선택하시면 답변을 자동 등록시킵니다.</td>
            </tr>
            <tr>
              <th scope="col">NO</th>
			  <th scope="col">요구제목</th>
			  <th scope="col"></th>
			  <th scope="col">답변</th>
              <th scope="col">요구기관</th>
              <th scope="col" style="width:40%; ">등록연도</th>
            </tr>
          </thead>
          <tbody>
<%
	// 어떻게 정리할 방법을 좀 찾자.. 아 정신없다...
	String viewHref = "";
	Enumeration enum1 = result.documents().elements();
	int intNo = 1;
	if (intHitCount > 1) {
		while(enum1.hasMoreElements()){
			Document doc = (Document)enum1.nextElement();
			if (!strReqID.equalsIgnoreCase(doc.field("REQ_ID"))) {
%>
            <tr>
              <td><%= doc.rank %></td>
              <td>
			  <% if (StringUtil.isAssigned((String)doc.field("ANS_ID")) && "001".equalsIgnoreCase((String)doc.field("ANS_MTD"))) { %>
					<a href="javascript:overlapConfirm('<%= doc.field("REQ_ID") %>');"><%= doc.field("REQ_CONT") %></a>
				<% } else { %>
					<%= doc.field("REQ_CONT") %>
				<% } %></td>
              <td >
				<div id="sub<%= intNo %>" style="display:none"><img src="/image/reqsubmit/combo.gif" border="0"></div>
			  </td>

              <td>
				<%= nads.lib.reqsubmit.util.DBAccessUtil.makeAnsInfoHtml(doc.field("ANS_ID"),doc.field("ANS_MTD"),doc.field("ANS_OPIN"),doc.field("SUBMT_FLAG"), objUserInfo.isRequester()) %><br>
			  </td>
			  <td>
				  <%= doc.field("REQ_ORGAN_NM") %>
			  </td>
			  <td>
				 <%= doc.field("AUDIT_YEAR") %>
			  </td>
            </tr>
<%
			} // end 요청한 요구와 검색결과 요구가 같지 않은 경우만 출력하자. 왜냐 .. 같으면 중복조회 기능이 아니니깐...
		} // end while
	} else { // 만약 검색결과가 1이거나 0이라면
		if (intHitCount == 1) { // 검색 결과가 1개
			Document doc = (Document)enum1.nextElement();
			if (!strReqID.equalsIgnoreCase(doc.field("REQ_ID"))) { // 요청한 요구ID와 검색결과 요구ID가 같지 않다. 즉 다른 요구다.
%>

            <tr>

              <td><%= doc.rank %></td>
              <td>
				<% if (StringUtil.isAssigned((String)doc.field("ANS_ID")) && "001".equalsIgnoreCase((String)doc.field("ANS_MTD"))) { %>
					<a href="javascript:overlapConfirm('<%= doc.field("REQ_ID") %>');"><%= doc.field("REQ_CONT") %></a>
				<% } else { %>
					<%= doc.field("REQ_CONT") %>
				<% } %>
			  </td>
              <td >
				<div id="sub<%= intNo %>" style="display:none"><img src="/image/reqsubmit/combo.gif" border="0"></div>
			  </td>

              <td>
				<%= nads.lib.reqsubmit.util.DBAccessUtil.makeAnsInfoHtml(doc.field("ANS_ID"),doc.field("ANS_MTD"),doc.field("ANS_OPIN"),doc.field("SUBMT_FLAG"), objUserInfo.isRequester()) %><br>
			  </td>
			  <td>
				  <%= doc.field("REQ_ORGAN_NM") %>
			  </td>
			  <td>
				<%= doc.field("REG_DT") %>
			  </td>
            </tr>
<%
			} else { // 같은 요구라면 없다구 출력
%>
				<tr>
				  <td colspan="6" align="center"> 중복된 요구가 없습니다.</td>
				</tr>
<%			}
		} else { // 만약 검색결과가 0이라면
%>
				<tr>
				  <td colspan="6" align="center"> 중복된 요구가 없습니다.</td>
				</tr>
<%
		}
	}
%>
          </tbody>
        </table>

        <!-- /list -->
<!-- Page Navigation -->
<%
	if (intHitCount > intDocPage) {
		int Total, Start, Page;
		int CurPage, StartPage, EndPage, TotalPage;
		int i;

		Total = intHitCount;
		if (intHitCount > intMaxDocs) Total = intMaxDocs-1;
		Start = intDocStart;
		Page = intDocPage;

		CurPage = Start / Page;
		StartPage = ( Start / ( 10 * Page ) ) * 10;
		TotalPage = Total / Page;
		EndPage = StartPage + 9 > TotalPage ? TotalPage : StartPage + 9;
%>
<br>
<%
		if (StartPage != 0)
			out.println("<a href=\'JavaScript:GotoPage(document.PageForm, " + (StartPage-10) + ")\'> Prev 10 Page</a>&nbsp;");

		for (i = StartPage ; i <= EndPage ; i++) {
			if( i == CurPage ) out.println("<b>" + (i+1) + "</b>");
			else out.println("<a href=\'JavaScript:GotoPage(document.PageForm, " + i + ")'>" + (i+1) + "</a> ");
		}

		if (TotalPage > EndPage) {
			EndPage = EndPage + 1;
			out.println("&nbsp;<a href=\'JavaScript:GotoPage(document.PageForm, " + EndPage + ")'>Next 10 Page</a>");
		}
	}
%>


       </td>
        </tr>
    </table>
    <p style= "height:2px;padding:0;"></p>
    <!-- 리스트 버튼-->
    <div id="btn_all" class="t_right"> <span class="list_bt"><a href="#" onClick="javascript:self.close()">창닫기</a></span>&nbsp;&nbsp;</div>
<form method="post" name="PageForm" action="/reqsubmit/common/SReqOverlapCheck.jsp">
	<input type="hidden" name="ReqID" value="">
	<input type="hidden" name="NewReqID" value="<%= strReqID %>">
	<input type="hidden" name="ReqBoxID" value="<%= strReqBoxID %>">
	<input type="hidden" name="queryText" value="<%= toMulti(strQueryText) %>">
	<input type="hidden" name="returnQueryText" value="<%= toMulti(strReturnQueryText) %>">
	<input type="hidden" name="maxDocs" VALUE="<%= intMaxDocs %>">
	<input type="hidden" name="docStart" VALUE="<%= intDocStart %>">
	<input type="hidden" name="docPage" VALUE="<%= intDocPage %>">
	<input type="hidden" name="ReturnURL" VALUE="<%= strReturnURL %>">
</form>
<DIV ID="loadingDiv" style="width:300px;display:none;position:absolute;left:150;top:150">
	<img src="/image/reqsubmit/loading.gif" border="1">
</DIV>

    <!-- /리스트 버튼-->
</div>
</body>
</html>