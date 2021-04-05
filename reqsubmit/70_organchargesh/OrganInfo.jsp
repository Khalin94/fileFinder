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
	ArrayList objAryUserList = new ArrayList();

	String strOrganId = request.getParameter("OrganId");
	String srchMode = "OrganId";
	String InOutMode = "I";
	String curPage = StringUtil.getNVL(request.getParameter("curPage"), "1");	//현재 페이지
	String numPerPage="";	


	String strOrganNm=request.getParameter("OrganNm");
	String strJuso1=request.getParameter("Juso1"); 
	String strJuso2 =request.getParameter("Juso2");
	String strTelNum=request.getParameter("TelNum"); 
	String strHomeUrl=request.getParameter("HomeUrl");
	String strINOUT_NM=request.getParameter("INOUT_NM");
	String totalCnt="0";



	try{
		Config objConfig = PropertyConfig.getInstance();
		numPerPage =objConfig.get("page.rowcount");		


		//선택한 부서가 없을경우 로그인한 사용자의 부서정보 조회
		if(strOrganId.equals("")) {
			strOrganId = (String)session.getAttribute("ORGAN_ID");
		}


/* Debug용 2015.05.11 박보성
String strDebug = "";
strDebug = "<script>" ;
strDebug = strDebug + "alert('";
strDebug = strDebug + "[DEBUG1]JUSO1: " +strJuso1 +"   ";
strDebug = strDebug + "[DEBUG1]JUSO2: " + strJuso2 +"   ";
strDebug = strDebug + "[DEBUG1]TelNum: " + strTelNum +"   ";
strDebug = strDebug + "[DEBUG1]HomeUrl: " + strHomeUrl +"   ";
strDebug = strDebug + "');";
strDebug = strDebug + "</script>";
out.println(strDebug);
*/

			//부서 정보 조회
		objHshParam.put("ORGAN_ID",strOrganId);
		objHshOrganInfo = objSearchOrgan.getOrganInfo(objHshParam);
    	if("외부".equals((String)objHshOrganInfo.get("INOUT_NM"))){
          objHshOrganInfo.put("ORGAN_NM", "국회");
          objHshOrganInfo.put("JUSO1", "서울시 영등포구 여의도동 1번지 국회");
          objHshOrganInfo.put("JUSO2", "");
          objHshOrganInfo.put("TEL_NUM", "02-788-2114");
		  objHshOrganInfo.put("HOME_URL", "http://assembly.go.kr/");
		}
		//부서 구성원 조회
		objAryUserList = objSearchOrgan.getOrganMember(InOutMode,srchMode,strOrganId,curPage,numPerPage);


/* Debug용 2015.05.11 박보성
strDebug = "";
strDebug = "<script>" ;
strDebug = strDebug + "alert('";
strDebug = strDebug + "[DEBUG2]JUSO1: " + objHshOrganInfo.get("JUSO1") +"   ";
strDebug = strDebug + "[DEBUG2]JUSO2: " + objHshOrganInfo.get("JUSO2") +"   ";
strDebug = strDebug + "[DEBUG2]TelNum: " + objHshOrganInfo.get("TelNum") +"  ";
strDebug = strDebug + "[DEBUG2]TEL_NUM: " + objHshOrganInfo.get("TEL_NUM") +"  ";
strDebug = strDebug + "[DEBUG2]HomeUrl: " + objHshOrganInfo.get("HomeUrl") +"   ";
strDebug = strDebug + "[DEBUG2]HOME_URL: " + objHshOrganInfo.get("HOME_URL") +"   ";
strDebug = strDebug + "');";
strDebug = strDebug + "</script>";
out.println(strDebug);
*/
	}
	catch(Exception e){
		out.print("[JSP] : " + e.toString());
	}

%>

<script>
	function goPage(varPageNo) {
		document.location = "/reqsubmit/70_organchargesh/PopupRelOrgan4OrganId.jsp?InOutMode=<%=InOutMode%>&OrganNm=<%=strOrganNm%>&Juso1=<%=strJuso1%>&Juso2=<%=strJuso2%>&TelNum=<%=strTelNum%>&HomeUrl=<%=strHomeUrl%>&OrganId=<%=strOrganId%>&curPage="+varPageNo;
	}
</script>



					  
<table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr class="td_join"> 
          <td width="101" height="2"></td>
          <td width="247" height="2"></td>
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
      </table>
