<%
	ArrayList objAryForumMenuSortData = null; //�����з�
	nads.dsdm.app.common.code.CodeInfoDelegate objCodeInfoMenu = new nads.dsdm.app.common.code.CodeInfoDelegate(); //�ڵ���� Delegate

	try {
		objAryForumMenuSortData = objCodeInfoMenu.lookUpCode("M02");
	
	} catch (AppException objAppEx) {	
		// ���� �߻� �޼��� �������� �̵��Ѵ�.
		out.println(objAppEx.getStrErrCode());
		return;		
	}
%>

<table width="186" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td align="left" valign="top">
	<a href="/forum/newinfo/ForumMain.jsp">���� �ֽ�����</a><br>
	<a href="/forum/search/ForumSearch.jsp?gbn=1">���� �˻�</a><br>
	���� �з�<br>

	<%
		for(int j=0; j< objAryForumMenuSortData.size(); j++) {
	%>
		<span class="text_s"> <a href="/forum/search/ForumSearch.jsp?gbn=2&fCd=<%=String.valueOf(((Hashtable)objAryForumMenuSortData.get(j)).get("MSORT_CD"))%>">- <%=String.valueOf(((Hashtable)objAryForumMenuSortData.get(j)).get("CD_NM"))%>����</a></span><br>
	<%
		}
	%>
	���� �Խ���<br>
	<span class="text_s"><a href="/forum/board/ForumBoardList.jsp?bbrdid=0000000001"> - ���� ��������</a></span><br>
	<span class="text_s"><a href="/forum/board/ForumBoardList.jsp?bbrdid=0000000002"> - ���� �����Խ���</a></span><br>
	<a href="/forum/openreq/ForumOpenreq.jsp">���� ������û<br>
	</td>
  </tr>
  <tr> 
    <td height="14" align="left" valign="top"></td>
  </tr>
  <tr> 
    <td align="center" valign="top"></td>
  </tr>
  <tr> 
    <td align="center" valign="top"> </td>
  </tr>
  <tr>
    <td height="5" align="center" valign="top"><%@ include file="/common/MyMenu.jsp" %></td>
  </tr>
  <tr> 
    <td height="5" align="left" valign="top"></td>
  </tr>
  <tr> 
    <td height="14" align="center" valign="top"><img src="/image/common/banner_eApproval.gif" width="175" height="35"></td>
  </tr>
  <tr> 
    <td height="5" align="left" valign="top"></td>
  </tr>
  <tr> 
    <td height="14" align="center" valign="top"><img src="/image/common/banner_iptong.gif" width="175" height="52"></td>
  </tr>
  <tr> 
    <td height="14" align="left" valign="top"></td>
  </tr>
</table>

