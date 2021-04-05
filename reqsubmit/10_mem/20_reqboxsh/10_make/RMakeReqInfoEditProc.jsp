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
<%@ page import="nads.lib.reqsubmit.params.requestinfo.RMemReqInfoVListForm" %>
<%@ page import="nads.lib.reqsubmit.params.requestinfo.RMemReqInfoEditForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.MemRequestInfoDelegate" %>
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
  RMemReqInfoVListForm objParams =new RMemReqInfoVListForm();  
  boolean blnParamCheck=false;
  /**���޵� �ĸ����� üũ */
  nads.lib.reqsubmit.form.RequestWrapper objRequestWrapper=null;
  try{
  	objRequestWrapper=
  	new nads.lib.reqsubmit.form.RequestWrapper(request);
  }catch(java.io.IOException ex){
  	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	objMsgBean.setStrCode("DSPARAM-0010");
  	objMsgBean.setStrMsg("���ε��� ���ϻ���� �ʰ��Ͽ����ϴ�. ���ѵ� ���ϻ���� Ȯ���� �ּ���!!");
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%
  	return;  	
  }
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
  RMemReqInfoEditForm objEditParams =new RMemReqInfoEditForm();  
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
   MemRequestInfoDelegate objReqInfo=new MemRequestInfoDelegate();   /** �䱸 ���� ������ */

   /********* ������ ��� �ϱ�  **************/
   String strCont = (String)objEditParams.getParamValue("ReqDtlCont");
   String strFileName = (String)objEditParams.getParamValue("AnsEstyleFilePath");

   System.out.println("strFileName : " +strFileName);
   boolean flag = true;
   if(strFileName != null && !strFileName.equals("")){
	   flag = false;
	   String[] strExtensions = nads.lib.reqsubmit.util.StringUtil.split(".",strFileName);
	   String strExtension = strExtensions[1];
	   strExtension = strExtension.toLowerCase();
	   String[] strEx = {"hwp", "pdf", "zip", "alz", "doc", "ppt", "xls", "txt"};

	   for(int i = 0; i < strEx.length ; i++){
		   if(strEx[i].equals(strExtension)){
			   flag = true;
		   }
	   }
   }
   
   if(flag == false){
		out.println("<script language=javascript>");
		out.println("alert('hwp,pdf,zip,alz,doc,ppt,xls,txt ������ ���ϸ� ���ε尡���մϴ�.');");
		out.println("history.go(-2);");
		out.println("</script>");
		return;
   }

   System.out.println("reqcont : "+this.replaceXss((String)objEditParams.getParamValue("ReqCont"))); 
   System.out.println("ReqDtlCont : "+this.replaceXss((String)objEditParams.getParamValue("ReqDtlCont"))); 

   objEditParams.setParamValue("ReqDtlCont",this.replaceXss((String)objEditParams.getParamValue("ReqDtlCont")));
   objEditParams.setParamValue("ReqCont",this.replaceXss((String)objEditParams.getParamValue("ReqCont")));
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
	System.out.println("SysErrorCode:" + objAppEx.getStrErrCode());
  	objMsgBean.setStrCode("SYS-00010");//AppException����.
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
				<form name="formName" method="<%=nads.lib.reqsubmit.EnvConstants.FORM_METHOD%>" action="./RMakeReqInfoVList.jsp" ><!--�䱸�� �ű����� ���� -->
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