<%@ page language="java" contentType="text/html;charset=EUC-KR" %>

<%@ page import="java.util.*"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.govSubmtData.SGovSubmtDataDelegate"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.UserInfoDelegate"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.CDInfoDelegate"%>
<%@ page import="nads.lib.reqsubmit.util.FileUtil"%>

<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
 UserInfoDelegate objUserInfo =null;
 CDInfoDelegate objCdinfo =null;
%>
<%@ include file="../common/RUserCodeInfoInc.jsp" %>

<%
	String  strGovSubmtDataId = null;
	String  strGovSubmtDataSortField = null;
	String  strGovSubmtDataSortMtd = null;
	String  strGovSubmtDataPageNum = null;
	String  strAnsSubmtQryTerm = null;
	String  strAnsSubmtQryField = null;

	String strSubmtOrganNm = null;
	String strSubmtDataCont = null;
	String strPdfFilePath = null;
	String strOrgFilePath = null;
	String strTocFilePath = null;
	String strReqOrganNm = null;//�䱸��� ID (�����ID)
	//String strReqOrganId = null;
	String strUserNm = null;
	String strSubmtDate = null;
	String strSelCodeName = null;   //���������ڷ� �ڵ��̸�
	String strGovSubmtYear = null; // �����ش�⵵
	String strGovDlbrtHighOrganID = null; //  ����� ID(�䱸��� ID)
	//String strGovSubmtDataID = null; // ���������ڷ� id

	SGovSubmtDataDelegate objGovSubmtData = null;
	UserInfoDelegate objUser = null;
	 FileUtil objFileUtil = new FileUtil();

	objUser = new UserInfoDelegate(request);

	String strGbnCode = null;
	String strOrganId = null;
	strGbnCode = objUser.getOrganGBNCode();   // 003:�ǿ��� 004:����ȸ (����), 006:������ (���)
	//System.out.println("��� ����  strGbnCode = " + strGbnCode );
	strOrganId = objUser.getOrganID();
	//System.out.println("�䱸 ���  strOrganId = " + strOrganId );
	String strUserId = null;
	//String strUserID =	objUser.getUserID();
	String strUserName = objUser.getUserName();
	boolean blnUserInfo = false;


/*************************************************************************************************/
 /** 					�Ķ���� üũ Part 														  */
 /*************************************************************************************************/

	//����� ID
	//strReqOrganId =  (String)request.getParameter("strReqOrganId");
	//System.out.println("[SGovSubDataDetailView.jsp] strReqOrganId = " + strReqOrganId);

	//�������
	//strReqOrganNm =  StringUtil.toMulti((String)(request.getParameter("strReqOrganNm")));
	//System.out.println("[SGovSubDataDetailView.jsp] strReqOrganNm = " + strReqOrganNm);

	//���������ڷ��� id
	strGovSubmtDataId =  (String)request.getParameter("strGovSubmtDataId");
	//System.out.println("[SGovSubDataDetailView.jsp] strGovSubmtDataId = " + strGovSubmtDataId);

	//�˻���
	strAnsSubmtQryTerm =  (String)request.getParameter("strAnsSubmtQryTerm");
	//System.out.println("strAnsSubmtQryTerm ="  + strAnsSubmtQryTerm);
	if(strAnsSubmtQryTerm != null){
		strAnsSubmtQryTerm =  StringUtil.toMulti(request.getParameter("strAnsSubmtQryTerm"));
	}
	//System.out.println("[SGovSubDataDetailView.jsp] strAnsSubmtQryTerm = " + strAnsSubmtQryTerm);

	//�˻��ʵ�
	strAnsSubmtQryField =  (String)request.getParameter("strAnsSubmtQryField");
	//System.out.println("[SGovSubDataDetailView.jsp] strAnsSubmtQryField = " + strAnsSubmtQryField);

	// ���� �ʵ弱�� (���������ڷ��ڵ�)
	strGovSubmtDataSortField =  (String)request.getParameter("strGovSubmtDataSortField");
	if(strGovSubmtDataSortField == null){
			strGovSubmtDataSortField = "REG_DT";
	}
	//System.out.println("[SGovSubDataDetailView.jsp] strGovSubmtDataSortField = " + strGovSubmtDataSortField);

	// ���� ����
 	strGovSubmtDataSortMtd=  (String)request.getParameter("strGovSubmtDataSortMtd");
	if(strGovSubmtDataSortMtd == null){
			strGovSubmtDataSortMtd = "DESC";
	}
		//System.out.println("[SGovSubDataDetailView.jsp] strGovSubmtDataSortMtd = " + strGovSubmtDataSortMtd);
	// ���� ������ ��ȣ �ޱ�.
	strGovSubmtDataPageNum = (String)request.getParameter("strGovSubmtDataPageNum");
	if(strGovSubmtDataPageNum == null){
		strGovSubmtDataPageNum = "1";
	}
	//System.out.println("[SGovSubDataDetailView.jsp] strGovSubmtDataPageNum = " + strGovSubmtDataPageNum);


	Hashtable objhash = null;

	objGovSubmtData = new SGovSubmtDataDelegate();

	objhash = objGovSubmtData.getGovSubmtDetailView(strGovSubmtDataId);


	String strGbnKindCode = (String)( (Vector)objhash.get("SUBMT_DATA_GBN") ).elementAt(0);	 //����
	//System.out.println("  ******* strGbnKindCode  =  " + strGbnKindCode + " ********** " );



	strSelCodeName = (String)( (Vector)objhash.get("CD_NM") ).elementAt(0);			//���������ڷ��ڵ��̸�
  	strSubmtOrganNm = (String)( (Vector)objhash.get("ORGAN_NM") ).elementAt(0); 			 //��������
	strReqOrganNm = (String)( (Vector)objhash.get("REQ_ORGAN_NM") ).elementAt(0); 	  //�������(�䱸�����)
    strUserNm = (String)( (Vector)objhash.get("USER_NM") ).elementAt(0);   				    // ����ڸ�
	strUserId = (String)( (Vector)objhash.get("REGR_ID") ).elementAt(0);                    // ���ID
  	strSubmtDataCont = (String)( (Vector)objhash.get("DATA_NM") ).elementAt(0);  			//���⳻��
    strSubmtDataCont  = StringUtil.getDescString(strSubmtDataCont);
  	strPdfFilePath  = (String)( (Vector)objhash.get("APD_PDF_FILE_PATH") ).elementAt(0);	//PDF�����н�
  	strPdfFilePath = FileUtil.getFileSeparatorPath(strPdfFilePath);
  	strPdfFilePath = FileUtil.getFileName(strPdfFilePath);
  	//System.out.println("[SGovSubDataDetailView.jsp] strPdfFilePath =" + strPdfFilePath);

  	strOrgFilePath =(String)( (Vector)objhash.get("APD_ORG_FILE_PATH") ).elementAt(0); 	//���������н�
  	strOrgFilePath = FileUtil.getFileSeparatorPath(strOrgFilePath);
  	strOrgFilePath = FileUtil.getFileName(strOrgFilePath);
  	//System.out.println("[SGovSubDataDetailView.jsp] strOrgFilePath =" + strOrgFilePath);

  	strTocFilePath =  (String)( (Vector)objhash.get("APD_TOC_FILE_PATH") ).elementAt(0); 	//TOC�����н�
  	strTocFilePath = FileUtil.getFileSeparatorPath(strTocFilePath);
  	strTocFilePath = FileUtil.getFileName(strTocFilePath);
  	//System.out.println("[SGovSubDataDetailView.jsp] strTocFilePath =" + strTocFilePath);

  	strSubmtDate =  (String)( (Vector)objhash.get("REG_DT") ).elementAt(0);  				//�������
	String strYear =strSubmtDate.substring(0,4); // �⵵

  	strGovSubmtYear =  (String)( (Vector)objhash.get("SUBMT_YEAR")).elementAt(0);  		//���� �ش� �⵵
  	strGovDlbrtHighOrganID =  (String)( (Vector)objhash.get("DLBRT_ORGAN_ID")).elementAt(0);  	//����� ID


	 String strFileNameInfo = strGovSubmtYear + "_" + strSelCodeName + "_" + strSubmtOrganNm;

	 //������ ����Ʈ : �ѱ�,word,powerpointer,excel,�ƹ�����,txt���� ,html����, toc���� , ��Ÿ����
%>
<%
	try{
		 blnUserInfo = objUserInfo.isRequester();
	}catch(Exception e){
	}
%>
<jsp:include page="/inc/header.jsp" flush="true"/>
<script language="javascript">

 	function gotoUpdate(formName){
  		var varTarget = formName.target;
		var varAction = formName.action;
		formName.action="/reqsubmit/40_govsubdatabox/SGovSubDataUpdate.jsp";
		formName.submit();
		formName.target = varTarget;
		formName.action = varAction;
    }

    function gotoList(formName){

  		var varTarget = formName.target;
		var varAction = formName.action;
		formName.strGovSubmtDataId.value = "<%=strGovSubmtDataId%>";
		formName.strGovSubmtDataSortField.value = "<%=strGovSubmtDataSortField%>";
		formName.strGovSubmtDataSortMtd.value = "<%=strGovSubmtDataSortMtd%>";
		formName.strGovSubmtDataPageNum.value = "<%=strGovSubmtDataPageNum%>";
		formName.strAnsSubmtQryField.value = "<%=strAnsSubmtQryField%>";
		formName.strAnsSubmtQryTerm.value =  "<%=strAnsSubmtQryTerm%>";

		formName.action="/reqsubmit/40_govsubdatabox/SGovSubDataBoxList.jsp";
		formName.submit();
		formName.target = varTarget;
		formName.action = varAction;
    }

    function gotoDelete(formName){

    	if(confirm("ȸ���ڷ����� ��Ͽ��� �����Ͻðڽ��ϱ� ?")==true){
  			var varTarget = formName.target;
			var varAction = formName.action;
			formName.action="/reqsubmit/40_govsubdatabox/SGovSubDataDelete.jsp";
			formName.submit();
			formName.target = varTarget;
			formName.action = varAction;
		}
    }

	function PDFfileDownLoad(govSubmtDataId,code){

			var linkPath = "/reqsubmit/common/ReqFileOpen.jsp?paramAnsId=" + govSubmtDataId + "&DOC=" + code;

			window.open(linkPath,"DowloadOrginalDocFile",
			"resizable=yes,menubar=no,status=yes,titlebar=yes,scrollbars=no,location=no,toolbar=no,height=800,width=900" );

	}

	//function OrgFileDownLoad(orgFileName,orgNewFileName){
	function OrgFileDownLoad(govSubmtDataId,strFileName,strYearData){

		var varTarget = formName.target;
		var varAction = formName.action;
		var linkPath = "/reqsubmit/common/ReqFileOpen.jsp?paramAnsId=" + govSubmtDataId + "&DOC=GDOC&YEAR=" + strYearData + "&FName=" + strFileName;
		formName.action=linkPath;
		formName.submit();
		formName.target = varTarget;
		formName.action = varAction;

	}

	function TocFileDownLoad(govSubmtDataId,strFileName,strYearData){

		var varTarget = formName.target;
		var varAction = formName.action;
		var linkPath = "/reqsubmit/common/ReqFileOpen.jsp?paramAnsId=" + govSubmtDataId + "&DOC=GTOC&YEAR=" + strYearData + "&FName=" + strFileName;
		formName.action=linkPath;
		formName.submit();
		formName.target = varTarget;
		formName.action = varAction;
	}



</script>
</head>

<body>
<div id="wrap">
<SCRIPT language="JavaScript" src="/js/reqsubmit/reqinfo.js"></SCRIPT>
  <jsp:include page="/inc/top.jsp" flush="true"/>
  <jsp:include page="/inc/top_menu02.jsp" flush="true"/>
  <div id="container">
    <div id="leftCon">
      <jsp:include page="/inc/log_info.jsp" flush="true"/>
      <jsp:include page="/inc/left_menu02.jsp" flush="true"/>
    </div>
    <div id="rightCon">
      <!-- pgTit -->
      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
<%
	if(blnUserInfo){ // �䱸���� ���
%>
        <h3>ȸ���ڷ���</h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> > �ڷ� �䱸 > ȸ���ڷ��� > ȸ���ڷ� �󼼺���
<%
	}else{  //�������� ���
%>
        <h3>ȸ���ڷ� �����</h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> > �ڷ� �䱸 > ȸ���ڷ� ����� > ȸ���ڷ� �󼼺���
<%
	}
%>
	</div>
        <p><!--����--></p>
      </div>
      <!-- /pgTit -->

      <!-- contents -->

      <div id="contents">
<form name="formName" method="post" action="./SGovSubDataInsertProc.jsp"><!--�䱸 �ű����� ���� -->
        <!-- �˻����� ���� ��� �Ʒ� div ���� �� �ּ����� ��������.-->
        <!-- /�˻�����-->


        <!-- �������� ���� -->
         <!-- list view-->

        <span class="list02_tl"><%=MenuConstants.GOV_SUBMT_DATA_DETAIL_VIEW%> </span>
        <table border="0" cellspacing="0" cellpadding="0" width="680" class="list02">

            <tr>
                <th height="25">&bull; ���� �⵵ </th>
                <td height="25" colspan="3"><%=strGovSubmtYear%></td>
            </tr>
            <tr>
                <th height="25">&bull; ���� </th>
                <td height="25" colspan="3"><%=strSelCodeName%></td>
            </tr>
            <tr>
                <th height="25">&bull; ����� </th>
                <td height="25"><%=strSubmtOrganNm%></td>
                <th height="25">&bull; ����� </th>
                <td height="25"><%=strUserNm%></td>
            </tr>
            <tr>
                <th height="25">&bull; ���⳻�� </th>
                <td height="25" colspan="3"><%=strSubmtDataCont%></td>
            </tr>
            <tr>
                <th height="25" rowspan="2">&bull; ÷������ </th>
				<%
					if(StringUtil.isAssigned(strPdfFilePath)) {
				%>
                <th height="25">PDF</th>
                <td height="25" colspan="2">
					<%
						if(strPdfFilePath == "DB�����" || strPdfFilePath.equals("DB�����")){
							out.println("�����");
						} else {
					%>
					<a href="javascript:PDFfileDownLoad('<%=strGovSubmtDataId%>','GPDF');">
					<img src="/image/common/icon_pdf.gif" border="0">&nbsp;
					<%
							String strPdfFileName =  strFileNameInfo  + ".pdf";
							out.println(strPdfFileName);
						}
					%>
				</td>
            </tr>
            <tr>
		   <%
				}
		   %>
		   <%
				if (StringUtil.isAssigned(strOrgFilePath)) {
		   %>
                <th height="25">��������</th>
                <td height="25" colspan="2">
				<%
					String strExtension = FileUtil.getFileExtension(strOrgFilePath);
					String strOrgFileName =  strFileNameInfo  + "." + strExtension;
				%>
			   <a href="javascript:OrgFileDownLoad('<%=strGovSubmtDataId%>','<%=strOrgFileName%>','<%=strYear%>')">
				<%
					if(strExtension.equals("PDF") || strExtension.equals("pdf")){
				%>
				<img src="/image/common/icon_pdf.gif" border="0">&nbsp;
				<%
					}else if(strExtension.equals("DOC") || strExtension.equals("doc")){
				%>
				<img src="/image/common/icon_word.gif" border="0"></a> &nbsp;
				<%
					}else if(strExtension.equals("HWP") || strExtension.equals("hwp")){
				%>
				<img src="/image/common/icon_hangul.gif" border="0"></a> &nbsp;
				<%
					}else if(strExtension.equals("GUL") || strExtension.equals("gul")){
				%>
				<img src="/image/common/icon_hun.gif" border="0"></a> &nbsp;
				<%
					}else if(strExtension.equals("TXT") || strExtension.equals("txt")){
				%>
				<img src="/image/common/icon_txt.gif" border="0"></a> &nbsp;
				<%
					}else if(strExtension.equals("HTML") || strExtension.equals("html") || strExtension.equals("HTM") || strExtension.equals("htm")){
				%>
				<img src="/image/common/icon_html.gif" border="0"></a> &nbsp;
				<%
					}else if(strExtension.equals("XLS") || strExtension.equals("xls")){
				%>
				<img src="/image/common/icon_excel.gif" border="0"></a> &nbsp;
				<%
					}else if(strExtension.equals("TOC") || strExtension.equals("toc")){
				%>
				<img src="/image/common/icon_toc.gif" border="0"></a> &nbsp;
				<%
					}else if(strExtension.equals("ppt") || strExtension.equals("PPT")){
				%>
				<img src="/image/common/icon_ppt.gif" border="0"></a> &nbsp;
				<%
					}else{
				%>
				<img src="/image/common/icon_etc.gif" border="0"></a> &nbsp;
			<%
					}
					out.println(strOrgFileName);
			%>
				</a>
		<%
			}
		%>
				</td>
            </tr>
        </table>
        <!-- /list view -->
<!--        <p class="warning mt10">* �䱸�� �߼� : �ǿ���(�Ǵ� �Ҽӱ��) ���Ƿ� �ش� �������� �䱸���� �߼��մϴ�.</p>
-->
        <!-- ����Ʈ ��ư-->
         <div id="btn_all"class="t_right">
		<!-- ���� �Ϸ� -->
<%
	//if(strUserName.equals(strUserNm) || strOrganId.equals(strGovDlbrtHighOrganID)){
	if(strOrganId.equals(strGovDlbrtHighOrganID)){
%>
			 <span class="list_bt"><a href="javascript:gotoDelete(formName)">����</a></span>
<%
	}
%>
			<span class="list_bt"><a href="javascript:gotoList(formName)">���</a></span>
		 </div>

        <!-- /����Ʈ ��ư-->

    </div>
  </div>
			<input type="hidden" name="strGovSubmtYear" value="<%=strGovSubmtYear%>"><!--���� �ش� �⵵-->
			<input type="hidden" name="strSubmtDataCont" value="<%=strSubmtDataCont%>"><!--���⳻�� -->
			<input type="hidden" name="strGovSubmtDataId" value="<%=strGovSubmtDataId%>"><!--���������ڷ� ID -->
			<input type="hidden" name="strOrganId" value="<%=strOrganId%>"><!--������ id ( ������ �ϰ��) -->
			<input type="hidden" name="strGbnKindCode" value="<%=strGbnKindCode%>"><!-- ���������ڷ� �ڵ� -->
			<input type="hidden" name="strAnsSubmtQryTerm" value="<%=strAnsSubmtQryTerm%>"> <!--�˻��� -->
			<input type="hidden" name="strAnsSubmtQryField" value="<%=strAnsSubmtQryField%>"> <!--�˻��ʵ� 000 �̸� ��ü -->
			<input type="hidden" name="strGovSubmtDataSortField" value="<%=strGovSubmtDataSortField%>">  <!--���� �ʵ� -->
			<input type="hidden" name="strGovSubmtDataSortMtd" value="<%=strGovSubmtDataSortMtd%>">  <!--���� ���� -->
			<input type="hidden" name="strGovSubmtDataPageNum" value="<%=strGovSubmtDataPageNum%>">  <!-- �������� -->
			<input type="hidden" name="strSubmtDate" value="<%=strSubmtDate%>">  <!-- ������� -->
			<input type="hidden" name="strPdfFilePath" value="<%=strPdfFilePath%>">  <!-- Pdf�����н� -->
			<input type="hidden" name="strOrgFilePath" value="<%=strOrgFilePath%>">  <!-- ���������н� -->
			<input type="hidden" name="strTocFilePath" value="<%=strTocFilePath%>">  <!-- Toc�����н� -->

			<input type="hidden" name="strReqOrganNm" value="<%=strReqOrganNm%>"><!--���� ������� -->
<input type="hidden" name="strGovDlbrtHighOrganID" value="<%=strGovDlbrtHighOrganID%>"><!--�����id (�䱸���ID)-->
			<input type="hidden" name="RegrID" value="<%=strUserId%>"><!-- ����� ID -->
</form>
  <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>