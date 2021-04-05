<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	/******************************************************************************
		* Name		  : RNewBoxMake.jsp
		* Summary	  : �ű� �䱸�� ���.
		* Description : �䱸�� ��� ȭ�� ����.
	******************************************************************************/
%>
<%
 UserInfoDelegate objUserInfo =null;
 CDInfoDelegate objCdinfo =null;
%>
<%@ include file="../../common/RUserCodeInfoInc.jsp" %>
<%
	// 2004-07-08
	// ������åó ������ ���ؼ� ������� �ڵ带 �����Ѵ�.
	String strOrgGbnCode = objUserInfo.getOrganGBNCode();
	
	/** ���� ������ SELECT Box Param */ 
	String strCmtOrganID = StringUtil.getEmptyIfNull((String)request.getParameter("CmtOrganID"));/**����ȸ ��� */
 	String strRltdDuty = StringUtil.getEmptyIfNull((String)request.getParameter("RltdDutyX"));/** �������� */
 	String strNatCnt = StringUtil.getEmptyIfNull((String)request.getParameter("NatCnt"));	/** ȸ�� */
 	String strSubmtDln = StringUtil.getEmptyIfNull((String)request.getParameter("SubmtDln"));/** ������ */
 	String strReqBoxDsc = StringUtil.getEmptyIfNull((String)request.getParameter("ReqBoxDsc"));/** �䱸�Լ��� */
 
	/**�������а� ���õȰ��� ������ �⺻���� ������ �ǰ���. ����� ���������ڵ�.*/
 	if(strRltdDuty.equals("")){
 		strRltdDuty=CDInfoDelegate.SELECTED_RLTD_DUTY;
	}
 	String strSubmtOrganID=StringUtil.getEmptyIfNull((String)request.getParameter("SubmtOrganIDX"));/** ������ID */
%>
<%

 /******** ������ ���� �����̳� ���� *********/
 ResultSetHelper objCmtRs=null;        /** �Ҽ� ����ȸ ����Ʈ ��¿� RsHelper */
 ResultSetHelper objSubmtOrganRs=null; /** ������ ����Ʈ ��¿� RsHelper */
 ResultSetHelper objRltdDutyRs=null;   /** ���þ��� ����Ʈ ��¿� RsHelper */
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
   
   // 2004-07-08 �繫ó, ����ó�� GbnCode�� ���� ��ü ������ ����� �����;� �ϹǷ�
   //objSubmtOrganRs = new ResultSetHelper(objOrganInfo.getSubmtOrganList(strCmtOrganID));/**����������Ʈ*/
   String strTmpOrgGbnCode = strOrgGbnCode;
   if (CodeConstants.ORGAN_GBN_MEM.equalsIgnoreCase(strOrgGbnCode)) strTmpOrgGbnCode = CodeConstants.ORGAN_GBN_CMT;
   objSubmtOrganRs = new ResultSetHelper(objOrganInfo.getSubmtOrganList(strCmtOrganID, strTmpOrgGbnCode)); // ����������Ʈ*/
   
   objRltdDutyRs=new ResultSetHelper(objCdinfo.getRelatedDutyList());
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

<!DOCTYPE HTML PUBLIC "-//w3c//dtd html 4.0 transitional//en">
<html>
<head>
<title><%=MenuConstants.getReqBoxGeneral(request)%> > <%=MenuConstants.REQ_BOX_WRITE%> <% //nads.lib.reqsubmit.EnvConstants.UNIX_TEMP_SAVE_PATH%></title>
<link href="/css/System.css" rel="stylesheet" type="text/css">
<script language=Javascript src="/js/reqsubmit/common.js"></script>
<script language=Javascript src="/js/nads_lib.js"></script>
<script language=Javascript src="/js/datepicker.js"></script>
<script language="JavaScript">
  /** ����������Ʈ ���. */
  function changeSubmtOrganList(){
    
  	formName.action="<%=request.getRequestURI()%>";
  	formName.submit();
  }
  
  /** �������� üũ */
  function checkFormData() {
	var alertStr = "";
  	if(formName.CmtOrganID.value == "") {
		alertStr = "- ����ȸ\n"
  	}
  	if(formName.SubmtOrganID.value == "") {
		alertStr = alertStr + "- ������\n";
  	}  
	if(formName.elements['NatCnt'].value==""){
		alertStr = alertStr + "- ȸ��\n";
	}
	if(formName.elements['SubmtDln'].value==""){
		alertStr = alertStr + "- �������\n";
	}

	if (alertStr.length != 0) {
		alertStr = "[�Ʒ��� �׸��� �Է��� �����Ǿ����ϴ�. Ȯ�ιٶ��ϴ�]\n\n" + alertStr;
		alert(alertStr);
		return;
	}

	if(formName.elements['ReqBoxDsc'].value.length>250){
		alert("�䱸�Լ����� 250���� �̳��� �ۼ����ּ���!!");
		formName.elements['ReqBoxDsc'].focus();
		return false;		
	}
	if(formName.elements['SubmtDln'].value<="<%=StringUtil.getSysDate()%>"){
		alert("��������� ����(<%=StringUtil.getSysDate()%>)������ ��¥�� �����ϼž��մϴ�");
		formName.elements['SubmtDln'].focus();
		return false;
	}
	
	formName.action="./RNewBoxMakeProc.jsp";
	formName.submit();
  }//endfunc
  
  /** ������ ��ȸ �˾� */
  function popupSearchSubmitOrgan(){
    var varWidth=320;
    var varHeight=250;
    var winl = (screen.width - varWidth) / 2;
	var wint = (screen.height - varHeight) / 2;
  	window.open("/reqsubmit/common/SearchSubmtOrganList.jsp",'','width=' + varWidth + ',height=' + varHeight + ',top='+wint+',left='+winl+',scrollbars=yes, resizable=no, toolbar=no, menubar=no, location=no, directories=no, status=yes');
  }
  
  // 2004-07-16
  // FORM RESET
  function formReset() {
  	document.formName.NatCnt.value = "";
  	document.formName.SubmtDln.value = "";
  	document.formName.ReqBoxDsc.value = "";
  }
  
   // 2004-07-19
  function gotoReqBoxList() {
  	var str1 = document.formName.NatCnt.value;
  	var str2 = document.formName.SubmtDln.value;
  	var str3 = document.formName.SubmtOrganID.value;
	
	if (str1.length != 0 && str2.length != 0 && str3.length != 0) {
  		if (confirm("�Է��Ͻ� �䱸���� �����Ͻðڽ��ϱ�?\n����Ͻ� ��� ��Ҹ� ������ �ּ���")) {
  			checkFormData();
  		} else {
  			location.href='/reqsubmit/10_mem/20_reqboxsh/10_make/RMakeReqBoxList.jsp';
  		}
  	} else {
		location.href='/reqsubmit/10_mem/20_reqboxsh/10_make/RMakeReqBoxList.jsp';
	}
  }
</script>
<head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="formName.NatCnt.focus()">
<%@ include file="../../common/MenuTopReqsubmit.jsp" %>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr align="left" valign="top">
    <td width="186" height="470" background="/image/common/bg_leftMenu.gif">
	<%@ include file="../../common/MenuLeftReqsubmit.jsp" %></td>
<!------- 2004-06-02 ������ �������� ���� ����� �κ� ���� ------->
<td width="100%"><table width="100%" border="0" cellspacing="0" cellpadding="0">
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
          <form name="formName" method="post" action="<%=request.getRequestURI()%>"><!--�䱸�� �ű����� ���� -->
              <input type="hidden" name="SubmtOrganIDX" value="">
              <tr> 
                <td height="23" align="left" valign="top"></td>
              </tr>
              <tr> 
                <td height="23" align="left" valign="top"><table width="100%" height="23" border="0" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="25%" background="/image/reqsubmit/bg_reqsubmit_tit.gif">
                      		<!-------------------- Ÿ��Ʋ�� �Է��� �ּ��� ------------------------>
                      		<span class="title"><%=MenuConstants.REQ_BOX_WRITE%></span>
                      </td>
                      <td width="16%" align="left" background="/image/common/bg_titLine.gif">&nbsp;</td>
                      <td width="59%" align="right" background="/image/common/bg_titLine.gif" class="text_s">
                      		<!-------------------- ���� ��ġ ������ ����Ѵ�ϴ�. ------------------------>
                      		<img src="/image/common/icon_navi.gif" width="3" height="5" align="absmiddle"> 
                        <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.getReqBoxGeneral(request)%> > <B><%=MenuConstants.REQ_BOX_WRITE%></B>
                      </td>
                    </tr>
                  </table></td>
              </tr>
              <tr> 
                <td height="30" align="left" class="text_s">
                		<!-------------------- ���� �������� ���� ���� ��� ------------------------>
                		���� ������� ���� �䱸������ ���� �䱸����  ����ϴ� ȭ���Դϴ�.  
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
						// 2004-07-08 �繫ó, ������åó Ư�� ������ ���� ���� ��~��~
						if ((CodeConstants.ORGAN_GBN_ASM.equalsIgnoreCase(strOrgGbnCode)) || (CodeConstants.ORGAN_GBN_BUD.equalsIgnoreCase(strOrgGbnCode))) {
							out.println("<input type='hidden' name='CmtOrganID' value='"+objUserInfo.getOrganID()+"'>");
						} else {
					%>
                    <tr> 
                      <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        ����ȸ </td>
                      <td height="25" colspan="3" class="td_lmagin">
						<select name="CmtOrganID" onChange="changeSubmtOrganList()"  class="select">
							<option value="" selected>::: ������ �ּ��� :::</option>
						<%
						   /** ��ü ����ȸ ����Ʈ ��� */
						   while(objCmtRs.next()){
						       String strOrganID=(String)objCmtRs.getObject("CMT_ORGAN_ID");
						   	   out.println("<option value=\"" + strOrganID + "\" " + StringUtil.getSelectedStr(strCmtOrganID,strOrganID) + ">" + objCmtRs.getObject("CMT_ORGAN_NM") + "</option>");
						   }//endwhile
						%>
						  <% //����ȸ�������� ���� ����� ������. %>
						  <option value="<%=CodeConstants.NO_CMT_ORGAN_ID%>" <%=StringUtil.getSelectedStr(strCmtOrganID,CodeConstants.NO_CMT_ORGAN_ID)%>><%=CodeConstants.NO_CMT_ORGAN_NM%></option>
						</select>  
                      </td>
                    </tr>
                    <tr height="1" class="tbl-line"> 
                      <td height="1"></td>
                      <td height="1" colspan="3"></td>
                    </tr>
					<% } %>                    
                    <tr> 
                      <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        ȸ��</td>
                      <td height="25" colspan="3" class="td_lmagin">
	                      ��<input type="text" size="3" maxlength="3" name="NatCnt" class="textfield" onKeyUp="CheckNumeric(this);" value="<%=strNatCnt%>">ȸ��ȸ
                      </td>
                    </tr>
                    <tr height="1" class="tbl-line"> 
                      <td height="1"></td>
                      <td height="1" colspan="3"></td>
                    </tr>
                    <tr> 
                      <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        ��������</td>
                      <td height="25" class="td_lmagin" width="191">
						<select name="RltdDutyX"  class="select">
						<%
						   /**�������� ����Ʈ ��� */
						   while(objRltdDutyRs.next()){
						   		String strCode=(String)objRltdDutyRs.getObject("MSORT_CD");
						   		out.println("<option value=\"" + strCode + "\" " + StringUtil.getSelectedStr(strRltdDuty,strCode) + ">" + objRltdDutyRs.getObject("CD_NM") + "</option>");
						   }
						%>													
						</select>
                      </td>                      
                      <td height="25" width="149" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        �������</td>
                      <td height="25" width="191"  class="td_lmagin">
						<input type="text" class="textfield" name="SubmtDln" size="10" maxlength="8" value="<%=strSubmtDln%>"  OnClick="this.select()" OnKeyPress="if ((event.keyCode&lt;48)||(event.keyCode&gt;57)) event.returnValue=false;" OnBlur="javascript:SetFormatDate(this);">
						<input type="button" value="..." style="cursor:hand" OnClick="javascript:show_calendar('formName.SubmtDln');">
                      </td>
                    </tr>
                    <tr height="1" class="tbl-line"> 
                      <td height="1"></td>
                      <td height="1" colspan="3"></td>
                    </tr>
                    <tr> 
                      <td height="25" class="td_gray1" width="149">
							<img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                              <a href="javascript:popupSearchSubmitOrgan()">������</a></td>
						<td height="25" colspan="3" class="td_lmagin"><table border="0" cellspacing="0" cellpadding="0"><tr><td>
							<select name="SubmtOrganID" class="select">		
								<%
									// 2004-07-08 �繫ó, ������åó Ư�� ������ ���� ���� ��~��~
									if ((CodeConstants.ORGAN_GBN_ASM.equalsIgnoreCase(strOrgGbnCode)) || (CodeConstants.ORGAN_GBN_BUD.equalsIgnoreCase(strOrgGbnCode))) {
									} else {
							%>
								<option value="" selected>::: ����ȸ�� ���� ������ �ּ��� :::</option>
							<% } %>
						<%
						   /**������ ����Ʈ ��� */
						   while(objSubmtOrganRs.next()){
						   		String strSubmitOrganID=(String)objSubmtOrganRs.getObject("SUBMT_ORGAN_ID");
						   		String strSubmitOrganNM=(String)objSubmtOrganRs.getObject("SUBMT_ORGAN_NM");
						   		out.println("<option value=\"" + strSubmitOrganID + "\" " + StringUtil.getSelectedStr(strSubmtOrganID,strSubmitOrganID) + ">" + strSubmitOrganNM.trim() + "</option>");
						   }
						%>																							
								</select>
							<td>&nbsp;&nbsp;<img src="/image/button/bt_inquiry_small.gif" onClick="popupSearchSubmitOrgan()" style="cursor:hand"></td></tr></table>
						</td>
                    </tr>
                    <tr height="1" class="tbl-line"> 
                      <td height="1"></td>
                      <td height="1" colspan="3"></td>
                    </tr>
                    <tr> 
                      <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        �䱸�Լ���</td>
                      <td height="25" colspan="3" class="td_box">
                      	<textarea rows="3" cols="70" name="ReqBoxDsc"  class="textfield" style="WIDTH: 90%; height: 80" onKeyDown="javascript:updateChar2(document.formName, 'ReqBoxDsc', '250')" onKeyUp="javascript:updateChar2(document.formName, 'ReqBoxDsc', '250')" onfocus="javascript:updateChar2(document.formName, 'ReqBoxDsc', '250')"  onClick="javascript:updateChar2(document.formName, 'ReqBoxDsc', '250')"><%=strReqBoxDsc%></textarea><br>
						<table border="0">
						<tr><td width="30" align="right"><B><div id ="textlimit"> </div></B></td>
						<td width="570"> bytes (250 bytes ������ �Էµ˴ϴ�) </td></tr>
						</table>
                      </td>
                    </tr>
                    <tr height="1" class="tbl-line"> 
                      <td height="1"></td>
                      <td height="1" colspan="3"></td>
                   </tr>
                    <tr height="1" class="tbl-line"> 
                      <td height="1"></td>
                      <td height="1" colspan="3"></td>
                   </tr>
                </table>
				<!------------------------- TAB�� �ش��ϴ� ���̺�(����̵� ������̵� ��������) ��� �� ------------------------->                   
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
               	 <table>
               	   <tr>
               		 <td>
               			<img src="/image/button/bt_save.gif"  height="20" border="0" onClick="checkFormData()" style="cursor:hand">
               			<img src="/image/button/bt_cancel.gif"  height="20" border="0" onClick="javascript:formReset()" style="cursor:hand">
               			<img src="/image/button/bt_reqBoxList.gif" height="20" border="0" onClick="javascript:gotoReqBoxList()" style="cursor:hand">
               		 </td>
               	   </tr>
               	</table>   
               	<!----------------------- ���� ��ҵ� Form���� ��ư �� ------------------------->               	   
                </td>
              </tr>                        
          </form>
          </table>
          </td>
        </tr>
        <tr>
        	<td height="35">&nbsp;</td>
        </tr>
    </table>
    <!--------------------------------------- �������  MAIN WORK AREA ���� �ڵ��� ���Դϴ�. ----------------------------->      
    </td>
  </tr>
</table>
<%@ include file="../../../common/Bottom.jsp" %>
</body>
</html>              
