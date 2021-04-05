<%@ page language="java" contentType="text/html;charset=euc-kr" %>

<html>
<head>
<title>기관 찾기</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link href="/css/System.css" rel="stylesheet" type="text/css">
<script src="/js/common.js"></script>
<script src="/js/validate.js" ></script>
</head>


<%@ page import = "java.util.*" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="kr.co.kcc.pf.util.PageCount" %>
<%@ page import="kr.co.kcc.bf.config.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>

<%

	Hashtable objHshSearchOrganList = new Hashtable();
	nads.dsdm.app.reqsubmit.delegate.searchrelorgan.SearchOrganDelegate objSearchOrgan = new nads.dsdm.app.reqsubmit.delegate.searchrelorgan.SearchOrganDelegate();
	ArrayList objArySearchOrgan = new ArrayList();

	String srchWord = request.getParameter("srchWord"); 
	srchWord = srchWord == null ? "":srchWord;


	String curPage = StringUtil.getNVL(request.getParameter("curPage"), "1");	//현재 페이지
	String numPerPage="";	
	String totalCnt="0";
	String strRelCd = request.getParameter("RelCd");
	Hashtable objHshParam = new Hashtable();

	


	try{
		Config objConfig = PropertyConfig.getInstance();
		numPerPage = objConfig.get("page.rowcount");

		
		objHshParam.put("OrganKind","006");
		objHshParam.put("OrganGbn","001");
		objHshParam.put("SttCd","001");
		objHshParam.put("GovGbn","N");
		objHshParam.put("Type","OutOrganList");
		objHshParam.put("SrchWord",srchWord);
		objHshParam.put("CurPage",curPage);
		objHshParam.put("NumPerPage",numPerPage);

		objArySearchOrgan = objSearchOrgan.getRelOrgan(objHshParam);

	}catch (ConfigException objConfigEx) {
		numPerPage = StringUtil.getNVL(request.getParameter("strCountPerPage"), "10");
	}catch(Exception e){
		out.print("[JSP] : " + e.toString());
	}


%>
<script>
	function goPage(varPageNo) {
		 var url = "/join/SearchOrg4Guide.jsp?srchWord=<%=srchWord%>"+"&curPage="+varPageNo;
		 document.location = url;
	}

function selectOrgan(organId,organNm, organNo) {
	if (opener != null) {
		opener.selectOrgan(organId, organNm, organNo);
		window.close();
	}
}
</script>


<script language="javascript">
<!--

/*[added by kikang]*/
function initSize()
{	
	try 
	{
		window.resizeTo(528, 465);	
	}
	catch (err) 
	{}
}

//-->
</script>


<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onload="init(); initSize();">
<table width="500" border="0" cellspacing="0" cellpadding="0">

  <tr height="10" align="left" valign="top"> 
    <td height="10"><img src="../image/guide/blank.gif" width="24" height="2"></td>
    <td width="478" height="10"><img src="../image/guide/searchOrg_tit.gif" width="478" height="19"></td>
  </tr>


  <tr height="15" align="left" valign="top"> 
    <td height="15">&nbsp;</td>
    <td height="15">&nbsp;</td>
  </tr>


  <tr> 
    <td>&nbsp;</td>
    <td height="2"><table width="97%" border="0" cellpadding="0" cellspacing="1" bgcolor="CCCCCC">
        <tr> 
          <td height="45" align="center" bgcolor="#F3F3F3"><table width="79%" border="0" cellspacing="3" cellpadding="0">
              <tr> 
                <td width="20%" align="left"><img src="../image/common/icon_nemo_gray.gif" width="3" height="6" align="absmiddle"> 
                  <strong>기관명 </strong></td>
			<form action="/join/SearchOrg4Guide.jsp" method="post" name="frmSearchOrganPop">
			 <td width="59%"  align="left" ><strong>
			
              <input name="srchWord" type="text" class="textfield" style="WIDTH: 200px" value="<%=srchWord%>" >
			</strong>
			 </td>
			</form>

                <td width="31%" align="left"><strong><img src="../image/button/bt_inquiry.gif" width="43" height="20" align="absmiddle" onclick="checkValidation(this.document.frmSearchOrganPop);" style="cursor:hand"></strong></td>
              </tr>
            </table></td>
        </tr>
      </table></td>
  </tr>
  
  <tr> 
    <td width="14">&nbsp;</td>
    <td height="1"></td>
  </tr>
  <tr> 
    <td width="14">&nbsp;</td>
    <td height="10" align="left" valign="top"><table width="97%" height="110" border="0" cellpadding="0" cellspacing="0">
        <tr>
          <td valign="top">




			<table width="100%" border="0" cellspacing="0" cellpadding="0">		
              <tr height="2" class="td_board"> 
                <td height="2"></td>
                <td height="2"></td>
                <td height="2"></td>
                <td height="2"></td>
              </tr>			
			  <tr> 
                <td width="11%" height="22" align="center" valign="middle" class="td_top">SEQ</td>
                <td width="41%" height="22" align="center" valign="middle" class="td_top">기관명</td>
                <td width="24%" height="22" align="center" valign="middle" class="td_top">구분</td>
                <td width="24%" height="22" align="center" valign="middle" class="td_top">전화번호</td>
			  </tr>
              <tr height="1" class="td_board"> 
                <td height="1"></td>
                <td height="1"></td>
                <td height="1"></td>
                <td height="1"></td>
              </tr>
			  <%
			  if(objArySearchOrgan != null && objArySearchOrgan.size() > 1){
					if( objArySearchOrgan.size()>0){
						objHshSearchOrganList = (Hashtable)objArySearchOrgan.get(0);
						totalCnt = (String)objHshSearchOrganList.get("TOTALCNT");
						out.println("전체:"+totalCnt);
					}
			 			
					for(int i=1;i < objArySearchOrgan.size();i++){
						objHshSearchOrganList = (Hashtable)objArySearchOrgan.get(i);
						String strRowNum = (String)objHshSearchOrganList.get("TOTALCNT");
						String strOrganNm = (String)objHshSearchOrganList.get("ORGAN_NM");
						String strOrganId = (String)objHshSearchOrganList.get("ORGAN_ID");
						String strTelNum = (String)objHshSearchOrganList.get("TEL_NUM");
						String strOrganNo = (String)objHshSearchOrganList.get("ORGAN_NO");					
			  %>
			  <tr align="center" onMouseOver="this.style.backgroundColor='#FCFDF0'" OnMouseOut="this.style.backgroundColor=''"> 
				<td height="22"><%=strRowNum%></td>
				<td height="22"><a href ="javascript:selectOrgan('<%=strOrganId%>','<%=strOrganNm%>', '<%=strOrganNo%>');"><%=strOrganNm%></a></td>
				<td height="22"><%=strOrganId%></td>
				<td height="22"><%=strTelNum%></td>
			  </tr>
              <tr> 
                <td height="1" colspan="4" class="tbl-line"></td>
              </tr>
			  <% 
				  } 
				}else{
			%>
			  <tr align="center" onMouseOver="this.style.backgroundColor='#FCFDF0'" OnMouseOut="this.style.backgroundColor=''"> 
				<td height="22" colspan=4>해당기관정보를 해당위원회로 신청 해야 합니다.</td>
			  </tr>
              <tr> 
                <td height="1" colspan="4" class="tbl-line"></td>
              </tr>
			<%
				}
			%>
			  <tr> 
                <td height="1" colspan="4" class="tbl-line"></td>
              </tr>
			</table>
		 </td>
          </tr>
      </table></td>
  </tr>
  <tr> 
    <td width="14">&nbsp;</td>
    <td height="40" align="center">
	<table width="96%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td align=center><%=PageCount.getLinkedString(totalCnt , curPage, numPerPage) %>		  </td>
        </tr>
      </table>
	  </td>
  </tr>

</table>
</body>
</html>
<script language="javascript">

function init()
{
	
	// 필수입력
	define('srchWord', 'string', '검색어', 1);	



}
function checkValidation(frm)
{


	if( OnValidationSubmit() == true)
	{
		
		frm.method = "post";
		frm.submit();
	}


}

</script>





