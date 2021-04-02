<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.bf.config.*"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.params.cmtsubmt.CmtSubmitReqBoxApplyForm"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.cmtsubmt.CmtSubmtReqBoxDelegate" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%
 UserInfoDelegate objUserInfo =null;
 CDInfoDelegate objCdinfo =null;
%>
<%@ include file="../../../common/RUserCodeInfoInc.jsp" %>
<%
 /*************************************************************************************************/
 /** 					파라미터 체크 Part 														  */
 /*************************************************************************************************/
  String strRightNow=(String)request.getParameter("RightNow");//즉시처리할것인지 여부 반환. Yes
  String strAuditYear = (String)request.getParameter("AuditYear");
  
  CmtSubmitReqBoxApplyForm objParams =new CmtSubmitReqBoxApplyForm();  
  boolean blnParamCheck=false;
  /**전달된 파리미터 체크 */
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
%>
<%
 /*************************************************************************************************/
 /** 					데이터 처리 Part 														  */
 /*************************************************************************************************/
 String strOffiDocNo=null; //공문번호.
 String strGovStdCD=null;//행정구분코드
 String strReqScheID=null;  //처리할 요구일자정 ID
 String[] strPdfInfoArr=null;
 
 String strCmtOrganNM="";//위원회명 (전자결재용) ORGAN_NM
 String strCmtGovStdCD=""; //위원회 GCC코드 (전자결재용) GOV_STD_CD
 try{
   /********* 대리자 정보 설정 *********/
   CmtSubmtReqBoxDelegate objReqBox=new CmtSubmtReqBoxDelegate();
   /** 1.위원회 일정확인 */
   strReqScheID = objReqBox.checkHavingCommSche(objParams.getParamValue("CmtOrganID"), strAuditYear);
   if(!StringUtil.isAssigned(strReqScheID)){
 	objMsgBean.setMsgType(MessageBean.TYPE_INFO);
  	objMsgBean.setStrCode("DSDATA-0020");
  	objMsgBean.setStrMsg("진행중인 위원회 일정이 없습니다.");
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%  	
  	return; 
   }
   /** 2.위원회 제출신청서 만들기 */
   strPdfInfoArr=objReqBox.getApplyPdfDocEncBase64(objUserInfo.getUserID(),objParams.getParamValue("ReqBoxID"));
   
    /** 즉시 완료 처리할경우 */
   if(StringUtil.isAssigned(strRightNow)){
   	   /** 3.1 즉시 처리 ==> 상태변경후 위원회요구로 입력하기. */
	   objReqBox.approveCmtSubmtReqBox(objParams.getParamValue("ReqBoxID"), true);
   }else{
   	  OrganInfoDelegate objOrganInfo=new OrganInfoDelegate();
   	  Hashtable objHashCmtOrgan=objOrganInfo.getOrganInfo(objParams.getParamValue("CmtOrganID"));
   	  if(objHashCmtOrgan!=null && objHashCmtOrgan.size()>0){
	   	  strCmtOrganNM=(String)objHashCmtOrgan.get("ORGAN_NM");//위원회명 (전자결재용) 
	      strCmtGovStdCD=(String)objHashCmtOrgan.get("GOV_STD_CD"); //위원회 GCC코드 (전자결재용) 
      }
	   
	   /** 3.2 전자결재용 Form 전달내용 만들기 ==> 상태변경 신청후. */
   	  //아래 HTML형태로 만들어서 자동 전달하게함.   
   	  String[] strArr=objReqBox.getElectInfo(objUserInfo.getOrganID(),objParams.getParamValue("ReqBoxID")); 
   	  //[0] 신규 공문 번호,  [1] 기관의 행정구분코드
   	  strOffiDocNo=strArr[0];
   	  strGovStdCD=strArr[1];
   }
 }catch(AppException objEx){ 
 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  	objMsgBean.setStrCode(objEx.getStrErrCode());
  	objMsgBean.setStrMsg(objEx.getMessage());
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%  	
  	return; 
 }
  String strFormType="hidden";
%>
<%
 /** 즉시 완료 처리할경우 */
 if(StringUtil.isAssigned(strRightNow)){
%>
<html>
<head>
<title>서류제출을 통한 위원회 제출신청서 발송</title>
<link href="/css/System.css" rel="stylesheet" type="text/css">
<script language="javascript">
	function selfClose(){
	  //opener.location.reload();
	  opener.location.href='/reqsubmit/10_mem/20_reqboxsh/40_commreq/RCommReqList.jsp?AuditYear=<%= strAuditYear %>&CmtOrganID=<%= objParams.getParamValue("CmtOrganID") %>';
	  self.close();
	}
</script>
</head>
<body leftmargin="0" topmargin="0">
<center>
<table border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td width="280" height="30" align="center">
			<table border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td width="280" height="35" bgcolor="#f4f4f4" align="center"><span class="title">위원회 제출 신청</span></td>
				</tr>
				<tr><td height="1" bgcolor="#c0c0c0"></td></tr>
			</table>
		</td>
	</tr>
	<tr>
		<td height="10" bgcolor="#ffffff"></td>
	</tr>
	<tr>
		<td align="center" height="160">
			위원회 제출 신청서 처리가 완료되었습니다.
			<p>
			<a href="javascript:selfClose()">[close]</a>
		</td>
	</tr>
</table>
</center>
</body>
</html>
<%
 }else{//전자결재를 경유할 경우 
%>
<html>
<head>
<title>전자결재를 통한 위원회 제출신청서 발송</title>
<script language="javascript">
   function addAcube(formName){   		 
		 if(confirm("POP-UP 확인")==true){
			   addAcube = window.open("http://docs.assembly.go.kr/acubecn/legacy/ACN_LegacyBridge.jsp","addAcube",
				   										 "resizable=yes,menubar=yes,status=yes,titlebar=yes, scrollbars=yes,location=yes,toolbar=yes,height=500,width=800");
				formName.target="addAcube";
				formName.submit();
		 }
   }
   function submitAcube(){
   		opener.location.reload();
   		formName.submit();
   }
</script>
</head>
<body leftmargin="0" topmargin="0" onload="submitAcube();">
<table>
			<form name="formName" method="POST" action="http://docs.assembly.go.kr/acubecn/legacy/ACN_LegacyBridge.jsp" >				
				   <input type="<%=strFormType%>" name="systemid" size="20"  value="request_send"><br>
    		       <input type="<%=strFormType%>" name="businessid" size="20"  value="request_in_comm"><br>
    		       <input type="<%=strFormType%>" name="cssversion" size="20"  value="2.0">
   				   <input type="<%=strFormType%>" name="formversion" size="20"  value="1.0"><br>
   				   <input type="<%=strFormType%>" name="title" size="20"  value="위원회 제출신청서"><br>
   				   <input type="<%=strFormType%>" name="method" size="20"  value="file"><br>
   				   <input type="<%=strFormType%>" name="recipients" size="20"  value="<%=strCmtGovStdCD%>"><br>
   				   <input type="<%=strFormType%>" name="recipnames" size="20"  value="<%=strCmtOrganNM%>"><br>   				   
				   <textarea name="legacyout" cols="110" rows="10" OnFocus="this.select();" this.style.visibility="hidden"><?xml version="1.0" encoding="euc-kr"?><REQUEST_IN_COMM><DOC_SUBMIT><SUID><%=strOffiDocNo%></SUID></DOC_SUBMIT></REQUEST_IN_COMM></textarea><br>
					<textarea name="attaches" cols="110" rows="10" OnFocus="this.select();" this.style.visibility="hidden"><?xml version='1.0' encoding='euc-kr'?><GENERAL_ATTACHES><GENERAL_ATTACH METHOD='add' MODIFY=''><DISPLAY_NAME><![CDATA[<%=strPdfInfoArr[2]%>]]></DISPLAY_NAME><FILE_NAME><%=strPdfInfoArr[2]%></FILE_NAME><FILE_SIZE><%=strPdfInfoArr[0]%></FILE_SIZE><FILE_BASE64_DATA><%=strPdfInfoArr[1]%></FILE_BASE64_DATA></GENERAL_ATTACH></GENERAL_ATTACHES></textarea><br>
			    <INPUT id="deptcode" name="deptcode" type="<%=strFormType%>" value="<%=strGovStdCD%>"><br><!-- GOV_STD_CD (행정표준코드) -->
			    <!--
				<input type="submit" value="보내기" style="cursor:hand" ><br>
                <input type="button" name="Button" value="POP-UP보내기" style="cursor:hand" OnClick="javascript:addAcube(form1);">
                -->
		</form>
</body>
</html>
<%
 }//endif 전자결재 여부 체크 끝.
%>

