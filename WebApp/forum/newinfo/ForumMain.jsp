<%@ page import="nads.dsdm.app.forum.*" %>
<%@ page import="nads.dsdm.app.common.code.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.net.*" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="nads.lib.util.BoardComm" %>

<%@ page import="nads.lib.message.MessageBean" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%@ include file="/common/CheckSession.jsp" %>

<%
	String strNoticeBoardID="";
	ArrayList objAryBbrdData = null; //공지사항목록
	nads.dsdm.app.board.SLBoardDelegate objForumBoard = new nads.dsdm.app.board.SLBoardDelegate();

	ArrayList objAryForumSortData = null; //포럼분류
	CodeInfoDelegate objCodeInfo = new CodeInfoDelegate(); //코드관련 Delegate

	ArrayList objAryNewForumData = null; //신규등록포럼목록
	ArrayList objArySuperForumData = null; //우수포럼목록
	SLDBForumDelegate objDBForum = new SLDBForumDelegate();
	
	int iResult[] = new int[5];
	try {
		//iResult = objDBForum.updateSuperForum(); //우수포럼설정(테스트/나중에 지워야함)

		Hashtable objHashBoardData = objForumBoard.selectIndBoardID("998");
		strNoticeBoardID = StringUtil.getNVLNULL((String)objHashBoardData.get("BBRD_ID")); //공지사항ID
		objAryBbrdData = objForumBoard.selectBbrdThreeData("AllBoard","998","3");
		objAryForumSortData = objCodeInfo.lookUpCode("M02");
		objAryNewForumData = objDBForum.selectNewForum(3); //신규등록포럼
		objArySuperForumData = objDBForum.selectSuperForum(); //우수포럼
	
	} catch (AppException objAppEx) {

		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		objMsgBean.setStrCode(objAppEx.getStrErrCode());
		objMsgBean.setStrMsg(objAppEx.getMessage());

		// 에러 발생 메세지 페이지로 이동한다.
%>

		<jsp:forward page="/common/message/ViewMsg.jsp"/>

<%
		return;
		
	}
%>

<html>
<head>
<title>의정자료 전자유통 시스템</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link href="/css/System.css" rel="stylesheet" type="text/css">
<script src='/js/forum.js'></script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<%@ include file="/common/TopMenu.jsp" %>
<table width="100%" height="183" border="0" cellpadding="0" cellspacing="0">
  <tr align="left" valign="top">
    <td width="186" background="/image/common/bg_leftMenu.gif">
	<%@ include file="/common/LeftMenu.jsp" %></td>
    <td width="100%"><table width="100%" border="0" cellspacing="0" cellpadding="0">
         <tr height="24" valign="top"> 
          <td height="24" colspan="2" align="left"><table width="789" height="24" border="0" cellpadding="0" cellspacing="0" bgcolor="E9E2F3">
              <tr>
                <td height="24"></td>
              </tr>
            </table></td>
        </tr>
		<tr valign="top">
          <td width="30" align="left"><img src="/image/common/bg_leftBody.gif" width="30" height="1"></td>
          <td align="left"><table width="759" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td height="23" align="left" valign="top"></td>
              </tr>
              <tr> 
                <td colspan="2" align="left" valign="top"><table width="100%" height="23" border="0" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="13%" background="/image/forum/bg_forum_tit.gif"><span class="title">포럼 최신정보</span></td>
                      <td width="13%" align="left" background="/image/common/bg_titLine.gif">&nbsp;</td>
                      <td width="74%" align="right" background="/image/common/bg_titLine.gif" class="text_s"><img src="/image/common/icon_navi.gif" width="3" height="5" align="absmiddle"> 
                        Home&gt;포럼&gt;<strong>포럼최신정보</strong></td>
                    </tr>
                  </table></td>
              </tr>
              <tr> 
                <td height="50" colspan="2" align="left" class="text_s">포럼 참여를 통한 다양한 정보 공유를 하실 수 있습니다.
				<br>포럼의 공지사항, 신규등록된 포럼, 우수포럼 등을 확인할 수 있는 화면입니다.</td>
              </tr>
              <tr> 
                <td height="5" colspan="2" align="left" class="soti_reqsubmit"></td>
              </tr>
              <tr> 
                <td width="580" height="30" align="left"><span class="soti_reqsubmit"><img src="/image/forum/icon_forum_soti.gif" width="9" height="9" align="absmiddle"> 
                  </span><span class="soti_forum">포럼 공지사항</span></td>
                <td width="179" align="right" class="menu_forum"><strong><a href="/forum/board/ForumBoardList.jsp?bbrdid=<%=strNoticeBoardID%>">[전체 공지 사항]</a>&nbsp;&nbsp;</strong></td>
              </tr>
              <tr> 
                <td height="72" colspan="2" align="left" valign="top"><table width="759" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td height="2" colspan="4" class="td_forum"></td>
                    </tr>
                    <tr class="td_top"> 
                      <td width="52" height="22" align="center">NO</td>
                      <td width="528" height="22" align="center">제목</td>
                      <td width="109" height="22" align="center">등록일자</td>
                      <td width="70" height="22" align="center">조회</td>
                    </tr>
                    <tr> 
                      <td height="1" colspan="4" class="td_forum"></td>
                    </tr>
                    <%
					if(objAryBbrdData.size() > 0) {
						for (int i = 0; i < objAryBbrdData.size(); i++) {
							Hashtable objHshBbrdData = (Hashtable)objAryBbrdData.get(i);

							String strBbrdID = (String)objHshBbrdData.get("BBRD_ID");
							String strDataID = (String)objHshBbrdData.get("DATA_ID");
							String strTitle = BoardComm.replaceTag2Text((String)objHshBbrdData.get("TITLE"));
							String strUserNm = (String)objHshBbrdData.get("USER_NM");
							String strWriteTs = (String)objHshBbrdData.get("WRITE_TS");
							String strUpdTs = (String)objHshBbrdData.get("UPD_TS");
							if(!strUpdTs.equals("")){
								strWriteTs = strUpdTs;
							}
							strWriteTs = strWriteTs.substring(0, 4) + "-" + strWriteTs.substring(4, 6) + "-" 
												+ strWriteTs.substring(6, 8);
							String strFileExt = (String)objHshBbrdData.get("APD_FILE_EXT");
							String strFileExtImg = "&nbsp;";
							if(strFileExt.equals("Y")){
								strFileExtImg = "<img src='/image/common/icon_file.gif' width='13' height='15'>";
							}
							String strQryCnt = (String)objHshBbrdData.get("QRY_CNT");
							int intDataLevel = Integer.valueOf((String)objHshBbrdData.get("DATA_LEVEL")).intValue();
							String strDelFlag = (String)objHshBbrdData.get("DEL_FLAG");
							if(strDelFlag.equals("A")){
								strTitle = "해당글이 삭제 되었습니다";
							}

							String strH = "1";
							if (i==objAryBbrdData.size()-1) {
								strH = "2";
							}
					%>
						<tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''"> 
						  <td height="22" align="center"><%=i+1%></td>
						  <td height="22" class="td_lmagin">
						  <%
							if(intDataLevel > 0 ){
		
								String strWid = "";
								
								for(int j=0; j < intDataLevel ; j++){
									strWid = strWid + "&nbsp;&nbsp;&nbsp;";
								}
								out.print(strWid + "<img src='/image/board/icon_reply.gif' border='0'>");		
							
							}
							String strGoToPage = URLEncoder.encode("/forum/board/ForumBoardContent.jsp", "UTF-8");

						  %>
						  <a href="/board/common/BoardList2Content.jsp?strGoToPage=<%=strGoToPage%>&strCurrentPage=1&bbrdid=<%=strBbrdID%>&dataid=<%=strDataID%>"><%=strTitle%></a></td>
						  <td height="22" align="center"><%=strWriteTs%></td>
						  <td height="22" align="center"><%=strQryCnt%></td>
						</tr>
						<tr class="tbl-line"> 
						  <td height="<%=strH%>"></td>
						  <td height="<%=strH%>"></td>
						  <td height="<%=strH%>" align="left" class="td_lmagin"></td>
						  <td height="<%=strH%>" align="left" class="td_lmagin"></td>
						</tr>
					<%
						} //end for

					} else {
					%>
						<tr> 
						  <td height="22" colspan=4 align="center">해당 데이타가 없습니다.</td>
						</tr>
						<tr class="tbl-line"> 
							<td height="2" colspan=4 align="center"></td>
						</tr>
					<%
					} //end if
					%>
                  </table></td>
              </tr>
              <tr> 
                <td height="20" colspan="2" align="left" valign="top">&nbsp;</td>
              </tr>
              <tr> 
                <td height="30" align="left"><span class="soti_reqsubmit"><img src="/image/forum/icon_forum_soti.gif" width="9" height="9" align="absmiddle"> 
                  </span><span class="soti_forum">신규 등록 포럼</span></td>
                <td align="right" class="menu_forum"><strong><a href="/forum/search/ForumSearch.jsp?gbn=1">[전체 포럼 
                  목록]</a>&nbsp;&nbsp;</strong></td>
              </tr>
              <tr> 
                <td colspan="2" align="left" valign="top"><table width="759" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td height="2" colspan="5" class="td_forum"></td>
                    </tr>
                    <tr class="td_top"> 
                      <td width="48" height="22" align="center">NO</td>
                      <td width="461" height="22" align="center">포럼 이름</td>
                      <td width="91" height="22" align="center">운영자</td>
                      <td width="92" height="22" align="center">개설일</td>
                      <td width="67" align="center">공개</td>
                    </tr>
                    <tr> 
                      <td height="1" colspan="5" class="td_forum"></td>
                    </tr>
				  <%
					if(objAryNewForumData.size() > 0) {
						for(int i=0; i<objAryNewForumData.size(); i++) {
							Hashtable objHashSearchForum = (Hashtable)objAryNewForumData.get(i);

							String strForumID = (String)objHashSearchForum.get("FORUM_ID"); //포럼ID
							String strForumNM = (String)objHashSearchForum.get("FORUM_NM"); //포럼명
							String strForumSort = (String)objHashSearchForum.get("FORUM_SORT"); //포럼분류
							for(int j=0; j< objAryForumSortData.size(); j++) {
								if(strForumSort.equals(String.valueOf(((Hashtable)objAryForumSortData.get(j)).get("MSORT_CD")))) {
									strForumSort = String.valueOf(((Hashtable)objAryForumSortData.get(j)).get("CD_NM"));
									break;
								}
							}
							String strOprtrNM = (String)objHashSearchForum.get("USER_NM"); //운영자명
							String strEstabTS = (String)objHashSearchForum.get("ESTAB_TS"); //개설일
							if(strEstabTS.length() > 8) {
								strEstabTS = strEstabTS.substring(0, 4) + "-" + strEstabTS.substring(4, 6) + "-" + strEstabTS.substring(6, 8);
							} else {
								strEstabTS = "개설전";
							}

							String strOpenFlag = (String)objHashSearchForum.get("OPEN_FLAG"); //공개여부
							String strOpenFlagWord ="공개";
							if(strOpenFlag.equals("N")) {
								strOpenFlagWord = "비공개";
							}

							String strH = "1";
							if (i==objAryNewForumData.size()-1) {
								strH = "2";
							}
				  %>
					<tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''"> 
					  <td height="22" align="center"><%=i+1%></td>
					  <td height="22" class="td_lmagin"><a href="javascript:openForum('<%=strForumID%>','<%=strOpenFlag%>');">[<%=strForumSort%>]<%=strForumNM%></a></td>
					  <td height="22" align="center"><%=strOprtrNM%></td>
					  <td height="22" align="center"><%=strEstabTS%></td>
					  <td align="center"><%=strOpenFlagWord%></td>
					</tr>
					<tr class="tbl-line"> 
					  <td height="<%=strH%>"></td>
					  <td height="<%=strH%>"></td>
					  <td height="<%=strH%>" align="left" class="td_lmagin"></td>
					  <td height="<%=strH%>" align="left" class="td_lmagin"></td>
					  <td align="left" class="td_lmagin"></td>
					</tr>
				<%
					} //end for

				} else {
				%>
					<tr> 
					  <td height="22" colspan=5 align="center">해당 데이타가 없습니다.</td>
					</tr>
					<tr class="tbl-line"> 
						<td height="2" colspan=5 align="center"></td>
					</tr>
				<%
				} //end if
				%>
                  </table></td>
              </tr>
              <tr> 
                <td height="20" colspan="2" align="left" valign="top">&nbsp;</td>
              </tr>
              <tr> 
                <td height="30" align="left"><span class="soti_reqsubmit"><img src="/image/forum/icon_forum_soti.gif" width="9" height="9" align="absmiddle"> 
                  </span><span class="soti_forum">우수 포럼</span></td>
                <td align="right" class="menu_forum"><strong><a href="javascript:openWin('/forum/newinfo/ForumSuperBasic.jsp','380','210')">[우수 포럼 선정 기준]</a>&nbsp;&nbsp;</strong></td>
              </tr>
              <tr> 
                <td height="72" colspan="2" align="left" valign="top"><table width="759" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td height="2" colspan="5" class="td_forum"></td>
                    </tr>
                    <tr class="td_top"> 
                      <td width="48" height="22" align="center">NO</td>
                      <td width="461" height="22" align="center">포럼 이름</td>
                      <td width="91" height="22" align="center">운영자</td>
                      <td width="92" height="22" align="center">개설일</td>
                      <td width="67" align="center">공개</td>
                    </tr>
                    <tr> 
                      <td height="1" colspan="5" class="td_forum"></td>
                    </tr>
				  <%
					if(objArySuperForumData.size() > 0) {
						for(int i=0; i<objArySuperForumData.size(); i++) {
							Hashtable objHashSearchForum = (Hashtable)objArySuperForumData.get(i);

							String strForumID = (String)objHashSearchForum.get("FORUM_ID"); //포럼ID
							String strForumNM = (String)objHashSearchForum.get("FORUM_NM"); //포럼명
							String strForumSort = (String)objHashSearchForum.get("FORUM_SORT"); //포럼분류
							for(int j=0; j< objAryForumSortData.size(); j++) {
								if(strForumSort.equals(String.valueOf(((Hashtable)objAryForumSortData.get(j)).get("MSORT_CD")))) {
									strForumSort = String.valueOf(((Hashtable)objAryForumSortData.get(j)).get("CD_NM"));
									break;
								}
							}
							String strOprtrNM = (String)objHashSearchForum.get("USER_NM"); //운영자명
							String strEstabTS = (String)objHashSearchForum.get("ESTAB_TS"); //개설일
							if(strEstabTS.length() > 8) {
								strEstabTS = strEstabTS.substring(0, 4) + "-" + strEstabTS.substring(4, 6) + "-" + strEstabTS.substring(6, 8);
							} else {
								strEstabTS = "개설전";
							}

							String strOpenFlag = (String)objHashSearchForum.get("OPEN_FLAG"); //공개여부
							String strOpenFlagWord ="공개";
							if(strOpenFlag.equals("N")) {
								strOpenFlagWord = "비공개";
							}

							String strH = "1";
							if (i==objArySuperForumData.size()-1) {
								strH = "2";
							}
				  %>
                    <tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''"> 
                      <td height="22" align="center"><%=i+1%></td>
                      <td height="22" class="td_lmagin"><a href="javascript:openForum('<%=strForumID%>','<%=strOpenFlag%>');">[<%=strForumSort%>]<%=strForumNM%></a></td>
                      <td height="22" align="center"><%=strOprtrNM%></td>
                      <td height="22" align="center"><%=strEstabTS%></td>
                      <td align="center"><%=strOpenFlagWord%></td>
                    </tr>
                    <tr class="tbl-line"> 
                      <td height="<%=strH%>"></td>
                      <td height="<%=strH%>"></td>
                      <td height="<%=strH%>" align="left" class="td_lmagin"></td>
                      <td height="<%=strH%>" align="left" class="td_lmagin"></td>
                      <td align="left" class="td_lmagin"></td>
                    </tr>
				<%
					} //end for

				} else {
				%>
					<tr> 
					  <td height="22" colspan=5 align="center">해당 데이타가 없습니다.</td>
					</tr>
					<tr class="tbl-line"> 
						<td height="2" colspan=5 align="center"></td>
					</tr>
				<%
				} //end if
				%>
                  </table></td>
              </tr>
              <tr> 
                <td height="35" colspan="2" align="left" valign="top"></td>
              </tr>
            </table></td>
        </tr>
      </table></td>
  </tr>
</table>
<%@ include file="/common/Bottom.jsp" %>
</body>
</html>