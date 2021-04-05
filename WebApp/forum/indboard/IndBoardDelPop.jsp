<%@ page language="java"  contentType="text/html;charset=euc-kr" %>	
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>

<%
	/*개별포럼 페이지 파라미터 (포럼ID, 회원상태, 공개여부, 포럼명)*/
	String strForumID = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("fid"))); 				 //포럼ID
	String strUserStt = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("uStt"))); 			 //회원상태
	String strOpenFlag = ""; 																										//공개여부
	String strForumNM = "";																										//포럼명
	
	/*GET 파라미터*/
	String strCurrentPage =  nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("strCurrentPage"))); //현재 페이지
	String strAncTgt = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("anctgt")));			 //공지대상
	String strCmd =  nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("cmd")));					 //구분 
	String strBbrdID =  nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("bbrdid")));			 //게시판 아이디
	String strDataID = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("dataid")));			 //게시물 아이디
	String strOneID=  nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("oneid")));				 //한줄답글 아이디
%>
<html>
<head>
<title>포럼 게시물 삭제</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link href="/css/System.css" rel="stylesheet" type="text/css">
<script language="javascript" src="/js/forum.js"></script>
<script language="javascript">
	
	function goToOprDelete(){
		
		var frm = document.frmOprDel;
		
		if (frm.delrsn.value == "" || frm.delrsn.value == null){
			alert("삭제사유를 입력해 주세요.");
			frm.delrsn.focus();
			return false;
		} 

		//한글, 영문 구별하여 문자열 길이를 체크한다.
        if(checkStrLen(frm.delrsn, 500, "삭제사유") == false){
            return false;
        }

       var msg = "해당 사항을 삭제 하시겠습니까?";

	    if(confirm(msg)){
			frm.cmd.value = "<%=strCmd%>"
			//frm.submit();
	    }
	    else{
	        return false;
	    }
	    
	}

</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="380" border="0" cellspacing="0" cellpadding="0">
<form name="frmOprDel" method="post" action="IndOprProc.jsp" onSubmit="return goToOprDelete();"> 
<input type="hidden" name="fid" value="<%=strForumID%>">
<input type="hidden" name="uStt" value="<%=strUserStt%>">
<input type="hidden" name="cmd" value="">
<input type="hidden" name="strCurrentPage" value="<%=strCurrentPage%>">
<input type="hidden" name="anctgt" value="<%=strAncTgt%>">
<input type="hidden" name="bbrdid" value="<%=strBbrdID%>">
<input type="hidden" name="dataid" value="<%=strDataID%>">
<input type="hidden" name="oneid" value="<%=strOneID%>">
  <tr class="td_forumpop"> 
    <td height="5"></td>
    <td height="5"></td>
  </tr>
  <tr> 
    <td width="14" height="10"></td>
    <td width="386" height="10"></td>
  </tr>
  <tr> 
    <td width="14">&nbsp;</td>
    <td height="25" valign="middle"><img src="/image/forum/icon_forumpop_soti.gif" width="9" height="9">&nbsp;<span class="soti_forumpop">포럼 운영자 삭제</span></td>
  </tr>
  <tr>
    <td height="5"></td>
    <td height="5"><table width="96%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td height="25" valign="bottom" class="text_s">선택 하신 자료 삭제 사유를 입력해 주세요.</td>
        </tr>
      </table></td>
  </tr>
  <tr> 
    <td height="10"></td>
    <td height="10"></td>
  </tr>
  <tr> 
    <td width="14">&nbsp;</td>
    <td height="23" align="left" valign="top"><textarea name="delrsn" wrap="hard" class="textfield" style="WIDTH: 96% ; height: 140"></textarea></td>
  </tr>
  <tr> 
    <td width="14">&nbsp;</td>
    <td height="40" align="left"><table width="96%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td height="25" align="right">&nbsp;
          	<input type="image" src="/image/button/bt_confirm.gif" width="42" height="20"> 
            <img src="/image/button/bt_cancel.gif" width="43" height="20" style="cursor:hand;"  onClick="reset();"></td>
        </tr>
      </table></td>
  </tr>
  <tr> 
    <td height="25" colspan="2" align="right" class="td_gray1">&nbsp;<a href="javascript:self.close()"><img src="/image/button/bt_close.gif" width="46" height="11" border="0"></a>&nbsp;&nbsp;</td>
  </tr>
</form>
</table>
</body>
</html>
