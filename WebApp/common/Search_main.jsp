<%
	String squery = nads.lib.reqsubmit.util.StringUtil.getEmptyIfNull(request.getParameter("squery")); 
	if(squery==null) squery = "";
%>

<script language="JavaScript">
function ChkStr()
{

		var str=document.SearchPageForm.squery.value
		for (var i=0; i < str.length; i++) {
			if (str.charAt(i) == "%" |str.charAt(i) == ">" |str.charAt(i) == "<" |str.charAt(i) == ">" |str.charAt(i) == "(" |str.charAt(i) == ")" |str.charAt(i) == "+" |str.charAt(i) == "," |str.charAt(i) == "[") {
			alert("���������� �����Դϴ�.");
			document.SearchPageForm.squery.focus();
			return false;
            }
         }
	
	document.SearchPageForm.submit();	


}
function SearchPageForm()
{

		var str=document.SearchPageForm.squery.value
		for (var i=0; i < str.length; i++) {
			if (str.charAt(i) == "%" |str.charAt(i) == ">" |str.charAt(i) == "<" |str.charAt(i) == ">" |str.charAt(i) == "(" |str.charAt(i) == ")" |str.charAt(i) == "+" |str.charAt(i) == "," |str.charAt(i) == "[") {
			alert("���������� �����Դϴ�.");
			document.SearchPageForm.squery.focus();
			return ;
            }
         }
	
	document.SearchPageForm.submit();	
}
</script>


<!-- �˻� ���̺� ���� -->
<table width="62%" border="0" cellspacing="0" cellpadding="3">
<form  method=post name=SearchPageForm action="/infosearch/ISearch_All01.jsp?sflag=1" >
  <tr> 
    <td width="29%" align="right"><img src="image/main/search.gif" width="41" height="12"></td>
    <td width="53%"><input type="text" name="squery" value="<%=squery%>"  maxlength=32 size="15" onKeyDown="JavaScript: if(event.keyCode == 13) {return ChkStr();};"  style='font-family:����,arial;font-size:12px;height:18px;border:1 solid #CDC5B7; width:198px; background-color:white;color:#6B6B6B'></td>
    <td width="18%"><a href="JavaScript:SearchPageForm();"><img src="image/main/bt_searchAll.gif" width="35" height="18" border=0></a></td>
  </tr>
</form>
</table>
<!-- �˻� ���̺� �� -->
