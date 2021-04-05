<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.params.cmtsubmt.CmtSubmtReqBoxVListForm" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.util.FileUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.cmtsubmt.CmtSubmtReqInfoDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	/******************************************************************************
	* Name		  : RCommReqInfoEdit.jsp
	* Summary	  : ��û�� �䱸������ �����ϴ� ȭ��.
	* Description : �䱸�����Է��� ūȭ�鿡�� �Է� �����ϰ� �ؾ��ϰ�,
	*				�亯��� ������ ÷���Ҽ� �ִ� ����� �����ؾ���.
	* 				����.. ūȭ���� ���� �غ��ؾ�����..
	*				
	******************************************************************************/
	UserInfoDelegate objUserInfo =null;
	CDInfoDelegate objCdinfo =null;
%>

<%@ include file="../../../common/RUserCodeInfoInc.jsp" %>

<%
	/*************************************************************************************************/
	/** 					�Ķ���� üũ Part 														  */
	/*************************************************************************************************/
	
	/**�Ϲ� ��û�� �󼼺��� �Ķ���� ����.*/
	CmtSubmtReqBoxVListForm objParams =new CmtSubmtReqBoxVListForm();  
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

	/*************************************************************************************************/
	/** 					������ ȣ�� Part 														  */
	/*************************************************************************************************/
	
	/*** Delegate �� ������ Container��ü ���� */
	ResultSetSingleHelper objRsSH=null;		/** ��û�� �󼼺��� ���� */
	ResultSetHelper objSubmtOrganRs=null; /** ������ ����Ʈ ��¿� RsHelper */ 
	try{
		/**��û�� �䱸���� �븮�� New */
		CmtSubmtReqInfoDelegate objReqInfo=null; 		/**��û Delegate*/
		objReqInfo=new CmtSubmtReqInfoDelegate();
		OrganInfoDelegate objOrganInfo=new OrganInfoDelegate();   /** ������� ��¿� �븮�� */
		/**��û�� �̿� ���� üũ */
		boolean blnHashAuth=objReqInfo.checkReqInfoAuth((String)objParams.getParamValue("ReqInfoID"),objUserInfo.getOrganID()).booleanValue();
		if(!blnHashAuth){
			objMsgBean.setMsgType(MessageBean.TYPE_WARN);
			objMsgBean.setStrCode("DSAUTH-0001");
			objMsgBean.setStrMsg("�ش� ��û���� �� ������ �����ϴ�.");
%>
			<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
			return;
		}else{
			/** ��û �䱸 ���� */
			objRsSH=new ResultSetSingleHelper(objReqInfo.getRecord((String)objParams.getParamValue("ReqInfoID")));
			objSubmtOrganRs=new ResultSetHelper(objOrganInfo.getSubmtOrganListOnly((String)objRsSH.getObject("CMT_ORGAN_ID")));/**����������Ʈ*/
		}/**���� endif*/
	}catch(AppException objAppEx){
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		System.out.println("SysErrorCode:" + objAppEx.getStrErrCode());
		objMsgBean.setStrCode("SYS-00010");//AppException����.
		objMsgBean.setStrMsg(objAppEx.getMessage());
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%  	
		return;
	}
	
	String strSubmtOrganID=(String)objRsSH.getObject("SUBMT_ORGAN_ID");
%>

<html>
<head>
<title><%=MenuConstants.getReqBoxGeneral(request)%> > <%=MenuConstants.REQ_BOK_COMM_REQ%> </title>
<link href="/css/System.css" rel="stylesheet" type="text/css">
<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>
<script language="JavaScript">

  /** �������� üũ */
  function checkFormData(){
	if(formName.elements['ReqCont'].value==""){
		alert("�䱸������  �Է��ϼ���!!");
		formName.elements['ReqCont'].focus();
		return false;
	}
	if(formName.elements['ReqDtlCont'].value.length><%=nads.lib.reqsubmit.EnvConstants.MAX_REQ_DTL_CONT_SIZE%>){
		alert("�䱸 ������ <%=nads.lib.reqsubmit.EnvConstants.MAX_REQ_DTL_CONT_SIZE%>���� �̳��� �ۼ����ּ���!!");
		formName.elements['ReqDtlCont'].focus();
		return false;
	}	
	formName.submit();
  }
  
	
	/**
	 * 2005-09-13 kogaeng ADD
	 */
	function updateChar2() {
		var length_limit = 4000;
		var aaaElem = document.formName.ReqDtlCont;
		var aaaLength = calcLength(aaaElem.value);
		document.getElementById("textlimit").innerHTML = aaaLength;
		if (aaaLength > length_limit) {
			alert("�ִ� " + length_limit + "byte�̹Ƿ� �ʰ��� ���ڼ��� �ڵ����� �����˴ϴ�.");
			aaaElem.value = aaaElem.value.replace(/\r\n$/, "");
			aaaElem.value = assertLength(aaaElem.value, length_limit);
		}
	}

	function calcLength(message) {
		var nbytes = 0;

		for (i=0; i<message.length; i++) {
			var ch = message.charAt(i);
			if(escape(ch).length > 4) {
				nbytes += 2;
			} else if (ch == '\n') {
				if (message.charAt(i-1) != '\r') {
					nbytes += 1;
				}
			} else if (ch == '<' || ch == '>') {
				nbytes += 4;
			} else {
				nbytes += 1;
			}
		}
		return nbytes;
	}

	function assertLength(message, maximum) {
		var inc = 0;
		var nbytes = 0;
		var msg = "";
		var msglen = message.length;

		for (i=0; i<msglen; i++) {
			var ch = message.charAt(i);
			if (escape(ch).length > 4) {
				inc = 2;
			} else if (ch == '\n') {
				if (message.charAt(i-1) != '\r') {
					inc = 1;
				}
			} else if (ch == '<' || ch == '>') {
				inc = 4;
			} else {
				inc = 1;
			}
			if ((nbytes + inc) > maximum) {
				break;
			}
			nbytes += inc;
			msg += ch;
		}
		document.getElementById("textlimit").innerHTML = nbytes;
		return msg;
	} 
</script>
<head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" >
<%@ include file="../../../common/MenuTopReqsubmit.jsp" %>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr align="left" valign="top">
    <td width="186" height="470" background="/image/common/bg_leftMenu.gif">
	<%@ include file="../../../common/MenuLeftReqsubmit.jsp" %></td>
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
          <form name="formName" method="post" encType="multipart/form-data" action="./RCommReqInfoEditProc.jsp">
            <%=objParams.getHiddenFormTags()%>
              <tr> 
                <td height="23" align="left" valign="top"></td>
              </tr>
              <tr> 
                <td height="23" align="left" valign="top"><table width="100%" height="23" border="0" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="35%" background="/image/reqsubmit/bg_reqsubmit_tit.gif">
                      		<!-------------------- Ÿ��Ʋ�� �Է��� �ּ��� ------------------------>
                      		<span class="title"><%=MenuConstants.REQ_BOK_COMM_REQ%></span><strong>-<%=MenuConstants.REQ_INFO_EDIT%></strong>
                      </td>
                      <td width="16%" align="left" background="/image/common/bg_titLine.gif">&nbsp;</td>
                      <td width="49%" align="right" background="/image/common/bg_titLine.gif" class="text_s">
                      		<!-------------------- ���� ��ġ ������ ����Ѵ�ϴ�. ------------------------>
                      		<img src="/image/common/icon_navi.gif" width="3" height="5" align="absmiddle"> 
                        <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.getReqBoxGeneral(request)%> > <B><%=MenuConstants.REQ_BOK_COMM_REQ%></B>
                      </td>
                    </tr>
                  </table></td>
              </tr>
              <tr> 
                <td height="30" align="left" class="text_s">
                		<!-------------------- ���� �������� ���� ���� ��� ------------------------>
                		���������� ���� �䱸������ �����ϴ� ȭ���Դϴ�.
                </td>
              </tr>
              <tr> 
                <td height="5" align="left" class="soti_reqsubmit"></td>
              </tr>
              <tr> 
                <td height="30" align="left" class="soti_reqsubmit">
                	<!-------------------- TAB �� �ش��ϴ� ������ ����ϴ� ��������. ------------------------>
                	<img src="/image/reqsubmit/icon_reqsubmit_soti.gif" width="9" height="9" align="absmiddle"> 
                  �䱸 ����
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
                    
                    <tr> 
                      <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        ��û�Ը�</td>
                      <td height="25" colspan="3" class="td_lmagin"><B><%=objRsSH.getObject("CMT_SUBMT_REQ_BOX_NM")%></B></td>
                    </tr>
                    <tr height="1" class="tbl-line"> 
                      <td height="1"></td>
                      <td height="1" colspan="3"></td>
                    </tr>
                    
                    <tr> 
                      <td height="25" width="149" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        ����ȸ </td>
                      <td height="25" colspan="3" class="td_lmagin">
                      <%=objRsSH.getObject("CMT_ORGAN_NM")%>
                      </td>
                    </tr>
                    <tr height="1" class="tbl-line"> 
                      <td height="1"></td>
                      <td height="1" colspan="3"></td>
                    </tr>
                    
                    <tr> 
                      <td height="25" width="149" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        ��������</td>
                      <td height="25" class="td_lmagin" width="191">
                      <%=objCdinfo.getRelatedDuty((String)objRsSH.getObject("RLTD_DUTY"))%>
                      </td>
                      <td width="149" height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        ������ </td>
					  <td height="25" width="191" class="td_lmagin">
						<select name="SubmtOrganID"  class="select">
						<%
						   /** ������ ����Ʈ ��� */
						   while(objSubmtOrganRs.next()){
						       String strOrganID=(String)objSubmtOrganRs.getObject("SUBMT_ORGAN_ID");
						   	   out.println("<option value=\"" + strOrganID + "\" " + StringUtil.getSelectedStr(strSubmtOrganID,strOrganID) + ">" + objSubmtOrganRs.getObject("SUBMT_ORGAN_NM") + "</option>");
						   }//endwhile
						%>
						</select>                      					  
						<%//(String)objRsSH.getObject("SUBMT_ORGAN_NM")%>
					  </td>
                    </tr>
                    <tr height="1" class="tbl-line"> 
                      <td height="1"></td>
                      <td height="1" colspan="3"></td>
                    </tr>
                    <tr> 
                      <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        �䱸����</td>
                      <td height="25" colspan="3" class="td_lmagin" style="padding-top:4px;padding-bottom:4px">
                      	<textarea rows="3" cols="80" name="ReqCont"  class="textarea" style="font-weight:bold"><%=(String)objRsSH.getObject("REQ_CONT")%></textarea>
                      	<br>
						&nbsp;<font class="soti_reqsubmit">* �ѱ��� 500��, ������ 1000�� ������ �Է� �����մϴ�.</font>						
                      </td>
                    </tr>
                    <tr height="1" class="tbl-line"> 
                      <td height="1"></td>
                      <td height="1" colspan="3"></td>
                    </tr>
                    <tr> 
                      <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        �䱸����</td>
                      <td height="25" colspan="3" class="td_lmagin" style="padding-top:4px;padding-bottom:4px"><textarea rows="10" cols="80" name="ReqDtlCont" onKeyDown="javascript:updateChar2(document.formName, 'ReqDtlCont', '4000')" onKeyUp="javascript:updateChar2(document.formName, 'ReqDtlCont', '4000')" onFocus="javascript:updateChar2(document.formName, 'ReqDtlCont', '4000')" onClick="javascript:updateChar2(document.formName, 'ReqDtlCont', '4000')" class="textarea">
                      		<%=(String)objRsSH.getObject("REQ_DTL_CONT")%>
                      	</textarea><br>
                      	<table border="0">
						<tr><td width="30" align="right"><B><div id ="textlimit"> </div></B></td>
						<td width="570"> bytes (4000 bytes ������ �Էµ˴ϴ�) </td></tr>
						</table>
						<BR>
						<font class="soti_reqsubmit">* �ѱ��� 2000��, ������ 4000�ڿ� �ش��մϴ�.</font>
                      </td>
                    </tr>
                    <tr height="1" class="tbl-line"> 
                      <td height="1"></td>
                      <td height="1" colspan="3"></td>
                   </tr>
                   <tr> 
                      <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        �������</td>
                      <td height="25" colspan="3" class="td_lmagin">
                      <select name="OpenCL"  class="select">
						<%
							List objOpenClassList=CodeConstants.getOpenClassList();
							String strOpenClass=(String)objRsSH.getObject("OPEN_CL");
							for(int i=0;i<objOpenClassList.size();i++){
								String strCode=(String)((Hashtable)objOpenClassList.get(i)).get("Code");
								String strValue=(String)((Hashtable)objOpenClassList.get(i)).get("Value");
								out.println("<option value=\"" + strCode + "\"" + StringUtil.getSelectedStr(strOpenClass,strCode) + ">" + strValue + "</option>");
							} 
						%>                      
                      </select>
					  </td>
                   </tr>
                   <tr height="1" class="tbl-line"> 
                      <td height="1"></td>
                      <td height="1" colspan="3"></td>
                   </tr>                   
                   <tr> 
                      <td height="25" width="149" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        ����������</td>
                      <td height="25" colspan="3" class="td_lmagin" style="padding-top:5px;padding-bottom:5px">
                      	<input type="file" name="AnsEstyleFilePath" size="70"  class="textfield">
                      	<%
                      	/**�Ϲݿ䱸ID�� ������: ������ �ȵǰ� ���� �ʿ�� ���游 �����ϰ���.*/
                      	if(StringUtil.isAssigned((String)objRsSH.getObject("GEN_REQ_ID"))){
	                      	if(StringUtil.isAssigned((String)objRsSH.getObject("ANS_ESTYLE_FILE_PATH"))){
	                      		/** �����û�� ��� �����̸� ���� ��� �߰�.*/
	                      		if(((String)objRsSH.getObject("ANS_ESTYLE_FILE_PATH")).indexOf(FileUtil.CMT_SUBMT_ATTACH_PATH_NAME)>=0){
	                      			out.println("<input type=\"checkbox\" name=\"DeleteFile\" value=\"OK\">���ϻ���:");
	                      		}
	                      		out.println(StringUtil.makeAttachedFileLink((String)objRsSH.getObject("ANS_ESTYLE_FILE_PATH"),(String)objRsSH.getObject("CMT_SUBMT_REQ_ID")));
	                      		out.println("<br><img src='/image/common/icon_exclam_mark.gif' border='0'> ������������ �����Ͻø� ������ ������ �����Ͻ� ���Ϸ� ��ġ�մϴ�");
	                      	}//endif
                      	}else{
	                      	if(StringUtil.isAssigned((String)objRsSH.getObject("ANS_ESTYLE_FILE_PATH"))){
	                      		out.println("<input type=\"checkbox\" name=\"DeleteFile\" value=\"OK\">���ϻ���:");
	                      		out.println(StringUtil.makeAttachedFileLink((String)objRsSH.getObject("ANS_ESTYLE_FILE_PATH"),(String)objRsSH.getObject("CMT_SUBMT_REQ_ID")));
	                      		out.println("<br><img src='/image/common/icon_exclam_mark.gif' border='0'> ������������ �����Ͻø� ������ ������ �����Ͻ� ���Ϸ� ��ġ�մϴ�");
	                      	}//endif
                      	}//endif
                      	
                      	%>                      	
					  </td>
                   </tr>
                   <tr height="2" class="tbl-line"> 
                      <td height="2"></td>
                      <td height="2" colspan="3"></td>
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
               			<img src="/image/button/bt_cancel.gif"  height="20" border="0" onClick="formName.reset()" style="cursor:hand">
               			<img src="/image/button/bt_prevPage.gif"  height="20" border="0" onClick="javascript:history.go(-1);" style="cursor:hand">
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
<%@ include file="../../../../common/Bottom.jsp" %>
</body>
</html>              
