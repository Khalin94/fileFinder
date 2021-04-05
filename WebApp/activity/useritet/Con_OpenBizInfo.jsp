<%@ page import="java.util.*"%>
<%@ page import="nads.lib.util.*"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>

<%
	ArrayList objDutyInfoOpenArry = new ArrayList();

	Hashtable objReturnOpenHt = new Hashtable();
	String strOpenDutyId = "";
	String strOpenCrtDt = "";
	String strOpenUserNm = "";

	String strOpenFileName = "";
	String strOpenDsc = "";
	String strOpenRealFile = "";
	String strOpenFileSize = "";
	String strOpenOrganNm = "";

	try{
		nads.dsdm.app.activity.businfo.BusInfoDelegate objBusInfoOpenDelegate = new nads.dsdm.app.activity.businfo.BusInfoDelegate();

		Hashtable objParamOpenHt = new Hashtable();
		objParamOpenHt.put("GUBUN", "1");
		objParamOpenHt.put("CONTENT", "");
		objParamOpenHt.put("CURRENTPAGE", "1");
		objParamOpenHt.put("COUNTPERPAGE", "3");

		Hashtable objDutyInfoOpenHt = objBusInfoOpenDelegate.selectOpenDutyInfoList(objParamOpenHt);
		objDutyInfoOpenArry = (ArrayList)objDutyInfoOpenHt.get("DUTY_INFO");
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
  <%=strPrgNm%><span class="sbt"><a href="javascript:fun_busowinopen('<%=strPrgUrl%>', '공개업무정보')"><img src="/images2/btn/bt_all.gif" width="78" height="19" /></a></span></span>
  <table>
	  <tr>
		<td>&nbsp;</td>
	  </tr>
  </table>
  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
	<thead>
	  <tr>
		<th scope="col"><a>NO</a></th>
		<th scope="col" style="width:300px; "><a>제목</a></th>
		<th scope="col"><a>크기</a></th>
		<th scope="col"><a>등록일시</a></th>
		<th scope="col"><a>등록자</a></th>
		<th scope="col"><a>소속부서</a></th>
	  </tr>
	</thead>
					<%
						if(objDutyInfoOpenArry.size() != 0) {

							for (int i = 0; i < objDutyInfoOpenArry.size(); i++) {

								objReturnOpenHt = (Hashtable)objDutyInfoOpenArry.get(i);
								strOpenDutyId = (String)objReturnOpenHt.get("DUTY_ID");
								strOpenFileName = (String)objReturnOpenHt.get("FILE_NAME");
								strOpenRealFile = (String)objReturnOpenHt.get("REAL_FILE");
								strOpenFileSize = (String)objReturnOpenHt.get("FILE_SIZE");
								strOpenCrtDt =(String)objReturnOpenHt.get("CRT_DT");
								strOpenDsc = (String)objReturnOpenHt.get("DSC");
								strOpenUserNm = (String)objReturnOpenHt.get("USER_NM");
								strOpenOrganNm = (String)objReturnOpenHt.get("ORGAN_NM");
					  %>
	<tbody>
	  <tr>
		<td><%=Integer.toString(i+1)%></td>
		<td style="text-align:left;"><a href="./businfo/FileDownload.jsp?duty_id=<%=strOpenDutyId%>&real_file=<%=strOpenRealFile%>&file_name=<%=strOpenFileName%>"><%=strOpenFileName%></a></td>
                      <td height="22" align="center"><%=strOpenFileSize%></td>
		<td><%=strOpenFileSize%></td>
		<td><%=strOpenCrtDt%></td>
		<td><%=strOpenUserNm%></td>
		<td><%=strOpenOrganNm%></td>
		</tr>
		<%
			}
			} else {
		%>
	<tbody>
	  <tr>
		<td colspan="6">해당 데이타가 없습니다</td>
	  </tr>
	</tbody>
		<%
			}
		%>
	</table>


<!--  기존 소스 2011-09-05

                <tr>
                  <td height="5" colspan="2" align="left" class="soti_reqsubmit"></td>
                </tr>
                 <tr>
                   <td width="655" height="30" align="left"><span class="soti_reqsubmit"><img src="../../image/mypage/icon_mypage_soti.gif" width="9" height="9" align="absmiddle">
                     </span><span class="soti_mypage"><%=strPrgNm%></span></td>
                   <td width="104" align="left"><a href="javascript:fun_busowinopen('<%=strPrgUrl%>', '공개업무정보')"><img src="../../image/button/bt_allList.gif" width="101" height="20" border="0"></a></td>
                 </tr>
                 <tr>
                 <td colspan="2" align="left" valign="top"><table width="759" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td height="2" colspan="6" class="td_mypage"></td>
                    </tr>
                    <tr class="td_top">
                      <td width="48" height="22" align="center">NO</td>
                      <td width="312" height="22" align="center">제목</td>
                      <td width="73" height="22" align="center">크기</td>
                      <td width="152" height="22" align="center">등록일시</td>
                      <td width="87" align="center">등록자</td>
                      <td width="87" align="center">소속부서</td>
                    </tr>
                    <tr>
                      <td height="1" colspan="6" class="td_mypage"></td>
                    </tr>
					<%
						if(objDutyInfoOpenArry.size() != 0) {

							for (int i = 0; i < objDutyInfoOpenArry.size(); i++) {

								objReturnOpenHt = (Hashtable)objDutyInfoOpenArry.get(i);
								strOpenDutyId = (String)objReturnOpenHt.get("DUTY_ID");
								strOpenFileName = (String)objReturnOpenHt.get("FILE_NAME");
								strOpenRealFile = (String)objReturnOpenHt.get("REAL_FILE");
								strOpenFileSize = (String)objReturnOpenHt.get("FILE_SIZE");
								strOpenCrtDt =(String)objReturnOpenHt.get("CRT_DT");
								strOpenDsc = (String)objReturnOpenHt.get("DSC");
								strOpenUserNm = (String)objReturnOpenHt.get("USER_NM");
								strOpenOrganNm = (String)objReturnOpenHt.get("ORGAN_NM");
					  %>
                    <tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''">
                      <td height="22" align="center"><%=Integer.toString(i+1)%></td>
                      <td height="22" class="td_lmagin" onMouseover="showtip(this,event,'<%=strOpenDsc%>')" onMouseout="hidetip()">
                        <a href="./businfo/FileDownload.jsp?duty_id=<%=strOpenDutyId%>&real_file=<%=strOpenRealFile%>&file_name=<%=strOpenFileName%>"><%=strOpenFileName%></a></td>
                      <td height="22" align="center"><%=strOpenFileSize%></td>
                      <td height="22" align="center"><%=strOpenCrtDt%></td>
                      <td height="22" align="center"><%=strOpenUserNm%></td>
                      <td height="22" align="center"><%=strOpenOrganNm%></td>
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
							out.println("<td height='22' colspan='5' align='center'>해당 데이타가 없습니다.");
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
                  <!-- 공지사항 리스트 테이블 끝 ----------------------
                  </td>
              </tr>

-->