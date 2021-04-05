<!--
**      Program Name : ISearch_Anslist.jsp
**      Program Date : 2004. 05.19.
**      Last    Date : 2004. 05.19.
**      Programmer   : Kim Kang Soo
**      Description  : 자료제출검색의 제출기관찾기를 우편번호 인터페이스로 구현
**
**      1)초기화면에 모든 데이터를 뿌려주고 시작하는것이 특징임
-->
<%@ page import="nads.dsdm.app.infosearch.common.IsSelectDelegate" %>
<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="nads.lib.message.MessageBean"%>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%@ include file="utils.jsp" %>
<html>
<head>
<title>제출기관 찾기</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link href="../css/System.css" rel="stylesheet" type="text/css">
<script language="JavaScript">
 function ReturnCode(str){
	opener.document.PageForm.ans_organ_select.value=str;	
	window.close();
 }
 function search()
{
	document.PageForm.submit();
}
 
</script>
</head>
<%
	String ans_list = nads.lib.reqsubmit.util.StringUtil.getEmptyIfNull(request.getParameter("ans_list")); 	
	if(ans_list==null) ans_list = "";
	ans_list = ans_list.trim();

	ArrayList objArr;
	IsSelectDelegate objCMD = new IsSelectDelegate();


//	if (!ans_list.equals("")){

		try {//제출기관 우편번호식 찾기
	
			objArr = objCMD.selectAns_Organ_Keyword(ans_list);
	
		} catch (AppException objAppEx) {
		
		// 에러 발생 메세지 페이지로 이동한다.
	 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
	  	objMsgBean.setStrCode(objAppEx.getStrErrCode());
	  	objMsgBean.setStrMsg(objAppEx.getMessage());
		System.out.println(objAppEx.getStrErrCode());
	%>
	  	<jsp:forward page="/common/message/ViewMsg.jsp"/>	
	<%	
			return;
		}
//	}
%>
<form  method=post name=PageForm action=./ISearch_Anslist.jsp >

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="500" border="0" cellspacing="0" cellpadding="0" scrolling="yes">
  <tr class="td_infosearch"> 
    <td height="5"></td>
    <td height="5"></td>
  </tr>
  <tr> 
    <td width="15" height="10"></td>
    <td width="485" height="10"></td>
  </tr>
  <tr> 
    <td width="15">&nbsp;</td>
    <td height="25" valign="middle"><img src="../image/infosearch/icon_infosearch_soti.gif" width="9" height="9" align="absmiddle"> 
      <span class="soti_infosearch"> 제출기관 찾기</span></td>
  </tr>
  <tr> 
    <td height="10"></td>
    <td height="10"></td>
  </tr>
  <tr> 
    <td width="15" height="5"></td>
    <td height="14" class="text_s"><table width="97%" border="0" cellpadding="0" cellspacing="1" bgcolor="CCCCCC">
        <tr> 
          <td height="35" align="center" bgcolor="#F3F3F3"><table width="75%" border="0" cellspacing="3" cellpadding="0">
              <tr> 
                <td width="19%" align="left"><img src="../image/common/icon_nemo_gray.gif" width="3" height="6"> 
                  <strong>제출기관</strong></td>
                <td width="60%" align="left"><strong> 
                  <input name="ans_list" type="text" class="textfield" style="WIDTH: 200px" >
                  </strong></td>
                <td width="21%" align="left"><strong><a href="javascript:search();"><img src="../image/button/bt_refer_icon.gif" width="47" height="19" align="absmiddle" border=0></a></strong></td>
              </tr>
            </table></td>
        </tr>
      </table></td>
  </tr>
  <tr> 
    <td width="15" height="10"></td>
    <td height="10"></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td height="23" align="left">&nbsp;제출기관을 Click하세요.</td>
  </tr>
  <tr> 
    <td width="15">&nbsp;</td>
    <td height="23" valign="top"><table width="97%" border="0" cellspacing="0" cellpadding="0">
        <tr height="2"> 
          <td height="2" class="td_infosearch"></td>
        </tr>
        <tr> 
          <td height="22" align="center" class="td_top">제출기관</td>
        </tr>
        <tr height="1"> 
          <td height="1" class="td_infosearch"></td>
        </tr>

<%
		if(objArr.size() == 0){

         out.println("<tr>");
         out.println("<td align='center'>검색결과가 없습니다.</td>");
         out.println("</tr>");
         }


		for (int i = 0; i < objArr.size(); i++) {
			Hashtable objHashBSorts = (Hashtable)objArr.get(i);
%>
        <tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''"> 
          <td height="25" class="td_lmagin"><a href="javascript:ReturnCode('<%=objHashBSorts.get("ORGAN_ID")%>')"><%=objHashBSorts.get("ORGAN_NM")%></a></td>
        </tr>
<%}%>
        <tr class="tbl-line"> 
          <td height="2"></td>
        </tr>
      </table></td>
  </tr>
  <tr> 
    <td width="15" height="20">&nbsp;</td>
    <td height="20" align="left">&nbsp;</td>
  </tr>
  <tr> 
    <td height="25" colspan="2" align="right" class="td_gray1">&nbsp;<a href="javascript:self.close()"><img src="../image/button/bt_close.gif" width="46" height="11" border="0"></a>&nbsp;&nbsp;</td>
  </tr>
</table>
</body>
</form>
</html>


