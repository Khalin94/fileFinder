<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.params.requestinfo.MainReqInfoListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.RequestInfoDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	 UserInfoDelegate objUserInfo =null;
	 CDInfoDelegate objCdinfo =null;
%>

<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>
<%
 /*************************************************************************************************/
 /** 					������ ȣ�� Part  														  */
 /*************************************************************************************************/
	java.util.Hashtable objMainCntHashTop=null;//�䱸�������ϱ� �ؽ�.
	boolean blnIsRequesterTop=false;
	RequestInfoDelegate objReqInfoTop=null;
	try{
  		blnIsRequesterTop=Boolean.valueOf((String)request.getSession().getAttribute("IS_REQUESTER")).booleanValue();
		/** �䱸��� ��� �븮��.*/
		objReqInfoTop=new RequestInfoDelegate();
		objMainCntHashTop=objReqInfoTop.getMainReqCount((String)request.getSession().getAttribute("ORGAN_ID"),blnIsRequesterTop,(String)request.getSession().getAttribute("ORGAN_KIND"));
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
<script language="javascript">
function fUsrActionChkAddJob(strCngJob) {
	//alert(strCngJob);
	 if (!confirm("������ �����Ͻðڽ��ϱ�?")) {
		location.reload();
		return false;
	 };
	 formAddJob.submit();
}
</script>
<div id="loginfo">
	<form name="formAddJob" method="post" action="/common/AddJobSessionProc.jsp">
<%
	 HttpSession objDupSession = request.getSession();

// ����ȸ/�ǿ��� ����ڸ� ����üũ
if (!"006".equalsIgnoreCase((String)objDupSession.getAttribute("ORGAN_KIND"))) {

	 //�α����� �����ID�� �����´�.
  	 String strUserID   = objUserInfo.getUserID();

  	 //���������� �����´�.
     nads.dsdm.app.common.addjob.AddJobDelegate objAddJobList = new  nads.dsdm.app.common.addjob.AddJobDelegate();
     ArrayList objAdditionalJobList = new ArrayList();
     objAdditionalJobList = objAddJobList.getAddJobList(strUserID);
%>
		<select name="addjob" onChange="javascript:fUsrActionChkAddJob(formAddJob.addjob.value);" class="select">
		<%   //������ Combo�� �������ش�.
			if (objAdditionalJobList.size()  > 0) {
				for(int i=0; i < objAdditionalJobList.size(); i++){
					Hashtable objAddList = (Hashtable)objAdditionalJobList.get(i);

					String strUserId   			 = (String)objAddList.get("USER_ID");
					String strUserNm 			 = (String)objAddList.get("USER_NM");
					String strOrganId 			 = (String)objAddList.get("ORGAN_ID");
					String strReqSubmitFlag		 = (String)objAddList.get("MSORT_CD");
					String strIsRequester        = (String)objAddList.get("REQORSEND");
					String strOrganKind			 = (String)objAddList.get("ORGAN_KIND");
					String strOrgPosiGbn 		 = (String)objAddList.get("ORG_POSI_GBN");
					String strSrchRecordCnt 	 = (String)objAddList.get("SRCH_RECORD_CNT");
					String strSrchDisplayKind	 = (String)objAddList.get("SRCH_DISPLAY_KIND");
					String strGtherPeriod 	     = (String)objAddList.get("GTHER_PERIOD");
					String strInOutGbn			 = (String)objAddList.get("INOUT_GBN");
					String strAddJob  			 = (String)objAddList.get("DEPT_NM");
					String strMsortNm            = (String)objAddList.get("MSORT_NM");
					String strBasicOrganId 		 = (String)objAddList.get("ORGAN_ID");

					//�繫ó, ������åó, ������ ����� ���ID ���ܻ��� ó��
					//������ �Ǵ� ������ ���� �μ�(��ȸ������, ����������, ���������, ���������, ��ȸ������)�ΰ��
					if ( strOrganId.equals("GI00004754") || strOrganId.equals("GI00005273") || strOrganId.equals("GI00005274") || strOrganId.equals("GI00005277") || strOrganId.equals("GI00005275") || strOrganId.equals("GI00005276")) {
						strOrganId  = "GI00004754";  			//������ �μ��ڵ�� ����
						strAddJob   = "������"+strMsortNm;  //��� �� �䱸/���� ����

					}else{

						// 001(��ȸ�繫ó), 002(������åó), 005(��ȸ������) ���� �μ��� Organ_ID�� �ش� ���� ����� Organ_ID�� �����Ѵ�.
						if ( strOrganKind.equals("001") || strOrganKind.equals("002") || strOrganKind.equals("005") ){
							ArrayList objSuperOrganID = new ArrayList();
							objSuperOrganID = objAddJobList.getSuperOrganID(strOrganId);

							//��������� �����ϸ�
							if (objSuperOrganID.size()  > 0) {
								Hashtable objSuperList = (Hashtable)objSuperOrganID.get(0);
								String strNational = (String)objSuperList.get("ORGAN_ID");

								//��ȸ�繫ó, ������åó, ��ȸ������
								if ( strNational.equals("GI00004739") || strNational.equals("GI00004746") || strNational.equals("GI00004743")) {
										strOrganId  = (String)objSuperList.get("ORGAN_ID");  						//��������ڵ�
										//strAddJob   = (String)objSuperList.get("ORGAN_NM")+strMsortNm;  //��� �� �䱸/���� ����
								}
							}
						}
					}

					String strSelected = "";
					if (strOrganId.equalsIgnoreCase((String)objDupSession.getAttribute("ORGAN_ID")) && strIsRequester.equalsIgnoreCase((String)objDupSession.getAttribute("IS_REQUESTER"))) {
						strSelected = "selected";
					}

					// ������ ���� ���(���� �μ��� ������ ���) ������ �μ��� ����Ѵ�.(�����κ������� �޺��ڽ� ������ ����������)
					// ��) ��ȹ������ �Թ�����ȭ������[�䱸] -> �Թ�����ȭ������[�䱸]
					// �����ڷ���������ý��� ��ɰ������_2011

					StringBuffer sb = new StringBuffer();
					if(strAddJob != null ){
						for(int s=0; s<strAddJob.length(); s++ ){
							if(strAddJob.charAt(s) == ' '){
								String[] arr = strAddJob.split(" ");
								strAddJob = arr[arr.length-1];
							}
						}
					}
		%>
		<option  value="<%=strAddJob%>^<%=strUserId%>^<%=strUserNm%>^<%=strOrganId%>^<%=strReqSubmitFlag%>^<%=strIsRequester%>^<%=strOrganKind%>^<%=strOrgPosiGbn%>^<%=strSrchRecordCnt%>^<%=strSrchDisplayKind%>^<%=strGtherPeriod%>^<%=strInOutGbn%>^<%=strBasicOrganId%>" <%= strSelected %>><%=strAddJob%></option>
		<%
				}
			}
		%>
		</select>
<%
	}
%>
		<table width="167px" border="0" cellspacing="0" cellpadding="0">

			<tr>
				<td ><span class="name"><%=request.getSession().getAttribute("USER_NM")%>�� �α���</span> <span class="logbt"><a href="/login/LogOut.jsp"><img src="/images2/btn/btn_logout.gif" width="60" height="20" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);" border=0 /></a></span></td>
			</tr>

			<%
					String strOrganKindS = (String)request.getSession().getAttribute("ORGAN_KIND");
					String strTempUrl = "";
					if(blnIsRequesterTop){
						if(strOrganKindS.equals("004")){//����ȸ ����̸� ����ȸ �䱸������� ����.
							//strTempUrl = "/reqsubmit/20_comm/30_reqlistsh/RCommSubReqList.jsp";
							strTempUrl = "/reqsubmit/20_comm/30_reqlistsh/20_nonsub/RNonReqList.jsp";
							
						}else{
							strTempUrl = "/reqsubmit/10_mem/30_reqlistsh/20_nonsub/RNonReqList.jsp";
						}
					}else{
						strTempUrl = "/reqsubmit/10_mem/30_reqlistsh/20_nonsub/SNonReqList.jsp";
					}
			%>

			<tr>
				<td ><span class="left">&bull;&nbsp;<a href="<%=strTempUrl%>">�������ڷ�&nbsp;</a><span class="num"><%=nads.lib.reqsubmit.util.HashtableUtil.getEmptyIfNull(objMainCntHashTop,"DIFF_SUM","0")%></span> </span><span class="right">&bull;&nbsp;���Ѱ���ڷ�&nbsp;<span class="num"><%=nads.lib.reqsubmit.util.HashtableUtil.getEmptyIfNull(objMainCntHashTop,"DELAY_SUBMT","0")%></span></span></td>
			</tr>
		</table>
	</form>
</div>

