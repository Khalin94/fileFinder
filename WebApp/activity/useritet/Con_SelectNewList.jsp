<%@ page import="java.util.*"%>
<%@ page import="nads.lib.util.*"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>

<%
	ArrayList objNewArry = new ArrayList();

	try{
		nads.dsdm.app.activity.useritet.UserItetDelegate objUserItetDelegateNew = new nads.dsdm.app.activity.useritet.UserItetDelegate();

		Hashtable objParamHt = new Hashtable();
		objParamHt.put("GUBUN", "-1");
		objParamHt.put("CONTENT", "");
		objParamHt.put("CURRENTPAGE", "1");   //����������
		objParamHt.put("COUNTPERPAGE", "3");  //�������� ���ڵ� ��

		Hashtable objNewHt = objUserItetDelegateNew.selectNewinfo(objParamHt);

		objNewArry = (ArrayList)objNewHt.get("NEW");

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
          <%=strPrgNm%><span class="sbt"><a href="javascript:fun_newpage('/activity/SelectNewList.jsp', 775, 380)"><img src="/images2/btn/bt_all.gif" width="78" height="19" /></a></span></span>
          <table>
			  <tr>
				<td>&nbsp;</td>
			  </tr>
		  </table>
          <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
            <thead>
              <tr>
                <th scope="col"><a>NO</a></th>
                <th scope="col" style="width:300px; "><a>��ó</a></th>
                <th scope="col"><a>����</a></th>
                <th scope="col"><a>�������</a></th>
              </tr>
            </thead>

			<%
				if(objNewArry.size() != 0){

					for (int i = 0; i < objNewArry.size(); i++) {
						Hashtable objNewHt = (Hashtable)objNewArry.get(i);

						String strNewTitle = (String)objNewHt.get("TITLE");
						String strNewUrl = (String)objNewHt.get("URL");
						String strNewGroupNm = (String)objNewHt.get("GROUPNAME");
						String strNewRegdate = nads.lib.util.ActComm.makeDate((String)objNewHt.get("GETDATE"));
			%>
            <tbody>
              <tr>
                <td><%=Integer.toString(i+1)%></td>
                <td style="text-align:left;"><%=strNewGroupNm%></td>
                <td><a href="javascript:fun_winopen('<%=strNewUrl%>', '�����˻�')"><%=strNewTitle%></a></td>
                <td><%=strNewRegdate%></td>
              </tr>
            </tbody>
			<%
					}
				} else {
			%>
			<tbody>
			  <tr>
				<td colspan="4">�ش� ����Ÿ�� �����ϴ�</td>
			  </tr>
			</tbody>
			<%
				}
			%>
	</table>

<!-- /list -->

<!-- 2011-09-05 ���� �ҽ�
                <tr>
                  <td height="5" colspan="2" align="left" class="soti_reqsubmit"></td>
                </tr>
                 <tr>
                   <td width="655" height="30" align="left"><span class="soti_reqsubmit"><img src="../../image/mypage/icon_mypage_soti.gif" width="9" height="9" align="absmiddle">
                     </span><span class="soti_mypage"><%=strPrgNm%></span></td>
                   <td width="104" align="left"><a href="javascript:fun_newpage('/activity/SelectNewList.jsp', 775, 380)"><img src="../../image/button/bt_allList.gif" width="101" height="20" border="0"></a></td>
                 </tr>
                 <tr>
                 <td colspan="2" align="left" valign="top"><table width="759" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td height="2" colspan="5" class="td_mypage"></td>
                    </tr>
                    <tr class="td_top">
                      <td width="48" height="22" align="center">NO</td>
                      <td width="179" height="22" align="center">��ó</td>
                      <td width="440" height="22" align="center">����</td>
                      <td width="92" height="22" align="center">�������</td>
                    </tr>
                    <tr>
                      <td height="1" colspan="5" class="td_mypage"></td>
                    </tr>
                    <%
						if(objNewArry.size() != 0){

							for (int i = 0; i < objNewArry.size(); i++) {
								Hashtable objNewHt = (Hashtable)objNewArry.get(i);

								String strNewTitle = (String)objNewHt.get("TITLE");
								String strNewUrl = (String)objNewHt.get("URL");
								String strNewGroupNm = (String)objNewHt.get("GROUPNAME");
								String strNewRegdate = nads.lib.util.ActComm.makeDate((String)objNewHt.get("GETDATE"));
					%>
                    <tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''">
                      <td height="22" align="center"><%=Integer.toString(i+1)%></td>
                      <td height="22" align="center"><%=strNewGroupNm%></td>
                      <td height="22" class="td_lmagin"><a href="javascript:fun_winopen('<%=strNewUrl%>', '�����˻�')"><%=strNewTitle%></a></td>
                      <td height="22" align="center"><%=strNewRegdate%></td>
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
							out.println("<td height='22' colspan='5' align='center'>�ش� ����Ÿ�� �����ϴ�.");
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