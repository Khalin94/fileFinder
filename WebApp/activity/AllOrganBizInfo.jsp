<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="kr.co.kcc.bf.config.*" %>
<%@ page import="kr.co.kcc.pf.util.PageCount" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<jsp:include page="/inc/header.jsp" flush="true"/>

<%@ include file="/common/CheckSession.jsp" %>

<%-- ��з� ����� ��ȸ�Ѵ�. --%>
<%
	String strTotal = "";
	String strCurrentPage = StringUtil.getNVL(request.getParameter("strCurrentPage"), "1");
	String strCountPerPage;

	// �ý��� ��ü������ �������� row�� ������ property�� ���Ͽ� ����Ѵ�.
	// ���� Ư�������������� row�� ������ �����ϰ� ������ �Ʒ� catch���� Ȱ���Ѵ�.
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
 **** ���� ���� Left menu �������� ���� �޴��� ������ �ʿ���. ****
<iframe frameborder=0 width='95%'  height='100%' leftmargin='0' rightmargin='0' topmargin='0' src="./businfo/BusInfoIndex.jsp?docbox_id=<%=strDocboxId%>&organ_id=<%=strOrganId%>" scrolling=auto ></iframe>
-->
        </div>
        <div id="rightCon">
            <!-- pgTit -->
            <div id="pgTit" style="background:url(/images2/foundation/stl_bg_my.jpg) no-repeat left top;">
                <h3>�ҼӺμ��ڷ���ȸ <!-- <span class="sub_stl" >- �󼼺���</span> --></h3>
                <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> > ���������� > �ҼӺμ��ڷ���ȸ</div>
                <p><!--����--></p>
            </div>
            <!-- /pgTit -->

            <!-- contents -->

            <div id="contents">

                <!-- �������� ���� -->

                <div class="myP">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
                        <thead>
                            <tr>
                                <th scope="col">����</th>
                                <th scope="col" style="width:400px; ">ũ��</th>
                                <th scope="col">������</th>
                                <th scope="col">����Ͻ�</th>
                                <th scope="col">�����</th>
								<th scope="col">�ҼӺμ�</th>
                            </tr>
                        </thead>
                        <tbody>
						<%@ include file="businfo/AllOrganBizInfoProc.jsp" %>
                        </tbody>
                    </table>

                    <!-- /list -->

                    <!-- ����¡-->
					<table  align="center">
						<tr>
							<td height="35" align="center" valign="middle"><div align="center">
								<%= PageCount.getLinkedString(strTotal , strCurrentPage, strCountPerPage) %>
							</div></td>
						</tr>
					</table>
                    <!-- /����¡-->
                    <!-- <p class="warning">* �䱸���� �߼��ϰ� �Ǹ� �ش� ���� ��� ��ǥ ����ڿ��� ���� �߼۵Ǹ�, ����ڰ� ���� ���� �ۼ� �� �䱸�Կ� �״�� �����ְ� �˴ϴ�. </p>
                <p class="warning">* �䱸�� �߼� ��ư�� �̿��Ͻñ� ���ؼ��� ����ȸ�� ������ �ֽñ� �ٶ��ϴ�. </p>-->

                    <!-- ����Ʈ ��ư-->
                    <div id="btn_all" > <!-- ����Ʈ �� �˻� -->
					<form name="form_duty" method="post" action="./AllOrganBizInfo.jsp">
					<input type="hidden" name="strCurrentPage" value="<%=strCurrentPage%>">
					<input type="hidden" name="gubn" value="">
                        <div class="list_ser" >
                            <select name="gubun" class="selectBox5">
								<option value="1" <%=strSelected1%> >��ü</option>
								<option value="2" <%=strSelected2%> >���ϸ�</option>
								<option value="3" <%=strSelected3%> >���</option>
								<option value="4" <%=strSelected4%> >�ۼ���</option>
								<option value="5" <%=strSelected5%> >�ҼӺμ�</option>
							  </select>
							  <input name="search" type="text" class="li_input"  value="<%=strSearch%>" style="WIDTH: 100px"  onKeyDown="if (event.keyCode == 13) fun_search();">
							  <a href="javascript:fun_search()"><img src="/images2/btn/bt_list_search.gif"  onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"/></a>
                         </div>
						<input type="hidden" name="organ_id" value="<%=strOrganId%>"></font>
						<input type="hidden" name="docbox_id" value="<%=strDocboxId%>"></font>
                    </form>
                    <!-- /����Ʈ ��ư-->
                    <!-- /�������� ���� -->
                </div>
                <!-- /contents -->

            </div>
        </div>
    </div>
    <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>