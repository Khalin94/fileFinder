<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
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
 String strReqBoxStt = request.getParameter("REQ_BOX_STT")==null?"000":request.getParameter("REQ_BOX_STT");

 if(strMainIsRequeser.equals("false") && strReqBoxStt.equals("000")){
	strReqBoxStt = "006";
 }
 
 System.out.println("Main stt "+strReqBoxStt);
 System.out.println("Main requester "+strMainIsRequeser);
 try{
   /** ������ �䱸�� ���  ��� �븮��.*/
   objReqBox=new RequestBoxDelegate();
   System.out.println("----------------------------------------------------------------------");
   objReqBoxRs=objReqBox.getMainReqBoxList2((String)request.getSession().getAttribute("ORGAN_ID"),(String)request.getSession().getAttribute("ORGAN_KIND"),strMainIsRequeser,strReqBoxStt);
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
 	String strBoxOutDate = "";
	if(objReqBoxRs.getRecordSize() >0) {//����� ������.
		String strReqBox = "";
		int cnt = 0;
		while(objReqBoxRs.next()){
			if(cnt==4) break;
%>
		<tr>
		  <td height="18" class="newReqBoxList"><img src="image/main/icon_bluedot.gif" width="3" height="4" align="absmiddle">
<%
            System.out.println("ssssssssssssssss"+(String)objReqBoxRs.getObject("REQ_BOX_TP"));
			out.print("<a href=\"" + objReqBox.getGotoMainReqBoxLink2(objReqBoxRs,(String)objReqBoxRs.getObject("REQ_BOX_STT")) + "\">");
			strReqBox = "[";
			if(strMainIsRequeser.equalsIgnoreCase("true")){//�䱸��
				strReqBox = strReqBox + (String)objReqBoxRs.getObject("SUBMT_ORGAN_NM");//��������
			}else{//������
				strReqBox = strReqBox + (String)objReqBoxRs.getObject("REQ_ORGAN_NM");//�䱸�����
			}
		    strReqBox = strReqBox + "] ";

			String tempReqBoxNM = (String)objReqBoxRs.getObject("REQ_BOX_NM");
			if(tempReqBoxNM.length() > 20){
				tempReqBoxNM = tempReqBoxNM.substring(0,20) + "...";
			}

		    strReqBox = strReqBox + tempReqBoxNM ;//�䱸���� 20�ڸ� ��������...

			strBoxOutDate = (String)objReqBoxRs.getObject("REG_DT");//�����
%>
            <%=nads.lib.util.ActComm.chrString(strReqBox,  46)   %>
		    </a>
	      </td>
	      <td width="80px;" align="right" class="newReqBoxList">[<%=nads.lib.reqsubmit.util.StringUtil.getDate(strBoxOutDate)%>]</td>

		</tr>
	  <%
			cnt++;
		}//endofwhile
	}else{
		out.println("<tr>");
		out.println("<td  height='18' class='newReqBoxList'><img src='image/main/icon_bluedot.gif' width='3' height='4' align='absmiddle'> ");
		out.println("�ش� ����Ÿ�� �����ϴ�.");
		out.println("</td>");
		out.println("</tr>");
	}//endif���üũ.
%>
<%
// �� ������ ���� ����Ʈ ��ȸ

	String strStatus1 = "";
	String strStatus2 = "";
	String strStatus3 = "";
	String strStatus4 = "";
	String strEventText1 = "";
	String strEventText2 = "";
	String strEventText3 = "";
	String strEventText4 = "";

	if ("000".equals(strReqBoxStt)){	// ��ü
		strStatus1 = "_on";
		strStatus2 = "";
		strStatus3 = "";
		strStatus4 = "";
		strEventText1 = "";
		strEventText2 = "onMouseOver=\"menuOn(this);\" onMouseOut=\"menuOut(this);\"";
		strEventText3 = "onMouseOver=\"menuOn(this);\" onMouseOut=\"menuOut(this);\"";
		strEventText4 = "onMouseOver=\"menuOn(this);\" onMouseOut=\"menuOut(this);\"";
	} else if ("003".equals(strReqBoxStt)) {	// �ǿ� : �ۼ���, ��� : X, ����ȸ : �����Ϸ�
		strStatus1 = "";
		strStatus2 = "_on";
		strStatus3 = "";
		strStatus4 = "";
		strEventText1 = "onMouseOver=\"menuOn(this);\" onMouseOut=\"menuOut(this);\"";
		strEventText2 = "";
		strEventText3 = "onMouseOver=\"menuOn(this);\" onMouseOut=\"menuOut(this);\"";
		strEventText4 = "onMouseOver=\"menuOn(this);\" onMouseOut=\"menuOut(this);\"";
	} else if ("006".equals(strReqBoxStt)) {	// �ǿ�, ����ȸ : �߼ۿϷ�, ��� : �ۼ���
		strStatus1 = "";
		strStatus2 = "";
		strStatus3 = "_on";
		strStatus4 = "";
		strEventText1 = "onMouseOver=\"menuOn(this);\" onMouseOut=\"menuOut(this);\"";
		strEventText2 = "onMouseOver=\"menuOn(this);\" onMouseOut=\"menuOut(this);\"";
		strEventText3 = "";
		strEventText4 = "onMouseOver=\"menuOn(this);\" onMouseOut=\"menuOut(this);\"";
	} else if ("007".equals(strReqBoxStt)) {	// ����Ϸ�
		strStatus1 = "";
		strStatus2 = "";
		strStatus3 = "";
		strStatus4 = "_on";
		strEventText1 = "onMouseOver=\"menuOn(this);\" onMouseOut=\"menuOut(this);\"";
		strEventText2 = "onMouseOver=\"menuOn(this);\" onMouseOut=\"menuOut(this);\"";
		strEventText3 = "onMouseOver=\"menuOn(this);\" onMouseOut=\"menuOut(this);\"";
		strEventText4 = "";
	}

%>
<script>


  jQuery(document).ready(function(){
	jQuery("#topImgList").find("img").click(function(){
		jQuery("#REQ_BOX_STT").val($(this).attr("id"));
		jQuery("#frmMain").submit();
	});
  });


</script>
<form id="frmMain" name="frmMain" method="post">
	<input type="hidden" id="REQ_BOX_STT" name="REQ_BOX_STT" value="<%=strReqBoxStt%>" />
</form>

<h3 id="topImgList" >
	<%if("true".equals(strMainIsRequeser)){ %>
	<!-- �ǿ��� -->
	<img id="000" src="images2/main/stl01_box_01<%=strStatus1%>.gif" width="32" height="14" <%=strEventText1%> style="cursor:hand;"/><img id="003" src="images2/main/stl01_box_02<%=strStatus2%>.gif" width="41" height="14" <%=strEventText2%> style="cursor:hand;"/><img id="006" src="images2/main/stl01_box_04<%=strStatus3%>.gif" width="52" height="14" <%=strEventText3%> style="cursor:hand;"/><img id="007" src="images2/main/stl01_box_05<%=strStatus4%>.gif" width="49" height="14" <%=strEventText4%> style="cursor:hand;"/>
	<%}else{ %>
	<!-- ��� -->
	<img id="000" src="images2/main/stl01_box2_01<%=strStatus1%>.gif" width="34" height="14" <%=strEventText1%> style="cursor:hand;"/><img id="006" src="images2/main/stl01_box2_02<%=strStatus3%>.gif" width="49" height="14" <%=strEventText3%> style="cursor:hand;"/><img id="007" src="images2/main/stl01_box2_03<%=strStatus4%>.gif" width="57" height="14" <%=strEventText4%> style="cursor:hand;"/>
	<%} %>
	<!-- ����ȸ
	<img id="000" src="images2/main/stl01_box_01<%=strStatus1%>.gif" width="32" height="14" <%=strEventText1%> /><img id="003" src="images2/main/stl01_box_03<%=strStatus2%>.gif" width="51" height="14" <%=strEventText2%> /><img id="006" src="images2/main/stl01_box_04<%=strStatus3%>.gif" width="52" height="14" <%=strEventText3%> /><img id="007" src="images2/main/stl01_box_05<%=strStatus4%>.gif" width="49" height="14" <%=strEventText4%> />-->
</h3>