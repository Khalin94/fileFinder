<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ page import="nads.lib.util.BoardComm" %>
<%@ page import="kr.co.kcc.bf.config.*" %>
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
		for (int i = 0; i < objNoticeArry.size(); i++) {
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
              <tr> 
	            <td width="87%" height="18" class="notice"><img src="image/main/icon_yellowdot.gif" width="3" height="4" align="absmiddle"> 
	              <a href="/board/common/BoardList2Content.jsp?strGoToPage=<%=strGoToPage%>&strCurrentPage=1&bbrdid=<%=strBbrdIdData%>&dataid=<%=strDataIdData%>"><%=nads.lib.util.ActComm.chrString(strTitleData,  46)   %>
	              </a>
	            </td>  
	            <td width="13%" align="right" class="notice">[<%=strWriteTsData%>]</td>  
	          </tr> 
<%
		}	
	} else {
		out.println("<tr>");
		out.println("<td  height='18' class='notice'><img src='image/main/icon_yellowdot.gif' width='3' height='4' align='absmiddle'> ");
		out.println("해당 데이타가 없습니다.");
		out.println("</td>");
		out.println("</tr>");	
	}
%>