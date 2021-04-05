
<script language="JavaScript" type="text/JavaScript">
<!--
function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}

function fun_bottomhomepage(strUrl, strNm){
	window.open(strUrl, strNm);
}

function fun_bottomhomepage_pop(strUrl, strNm, width, height){
	//window.open(strUrl, strNm);
	var hWin=null;

	hWin = window.open(strUrl, strNm ,"toolbar=no,scrollbars=yes,left=1,top=1,width="+width+",height="+height+",resizable=no, screenX=0,screenY=0,top=100,left=100");
	hWin.focus();
}

//-->
</script>

<%
	String strBottomIsRequesterGbn = (String)session.getValue("IS_REQUESTER");
	String strBottomImage_ReqSubmit = (strBottomIsRequesterGbn !=null && strBottomIsRequesterGbn.equals("true")) ? "req" : "submit"; 
	//서류 요구/제출에 따라 이미지 변경

	//하단 각 메뉴별 링크는 상단메뉴페이지(/common/TopMenu.jsp)에서 선언함
%>

<body>
<table width="100%" height="101" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td align="left" valign="top" background="/image/main/bg_bot.gif"><table width="975" height="101" border="0" cellpadding="0" cellspacing="0">
        <tr>
          <td height="70" align="left" valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr align="left" valign="top"> 
                <td width="41%"><img src="/image/common/bottom_links.gif" width="397" height="70"></td>
                <td width="14%"><a href="javascript:fun_bottomhomepage(' http://org.mopas.go.kr/org/external/chart/index.jsp','정부조직도');"><img src="/image/common/govern_sub.gif" width="140" height="70" border=0></a></td>
                <td width="15%"><a href="javascript:fun_bottomhomepage(' http://org.mopas.go.kr/org/external/chart/index.jsp','행정기관전화번호');"><img src="/image/common/orgPhoneNum_sub.gif" width="144" height="70" border=0></a></td>
                <td width="1%"><a href="javascript:fun_bottomhomepage('/reqsubmit/70_organchargesh/SearchRelOrgan.jsp?InOutMode=I','국회직원조회');"><img src="/image/common/searchStaff_sub.gif" width="146" height="70" border=0></a></td>
                <td width="29%"><a href="javascript:fun_bottomhomepage('/reqsubmit/70_organchargesh/SearchOutRelOrgan.jsp?InOutMode=X','기관담당자조회');"><img src="/image/common/searchOrgStaff_sub.gif" width="148" height="70" border=0></a></td>
              </tr>
            </table></td>
        </tr>
        <tr>
          <td height="31" align="left" valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr align="left" valign="top">
                <td width="42%"><img src="/image/common/bot_copyright_sub.gif" width="412" height="31"></td>
                <td width="10%"><a href="<%=strMypageURL%>"><img src="/image/common/bot_mypage_sub.gif" width="98" height="31" border=0></a></td>
                <td width="10%"><a href="<%=strReqSubmitURL%>"><img src="/image/common/bot_<%=strBottomImage_ReqSubmit%>_sub.gif" width="98" height="31" border=0></a></td>
                <td width="10%"><a href="<%=strInfoSearchURL%>"><img src="/image/common/bot_infosearch_sub.gif" width="100" height="31" border=0></a></td>
                <td width="8%"><a href="<%=strForumURL%>"><img src="/image/common/bot_forum_sub.gif" width="79" height="31" border=0></a></td>
                <td width="1%"><a href="<%=strBoardURL%>"><img src="/image/common/bot_board_sub.gif" width="86" height="31" border=0></a></td>
                <td width="19%"><a href="<%=strHelpURL%>"><img src="/image/common/bot_help_sub.gif" width="102" height="31" border=0></a></td>
              </tr>
            </table></td>
        </tr>
      </table></td>
  </tr>
</table>
</body>