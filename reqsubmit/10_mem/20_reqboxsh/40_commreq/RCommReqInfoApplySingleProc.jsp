<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.bf.config.*"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.cmtsubmt.CmtSubmtReqInfoDelegate" %>
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
  //�䱸����
  String[] strReqInfoIDs=request.getParameterValues("ReqInfoID");
%>
 
<%
 /*************************************************************************************************/
 /** 					������ ó�� Part 														  */
 /*************************************************************************************************/
  boolean blnHasIDs=false;
  String[] strReturns=null; //ó�� ��� �迭. "" �� ó�����Ѱ���.
  int intOkNumber=0;
  /** ó���� �䱸 ID�� �ִ��� üũ */
  if(strReqInfoIDs!=null && strReqInfoIDs.length >0){
	 boolean blnOk=false; //ó�� ��������.
	 try{
	   /********* �븮�� ���� ���� *********/
	   CmtSubmtReqInfoDelegate objReqInfo=new CmtSubmtReqInfoDelegate();
	   strReturns=objReqInfo.copyRecord(objUserInfo.getUserID(),strReqInfoIDs);
	   if(strReturns!=null){
	   		for(int i=0;i<strReturns.length;i++){
	   			if(!strReturns[i].equals("")){
	   			intOkNumber++;
	   			}
	   		}
	   }
	   
	 }catch(AppException objAppEx){ 
	 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  		objMsgBean.setStrCode(objAppEx.getStrErrCode());
	  	objMsgBean.setStrMsg(objAppEx.getMessage());
	  	%>
	  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
	  	<%  	
	  	return; 
	 }//endoftry
	 blnHasIDs=true;//ó����.
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
		<%
		 if(blnHasIDs){
		%>
			alert("�䱸 ������  �����û�Ǿ����ϴ� ");
		<%
		}else{
		%>
			alert("��û�� �䱸������ �߸����õǾ����ϴ�.");
		<%
		}
		%>
		formName.submit();
	}
</script>
<body onLoad="init()">
				<form name="formName" method="<%=nads.lib.reqsubmit.EnvConstants.FORM_METHOD%>" action="<%=request.getParameter("ReturnUrl")%>" >
				<%=nads.lib.reqsubmit.form.Form.makeHiddenFormTags(request)%>
				</form>
</body>
</html>