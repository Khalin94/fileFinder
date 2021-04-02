<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.params.requestinfo.ConcernReqInfoListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.RequestInfoDelegate" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
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
<!DOCTYPE HTML PUBLIC "-//w3c//dtd html 4.0 transitional//en">
<html>
<head>
<title>�������� �ý���</title>
<link href="/css/System.css" rel="stylesheet" type="text/css">
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<h3>�䱸���</h3>
		<table border="1" width="400">
              <tr> 
                <td height="5" align="left" class="soti_mypage">
                ���� �䱸 ���
                </td>
              </tr>
              <tr> 
                <td height="30" class="soti_mypage">
                	<!-------------------- TAB �� �ش��ϴ� ������ ����ϴ� ��������. ------------------------>
                	<table border="0" cellpadding="0" cellspacing="0" width="759">
                		<tr>
                			<td width="400">
				            </td>
				            <td width="359" align="right" valign="bottom" class="text_s">
				             <a href="/reqsubmit/30_opendatalist/ROpenReqList.jsp">�����ڷ��̹���</a>
				            </td>
				       </tr>
				   </table>
                </td>
              </tr>
<%
	if(objReqInfoRs.getRecordSize() >0) {//����� ������.
%>
              <tr> 
                <td align="left" valign="top" class="soti_mypage">
                <!------------------------- TAB�� �ش��ϴ� ���̺�(����̵� ������̵� ��������) ��� ��~~~�� ------------------------->
					<table width="759" border="0" cellspacing="0" cellpadding="0">
                    	<tr> 
                      		<td height="2" class="td_mypage"></td>
	                    </tr>
	                    <tr align="center" class="td_top">
	                    	<td>
	                    		<table width="759" border="0" cellspacing="0" cellpadding="0">
									<tr class="td_top">
										<td height="22" width="19" align="center">NO</td>
										<td width="100" align="center">�䱸���</td>
										<td width="100" align="center">������</td>
										<td width="350" align="center">�䱸����</td>
										<td width="100" align="center">�亯</td>
										<td width="90" align="center">�����</td>
									</tr>
	                    		</table>
	                    	</td>
	                    </tr>
                	    <tr> 
                    	  	<td height="1" class="td_mypage"></td>
                    	</tr>
						<%
						  int intRecordNumber= objReqInfoRs.getRecordSize();
						  while(objReqInfoRs.next()){
						 %>								
						<tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''">
							<td>
								<table width="759" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td height="22" width="19" align="center"><%=intRecordNumber%></td>
										<td width="100" align="center"><%=objReqInfoRs.getObject("REQ_ORGAN_NM")%></td>
										<td width="100" align="center"><%=objReqInfoRs.getObject("SUBMT_ORGAN_NM")%></td>
										<td width="340" class="td_lmagin">
											<a href="<%=objParams.getGotoLink(objReqInfoRs.getObject("AUDIT_YEAR"),
											objReqInfoRs.getObject("CMT_ORGAN_ID"),
											objReqInfoRs.getObject("REQ_ID"))%>"><%=StringUtil.substring((String)objReqInfoRs.getObject("REQ_CONT"),30)%></a></td>
										<td width="100" align="center"><%=nads.lib.reqsubmit.util.DBAccessUtil.makeAnsInfoHtml((String)objReqInfoRs.getObject("ANS_ID"),(String)objReqInfoRs.getObject("ANS_MTD"),(String)objReqInfoRs.getObject("ANS_OPIN"),(String)objReqInfoRs.getObject("SUBMT_FLAG"),true)%></td>
										<td width="90" align="center"><%=StringUtil.getDate((String)objReqInfoRs.getObject("LAST_ANS_DT"))%> </td>
									</tr>
								</table>
							</td>
						</tr>
    	                <tr class="tbl-line"> 
                      		<td height="1"></td>
                    	</tr>       	
						<%
							    intRecordNumber --;
							}//endwhile
						%>
    	                <tr class="tbl-line"> 
                      		<td height="1"></td>
                    	</tr>       													
	                </table>
				<!------------------------- TAB�� �ش��ϴ� ���̺�(����̵� ������̵� ��������) ��� �� ------------------------->
               </td>
              </tr>
		</table>
<%
	}//endif���üũ.
%>
</body>
</html>              
