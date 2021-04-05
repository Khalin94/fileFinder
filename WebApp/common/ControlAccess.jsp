<%@ page import="java.util.*"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%@ include file="/forum/common/CheckSessionPop.jsp" %>

<%
	/** ��ȸ���ڹ����ý��ۿ� ������ �� �ִ� IP �� ��� **/
	String strInIP[] = {
								"10.0.0.0",
								"192.168.1.0",
								"192.168.2.0",
								"192.168.3.0",
								"192.168.4.0",
								"192.168.5.0",
								"192.168.6.0",
								"192.168.7.0",
								"192.168.8.0",
								"192.168.9.0",
								"192.168.10.0",
								"192.168.11.0",
								"192.168.12.0",
								"192.168.13.0",
								"192.168.14.0",
								"192.168.15.0",
								"192.168.16.0",
								"192.168.17.0",
								"192.168.18.0",
								"192.168.19.0",
								"192.168.20.0",
								"192.168.21.0",
								"192.168.22.0",
								"192.168.23.0",
								"192.168.24.0",
								"192.168.25.0",
								"192.168.26.0",
								"192.168.27.0",
								"192.168.28.0",
								"192.168.29.0",
								"192.168.30.0"
								};
	/*********************************************/
	String strUserIp = "";
	String strGubn = "";
	String strUrl = "";
	String strMessage = "���� �� VPN�� ���ؼ� �������ϼ���.";
	boolean blnCheck = false;
	Vector objInIP = new Vector();
	try
	{
		strGubn = StringUtil.getNVL(request.getParameter("gubn"), "1");

		//Ŭ���̾�Ʈ IP ��ȸ
		strUserIp = request.getHeader("Proxy-Client-IP");
		if ((strUserIp == null) || strUserIp.equals("")){
			strUserIp = request.getRemoteAddr();
		}
		Vector objUserIP = ActComm.makeNoType(strUserIp, ".");

		String strIpEach = "";
		String strUserIpEach = "";

		for(int i=0; i<strInIP.length; i++){
			objInIP = ActComm.makeNoType(strInIP[i], ".");
			for(int j=0; j<objInIP.size(); j++){
				if(j >= 4) break; //����� IP�� �߸� �Ǿ��� ���

				strIpEach = (String)objInIP.elementAt(j);
				if(strIpEach.equals("0") || strIpEach.equals("")){
					if (j == 0) blnCheck = true;
					break;
				}
				strUserIpEach = (String)objUserIP.elementAt(j);
				if(strIpEach.equals(strUserIpEach)){
					blnCheck = true;
				}else{
					blnCheck = false;
				}
			}

			if (blnCheck == true){
				break;
			} //if (strErr.equals("no")){
		}//for(int i=0; i<strInIP.length; i++){

		if (blnCheck == true){
			switch (Integer.parseInt(strGubn)){
				case 1:  //��ȸ���ڰ���
					//strUrl = "http://docs.assembly.go.kr/EP/web/login/assem_sso_login.jsp";
                    strUrl = "http://docs.assembly.go.kr";

					break;
				case 2:  //���԰���
					strUrl = "http://docs.assembly.go.kr/EP/web/login_idir/AEP_BusinessCard_SSO.jsp";
					break;
				case 3:  //��������
					strUrl = "http://docs.assembly.go.kr/EP/web/login_idir/AEP_Schedule_SSO.jsp";
					break;
			}//switch (Integer.parseInt(strGubn)){
		}else{
			switch (Integer.parseInt(strGubn)){
				case 1:  //��ȸ���ڰ���
					strMessage = "��ȸ���ڰ��� �ý��� " + strMessage;
					break;
				case 2:  //���԰���
					strMessage = "���԰��� " + strMessage;
					break;
				case 3:  //��������
					strMessage = "�������� " + strMessage;
					break;
			}//switch (Integer.parseInt(strGubn)){
		} //if (strErr.equals("no")){

	}catch(Exception objEx)
	{
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  		objMsgBean.setStrCode("SYS-00001");
  		objMsgBean.setStrMsg(objEx.getMessage());
  		out.println("<br>Error!!!" + objEx.getMessage());
%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}
%>

<script language="javascript">
<!--

	<%if(blnCheck == true){%>
		document.location = '<%=strUrl%>';
	<%}else{%>
		alert('<%=strMessage%>');
		self.window.close();
	<%}%>
//-->
</script>