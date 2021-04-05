<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RCommReqBoxVListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.CommRequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.CommRequestInfoDelegate" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%
 UserInfoDelegate objUserInfo =null;
 CDInfoDelegate objCdinfo =null;
%>
<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>

<%
  /**�Ϲ� �䱸�� �󼼺��� �Ķ���� ����.*/
  RCommReqBoxVListForm objParams =new RCommReqBoxVListForm();  
  
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
%>
<% 
  //�α��� ����� ������ �����´�. ���Ѿ��� ��� ������ �����ϴ�.
  String strReqSubmitFlag = objUserInfo.getReqSubmitFlag(); 
  
 /*** Delegate �� ������ Container��ü ���� */
 CommRequestBoxDelegate objReqBox=null; 		/**�䱸�� Delegate*/
 CommRequestInfoDelegate  objReqInfo=null;		/** �䱸���� Delegate */
 ResultSetSingleHelper objRsSH=null;			/** �䱸�� �󼼺��� ���� */
 ResultSetSingleHelper objRsRI=null;			/** �䱸 �󼼺��� ���� */
 ResultSetSingleHelper objRsCS=null;			/** �䱸 �󼼺��� ���� */
 String strRefReqID ="";
 
 try{
   /**�䱸�� ���� �븮�� New */
   objReqBox=new CommRequestBoxDelegate();
   /**�䱸�� �̿� ���� üũ */

   boolean blnHashAuth=objReqBox.checkReqBoxAuth((String)objParams.getParamValue("ReqBoxID"),objUserInfo.getCurrentCMTList()).booleanValue();
   if(!blnHashAuth){
      objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	  objMsgBean.setStrCode("DSAUTH-0001");
  	  objMsgBean.setStrMsg("�ش� �䱸���� �� ������ �����ϴ�.");
  	  out.println("�ش� �䱸���� �� ������ �����ϴ�.");
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%
      return;
  }else{
   /** �䱸�� ���� */
    objRsSH=new ResultSetSingleHelper(objReqBox.getRecord((String)objParams.getParamValue("ReqBoxID")));
   /**�䱸 ���� �븮�� New */    
    objReqInfo=new CommRequestInfoDelegate();
	objRsRI=new ResultSetSingleHelper(objReqInfo.getRecord((String)objParams.getParamValue("CommReqID")));   
	strRefReqID = (String)objRsRI.getObject("REF_REQ_ID");
    objRsCS=new ResultSetSingleHelper(objReqInfo.getCmtSubmt((String)objParams.getParamValue("CommReqID"),strRefReqID));
	 
  }/**���� endif*/
 }catch(AppException objAppEx){
 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  	objMsgBean.setStrCode(objAppEx.getStrErrCode());
  	objMsgBean.setStrMsg(objAppEx.getMessage());
  	out.println("<br>Error!!!" + objAppEx.getMessage());
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%  	
  	return;
 }
 String strIngStt=(String)objRsSH.getObject("ING_STT");
 String strCmt = (String)objRsCS.getObject("CMT_SUBMT_REQ_ID");
 
 // 2005-08-09 kogaeng ADD
 // ��Ȯ�� �䱸�� ã�ư��� �ϱ� ���� �䱸�� ���� ���� ���� �� ����
 String strReqBoxStt = (String)objRsSH.getObject("REQ_BOX_STT");
%>

<html>
<head>
<title><%=MenuConstants.REQUEST_BOX_COMM%> > <%=MenuConstants.REQ_BOX_DETAIL_VIEW%></title>
<link href="/css/System.css" rel="stylesheet" type="text/css">
<script language="javascript">
//������� ������������ ����
function openCLUp(){
	form = document.formName; 
	form.action="/reqsubmit/20_comm/20_reqboxsh/ROpenCLProc.jsp";
	form.target=""; 	
	form.submit();
}
  /**�䱸���� ������������ ����.*/
  function gotoEdit(){
  	formName.action="/reqsubmit/20_comm/20_reqboxsh/RCommReqInfoEdit.jsp";
	formName.target="";   	
  	formName.submit();
  }
  
  /**�䱸�� ����*/
  function gotoReqBox(){
  	form = document.formName; 
  	form.action="./RAccBoxConfirmVList.jsp";
	form.target="";  	
  	form.submit();
  } 
  
  /**�䱸������������ ����.*/
  function gotoDelete(){
  	formName.action="/reqsubmit/20_comm/20_reqboxsh/RCommReqDelProc.jsp";
	formName.target="";
  	formName.submit();
  }
     
  function showDelMoreInfoDiv() {
	  document.all.delMoreInfoDiv.style.display = '';
  }

  function FinalSubmit() {
	  var f = document.formName;
	<%if(!"".equalsIgnoreCase(strCmt)){%>	
		if (f.elements['Rsn'].value == "") {
			f.elements['Rsn'].value = "���� ���� ����";
			//return;
		}
	<% } %>		  
	  f.action = "/reqsubmit/20_comm/20_reqboxsh/RCommReqDelProc.jsp";
	  f.target = "";
	  if (confirm("�䱸 ������ �����Ͻðڽ��ϱ�?")) f.submit();
  }

  function hiddenDelMoreInfoDiv() {
	  document.all.delMoreInfoDiv.style.display = 'none';
  }  
</script>
</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<SCRIPT language="JavaScript" src="/js/reqinfo.js"></SCRIPT>
<%@ include file="/reqsubmit/common/MenuTopReqsubmit.jsp" %>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
<tr align="left" valign="top">
	<td width="186" height="470" background="/image/common/bg_leftMenu.gif">
	<%@ include file="/reqsubmit/common/MenuLeftReqsubmit.jsp" %>
   	<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT></td>	
<!------- 2004-06-02 ������ �������� ���� ����� �κ� ���� ------->
	<td width="100%">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr height="24" valign="top"> 
    	<td height="24" colspan="2" align="left"><table width="789" height="24" border="0" cellpadding="0" cellspacing="0" bgcolor="DEEFCC">
    <tr>
    	<td height="24"></td>
	</tr>
    </table></td>
    </tr>
<!------- 2004-06-02 ������ �������� ���� ����� �κ� �� ------->
    <tr valign="top"> 
		<td width="30" align="left"><img src="/image/common/bg_leftBody.gif" width="30" height="1"></td>
		<td align="left">
		<table width="759" border="0" cellspacing="0" cellpadding="0">
		<form name="formName" method="post" action="<%=request.getRequestURI()%>">
		<%  //�䱸 ���� ���� ���� �ޱ�.
		String strCommReqInfoSortField=objParams.getParamValue("CommReqInfoSortField");
		String strCommReqInfoSortMtd=objParams.getParamValue("CommReqInfoSortMtd");
		//�䱸�� ���� ������ ��ȣ �ޱ�.
		String strCommReqInfoPagNum=objParams.getParamValue("CommReqInfoPageNum");					
		%>
		<input type="hidden" name="CommReqBoxSortField" value="<%=objParams.getParamValue("CommReqBoxSortField")%>"><!--�䱸�Ը�������ʵ� -->
		<input type="hidden" name="CommReqBoxSortMtd" value="<%=objParams.getParamValue("CommReqBoxSortMtd")%>"><!--�䱸�Ը�����ɹ��-->
		<input type="hidden" name="CommReqBoxPage" value="<%=objParams.getParamValue("CommReqBoxPage")%>"><!--�䱸�� ������ ��ȣ -->
		<input type="hidden" name="CommReqBoxQryField" value="<%=objParams.getParamValue("CommReqBoxQryField")%>"><!--�䱸�� ��ȸ�ʵ� -->
		<input type="hidden" name="CommReqBoxQryTerm" value="<%=objParams.getParamValue("CommReqBoxQryTerm")%>"><!--�䱸�� ��ȸ�� -->		
	    <input type="hidden" name="ReqBoxID" value="<%=objParams.getParamValue("ReqBoxID")%>">
	    <input type="hidden" name="CmtOrganID" value="<%=objParams.getParamValue("CmtOrganID")%>">
		<input type="hidden" name="CommReqID" value="<%=(String)objParams.getParamValue("CommReqID")%>"><!--�䱸���� ID-->
		<input type="hidden" name="RefReqID" value="<%=strRefReqID%>">	    
		<input type="hidden" name="CommReqInfoSortField" value="<%=strCommReqInfoSortField%>"><!--�䱸���� ��������ʵ� -->
		<input type="hidden" name="CommReqInfoSortMtd" value="<%=strCommReqInfoSortMtd%>"><!--�䱸���� ������ɹ��-->
		<input type="hidden" name="CommReqInfoPage" value="<%=strCommReqInfoPagNum%>"><!--�䱸���� ������ ��ȣ -->
		<input type="hidden" name="CommReqID" value="<%=objRsRI.getObject("REQ_ID")%>"><!--�䱸���� ID-->
		<input type="hidden" name="ReturnURL" value="<%=request.getRequestURI()%>">
		<input type="hidden" name="AuditYear" value="<%=objParams.getParamValue("AuditYear")%>">
		<input type="hidden" name="IngStt" value="<%=strIngStt%>">		
		<input type="hidden" name="RltdDuty" value="<%=objParams.getParamValue("RltdDuty")%>">			
		
		<input type="hidden" name="ReqBoxStt" value="<%= strReqBoxStt %>">
		
		<tr> 
			<td align="left" valign="top">
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td colspan="3" height="23px">
			</tr>
            <tr> 
				<td width="35%" background="/image/reqsubmit/bg_reqsubmit_tit.gif" height="23">
		    		<!-------------------- Ÿ��Ʋ�� �Է��� �ּ��� ------------------------>
		      		<span class="title"><%=MenuConstants.COMM_MNG_CONFIRM_END%></span>  <strong>- �䱸�󼼺���</strong>
              	</td>
              	<td width="10%" align="left" background="/image/common/bg_titLine.gif">&nbsp;</td>
              	<td width="55%" align="right" background="/image/common/bg_titLine.gif" class="text_s">
              		<!-------------------- ���� ��ġ ������ ����Ѵ�ϴ�. ------------------------>
              		<img src="/image/common/icon_navi.gif" width="3" height="5" align="absmiddle"> 
					<%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.REQUEST_BOX_COMM%> > <B><%=MenuConstants.COMM_MNG_CONFIRM_END%></B>
              	</td>
			</tr>
			</table></td>
		</tr>
		<tr> 
			<td height="30" align="left" class="text_s">
    		<!-------------------- ���� �������� ���� ���� ��� ------------------------>
    		���������� ���� �䱸������ Ȯ���ϴ� ȭ���Դϴ�.
			</td>
		</tr>
		<tr> 
			<td height="5" align="left" class="soti_reqsubmit"></td>
		</tr>
		<tr> 
			<td height="30" align="left" class="soti_reqsubmit">
	        	<!-------------------- TAB �� �ش��ϴ� ������ ����ϴ� ��������. ------------------------>
	        	<img src="/image/reqsubmit/icon_reqsubmit_soti.gif" width="9" height="9" align="absmiddle"> 
                  �䱸�� ����
			</td>
		</tr>
		<tr> 
			<td align="left" valign="top" class="soti_reqsubmit">
			<!------------------------- TAB�� �ش��ϴ� ���̺�(����̵� ������̵� ��������) ��� ��~~~�� ------------------------->
			<table width="680" border="0" cellspacing="0" cellpadding="0">
            <tr class="td_reqsubmit"> 
              <td width="149" height="2"></td>
              <td height="2" colspan="3"></td>
            </tr>
			<%
				if(!objRsSH.next()){
			%>
			<tr>
				<td height="25" class="td_gray1">�䱸�� ���� �� �����ϴ�.</td>
			</tr>
			<%
				}else{
			%>
			<tr> 
				<td width="100" height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
				�䱸�Ը� </td>
				<td width="580" height="25" colspan="3" class="td_lmagin"><B><%=objRsSH.getObject("REQ_BOX_NM")%></B>
				</td>
			</tr>
            <tr height="1" class="tbl-line"> 
              	<td height="1" colspan="4"></td>
            </tr>
			<tr> 
				<td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
				�������� </td>
				<td height="25" colspan="3" class="td_lmagin">
               	<%=objCdinfo.getRelatedDuty((String)objRsSH.getObject("RLTD_DUTY"))%>
				</td>
			</tr>
            <tr height="1" class="tbl-line"> 
              	<td height="1" colspan="4"></td>
            </tr>             
            <tr> 
              	<td width="100" height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                �䱸��� </td>
              	<td width="240" height="25" class="td_lmagin">
           	   	<%=objRsSH.getObject("CMT_ORGAN_NM")%>
              	</td>
              	<td width="100" height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                ������ </td>
              	<td width="240" height="25" class="td_lmagin">
              	<%=(String)objRsSH.getObject("SUBMT_ORGAN_NM")%>
              	</td> 
            </tr>
            <tr height="1" class="tbl-line"> 
              	<td height="1" colspan="4"></td>
            </tr>
            <tr> 
              	<td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                �������� </td>
              	<td height="25" class="td_lmagin">
              	<%=StringUtil.getDate((String)objRsSH.getObject("ACPT_BGN_DT"))%>
              	</td>
              	<td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                �������� </td>
              	<td height="25" class="td_lmagin">
              	<%=StringUtil.getDate((String)objRsSH.getObject("ACPT_END_DT"))%>
              	</td> 
            </tr>
			<%
			}/** �䱸�� ���� �� ������. */
			%>
			<!------------------------- TAB�� �ش��ϴ� ���̺�(����̵� ������̵� ��������) ��� �� ------------------------->                   
            <tr height="1" class="tbl-line"> 
              	<td height="2" colspan="4"></td>
            </tr>
			</table>
        	</td>
		</tr>
		<tr>
		   	<!-- �����̽���ĭ -->
		   	<td>&nbsp;</td>
		   	<!-- �����̽���ĭ -->
		</tr>
		<tr> 
			<td height="30" align="left" class="soti_reqsubmit">
            <!-------------------- TAB �� �ش��ϴ� ������ ����ϴ� ��������. ------------------------>
	       	<img src="/image/reqsubmit/icon_reqsubmit_soti.gif" width="9" height="9" align="absmiddle"> 
            �䱸 ����</td>
		</tr>
		<tr> 
			<td align="left" valign="top" class="soti_reqsubmit">
			<!------------------------- TAB�� �ش��ϴ� ���̺�(����̵� ������̵� ��������) ��� ��~~~�� ------------------------->
			<table width="680" border="0" cellspacing="0" cellpadding="0">
            <tr class="td_reqsubmit"> 
              <td height="2" colspan="4"></td>
            </tr>
			<%
				if(!objRsRI.next()){
			%>
			<tr>
				<td height="35" class="td_gray1" colspan="4">�䱸 ���� �� �����ϴ�.</td>
			</tr>
			<%
				}else{
			%>
			<tr> 
				<td width="100" height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
				�䱸����</td>
				<td width="580" height="25" colspan="3" class="td_lmagin"><B><%=objRsRI.getObject("REQ_CONT")%></B>
				</td>
			</tr>
            <tr height="1" class="tbl-line"> 
              	<td height="1" colspan="4"></td>
            </tr>
			<tr> 
				<td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
				�䱸����</td>
				<td height="25" colspan="3" class="td_lmagin" style="padding-top:5px;padding-bottom:5px">
				<%=StringUtil.getDescString((String)objRsRI.getObject("REQ_DTL_CONT"))%>
				</td>
			</tr>
            <tr height="1" class="tbl-line"> 
              	<td height="1" colspan="4"></td>
            </tr>
             <tr> 
              	<td width="100" height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                �������</td>
              	<td width="240" height="25" class="td_lmagin">
   	   	        <%=CodeConstants.getOpenClass((String)objRsRI.getObject("OPEN_CL"))%>
              	</td>
              	<td width="100" height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                �������</td>
              	<td width="240" height="25" class="td_lmagin">
              	<%=StringUtil.getDate2((String)objRsSH.getObject("REG_DT"))%>
              	</td> 
            </tr>
            <tr height="1" class="tbl-line"> 
              	<td height="1" colspan="4"></td>
            </tr>
			<tr> 
				<td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
				����������</td>
				<td height="25" colspan="3" class="td_lmagin">
				<%=StringUtil.makeAttachedFileLink((String)objRsRI.getObject("ANS_ESTYLE_FILE_PATH"),(String)objRsRI.getObject("REQ_ID"))%>
				</td>
			</tr>
            <tr height="1" class="tbl-line"> 
              	<td height="1" colspan="4"></td>
            </tr>
             <tr> 
              	<td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                ��û���</td>
              	<td height="25" class="td_lmagin">
              	<%=objRsRI.getObject("OLD_REQ_ORGAN_NM")%>
              	</td>
              	<td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                ��û��</td>
              	<td height="25" class="td_lmagin">
              	<%=objRsRI.getObject("REGR_NM")%>
              	</td> 
            </tr>
			<%
			}/** �䱸 ���� �� ������. */
			%>
            <tr height="1" class="tbl-line"> 
              	<td height="2" colspan="4"></td>
            </tr>
			</table>
        	</td>
		</tr>
		<tr>
       		<!-- �����̽���ĭ -->
	       	<td>&nbsp;</td>
       		<!-- �����̽���ĭ -->
		</tr>
      	<tr>
       		<td>
       		<!----------------------- ���� ��ҵ� Form���� ��ư ���� ------------------------->
       	 	<table width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td>
				<%
   				String strDelete = "";
	   			if(strCmt.equalsIgnoreCase("")){
    				strDelete = "gotoDelete()";
      			} else {
	   				strDelete = "javascript:showDelMoreInfoDiv()";
      			}

      			/**����ȸ���� �űԵ���� �䱸�� ����-> ����??*/
      			//�䱸�Ժ��� ��ư...
     			/** ����ȸ �������� �϶��� ȭ�鿡 �����.*/
				if(objUserInfo.getOrganGBNCode().equals("004")  && !strReqSubmitFlag.equals("004")){
	      			//if(objRsSH.getObject("REQ_BOX_STT").equals("002") || objRsSH.getObject("REQ_BOX_STT").equals("005")){
    	  			%>
					<img src="/image/button/bt_modifyReq.gif"  height="20" border="0" onClick="gotoEdit()" style="cursor:hand">
					<img src="/image/button/bt_delReq.gif"  height="20" border="0" onClick="<%=strDelete%>" style="cursor:hand">
	      			<%//}
				}
      			%>
				<img src="/image/button/bt_viewReqHistory.gif"  height="20" border="0" onClick="viewReqHistory('<%=(String)request.getParameter("CommReqID")%>')" style="cursor:hand" alt="���� �䱸�� ó�������� ���ں��� ��ȸ�մϴ�.">
      			<img src="/image/button/bt_viewReqBox.gif" height="20"  style="cursor:hand" onClick="gotoReqBox();">				
				</td>
			</tr>
			</table>
           	<!----------------------- ���� ��ҵ� Form���� ��ư �� ------------------------->               	   
            </td>
		</tr> 
		<tr>
       		<!-- �����̽���ĭ -->
	       	<td>&nbsp;</td>
       		<!-- �����̽���ĭ -->
		</tr>		
		<tr>
			<td>
			<div id="delMoreInfoDiv" style="display:none;width:680;top:300;left:600;">
				<table width="680" height="151" border="0" cellpadding="0" cellspacing="0">
				<tr>
					 <td height="30" align="left" class="soti_reqsubmit" colspan="2">
					 <img src="/image/reqsubmit/icon_reqsubmit_soti.gif" width="9" height="9" align="absmiddle"> 
			         �䱸 ���� ���� �� �뺸���</td>
				</tr>
				<tr>
					<td width="149" height="2" class="td_reqsubmit"></td>
			        <td width="531" height="2" class="td_reqsubmit"></td>
				</tr>
				<tr>
					<td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
			        �������� ����</td>
			        <td valign="middle" class="td_box"><input type="checkbox" name="NtcMtd" value="002">
			        ���</td>
				</tr>
			    <tr> 
			      <td height="1" class="tbl-line"></td>
			      <td height="1" class="tbl-line"></td>
			    </tr>
			    <tr> 
			      <td class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
			      ����</td>
			      <td valign="middle" class="td_box"> 
			      <textarea rows="3" cols="10" name="Rsn" class="textfield" style="WIDTH: 90% ; height: 30"></textarea>
			      </td>
			    </tr>
			    <tr height="1"> 
			      <td height="2" class="tbl-line"></td>
			      <td height="2" class="tbl-line"></td>
			    </tr>
				<tr align="left" valign="middle" height="1"> 
			    	<td height="40" colspan="2"><img src="/image/button/bt_delete.gif" width="43" height="20" onClick="javascript:FinalSubmit()"></td>
			    </tr>	
				</table>
				<p>
			</div>
			</td>
		</tr>
	    <tr>
			<td height="35px"></td>
        </tr>    		
		</table>
		</td>
	</tr>
	</table>
	<!---------------------------------------------------------------- FINISH  --------------------------------------------------------------->

	<!-- ������� ���� ������ �Է��� �ּ��� -->
	</td>
</tr>
<tr>
	<td width="980" height="45" align="center" colspan="2"><%@ include file="/common/Bottom.jsp" %></td>
</tr>
</table>
</body>
</html>


