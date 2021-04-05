<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="nads.lib.message.MessageBean" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%@ include file="/forum/common/CheckSessionPop.jsp" %>
<%@ include file="/board/common/GetBoardProperty.jsp" %>
<%	
	/*세션값 */
	String strLoginID = (String)session.getAttribute("USER_ID");							//로그인 ID
	
	/*개별포럼 페이지 파라미터 (포럼ID, 회원상태, 공개여부, 포럼명)*/
	String strForumID = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("fid"))); 				 //포럼ID
	String strUserStt = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("uStt")));		 	//회원상태
	String strOpenFlag = ""; 																									//공개여부
	String strForumNM = ""; 																									//포럼명
	
	if(strForumID == null || strForumID.equals("") || strForumID.equals(" ")){
		
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		objMsgBean.setStrCode("DSPARAM-0000");
		objMsgBean.setStrMsg("포럼 정보를 알수 없습니다.");
		
		// 에러 발생 메세지 페이지로 이동한다.
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
			
	}
	
	/*초기값 설정 */
	nads.dsdm.app.forum.SLMngBoardDelegate objMngBoard = new nads.dsdm.app.forum.SLMngBoardDelegate();
	ArrayList objAryBbrdList = null;
	
	try{

		//1. 게시판 리스트 정보를 가져온다.
		objAryBbrdList = objMngBoard.selectBbrdInfoList(strForumID);	
		
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
<script language="javascript" src="/js/forum.js"></script>
<script language="javascript">	
	function goToMngWrite(cnt){

		if(cnt >= "<%=boardMaxCnt%>"){
			var msg = "개별포럼 게시판 최대 생성 갯수는 " + "<%=boardMaxCnt%>" + "개 이므로 더이상 게시판 생성하실 수 없습니다."
							+ " \n 게시판을 추가 하시려면 기존게시판을 삭제하신 후 추가 하실 수 있습니다.";
			alert(msg);
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
          <!--<td height="30" align="left" class="text_s">-->
          <td height="50" align="left" class="text_s">
          	포럼에서 구성되는 게시판 형태의 메뉴를 관리하실 수 있습니다. <br>
          	포럼에서 제공되는 기본 게시판 3개는 수정, 삭제 하실 수 없습니다.  <br>      	
          	개별 포럼 게시판 최대 생성 갯수는 <%=boardMaxCnt%>개 입니다.
          </td>
        </tr>
        <tr> 
          <td height="5" align="left" valign="top"></td>
        </tr>
        <tr> 
          <td align="left" valign="top">
            <!-- 게시판 리스트 테이블 시작 ---------------------------->
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td height="2" colspan="5" class="td_forumpop"></td>
              </tr>
              <tr class="td_top"> 
                <td width="46" height="22" align="center">NO</td>
                <td width="370" height="22" align="center">게시판 이름</td>
                <td width="100" height="22" align="center">등록일자</td>
                <td width="55" height="22" align="center">게시물</td>
              </tr>
              <tr> 
                <td height="1" colspan="5" class="td_forumpop"></td>
              </tr>
              <%
              int intBbrdCnt  = 0;						//현재 OPERATOR 게시판 수 
              
              if (objAryBbrdList != null) {
	              if (objAryBbrdList.size() != 0) {
	              	for (int i = 0; i < objAryBbrdList.size(); i++) {
	              		Hashtable objHshBbrdList = (Hashtable)objAryBbrdList.get(i);
	              		
	              		String strBbrdID = (String)objHshBbrdList.get("BBRD_ID");
	              		String strRegTs = (String)objHshBbrdList.get("REG_TS");
	              		String strUpdTs = (String)objHshBbrdList.get("UPD_TS");
	              		if(!strUpdTs.equals("")){
								strRegTs = strUpdTs;
						}
	              		strRegTs = strRegTs.substring(0, 4) + "-" + strRegTs.substring(4, 6) + "-"  + strRegTs.substring(6, 8);
	              		String strRemark = (String)objHshBbrdList.get("REMARK");
	              		if(strRemark.equals("OPERATOR")){
	              			intBbrdCnt = intBbrdCnt + 1;
	              		}
              %>
              <tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''"> 
                <td height="22" align="center" width="46"><%=i+1%></td>
                <td height="22" class="td_lmagin" width="355">
                	<% if (strRemark.equals("ADMIN")) { %>
                	<b><%=objHshBbrdList.get("BBRD_NM")%></b>
                	<% } else if (strRemark.equals("OPERATOR")) { %>
                	<a href="ManageBoardContent.jsp?fid=<%=strForumID%>&uStt=<%=strUserStt%>&bbrdid=<%=strBbrdID%>"><%=objHshBbrdList.get("BBRD_NM")%></a>
                	<% } %>
                </td>
                <td height="22" align="center" width="100"><%=strRegTs%></td>
                <td height="22" align="center" width="70"><%=objHshBbrdList.get("CNT")%></td>
              </tr>
              <tr class="tbl-line"> 
                <td height="1" width="46"></td>
                <td height="1" width="355"></td>
                <td height="1" align="left" class="td_lmagin" width="100"></td>
                <td height="1" align="left" class="td_lmagin" width="70"></td>
              </tr>
              <%
	              	}
	              } else {
	              		out.println("<tr>");
						out.println("<td height='22' colspan='4' align='center'>해당 데이타가 없습니다.");
						out.println("</td>");
						out.println("</tr>");
						out.println("<tr class='tbl-line'> ");
						out.println("<td height='1' width='46'></td>");
						out.println("<td height='1' width='355'></td>");
						out.println("<td height='1' align='left' class='td_lmagin' width='100'></td>");
						out.println("<td height='1' align='left' class='td_lmagin' width='70'></td>");
						out.println("</tr>");
	              }
              }
              %>
              <tr class="tbl-line"> 
                <td height="1" width="46"></td>
                <td height="1" width="355"></td>
                <td height="1" align="left" class="td_lmagin" width="100"></td>
                <td height="1" align="left" class="td_lmagin" width="70"></td>
              </tr>
            </table>
          	<!-- 게시판 리스트 테이블 끝 ---------------------------->
          </td>
        </tr>
        <tr> 
          <td height="15" align="left" valign="top">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td height="40"><a href="WriteManageBoard.jsp?fid=<%=strForumID%>&uStt=<%=strUserStt%>"><img src="/image/button/bt_add.gif" width="45" height="20" border="0" onClick="return goToMngWrite('<%=intBbrdCnt%>');"></a>
                </td>
              </tr>
            </table>
          </td>
        </tr>
        <tr> 
          <td height="15" align="left" valign="top"></td>
        </tr>
      </table>
      </td>
  </tr>
</table>
<%@ include file="/forum/common/BottomForumPop.jsp" %>
</body>
</html>
