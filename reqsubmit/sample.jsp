<%@ page language="java" contentType="text/html;charset=EUC-KR" %>

<%
	String strOpacity = request.getParameter("select1");
	if(strOpacity == null || strOpacity.length() == 0 || "".equals(strOpacity)) strOpacity = "100";
%>

<HTML>
<HEAD>
<TITLE>���� ���� �׽�Ʈ</TITLE>

<script language="javascript">
	function changeOpacity(val) {
		document.testForm.submit();
	}
</script>

</HEAD>

<BODY>
<form name="testForm" action="<%= request.getRequestURI() %>" method="get">
<select name="select1" onChange="changeOpacity(this.value)">
	<option value="">::: ������ ������ �ּ��� :::</option>
	<option value="10">10</option>
	<option value="20">20</option>
	<option value="30">30</option>
	<option value="40">40</option>
	<option value="50">50</option>
	<option value="60">60</option>
	<option value="70">70</option>
	<option value="80">80</option>
	<option value="90">90</option>
	<option value="100">100</option>
</select>
<p>
<table id="table1" style="filter:alpha(opacity=<%= strOpacity %>); background-color:gray">
	<tr><td>
���� �׽�Ʈ
<img src="http://www.fog.pe.kr/ktt/attach/0805/050805154711055729/083181.JPG" border="0">
</td></tr></table>
</span>
<img src="http://www.fog.pe.kr/ktt/attach/0805/050805154711055729/083181.JPG" border="0" style="filter:alpha(opacity=30);">
</form>
</BODY>
</HTML>
