<%@ page language="java"  contentType="text/html;charset=euc-kr" %>	
<%@ page import = "java.util.*" %>
<%@ page import = "java.net.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="nads.lib.message.MessageBean" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%@ include file="/board/common/GetBoardProperty.jsp" %>
<%
	String strLoginID = (String)session.getAttribute("USER_ID");
	out.println("============>"+strLoginID);	
	/*GET �Ķ����*/
	String strCurrentPage =  StringUtil.getNVLNULL(request.getParameter("strCurrentPage")); //���� ������
	String strBbrdID =  StringUtil.getNVLNULL(request.getParameter("bbrdid"));						//�Խ��� ���̵�
	String strEditorExt =  "N";																										//����Ʈ�� "N"
	/* �亯�� ��� �߰��Ǵ� GET �Ķ���� */
	String strDataID =  StringUtil.getNVLNULL(request.getParameter("dataid"));
	String strTTopID =  StringUtil.getNVLNULL(request.getParameter("ttopid"));
	String strTopLevel =  StringUtil.getNVLNULL(request.getParameter("toplevel"));
	String strTopOrder =  StringUtil.getNVLNULL(request.getParameter("toporder"));
	
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
	nads.dsdm.app.board.SLBoardDelegate objAuthBoard = new nads.dsdm.app.board.SLBoardDelegate();
	Hashtable objHshBbrdInfo = null;			//�Խ��� 
	String strGoToPage = URLEncoder.encode("/authinfo/AuthBoardList.jsp", "UTF-8");	//��ũ�� ������ ���� 
	
	try{
		//1. �Խ��� ������ �����´�.
		objHshBbrdInfo = objAuthBoard.selectBbrdInfo(strBbrdID);
	
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
	
	//�Խ��� ���� 
	String strBbrdKind = (String)objHshBbrdInfo.get("BBRD_KIND");
	int intBbrdFileCnt = Integer.valueOf((String)objHshBbrdInfo.get("APD_FILE_CNT")).intValue();
%>

<html>
<head>
<title>++ ������ �߱޾ȳ�++</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" href="style.css" type="text/css">
<link href="/css/System.css" rel="stylesheet" type="text/css">
<script language="javascript" src="/js/forum.js"></script>
<script language="javascript" src="/js/editor/htmleditor.js"></script>
<script language="javascript">
	
	//������ �ʱ�ȭ
	var myeditor = new htmleditor("myeditor");
	
	function setCont() {

		myeditor.width = 480;
		myeditor.height = 250;
		//myeditor.fontsize = '10pt';
		//myeditor.lineheight = '14pt';
		var varCont = document.frmWrite.cont.value;
		myeditor.init(varCont);
		
	}

	function isSave() {
		
		frm = document.frmWrite;
		
		//���� 
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
        
        //����� 
        if (frm.writernm.value == "" || frm.writernm.value == null){
			alert("����ڸ� �Է��� �ּ���.");
			frm.writernm.focus();
			return false;
		} 
		
		if (fnSpaceChk(frm.writernm.value, "����ڸ� �ùٸ��� �Է��ϼ���.") == false ) 	return false;
		
		//�ѱ�, ���� �����Ͽ� ���ڿ� ���̸� üũ�Ѵ�.
        if(checkStrLen(frm.writernm, 10, "�����") == false){
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
		
		//��й�ȣ 
		 if (frm.datapwd.value == "" || frm.datapwd.value == null){
			alert("��й�ȣ�� �Է��� �ּ���.");
			frm.datapwd.focus();
			return false;
		} 
		
		if (fnSpaceChk(frm.datapwd.value, "��й�ȣ�� �ùٸ��� �Է��ϼ���.") == false ) 	return false;
		
		//�ѱ�, ���� �����Ͽ� ���ڿ� ���̸� üũ�Ѵ�.
        if(checkStrLen(frm.datapwd, 8, "��й�ȣ") == false){
            return false;
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
		       
		
        frm.editorext.value = ext;
		
	}
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="725" border="0" cellpadding="0" cellspacing="0" background="images/bg.gif">
  <tr>
    <td width="24">&nbsp;</td>
    <td width="677" align="center"> <br>
      <!-- ���ǰԽ��� ��� ���̺� ���� ----------------------------->
      <table width="636" border="0" cellspacing="0" cellpadding="0">
      <form name="frmWrite" method="post" action="/board/common/BoardProc.jsp?bbrdid=<%=strBbrdID%>&bbrdkind=<%=strBbrdKind%>"  onSubmit="return isSave();" encType="multipart/form-data">
		<input type="hidden" name="cmd" value="CREATE">
		<textarea name="cont" wrap="hard"  style="display:none;"></textarea>
		<input type="hidden" name="strGoToPage" value="<%=strGoToPage%>">
		<input type="hidden" name="strCurrentPage" value="<%=strCurrentPage%>">
		<input type="hidden" name="bbrdid" value="<%=strBbrdID%>">
		<input type="hidden" name="dataid" value="<%=strDataID%>">
		<input type="hidden" name="ttopid" value="<%=strTTopID%>">
		<input type="hidden" name="toplevel" value="<%=strTopLevel%>">
		<input type="hidden" name="toporder" value="<%=strTopOrder%>">
		<input type="hidden" name="editorext" value="">
        <tr> 
          <td height="10" align="left" valign="top"></td>
        </tr>
        <tr> 
          <td height="23" align="left" valign="top"><table width="100%" height="23" border="0" cellpadding="0" cellspacing="0">
              <tr> 
                <td width="13%" background="/image/board/bg_board_tit.gif"><span class="title">���ǰԽ���</span></td>
                <td width="28%" align="left" background="/image/common/bg_titLine.gif">&nbsp;</td>
                <td width="59%" align="right" background="/image/common/bg_titLine.gif" class="text_s">&nbsp;</td>
              </tr>
            </table></td>
        </tr>
        <tr> 
          <td height="30" align="left" class="soti_reqsubmit"></td>
        </tr>
        <tr> 
          <td align="left" valign="top">
            <table width="636" border="0" cellspacing="0" cellpadding="0">
              <tr class="td_board"> 
                <td width="130" height="2"></td>
                <td width="506" height="2"></td>
              </tr>
              <tr> 
                <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> ����</td>
                <td height="25" class="td_lmagin"><input name="title" type="text" class="textfield" style="WIDTH: 300px" ></td>
              </tr>
              <tr class="tbl-line"> 
                <td height="1"></td>
                <td height="1"></td>
              </tr>
              <tr> 
                <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> �����</td>
                <td height="25" class="td_lmagin"><input name="writernm" type="text" class="textfield" style="WIDTH: 150px"></td>
              </tr>
              <tr class="tbl-line"> 
                <td height="1"></td>
                <td height="1"></td>
              </tr>
              <tr> 
                <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> ���⼱��</td>
                <td height="25" class="td_lmagin">
				  <input type="radio" name="editorflag" value="N" onClick="selEditor('newlayer', 'newlayer2', frmWrite.txtCont);" <% if(strEditorExt.equals("N")) out.println("checked"); %>>�ؽ�Ʈ
				  <input type="radio" name="editorflag" value="Y" onClick="selEditor('newlayer2', 'newlayer', frmWrite.txtCont);" <% if(strEditorExt.equals("Y")) out.println("checked"); %>>HTML ������
				</td>
              </tr>
              <tr class="tbl-line"> 
                <td height="1"></td>
                <td height="1"></td>
              </tr>
              <tr> 
                <td height="45" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> ����</td>
                <td height="45" valign="top" class="td_box">
                	<span ID="newlayer" style="position:absolute;"><textarea name="txtCont" wrap="hard" class="textfield" style="WIDTH: 100% ; height: 250"></textarea></span>
               		<span ID="newlayer2"><script>setCont();</script></span>
               	</td>
              </tr>
              <% if (intBbrdFileCnt != 0) {	//����÷�ΰ� 0���� �ƴ϶��....%>
              <tr height="1" class="tbl-line"> 
                <td height="1"></td>
                <td height="1"></td>
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
              <tr class="tbl-line"> 
                <td height="1"></td>
                <td height="1"></td>
              </tr>    
              <tr> 
                <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> ��й�ȣ</td>
                <td height="25" class="td_lmagin"><input name="datapwd" type="password" class="textfield" style="WIDTH: 150px"></td>
              </tr>
              <tr height="1" class="tbl-line"> 
                <td height="2"></td>
                <td height="2"></td>
              </tr>
            </table>
            
          </td>
        </tr>
        <tr> 
          <td height="40" align="left" valign="middle">
            <input type="image"  src="/image/button/bt_save.gif" width="43" height="20"> 
            <img src="/image/button/bt_cancel.gif" width="43" height="20" style="cursor:hand;" onClick="reset();">
            <a href="AuthBoardList.jsp?strCurrentPage=<%=strCurrentPage%>&bbrdid=<%=strBbrdID%>"><img src="/image/button/bt_list.gif" width="43" height="20" border="0"></a> 
          </td>
        </tr>
      </form>
      </table>
      <!-- ���ǰԽ��� ��� ���̺� �� -----------------------------> 
      <br>
      <br>
    </td>
    <td width="24">&nbsp;</td>
  </tr>
  <tr>
    <td width="24">&nbsp;</td>
    <td><img src="images/copy.gif" width="677" height="29"></td>
    <td width="24">&nbsp;</td>
  </tr>
  <tr>
    <td width="24">&nbsp;</td>
    <td>&nbsp;</td>
    <td width="24">&nbsp;</td>
  </tr>
</table>
<script language="javascript">
	
	//������ �ʱ�ȭ 
	selEditor('newlayer', 'newlayer2');
	
</script>
</body>
</html>
