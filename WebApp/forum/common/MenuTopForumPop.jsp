<%
		
	if(strForumNM==null || strForumNM.equals("") || strOpenFlag==null || strOpenFlag.equals("")) {

		Hashtable objHashForumNM;
		nads.dsdm.app.forum.SLDBForumDelegate objForumNM = new nads.dsdm.app.forum.SLDBForumDelegate();
		
		try {

			objHashForumNM = objForumNM.selectIndForumInfo(strForumID);
			strForumNM = StringUtil.getNVLNULL((String)objHashForumNM.get("FORUM_NM"));
			strOpenFlag = StringUtil.getNVLNULL((String)objHashForumNM.get("OPEN_FLAG"));

		} catch (AppException objAppEx) {	
			// 에러 발생 메세지 페이지로 이동한다.
			out.println(objAppEx.getStrErrCode());
			return;		
		}

	}
%>
<table width="800" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td height="48" align="left" valign="top" background="/image/forum/bg_forumTop.gif"><table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td width="11%"><img src="/image/forum/img_logo.gif" width="250" height="48"></td>
          <td width="89%" align="center" class="title_w"><a href="/forum/indmain/ForumIndMain.jsp?fid=<%=strForumID%>&uStt=<%=strUserStt%>"><font color="ffffff">:: <%=strForumNM%> ::</font></a></td>
        </tr>
      </table></td>
  </tr>
</table>