<%
	String squery = nads.lib.reqsubmit.util.StringUtil.getEmptyIfNull(request.getParameter("squery")); 
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
	String SRCH_RECORD_CNT = (String)session.getAttribute("SRCH_RECORD_CNT");
	if(SRCH_RECORD_CNT.equals("")||SRCH_RECORD_CNT == null){
		SRCH_RECORD_CNT = "10";
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

	if(request.getParameter("docPage")!=null)
		docPage = Integer.parseInt(nads.lib.reqsubmit.util.StringUtil.getEmptyIfNull(request.getParameter("docPage")));


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
	
			var str=document.SearchPageForm.squery.value
			for (var i=0; i < str.length; i++) {
			if (str.charAt(i) == "%" |str.charAt(i) == ">" |str.charAt(i) == "<" |str.charAt(i) == ">" |str.charAt(i) == "(" |str.charAt(i) == ")" |str.charAt(i) == "+" |str.charAt(i) == "," |str.charAt(i) == "[") {
				alert("허용되지않은 문자입니다.");
				document.SearchPageForm.squery.focus();
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
	
			var str=document.dummy.squery.value
			for (var i=0; i < str.length; i++) {
			if (str.charAt(i) == "%" |str.charAt(i) == ">" |str.charAt(i) == "<" |str.charAt(i) == ">" |str.charAt(i) == "(" |str.charAt(i) == ")" |str.charAt(i) == "+" |str.charAt(i) == "," |str.charAt(i) == "[") {
				alert("허용되지않은 문자입니다.");
				document.dummy.squery.focus();
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
	
			var str=document.SearchPageForm.squery.value
			for (var i=0; i < str.length; i++) {
			if (str.charAt(i) == "%" |str.charAt(i) == ">" |str.charAt(i) == "<" |str.charAt(i) == ">" |str.charAt(i) == "(" |str.charAt(i) == ")" |str.charAt(i) == "+" |str.charAt(i) == "," |str.charAt(i) == "[") {
				alert("허용되지않은 문자입니다.");
				document.SearchPageForm.squery.focus();
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
	
			var str=document.dummy.squery.value
			for (var i=0; i < str.length; i++) {
			if (str.charAt(i) == "%" |str.charAt(i) == ">" |str.charAt(i) == "<" |str.charAt(i) == ">" |str.charAt(i) == "(" |str.charAt(i) == ")" |str.charAt(i) == "+" |str.charAt(i) == "," |str.charAt(i) == "[") {
				alert("허용되지않은 문자입니다.");
				document.dummy.squery.focus();
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


<table width="81%" border="0" cellspacing="0" cellpadding="3">
<form  method=post name=SearchPageForm >
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

              <tr> 
                <td width="29%" align="right"><img src="/image/common/search_sub.gif" width="52" height="14"></td>
                <td width="53%"><input type="text" name="squery" value="<%=squery%>" size="15" maxlength=32  onKeyDown="JavaScript: if(event.keyCode == 13) {return ChkStr('1');};"  style='font-family:돋움,arial;font-size:12px;height:18px;border:1 solid #947C55; width:131px; background-color:white;color:#5E4215'></td>
                <td width="18%"><a href="JavaScript:SearchPageForm('<%=sortField%>','<%=sortMethod%>','1');"><img src="/image/common/bt_searchAll_sub.gif" width="31" height="17" align="absmiddle" border=0></a></td>
              </tr>
</form>              
</table>
