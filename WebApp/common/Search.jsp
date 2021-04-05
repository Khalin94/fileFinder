
<%
	String squery = nads.lib.reqsubmit.util.StringUtil.getEmptyIfNull(request.getParameter("squery")); 
	if(squery==null) squery = "";
	String sflag = nads.lib.reqsubmit.util.StringUtil.getEmptyIfNull(request.getParameter("sflag")); 
	if(sflag==null) sflag = "1";
	
%>	
<script language="JavaScript">
function ChkStr()
{
		var str=document.SearchPageForm.squery.value
		for (var i=0; i < str.length; i++) {
			if (str.charAt(i) == "%" |str.charAt(i) == ">" |str.charAt(i) == "<" |str.charAt(i) == ">" |str.charAt(i) == "(" |str.charAt(i) == ")" |str.charAt(i) == "+" |str.charAt(i) == "," |str.charAt(i) == "[") {
			alert("허용되지않은 문자입니다.");
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
			alert("허용되지않은 문자입니다.");
			document.SearchPageForm.squery.focus();
			return ;
            }
         }
	
	document.SearchPageForm.submit();	
}
</script>

<table width="81%" border="0" cellspacing="0" cellpadding="3">
<form  method=post name=SearchPageForm action="/infosearch/ISearch_All01.jsp?sflag=1" >
              <tr> 
                <td width="29%" align="right"><img src="/image/common/search_sub.gif" width="52" height="14"></td>
                <td width="53%"><input type="text" name="squery" value="<%=squery%>" size="15" maxlength=32  onKeyDown="JavaScript: if(event.keyCode == 13) {return ChkStr('1');};"  style='font-family:돋움,arial;font-size:12px;height:18px;border:1 solid #947C55; width:131px; background-color:white;color:#5E4215'></td>
                <td width="18%"><a href="JavaScript:SearchPageForm();"><img src="/image/common/bt_searchAll_sub.gif" width="31" height="17" align="absmiddle" border=0></a></td>
              </tr>
</form>              
</table>