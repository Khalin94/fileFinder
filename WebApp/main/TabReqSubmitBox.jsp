<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.CDInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.RequestBoxDelegate" %>

<%
 /*************************************************************************************************/
 /** 					데이터 호출 Part  														  */
 /*************************************************************************************************/
 /**요구함 목록 */
 ResultSetHelper objReqBoxRs=null;	
 /**요구함정보 대리자 */
 RequestBoxDelegate objReqBox=null;			
 String strMainIsRequeser=(String)request.getSession().getAttribute("IS_REQUESTER");
 try{
   /** 제출자 요구함 목록  출력 대리자.*/
   objReqBox=new RequestBoxDelegate();
   objReqBoxRs=objReqBox.getMainReqBoxList((String)request.getSession().getAttribute("ORGAN_ID"),(String)request.getSession().getAttribute("ORGAN_KIND"),strMainIsRequeser);
 }catch(AppException objAppEx){
 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  	objMsgBean.setStrCode(objAppEx.getStrErrCode());
  	objMsgBean.setStrMsg(objAppEx.getMessage());
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%  	
  	return;
 }
 	String strBoxOutDate = "";
	if(objReqBoxRs.getRecordSize() >0) {//목록이 있으면.
		String strReqBox = "";
		while(objReqBoxRs.next()){
%>
		<tr>
		  <td  width="87%" height="18" class="newReqBoxList"><img src="image/main/icon_bluedot.gif" width="3" height="4" align="absmiddle"> 
<%
			out.print("<a href=\"" + objReqBox.getGotoMainReqBoxLink(objReqBoxRs) + "\">");
			strReqBox = "[";
			if(strMainIsRequeser.equalsIgnoreCase("true")){//요구자
				strReqBox = strReqBox + (String)objReqBoxRs.getObject("SUBMT_ORGAN_NM");//제출기관명
			}else{//제출자
				strReqBox = strReqBox + (String)objReqBoxRs.getObject("REQ_ORGAN_NM");//요구기관명
			}
		    strReqBox = strReqBox + "] ";
		    
		    strReqBox = strReqBox + (String)objReqBoxRs.getObject("REQ_BOX_NM");//요구내용 30자만 가져오기...
			
			strBoxOutDate = (String)objReqBoxRs.getObject("REG_DT");//등록일
%>		
            <%=nads.lib.util.ActComm.chrString(strReqBox,  46)   %>
		    </a>
	      </td>  
	      <td width="13%" align="right" class="newReqBoxList">[<%=nads.lib.reqsubmit.util.StringUtil.getDate(strBoxOutDate)%>]</td>  

		</tr>
	  <%
		}//endofwhile
	}else{
		out.println("<tr>");
		out.println("<td  height='18' class='newReqBoxList'><img src='image/main/icon_bluedot.gif' width='3' height='4' align='absmiddle'> ");
		out.println("해당 데이타가 없습니다.");
		out.println("</td>");
		out.println("</tr>");
	}//endif목록체크.
%>
