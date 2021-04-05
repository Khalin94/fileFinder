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
 /** 					파라미터 체크 Part 														  */
 /*************************************************************************************************/
  /** 요구정보 */
  String strReqInfoID=(String)request.getParameter("ReqInfoID");
  String strFilePath="";
  /**전달된 파리미터 체크 */
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
 /** 					데이터 호출 Part 														  */
 /*************************************************************************************************/

 /*** Delegate 과 데이터 Container객체 선언 */
 MemRequestInfoDelegate  objReqInfo=null;	/** 요구정보 Delegate */
 ResultSetSingleHelper objInfoRsSH=null;		/**요구 정보 상세보기 */
 try{
   /**요구 정보 대리자 New */    
    objReqInfo=new MemRequestInfoDelegate();
   /**요구정보 이용 권한 체크 */
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
  }/**권한 endif*/
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
 /** 					데이터 값 할당  Part 														  */
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
<TITLE>제출양식파일 작성</TITLE>
<SCRIPT language="JavaScript">
<!--
var MinVersion = 0x05050118;
var filePath;
var pHwpCtrl;
var blnUpload;
    blnUpload=false;
function OnStart(){

	if(document.ezFileUploadControl.object == null) {
		alert("파일 전송 Control이 설치되지 않았습니다.");
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
		alert("파일 Download error");
	}
	else {
		var localFile = document.ezFileUploadControl.GetDownloadedTempFile();

		if(!document.HwpCtrl.Open(localFile)){
			alert("문서 Open() 실패");
		}else{
			blnUpload=true;
		}
	}
}
function _VerifyVersion()
{
	//설치 확인
	if(pHwpCtrl.getAttribute("Version") == null)
	{
		alert("한글 2002 컨트롤이 설치되지 않았습니다.");
		return false;
	}
	//버젼 확인
	CurVersion = pHwpCtrl.Version;
	if(CurVersion < MinVersion)
	{
		alert("HwpCtrl의 버젼이 낮아서 정상적으로 동작하지 않을 수 있습니다.\n"+
			"최신 버젼으로 업데이트하기를 권장합니다.\n\n"+
			"현재 버젼:" + CurVersion + "\n"+
			"권장 버젼:" + MinVersion + " 이상"			
			);
	}
	return true;
}
function _GetBasePath()
{
	//BasePath를 구한다.
	var loc = unescape(document.location.href);
	var lowercase = loc.toLowerCase(loc);
	if (lowercase.indexOf("http://") == 0) // Internet
	{
		return loc.substr(0,loc.lastIndexOf("/") + 1);//BasePath 생성
	}
	else // local
	{
		var path;
		path = loc.replace(/.{2,}:\/{2,}/, ""); // file:/// 를 지워버린다.
		return path.substr(0,path.lastIndexOf("/") + 1);//BasePath 생성
	}
}

function InitHwpCtrlFrame()
{
	//pHwpCtrl.SetToolBar(-1, "#1;1:TOOLBAR_MENU");
	// 맨 앞에 FileNew, FileOpen, FileSave, FileSaveAs 를 넣기 위해 TOOLBAR_STANDARD를 사용하지 않는다.
	pHwpCtrl.SetToolBar(1, "#2;1:기본 도구 상자, FileNew, FileOpen, FileSave, FileSaveAs, Separator, FilePreview, Print, Separator, Undo, Redo, Separator, Cut, Copy, Paste,"
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

	// 새문서, 불러오기, 저장
	pHwpCtrl.ReplaceAction("FileNew", "HwpCtrlFileNew");
	pHwpCtrl.ReplaceAction("FileOpen", "HwpCtrlFileOpen");
	pHwpCtrl.ReplaceAction("FileSave", "HwpCtrlFileSaveAutoBlock");
	pHwpCtrl.ReplaceAction("FileSaveAs", "HwpCtrlFileSaveAsAutoBlock");

	// Modeless 대화상자 -> Modal 대화상자.
	pHwpCtrl.ReplaceAction("FindDlg", "HwpCtrlFindDlg");
	pHwpCtrl.ReplaceAction("ReplaceDlg", "HwpCtrlReplaceDlg");

	// 수식 입력은 97방식으로 입력하도록 한다.
	pHwpCtrl.ReplaceAction("EquationCreate", "HwpCtrlEquationCreate97");
	pHwpCtrl.ReplaceAction("InsertEquation", "HwpCtrlEquationCreate97");
	
	var lockCommandList = new Array(
		// 아래 Action은 OLE관련 문제로 인해 막아 놓는다.
		"OleCreateNew",
		"InsertTextArt",
		"InsertChart",
		"InsertVoice",

		// 아래 Action은 새창이나, 새탭을 사용하므로 막아 놓는다.
		"LabelTemplate", // 라벨 문서 만들기
		"ManuScriptTemplate", // 원고지 쓰기
		"IndexMark", // 찾아보기 표시
		"MakeIndex", // 찾아보기 만들기
		"MakeContents" // 차례만들기
		);
	for (i = 0; i < lockCommandList.length; i++)
		pHwpCtrl.LockCommand(lockCommandList[i], true);
}
/**저장 보내기 */
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
	
	alert("작성하신 양식파일이 저장되었습니다");
	
	top.opener.location.reload();
}	
/** 닫을때 저장 확인 */
function closing(){
  if(blnUpload==false) return;
  if(confirm('제출양식파일을 저장하시겠습니까?')){
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