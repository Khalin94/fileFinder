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
 /** 					������ ȣ�� Part  														  */
 /*************************************************************************************************/
 java.util.Hashtable objMainCntHash=null;//�䱸�������ϱ� �ؽ�.
 boolean blnIsRequester=false;
 RequestInfoDelegate objReqInfo=null;
 try{
   blnIsRequester=Boolean.valueOf((String)request.getSession().getAttribute("IS_REQUESTER")).booleanValue();
   /** �䱸��� ��� �븮��.*/
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
 
 //�䱸����:REQ_SUM,���ⰳ��:SUBMT_SUM,�����ⰳ��:DIFF_SUM,���Ѱ��������䱸:DELAY_SUBMT
 out.println("<br>�䱸����:" + nads.lib.reqsubmit.util.HashtableUtil.getEmptyIfNull(objMainCntHash,"REQ_SUM","0"));
 out.println("<br>���ⰳ��:" + nads.lib.reqsubmit.util.HashtableUtil.getEmptyIfNull(objMainCntHash,"SUBMT_SUM","0"));
 out.println("<br>�����ⰳ��:" + nads.lib.reqsubmit.util.HashtableUtil.getEmptyIfNull(objMainCntHash,"DIFF_SUM","0"));
 out.println("<br>���Ѱ������:" + nads.lib.reqsubmit.util.HashtableUtil.getEmptyIfNull(objMainCntHash,"DELAY_SUBMT","0"));
 out.println("<a href='" + RequestInfoDelegate.gotoMainMoreLink(blnIsRequester,(String)request.getSession().getAttribute("ORGAN_KIND")) + "'>More<a>");
%>