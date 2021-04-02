<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.params.cmtsubmt.CmtSubmtReqBoxVListForm" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.cmtsubmt.CmtSubmtReqBoxDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	/******************************************************************************
	* Name		  : RCommReqInfoWrite.jsp
	* Summary	  : ��û�Կ� �Էµ� �䱸���� �ۼ�.
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
	CmtSubmtReqBoxDelegate objReqBox=null; 		/**��û�� Delegate*/
	ResultSetSingleHelper objRsSH=null;		/** ��û�� �󼼺��� ���� */
	ResultSetHelper objSubmtOrganRs=null; /** ������ ����Ʈ ��¿� RsHelper */ 
	try{
		/**��û�� ���� �븮�� New */
		objReqBox=new CmtSubmtReqBoxDelegate();
		OrganInfoDelegate objOrganInfo=new OrganInfoDelegate();   /** ������� ��¿� �븮�� */
		/**��û�� �̿� ���� üũ */
		boolean blnHashAuth=objReqBox.checkReqBoxAuth((String)objParams.getParamValue("ReqBoxID"),objUserInfo.getOrganID()).booleanValue();
		if(!blnHashAuth){
			objMsgBean.setMsgType(MessageBean.TYPE_WARN);
			objMsgBean.setStrCode("DSAUTH-0001");
			objMsgBean.setStrMsg("�ش� ��û���� �� ������ �����ϴ�.");
%>
			<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
			return;
		}else{
			/** ��û�� ���� */
			objRsSH=new ResultSetSingleHelper(objReqBox.getRecord((String)objParams.getParamValue("ReqBoxID")));
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
  }//endfunc
  
  // 2004-07-19
  function gotoCommReqBoxList() {
  	var str1 = document.formName.SubmtOrganID.value;
  	var str2 = document.formName.ReqCont.value;
  	var str3 = document.formName.ReqDtlCont.value;
  	
  	if (str1.length != 0 && str2.length != 0 && str3.length != 0) {
  		if (confirm("�Է��Ͻ� �䱸 ������ ����Ͻðڽ��ϱ�?\n��Ҹ� ���Ͻø� �ƴϿ��� ������ �ּ���")) document.formName.action = "./RCommReqInfoWriteProc.jsp";
  		else document.formName.action = "./RCommReqVList.jsp";
  	} else {
  		document.formName.action = "./RCommReqVList.jsp";
  	}
  	document.formName.submit();
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
          <form name="formName" method="post" encType="multipart/form-data" action="./RCommReqInfoWriteProc.jsp"><!--�䱸 �ű����� ���� -->
            <!--�䱸���� ������ ��ȣ(����¡����ؼ� �켱 1��������) -->          
            <% objParams.setParamValue("ReqInfoPage","1");%>
            <%=objParams.getHiddenFormTags()%>
              <tr> 
                <td height="23" align="left" valign="top"></td>
              </tr>
              <tr> 
                <td height="23" align="left" valign="top"><table width="100%" height="23" border="0" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="35%" background="/image/reqsubmit/bg_reqsubmit_tit.gif">
                      		<!-------------------- Ÿ��Ʋ�� �Է��� �ּ��� ------------------------>
                      		<span class="title"><%=MenuConstants.REQ_BOK_COMM_REQ%></span><strong>-<%=MenuConstants.REQ_INFO_WRITE%></strong>
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
                		���������� ���� �䱸������ ����ϴ� ȭ���Դϴ�.
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
						<%=(String)objRsSH.getObject("SUBMT_ORGAN_NM")%>
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
                      	<input type="text" name="ReqCont" class="textfield" size="85" maxlength="1000">			
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
                      <td height="25" colspan="3"  class="td_box">
                      	<textarea rows="5" cols="70" name="ReqDtlCont"  
                      		class="textfield" style="WIDTH: 95%; height:180"  
                      		onKeyDown="javascript:updateChar2(document.formName, 'ReqDtlCont', '4000')" onKeyUp="javascript:updateChar2(document.formName, 'ReqDtlCont', '4000')" onFocus="javascript:updateChar2(document.formName, 'ReqDtlCont', '4000')" onClick="javascript:updateChar2(document.formName, 'ReqDtlCont', '4000')"></textarea><br>
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
							String strOpenClass=CodeConstants.OPN_CL_CLOSE;//�������Ģ.
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
                      <td height="25" colspan="3" class="td_lmagin">
                      	<input type="file" name="AnsEstyleFilePath" size="70"  class="textfield">
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
               			<img src="/image/button/bt_viewAppBox.gif" height="20" border="0" onClick="gotoCommReqBoxList()" style="cursor:hand">
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
