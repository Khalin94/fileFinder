<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper " %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.all.ReqInfoAllInOneDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	UserInfoDelegate objUserInfo =null;
	CDInfoDelegate objCdinfo =null;
	ResultSetSingleHelper objReqRs = null;
	ResultSetHelper objAnsRs = null;
%>

<%@ include file="../../../common/RUserCodeInfoInc.jsp" %>

<%
	String[] arrReqBoxIDs = request.getParameterValues("ReqBoxID");
	if(arrReqBoxIDs == null || arrReqBoxIDs.length < 1) {
		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
		objMsgBean.setStrCode("DSPARAM-0000");
		objMsgBean.setStrMsg("�Ķ����(�䱸�� ID)�� ���޵��� �ʾҽ��ϴ�");
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}

	boolean blnEditOk = false; //���� ����.
	int resultInt = -1;
	int resultInt2 = -1;
	int resultInt3 = -1;
	int resultInt4 = -1;
	try{
		
		ReqInfoAllInOneDelegate objReqBox=new ReqInfoAllInOneDelegate();   
		for(int i=0; i<arrReqBoxIDs.length; i++) {
			System.out.println("REQ_BOX_ID : "+arrReqBoxIDs[i]);
			objReqRs = new ResultSetSingleHelper(objReqBox.getReqId(arrReqBoxIDs[i]));
			if(objReqRs != null){
				System.out.println("REQ_ID : "+objReqRs.getObject("REQ_ID"));
				objAnsRs = new ResultSetHelper(objReqBox.getAnsId((String)objReqRs.getObject("REQ_ID")));
			}
			if(((String)objReqRs.getObject("REQ_ID")) != null && !((String)objReqRs.getObject("REQ_ID")).equals("")){
				resultInt3 = objReqBox.deleteAnsInfo((String)objReqRs.getObject("REQ_ID"));	
			}								
			System.out.println("resultInt3 : "+resultInt3);
			if(objAnsRs != null && objAnsRs.getTotalRecordCount() > 0){
				while(objAnsRs.next()){					
					if(resultInt3 > 0 && !((String)objAnsRs.getObject("ANS_FILE_ID")).equals("")){
						System.out.println("ANS_FILE_ID : "+objAnsRs.getObject("ANS_FILE_ID"));
						resultInt4 = objReqBox.deleteAnsFileInfo((String)objAnsRs.getObject("ANS_FILE_ID"));
					}else{
						System.out.println("���⿩��");
						resultInt4 = 1;
					}
					
				}
			}else{
				System.out.println("�亯�̾��� �䱸��");
				resultInt4 = 1;
			}
			System.out.println("resultInt4 : "+resultInt4);
			if(resultInt4 > 0){
				resultInt = objReqBox.deleteReqInfo((String)objReqRs.getObject("REQ_ID"));
			}
			

			if(resultInt > 0){
				resultInt2 = objReqBox.deleteReqBox(arrReqBoxIDs[i]);
			}
			
			if(resultInt2 < 0){
				objMsgBean.setMsgType(MessageBean.TYPE_WARN);
				objMsgBean.setStrCode("DSDATA-0012");
				objMsgBean.setStrMsg("��û�Ͻ� �䱸�� ������ �������� ���߽��ϴ�");
%>
				<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%  	
				return;   	
			}
		}
	} catch(AppException objAppEx) { 
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		System.out.println("SysErrorCode:" + objAppEx.getStrErrCode());
		objMsgBean.setStrCode("SYS-00010");//AppException����.
		objMsgBean.setStrMsg(objAppEx.getMessage());
		//out.println("<br>Error!!!" + objAppEx.getMessage());
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%  	
		return; 
	}
%>

<script language="JavaScript">	
	parent.notProcessing();
	alert("�䱸�� ������ �����Ǿ����ϴ� ");
	parent.location.href='./SMakeOpReqBoxList.jsp?AuditYear=<%=StringUtil.getEmptyIfNull((String)request.getParameter("AuditYear"))%>&ReqOrganID=<%=(String)request.getParameter("ReqOrganID")%>';
	self.close();
</script>
				