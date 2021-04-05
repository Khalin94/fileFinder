<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ page import="kr.co.kcc.bf.config.*" %>
<%@ page import="nads.lib.util.BoardComm" %>
<%@ page import="nads.lib.util.*"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%
	String strBoardIdNotice = "";

	ArrayList objAryBbrdData = new ArrayList();

	try{
		Config objConfigNotice = PropertyConfig.getInstance();

		String strConfigParam = "";
		if(strForumNotice.equals(strPrgId)){
			strConfigParam = "board.forumAllNotice";  //포럼의 전체공지사항 게시판 종류('998')
		}else{
			strConfigParam = "board.forumAllFree";  //포럼의 자유게시판 게시판 종류('999')
		}

		String strNotice = objConfigNotice.get(strConfigParam);
		nads.dsdm.app.board.SLBoardDelegate objForumBoard = new nads.dsdm.app.board.SLBoardDelegate();
		Hashtable objBoardIdNoticeHt = objForumBoard.selectIndBoardID(strNotice);
		strBoardIdNotice = (String)objBoardIdNoticeHt.get("BBRD_ID");
		objAryBbrdData = objForumBoard.selectBbrdDataListPerPage(strBoardIdNotice, "0", "1", "3");

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

          <span class="list01_tl">
          <%=strPrgNm%><span class="sbt"><a href="<%=strPrgUrl%>?bbrdid=<%=strBoardIdNotice%>"><img src="/images2/btn/bt_all.gif" width="78" height="19" /></a></span></span>
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
              </tr>
            </thead>
				<%
					if(objAryBbrdData.size() > 1){
						for (int i = 1; i < objAryBbrdData.size(); i++) {
							Hashtable objHshBbrdDataNotice = (Hashtable)objAryBbrdData.get(i);

							String strDataIDNotice = (String)objHshBbrdDataNotice.get("DATA_ID");  //게시물ID
							String strTitleNotice = BoardComm.replaceTag2Text((String)objHshBbrdDataNotice.get("TITLE"));  //제목
							String strUserNmNotice = (String)objHshBbrdDataNotice.get("USER_NM");  //작성자
							String strWriteTsNotice = (String)objHshBbrdDataNotice.get("WRITE_TS");  //생성일자
							String strUpdTsNotice = (String)objHshBbrdDataNotice.get("UPD_TS");   //수정일자
							if(!strUpdTsNotice.equals("")){
								strWriteTsNotice = strUpdTsNotice;
							}
							strWriteTsNotice = strWriteTsNotice.substring(0, 4) + "-" + strWriteTsNotice.substring(4, 6) + "-"
												+ strWriteTsNotice.substring(6, 8);
							String strFileExtNotice = (String)objHshBbrdDataNotice.get("APD_FILE_EXT");  //파일첨부여부
							String strFileExtImgNotice = "&nbsp;";
							if(strFileExtNotice.equals("Y")){
								strFileExtImgNotice = "<img src='/image/common/icon_file.gif' width='13' height='15'>";
							}
							String strQryCntNotice = (String)objHshBbrdDataNotice.get("QRY_CNT");  //조회건수
							int intDataLevelNotice = Integer.valueOf((String)objHshBbrdDataNotice.get("DATA_LEVEL")).intValue();
							String strDelFlagNotice = (String)objHshBbrdDataNotice.get("DEL_FLAG");  //삭제여부
							if(strDelFlagNotice.equals("A")){
								strTitleNotice = "해당글이 삭제 되었습니다";
							}
				%>
            <tbody>
              <tr>
                <td><%=Integer.toString(i)%></td>
                <td style="text-align:left;"><%
						if(intDataLevelNotice > 0 ){

							String strWidNotice = "";

							for(int j=0; j < intDataLevelNotice ; j++){
								strWidNotice = strWidNotice + "&nbsp;&nbsp;&nbsp;";
							}
							out.print(strWidNotice + "<img src='/image/board/icon_reply.gif' border='0'>");

						}

						String strGoToPage = URLEncoder.encode("/forum/board/ForumBoardContent.jsp", "UTF-8");
                      %>
                      <a href="/board/common/BoardList2Content.jsp?strGoToPage=<%=strGoToPage%>&strCurrentPage=1&bbrdid=<%=strBoardIdNotice%>&dataid=<%=strDataIDNotice%>"><%=strTitleNotice%></a></td>
                <td><%=strFileExtImgNotice%></td>
                <td><%=strUserNmNotice%></td>
                <td><img src="/images2/common/icon_noAnswer.gif" width="26" height="20" /></td>
                <td><%=strQryCntNotice%></td>
              </tr>
            </tbody>
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


<!--
===================================================================================================================================================================================
-->
<!--    2011-08-30  이전 소스 부분

                <tr>
                  <td height="5" colspan="2" align="left" class="soti_reqsubmit"></td>
                </tr>
                 <tr>
                   <td width="655" height="30" align="left"><span class="soti_reqsubmit"><img src="../../image/mypage/icon_mypage_soti.gif" width="9" height="9" align="absmiddle">
                     </span><span class="soti_mypage"><%=strPrgNm%></span></td>
                   <td width="104" align="left"><a href="<%=strPrgUrl%>?bbrdid=<%=strBoardIdNotice%>"><img src="../../image/button/bt_allList.gif" width="101" height="20" border="0"></a></td>
                 </tr>
                 <tr>
                 <td colspan="2" align="left" valign="top"><table width="759" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td height="2" colspan="6" class="td_mypage"></td>
                    </tr>
                    <tr class="td_top">
                      <td width="45" height="22" align="center">NO</td>
                      <td width="465" height="22" align="center">제목</td>
                      <td width="50" height="22" align="center">파일</td>
                      <td width="70" height="22" align="center">등록자</td>
                      <td width="70" height="22" align="center">등록일자</td>
                      <td width="50" align="center">조회</td>
                    </tr>
                    <tr>
                      <td height="1" colspan="6" class="td_mypage"></td>
                    </tr>
					<%
						if(objAryBbrdData.size() > 1){
							for (int i = 1; i < objAryBbrdData.size(); i++) {
								Hashtable objHshBbrdDataNotice = (Hashtable)objAryBbrdData.get(i);

								String strDataIDNotice = (String)objHshBbrdDataNotice.get("DATA_ID");  //게시물ID
								String strTitleNotice = BoardComm.replaceTag2Text((String)objHshBbrdDataNotice.get("TITLE"));  //제목
								String strUserNmNotice = (String)objHshBbrdDataNotice.get("USER_NM");  //작성자
								String strWriteTsNotice = (String)objHshBbrdDataNotice.get("WRITE_TS");  //생성일자
								String strUpdTsNotice = (String)objHshBbrdDataNotice.get("UPD_TS");   //수정일자
								if(!strUpdTsNotice.equals("")){
									strWriteTsNotice = strUpdTsNotice;
								}
								strWriteTsNotice = strWriteTsNotice.substring(0, 4) + "-" + strWriteTsNotice.substring(4, 6) + "-"
													+ strWriteTsNotice.substring(6, 8);
								String strFileExtNotice = (String)objHshBbrdDataNotice.get("APD_FILE_EXT");  //파일첨부여부
								String strFileExtImgNotice = "&nbsp;";
								if(strFileExtNotice.equals("Y")){
									strFileExtImgNotice = "<img src='/image/common/icon_file.gif' width='13' height='15'>";
								}
								String strQryCntNotice = (String)objHshBbrdDataNotice.get("QRY_CNT");  //조회건수
								int intDataLevelNotice = Integer.valueOf((String)objHshBbrdDataNotice.get("DATA_LEVEL")).intValue();
								String strDelFlagNotice = (String)objHshBbrdDataNotice.get("DEL_FLAG");  //삭제여부
								if(strDelFlagNotice.equals("A")){
									strTitleNotice = "해당글이 삭제 되었습니다";
								}
					%>
                    <tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''">
                      <td height="22" align="center"><%=Integer.toString(i)%></td>
                      <td height="22" class="td_lmagin">
                      <%
						if(intDataLevelNotice > 0 ){

							String strWidNotice = "";

							for(int j=0; j < intDataLevelNotice ; j++){
								strWidNotice = strWidNotice + "&nbsp;&nbsp;&nbsp;";
							}
							out.print(strWidNotice + "<img src='/image/board/icon_reply.gif' border='0'>");

						}

						String strGoToPage = URLEncoder.encode("/forum/board/ForumBoardContent.jsp", "UTF-8");
                      %>
                      <a href="/board/common/BoardList2Content.jsp?strGoToPage=<%=strGoToPage%>&strCurrentPage=1&bbrdid=<%=strBoardIdNotice%>&dataid=<%=strDataIDNotice%>"><%=strTitleNotice%></a></td>
                      <td height="22" align="center"><%=strFileExtImgNotice%></td>
                      <td height="22" align="center"><%=strUserNmNotice%></td>
                      <td height="22" align="center"><%=strWriteTsNotice%></td>
                      <td align="center"><%=strQryCntNotice%></td>
                    </tr>
                    <tr class="tbl-line">
                      <td height="1"></td>
                      <td height="1"></td>
                      <td height="1" align="left" class="td_lmagin"></td>
                      <td height="1" align="left" class="td_lmagin"></td>
                      <td height="1" align="left" class="td_lmagin"></td>
                      <td height="1"></td>
                    </tr>
					<%
							}
						} else {

							out.println("<tr>");
							out.println("<td height='22' colspan='6' align='center'>해당 데이타가 없습니다.");
							out.println("</td>");
							out.println("</tr>");
							out.println("<tr class='tbl-line'>");
							out.println("<td height='1'></td>");
							out.println("<td height='1'></td>");
							out.println("<td height='1' align='left' class='td_lmagin'></td>");
							out.println("<td height='1' align='left' class='td_lmagin'></td>");
							out.println("<td height='1' align='left' class='td_lmagin'></td>");
							out.println("<td height='1'></td>");
							out.println("</tr>");

						}
					%>
					<tr class="tbl-line">
                      <td height="1"></td>
                      <td height="1"></td>
                      <td height="1" align="left" class="td_lmagin"></td>
                      <td height="1" align="left" class="td_lmagin"></td>
                      <td height="1" align="left" class="td_lmagin"></td>
                      <td height="1"></td>
                    </tr>
                  </table>
                  !-- 공지사항 리스트 테이블 끝 -------------------------
                  </td>
              </tr>
-->
