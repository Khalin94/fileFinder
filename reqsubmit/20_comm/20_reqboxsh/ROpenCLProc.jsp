<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.CommRequestInfoDelegate" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%
 UserInfoDelegate objUserInfo =null;
 CDInfoDelegate objCdinfo =null;
%>
<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>

<%
 /*************************************************************************************************/
 /** 					파라미터 체크 Part 														  */
 /*************************************************************************************************/
	//요구함 ID
	String strReqBoxID = request.getParameter("ReqBoxID");
	String strReqID	= request.getParameter("CommReqID");
	String strCmtOrganID = request.getParameter("CmtOrganID");
	
	String strCommReqBoxSortField = request.getParameter("CommReqBoxSortField");
	String strCommReqBoxSortMtd = request.getParameter("CommReqBoxSortMtd");
	String strCommReqBoxPage = request.getParameter("CommReqBoxPage");
	String strCommReqBoxQryField = request.getParameter("CommReqBoxQryField");
	String strCommReqBoxQryMtd = request.getParameter("CommReqBoxQryMtd");
	//요구 정보 정렬 정보 받기.
	String strCommReqInfoSortField = request.getParameter("CommReqInfoSortField");
	String strCommReqInfoSortMtd = request.getParameter("CommReqInfoSortMtd");
	//요구함 정보 페이지 번호 받기.
	String strCommReqInfoPage = request.getParameter("CommReqInfoPage");					
	String strCommReqInfoPagNum = request.getParameter("CommReqInfoPageNum");					
	String strReturnURL = request.getParameter("ReturnURL");
	String strCommReqInfoQryField = request.getParameter("CommReqInfoQryField");
	String strCommReqInfoQryMtd	= request.getParameter("CommReqInfoQryTerm");
	String strOpenCL = request.getParameter("OpenCL");
%>
<%
 /*************************************************************************************************/
 /** 					데이터 처리 Part 														  */
 /*************************************************************************************************/

 try{
   /********* 대리자 정보 설정 *********/
   CommRequestInfoDelegate objReqInfo=new CommRequestInfoDelegate();   /** 요구 정보 수정용 */

   /********* 데이터 등록 하기  **************/
   boolean blnReturn=objReqInfo.setOpenCL(strReqID, strOpenCL).booleanValue();  
   if(!blnReturn){
 	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	objMsgBean.setStrCode("DSDATA-0011");
  	objMsgBean.setStrMsg("요청하신 요구 정보를 수정하지 못했습니다");
  	//out.println("<br>Error!!!" + "요청하신 요구 정보를 수정하지 못했습니다");   
  	%>
	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%  	
  	return;   	
   }
 }catch(AppException objAppEx){ 
 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  	objMsgBean.setStrCode(objAppEx.getStrErrCode());
  	objMsgBean.setStrMsg(objAppEx.getMessage());
  	//out.println("<br>Error!!!" + objAppEx.getMessage());
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%  	
  	return; 
 }
%>

<%
 /*************************************************************************************************/
 /** 					페이지 전환 Part 														  */
 /*************************************************************************************************/
%>
<html>
<script language="JavaScript">
	function init(){
		alert("요구 정보가 수정되었습니다 ");
		formName.submit();
	}
</script>
<body onLoad="init()">
	<form name="formName" method="post" action="<%=strReturnURL%>"><!--요구함 신규정보 전달 -->
	    <input type="hidden" name="ReqBoxID" value="<%=strReqBoxID%>">
		<input type="hidden" name="CommReqBoxSortField" value="<%=strCommReqBoxSortField%>"><!--요구함목록정렬필드 -->
		<input type="hidden" name="CommReqBoxSortMtd" value="<%=strCommReqBoxSortMtd%>"><!--요구함목록정령방법-->
		<input type="hidden" name="CommReqBoxPage" value="<%=strCommReqBoxPage%>"><!--요구함 페이지 번호 -->
		<input type="hidden" name="CommReqBoxQryField" value="<%=strCommReqBoxQryField%>"><!--요구함 조회필드 -->
		<input type="hidden" name="CommReqBoxQryTerm" value="<%=strCommReqBoxQryMtd%>"><!--요구함 조회어 -->
		<input type="hidden" name="CommReqInfoSortField" value="<%=strCommReqInfoSortField%>"><!--요구정보 목록정렬필드 -->
		<input type="hidden" name="CommReqInfoSortMtd" value="<%=strCommReqInfoSortMtd%>"><!--요구정보 목록정령방법-->
		<input type="hidden" name="CommReqInfoPage" value="<%=strCommReqInfoPage%>"><!--요구정보 페이지 번호 -->
		<input type="hidden" name="CommReqInfoQryField" value="<%=strCommReqInfoQryField%>"><!--요구 조회필드 -->
		<input type="hidden" name="CommReqInfoQryTerm" value="<%=strCommReqInfoQryMtd%>"><!--요구 조회어 -->										
		<input type="hidden" name="CommReqID" value="<%=strReqID%>"><!--요구정보 ID-->
	</form>
</body>
</html>

