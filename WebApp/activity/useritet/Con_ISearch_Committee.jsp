<%@ page import="java.util.*"%>
<%@ page import="nads.lib.util.*"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>

<%
	ArrayList objComArry = new ArrayList();

	try{
		nads.dsdm.app.activity.useritet.UserItetDelegate objUserItetDelegateCom = new nads.dsdm.app.activity.useritet.UserItetDelegate();

		objComArry = objUserItetDelegateCom.selectBoardinfo() ;
	}catch(AppException objAppEx)
	{
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  		objMsgBean.setStrCode(objAppEx.getStrErrCode());
  		objMsgBean.setStrMsg(objAppEx.getMessage());
  		out.println("<br>Error!!!" + objAppEx.getMessage());
%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}
%>
<!-- list -->
         <span class="list01_tl">
          <%=strPrgNm%><span class="sbt"><a href="<%=strPrgUrl%>"><img src="/images2/btn/bt_all.gif" width="78" height="19" /></a></span></span>
          <table>
			  <tr>
				<td>&nbsp;</td>
			  </tr>
		  </table>
          <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
            <thead>
              <tr>
                <th scope="col"><a>NO</a></th>
                <th scope="col" style="width:300px; "><a>출처</a></th>
                <th scope="col"><a>제목</a></th>
                <th scope="col"><a>등록일자</a></th>
              </tr>
            </thead>

                    <%
						if(objComArry.size() != 0){

							for (int i = 0; i < objComArry.size(); i++) {
								Hashtable objComHt = (Hashtable)objComArry.get(i);

								String strComTitle = (String)objComHt.get("TITLE");  //제목
								String strComUrl = (String)objComHt.get("URL");   //URL
								String strComGroupNm = (String)objComHt.get("GROUPNAME");  //출처
								String strComGetdate = nads.lib.util.ActComm.makeDate((String)objComHt.get("GETDATE"));  //등록일자
					%>
            <tbody>
              <tr>
                <td><%=Integer.toString(i+1)%></td>
                <td style="text-align:left;"><%=strComGroupNm%></td>
                <td><a href="javascript:fun_winopen('<%=strComUrl%>', '위원회사이트검색')"><%=strComTitle%></a></td>
                <td><%=strComGetdate%></td>
              </tr>
            </tbody>
			<%
							}
						} else {
			%>
			<tbody>
			  <tr>
				<td colspan="4">해당 데이타가 없습니다</td>
			  </tr>
			</tbody>
			<%
						}
			%>
	</table>
<!-- list -->

<!-- 2011-09-05 이전 소스
 <tr>
                  <td height="5" colspan="2" align="left" class="soti_reqsubmit"></td>
                </tr>
                 <tr>
                   <td width="655" height="30" align="left"><span class="soti_reqsubmit"><img src="../../image/mypage/icon_mypage_soti.gif" width="9" height="9" align="absmiddle">
                     </span><span class="soti_mypage"><%=strPrgNm%></span></td>
                   <td width="104" align="left"><a href="<%=strPrgUrl%>"><img src="../../image/button/bt_allList.gif" width="101" height="20" border="0"></a></td>
                 </tr>
                 <tr>
                 <td colspan="2" align="left" valign="top"><table width="759" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td height="2" colspan="5" class="td_mypage"></td>
                    </tr>
                    <tr class="td_top">
                      <td width="48" height="22" align="center">NO</td>
                      <td width="279" height="22" align="center">출처</td>
                      <td width="340" height="22" align="center">제목</td>
                      <td width="92" height="22" align="center">등록일자</td>
                    </tr>
                    <tr>
                      <td height="1" colspan="5" class="td_mypage"></td>
                    </tr>
                    <%
						if(objComArry.size() != 0){

							for (int i = 0; i < objComArry.size(); i++) {
								Hashtable objComHt = (Hashtable)objComArry.get(i);

								String strComTitle = (String)objComHt.get("TITLE");  //제목
								String strComUrl = (String)objComHt.get("URL");   //URL
								String strComGroupNm = (String)objComHt.get("GROUPNAME");  //출처
								String strComGetdate = nads.lib.util.ActComm.makeDate((String)objComHt.get("GETDATE"));  //등록일자
					%>
                    <tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''">
                      <td height="22" align="center"><%=Integer.toString(i+1)%></td>
                      <td height="22" align="center"><%=strComGroupNm%></td>
                      <td height="22" class="td_lmagin"><a href="javascript:fun_winopen('<%=strComUrl%>', '위원회사이트검색')"><%=strComTitle%></a></td>
                      <td height="22" align="center"><%=strComGetdate%></td>
                    </tr>
                    <tr class="tbl-line">
                      <td height="1"></td>
                      <td height="1"></td>
                      <td height="1" align="left" class="td_lmagin"></td>
                      <td height="1"></td>
                    </tr>
                    <%
							}
						} else {

							out.println("<tr>");
							out.println("<td height='22' colspan='5' align='center'>해당 데이타가 없습니다.");
							out.println("</td>");
							out.println("</tr>");
							out.println("<tr class='tbl-line'>");
							out.println("<td height='1'></td>");
							out.println("<td height='1' align='left' class='td_lmagin'></td>");
							out.println("<td height='1' align='left' class='td_lmagin'></td>");
							out.println("<td height='1' align='left' class='td_lmagin'></td>");
							out.println("</tr>");

						}
					%>
					 <tr class="tbl-line">
                      <td height="1"></td>
                      <td height="1"></td>
                      <td height="1" align="left" class="td_lmagin"></td>
                      <td height="1"></td>
                    </tr>
                  </table>
				 </td>
              </tr>

-->