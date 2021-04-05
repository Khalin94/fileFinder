<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="com.verity.search.*" %>
<%@ page import="com.verity.k2.*" %>
<%@ page import="com.verity.net.MbEncoder" %>
<%@ page import="nads.dsdm.app.infosearch.common.IsSelectDelegate" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.message.MessageBean"%>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<jsp:include page="/inc/header.jsp" flush="true"/>

<%@ include file="utils.jsp" %>
<%

	IsSelectDelegate objCMD = new IsSelectDelegate();
	ArrayList objArrselectNews;

	try {

		objArrselectNews = objCMD.selectNews("70");

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

	String serverSpec = "10.201.12.139:9932";
	String realqueryText = "";
	String deptText_last = "";
	
	System.out.println("1111");
    //�����Ķ����
	String SRCH_DISPLAY_KIND = "0";

	String SRCH_RECORD_CNT = "10";

	String ri = StringUtil.getEmptyIfNull(request.getParameter("ri"));
	if(ri==null) ri = "";

	String query = StringUtil.getEmptyIfNull(request.getParameter("query"));
	if(query==null) query = "";

	String queryText = StringUtil.getEmptyIfNull(request.getParameter("queryText"));
	if(queryText==null) queryText = "";

	String deptText = StringUtil.getEmptyIfNull(request.getParameter("deptText"));
	if(deptText==null) deptText = "";


	String MENU_CD = StringUtil.getEmptyIfNull(request.getParameter("MENU_CD"));
	if(MENU_CD==null || MENU_CD.equals("")) MENU_CD = "04";
	System.out.println("22222");

//�����Ķ����
	int docStart = 1;
	if(request.getParameter("docStart")!=null) docStart = Integer.parseInt(request.getParameter("docStart"));
System.out.println("44444");
	int docPage = Integer.parseInt(SRCH_RECORD_CNT.trim());
	System.out.println("qwqwqw");
	if(request.getParameter("docPage")!=null) docPage = Integer.parseInt(request.getParameter("docPage"));
System.out.println("555555");
	int maxDocs = 4000;
	if(request.getParameter("maxDocs") != null) maxDocs = Integer.parseInt(request.getParameter("maxDocs"));
System.out.println("666666");

    if (queryText.equals("")) {
		if (!deptText.equals("")) realqueryText = deptText+"<IN>Z_GROUPID";
	}
	else {
		//queryText = "`" + queryText + "`";
		if (deptText.equals("")) realqueryText =toMulti(queryText);
		else realqueryText = "("+deptText+"<IN>Z_GROUPID)<AND>("+toMulti(queryText)+")";
	}
System.out.println("777777");
	Result result = null;
	
	try {
		VSearch vs = new VSearch();

		vs.setServerSpec(serverSpec);
		vs.setCharMap("utf8");
		vs.setQueryParser("3soft");
		vs.setUrlStringsMode(true);
		vs.addCollection("news");
		vs.addCollection("news_sigawin");
		vs.disableConnectionPooling(true);

		vs.addField("VDKPBSUMMARY");
		vs.addField("TITLE");
		vs.addField("GROUPCODE00");
		vs.addField("GROUPCODE01");
		vs.addField("GROUPCODE02");
		vs.addField("GROUPNAME00");
		vs.addField("GROUPNAME01");
		vs.addField("GROUPNAME02");
		vs.addField("GETDATE");
		vs.addField("REGDATE");

		vs.setMaxDocCount(maxDocs);
//		vs.setSortSpec("Score desc");
		vs.setSortSpec("GETDATE desc");
		vs.setDateFormat("${yyyy}-${mm}-${dd} ${hh24}:${mi}:${ss}");
		vs.setDocsStart(docStart);
		vs.setDocsCount(docPage);
		vs.setQueryText(MbEncoder.encode(realqueryText, "utf8"));
		//vs.setQueryText(toAscii(realqueryText));

		//������๮ ó�� ����
		vs.setSummaryMaxPassageCount(1);
		vs.setSummaryMaxPassageBytes(300);

		VFieldHighlightParameters objFieldHLParams = vs.getFieldHighlightParameters();
		objFieldHLParams.addFieldHighlight("TITLE", "<b>", "</b>");
		objFieldHLParams.addFieldHighlight("VDKPBSUMMARY", "<b>", "</b>");

		result = vs.getResult();

	} catch(Exception e) {
		System.out.println("ISearch_News : "+e.getMessage());
%>
	<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}

	//�˻� ��� Print
	int hitCount = result.docsFound;
%>
<script language="JavaScript">
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
	document.PageForm.action="./ISearch_News2.jsp";
	}
	form.docStart.value = docStart * form.docPage.value + 1;
	form.submit();
	return;
}

function search()
{

	var vQuery=""; //��������
	var vQueryText=""; //�������� + ��������

	vQueryText = document.PageForm.queryText.value;
	vQuery = document.PageForm.query.value;//�˻�â�Է°�

	if (document.PageForm.ri.checked) {
	  if (vQueryText != "" && vQuery != "") vQueryText = '(' + vQueryText + ')' + '<and>';
	  if (vQuery != "") vQueryText = vQueryText + "`" + vQuery + "`";
	}
	else {
	  if(vQuery != "") vQueryText = "`" + vQuery + "`";
	  else vQueryText = "";
	}

	if(document.PageForm.query.value == '') {
	  document.PageForm.action="./ISearch_News2.jsp";
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
	document.PageForm.queryText.value = vQueryText;
	document.PageForm.submit();
}

</script>
</head>
<body>
<div id="wrap">
<div id="container">
    <div id="leftCon">
    </div>

        <div id="rightCon">
            <!-- pgTit -->
            <div id="pgTit" style="background:url(/images2/foundation/stl_bg_search.jpg) no-repeat left top;">
                <h3>�Ź��˻�<!-- <span class="sub_stl" >- �󼼺���</span> --></h3>
                <div class="navi"></div>
                <p><!--����--></p>
            </div>
            <!-- /pgTit -->

            <!-- contents -->

            <div id="contents">
                <form  method=post name=PageForm action='./history/InsertUserHistoryProc3.jsp'>
                <!-- �������� ���� -->

                <div class="serP">

                    <!-- �˻�â -->

                    <div class="schBox"> <span class="line"><img src="/images2/foundation/search_line02.gif" width="172" height="3" /></span>
                        <div class="box" style="text-align:center;">
						 <ul>
                           <li>
							<!-- ������ �˻� ����Ʈ�� ��ư�� ��������-->
							 <select name="deptText" class="select" onchange="search()">
							  <option value="" <%if(deptText.equals("")) {%> selected <%}%>>��ü����</option>
							  <% for(int i=0; i < objArrselectNews.size(); i++){
							 	Hashtable objHashBSorts = (Hashtable)objArrselectNews.get(i);
								if(!((String)objHashBSorts.get("NAME")).equals("����Ź�") && !((String)objHashBSorts.get("NAME")).equals("�Ѱܷ��Ź�")){
							  %>
							  <option value="<%=objHashBSorts.get("GROUPID")%>" <%if((toMulti(deptText)).equals(objHashBSorts.get("GROUPID"))) {%> selected <%}%>><%=objHashBSorts.get("NAME")%></option>
							  <%}}//end for%>
                             </select>&nbsp;
						 	 <input name="query" type="text" class="colBar" value="<%=toMulti(query)%>" maxlength=32 onKeyDown="JavaScript: if(event.keyCode == 13) {return search();};" ><a href="JavaScript:search();"><img src="../images2/btn/bt_search02.gif" width="68" height="28" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);" /></a>
                             <input type="checkbox" name="ri"  class="borderNo"  <%if (!ri.equals("")) {%> checked <%}%>/>����� ��˻�
                            </li>
                            <li>
							 <input type=hidden name=queryText value="<%=toMulti(queryText)%>">
							 <input type=hidden name=maxDocs VALUE="<%=maxDocs%>">
							 <input type=hidden name=docStart VALUE="<%=docStart%>">
							 <input type=hidden name=docPage VALUE="<%=docPage%>">
							 <input type=hidden name=MENU_CD VALUE="<%=MENU_CD%>">
                            </li>
                           </ul>
                        </div>
                    </div>
                    <!-- /�˻�â  -->
					<%if(!queryText.equals("")){%>
					<span>�˻���&nbsp;<span style="color:#ea5e11">"<%=replace(replace(toMulti(queryText), "<", "&lt;"),">","&gt")%>"</span>���� <span style="color:#ea5e11">(<%=hitCount%>)</span>�Ǽ��� ����� ���Խ��ϴ�. </span>
                    <%}%>
					<ul class="result">
					<%
					if (hitCount !=0) {
					  String viewHref = "";
					  String temp = "";
					  int i=0;
					  Enumeration enum1 = result.documents().elements();
						while(enum1.hasMoreElements()){
					  	 Document doc = (Document)enum1.nextElement();
						 temp =query;
						 i++;
						 int j=i%2;
					%>
						<li>
							<div>
								<a href="<%=doc.field("url")%>"  <%if (SRCH_DISPLAY_KIND.trim().equals("0")) { out.println("target='_blank'");}%>><%=doc.rank%>. <%=(doc.title)%></a>
								<p>
									<%=doc.field("GROUPNAME00")%>><%=doc.field("GROUPNAME01")%>><%=doc.field("GROUPNAME02")%>>���ͳ��� <%=doc.field("GETDATE").substring(0,10)%>��
								</p>
							</div>
							<%=doc.field("VDKPBSUMMARY")%><br>
						</li>
					<% }//while %>
					<%}else{%>
                        <li>�˻��� ����� �����ϴ�.</li>
					<%}%>
					</ul>
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr valign="middle">
							<td height="35" colspan="2" align="center" valign="middle">
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

							//		out.println("Total % Page="+Total % Page+"<br>");
									if((Total % Page)==0)
									{
									TotalPage = (Total / Page) -1;
									}else{
									TotalPage = Total / Page;
									}
							//		out.println("TotalPage="+TotalPage+"<br>");

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
                </form>
                <!-- /�������� ���� -->
            </div>
            <!-- /contents -->

        </div>
    </div>

</div>
</div>
</body>
</html>