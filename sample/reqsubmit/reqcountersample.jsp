<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.params.requestinfo.MainReqInfoListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.RequestInfoDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%
  
 /*************************************************************************************************/
 /** 					데이터 호출 Part  														  */
 /*************************************************************************************************/
 java.util.Hashtable objMainCntHash=null;//요구개수구하기 해쉬.
 boolean blnIsRequester=false;
 RequestInfoDelegate objReqInfo=null;
 try{
   blnIsRequester=Boolean.valueOf((String)request.getSession().getAttribute("IS_REQUESTER")).booleanValue();
   /** 요구목록 출력 대리자.*/
   objReqInfo=new RequestInfoDelegate();
   objMainCntHash=objReqInfo.getMainReqCount((String)request.getSession().getAttribute("ORGAN_ID"),blnIsRequester,(String)request.getSession().getAttribute("ORGAN_KIND"));
 }catch(AppException objAppEx){
 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  	objMsgBean.setStrCode(objAppEx.getStrErrCode());
  	objMsgBean.setStrMsg(objAppEx.getMessage());
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%  	
  	return;
 }
 
 //요구개수:REQ_SUM,제출개수:SUBMT_SUM,미제출개수:DIFF_SUM,기한경과미제출요구:DELAY_SUBMT
 out.println("<br>요구개수:" + nads.lib.reqsubmit.util.HashtableUtil.getEmptyIfNull(objMainCntHash,"REQ_SUM","0"));
 out.println("<br>제출개수:" + nads.lib.reqsubmit.util.HashtableUtil.getEmptyIfNull(objMainCntHash,"SUBMT_SUM","0"));
 out.println("<br>미제출개수:" + nads.lib.reqsubmit.util.HashtableUtil.getEmptyIfNull(objMainCntHash,"DIFF_SUM","0"));
 out.println("<br>기한경과개수:" + nads.lib.reqsubmit.util.HashtableUtil.getEmptyIfNull(objMainCntHash,"DELAY_SUBMT","0"));
 out.println("<a href='" + RequestInfoDelegate.gotoMainMoreLink(blnIsRequester,(String)request.getSession().getAttribute("ORGAN_KIND")) + "'>More<a>");
%>