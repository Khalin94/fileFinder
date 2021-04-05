<%@ page language="java"  contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import = "java.net.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="nads.lib.message.MessageBean" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%@ include file="/board/common/GetBoardProperty.jsp" %>
<%
	/*GET �Ķ����*/
	String strCurrentPage =  nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("strCurrentPage"))); //���� ������
	String strBbrdID =  nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("bbrdid")));			 //�Խ��� ���̵�
	String strDataID = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("dataid")));			 //�Խù� ���̵�
	String strWriteID = (String)session.getAttribute("USER_ID")==null?"BBRDUSER":(String)session.getAttribute("USER_ID");//�α��� ID

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

	/*�ʱⰪ ���� */
	nads.dsdm.app.board.SLBoardDelegate objBoard = new nads.dsdm.app.board.SLBoardDelegate();
	Hashtable objHshBbrdInfo = null;		//�Խ���
	Hashtable objHshDataInfo = null;		//�Խù�
	ArrayList objAryFileList = null;		//��������
	int intFileCnt = 0;						//������ ��ϵ� ���� ����
	String strGoToPage = URLEncoder.encode("/guide/GuideBoardList.jsp", "UTF-8");	//��ũ�� ������ ����

	try {
		//1. �Խ��� ������ �����´�.
		objHshBbrdInfo = objBoard.selectBbrdInfo(strBbrdID);

		//2. �Խù� ������ �����´�.
		objHshDataInfo = objBoard.selectBbrdDataInfo(strDataID);

		//3. ��ϵ� ������ �ִٸ� �������� ����Ʈ�� �����´�.
		if (((String)objHshDataInfo.get("APD_FILE_EXT")).equals("Y")) {
			objAryFileList = objBoard.selectFileList(strDataID);
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

	//�Խù� ����
	String strTitle = (String)objHshDataInfo.get("TITLE");
	if (strTitle.equals("") || strTitle.equals(" " ) || strTitle == null){
		strTitle = "&nbsp;";
	}
	String strWriterNm = (String)objHshDataInfo.get("WRITER_NM");
	if (strWriterNm == null || strWriterNm.equals("") || strWriterNm.equals(" " )){
		strWriterNm = "&nbsp;";
	}
	String strCont = (String)objHshDataInfo.get("CONT");
	if ( strCont == null || strCont.equals("") || strCont.equals(" " )){
		strCont = "&nbsp;";
	}

	//strCont = strCont.replaceAll("<","&lt;");
	//strCont = strCont.replaceAll(">","&gt;");
	//strTitle = strTitle.replaceAll("<","&lt;");
	//strTitle = strTitle.replaceAll(">","&gt;");

	String strWriteTS = (String)objHshDataInfo.get("WRITE_TS");
	strWriteTS = strWriteTS.substring(0, 4) + "-" + strWriteTS.substring(4, 6) + "-"
						+ strWriteTS.substring(6, 8);
	String strEditorExt = (String)objHshDataInfo.get("HTML_USE_FLAG");
	session.setAttribute("WRITER_ID",strWriteID);
	session.setAttribute("BBRD_ID",strBbrdID);
	session.setAttribute("DATA_ID",strDataID);
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link href="../css/System.css" rel="stylesheet" type="text/css">
<script language="javascript" src="/js/forum.js"></script>
<script language="javascript" src="/js/editor/htmleditor.js"></script>
<script type="text/javascript" src="/js/core.js"></script><!-- �ܹ��� -->
<script type="text/javascript" src="/js/sha256.js"></script><!-- �ܹ��� -->
<script language="javascript">

	//������ �ʱ�ȭ
	var myeditor = new htmleditor("myeditor");

	function setCont() {

		myeditor.width = 200;
		myeditor.height = 200;
		//myeditor.fontsize = '10pt';
		//myeditor.lineheight = '14pt';
		var varCont = document.frmUpdate.cont.value;
		myeditor.init(varCont);

	}

	function isSave() {

		var frm = document.frmUpdate;

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
		var ext = "";
		for (i = 0; i < frm.editorflag.length; i++) {
		    if (frm.editorflag[i].checked == true) {
		        ext = frm.editorflag[i].value;
		        break;
		    }
		}

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

		//��й�ȣ
		 if (frm.tmp_datapwd.value == "" || frm.tmp_datapwd.value == null){
			alert("��й�ȣ�� �Է��� �ּ���.");
			frm.tmp_datapwd.focus();
			return false;
		}

		if (fnSpaceChk(frm.tmp_datapwd.value, "��й�ȣ�� �ùٸ��� �Է��ϼ���.") == false ) 	return false;

		//�ѱ�, ���� �����Ͽ� ���ڿ� ���̸� üũ�Ѵ�.
        if(checkStrLen(frm.tmp_datapwd, 8, "��й�ȣ") == false){
            return false;
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

		//÷�������� Ÿ���� üũ�Ѵ�.
		for (var i = 0; i < max_file; i++) {
			var file_object = "document.frmUpdate.upfile" + i + ".value";
			if (eval(file_object) != "") {
				 if(fnBoardLimitAttach2(eval(file_object))== false){
		            return false;
		        }
			}
		}

		frm.editorext.value = ext;
		frm.fileext.value = fileext;
		//�ܹ��������� ���� 20180824
	    var temp = CryptoJS.SHA256(frm.tmp_datapwd.value).toString();
        frm.datapwd.value = temp.toUpperCase();
        frm.tmp_datapwd.value = "";

	}

</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="502" height="216" border="0" cellpadding="0" cellspacing="0">
  <tr height="15" align="left" valign="top">
    <td><img src="../image/guide/blank.gif" width="24" height="2"></td>
    <td width="478" height="141">
	 <!-- ���ǰԽ��� ���� ���̺� ���� ----------------------------->
	  <table width="100%" height="141" border="0" cellpadding="0" cellspacing="0">
	  <form name="frmUpdate" method="post" action="BoardProc.jsp?bbrdid=<%=strBbrdID%>&bbrdkind=<%=strBbrdKind%>" onSubmit="return isSave();" encType="multipart/form-data">
	    <textarea name="cont" wrap="hard" style="display:none;"><%=strCont%></textarea>
		<input type="hidden" name="cmd" value="OPENUPDATE">
		<input type="hidden" name="strGoToPage" value="<%=strGoToPage%>">
		<input type="hidden" name="strCurrentPage" value="<%=strCurrentPage%>">
		<input type="hidden" name="dataid" value="<%=strDataID%>">
		<input type="hidden" name="editorext" value="">
		<input type="hidden" name="fileext" value="">
		<input type="hidden" name="editorflag" value="N">
		<input type="hidden" name="datapwd" value="">
        <tr>
          <td height="141" valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr class="td_board">
                <td width="100" height="2"></td>
                <td width="378" height="2"></td>
              </tr>
              <tr>
                <td height="25" class="td_gray1"><img src="../image/common/icon_nemo_gray.gif" width="3" height="6"> ����</td>
                <td height="25" class="td_lmagin"><input name="title" type="text" class="textfield" style="WIDTH: 300px" value="<%=strTitle%>"></td>
              </tr>
              <tr class="tbl-line">
                <td height="1"></td>
                <td height="1"></td>
              </tr>
              <tr>
                <td height="25" class="td_gray1"><img src="../image/common/icon_nemo_gray.gif" width="3" height="6"> �����</td>
                <td height="25" class="td_lmagin"><input name="writernm" type="text" class="textfield" style="WIDTH: 150px" value="<%=strWriterNm%>" readonly style="border:0px;"></td>
              </tr>
              <tr class="tbl-line">
                <td height="1"></td>
                <td height="1"></td>
              </tr>
			  <tr>
                <td height="25" class="td_gray1"><img src="../image/common/icon_nemo_gray.gif" width="3" height="6"> �����</td>
                <td height="25" class="td_lmagin"><%=strWriteTS%></td>
              </tr>
              <tr class="tbl-line">
                <td height="1"></td>
                <td height="1"></td>
              </tr>
              <tr>
                <td height="45" class="td_gray1"><img src="../image/common/icon_nemo_gray.gif" width="3" height="6">
                  ����</td>
                <td height="45" valign="top" class="td_box">
				  <span ID="newlayer" style="position:absolute;"><textarea name="txtCont" wrap="hard" class="textfield" style="WIDTH: 100%; height: 200"><%=strCont%></textarea></span>
               	  <span ID="newlayer2"><script>setCont();</script></span>
				</td>
              </tr>
			  <% if (intBbrdFileCnt != 0) {	//����÷�ΰ� 0���� �ƴ϶��....%>
			  <tr class="tbl-line">
                <td height="1"></td>
                <td height="1"></td>
              </tr>
			  <tr>
                <td height="25" class="td_gray1"><img src="../image/common/icon_nemo_gray.gif" width="3" height="6"> ����</td>
                <td height="25" class="td_lmagin">
				<%
                for(int i = 0; i < intBbrdFileCnt; i++) {

                	out.println("<input type='text' name='showfile" + i + "'  class='textfield' style='WIDTH: 230px'  value='' readonly>");
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
			  <tr class="tbl-line">
                <td height="1"></td>
                <td height="1"></td>
              </tr>
			  <tr>
                <td height="25" class="td_gray1"><img src="../image/common/icon_nemo_gray.gif" width="3" height="6"> ��й�ȣ</td>
                <td height="25" class="td_lmagin"><input name="tmp_datapwd" type="password" class="textfield" style="WIDTH: 150px" value=""></td>
              </tr>
              <tr height="1" class="tbl-line">
                <td height="2"></td>
                <td height="2"></td>
              </tr>
            </table></td>
        </tr>
		<tr align="left" valign="top">
		  <td height="40" align="left" valign="middle">
		    <input type="image" src="../image/button/bt_save.gif" width="43" height="20">
		    <img src="../image/button/bt_cancel.gif" width="43" height="20" style="cursor:hand;" onClick="reset();">
            <a href="GuideBoardList.jsp?strCurrentPage=<%=strCurrentPage%>&bbrdid=<%=strBbrdID%>"><img src="../image/button/bt_list.gif" width="43" height="20" border="0"></a>
			</td>
		  </tr>
		</form>
      </table>
	  <!-- ���ǰԽ��� ���� ���̺� ���� ----------------------------->
	</td>
  </tr>
  <tr align="left" valign="top">
    <td height="35">&nbsp;</td>
    <td height="35">&nbsp;</td>
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
</body>
</html>
