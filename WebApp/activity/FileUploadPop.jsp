<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>파일 올리기</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">

<link href="../css/System.css" rel="stylesheet" type="text/css">
<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil"%>
<%@ page import="kr.co.kcc.bf.config.*"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%@ include file="/forum/common/CheckSessionPop.jsp" %>
<%
	String strTotalSize = "";
	String strUsedSize = "";
	String strDocboxId = "";
	String strOrganId = "";
	String strUserId = "";
	long lUsingSize = 0L;

	String strFileSize = "";
	long lFileSize = 0L;
	
	String strMessage = "";
	String strError = "";
	try{
		strUserId = (String)session.getAttribute("USER_ID");
		
		strTotalSize = StringUtil.getNVL(request.getParameter("total_size"), "0");
		strUsedSize = StringUtil.getNVL(request.getParameter("used_size"), "0");
		strDocboxId = StringUtil.getNVL(request.getParameter("docbox_id"), "");
		strOrganId = StringUtil.getNVL(request.getParameter("organ_id"), "");
		lUsingSize = Long.parseLong(strTotalSize) - Long.parseLong(strUsedSize);


		Config objConfig = PropertyConfig.getInstance();
		strFileSize = StringUtil.getNVL(objConfig.get("activity.filemaxsize"), "0");	
		lFileSize =Long.parseLong(strFileSize) * 1024 * 1024;
	}
	catch(Exception objExcept)
	{	
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  		objMsgBean.setStrCode("SYS-00001");
  		objMsgBean.setStrMsg(objExcept.toString());
  		out.println("<br>Error!!!" + objExcept.toString());
%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%  	
		return;
	}
%>
<script src='/js/activity.js'></script>
<script src='/js/forum.js'></script>
<script language="javascript">
	function fun_filename(varName){
		var varTmp = "";
		var i, len=0;
		
		for(i=varName.length; i >= 0; i--){
			if(varName.charAt(i-1) == '\\') break;
			varTmp = varTmp + varName.charAt(i-1);
		}

	    // String 길이를 구하는 부분.. # 여기서 한글인지 판단을 해서 응용할수 있을것이다. 
		for(i=0;i < varTmp.length; i++)  
			(varTmp.charCodeAt(i) > 255)? len+=2:len++; 
         
		// 길이 확인.        
		if (len > 42)  
		{ 
			alert("파일명은 한글 " + 42/2 +"자 영문 " + 42 + "자를 넘을 수 없습니다."); 
	        return false; 
		} 
		return true; 
	}
	
	function fun_upload(lmax){
		if (form_main.t1.value == '' && 
		  form_main.t2.value == '' && 
		  form_main.t3.value == '' && 
		  form_main.t4.value == '' && 
		  form_main.t5.value == ''){
			alert("파일이 없습니다.!");
 			return; 	
		}
		 if(checkStrLen(form_main.tx1, 100, "설명") == false){
            form_main.tx1.focus();
            return;
        } 
         if(checkStrLen(form_main.tx2, 100, "설명") == false){
            form_main.tx2.focus();
            return;
        } 
         if(checkStrLen(form_main.tx3, 100, "설명") == false){
            form_main.tx3.focus();
            return;
        } 
         if(checkStrLen(form_main.tx4, 100, "설명") == false){
            form_main.tx4.focus();
            return;
        } 
         if(checkStrLen(form_main.tx5, 100, "설명") == false){
            form_main.tx5.focus();
            return;
        } 
		
		
		for (var i = 1; i < 6; i++) {
			var file_object = "form_main.t" + i + ".value";
			if (eval(file_object) != "") { 		
				 if(fnBoardLimitAttach(eval(file_object))== false){
		            return;
		        }
			}
		} 
		 
		 if((form_main.t1.value != "") && (fun_filename(form_main.t1.value) == false)){
            form_main.t1.focus();
            return;
        } 
		 if((form_main.t2.value != "") && (fun_filename(form_main.t2.value) == false)){
            form_main.t2.focus();
            return;
        } 
		 if((form_main.t3.value != "") && (fun_filename(form_main.t3.value) == false)){
            form_main.t3.focus();
            return;
        }  
		 if((form_main.t4.value != "") && (fun_filename(form_main.t4.value) == false)){
            form_main.t4.focus();
            return;
        } 
		 if((form_main.t5.value != "") && (fun_filename(form_main.t5.value) == false)){
            form_main.t5.focus();
            return;
        } 
     
		var lsize = 0;

		form_main.goup.src = "/image/login/ing_gif.gif";
		form_main.goup.width="196";
		form_main.goup.height="15";
		form_main.goup.cursor="wait";
		document.body.style.cursor = "wait";
		form_main.submit();
	}
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="470" border="0" cellspacing="0" cellpadding="0">
<form id="form_main" method="post" action="./businfo/FileUploadPopProc.jsp" enctype="multipart/form-data">
<input type="hidden" name="docbox_id" value="<%=strDocboxId%>"><br>
<input type="hidden" name="organ_id" value="<%=strOrganId%>"><br>
<input type="hidden" name="max_size" value="<%=Long.toString(lFileSize)%>"><br>
<input type="hidden" name="using_size" value="<%=Long.toString(lUsingSize)%>"><br>
  <tr class="td_mypage"> 
    <td height="5"></td>
    <td height="5"></td>
  </tr>
  <tr> 
    <td height="10"></td>
    <td height="10"></td>
  </tr>
  <tr> 
    <td width="14">&nbsp;</td>
    <td width="386" height="25" valign="middle"><span class="soti_reqsubmit"><img src="../image/mypage/icon_mypage_soti.gif" width="9" height="9" align="absmiddle"> 
      </span><span class="soti_mypage">파일 올리기</span></td>
  </tr>
  <tr> 
    <td width="14">&nbsp;</td>
    <td height="23" align="left" valign="top"><table width="96%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td height="2" colspan="2" class="td_mypage"></td>
        </tr>
        <tr class="td_top"> 
          <td width="328" height="22" align="center">파일</td>
        </tr>
        <tr> 
          <td height="1" colspan="2" class="td_mypage"></td>
        </tr>
        <tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''"> 
          <td height="25" class="td_lmagin"><input name="t1" type="file" class="textfield" style="WIDTH: 300px" > 
          </td>
        </tr>
        <tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''"> 
          <td height="25" class="td_lmagin"><input name="tx1" type="text" class="textfield" style="WIDTH: 330px" value="" ></td>
        </tr>
        <tr class="tbl-line"> 
          <td height="1"></td>
          <td height="1"></td>
        </tr>
        <tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''"> 
          <td height="25" class="td_lmagin"><input name="t2" type="file" class="textfield" style="WIDTH: 300px" > 
          </td>
        </tr>
        <tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''"> 
          <td height="25" class="td_lmagin"><input name="tx2" type="text" class="textfield" style="WIDTH: 330px" value="" ></td>
        </tr>
        <tr class="tbl-line"> 
          <td height="1"></td>
          <td height="1"></td>
        </tr>
        <tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''"> 
          <td height="25" class="td_lmagin"><input name="t3" type="file" class="textfield" style="WIDTH: 300px" > 
          </td>
        </tr>
        <tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''"> 
          <td height="25" class="td_lmagin"><input name="tx3" type="text" class="textfield" style="WIDTH: 330px" value="" ></td>
        </tr>
        <tr class="tbl-line"> 
          <td height="1"></td>
          <td height="1"></td>
        </tr>
        <tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''"> 
          <td height="25" class="td_lmagin"><input name="t4" type="file" class="textfield" style="WIDTH: 300px" > 
          </td>
        </tr>
        <tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''"> 
          <td height="25" class="td_lmagin"><input name="tx4" type="text" class="textfield" style="WIDTH: 330px" value="" ></td>
        </tr>
        <tr class="tbl-line"> 
          <td height="1"></td>
          <td height="1"></td>
        </tr>
        <tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''"> 
          <td height="25" class="td_lmagin"><input name="t5" type="file" class="textfield" style="WIDTH: 300px" > 
          </td>
        </tr>
        <tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''"> 
          <td height="25" class="td_lmagin"><input name="tx5" type="text" class="textfield" style="WIDTH: 330px" value="" ></td>
        </tr>
        <tr class="tbl-line"> 
          <td height="2"></td>
          <td height="2"></td>
        </tr>
      </table></td>
  </tr>
  <tr> 
    <td width="14">&nbsp;</td>
    <td height="40" align="left"><table width="96%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td width="36%">&nbsp;</td>
          <td width="64%" align="right"><a href="javascript:fun_upload(<%=Long.toString(lUsingSize)%>)"><img name="goup" src="../image/button/bt_goUp.gif" width="54" height="20" border="0"></a></td>
        </tr>
      </table></td>
  </tr>
  <tr align="right"> 
    <td height="25" colspan="2" class="td_gray1">&nbsp;<a href="javascript:self.close()"><img src="../image/button/bt_close.gif" width="46" height="11" border="0"></a>&nbsp;&nbsp;</td>
  </tr>
</form>
</table>
</body>
</html>
