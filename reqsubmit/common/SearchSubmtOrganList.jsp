<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.bf.config.*"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%
 /*************************************************************************************************/
 /** 					파라미터 체크 Part 														  */
 /*************************************************************************************************/
  /** 검색어(제출기관명) */
  String strSubmtOrganNm=StringUtil.getEmptyIfNull(request.getParameter("SubmtOrganNm"));
%>
<% 
 /*************************************************************************************************/
 /** 					데이터 호출 Part 														  */
 /*************************************************************************************************/

 /*** Delegate 과 데이터 Container객체 선언 */
 ResultSetHelper objRs=null;	/* 제출기관목록 */
 
 /** 검색어가 있는 경우만 */
 if(StringUtil.isAssigned(strSubmtOrganNm)){
	 try{
	   OrganInfoDelegate objOrganInfo=new OrganInfoDelegate();
	   objRs=new ResultSetHelper(objOrganInfo.getSubmtOrganListByName(strSubmtOrganNm));
	 }catch(AppException objAppEx){
	 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
	  	objMsgBean.setStrCode(objAppEx.getStrErrCode());
	  	objMsgBean.setStrMsg(objAppEx.getMessage());
	  	%>
	  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
	  	<%  	
	  	return;
	 }
 }
%>
<!DOCTYPE HTML PUBLIC "-//w3c//dtd html 4.0 transitional//en">
<html>
<head>
<title>제출기관 조회</title>
<link href="/css/System.css" rel="stylesheet" type="text/css">
<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>
<SCRIPT language="JavaScript">
  /** 제출기관조회 */
  function searchSubmt(){
  	if(formName.SubmtOrganNm.value==""){
  		alert("조회할 제출기관명을 입력해주세요");
  		formName.SubmtOrganNm.focus();
  		return false;
  	}
  	formName.submit();
  }
  /** 위원회 및 제출기관 설정 */
  function setSubmtOrgan(strSubmtOrganID,strCmtOrganID){
  	opener.formName.SubmtOrganIDX.value=strSubmtOrganID;
  	if(opener.formName.CmtOrganIDX==null){
  	   opener.formName.CmtOrganID.value=strCmtOrganID;
  	}else{
  	   opener.formName.CmtOrganIDX.value=strCmtOrganID;
  	}
  	opener.formName.submit();
  	self.close();
  }
</SCRIPT>
</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="300" border="0" cellspacing="0" cellpadding="0"  scrolling="yes">
  <tr class="td_reqsubmit"> 
    <td height="5"></td>
    <td height="5"></td>
  </tr>
  <tr> 
    <td width="14" height="10"></td>
    <td width="286" height="10"></td>
  </tr>
  <tr> 
    <td width="14">&nbsp;</td>
    <td height="25" valign="middle"><img src="/image/reqsubmit/icon_reqsubmit_soti.gif" width="9" height="9" align="absmiddle"> 
      <span class="soti_reqsubmit">제출기관조회</span></td>
  </tr>
  <tr>
    <form name="formName" method="post" action="<%=request.getRequestURI()%>">
    <td width="14" height="5"></td>
    <td height="14" class="text_s">
    	<table border="0">
    	<tr>
    		<td><input type="text" value="<%=strSubmtOrganNm%>" name="SubmtOrganNm" size="28" class="textfield"></td>
    		<td><img src="/image/button/bt_inquiry.gif" height="20"  style="cursor:hand" onClick="searchSubmt();"></td>
    	</tr>
        </table>
    </td>
    </form>
  </tr>
<%
 if(objRs!=null){//검색어로 조회했을경우
%>  
  <tr> 
    <td width="14">&nbsp;</td>
    <td height="23" align="left" valign="top">
    	<TABLE cellSpacing=0 cellPadding=0 width="286" border=0>
        <TBODY>
          <TR> 
            <TD class=td_reqsubmit height=2></TD>
          </TR>
       <%
         if(objRs.getRecordSize()>0){
         	while(objRs.next()){
       %>
          <TR onmouseover="this.style.backgroundColor='#FCFDF0'"  onmouseout="this.style.backgroundColor=''"> 
            <TD height="22">
            	<a href="javascript:setSubmtOrgan('<%=objRs.getObject("SUBMT_ORGAN_ID")%>','<%=objRs.getObject("CMT_ORGAN_ID")%>')"><%=objRs.getObject("SUBMT_ORGAN_NM")%>(<%=objRs.getObject("CMT_ORGAN_NM")%>)</a>
            </TD>
          </TR>
          <TR class=tbl-line> 
            <TD height=1></TD>
          </TR>
		<%
		    }//endwhile
		  }else{
		%> 
		  <TR onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''">
			<TD align="center">조회된 제출기관이 없습니다.</TD>
		  </TR>
          <TR class=tbl-line> 
            <TD height=1></TD>
          </TR>
		<%
		}//end if 목록 출력 끝.
		%>		         
          <TR class=tbl-line> 
            <TD height=1></TD>
          </TR>
        </TBODY>
      </TABLE></td>
  </tr>
<%
 } else { //endif 목록조회.
%>
 	<tr>
 		<td height="158"></td>
 	</tr>
<%
 }
%>  
  <tr> 
    <td height="25" colspan="2" align="right" class="td_gray1">&nbsp;<img src="/image/button/bt_close.gif" width="46" height="11" border="0" style="cursor:hand" onClick="self.close();">&nbsp;&nbsp;</td>
  </tr>
</table>
</body>
</html>  
