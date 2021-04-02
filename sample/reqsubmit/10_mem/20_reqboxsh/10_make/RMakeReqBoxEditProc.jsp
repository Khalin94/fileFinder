<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RMemReqBoxEditForm"%>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RMemReqBoxVListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.MemRequestBoxDelegate" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%
/******************************************************************************
* Name		  : RMakeReqBoxEditProc.jsp
* Summary	  : �䱸�� ���� ó�� ���.
* Description : �䱸�� ���� �ܿ� ��ȸ������ ����ٴϴ� �Ķ���� ���� ��Ƽ� ó����.
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

  /** �󼼺��� ����¡�� �Ķ���� ����.*/
  RMemReqBoxVListForm objParams =new RMemReqBoxVListForm();  
  boolean blnParamCheck=false;
  /**����¡  �ĸ����� üũ */
  blnParamCheck=objParams.validateParams(request);
  if(blnParamCheck==false){
  	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	objMsgBean.setStrCode("DSPARAM-0000");
  	objMsgBean.setStrMsg(objParams.getStrErrors());
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%
  	return;
  }//endif
  
  /** �䱸�� ���� �Ķ���� ����.*/
  RMemReqBoxEditForm objEditParams =new RMemReqBoxEditForm();  
  objEditParams.setParamValue("ReqOrganID",objUserInfo.getOrganID());//�䱸����� ���ǿ��� �־���.
    
  blnParamCheck=false;
  /** �䱸������ ���� �ĸ����� üũ */
  blnParamCheck=objEditParams.validateParams(request);
  if(blnParamCheck==false){
  	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	objMsgBean.setStrCode("DSPARAM-0000");
  	objMsgBean.setStrMsg(objEditParams.getStrErrors());
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%
  	return;
  }//endif

  /** �Ҽ�����ȸ �������� �ƴϸ� ��Ÿ����ȸ ���� 2004.05.13 ==> ���� 2004.06.04*/
  //if(objUserInfo.getIsMyCmtOrganID(objEditParams.getParamValue("CmtOrganIDX"))==false){
  //   objEditParams.setParamValue("CmtOrganIDX",CodeConstants.ETC_CMT_ORGAN_ID);     
  //}//endif

%>

<%
 /*************************************************************************************************/
 /** 					������ ó�� Part 														  */
 /*************************************************************************************************/

 boolean blnEditOk=false; //���� ����.
 try{
   /********* �븮�� ���� ���� *********/
   MemRequestBoxDelegate objReqBox=new MemRequestBoxDelegate();   /** �䱸�� ���� �Է¿� */
   String strOrganId = objUserInfo.getOrganID();
   ResultSetSingleHelper Rsh = null;
   Rsh = new ResultSetSingleHelper(objReqBox.getRecord((String)objEditParams.getParamValue("ReqBoxID")));
   
   
	
   objEditParams.setParamValue("ReqBoxNm",this.replaceXss((String)objEditParams.getParamValue("ReqBoxNm")));
   objEditParams.setParamValue("ReqBoxDsc",this.replaceXss((String)objEditParams.getParamValue("ReqBoxDsc")));
   /********* ������ ���� �ϱ�  **************/
   if(((String)Rsh.getObject("REQ_ORGAN_ID")).equals(strOrganId)){
		blnEditOk =((Boolean)objReqBox.setRecord(objEditParams)).booleanValue(); 
   }   
   if(!blnEditOk){
 	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	objMsgBean.setStrCode("DSDATA-0011");
  	objMsgBean.setStrMsg("��û�Ͻ� �䱸�� ������ �������� ���߽��ϴ�");
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%  	
  	return;   	
   }
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
<%
 /*************************************************************************************************/
 /** 					������ ��ȯ Part 														  */
 /*************************************************************************************************/
%>
<html>
<script language="JavaScript">
	function init(){
		alert("�䱸�� ������ �����Ǿ����ϴ� ");
		formName.submit();
	}
</script>
<body onLoad="init()">
				<form name="formName" method="<%=nads.lib.reqsubmit.EnvConstants.FORM_METHOD%>" action="./RMakeReqBoxVList.jsp" ><!--�䱸�� �ű����� ���� -->
					<%=objParams.getHiddenFormTags()%>
				</form>
</body>
</html>
<%!
	public String replaceXss(String str){
		
		if(str.equals("") || str == null){			
			str = "";
		}else{
			str = str.replaceAll("<","&lt;");
			str = str.replaceAll(">","&gt;");
		}		
		
		return str;
	}	
%>					
					
					

