<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.bf.config.*"%>
<%@ page import="kr.co.kcc.pf.util.PageCount"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.params.requestinfo.RPreReqInfoVListForm" %>
<%@ page import="nads.lib.reqsubmit.params.requestinfo.RPreReqInfoEditForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.prereqinfo.PreRequestInfoDelegate" %>
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

  /**일반 요구함 상세보기 파라미터 설정.*/
  RPreReqInfoVListForm objParams =new RPreReqInfoVListForm();  
  boolean blnParamCheck=false;
  /**전달된 파리미터 체크 */
  nads.lib.reqsubmit.form.RequestWrapper objRequestWrapper=
  new nads.lib.reqsubmit.form.RequestWrapper(request);  
  blnParamCheck=objParams.validateParams(objRequestWrapper);
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

  //out.println(objParams.getValuesForDebug()); 
  //out.println("<br><br>");
  
  /** 요구 수정에 필요한 파라 미터 체크.*/
  RPreReqInfoEditForm objEditParams =new RPreReqInfoEditForm();  
  blnParamCheck=false;
  /** 요구함정보 수정 파리미터 체크 */
  /** 위에서 선언한 Wrapper */
  blnParamCheck=objEditParams.validateParams(objRequestWrapper);
  if(blnParamCheck==false){
  	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	objMsgBean.setStrCode("DSPARAM-0000");
  	objMsgBean.setStrMsg(objEditParams.getStrErrors());
  	//out.println("ParamError:" + objEditParams.getStrErrors());
  	%>
	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%
  	return;
  }//endif
	
  //out.println(objEditParams.getValuesForDebug()); 
  
%>

<%
 /*************************************************************************************************/
 /** 					데이터 처리 Part 														  */
 /*************************************************************************************************/

 try{
   /********* 대리자 정보 설정 *********/
   PreRequestInfoDelegate objReqInfo=new PreRequestInfoDelegate();   /** 요구 정보 수정용 */

   /********* 데이터 등록 하기  **************/
   boolean blnReturn=objReqInfo.setRecord(objEditParams).booleanValue();  
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
				<form name="formName" method="get" action="./RBasicReqInfoVList.jsp" ><!--요구함 신규정보 전달 -->
				    <input type="hidden" name="ReqBoxID" value="<%=objParams.getParamValue("ReqBoxID")%>">
				    <input type="hidden" name="CmtOrganID" value="<%=objParams.getParamValue("CmtOrganID")%>">
					<input type="hidden" name="ReqBoxSortField" value="<%=objParams.getParamValue("ReqBoxSortField")%>"><!--요구함목록정렬필드 -->
					<input type="hidden" name="ReqBoxSortMtd" value="<%=objParams.getParamValue("ReqBoxSortMtd")%>"><!--요구함목록정령방법-->
					<input type="hidden" name="ReqBoxPage" value="<%=objParams.getParamValue("ReqBoxPage")%>"><!--요구함 페이지 번호 -->
					<input type="hidden" name="ReqBoxQryField" value="<%=objParams.getParamValue("ReqBoxQryField")%>"><!--요구함 조회필드 -->
					<input type="hidden" name="ReqBoxQryTerm" value="<%=objParams.getParamValue("ReqBoxQryMtd")%>"><!--요구함 조회어 -->
					<input type="hidden" name="ReqInfoSortField" value="<%=objParams.getParamValue("ReqInfoSortField")%>"><!--요구정보 목록정렬필드 -->
					<input type="hidden" name="ReqInfoSortMtd" value="<%=objParams.getParamValue("ReqInfoSortMtd")%>"><!--요구정보 목록정령방법-->
					<input type="hidden" name="ReqInfoPage" value="<%=objParams.getParamValue("ReqInfoPage")%>"><!--요구정보 페이지 번호 -->
					<input type="hidden" name="ReqInfoQryField" value="<%=objParams.getParamValue("ReqInfoQryField")%>"><!--요구 조회필드 -->
					<input type="hidden" name="ReqInfoQryTerm" value="<%=objParams.getParamValue("ReqInfoQryMtd")%>"><!--요구 조회어 -->										
					<input type="hidden" name="ReqInfoID" value="<%=objParams.getParamValue("ReqInfoID")%>"><!--요구정보 ID-->
				</form>
</body>
</html>

