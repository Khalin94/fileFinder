			  <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td align="left" valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr align="left" valign="top"> 
<%
	switch (Integer.parseInt(strHighGubn)){
		case 1:
%>
                      <td width="125"><img src="image/main/tab_newReqBoxList_over.gif" width="125" height="25"></td>
                       <!-- onMouseOut="MM_swapImgRestore()"  onMouseOver="MM_swapImage('Image30','','image/main/tab_newReqList_over.gif',1)" 2004.06.15 요청에 의해 삭제-->
<%
			if(!strUserGubn.equals("true")){
%>                      
                      <td width="126"><a href="/main.jsp?highgubn=2&lowgubn=<%=strLowGubn%>&comm=<%=strCommittee%>"  ><img src="image/main/tab_newReqList.gif" name="Image30" width="126" height="25" border="0"></a></td>
<%
			}else{
%>
                      <td width="126"><a href="/main.jsp?highgubn=2&lowgubn=<%=strLowGubn%>&comm=<%=strCommittee%>"  ><img src="image/main/tab_newSubmitList.gif" name="Image30" width="126" height="25" border="0"></a></td>
<%
			}
%>
			                      
                      <td width="332" align="right" valign="middle">
                        <a href="<%=RequestBoxDelegate.getGotoMoreLink(blnIsRequesterTop,(String)request.getSession().getAttribute("ORGAN_KIND"))%>">
                          <img src="image/main/bt_more_green.gif" width="35" height="9" border="0">
                        </a>
                      </td>
                    </tr>
                  </table></td>
              </tr>
              <tr> 
                <td align="left" valign="top"><img src="image/main/bar_newReqBoxList.gif" width="583" height="6"></td>
              </tr>
<%
			break;
		case 2:
			/** 제출자, 요구자 를 구분한다 **/
			if(!strUserGubn.equals("true")){
%>
                       <!-- onMouseOut="MM_swapImgRestore()"  onMouseOver="MM_swapImage('Image30','','image/main/tab_newReqBoxList_over.gif',1)" 2004.06.15 요청에 의해 삭제-->
                      <td width="126"><a href="/main.jsp?highgubn=1&lowgubn=<%=strLowGubn%>&comm=<%=strCommittee%>"  ><img src="image/main/tab_newReqBoxList.gif" name="Image30" width="126" height="25" border="0"></a></td>
                      <td width="125"><img src="image/main/tab_newReqList_over.gif" width="125" height="25"></td>
<%
			}else{
%>
                      <td width="126"><a href="/main.jsp?highgubn=1&lowgubn=<%=strLowGubn%>&comm=<%=strCommittee%>"  ><img src="image/main/tab_newReqBoxList.gif" name="Image30" width="126" height="25" border="0"></a></td>
                      <td width="125"><img src="image/main/tab_newSubmitList_over.gif" width="125" height="25"></td>
<%
			}
%>
                      <td width="332" align="right" valign="middle">
                        <a href="<%=RequestInfoDelegate.gotoMainMoreLink(blnIsRequesterTop,(String)request.getSession().getAttribute("ORGAN_KIND"))%>">
                          <img src="image/main/bt_more_green.gif" width="35" height="9" border="0">
                        </a>
                      </td>
                    </tr>
                  </table></td>
              </tr>
              <tr> 
                <td align="left" valign="top"><img src="image/main/bar_newReqsubmitList.gif" width="583" height="6"></td>
              </tr>
<%
	}
%>                  
              <tr> 
                <td  height="100" align="right" valign="top"><table width="99%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td height="10" class="newList"></td>
                    </tr>
<%

		switch (Integer.parseInt(strHighGubn)){
			/** 최신자료 **/
			case 1:
%>                                          

<%@ include file="/main/TabReqSubmitBox.jsp" %>

<%

				break;
			/** 공지사항 **/
			case 2:
%>
            
<%@ include file="/main/TabReqSubmitList.jsp" %>

<%
				break;
		}

%>
                  </table></td>
              </tr>
			  </table>
