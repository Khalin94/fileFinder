<%@ page import="java.util.*"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>

<%
	nads.dsdm.app.activity.forum.UserForumDelegate objUserForumDelegate = null;
	String strUserId = "";

	String strRownum = "";
	String strFid = "";
	String strSortNm = "";
	String strForumNm = "";
	String strOpenFlag = "";
	String strOpenFlagCon = "";
	String strOprtrNm = "";
	String strEstabTs = "";

	Vector objRownum = new Vector();
	Vector objFid = new Vector();
	Vector objSortNm = new Vector();
	Vector objForumNm = new Vector();
	Vector objOpenFlag = new Vector();
	Vector objOprtrNm = new Vector();
	Vector objEstabTs = new Vector();

	try
	{
		strUserId = (String)session.getAttribute("USER_ID");
	
		objUserForumDelegate = new nads.dsdm.app.activity.forum.UserForumDelegate();
	
		Hashtable objJoinHtable = objUserForumDelegate.selectJoinForum(strUserId);
	
		objRownum = (Vector)objJoinHtable.get("ROWNUM");
		objFid = (Vector)objJoinHtable.get("FID");
		objSortNm = (Vector)objJoinHtable.get("SORTNM");
		objForumNm = (Vector)objJoinHtable.get("FORUM_NM");
		objOpenFlag = (Vector)objJoinHtable.get("OPEN_FLAG");
		objOprtrNm = (Vector)objJoinHtable.get("OPRTRNM");
		objEstabTs = (Vector)objJoinHtable.get("ESTAB_TS");
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
	
	if ((objRownum != null) && (objRownum.size() > 0)){	
		String strH = "1";
		for (int i=0; i < objRownum.size(); i++){
			strRownum = (String)objRownum.elementAt(i);
			strFid = (String)objFid.elementAt(i);
			strSortNm = (String)objSortNm.elementAt(i);
			strForumNm = (String)objForumNm.elementAt(i);
			strOpenFlag = (String)objOpenFlag.elementAt(i);
			
			if(strOpenFlag.equals("Y")){
				strOpenFlagCon = "공개";
			}else{
				strOpenFlagCon = "비공개";
			}
			strOprtrNm = (String)objOprtrNm.elementAt(i);
			strEstabTs = nads.lib.util.ActComm.makeDate((String)objEstabTs.elementAt(i));
			
			if(i ==  objRownum.size() - 1){
				strH = "2";
			}
%>          

                    <tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''"> 
                      <td height="22" align="center"><%=Integer.toString(i+1)%></td>
                      <td height="22" align="center"><%=strSortNm%></td>
                      <td height="22" align="left" class="td_lmagin">
                        <a href="javascript:openForum('<%=strFid%>','<%=strOpenFlag%>');"><%=strForumNm%></a>
                      </td>
                      <td height="22" align="center"><%=strOpenFlagCon%></td>
                      <td height="22" align="center"><%=strOprtrNm%></td>
                      <td height="22" align="center"><%=strEstabTs%></td>
                    </tr>
                    <tr class="tbl-line"> 
                      <td height="<%=strH%>"></td>
                      <td height="<%=strH%>"></td>
                      <td height="<%=strH%>" align="left" class="td_lmagin"></td>
                      <td height="<%=strH%>" align="left" class="td_lmagin"></td>
                      <td height="<%=strH%>"></td>
                      <td height="<%=strH%>"></td>
                    </tr>
<%
		}//for (int i=0; i < objRownum.size(); i++)
	} else {
		out.println("<tr>");
		out.println("<td height='22' colspan='5' align='center'>해당 데이타가 없습니다.");
		out.println("</td>");
		out.println("</tr>");
		out.println("<tr class='tbl-line'>");
		out.println("<td height='2'></td>");
		out.println("<td height='2'></td>");
		out.println("<td height='2' align='left' class='td_lmagin'></td>");
		out.println("<td height='2' align='left' class='td_lmagin'></td>");
		out.println("<td height='2'></td>");
		out.println("<td height='2'></td>");
		out.println("</tr>");
	}if ((objRownum != null) && (objRownum.size() > 0))		
%>				
