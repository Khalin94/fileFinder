<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	 UserInfoDelegate objUserInfo =null;
	 CDInfoDelegate objCdinfo =null;
%>

<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>
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
<table width="600" border="0" cellspacing="1" cellpadding="0">
	<form name="formAddJob" method="post" action="/common/AddJobSessionProc.jsp">
	  <tr> 
		<td width="529" align="right" valign="middle"><img src="/image/main/icon_login.gif" width="9" height="9" align="absmiddle"> 		
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
 		&nbsp;<strong><%=request.getSession().getAttribute("USER_NM")%></strong>�� �α���</td>
		<td width="68" align="center" valign="bottom"><a href="/login/LogOut.jsp"><img src="/image/common/bt_logout_sub.gif" width="53" height="17" align="absmiddle" border=0></a></td> 				
	  </tr>
	</form>
</table>
