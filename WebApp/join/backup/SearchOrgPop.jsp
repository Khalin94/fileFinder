<%@ page language="java" contentType="text/html;charset=euc-kr" %>

<html>
<head>
<title>기관 찾기</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link href="../css/global.css" rel="stylesheet" type="text/css">
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
		 var url = "/join/SearchOrgPop.jsp?srchWord=<%=srchWord%>"+"&curPage="+varPageNo;
		 document.location = url;
	}

function selectOrgan(organId,organNm) {
	if (opener != null) {
		opener.selectOrgan(organId, organNm);
		window.close();
	}
}
</script>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onload="init()";>
<table width="500" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td width="14">&nbsp;&nbsp;&nbsp;</td>
    <td width="386" height="10"><img src="../image/common/spacer.gif" width="10" height="15"></td>
  </tr>
  <tr> 
    <td width="14">&nbsp;</td>
    <td height="23"><img src="../image/join/icon_sqaure.gif" width="3" height="6">&nbsp;<span class="lm_join">기관찾기</span></td>
  </tr>
  <tr> 
    <td width="14"></td>
    <td height="14"></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td height="2"><table width="97%" border="0" cellspacing="0" cellpadding="0">
        <td height="2" colspan="3" class="tbl-line"></td>
        </tr>
        <tr > 
          <td width="94" height="30"  class="td_gray1"><img src="../image/common/icon_sqaure_grary.gif" width="3" height="6">&nbsp; 
            기관명</td>
         
			<form action="/join/SearchOrgPop.jsp" method="post" name="frmSearchOrganPop">
			 <td width="270" height="30"  class="td_lmagin" >
			<div align="left"> 
              <input name="srchWord" type="text" class="input" style="WIDTH: 250px" value="<%=srchWord%>" >
			</div>
			 </td>
			</form>
           
          <td width="105" ><img src="../image/button/bt_refer.gif" width="50" height="20" onclick="checkValidation(this.document.frmSearchOrganPop);" style="cursor:hand"></td>
        </tr>
        <td height="2" colspan="3" class="tbl-line"></td>
        </tr>
      </table></td>
  </tr>
  <tr> 
    <td width="14">&nbsp;</td>
    <td height="2"></td>
  </tr>
  <tr> 
    <td width="14">&nbsp;</td>
    <td height="23" align="left" valign="top"><table width="97%" height="210" border="0" cellpadding="0" cellspacing="0">
        <tr>
          <td valign="top">




			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr> 
				<td colspan="4" class="td0_1" height="3"></td>
			  </tr>
			  <tr> 
				<td width="18%" height="21" align="center" class="td0_2">SEQ</td>
				<td width="21%" height="21" align="center" class="td0_2">기관명</td>
				<td width="24%" height="21" align="center" class="td0_2">구분</td>
				<td width="37%" align="center" class="td0_2">전화번호</td>
			  </tr>
			  <%
			  if(objArySearchOrgan != null){
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
						
			  %>



			  <tr align="center" onMouseOver="this.style.backgroundColor='#f4f4f4'" OnMouseOut="this.style.backgroundColor=''"> 
				<td height="22"><%=strRowNum%></td>
				<td height="22"><a href ="javascript:selectOrgan('<%=strOrganId%>','<%=strOrganNm%>');"><%=strOrganNm%></a></td>
				<td height="22"><%=strOrganId%></td>
				<td height="22"><%=strTelNum%></td>
			  </tr>
			  <tr> 
				<td height="1" colspan="4" class="tbl-line"></td>
			  </tr>

			  <% 
				  } 
				}
			%>
			</table>

		 </td>
          </tr>
      </table></td>
  </tr>
  <tr> 
    <td width="14">&nbsp;</td>
    <td height="40" align="left">
	<table width="96%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td align="right"><%=PageCount.getLinkedString(totalCnt , curPage, numPerPage) %>		  </td>
        </tr>
      </table>
	  </td>
  </tr>
  <tr align="right"> 
    <td height="25" colspan="2" class="td_gray1">&nbsp;<a href="javascript:self.close()"><img src="../image/button/bt_close.gif" width="46" height="11" border="0"></a>&nbsp;&nbsp;</td>
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