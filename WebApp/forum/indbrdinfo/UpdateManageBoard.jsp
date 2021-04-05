<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="nads.dsdm.app.common.code.*" %>
<%@ page import="nads.lib.message.MessageBean" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%@ include file="/forum/common/CheckSessionPop.jsp" %>
<%@ include file="/board/common/GetBoardProperty.jsp" %>
<%
	/*���ǰ� */
	String strLoginID = (String)session.getAttribute("USER_ID");							//�α��� ID
	
	/*�������� ������ �Ķ���� (����ID, ȸ������, ��������, ������)*/
	String strForumID = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("fid"))); 				//���� ���̵�
	String strUserStt = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("uStt")));		 		//ȸ������
	String strOpenFlag = ""; 																							//��������
	String strForumNM = ""; 																							//������
	
	/*GET �Ķ����*/
	String strBbrdID = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("bbrdid")));			//�Խ��� ���̵�	
	
	if(strBbrdID == null || strBbrdID.equals("") || strBbrdID.equals(" ")){
		
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		objMsgBean.setStrCode("DSPARAM-0000");
		objMsgBean.setStrMsg("�Խ��� ������ �˼� �����ϴ�.");
		
		// ���� �߻� �޼��� �������� �̵��Ѵ�.
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
			
	}
	
	/*�ʱⰪ ���� */
	nads.dsdm.app.forum.SLMngBoardDelegate objMngBoard = new nads.dsdm.app.forum.SLMngBoardDelegate();
	Hashtable objHshBbrdInfo = null;
	//�Խ��� ÷������ �ִ� ���� 
	CodeInfoDelegate objCode = new CodeInfoDelegate();
	int intFileMaxCnt = Integer.valueOf(objCode.lookUpCodeName("M07", "001")).intValue();
	
	try{
		
		//�Խ��� ������ �����´�.
		objHshBbrdInfo = objMngBoard.selectBbrdInfo(strBbrdID);
		
	} catch (AppException objAppEx) {
	
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		objMsgBean.setStrCode(objAppEx.getStrErrCode());
		objMsgBean.setStrMsg(objAppEx.getMessage());
		
		// ���� �߻� �޼��� �������� �̵��Ѵ�.
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
		
	}
	
	String strBbrdKind = (String)objHshBbrdInfo.get("BBRD_KIND");
	String strSelKindNm = "";
	int intDataCnt = Integer.valueOf((String)objHshBbrdInfo.get("CNT")).intValue();
	int intFileCnt = Integer.valueOf((String)objHshBbrdInfo.get("APD_FILE_CNT")).intValue();
	String strAnsExt = (String)objHshBbrdInfo.get("ANS_EXT");
	String strOneExt = (String)objHshBbrdInfo.get("ONE_ANS_EXT");

%>
<html>
<head>
<title>�����ڷ� �������� �ý���</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link href="/css/System.css" rel="stylesheet" type="text/css">
<script language="javascript" src="/js/forum.js"></script>
<script language="javascript">
	
	function isSave(){
		var frm = document.frmUpdate;
		
		//�Խ��� �̸� 
		if (frm.bbrdnm.value == "" || frm.bbrdnm.value == null){
			alert("�Խ��� �̸��� �Է��� �ּ���.");
			frm.bbrdnm.focus();
			return false;
		} 
		
		if (fnSpaceChk(frm.bbrdnm.value, "�Խ��� �̸��� �ùٸ��� �Է��ϼ���.") == false ) 	return false;
		
		//�ѱ�, ���� �����Ͽ� ���ڿ� ���̸� üũ�Ѵ�.
        if(checkStrLen(frm.bbrdnm, 100, "�̸�") == false){
            return false;
        }
        
		//��� 
		var AnsExt = "";
		for(var i=0;i<frm.selans.length; i++) {
			if (frm.selans[i].checked == true) {
				AnsExt = frm.selans[i].value;
            }	
		}
		
		if(AnsExt == "" || AnsExt == null){
			alert("�亯 ������ ������ �ּ���.");
			return false;
		}
		
		//���� ��� 
		var OneExt = "";
		for(var i=0;i<frm.selone.length; i++) {
			if (frm.selone[i].checked == true) {
				OneExt = frm.selone[i].value;
            }	
		}
		
		if(OneExt == "" || OneExt == null){
			alert("���ٴ�� ������ ������ �ּ���.");
			return false;
		}
		
		//���� 
		if (frm.dsc.value == "" || frm.dsc.value == null){
			alert("������ �Է��� �ּ���.");
			frm.dsc.focus();
			return false;
		} 
		
		if (fnSpaceChk(frm.dsc.value, "������ �ùٸ��� �Է��ϼ���.") == false ) 	return false;
		
		//�ѱ�, ���� �����Ͽ� ���ڿ� ���̸� üũ�Ѵ�.
        if(checkStrLen(frm.dsc, 100, "����") == false){
            return false;
        }
        
		frm.ansext.value = AnsExt;
		frm.oneext.value = OneExt;
		//frm.submit();
	}

</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<%@ include file="/forum/common/MenuTopForumPop.jsp" %>
<table width="800" height="450" border="0" cellpadding="0" cellspacing="0">
  <tr align="left" valign="top"> 
    <td width="149" background="/image/forum/bg_forumLeft.gif"> 
      <%@ include file="/forum/common/MenuLeftForumPop.jsp" %>
    </td>
    <td align="center"><table width="589" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td height="21" align="left" valign="top"></td>
        </tr>
        <tr> 
          <td align="left" valign="top"><table width="100%" height="23" border="0" cellpadding="0" cellspacing="0">
              <tr> 
                <td width="15%" background="/image/forum/bg_forumpop_tit.gif"><span class="title">�Խ��� ����</span></td>
                <td width="85%" align="left" background="/image/common/bg_titLine.gif">&nbsp;</td>
              </tr>
            </table></td>
        </tr>
        <tr> 
          <td height="30" align="left" class="text_s">�������� �����Ǵ� �Խ��� ������ �޴��� �����Ͻ� �� �ֽ��ϴ�.</td>
        </tr>
        <tr> 
          <td height="5" align="left" valign="top"></td>
        </tr>
        <tr> 
          <td align="left" valign="top">
		    <!-- �Խ��� ���� ���̺� ���� --------------------------->
		    <table width="100%" border="0" cellspacing="0" cellpadding="0">
		    <form name="frmUpdate" method="post" action="ManageBoardProc.jsp" onSubmit="return isSave();">
			<input type="hidden" name="cmd" value="UPDATE">
			<input type="hidden" name="fid" value="<%=strForumID%>">
			<input type="hidden" name="uStt" value="<%=strUserStt%>">
			<input type="hidden" name="bbrdid" value="<%=strBbrdID%>">
			<input type="hidden" name="ansext" value="">
			<input type="hidden" name="oneext" value="">
              <tr> 
                <td width="91" height="2" class="td_forumpop"></td>
                <td width="480" height="2" class="td_forumpop"></td>
              </tr>
              <tr> 
                <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> �Խ��� �̸�</td>
                <td height="25" class="td_lmagin"><input name="bbrdnm" type="text" class="textfield" style="WIDTH: 300px" value="<%=objHshBbrdInfo.get("BBRD_NM")%>" ></td>
              </tr>
              <tr> 
                <td height="1" class="tbl-line"></td>
                <td height="1" class="tbl-line"></td>
              </tr>
			  <tr> 
                <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> �Խ��� ����</td>
                <td height="25" class="td_lmagin">
                  <select name="bbrdkind" class="select">
                  	<option value="<%=noticeBoard%>" <%if(strBbrdKind.equals(noticeBoard)) out.println("selected");%>>��������</option>
					<option value="<%=freeBoard%>" <%if(strBbrdKind.equals(freeBoard)) out.println("selected");%>>�Խ���</option>
					<option value="<%=dataBoard%>" <%if(strBbrdKind.equals(dataBoard)) out.println("selected");%>>�ڷ��</option>
                  </select>
              </tr>
              <tr> 
                <td height="1" class="tbl-line"></td>
                <td height="1" class="tbl-line"></td>
              </tr>
              <tr> 
                <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> ÷������ ����</td>
                <td height="25" class="td_lmagin">
                  <select name="filecnt" class="select">
                  <% for (int i = intFileCnt; i < intFileMaxCnt + 1; i++) {%>
                  	<option value="<%=i%>"><%=i%></option>
                  <% } %>
                  </select><font color="red"> - ���� �����θ� ���� ����</font>
                </td>
              </tr>
              <tr> 
                <td height="1" class="tbl-line"></td>
                <td height="1" class="tbl-line"></td>
              </tr>
              <tr> 
                <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> �亯��</td>
                <td height="25" class="td_lmagin">
                  <input type="radio" name="selans" value="Y" <%if(strAnsExt.equals("Y")) out.println("checked");%>> ����� 
                  <input type="radio" name="selans" value="N" <%if(strAnsExt.equals("N")) out.println("checked"); else out.println("disabled");%>> ������
                  <font color="red"> - ������� ������ ���� ���� ���� �Ұ�</font>
                 </td>
              </tr>
              <tr> 
                <td height="1" class="tbl-line"></td>
                <td height="1" class="tbl-line"></td>
              </tr>
              <tr> 
                <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> ���ٴ亯</td>
                <td height="25" class="td_lmagin">
                  <input type="radio" name="selone" value="Y" <%if(strOneExt.equals("Y")) out.println("checked");%>> ����� 
                  <input type="radio" name="selone" value="N" <%if(strOneExt.equals("N")) out.println("checked"); else out.println("disabled");%>> ������
                  <font color="red"> - ������� ������ ���� ���� ���� �Ұ�</font>
                </td>
              </tr>
              <tr> 
                <td height="1" class="tbl-line"></td>
                <td height="1" class="tbl-line"></td>
              </tr>
              <tr> 
                <td height="45" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> ����</td>
                <td height="45" valign="top" class="td_box"><textarea name="dsc" wrap="hard" class="textfield" style="WIDTH: 100% ; height: 100"><%=objHshBbrdInfo.get("DSC")%></textarea></td>
              </tr>
              <tr height="1"> 
                <td height="2" class="tbl-line"></td>
                <td height="2" class="tbl-line"></td>
              </tr>
			  <tr>
			  	<td height="35" colspan="2">
					<input type="image" src="/image/button/bt_save.gif" width="43" height="20">&nbsp;
					<img src="/image/button/bt_cancel.gif" width="43" height="20" style="cursor:hand;" onClick="reset()">&nbsp;
					<a href="ManageBoardList.jsp?fid=<%=strForumID%>&uStt=<%=strUserStt%>"><img src="/image/button/bt_list.gif" width="43" height="20" border="0"></a>
			  	</td>
			  </tr>
			 </form>
            </table>
		  	<!-- �Խ��� ���� ���̺� �� --------------------------->
		  </td>
        </tr>
        <tr> 
          <td height="15">&nbsp;</td>
        </tr>
      </table></td>
  </tr>
</table>
<%@ include file="/forum/common/BottomForumPop.jsp" %>
</body>
</html>
