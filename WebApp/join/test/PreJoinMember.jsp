<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>��ȸ ����Ȱ�� �������� �������� �ý���</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link href="../css/global.css" rel="stylesheet" type="text/css">
<link href="../css/System.css" rel="stylesheet" type="text/css">
<script src="/js/common.js"></script>
<script src="/js/validate.js" ></script>
<script language="JavaScript">
<!--
//���� ÷��
function showImageFile(fileValue, showValue) { 
	eval("document.frmPreJoinMember."+showValue+".value = document.frmPreJoinMember."+fileValue+".value");
}
//-->
</script>
</head>

<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="kr.co.kcc.bf.config.*" %>
<%@ page import="nads.lib.message.MessageBean" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%
	String strUserInGrpId = ""; 
	String strUserOutGrpId = ""; 
	String strSrchRecordCnt = ""; 
	String strSrchDisplayKind = "";
	String strGtherPeriod = "";
	String strReqSubmtFlag = "";
	

	String strJuminNo = request.getParameter("juminNo1")==null?"":request.getParameter("juminNo1") ;
	strJuminNo += request.getParameter("juminNo2")==null?"":request.getParameter("juminNo2") ;
	
	
	java.util.Hashtable objHshReqUserInfo = new java.util.Hashtable();
	java.util.Hashtable objHshParam = new java.util.Hashtable();
	try
	{	
		Config objConfig = PropertyConfig.getInstance();
		strUserInGrpId = objConfig.get("join.userInGrpId");
		strUserOutGrpId = objConfig.get("join.userOutGrpId");
		strSrchRecordCnt = objConfig.get("join.srchRecordCnt");  
		strSrchDisplayKind = objConfig.get("join.srchDisplayKind");
		strGtherPeriod = objConfig.get("join.gtherPeriod");  
		strReqSubmtFlag = objConfig.get("join.reqSubmtFlag4Submit");  

		


		nads.dsdm.app.join.JoinMemberDelegate objJoinMemberDelegate = new nads.dsdm.app.join.JoinMemberDelegate();
		
		objHshParam.put("CERT_DN",request.getParameter("CERT_DN"));
		objHshParam.put("JUMIN_NO",strJuminNo);

		if(strJuminNo.equals("") != true)
			objHshReqUserInfo = objJoinMemberDelegate.getUserInfo(objHshParam);

		


		if(objHshReqUserInfo.isEmpty()){

			objHshReqUserInfo.put("USER_ID","");
			objHshReqUserInfo.put("USER_NM","");
			objHshReqUserInfo.put("STT_CD","000");
			objHshReqUserInfo.put("JUMIN_NO","");
			objHshReqUserInfo.put("INOUT_GBN","");
			objHshReqUserInfo.put("REP_FLAG","");
			objHshReqUserInfo.put("ORGAN_NM","");
			objHshReqUserInfo.put("DEPT_NM","");
			objHshReqUserInfo.put("POSI_NM","");
			objHshReqUserInfo.put("GRD_NM","");
			objHshReqUserInfo.put("USER_DN","");
			objHshReqUserInfo.put("EMAIL","");
			objHshReqUserInfo.put("OFFICE_TEL","");
			objHshReqUserInfo.put("CPHONE","");
			objHshReqUserInfo.put("FAX_NO","");
			objHshReqUserInfo.put("POST_CD","");
			objHshReqUserInfo.put("JUSO1","");
			objHshReqUserInfo.put("JUSO2","");
			objHshReqUserInfo.put("CG_DUTY","");
			objHshReqUserInfo.put("REMARK","");
			objHshReqUserInfo.put("INOUT_GBN","I");
			
		}
		

		
	}
	catch(Exception objExcept)
	{	
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		objMsgBean.setStrCode("SYS-00001");
		objMsgBean.setStrMsg(objExcept.getMessage());
		
		// ���� �߻� �޼��� �������� �̵��Ѵ�.
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;

	}
	
%>
<body bgcolor="F0F0F0" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onload="init()">

		<%@ include file="/join/PreJoinMemberCenter.jsp"%>
<%
	if(objHshReqUserInfo.get("STT_CD").equals("000")){
		out.println("<script> alert('������û�� �ϼž� �մϴ�'); </script>");
	}else if(objHshReqUserInfo.get("STT_CD").equals("001")){
		out.println("<script> alert('�̹� �����ϼ̽��ϴ�'); document.location = '/index.html';</script>");
	}else if(objHshReqUserInfo.get("STT_CD").equals("002")){
		out.println("<script> alert('������������Դϴ�'); document.location = '/index.html';</script>");
	}else if(objHshReqUserInfo.get("STT_CD").equals("003")){
		out.println("<script> alert('Ż�� ������Դϴ�.'); document.location = '/index.html';</script>");
	}else if(objHshReqUserInfo.get("STT_CD").equals("005")){
		out.println("<script> alert('�����ڰ� ���� ó���� Ȯ�� ���Դϴ�.'); document.location = '/index.html';</script>");
	}else if(objHshReqUserInfo.get("STT_CD").equals("006")){
		out.println("<script> alert('ȸ�����ο��θ� Ȯ�� �Ͻʽÿ�'); document.location = '/index.html';</script>");
	}else if(objHshReqUserInfo.get("STT_CD").equals("007")){
		out.println("<script> alert('�����ڰ� ��û�� �ݷ��Ͽ����ϴ�'); document.location = '/index.html';</script>");
	}

%>


</body>
</html>
<script language="javascript">

function init()
{
	
	// �ʼ��Է�
	define('USER_NM', 'string', '�̸�', 1);	
	define('JUMIN_NO', 'string', '�ֹε�Ϲ�ȣ', 1);	
	define('JUMIN_NO1', 'string', '�ֹε�Ϲ�ȣ', 6,6);	
	define('JUMIN_NO2', 'string', '�ֹε�Ϲ�ȣ', 7,7);	
	define('ORGAN_NM', 'string', '���', 1);	
	define('ORGAN_ID', 'string', '���', 1);	
	define('DEPT_NM', 'string', '�μ�', 1);	
	define('EMAIL', 'string', '�̸���', 1);	
	define('OFFICE_TEL1', 'num', '�繫����ȭ��ȣ', 2,3);	
	define('OFFICE_TEL2', 'num', '�繫����ȭ��ȣ', 3,4);	
	define('OFFICE_TEL3', 'num', '�繫����ȭ��ȣ', 4,4);	
	define('FAX_NO1', 'num', '�ѽ���ȣ', 2,3);	
	define('FAX_NO2', 'num', '�ѽ���ȣ', 3,4);	
	define('FAX_NO3', 'num', '�ѽ���ȣ', 4,4);	
	//define('CPHONE1', 'num', '�ڵ���', 3,3);	
	define('CPHONE2', 'num', '�ڵ���', 3,4);	
	define('CPHONE3', 'num', '�ڵ���', 4,4);	
	define('POST_CD1', 'num', '�����ȣ', 3,3);	
	define('POST_CD2', 'num', '�����ȣ', 3,3);	
	define('JUSO2', 'string', '���ּ�', 1);	
	//define('REP_FLAG', 'string', '��ǥ�ڿ���', 1);	


}
function checkValidation(frm)
{

	
	frm.POST_CD.value = frm.POST_CD1.value + frm.POST_CD2.value;
	frm.JUMIN_NO.value = frm.JUMIN_NO1.value + frm.JUMIN_NO2.value;
	frm.OFFICE_TEL.value = frm.OFFICE_TEL1.value + "-"+ frm.OFFICE_TEL2.value + "-"+ frm.OFFICE_TEL3.value;
	frm.CPHONE.value = frm.CPHONE1.value +"-"+ frm.CPHONE2.value + "-"+ frm.CPHONE3.value;
	frm.FAX_NO.value = frm.FAX_NO1.value + "-"+ frm.FAX_NO2.value + "-"+ frm.FAX_NO3.value;
	

	if( OnValidationSubmit() == true)
	{

		if(frm.selFile.value != ""){

			var vafile = frm.selFile.value.substr(frm.selFile.value.length - 4, frm.selFile.value.length);

			frm.PHOTO_PATH.value=frm.selFile.value.substr(frm.selFile.value.lastIndexOf("\\")+1,frm.selFile.value.length);
		

			if((vafile.toLowerCase() != ".gif") && (vafile.toLowerCase() != ".jpg") &&
			   (vafile.toLowerCase() != ".bmp") && (vafile.toLowerCase() != ".jpeg")){
				alert("���������� Ȯ����� .gif, .jpg .jpeg .bmp �� ����� �� �ֽ��ϴ�. (." + vafile+")");
				return false;
			}	

		}
		return true;
	}else{

		return false;
	}

}

function selectZipCd(varZipCd1, varZipCd2, varAddr1)
{
	var frm = document.forms[0];
	frm.POST_CD1.value = varZipCd1;
	frm.POST_CD2.value = varZipCd2;
	frm.JUSO1.value = varAddr1;
}
function selectOrgan(organId,organNm) {
	var frm = document.forms[0];
	frm.ORGAN_ID.value = organId;
	frm.ORGAN_NM.value = organNm;
}

function viewFile() {
	var frm = document.forms[0];
	var img = frm.selFile.value;

	
	img=img.replace(/:/, "|");
    img=img.replace(/\\/gi, "/");
	img= 'file:///' + img;

	
	winBG=window.open("", "", "width=200,height=190,resizable=false");
	winBG.document.open();
	winBG.document.write("<html>");
	winBG.document.write("<head></head>");
	winBG.document.write("<body background='"+img+"'></body>");
	winBG.document.write("</html>");
	winBG.document.close();
	winBG.window.focus();
}
</script>
