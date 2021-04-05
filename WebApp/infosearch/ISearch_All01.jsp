<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="com.verity.search.*" %>
<%@ page import="com.verity.k2.*" %>
<%@ page import="com.verity.net.MbEncoder" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="nads.lib.message.MessageBean"%>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<jsp:include page="/inc/header.jsp" flush="true"/>

<%@ include file="utils.jsp" %>
<%@ include file="/common/CheckSession.jsp" %>
<%@ page errorPage = "bad.jsp" %>
<%
	String squery = nads.lib.reqsubmit.util.StringUtil.getEmptyIfNull(request.getParameter("iptName"));
	if(squery==null || squery.equals("")) squery = "";
	String sflag = nads.lib.reqsubmit.util.StringUtil.getEmptyIfNull(request.getParameter("sflag"));
	if(sflag==null || sflag.equals("")) sflag = "1";

	String sortField = nads.lib.reqsubmit.util.StringUtil.getEmptyIfNull(request.getParameter("sortField"));
	if(sortField==null || sortField.equals("")){
		if(sflag.equals("1")) sortField = "LAST_ANS_DT";
		else if (sflag.equals("5")) sortField = "REG_DT";
		else sortField = "score";
	}

    String SRCH_RECORD_CNT = nads.lib.reqsubmit.util.StringUtil.getEmptyIfNull(request.getParameter("SRCH_RECORD_CNT"));
	if(SRCH_RECORD_CNT.equals("") || SRCH_RECORD_CNT == null) SRCH_RECORD_CNT = "10";

	String sortMethod = nads.lib.reqsubmit.util.StringUtil.getEmptyIfNull(request.getParameter("sortMethod"));
	if(sortMethod==null || sortMethod.equals("")) sortMethod = " desc ";

	int maxDocs = 4000;
	if(request.getParameter("maxDocs") != null) maxDocs = Integer.parseInt(nads.lib.reqsubmit.util.StringUtil.getEmptyIfNull(request.getParameter("maxDocs")));

	int docStart = 1;
	if(request.getParameter("docStart")!=null) docStart = Integer.parseInt(nads.lib.reqsubmit.util.StringUtil.getEmptyIfNull(request.getParameter("docStart")));

	int docPage = Integer.parseInt(SRCH_RECORD_CNT.trim());

    //�䱸 �� ������ ����
 	boolean IS_REQUESTER=false;
	if(session.getAttribute("IS_REQUESTER").equals("true")) IS_REQUESTER=true;

	//�䱸�ڸ� �䱸���ID �����ڸ� ������ ID
	String ORGAN_ID=(String)session.getAttribute("ORGAN_ID");
	String SRCH_DISPLAY_KIND = (String)session.getAttribute("SRCH_DISPLAY_KIND");

	String serverSpec1 = "10.201.12.139:9930";
    String serverSpec2 = "10.201.12.139:9932";
    String serverSpec3 = "10.201.12.139:9931";
	String SortSpec="";
	String default_query = "";
    String realqueryText ="";

	//�⺻�˻����� ����(�����Ȱ��̰ų� �ڽ��� �䱸�� �������ڷῡ���� �����ش�)
	if(IS_REQUESTER) default_query="((001<IN>Z_OPEN_CL)<OR>("+ORGAN_ID+"<IN>Z_REQ_ORGAN_ID))";
	else default_query="("+ORGAN_ID+"<IN>Z_SUBMT_ORGAN_ID)";

	Result result01 = null;
	Result result02 = null;
	Result result03 = null;

	try {//�ڷ�����˻�_���
		VSearch vs = new VSearch();

		vs.setServerSpec(serverSpec1);
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
		vs.addField("INX_FILE_PATH");
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

		vs.setMaxDocCount(maxDocs);
        vs.setDocsStart(docStart);
		vs.setDocsCount(docPage);
        vs.setDateFormat("${yyyy}-${mm}-${dd}");
		vs.disableConnectionPooling(true);

		if(sortMethod.equals("") || sortMethod == null) sortMethod = " desc";
		//vs.setSortSpec(sortField+sortMethod);

		if (squery.equals("")) realqueryText = default_query;
		else realqueryText = squery + "<AND>" +default_query;

        //out.println("<br>�˻��� ����1:<b>"+replace(replace(toMulti(realqueryText), "<", "&lt;"),">","&gt")+"</b>");
		vs.setQueryText(MbEncoder.encode(realqueryText, "utf8"));
		result01 = vs.getResult();

		//�ڷ����⿡���� ���� �����̹Ƿ� �ٸ��˻������� Only Ű���常���� �ϱ����� �˻�����ʱ�ȭ
		realqueryText = squery;
	}
	catch(Exception e) {
	  	  System.out.println("ISearch_All01_1 : "+e.getMessage());
    }

	try {//�����˻�
		VSearch vs = new VSearch();
		vs.setServerSpec(serverSpec2);
		vs.setCharMap("utf8");
		vs.setQueryParser("3soft");
		vs.setUrlStringsMode(true);
		vs.addCollection("news");
		vs.addCollection("news_sigawin");
		vs.setMaxDocCount(0);
		vs.disableConnectionPooling(true);

        //out.println("<br>�˻��� ����4:<b>"+replace(replace(toMulti(realqueryText), "<", "&lt;"),">","&gt")+"</b>");
		vs.setQueryText(MbEncoder.encode(realqueryText, "utf8"));
		result02 = vs.getResult();
	}
	catch(Exception e) {
	   System.out.println("ISearch_All01_2 : "+e.getMessage());
    }

	try {//���������ڷ�˻�
		VSearch vs = new VSearch();
		vs.setServerSpec(serverSpec3);
		vs.setCharMap("utf8");
		vs.setQueryParser("3soft");
		vs.setUrlStringsMode(true);
		vs.addCollection("submit");
		vs.setMaxDocCount(0);
		vs.disableConnectionPooling(true);

        //out.println("<br>�˻��� ����4:<b>"+replace(replace(toMulti(realqueryText), "<", "&lt;"),">","&gt")+"</b>");
        vs.setQueryText(MbEncoder.encode(realqueryText, "utf8"));
		result03 = vs.getResult();
	}
    catch(Exception e) {
	  	  System.out.println("ISearch_All01_3 : "+e.getMessage());
    }

	//�˻� ��� Print
	int hitCount01 = result01.docsFound;
	int hitCount04 = result02.docsFound;
	int hitCount05 = result03.docsFound;
%>

<script language="JavaScript">
<!--
function GotoPage(form, docStart){
	form.docStart.value = docStart * form.docPage.value + 1;
	form.submit();
	return;
}

function gotoDetailView(ReqInfoID){
    var http = "/reqsubmit/common/ISearchNadsVList.jsp?ReqInfoID=" + ReqInfoID;
	window.open(http,"DetailView","resizable=no,menubar=no,status=yes,titlebar=yes,scrollbars=yes,location=no,toolbar=no,height=600,width=800" );
}

function gotoLink(str){
    var http = "./ISearch_All06.jsp?query=" + str;
	window.open(http,"gotoLink","resizable=yes,menubar=yes,status=yes,titlebar=yes,scrollbars=yes,location=yes,toolbar=yes,height=600,width=800" );
}
//-->
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
            <h3>���հ˻� <!-- <span class="sub_stl" >- �󼼺���</span> --></h3>
            <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> > �����˻� > ���հ˻�</div>
            <p><!--����--></p>
        </div>
        <!-- /pgTit -->

        <!-- contents -->

        <div id="contents">

            <!-- �������� ���� -->

            <div class="serP">

                <!-- �˻�â -->
				<form method="post" name="dummy">
                <div class="schBox">
							<input type=hidden name=maxDocs VALUE="<%=maxDocs%>">
							<input type=hidden name=docStart VALUE="<%=docStart%>">
							<input type=hidden name=docPage VALUE="<%=docPage%>">
							<input type=hidden name=sortField VALUE="<%=sortField%>">
							<input type=hidden name=sortMethod VALUE="<%=sortMethod%>">
							<input type="hidden" name="strOrganId" > <!--������ id -->
							<input type="hidden" name="strSubmtOrganNm" > <!--�������� -->
							<input type="hidden" name="strReqOrganId" > <!--����� id -->
							<input type="hidden" name="strReqOrganNm" > <!--������� -->
							<input type="hidden" name="strGbnCode" > <!--ȸ�ǵ���ڷ� �ڵ� -->
							<input type="hidden" name="strGovSubmtDataId" > <!--ȸ�ǵ���ڷ� id -->

						<span class="line"><img src="/images2/foundation/search_line02.gif" width="172" height="3" /></span>
                        <div class="box" style="height:36px;padding-top:25px; text-align:center;">
                            <!-- ������ �˻� ����Ʈ�� ��ư�� ��������--><img src="../images2/foundation/search_tl.gif" width="58" height="15" />&nbsp;
                        <input name="iptName" type="text" value="<%=toMulti(squery)%>" maxlength=32 onKeyDown="JavaScript: if(event.keyCode == 13) {return ChkStr(2);};"/>
                        &nbsp;<a href="JavaScript:SearchPageForm('<%=sortField%>','<%=sortMethod%>','2');"><img src="../images2/btn/bt_search02.gif" width="68" height="28" /></a></div>
                </div>
                    <!-- /�˻�â  -->
                    <%if(!squery.equals("")){%>
					<span class="list02_tl">(<span style="color:#ea5e11"><%=replace(replace(toMulti(squery), "<", "&lt;"),">","&gt")%></span>) ���� �˻��� ����Դϴ�.</span>
					<%}%>
                    <script language="JavaScript" src="/js2/reqsubmit/tooltip.js"></script>
                    <script language="JavaScript" src="/js/reqsubmit/reqinfo.js"></script>
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="list02">
						<tr>
							<td colspan="3">
								<ul><li>&bull;&nbsp;<a href="ISearch_All01.jsp?iptName=<%=squery%>&sflag=1">�䱸�����ڷ�</a><span class="num"> <%=hitCount01%> </span>��</li>
									<li>&bull;&nbsp;<a href="ISearch_All05.jsp?iptName=<%=squery%>&sflag=5">ȸ���ڷ�</a> <span class="num"><%=hitCount05%> </span> ��</li>
									<%if(IS_REQUESTER) {//%>
									  <li>&bull;&nbsp;<a href="ISearch_All04.jsp?iptName=<%=squery%>&sflag=4">�Ź��˻�</a> <span class="num"><%=hitCount04%> </span> ��</li>
									<%}%>
									<li>&bull;&nbsp;��ȸ ȸ�ǷϽý���<a href="javascript:gotoLink('<%=squery%>');">&nbsp;<img src="../images2/btn/bt_search04.gif" width="73" height="17" /></a></li>
								</ul>
							</td>
						</tr>
					</table>
<!-- /list view --> <br />
					<br />
					<!-- list -->
					<span class="list01_tl">�䱸�����ڷ� �˻� ���<span class="list_total">&bull;&nbsp;��ü�ڷ�� : <%=hitCount01%>��</span>
                    <select name="SRCH_RECORD_CNT" onchange="javascript:ChkStr('2');">
                        <option value="10" <%=SRCH_RECORD_CNT.equals("10")? "selected":""%>>10��</option>
                        <option value="15" <%=SRCH_RECORD_CNT.equals("15")? "selected":""%>>15��</option>
                        <option value="20" <%=SRCH_RECORD_CNT.equals("20")? "selected":""%>>20��</option>
                    </select></span>
					<table width="100%" style="padding:0;">
                        <tr>
                            <td>&nbsp;</td>
                        </tr>
                    </table>
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
						<thead>
							<tr>
								<th scope="col">NO</th>
								<th scope="col"><a href="javascript:SearchPageForm('REQ_CONT','<%if(sortMethod.equals(" asc ")){out.println(" desc ");}else{out.println(" asc ");}%>');">�䱸 ����<%if(sortField.equals("REQ_CONT")){if(sortMethod.equals(" asc ")){out.println(" �� ");}else{out.println(" �� ");}}%></a></th>
								<th scope="col">�亯</th>
								<th scope="col"><a href="javascript:SearchPageForm('REQ_ORGAN_NM','<%if(sortMethod.equals(" asc ")){out.println(" desc ");}else{out.println(" asc ");}%>');">�䱸���<%if(sortField.equals("REQ_ORGAN_NM")){if(sortMethod.equals(" asc ")){out.println(" �� ");}else{out.println(" �� ");}}%></a></th>
								<th scope="col"><a href="javascript:SearchPageForm('SUBMT_ORGAN_NM','<%if(sortMethod.equals(" asc ")){out.println(" desc ");}else{out.println(" asc ");}%>');">������<%if(sortField.equals("SUBMT_ORGAN_NM")){if(sortMethod.equals(" asc ")){out.println(" �� ");}else{out.println(" �� ");}}%></a></th>
								<th scope="col"><a href="javascript:SearchPageForm('LAST_ANS_DT','<%if(sortMethod.equals(" asc ")){out.println(" desc ");}else{out.println(" asc ");}%>');">��������<%if(sortField.equals("LAST_ANS_DT")){if(sortMethod.equals(" asc ")){out.println(" �� ");}else{out.println(" �� ");}} %></a></th>
							</tr>
						</thead>
						<tbody>
							<%

								if (hitCount01 !=0) {

									String VDKSUMMARY = "";
									Enumeration enum1 = result01.documents().elements();
									while(enum1.hasMoreElements()){
										Document doc = (Document)enum1.nextElement();
										VDKSUMMARY = replace(doc.field("VDKSUMMARY"),"\"", "'");//VDKSUMMARY�� "�� ������� '�� ��ȯ(alt�ױ׿��� ������)
							%>
							<tr>
							  <td><%=doc.rank%></td>
							  <td style="text-align:left;"><a href="javascript:gotoDetailView('<%=doc.field("REQ_ID")%>');"><%=doc.field("REQ_CONT")%></a><!--<img src="/images2/common/icon_noAnswer.gif" width="26" height="20" />--></td>
							  <td><%=nads.lib.reqsubmit.util.DBAccessUtil.makeAnsInfoHtml(doc.field("ANS_ID"),doc.field("ANS_MTD"),doc.field("ANS_OPIN"),doc.field("SUBMT_FLAG"),IS_REQUESTER,squery,SRCH_DISPLAY_KIND.trim(),VDKSUMMARY)%><br></td>
							  <td><%=doc.field("REQ_ORGAN_NM")%></td>
							  <td><%=doc.field("SUBMT_ORGAN_NM")%></td>
							  <td><%=doc.field("LAST_ANS_DT")%></td>
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

						</tbody>
					</table>
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td height="35" align="center" valign="middle"><div align="center">
							<!-- Page Navigation -->
							<%
								if (hitCount01 > docPage) {
									int Total, Start, Page;
									int CurPage, StartPage, EndPage, TotalPage;
									int i;

									Total = hitCount01;
									if (hitCount01 > maxDocs) Total = maxDocs-1;
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
										out.println("<a href=\'JavaScript:GotoPage(document.dummy, 0)\'>[First]</a>&nbsp;");
										out.println("<a href=\'JavaScript:GotoPage(document.dummy, " + (StartPage-10) + ")\'><img src='/image/button/bt_prev.gif' border='0'></a>&nbsp;");
									}


									for (i = StartPage ; i <= EndPage ; i++) {
										if( i == CurPage ){
											out.println("<strong>["+(i+1)+"]</strong>&nbsp;");;
										}
										else {
											out.println("<a href=\'JavaScript:GotoPage(document.dummy, " + i + ")'>" +"["+ (i+1)+"]&nbsp;</a> ");
										}
									}

									if (TotalPage > EndPage) {
										EndPage = EndPage + 1;
										out.println("&nbsp;<a href=\'JavaScript:GotoPage(document.dummy, " + EndPage + ")'><img src='/image/button/bt_next.gif' border='0'></a>");
										out.println("&nbsp;<a href=\'JavaScript:GotoPage(document.dummy, " + TotalPage + ")'>[End]</a>");
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
    <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>