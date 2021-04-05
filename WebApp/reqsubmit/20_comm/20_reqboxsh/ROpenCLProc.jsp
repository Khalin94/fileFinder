<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.CommRequestInfoDelegate" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%
 UserInfoDelegate objUserInfo =null;
 CDInfoDelegate objCdinfo =null;
%>
<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>

<%
 /*************************************************************************************************/
 /** 					�Ķ���� üũ Part 														  */
 /*************************************************************************************************/
	//�䱸�� ID
	String strReqBoxID = request.getParameter("ReqBoxID");
	String strReqID	= request.getParameter("CommReqID");
	String strCmtOrganID = request.getParameter("CmtOrganID");
	
	String strCommReqBoxSortField = request.getParameter("CommReqBoxSortField");
	String strCommReqBoxSortMtd = request.getParameter("CommReqBoxSortMtd");
	String strCommReqBoxPage = request.getParameter("CommReqBoxPage");
	String strCommReqBoxQryField = request.getParameter("CommReqBoxQryField");
	String strCommReqBoxQryMtd = request.getParameter("CommReqBoxQryMtd");
	//�䱸 ���� ���� ���� �ޱ�.
	String strCommReqInfoSortField = request.getParameter("CommReqInfoSortField");
	String strCommReqInfoSortMtd = request.getParameter("CommReqInfoSortMtd");
	//�䱸�� ���� ������ ��ȣ �ޱ�.
	String strCommReqInfoPage = request.getParameter("CommReqInfoPage");					
	String strCommReqInfoPagNum = request.getParameter("CommReqInfoPageNum");					
	String strReturnURL = request.getParameter("ReturnURL");
	String strCommReqInfoQryField = request.getParameter("CommReqInfoQryField");
	String strCommReqInfoQryMtd	= request.getParameter("CommReqInfoQryTerm");
	String strOpenCL = request.getParameter("OpenCL");
%>
<%
 /*************************************************************************************************/
 /** 					������ ó�� Part 														  */
 /*************************************************************************************************/

 try{
   /********* �븮�� ���� ���� *********/
   CommRequestInfoDelegate objReqInfo=new CommRequestInfoDelegate();   /** �䱸 ���� ������ */

   /********* ������ ��� �ϱ�  **************/
   boolean blnReturn=objReqInfo.setOpenCL(strReqID, strOpenCL).booleanValue();  
   if(!blnReturn){
 	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	objMsgBean.setStrCode("DSDATA-0011");
  	objMsgBean.setStrMsg("��û�Ͻ� �䱸 ������ �������� ���߽��ϴ�");
  	//out.println("<br>Error!!!" + "��û�Ͻ� �䱸 ������ �������� ���߽��ϴ�");   
  	%>
	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%  	
  	return;   	
   }
 }catch(AppException objAppEx){ 
 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  	objMsgBean.setStrCode(objAppEx.getStrErrCode());
  	objMsgBean.setStrMsg(objAppEx.getMessage());
  	//out.println("<br>Error!!!" + objAppEx.getMessage());
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%  	
  	return; 
 }
%>

<%
 /*************************************************************************************************/
 /** 					������ ��ȯ Part 														  */
 /*************************************************************************************************/
%>
<html>
<script language="JavaScript">
	function init(){
		alert("�䱸 ������ �����Ǿ����ϴ� ");
		formName.submit();
	}
</script>
<body onLoad="init()">
	<form name="formName" method="post" action="<%=strReturnURL%>"><!--�䱸�� �ű����� ���� -->
	    <input type="hidden" name="ReqBoxID" value="<%=strReqBoxID%>">
		<input type="hidden" name="CommReqBoxSortField" value="<%=strCommReqBoxSortField%>"><!--�䱸�Ը�������ʵ� -->
		<input type="hidden" name="CommReqBoxSortMtd" value="<%=strCommReqBoxSortMtd%>"><!--�䱸�Ը�����ɹ��-->
		<input type="hidden" name="CommReqBoxPage" value="<%=strCommReqBoxPage%>"><!--�䱸�� ������ ��ȣ -->
		<input type="hidden" name="CommReqBoxQryField" value="<%=strCommReqBoxQryField%>"><!--�䱸�� ��ȸ�ʵ� -->
		<input type="hidden" name="CommReqBoxQryTerm" value="<%=strCommReqBoxQryMtd%>"><!--�䱸�� ��ȸ�� -->
		<input type="hidden" name="CommReqInfoSortField" value="<%=strCommReqInfoSortField%>"><!--�䱸���� ��������ʵ� -->
		<input type="hidden" name="CommReqInfoSortMtd" value="<%=strCommReqInfoSortMtd%>"><!--�䱸���� ������ɹ��-->
		<input type="hidden" name="CommReqInfoPage" value="<%=strCommReqInfoPage%>"><!--�䱸���� ������ ��ȣ -->
		<input type="hidden" name="CommReqInfoQryField" value="<%=strCommReqInfoQryField%>"><!--�䱸 ��ȸ�ʵ� -->
		<input type="hidden" name="CommReqInfoQryTerm" value="<%=strCommReqInfoQryMtd%>"><!--�䱸 ��ȸ�� -->										
		<input type="hidden" name="CommReqID" value="<%=strReqID%>"><!--�䱸���� ID-->
	</form>
</body>
</html>

