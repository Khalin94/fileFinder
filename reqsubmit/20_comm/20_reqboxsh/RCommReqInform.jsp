<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RCommReqBoxVListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.CommRequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.CommRequestInfoDelegate" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%
 UserInfoDelegate objUserInfo =null;
 CDInfoDelegate objCdinfo =null;
%>
<%@ include file="../../common/RUserCodeInfoInc.jsp" %>

<%
  /**일반 요구함 상세보기 파라미터 설정.*/
  RCommReqBoxVListForm objParams =new RCommReqBoxVListForm();  
  
  boolean blnParamCheck=false;
  /**전달된 파리미터 체크 */
  blnParamCheck=objParams.validateParams(request);
  if(blnParamCheck==false){
  	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	objMsgBean.setStrCode("DSPARAM-0000");
  	objMsgBean.setStrMsg(objParams.getStrErrors());
  	//out.println("ParamError:" + objParams.getStrErrors());
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%
  	return;
  }//endif
  
 CommRequestInfoDelegate  objReqInfo=null;		/** 요구정보 Delegate */
 ResultSetSingleHelper objRsRI=null;			/** 요구 상세보기 정보 */

 // 요구함 상자 ID
 String strReqID = StringUtil.getEmptyIfNull(request.getParameter("ReqID"));
 String strRefReqID = StringUtil.getEmptyIfNull(request.getParameter("RefReqID"));
 String strUdFlag = StringUtil.getEmptyIfNull(request.getParameter("UdFlag"));
 
 try{
	
   /**요구 정보 대리자 New */    
    objReqInfo=new CommRequestInfoDelegate();
	objRsRI=new ResultSetSingleHelper(objReqInfo.getRecord((String)request.getParameter("ReqID")));  
 }catch(AppException objAppEx){
 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  	objMsgBean.setStrCode(objAppEx.getStrErrCode());
  	objMsgBean.setStrMsg(objAppEx.getMessage());
  	out.println("<br>Error!!!" + objAppEx.getMessage());
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%  	
  	return;
 } 
%>

<!DOCTYPE HTML PUBLIC "-//w3c//dtd html 4.0 transitional//en">
<html>
<head>
<title><%=MenuConstants.REQ_UP_INFORM%></title>
<link href="/css/System.css" rel="stylesheet" type="text/css">
<script language="javascript">
<!--
  //요구함 삭제로 가기.
  function gotoCall(){
    form=document.formName;
	form.action="./RCommReqInformProc.jsp";
	form.submit();
  }
 //-->
</script>
</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="100%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td align="center" height="30"><span class="title">요구 내용 수정(삭제) 통보</span></td>
</tr>
<tr>
	<td align=center>
	<form name="formName" method="post" action="">
	<input type="hidden" name="ReqBoxID" value="<%=(String)request.getParameter("ReqBoxID")%>">
	<input type="hidden" name="CommReqID" value="<%=objRsRI.getObject("REQ_ID")%>">
	<input type="hidden" name="CommReqInfoSortField" value="<%=objParams.getParamValue("CommReqInfoSortField")%>"><!--요구정보 목록정렬필드 -->
	<input type="hidden" name="CommReqInfoSortMtd" value="<%=objParams.getParamValue("CommReqInfoSortMtd")%>"><!--요구정보 목록정령방법-->
	<input type="hidden" name="CommReqInfoPage" value="<%=objParams.getParamValue("CommReqInfoPage")%>"><!--요구정보 페이지 번호 -->
	<input type="hidden" name="RefReqID" value="<%=strRefReqID%>">
	<input type="hidden" name="RegrID" value="<%=objRsRI.getObject("REGR_ID")%>">					
	<input type="hidden" name="UdFlag" value="<%=strUdFlag%>">
    <input type="hidden" name="ReturnURL" value="<%=(String)request.getParameter("ReturnURL")%>">					

	<table width="85%" border="0" cellpadding="0" cellspacing="0">
    <tr class="td_reqsubmit"> 
        <td height="2" colspan="2"></td>
    </tr>	
	<tr>
		<td class="text_s" height="25" colspan="2"> * 요구기관의 담당자에게 수정(삭제)사유를 통보합니다.</td>
	</tr>
    <tr height="1" class="tbl-line"> 
		<td height="1" colspan="2"></td>
	</tr>
	<tr>
		<td width="150" height="30" align="left" class="soti_reqsubmit">
		<img src="/image/reqsubmit/icon_reqsubmit_soti.gif" width="9" height="9" align="absmiddle">
		요구기관
		</td>
		<td><%=objRsRI.getObject("REQ_ORGAN_NM")%>
		</td>
	</tr>
    <tr height="1" class="tbl-line"> 
		<td height="1" colspan="2"></td>
	</tr>
	<tr>
		<td width="150" height="30" align="left" class="soti_reqsubmit">
		<img src="/image/reqsubmit/icon_reqsubmit_soti.gif" width="9" height="9" align="absmiddle">
		요구자
		</td>
		<td><%=objRsRI.getObject("REGR_NM")%>
		</td>
	</tr>
    <tr height="1" class="tbl-line"> 
		<td height="1" colspan="2"></td>
	</tr>
	<tr>
		<td width="150" height="30" align="left" class="soti_reqsubmit">
		<img src="/image/reqsubmit/icon_reqsubmit_soti.gif" width="9" height="9" align="absmiddle">
		요구제목
		</td>
		<td><%=objRsRI.getObject("REQ_CONT")%>
		</td>
	</tr>
    <tr height="1" class="tbl-line"> 
		<td height="1" colspan="2"></td>
	</tr>
	<tr>
		<td width="150" height="30" align="left" class="soti_reqsubmit">
		<img src="/image/reqsubmit/icon_reqsubmit_soti.gif" width="9" height="9" align="absmiddle">
		통보방법
		</td>
		<td><input type="checkbox" name="NtcMtd" value="002">문자 전송 서비스
		</td>
	</tr>
    <tr height="1" class="tbl-line"> 
		<td height="1" colspan="2"></td>
	</tr>
	<tr>
		<td width="150" height="30" align="left" class="soti_reqsubmit">
		<img src="/image/reqsubmit/icon_reqsubmit_soti.gif" width="9" height="9" align="absmiddle">
		수정(삭제)사유
		</td>
		<td><textarea name="Rsn" wrap="hard" class="textfield" style="WIDTH: 90% ; height: 80"></textarea>
		</td>
	</tr>
    <tr height="2" class="tbl-line"> 
		<td height="2" colspan="2"></td>
	</tr>			
	<tr>
		<td colspan="2" align="center">
		<img src="/image/button/bt_ok.gif"  height="20" border="0" onClick="gotoCall()" style="cursor:hand">
		<img src="/image/button/bt_cancel.gif"  height="20" border="0" onClick="formName.reset()" style="cursor:hand">
		</td>
	</tr>
	</table>
	</form>
	</td>
</tr>
</table>
</body>
</html>


