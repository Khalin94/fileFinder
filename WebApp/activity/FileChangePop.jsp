<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>����/���ϸ� ����</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">

<link href="../css/System.css" rel="stylesheet" type="text/css">
<script src='/js/forum.js'></script>
<script language="javascript">
	function fun_update(){
		 if(checkStrLen(form_main.chg_nm, 50, "����/���ϸ�") == false){
            form_main.chg_nm.focus();
            return;
        } 
		document.form_main.action = "./businfo/UpdateNameProc.jsp";
		document.form_main.submit();
	}
</script>
</head>

<%@ page import="java.util.*"%>
<%@ page import="nads.lib.util.*"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%@ include file="/forum/common/CheckSessionPop.jsp" %>
<%
	String strMessage = "";
	String strError = "yes";
	try
	{
		String strUserId = (String)session.getAttribute("USER_ID");
	
		nads.dsdm.app.activity.businfo.BusInfoDelegate objBusInfoDelegate = new nads.dsdm.app.activity.businfo.BusInfoDelegate();
		int iResult = 0;
	
		String strDocIds = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(request.getParameter("doc_id"));
		String strDutyIds = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(request.getParameter("duty_id"));	
		String strGubn = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(request.getParameter("gubn")); //�������� �̵�/�������� ����.

		Vector objDocVt = new Vector();
		Vector objDutyVt = new Vector();
		
		if(strDocIds != null){
			objDocVt = ActComm.makeNoType(strDocIds, ",");
		}
		
		if(strDutyIds != null){
			objDutyVt = ActComm.makeNoType(strDutyIds, ",");
		}
		
		Hashtable objParam = new Hashtable();
		objParam.put("USER_ID", strUserId);
		objParam.put("DOC_ID", objDocVt);
		objParam.put("DUTY_ID", objDutyVt);

		Hashtable objDocHt = objBusInfoDelegate.selectEqualUserIdInfo(objParam);
		
		ArrayList objResultDocIdArry = (ArrayList)objDocHt.get("DOC_ID");
		ArrayList objResultDutyIdArry = (ArrayList)objDocHt.get("DUTY_ID");
		String strEqual = (String)objDocHt.get("EQUAL");
		
		if ((objResultDocIdArry.size() + objResultDutyIdArry.size() < 1) 
			|| (strEqual.equals("N"))){  //strEqual => "N" �̸� ������ ������ �� �ۼ��ڿ� ����ڰ� Ʋ�� ��찡 ����
%>
<script language="javascript">
<!--
	alert("���������� �ۼ��ڸ� ����/������ �� �ֽ��ϴ�.!");
	self.close();
//-->
</script>

<%
		}
%>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="380" border="0" cellspacing="0" cellpadding="0">
<form name="form_main" method="post" action="">
<%		
		String strId = "";
		String strNm = "";
		String strGubnReturn = "";
		if(objResultDocIdArry.size() > 0){
			/**** �з��� ���̺��� �ۼ��ڿ� ������ ���� �����͸� display -- start ****/
			Hashtable objResultDocIdHt = new Hashtable();
			objResultDocIdHt =(Hashtable)objResultDocIdArry.get(0);
			strId = (String)objResultDocIdHt.get("DOCBOX_ID");
			strNm = (String)objResultDocIdHt.get("DOCBOX_NM");
			strGubnReturn = "D";
		}else if(objResultDutyIdArry.size() > 0){
			/**** �������� ���̺��� �ۼ��ڿ� ������ ���� �����͸� display -- start ****/
			Hashtable objResultDutyIdHt = new Hashtable();
			objResultDutyIdHt =(Hashtable)objResultDutyIdArry.get(0);
			strId = (String)objResultDutyIdHt.get("DUTY_ID");
			strNm = (String)objResultDutyIdHt.get("FILE_NAME");
			strGubnReturn = "F";
		}
%>
<input type="hidden" name="gubun"  value="<%=strGubnReturn%>"><br>
<input type="hidden" name="chg_id"  value="<%=strId%>"><br>
  <tr class="td_mypage"> 
    <td height="5"></td>
    <td height="5"></td>
  </tr>
  <tr> 
    <td height="10"></td>
    <td height="10"></td>
  </tr>
  <tr> 
    <td width="14">&nbsp;</td>
    <td width="386" height="25" valign="middle"><span class="soti_reqsubmit"><img src="../image/mypage/icon_mypage_soti.gif" width="9" height="9" align="absmiddle"> 
      </span><span class="soti_mypage">����/���ϸ� ����</span></td>
  </tr>
  <tr> 
    <td width="14">&nbsp;</td>
    <td height="23" align="left" valign="top"><table width="96%" border="0" cellspacing="0" cellpadding="0">
        <tr bgcolor="AED889" height="3"> 
          <td height="2"  colspan="2" class="td_mypage"></td>
        </tr>
        <tr > 
          <td width="104" height="25"  class="td_gray1"><img src="../image/common/icon_nemo_gray.gif" width="3" height="6"> 
            ����/���ϸ� </td>
          <td width="248" height="25"  class="td_lmagin" ><div align="left"> 
              <input name="chg_nm" type="text" class="textfield" style="WIDTH: 200px" value="<%=strNm%>">
            </div></td>
        </tr>
        <tr > 
          <td height="1" colspan="2"  class="tbl-line"></td>
        </tr>
        <tr> 
          <td height="2" colspan="2" class="tbl-line"></td>
        </tr>
      </table></td>
  </tr>
  <tr> 
    <td width="14">&nbsp;</td>
    <td height="40" align="left"><table width="96%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td width="36%">&nbsp;</td>
          <td width="64%" align="right"><a href="javascript:fun_update()"><img src="../image/button/bt_change.gif" width="43" height="20" border="0"></a>&nbsp;<a href="javascript:self.close()"><img src="../image/button/bt_cancel.gif" width="43" height="20" border="0"></a></td>
        </tr>
      </table></td>
  </tr>
  <tr align="right"> 
    <td height="25" colspan="2" class="td_gray1">&nbsp;<a href="javascript:self.close()"><img src="../image/button/bt_close.gif" width="46" height="11" border="0"></a>&nbsp;&nbsp;</td>
  </tr>
</form>
</table>
</body>
<%
	}
	catch(AppException objAppEx)
	{	
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
</html>
