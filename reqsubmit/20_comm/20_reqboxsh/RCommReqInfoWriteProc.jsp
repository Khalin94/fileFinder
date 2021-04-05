<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RCommReqBoxVListForm" %>
<%@ page import="nads.lib.reqsubmit.params.requestinfo.RCommReqInfoWriteForm" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.CommRequestInfoDelegate" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%
 UserInfoDelegate objUserInfo =null;
 CDInfoDelegate objCdinfo =null;
%>
<%@ include file="../../common/RUserCodeInfoInc.jsp" %>
<%
 /*************************************************************************************************/
 /** 					파라미터 체크 Part 														  */
 /*************************************************************************************************/

  /**일반 요구함 상세보기 파라미터 설정 등록에도 계속 따라다님..*/
  RCommReqBoxVListForm objParams =new RCommReqBoxVListForm();  
  boolean blnParamCheck=false;
  /**전달된 파리미터 체크 */

  /**Multipart일경우 반드시 이녀석을 이용해서 담의 Valid파람으로 넘겨줘야함 */
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

  /** 요구 등록에 필요한 파라 미터 체크.*/
  RCommReqInfoWriteForm objWriteParams =new RCommReqInfoWriteForm();  
  objWriteParams.setParamValue("ReqOrganID",objUserInfo.getOrganID());//요구기관을 세션에서 넣어줌.
  objWriteParams.setParamValue("RegrID",objUserInfo.getUserID());//요구생성자를 세션에서 넣어줌.
  objWriteParams.setParamValue("OldReqOrganId",objUserInfo.getOrganID());//요구생성자를 세션에서 넣어줌.
  blnParamCheck=false;
  /** 요구함정보 수정 파리미터 체크 */
  /** 위에서 선언한 Wrapper */
  blnParamCheck=objWriteParams.validateParams(objRequestWrapper);
  if(blnParamCheck==false){
  	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	objMsgBean.setStrCode("DSPARAM-0000");
  	objMsgBean.setStrMsg(objWriteParams.getStrErrors());
  	//out.println("ParamError:" + objWriteParams.getStrErrors());
  	%>
	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%
  	return;
  }//endif
	
  //out.println(objWriteParams.getValuesForDebug()); 
  
%>

<%
 /*************************************************************************************************/
 /** 					데이터 처리 Part 														  */
 /*************************************************************************************************/

 boolean blnOk=false; //등록 여부.
 try{
   /********* 대리자 정보 설정 *********/
   CommRequestInfoDelegate objReqInfo=new CommRequestInfoDelegate();   /** 요구함 정보 입력용 */

   /********* 데이터 등록 하기  **************/
   String strReqID=objReqInfo.setNewRecord(objWriteParams);  
   if(!StringUtil.isAssigned(strReqID)){
 	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	objMsgBean.setStrCode("DSDATA-0011");
  	objMsgBean.setStrMsg("요청하신 요구 정보를 등록하지 못했습니다");
  	out.println("<br>Error!!!" + "요청하신 요구 정보를 등록하지 못했습니다");   
  	%>

  	<%  	
  	return;   	
   }
 }catch(AppException objAppEx){ 
 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  	objMsgBean.setStrCode(objAppEx.getStrErrCode());
  	objMsgBean.setStrMsg(objAppEx.getMessage());
  	out.println("<br>Error!!!" + objAppEx.getMessage());
  	%>
  	
  	<%  	
  	return; 
 }
%>

<%
 /*************************************************************************************************/
 /** 					페이지 전환 Part 														  */
 /*************************************************************************************************/
	String strReturnURL = (String)objWriteParams.getParamValue("ReturnURL");
%>
<html>
<script language="JavaScript">
	function init(strReturn){
		if (confirm(" 요구 정보가 등록되었습니다. \n 계속 등록하시겠습니까?")) {
			formName.action="./RCommReqInfoWrite.jsp";
		} else {
			formName.action=strReturn;
		}
		formName.submit();
	}
</script>
<body onLoad="init('<%=strReturnURL%>')">
	<form name="formName" method="get" action="" ><!--요구함 신규정보 전달 -->
	    <input type="hidden" name="ReqBoxID" value="<%=objParams.getParamValue("ReqBoxID")%>">
		<input type="hidden" name="CommReqBoxSortField" value="<%=objParams.getParamValue("CommReqBoxSortField")%>"><!--요구함목록정렬필드 -->
		<input type="hidden" name="CommReqBoxSortMtd" value="<%=objParams.getParamValue("CommReqBoxSortMtd")%>"><!--요구함목록정령방법-->
		<input type="hidden" name="CommReqBoxPage" value="<%=objParams.getParamValue("CommReqBoxPage")%>"><!--요구함 페이지 번호 -->
		<input type="hidden" name="CommReqBoxQryField" value="<%=objParams.getParamValue("CommReqBoxQryField")%>"><!--요구함 조회필드 -->
		<input type="hidden" name="CommReqBoxQryTerm" value="<%=objParams.getParamValue("CommReqBoxQryMtd")%>"><!--요구함 조회어 -->
		<input type="hidden" name="CommReqInfoSortField" value="<%=objParams.getParamValue("CommReqInfoSortField")%>"><!--요구정보 목록정렬필드 -->
		<input type="hidden" name="CommReqInfoSortMtd" value="<%=objParams.getParamValue("CommReqInfoSortMtd")%>"><!--요구정보 목록정령방법-->
		<input type="hidden" name="CommReqInfoQryField" value="<%=objParams.getParamValue("CommReqInfoQryField")%>"><!--요구 조회필드 -->
		<input type="hidden" name="CommReqInfoQryTerm" value="<%=objParams.getParamValue("CommReqInfoQryMtd")%>"><!--요구 조회어 -->										
		<input type="hidden" name="CommReqInfoPage" value="<%=objParams.getParamValue("CommReqInfoPage")%>"><!--요구정보 페이지 번호 -->
		<input type="hidden" name="ReturnURL" value="<%=strReturnURL%>"><!-- 돌아갈 주소 -->
	</form>
</body>
</html>
			
