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
	 if (!confirm("업무를 변경하시겠습니까?")) {
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
	 
// 위원회/의원실 사용자만 겸직체크
if (!"006".equalsIgnoreCase((String)objDupSession.getAttribute("ORGAN_KIND"))) {
     
	 //로그인한 사용자ID를 가져온다.
  	 String strUserID   = objUserInfo.getUserID();
  	 
  	 //겸직정보를 가져온다.
     nads.dsdm.app.common.addjob.AddJobDelegate objAddJobList = new  nads.dsdm.app.common.addjob.AddJobDelegate();
     ArrayList objAdditionalJobList = new ArrayList();
     objAdditionalJobList = objAddJobList.getAddJobList(strUserID);
%>
		<select name="addjob" onChange="javascript:fUsrActionChkAddJob(formAddJob.addjob.value);" class="select">
		<%   //겸직을 Combo에 세팅해준다.
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
					
					//사무처, 예산정책처, 도서관 사용자 기관ID 예외사항 처리 
					//법제실 또는 법제실 하위 부서(의회법제과, 행정법제과, 경재법제과, 산업법제과, 사회법제과)인경우
					if ( strOrganId.equals("GI00004754") || strOrganId.equals("GI00005273") || strOrganId.equals("GI00005274") || strOrganId.equals("GI00005277") || strOrganId.equals("GI00005275") || strOrganId.equals("GI00005276")) {
						strOrganId  = "GI00004754";  			//법제실 부서코드로 세팅
						strAddJob   = "법제실"+strMsortNm;  //기관 및 요구/제출 여부
					
					}else{
					
						// 001(국회사무처), 002(예산정책처), 005(국회도서관) 하위 부서는 Organ_ID를 해당 상위 기관의 Organ_ID로 셋팅한다.
						if ( strOrganKind.equals("001") || strOrganKind.equals("002") || strOrganKind.equals("005") ){
							ArrayList objSuperOrganID = new ArrayList();
							objSuperOrganID = objAddJobList.getSuperOrganID(strOrganId);
							
							//상위기관이 존재하면
							if (objSuperOrganID.size()  > 0) {
								Hashtable objSuperList = (Hashtable)objSuperOrganID.get(0);
								String strNational = (String)objSuperList.get("ORGAN_ID");
								
								//국회사무처, 예산정책처, 국회도서관
								if ( strNational.equals("GI00004739") || strNational.equals("GI00004746") || strNational.equals("GI00004743")) {
										strOrganId  = (String)objSuperList.get("ORGAN_ID");  						//상위기관코드
										//strAddJob   = (String)objSuperList.get("ORGAN_NM")+strMsortNm;  //기관 및 요구/제출 여부
								}
							}
						}
					}
					
					String strSelected = "";
					if (strOrganId.equalsIgnoreCase((String)objDupSession.getAttribute("ORGAN_ID")) && strIsRequester.equalsIgnoreCase((String)objDupSession.getAttribute("IS_REQUESTER"))) {
						strSelected = "selected";
					}

					// 공백이 있을 경우(상위 부서가 존재할 경우) 최하위 부서명만 출력한다.(디자인변경으로 콤보박스 사이즈 고정때문에)
					// 예) 기획조정실 입법정보화담당관실[요구] -> 입법정보화담당관실[요구]
					// 의정자료전자유통시스템 기능개선사업_2011

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
 		&nbsp;<strong><%=request.getSession().getAttribute("USER_NM")%></strong>님 로그인</td>
		<td width="68" align="center" valign="bottom"><a href="/login/LogOut.jsp"><img src="/image/common/bt_logout_sub.gif" width="53" height="17" align="absmiddle" border=0></a></td> 				
	  </tr>
	</form>
</table>
