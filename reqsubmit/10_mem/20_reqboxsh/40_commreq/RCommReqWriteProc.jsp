<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.params.cmtsubmt.CmtSubmtReqBoxWriteForm"%>
<%@ page import="nads.lib.reqsubmit.params.cmtsubmt.CmtSubmtReqBoxListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.cmtsubmt.CmtSubmtReqBoxDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	/******************************************************************************
	* Name		  : RCommReqWriteProc.jsp
	* Summary	  : 신청함 처리 기능제공.
	* Description : 요구함 정보를 입력하고 상세보기 화면으로 이동한다.
	******************************************************************************/
	UserInfoDelegate objUserInfo =null;
	CDInfoDelegate objCdinfo =null;
%>

<%@ include file="../../../common/RUserCodeInfoInc.jsp" %>

<%
	/*************************************************************************************************/
	/** 					파라미터 체크 Part 														  */
	/*************************************************************************************************/
	
	/** 상세보기 페이징용 파라미터 설정.*/
	CmtSubmtReqBoxListForm objParams =new CmtSubmtReqBoxListForm();  
	boolean blnParamCheck=false;
	objParams.setParamValue("ReqOrganID",objUserInfo.getOrganID());//요구기관을 세션에서 넣어줌.
	/**페이징  파리미터 체크 */
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
	}
  
	/** 요구함 정보 파라미터 설정.*/
	CmtSubmtReqBoxWriteForm objWriteParams =new CmtSubmtReqBoxWriteForm();  
	objWriteParams.setParamValue("ReqOrganID",objUserInfo.getOrganID());//요구기관을 세션에서 넣어줌.
	objWriteParams.setParamValue("CmtSubmtReqrID",objUserInfo.getUserID());//작성자 ID
	  
	blnParamCheck = false;
	/** 요구함정보 수정 파리미터 체크 */
	blnParamCheck = objWriteParams.validateParams(request);
	if(blnParamCheck == false) {
		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
		objMsgBean.setStrCode("DSPARAM-0000");
		objMsgBean.setStrMsg(objWriteParams.getStrErrors());
		//out.println("ParamError:" + objWriteParams.getStrErrors());
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}//endif

	/*************************************************************************************************/
	/** 					데이터 처리 Part 														  */
	/*************************************************************************************************/

	boolean blnOk = false; //등록 여부.
	try {
		/********* 대리자 정보 설정 *********/
		CmtSubmtReqBoxDelegate objReqBox=new CmtSubmtReqBoxDelegate();   /** 요구함 정보 입력용 */
		
		/********* 데이터 등록 하기  **************/
		String strReturn=objReqBox.setNewRecord(objWriteParams);
		   
		blnOk =StringUtil.isAssigned(strReturn);
		if(!blnOk){
			objMsgBean.setMsgType(MessageBean.TYPE_WARN);
			objMsgBean.setStrCode("DSDATA-0010");
			objMsgBean.setStrMsg("요청하신 요구함 정보를 등록하지 못했습니다");
%>
			<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%  	
			return;   	
		}
	} catch(AppException objAppEx) { 
 		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		System.out.println("SysErrorCode:" + objAppEx.getStrErrCode());
		if(objAppEx.getStrErrCode().equals("DSDATA-0002")) {
			objMsgBean.setStrCode(objAppEx.getStrErrCode());
			objMsgBean.setStrMsg("중복된 신청함이 있습니다. 신청함 목록을 확인하세요!!");
		} else {
	  		objMsgBean.setStrCode("SYS-00010");//AppException에러.
	  		objMsgBean.setStrMsg(objAppEx.getMessage());
		}
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%  	
		return; 
	}
%>

<html>
<script language="JavaScript">
	function init(){
		alert("신청함 정보가 등록되었습니다 ");
		formName.submit();
	}
</script>
<body onLoad="init()">
				<form name="formName" method="<%=nads.lib.reqsubmit.EnvConstants.FORM_METHOD%>" action="./RCommReqList.jsp" >
					<% objParams.setParamValue("CmtOrganID",objWriteParams.getParamValue("CmtOrganIDX")); //위원회ID를 변경해서 보여줌.%>
					<%=objParams.getHiddenFormTags()%>
				</form>
</body>
</html>
					
					
					

