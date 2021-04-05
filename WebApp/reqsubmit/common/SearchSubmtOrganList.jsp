<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.bf.config.*"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%
 /*************************************************************************************************/
 /** 					�Ķ���� üũ Part 														  */
 /*************************************************************************************************/
  /** �˻���(��������) */
  String strSubmtOrganNm=StringUtil.getEmptyIfNull(request.getParameter("SubmtOrganNm"));
%>
<% 
 /*************************************************************************************************/
 /** 					������ ȣ�� Part 														  */
 /*************************************************************************************************/

 /*** Delegate �� ������ Container��ü ���� */
 ResultSetHelper objRs=null;	/* ��������� */
 
 /** �˻�� �ִ� ��츸 */
 if(StringUtil.isAssigned(strSubmtOrganNm)){
	 try{
	   OrganInfoDelegate objOrganInfo=new OrganInfoDelegate();
	   objRs=new ResultSetHelper(objOrganInfo.getSubmtOrganListByName(strSubmtOrganNm));
	 }catch(AppException objAppEx){
	 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
	  	objMsgBean.setStrCode(objAppEx.getStrErrCode());
	  	objMsgBean.setStrMsg(objAppEx.getMessage());
	  	%>
	  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
	  	<%  	
	  	return;
	 }
 }
%>
<!DOCTYPE HTML PUBLIC "-//w3c//dtd html 4.0 transitional//en">
<html>
<head>
<title>������ ��ȸ</title>
<link href="/css/System.css" rel="stylesheet" type="text/css">
<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>
<SCRIPT language="JavaScript">
  /** ��������ȸ */
  function searchSubmt(){
  	if(formName.SubmtOrganNm.value==""){
  		alert("��ȸ�� ���������� �Է����ּ���");
  		formName.SubmtOrganNm.focus();
  		return false;
  	}
  	formName.submit();
  }
  /** ����ȸ �� ������ ���� */
  function setSubmtOrgan(strSubmtOrganID,strCmtOrganID){
  	opener.formName.SubmtOrganIDX.value=strSubmtOrganID;
  	if(opener.formName.CmtOrganIDX==null){
  	   opener.formName.CmtOrganID.value=strCmtOrganID;
  	}else{
  	   opener.formName.CmtOrganIDX.value=strCmtOrganID;
  	}
  	opener.formName.submit();
  	self.close();
  }
</SCRIPT>
</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="300" border="0" cellspacing="0" cellpadding="0"  scrolling="yes">
  <tr class="td_reqsubmit"> 
    <td height="5"></td>
    <td height="5"></td>
  </tr>
  <tr> 
    <td width="14" height="10"></td>
    <td width="286" height="10"></td>
  </tr>
  <tr> 
    <td width="14">&nbsp;</td>
    <td height="25" valign="middle"><img src="/image/reqsubmit/icon_reqsubmit_soti.gif" width="9" height="9" align="absmiddle"> 
      <span class="soti_reqsubmit">��������ȸ</span></td>
  </tr>
  <tr>
    <form name="formName" method="post" action="<%=request.getRequestURI()%>">
    <td width="14" height="5"></td>
    <td height="14" class="text_s">
    	<table border="0">
    	<tr>
    		<td><input type="text" value="<%=strSubmtOrganNm%>" name="SubmtOrganNm" size="28" class="textfield"></td>
    		<td><img src="/image/button/bt_inquiry.gif" height="20"  style="cursor:hand" onClick="searchSubmt();"></td>
    	</tr>
        </table>
    </td>
    </form>
  </tr>
<%
 if(objRs!=null){//�˻���� ��ȸ�������
%>  
  <tr> 
    <td width="14">&nbsp;</td>
    <td height="23" align="left" valign="top">
    	<TABLE cellSpacing=0 cellPadding=0 width="286" border=0>
        <TBODY>
          <TR> 
            <TD class=td_reqsubmit height=2></TD>
          </TR>
       <%
         if(objRs.getRecordSize()>0){
         	while(objRs.next()){
       %>
          <TR onmouseover="this.style.backgroundColor='#FCFDF0'"  onmouseout="this.style.backgroundColor=''"> 
            <TD height="22">
            	<a href="javascript:setSubmtOrgan('<%=objRs.getObject("SUBMT_ORGAN_ID")%>','<%=objRs.getObject("CMT_ORGAN_ID")%>')"><%=objRs.getObject("SUBMT_ORGAN_NM")%>(<%=objRs.getObject("CMT_ORGAN_NM")%>)</a>
            </TD>
          </TR>
          <TR class=tbl-line> 
            <TD height=1></TD>
          </TR>
		<%
		    }//endwhile
		  }else{
		%> 
		  <TR onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''">
			<TD align="center">��ȸ�� �������� �����ϴ�.</TD>
		  </TR>
          <TR class=tbl-line> 
            <TD height=1></TD>
          </TR>
		<%
		}//end if ��� ��� ��.
		%>		         
          <TR class=tbl-line> 
            <TD height=1></TD>
          </TR>
        </TBODY>
      </TABLE></td>
  </tr>
<%
 } else { //endif �����ȸ.
%>
 	<tr>
 		<td height="158"></td>
 	</tr>
<%
 }
%>  
  <tr> 
    <td height="25" colspan="2" align="right" class="td_gray1">&nbsp;<img src="/image/button/bt_close.gif" width="46" height="11" border="0" style="cursor:hand" onClick="self.close();">&nbsp;&nbsp;</td>
  </tr>
</table>
</body>
</html>  
