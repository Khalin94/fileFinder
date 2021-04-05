<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.CDInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.RequestBoxDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
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
%>
<!DOCTYPE HTML PUBLIC "-//w3c//dtd html 4.0 transitional//en">
<html>
<head>
<title>서류제출 시스템</title>
<link href="/css/System.css" rel="stylesheet" type="text/css">
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<h3>메인화면 요구함 목록</h3>
<%
	if(objReqBoxRs.getRecordSize() >0) {//목록이 있으면.
%>
		<table border="1" width="400">
	   <%
		while(objReqBoxRs.next()){
	   %>
		<tr><td>
			<%
			  out.print("<a href=\"" + objReqBox.getGotoMainReqBoxLink(objReqBoxRs) + "\">");
			  out.print((String)objReqBoxRs.getObject("REQ_BOX_NM"));//요구함명
			  out.print("</a>");
			  if(strMainIsRequeser.equalsIgnoreCase("true")){//요구자
			      out.print((String)objReqBoxRs.getObject("SUBMT_ORGAN_NM"));//제출기관명
			  }else{
				  out.print((String)objReqBoxRs.getObject("REQ_ORGAN_NM"));//요구기관명
			  }
			  out.println(nads.lib.reqsubmit.util.StringUtil.getDate((String)objReqBoxRs.getObject("REG_DT")));//등록일
			 %>		
			</a>
		</td></tr>
	  <%
		}//endofwhile
	  %>
		</table>
<%
	}//endif목록체크.
%>
</body>
</html>              
