<%@ page import = "java.util.*" %>
<%@ page import = "java.net.*" %>
<%@ page import="kr.co.kcc.bf.config.*" %>
<%@ page import="nads.lib.util.BoardComm" %>
<%@ page import="nads.lib.message.MessageBean" %>
<%@ include file="/board/common/GetBoardProperty.jsp" %>
<h2><img src="images2/main/tl_notice.gif" width="225" height="17" /></h2>
<ul>
<!-- 공지사항 게시판 Start -->
	<li class="mNotice">
	<ul>
<%
	ArrayList objNoticeArry = new ArrayList();//공지사항
	Hashtable objNoticeHt = new Hashtable();

	try{
		Config objConfigNotice = PropertyConfig.getInstance();
		String strNoticeAppCode = objConfigNotice.get("activity.useritet.board.noticeBoard");
		nads.dsdm.app.board.SLBoardDelegate objBoard = new nads.dsdm.app.board.SLBoardDelegate();

		//게시판 ID를 가져온다.
		ArrayList objAryBbrdMenu = objBoard.selectBbrdMenu("MYBOARD", strUserId, strNoticeAppCode);

		String strBbrdID = "";
		if (objAryBbrdMenu.size() != 0){
			strBbrdID = (String)((Hashtable)objAryBbrdMenu.get(0)).get("PARAM");
			strBbrdID = strBbrdID.replaceAll(" ", "");
			int intIndex = strBbrdID.indexOf("bbrdid=");
			strBbrdID = strBbrdID.substring(intIndex+7, intIndex+17);
		}

		//게시판 정보를 가져온다.
		objNoticeArry = objBoard.selectBbrdThreeData("BoardData", strBbrdID, "5");

	} catch (AppException objAppEx) {

		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  		objMsgBean.setStrCode(objAppEx.getStrErrCode());
  		objMsgBean.setStrMsg(objAppEx.getMessage());
  		out.println("<br>Error!!!" + objAppEx.getMessage());
%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}

	if(objNoticeArry.size() > 0) {
//		for (int i = 0; i < objNoticeArry.size(); i++) {
		for (int i = 0; i < 4; i++) {
			objNoticeHt = (Hashtable)objNoticeArry.get(i);
			String strDataIdData = (String)objNoticeHt.get("DATA_ID");
			String strTitleData = BoardComm.replaceTag2Text((String)objNoticeHt.get("TITLE"));
			String strBbrdIdData = (String)objNoticeHt.get("BBRD_ID");
			String strUpdTsData = (String)objNoticeHt.get("UPD_TS");
			String strWriteTsData = (String)objNoticeHt.get("WRITE_TS");
			String strBbrdNmData = (String)objNoticeHt.get("BBRD_NM");
			if(!strUpdTsData.equals("")){
				strWriteTsData = strUpdTsData;
			}
			strWriteTsData = strWriteTsData.substring(0, 4) + "-" + strWriteTsData.substring(4, 6) + "-"
									+ strWriteTsData.substring(6, 8);
			String strDelFlagData = (String)objNoticeHt.get("DEL_FLAG");
			if(strDelFlagData.equals("A") || strDelFlagData.equals("Y")){
				strTitleData = "해당글이 삭제 되었습니다";
			}

			String strGoToPage = URLEncoder.encode("/board/BoardContent.jsp", "UTF-8");
%>
	<li><a href="/board/common/BoardList2Content.jsp?strGoToPage=<%=strGoToPage %>&strCurrentPage=1&bbrdid=<%=strBbrdIdData %>&dataid=<%=strDataIdData %>" onfocus="this.blur();"><%=nads.lib.util.ActComm.chrString(strTitleData, 14) %></a></li>
<%
		}
	}
%>
		</ul>
	</li>
<!-- 공지사항 게시판 End -->


	<li style=" text-align:center; "> <img src="images2/main/line01.gif" width="205" height="1" /></li>


<!-- 자료 게시판 Start -->
	<li class="mData">
	<ul>
<%
	ArrayList objDataArry = new ArrayList();//자료실
	Hashtable objDataHt = new Hashtable();

	try{
		Config objConfigData = PropertyConfig.getInstance();
		String strDataAppCode = objConfigData.get("activity.useritet.board.dataBoard");
		nads.dsdm.app.board.SLBoardDelegate objBoard = new nads.dsdm.app.board.SLBoardDelegate();

		//게시판 ID를 가져온다.
		ArrayList objAryBbrdMenu = objBoard.selectBbrdMenu("MYBOARD", strUserId, strDataAppCode);

		String strBbrdID = "";
		if (objAryBbrdMenu.size() != 0){
			strBbrdID = (String)((Hashtable)objAryBbrdMenu.get(0)).get("PARAM");
			strBbrdID = strBbrdID.replaceAll(" ", "");
			int intIndex = strBbrdID.indexOf("bbrdid=");
			strBbrdID = strBbrdID.substring(intIndex+7, intIndex+17);
		}

		//게시판 정보를 가져온다.
		objDataArry = objBoard.selectBbrdThreeData("BoardData", strBbrdID, "5");

	} catch (AppException objAppEx) {

		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  		objMsgBean.setStrCode(objAppEx.getStrErrCode());
  		objMsgBean.setStrMsg(objAppEx.getMessage());
  		out.println("<br>Error!!!" + objAppEx.getMessage());
%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}

	if(objDataArry.size() > 0) {
//		for (int i = 0; i < objDataArry.size(); i++) {
		for (int i = 0; i < 4; i++) {
			objDataHt = (Hashtable)objDataArry.get(i);
			String strDataIdData = (String)objDataHt.get("DATA_ID");
			String strTitleData = BoardComm.replaceTag2Text((String)objDataHt.get("TITLE"));
			String strBbrdIdData = (String)objDataHt.get("BBRD_ID");
			String strUpdTsData = (String)objDataHt.get("UPD_TS");
			String strWriteTsData = (String)objDataHt.get("WRITE_TS");
			String strBbrdNmData = (String)objDataHt.get("BBRD_NM");
			if(!strUpdTsData.equals("")){
				strWriteTsData = strUpdTsData;
			}
			strWriteTsData = strWriteTsData.substring(0, 4) + "-" + strWriteTsData.substring(4, 6) + "-"
									+ strWriteTsData.substring(6, 8);
			String strDelFlagData = (String)objDataHt.get("DEL_FLAG");
			if(strDelFlagData.equals("A") || strDelFlagData.equals("Y")){
				strTitleData = "해당글이 삭제 되었습니다";
			}

			String strGoToPage = URLEncoder.encode("/board/BoardContent.jsp", "UTF-8");
%>
	<li><a href="/board/common/BoardList2Content.jsp?strGoToPage=<%=strGoToPage %>&strCurrentPage=1&bbrdid=<%=strBbrdIdData %>&dataid=<%=strDataIdData %>" onfocus="this.blur();"><%=nads.lib.util.ActComm.chrString(strTitleData, 14) %></a></li>
<%
		}
	}
%>
		</ul>
	</li>
<!-- 자료 게시판 End -->


	<li style=" text-align:center; "> <img src="images2/main/line01.gif" width="205" height="1" /></li>


<!-- 묻고답하기 Start -->
	<li class="mWork">
	<ul>
<%
	String strBbrdID = "";

	/*초기값 설정 */
	nads.dsdm.app.board.SLBoardDelegate objQnaBoard = new nads.dsdm.app.board.SLBoardDelegate();
	ArrayList objAryBbrdData = null;						//게시물
	Hashtable objHshBbrdInfo = null;						//게시판
	String strGoToPage = URLEncoder.encode("/help/BoardContent.jsp", "UTF-8");

	if(strBbrdID == null || strBbrdID.equals("")){

		try {

			//게시판 아이디가 없다면 가장 최근의 공지사항 아이디를 가져온다.
			Hashtable objHshMaxBbrdID = objQnaBoard.selectMaxBbrdID(qnaBoard);
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

	if(strBbrdID == null || strBbrdID.equals("") || strBbrdID.equals(" ")){

		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		objMsgBean.setStrCode("DSPARAM-0000");
		objMsgBean.setStrMsg("게시판 정보를 알수 없습니다.");

		// 에러 발생 메세지 페이지로 이동한다.

%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;

	}

	try{
		//1. 게시판 정보를 가져온다.
		objHshBbrdInfo = objQnaBoard.selectBbrdInfo(strBbrdID);

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

		objAryBbrdData = objQnaBoard.selectBbrdDataListPerPage(strBbrdID, "0", "1", "4");


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

	//전체 페이지수 구하기.
	String strTotalCount = (String)((Hashtable)objAryBbrdData.get(0)).get("TOTAL_COUNT");
	int intTotalCount = Integer.valueOf(strTotalCount).intValue();
	int intCountPerPage= Integer.valueOf("4").intValue();
	int  intTotalPage = intTotalCount / intCountPerPage + 1;

%>
<%

	if(intTotalCount != 0){

	//	for (int i = 1; i < objAryBbrdData.size(); i++) {
		for (int i = 1; i < 5; i++) {
			Hashtable objHshBbrdData = (Hashtable)objAryBbrdData.get(i);
			String strDataID = (String)objHshBbrdData.get("DATA_ID");
			String strTitle = BoardComm.replaceTag2Text((String)objHshBbrdData.get("TITLE"));
%>
		<li><a href="/board/common/BoardList2Content.jsp?strGoToPage=<%=strGoToPage%>&strCurrentPage=1&bbrdid=<%=strBbrdID%>&dataid=<%=strDataID%>"><%=nads.lib.util.ActComm.chrString(strTitle,  14)%></a></li>
<%

		}

	} else {
		out.println("<tr>");
		out.println("<td  height='18' class='news'><img src='image/main/icon_yellowdot.gif' width='3' height='4' align='absmiddle'> ");
		out.println("해당 데이타가 없습니다.");
		out.println("</td>");
		out.println("</tr>");
	}

%>
		</ul>
	</li>
<!-- 묻고답하기 End -->
</ul>