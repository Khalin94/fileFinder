<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.bf.config.*"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.MemRequestInfoDelegate" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%
 UserInfoDelegate objUserInfo =null;
 CDInfoDelegate objCdinfo =null;
%>
<%@ include file="../../../common/RUserCodeInfoInc.jsp" %>

<%
 /*************************************************************************************************/
 /** 					�Ķ���� üũ Part 														  */
 /*************************************************************************************************/
  /** �䱸���� */
  String strReqInfoID=(String)request.getParameter("ReqInfoID");
  String strFilePath="";
  /**���޵� �ĸ����� üũ */
  if(!StringUtil.isAssigned(strReqInfoID)){
  	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	objMsgBean.setStrCode("DSPARAM-0002");
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%
  	return;
  }//endif
%>
<% 
 /*************************************************************************************************/
 /** 					������ ȣ�� Part 														  */
 /*************************************************************************************************/

 /*** Delegate �� ������ Container��ü ���� */
 MemRequestInfoDelegate  objReqInfo=null;	/** �䱸���� Delegate */
 ResultSetSingleHelper objInfoRsSH=null;		/**�䱸 ���� �󼼺��� */
 try{
   /**�䱸 ���� �븮�� New */    
    objReqInfo=new MemRequestInfoDelegate();
   /**�䱸���� �̿� ���� üũ */
   boolean blnHashAuth=objReqInfo.checkReqInfoAuth(strReqInfoID,objUserInfo.getOrganID()).booleanValue();
   if(!blnHashAuth){
      objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	  objMsgBean.setStrCode("DSAUTH-0003");
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%
      return;
  }else{
    objInfoRsSH=new ResultSetSingleHelper(objReqInfo.getRecord(strReqInfoID));
  }/**���� endif*/
 }catch(AppException objAppEx){
 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  	objMsgBean.setStrCode(objAppEx.getStrErrCode());
  	objMsgBean.setStrMsg(objAppEx.getMessage());
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%  	
  	return;
 }
%>

<%
 /*************************************************************************************************/
 /** 					������ �� �Ҵ�  Part 														  */
 /*************************************************************************************************/
 strFilePath=(String)objInfoRsSH.getObject("ANS_ESTYLE_FILE_PATH");
 if(!StringUtil.isAssigned(strFilePath)){
   strFilePath=nads.lib.reqsubmit.EnvConstants.getConstFilePath();
 }
 //strFilePath="http://" + request.getRemoteAddr() + "/reqsubmit/common/AttachStyleFileDownload.jsp?path=" + strFilePath;
 
 String strServerName=(String)request.getServerName();
 String strServerPort=String.valueOf(request.getServerPort());
 String strLocalFileRoot="C:/";
 String strLocalFileName="LocalFile.hwp";
%>
<!DOCTYPE HTML PUBLIC "-//w3c//dtd html 4.0 transitional//en">
<HTML>
<HEAD>
<META content="text/html; charset=ks_c_5601-1987" http-equiv=Content-Type>
<TITLE>���������� �ۼ�</TITLE>
<SCRIPT language="JavaScript">
<!--
var MinVersion = 0x05050118;
var filePath;
var pHwpCtrl;
var blnUpload;
    blnUpload=false;
function OnStart(){

	if(document.ezFileUploadControl.object == null) {
		alert("���� ���� Control�� ��ġ���� �ʾҽ��ϴ�.");
		return;
	}
  	document.ezFileUploadControl.CreateHttpForm("<%=strServerName%>", <%=strServerPort%>);
	document.ezFileUploadControl.SetField("Cookie:", document.cookie);

  	document.ezFileUploadControl.SetField("ReqInfoID", "<%=strReqInfoID%>");
  	document.ezFileUploadControl.SetField("path", "<%=strFilePath%>");

	var ret = document.ezFileUploadControl.DownloadTempFile("/reqsubmit/common/AttachStyleFileDownload.jsp", "localform.hwp");

	pHwpCtrl = HwpControl.HwpCtrl;
	
	InitHwpCtrlFrame();
		
	if(ret == 0) {
		alert("���� Download error");
	}
	else {
		var localFile = document.ezFileUploadControl.GetDownloadedTempFile();

		if(!document.HwpCtrl.Open(localFile)){
			alert("���� Open() ����");
		}else{
			blnUpload=true;
		}
	}
}
function _VerifyVersion()
{
	//��ġ Ȯ��
	if(pHwpCtrl.getAttribute("Version") == null)
	{
		alert("�ѱ� 2002 ��Ʈ���� ��ġ���� �ʾҽ��ϴ�.");
		return false;
	}
	//���� Ȯ��
	CurVersion = pHwpCtrl.Version;
	if(CurVersion < MinVersion)
	{
		alert("HwpCtrl�� ������ ���Ƽ� ���������� �������� ���� �� �ֽ��ϴ�.\n"+
			"�ֽ� �������� ������Ʈ�ϱ⸦ �����մϴ�.\n\n"+
			"���� ����:" + CurVersion + "\n"+
			"���� ����:" + MinVersion + " �̻�"			
			);
	}
	return true;
}
function _GetBasePath()
{
	//BasePath�� ���Ѵ�.
	var loc = unescape(document.location.href);
	var lowercase = loc.toLowerCase(loc);
	if (lowercase.indexOf("http://") == 0) // Internet
	{
		return loc.substr(0,loc.lastIndexOf("/") + 1);//BasePath ����
	}
	else // local
	{
		var path;
		path = loc.replace(/.{2,}:\/{2,}/, ""); // file:/// �� ����������.
		return path.substr(0,path.lastIndexOf("/") + 1);//BasePath ����
	}
}

function InitHwpCtrlFrame()
{
	//pHwpCtrl.SetToolBar(-1, "#1;1:TOOLBAR_MENU");
	// �� �տ� FileNew, FileOpen, FileSave, FileSaveAs �� �ֱ� ���� TOOLBAR_STANDARD�� ������� �ʴ´�.
	pHwpCtrl.SetToolBar(1, "#2;1:�⺻ ���� ����, FileNew, FileOpen, FileSave, FileSaveAs, Separator, FilePreview, Print, Separator, Undo, Redo, Separator, Cut, Copy, Paste,"
	+"Separator, ParaNumberBullet, MultiColumn, SpellingCheck, HwpDic, Separator, PictureInsertDialog, MacroPlay1");
	pHwpCtrl.SetToolBar(-1, "#3;1:TOOLBAR_FORMAT");
	pHwpCtrl.SetToolBar(-1, "#4;1:TOOLBAR_DRAW");
	pHwpCtrl.SetToolBar(-1, "#5;2:TOOLBAR_TABLE");
	pHwpCtrl.SetToolBar(-1, "#6;2:TOOLBAR_NUMBERBULLET");
	pHwpCtrl.SetToolBar(-1, "#7;2:TOOLBAR_HEADER_FOOTER");
	pHwpCtrl.SetToolBar(-1, "#8;2:TOOLBAR_MASTERPAGE");
	pHwpCtrl.SetToolBar(-1, "#9;2:TOOLBAR_NOTE");
	pHwpCtrl.SetToolBar(-1, "#10;2:TOOLBAR_COMMENT");
	pHwpCtrl.ShowToolBar(1);
	pHwpCtrl.ShowStatusBar(1);
	//pHwpCtrl.AutoShowHideToolBar(true);

	// ������, �ҷ�����, ����
	pHwpCtrl.ReplaceAction("FileNew", "HwpCtrlFileNew");
	pHwpCtrl.ReplaceAction("FileOpen", "HwpCtrlFileOpen");
	pHwpCtrl.ReplaceAction("FileSave", "HwpCtrlFileSaveAutoBlock");
	pHwpCtrl.ReplaceAction("FileSaveAs", "HwpCtrlFileSaveAsAutoBlock");

	// Modeless ��ȭ���� -> Modal ��ȭ����.
	pHwpCtrl.ReplaceAction("FindDlg", "HwpCtrlFindDlg");
	pHwpCtrl.ReplaceAction("ReplaceDlg", "HwpCtrlReplaceDlg");

	// ���� �Է��� 97������� �Է��ϵ��� �Ѵ�.
	pHwpCtrl.ReplaceAction("EquationCreate", "HwpCtrlEquationCreate97");
	pHwpCtrl.ReplaceAction("InsertEquation", "HwpCtrlEquationCreate97");
	
	var lockCommandList = new Array(
		// �Ʒ� Action�� OLE���� ������ ���� ���� ���´�.
		"OleCreateNew",
		"InsertTextArt",
		"InsertChart",
		"InsertVoice",

		// �Ʒ� Action�� ��â�̳�, ������ ����ϹǷ� ���� ���´�.
		"LabelTemplate", // �� ���� �����
		"ManuScriptTemplate", // ������ ����
		"IndexMark", // ã�ƺ��� ǥ��
		"MakeIndex", // ã�ƺ��� �����
		"MakeContents" // ���ʸ����
		);
	for (i = 0; i < lockCommandList.length; i++)
		pHwpCtrl.LockCommand(lockCommandList[i], true);
}
/**���� ������ */
function save_and_submit(){	
   if(blnUpload==false) return;		
	document.HwpCtrl.Save();
	document.ezFileUploadControl.CreateHttpForm("<%=strServerName%>", <%=strServerPort%>);
	document.ezFileUploadControl.SetField("Cookie:", document.cookie);
	document.ezFileUploadControl.SetField("ReqInfoID", "<%=strReqInfoID%>");
	
	//document.ezFileUploadControl.SetFileField("AnsEstyleFilePath", filePath);
	var localFile = document.ezFileUploadControl.GetDownloadedTempFile();
	document.ezFileUploadControl.SetFileField("AnsEstyleFilePath",localFile);
	
	ret = document.ezFileUploadControl.DoSubmit("/reqsubmit/common/AttachStyleFileUpload.jsp");
	
	alert("�ۼ��Ͻ� ��������� ����Ǿ����ϴ�");
	
	top.opener.location.reload();
}	
/** ������ ���� Ȯ�� */
function closing(){
  if(blnUpload==false) return;
  if(confirm('������������ �����Ͻðڽ��ϱ�?')){
	document.HwpCtrl.Save();
	document.ezFileUploadControl.CreateHttpForm("<%=strServerName%>", <%=strServerPort%>);
	document.ezFileUploadControl.SetField("Cookie:", document.cookie);
	document.ezFileUploadControl.SetField("ReqInfoID", "<%=strReqInfoID%>");
	var localFile = document.ezFileUploadControl.GetDownloadedTempFile();
	document.ezFileUploadControl.SetFileField("AnsEstyleFilePath",localFile);
	ret = document.ezFileUploadControl.DoSubmit("/reqsubmit/common/AttachStyleFileUpload.jsp");	
	top.opener.location.reload();
	document.ezFileUploadControl.RemoveTempFile();
  }else{
	document.ezFileUploadControl.RemoveTempFile();
     return;
  }
}
//-->
</SCRIPT>
</HEAD>
<BODY leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onload = "OnStart()" bgcolor="D4D0C8" onBeforeUnload="closing();">
<form name = "HwpControl" >
<script language="javascript" src="/js/ezFileUploadControl.js"></script>
</form>
</BODY>
</HTML>