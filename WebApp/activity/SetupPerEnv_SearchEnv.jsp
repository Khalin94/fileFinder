<%@ page language="java" contentType="text/html;charset=euc-kr" %>

<html>
<head>
<title>�����ڷ� �������� �ý���</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link href="../css/System.css" rel="stylesheet" type="text/css">
<script language="JavaScript" type="text/JavaScript">
<!--
	function OpenSave(){
		if((form_main.win_type[0].checked == false) && (form_main.win_type[1].checked == false)){
			alert("�˻� ��� ���� ����� ���õ��� �ʾҽ��ϴ�.");
			return;
		}
		form_main.submit();
	}
	function fun_cancel(){
		location.href="/activity/SetupPerEnv_SearchEnv.jsp";
	}
//-->
</script>
<%@ include file="/common/CheckSession.jsp" %>
<%@ include file="./userinfo/SelectSearchEnvProc.jsp" %>
</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<%@ include file="/common/TopMenu.jsp" %>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr align="left" valign="top">
    <td width="186" background="../image/common/bg_leftMenu.gif">
	<%@ include file="/common/LeftMenu.jsp" %></td>
    <td width="100%"><table width="100%" border="0" cellspacing="0" cellpadding="0">
         <tr height="24" valign="top"> 
          <td height="24" colspan="2" align="left"><table width="789" height="24" border="0" cellpadding="0" cellspacing="0" bgcolor="E2ECF3">
              <tr>
                <td height="24"></td>
              </tr>
            </table></td>
        </tr>
<form name="form_main" method="post" action="./userinfo/UpdateSearchEnvProc.jsp">
        <tr valign="top">
          <td width="30" align="left"><img src="../image/common/bg_leftBody.gif" width="30" height="1"></td>
          <td width="923" align="left"><table width="759" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td width="759" height="23" align="left" valign="top"></td>
              </tr>
              <tr> 
                <td height="23" align="left" valign="top"><table width="100%" height="23" border="0" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="28%" background="../image/mypage/bg_mypage_tit.gif"><span class="title">���� 
                        ȯ�� ���� </span><strong>- �˻� ȯ�� ����</strong></td>
                      <td width="13%" align="left" background="../image/common/bg_titLine.gif">&nbsp;</td>
                      <td width="59%" align="right" background="../image/common/bg_titLine.gif" class="text_s"><img src="../image/common/icon_navi.gif" width="3" height="5" align="absmiddle"> 
                        Home&gt;����������&gt;����ȯ�漳��&gt;<strong>�˻�ȯ�漳��</strong></td>
                    </tr>
                  </table></td>
              </tr>
              <tr> 
                <td height="30"  align="left" class="text_s">
                  [�����˻�]�޴����� ����ϴ� ȭ���� ȯ���� ������ �� �ֽ��ϴ�.
                </td>
              </tr>
              <tr>
                <td height="5" align="left" valign="top" class="soti_reqsubmit"></td>
              </tr>
              <tr> 
                <td height="30" align="left" class="soti_reqsubmit"><span class="soti_reqsubmit"><img src="../image/mypage/icon_mypage_soti.gif" width="9" height="9" align="absmiddle"> 
                  </span><span class="soti_mypage">�˻� ȯ�� ����</span></td>
              </tr>
              <tr> 
                <td align="left" valign="top"><table width="680" border="0" cellspacing="0" cellpadding="0">
                    <tr class="td_mypage"> 
                      <td width="223" height="2"></td>
                      <td width="457" height="2"></td>
                    </tr>
                    <tr> 
                      <td height="25" class="td_gray1"><img src="../image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        �������� ��� ��</td>       
                      <td height="25" class="td_lmagin"><select name="page_cnt" class="select">
                          <option value="10" <%=strRecordCnt_10%>>10��</option>
                          <option value="15" <%=strRecordCnt_15%>>15��</option>
                          <option value="20" <%=strRecordCnt_20%>>20��</option>
                        </select></td>
                    </tr>
                    <tr class="tbl-line"> 
                      <td height="1"></td>
                      <td height="1"></td>
                    </tr>
                    <tr> 
                      <td height="45" class="td_gray1"><img src="../image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        �˻� ��� ���� ���</td>
                      <td height="45" class="td_lmagin">
                      	<input type="radio" name="win_type" value="0" <%=strDisplayKind_new%>>�� â���� ����&nbsp;<br> 
                      	<input type="radio" name="win_type" value="1" <%=strDisplayKind_curr%>>���� â�� ����</td>
                    </tr>
                    <tr class="tbl-line"> 
                      <td height="1"></td>
                      <td height="1"></td>
                    </tr>
                    <tr> 
                      <td height="25" class="td_gray1"><img src="../image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        �α� �˻��� ��ȸ �Ⱓ</td>
                      <td height="25" class="td_lmagin"><select name="term" class="select">
                          <option value="7" <%=strPeriod_7%>>1����</option>
                          <option value="14" <%=strPeriod_14%>>2����</option>
                          <option value="30" <%=strPeriod_30%>>�Ѵ�</option>
                        </select></td>
                    </tr>
                    <tr height="1" class="tbl-line"> 
                      <td height="2"></td>
                      <td height="2"></td>
                    </tr>
                  </table></td>
              </tr>
              <tr> 
                <td height="30" align="left" valign="top"><table width="680" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td height="40" align="left"><a href="javascript:OpenSave()"><img src="../image/button/bt_save.gif" width="43" height="20" border="0"></a>&nbsp;<a href="javascript:fun_cancel()"><img src="../image/button/bt_cancel.gif" width="43" height="20" border="0"></a> 
                        <div align="right"></div></td>
                    </tr>
                  </table></td>
              </tr>
              <tr> 
                <td height="15" align="left" valign="top"></td>
              </tr>
            </table></td>
        </tr>
      </table></td>
  </tr>
</form>
</table>
<%@ include file="../common/Bottom.jsp" %>
</body>
</html>
