<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%
 UserInfoDelegate objUserInfo =null;
 CDInfoDelegate objCdinfo =null;
%>
<%@ include file="./RUserCodeInfoInc.jsp" %>
<%
 /*************************************************************************************************/
 /** 					파라미터 체크 Part 														  */
 /*************************************************************************************************/

  String strReqBoxID=request.getParameter("ReqBoxID");
  String strReqCont=request.getParameter("ReqCont");
  String strReDtlCont=request.getParameter("ReqDtlCont");
  //nads.lib.reqsubmit.util.StringUtil.logSQL("Size:" + strReDtlCont.length() ,null);//로깅
  //nads.lib.reqsubmit.util.StringUtil.logSQL("Value:" + strReDtlCont ,null);//로깅
%>

<%
 /*************************************************************************************************/
 /** 					데이터 처리 Part 														  */
 /*************************************************************************************************/
 String strDupMsg="";
 try{
   nads.dsdm.app.reqsubmit.delegate.requestinfo.RequestInfoDelegate objDupCheckReqInfo=new nads.dsdm.app.reqsubmit.delegate.requestinfo.RequestInfoDelegate();
   /** 2004.06.05 제목중복만으로 바뀜 */
   //strDupMsg=objDupCheckReqInfo.checkDuplicatedReqInfo(strReqBoxID,strReqCont,strReDtlCont);
   strDupMsg=objDupCheckReqInfo.checkDuplicatedReqInfo(strReqBoxID,strReqCont);
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

<!DOCTYPE HTML PUBLIC "-//w3c//dtd html 4.0 transitional//en">

<html>
<head>
<title>요구정보 중복체크</title>
<link href="/css/System.css" rel="stylesheet" type="text/css">
<script language="JavaScript">
	//요구 복사 확인
	function init(){
		if('<%=StringUtil.ReplaceString(strDupMsg,"'","")%>'!=''){//중복있음.
		   if(confirm("『<%=strDupMsg%>』의 요구정보와 중복되었습니다. \n 등록하시겠습니까?")==true){
		      opener.formName.submit();
		   }
		}else{
		  opener.formName.submit();
		}
		self.close();
	}
</script>
</head>
<body onLoad="init()">
</body>
</html>