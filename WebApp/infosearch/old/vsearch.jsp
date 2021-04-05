<%@ page language="java" contentType="text/html; charset=euc-kr"%>
<%@ page import="java.util.* "%>
<%@ page import="java.io.*" %>
<%@ page import="java.net.*" %>
<%@ page import="com.verity.search.VSearch" %>
<%@ page import="com.verity.search.Result" %>
<%@ page import="com.verity.search.Document" %>
<%@ page import="com.verity.search.Documents" %>
<%@ page session="true" %>
<%@ page errorPage = "bad.jsp" %>
<%@ include file="utils.jsp" %> 

<script language="JavaScript">
function GotoPage(form, docStart){	
	form.docStart.value = docStart * form.docPage.value + 1;
	form.submit();
	return;
}

function search(form)
{
	var vQueryString=""; //��������
	var vQuery=""; //��������
	var vQueryText=""; //�������� + ��������

	vQueryText = form.queryText.value;
	vQuery = form.query.value;
	
	if (form.ri.checked) {
		if (vQueryText != "" && vQuery != "") {
			vQueryText = '(' + vQueryText + ')' + '<and>';
		}
		if (vQuery != "") {
			vQueryText = vQueryText + vQuery;
		}
	} else {
		vQueryText = vQuery;
	}

	form.queryText.value = vQueryText;
	form.submit();
}
</script>

<%
	//�˻��� �ʿ��� parameter ����
	String host = "10.201.60.2";
	String port ="9930";
	String queryText = "��";
	String[] fields = {"VdkVgwKey","vdksummary"};
	int maxDocs = 200;
	String[] colls = {"nads"};
	int docStart = 1;
	int docPage = 10;
	String hostport = host + ":" + port;
	
	Result result = null;
	try {
		VSearch vs = new VSearch();
		
		//3.x �̻󿡸� �ִ� method
		
		vs.setServerSpec(hostport);
		
		for (int i=0; i<colls.length; i++)
			vs.addCollection(colls[i]);
		for (int j=0; j<fields.length; j++)
			vs.addField(fields[j]);
		vs.addField("k2dockey");
		vs.setMaxDocCount(maxDocs);
		vs.setSortSpec("score desc");
		//vs.setDateFormat("${yyyy}-${mm}-${dd}");
		vs.setQueryText(toMulti(queryText));
		vs.setDocsStart(docStart);
		vs.setDocsCount(docPage);
		vs.setCharMap("ksc");
		//vs.setUrlStringsMode(true);		
		result = vs.getResult();	

	} catch(Exception e) {
		throw new RuntimeException(e.getMessage()+e.getClass());
	}
	
	//�˻� ��� Print
	int hitCount = result.docsFound;
%>
<form  method=get name=PageForm action=vsearch.jsp language=javascript onsubmit="return search(this)">
	<input type=hidden name=host value="<%=host %>"> 
	<input type=hidden NAME=port VALUE="<%=port %>">
	�˻���:<input type=text name=query value=""></input>
	<input type="submit" value=" �� �� ">
	<input name="ri" type="checkbox" <%if (request.getParameter("ri")!=null) {%> checked <%}%>>��˻�
	<input type=hidden name=queryText value="<%=toMulti(queryText)%>">
<%
	for(int x=0; x<colls.length; x++) {
%>
	<input type=hidden name=colls value="<%=colls[x]%>"></input>
<%
	}
%>
<%
	for(int x=0; x<fields.length; x++) {
%>
	<input type=hidden name=fields value="<%=fields[x]%>"></input>
<%
	}
%>
	<input type=hidden name=maxDocs VALUE="<%=maxDocs%>">		
	<input type=hidden name=docStart VALUE="<%=docStart%>">
	<input type=hidden name=docPage VALUE="<%=docPage%>">
</form>

<font size=2>�˻���:<b><%=replace(toMulti(queryText), "<", "&lt;")%></b><br>
�˻��Ǽ� <%=hitCount%>(<%=maxDocs%>)/<%=result.docsSearched%><br>
</font>

<br>
<table border=1>
<!-- �ʵ� ���� Print -->
<tr>
<td>RANK</td>
<%
	for (int i=0 ; i<fields.length; i++)
		out.println("<td>" + fields[i] + "</td>");
%>
</tr>

<!-- ��� �� print -->
<%
	String viewHref = "";
	Enumeration enum = result.documents().elements();
	while(enum.hasMoreElements()){
		Document doc = (Document)enum.nextElement();
		viewHref = "docview.jsp?hostport=" + hostport + "&queryText=" + toMulti(queryText);
		viewHref += "&k2DocKey=" + doc.field("k2dockey");
		out.println("<tr><td><a href=" + viewHref + ">" + doc.rank + "</a></td>");
		for (int i=0; i<fields.length; i++) {
			out.println("<td>" + doc.field(fields[i]) + "</td>");
		}
		out.println("</tr>");
	}
%>
</table>

<!-- Page Navigation -->
<%
	if (hitCount > docPage) {
		int Total, Start, Page;
		int CurPage, StartPage, EndPage, TotalPage;
		int i;

		Total = hitCount-1; 
		if (hitCount > maxDocs) Total = maxDocs-1;
		Start = docStart;
		Page = docPage;

		CurPage = Start / Page;
		StartPage = ( Start / ( 10 * Page ) ) * 10;
		TotalPage = Total / Page;
		EndPage = StartPage + 9 > TotalPage ? TotalPage : StartPage + 9;

%>
<br>
<%
		if (StartPage != 0) {
			out.println("<a href=\'JavaScript:GotoPage(document.PageForm, " + (StartPage-10) + ")\'> Prev 10 Page</a>&nbsp;");
		}
		

		for (i = StartPage ; i <= EndPage ; i++) {
			if( i == CurPage ){
				out.println("<b>" + (i+1) + "</b>");
			}
			else {
				out.println("<a href=\'JavaScript:GotoPage(document.PageForm, " + i + ")'>" + (i+1) + "</a> ");
			}
		}

		if (TotalPage > EndPage) {
			EndPage = EndPage + 1;
			out.println("&nbsp;<a href=\'JavaScript:GotoPage(document.PageForm, " + EndPage + ")'>Next 10 Page</a>");
		}
	}
%>

<br><br><a href=./vsearch.html>�ʱ�ȭ��</a>

</body>
</html>
