<%
	srchWord = srchWord==null?" ":srchWord;  
	srchMode = srchMode==null?" ":srchMode;  
	InOutMode = InOutMode==null?" ":InOutMode;  
%>

<table width="73%" border="0" cellspacing="3" cellpadding="0">
<FORM NAME="searchRelOrgan" action="/reqsubmit/70_organchargesh/SearchRelOrgan4Word.jsp">
  <tr> 
	<td width="30%" align="left"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6" align="absmiddle"> 
	  <strong><%=strTitle2%> 검색</strong></td>
	<td width="16%" align="left">
	<select name="srchMode" class="select_join">
		<OPTION VALUE="total" <%out.println(srchMode.equals("total")?"selected":" ");%> >전체
		<OPTION VALUE="OrganNm" <%out.println(srchMode.equals("OrganNm")?"selected":" ");%> >소속
		<OPTION VALUE="UserNm" <%out.println(srchMode.equals("UserNm")?"selected":" ");%>>이름
		<OPTION VALUE="PosiNm" <%out.println(srchMode.equals("PosiNm")?"selected":" ");%>>직위
		<OPTION VALUE="GrdNm" <%out.println(srchMode.equals("GrdNm")?"selected":" ");%>>직급
		<% if(InOutMode.equals("X")) { %>
		<OPTION VALUE="CdNm" <%out.println(srchMode.equals("CdNm")?"selected":" ");%>>담당업무
		<% } %>
		
	  </select></td>
	<td width="46%" align="left"><strong> 
	  <input name="srchWord" type="text" class="textfield" style="WIDTH: 250px" VALUE=<%//=srchMode.equals("OrganId")==true?"":srchWord%><%=srchMode.equals("OrganId")||srchMode.equals("OrganIdForSubmit")?"":srchWord%>>
	  <INPUT type="hidden" name="InOutMode" VALUE=<%=InOutMode%>>
	  </strong></td>
	<td width="13%" align="left"><strong><img src="/image/button/bt_gumsack_icon.gif" width="47" height="19" align="absmiddle" onclick="this.document.searchRelOrgan.submit();" style="cursor:hand"></strong></td>
  </tr></FORM>
</table>