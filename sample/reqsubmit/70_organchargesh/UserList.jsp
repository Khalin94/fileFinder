<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link href="/css/System.css" rel="stylesheet" type="text/css">
<script src="/js/common.js"></script>

	<link href="/css/Main.css" rel="stylesheet" type="text/css">
	<link href="/css/global.css" rel="stylesheet" type="text/css">
</head>

<%@ page import = "java.util.*" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="kr.co.kcc.pf.util.PageCount" %>
<%@ page import="kr.co.kcc.bf.config.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>




<%

	Hashtable objHshUserList = new Hashtable();

	nads.dsdm.app.reqsubmit.delegate.searchrelorgan.SearchOrganDelegate objSearchOrgan = new nads.dsdm.app.reqsubmit.delegate.searchrelorgan.SearchOrganDelegate();
	ArrayList objAryUserList = new ArrayList();

	String strOrganId = StringUtil.getNVLNULL(request.getParameter("OrganId"));
	String srchMode = "OrganId";
	String InOutMode = "I";
	String curPage = StringUtil.getNVL(request.getParameter("curPage"), "1");	//현재 페이지
	String numPerPage="999";	


	String strOrganNm=request.getParameter("OrganNm");
	String strJuso1=request.getParameter("Juso1"); 
	String strJuso2 =request.getParameter("Juso2");
	String strTelNum=request.getParameter("TelNum"); 
	String strHomeUrl=request.getParameter("HomeUrl");
	String totalCnt="0";



	try{
		Config objConfig = PropertyConfig.getInstance();
		//numPerPage =objConfig.get("page.rowcount");		


		//선택한 부서가 없을경우 로그인한 사용자의 부서정보 조회
		if(strOrganId.equals(""))
			strOrganId = (String)session.getAttribute("ORGAN_ID");

		//System.out.println("organ id:"+strOrganId);
		//System.out.println("organ id:"+(String)session.getAttribute("ORGAN_ID"));

    	
		//부서 구성원 조회
		objAryUserList = objSearchOrgan.getOrganMember(InOutMode,srchMode,strOrganId,curPage,numPerPage);


		
	}
	catch(Exception e){
		out.print("[JSP] : " + e.toString());
	}

%>


<script language="javascript">
	parent.document.frames['userinfo'].location.href = "./OrganInfo.jsp?OrganId=<%=strOrganId%>";
</script>

<script>
	function goPage(varPageNo) {
		document.location = "/reqsubmit/70_organchargesh/PopupRelOrgan4OrganId.jsp?InOutMode=<%=InOutMode%>&OrganNm=<%=strOrganNm%>&Juso1=<%=strJuso1%>&Juso2=<%=strJuso2%>&TelNum=<%=strTelNum%>&HomeUrl=<%=strHomeUrl%>&OrganId=<%=strOrganId%>&curPage="+varPageNo;
	}
</script>

  <table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr> 
        <td height="2" colspan="2" class="td_join"></td>
      </tr>
      <tr align="center" class="td_top"> 
        <td width="103" height="22">이름</td>
        <td width="163" height="22">직위</td>
      </tr>
      <tr> 
        <td height="1" colspan="2" class="td_join"></td>
      </tr>

			  <%
			  if(objAryUserList != null && objAryUserList.size() > 1){
				  String strUserIdTest1 = "0000056090";
				  String strUserIdTest2 = "0000056025";
				  String strUserIdTest3 = "0000063256";
				  String strUserIdTest4 = "0000056092";
				  String strUserIdTest5 = "0000056093";
				  String strUserIdTest6 = "0000056094";
				  String strUserIdTest7 = "0000056098";
				  String strUserIdTest8 = "0000056091";
				  String strUserIdTest9 = "0000056097";
				  String strUserIdTest10 = "0000056095";
				  
				  
								  
					if( objAryUserList.size()>0){
						objHshUserList = (Hashtable)objAryUserList.get(0);
						totalCnt = (String)objHshUserList.get("TOTALCNT");
					}
			 			
		 			
					for(int i=1;i < objAryUserList.size();i++)
					{
						objHshUserList = (Hashtable)objAryUserList.get(i);
					
						String strUserNm = (String)objHshUserList.get("USER_NM");
						String strUserId = (String)objHshUserList.get("USER_ID");
						String strPosiNm = (String)objHshUserList.get("POSI_NM");
						String strGrdNm = (String)objHshUserList.get("GRD_NM4I");
						String strCgDuty = (String)objHshUserList.get("CG_DUTY");
						String strOfficeTel = (String)objHshUserList.get("OFFICE_TEL");
						String strEmail = (String)objHshUserList.get("EMAIL");
				
			  %>
<% 

if (!strUserIdTest1.equals((String)objHshUserList.get("USER_ID"))
		&& !strUserIdTest2.equals((String)objHshUserList.get("USER_ID"))
		&& !strUserIdTest3.equals((String)objHshUserList.get("USER_ID"))
		&& !strUserIdTest4.equals((String)objHshUserList.get("USER_ID"))
		&& !strUserIdTest5.equals((String)objHshUserList.get("USER_ID"))
		&& !strUserIdTest6.equals((String)objHshUserList.get("USER_ID"))
		&& !strUserIdTest7.equals((String)objHshUserList.get("USER_ID"))
		&& !strUserIdTest8.equals((String)objHshUserList.get("USER_ID"))
		&& !strUserIdTest9.equals((String)objHshUserList.get("USER_ID"))
		&& !strUserIdTest10.equals((String)objHshUserList.get("USER_ID"))){ %>
		
      <tr  align="center" onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''"> 
        <td height="22"><a href="./UserInfo.jsp?UserId=<%=strUserId%>" target="userinfo"><%=strUserNm%></a></td>
        <td height="22"><%=strGrdNm%></td>
      </tr>
      <tr class="tbl-line"> 
        <td height="1"></td>
        <td height="1"></td>
      </tr>
      
<%}%>

			  <%

					}	
				}
				else{
					out.println("<tr ><td colspan=2 align='center'>직원 없음</td></tr>");

			%>
			  <tr class="tbl-line"> 
				<td height="2"></td>
				<td height="2"></td>
			  </tr>
			<%
				}
			  %>
<!--       <tr class="tbl-line"> 
        <td height="2"></td>
        <td height="2"></td>
      </tr> -->

   
      </table>
<!-- <%=PageCount.getLinkedString(totalCnt , curPage, numPerPage) %> -->

