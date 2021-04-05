<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.bf.config.*"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.params.cmtsubmt.CmtSubmitReqBoxApplyForm"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.cmtsubmt.CmtSubmtReqBoxDelegate" %>
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
  String strRightNow=(String)request.getParameter("RightNow");//���ó���Ұ����� ���� ��ȯ. Yes
  String strAuditYear = (String)request.getParameter("AuditYear");
  
  CmtSubmitReqBoxApplyForm objParams =new CmtSubmitReqBoxApplyForm();  
  boolean blnParamCheck=false;
  /**���޵� �ĸ����� üũ */
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
%>
<%
 /*************************************************************************************************/
 /** 					������ ó�� Part 														  */
 /*************************************************************************************************/
 String strOffiDocNo=null; //������ȣ.
 String strGovStdCD=null;//���������ڵ�
 String strReqScheID=null;  //ó���� �䱸������ ID
 String[] strPdfInfoArr=null;
 
 String strCmtOrganNM="";//����ȸ�� (���ڰ����) ORGAN_NM
 String strCmtGovStdCD=""; //����ȸ GCC�ڵ� (���ڰ����) GOV_STD_CD
 try{
   /********* �븮�� ���� ���� *********/
   CmtSubmtReqBoxDelegate objReqBox=new CmtSubmtReqBoxDelegate();
   /** 1.����ȸ ����Ȯ�� */
   strReqScheID = objReqBox.checkHavingCommSche(objParams.getParamValue("CmtOrganID"), strAuditYear);
   if(!StringUtil.isAssigned(strReqScheID)){
 	objMsgBean.setMsgType(MessageBean.TYPE_INFO);
  	objMsgBean.setStrCode("DSDATA-0020");
  	objMsgBean.setStrMsg("�������� ����ȸ ������ �����ϴ�.");
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%  	
  	return; 
   }
   /** 2.����ȸ �����û�� ����� */
   strPdfInfoArr=objReqBox.getApplyPdfDocEncBase64(objUserInfo.getUserID(),objParams.getParamValue("ReqBoxID"));
   
    /** ��� �Ϸ� ó���Ұ�� */
   if(StringUtil.isAssigned(strRightNow)){
   	   /** 3.1 ��� ó�� ==> ���º����� ����ȸ�䱸�� �Է��ϱ�. */
	   objReqBox.approveCmtSubmtReqBox(objParams.getParamValue("ReqBoxID"), true);
   }else{
   	  OrganInfoDelegate objOrganInfo=new OrganInfoDelegate();
   	  Hashtable objHashCmtOrgan=objOrganInfo.getOrganInfo(objParams.getParamValue("CmtOrganID"));
   	  if(objHashCmtOrgan!=null && objHashCmtOrgan.size()>0){
	   	  strCmtOrganNM=(String)objHashCmtOrgan.get("ORGAN_NM");//����ȸ�� (���ڰ����) 
	      strCmtGovStdCD=(String)objHashCmtOrgan.get("GOV_STD_CD"); //����ȸ GCC�ڵ� (���ڰ����) 
      }
	   
	   /** 3.2 ���ڰ���� Form ���޳��� ����� ==> ���º��� ��û��. */
   	  //�Ʒ� HTML���·� ���� �ڵ� �����ϰ���.   
   	  String[] strArr=objReqBox.getElectInfo(objUserInfo.getOrganID(),objParams.getParamValue("ReqBoxID")); 
   	  //[0] �ű� ���� ��ȣ,  [1] ����� ���������ڵ�
   	  strOffiDocNo=strArr[0];
   	  strGovStdCD=strArr[1];
   }
 }catch(AppException objEx){ 
 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  	objMsgBean.setStrCode(objEx.getStrErrCode());
  	objMsgBean.setStrMsg(objEx.getMessage());
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%  	
  	return; 
 }
  String strFormType="hidden";
%>
<%
 /** ��� �Ϸ� ó���Ұ�� */
 if(StringUtil.isAssigned(strRightNow)){
%>
<html>
<head>
<title>���������� ���� ����ȸ �����û�� �߼�</title>
<link href="/css/System.css" rel="stylesheet" type="text/css">
<script language="javascript">
	function selfClose(){
	  //opener.location.reload();
	  opener.location.href='/reqsubmit/10_mem/20_reqboxsh/40_commreq/RCommReqList.jsp?AuditYear=<%= strAuditYear %>&CmtOrganID=<%= objParams.getParamValue("CmtOrganID") %>';
	  self.close();
	}
</script>
</head>
<body leftmargin="0" topmargin="0">
<center>
<table border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td width="280" height="30" align="center">
			<table border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td width="280" height="35" bgcolor="#f4f4f4" align="center"><span class="title">����ȸ ���� ��û</span></td>
				</tr>
				<tr><td height="1" bgcolor="#c0c0c0"></td></tr>
			</table>
		</td>
	</tr>
	<tr>
		<td height="10" bgcolor="#ffffff"></td>
	</tr>
	<tr>
		<td align="center" height="160">
			����ȸ ���� ��û�� ó���� �Ϸ�Ǿ����ϴ�.
			<p>
			<a href="javascript:selfClose()">[close]</a>
		</td>
	</tr>
</table>
</center>
</body>
</html>
<%
 }else{//���ڰ��縦 ������ ��� 
%>
<html>
<head>
<title>���ڰ��縦 ���� ����ȸ �����û�� �߼�</title>
<script language="javascript">
   function addAcube(formName){   		 
		 if(confirm("POP-UP Ȯ��")==true){
			   addAcube = window.open("http://docs.assembly.go.kr/acubecn/legacy/ACN_LegacyBridge.jsp","addAcube",
				   										 "resizable=yes,menubar=yes,status=yes,titlebar=yes, scrollbars=yes,location=yes,toolbar=yes,height=500,width=800");
				formName.target="addAcube";
				formName.submit();
		 }
   }
   function submitAcube(){
   		opener.location.reload();
   		formName.submit();
   }
</script>
</head>
<body leftmargin="0" topmargin="0" onload="submitAcube();">
<table>
			<form name="formName" method="POST" action="http://docs.assembly.go.kr/acubecn/legacy/ACN_LegacyBridge.jsp" >				
				   <input type="<%=strFormType%>" name="systemid" size="20"  value="request_send"><br>
    		       <input type="<%=strFormType%>" name="businessid" size="20"  value="request_in_comm"><br>
    		       <input type="<%=strFormType%>" name="cssversion" size="20"  value="2.0">
   				   <input type="<%=strFormType%>" name="formversion" size="20"  value="1.0"><br>
   				   <input type="<%=strFormType%>" name="title" size="20"  value="����ȸ �����û��"><br>
   				   <input type="<%=strFormType%>" name="method" size="20"  value="file"><br>
   				   <input type="<%=strFormType%>" name="recipients" size="20"  value="<%=strCmtGovStdCD%>"><br>
   				   <input type="<%=strFormType%>" name="recipnames" size="20"  value="<%=strCmtOrganNM%>"><br>   				   
				   <textarea name="legacyout" cols="110" rows="10" OnFocus="this.select();" this.style.visibility="hidden"><?xml version="1.0" encoding="euc-kr"?><REQUEST_IN_COMM><DOC_SUBMIT><SUID><%=strOffiDocNo%></SUID></DOC_SUBMIT></REQUEST_IN_COMM></textarea><br>
					<textarea name="attaches" cols="110" rows="10" OnFocus="this.select();" this.style.visibility="hidden"><?xml version='1.0' encoding='euc-kr'?><GENERAL_ATTACHES><GENERAL_ATTACH METHOD='add' MODIFY=''><DISPLAY_NAME><![CDATA[<%=strPdfInfoArr[2]%>]]></DISPLAY_NAME><FILE_NAME><%=strPdfInfoArr[2]%></FILE_NAME><FILE_SIZE><%=strPdfInfoArr[0]%></FILE_SIZE><FILE_BASE64_DATA><%=strPdfInfoArr[1]%></FILE_BASE64_DATA></GENERAL_ATTACH></GENERAL_ATTACHES></textarea><br>
			    <INPUT id="deptcode" name="deptcode" type="<%=strFormType%>" value="<%=strGovStdCD%>"><br><!-- GOV_STD_CD (����ǥ���ڵ�) -->
			    <!--
				<input type="submit" value="������" style="cursor:hand" ><br>
                <input type="button" name="Button" value="POP-UP������" style="cursor:hand" OnClick="javascript:addAcube(form1);">
                -->
		</form>
</body>
</html>
<%
 }//endif ���ڰ��� ���� üũ ��.
%>

