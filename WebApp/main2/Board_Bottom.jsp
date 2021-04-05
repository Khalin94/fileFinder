<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
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
  String strReqStt = request.getParameter("REQ_STT")==null?"000":request.getParameter("REQ_STT");
  objParams.setParamValue("ReqStt",strReqStt);

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
   System.out.println("----------------------------------------------------------------------");
   objReqInfoRs=new ResultSetHelper(objReqInfo.getRecordList2(objParams));
   System.out.println("----------------------------------------------------------------------");
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
	if(objReqInfoRs.getRecordSize() >0) {//����� ������.
		int i=0;
		String strReqList = "";
		while(objReqInfoRs.next()){
%>
                    <tr>
                      <td height="18" class="newReqsubmitList"><img src="image/main/icon_bluedot.gif" width="3" height="4" align="absmiddle">

     			        <a href="<%=RequestInfoDelegate.getGotoLink2(blnIsRequester,
											objReqInfoRs.getObject("REQ_BOX_ID"),
											objReqInfoRs.getObject("REQ_BOX_TP"),
											objReqInfoRs.getObject("REQ_ID"),
											objReqInfoRs.getObject("AUDIT_YEAR"),
											objReqInfoRs.getObject("CMT_ORGAN_ID"),
											objReqInfoRs.getObject("REQ_ORGAN_ID"),
											objReqInfoRs.getObject("REQ_STT"))%>">
<%
   		    //��� ��¥.
		    String strOutDate=null;
		    strReqList = "[";
		    if(objParams.isRequester()){//�䱸��
		  	  strReqList = strReqList + (String)objReqInfoRs.getObject("SUBMT_ORGAN_NM");//������
			  strOutDate=(String)objReqInfoRs.getObject("LAST_ANS_DT");
		    }else{//������
		  	  strReqList = strReqList + (String)objReqInfoRs.getObject("REQ_ORGAN_NM");//�䱸���
		  	  strOutDate=(String)objReqInfoRs.getObject("LAST_REQ_DT");
		    }
		    strReqList = strReqList + "] ";

			String tempReqCont = (String)objReqInfoRs.getObject("REQ_CONT");
			if(tempReqCont.length() > 20){
				tempReqCont = tempReqCont.substring(0,20) + "...";
			}

		    strReqList = strReqList + tempReqCont ;//�䱸���� 20�ڸ� ��������...
%>
                      <%=nads.lib.util.ActComm.chrString(strReqList,  46)   %>
                     </a>
	               </td>
	             <td width="80px;" align="right" class="newReqsubmitList">[<%=strOutDate==null?"�亯������":nads.lib.reqsubmit.util.StringUtil.getDate(strOutDate)%>]</td>
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
<%
// �� ������ ���� ����Ʈ ��ȸ

	if ("000".equals(strReqStt)){	// ��ü
		strStatus1 = "_on";
		strStatus2 = "";
		strStatus3 = "";
		strStatus4 = "";
		strEventText1 = "";
		strEventText2 = "onMouseOver=\"menuOn(this);\" onMouseOut=\"menuOut(this);\"";
		strEventText3 = "onMouseOver=\"menuOn(this);\" onMouseOut=\"menuOut(this);\"";
		strEventText4 = "onMouseOver=\"menuOn(this);\" onMouseOut=\"menuOut(this);\"";
	} else if ("002".equals(strReqStt)) {	// ����
		strStatus1 = "";
		strStatus2 = "_on";
		strStatus3 = "";
		strStatus4 = "";
		strEventText1 = "onMouseOver=\"menuOn(this);\" onMouseOut=\"menuOut(this);\"";
		strEventText2 = "";
		strEventText3 = "onMouseOver=\"menuOn(this);\" onMouseOut=\"menuOut(this);\"";
		strEventText4 = "onMouseOver=\"menuOn(this);\" onMouseOut=\"menuOut(this);\"";
	} else if ("001".equals(strReqStt)) {	// ������(�߰��䱸 ����)
		strStatus1 = "";
		strStatus2 = "";
		strStatus3 = "_on";
		strStatus4 = "";
		strEventText1 = "onMouseOver=\"menuOn(this);\" onMouseOut=\"menuOut(this);\"";
		strEventText2 = "onMouseOver=\"menuOn(this);\" onMouseOut=\"menuOut(this);\"";
		strEventText3 = "";
		strEventText4 = "onMouseOver=\"menuOn(this);\" onMouseOut=\"menuOut(this);\"";
	}
%>
<script>


  jQuery(document).ready(function(){
	jQuery("#subImgList").find("img").click(function(){
		jQuery("#REQ_STT").val($(this).attr("id"));
		jQuery("#frmMain2").submit();
	});
  });


</script>
<form id="frmMain2" name="frmMain2" method="post">
	<input type="hidden" id="REQ_STT" name="REQ_STT" value="<%=strReqStt%>" />
</form>
<h3 id="subImgList">
	<img id="000" src="images2/main/stl02_list_01<%=strStatus1%>.gif" width="31" height="14" <%=strEventText1%> style="cursor:hand;"/><img id="002" src="images2/main/stl02_list_02<%=strStatus2%>.gif" width="52" height="14" <%=strEventText2%> style="cursor:hand;"/><img id="001" src="images2/main/stl02_list_03<%=strStatus3%>.gif" width="58" height="14" <%=strEventText3%> style="cursor:hand;"/>
</h3>
