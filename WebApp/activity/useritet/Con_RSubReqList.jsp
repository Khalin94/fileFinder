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
	String 	strOrganTitle = "";
	String 	strDateTitle = "";
	String strOrganTmp = "";
	String strOutDate= "";
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

	if (strUserGubn.equals("true")){
		strOrganTitle = "������";
		strDateTitle = "��������";
		strPrgNm = "�ű�������";
	}else{
		strOrganTitle = "�䱸���";
		strDateTitle = "�䱸����";
		strPrgNm = "�űԿ䱸���";
	}
	boolean blnIsRequesterTop=false;
	blnIsRequesterTop=Boolean.valueOf((String)request.getSession().getAttribute("IS_REQUESTER")).booleanValue();
%>
<!-- list -->
  <span class="list01_tl">
  <%=strPrgNm%><span class="sbt"><a href="<%=RequestInfoDelegate.gotoMainMoreLink(blnIsRequesterTop,(String)request.getSession().getAttribute("ORGAN_KIND"))%>"><img src="/images2/btn/bt_all.gif" width="78" height="19" border="0"></a></span></span>
  <table>
	  <tr>
		<td>&nbsp;</td>
	  </tr>
  </table>
  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
	<thead>
	  <tr>
		<th scope="col"><a>NO</a></th>
		<th scope="col" style="width:300px; "><a>����</a></th>
        <th scope="col"><a><%=strOrganTitle%></a></th>
		<th scope="col"><a><%=strDateTitle%></a></th>
	  </tr>
	</thead>
<%
	if(objReqInfoRs.getRecordSize() >0) {//����� ������.
		int i=1;
		while(objReqInfoRs.next()){

			if (strUserGubn.equals("true")){
				strOrganTmp = (String)objReqInfoRs.getObject("SUBMT_ORGAN_NM");
				strOutDate=(String)objReqInfoRs.getObject("LAST_ANS_DT");
			}else{
				strOrganTmp = (String)objReqInfoRs.getObject("REQ_ORGAN_NM");
				strOutDate=(String)objReqInfoRs.getObject("LAST_REQ_DT");
			}
%>
	<tbody>
	  <tr>
		<td><%=Integer.toString(i)%></td>
        <td>
			<a href="<%=RequestInfoDelegate.getGotoLink(blnIsRequester,
												objReqInfoRs.getObject("REQ_BOX_ID"),
												objReqInfoRs.getObject("REQ_BOX_TP"),
												objReqInfoRs.getObject("REQ_ID"),
												objReqInfoRs.getObject("AUDIT_YEAR"),
												objReqInfoRs.getObject("CMT_ORGAN_ID"),
												objReqInfoRs.getObject("REQ_ORGAN_ID"))%>">

							<%=(String)objReqInfoRs.getObject("REQ_CONT")%>
			</a>
		</td>
        <td><%=strOrganTmp%></td>
		<td><%=nads.lib.reqsubmit.util.StringUtil.getDate(strOutDate)%></td>
	  </tr>
	</tbody>
<%
			i++;
		}
		} else {
		%>
	<tbody>
	  <tr>
		<td colspan="5">�ش� ����Ÿ�� �����ϴ�</td>
	  </tr>
	</tbody>
		<%
			}
		%>
	</table>

<!-- /list -->

<!-- 2011-09-05 ���� �ҽ�
 <tr>
                  <td height="5" colspan="2" align="left" class="soti_reqsubmit"></td>
                </tr>
                 <tr>
                   <td width="655" height="30" align="left"><span class="soti_reqsubmit"><img src="../../image/mypage/icon_mypage_soti.gif" width="9" height="9" align="absmiddle">
                     </span><span class="soti_mypage"><%=strPrgNm%></span></td>
                   <td width="104" align="left"><a href="<%=RequestInfoDelegate.gotoMainMoreLink(blnIsRequesterTop,(String)request.getSession().getAttribute("ORGAN_KIND"))%>"><img src="../../image/button/bt_allList.gif" width="101" height="20" border="0"></a></td>
                 </tr>
                 <tr>
                 <td colspan="2" align="left" valign="top"><table width="759" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td height="2" colspan="4" class="td_mypage"></td>
                    </tr>
                    <tr class="td_top">
                      <td width="48" height="22" align="center">NO</td>
                      <td width="150" height="22" align="center"><%=strOrganTitle%></td>
                      <td width="466" height="22" align="center">����</td>
                      <td width="95" height="22" align="center"><%=strDateTitle%></td>
                    </tr>
                    <tr>
                      <td height="1" colspan="4" class="td_mypage"></td>
                    </tr>
<%
	if(objReqInfoRs.getRecordSize() >0) {//����� ������.
		int i=1;
		while(objReqInfoRs.next()){

			if (strUserGubn.equals("true")){
				strOrganTmp = (String)objReqInfoRs.getObject("SUBMT_ORGAN_NM");
				strOutDate=(String)objReqInfoRs.getObject("LAST_ANS_DT");
			}else{
				strOrganTmp = (String)objReqInfoRs.getObject("REQ_ORGAN_NM");
				strOutDate=(String)objReqInfoRs.getObject("LAST_REQ_DT");
			}
%>
                    <tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''">
					  <td height="22" align="center"><%=Integer.toString(i)%></td>
					  <td height="22" align="center"><%=strOrganTmp%></td>
					  <td height="22" class="td_lmagin">
						<a href="<%=RequestInfoDelegate.getGotoLink(blnIsRequester,
											objReqInfoRs.getObject("REQ_BOX_ID"),
											objReqInfoRs.getObject("REQ_BOX_TP"),
											objReqInfoRs.getObject("REQ_ID"),
											objReqInfoRs.getObject("AUDIT_YEAR"),
											objReqInfoRs.getObject("CMT_ORGAN_ID"),
											objReqInfoRs.getObject("REQ_ORGAN_ID"))%>">

					    <%=(String)objReqInfoRs.getObject("REQ_CONT")%>
					    </a>
					  </td>
					  <td height="22" align="center"><%=nads.lib.reqsubmit.util.StringUtil.getDate(strOutDate)%></td>
                    </tr>
                    <tr class="tbl-line">
                      <td height="1"></td>
                      <td height="1"></td>
                       <td height="1" align="left" class="td_lmagin"></td>
                      <td height="1"></td>
                    </tr>
<%
			i++;
		}
	} else {
		out.println("<tr>");
		out.println("<td height='22' colspan='4' align='center'>�ش� ����Ÿ�� �����ϴ�.");
		out.println("</td>");
		out.println("</tr>");
		out.println("<tr class='tbl-line'>");
		out.println("<td height='1'></td>");
		out.println("<td height='1' align='left' class='td_lmagin'></td>");
		out.println("<td height='1' align='left' class='td_lmagin'></td>");
		out.println("<td height='1' align='left' class='td_lmagin'></td>");
		out.println("</tr>");
	}
%>
					 <tr class="tbl-line">
                      <td height="1"></td>
                      <td height="1"></td>
                      <td height="1" align="left" class="td_lmagin"></td>
                      <td height="1"></td>
                    </tr>
                  </table>
				 </td>
              </tr>


-->