<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="nads.dsdm.app.forum.SLDBForumDelegate" %>
<%@ page import="nads.dsdm.app.common.code.*" %>
<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="kr.co.kcc.bf.config.*" %>
<%@ page import="kr.co.kcc.pf.util.PageCount" %>

<%@ page import="nads.lib.message.MessageBean" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%@ include file="/common/CheckSession.jsp" %>

<%
	String strGbn = this.replaceXss(StringUtil.getNVLNULL(request.getParameter("gbn"))); //구분(1:포럼검색, 2:분류별 포럼)
	String strWord = "포럼 검색";
	String strDesc = "검색을 통하여 원하는 포럼을 찾을 수 있습니다. <br>포럼분류, 포럼명, 운영자명, 포럼소개 등을 대상으로 검색할 수 있습니다.";

	if(strGbn.equals("2")) {
		strWord = "포럼 분류";
		strDesc = "포럼목록을 분류별로 볼 수 있습니다. <br>포럼 검색을 원하실 경우 '포럼 검색 및 가입하기' 메뉴를 이용하십시요.";
	}
	String strFCd = this.replaceXss(StringUtil.getNVLNULL(request.getParameter("fCd"))); //포럼분류
	String strSrchType =  this.replaceXss(StringUtil.getNVLNULL(request.getParameter("strSrchType")));
	String strSrchText =  this.replaceXss(StringUtil.getNVLNULL(request.getParameter("strSrchText")));
	//out.print("strGbn="+strGbn+"<br>fCd="+strFCd+"<br>strSrchType="+strSrchType+"<br>strSrchText="+strSrchText+"<br>");

	String strCurrentPage = this.replaceXss(StringUtil.getNVL(request.getParameter("strCurrentPage"), "1"));	//현재 페이지
	String strCountPerPage;

	try {
		//CountPerPage를 가져온다.
		Config objConfig = PropertyConfig.getInstance();
		strCountPerPage = objConfig.get("page.rowcount");
		//strCountPerPage = "3";
		
	} catch (ConfigException objConfigEx) {
		strCountPerPage = StringUtil.getNVL(request.getParameter("strCountPerPage"), "10");
	}


	ArrayList objForumSortData;
	ArrayList objSearchForumData;

	CodeInfoDelegate objCodeInfo = new CodeInfoDelegate(); //코드관련 Delegate
	SLDBForumDelegate objDBForum = new SLDBForumDelegate();
	
	try {

		objForumSortData = objCodeInfo.lookUpCode("M02");
		objSearchForumData = objDBForum.selectSearchForum(strFCd,strSrchType,strSrchText,strCurrentPage,strCountPerPage);

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

	String strTotalCount = (String)((Hashtable)objSearchForumData.get(0)).get("TOTAL_COUNT");
	int intTotalCount = Integer.valueOf(strTotalCount).intValue();

%>

<html>
<head>
<title>의정자료 전자유통 시스템</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link href="/css/System.css" rel="stylesheet" type="text/css">
<script src='/js/forum.js'></script>
<script language="JavaScript">
<!--
	function fnChk() {
		//alert(document.form.strSrchType.value);
		var strSrchText = document.form.strSrchText.value;
		if(strSrchText=="") {
			alert("검색어를 입력해주세요");
			document.form.strSrchText.focus();
			return false;
		}
		document.form.strCurrentPage.value = "1";
		document.form.submit();
	}
//-->
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<%@ include file="/common/TopMenu.jsp" %>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr align="left" valign="top">
    <td width="186" background="/image/common/bg_leftMenu.gif">
	<%@ include file="/common/LeftMenu.jsp" %></td>
	<!-- /forum/common/MenuLeftForum.jsp -->
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
                <td width="759" height="23" align="left" valign="top"></td>
              </tr>
              <tr> 
                <td align="left" valign="top"><table width="100%" height="23" border="0" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="9%" background="/image/forum/bg_forum_tit.gif"><span class="title"><%=strWord%></span></td>
                      <td width="32%" align="left" background="/image/common/bg_titLine.gif">&nbsp;</td>
                      <td width="59%" align="right" background="/image/common/bg_titLine.gif" class="text_s"><img src="/image/common/icon_navi.gif" width="3" height="5" align="absmiddle"> 
                        Home&gt;포럼&gt;<strong><%=strWord%></strong></td>
                    </tr>
                  </table></td>
              </tr>
              <tr> 
                <td height="50" align="left" class="text_s"><%=strDesc%></td>
              </tr>
              <tr> 
                <td height="5" align="left" class="soti_reqsubmit"></td>
              </tr>
<%
	if(strGbn.equals("1")) {
%>
              <tr> 
                <td height="30" align="left"><span class="soti_reqsubmit"><img src="/image/forum/icon_forum_soti.gif" width="9" height="9" align="absmiddle"> 
                  </span><span class="soti_forum">포럼 검색</span></td>
              </tr>
              <tr> 
                <td height="20" align="left" valign="top"><table width="100%" border="0" cellpadding="0" cellspacing="1" bgcolor="CCCCCC">
                    <tr> 
                      <td height="75" align="center" bgcolor="#F3F3F3"><table width="54%" border="0" cellspacing="5" cellpadding="0">

						  <form name="form" method="post" action="ForumSearch.jsp" onSubmit="return fnChk();">
						  <input type="hidden" name="gbn" value="<%=strGbn%>">
						  <input type="hidden" name="strCurrentPage">
                          <tr> 
                            <td align="left"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                              <strong>포 &nbsp;&nbsp;럼 :</strong> <select name="fCd" class="select">
								<option value="">전체포럼</option>
								<%
									for(int j=0; j< objForumSortData.size(); j++) {
										if(!strFCd.equals("") && strFCd.equals(String.valueOf(((Hashtable)objForumSortData.get(j)).get("MSORT_CD")))) {
								%>
											<option value="<%=String.valueOf(((Hashtable)objForumSortData.get(j)).get("MSORT_CD"))%>" selected><%=String.valueOf(((Hashtable)objForumSortData.get(j)).get("CD_NM"))%></option>
								<%
										} else {
								%>
											<option value="<%=String.valueOf(((Hashtable)objForumSortData.get(j)).get("MSORT_CD"))%>"><%=String.valueOf(((Hashtable)objForumSortData.get(j)).get("CD_NM"))%></option>
								<%
										}
									}
								%>
                              </select> &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;<img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                              <strong>검색대상 :</strong> <select name="strSrchType" class="select">
								<option value="ALL">전체포럼</option>
								<option value="FORUM_NM">포럼명</option>
								<option value="USER_NM">운영자명</option>
								<option value="FORUM_INTRO">포럼소개</option>
                              </select> </td>
							<% //select box 값 셋팅
								out.print("<SCRIPT LANGUAGE='JavaScript'>\n");
								out.print("<!--\n");
								if (strSrchType == null || strSrchType.equals("")){
								} else {
									out.print("document.form.strSrchType.value ='" + strSrchType + "'  ;\n ")    ;
								}
								out.print("//-->\n")    ;
								out.print("</SCRIPT>\n")    ;
							%>

                          </tr>
                          <tr> 
                            <td align="left"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                              <strong>검색어 : 
                              <input name="strSrchText" type="text" class="textfield" style="WIDTH: 240px" value="<%=strSrchText%>">
                              <input type="image" src="/image/button/bt_gumsack_icon.gif" width="47" height="19" align="absmiddle"> 
                              </strong></td>
                          </tr>
						  </form>

                        </table></td>
                    </tr>
                  </table></td>
              </tr>
              <tr> 
                <td height="20" align="left">&nbsp;</td>
              </tr>
			  <form name="form2" method="post" action="<%=request.getRequestURI()%>">
			  <input type="hidden" name="gbn" value="<%=strGbn%>">
              <tr>
                <td height="30" align="left">
				  <table border="0" width="100%"><tr><td align="left">
					  <span class="soti_reqsubmit"><img src="/image/forum/icon_forum_soti.gif" width="9" height="9" align="absmiddle"> 
					  </span> <select name="fCd" class="select_forum" onChange="document.form2.submit();">
						<option value="">전체포럼</option>
						<%
							for(int j=0; j< objForumSortData.size(); j++) {
								if(!strFCd.equals("") && strFCd.equals(String.valueOf(((Hashtable)objForumSortData.get(j)).get("MSORT_CD")))) {
						%>
									<option value="<%=String.valueOf(((Hashtable)objForumSortData.get(j)).get("MSORT_CD"))%>" selected><%=String.valueOf(((Hashtable)objForumSortData.get(j)).get("CD_NM"))%></option>
						<%
								} else {
						%>
									<option value="<%=String.valueOf(((Hashtable)objForumSortData.get(j)).get("MSORT_CD"))%>"><%=String.valueOf(((Hashtable)objForumSortData.get(j)).get("CD_NM"))%></option>
						<%
								}
							}
						%>
					  </select> <span class="soti_forum">포럼 전체 목록</span>
					</td><td align="right">총 <%=strTotalCount%>개</td></td></tr></table>
				  </td>
              </tr>
			  </form>
<%
	} else {
%>
			  <form name="form" method="post" action="<%=request.getRequestURI()%>">
				  <input type="hidden" name="gbn" value="<%=strGbn%>">
				  <input type="hidden" name="strCurrentPage">
				  <input type="hidden" name="fCd" value="<%=strFCd%>">
			  </form>
              <tr>
                <td height="30" align="left">
				  <table border="0" width="100%"><tr><td align="left">
					<span class="soti_reqsubmit"><img src="/image/forum/icon_forum_soti.gif" width="9" height="9" align="absmiddle"></span>
					<%
						for(int j=0; j< objForumSortData.size(); j++) {
							if(!strFCd.equals("") && strFCd.equals(String.valueOf(((Hashtable)objForumSortData.get(j)).get("MSORT_CD")))) {
					%>
								<span class="soti_forum"><%=String.valueOf(((Hashtable)objForumSortData.get(j)).get("CD_NM"))%> 포럼 전체 목록</span>
					<%
							}
						}
					%>
					</td><td align="right">총 <%=strTotalCount%>개</td></td></tr></table>
				</td>
              </tr>
<%
	}
%>
              <tr> 
                <td align="left" valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr class="td_forum"> 
                      <td width="64" height="2"></td>
                      <td width="1"></td>
                      <td width="396" height="2"></td>
                      <td width="72" height="2"></td>
                      <td width="98" height="2"></td>
                      <td width="82" height="2"></td>
                      <td width="67" height="2"></td>
                    </tr>
                    <tr class="td_top"> 
                      <td height="22" align="center">NO</td>
                      <td width="1" height="22"></td>
                      <td height="22" align="center">제목</td>
                      <td height="22" align="center">공개</td>
                      <td height="22" align="center">개설일</td>
                      <td height="22" align="center">운영자</td>
                      <td height="22" align="center">회원</td>
                    </tr>
                    <tr> 
                      <td height="1" class="td_forum"></td>
                      <td height="1" class="td_forum"></td>
                      <td height="1" class="td_forum"></td>
                      <td height="1" class="td_forum"></td>
                      <td height="1" class="td_forum"></td>
                      <td height="1" class="td_forum"></td>
                      <td height="1" class="td_forum"></td>
                    </tr>
				  <%
				  if(intTotalCount != 0){
					for(int i=1; i<objSearchForumData.size(); i++) {
						Hashtable objHashSearchForum = (Hashtable)objSearchForumData.get(i);
						String strRNUM = (String)objHashSearchForum.get("RNUM"); //rownum
						String strForumID = (String)objHashSearchForum.get("FORUM_ID"); //포럼ID
						String strForumNM = (String)objHashSearchForum.get("FORUM_NM"); //포럼명
						String strForumSort = (String)objHashSearchForum.get("FORUM_SORT"); //포럼분류
						for(int j=0; j< objForumSortData.size(); j++) {
							if(strForumSort.equals(String.valueOf(((Hashtable)objForumSortData.get(j)).get("MSORT_CD")))) {
								strForumSort = String.valueOf(((Hashtable)objForumSortData.get(j)).get("CD_NM"));
								break;
							}
						}
						String strOprtrNM = (String)objHashSearchForum.get("USER_NM"); //운영자명
						String strEstabTS = (String)objHashSearchForum.get("ESTAB_TS"); //개설일
						if(strEstabTS.length() > 8) {
							strEstabTS = strEstabTS.substring(0, 4) + "-" + strEstabTS.substring(4, 6) + "-" + strEstabTS.substring(6, 8);
						} else {
							strEstabTS = "개설전";
						}

						String strOpenFlag = (String)objHashSearchForum.get("OPEN_FLAG"); //공개여부
						String strOpenFlagWord ="공개";
						if(strOpenFlag.equals("N")) {
							strOpenFlagWord = "비공개";
						}

						String strCountUser = (String)objHashSearchForum.get("COUNT_USER"); //회원수

						String strForumIntro = (String)objHashSearchForum.get("FORUM_INTRO"); //포럼소개
						String strH = "1";
						if (i==objSearchForumData.size()-1) {
							strH = "2";
						}
				  %>
                    <tr> 
                      <td rowspan="3" align="center"><%=strRNUM%></td>
                      <td class="tbl-line"></td>
                      <td height="22" class="td_lmagin"><a href="javascript:openForum('<%=strForumID%>','<%=strOpenFlag%>');">[<%=strForumSort%>]<b><%=strForumNM%></b></a></td>
                      <td height="22" align="center"><%=strOpenFlagWord%></td>
                      <td height="22" align="center"><%=strEstabTS%></td>
                      <td height="22" align="center"><%=strOprtrNM%></td>
                      <td height="22" align="center"><%=strCountUser%></td>
                    </tr>
                    <tr height="1"> 
                      <td height="1"></td>
                      <td height="1" colspan="5"  background="/image/common/line_dot_wide.gif"></td>
                    </tr>
                    <tr> 
                      <td class="tbl-line" ></td>
                      <td height="22" colspan="4" class="td_lmagin"><%=strForumIntro%></td>
                      <td height="22" align="center"><a href="javascript:openWinB('/forum/induser/ForumJoinreq.jsp?fid=<%=strForumID%>&openYN=<%=strOpenFlag%>&fnm=<%=strForumNM%>','winJoin','250','130');"><img src="/image/button/bt_join_icon.gif" width="46" height="20" border=0></a></td>
                    </tr>
                    <tr> 
                      <td height="<%=strH%>" class="tbl-line"></td>
                      <td height="<%=strH%>" class="tbl-line"></td>
                      <td height="<%=strH%>" class="tbl-line"></td>
                      <td height="<%=strH%>" class="tbl-line"></td>
                      <td height="<%=strH%>" class="tbl-line"></td>
                      <td height="<%=strH%>" class="tbl-line"></td>
                      <td height="<%=strH%>" class="tbl-line"></td>
                    </tr>
				  <%
					}	//end for

				  } else {
				  %>
					<tr> 
					  <td height="22" colspan=7 align="center">해당 데이타가 없습니다.</td>
					</tr>
					<tr class="tbl-line"> 
						<td height="2" colspan=7 align="center"></td>
					</tr>
				  <%
				  } //end if
				  %>

                  </table></td>
              </tr>
              <tr align="center"> 
                <td height="35"><%=PageCount.getLinkedString(strTotalCount , strCurrentPage, strCountPerPage) %></td>
              </tr>
              <tr> 
                <td height="35" align="left" valign="top"></td>
              </tr>
            </table></td>
        </tr>
      </table></td>
  </tr>
</table>
<%@ include file="/common/Bottom.jsp" %>
</body>
</html>
<%!
	public String replaceXss(String str){
		
		if(str.equals("") || str == null){			
			str = "";
		}else{
			str = str.replaceAll("<","&lt;");
			str = str.replaceAll(">","&gt;");
			str = str.replaceAll("\"","&#34;");
			str = str.replaceAll("\'","&#39;");
		}		
		
		return str;
	}	
%>