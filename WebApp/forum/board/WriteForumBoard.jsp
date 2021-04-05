<%@ page language="java"  contentType="text/html;charset=euc-kr" %>	
<%@ page import = "java.util.*" %>
<%@ page import = "java.net.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="nads.lib.message.MessageBean" %>
<%@ page import="nads.lib.util.BoardComm" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%@ include file="/common/CheckSession.jsp" %>
<%@ include file="/board/common/GetBoardProperty.jsp" %>
<%
	/*���ǰ� */
	String strLoginID = (String)session.getAttribute("USER_ID");						//�α��� ID
	String strLoginNm = (String)session.getAttribute("USER_NM");					//�α��� Name
	
	/*GET �Ķ����*/
	String strCurrentPage =  nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("strCurrentPage"))); //���� ������
	String strBbrdID =  nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("bbrdid")));						//�Խ��� ���̵�
	String strEditorExt =  "N";																										//����Ʈ�� "N"
	/* �亯�� ��� �߰��Ǵ� ���� GET �Ķ���� */
	String strDataID =  nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("dataid")));
	String strTTopID =  nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("ttopid")));
	String strTopLevel =  nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("toplevel")));
	String strTopOrder =  nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("toporder")));
	
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

	if(strBbrdID.equals("0000000010")){
		if(strLoginID.equals("ADMIN") || strLoginID.equals("ADMIN1") || strLoginID.equals("ADMIN2")){
		
		}else{
			out.println("<script language=javascript>");
			out.println("alert('�Խ��ǿ� ���� ������ �����ϴ�.');");
			out.println("history.go(-1);");
			out.println("</script>");				
			return;
		}
	}
	
	/*�ʱⰪ ���� */
	nads.dsdm.app.board.SLBoardDelegate objForumBoard = new nads.dsdm.app.board.SLBoardDelegate();
	Hashtable objHshBbrdInfo = null;			//�Խ��� 
	Hashtable objHshMainInfo = null;			//�Խ��� 
	String strGoToPage = URLEncoder.encode("/forum/board/ForumBoardList.jsp", "UTF-8");	//��ũ�� ������ ���� 
	
	try{
		//1. �Խ��� ������ �����´�.
		objHshBbrdInfo = objForumBoard.selectBbrdInfo(strBbrdID);
		//2004.08.11 ��۽� ������ �����ش�.
		if(!strDataID.equals("")){
			Hashtable objHshDataInfo = objForumBoard.selectBbrdBNInfo(strBbrdID, strDataID, "0");
			objHshMainInfo = (Hashtable)objHshDataInfo.get("MAIN_INFO");
		}
		
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
	String strBbrdNm = (String)objHshBbrdInfo.get("BBRD_NM");
	int intBbrdLength = strBbrdNm.length() * 2 - 1;
	int intBbrdLength2 = 0;
	if (intBbrdLength < 40) {
		intBbrdLength2 = 40 - intBbrdLength;
	}

 	//2004.08.11 ��۽� ������ �����ش�.
	String strCont = "";
	String strTitle = "";

	if(!strDataID.equals("")) {
		strTitle ="Re:"+(String)objHshMainInfo.get("TITLE"); 		
		strCont = "==����==<br>"+(String)objHshMainInfo.get("CONT");
		if (strCont.equals("") || strCont.equals(" " ) || strCont == null){

			strCont = "&nbsp;";

		}
		
		
		if(strEditorExt.equals("N")) {
			strCont = BoardComm.replaceTag2Text(strCont); 
		}
	}
%>
<%@ include file="/board/common/ForumBoardNavigator.jsp" %>

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

		myeditor.width = 520;
		myeditor.height = 290;
		//myeditor.fontsize = '10pt';
		//myeditor.lineheight = '14pt';
		var varCont = document.frmWrite.cont.value;
		myeditor.init(varCont);
		
	}

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
        
		var ext = "N";
		//for (i = 0; i < frm.editorflag.length; i++) {
		//    if (frm.editorflag[i].checked == true) {
		//        ext = frm.editorflag[i].value;
		//        break;
		//   }
		//}

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
<%@ include file="/common/TopMenu.jsp" %>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr align="left" valign="top">
    <td width="186" background="/image/common/bg_leftMenu.gif">
	<%@ include file="/common/LeftMenu.jsp" %></td>
    <td width="100%">
      <!-- �����Խ��� ��� ���̺� ���� -----------------------------> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
         <tr height="24" valign="top"> 
          <td height="24" colspan="2" align="left"><table width="789" height="24" border="0" cellpadding="0" cellspacing="0" bgcolor="E9E2F3">
              <tr>
                <td height="24"></td>
              </tr>
            </table></td>
        </tr>
        <tr valign="top"> 
          <td width="30" align="left"><img src="/image/common/bg_leftBody.gif" width="30" height="1"></td>
          <td align="left">
           <table width="760" border="0" cellspacing="0" cellpadding="0">
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
                <td width="760" height="23" align="left" valign="top"></td>
              </tr>
              <tr> 
                <td align="left" valign="top"><table width="100%" height="23" border="0" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="<%=intBbrdLength%>%" background="/image/forum/bg_forum_tit.gif"><span class="title"><%=strBbrdNm%></span></td>
                      <td width="<%=intBbrdLength2%>%" align="left" background="/image/common/bg_titLine.gif">&nbsp;</td>
                      <td width="60%" align="right" background="/image/common/bg_titLine.gif" class="text_s"><img src="/image/common/icon_navi.gif" width="3" height="5" align="absmiddle"> 
                        Home&gt;����&gt;�����Խ���&gt;<strong><%=strBbrdKindNm%></strong></td>
                    </tr>
                  </table></td>
              </tr>
              <tr> 
                <td height="30" align="left" class="text_s"><%=objHshBbrdInfo.get("DSC")%></td>
              </tr>
              <tr> 
                <td height="15" align="left"></td>
              </tr>
              <tr> 
                <td align="left" valign="top"><table width="680" border="0" cellspacing="0" cellpadding="0">
                    <tr class="td_forum"> 
                      <td width="130" height="2"></td>
                      <td width="550" height="2"></td>
                    </tr>
                    <tr> 
                      <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> ����</td>
                      <td height="25" class="td_lmagin"><input name="title" type="text" class="textfield" style="WIDTH: 300px" value="<%=strTitle%>"></td>
                    </tr>
                    <tr class="tbl-line"> 
                      <td height="1"></td>
                      <td height="1"></td>
                    </tr>
                    <tr> 
                      <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> �����</td>
                      <td height="25" class="td_lmagin"><%=strLoginNm%></td>
                    </tr>
                    <tr class="tbl-line"> 
                      <td height="1"></td>
                      <td height="1"></td>
                    </tr>
					<!--
                    <tr> 
                      <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> ���� ����</td>
                      <td height="25" class="td_lmagin">
                      	<input type="radio" name="editorflag" value="N" onClick="selEditor('newlayer', 'newlayer2', frmWrite.txtCont);" <% if(strEditorExt.equals("N")) out.println("checked"); %>>�ؽ�Ʈ
                      	<input type="radio" name="editorflag" value="Y" onClick="selEditor('newlayer2', 'newlayer', frmWrite.txtCont);" <% if(strEditorExt.equals("Y")) out.println("checked"); %>>HTML ������
                      </td>
                    </tr>
                    <tr class="tbl-line"> 
                      <td height="1"></td>
                      <td height="1"></td>
                    </tr>
					-->
                    <tr> 
                      <td height="45" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> ����</td>
                      <td height="310" valign="top" class="td_box">
						<span ID="newlayer" style="position:absolute;"><textarea name="txtCont" wrap="hard" class="textfield" style="WIDTH: 100% ; height: 290"><%=strCont%></textarea></span>
                      	<span ID="newlayer2"><script>setCont();</script></span>
                      </td>
                    </tr>
                    <% if (intBbrdFileCnt != 0) {	//����÷�ΰ� 0���� �ƴ϶��....%>
                    <tr class="tbl-line"> 
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
                    <tr height="1" class="tbl-line"> 
                      <td height="2"></td>
                      <td height="2"></td>
                    </tr>
                  </table></td>
              </tr>
              <tr> 
                <td align="left" valign="top"><table width="680" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td height="40" align="left">
                      	<input type="image" src="/image/button/bt_save.gif" width="43" height="20"> 
                        <img src="/image/button/bt_cancel.gif" width="43" height="20" style="cursor:hand;" onClick="reset();">
                        <a href="ForumBoardList.jsp?strCurrentPage=<%=strCurrentPage%>&bbrdid=<%=strBbrdID%>"><img src="/image/button/bt_list.gif" width="43" height="20" border="0"></a>
                        <div align="right"></div></td>
                    </tr>
                  </table>
                </td>
              </tr>
              <tr> 
                <td height="15" align="left">&nbsp;</td>
              </tr>
            </form>
            </table>
            <!-- �����Խ��� ��� ���̺� �� ----------------------------->
           </td>
        </tr>
      </table>
      </td>
  </tr>
</table>
<script language="javascript">
	
	//������ �ʱ�ȭ 
	selEditor('newlayer', 'newlayer2');
	frmWrite.txtCont.value = stripHTMLtag(frmWrite.txtCont.value) ;
</script>
<%@ include file="/common/Bottom.jsp" %>
</body>
</html>
