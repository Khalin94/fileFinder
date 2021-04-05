<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.net.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="kr.co.kcc.pf.util.PageCount" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="nads.lib.util.BoardComm" %>
<%@ page import="nads.lib.message.MessageBean" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%@ include file="/common/CheckSession.jsp" %>
<%@ include file="/board/common/GetBoardProperty.jsp" %>
<%
	/*GET 파라미터*/
	String strBbrdMenuKind = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("mbbrdkind")));	 //게시판 종류(메뉴에서 받을값)
	String strBbrdID = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("bbrdid")));			 //게시판 아이디
	String strCurrentPage = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVL(request.getParameter("strCurrentPage"), "1"));	//현재 페이지
	String strCountPerPage;																										//한페이지 ROW갯수 
	String strSrchType = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("srchType")));		 //검색타입(검색)
	String strSrchText = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("srchText")));		 //검색어(검색)
	
	/*초기값 설정 */
	nads.dsdm.app.board.SLBoardDelegate objForumBoard = new nads.dsdm.app.board.SLBoardDelegate();
	ArrayList objAryBbrdData = null;							//게시물 
	Hashtable objHshBbrdInfo = null;						//게시판 
	String strGoToPage = URLEncoder.encode("/forum/board/ForumBoardContent.jsp", "UTF-8");
	
	if(strBbrdID == null || strBbrdID.equals("") || strBbrdID.equals(" ")){
		
		try {
			
			//게시판 아이디가 없다면 가장 최근의 게시판종류에 따른 아이디를 가져온다.
			Hashtable objHshMaxBbrdID = objForumBoard.selectMaxBbrdID(strBbrdMenuKind);
			strBbrdID = (String)objHshMaxBbrdID.get("BBRD_ID");
			
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
			
	}

	try {
		//CountPerPage를 가져온다.
		Config objConfig = PropertyConfig.getInstance();
		strCountPerPage = objConfig.get("page.rowcount");
		
	} catch (ConfigException objConfigEx) {
		strCountPerPage = StringUtil.getNVL(request.getParameter("strCountPerPage"), "10");
	}
	
	try{
	
		//1. 게시판 정보를 가져온다.
		objHshBbrdInfo = objForumBoard.selectBbrdInfo(strBbrdID);
		
		if(objHshBbrdInfo.size() == 0){
		
			objMsgBean.setMsgType(MessageBean.TYPE_ERR);
			objMsgBean.setStrCode("DSPARAM-0000");
			objMsgBean.setStrMsg("게시판 정보를 알수 없습니다.");
			
			// 에러 발생 메세지 페이지로 이동한다.
%>
			<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
			return;
			
		}
		
		//2. 게시판 리스트 정보를 가져온다.
		if(strSrchText.equals("") || strSrchText == null){
			//검색 조건이 없을 경우
			objAryBbrdData = objForumBoard.selectBbrdDataListPerPage(strBbrdID, "0", strCurrentPage, strCountPerPage);	
		
		} else {
			//검색 조건이 있을 경우.
			objAryBbrdData = objForumBoard.selectBbrdSearchListPerPage(strBbrdID, "0", strCurrentPage, 
																strCountPerPage, strSrchType, strSrchText);
			
		}

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
	
	//게시판 정보 
	String strBbrdKind = (String)objHshBbrdInfo.get("BBRD_KIND");		//검색시 사용 
	String strBbrdNm = (String)objHshBbrdInfo.get("BBRD_NM");
	int intBbrdLength = strBbrdNm.length() * 2 - 1;
	int intBbrdLength2 = 0;
	if (intBbrdLength < 40){
		intBbrdLength2 = 40 - intBbrdLength;
	}
	
	//전체 페이지수 구하기.
	String strTotalCount = (String)((Hashtable)objAryBbrdData.get(0)).get("TOTAL_COUNT");
	int intTotalCount = Integer.valueOf(strTotalCount).intValue();
	int intCountPerPage= Integer.valueOf(strCountPerPage).intValue();
	int  intTotalPage = intTotalCount / intCountPerPage + 1;
%>
<%@ include file="/board/common/ForumBoardNavigator.jsp" %>

<html>
<head>
<title>의정자료 전자유통 시스템</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link href="/css/System.css" rel="stylesheet" type="text/css">
<script language="javascript" src="/js/forum.js"></script>
<script language="javascript">

	function goPage(varPageNo) {
		document.frmBbrdList.strCurrentPage.value = varPageNo;
		document.frmBbrdList.submit();
	}
	
	function doSearch(){
		
		var frm = document.frmSearch;
		
		if (frm.txtSearch.value == "" || frm.txtSearch.value == null){
			alert("검색어를 입력해 주세요.");
			frm.txtSearch.focus();
			return false;
		} 
		
		frm.srchType.value = frm.selSearch.options[frm.selSearch.selectedIndex].value;
		frm.srchText.value = frm.txtSearch.value;
		//frm.submit();
		
	}

</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<%@ include file="/common/TopMenu.jsp" %>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
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
                <td height="23" colspan="2" align="left" valign="top"></td>
              </tr>
              <tr> 
                <td colspan="2" align="left" valign="top"><table width="100%" height="23" border="0" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="<%=intBbrdLength%>%" background="/image/forum/bg_forum_tit.gif"><span class="title"><%=strBbrdNm%></span></td>
                      <td width="<%=intBbrdLength2%>%" align="left" background="/image/common/bg_titLine.gif">&nbsp;</td>
                      <td width="60%" align="right" background="/image/common/bg_titLine.gif" class="text_s"><img src="/image/common/icon_navi.gif" width="3" height="5" align="absmiddle"> 
                        Home&gt;포럼&gt;포럼게시판&gt;<strong><%=strBbrdKindNm%></strong></td>
                    </tr>
                  </table></td>
              </tr>
              <tr> 
                <td height="30" colspan="2" align="left" class="text_s"><%=objHshBbrdInfo.get("DSC")%></td>
              </tr>
              <tr> 
                <td height="5" colspan="2" align="left" class="soti_reqsubmit"></td>
              </tr>
              <tr> 
                <td width="556" height="25" align="left"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"><span class="text_s"> 
                  전체 자료 수 : <%=strTotalCount%>건</span></td>
                <td width="203" height="25" align="right"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"><span class="text_s"> 
                  <%=strCurrentPage%>/<%=intTotalPage%> Page&nbsp;&nbsp;</span></td>
              </tr>
              <tr> 
                <td height="20" colspan="2" align="left" valign="top">
				<!-- 자유게시판 리스트 시작 ------------------------------->
				<table width="760" border="0" cellspacing="0" cellpadding="0">
				<form name="frmBbrdList" method="post" action="ForumBoardList.jsp">
				<input type="hidden" name="strCurrentPage" value="<%=strCurrentPage%>">
				<input type="hidden" name="bbrdid" value="<%=strBbrdID%>">
                    <tr> 
                      <td height="2" colspan="6" class="td_forum"></td>
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
                      <td height="1" colspan="6" class="td_forum"></td>
                    </tr>
                    <%
						if(intTotalCount != 0){

							for (int i = 1; i < objAryBbrdData.size(); i++) {
								Hashtable objHshBbrdData = (Hashtable)objAryBbrdData.get(i);
								
								String strDataID = (String)objHshBbrdData.get("DATA_ID");
								//NO = 전체갯수 - rownum + 1 
								int intViewDataID = Integer.valueOf(strTotalCount).intValue() - Integer.valueOf((String)objHshBbrdData.get("RNUM")).intValue() + 1;
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
								if(strDelFlag.equals("A") || strDelFlag.equals("Y")){
									strTitle = "해당글이 삭제 되었습니다";
								}
					%>
                    <tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''"> 
                      <td height="22" align="center"><%=intViewDataID%></td>
                      <td height="22" class="td_lmagin">
                      <%
						if(intDataLevel > 0 ){
	
							String strWid = "";
							
							for(int j=0; j < intDataLevel ; j++){
								strWid = strWid + "&nbsp;&nbsp;&nbsp;";
							}
							out.print(strWid + "<img src='/image/board/icon_reply.gif' border='0'>");		
						
						}
                      %>
                      <a href="/board/common/BoardList2Content.jsp?strGoToPage=<%=strGoToPage%>&strCurrentPage=<%=strCurrentPage%>&bbrdid=<%=strBbrdID%>&dataid=<%=strDataID%>"><%=strTitle%></a></td>
                      <td height="22" align="center"><%=strFileExtImg%></td>
                      <td height="22" align="center"><%=strUserNm%></td>
                      <td height="22" align="center"><%=strWriteTs%></td>
                      <td align="center"><%=strQryCnt%></td>
                    </tr>
                    <tr class="tbl-line"> 
                      <td height="1"></td>
                      <td height="1"></td>
                      <td height="1"></td>
                      <td height="1" align="left" class="td_lmagin"></td>
                      <td height="1" align="left" class="td_lmagin"></td>
                      <td align="left" class="td_lmagin"></td>
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
                      <td height="1"></td>
                      <td height="1" align="left" class="td_lmagin"></td>
                      <td height="1" align="left" class="td_lmagin"></td>
                      <td align="left" class="td_lmagin"></td>
                    </tr>
			      </form>
                  </table>
				 <!-- 자유게시판 리스트 끝 ------------------------------->
				 </td>
              </tr>
              <tr align="center"> 
                <td height="35" colspan="2" valign="middle">
                <%=PageCount.getLinkedString(strTotalCount , strCurrentPage, strCountPerPage) %>
                 </td>
              </tr>
              <tr height="3"> 
                <td height="3" colspan="2" align="left" valign="top" background="/image/common/line_table.gif"></td>
              </tr>
              <tr> 
                <td height="40" colspan="2">
                  <!-- 등록, 검색 테이블 시작 ------------------------------->
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
					<form name="frmSearch" method="post"  action="ForumBoardList.jsp" onSubmit="return doSearch()"> 
					<input type="hidden" name="strCurrentPage" value="<%=strCurrentPage%>">
					<input type="hidden" name="bbrdid" value="<%=strBbrdID%>">
					<input type="hidden" name="srchType" value="">
					<input type="hidden" name="srchText" value="">
                    <tr> 
                      <td width="256" height="40">
                      	<% if (strBbrdKind.equals(allFreeBoard)) {%>
                      	<a href="WriteForumBoard.jsp?bbrdid=<%=strBbrdID%>"><img src="/image/button/bt_register.gif" width="44" height="20" border="0"></a>
                      	<% } %>
                      </td>
                      <td width="503" align="right" valign="middle"><div align="right"> 
                        <%
                        	String strSelValue = "";
							if(strBbrdKind.equals(allNoticeBoard)) {
								strSelValue = "NOTICE_ALL";
							} else if (strBbrdKind.equals(allFreeBoard)) {
								strSelValue = "FREE_ALL";
							}
						%>
                          <select name="selSearch" class="select">
                            <option value="<%=strSelValue%>" <% if(strSrchType.equals("FREE_ALL") || strSrchType.equals("NOTICE_ALL")) out.println("selected"); %>>전체</option>
							<option value="TITLE" <% if (strSrchType.equals("TITLE")) out.println("selected"); %>>제목</option>
							<option value="CONT" <% if (strSrchType.equals("CONT")) out.println("selected"); %>>내용</option>
							<% if (strBbrdKind.equals(allFreeBoard)) { %>
							<option value="USER_NM" <% if (strSrchType.equals("USER_NM")) out.println("selected"); %>>작성자</option>
							<% } %>
                          </select>
                          <input name="txtSearch" type="text" class="textfield" style="WIDTH: 180px" value="<%=strSrchText%>">
                          <input type="image" src="/image/common/bt_search_table.gif" width="51" height="18" align="absmiddle">
                        </div></td>
                    </tr>
                  </form>
                  </table>
                  <!-- 등록, 검색 테이블 끝 ------------------------------->
                </td>
              </tr>
              <tr> 
                <td height="15" colspan="2" align="left">&nbsp;</td>
              </tr>
            </table></td>
        </tr>
      </table></td>
  </tr>
</table>
<%@ include file="/common/Bottom.jsp" %>
</body>
</html>
