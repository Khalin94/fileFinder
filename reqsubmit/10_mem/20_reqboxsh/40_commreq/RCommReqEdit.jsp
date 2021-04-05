<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.params.cmtsubmt.CmtSubmtReqBoxVListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.cmtsubmt.CmtSubmtReqBoxDelegate" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%
/******************************************************************************
* Name		  : RCommReqEdit.jsp
* Summary	  : ��û�� ���� ȭ�� ����.
* Description : ��û���� ���������� ���� ������ �� �ִ� ȭ���� �����Ѵ�.
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

  /**�Ϲ� �䱸�� �󼼺��� �Ķ���� ����.*/
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
%>


<% 
 
 /******* ���� ������ SELECT Box Param */ 
 String strCmtOrganID=null;/**����ȸ ID */
 String strRltdDuty=null;/** �������� */
 
%>

<%
 /*************************************************************************************************/
 /** 					������ ȣ�� Part 														  */
 /*************************************************************************************************/

 /******** ������ ���� �����̳� ���� ********/
 ResultSetHelper objCmtRs=null;        /** �Ҽ� ����ȸ ����Ʈ ��¿� RsHelper */
 ResultSetSingleHelper objRsSH=null;	/** ������ */
 ResultSetHelper objRltdDutyRs=null;   /** �������� ����Ʈ ��¿� RsHelper */
 
 try{
   /********* �븮�� ���� ���� *********/
   CmtSubmtReqBoxDelegate objReqBox=new CmtSubmtReqBoxDelegate();
   
   /********* ���������� **************/
   objCmtRs=new ResultSetHelper(objUserInfo.getCurrentCMTList());   /** �Ҽ� ����ȸ */
   objRltdDutyRs=new ResultSetHelper(objCdinfo.getRelatedDutyList()); /** ���� ���� �������� */      
   objRsSH=new  ResultSetSingleHelper(objReqBox.getRecord(objParams.getParamValue("ReqBoxID")));
   
 }catch(Exception objEx){ 
 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  	objMsgBean.setStrCode("SYS-00010");//AppException����.
  	objMsgBean.setStrMsg(objEx.getMessage());
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%  	
  	return; 
 }

%>

<%
 /*************************************************************************************************/
 /** 					������ �� �Ҵ�  Part 														  */
 /*************************************************************************************************/

 strCmtOrganID=StringUtil.getEmptyIfNull((String)objRsSH.getObject("CMT_ORGAN_ID"));/**����ȸ ID */
 strRltdDuty=StringUtil.getEmptyIfNull((String)objRsSH.getObject("RLTD_DUTY"));	/**��������ID */
 
%>

<html>
<head>
<title><%=MenuConstants.REQ_BOK_COMM_REQ%>  </title>
<link href="/css/System.css" rel="stylesheet" type="text/css">
<script language="JavaScript">  
  /** �������� üũ */
  function checkFormData(){
	if(formName.elements['ReqBoxNm'].value==""){
		alert("��û�Ը���  �Է��ϼ���!!");
		formName.elements['ReqBoxNm'].focus();
		return false;
	}
	formName.submit();
  }
  
	function gotoList() {
		var f = document.formName;
		f.method = "get";
		f.action = "/reqsubmit/10_mem/20_reqboxsh/40_commreq/RCommReqList.jsp";
		f.target = "";
		f.submit();
	}
</script>
<head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
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
<form name="formName" method="post" action="./RCommReqEditProc.jsp">
          	 <%=objParams.getHiddenFormTags()%>
          	 <input type="hidden" name="AuditYear" value="<%=(String)objRsSH.getObject("AUDIT_YEAR")%>"><!--�ߺ�üũ�� -->
              <tr> 
                <td height="23" align="left" valign="top"></td>
              </tr>
              <tr> 
                <td height="23" align="left" valign="top"><table width="100%" height="23" border="0" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="35%" background="/image/reqsubmit/bg_reqsubmit_tit.gif">
                      		<!-------------------- Ÿ��Ʋ�� �Է��� �ּ��� ------------------------>
                      		<span class="title"><%=MenuConstants.REQ_BOK_COMM_REQ%></span> <strong>- ��û�� ����</strong>
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
                		����ȸ�� ������ �䱸������ ���� ��û���� �����ϴ� ȭ���Դϴ�.  
                </td>
              </tr>
              <tr> 
                <td height="5" align="left" class="soti_reqsubmit"></td>
              </tr>
              <tr> 
                <td height="30" align="left" class="soti_reqsubmit">
                	<!-------------------- TAB �� �ش��ϴ� ������ ����ϴ� ��������. ------------------------>
                	<img src="/image/reqsubmit/icon_reqsubmit_soti.gif" width="9" height="9" align="absmiddle"> 
                  ��û�� ����
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
                        ����ȸ </td>
                      <td height="25" colspan="3" class="td_lmagin">
						<select name="CmtOrganIDX"   class="select">
						<%
						   /** �Ҽ�����ȸ ����Ʈ ��� */
						   while(objCmtRs.next()){
						       String strOrganID=(String)objCmtRs.getObject("ORGAN_ID");
						   	   out.println("<option value=\"" + strOrganID + "\" " + StringUtil.getSelectedStr(strCmtOrganID,strOrganID) + ">" + objCmtRs.getObject("ORGAN_NM") + "</option>");
						   }//endwhile
						%>
						</select>                      
                      </td>
                    </tr>
                    <tr height="1" class="tbl-line"> 
                      <td height="1"></td>
                      <td height="1" colspan="3"></td>
                    </tr>
                    <tr> 
                      <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        ��û�Ը�</td>
                      <td height="25" colspan="3" class="td_lmagin">
	                      <input type="text" size="70" maxlength="100" name="ReqBoxNm" class="textfield" value="<%=(String)objRsSH.getObject("CMT_SUBMT_REQ_BOX_NM")%>">
                      </td>
                    </tr>
                    <tr height="1" class="tbl-line"> 
                      <td height="1"></td>
                      <td height="1" colspan="3"></td>
                    </tr>
                    <tr> 
                      <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        ��������</td>
                      <td height="25" class="td_lmagin" colspan="3">
						<select name="RltdDuty"  class="select">
						<%
						   /**�������� ����Ʈ ��� */
						   while(objRltdDutyRs.next()){
						   		String strCode=(String)objRltdDutyRs.getObject("MSORT_CD");
						   		out.println("<option value=\"" + strCode + "\" " + StringUtil.getSelectedStr(strRltdDuty,strCode) + ">" + objRltdDutyRs.getObject("CD_NM") + "</option>");
						   }
						%>													
						</select>
                      </td>
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
               			<img src="/image/button/bt_cancel.gif"  height="20" border="0" onClick="formName.reset()" style="cursor:hand">
               			<img src="/image/button/bt_appBoxList.gif"  height="20" border="0" onClick="javascript:gotoList()" style="cursor:hand">
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
