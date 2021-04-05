<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.params.requestinfo.MainReqInfoListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.RequestInfoDelegate" %>

<%
 /*************************************************************************************************/
 /** 					�Ķ���� üũ Part 														  */
 /*************************************************************************************************/

  /** �䱸��� ��� �Ķ���� ����.*/
  MainReqInfoListForm objParams =new MainReqInfoListForm();
  boolean blnParamCheck=false;
  /**���޵� �ĸ����� üũ */
  blnParamCheck=objParams.validateParams(request);
  if(blnParamCheck==false){
  	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	objMsgBean.setStrCode("DSPARAM-0000");
  	objMsgBean.setStrMsg(objParams.getStrErrors());
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%
  	return;
  }//endif
 /*************************************************************************************************/
 /** 					������ ȣ�� Part  														  */
 /*************************************************************************************************/
 ResultSetHelper objReqInfoRs=null;				/**�䱸 ��� */
 boolean blnIsRequester=Boolean.valueOf((String)request.getSession().getAttribute("IS_REQUESTER")).booleanValue();
 try{
   /** �䱸��� ��� �븮��.*/
   RequestInfoDelegate objReqInfo=new RequestInfoDelegate();
   objReqInfoRs=new ResultSetHelper(objReqInfo.getRecordList(objParams));
 }catch(AppException objAppEx){
 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  	objMsgBean.setStrCode(objAppEx.getStrErrCode());
  	objMsgBean.setStrMsg(objAppEx.getMessage());
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%  	
  	return;
 }
%>
<!DOCTYPE HTML PUBLIC "-//w3c//dtd html 4.0 transitional//en">
<%
System.out.println("[JSP] reqsubmit 5==>");
	if(objReqInfoRs.getRecordSize() >0) {//����� ������.
		int i=0;
		String strReqList = "";
		while(objReqInfoRs.next()){
%>
                    <tr> 
                      <td  width="87%" height="18" class="newReqsubmitList"><img src="image/main/icon_bluedot.gif" width="3" height="4" align="absmiddle"> 

     			        <a href="<%=RequestInfoDelegate.getGotoLink(blnIsRequester,
											objReqInfoRs.getObject("REQ_BOX_ID"),
											objReqInfoRs.getObject("REQ_BOX_TP"),
											objReqInfoRs.getObject("REQ_ID"),
											objReqInfoRs.getObject("AUDIT_YEAR"),
											objReqInfoRs.getObject("CMT_ORGAN_ID"),
											objReqInfoRs.getObject("REQ_ORGAN_ID"))%>">
<%
   		    //��� ��¥.
		    String strOutDate=null;
		    strReqList = "[";
		    if(objParams.isRequester()){//�䱸��
		  	  strReqList = strReqList + (String)objReqInfoRs.getObject("SUBMT_ORGAN_NM");//������
		  	  strOutDate=(String)objReqInfoRs.getObject("LAST_ANS_DT");
		    }else{//������
		  	  strReqList = strReqList + (String)objReqInfoRs.getObject("REQ_ORGAN_NM");//������
		  	  strOutDate=(String)objReqInfoRs.getObject("LAST_REQ_DT");
		    }
		    strReqList = strReqList + "] ";
		    strReqList = strReqList + (String)objReqInfoRs.getObject("REQ_CONT");//�䱸���� 30�ڸ� ��������...
%>		
                      <%=nads.lib.util.ActComm.chrString(strReqList,  46)   %>
                     </a>
	               </td>  
	             <td width="13%" align="right" class="newReqsubmitList">[<%=nads.lib.reqsubmit.util.StringUtil.getDate(strOutDate)%>]</td>  
	           </tr>
<%
			i++;
		}//endofwhile
	}else{
		out.println("<tr>");
		out.println("<td  height='18' class='newReqsubmitList'><img src='image/main/icon_bluedot.gif' width='3' height='4' align='absmiddle'> ");
		out.println("�ش� ����Ÿ�� �����ϴ�.");
		out.println("</td>");
		out.println("</tr>");
	}//endif���üũ.
%>
