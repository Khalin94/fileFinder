<%@ page import="java.util.*"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>

<%
	String strRownum2 = "";
	String strFid2 = "";
	String strSortNm2 = "";
	String strForumNm2 = "";
	String strUserNm2 = "";
	String strSttNm2 = "";
	String strUserStt2 = "";

	Vector objRownum2 = new Vector();
	Vector objFid2 = new Vector();
	Vector objSortNm2 = new Vector();
	Vector objForumNm2 = new Vector();
	Vector objUserNm2 = new Vector();
	Vector objSttNm2 = new Vector();
	Vector objUserStt2 = new Vector();

	try
	{
		Hashtable objJoinleaveHtable = objUserForumDelegate.selectJoinleaveForum(strUserId);
	
		objRownum2 = (Vector)objJoinleaveHtable.get("ROWNUM");
		objFid2 = (Vector)objJoinleaveHtable.get("FID");
		objSortNm2 = (Vector)objJoinleaveHtable.get("SORTNM");
		objForumNm2 = (Vector)objJoinleaveHtable.get("FORUM_NM");
		objUserNm2 = (Vector)objJoinleaveHtable.get("USER_NM");
		objSttNm2 = (Vector)objJoinleaveHtable.get("STTNM");
		objUserStt2 = (Vector)objJoinleaveHtable.get("USER_STT");
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

	if ((objRownum2 != null) && (objRownum2.size() > 0)){
		String strH2 = "1";
		for (int j=0; j < objRownum2.size(); j++){
			strRownum2 = (String)objRownum2.elementAt(j);
			strFid2 = (String)objFid2.elementAt(j);
			strSortNm2 = (String)objSortNm2.elementAt(j);
			strForumNm2 = (String)objForumNm2.elementAt(j);
			strUserNm2 = (String)objUserNm2.elementAt(j);
			strSttNm2 = (String)objSttNm2.elementAt(j);
			strUserStt2 = (String)objUserStt2.elementAt(j);
%>
                    <tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''"> 
                      <td height="22" align="center"><%=Integer.toString(j+1)%></td>
                      <td height="22" align="center"><%=strSortNm2%></td>
                      <td height="22" align="center"><%=strSttNm2%></td>
                      <td height="22" align="left" class="td_lmagin"><%=strForumNm2%></td>
                      <td height="22" align="center"><%=strUserNm2%></td>
<%
			//가입신청(001), 탈퇴신청(004)일 경우 처리상태 표시를 승인대기중으로하고,  취소여부를 결정하게한다.
			//가입거부(002), 탈퇴거부(005)일 경우 처리상태 표시를 승인반려으로하고,  확인여부를 결정하게한다.		 
			if(strUserStt2.equals("001") || strUserStt2.equals("004")){                        
%>
                      <td height="22" align="center">승인대기중</td>
                      <td height="22" align="center"><a href="javascript:fun_canceluser('<%=strFid2%>', '<%=strUserStt2%>')"><img src="../image/button/bt_cancel_icon.gif" width="46" height="20" border="0"></a></td>
<%
			}else{
%>
                      <td height="22" align="center"><a href="javascript:fun_reasonuser('<%=strFid2%>')">승인반려</a></td>
                      <td height="22" align="center"><a href="javascript:fun_canceluser('<%=strFid2%>', '<%=strUserStt2%>')"><img src="../image/button/bt_confirm_icon2.gif" width="46" height="20" border="0"></a></td>

<%
			}
			if(j ==  objRownum2.size() - 1){
				strH2 = "2";
			}
%>                      
                    </tr>
                    <tr class="tbl-line"> 
                      <td height="<%=strH2%>"></td>
                      <td height="<%=strH2%>"></td>
                      <td height="<%=strH2%>"></td>
                      <td height="<%=strH2%>" align="left" class="td_lmagin"></td>
                      <td height="<%=strH2%>"></td>
                      <td height="<%=strH2%>"></td>
                      <td height="<%=strH2%>"></td>
                    </tr>

<%
		}//(int j=0; j < objRownum2.size(); j++)
	} else {
		out.println("<tr>");
		out.println("<td height='22' colspan='7' align='center'>해당 데이타가 없습니다.");
		out.println("</td>");
		out.println("</tr>");
		out.println("<tr class='tbl-line'>");
		out.println("<td height='2'></td>");
		out.println("<td height='2'></td>");
		out.println("<td height='2'></td>");
		out.println("<td height='2' align='left' class='td_lmagin'></td>");
		out.println("<td height='2'></td>");
		out.println("<td height='2'></td>");
		out.println("<td height='2'></td>");
		out.println("</tr>");	
	}//if ((objRownum2 != null) && (objRownum2.size() > 0))
%>				
