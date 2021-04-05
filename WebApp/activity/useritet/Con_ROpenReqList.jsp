<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.params.requestinfo.ConcernReqInfoListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.RequestInfoDelegate" %>
<%
 /*************************************************************************************************/
 /** 					�Ķ���� üũ Part 														  */
 /*************************************************************************************************/

  /** �䱸��� ��� �Ķ���� ����.*/
  ConcernReqInfoListForm objParams =new ConcernReqInfoListForm();
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
<!-- list -->

          <span class="list01_tl">
          <%=strPrgNm%><span class="sbt"><a href="<%=strPrgUrl%>"><img src="/images2/btn/bt_all.gif" width="78" height="19" /></a></span></span>
          <table>
			  <tr>
				<td>&nbsp;</td>
			  </tr>
		  </table>
          <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
            <thead>
              <tr>
                <th scope="col"><a>NO</a></th>
                <th scope="col" style="width:300px; "><a>�䱸���</a></th>
                <th scope="col"><a>������</a></th>
                <th scope="col"><a>�䱸����</a></th>
                <th scope="col"><a>�亯</a></th>
                <th scope="col"><a>�����</a></th>
              </tr>
            </thead>
					 <%
						if(objReqInfoRs.getRecordSize()>0){
							int i=1;
							while(objReqInfoRs.next()) {
					%>
            <tbody>
              <tr>
                <td><%=Integer.toString(1)%></td>
                <td style="text-align:left;"><%=objReqInfoRs.getObject("REQ_ORGAN_NM")%></td>
                <td><%=objReqInfoRs.getObject("SUBMT_ORGAN_NM")%></td>
                <td> <a href="<%=objParams.getGotoLink(objReqInfoRs.getObject("AUDIT_YEAR"),
					                        objReqInfoRs.getObject("CMT_ORGAN_ID"),
					                        objReqInfoRs.getObject("REQ_ID"))%>"><%=nads.lib.reqsubmit.util.StringUtil.substring((String)objReqInfoRs.getObject("REQ_CONT"),30)%>
					 </a>
				</td>
                <td><%=nads.lib.reqsubmit.util.DBAccessUtil.makeAnsInfoHtml((String)objReqInfoRs.getObject("ANS_ID"),(String)objReqInfoRs.getObject("ANS_MTD"),(String)objReqInfoRs.getObject("ANS_OPIN"),(String)objReqInfoRs.getObject("SUBMT_FLAG"),true)%></td>
                <td><%=nads.lib.reqsubmit.util.StringUtil.getDate((String)objReqInfoRs.getObject("LAST_ANS_DT"))%></td>
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
                   <td width="104" align="left"><a href="<%=strPrgUrl%>"><img src="../../image/button/bt_allList.gif" width="101" height="20" border="0"></a></td>
                 </tr>
                 <tr>
                 <td colspan="2" align="left" valign="top"><table width="759" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td height="2" colspan="6" class="td_mypage"></td>
                    </tr>
                    <tr class="td_top">
                      <td width="48" height="22" align="center">NO</td>
                      <td width="100" height="22" align="center">�䱸���</td>
                      <td width="100" height="22" align="center">������</td>
                      <td width="290" height="22" align="center">�䱸����</td>
                      <td width="126" height="22" align="center">�亯</td>
                      <td width="95" height="22" align="center">�����</td>
                    </tr>
                    <tr>
                      <td height="1" colspan="6" class="td_mypage"></td>
                    </tr>
                    <%
						if(objReqInfoRs.getRecordSize()>0){
							int i=1;
							while(objReqInfoRs.next()) {
					%>
                    <tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''">
					  <td height="22" align="center"><%=Integer.toString(1)%></td>
					  <td height="22" align="center"><%=objReqInfoRs.getObject("REQ_ORGAN_NM")%></td>
					  <td height="22" align="center"><%=objReqInfoRs.getObject("SUBMT_ORGAN_NM")%></td>
					  <td height="22" class="td_lmagin">
					    <a href="<%=objParams.getGotoLink(objReqInfoRs.getObject("AUDIT_YEAR"),
					                        objReqInfoRs.getObject("CMT_ORGAN_ID"),
					                        objReqInfoRs.getObject("REQ_ID"))%>"><%=nads.lib.reqsubmit.util.StringUtil.substring((String)objReqInfoRs.getObject("REQ_CONT"),30)%>
					    </a>
					  </td>
					  <td height="22" align="center"><%=nads.lib.reqsubmit.util.DBAccessUtil.makeAnsInfoHtml((String)objReqInfoRs.getObject("ANS_ID"),(String)objReqInfoRs.getObject("ANS_MTD"),(String)objReqInfoRs.getObject("ANS_OPIN"),(String)objReqInfoRs.getObject("SUBMT_FLAG"),true)%></td>
					  <td height="22" align="center"><%=nads.lib.reqsubmit.util.StringUtil.getDate((String)objReqInfoRs.getObject("LAST_ANS_DT"))%> </td>
                    </tr>
                    <tr class="tbl-line">
                      <td height="1"></td>
                      <td height="1"></td>
                      <td height="1"></td>
                      <td height="1" align="left" class="td_lmagin"></td>
                      <td height="1"></td>
                      <td height="1"></td>
                    </tr>
                    <%
                    		i++;
							}
						} else {

							out.println("<tr>");
							out.println("<td height='22' colspan='6' align='center'>�ش� ����Ÿ�� �����ϴ�.");
							out.println("</td>");
							out.println("</tr>");
							out.println("<tr class='tbl-line'>");
							out.println("<td height='1'></td>");
							out.println("<td height='1'></td>");
							out.println("<td height='1'></td>");
							out.println("<td height='1' align='left' class='td_lmagin'></td>");
							out.println("<td height='1'></td>");
							out.println("<td height='1'></td>");
							out.println("</tr>");

						}
					%>
					 <tr class="tbl-line">
                      <td height="1"></td>
                      <td height="1"></td>
                      <td height="1"></td>
                      <td height="1" align="left" class="td_lmagin"></td>
                      <td height="1"></td>
                      <td height="1"></td>
                    </tr>
                  </table>
				 </td>
              </tr>


-->
