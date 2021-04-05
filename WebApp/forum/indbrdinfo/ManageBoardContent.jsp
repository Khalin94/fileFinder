<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="nads.lib.message.MessageBean" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%@ page import="nads.lib.util.BoardComm" %>

<%@ include file="/forum/common/CheckSessionPop.jsp" %>
<%@ include file="/board/common/GetBoardProperty.jsp" %>
<%
	/*세션값 */
	String strLoginID = (String)session.getAttribute("USER_ID");							//로그인 ID
	
	/*개별포럼 페이지 파라미터 (포럼ID, 회원상태, 공개여부, 포럼명)*/
	String strForumID = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("fid"))); 			//포럼 아이디
	String strUserStt = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("uStt")));		 	//회원상태
	String strOpenFlag = ""; 																						//공개여부
	String strForumNM = ""; 																						//포럼명
	
	/*GET 파라미터*/
	String strBbrdID = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("bbrdid")));		//게시판 아이디

	/*초기값 설정 */
	nads.dsdm.app.forum.SLMngBoardDelegate objMngBoard = new nads.dsdm.app.forum.SLMngBoardDelegate();
	Hashtable objHshBbrdInfo = null;
	
	try{
		
		//게시판 정보를 가져온다.
		objHshBbrdInfo = objMngBoard.selectBbrdInfo(strBbrdID);
		
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
	
	String strRegTs = (String)objHshBbrdInfo.get("REG_TS");
	String strUpdTs = (String)objHshBbrdInfo.get("UPD_TS");
	if(!strUpdTs.equals("")){
		strRegTs = strUpdTs;
	}
	strRegTs = strRegTs.substring(0, 4) + "-" + strRegTs.substring(4, 6) + "-"  + strRegTs.substring(6, 8);
	String strAnsExt = (String)objHshBbrdInfo.get("ANS_EXT");
	String strOneExt = (String)objHshBbrdInfo.get("ONE_ANS_EXT");
	int intFileCnt  = Integer.valueOf((String)objHshBbrdInfo.get("APD_FILE_CNT")).intValue();
	if(strAnsExt.equals("Y")) { strAnsExt = "사용함"; } else if(strAnsExt.equals("N")) { strAnsExt = "사용안함"; }
	if(strOneExt.equals("Y")) { strOneExt = "사용함"; } else if(strOneExt.equals("N")) {strOneExt = "사용안함"; }
	String strBbrdKind = (String)objHshBbrdInfo.get("BBRD_KIND");
	String strSelKindNm = "";
	if (strBbrdKind.equals(noticeBoard)){ strSelKindNm = "공지사항"; } 
	else if (strBbrdKind.equals(freeBoard)){strSelKindNm = "게시판"; } 
	else if (strBbrdKind.equals(dataBoard)){ strSelKindNm = "자료실"; }

%>
<html>
<head>
<title>의정자료 전자유통 시스템</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link href="/css/System.css" rel="stylesheet" type="text/css">
<script language="javascript" src="/js/forum.js"></script>
<script language="javascript">
	
	function goToUpdate(frm){

		frm.action = "UpdateManageBoard.jsp";
		
	}
	
	function goToDelete(frm){

		var msg = "게시판을 삭제 하시겠습니까?\n복구하시려면 관리자에게 문의 하십시요.";

	    if(confirm(msg)){
			frm.cmd.value = "DELETE";
			frm.action = "ManageBoardProc.jsp";
	    }
	    else{
	        return false;
	    }
	    
	}
	
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<%@ include file="/forum/common/MenuTopForumPop.jsp" %>
<table width="800" height="450" border="0" cellpadding="0" cellspacing="0">
  <tr align="left" valign="top"> 
    <td width="149" background="/image/forum/bg_forumLeft.gif"> 
      <%@ include file="/forum/common/MenuLeftForumPop.jsp" %>
    </td>
    <td align="center"><table width="589" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td height="21" align="left" valign="top"></td>
        </tr>
        <tr> 
          <td align="left" valign="top"><table width="100%" height="23" border="0" cellpadding="0" cellspacing="0">
              <tr> 
                <td width="15%" background="/image/forum/bg_forumpop_tit.gif"><span class="title">게시판 관리</span></td>
                <td width="85%" align="left" background="/image/common/bg_titLine.gif">&nbsp;</td>
              </tr>
            </table></td>
        </tr>
        <tr> 
          <td height="30" align="left" class="text_s">포럼에서 구성되는 게시판 형태의 메뉴를 관리하실 수 있습니다.</td>
        </tr>
        <tr> 
          <td height="5" align="left" valign="top"></td>
        </tr>
        <tr> 
          <td align="left" valign="top">
          	<!-- 게시판 관리 상세정보 시작 -------------------------------->
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <form name="frmContent" method="post" action="">
            <input type="hidden" name="fid" value="<%=strForumID%>">
			<input type="hidden" name="uStt" value="<%=strUserStt%>">
            <input type="hidden" name="cmd" value="">
			<input type="hidden" name="bbrdid" value="<%=strBbrdID%>">
			<input type="hidden" name="bbrdkind" value="<%=strBbrdKind%>">
			<input type="hidden" name="datacnt" value="<%=objHshBbrdInfo.get("CNT")%>">
              <tr> 
                <td width="115" height="2" class="td_forumpop"></td>
                <td width="474" height="2" class="td_forumpop"></td>
              </tr>
              <tr> 
                <td width="115" height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 게시판 이름</td>
                <td width="474" height="25" class="td_lmagin"><%=objHshBbrdInfo.get("BBRD_NM")%></td>
              </tr>
              <tr> 
                <td width="115" height="1" class="tbl-line"></td>
                <td width="474"  height="1" class="tbl-line"></td>
              </tr>
              <tr> 
                <td width="115" height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 게시판 종류</td>
                <td width="474" height="25" class="td_lmagin"><%=strSelKindNm%></td>
              </tr>
              <tr> 
                <td width="115" height="1" class="tbl-line"></td>
                <td width="474" height="1" class="tbl-line"></td>
              </tr>
              <tr> 
                <td width="115" height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 등록일</td>
                <td width="474" height="25" class="td_lmagin"><%=strRegTs%></td>
              </tr>
              <tr> 
                <td width="115" height="1" class="tbl-line"></td>
                <td width="474" height="1" class="tbl-line"></td>
              </tr>
              <tr> 
                <td width="115" height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 파일첨부</td>
                <td width="474" ="25" class="td_lmagin"><%=intFileCnt%>개</td>
              </tr>
              <tr> 
                <td width="115" height="1" class="tbl-line"></td>
                <td width="474" height="1" class="tbl-line"></td>
              </tr>
			  <tr> 
                <td width="115" height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 답변형</td>
                <td width="474" height="25" class="td_lmagin"><%=strAnsExt%></td>
              </tr>
              <tr> 
                <td width="115" height="1" class="tbl-line"></td>
                <td width="474" height="1" class="tbl-line"></td>
              </tr>
			  <tr> 
                <td width="115" height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 한줄답글</td>
                <td width="474" height="25" class="td_lmagin"><%=strOneExt%></td>
              </tr>
              <tr> 
                <td width="115" height="1" class="tbl-line"></td>
                <td width="474" height="1" class="tbl-line"></td>
              </tr>
              <tr> 
                <td width="115" height="34" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 설명</td>
                <td width="474" height="100" valign="top" class="td_box"><%=objHshBbrdInfo.get("DSC")%></td>
              </tr>
              <tr> 
                <td width="115" height="1" class="tbl-line"></td>
                <td width="474" height="1" class="tbl-line"></td>
              </tr>
              <tr> 
                <td width="115" height="30" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 등록 게시물</td>
                <td width="474" height="30" class="td_lmagin"><%=objHshBbrdInfo.get("CNT")%>개 &nbsp;
                <a href="/forum/indboard/IndBoardList.jsp?fid=<%=strForumID%>&uStt=<%=strUserStt%>&bbrdid=<%=strBbrdID%>"><img src="/image/button/bt_list_icon.gif" width="37" height="17" border="0"></a>
                </td>
              </tr>
              <tr height="1"> 
                <td width="115" height="2" class="tbl-line"></td>
                <td width="474" height="2" class="tbl-line"></td>
              </tr>
              <tr>
	          <td height="35" colspan="2">
			  	<input type="image" src="/image/button/bt_modify.gif" width="43" height="20" style="cursor:hand;" onClick="goToUpdate(this.form)">&nbsp;
			  	<input type="image" src="/image/button/bt_delete.gif" width="43" height="20" onClick="goToDelete(this.form)">&nbsp;
				<a href="ManageBoardList.jsp?fid=<%=strForumID%>&uStt=<%=strUserStt%>"><img src="/image/button/bt_list.gif" width="43" height="20" border="0"></a>
			  </td>
	        </tr>
	        </form>
            </table>
            <!-- 게시판 관리 상세정보 끝 -------------------------------->
            </td>
        </tr>
        <tr> 
          <td height="15">&nbsp;</td>
        </tr>
      </table></td>
  </tr>
</table>
<%@ include file="/forum/common/BottomForumPop.jsp" %>
</body>
</html>
