<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ page import="kr.co.kcc.bf.config.*" %>
<%@ page import="nads.lib.util.BoardComm" %>
<%@ page import="nads.lib.util.*"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>

<%
	ArrayList objBoardDataArry = new ArrayList();
	String strBbrdID = "";
	String strAppCode = "";

	try{
		Config objConfigNotice = PropertyConfig.getInstance();

		if(strPrgId.equals(strFreeBoard)){
			strAppCode = strFreeBoard;     //자유게시판 프로그램ID('activity.useritet.board.freeBoard')
		}
		if(strPrgId.equals(strNoticeBoard)){
			strAppCode = strNoticeBoard;  //공지사항 프로그램ID('activity.useritet.board.noticeBoard')
		}
		if(strPrgId.equals(strReportBoard)){
			strAppCode = strReportBoard;  //보도자료 프로그램ID('activity.useritet.board.reportBoard')
		}
		if(strPrgId.equals(strDataBoard)){
			strAppCode = strDataBoard;  //자료실 프로그램ID('activity.useritet.board.dataBoard')
		}

		nads.dsdm.app.board.SLBoardDelegate objBoard = new nads.dsdm.app.board.SLBoardDelegate();
		//게시판 ID를 가져온다.
		ArrayList objAryBbrdMenu = objBoard.selectBbrdMenu("MYBOARD", strUserId, strAppCode);

		if (objAryBbrdMenu.size() != 0){
			strBbrdID = (String)((Hashtable)objAryBbrdMenu.get(0)).get("PARAM");
			strBbrdID = strBbrdID.replaceAll(" ", "");
			int intIndex = strBbrdID.indexOf("bbrdid=");
			strBbrdID = strBbrdID.substring(intIndex+7, intIndex+17);
		}

		//게시판 정보를 가져온다.
		objBoardDataArry = objBoard.selectBbrdThreeData("BoardData", strBbrdID, "3");

	}
	catch(AppException objAppEx) {
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
          <%=strPrgNm%><span class="sbt"><a href="<%=strPrgUrl%>?bbrdid=0000000127"><img src="/images2/btn/bt_all.gif" width="78" height="19" /></a></span></span>
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
                <th scope="col"><a>파일</a></th>
                <th scope="col"><a>등록자</a></th>
                <th scope="col"><a>등록일자</a></th>
                <th scope="col"><a>조회</a></th>
                <th scope="col"><a>게시판명</a></th>
              </tr>
            </thead>
			<%
				if(objBoardDataArry.size() > 0){
					for (int i = 0; i < objBoardDataArry.size(); i++) {
						Hashtable objHshBbrdData = (Hashtable)objBoardDataArry.get(i);

						String strDataIdData = (String)objHshBbrdData.get("DATA_ID");  //게시물ID
						String strTitleData = BoardComm.replaceTag2Text((String)objHshBbrdData.get("TITLE"));  //제목
						String strUserNmData = (String)objHshBbrdData.get("USER_NM");  //작성자명
						String strWriteTsData = (String)objHshBbrdData.get("WRITE_TS");  //작성일자
						String strUpdTsData = (String)objHshBbrdData.get("UPD_TS");      //수정일자
						String strBbrdIdData = (String)objHshBbrdData.get("BBRD_ID");     //게시판ID
						String strBbrdNmData = (String)objHshBbrdData.get("BBRD_NM");  //게시판명
						if(!strUpdTsData.equals("")){
							strWriteTsData = strUpdTsData;
						}
						strWriteTsData = strWriteTsData.substring(0, 4) + "-" + strWriteTsData.substring(4, 6) + "-"
											+ strWriteTsData.substring(6, 8);
						String strFileExtData = (String)objHshBbrdData.get("APD_FILE_EXT");
						String strFileExtImgData = "&nbsp;";
						if(strFileExtData.equals("Y")){
							strFileExtImgData = "<img src='/image/common/icon_file.gif' width='13' height='15'>";
						}
						String strQryCntData = (String)objHshBbrdData.get("QRY_CNT");
						int intDataLevelData = Integer.valueOf((String)objHshBbrdData.get("DATA_LEVEL")).intValue();
						String strDelFlagData = (String)objHshBbrdData.get("DEL_FLAG");
						if(strDelFlagData.equals("A")){
							strTitleData = "해당글이 삭제 되었습니다";
						}
			%>
            <tbody>
              <tr>
                <td><%=Integer.toString(i+1)%></td>
                <td style="text-align:left;"><%
						if(intDataLevelData > 0 ){

							String strWidData = "";

							for(int j=0; j < intDataLevelData ; j++){
								strWidData = strWidData + "&nbsp;&nbsp;&nbsp;";
							}
							out.print(strWidData + "<img src='/image/board/icon_reply.gif' border='0'>");

						}
						String strGoToPage = URLEncoder.encode("/board/BoardContent.jsp", "UTF-8");
                      %>
                      <a href="/board/common/BoardList2Content.jsp?strGoToPage=<%=strGoToPage%>&strCurrentPage=1&bbrdid=<%=strBbrdIdData%>&dataid=<%=strDataIdData%>"><%=strTitleData%></a></td>
                <td><%=strFileExtImgData%></td>
                <td><%=strUserNmData%></td>
                <td><%=strWriteTsData%></td>
                <td><%=strQryCntData%></td>
				<td><%=strBbrdNmData%></td>
              </tr>
            </tbody>
					<%
						}
						} else {
					%>
            <tbody>
              <tr>
                <td colspan="7">해당 데이타가 없습니다</td>
              </tr>
            </tbody>
				<%
					}
				%>
          </table>

          <!-- /list -->
<!--
   <tr>
                  <td height="5" colspan="2" align="left" class="soti_reqsubmit"></td>
                </tr>
                 <tr>
                   <td width="655" height="30" align="left"><span class="soti_reqsubmit"><img src="../../image/mypage/icon_mypage_soti.gif" width="9" height="9" align="absmiddle">
                     </span><span class="soti_mypage"><%=strPrgNm%></span></td>
                   <td width="104" align="left"><a href="<%=strPrgUrl%>?bbrdid=<%=strBbrdID%>"><img src="../../image/button/bt_allList.gif" width="101" height="20" border="0"></a></td>
                 </tr>
                 <tr>
                 <td colspan="2" align="left" valign="top"><table width="759" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td height="2" colspan="7" class="td_mypage"></td>
                    </tr>
                    <tr class="td_top">
                      <td width="45" height="22" align="center">NO</td>
                      <td width="300" height="22" align="center">제목</td>
                      <td width="50" height="22" align="center">파일</td>
                      <td width="70" height="22" align="center">등록자</td>
                      <td width="70" height="22" align="center">등록일자</td>
                      <td width="50" align="center">조회</td>
                      <td width="165" align="center">게시판명</td>
                    </tr>
                    <tr>
                      <td height="1" colspan="7" class="td_mypage"></td>
                    </tr>
					<%
						if(objBoardDataArry.size() > 0){
							for (int i = 0; i < objBoardDataArry.size(); i++) {
								Hashtable objHshBbrdData = (Hashtable)objBoardDataArry.get(i);

								String strDataIdData = (String)objHshBbrdData.get("DATA_ID");  //게시물ID
								String strTitleData = BoardComm.replaceTag2Text((String)objHshBbrdData.get("TITLE"));  //제목
								String strUserNmData = (String)objHshBbrdData.get("USER_NM");  //작성자명
								String strWriteTsData = (String)objHshBbrdData.get("WRITE_TS");  //작성일자
								String strUpdTsData = (String)objHshBbrdData.get("UPD_TS");      //수정일자
								String strBbrdIdData = (String)objHshBbrdData.get("BBRD_ID");     //게시판ID
								String strBbrdNmData = (String)objHshBbrdData.get("BBRD_NM");  //게시판명
								if(!strUpdTsData.equals("")){
									strWriteTsData = strUpdTsData;
								}
								strWriteTsData = strWriteTsData.substring(0, 4) + "-" + strWriteTsData.substring(4, 6) + "-"
													+ strWriteTsData.substring(6, 8);
								String strFileExtData = (String)objHshBbrdData.get("APD_FILE_EXT");
								String strFileExtImgData = "&nbsp;";
								if(strFileExtData.equals("Y")){
									strFileExtImgData = "<img src='/image/common/icon_file.gif' width='13' height='15'>";
								}
								String strQryCntData = (String)objHshBbrdData.get("QRY_CNT");
								int intDataLevelData = Integer.valueOf((String)objHshBbrdData.get("DATA_LEVEL")).intValue();
								String strDelFlagData = (String)objHshBbrdData.get("DEL_FLAG");
								if(strDelFlagData.equals("A")){
									strTitleData = "해당글이 삭제 되었습니다";
								}
					%>
                    <tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''">
                      <td height="22" align="center"><%=Integer.toString(i+1)%></td>
                      <td height="22" class="td_lmagin">
                      <%
						if(intDataLevelData > 0 ){

							String strWidData = "";

							for(int j=0; j < intDataLevelData ; j++){
								strWidData = strWidData + "&nbsp;&nbsp;&nbsp;";
							}
							out.print(strWidData + "<img src='/image/board/icon_reply.gif' border='0'>");

						}
						String strGoToPage = URLEncoder.encode("/board/BoardContent.jsp", "UTF-8");
                      %>
                      <a href="/board/common/BoardList2Content.jsp?strGoToPage=<%=strGoToPage%>&strCurrentPage=1&bbrdid=<%=strBbrdIdData%>&dataid=<%=strDataIdData%>"><%=strTitleData%></a></td>
                      <td height="22" align="center"><%=strFileExtImgData%></td>
                      <td height="22" align="center"><%=strUserNmData%></td>
                      <td height="22" align="center"><%=strWriteTsData%></td>
                      <td align="center"><%=strQryCntData%></td>
                      <td height="22" align="center"><%=strBbrdNmData%></td>
                    </tr>
                    <tr class="tbl-line">
                      <td height="1"></td>
                      <td height="1"></td>
                      <td height="1" align="left" class="td_lmagin"></td>
                      <td height="1" align="left" class="td_lmagin"></td>
                      <td height="1" align="left" class="td_lmagin"></td>
                      <td height="1" align="left" class="td_lmagin"></td>
                      <td height="1" align="left" class="td_lmagin"></td>
                    </tr>
					<%
							}
						} else {

							out.println("<tr>");
							out.println("<td height='22' colspan='7' align='center'>해당 데이타가 없습니다.");
							out.println("</td>");
							out.println("</tr>");
							out.println("<tr class='tbl-line'>");
							out.println("<td height='1'></td>");
							out.println("<td height='1'></td>");
							out.println("<td height='1'></td>");
							out.println("<td height='1' align='left' class='td_lmagin'></td>");
							out.println("<td height='1' align='left' class='td_lmagin'></td>");
							out.println("<td height='1' align='left' class='td_lmagin'></td>");
							out.println("<td height='1' align='left' class='td_lmagin'></td>");
							out.println("</tr>");

						}
					%>
					<tr class="tbl-line">
                      <td height="1"></td>
                      <td height="1"></td>
                      <td height="1"></td>
                      <td height="1" align="left" class="td_lmagin"></td>
                      <td height="1" align="left" class="td_lmagin"></td>
                      <td height="1" align="left" class="td_lmagin"></td>
                      <td height="1" align="left" class="td_lmagin"></td>
                    </tr>
                  </table>
                  !-- 공지사항 리스트 테이블 끝 -------------------------
                  </td>
              </tr>

			  -->