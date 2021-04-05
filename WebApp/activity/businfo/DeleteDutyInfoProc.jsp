<%@ page language="java" contentType="text/html;charset=euc-kr" %>

<%@ page import="java.util.*"%>
<%@ page import="nads.lib.util.*"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%@ include file="/common/CheckSession.jsp" %>

<%
	String strMessage = "";
	String strError = "no";
	try
	{	
		String strUserId = (String)session.getAttribute("USER_ID");
	
		nads.dsdm.app.activity.businfo.BusInfoDelegate objBusInfoDelegate = new nads.dsdm.app.activity.businfo.BusInfoDelegate();

		String strDocIdArry[] = request.getParameterValues("checkD"); 
		//�����ϰ��� �ϴ� ����ID
		String strDutyIdArry[] = request.getParameterValues("checkF"); 
		//�����ϰ��� �ϴ� ����ID
		
		Vector objDocId = new Vector();
		Vector objDutyId = new Vector();
		
		int iDocCnt = 0;
		int iDutyCnt = 0;
		
		if(strDocIdArry == null){
			iDocCnt = 0;
		}else{
			iDocCnt = strDocIdArry.length;  //������ �з��� ����
		}	

		if(strDutyIdArry == null){
			iDutyCnt = 0;
		}else{
			iDutyCnt = strDutyIdArry.length;  //������ �������� ����
		}	
				
		if(iDocCnt + iDutyCnt > 0){
			if(iDocCnt > 0){
				for (int i=0; i < strDocIdArry.length ; i++){
					objDocId.add(strDocIdArry[i]);			
				}
			}
			
			if(iDutyCnt > 0){
				for (int i=0; i < strDutyIdArry.length ; i++){
					objDutyId.add(strDutyIdArry[i]);			
				}
			}
			
			Hashtable objParamHt = new Hashtable();
			objParamHt.put("USER_ID", strUserId);  //�����ID
			objParamHt.put("DOC_ID", objDocId);    //�����ϰ����ϴ� �з���ID
			objParamHt.put("DUTY_ID", objDutyId);  //�����ϰ��� �ϴ� ��������ID
		
			int iResult = objBusInfoDelegate.deleteDutyInfo(objParamHt);
			
			if(iResult == -1){
				strMessage = "������ �ٸ� ����ڰ� ���������� �����Ͽ����ϴ�(Ȯ�ο��).";
			}else{
				strMessage = strMessage + String.valueOf(iResult) + "�� ���� �Ǿ����ϴ�.";
			}	
		}else{
			strMessage = "������ ���������� �������� �ʾҽ��ϴ�.!";
		}//strDocIdArry.length + strDutyIdArry.length > 1)
		strError = "no";
	}
	catch(AppException objAppEx)
	{	
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  		objMsgBean.setStrCode(objAppEx.getStrErrCode());
  		objMsgBean.setStrMsg(objAppEx.getMessage());
  		out.println("<br>Error!!!" + objAppEx.getMessage());
		strError = "yes";
%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%  	
		return;
	}
%>

<script language="javascript">
<!--
	alert("<%=strMessage%>");
		
	<%if(strError.equals("no")){%>
	opener.location.reload();
    self.window.close(); 
	<%}else{%>
	history.back();
	<%}%>
//-->
</script>
