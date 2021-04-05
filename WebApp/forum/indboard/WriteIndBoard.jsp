<%@ page language="java"  contentType="text/html;charset=euc-kr" %>	
<%@ page import = "java.util.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="nads.lib.message.MessageBean" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%@ include file="/forum/common/CheckSessionPop.jsp" %>
<%@ include file="/board/common/GetBoardProperty.jsp" %>
<%
	/*���ǰ� */
	String strLoginID = (String)session.getAttribute("USER_ID");							//�α��� ID
	String strLoginNm = (String)session.getAttribute("USER_NM");						//�α��� Name	
	
	/*�������� ������ �Ķ���� (����ID, ȸ������, ��������, ������)*/
	String strForumID = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("fid"))); //����ID
	String strUserStt = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("uStt"))); //ȸ������
	String strOpenFlag = ""; //��������
	String strForumNM = ""; //������
	
	/*GET �Ķ����*/
	String strCurrentPage =  nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("strCurrentPage"))); //���� ������
	String strBbrdID =  nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("bbrdid")));						//�Խ��� ���̵�
	String strAncTgt = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("anctgt")));							//�������
	String strEditorExt =  "N";																										//����Ʈ�� "N"
	/* �亯�� ��� �߰��Ǵ� GET �Ķ���� */
	String strDataID =  nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("dataid")));
	String strTTopID =  nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("ttopid")));
	String strTopLevel =  nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("toplevel")));
	String strTopOrder =  nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("toporder")));
	String strFORUM_OPRTR_ID = "";
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
	nads.dsdm.app.board.SLBoardDelegate objForumBoard = new nads.dsdm.app.board.SLBoardDelegate();
	nads.dsdm.app.forum.SLDBForumDelegate objDBForum = new nads.dsdm.app.forum.SLDBForumDelegate();
	Hashtable objHshBbrdInfo = null;			//�Խ��� 
	Hashtable objHshFidInfo = null;
	
	try{
		//1. �Խ��� ������ �����´�.
		objHshBbrdInfo = objForumBoard.selectBbrdInfo(strBbrdID);
		objHshFidInfo = objDBForum.selectIndForumInfo(strForumID);
		
		strFORUM_OPRTR_ID = StringUtil.getNVLNULL((String)objHshFidInfo.get("FORUM_OPRTR_ID"));
				
		
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
	
	if(strForumID.equals("0000000178") || strForumID.equals("0000000180")){
		if(strBbrdID.equals("0000000141") || strBbrdID.equals("0000000144")){
			if(strLoginID.equals(strFORUM_OPRTR_ID) || strLoginID.equals("ADMIN")){
				
			}else{
				out.println("<script language=javascript>");
				out.println("alert('�Խ��ǿ� ���� ������ �����ϴ�.');");
				out.println("history.go(-1);");
				out.println("</script>");				
				return;
			}
		}
	}
	
	//�Խ��� ���� 
	String strBbrdKind = (String)objHshBbrdInfo.get("BBRD_KIND");
	int intBbrdFileCnt = Integer.valueOf((String)objHshBbrdInfo.get("APD_FILE_CNT")).intValue();
	String strBbrdNm = (String)objHshBbrdInfo.get("BBRD_NM");
	if(strAncTgt.equals("1")){
		strBbrdNm = "��� ��������";
	}
	String strBbrdDsc = (String)objHshBbrdInfo.get("DSC");
	if(strAncTgt.equals("1")){
		strBbrdDsc = "���� ��� ���������Դϴ�.";
	}
	int intBbrdLength = strBbrdNm.length() * 3;
	int intBbrdLength2 = 0;
	if(intBbrdLength < 100){
		intBbrdLength2 = 100 - intBbrdLength;
	}
	
	session.setAttribute("BBRD_ID",strBbrdID);
%>

<html>
<head>
<title>�����ڷ� �������� �ý���</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link href="/css/System.css" rel="stylesheet" type="text/css">
<script language="javascript" src="/js/forum.js"></script>
<script language="javascript" src="/js/editor/htmleditor.js"></script>
<script language="javascript">
	
	//������ �ʱ�ȭ
	var myeditor = new htmleditor("myeditor");
	
	function setCont() {

		myeditor.width = 460;
		myeditor.height = 250;
		//myeditor.fontsize = '10pt';
		//myeditor.lineheight = '14pt';
		var varCont = document.frmWrite.cont.value;
		myeditor.init(varCont);
		
	}
	
	//����
	function isSave() {
	
		frm = document.frmWrite;
		
		if (frm.title.value == "" || frm.title.value == null){
			alert("������ �Է��� �ּ���.");
			frm.title.focus();
			return false;
		} 
		
		if (fnSpaceChk(frm.title.value, "������ �ùٸ��� �Է��ϼ���.") == false ) 	return false;
		
		//�ѱ�, ���� �����Ͽ� ���ڿ� ���̸� üũ�Ѵ�.
        if(checkStrLen(frm.title, 100, "����") == false){
            return false;
        }

		var ext = "";
		for (i = 0; i < frm.editorflag.length; i++) {
		    if (frm.editorflag[i].checked == true) {
		        ext = frm.editorflag[i].value;
		        break;
		    }
		}
		
		if(ext == "Y"){													//HTML�����͸� ����� ��� 
			
			var varCont = myeditor.get_content("NO");
			frm.cont.value = varCont;
			
		} else {															//�ؽ�Ʈ�� ����� ��� 
			
			if (frm.txtCont.value == "" || frm.txtCont.value == null){
				alert("���� ������ �Է��� �ּ���.");
				frm.txtCont.focus();
				return false;
			} 
			
			if (fnSpaceChk(frm.txtCont.value, "������ �ùٸ��� �Է��ϼ���.") == false ) 	return false;
		}
		
		//÷�����ϸ� ���̸� üũ�Ѵ�.
		var max_file = <%=intBbrdFileCnt%>;		//��� ������ ���� ���� 
		
		for(var i = 0; i < max_file; i++) {
			var file_object = "document.frmWrite.upfile" + i + ".value";
			if(eval(file_object) != ""){
				if(checkFileName(eval(file_object)) == false){
					return false;					
				}
			}
		}
		
		//÷�������� Ÿ���� üũ�Ѵ�.		
		for (var i = 0; i < max_file; i++) {
			var file_object = "document.frmWrite.upfile" + i + ".value";
			if (eval(file_object) != "") { 		
				 if(fnBoardLimitAttach(eval(file_object))== false){
		            return false;
		        }
			}
		}
		
		frm.editorext.value = ext;	
			
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
    <td align="center">
      <!-- �����Խ��� ��� ���̺� ���� ----------------------------->
	  <table width="590" border="0" cellspacing="0" cellpadding="0">
	  <form name="frmWrite" method="post" action="IndBoardProc.jsp?bbrdid=<%=strBbrdID%>&bbrdkind=<%=strBbrdKind%>" onSubmit="return isSave();" encType="multipart/form-data"> 
	  <input type="hidden" name="fid" value="<%=strForumID%>">
	  <input type="hidden" name="uStt" value="<%=strUserStt%>">
	  <input type="hidden" name="anctgt" value="<%=strAncTgt%>">
	  <input type="hidden" name="cmd" value="CREATE">
	  <textarea name="cont" wrap="hard" style="display:none;"></textarea>
	  <input type="hidden" name="strCurrentPage" value="<%=strCurrentPage%>">
	  <input type="hidden" name="bbrdid" value="<%=strBbrdID%>">
	  <input type="hidden" name="dataid" value="<%=strDataID%>">
	  <input type="hidden" name="ttopid" value="<%=strTTopID%>">
	  <input type="hidden" name="toplevel" value="<%=strTopLevel%>">
	  <input type="hidden" name="toporder" value="<%=strTopOrder%>">
	  <input type="hidden" name="editorext" value="">
        <tr> 
          <td height="21" align="left" valign="top"></td>
        </tr>
        <tr> 
          <td align="left" valign="top">
          <table width="100%" height="23" border="0" cellpadding="0" cellspacing="0">
              <tr> 
                <td width="<%=intBbrdLength%>%" background="/image/forum/bg_forumpop_tit.gif"><span class="title"><%=strBbrdNm%></span></td>
                <td width="<%=intBbrdLength2%>%" align="left" background="/image/common/bg_titLine.gif">&nbsp;</td>
              </tr>
            </table></td>
        </tr>
        <tr> 
          <td height="30" align="left" class="text_s"><%=strBbrdDsc%></td>
        </tr>
        <tr> 
          <td height="5" align="left" valign="top"></td>
        </tr>
        <tr> 
          <td align="left" valign="top">
          	<table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td width="105" height="2" class="td_forumpop"></td>
                <td width="485" height="2" class="td_forumpop"></td>
              </tr>
              <tr> 
                <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> ����</td>
                <td height="25" class="td_lmagin"><input name="title" type="text" class="textfield" style="WIDTH: 300px"></td>
              </tr>
              <tr> 
                <td height="1" class="tbl-line"></td>
                <td height="1" class="tbl-line"></td>
              </tr>
              <tr> 
                <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> �����</td>
                <td height="25" class="td_lmagin"><%=strLoginNm%></td>
              </tr>
              <tr> 
                <td height="1" class="tbl-line"></td>
                <td height="1" class="tbl-line"></td>
              </tr>
              <tr> 
                <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> ���� ����</td>
                <td height="25" class="td_lmagin">
                	<input type="radio" name="editorflag" value="N" onClick="selEditor('newlayer', 'newlayer2', frmWrite.txtCont);" <% if(strEditorExt.equals("N")) out.println("checked"); %>>�ؽ�Ʈ
                	<input type="radio" name="editorflag" value="Y" onClick="selEditor('newlayer2', 'newlayer', frmWrite.txtCont);" <% if(strEditorExt.equals("Y")) out.println("checked"); %>>HTML ������
				</td>
              </tr>
              <tr> 
                <td height="1" class="tbl-line"></td>
                <td height="1" class="tbl-line"></td>
              </tr>
              <tr> 
                <td height="45" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> ����</td>
                <td height="260" valign="top" class="td_box">
                  <span ID="newlayer" style="position:absolute;"><textarea name="txtCont" wrap="hard" class="textfield" style="WIDTH: 100% ; height: 250"></textarea></span>
                  <span ID="newlayer2"><script>setCont();</script></span>
                </td>
              </tr>
              <% if (intBbrdFileCnt != 0) {	//����÷�ΰ� 0���� �ƴ϶��....%>
              <tr> 
                <td height="1" class="tbl-line"></td>
                <td height="1" class="tbl-line"></td>
              </tr>
              <tr> 
                <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> ����</td>
                <td height="25" class="td_lmagin">
				<% for(int i = 0; i < intBbrdFileCnt; i++) {%>
					<input type="text" name="showfile<%=i%>"  class="textfield" style="WIDTH: 300px"  value="" readonly>
					<input type="file" name="upfile<%=i%>" class="textfield" style="WIDTH: 0px" onChange="javascript:searchFile(this.form, this);"><br>
				<% } %>
					÷������ �ִ�뷮 : <%=intKBSize%>M
				</td>
              </tr>
              <% } %>
              <tr height="1"> 
                <td height="2" class="tbl-line"></td>
                <td height="2" class="tbl-line"></td>
              </tr>
            </table></td>
        </tr>
        <tr>
          <td height="35">
          	<input type="image" src="/image/button/bt_save.gif" width="43" height="20">
          	<img src="/image/button/bt_cancel.gif" width="43" height="20" style="cursor:hand;" onClick="reset();">
          	<a href="IndBoardList.jsp?fid=<%=strForumID%>&uStt=<%=strUserStt%>&anctgt=<%=strAncTgt%>&strCurrentPage=<%=strCurrentPage%>&bbrdid=<%=strBbrdID%>"><img src="/image/button/bt_list.gif" width="43" height="20" border="0"></a>
         </td>
        </tr>
        <tr> 
          <td height="15">&nbsp;</td>
        </tr>
      </form>
      </table>
      <!-- �����Խ��� ��� ���̺� �� ----------------------------->
    </td>
  </tr>
</table>
<script language="javascript">
	
	//������ �ʱ�ȭ 
	selEditor('newlayer', 'newlayer2');
	
</script>
<%@ include file="/forum/common/BottomForumPop.jsp" %>
</body>
</html>
