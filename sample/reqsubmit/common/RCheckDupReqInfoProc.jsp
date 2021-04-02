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
 /** 					�Ķ���� üũ Part 														  */
 /*************************************************************************************************/

  String strReqBoxID=request.getParameter("ReqBoxID");
  String strReqCont=request.getParameter("ReqCont");
  String strReDtlCont=request.getParameter("ReqDtlCont");
  //nads.lib.reqsubmit.util.StringUtil.logSQL("Size:" + strReDtlCont.length() ,null);//�α�
  //nads.lib.reqsubmit.util.StringUtil.logSQL("Value:" + strReDtlCont ,null);//�α�
%>

<%
 /*************************************************************************************************/
 /** 					������ ó�� Part 														  */
 /*************************************************************************************************/
 String strDupMsg="";
 try{
   nads.dsdm.app.reqsubmit.delegate.requestinfo.RequestInfoDelegate objDupCheckReqInfo=new nads.dsdm.app.reqsubmit.delegate.requestinfo.RequestInfoDelegate();
   /** 2004.06.05 �����ߺ������� �ٲ� */
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
<title>�䱸���� �ߺ�üũ</title>
<link href="/css/System.css" rel="stylesheet" type="text/css">
<script language="JavaScript">
	//�䱸 ���� Ȯ��
	function init(){
		if('<%=StringUtil.ReplaceString(strDupMsg,"'","")%>'!=''){//�ߺ�����.
		   if(confirm("��<%=strDupMsg%>���� �䱸������ �ߺ��Ǿ����ϴ�. \n ����Ͻðڽ��ϱ�?")==true){
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