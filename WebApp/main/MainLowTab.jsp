			  <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td align="left" valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr align="left" valign="top"> 
<%
	switch (Integer.parseInt(strLowGubn)){
		case 1:   //최신자료
%>
                      <td width="85"><img src="image/main/tab_newMaterial_over.gif" width="85" height="25"></td>
                      <!-- onMouseOut="MM_swapImgRestore()"  2004.06.15 요청에 의해 삭제-->
                      <td width="85"><a href="/main.jsp?highgubn=<%=strHighGubn%>&lowgubn=2&comm=<%=strCommittee%>"  ><img src="image/main/tab_notice.gif" name="Image43" width="85" height="25" border="0"></a></td>
                      <td width="85"><a href="/main.jsp?highgubn=<%=strHighGubn%>&lowgubn=3&comm=<%=strCommittee%>"  ><img src="image/main/tab_news.gif" name="Image431" width="86" height="25" border="0" id="Image431"></a></td>

                      <td width="328" align="right" valign="middle"></td>
                    </tr>
                  </table></td>
              </tr>
              <tr> 
                <td align="left" valign="top"><img src="image/main/bar_newMaterial.gif" width="583" height="6"></td>
              </tr>
<%
			break;
		case 2:  //공지사항
%>              
                       <!-- onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image43','','image/main/tab_newMaterial_over.gif',1)" 2004.06.15 요청에 의해 삭제-->
                      <td width="85"><a href="/main.jsp?highgubn=<%=strHighGubn%>&lowgubn=1&comm=<%=strCommittee%>"  ><img src="image/main/tab_newMaterial.gif" name="Image43" width="85" height="25" border="0"></a></td>
                      <td width="85"><img src="image/main/tab_notice_over.gif" width="85" height="25"></td>
                      <td width="85"><a href="/main.jsp?highgubn=<%=strHighGubn%>&lowgubn=3&comm=<%=strCommittee%>"  ><img src="image/main/tab_news.gif" name="Image431" width="86" height="25" border="0" id="Image431"></a></td>
                      <td width="328" align="right" valign="middle"><a href="/board/BoardList.jsp"><img src="image/main/bt_more_red.gif" width="35" height="9" border="0"></a></td>
                    </tr>
                  </table></td>
              </tr>
              <tr> 
                <td align="left" valign="top"><img src="image/main/bar_notice.gif" width="583" height="6"></td>
              </tr>
<%
			break;
		case 3:  //뉴스
%>              
                       <!-- onMouseOut="MM_swapImgRestore()"  2004.06.15 요청에 의해 삭제-->
                      <td width="85"><a href="/main.jsp?highgubn=<%=strHighGubn%>&lowgubn=1&comm=<%=strCommittee%>"  ><img src="image/main/tab_newMaterial.gif" name="Image43" width="85" height="25" border="0"></a></td>
                      <td width="85"><a href="/main.jsp?highgubn=<%=strHighGubn%>&lowgubn=2&comm=<%=strCommittee%>"  ><img src="image/main/tab_notice.gif" name="Image431" width="85" height="25" border="0" id="Image431"></a></td>
                      <td width="85"><img src="image/main/tab_news_over.gif" width="86" height="25"></td>
                      <td width="328" align="right" valign="middle"><a href="javascript:fun_newpage('/activity/SelectNewList.jsp', 775, 380)"><img src="image/main/bt_more_red.gif" width="35" height="9" border="0"></a></td>
                    </tr>
                  </table></td>
              </tr>
              <tr> 
                <td align="left" valign="top"><img src="image/main/bar_news.gif" width="583" height="6"></td>
              </tr>
<%
			break;
	}
%>              
              <tr> 
                <td height="64" align="right" valign="top"><table width="99%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td height="10" class="newList"></td>
                    </tr>
<%

		switch (Integer.parseInt(strLowGubn)){
			/** 최신자료 **/
			case 1:
%>                                          

<%@ include file="/main/TabRecData.jsp" %>

<%

				break;
			/** 공지사항 **/
			case 2:
%>

<%@ include file="/main/TabNotice.jsp" %>

<%
				break;
			/** 뉴스 **/
			case 3:
%>                                          

<%@ include file="/main/TabRecNews.jsp" %>

<%
				break;
		}

%>
                  </table></td>
              </tr>
			  </table>