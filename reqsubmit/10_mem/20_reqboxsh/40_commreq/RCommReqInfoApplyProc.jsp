<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.bf.config.*"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.params.requestinfo.RMemReqInfoListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.cmtsubmt.CmtSubmtReqInfoDelegate" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%
/******************************************************************************
* Name		  : RCommReqInfoAppyProc.jsp
* Summary	  : ����ȸ �����û ó�� 
* Description : ���õ� �Ϲݿ䱸�� ID �迭�� �޾Ƽ�
*               �����⵵, ���� ����ȸ,���� �Ұ������� �ش��ϴ� ��û���� ã�Ƽ� �־���.
*				
* 				
*				
******************************************************************************/
%>
<%
 UserInfoDelegate objUserInfo =null;
 CDInfoDelegate objCdinfo =null;
%>
<%@ include file="../../../common/RUserCodeInfoInc.jsp" %>

<%
 /*************************************************************************************************/
 /** 					�Ķ���� üũ Part 														  */
 /*************************************************************************************************/
  /**�䱸��Ͽ� �Ķ���� ���� üũ */
  RMemReqInfoListForm objParams =new RMemReqInfoListForm();  
  boolean blnParamCheck=false;
  /**���޵� �ĸ����� üũ */
  blnParamCheck=objParams.validateParams(request);
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
  
  String strReqBoxID = StringUtil.getEmptyIfNull(request.getParameter("ReqBoxID"));
  String[] strReqInfoIDs=request.getParameterValues("ReqInfoIDs");
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
		System.out.println("SysErrorCode:" + objAppEx.getStrErrCode());
  		objMsgBean.setStrCode("SYS-00010");//AppException����.
	  	objMsgBean.setStrMsg(objAppEx.getMessage());
	  	//out.println("<br>Error!!!" + objAppEx.getMessage());
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
			alert("�����Ͻ� �䱸 ����(<%=strReqInfoIDs.length%>) �� (<%=intOkNumber%>)����  �����û�Ǿ����ϴ� ");
		<%
		}else{
		%>
			alert("��û�� �䱸������ ���õ��� �ʾҽ��ϴ�.");
		<%
		}
		%>
		formName.submit();
	}
</script>
<body onLoad="init()">
				<form name="formName" method="<%=nads.lib.reqsubmit.EnvConstants.FORM_METHOD%>" action="<%=request.getParameter("ReturnUrl")%>" >
					<%=objParams.getHiddenFormTags()%>
					<input type="hidden" name="ReqBoxID" value="<%= strReqBoxID %>">
				</form>
</body>
</html>