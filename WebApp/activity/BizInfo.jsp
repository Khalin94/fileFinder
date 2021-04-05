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
	PagingDelegate objPaging=new PagingDelegate(); 		/*페이징 변환 Delegate*/
%>
<%-- 대분류 목록을 조회한다. --%>
<%
	String strUserId = (String)session.getAttribute("USER_ID");

	String strCurrentPage = nads.lib.reqsubmit.util.StringUtil.getEmptyIfNull(request.getParameter("strCurrentPage"), "1");
	String strSelectedOrganNm = nads.lib.reqsubmit.util.StringUtil.getEmptyIfNull(request.getParameter("organ_nm"), "선택된 부서가 없습니다.");
	String strCountPerPage;

	nads.dsdm.app.activity.businfo.BusInfoDelegate objBusInfoDelegate = new nads.dsdm.app.activity.businfo.BusInfoDelegate();
	String strDocboxId = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVL(request.getParameter("docbox_id"), ""));
	String strOrganId   = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVL(request.getParameter("organ_id"), ""));

	String strGubn = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVL(request.getParameter("gubun"), "1"));
	String strContent = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVL(request.getParameter("search"), ""));
	String strPriOrganNm = "";    //좌측메뉴에서 클릭한 기관명
	String strPriDocboxNm = "";    //좌측메뉴에서 클릭한 분류함명
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

	// 시스템 전체적으로 페이지당 row의 갯수는 property로 정하여 사용한다.
	// 만일 특정페이지에서만 row의 갯수를 변경하고 싶으면 아래 catch문을 활용한다.
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

		/*****부서명를 조회한다.*****/
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
		 		strPriOrganNm = "(겸무)" + strPriOrganNm;
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

		 	//분류함이름 조회
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
			alert('부서가 선택되지 않았습니다.!');
			return;
		}

		if(document.form_duty.docbox_id.value == '0')
		{
			alert('최상위(기관폴더)에는 파일을 업로드할 수 없습니다.!');
			return;
		}

		var url = "./FileUploadPop.jsp?total_size=" + strTotalSize
		            + "&used_size=" + strUsedSize + "&docbox_id=" + strDocboxId + "&organ_id=" + strOrgan_id ;
		window.open(url,'New','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,copyhistory=no,width=470,height=440,left=0,top=0');
	}

	function fun_create(strDocboxId, strOrgan_id){
		if(document.form_duty.organ_id.value == ''){
			alert('부서가 선택되지 않았습니다.!');
			return;
		}

		var url = "./FolderCreatePop.jsp?docbox_id=" + strDocboxId + "&organ_id=" + strOrgan_id;
		window.open(url,'New','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,copyhistory=no,width=385,height=179,left=0,top=0');
	}

	function fun_equaluser(strGubn, strDocboxId, strOrgan_id, strOrgan_nm){
		if(document.form_duty.organ_id.value == ''){
			alert('부서가 선택되지 않았습니다.!');
			return;
		}

		var varDoc = fun_checked(document.form_duty.checkD);
		var varDuty = fun_checked(document.form_duty.checkF);
		var varDocStrings = "";
		var varDutyStrings = "";
		var varUrl = "";

		if(parseInt(varDoc + varDuty) < 1){
				alert('선택된 정보가 없습니다.');
				return;
		}
		if(strGubn == 'U'){
			if(parseInt(varDoc + varDuty) > 1){
				alert('수정(변경)은 하나만 가능합니다.');
				return;
			}
			varUrl = "./FileChangePop.jsp"; //변경
		}else{
			varUrl = "./FileShiftPop.jsp";  //폴더이동 및 삭제
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
			alert('부서가 선택되지 않았습니다.!');
			return;
		}

		strTmp = "/activity/BizInfo.jsp?docbox_id=" + strDocboxId + "&organ_id=" + strOrganId;
		window.location = strTmp
	}

	function fun_down() {

	}

	function fun_search(){
		if(document.form_duty.organ_id.value == ''){
			alert('부서가 선택되지 않았습니다.!');
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
			alert('백업 받을 업무정보(자료)가 없습니다.');
			return;
		}

		if(document.form_duty.organ_id.value == ''){
			alert('부서가 선택되지 않았습니다.!');
			return;
		}

		var url = "./DutyBackupCreatePop.jsp?organ_id=" + document.form_duty.organ_id.value;
		window.open(url,'BackUpFileCreate','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,copyhistory=no,width=385,height=179,left=0,top=0');
	}

	function fun_backupdown(vaSize){
		if(vaSize == '0.0'){
			alert('백업 받을 업무정보(자료)가 없습니다.');
			return;
		}

		if(document.form_duty.organ_id.value == ''){
			alert('부서가 선택되지 않았습니다.!');
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
	**** 기존 별도 Left menu 구성으로 현재 메뉴와 통합이 필요함. ****
<iframe frameborder=0 width='95%'  height='100%' leftmargin='0' rightmargin='0' topmargin='0' src="./businfo/BusInfoIndex.jsp?docbox_id=<%=strDocboxId%>&organ_id=<%=strOrganId%>" scrolling=auto ></iframe>
-->
        </div>
        <div id="rightCon">

<form name="form_duty" method="post" action="">
<input type="hidden" name="strCurrentPage" value="<%=strCurrentPage%>">
<input type="hidden" name="gubn" value="">

            <!-- pgTit -->
            <div id="pgTit" style="background:url(/images2/foundation/stl_bg_my.jpg) no-repeat left top;">
                <h3>부서자료실 <!-- <span class="sub_stl" >- 상세보기</span> -->

<!--  기존 기능인 백업업파일생성, 다운로드 기능 추가 함. -->
				<span class="title">&nbsp;
				  <a href="javascript:fun_backupcreate('<%=Double.toString(dUsedSize)%>')">
					<img src="../image/mypage/bt_create_backFile.gif" width="76" height="16" align="absbottom" border="0">
				  </a>&nbsp;
				  <a href="javascript:fun_backupdown('<%=Double.toString(dUsedSize)%>')">
					<img src="../image/mypage/bt_down_backFile.gif" width="93" height="16" align="absbottom" border="0">
				  </a>
				</span>
				</h3>
                <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> > 나의페이지 > 부서자료실</div>
                <p><!--문구--></p>
            </div>
            <!-- /pgTit -->

            <!-- contents -->

            <div id="contents">

                <!-- 각페이지 내용 -->

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
						(<span style=" color:#F60"><%=Double.toString(dUsedSize)%>M</span>사용 / <%=Double.toString(dTotalSize)%>M)</span>
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
                                <th scope="col" style="width:400px; "><a>제목</a></th>
                                <th scope="col"><a>크기</a></th>
                                <th scope="col"><a>등록일시</a></th>
                                <th scope="col"><a>등록자</a></th>
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

                    <!-- <p class="warning">* 요구서를 발송하게 되면 해당 제출 기관 대표 담당자에게 지정 발송되며, 담당자가 없는 경우는 작성 중 요구함에 그대로 남아있게 됩니다. </p>
                <p class="warning">* 요구서 발송 버튼을 이용하시기 위해서는 위원회를 선택해 주시기 바랍니다. </p>-->

                    <!-- 리스트 버튼-->
                    <div id="btn_all" > <!-- 리스트 내 검색 -->
                        <div class="list_ser" >
                            <select name="gubun" class="selectBox5"  style="width:70px;" >
								<option value="1" <%=strSelected1%> >전체</option>
								<option value="2" <%=strSelected2%> >폴더/파일명</option>
								<option value="3" <%=strSelected3%> >요약</option>
								<option value="4" <%=strSelected4%> >작성자</option>
                            </select>
                            <input name="search" onKeyDown="return ch()" value="<%=strContent%>" onMouseDown="return ch()"
		 class="li_input"  style="width:100px" onKeyDown="if (event.keyCode == 13) fun_search();"/>
                            <img src="/images2/btn/bt_list_search.gif"  onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"/
							onclick="javascript:fun_search();"> </div>
                        <!-- /리스트 내 검색 -->
							<span class="right">
								<span class="list_bt"><a href="javascript:fun_create('<%=strDocboxId%>', '<%=strOrganId%>')">폴더생성</a></span>
								<span class="list_bt"><a href="javascript:fun_upload('<%=strDocboxId%>', '<%=strOrganId%>', '<%=strTotalSize%>', '<%=strUsedSize%>')">파일등록</a></span>
								<span class="list_bt"><a href="javascript:fun_equaluser('M', '<%=strDocboxId%>', '<%=strOrganId%>', '<%=strPriOrganNm%>')">이동</a></span>
								<span class="list_bt"><a href="javascript:fun_equaluser('U', '<%=strDocboxId%>', '<%=strOrganId%>', '<%=strPriOrganNm%>')">이름변경</a></span>
								<span class="list_bt"><a href="javascript:fun_equaluser('D', '<%=strDocboxId%>', '<%=strOrganId%>', '<%=strPriOrganNm%>')">삭제</a></span>
							</span>
						</div>

                    <!-- /리스트 버튼-->
                    <!-- /각페이지 내용 -->
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