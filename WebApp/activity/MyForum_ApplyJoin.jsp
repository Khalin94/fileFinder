<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<html>
<head>
<title>�����ڷ� �������� �ý���</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link href="../css/System.css" rel="stylesheet" type="text/css">
</head>
<script language="javascript">
	function fun_reason(varForumId, varStt){
		var url = "ApprovalRejectionReasonPop.jsp?gubn=1&forum_id=" + varForumId +  "&forum_stt=" + varStt;
		window.open(url,'New','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=no,width=390,height=255,left=0,top=0');		
	}
		
	function fun_cancel(varForumId, varStt){
		document.form_main.action = "./forum/CancelEstabcloseProc.jsp?forum_id=" + varForumId + "&forum_stt=" + varStt;
		document.form_main.submit();
	}
	
	function fun_reasonuser(varForumId){
		var url = "ApprovalRejectionReasonPop.jsp?gubn=2&forum_id=" + varForumId;
		window.open(url,'New','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=no,width=390,height=255,left=0,top=0');		
	}
		
	function fun_canceluser(varForumId, varStt){
		document.form_main.action = "./forum/CancelJoinleaveProc.jsp?forum_id=" + varForumId + "&user_stt=" + varStt;
		document.form_main.submit();
	}	
</script>
<script src='/js/forum.js'></script>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<%@ include file="/common/CheckSession.jsp" %>
<%@ include file="/common/TopMenu.jsp" %>
<table width="100%" height="508" border="0" cellpadding="0" cellspacing="0">
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
<form name="form_main" method="post" action="" >
        <tr valign="top">
          <td width="30" height="363" align="left"><img src="../image/common/bg_leftBody.gif" width="30" height="1"></td>
          <td align="left"><table width="759" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td width="759" height="23" align="left" valign="top"></td>
              </tr>
              <tr> 
                <td align="left" valign="top"><table width="100%" height="23" border="0" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="23%" background="../image/mypage/bg_mypage_tit.gif"><span class="title">���� 
                        ���� </span><strong>- ����/��û ����</strong> </td>
                      <td width="18%" align="left" background="../image/common/bg_titLine.gif">&nbsp;</td>
                      <td width="59%" align="right" background="../image/common/bg_titLine.gif" class="text_s"><img src="../image/common/icon_navi.gif" width="3" height="5" align="absmiddle"> 
                        Home&gt;����������&gt;��������&gt;<strong>����/��û ����</strong></td>
                    </tr>
                  </table></td>
              </tr>
              <tr> 
                <td height="30"  align="left" class="text_s">
                  ���� Ȱ�� ���� ��������� ǥ�õǸ�, ����/��� ��û ���� ����, ����/Ż�� ��û ���� ���� ����� ���� �� �ֽ��ϴ�.
                </td>
              </tr>
              <tr> 
                <td height="5" align="left" class="soti_reqsubmit"></td>
              </tr>
              <tr> 
                <td height="30" align="left"><span class="soti_reqsubmit"><img src="../image/mypage/icon_mypage_soti.gif" width="9" height="9" align="absmiddle"> 
                  </span><span class="soti_mypage">���Ե� ����</span></td>
              </tr>
              <tr> 
                <td align="left" valign="top"><table width="759" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td height="2" colspan="6" class="td_mypage"></td>
                    </tr>
                    <tr class="td_top"> 
                      <td width="41" height="22" align="center">NO</td>
                      <td width="105" height="22" align="center">�з�</td>
                      <td width="365" height="22" align="center">������</td>
                      <td width="80" height="22" align="center">����</td>
                      <td width="82" height="22" align="center">����</td>
                      <td width="86" height="22" align="center">������</td>
                    </tr>
                    <tr> 
                      <td height="1" colspan="6" class="td_mypage"></td>
                    </tr>                          
                    <%@ include file="forum/SelectJoinProc.jsp" %></td>
                  </table></td>
              </tr>
              <tr> 
                <td height="20" align="left" valign="top">&nbsp;</td>
              </tr>
              <tr> 
                <td height="30" align="left"><span class="soti_reqsubmit"><img src="../image/mypage/icon_mypage_soti.gif" width="9" height="9" align="absmiddle"> 
                  </span><span class="soti_mypage">����/��� ��û ���� ����</span></td>
              </tr>
              <tr> 
                <td align="left" valign="top"><table width="759" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td height="2" colspan="7" class="td_mypage"></td>
                    </tr>
                    <tr class="td_top"> 
                      <td width="38" height="22" align="center">NO</td>
                      <td width="80" height="22" align="center">�з�</td>
                      <td width="89" height="22" align="center">����</td>
                      <td width="320" height="22" align="center">������</td>
                      <td width="86" height="22" align="center">���</td>
                      <td width="69" height="22" align="center">ó������</td>
                      <td width="77" align="center">���</td>
                    </tr>
					<tr> 
                      <td height="1" colspan="7" class="td_mypage"></td>
                    </tr>              
                    <%@ include file="forum/SelectEstabcloseProc.jsp" %></td>
                  </table></td>
              </tr>
              <tr> 
                <td height="20" align="left" valign="top">&nbsp;</td>
              </tr>
              <tr> 
                <td height="30" align="left"><span class="soti_reqsubmit"><img src="../image/mypage/icon_mypage_soti.gif" width="9" height="9" align="absmiddle"> 
                  </span><span class="soti_mypage">����/Ż�� ��û ���� ����</span></td>
              </tr>
              <tr> 
                <td align="left" valign="top"><table width="759" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td height="2" colspan="7" class="td_mypage"></td>
                    </tr>
                    <tr class="td_top"> 
                      <td width="38" height="22" align="center">NO</td>
                      <td width="80" height="22" align="center">�з�</td>
                      <td width="89" height="22" align="center">����</td>
                      <td width="320" height="22" align="center">���� ��</td>
                      <td width="86" height="22" align="center">���</td>
                      <td width="69" height="22" align="center">ó������</td>
                      <td width="77" align="center">���</td>
                    </tr>
                    <tr> 
                      <td height="1" colspan="7" class="td_mypage"></td>
                    </tr>
                    <%@ include file="forum/SelectJoinleaveProc.jsp" %></td>
                  </table></td>
              </tr>
              <tr> 
                <td height="35" align="left" valign="top"></td>
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
