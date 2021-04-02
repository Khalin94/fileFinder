<html>
<!doctype html public "-//w3c//dtd html 4.0 transitional//en">
<head>
<title>국회직원조회</title>
<link href="/css/global.css" rel="stylesheet" type="text/css">
<script src="/js/reqsubmit.js"></script>
</head>
<%@ page import = "java.util.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RMemReqBoxListForm" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%

	String srchWord = request.getParameter("srchWord"); 
	String srchMode = request.getParameter("srchMode"); 
	String InOutMode = request.getParameter("InOutMode"); 
	String strRelCd = request.getParameter("RelCd");


	String strRootOrganId = request.getParameter("organId");


 UserInfoDelegate objUserInfo =null;
 CDInfoDelegate objCdinfo =null;
%>
<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>


<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<%@ include file="/reqsubmit/common/MenuTopReqsubmit.jsp" %>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr align="left" valign="top">
    <td width="186" height="470" background="/image/common/bg_leftMenu.gif">
	<%@ include file="/reqsubmit/common/MenuLeftReqsubmit.jsp" %>
	<script src="/js/searchRel.js"></script>	
	</td>
    <td width="950">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr valign="top"> 
          <td width="30" align="left"><img src="/image/common/bg_leftBody.gif" width="30" height="1"></td>
          <td align="left"><table width="759" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td height="23" align="left" valign="top"></td>
              </tr>
              <tr> 
                <td height="23" align="left" valign="top"><table width="100%" height="23" border="0" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="20%" background="/image/reqsubmit/bg_reqsubmit_tit.gif"><span class="title">국회의원 및 직원 조회</span></td>
                      <td width="21%" align="left" background="/image/common/bg_titLine.gif">&nbsp;</td>
                      <td width="59%" align="right" background="/image/common/bg_titLine.gif" class="text_s"><img src="/image/common/icon_navi.gif" width="3" height="5" align="absmiddle"> 
                        Home&gt;서류 제출&gt;<strong>국회의원 및 직원 조회</strong></td>
                    </tr>
                  </table></td>
              </tr>
              <tr> 
                <td height="30" align="left" class="text_s">국회의원 및 직원을 조회하실 
                  수 있습니다.</td>
              </tr>
              <tr> 
                <td height="15" align="left" valign="top"></td>
              </tr>
			 
              <tr> 
                <td height="5" align="left" valign="top"><table width="100%" border="0" cellpadding="0" cellspacing="1" bgcolor="CCCCCC">
                    <tr> 
                      <td height="45" align="center" bgcolor="#F3F3F3">
					   <!-- 위원회별 검색-->
			<%
				String strTitle1 = "";
				String strTitle2 = "";
				if(InOutMode == null || InOutMode.equals("I") )
				{
					
					strTitle1 = "국회의원 및 직원 조회";
					strTitle2 = "국회 직원";
				}
				else
				{
					strTitle1 = "기관 담당자 조회";
					strTitle2 = "기관 담당자";


				}
			%>
						<%@ include file="/reqsubmit/70_organchargesh/SearchRelOrganForm.jsp" %>
						
						</td>
                    </tr>
                  </table>
				  </td>
              </tr>
              <tr> 
                <td height="15" align="left" valign="top"></td>
              </tr>
              <tr> 
                <td height="2" align="left" valign="top" class="td_reqsubmit"></td>
              </tr>

				<table width="100%" height="319" border="0" cellpadding="0" cellspacing="0">
                    <tr align="left" valign="top"> 
                      <td width="33%" height="30" valign="middle"><img src="/image/reqsubmit/icon_reqsubmit_soti.gif" width="9" height="9" align="absmiddle"> 
                        <span class="soti_reqsubmit">조직도</span></td>
                      <td width="2%" height="30">&nbsp;</td>
                      <td width="17%" height="30">&nbsp;</td>
                      <td width="2%" height="30">&nbsp;</td>
                      <td width="46%" height="30" valign="middle"><img src="/image/reqsubmit/icon_reqsubmit_soti.gif" width="9" height="9" align="absmiddle"> 
                        <span class="soti_reqsubmit">상세정보</span></td>
                    </tr>



					<!-- 2 tr 시작 -->
                    <tr align="left" valign="top"> 
					<!-- 조직도 -->
                      <td height="289">
					  
					<iframe src="/reqsubmit/70_organchargesh/TestSearchRelOrganCenter.jsp" name="dept" scrolling="yes" frameborder="no" width="270" height="370" align="left" marginwidth="0" marginheight="0"></iframe>


					</td>
                      <td>&nbsp;</td>

					<!-- 부서원목록 -->
                      <td>
					  
						<iframe src="/reqsubmit/70_organchargesh/UserList.jsp" name="userlist" scrolling="yes" frameborder="no" width="143" height="370" align="left" marginwidth="0" marginheight="0"></iframe>

						</td>
                      <td>&nbsp;</td>

					  <!-- 구성원정보 또는 부서 정보 -->
                      <td>

						<iframe src="/reqsubmit/70_organchargesh/OrganInfo.jsp?OrganId=<%=(String)session.getAttribute("ORGAN_ID")%>" name="userinfo" scrolling="no" frameborder="no" width="350" height="370" align="left" marginwidth="0" marginheight="0" ID="userinfo"></iframe>

						</td>
					<!-- 2 tr 끝 -->
                    </tr>

                  </table>			  
			  
			  
			  </td>
              <tr> 
                <td height="10" align="left" valign="top"></td>
              </tr>
              <tr> 
                <td height="1" align="left" valign="top" class="tbl-line"></td>
              </tr>
              <tr> 
                <td height="35" align="left" valign="top" class="soti_reqsubmit">&nbsp;</td>
              </tr>
			 
            </table>
			</td>
        </tr>
      </table></td>
  </tr>
</table>
<%@ include file="/common/Bottom.jsp" %>
</body>
</html>
