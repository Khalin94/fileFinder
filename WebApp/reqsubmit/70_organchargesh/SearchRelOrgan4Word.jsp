<html>
<!doctype html public "-//w3c//dtd html 4.0 transitional//en">
<head>
<title>의정자료 전자유통 시스템</title>
<link href="/css/System.css" rel="stylesheet" type="text/css">
<script src="/js/common.js"></script>
<script>
	function goPage(varPageNo) {
		 var url = "/reqsubmit/70_organchargesh/SearchRelOrgan4Word.jsp?srchMode=<%=request.getParameter("srchMode")%>&srchWord=<%=request.getParameter("srchWord")%>"+"&curPage="+varPageNo+"&InOutMode="+"<%=request.getParameter("InOutMode")%>"+"&organNm="+"<%=request.getParameter("organNm")%>";
		
		 document.location = url;
	}
</script>
</head>

<%@ page import = "java.util.*" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="kr.co.kcc.pf.util.PageCount" %>
<%@ page import="kr.co.kcc.bf.config.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RMemReqBoxListForm" %>
<%@ page import="nads.lib.message.MessageBean" %>
<%@ page import=" kr.co.kcc.bf.log.Log" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%


	nads.dsdm.app.reqsubmit.delegate.searchrelorgan.SearchOrganDelegate objSearchOrgan = new nads.dsdm.app.reqsubmit.delegate.searchrelorgan.SearchOrganDelegate();

	Hashtable objHshSearchOrganList = new Hashtable();
	Hashtable objHshUserChargeList = new Hashtable();
	Hashtable objHshUserChargeParam = new Hashtable();

	ArrayList objArySearchOrgan = new ArrayList();
	ArrayList objAryUserCharge = new ArrayList();

	String srchWord = nads.lib.reqsubmit.util.StringUtil.getEmptyIfNull(request.getParameter("srchWord"));
	String srchMode = nads.lib.reqsubmit.util.StringUtil.getEmptyIfNull(request.getParameter("srchMode"));
	String InOutMode =nads.lib.reqsubmit.util.StringUtil.getEmptyIfNull(request.getParameter("InOutMode"));
	String curPage = StringUtil.getNVL(request.getParameter("curPage"), "1");	//현재 페이지
	String numPerPage="";	
	String totalCnt="0";
	
	try{

		Config objConfig = PropertyConfig.getInstance();
		numPerPage = objConfig.get("page.rowcount");		
    	objArySearchOrgan = objSearchOrgan.getOrganMember(InOutMode,srchMode,srchWord,curPage,numPerPage);
		
	}catch (ConfigException objConfigEx) {
		numPerPage = StringUtil.getNVL(request.getParameter("strCountPerPage"), "10");
	}
	catch(Exception objExcept){
		Log.debug.println("오류 발생:"+objExcept);
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		objMsgBean.setStrCode("DSPARAM-0000");
		
		
		// 에러 발생 메세지 페이지로 이동한다.
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;

	}
	


 UserInfoDelegate objUserInfo =null;
 CDInfoDelegate objCdinfo =null;

%>
<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="819" border="0" cellpadding="0" cellspacing="0">
  <tr height="54">
    <td height="54" align="left" valign="top" background="/image/reqsubmit/bg_bottomsearch.gif"><img src="/image/reqsubmit/logo_bottomsearch.gif" width="270" height="54"></td>
  </tr>
  <tr>
    <td align="center" valign="top"><table width="759" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td height="23" align="left" valign="top"></td>
        </tr>
        <tr> 
          <td height="23" align="left" valign="top"><table width="100%" height="23" border="0" cellpadding="0" cellspacing="0">
			<%
				String strTitle1 = "";
				String strTitle2 = "";
				String strTitle3 = "";
				if(InOutMode == null || InOutMode.equals("I") )
				{
					strTitle1 = "국회의원 및 직원 조회";
					strTitle2 = "국회 직원";
					strTitle3 = "국회의원 및 의원보좌진, 국회사무처, 국회도서관, 국회예산정책처, 위원회 직원 조회를 하실 수 있습니다.";
				}
				else
				{
					strTitle1 = "기관 담당자 조회";
					strTitle2 = "기관 담당자";
					strTitle3 = "기관 담당자 조회를 하실 수 있습니다.";
				}
			%>

              <tr> 
                <td width="20%" background="/image/join/bg_join_tit.gif"><span class="title"><%=strTitle1%></span></td>
                <td width="20%" align="left" background="/image/common/bg_titLine.gif">&nbsp;</td>
                <td width="59%" align="right" background="/image/common/bg_titLine.gif" class="text_s">&nbsp;</td>
              </tr>
            </table></td>
        </tr>
        <tr> 
          <td height="30" align="left" class="text_s"><%=strTitle3%></td>
        </tr>
        <tr> 
          <td height="15" align="left" valign="top"></td>
        </tr>
        <tr> 
          <td align="left" valign="top"><table width="100%" border="0" cellpadding="0" cellspacing="1" bgcolor="CCCCCC">
              <tr> 
                <td height="45" align="center" bgcolor="#F3F3F3">
					   <!--검색-->
						<%@ include file="/reqsubmit/70_organchargesh/SearchRelOrganForm.jsp" %>
				  </td>
              </tr>
            </table></td>

              </tr>
              <tr> 
                <td height="15" align="left" valign="top"></td>
              </tr>
              <tr> 
                <td height="22" align="left" valign="middle" class="soti_join"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td width="50%" class="text_s">&nbsp;&nbsp;<img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
					<%
					  if(objArySearchOrgan != null && objArySearchOrgan.size()>0){
								objHshSearchOrganList = (Hashtable)objArySearchOrgan.get(0);
								totalCnt = (String)objHshSearchOrganList.get("TOTALCNT");
						}
					%>

                        <%//=srchMode.equals("OrganId")==true?"기관명 : "+request.getParameter("organNm"):"검색어 : "+srchWord%>
						<%=srchMode.equals("OrganId")||srchMode.equals("OrganIdForSubmit")?"기관명 : "+request.getParameter("organNm"):"검색어 : "+srchWord%>
						</td>
                      <td width="50%" align="right" class="text_s"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        총 <%=totalCnt%>명&nbsp;&nbsp;</td>
                    </tr>
                  </table></td>
              </tr>
              <tr> 
                <td height="118" align="left" valign="top" class="soti_join"><table width="759" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td height="2" colspan="8" class="td_join"></td>
                    </tr>
                    <tr align="center" class="td_top"> 
                      <td width="37" height="22">NO</td>
                      <td width="223" height="22">부서</td>
                      <td width="78" height="22">이름</td>
                      <td width="100" height="22">직위</td>
                      <td  height="22" align=center>직급</td>
					  <% if(InOutMode.equals("X")  == true) { %>
                      <td width="107" height="22">담당업무</td>
					  <% } %>
                      
                      <td width="40" height="22">상세<br>정보</td>
                    </tr>
                    <tr> 
                      <td height="1" colspan="8" class="td_join"></td>
                    </tr>

			  <%
			  if(objArySearchOrgan != null && totalCnt.equals("0") != true ){
			 		
					for(int i=1;i < objArySearchOrgan.size();i++){
						objHshSearchOrganList = (Hashtable)objArySearchOrgan.get(i);
						String strRn = (String)objHshSearchOrganList.get("TOTALCNT");
						String strOrganNm = (String)objHshSearchOrganList.get("ORGAN_NM");
						String strUserNm = (String)objHshSearchOrganList.get("USER_NM");
						String strUserId = (String)objHshSearchOrganList.get("USER_ID");
						String strGrdNm = "";
						if(InOutMode == null || InOutMode.equals("I") ){
							strGrdNm = (String)objHshSearchOrganList.get("GRD_NM4I");
						}else{
							strGrdNm = (String)objHshSearchOrganList.get("GRD_NM4X");
						
						}

						
						String strCgDuty = (String)objHshSearchOrganList.get("CG_DUTY");
						String strOfficeTel = (String)objHshSearchOrganList.get("OFFICE_TEL");
						String strinnerphone = (String)objHshSearchOrganList.get("INNERPHONE");
						String strEmail = (String)objHshSearchOrganList.get("EMAIL");
						String strDeptNm = (String)objHshSearchOrganList.get("DEPT_NM");

						//2004.6.7 추가
						String strPosiNm = (String)objHshSearchOrganList.get("POSI_NM");
			  %>

              <tr  align="center" onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''"> 
                <td height="22"><%=strRn%></td>
                <td height="22" align="left" class="td_lmagin"><%=strOrganNm%><br><%=InOutMode.equals("X")?strDeptNm:""%></td>
                <td height="22" align="center"><a href="javascript:winopen('./PopUserInfo.jsp?UserId=<%=strUserId%>','UserInfo','width=575,height=390,scrollbars=no')"><%=strUserNm%></a></td>
                <td height="22"><%=strPosiNm%></td>
                <td height="22"><%=strGrdNm%></td>
				
				<% if(InOutMode.equals("X")  == true) { 
				%>
				<td height="22">
				<%
					objHshUserChargeParam.put("USER_ID",strUserId);
					objAryUserCharge = objSearchOrgan.getUserCharge(objHshUserChargeParam);	
					if(objAryUserCharge !=null){
						for(int j = 0; j < objAryUserCharge.size() ; j++){
							objHshUserChargeList = (Hashtable)objAryUserCharge.get(j);
							out.println((String)objHshUserChargeList.get("CD_NM"));
							
						}
						
					}
					%>
				</td>
			    <%
				 } 
				%>
				
                
                <td height="22">
				<a href="javascript:winopen('./PopUserInfo.jsp?UserId=<%=strUserId%>','UserInfo','width=575,height=390,scrollbars=no')"><img src='/image/button/bt_detail_icon.gif' border='0'></a>
				</td>
              </tr>
              <tr class="tbl-line"> 
                <td height="1"></td>
                <td height="1"></td>
                <td height="1"></td>
                <td height="1" align="left" class="td_lmagin"></td>
                <td height="1" align="left" class="td_lmagin"></td>
				<% if(InOutMode.equals("X")  == true) { %>
                <td height="1"></td>
				<% } %>
                <td height="1"></td>
                <td height="1"></td>
              </tr>
			  
			  <%

					}// end for	
				}
				else{
					
					out.println("<tr align='center' ><td colspan='8'>해당 데이타가 없습니다</td></tr>");
				%>
				<tr class="tbl-line"> 
                <td height="1"></td>
                <td height="1"></td>
                <td height="1"></td>
                <td height="1" align="left" class="td_lmagin"></td>
                <td height="1" align="left" class="td_lmagin"></td>
				<% if(InOutMode.equals("X")  == true) { %>
                <td height="1"></td>
				<% } %>
                <td height="1"></td>
                <td height="1"></td>
              </tr>
				<%
				}
			  %>
			  
                  </table></td>
              </tr>
			  <tr align="center"><td valign="middle"> <%=PageCount.getLinkedString(totalCnt , curPage, numPerPage) %></td></tr>
              <tr> 
                <td height="35" align="left" valign="top" class="soti_join">&nbsp;</td>
              </tr>
            </table></td>
  </tr>
  <tr height="38">
    <td height="38" align="left" valign="top" background="/image/reqsubmit/bbg_bottomsearch.gif"><img src="/image/reqsubmit/copyright_bottomsearch.gif" width="270" height="38"></td>
  </tr>
</table>
</body>
</html>