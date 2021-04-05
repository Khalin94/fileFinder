<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.math.*" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="kr.co.kcc.bf.config.*" %>
<%@ page import="kr.co.kcc.pf.util.PageCount" %>
<%@ page import="nads.dsdm.app.common.page.PagingDelegate" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<jsp:include page="/inc/header.jsp" flush="true"/>
<%@ include file="/common/CheckSession.jsp" %>
<%
	/*** PagingDelegate */
	PagingDelegate objPaging=new PagingDelegate(); 		/*����¡ ��ȯ Delegate*/
%>
<%-- ��з� ����� ��ȸ�Ѵ�. --%>
<%
	String strUserId = (String)session.getAttribute("USER_ID");

	String strCurrentPage = nads.lib.reqsubmit.util.StringUtil.getEmptyIfNull(request.getParameter("strCurrentPage"), "1");
	String strSelectedOrganNm = nads.lib.reqsubmit.util.StringUtil.getEmptyIfNull(request.getParameter("organ_nm"), "���õ� �μ��� �����ϴ�.");
	String strCountPerPage;

	nads.dsdm.app.activity.businfo.BusInfoDelegate objBusInfoDelegate = new nads.dsdm.app.activity.businfo.BusInfoDelegate();
	String strDocboxId = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVL(request.getParameter("docbox_id"), ""));
	String strOrganId   = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVL(request.getParameter("organ_id"), ""));

	String strGubn = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVL(request.getParameter("gubun"), "1"));
	String strContent = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVL(request.getParameter("search"), ""));
	String strPriOrganNm = "";    //�����޴����� Ŭ���� �����
	String strPriDocboxNm = "";    //�����޴����� Ŭ���� �з��Ը�
	String strTotalSize = "";
	String strUsedSize = "";
	String strTotalCnt = "";
	String strPath = "";

	String strSelected1 = "";
	String strSelected2 = "";
	String strSelected3 = "";
	String strSelected4 = "";

	double dTotalSize = 0;
	double dUsedSize = 0;

	float fPer = 0;

	// �ý��� ��ü������ �������� row�� ������ property�� ���Ͽ� ����Ѵ�.
	// ���� Ư�������������� row�� ������ �����ϰ� ������ �Ʒ� catch���� Ȱ���Ѵ�.
	try {
		Config objConfig = PropertyConfig.getInstance();
		strCountPerPage = objConfig.get("page.rowcount");

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
		}

		/*****�μ��� ��ȸ�Ѵ�.*****/
		Vector objParamVt = new Vector();
		if(!strOrganId.equals("")){
			objParamVt.add(strOrganId) ;
			objParamVt.add(strOrganId) ;
			objParamVt.add(strUserId) ;
			objParamVt.add(strOrganId) ;
		 	Hashtable objOrganHt = objBusInfoDelegate.selectOrganSize(objParamVt);
		 	strPriOrganNm = (String)objOrganHt.get("ORGAN_NM");
		 	strTotalSize = (String)objOrganHt.get("DUTY_SIZE");
		 	strUsedSize = (String)objOrganHt.get("SUM_SIZE");
		 	String strOrgGbn = (String)objOrganHt.get("ORG_POSI_GBN");
		 	if(!strOrgGbn.equals("1")){
		 		strPriOrganNm = "(�⹫)" + strPriOrganNm;
		 	}

		 	dTotalSize = (double)Math.round(Double.parseDouble(strTotalSize)/1024/1024 * 100)/100;
		 	dUsedSize = (double)Math.round(Double.parseDouble(strUsedSize)/1024/1024 * 100)/100;

			if(!strTotalSize.equals("0") && dTotalSize == 0.00){
				dTotalSize = 0.01;
			}
			if(!strUsedSize.equals("0") && dUsedSize == 0.00){
				dUsedSize = 0.01;
			}
		 	fPer = (Float.parseFloat(strUsedSize)/Float.parseFloat(strTotalSize)) * 100;

		 	//�з����̸� ��ȸ
		 	if(strDocboxId != null){
		 		objParamVt.clear() ;
		 		objParamVt.add(strDocboxId) ;
		 		Hashtable objDocboxNmHt = objBusInfoDelegate.selectDocboxNm(objParamVt);
		 		strPriDocboxNm = (String)objDocboxNmHt.get("DOCBOX_NM");
		 		if(strPriDocboxNm != null){
		 			strPath = strPriOrganNm + "-->" + strPriDocboxNm;
		 		}else{
		 			strPath = strPriOrganNm;
		 		}
		 	}else{
		 		strPath = strPriOrganNm;
		 	}
		 }

	}
	catch (ConfigException objConfigEx) {
		strCountPerPage = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVL(request.getParameter("strCountPerPage"), "10"));
	}
%>


<script language="javascript">
	function fun_getstrings(obj){
		var varStrings = "";
		if(obj!= null){
			if(obj.length == undefined){
				if(obj.checked){
					varStrings = varStrings + obj.value;
				}
			}else{
				varCnt = obj.length;
				for(var i=0; i<varCnt; i++){
					if(obj[i].checked){
						if(varStrings != ""){
							varStrings = varStrings + ',' + obj[i].value;
						}else{
							varStrings = obj[i].value;
						}
					}
				}
			}
		}
		return varStrings;
	}

	function fun_checked(obj){
		var varCheckNum = 0;
		if(obj!= null){
			if(obj.length == undefined){
				if(obj.checked){
					varCheckNum = parseInt(varCheckNum + 1);
				}
			}else{
				varCnt = obj.length;

				for(var i=0; i<varCnt; i++){
					if(obj[i].checked){
						varCheckNum = parseInt(varCheckNum + 1);
					}
				}
			}
		}
		return varCheckNum;
	}

	function fun_upload(strDocboxId, strOrgan_id,  strTotalSize,  strUsedSize){
		if(document.form_duty.organ_id.value == ''){
			alert('�μ��� ���õ��� �ʾҽ��ϴ�.!');
			return;
		}

		if(document.form_duty.docbox_id.value == '0')
		{
			alert('�ֻ���(�������)���� ������ ���ε��� �� �����ϴ�.!');
			return;
		}

		var url = "./FileUploadPop.jsp?total_size=" + strTotalSize
		            + "&used_size=" + strUsedSize + "&docbox_id=" + strDocboxId + "&organ_id=" + strOrgan_id ;
		window.open(url,'New','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,copyhistory=no,width=470,height=440,left=0,top=0');
	}

	function fun_create(strDocboxId, strOrgan_id){
		if(document.form_duty.organ_id.value == ''){
			alert('�μ��� ���õ��� �ʾҽ��ϴ�.!');
			return;
		}

		var url = "./FolderCreatePop.jsp?docbox_id=" + strDocboxId + "&organ_id=" + strOrgan_id;
		window.open(url,'New','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,copyhistory=no,width=385,height=179,left=0,top=0');
	}

	function fun_equaluser(strGubn, strDocboxId, strOrgan_id, strOrgan_nm){
		if(document.form_duty.organ_id.value == ''){
			alert('�μ��� ���õ��� �ʾҽ��ϴ�.!');
			return;
		}

		var varDoc = fun_checked(document.form_duty.checkD);
		var varDuty = fun_checked(document.form_duty.checkF);
		var varDocStrings = "";
		var varDutyStrings = "";
		var varUrl = "";

		if(parseInt(varDoc + varDuty) < 1){
				alert('���õ� ������ �����ϴ�.');
				return;
		}
		if(strGubn == 'U'){
			if(parseInt(varDoc + varDuty) > 1){
				alert('����(����)�� �ϳ��� �����մϴ�.');
				return;
			}
			varUrl = "./FileChangePop.jsp"; //����
		}else{
			varUrl = "./FileShiftPop.jsp";  //�����̵� �� ����
		}

		if (parseInt(varDoc) > 0){
			varDocStrings = fun_getstrings(document.form_duty.checkD);
		}

		if (parseInt(varDuty) > 0){
			varDutyStrings = fun_getstrings(document.form_duty.checkF);
		}

		varUrl =  varUrl + "?gubn=" + strGubn
		           + "&docbox_id=" + strDocboxId + "&organ_id=" + strOrgan_id + "&organ_nm=" + strOrgan_nm;
		varUrl = varUrl + "&doc_id=" + varDocStrings;
		varUrl = varUrl + "&duty_id=" + varDutyStrings;
		document.form_duty.gubn.value = strGubn;

		if(strGubn == 'U'){
			window.open(varUrl,'New','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,copyhistory=no,width=400,height=176,left=0,top=0');
		}else{
			window.open(varUrl,'New','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=no,width=490,height=320,left=0,top=0');
		}
	}
	function fun_organ(strDocboxId, strOrganId){
		if(document.form_duty.organ_id.value == ''){
			alert('�μ��� ���õ��� �ʾҽ��ϴ�.!');
			return;
		}

		strTmp = "/activity/BizInfo.jsp?docbox_id=" + strDocboxId + "&organ_id=" + strOrganId;
		window.location = strTmp
	}

	function fun_down() {

	}

	function fun_search(){
		if(document.form_duty.organ_id.value == ''){
			alert('�μ��� ���õ��� �ʾҽ��ϴ�.!');
			return;
		}

		document.form_duty.strCurrentPage.value = '1';
		document.form_duty.action = "BizInfo.jsp";
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
		document.form_duty.action = "BizInfo.jsp";
		document.form_duty.submit();
	}
	function fun_clickId(varClck){
		alert(varClck);
	}


	function fun_backupcreate(vaSize){
		if(vaSize == '0.0'){
			alert('��� ���� ��������(�ڷ�)�� �����ϴ�.');
			return;
		}

		if(document.form_duty.organ_id.value == ''){
			alert('�μ��� ���õ��� �ʾҽ��ϴ�.!');
			return;
		}

		var url = "./DutyBackupCreatePop.jsp?organ_id=" + document.form_duty.organ_id.value;
		window.open(url,'BackUpFileCreate','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,copyhistory=no,width=385,height=179,left=0,top=0');
	}

	function fun_backupdown(vaSize){
		if(vaSize == '0.0'){
			alert('��� ���� ��������(�ڷ�)�� �����ϴ�.');
			return;
		}

		if(document.form_duty.organ_id.value == ''){
			alert('�μ��� ���õ��� �ʾҽ��ϴ�.!');
			return;
		}

		var url = "./DutyBackupDownPop.jsp?organ_id=" + document.form_duty.organ_id.value;
		window.open(url,'BackUpFileDownLoad','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,copyhistory=no,width=385,height=179,left=0,top=0');
	}
</script>
<script src='/js/activity.js'></script>
<SCRIPT LANGUAGE="JavaScript" src="/js/bustree.js"></SCRIPT>
</head>

<body>
<div id="tooltip" style="position:absolute;visibility:hidden"></div>
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

<form name="form_duty" method="post" action="">
<input type="hidden" name="strCurrentPage" value="<%=strCurrentPage%>">
<input type="hidden" name="gubn" value="">

            <!-- pgTit -->
            <div id="pgTit" style="background:url(/images2/foundation/stl_bg_my.jpg) no-repeat left top;">
                <h3>�μ��ڷ�� <!-- <span class="sub_stl" >- �󼼺���</span> -->

<!--  ���� ����� ��������ϻ���, �ٿ�ε� ��� �߰� ��. -->
				<span class="title">&nbsp;
				  <a href="javascript:fun_backupcreate('<%=Double.toString(dUsedSize)%>')">
					<img src="../image/mypage/bt_create_backFile.gif" width="76" height="16" align="absbottom" border="0">
				  </a>&nbsp;
				  <a href="javascript:fun_backupdown('<%=Double.toString(dUsedSize)%>')">
					<img src="../image/mypage/bt_down_backFile.gif" width="93" height="16" align="absbottom" border="0">
				  </a>
				</span>
				</h3>
                <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> > ���������� > �μ��ڷ��</div>
                <p><!--����--></p>
            </div>
            <!-- /pgTit -->

            <!-- contents -->

            <div id="contents">

                <!-- �������� ���� -->

                <div class="myP">

                    <!-- list -->
                    <!--span class="list01_tl"-->
					<%
						if((strPath != null) && (!strPath.equals(""))){
					%>
					<%=strPath%>
					<%
						}
					%>
					<span class="list_total">
						(<span style=" color:#F60"><%=Double.toString(dUsedSize)%>M</span>��� / <%=Double.toString(dTotalSize)%>M)</span>
					</span>
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td height="1">&nbsp;</td>
						</tr>
					</table>
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
                        <thead>
                            <tr>
                                <th scope="col"></th>
                                <th scope="col" style="width:400px; "><a>����</a></th>
                                <th scope="col"><a>ũ��</a></th>
                                <th scope="col"><a>����Ͻ�</a></th>
                                <th scope="col"><a>�����</a></th>
                            </tr>
					<%@ include file="businfo/BusInfoDutyProc.jsp" %>
                        </thead>
                        <tbody>
                        </tbody>
                    </table>
                    <table  align="center">
                      <tr>
                        <td height="35" align="center">
                            <%=objPaging.pagingTrans(PageCount.getLinkedString(strTotalCnt , strCurrentPage, strCountPerPage))%>
                        </td>
                      </tr>
                    </table>
                    <!-- /list -->

                    <!-- <p class="warning">* �䱸���� �߼��ϰ� �Ǹ� �ش� ���� ��� ��ǥ ����ڿ��� ���� �߼۵Ǹ�, ����ڰ� ���� ���� �ۼ� �� �䱸�Կ� �״�� �����ְ� �˴ϴ�. </p>
                <p class="warning">* �䱸�� �߼� ��ư�� �̿��Ͻñ� ���ؼ��� ����ȸ�� ������ �ֽñ� �ٶ��ϴ�. </p>-->

                    <!-- ����Ʈ ��ư-->
                    <div id="btn_all" > <!-- ����Ʈ �� �˻� -->
                        <div class="list_ser" >
                            <select name="gubun" class="selectBox5"  style="width:70px;" >
								<option value="1" <%=strSelected1%> >��ü</option>
								<option value="2" <%=strSelected2%> >����/���ϸ�</option>
								<option value="3" <%=strSelected3%> >���</option>
								<option value="4" <%=strSelected4%> >�ۼ���</option>
                            </select>
                            <input name="search" onKeyDown="return ch()" value="<%=strContent%>" onMouseDown="return ch()"
		 class="li_input"  style="width:100px" onKeyDown="if (event.keyCode == 13) fun_search();"/>
                            <img src="/images2/btn/bt_list_search.gif"  onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"/
							onclick="javascript:fun_search();"> </div>
                        <!-- /����Ʈ �� �˻� -->
							<span class="right">
								<span class="list_bt"><a href="javascript:fun_create('<%=strDocboxId%>', '<%=strOrganId%>')">��������</a></span>
								<span class="list_bt"><a href="javascript:fun_upload('<%=strDocboxId%>', '<%=strOrganId%>', '<%=strTotalSize%>', '<%=strUsedSize%>')">���ϵ��</a></span>
								<span class="list_bt"><a href="javascript:fun_equaluser('M', '<%=strDocboxId%>', '<%=strOrganId%>', '<%=strPriOrganNm%>')">�̵�</a></span>
								<span class="list_bt"><a href="javascript:fun_equaluser('U', '<%=strDocboxId%>', '<%=strOrganId%>', '<%=strPriOrganNm%>')">�̸�����</a></span>
								<span class="list_bt"><a href="javascript:fun_equaluser('D', '<%=strDocboxId%>', '<%=strOrganId%>', '<%=strPriOrganNm%>')">����</a></span>
							</span>
						</div>

                    <!-- /����Ʈ ��ư-->
                    <!-- /�������� ���� -->
					</div>
                <!-- /contents -->

            </div>

			<!--/span-->

        </div>
    </div>
<input type="hidden" name="tx_size" value="<%=strTotalSize%>"></font>
<input type="hidden" name="docbox_id" value="<%=strDocboxId%>"></font>
<input type="hidden" name="organ_id" value="<%=strOrganId%>"></font>
</form>
    <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>