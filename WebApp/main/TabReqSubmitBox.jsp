<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.CDInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.RequestBoxDelegate" %>

<%
 /*************************************************************************************************/
 /** 					������ ȣ�� Part  														  */
 /*************************************************************************************************/
 /**�䱸�� ��� */
 ResultSetHelper objReqBoxRs=null;	
 /**�䱸������ �븮�� */
 RequestBoxDelegate objReqBox=null;			
 String strMainIsRequeser=(String)request.getSession().getAttribute("IS_REQUESTER");
 try{
   /** ������ �䱸�� ���  ��� �븮��.*/
   objReqBox=new RequestBoxDelegate();
   objReqBoxRs=objReqBox.getMainReqBoxList((String)request.getSession().getAttribute("ORGAN_ID"),(String)request.getSession().getAttribute("ORGAN_KIND"),strMainIsRequeser);
 }catch(AppException objAppEx){
 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  	objMsgBean.setStrCode(objAppEx.getStrErrCode());
  	objMsgBean.setStrMsg(objAppEx.getMessage());
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%  	
  	return;
 }
 	String strBoxOutDate = "";
	if(objReqBoxRs.getRecordSize() >0) {//����� ������.
		String strReqBox = "";
		while(objReqBoxRs.next()){
%>
		<tr>
		  <td  width="87%" height="18" class="newReqBoxList"><img src="image/main/icon_bluedot.gif" width="3" height="4" align="absmiddle"> 
<%
			out.print("<a href=\"" + objReqBox.getGotoMainReqBoxLink(objReqBoxRs) + "\">");
			strReqBox = "[";
			if(strMainIsRequeser.equalsIgnoreCase("true")){//�䱸��
				strReqBox = strReqBox + (String)objReqBoxRs.getObject("SUBMT_ORGAN_NM");//��������
			}else{//������
				strReqBox = strReqBox + (String)objReqBoxRs.getObject("REQ_ORGAN_NM");//�䱸�����
			}
		    strReqBox = strReqBox + "] ";
		    
		    strReqBox = strReqBox + (String)objReqBoxRs.getObject("REQ_BOX_NM");//�䱸���� 30�ڸ� ��������...
			
			strBoxOutDate = (String)objReqBoxRs.getObject("REG_DT");//�����
%>		
            <%=nads.lib.util.ActComm.chrString(strReqBox,  46)   %>
		    </a>
	      </td>  
	      <td width="13%" align="right" class="newReqBoxList">[<%=nads.lib.reqsubmit.util.StringUtil.getDate(strBoxOutDate)%>]</td>  

		</tr>
	  <%
		}//endofwhile
	}else{
		out.println("<tr>");
		out.println("<td  height='18' class='newReqBoxList'><img src='image/main/icon_bluedot.gif' width='3' height='4' align='absmiddle'> ");
		out.println("�ش� ����Ÿ�� �����ϴ�.");
		out.println("</td>");
		out.println("</tr>");
	}//endif���üũ.
%>
