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
 /** 					데이터 호출 Part  														  */
 /*************************************************************************************************/
	java.util.Hashtable objMainCntHashTop=null;//요구개수구하기 해쉬.
	boolean blnIsRequesterTop=false;
	RequestInfoDelegate objReqInfoTop=null;
	try{
  		blnIsRequesterTop=Boolean.valueOf((String)request.getSession().getAttribute("IS_REQUESTER")).booleanValue();
		/** 요구목록 출력 대리자.*/
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
	 if (!confirm("업무를 변경하시겠습니까?")) {
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
		<table width="167px" border="0" cellspacing="0" cellpadding="0">

			<tr>
				<td ><span class="name"><%=request.getSession().getAttribute("USER_NM")%>님 로그인</span> <span class="logbt"><a href="/login/LogOut.jsp"><img src="/images2/btn/btn_logout.gif" width="60" height="20" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);" border=0 /></a></span></td>
			</tr>

			<%
					String strOrganKindS = (String)request.getSession().getAttribute("ORGAN_KIND");
					String strTempUrl = "";
					if(blnIsRequesterTop){
						if(strOrganKindS.equals("004")){//위원회 기관이면 위원회 요구목록으로 가기.
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
				<td ><span class="left">&bull;&nbsp;<a href="<%=strTempUrl%>">미제출자료&nbsp;</a><span class="num"><%=nads.lib.reqsubmit.util.HashtableUtil.getEmptyIfNull(objMainCntHashTop,"DIFF_SUM","0")%></span> </span><span class="right">&bull;&nbsp;기한경과자료&nbsp;<span class="num"><%=nads.lib.reqsubmit.util.HashtableUtil.getEmptyIfNull(objMainCntHashTop,"DELAY_SUBMT","0")%></span></span></td>
			</tr>
		</table>
	</form>
</div>

