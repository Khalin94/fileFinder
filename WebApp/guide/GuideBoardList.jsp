<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.net.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="kr.co.kcc.pf.util.PageCount" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="nads.lib.util.BoardComm" %>
<%@ page import="nads.lib.message.MessageBean" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%@ include file="/board/common/GetBoardProperty.jsp" %>
<%
	/*GET 파라미터*/
	String strBbrdMenuKind = nads.lib.reqsubmit.util.StringUtil.getEmptyIfNull(request.getParameter("mbbrdkind"));		//게시판 종류(메뉴에서 받을값)
	String strBbrdID = nads.lib.reqsubmit.util.StringUtil.getEmptyIfNull(request.getParameter("bbrdid"));						//게시판 아이디
	String strCurrentPage = StringUtil.getNVL(request.getParameter("strCurrentPage"), "1");	//현재 페이지
	String strCountPerPage;																										//한페이지 ROW갯수 
	String strSrchType = nads.lib.reqsubmit.util.StringUtil.getEmptyIfNull(request.getParameter("srchType"));				//검색타입(검색)
	String strSrchText = nads.lib.reqsubmit.util.StringUtil.getEmptyIfNull(request.getParameter("srchText"));					//검색어(검색)
	
	/*초기값 설정 */
	nads.dsdm.app.board.SLBoardDelegate objBoard = new nads.dsdm.app.board.SLBoardDelegate();
	ArrayList objAryBbrdData = null;								//게시물 
	ArrayList objAryAdminBbrdData = null;					//관리자 게시물 
	String strGoToPage = URLEncoder.encode("/guide/GuideBoardContent.jsp", "UTF-8");
	
	if(strBbrdID == null || strBbrdID.equals("") || strBbrdID.equals(" ")){
		
		try {
			
			//게시판 아이디가 없다면 가장 최근의 게시판종류에 따른 아이디를 가져온다.
			Hashtable objHshMaxBbrdID = objBoard.selectMaxBbrdID(strBbrdMenuKind);
			strBbrdID = (String)objHshMaxBbrdID.get("BBRD_ID");
                        if (!strBbrdMenuKind.equals("006")) {
				%>
				<jsp:forward page="/common/message/ViewMsg.jsp"/>
				<%
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

	try {
		//CountPerPage를 가져온다.
		Config objConfig = PropertyConfig.getInstance();
		strCountPerPage = objConfig.get("page.rowcount");
		
	} catch (ConfigException objConfigEx) {
		strCountPerPage = StringUtil.getNVL(request.getParameter("strCountPerPage"), "10");
	}
	
	try{
		
		//2. 게시판 리스트 정보를 가져온다.
		if(strSrchText.equals("") || strSrchText == null){
			//검색 조건이 없을 경우
			objAryBbrdData = objBoard.selectBbrdDataListPerPage(strBbrdID, "0", strCurrentPage, strCountPerPage);	
			
			//관리자가 등록한 문의게시물을 가져온다.
			objAryAdminBbrdData = objBoard.selectAdminBbrdList(strBbrdID, "0", noticeDataCnt);
			
		} else {
			//검색 조건이 있을 경우.
			objAryBbrdData = objBoard.selectBbrdSearchListPerPage(strBbrdID, "0", strCurrentPage, 
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
	
	//전체 페이지수 구하기.
	String strTotalCount = (String)((Hashtable)objAryBbrdData.get(0)).get("TOTAL_COUNT");
	int intTotalCount = Integer.valueOf(strTotalCount).intValue();
	int intCountPerPage= Integer.valueOf(strCountPerPage).intValue();
	int  intTotalPage = intTotalCount / intCountPerPage + 1;
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link href="../css/System.css" rel="stylesheet" type="text/css">
<script language="javascript">

	function goPage(varPageNo) {
		document.frmBbrdList.strCurrentPage.value = varPageNo;
		document.frmBbrdList.submit();
	}
	
	function doSearch(){
		
		var frm = document.frmSearch;
                var initCurrent = 1;
		
		if (frm.txtSearch.value == "" || frm.txtSearch.value == null){
			alert("검색어를 입력해 주세요.");
			frm.txtSearch.focus();
			return false;
		} 
		
		frm.srchType.value = frm.selSearch.options[frm.selSearch.selectedIndex].value;
		frm.srchText.value = frm.txtSearch.value;
                frm.strCurrentPage.value = initCurrent;
		
	}

</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="502" border="0" cellpadding="0" cellspacing="0">
  <tr height="15" align="left" valign="top"> 
    <td height="22"><img src="../image/guide/blank.gif" width="24" height="2"></td>
    <td width="478" height="22" valign="middle"><table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td width="50%" class="text_s">&nbsp;&nbsp;<img src="../image/common/icon_nemo_gray.gif" width="3" height="6"> 
            전체 자료 수 : <%=strTotalCount%>개</td>
          <td width="50%" align="right" class="text_s"><img src="../image/common/icon_nemo_gray.gif" width="3" height="6"> <%=strCurrentPage%>/<%=intTotalPage%> page&nbsp;&nbsp;</td>
        </tr>
      </table></td>
  </tr>
  <tr height="15" align="left" valign="top"> 
    <td></td>
    <td><table width="100%" border="0" cellpadding="0" cellspacing="0">
        <tr> 
          <td valign="top">
		    <!-- 이용안내 문의게시판 리스트 시작 -->
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<form name="frmBbrdList" method="post" action="GuideBoardList.jsp">
			<input type="hidden" name="strCurrentPage" value="<%=strCurrentPage%>">
			<input type="hidden" name="bbrdid" value="<%=strBbrdID%>">
                        <input type="hidden" name="srchType" value="<%=strSrchType%>">
			<input type="hidden" name="srchText" value="<%=strSrchText%>">
              <tr> 
                <td height="2" colspan="6" class="td_board"></td>
              </tr>
              <tr align="center" class="td_top"> 
                <td width="50" height="22">NO</td>
                <td width="235" height="22">제목</td>
				<td width="40" height="22">파일</td>
                <td width="65" height="22">작성자</td>
                <td width="69" height="22">등록일자</td>
                <td width="43" height="22">조회</td>
              </tr>
              <tr> 
                <td height="1" colspan="6" class="td_board"></td>
              </tr>
              <%
              //관리자 게시물을 보여준다. - 문의게시판 공지사항
              if (objAryAdminBbrdData != null){
              		for (int i = 0; i < objAryAdminBbrdData.size(); i++) {
              			Hashtable objHshAdminBbrdData = (Hashtable)objAryAdminBbrdData.get(i);
              			
              			String strADataID = (String)objHshAdminBbrdData.get("DATA_ID");
              			String strATitle = (String)objHshAdminBbrdData.get("TITLE");
              			String strAWriterNm = (String)objHshAdminBbrdData.get("WRITER_NM");
              			String strAWriteTs = (String)objHshAdminBbrdData.get("WRITE_TS");
              			String strAUpdTs = (String)objHshAdminBbrdData.get("UPD_TS");
              			if(!strAUpdTs.equals("")){
							strAWriteTs = strAUpdTs;
						}
						strAWriteTs = strAWriteTs.substring(0, 4) + "-" + strAWriteTs.substring(4, 6) + "-" 
										+ strAWriteTs.substring(6, 8);
										
						String strAFileExt = (String)objHshAdminBbrdData.get("APD_FILE_EXT");
						String strAFileExtImg = "&nbsp;";
						if(strAFileExt.equals("Y")){
							strAFileExtImg = "<img src='/image/common/icon_file.gif' width='13' height='15'>";
						}
						String strAQryCnt = (String)objHshAdminBbrdData.get("QRY_CNT");
              %>
              <tr align="center" bgcolor="#FCFDF0" > 
                <td height="22">공지</td>
                <td height="22" align="left" class="td_lmagin">
				<a href="/board/common/BoardList2Content.jsp?strGoToPage=<%=strGoToPage%>&strCurrentPage=<%=strCurrentPage%>&bbrdid=<%=strBbrdID%>&dataid=<%=strADataID%>"><%=strATitle%></a></td>
				<td height="22"><%=strAFileExtImg%></td>
                <td height="22"><%=strAWriterNm%></td>
                <td height="22" align="center"><%=strAWriteTs%></td>
                <td height="22"><%=strAQryCnt%></td>
              </tr>
              <tr class="tbl-line"> 
                <td height="1"></td>
                <td height="1"></td>
				<td height="1"></td>
                <td height="1" align="left" class="td_lmagin"></td>
                <td height="1" align="center" class="td_lmagin"></td>
                <td height="1"></td>
              </tr>
              <% 
              		
              		}	//end for	
              } //end if
              %>
			  <%
			  if(intTotalCount != 0){

				  for (int i = 1; i < objAryBbrdData.size(); i++) {
					Hashtable objHshBbrdData = (Hashtable)objAryBbrdData.get(i);
					
					String strDataID = (String)objHshBbrdData.get("DATA_ID");
					//NO = 전체갯수 - rownum + 1 
					int intViewDataID = Integer.valueOf(strTotalCount).intValue() - Integer.valueOf((String)objHshBbrdData.get("RNUM")).intValue() + 1;
					String strTitle = BoardComm.replaceTag2Text((String)objHshBbrdData.get("TITLE"));
					String strWriterNm = (String)objHshBbrdData.get("WRITER_NM");
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
              <tr align="center" onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''"> 
                <td height="22"><%=intViewDataID%></td>
                <td height="22" align="left" class="td_lmagin">
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
				<td height="22"><%=strFileExtImg%></td>
                <td height="22"><%=strWriterNm%></td>
                <td height="22" align="center"><%=strWriteTs%></td>
                <td height="22"><%=strQryCnt%></td>
              </tr>
              <tr class="tbl-line"> 
                <td height="1"></td>
                <td height="1"></td>
				<td height="1"></td>
                <td height="1" align="left" class="td_lmagin"></td>
                <td height="1" align="center" class="td_lmagin"></td>
                <td height="1"></td>
              </tr>
		   <%
				}
			} else {
			
				out.println("<tr>");
				out.println("	<td height='22' colspan='6' align='center'>해당 데이타가 없습니다.");
				out.println("	</td>");
				out.println("</tr>");
				out.println("<tr class='tbl-line'>");
				out.println("	<td height='1'></td>");
				out.println("	<td height='1'></td>");
				out.println("	<td height='1'></td>");
				out.println("	<td height='1' align='left' class='td_lmagin'></td>");
				out.println("	<td height='1' align='left' class='td_lmagin'></td>");
				out.println("	<td align='left' class='td_lmagin'></td>");
				out.println("</tr>");
				
			}
			%>
              <tr class="tbl-line"> 
                <td height="1"></td>
                <td height="1"></td>
				<td height="1"></td>
                <td height="1"></td>
                <td height="1"></td>
                <td height="1"></td>
              </tr>
			</form>
            </table>
		    <!-- 이용안내 문의게시판 리스트 끝 -->
		  </td>
        </tr>
      </table></td>
  </tr>
  <tr align="left" valign="top"> 
    <td width="24" height="26">&nbsp;</td>
    <td height="40" align="center" valign="middle">
	<%=PageCount.getLinkedString(strTotalCount , strCurrentPage, strCountPerPage) %>
	</td>
  </tr>
  <tr height="3" align="left" valign="top"> 
    <td height="3"></td>
    <td height="3" background="../image/common/line_table.gif"></td>
  </tr>
  <tr align="left" valign="top"> 
    <td height="35">&nbsp;</td>
    <td height="35">
	  <!-- 등록, 검색 테이블 시작 ------------------------------->
	  <table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <form name="frmSearch" method="post"  action="GuideBoardList.jsp" onSubmit="return doSearch()"> 
	  <input type="hidden" name="strCurrentPage" value="<%=strCurrentPage%>">
	  <input type="hidden" name="bbrdid" value="<%=strBbrdID%>">
	  <input type="hidden" name="srchType" value="">
	  <input type="hidden" name="srchText" value="">
        <tr> 
          <td width="256" height="40"><a href="WriteGuideBoard.jsp?bbrdid=<%=strBbrdID%>"><img src="../image/button/bt_register.gif" width="44" height="20" border="0"></a></td>
          <td width="503" align="right" valign="middle"><div align="right"> 
              <select name="selSearch" class="select">
				<option value="FREE_ALL" <% if(strSrchType.equals("FREE_ALL")) out.println("selected"); %>>전체</option>
				<option value="TITLE" <% if (strSrchType.equals("TITLE")) out.println("selected"); %>>제목</option>
				<option value="CONT" <% if (strSrchType.equals("CONT")) out.println("selected"); %>>내용</option>
				<option value="USER_NM" <% if (strSrchType.equals("USER_NM")) out.println("selected"); %>>작성자</option>
			  </select>
              <input name="txtSearch" type="text" class="textfield" style="WIDTH: 180px" value="<%=strSrchText%>">
			  <input type="image"  src="../image/common/bt_search_table.gif" width="51" height="18" align="absmiddle"></div></td>
        </tr>
	  </form>
      </table>
	  <!-- 등록, 검색 테이블 끝 ------------------------------->
  	</td>
  </tr>
  <tr align="left" valign="top"> 
    <td height="35">&nbsp;</td>
    <td height="35">&nbsp;</td>
  </tr>
</table>
</body>
</html>
