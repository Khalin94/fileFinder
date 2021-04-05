<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="kr.co.kcc.bf.config.*" %>
<%@ page import="kr.co.kcc.pf.util.PageCount" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<jsp:include page="/inc/header.jsp" flush="true"/>

<%@ include file="/common/CheckSession.jsp" %>

<%-- 대분류 목록을 조회한다. --%>
<%
	String strTotal = "";
	String strCurrentPage = StringUtil.getNVL(request.getParameter("strCurrentPage"), "1");
	String strCountPerPage;

	// 시스템 전체적으로 페이지당 row의 갯수는 property로 정하여 사용한다.
	// 만일 특정페이지에서만 row의 갯수를 변경하고 싶으면 아래 catch문을 활용한다.
	nads.dsdm.app.activity.businfo.BusInfoDelegate objBusInfoDelegate = new nads.dsdm.app.activity.businfo.BusInfoDelegate();
	String strUserId = (String)session.getAttribute("USER_ID");

	String strDocboxId = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVL(request.getParameter("docbox_id"), ""));
	String strGubn = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVL(request.getParameter("gubun"), "0"));
	String strOrganId = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVL(request.getParameter("organ_id"), ""));
	String strSearch = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVL(request.getParameter("search"), ""));

	String strSelected1 = "";
	String strSelected2 = "";
	String strSelected3 = "";
	String strSelected4 = "";
	String strSelected5 = "";


	try {
		switch(Integer.parseInt(strGubn)){
			case 1:
				strSelected1 = "selected";
				break;
			case 2:
				strSelected2 = "selected";
				break;
			case 3:
				strSelected3 = "selected";
				break;
			case 4:
				strSelected4 = "selected";
				break;
			case 5:
				strSelected5 = "selected";
				break;
		}
		Config objConfig = PropertyConfig.getInstance();
		strCountPerPage = objConfig.get("page.rowcount");
	}
	catch (ConfigException objConfigEx) {
		strCountPerPage = StringUtil.getNVL(request.getParameter("strCountPerPage"), "10");
	}
%>
<script language="javascript">
	function fun_search(){
		document.form_duty.strCurrentPage.value = '1';
		document.form_duty.submit();
	}

	function goPage(varPageNo) {
		document.form_duty.strCurrentPage.value = varPageNo;
		document.form_duty.action = "OpenBizInfo.jsp";
		document.form_duty.submit();
	}
</script>
<script src='/js/activity.js'></script>
<SCRIPT LANGUAGE="JavaScript" src="/js/bustree.js"></SCRIPT>

</head>
<div id="wrap">
    <jsp:include page="/inc/top.jsp" flush="true"/>
    <jsp:include page="/inc/top_menu01.jsp" flush="true"/>
    <div id="container">
        <div id="leftCon">
            <jsp:include page="/inc/log_info.jsp" flush="true"/>
            <jsp:include page="/inc/left_menu01_data.jsp" flush="true"/>
<!--
 **** 기존 별도 Left menu 구성으로 현재 메뉴와 통합이 필요함. ****
<iframe frameborder=0 width='95%'  height='100%' leftmargin='0' rightmargin='0' topmargin='0' src="./businfo/BusInfoIndex.jsp?docbox_id=<%=strDocboxId%>&organ_id=<%=strOrganId%>" scrolling=auto ></iframe>
-->
        </div>
        <div id="rightCon">
            <!-- pgTit -->
            <div id="pgTit" style="background:url(/images2/foundation/stl_bg_my.jpg) no-repeat left top;">
                <h3>소속부서자료조회 <!-- <span class="sub_stl" >- 상세보기</span> --></h3>
                <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> > 나의페이지 > 소속부서자료조회</div>
                <p><!--문구--></p>
            </div>
            <!-- /pgTit -->

            <!-- contents -->

            <div id="contents">

                <!-- 각페이지 내용 -->

                <div class="myP">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
                        <thead>
                            <tr>
                                <th scope="col">제목</th>
                                <th scope="col" style="width:400px; ">크기</th>
                                <th scope="col">폴더명</th>
                                <th scope="col">등록일시</th>
                                <th scope="col">등록자</th>
								<th scope="col">소속부서</th>
                            </tr>
                        </thead>
                        <tbody>
						<%@ include file="businfo/AllOrganBizInfoProc.jsp" %>
                        </tbody>
                    </table>

                    <!-- /list -->

                    <!-- 페이징-->
					<table  align="center">
						<tr>
							<td height="35" align="center" valign="middle"><div align="center">
								<%= PageCount.getLinkedString(strTotal , strCurrentPage, strCountPerPage) %>
							</div></td>
						</tr>
					</table>
                    <!-- /페이징-->
                    <!-- <p class="warning">* 요구서를 발송하게 되면 해당 제출 기관 대표 담당자에게 지정 발송되며, 담당자가 없는 경우는 작성 중 요구함에 그대로 남아있게 됩니다. </p>
                <p class="warning">* 요구서 발송 버튼을 이용하시기 위해서는 위원회를 선택해 주시기 바랍니다. </p>-->

                    <!-- 리스트 버튼-->
                    <div id="btn_all" > <!-- 리스트 내 검색 -->
					<form name="form_duty" method="post" action="./AllOrganBizInfo.jsp">
					<input type="hidden" name="strCurrentPage" value="<%=strCurrentPage%>">
					<input type="hidden" name="gubn" value="">
                        <div class="list_ser" >
                            <select name="gubun" class="selectBox5">
								<option value="1" <%=strSelected1%> >전체</option>
								<option value="2" <%=strSelected2%> >파일명</option>
								<option value="3" <%=strSelected3%> >요약</option>
								<option value="4" <%=strSelected4%> >작성자</option>
								<option value="5" <%=strSelected5%> >소속부서</option>
							  </select>
							  <input name="search" type="text" class="li_input"  value="<%=strSearch%>" style="WIDTH: 100px"  onKeyDown="if (event.keyCode == 13) fun_search();">
							  <a href="javascript:fun_search()"><img src="/images2/btn/bt_list_search.gif"  onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"/></a>
                         </div>
						<input type="hidden" name="organ_id" value="<%=strOrganId%>"></font>
						<input type="hidden" name="docbox_id" value="<%=strDocboxId%>"></font>
                    </form>
                    <!-- /리스트 버튼-->
                    <!-- /각페이지 내용 -->
                </div>
                <!-- /contents -->

            </div>
        </div>
    </div>
    <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>