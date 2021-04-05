<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="nads.dsdm.app.common.code.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>

<%@ page import="nads.lib.message.MessageBean" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%@ include file="/common/CheckSession.jsp" %>

<%
	/*세션값 */ 
	String strLoginID = (String)session.getAttribute("USER_ID"); //로그인 ID

	ArrayList objForumSortData;

	CodeInfoDelegate objCodeInfo = new CodeInfoDelegate(); //코드관련 Delegate
	
	try {

		objForumSortData = objCodeInfo.lookUpCode("M02");

	} catch (AppException objAppEx) {

		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		objMsgBean.setStrCode(objAppEx.getStrErrCode());
		objMsgBean.setStrMsg(objAppEx.getMessage());

		// 에러 발생 메세지 페이지로 이동한다.
%>

		<jsp:forward page="/common/message/ViewMsg.jsp"/>

<%
		return;
		
	}
%>

<html>
<head>
<title>의정자료 전자유통 시스템</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link href="/css/System.css" rel="stylesheet" type="text/css">
<script src='/js/forum.js'></script>
<script language="JavaScript">
<!--


var ie4 = (document.all) ? true : false;
var ns4 = (document.layers) ? true : false;
var ns6 = (document.getElementById && !document.all) ? true : false;

function showCase01()
{
	if (ie4) {
		//document.all["newlayer2"].style.visibility = "visible";
		//document.all["newlayer"].style.visibility = "hidden";
		document.all["span_01"].style.display = "block";
		document.all["span_02"].style.display = "none";
	}
	
	if (ns4) {
		document.layers["span_01"].visibility = "show";
		document.layers["span_02"].visibility = "hide";
	}
	
	if (ns6) {
		document.getElementById(["span_01"]).style.display = "block";
		document.getElementById(["span_02"]).style.display = "none";
	}
}


function showCase02()
{
	if (ie4) {
		//document.all["newlayer2"].style.visibility = "visible";
		//document.all["newlayer"].style.visibility = "hidden";
		document.all["span_02"].style.display = "block";
		document.all["span_01"].style.display = "none";
	}
	
	if (ns4) {
		document.layers["span_02"].visibility = "show";
		document.layers["span_01"].visibility = "hide";
	}
	
	if (ns6) {
		document.getElementById(["span_02"]).style.display = "block";
		document.getElementById(["span_01"]).style.display = "none";
	}
}

//파일 첨부
function showImageFile(fileValue, showValue) { 

	eval("document.form."+showValue+".value = document.form."+fileValue+".value");


	var strImgPath = eval("document.form." + fileValue + ".value");

	//alert(strImgPath);


	showCase02();

	if(document.all["imgPreView"] != null && strImgPath != "")
	{
		document.all["imgPreView"].src = strImgPath;
	}
}

function formReset()
{	

	document.form.reset();

	showCase01();
		
}

function fnChk() {
	if(document.form.FORUM_NM.value=="") {
		alert("포럼명을 입력하세요.");
		document.form.FORUM_NM.focus();
		return false;
	}

	if (fnSpaceChk(document.form.FORUM_NM.value, "포럼명을 올바르게 입력하세요.") == false ) 	return false;

	var openFlag="";
	for (var i = 0; i < document.form.OPEN_FLAG.length; i++) {
		if(document.form.OPEN_FLAG[i].checked) {
			openFlag = document.form.OPEN_FLAG[i].value;
			break;
		}
	}
	if(openFlag=="") {
		alert("공개여부를 선택하세요.");
		return false;
	}

	if(document.form.IMG_PATH.value!="") {
		if (LimitAttach(document.form.IMG_PATH.value) == false )  return false;	
	}

    if(document.form.FORUM_INTRO.value.length < 1 || document.form.FORUM_INTRO.value.length > 500){
        alert('포럼소개는 500자 이내 입니다.');
        document.form.FORUM_INTRO.focus();
		return false;
    }	

	document.form.action="ForumOpenreqProc.jsp"
	document.form.submit();
}
//-->
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="javascript:showCase01();">
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
          <td width="30" height="523" align="left"><img src="/image/common/bg_leftBody.gif" width="30" height="1"></td>
          <td align="left"><table width="759" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td width="759" height="23" align="left" valign="top"></td>
              </tr>
              <tr> 
                <td align="left" valign="top"><table width="100%" height="23" border="0" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="14%" background="/image/forum/bg_forum_tit.gif"><span class="title">포럼 
                        개설 신청</span></td>
                      <td width="27%" align="left" background="/image/common/bg_titLine.gif">&nbsp;</td>
                      <td width="59%" align="right" background="/image/common/bg_titLine.gif" class="text_s"><img src="/image/common/icon_navi.gif" width="3" height="5" align="absmiddle"> 
                        Home&gt;포럼&gt;<strong>포럼 개설신청</strong></td>
                    </tr>
                  </table></td>
              </tr>
              <tr> 
                <td height="50" align="left" class="text_s">포럼 개설 신청을 하실 수 있습니다. 
				<br>신청 후에는 "나의 페이지>나의포럼" 에서 확인할 수 있습니다.</td>
              </tr>
              <tr> 
                <td height="15" align="left"></td>
              </tr>
              <tr> 
                <td align="left" valign="top"><table width="680" border="0" cellspacing="0" cellpadding="0">
					<form name="form" method="post" encType="multipart/form-data" onSubmit="return fnChk();">
					<input type="hidden" name="FORUM_STT" value="001">
					<input type="hidden" name="FORUM_OPRTR_ID" value="<%=strLoginID%>"><!--세션에서 받아오도록-->
                    <tr class="td_forum"> 
                      <td width="128" height="2"></td>
                      <td width="552" height="2"></td>
                    </tr>
                    <tr> 
                      <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        포럼 분류</td>
                      <td height="25" class="td_lmagin"><select name="FORUM_SORT" class="select">
						<%
							for(int j=0; j< objForumSortData.size(); j++) {
						%>
							<option value="<%=String.valueOf(((Hashtable)objForumSortData.get(j)).get("MSORT_CD"))%>"><%=String.valueOf(((Hashtable)objForumSortData.get(j)).get("CD_NM"))%></option>
						<%
							}
						%>
                        </select></td>
                    </tr>
                    <tr class="tbl-line"> 
                      <td height="1"></td>
                      <td height="1"></td>
                    </tr>
                    <tr> 
                      <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        포럼명</td>
                      <td height="25" class="td_lmagin"><input name="FORUM_NM" type="text" class="textfield" style="WIDTH: 300px" maxlength="50"></td>
                    </tr>
                    <tr class="tbl-line"> 
                      <td height="1"></td>
                      <td height="1"></td>
                    </tr>
                    <tr> 
                      <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        공개여부</td>
                      <td height="25" class="td_lmagin"><input type="radio" name="OPEN_FLAG" value="Y">
                        공개&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
                        <input type="radio" name="OPEN_FLAG" value="N">
                        비공개</td>
                    </tr>
                    <tr class="tbl-line"> 
                      <td height="1"></td>
                      <td height="1"></td>
                    </tr>
                    <tr> 
                      <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        메인 이미지</td>
                      <td height="25" class="td_lmagin">
						<input type="text" name="IMG_PATH_TXT" class="textfield" style="WIDTH: 300px" readonly>
						<input type="file" name="IMG_PATH" class="textfield" style="WIDTH: 0px" onChange="javascript:showImageFile('IMG_PATH','IMG_PATH_TXT');"><br>
						
						
						
							<table width="154" height="77" border="0" cellpadding="0" cellspacing="1" bgcolor="CCCCCC">
								<tr> 
								  <td align="center" bgcolor="ffffff">
								  
								  <span id="span_01" >
									이미지 미리보기
								  </span>

								  <span id="span_02" >
									<img name="imgPreView" src="" width="154" height="77">
								  </span>
								  
								  </td>
								</tr>
							</table>
						

						


                    </tr>
                    <tr class="tbl-line"> 
                      <td height="1"></td>
                      <td height="1"></td>
                    </tr>
                    <tr> 
                      <td height="45" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        포럼소개</td>
                      <td height="45" valign="top" class="td_box"><textarea name="FORUM_INTRO" wrap="hard" class="textfield" style="WIDTH: 100% ; height: 250"></textarea></td>
                    </tr>
                    <tr height="1" class="tbl-line"> 
                      <td height="2"></td>
                      <td height="2"></td>
                    </tr>
                  </table></td>
              </tr>
              <tr> 
                <td align="left" valign="top"><table width="680" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td height="40" align="left"><input type="image" src="/image/button/bt_request.gif" width="44" height="20" border=0>&nbsp;<a href="javascript:formReset();"><img src="/image/button/bt_cancel.gif" width="43" height="20" border=0></a>
						<div align="right"></div></td>
					</form>
                    </tr>
                  </table></td>
              </tr>
              <tr> 
                <td height="15" align="left">&nbsp;</td>
              </tr>
            </table></td>
        </tr>
      </table></td>
  </tr>
</table>
<%@ include file="/common/Bottom.jsp" %>
</body>
</html>
