<%@ page language="java"  contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>	
<%@ page import="java.net.*"%>	
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="nads.lib.message.MessageBean" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%@ include file="/common/CheckSession.jsp" %>
<%@ include file="/board/common/GetBoardProperty.jsp" %>
<%
	String strLoginID = (String)session.getAttribute("USER_ID");
	/*GET �Ķ����*/
	String strCurrentPage =  nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("strCurrentPage"))); //���� ������
	String strBbrdID =  nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("bbrdid")));			 //�Խ��� ���̵�
	String strDataID = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("dataid")));			 //�Խù� ���̵�
	
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
	
	if(strDataID == null || strDataID.equals("") || strDataID.equals(" ")){
		
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		objMsgBean.setStrCode("DSPARAM-0000");
		objMsgBean.setStrMsg("�Խù� ������ �˼� �����ϴ�.");
		
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
	Hashtable objHshBbrdInfo = null;		//�Խ��� 
	Hashtable objHshDataInfo = null;		//�Խù� 
	ArrayList objAryFileList = null;				//�������� 
	int intFileCnt = 0;									//������ ��ϵ� ���� ���� 
	String strGoToPage = URLEncoder.encode("/forum/board/ForumBoardList.jsp", "UTF-8");	//��ũ�� ������ ���� 
	
	try {
		//1. �Խ��� ������ �����´�.
		objHshBbrdInfo = objForumBoard.selectBbrdInfo(strBbrdID);
		
		//2. �Խù� ������ �����´�.
		objHshDataInfo = objForumBoard.selectBbrdDataInfo(strDataID);
		
		//3. ��ϵ� ������ �ִٸ� �������� ����Ʈ�� �����´�.
		if (((String)objHshDataInfo.get("APD_FILE_EXT")).equals("Y")) {
			objAryFileList = objForumBoard.selectFileList(strDataID);
			intFileCnt = objAryFileList.size();
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
	if(intBbrdLength < 40 ){
		intBbrdLength2 = 40 - intBbrdLength;
	}
	
	//�Խù� ���� 
	String strTitle = (String)objHshDataInfo.get("TITLE");

	String strWriteID = StringUtil.getNVLNULL((String)objHshDataInfo.get("WRITER_ID"));

	session.setAttribute("WRITER_ID",strWriteID);
	
	if (strTitle.equals("") || strTitle.equals(" " ) || strTitle == null){
		strTitle = "&nbsp;";
	}
	String strUserNm = (String)objHshDataInfo.get("USER_NM");
	if (strUserNm.equals("") || strUserNm.equals(" " ) || strUserNm == null){
		strUserNm = "&nbsp;";
	}
	String strCont = (String)objHshDataInfo.get("CONT");
	if (strCont.equals("") || strCont.equals(" " ) || strCont == null){
		strCont = "&nbsp;";
	}
	String strWriteTS = (String)objHshDataInfo.get("WRITE_TS");
	strWriteTS = strWriteTS.substring(0, 4) + "-" + strWriteTS.substring(4, 6) + "-" 
						+ strWriteTS.substring(6, 8);
	String strEditorExt = (String)objHshDataInfo.get("HTML_USE_FLAG");
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
		var varCont = document.frmUpdate.cont.value;
		myeditor.init(varCont);
		
	}

	function isSave() {
		
		var frm = document.frmUpdate;
		
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

		//���� ��ü ���� ���ϱ�
		var max_file = <%=intBbrdFileCnt%>;		//��� ������ ���� ���� 
		var del_file = 0;											//���� ��û�� ���� ���� 
		var new_file = 0;										//���� �߰��� ���� ���� 
		var old_file = "<%=intFileCnt%>";				//���� ��ϵ� ���� ���� 
		var total_file = 0;										//��� �� ������ ���� ����
		var fileext = ""											//���� ���� ���� 

		//���� ��û�� ������ ������ ���Ѵ�.
		if (frm.delfile != null){
			//length�� 1�ϰ�� undefined�� ���� üũ���ش�.
			if(frm.delfile.length == undefined){
				if(frm.delfile.checked == true){
					del_file = 1;
				}
			} else {
				for(var i = 0; i < frm.delfile.length; i++){
					if(frm.delfile[i].checked == true){		
						del_file = del_file + 1;
					}
				}
			}
		}		
		
		//���� �߰��Ǵ� ���� ������ ���Ѵ�.
		for (var i = 0; i < max_file; i++) {
			var file_object = "document.frmUpdate.upfile" + i + ".value";
			if (eval(file_object) != "") { new_file = new_file + 1; }
		}

		total_file = (old_file - del_file) + new_file;
		//alert("�����Ѱ��� : " + total_file);
		
		//���� ���������� �����Ѵ�.
		if(total_file == 0){ 
			fileext = "N"; 
		} else { 
			fileext = "Y"; 
		}
	
		if(total_file > max_file){
			alert("���� ÷�δ� " + max_file + "������ �Դϴ�.");
			return false;
		}
		
		//������ ���� ����
		var ext = "N";
		//for (i = 0; i < frm.editorflag.length; i++) {
		//    if (frm.editorflag[i].checked == true) {
		//        ext = frm.editorflag[i].value;
		//        break;
		//    }
		//}

		if(ext == "Y"){														//HTML�����͸� ����� ��� 
		
			var varCont = myeditor.get_content("NO");
			frm.cont.value = varCont;
		
		} else {																//�ؽ�Ʈ�� ����� ��� 
			
			if (frm.txtCont.value == "" || frm.txtCont.value == null){
				alert("���� ������ �Է��� �ּ���.");
				frm.txtCont.focus();
				return false;
			} 
			
			if (fnSpaceChk(frm.txtCont.value, "������ �ùٸ��� �Է��ϼ���.") == false ) 	return false;
		}
		
		//÷�����ϸ� ���̸� üũ�Ѵ�.
		for(var i = 0; i < max_file; i++) {
			var file_object = "document.frmUpdate.upfile" + i + ".value";
			if(eval(file_object) != ""){
				if(checkFileName(eval(file_object)) == false){
					return false;					
				}
			}
		}
		
		//÷�������� Ÿ���� üũ�Ѵ�.		
		for (var i = 0; i < max_file; i++) {
			var file_object = "document.frmUpdate.upfile" + i + ".value";
			if (eval(file_object) != "") { 		
				 if(fnBoardLimitAttach(eval(file_object))== false){
		            return false;
		        }
			}
		}
		
		frm.editorext.value = ext;
		frm.fileext.value = fileext;
		
	}
	
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<%@ include file="/common/TopMenu.jsp" %>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr align="left" valign="top">
    <td width="186" background="/image/common/bg_leftMenu.gif">
	<%@ include file="/common/LeftMenu.jsp" %></td>
    <td width="100%"><table width="100%" border="0" cellspacing="0" cellpadding="0">
         <tr height="24" valign="top"> 
          <td height="24" colspan="2" align="left"><table width="789" height="24" border="0" cellpadding="0" cellspacing="0" bgcolor="E9E2F3">
              <tr>
                <td height="24"></td>
              </tr>
            </table></td>
        </tr>
        <tr valign="top"> 
          <td width="30" align="left"><img src="/image/common/bg_leftBody.gif" width="30" height="1"></td>
          <td align="left"><table width="759" border="0" cellspacing="0" cellpadding="0">
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
                <td align="left" valign="top">
                <!-- �����Խ��� ���� ���̺� ���� ------------------------->
                <table width="680" border="0" cellspacing="0" cellpadding="0">
                <form name="frmUpdate" method="post" action="/board/common/BoardProc.jsp?bbrdid=<%=strBbrdID%>&bbrdkind=<%=strBbrdKind%>" onSubmit="return isSave();" encType="multipart/form-data">
                <textarea name="cont" wrap="hard" style="display:none;"><%=strCont%></textarea>
				<input type="hidden" name="cmd" value="UPDATE">
				<input type="hidden" name="strGoToPage" value="<%=strGoToPage%>">
				<input type="hidden" name="strCurrentPage" value="<%=strCurrentPage%>">
				<input type="hidden" name="dataid" value="<%=strDataID%>">
				<input type="hidden" name="editorext" value="N">
				<input type="hidden" name="fileext" value="">
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
                      <td height="25" class="td_lmagin"><%=strUserNm%></td>
                    </tr>
                    <tr class="tbl-line"> 
                      <td height="1"></td>
                      <td height="1"></td>
                    </tr>
                    <tr> 
                      <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> �����</td>
                      <td height="25" class="td_lmagin"><%=strWriteTS%></td>
                    </tr>
                    <tr class="tbl-line"> 
                      <td height="1"></td>
                      <td height="1"></td>
                    </tr>
					<!--
                    <tr> 
                      <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> ���� ����</td>
                      <td height="25" class="td_lmagin">
					  	<input type="radio" name="editorflag" value="N" onClick="selEditor('newlayer', 'newlayer2', frmUpdate.txtCont);" <% if(strEditorExt.equals("N")) out.println("checked"); %>>�ؽ�Ʈ
                      	<input type="radio" name="editorflag" value="Y" onClick="selEditor('newlayer2', 'newlayer', frmUpdate.txtCont);" <% if(strEditorExt.equals("Y")) out.println("checked"); %>>HTML ������
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
					  <%
					  	 for(int i = 0; i < intBbrdFileCnt; i++) {
							
							out.println("<input type='text' name='showfile" + i + "'  class='textfield' style='WIDTH: 300px'  value='' readonly>");
							out.println("<input type='file' name='upfile" + i + "' class='textfield' style='WIDTH: 0px' onChange='javascript:searchFile(this.form, this);'><br>");
							
						} //end for
						
						if (objAryFileList != null) {
		                	if (objAryFileList.size() != 0){ 
						    	for (int i = 0; i < objAryFileList.size(); i++) {
						    		Hashtable objHshFile = (Hashtable)objAryFileList.get(i);
					
									String strFileName = (String)objHshFile.get("FILE_NAME");
									out.println("<input type='checkbox' name='delfile' value='"+ (String)objHshFile.get("FILE_ID") + "'>");
									out.println(strFileName + " ����<br>");
						    	}
							} 
						}
					  %>
					  </td>
                    </tr>
                    <% } %>
                    <tr height="1" class="tbl-line"> 
                      <td height="2"></td>
                      <td height="2"></td>
                    </tr>
                    <tr>
                      <td align="left" valign="top" colspan="2">
                      <table width="680" border="0" cellspacing="0" cellpadding="0">
	                    <tr> 
	                      <td height="40" align="left">
	                      	<input type="image" src="/image/button/bt_save.gif" width="43" height="20"> 
	                        <img src="/image/button/bt_cancel.gif" width="43" height="20" style="cursor:hand;" onClick="reset();"> 
	                        <a href="ForumBoardList.jsp?strCurrentPage=<%=strCurrentPage%>&bbrdid=<%=strBbrdID%>"><img src="/image/button/bt_list.gif" width="43" height="20" border="0"></a>
	                      </td>
	                    </tr>
	                  </table>
                      </td>
                    </tr>
                  </form>
                  </table>
                  <!-- �����Խ��� ���� ���̺� �� ------------------------->
                  </td>
              </tr>
              <tr> 
                <td height="15" align="left">&nbsp;</td>
              </tr>
            </table>
            </td>
        </tr>
      </table></td>
  </tr>
</table>

<%
	if(strEditorExt.equals("N")) {
		out.println("<script language='javascript'>");
		out.println("selEditor('newlayer', 'newlayer2');");
		out.println("</script>");
	} 
	else if (strEditorExt.equals("Y")) {
		out.println("<script language='javascript'>");
		out.println("selEditor('newlayer2', 'newlayer');");
		out.println("</script>");
	}
%>

<%@ include file="/common/Bottom.jsp" %>
</body>
</html>
