<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.*" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%@ page import="nads.lib.message.MessageBean" %>


<%
	String strUserId = (String)session.getAttribute("USER_ID");  //����� ID
	String strMainOrganIdLeft = (String)session.getAttribute("ORGAN_ID");  //����� �� ���ID
	String strDocboxId = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVL(request.getParameter("docbox_id"), ""));  //�����޴����� Ŭ���� �з���ID
	String strOrganId   = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVL(request.getParameter("organ_id"), ""));  //�����޴����� Ŭ���� ���ID
	
	String strOrganIdLeft = "";  //�з����� ���ID
	String strDocboxIdLeft = "";  //�з���ID
	String strDocboxNmLeft = "";  //�з��Ը�
	String strTopDocboxIdLeft = "";  //�з����� �����з���ID
	String strSeqLeft = "";  //�з���(����)�� �ܰ�(1,2,3...)
	String strNumber = "";  //�з���(����)�� �ܰ�==>(strSeqLeft + 3) /2 == ��)
	String strNmMenuLeft = "";  //�з���(����)�� �ܰ�(0,2,4...)
	
	Hashtable objDocboxLeftHt = new Hashtable();
	ArrayList objDocboxLeftArry = new ArrayList();

	try 
	{
		nads.dsdm.app.activity.businfo.BusInfoDelegate objBusInfoDelegate = new nads.dsdm.app.activity.businfo.BusInfoDelegate();	
		objDocboxLeftArry = objBusInfoDelegate.selectOrganDocboxList(strUserId);	
	} catch (AppException objAppEx) {
		
		//���� �߻� �޼��� �������� �̵��Ѵ�.
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		objMsgBean.setStrCode(objAppEx.getStrErrCode());
		objMsgBean.setStrMsg(objAppEx.getMessage());
		//out.println("�޴���� ��ȸ �� ���� �߻� || �޼��� �������� �̵�");
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}	
%>	

			<!-------------------------------------- �޴� Tree Start ------------------------------>						
			<SCRIPT LANGUAGE="JavaScript" >
			<!--
			

			aux0=gFld("�μ��ڷ��","", "", "");
<%
		String strUserAllOrganId = "";
		String strOrgGbn = "";
		for (int i=0; i < objDocboxLeftArry.size(); i++)
		{
			objDocboxLeftHt = (Hashtable)objDocboxLeftArry.get(i);

			strOrganIdLeft = (String)objDocboxLeftHt.get("ORGAN_ID");
			strDocboxIdLeft = (String)objDocboxLeftHt.get("DOCBOX_ID");
			strDocboxNmLeft = (String)objDocboxLeftHt.get("DOCBOX_NM");
			strNmMenuLeft = (String)objDocboxLeftHt.get("NM_MENU");
			strTopDocboxIdLeft = (String)objDocboxLeftHt.get("TOP_DOCBOX_ID");
			strSeqLeft = (String)objDocboxLeftHt.get("SEQ");
			//strDocboxNmLeft = nads.lib.util.ActComm.chgSpace(strDocboxNmLeft);

			if (strDocboxIdLeft.equals("M")){
				strUserAllOrganId = strUserAllOrganId + "," + strOrganIdLeft;
				strNumber = "1";
				strOrgGbn = (String)objDocboxLeftHt.get("ORG_POSI_GBN") ;
				if(!strOrgGbn.equals("1")){   //���� ���� '1'->����
					strNmMenuLeft = "(�⹫)" + strNmMenuLeft;
				}
%>
				aux<%=strNumber%> = insFld(aux<%=String.valueOf(Integer.parseInt(strNumber)-1)%>, gFld("<%=strNmMenuLeft%>", "fun_organleft", "0" , "<%=strOrganIdLeft%>", "<%=strNumber%>"));

<%
			}else{
				strNumber = Integer.toString((Integer.parseInt(strSeqLeft) + 3) /2) ;
%>
				aux<%=strNumber%> = insFld(aux<%=String.valueOf(Integer.parseInt(strNumber)-1)%>, gFld("<%=strNmMenuLeft%>", "fun_organleft", "<%=strDocboxIdLeft%>" , "<%=strOrganIdLeft%>", "<%=strNumber%>"));
<%
			}
		}
		strNumber = "1";
%>
			aux<%=strNumber%> = insFld(aux<%=String.valueOf(Integer.parseInt(strNumber)-1)%>, gFld("�ҼӺμ��ڷ���ȸ", "fun_alldutyinfo", "0" , "<%=strUserAllOrganId%>", "<%=strNumber%>"));
			
			if (document.all) {  // IE4
			     document.write("<table border='0' cellpadding='0' cellspacing='0'>");
			     document.write("<td valign='top'>");
			     reloadDocument("<%=strDocboxId%>", "<%=strOrganId%>");
			     document.write("</td>");
			     document.write("</table>");
			}
			else {  // NS4
				 reloadDocument("<%=strDocboxId%>", "<%=strOrganId%>");
			}
		
			//-->
			</SCRIPT>
								