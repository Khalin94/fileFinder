<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.bf.config.*"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.MemRequestBoxDelegate" %>
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
  String[] strSubmtOrganIDs = request.getParameterValues("SubmtOrganIDs");/**  ���õ� ������ ����Ʈ  */
  String strNatCnt = (String)request.getParameter("NatCnt");
  String strCmtOrganID = (String)request.getParameter("CmtOrganID");

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
	System.out.println("ERROR1");
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
		MemRequestBoxDelegate objReqBox=new MemRequestBoxDelegate();
		System.out.println("Start");
System.out.println("strSubmtOrganIDs.length : " + strSubmtOrganIDs.length);
		for(int i=0;i<strSubmtOrganIDs.length;i++){
		  //String strCmtOrganID = objOrganInfo.getCmtOrganID(strSubmtOrganIDs[i]);//������ ""��ȯ.		  
		  /** �Ҽ�����ȸ �������� �ƴϸ� ��Ÿ����ȸ ���� 2004.05.13 ==> ���� 2004.06.04 */
		  //if(objUserInfo.getIsMyCmtOrganID(strCmtOrganID)==false){
		  //   strCmtOrganID=CodeConstants.ETC_CMT_ORGAN_ID;
		  //}//endif		

			/*
			out.println("TEST ���Դϴ�.<BR>");
			out.println(strReqBoxID+"<BR>");
			out.println(objUserInfo.getUserID()+"<BR>");
			out.println(strNatCnt+"<BR>");
			out.println(strCmtOrganID+"<BR>");
			out.println(strSubmtOrganIDs[i]+"<BR>");
			if(1==1) return;
			*/
		  
	System.out.println("strReqBoxID : " + strReqBoxID);
			String strReturn=objReqBox.copyRecord(strReqBoxID, objUserInfo.getUserID(), strNatCnt, strCmtOrganID, strSubmtOrganIDs[i]);
			if(!StringUtil.isAssigned(strReturn)){
			 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
			  	objMsgBean.setStrCode("DSDATA-0010");
			  	objMsgBean.setStrMsg("�䱸���� �������� ���߽��ϴ�");
System.out.println("ERROR2");
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
System.out.println("ERROR3");
System.out.println(objAppEx.getMessage());
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
		opener.location.href="/reqsubmit/10_mem/20_reqboxsh/10_make/RMakeReqBoxList.jsp";
		self.close();
</script>
</html>