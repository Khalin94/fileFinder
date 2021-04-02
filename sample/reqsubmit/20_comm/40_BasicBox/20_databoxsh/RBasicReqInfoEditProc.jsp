<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.bf.config.*"%>
<%@ page import="kr.co.kcc.pf.util.PageCount"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.params.requestinfo.RPreReqInfoVListForm" %>
<%@ page import="nads.lib.reqsubmit.params.requestinfo.RPreReqInfoEditForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.prereqinfo.PreRequestInfoDelegate" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%
 UserInfoDelegate objUserInfo =null;
 CDInfoDelegate objCdinfo =null;
%>
<%@ include file="../../../common/RUserCodeInfoInc.jsp" %>

<%
 /*************************************************************************************************/
 /** 					�Ķ���� üũ Part 														  */
 /*************************************************************************************************/

  /**�Ϲ� �䱸�� �󼼺��� �Ķ���� ����.*/
  RPreReqInfoVListForm objParams =new RPreReqInfoVListForm();  
  boolean blnParamCheck=false;
  /**���޵� �ĸ����� üũ */
  nads.lib.reqsubmit.form.RequestWrapper objRequestWrapper=
  new nads.lib.reqsubmit.form.RequestWrapper(request);  
  blnParamCheck=objParams.validateParams(objRequestWrapper);
  if(blnParamCheck==false){
  	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	objMsgBean.setStrCode("DSPARAM-0000");
  	objMsgBean.setStrMsg(objParams.getStrErrors());
  	//out.println("ParamError:" + objParams.getStrErrors());
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%
  	return;
  }//endif

  //out.println(objParams.getValuesForDebug()); 
  //out.println("<br><br>");
  
  /** �䱸 ������ �ʿ��� �Ķ� ���� üũ.*/
  RPreReqInfoEditForm objEditParams =new RPreReqInfoEditForm();  
  blnParamCheck=false;
  /** �䱸������ ���� �ĸ����� üũ */
  /** ������ ������ Wrapper */
  blnParamCheck=objEditParams.validateParams(objRequestWrapper);
  if(blnParamCheck==false){
  	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	objMsgBean.setStrCode("DSPARAM-0000");
  	objMsgBean.setStrMsg(objEditParams.getStrErrors());
  	//out.println("ParamError:" + objEditParams.getStrErrors());
  	%>
	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%
  	return;
  }//endif
	
  //out.println(objEditParams.getValuesForDebug()); 
  
%>

<%
 /*************************************************************************************************/
 /** 					������ ó�� Part 														  */
 /*************************************************************************************************/

 try{
   /********* �븮�� ���� ���� *********/
   PreRequestInfoDelegate objReqInfo=new PreRequestInfoDelegate();   /** �䱸 ���� ������ */

   /********* ������ ��� �ϱ�  **************/
   boolean blnReturn=objReqInfo.setRecord(objEditParams).booleanValue();  
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
				<form name="formName" method="get" action="./RBasicReqInfoVList.jsp" ><!--�䱸�� �ű����� ���� -->
				    <input type="hidden" name="ReqBoxID" value="<%=objParams.getParamValue("ReqBoxID")%>">
				    <input type="hidden" name="CmtOrganID" value="<%=objParams.getParamValue("CmtOrganID")%>">
					<input type="hidden" name="ReqBoxSortField" value="<%=objParams.getParamValue("ReqBoxSortField")%>"><!--�䱸�Ը�������ʵ� -->
					<input type="hidden" name="ReqBoxSortMtd" value="<%=objParams.getParamValue("ReqBoxSortMtd")%>"><!--�䱸�Ը�����ɹ��-->
					<input type="hidden" name="ReqBoxPage" value="<%=objParams.getParamValue("ReqBoxPage")%>"><!--�䱸�� ������ ��ȣ -->
					<input type="hidden" name="ReqBoxQryField" value="<%=objParams.getParamValue("ReqBoxQryField")%>"><!--�䱸�� ��ȸ�ʵ� -->
					<input type="hidden" name="ReqBoxQryTerm" value="<%=objParams.getParamValue("ReqBoxQryMtd")%>"><!--�䱸�� ��ȸ�� -->
					<input type="hidden" name="ReqInfoSortField" value="<%=objParams.getParamValue("ReqInfoSortField")%>"><!--�䱸���� ��������ʵ� -->
					<input type="hidden" name="ReqInfoSortMtd" value="<%=objParams.getParamValue("ReqInfoSortMtd")%>"><!--�䱸���� ������ɹ��-->
					<input type="hidden" name="ReqInfoPage" value="<%=objParams.getParamValue("ReqInfoPage")%>"><!--�䱸���� ������ ��ȣ -->
					<input type="hidden" name="ReqInfoQryField" value="<%=objParams.getParamValue("ReqInfoQryField")%>"><!--�䱸 ��ȸ�ʵ� -->
					<input type="hidden" name="ReqInfoQryTerm" value="<%=objParams.getParamValue("ReqInfoQryMtd")%>"><!--�䱸 ��ȸ�� -->										
					<input type="hidden" name="ReqInfoID" value="<%=objParams.getParamValue("ReqInfoID")%>"><!--�䱸���� ID-->
				</form>
</body>
</html>

