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
    String serverSpec3 = "10.201.12.139:9932";
    String serverSpec4 = "10.201.12.139:9931";
	String SortSpec="";
	String default_query = "";
    String realqueryText ="";

	//�⺻�˻����� ����(�����Ȱ��̰ų� �ڽ��� �䱸�� �������ڷῡ���� �����ش�)
	if(IS_REQUESTER) default_query="((001<IN>Z_OPEN_CL)<OR>("+ORGAN_ID+"<IN>Z_REQ_ORGAN_ID))";
	else default_query="("+ORGAN_ID+"<IN>Z_SUBMT_ORGAN_ID)";

	Result result01 = null;
	Result result04 = null;
	Result result05 = null;

	try {//�ڷ�����˻�
		VSearch vs = new VSearch();

		vs.setServerSpec(serverSpec1);
        vs.setCharMap("utf8");
		vs.setQueryParser("3soft");
		vs.setUrlStringsMode(true);
		vs.addCollection("nads");
		vs.setMaxDocCount(0);
		vs.disableConnectionPooling(true);

		if (squery.equals("")) realqueryText = default_query;
		else realqueryText = squery+default_query;

		vs.setQueryText(MbEncoder.encode(realqueryText, "utf8"));
		result01 = vs.getResult();

		//�ڷ����⿡���� ���� �����̹Ƿ� �ٸ��˻������� Only Ű���常���� �ϱ����� �˻�����ʱ�ȭ
		realqueryText = squery;
	}
	catch(Exception e) {
	  System.out.println("ISearch_All04_1 : "+e.getMessage());
    }

    try {//�����˻�_���
		VSearch vs = new VSearch();

		vs.setServerSpec(serverSpec3);
		vs.setCharMap("utf8");
		vs.setQueryParser("3soft");
		vs.setUrlStringsMode(true);
		vs.addCollection("news");
		vs.addCollection("news_sigawin");
		vs.disableConnectionPooling(true);

		vs.addField("VDKPBSUMMARY");
		vs.addField("TITLE");
		vs.addField("GROUPNAME00");
		vs.addField("GROUPNAME01");
		vs.addField("GROUPNAME02");
		vs.addField("GETDATE");
		vs.addField("REGDATE");

		vs.setMaxDocCount(maxDocs);
		vs.setDocsStart(docStart);
		vs.setDocsCount(docPage);
		vs.setSortSpec("GETDATE desc");
		vs.setDateFormat("${yyyy}-${mm}-${dd}");
		vs.setQueryText(MbEncoder.encode(realqueryText, "utf8"));

		//������๮ ó�� ����
		vs.setSummaryMaxPassageCount(1);
		vs.setSummaryMaxPassageBytes(300);

		VFieldHighlightParameters objFieldHLParams = vs.getFieldHighlightParameters();
		objFieldHLParams.addFieldHighlight("TITLE", "<b>", "</b>");
		objFieldHLParams.addFieldHighlight("VDKPBSUMMARY", "<b>", "</b>");

		result04 = vs.getResult();
	}
	catch(Exception e) {
	  System.out.println("ISearch_All04_2 : "+e.getMessage());
    }

	try {//���������ڷ�˻�
		VSearch vs = new VSearch();

		vs.setServerSpec(serverSpec4);
		vs.setCharMap("utf8");
		vs.setQueryParser("3soft");
		vs.setUrlStringsMode(true);
		vs.addCollection("submit");
		vs.setMaxDocCount(0);
		vs.disableConnectionPooling(true);
		vs.setQueryText(MbEncoder.encode(realqueryText, "utf8"));

		result05 = vs.getResult();
	}
	catch(Exception e) {
	  System.out.println("ISearch_All04_3 : "+e.getMessage());
	}

	//�˻� ��� Print
	int hitCount01 = result01.docsFound;
	int hitCount04 = result04.docsFound;
	int hitCount05 = result05.docsFound;

%>

<script language="JavaScript">
<!--
function GotoPage(form, docStart){
	form.docStart.value = docStart * form.docPage.value + 1;
	form.submit();
	return;
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
            <form  method=post name=dummy>
            <div class="serP">

                <!-- �˻�â -->

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
					<span class="list01_tl">�Ź��˻� �˻� ���<span class="list_total">&bull;&nbsp;��ü�ڷ�� : <%=hitCount04%>��</span>
                    <select name="SRCH_RECORD_CNT" onchange="javascript:ChkStr('2');">
                        <option value="10" <%=SRCH_RECORD_CNT.equals("10")? "selected":""%>>10��</option>
                        <option value="15" <%=SRCH_RECORD_CNT.equals("15")? "selected":""%>>15��</option>
                        <option value="20" <%=SRCH_RECORD_CNT.equals("20")? "selected":""%>>20��</option>
                    </select></span>
					<br><table width="719" border="0" cellspacing="0" cellpadding="0">

<%
	if (hitCount04 !=0) {
		String viewHref = "";
		String temp = "";
		int i=0;
		Enumeration enum1 = result04.documents().elements();
		while(enum1.hasMoreElements()){
			Document doc = (Document)enum1.nextElement();
		temp =squery;
		i++;
		int j=i%2;
%>
                    <tr>
					  <td  height="22" valign="top" <% if (j==1){out.println(" bgcolor='#FEFAEF'");}%> class="td_box"><strong><a href="<%=doc.field("url")%>"  <%if (SRCH_DISPLAY_KIND.trim().equals("0")) { out.println("target='_blank'");}%>><%=doc.rank%>. <%=(doc.title)%></a></strong><br>
						<%=doc.field("GROUPNAME00")%>><%=doc.field("GROUPNAME01")%>><%=doc.field("GROUPNAME02")%>>���ͳ��� <%=doc.field("REGDATE")%>��<br>
						<%=doc.field("VDKPBSUMMARY")%>
					    <br><br>
					  </td>
					</tr>
					<%} //while%>
				   <%}else{%>
					 <tr><td height="22" align="center">�˻��� ����� �����ϴ�.</td><tr>
				   <% } %>
                  </table></td>
              </tr>
              <tr>
                <td height="10" align="left" class="soti_reqsubmit"></td>
              </tr>
              <tr>
                <td height="1" align="left" valign="top" class="tbl-line"></td>
              </tr>
              <tr>
                <td height="35" align="center" valign="middle"><div align="center">
<!-- Page Navigation -->
<%
	if (hitCount04 > docPage) {
		int Total, Start, Page;
		int CurPage, StartPage, EndPage, TotalPage;
		int i;

		Total = hitCount04;
		if (hitCount04 > maxDocs) Total = maxDocs-1;
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
%>                                </td>
              </tr>
              <tr>
                <td height="35" align="left" valign="top">&nbsp;</td>
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
