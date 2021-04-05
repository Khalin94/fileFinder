<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="kr.co.kcc.bf.config.*" %>
<%@ page import="kr.co.kcc.pf.util.PageCount" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%@ include file="/common/CheckSession.jsp" %>
<%-- 대분류 목록을 조회한다. --%>
<%
	String strCurrentPage = StringUtil.getNVL(request.getParameter("strCurrentPage"), "1");
	String strCountPerPage;
	
	// 시스템 전체적으로 페이지당 row의 갯수는 property로 정하여 사용한다.
	// 만일 특정페이지에서만 row의 갯수를 변경하고 싶으면 아래 catch문을 활용한다.
	nads.dsdm.app.activity.businfo.BusInfoDelegate objBusInfoDelegate = new nads.dsdm.app.activity.businfo.BusInfoDelegate();	
	String strUserId = (String)session.getAttribute("USER_ID");
	
	String strDocboxId = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVL(request.getParameter("docbox_id"), ""));
	String strGubn = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVL(request.getParameter("gubun"), ""));
	String strOrganId = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVL(request.getParameter("organ_id"), ""));
	String strSearch = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVL(request.getParameter("search"), ""));
	try {
		Config objConfig = PropertyConfig.getInstance();
		strCountPerPage = objConfig.get("page.rowcount");
	}
	catch (ConfigException objConfigEx) {
		strCountPerPage = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVL(request.getParameter("strCountPerPage"), "10"));
	}
%>	
<html>
<head>
<title>의정자료 전자유통 시스템</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link href="../css/System.css" rel="stylesheet" type="text/css">
</head>

<script language="javascript">
	function fun_down() {

	}  	

	function fun_search(){
		document.form_duty.strCurrentPage.value = '1';
		document.form_duty.submit();
	}

	function fun_organleft(strDocboxId, strOrganId){  	
		strTmp = "/activity/BizInfo.jsp?docbox_id=" + strDocboxId + "&organ_id=" + strOrganId;
		parent.location.href = strTmp
	}  
  
	function fun_open(strOrganId){ 	
		strTmp = "/activity/OpenBizInfo.jsp?organ_id=" + strOrganId
		parent.location.href = strTmp
	}    
			  
	function goPage(varPageNo) {
		document.form_duty.strCurrentPage.value = varPageNo;
		document.form_duty.action = "OpenBizInfo.jsp";
		document.form_duty.submit();
	}  			
</script>
<script src='/js/activity.js'></script>
<SCRIPT LANGUAGE="JavaScript" src="/js/bustree.js"></SCRIPT>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<%@ include file="/common/TopMenu.jsp" %>
<table width="100%" height="508" border="0" cellpadding="0" cellspacing="0">
  <tr align="left" valign="top">
    <td width="186" height="508" background="../image/common/bg_leftMenu.gif">
	<%@ include file="/activity/businfo/BusInfoDeptProc.jsp" %></td>
	</td>
    <td width="100%"><table width="100%" border="0" cellspacing="0" cellpadding="0">
         <tr height="24" valign="top"> 
          <td height="24" colspan="2" align="left"><table width="789" height="24" border="0" cellpadding="0" cellspacing="0" bgcolor="E2ECF3">
              <tr>
                <td height="24"></td>
              </tr>
            </table></td>
        </tr>
<form name="form_duty" method="post" action="./OpenBizInfo.jsp">
<input type="hidden" name="strCurrentPage" value="<%=strCurrentPage%>">
<input type="hidden" name="gubn" value="">
        <tr valign="top">
          <td width="30" align="left"><img src="../image/common/bg_leftBody.gif" width="30" height="1"></td>
          <td align="left"><table width="759" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td height="23" align="left" valign="top"></td>
              </tr>
              <tr> 
                <td align="left" valign="top"><table width="100%" height="23" border="0" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="10%" background="../image/mypage/bg_mypage_tit.gif"><span class="title">업무 
                        정보</span></td>
                      <td width="30%" align="left" background="../image/common/bg_titLine.gif">&nbsp;</td>
                      <td width="60%" align="right" background="../image/common/bg_titLine.gif" class="text_s"><img src="../image/common/icon_navi.gif" width="3" height="5" align="absmiddle"> 
                        Home&gt;나의페이지&gt;<strong>부서업무정보</strong></td>
                    </tr>
                  </table></td>
              </tr>
              <tr> 
                <td height="30" align="left" class="text_s">개인 업무 관련 자료를 등록, 활용 
                  하실 수 있습니다.(공개업무정보)</td>
              </tr>
              <tr> 
                <td height="5" valign="top"></td>
              </tr>
              <tr height="5"> 
                <td height="8" align="left"></td>
              </tr>
              <tr> 
                <td align="left" valign="top"><table width="759" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td height="2" colspan="6" class="td_mypage"></td>
                    </tr>
                    <tr class="td_top"> 
                      <td width="45" height="22" align="center">&nbsp;</td>
                      <td width="286" height="22" align="center">제목</td>
                      <td width="69" height="22" align="center">크기</td>
                      <td width="166" height="22" align="center">등록일시</td>
                      <td width="83" height="22" align="center">등록자</td>
                      <td width="110" height="22" align="center">소속부서</td>
                    </tr>
                    <tr> 
                      <td height="1" colspan="6" class="td_mypage"></td>
                    </tr>
					<%@ include file="businfo/OpenBizInfoProc.jsp" %>
                  </table></td>
              </tr>
              <tr> 
                <td height="35" align="center" valign="middle"><div align="center">
                  <%= PageCount.getLinkedString(strTotal , strCurrentPage, strCountPerPage) %>
                </div></td>
              </tr>
              <tr height="3"> 
                <td height="3" align="left" valign="top" background="../image/common/line_table.gif"></td>
              </tr>
              <tr> 
                <td height="40" align="left" valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td width="314" align="right" valign="middle"><div align="right"> 
                          <select name="gubun" class="select">
                            <option value="1">전체</option>
                            <option value="2">파일명</option>
                            <option value="3">요약</option>
                            <option value="4">작성자</option>
                            <option value="5">소속부서</option>
                          </select>
                          <input name="search" type="text" class="textfield" style="WIDTH: 180px"  onKeyDown="if (event.keyCode == 13) fun_search();">
                          <a href="javascript:fun_search()"><img src="../image/common/bt_search_table.gif" width="51" height="18" align="absmiddle" border="0"></a></div></td>
                    </tr>
                  </table></td>
              </tr>
              <tr> 
                <td height="35" align="left" valign="top">&nbsp;</td>
              </tr>
            </table></td>
        </tr>
      </table></td>
  </tr>
<input type="hidden" name="organ_id" value="<%=strOrganId%>"></font>
<input type="hidden" name="docbox_id" value="<%=strDocboxId%>"></font>
</form>
</table>
<%@ include file="../common/Bottom.jsp" %>
</body>
</html>
