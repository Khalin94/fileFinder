<%@ page import="java.util.*"%>
<%@ page import="nads.lib.util.*"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>

<%
	ArrayList objDutyInfoBizArry = new ArrayList();

	ArrayList objReturnBizArry = new ArrayList();
	Hashtable objBizHt = new Hashtable();

	String strBizDutyId = ""; //��������ID
	String strBizCrtDt = "";  //���� ��������
	String strBizUserNm = "";  //�ۼ��ڸ�

	String strBizFileName = "";  //���� ���ϸ�
	String strBizDsc = "";      //�������� ����
	String strBizRealFile = "";  //������ ���ϸ�
	String strBizFileSize = "";  //���� ������
	String strBizOrganNm = "";	//�ۼ����� �μ���
	String strBizOrganId = "";	//�ۼ����� Id

	try{
		nads.dsdm.app.activity.businfo.BusInfoDelegate objBusInfoBizDelegate = new nads.dsdm.app.activity.businfo.BusInfoDelegate();

		Vector objParamBizVt = new Vector();
		objParamBizVt.add(strUserId);
		objParamBizVt.add(strUserId);
		objParamBizVt.add("3");

		objReturnBizArry = objBusInfoBizDelegate.selectOpenBizCon(objParamBizVt);
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
          <%=strPrgNm%><span class="sbt"><a href="javascript:fun_busowinopen('<%=strPrgUrl%>', '�μ���������')"><img src="/images2/btn/bt_all.gif" width="78" height="19" /></a></span></span>
  <table>
	  <tr>
		<td>&nbsp;</td>
	  </tr>
  </table>
          <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
            <thead>
              <tr>
                <th scope="col"><a>NO</a></th>
                <th scope="col" style="width:300px; "><a>����</a></th>
                <th scope="col"><a>ũ��</a></th>
                <th scope="col"><a>����Ͻ�</a></th>
                <th scope="col"><a>�����</a></th>
                <th scope="col"><a>�ҼӺμ�</a></th>
              </tr>
            </thead>
					<%
						if(objReturnBizArry.size() != 0) {

							for (int i = 0; i < objReturnBizArry.size(); i++) {

								objBizHt = (Hashtable)objReturnBizArry.get(i);
								strBizDutyId = (String)objBizHt.get("DUTY_ID");
								strBizFileName = (String)objBizHt.get("FILE_NAME");
								strBizRealFile = (String)objBizHt.get("REAL_FILE");
								strBizFileSize = (String)objBizHt.get("FILE_SIZE");
								strBizCrtDt =(String)objBizHt.get("CRT_DT");
								strBizDsc = (String)objBizHt.get("DSC");
								strBizUserNm = (String)objBizHt.get("USER_NM");
								strBizOrganNm = (String)objBizHt.get("ORGAN_NM");
								strBizOrganId = (String)objBizHt.get("ORGAN_ID");
					  %>
            <tbody>
              <tr>
                <td><%=Integer.toString(i+1)%></td>
                <td style="text-align:left;"> <a href="/activity/businfo/FileDownload.jsp?duty_id=<%=strBizDutyId%>&organ_id=<%=strBizOrganId%>&real_file=<%=strBizRealFile%>&file_name=<%=strBizFileName%>"><%=strBizFileName%></a></td>
                <td><%=strBizFileSize%></td>
                <td><%=strBizCrtDt%></td>
                <td><%=strBizUserNm%></td>
                <td><%=strBizOrganNm%></td>
              </tr>
					<%
						}
						} else {
					%>
            <tbody>
              <tr>
                <td colspan="6">�ش� ����Ÿ�� �����ϴ�</td>
              </tr>
            </tbody>
				<%
					}
				%>
          </table>
<!-- list -->

<!--  ���� �ҽ� 2011-09-05
               <tr>
                  <td height="5" colspan="2" align="left" class="soti_reqsubmit"></td>
                </tr>
                 <tr>
                   <td width="655" height="30" align="left"><span class="soti_reqsubmit"><img src="../../image/mypage/icon_mypage_soti.gif" width="9" height="9" align="absmiddle">
                     </span><span class="soti_mypage"><%=strPrgNm%></span></td>
                   <td width="104" align="left"><a href="javascript:fun_busowinopen('<%=strPrgUrl%>', '�μ���������')"><img src="../../image/button/bt_allList.gif" width="101" height="20" border="0"></a></td>
                 </tr>
                 <tr>
                 <td colspan="2" align="left" valign="top"><table width="759" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td height="2" colspan="6" class="td_mypage"></td>
                    </tr>
                    <tr class="td_top">
                      <td width="48" height="22" align="center">NO</td>
                      <td width="312" height="22" align="center">����</td>
                      <td width="73" height="22" align="center">ũ��</td>
                      <td width="152" height="22" align="center">����Ͻ�</td>
                      <td width="87" align="center">�����</td>
                      <td width="87" align="center">�ҼӺμ�</td>
                    </tr>
                    <tr>
                      <td height="1" colspan="6" class="td_mypage"></td>
                    </tr>
					<%
						if(objReturnBizArry.size() != 0) {

							for (int i = 0; i < objReturnBizArry.size(); i++) {

								objBizHt = (Hashtable)objReturnBizArry.get(i);
								strBizDutyId = (String)objBizHt.get("DUTY_ID");
								strBizFileName = (String)objBizHt.get("FILE_NAME");
								strBizRealFile = (String)objBizHt.get("REAL_FILE");
								strBizFileSize = (String)objBizHt.get("FILE_SIZE");
								strBizCrtDt =(String)objBizHt.get("CRT_DT");
								strBizDsc = (String)objBizHt.get("DSC");
								strBizUserNm = (String)objBizHt.get("USER_NM");
								strBizOrganNm = (String)objBizHt.get("ORGAN_NM");
								strBizOrganId = (String)objBizHt.get("ORGAN_ID");
					  %>
                    <tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''">
                      <td height="22" align="center"><%=Integer.toString(i+1)%></td>
                      <td height="22" class="td_lmagin" onMouseover="showtip(this,event,'<%=strBizDsc%>')" onMouseout="hidetip()">
                        <a href="/activity/businfo/FileDownload.jsp?duty_id=<%=strBizDutyId%>&organ_id=<%=strBizOrganId%>&real_file=<%=strBizRealFile%>&file_name=<%=strBizFileName%>"><%=strBizFileName%></a></td>
                      <td height="22" align="center"><%=strBizFileSize%></td>
                      <td height="22" align="center"><%=strBizCrtDt%></td>
                      <td height="22" align="center"><%=strBizUserNm%></td>
                      <td height="22" align="center"><%=strBizOrganNm%></td>
                    </tr>
                    <tr class="tbl-line">
                      <td height="1"></td>
                      <td height="1"></td>
                      <td height="1" align="left" class="td_lmagin"></td>
                      <td height="1" align="left" class="td_lmagin"></td>
                      <td height="1"></td>
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
							out.println("<td height='1'></td>");
							out.println("<td height='1' align='left' class='td_lmagin'></td>");
							out.println("<td height='1' align='left' class='td_lmagin'></td>");
							out.println("<td align='left' class='td_lmagin'></td>");
							out.println("</tr>");

						}
					%>
                    <tr class="tbl-line">
                      <td height="1"></td>
                      <td height="1"></td>
                      <td height="1" align="left" class="td_lmagin"></td>
                      <td height="1" align="left" class="td_lmagin"></td>
                      <td height="1"></td>
                      <td height="1"></td>
                    </tr>
                  </table>
                  <!-- �������� ����Ʈ ���̺� �� ------------------------
                  </td>
              </tr>
-->