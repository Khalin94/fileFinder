<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.bf.config.*"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.prereqbox.PreRequestBoxDelegate" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%
 UserInfoDelegate objUserInfo =null;
 CDInfoDelegate objCdinfo =null;
%>
<%@ include file="RUserCodeInfoInc.jsp" %>

<%
 /*************************************************************************************************/
 /** 					�Ķ���� üũ Part 														  */
 /*************************************************************************************************/

  /**�䱸�� ID */
  String strReqBoxID=(String)request.getParameter("ReqBoxID");
  String[] strSubmtOrganIDs=request.getParameterValues("SubmtOrganIDs");/**  ���õ� ������ ����Ʈ  */
  String strNatCnt=(String)request.getParameter("NatCnt");
  /**���� üũ ���ڿ� */
  String strErrorMsg="";
  boolean blnParamCheck=false;
  /**���޵� �ĸ����� üũ */
  if(StringUtil.isAssigned(strReqBoxID)){
    if(strSubmtOrganIDs==null){
    	strErrorMsg="�������� ���õ��� �ʾҽ��ϴ�.";
    }else{
	  	blnParamCheck=true;
  	}
  }else{
  	strErrorMsg="�䱸��ID�� ���� �Ǿ����ϴ�.";
  }
  if(blnParamCheck==false){
  	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	objMsgBean.setStrCode("DSPARAM-0000");
  	objMsgBean.setStrMsg(strErrorMsg);
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
	try{
        OrganInfoDelegate objOrganInfo=new OrganInfoDelegate();   /** ������� ��¿� �븮�� */
		PreRequestBoxDelegate objReqBox=new PreRequestBoxDelegate();
		for(int i=0;i<strSubmtOrganIDs.length;i++){
		  String strCmtOrganID=objOrganInfo.getCmtOrganID(strSubmtOrganIDs[i]);//������ ""��ȯ.		
		  /** �Ҽ�����ȸ �������� �ƴϸ� ��Ÿ����ȸ ���� 2004.05.13 */
		  if(objUserInfo.getIsMyCmtOrganID(strCmtOrganID)==false){
		     strCmtOrganID=CodeConstants.ETC_CMT_ORGAN_ID;
		  }//endif		
			String strReturn=objReqBox.copyRecord(strReqBoxID,objUserInfo.getUserID(),strNatCnt,strCmtOrganID,strSubmtOrganIDs[i]);
			if(!StringUtil.isAssigned(strReturn)){
			 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
			  	objMsgBean.setStrCode("DSDATA-0010");
			  	objMsgBean.setStrMsg("�䱸���� �������� ���߽��ϴ�");
			  	%>
			  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
			  	<%  	
			  	return;
			}//endif
		}//endfor
	 }catch(AppException objAppEx){ 
	 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
	  	objMsgBean.setStrCode(objAppEx.getStrErrCode());
	  	objMsgBean.setStrMsg(objAppEx.getMessage());
	  	%>
	  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
	  	<%  	
	  	return; 
	 }//endoftry
%>
<%
 /*************************************************************************************************/
 /** 					������ ��ȯ Part 														  */
 /*************************************************************************************************/
%>
<html>
<script language="JavaScript">
		alert("�䱸���� ����Ǿ����ϴ�");
		opener.location.href="/reqsubmit/20_comm/40_BasicBox/20_databoxsh/RBasicReqBoxList.jsp";
		self.close();
</script>
</html>