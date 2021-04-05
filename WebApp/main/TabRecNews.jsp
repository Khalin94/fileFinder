<%@ page import="java.util.*" %>
<%
	ArrayList objNewArry = new ArrayList();
	
	try{
		nads.dsdm.app.activity.useritet.UserItetDelegate objUserItetDelegateNew = new nads.dsdm.app.activity.useritet.UserItetDelegate();
		
		Hashtable objParamHt = new Hashtable();
		objParamHt.put("GUBUN", "-1");
		objParamHt.put("CONTENT", "");
		objParamHt.put("CURRENTPAGE", "1");
		objParamHt.put("COUNTPERPAGE", "5");
	
		Hashtable objNewHt = objUserItetDelegateNew.selectNewinfo(objParamHt);	
	
		objNewArry = (ArrayList)objNewHt.get("NEW");
		
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
	
	if(objNewArry.size() != 0){
		Hashtable objNewHt  = new Hashtable();
		String strNewTitle = "";
		String strNewUrl = "";
		String strNewGroupNm = "";
		String strNewRegdate = "";
		String strGetDate = "";
		
		for (int i = 0; i < objNewArry.size(); i++) {
			objNewHt = (Hashtable)objNewArry.get(i);
			strNewTitle = (String)objNewHt.get("TITLE");
			strNewUrl = (String)objNewHt.get("URL");
			strNewGroupNm = (String)objNewHt.get("GROUPNAME");
			strGetDate = (String)objNewHt.get("GETDATE");
			
			if((strGetDate != null) && (strGetDate.length() >= 8))
				strGetDate = strGetDate.substring(0, 4) + "-" + strGetDate.substring(4, 6) + "-"  + strGetDate.substring(6, 8);
			
%>
            <tr> 
              <td  width="87%" height="18" class="news"><img src="image/main/icon_yellowdot.gif" width="3" height="4" align="absmiddle"> 
                <a href="javascript:fun_winopen('<%=strNewUrl%>', '뉴스검색')"><%=nads.lib.util.ActComm.chrString("[" + strNewGroupNm + "] " +  strNewTitle,  46)   %></td>
                </a>
	          </td>  
	          <td width="13%" align="right" class="news">[<%=strGetDate%>]</td>  
            </tr>
<%
		}//for (int i = 0; i < objNewArry.size(); i++)
	} else {
		out.println("<tr>");
		out.println("<td  height='18' class='news'><img src='image/main/icon_yellowdot.gif' width='3' height='4' align='absmiddle'> ");
		out.println("해당 데이타가 없습니다.");
		out.println("</td>");
		out.println("</tr>");	
	}
%>
