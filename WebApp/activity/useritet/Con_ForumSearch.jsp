<%@ page import="nads.dsdm.app.forum.SLDBForumDelegate" %>
<%@ page import="nads.dsdm.app.common.code.*" %>
<%@ page import="java.util.*" %>
<%@ page import="nads.lib.util.*"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>

<%
	ArrayList objForumSortData = null;
	ArrayList objNewForumData = null;

	try {
		CodeInfoDelegate objCodeInfo = new CodeInfoDelegate(); //코드관련 Delegate
		SLDBForumDelegate objDBForum = new SLDBForumDelegate();

		objForumSortData = objCodeInfo.lookUpCode("M02");
		objNewForumData = objDBForum.selectNewForum(3); //신규등록포럼

	}catch(AppException objAppEx)
	{
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  		objMsgBean.setStrCode(objAppEx.getStrErrCode());
  		objMsgBean.setStrMsg(objAppEx.getMessage());
  		out.println("<br>Error!!!" + objAppEx.getMessage());
%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}
%>
       <!-- list -->


          <span class="list01_tl">
          <%=strPrgNm%><span class="sbt"><a href="<%=strPrgUrl%>?gbn=1"><img src="/images2/btn/bt_all.gif" width="78" height="19" /></a></span></span>
          <table>
			  <tr>
				<td>&nbsp;</td>
			  </tr>
		  </table>
          <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
            <thead>
              <tr>
                <th scope="col"><a>NO</a></th>
                <th scope="col" style="width:300px; "><a>포럼 이름</a></th>
                <th scope="col"><a>운영자</a></th>
                <th scope="col"><a>개설일</a></th>
                <th scope="col"><a>공개</a></th>
              </tr>
            </thead>
<%
					for(int i=0; i<objNewForumData.size(); i++) {
						Hashtable objHashSearchForum = (Hashtable)objNewForumData.get(i);

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

						String strH = "1";
						if (i==objNewForumData.size()-1) {
							strH = "2";
						}
%>
            <tbody>
              <tr>
                <td><%=i+1%></td>
                <td style="text-align:left;">[<%=strForumSort%>]<%=strForumNM%></td>
                <td><%=strOprtrNM%></td>
                <td><%=strEstabTS%></td>
                <td><%=strOpenFlagWord%></td>
              </tr>
            </tbody>
<%
					} //end for(신규등록포럼)
%>
          </table>

<!-- /list -->

<!-- 2011-09-05 이전 소스

                <tr>
                  <td height="5" colspan="2" align="left" class="soti_reqsubmit"></td>
                </tr>
                <tr>
                  <td width="655" height="30" align="left"><span class="soti_reqsubmit"><img src="../../image/mypage/icon_mypage_soti.gif" width="9" height="9" align="absmiddle">
                    </span><span class="soti_mypage"><%=strPrgNm%></span></td>
                  <td width="104" align="left"><a href="<%=strPrgUrl%>?gbn=1"><img src="../../image/button/bt_allList.gif" width="101" height="20" border="0"></a></td>
                </tr>
                <tr>
                <td colspan="2" align="left" valign="top"><table width="759" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td height="2" colspan="5" class="td_mypage"></td>
                    </tr>
                    <tr class="td_top">
                      <td width="48" height="22" align="center">NO</td>
                      <td width="461" height="22" align="center">포럼 이름</td>
                      <td width="91" height="22" align="center">운영자</td>
                      <td width="92" height="22" align="center">개설일</td>
                      <td width="67" align="center">공개</td>
                    </tr>
                    <tr>
                      <td height="1" colspan="5" class="td_mypage"></td>
                    </tr>
<%
					for(int i=0; i<objNewForumData.size(); i++) {
						Hashtable objHashSearchForum = (Hashtable)objNewForumData.get(i);

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

						String strH = "1";
						if (i==objNewForumData.size()-1) {
							strH = "2";
						}
%>
                    <tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''">
                      <td height="22" align="center"><%=i+1%></td>
                      <td height="22" class="td_lmagin">[<%=strForumSort%>]<%=strForumNM%></a></td>
                      <td height="22" align="center"><%=strOprtrNM%></td>
                      <td height="22" align="center"><%=strEstabTS%></td>
                      <td align="center"><%=strOpenFlagWord%></td>
                    </tr>
                    <tr class="tbl-line">
                      <td height="<%=strH%>"></td>
                      <td height="<%=strH%>"></td>
                      <td height="<%=strH%>" align="left" class="td_lmagin"></td>
                      <td height="<%=strH%>" align="left" class="td_lmagin"></td>
                      <td align="left" class="td_lmagin"></td>
                    </tr>
<%
					} //end for(신규등록포럼)
%>
                  </table></td>
                </tr>

-->
