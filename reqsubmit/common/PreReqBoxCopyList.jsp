<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.bf.config.*"%>
<%@ page import="kr.co.kcc.pf.util.PageCount"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%
 UserInfoDelegate objUserInfo =null;
 CDInfoDelegate objCdinfo =null;
%>
<%@ include file="./RUserCodeInfoInc.jsp" %>
<%
 /*************************************************************************************************/
 /** 					�Ķ���� üũ Part 														  */
 /*************************************************************************************************/
 String strReqBoxID=StringUtil.getEmptyIfNull((String)request.getParameter("ReqBoxID")); /** ������ �䱸��ID */
 String strCmtOrganID=StringUtil.getEmptyIfNull((String)request.getParameter("CmtOrganID")); /** ���� ����ȸID */
 String strCmtOrganNM=StringUtil.getEmptyIfNull((String)request.getParameter("CmtOrganNM")); /** ���� ����ȸNM */
 String strNatCnt=StringUtil.getEmptyIfNull((String)request.getParameter("NatCnt"));	/** ȸ�� */
 String[] strSubmtOrganIDs=request.getParameterValues("SubmtOrganIDs");/**  ���õ� ������ ����Ʈ  */
 
 if(!StringUtil.isAssigned(strReqBoxID)){
 	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	objMsgBean.setStrCode("DSPARAM-0020");
  	//objMsgBean.setStrMsg(objAppEx.getMessage());
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%  	
  	return;  
 }
%>
<% 
 /*************************************************************************************************/
 /** 					������ ȣ�� Part 														  */
 /*************************************************************************************************/
 /******** ������ ���� �����̳� ���� *********/
 ResultSetHelper objCmtRs=null;        /** �Ҽ� ����ȸ ����Ʈ ��¿� RsHelper */
 ResultSetHelper objSubmtOrganXRs=null; /** ������ ����Ʈ ��¿� RsHelper */
 ResultSetHelper objSubmtOrganRs=null; /** ���õ� ������ ����Ʈ ��¿� RsHelper */
 try{
   /********* �븮�� ���� ���� *********/
   OrganInfoDelegate objOrganInfo=new OrganInfoDelegate();   /** ������� ��¿� �븮�� */
   if(strCmtOrganID.equals("")){
	   /********* ���������� **************/
	   objCmtRs=new ResultSetHelper(objUserInfo.getCurrentCMTList());   /** �Ҽ� ����ȸ */
	   if(objCmtRs.next()){
	   	strCmtOrganID=(String)objCmtRs.getObject("ORGAN_ID");
	   }
   }
   objCmtRs=new ResultSetHelper(objOrganInfo.getCmtOrganList());   /** ��ü ����ȸ */
   objSubmtOrganXRs=new ResultSetHelper(objOrganInfo.getSubmtOrganList(strCmtOrganID));/**����������Ʈ*/
   objSubmtOrganRs=new ResultSetHelper(objOrganInfo.getOrganList(strSubmtOrganIDs));/** ���õ�����������Ʈ*/
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

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>�䱸�� ����</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script language="JavaScript">
<!--
  /** ����������Ʈ ���. */
  function changeSubmtOrganList(){
  	formName.action="<%=request.getRequestURI()%>";
	for(var j=0;j<formName.SubmtOrganIDs.options.length;j++){
	   formName.SubmtOrganIDs.options[j].selected=true;
	}
	if(formName.NatCnt.value==""){
	  alert("ȸ�⸦ �Է��ϼ���");
	  formName.NatCnt.focuse();
	  return false;
	}
	if(formName.SubmtOrganIDs.options.length<1){
	    alert("�䱸���� ������ �������� �������ּ���");
		return false;
	}
  	formName.submit();
  }
   /** �䱸�� ���� ��ư ����*/
   function copyReqBox(){
	for(var j=0;j<formName.SubmtOrganIDs.options.length;j++){
	   formName.SubmtOrganIDs.options[j].selected=true;
	}
	if(formName.NatCnt.value==""){
	  alert("ȸ�⸦ �Է��ϼ���");
	  formName.NatCnt.focus();
	  return false;
	}
	if(formName.SubmtOrganIDs.options.length<1){
	    alert("�䱸���� ������ �������� �������ּ���");
		return false;
	}
	
	formName.action="./PreReqBoxCopyProc.jsp";
	formName.submit();
   }//endfunc
   
   function gotoRight(){
	var lstLen=formName.SubmtOrganIDX.length;
	var curSelected=formName.SubmtOrganIDX.selectedIndex;
	if (lstLen<1){
		alert("������ �������� �����ϴ�.");
		return;
	}
	if(curSelected<0){
		alert("������ �������� �������ּ���");
		return;
	}
	var oNewOption = new Option();
	var oSelOption = formName.SubmtOrganIDX.item(curSelected);
	var i=0;
	for(i=0;i<formName.SubmtOrganIDs.options.length;i++){
	   var tmpOrganID=formName.SubmtOrganIDs.item(i);
	   if(tmpOrganID.value==oSelOption.value){
	      alert("\"" + oSelOption.text + "\" ��(��) ���õ� �������Դϴ�");
	      return false;
	   }
	}
	oNewOption.value =oSelOption.value;
	oNewOption.text =oSelOption.text;
	formName.SubmtOrganIDs.add(oNewOption);	
   }//endfunc
   
   function gotoLeft(){
	var lstLen=formName.SubmtOrganIDs.length;
	var curSelected=formName.SubmtOrganIDs.selectedIndex;
	if (lstLen<1){
		alert("������ �������� �����ϴ�");
		return;
	}
	if(curSelected<0){
		alert("������ �������� �������ּ���");
		return;
	}
	formName.SubmtOrganIDs.options.remove(curSelected);
	formName.SubmtOrganIDs.focus();
   }//endfunc
   
 
   
   
//-->
</script>
<script language=Javascript src="/js/reqsubmit/common.js"></script>
<link href="/css/System.css" rel="stylesheet" type="text/css">
</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="formName.NatCnt.focus();">
<table width="529" border="0" cellspacing="0" cellpadding="0" scrolling="yes">
  <tr class="td_reqsubmit"> 
    <td height="5"></td>
    <td height="5"></td>
  </tr>
  <tr> 
    <td width="14" height="10"></td>
    <td width="515" height="10"></td>
  </tr>
  <tr> 
    <td width="14">&nbsp;</td>
    <td height="25" valign="middle"><img src="/image/reqsubmit/icon_reqsubmit_soti.gif" width="9" height="9" align="absmiddle"> 
      <span class="soti_reqsubmit"> �䱸�� ����</span></td>
  </tr>
  <tr> 
    <td width="14" height="5"></td>
    <td height="14" class="text_s">&nbsp;���� �������� ȸ��� ������ �䱸�� ������ŭ�� �������� ������ �ּ���</td>
  </tr>
<form name="formName" method="post" action="<%=request.getRequestURI()%>">  
 <input type="hidden" name="ReqBoxID" value="<%=strReqBoxID%>">
  <tr> 
    <td height="5"></td>
    <td height="5" align="left" valign="middle">&nbsp;&nbsp;<img src="/image/common/icon_nemo_gray.gif" width="3" height="6" align="absmiddle"> 
      <strong>ȸ�� : ��  <input name="NatCnt" size="3" maxlength="3" type="text"  value="<%=strNatCnt%>" onKeyUp="CheckNumeric(this);" class="textfield" style="WIDTH: 50px"> ȸ ��ȸ</strong></td>
  </tr>
  <tr> 
    <td width="14" height="10"></td>
    <td height="10" align="left" valign="top"></td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
    <td height="23" align="left" valign="top"><table width="500" height="225" border="0" cellpadding="0" cellspacing="0">
        <tr align="left" valign="top"> 
          <td width="44%" height="225"><table width="100%" height="104" border="0" cellpadding="0" cellspacing="1" bgcolor="CCCCCC" class="td_reqsubmit">
              <tr> 
                <td height="30" align="center" bgcolor="#F3F3F3" class="td_gray1">
                  <%=strCmtOrganNM%></td>
              </tr>
              <tr> 
                <td height="200" align="left" valign="top" bgcolor="ffffff"> 
                <select name="SubmtOrganIDX" multiple size="1"  style="WIDTH: 100% ; height: 220" >
			<%
			   /**������ ����Ʈ ��� */
			   while(objSubmtOrganXRs!=null && objSubmtOrganXRs.next()){
		   		String strSubmitOrganID=(String)objSubmtOrganXRs.getObject("SUBMT_ORGAN_ID");
		   		String strSubmitOrganNM=(String)objSubmtOrganXRs.getObject("SUBMT_ORGAN_NM");
		   		out.println("<option value=\"" + strSubmitOrganID + "\" >" + strSubmitOrganNM.trim() + "</option>");
			   }
			%>																							
                </select>
                </td>
              </tr>
            </table></td>
          <td width="12%" height="225" align="center" valign="middle"><table width="44" border="0" cellspacing="3" cellpadding="0">
              <tr> 
                <td><img src="/image/button/bt_add_admin.gif" width="38" height="18" onClick="gotoRight();" style="cursor:hand"></td>
              </tr>
              <tr> 
                <td height="5"></td>
              </tr>
              <tr> 
                <td><img src="/image/button/bt_cancel_admin.gif" width="38" height="18"  onClick="gotoLeft();" style="cursor:hand"></td>
              </tr>
            </table></td>
          <td width="44%" align="right"><table width="100%" height="104" border="0" cellpadding="0" cellspacing="1" bgcolor="CCCCCC" class="td_reqsubmit">
              <tr> 
                <td height="30" align="center" bgcolor="#F3F3F3" class="td_gray1">������</td>
              </tr>
              <tr> 
                <td height="220" align="left" valign="top" bgcolor="ffffff">
                <select name="SubmtOrganIDs" multiple style="WIDTH: 100% ; height: 220">
			<%		
			   /**������ ����Ʈ ��� */
			   while(objSubmtOrganRs!=null && objSubmtOrganRs.next()){
		   		String strSubmitOrganID=(String)objSubmtOrganRs.getObject("ORGAN_ID");
		   		String strSubmitOrganNM=(String)objSubmtOrganRs.getObject("ORGAN_NM");
		   		out.println("<option value=\"" + strSubmitOrganID + "\" >" + strSubmitOrganNM.trim() + "</option>");
			   }
			   
			%>																							
                </select>
                </td>
              </tr>
            </table></td>
        </tr>
      </table></td>
  </tr>
  <tr height="10"> 
    <td height="10"></td>
    <td height="10" align="left" valign="top"></td>
  </tr>
  <tr> 
    <td width="14" height="20">&nbsp;</td>
    <td height="40" align="left"><table width="96%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td height="25" align="right">&nbsp;<img src="/image/button/bt_copy.gif" width="42" height="20" onClick="copyReqBox()" style="cursor:hand"></td>
        </tr>
      </table></td>
  </tr>
</form>  
  <tr> 
    <td height="25" colspan="2" align="right" class="td_gray1">&nbsp;<img src="/image/button/bt_close.gif" width="46" height="11" border="0" onClick="self.close();" style="cursor:hand">&nbsp;&nbsp;</td>
  </tr>
</table>
</body>
</html>
