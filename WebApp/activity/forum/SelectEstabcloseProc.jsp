<%@ page import="java.util.*"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>

<%
	String strRownum3 = "";
	String strFid3= "";
	String strSortNm3= "";
	String strForumNm3= "";
	String strUserNm3= "";
	String strSttNm3= "";
	String strForumStt = "";
	
	Vector objRownum3 = new Vector();
	Vector objFid3 = new Vector();
	Vector objSortNm3 = new Vector();
	Vector objForumNm3 = new Vector();
	Vector objUserNm3 = new Vector();
	Vector objSttNm3 = new Vector();
	Vector objForumStt3 = new Vector();
	
	try
	{
		Hashtable objEstabcloseHtable = objUserForumDelegate.selectEstabcloseForum(strUserId);
	
		objRownum3 = (Vector)objEstabcloseHtable.get("ROWNUM");
		objFid3 = (Vector)objEstabcloseHtable.get("FORUM_ID");
		objSortNm3 = (Vector)objEstabcloseHtable.get("SORTNM");
		objForumNm3 = (Vector)objEstabcloseHtable.get("FORUM_NM");
		objUserNm3 = (Vector)objEstabcloseHtable.get("USER_NM");
		objSttNm3 = (Vector)objEstabcloseHtable.get("STTNM");
		objForumStt3 = (Vector)objEstabcloseHtable.get("FORUM_STT");
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
	
	if ((objRownum3 != null) && (objRownum3.size() > 0)){
		String strH3 = "1";
		for (int k=0; k < objRownum3.size(); k++){
			strRownum3 = (String)objRownum3.elementAt(k);
			strFid3= (String)objFid3.elementAt(k);
			strSortNm3= (String)objSortNm3.elementAt(k);
			strForumNm3= (String)objForumNm3.elementAt(k);
			strUserNm3= (String)objUserNm3.elementAt(k);
			strSttNm3= (String)objSttNm3.elementAt(k);
			strForumStt = (String)objForumStt3.elementAt(k);
%>
                    <tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''"> 
                      <td height="22" align="center"><%=Integer.toString(k+1)%></td>
                      <td height="22" align="center"><%=strSortNm3%></td>
                      <td height="22" align="center"><%=strSttNm3%></td>
                      <td height="22" align="left" class="td_lmagin"><%=strForumNm3%></td>
                      <td height="22" align="center"><%=strUserNm3%></td>
<%
			//개설신청(001), 폐쇄신청(004)일 경우 처리상태 표시를 승인대기중으로하고,  취소여부를 결정하게한다.
			//개설거부(002), 폐쇄거부(005)일 경우 처리상태 표시를 승인반려으로하고,  확인여부를 결정하게한다.		 
			if(strForumStt.equals("001") || strForumStt.equals("004")){                        
%>
                      <td height="22" align="center">승인대기중</td>       
                      <td height="22" align="center"><a href="javascript:fun_cancel('<%=strFid3%>', '<%=strForumStt%>')"><img src="../image/button/bt_cancel_icon.gif" width="46" height="20" border="0"></a></td>
<%
			}else{
%>
                      <td height="22" align="center"><a href="javascript:fun_reason('<%=strFid3%>', '<%=strForumStt%>')">승인반려</a></td>
                      <td height="22" align="center"><a href="javascript:fun_cancel('<%=strFid3%>', '<%=strForumStt%>')"><img src="../image/button/bt_confirm_icon2.gif" width="46" height="20" border="0"></a></td>
<%
			}
			if(k == objRownum3.size() - 1){
				strH3 = "2";
			}
%>
                    </tr>
                    <tr class="tbl-line"> 
                      <td height="<%=strH3%>"></td>
                      <td height="<%=strH3%>"></td>
                      <td height="<%=strH3%>"></td>
                      <td height="<%=strH3%>" align="left" class="td_lmagin"></td>
                      <td height="<%=strH3%>"></td>
                      <td height="<%=strH3%>"></td>
                      <td height="<%=strH3%>"></td>
                      <td></td>
                    </tr>

<%
		}//for (int k=0; k < objRownum3.size(); k++)
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
	}//if (objRownum3.size() > 0)		
	
%>				
