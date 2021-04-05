<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.net.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="kr.co.kcc.pf.util.PageCount" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="nads.lib.util.BoardComm" %>
<%@ page import="nads.lib.message.MessageBean" %>
<%@ page import="nads.dsdm.app.common.page.PagingDelegate" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<jsp:include page="/inc/header.jsp" flush="true"/>
<%@ include file="/common/CheckSession.jsp" %>
<%@ include file="/board/common/GetBoardProperty.jsp" %>
<%
	/*** PagingDelegate */
	PagingDelegate objPaging=new PagingDelegate(); 		/*페이징 변환 Delegate*/
%>
<%

	/*세션값 */
	String strLoginID = (String)session.getAttribute("USER_ID");						//로그인 ID

	/*GET 파라미터*/
	String strBbrdID = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("bbrdid")));						//게시판 아이디
	String strCurrentPage = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVL(request.getParameter("strCurrentPage"), "1"));	//현재 페이지
	String strCountPerPage;																										//한페이지 ROW갯수
	String strSrchType = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("srchType")));				//검색타입(검색)
	String strSrchText = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("srchText")));					//검색어(검색)

	/*초기값 설정 */
	nads.dsdm.app.board.SLBoardDelegate objBoard = new nads.dsdm.app.board.SLBoardDelegate();
	ArrayList objAryBbrdData = null;							//게시물
	Hashtable objHshBbrdInfo = null;						//게시판
	Hashtable objHshBbrdAuthInfo = null;					//게시판 사용자 권한
	String strBbrdUserAuth = "Y";								//게시판 사용자 권한
	String strGoToPage = URLEncoder.encode("/board/BoardContent.jsp", "UTF-8");

	if(strBbrdID == null || strBbrdID.equals("")) {
		try {

			//게시판 아이디가 없다면 가장 최근의 게시판종류에 따른 아이디를 가져온다.
			ArrayList objAryBbrdMenu = objBoard.selectBbrdMenu("BOARD", strLoginID, "");
			if (objAryBbrdMenu.size() != 0) {
				strBbrdID = (String)((Hashtable)objAryBbrdMenu.get(0)).get("PARAM");
				strBbrdID = strBbrdID.replaceAll(" ", "");
				int intIndex = strBbrdID.indexOf("bbrdid=");
				strBbrdID = strBbrdID.substring(intIndex+7, intIndex+17);
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
	}

	if(strBbrdID == null || strBbrdID.equals("") || strBbrdID.equals(" ")) {

		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		objMsgBean.setStrCode("DSPARAM-0000");
		objMsgBean.setStrMsg("게시판 정보를 알수 없습니다.");

		// 에러 발생 메세지 페이지로 이동한다.

%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%

		return;
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
		objHshBbrdInfo = objBoard.selectBbrdInfo(strBbrdID);
		if(objHshBbrdInfo.size() == 0) {

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
		if(strSrchText.equals("") || strSrchText == null) {

			//검색 조건이 없을 경우
			objAryBbrdData = objBoard.selectBbrdDataListPerPage(strBbrdID, "0", strCurrentPage, strCountPerPage);

		}else {

			//검색 조건이 있을 경우.
			objAryBbrdData = objBoard.selectBbrdSearchListPerPage(strBbrdID, "0", strCurrentPage, strCountPerPage, strSrchType, strSrchText);

		}

		//3. 게시판 사용자 권한을 가져온다.
		if(objHshBbrdInfo.get("AUTH_NEED_FLAG").equals("Y")) {

			objHshBbrdAuthInfo = objBoard.selectBbrdAuth(strBbrdID, strLoginID);

			if(objHshBbrdAuthInfo.size() == 0) {

				strBbrdUserAuth = "N";

			}

		}

	}catch (AppException objAppEx) {

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
	String strBbrdExt = (String)objHshBbrdInfo.get("ANS_EXT");
	String strBbrdApdFileCnt = (String)objHshBbrdInfo.get("APD_FILE_CNT");
	String strBbrdOneAnsExt = (String)objHshBbrdInfo.get("ONE_ANS_EXT");
	String strBbrdColor = (String)objHshBbrdInfo.get("BBRD_COLOR");
	strBbrdColor = strBbrdColor.equals("")?"D3BA8F":strBbrdColor;
	String strBbrdImgPath = (String)objHshBbrdInfo.get("IMG_PATH");
	String strBbrdDsc = (String)objHshBbrdInfo.get("DSC");
	String strBbrdAuthNeedFlag = (String)objHshBbrdInfo.get("AUTH_NEED_FLAG");

	int intBbrdLength = strBbrdNm.length() * 4 + 1;
	int intBbrdLength2 = 0;
	if (intBbrdLength < 40) {
		intBbrdLength2 = 40 - intBbrdLength;
	}

	//전체 페이지수 구하기.
	String strTotalCount = (String)((Hashtable)objAryBbrdData.get(0)).get("TOTAL_COUNT");
	int intTotalCount = Integer.valueOf(strTotalCount).intValue();
	int intCountPerPage= Integer.valueOf(strCountPerPage).intValue();
	int  intTotalPage = intTotalCount / intCountPerPage + 1;
%>

<%@ include file="/board/common/BoardNavigator.jsp" %>

		<link href="/css2/style.css" rel="stylesheet" type="text/css">
		<script language="javascript">
			function goPage(varPageNo) {

				document.frmSearch.strCurrentPage.value = varPageNo;
				document.frmSearch.submit();

			}

			function doSearch() {

				var frm = document.frmSearch;
				if (frm.txtSearch.value == "" || frm.txtSearch.value == null) {

					alert("검색어를 입력해 주세요.");
					frm.txtSearch.focus();
					return false;

				}

				frm.srchType.value = frm.selSearch.options[frm.selSearch.selectedIndex].value;
				frm.srchText.value = frm.txtSearch.value;
                frm.submit();
			}
		</script>
	</head>
	<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
		<div id="wrap">
			<jsp:include page="/inc/top.jsp" flush="true"/>
			<jsp:include page="/inc/top_menu04.jsp" flush="true"/>
			<div id="container">
				<div id="leftCon">
					<jsp:include page="/inc/log_info.jsp" flush="true"/>
					<jsp:include page="/inc/left_menu04.jsp" flush="true"/>
				</div>
				<div id="rightCon">
					<!-- pgTit -->
					<div id="pgTit" style="background:url(/images2/foundation/stl_bg_board.jpg) no-repeat left top;">
						<h3><%=strBbrdNm%> <!-- <span class="sub_stl" >- 상세보기</span> --></h3>
						<div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> &gt;게시판&gt;<%=strBbrdKindNm%></div>
						<p><!--문구--></p>
					</div>
					<!-- /pgTit -->
					<!-- contents -->
					<div id="contents">
					<!-- 각페이지 내용 -->
						<div class="myP">
							<!-- 검색창 -->
							<!-- /검색창  -->
							<!-- list -->
							<span class="list_total">&bull;&nbsp;전체자료수 : <%=strTotalCount%>개 (<%=strCurrentPage%>/<%=intTotalPage%> page)</span>
							<table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
								<thead>
									<tr>
										<th scope="col"><a href="#">NO</a></th>
										<th scope="col" style="width:450px; "><a href="#">제목</a></th>
										<th scope="col"><a href="#">파일</a></th>
										<th scope="col"><a href="#">등록자</a></th>
										<th scope="col"><a href="#">등록일자</a></th>
										<th scope="col"><a href="#">조회</a></th>
									</tr>
								</thead>
								<tbody>
									<%
										if(intTotalCount != 0) {
											for (int i = 1; i < objAryBbrdData.size(); i++) {
												Hashtable objHshBbrdData = (Hashtable)objAryBbrdData.get(i);
												String strDataID = (String)objHshBbrdData.get("DATA_ID");
												int intViewDataID = Integer.valueOf(strTotalCount).intValue() - Integer.valueOf((String)objHshBbrdData.get("RNUM")).intValue() + 1;
												String strTitle = nads.lib.reqsubmit.util.StringUtil.getNoTagStr((String)objHshBbrdData.get("TITLE"));

                                                String strUserNm = (String)objHshBbrdData.get("USER_NM");
												String strWriteTs = (String)objHshBbrdData.get("WRITE_TS");
												String strUpdTs = (String)objHshBbrdData.get("UPD_TS");

												if(!strUpdTs.equals("")) {
													strWriteTs = strUpdTs;
												}

												strWriteTs = strWriteTs.substring(0, 4) + "-" + strWriteTs.substring(4, 6) + "-" + strWriteTs.substring(6, 8);
												String strFileExt = (String)objHshBbrdData.get("APD_FILE_EXT");
												String strFileExtImg = "&nbsp;";

												if(strFileExt.equals("Y")) {
													strFileExtImg = "<img src='/image/common/icon_file.gif' width='13' height='15'>";
												}

												String strQryCnt = (String)objHshBbrdData.get("QRY_CNT");
												int intDataLevel = Integer.valueOf((String)objHshBbrdData.get("DATA_LEVEL")).intValue();
												String strDelFlag = (String)objHshBbrdData.get("DEL_FLAG");

												if(strDelFlag.equals("A") || strDelFlag.equals("Y")) {
													strTitle = "해당글이 삭제 되었습니다";
												}
									%>
									<tr>
										<td><%=intViewDataID%></td>
										<td style="text-align:left;">
											<%
												if(intDataLevel > 0 ) {

													String strWid = "";

													for(int j=0; j < intDataLevel ; j++){
														strWid = strWid + "&nbsp;&nbsp;&nbsp;";
													}

													out.print(strWid + "<img src='/image/board/icon_reply.gif' border='0'>");
												}

											%>
											<a href="/board/common/BoardList2Content.jsp?strGoToPage=<%=strGoToPage%>&strCurrentPage=<%=strCurrentPage%>&bbrdid=<%=strBbrdID%>&dataid=<%=strDataID%>">
												<%=strTitle%>
											</a>
										</td>
										<td><%=strFileExtImg%></td>
										<td><%=strUserNm%></td>
										<td><%=strWriteTs%></td>
										<td><p><%=strQryCnt%></p></td>
									</tr>
									<%

											}

										} else {
											out.println("<tr>");
											out.println("<td height='22' colspan='6' align='center'>해당 데이타가 없습니다.");
											out.println("</td>");
											out.println("</tr>");
										}

									%>
								</tbody>
							</table>

							<!-- 페이징-->
							<table  align="center">
								  <tr>
									<td height="35" align="center">
										<!-----------------------------------------  페이징 네비게이션 ---------------------------------------->
										<%//=PageCount.getLinkedString(strTotalCount , strCurrentPage, strCountPerPage) %>
										<!-----------------------------------------  페이징 네비게이션 ---------------------------------------->
										<%=objPaging.pagingTrans(PageCount.getLinkedString(strTotalCount , strCurrentPage, strCountPerPage))%>
									</td>
								  </tr>
							</table>
							<!-- /페이징-->

							<!-- /list -->
							<!-- 리스트 버튼-->
							<div id="btn_all" >
								<!-- 리스트 내 검색 -->
								<div class="list_ser" >
								<form name="frmSearch" method="post" action="<%=request.getRequestURI()%>">
									<input type="hidden" name="strCurrentPage" value="<%=strCurrentPage%>">
									<input type="hidden" name="bbrdid" value="<%=strBbrdID%>">
                                    <input type="hidden" name="srchType" value="<%=strSrchType%>">
                                    <input type="hidden" name="srchText" value="<%=strSrchText%>">
									<%

										String strSelValue = "";

										if(strBbrdKind.equals(noticeBoard)) {
											strSelValue = "NOTICE_ALL";
										}else {
											strSelValue = "FREE_ALL";
										}

									%>
									<select name="selSearch" class="selectBox5" style="width:70px;" >
										<option value="<%=strSelValue%>" <% if(strSrchType.equals("FREE_ALL") || strSrchType.equals("NOTICE_ALL")) out.println("selected"); %>>전체</option>
										<option value="TITLE" <% if (strSrchType.equals("TITLE")) out.println("selected"); %>>제목</option>
										<option value="CONT" <% if (strSrchType.equals("CONT")) out.println("selected"); %>>내용</option>
										<% if (!strBbrdKind.equals(noticeBoard)) { %>
										<option value="USER_NM" <% if (strSrchType.equals("USER_NM")) out.println("selected"); %>>작성자</option>
										<% } %>
									</select>
									<input name="txtSearch" onKeyDown="if(event.keyCode==13) doSearch();return ch();" onMouseDown="return ch()" class="li_input" style="width:100px" value="<%=strSrchText%>" />
									<img src="/images2/btn/bt_list_search.gif" style="cursor:hand;" onclick="doSearch()" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"/> </div>
									<!-- /리스트 내 검색 -->
									<span class="right">
										<span class="list_bt">
											<!-- 의정자료기능개선사업_2011 -->
											<%// if (strBbrdUserAuth.equals("Y") ) {%>
											<a href="WriteBoard.jsp?bbrdid=<%=strBbrdID%>">쓰기</a>
											<%// } %>
											<a href="BoardList.jsp?strCurrentPage=<%=strCurrentPage%>&bbrdid=<%=strBbrdID%>">
												목록
											</a>
										</span>
									</span>
								</div>
								</form>
								<!-- /리스트 버튼-->
								<!-- /각페이지 내용 -->
							</div>
							<!-- /contents -->
						</div>
					</div>
				</div>
			</div>
		</div>
		<jsp:include page="/inc/footer.jsp" flush="true"/>
	</body>
</html>

