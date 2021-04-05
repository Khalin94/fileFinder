<%@ page contentType="text/html;charset=UTF-8" %>
<%
	String squery = nads.lib.reqsubmit.util.StringUtil.getEmptyIfNull(request.getParameter("iptName"));
	if(squery==null) squery = "";
	String sflag = nads.lib.reqsubmit.util.StringUtil.getEmptyIfNull(request.getParameter("sflag"));
	if(sflag==null) sflag = "1";

	String sortField = nads.lib.reqsubmit.util.StringUtil.getEmptyIfNull(request.getParameter("sortField"));

	if(sortField==null){
		if(sflag.equals("1")){
		sortField = "LAST_ANS_DT";
		}else if (sflag.equals("5")){
		sortField = "REG_DT";
		}else {
		sortField = "score";
		}
	}
	String SRCH_RECORD_CNT = nads.lib.reqsubmit.util.StringUtil.getEmptyIfNull(request.getParameter("SRCH_RECORD_CNT"));
	if(SRCH_RECORD_CNT.equals("")||SRCH_RECORD_CNT == null){
		SRCH_RECORD_CNT = "20";
	}
	String sortMethod = nads.lib.reqsubmit.util.StringUtil.getEmptyIfNull(request.getParameter("sortMethod"));
	if(sortMethod==null) sortMethod = " desc ";

	int     maxDocs     = 4000;
	if(request.getParameter("maxDocs") != null)
		maxDocs = Integer.parseInt(nads.lib.reqsubmit.util.StringUtil.getEmptyIfNull(request.getParameter("maxDocs")));
	int docStart = 1;
	if(request.getParameter("docStart")!=null)
		docStart = Integer.parseInt(nads.lib.reqsubmit.util.StringUtil.getEmptyIfNull(request.getParameter("docStart")));

	int docPage = Integer.parseInt(SRCH_RECORD_CNT.trim());
%>
<script language="JavaScript">

function ChkStr(str)
{

	if (str=='1') {
		<% if (sflag.equals("1")){%>
		document.SearchPageForm.action='/infosearch/ISearch_All01.jsp?sflag=1';
		<%}else if (sflag.equals("2")){%>
		document.SearchPageForm.action='/infosearch/ISearch_All02.jsp?sflag=2';
		<%}else if (sflag.equals("3")){%>
		document.SearchPageForm.action='/infosearch/ISearch_All03.jsp?sflag=3';
		<%}else if (sflag.equals("4")){%>
		document.SearchPageForm.action='/infosearch/ISearch_All04.jsp?sflag=4';
		<%}else if (sflag.equals("5")){%>
		document.SearchPageForm.action='/infosearch/ISearch_All05.jsp?sflag=5';
		<%}else{%>
		document.SearchPageForm.action='/infosearch/ISearch_All01.jsp?sflag=1';
		<%}%>

			var str=document.SearchPageForm.iptName.value
			for (var i=0; i < str.length; i++) {
			if (str.charAt(i) == "%" |str.charAt(i) == ">" |str.charAt(i) == "<" |str.charAt(i) == ">" |str.charAt(i) == "(" |str.charAt(i) == ")" |str.charAt(i) == "+" |str.charAt(i) == "," |str.charAt(i) == "[") {
				alert("허용되지않은 문자입니다.");
				document.SearchPageForm.iptName.focus();
				return false;
	            }
	         }

		document.SearchPageForm.docStart.value = 1;
		document.SearchPageForm.sortField.value = "<%=sortField%>";
		document.SearchPageForm.sortMethod.value = "<%=sortMethod%>";
		document.SearchPageForm.submit();
	}else{
		<% if (sflag.equals("1")){%>
		document.dummy.action='/infosearch/ISearch_All01.jsp?sflag=1';
		<%}else if (sflag.equals("2")){%>
		document.dummy.action='/infosearch/ISearch_All02.jsp?sflag=2';
		<%}else if (sflag.equals("3")){%>
		document.dummy.action='/infosearch/ISearch_All03.jsp?sflag=3';
		<%}else if (sflag.equals("4")){%>
		document.dummy.action='/infosearch/ISearch_All04.jsp?sflag=4';
		<%}else if (sflag.equals("5")){%>
		document.dummy.action='/infosearch/ISearch_All05.jsp?sflag=5';
		<%}else{%>
		document.dummy.action='/infosearch/ISearch_All01.jsp?sflag=1';
		<%}%>

			var str=document.dummy.iptName.value
			for (var i=0; i < str.length; i++) {
			if (str.charAt(i) == "%" |str.charAt(i) == ">" |str.charAt(i) == "<" |str.charAt(i) == ">" |str.charAt(i) == "(" |str.charAt(i) == ")" |str.charAt(i) == "+" |str.charAt(i) == "," |str.charAt(i) == "[") {
				alert("허용되지않은 문자입니다.");
				document.dummy.iptName.focus();
				return false;
	            }
	         }

		document.dummy.docStart.value = 1;
		document.dummy.sortField.value = "<%=sortField%>";
		document.dummy.sortMethod.value = "<%=sortMethod%>";
		document.dummy.submit();

	}

}

function SearchPageForm(sortField,sortMethod,str)
{

	if (str=='1') {
		<% if (sflag.equals("1")){%>
		document.SearchPageForm.action='/infosearch/ISearch_All01.jsp?sflag=1';
		<%}else if (sflag.equals("2")){%>
		document.SearchPageForm.action='/infosearch/ISearch_All02.jsp?sflag=2';
		<%}else if (sflag.equals("3")){%>
		document.SearchPageForm.action='/infosearch/ISearch_All03.jsp?sflag=3';
		<%}else if (sflag.equals("4")){%>
		document.SearchPageForm.action='/infosearch/ISearch_All04.jsp?sflag=4';
		<%}else if (sflag.equals("5")){%>
		document.SearchPageForm.action='/infosearch/ISearch_All05.jsp?sflag=5';
		<%}else{%>
		document.SearchPageForm.action='/infosearch/ISearch_All01.jsp?sflag=1';
		<%}%>

			var str=document.SearchPageForm.iptName.value
			for (var i=0; i < str.length; i++) {
			if (str.charAt(i) == "%" |str.charAt(i) == ">" |str.charAt(i) == "<" |str.charAt(i) == ">" |str.charAt(i) == "(" |str.charAt(i) == ")" |str.charAt(i) == "+" |str.charAt(i) == "," |str.charAt(i) == "[") {
				alert("허용되지않은 문자입니다.");
				document.SearchPageForm.iptName.focus();
				return ;
	            }
	         }

		document.SearchPageForm.docStart.value = 1;
		document.SearchPageForm.sortField.value = sortField;
		document.SearchPageForm.sortMethod.value = sortMethod;
		document.SearchPageForm.submit();
	}else{
		<% if (sflag.equals("1")){%>
		document.dummy.action='/infosearch/ISearch_All01.jsp?sflag=1';
		<%}else if (sflag.equals("2")){%>
		document.dummy.action='/infosearch/ISearch_All02.jsp?sflag=2';
		<%}else if (sflag.equals("3")){%>
		document.dummy.action='/infosearch/ISearch_All03.jsp?sflag=3';
		<%}else if (sflag.equals("4")){%>
		document.dummy.action='/infosearch/ISearch_All04.jsp?sflag=4';
		<%}else if (sflag.equals("5")){%>
		document.dummy.action='/infosearch/ISearch_All05.jsp?sflag=5';
		<%}else{%>
		document.dummy.action='/infosearch/ISearch_All01.jsp?sflag=1';
		<%}%>

			var str=document.dummy.iptName.value
			for (var i=0; i < str.length; i++) {
			if (str.charAt(i) == "%" |str.charAt(i) == ">" |str.charAt(i) == "<" |str.charAt(i) == ">" |str.charAt(i) == "(" |str.charAt(i) == ")" |str.charAt(i) == "+" |str.charAt(i) == "," |str.charAt(i) == "[") {
				alert("허용되지않은 문자입니다.");
				document.dummy.iptName.focus();
				return ;
	            }
	         }

		document.dummy.docStart.value = 1;
		document.dummy.sortField.value = sortField;
		document.dummy.sortMethod.value = sortMethod;
		document.dummy.submit();
	}

}
</script>
<form  method=post name=SearchPageForm>
    <input type=hidden name=maxDocs VALUE="<%=maxDocs%>">
    <input type=hidden name=docStart VALUE="<%=docStart%>">
    <input type=hidden name=docPage VALUE="<%=docPage%>">
    <input type=hidden name=sortField VALUE="<%=sortField%>">
    <input type=hidden name=sortMethod VALUE="<%=sortMethod%>">
    <input type="hidden" name="strOrganId" > <!--제출기관 id -->
    <input type="hidden" name="strSubmtOrganNm" > <!--제출기관명 -->
    <input type="hidden" name="strReqOrganId" > <!--담당기관 id -->
    <input type="hidden" name="strReqOrganNm" > <!--담당기관명 -->
    <input type="hidden" name="strGbnCode" > <!--회의등록자료 코드 -->
    <input type="hidden" name="strGovSubmtDataId" > <!--회의등록자료 id -->
	<input type="text" name="iptName" value="<%=squery%>" onMouseDown="return ch();" onKeyDown="JavaScript: if(event.keyCode == 13) {return ChkStr('1');};" style="background-image:url(/images2/common/search_bg.gif); background-repeat:no-repeat;background-position:left top;"/>
    <a href="JavaScript:SearchPageForm('','','1');"><img src="/images2/btn/bt_search.gif"  width="29" height="25"  onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"/></a>
</form>
