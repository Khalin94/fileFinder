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
	String strQueryText = toMulti(request.getParameter("queryText")); // ������ �������� ���� ������ �˻����ǳ���
	strQueryText = StringUtil.ReplaceString(strQueryText, "(", "");
	strQueryText = StringUtil.ReplaceString(strQueryText, ")", "");
	String strReturnQueryText = request.getParameter("returnQueryText"); // �˻��������� �䱸�ϴ� ������ ���ǹ�
	String strReqID = request.getParameter("ReqID");
	String strReqBoxID = request.getParameter("ReqBoxID");
	String strReturnURL = StringUtil.getEmptyIfNull(request.getParameter("ReturnURL"));

	int intDocStart = 1; // ����������
	int intDocPage = 10; // ����¡ ��
	int intMaxDocs = 4000; // �ִ� �˻� ����
	Result result = null; // �˻������ ���� OBJECT
	int intHitCount = 0; // �˻���� �Ǽ�

	String SEARCH_SERVER_IP = "10.201.12.139";
	String SEARCH_SERVER_PORT = "9930";

	if(StringUtil.isAssigned(request.getParameter("docStart"))) intDocStart = Integer.parseInt(request.getParameter("docStart"));
	if(StringUtil.isAssigned(request.getParameter("docPage"))) intDocPage = Integer.parseInt(request.getParameter("docPage"));
	if(StringUtil.isAssigned(request.getParameter("maxDocs"))) intMaxDocs = Integer.parseInt(request.getParameter("maxDocs"));

	if (!StringUtil.isAssigned(strQueryText) && !StringUtil.isAssigned(strReturnQueryText)) {
		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  		objMsgBean.setStrCode("");
  		objMsgBean.setStrMsg("�˻� ���ǹ�(QueryText)�� �����ϴ�. �ʼ� �Է°��Դϴ�.");
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
	  	return;
	}

	try {
		if (StringUtil.isAssigned(strQueryText) && !StringUtil.isAssigned(strReturnQueryText)) {
			// �˻��� Query String ����
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
				System.out.println("���ڿ� �迭�� �� ���������...");
			}
		}

		// �˻����� FIELD SETTING
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
		if (confirm("�����Ͻ� �䱸�� �ߺ� �䱸�� �����Ͻðڽ��ϱ�?")) {
			document.all.loadingDiv.style.display = '';
			f.ReqID.value = strReqID;
			//location.href="/reqsubmit/common/SReqOverlapCheckProc.jsp?ReqID="+strReqID;
			f.submit();
		}
	}

	// ���콺�� �ö� �� �׵θ��� ����� �����Ű���? �� ��ũ��Ʈ�� �� �Ẹ����. ���� ¥������ �����մϴ�.
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

			// ������ �޺��ڽ� �̹����� �����ش�.
			//window.document.getElementById("sub"+seq).style.display = '';
		}else{
			for(var i =0; i < len; i++){
				oTD[i].style.border = "";
				oTD[i].style.backgroundColor = "#ffffff";
			}
			oTD[0].style.backgroundColor = "#f4f4f4";
			oTD[0].style.color = "";
			// ������ �޺��ڽ� �̹����� �����ش�.
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
		<td bgcolor="#EBF2F5" width="30" height="20" align="center" style="border-left:1px solid #808080;border-top:1px solid #808080;border-bottom:2px solid #808080;"><font style="font-size:11px;font-family:verdana,����;font-weight:bold">�䱸<BR>��<BR>����</font></td>
		<td style="border-left:1px solid #808080;border-top:1px solid #808080;border-bottom:2px solid #808080;border-right:2px solid #808080;text-align:justify;word-break:break-all;" width="220">
			<font style="font-size:11px;font-family:verdana,����">{{hint}}</font>
		</td>
	</tr>
</table>
</div>
<SCRIPT language="JavaScript" src="/js2/reqsubmit/tooltip.js"></SCRIPT>
<script language="javascript">balloonHint("balloonHint")</script>
<SCRIPT language="JavaScript" src="/js/reqsubmit/reqinfo.js"></SCRIPT>
<div class="popup">
    <p>�䱸 �ߺ� ��ȸ</p>

    <table width="100%" cellpadding="0" cellspacing="0">
        <tr>
            <td width="100%" style="padding:10px;">  <!-- list -->
        <!-- <span class="list01_tl">�䱸 ��� <span class="list_total">&bull;&nbsp;��ü�ڷ�� : 2�� </span></span> -->




        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="popup_lis">
          <thead>
            <tr>
			  <td colspan="6"> &nbsp;* �ش� �䱸�� �����Ͻø� �亯�� �ڵ� ��Ͻ�ŵ�ϴ�.</td>
            </tr>
            <tr>
              <th scope="col">NO</th>
			  <th scope="col">�䱸����</th>
			  <th scope="col"></th>
			  <th scope="col">�亯</th>
              <th scope="col">�䱸���</th>
              <th scope="col" style="width:40%; ">��Ͽ���</th>
            </tr>
          </thead>
          <tbody>
<%
	// ��� ������ ����� �� ã��.. �� ���ž���...
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
			} // end ��û�� �䱸�� �˻���� �䱸�� ���� ���� ��츸 �������. �ֳ� .. ������ �ߺ���ȸ ����� �ƴϴϱ�...
		} // end while
	} else { // ���� �˻������ 1�̰ų� 0�̶��
		if (intHitCount == 1) { // �˻� ����� 1��
			Document doc = (Document)enum1.nextElement();
			if (!strReqID.equalsIgnoreCase(doc.field("REQ_ID"))) { // ��û�� �䱸ID�� �˻���� �䱸ID�� ���� �ʴ�. �� �ٸ� �䱸��.
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
			} else { // ���� �䱸��� ���ٱ� ���
%>
				<tr>
				  <td colspan="6" align="center"> �ߺ��� �䱸�� �����ϴ�.</td>
				</tr>
<%			}
		} else { // ���� �˻������ 0�̶��
%>
				<tr>
				  <td colspan="6" align="center"> �ߺ��� �䱸�� �����ϴ�.</td>
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
    <!-- ����Ʈ ��ư-->
    <div id="btn_all" class="t_right"> <span class="list_bt"><a href="#" onClick="javascript:self.close()">â�ݱ�</a></span>&nbsp;&nbsp;</div>
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

    <!-- /����Ʈ ��ư-->
</div>
</body>
</html>