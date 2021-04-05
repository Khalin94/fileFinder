<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ page import="nads.lib.util.BoardComm" %>
<%@ page import="kr.co.kcc.bf.config.*" %>
<%
	ArrayList objNewDataArry = new ArrayList();
	
	try{
		nads.dsdm.app.main.MainDelegate objMainDelegateNew = new nads.dsdm.app.main.MainDelegate();
		objNewDataArry = objMainDelegateNew.selectRecentData(strMainOrganId, strUserId) ;
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


	String strBbrdNm="";
	for (int i = 0; i < objNewDataArry.size(); i++) {
		Hashtable objNewHt = (Hashtable)objNewDataArry.get(i);
		String strGoToPage = URLEncoder.encode("/board/BoardContent.jsp", "UTF-8");
//		System.out.println("----------->"+i+":"+(String)objNewHt.get("BBRD_KIND"));
//		System.out.println("----------->"+i+":"+(String)objNewHt.get("BBRD_NM"));
		


%>
				<tr> 
<%
				if((objNewHt != null) && (objNewHt.size() > 0)){
					String strDataId = (String)objNewHt.get("DATA_ID");
					String strTitle = BoardComm.replaceTag2Text((String)objNewHt.get("TITLE"));
					String strBbrdId = (String)objNewHt.get("BBRD_ID");
					strBbrdNm = (String)objNewHt.get("BBRD_NM");
					String strWriteTs = (String)objNewHt.get("WRITE_TS");
					String strUpdTs = (String)objNewHt.get("UPD_TS");
					if(!strUpdTs.equals("")){
						strWriteTs = strUpdTs;
					}
					strWriteTs = strWriteTs.substring(0, 4) + "-" + strWriteTs.substring(4, 6) + "-"  + strWriteTs.substring(6, 8);
%>						  
		            <td height="87%" class="newMaterial"><img src="image/main/icon_yellowdot.gif" width="3" height="4" align="absmiddle"> 
		              <a href="/board/common/BoardList2Content.jsp?strGoToPage=<%=strGoToPage%>&strCurrentPage=1&bbrdid=<%=strBbrdId%>&dataid=<%=strDataId%>"><%=nads.lib.util.ActComm.chrString("["+strBbrdNm+"] " +  strTitle,  46)   %>
		              </a>
	                </td>  
	                <td width="13%" align="right" class="newMaterial">[<%=strWriteTs%>]</td>  
		          </tr>
<%	
				}else{
%>
					<td height="18" class="newMaterial"><img src="image/main/icon_yellowdot.gif" width="3" height="4" align="absmiddle"> [<%=strBbrdNm%>] 해당 데이타가 없습니다 </td>
				 </tr>      
<%
				}

	}//for (int i = 0; i < objNewArry.size(); i++)
%>
