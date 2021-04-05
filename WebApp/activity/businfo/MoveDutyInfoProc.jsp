<%@ page language="java" contentType="text/html;charset=euc-kr" %>

<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%@ include file="/forum/common/CheckSessionPop.jsp" %>

<%
	String strMessage = "";
	String strError = "no";
	int iResult = 0;

	try
	{
		String strUserId = (String)session.getAttribute("USER_ID");

		nads.dsdm.app.activity.businfo.BusInfoDelegate objBusInfoDelegate = new nads.dsdm.app.activity.businfo.BusInfoDelegate();

		String strDutyIdArry[]   = request.getParameterValues("checkF");
		//������ ����(��������) ID
		String strDocboxIdArry[]   = request.getParameterValues("checkD");
		//������ ����(�з���)ID
		String strChgDocboxId   = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(request.getParameter("chg_docbox_id"));
		//�̵��ϰ����ϴ� ����(�з���)ID

		int iDocCnt = 0;
		int iDutyCnt = 0;

		if(strDocboxIdArry == null){
			iDocCnt = 0;
		}else{
			iDocCnt = strDocboxIdArry.length;  //������ ���� ����
		}
		if(strDutyIdArry == null){
			iDutyCnt = 0;
		}else{
			iDutyCnt = strDutyIdArry.length;  //������ ���� ����
		}

		if((iDocCnt + iDutyCnt) < 1){ //���õ� ���������� �ִ��� Ȯ��
			strMessage = "���õ� ���������� �����ϴ�.!";
		}else{
			if((iDutyCnt > 0) && strChgDocboxId.equals( "0")){
				strError = "yes";
				strMessage = "������ �μ� ������ �̵��� �� �����ϴ�.(Ȯ�ο��-������ ����)";
			}else{
				Hashtable objParamHt = new Hashtable();
				Vector objDutyIdVt = new Vector();
				Vector objDocIdVt = new Vector();

				if (iDutyCnt > 0){
					for(int i=0; i<strDutyIdArry.length; i++){
						objDutyIdVt.add(nads.lib.reqsubmit.util.StringUtil.getNoTagStr(strDutyIdArry[i]));
					}
				}

				if (iDocCnt > 0){
					for(int i=0; i<strDocboxIdArry.length; i++){
						objDocIdVt.add(nads.lib.reqsubmit.util.StringUtil.getNoTagStr(strDocboxIdArry[i]));
					}
				}
				objParamHt.put("CHG_DOCBOX_ID", strChgDocboxId);  //�̵��ϰ��� �ϴ� ������ ID
				objParamHt.put("USER_ID", strUserId);  //�����ID
				objParamHt.put("DUTY_ID", objDutyIdVt);  //
				objParamHt.put("DOC_ID", objDocIdVt);

				iResult = objBusInfoDelegate.updateDutyInfo(objParamHt);

				if(iResult == -1){
					strMessage = "������ �ٸ� ����ڰ� ���������� �����Ͽ����ϴ�(Ȯ�ο��).";
					strError = "yes";
				}else{
					strMessage = strMessage + String.valueOf(iResult) + "�� �̵�/���� �Ǿ����ϴ�.";
					strError = "no";
				}
			}
		}
		//--out.println("Result : " + intResult);
		//--response.sendRedirect("SendFax.jsp");
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
