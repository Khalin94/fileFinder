<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RPreReqBoxVListForm" %>


<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.prereqinfo.PreRequestInfoDelegate" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%
/******************************************************************************
* Name		  : RBasicReqInfoAppointListProc.jsp
* Summary	  : ���� �䱸 ���� ó��.
* Description : ���� �䱸 ���� ó�� ��� ����.
* 				�ء� üũ �ء�
*				 ���� ����ó���� ������ �������� �ѱ��� ����.
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

  /** �䱸�� �������� ���� �Ķ���� ����.*/
  RPreReqBoxVListForm objParams =new RPreReqBoxVListForm();  
  objParams.setParamValue("CmtOrganID",objUserInfo.getOrganID());
  
  objParams.setParamValue("ReqOrganID",objUserInfo.getOrganID());//�䱸�������.
  objParams.setParamValue("RegrID",objUserInfo.getUserID());	//�䱸�� ID����.
  //System.out.println("���� ����� "+objUserInfo.getUserID());
  
  boolean blnParamCheck=false;
  /**���޵� �ĸ����� üũ */
  blnParamCheck=objParams.validateParams(request);
  if(blnParamCheck==false){
  	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	objMsgBean.setStrCode("DSPARAM-0000");
  	objMsgBean.setStrMsg(objParams.getStrErrors());
  	//out.println("ParamError:" + objParams.getStrErrors());
  	%>
  	<!--jsp:forward page="/common/message/ViewMsg.jsp"/-->
  	<%
  	//return;
  }//endif

%>

<%
 /*************************************************************************************************/
 /** 					������ ó�� Part 														  */
 /*************************************************************************************************/
 PreRequestInfoDelegate objReqInfo=new PreRequestInfoDelegate();   /** �䱸 ���� �Է¿� */

	String strReqBoxID=null;
 	String[] strReqIdArray = new String[300];	
	strReqIdArray = request.getParameterValues("ReqInfoIDs");
	strReqBoxID = request.getParameter("ReqBoxID");
	
	if (strReqIdArray != null)
	{
		int intlength = strReqIdArray.length ;
		String strAppointIndex = null;		
		String strBoxID=null;
		for(int i=0; i<intlength; i++) {
			strAppointIndex = strReqIdArray[i];
			strBoxID = strReqBoxID;
			
			String strUserID=objUserInfo.getUserID();
			String strReqInfoID=objReqInfo.setRecordNewApp(strAppointIndex,strBoxID,strUserID);
			
            //out.println(strReqInfoID);
			
			System.out.println("<br>");
			System.out.println(" �Ѱܹ��� ����  =" + strAppointIndex + "<br>");				 		
		}
		
	}

%>



<html>
<script language="JavaScript">
	function init(){
		
		alert("�����Ͻ� �䱸�Կ� ���⵵ ���� �䱸�� �����Խ��ϴ�.");
		opener.window.location.href='<%=request.getParameter("ReturnUrl")%>?ReqBoxID=<%=objParams.getParamValue("ReqBoxID")%>&CmtOrganID=<%=objParams.getParamValue("CmtOrganID")%>'; 
		
		self.close();
		formName.submit();
		
	}
</script>
<body onLoad="init()">
				
                <form name="formName" method="get" action="<%=request.getParameter("ReturnUrl")%>" ><!--�䱸�� �󼼺��� ���� ���� -->
				<input type="hidden" name="AuditYear" value="<%=objParams.getParamValue("AuditYear")%>">
				<input type="hidden" name="CmtOrganID" value="<%=objParams.getParamValue("CmtOrganID")%>">
				<input type="hidden" name="ReqOrganID" value="<%=objParams.getParamValue("ReqOrganID")%>">		    		    		    		    				
				<input type="hidden" name="ReqBoxID" value="<%=objParams.getParamValue("ReqBoxID")%>">
				<input type="hidden" name="ReqBoxSortField" value="<%=objParams.getParamValue("ReqBoxSortField")%>"><!--�䱸�Ը�������ʵ� -->
				<input type="hidden" name="ReqBoxSortMtd" value="<%=objParams.getParamValue("ReqBoxSortMtd")%>"><!--�䱸�Ը�����ɹ��-->
				<input type="hidden" name="ReqBoxPage" value="<%=objParams.getParamValue("ReqBoxPage")%>"><!--�䱸�� ������ ��ȣ -->
				<input type="hidden" name="ReqBoxQryField" value="<%=objParams.getParamValue("ReqBoxQryField")%>"><!--�䱸�� ��ȸ�ʵ� -->
				<input type="hidden" name="ReqBoxQryTerm" value="<%=objParams.getParamValue("ReqBoxQryMtd")%>"><!--�䱸�� ��ȸ�� -->
				<input type="hidden" name="ReqInfoSortField" value="<%=objParams.getParamValue("ReqInfoSortField")%>"><!--�䱸���� ��������ʵ� -->
				<input type="hidden" name="ReqInfoSortMtd" value="<%=objParams.getParamValue("ReqInfoSortMtd")%>"><!--�䱸���� ������ɹ��-->
				<input type="hidden" name="ReqInfoQryField" value="<%=objParams.getParamValue("ReqInfoQryField")%>"><!--�䱸 ��ȸ�ʵ� -->
				<input type="hidden" name="ReqInfoQryTerm" value="<%=objParams.getParamValue("ReqInfoQryMtd")%>"><!--�䱸 ��ȸ�� -->					
				<input type="hidden" name="ReqInfoPage" value="1"><!--�䱸���� ������ ��ȣ <%=objParams.getParamValue("ReqInfoPage")%> -->
				</form>
</body>
</html>




