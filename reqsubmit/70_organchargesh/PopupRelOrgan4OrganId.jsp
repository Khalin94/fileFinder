<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link href="/css/System.css" rel="stylesheet" type="text/css">
<script src="/js/common.js"></script>
</head>

<%@ page import = "java.util.*" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="kr.co.kcc.pf.util.PageCount" %>
<%@ page import="kr.co.kcc.bf.config.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>

<%

	Hashtable objHshOrganInfo = new Hashtable();
	Hashtable objHshParam = new Hashtable();
	Hashtable objHshSearchOrganList = new Hashtable();

	nads.dsdm.app.reqsubmit.delegate.searchrelorgan.SearchOrganDelegate objSearchOrgan = new nads.dsdm.app.reqsubmit.delegate.searchrelorgan.SearchOrganDelegate();
	ArrayList objArySearchOrgan = new ArrayList();

	String srchWord = request.getParameter("OrganId");
	String srchMode = "OrganId";
	String InOutMode = "I";
	String curPage = StringUtil.getNVL(request.getParameter("curPage"), "1");	//현재 페이지
	String numPerPage="";	


	String strOrganNm=request.getParameter("OrganNm");
	String strJuso1=request.getParameter("Juso1"); 
	String strJuso2 =request.getParameter("Juso2");
	String strTelNum=request.getParameter("TelNum"); 
	String strHomeUrl=request.getParameter("HomeUrl");
	String totalCnt="0";



	try{
		Config objConfig = PropertyConfig.getInstance();
		numPerPage =objConfig.get("page.rowcount");		


		//부서 정보 조회
		objHshParam.put("ORGAN_ID",srchWord);
		objHshOrganInfo = objSearchOrgan.getOrganInfo(objHshParam);
    	
		//부서 구성원 조회
		objArySearchOrgan = objSearchOrgan.getOrganMember(InOutMode,srchMode,srchWord,curPage,numPerPage);


		
	}
	catch(Exception e){
		out.print("[JSP] : " + e.toString());
	}

%>

<script>
	function goPage(varPageNo) {
		document.location = "/reqsubmit/70_organchargesh/PopupRelOrgan4OrganId.jsp?InOutMode=<%=InOutMode%>&OrganNm=<%=strOrganNm%>&Juso1=<%=strJuso1%>&Juso2=<%=strJuso2%>&TelNum=<%=strTelNum%>&HomeUrl=<%=strHomeUrl%>&OrganId=<%=srchWord%>&curPage="+varPageNo;
	}
</script>


<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="527" border="0" cellspacing="0" cellpadding="0" scrolling="yes">
  <tr class="td_reqsubmit"> 
    <td height="5"></td>
    <td height="5"></td>
  </tr>
  <tr> 
    <td width="14" height="10"></td>
    <td width="515" height="10"></td>
  </tr>
  <!--tr> 
    <td width="14">&nbsp;</td>
    <td height="25" valign="middle"><img src="/image/reqsubmit/icon_reqsubmit_soti.gif" width="9" height="9" align="absmiddle"> 
      <span class="soti_reqsubmit"> <%=objHshOrganInfo.get("ORGAN_NM")%></span></td>
  </tr-->
  <tr> 
    <td width="14" height="5"></td>
    <td height="14" class="text_s">&nbsp;</td>
  </tr>
  <!--tr>
    <td height="5"></td>
    <td height="5" align="left" valign="middle">&nbsp;&nbsp;<img src="/image/common/icon_nemo_gray.gif" width="3" height="6" align="absmiddle"> 
      <select name="select2" class="select_reqsubmit">
        <option>기획예산담당관실</option>
      </select> <span class="soti_reqsubmit">직원조회</span></td>
  </tr-->
  <tr> 
    <td width="14" height="10"></td>
    <td height="10" align="left" valign="top"></td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
    <td height="23" align="left" valign="top"><table width="500" border="0" cellspacing="0" cellpadding="0">
        <tr class="td_reqsubmit"> 
          <td width="136" height="2"></td>
          <td width="364" height="2"></td>
        </tr>
        <tr> 
          <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
            부서명</td>
          <td height="25" class="td_lmagin"><%=objHshOrganInfo.get("ORGAN_NM")%></td>
        </tr>
        <tr class="tbl-line"> 
          <td height="1"></td>
          <td height="1"></td>
        </tr>
        <tr> 
          <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
            주소</td>
          <td height="25" class="td_lmagin"><%=objHshOrganInfo.get("JUSO1")%><%=objHshOrganInfo.get("JUSO2")%></td>
        </tr>
        <tr class="tbl-line"> 
          <td height="1"></td>
          <td height="1"></td>
        </tr>
        <tr> 
          <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
            전화번호</td>
          <td height="25" class="td_lmagin"><%=objHshOrganInfo.get("TEL_NUM")%></td>
        </tr>
        <tr class="tbl-line"> 
          <td height="1"></td>
          <td height="1"></td>
        </tr>
        <tr> 
          <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
            홈페이지</td>
          <td height="25" class="td_lmagin"><%=objHshOrganInfo.get("HOME_URL")%></td>
        </tr>
        <tr height="1" class="tbl-line"> 
          <td height="2"></td>
          <td height="2"></td>
        </tr>
      </table></td>
  </tr>
  <tr height="15"> 
    <td height="15"></td>
    <td height="15" align="left" valign="top"></td>
  </tr>
  <tr> 
    <td width="14">&nbsp;</td>
    <td height="23" align="left" valign="top"><table width="500" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td height="2" colspan="7" class="td_reqsubmit"></td>
        </tr>
        <tr align="center" class="td_top"> 
          <!--td width="86" height="22">구분</td-->
          <td width="65" height="22">이름</td>
          <td width="78" height="22">직급</td>
          <td width="146" height="22">업무</td>
          <td width="66" height="22">전화번호</td>
          <td width="59" height="22">E-Mail</td>
        </tr>
			<tr> 
			  <td height="1" colspan="7" class="td_reqsubmit"></td>
			</tr>			  <%
			  if(objArySearchOrgan != null && objArySearchOrgan.size() > 1){
				  
					if( objArySearchOrgan.size()>0){
						objHshSearchOrganList = (Hashtable)objArySearchOrgan.get(0);
						totalCnt = (String)objHshSearchOrganList.get("TOTALCNT");
					}
			 			
		 			
					for(int i=1;i < objArySearchOrgan.size();i++){
					objHshSearchOrganList = (Hashtable)objArySearchOrgan.get(i);
					
					String strUserNm = (String)objHshSearchOrganList.get("USER_NM");
					String strPosiNm = (String)objHshSearchOrganList.get("POSI_NM");
					String strCgDuty = (String)objHshSearchOrganList.get("CG_DUTY");
					String strOfficeTel = (String)objHshSearchOrganList.get("OFFICE_TEL");
					String strEmail = (String)objHshSearchOrganList.get("EMAIL");
							
			  %>



			<tr  align="center" onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''"> 
			  <!--td height="22">담당관</td-->
			  <td height="22"><%=strUserNm%></td>
			  <td height="22" align="center"><%=strPosiNm%></td>
			  <td height="22"><%=strCgDuty%></td>
			  <td height="22"><%=strOfficeTel%></td>
			  <td height="22"> 
				<% 
					strEmail = "jkyang@kcc.co.kr";
					if(StringUtil.getNVLNULL(strEmail).equals("")) {
				%>
						<a href="mailto:<%=strEmail%>"><img src="/image/reqsubmit/icon_mail.gif" width="17" height="12" border="0"></a>
				<%
					} 
				%>
				
				</td>
			</tr>
			<tr class="tbl-line"> 
			  <td height="1"></td>
			  <td height="1"></td>
			  <td height="1" align="left" class="td_lmagin"></td>
			  <td height="1"></td>
			  <td height="1"></td>
			  <td height="1"></td>
			</tr>



			  <%

					}	
				}
				else{
					out.println("<tr ><td colspan=6 align='center'>해당 데이타가 없습니다.</td></tr>");

			%>
			<tr class="tbl-line"> 
			  <td height="1"></td>
			  <td height="1"></td>
			  <td height="1" align="left" class="td_lmagin"></td>
			  <td height="1"></td>
			  <td height="1"></td>
			  <td height="1"></td>
			</tr>
			<%
				}
			  %>





        
      </table></td>
  </tr>
  <tr> 
    <td width="14" height="20">&nbsp;</td>
    <td height="20" align="left">&nbsp;</td>
  </tr>
  <tr><td colspan=2 align=center><%=PageCount.getLinkedString(totalCnt , curPage, numPerPage) %></td></tr>
  <tr> 
    <td height="25" colspan="2" align="right" class="td_gray1">&nbsp;<a href="javascript:self.close()"><img src="/image/button/bt_close.gif" width="46" height="11" border="0"></a>&nbsp;&nbsp;</td>
  </tr>
</table>
</body>
</html>
