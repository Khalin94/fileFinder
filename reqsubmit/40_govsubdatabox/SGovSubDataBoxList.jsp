<%@ page language="java" contentType="text/html;charset=EUC-KR" %>

<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.util.PageCount"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.govSubmtData.SGovSubmtDataDelegate"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.UserInfoDelegate"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.CDInfoDelegate"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.util.FileUtil"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.dsdm.app.common.page.PagingDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%
	/*** PagingDelegate */
	PagingDelegate objPaging=new PagingDelegate(); 		/*����¡ ��ȯ Delegate*/
%>
<%
 UserInfoDelegate objUserInfo =null;
 CDInfoDelegate objCdinfo =null;
%>


<%@ include file="../common/RUserCodeInfoInc.jsp" %>
<%
 /*************************************************************************************************/
 /** 					�Ķ���� üũ Part 														  */
 /*************************************************************************************************/

	boolean blnCheckPDFFileUploadComplet = true;
    StringUtil objDate = new StringUtil();
	ArrayList objAllBinderArray = null;
	Hashtable objGovSubmtDataHash = null;
	ResultSetHelper objRs = null;
	SGovSubmtDataDelegate objGovSubmtData = null;
	String strReqId = null;
	String strGovSubmtDataSortField = null;
	String strGovSubmtDataSortMtd = null;
	String strGovSubmtDataPageNum = null;
	//String strPageSize = null;
	String strUserID = null;
	String strGbnCode = null;    // ���������ڷᱸ���ڵ� 000 ��ü 001 ����� ..
	//String strOrganId = null;  // ��� id
	String	strGovSubmtGNB = null;
	String strGovSubmtDataId = null;
	String strSubmtOrganId = null;
	String strOrgFilePath = null;
	String strPdfFilePath = null;
	String strTocFilePath = null;
	String strGovSubmtYear = null;

	String	strSubmtDate = null;
	String	strSubmtOrganNm = null;
	String	strSubmtDataCont = null;
	String  strHttpPdfFilePath = null;
	String	strReqOrganId = null;
	String  strReqOrganNmValue = null;
	String	strAnsSubmtQryField = null;
	String	strAnsSubmtQryTerm = null;
	String	strReqOrganNm  = null;
    String  strCheckLegiConn = null;
	String	strRegerNm = null ;  // �����
	String  strCDNm = null; // ���� �ڵ��

	String strOrgan_Kind = null; // ������� ( 001 �繫ó ,002 ������åó , 003 �ǿ��� , 004 ����ȸ)

	boolean blnGovSubmtDataNoExist =  true;
	boolean blnUserInfo = false;

	int intPageSize = 10 ; //  �����ټ��ִ� ������ ��
	int	intTotalRecordCount = 0;
	int	intCurrentPageNum = 0; // ���� ������
	int	intTotalPage = 0;
	int	intRecordNumber = 0;
	int intIndexNum = 1;
	int intStartPage = 0;
	int intEndPage = 0;

	String strQryFieldValue =StringUtil.getEmptyIfNull(StringUtil.toHan(request.getParameter("strAnsSubmtQryField")));
	String strQryTermValue = StringUtil.getEmptyIfNull(request.getParameter("strAnsSubmtQryTerm"));
    strGbnCode = StringUtil.getEmptyIfNull(request.getParameter("GovSubmtDataType")); // ���������ڷ� ����ڵ� 000 ��ü 001 ����� ..

	strReqOrganNmValue = StringUtil.getEmptyIfNull(StringUtil.toHan(request.getParameter("strReqOrganNm")));

	if(strGbnCode == null || strGbnCode == "" || strGbnCode.equals("")){
		strGbnCode = "000";
	}

	if(strQryFieldValue == null || strQryFieldValue == "" ||strQryFieldValue.equals("")){
		strAnsSubmtQryField = "001";
	}else{
	    strAnsSubmtQryField = strQryFieldValue;
	}

	if( strQryTermValue == null || strQryTermValue.equals("")){
		strAnsSubmtQryTerm = "";
	}else{
		strQryTermValue = StringUtil.toMulti(strQryTermValue);
		StringUtil.isAssigned(strQryTermValue);
		strAnsSubmtQryTerm = strQryTermValue;
	}
	//System.out.println("[SGovSubDataBoxList.jsp] ���� strAnsSubmtQryTerm = " + strAnsSubmtQryTerm);


	strUserID = objUserInfo.getUserID();
	strSubmtOrganId = objUserInfo.getOrganID();
	//strOrgan_Kind = (String)session.getAttribute("ORGAN_KIND");  // ������� ( 001 �繫ó ,002 ������åó , 003 �ǿ��� , 004 ����ȸ ,006 ������)
	strOrgan_Kind = objUserInfo.getOrganGBNCode();

	//���� ���� �ޱ�.
	strGovSubmtDataSortField = StringUtil.getEmptyIfNull(StringUtil.toHan(request.getParameter("strGovSubmtDataSortField")));
	if(strGovSubmtDataSortField == null || strGovSubmtDataSortField.equals("")){
		strGovSubmtDataSortField = "REG_DT";
	}

 	strGovSubmtDataSortMtd= StringUtil.getEmptyIfNull(request.getParameter("strGovSubmtDataSortMtd"));
 	if(strGovSubmtDataSortMtd == null || strGovSubmtDataSortMtd.equals("")){
	 	strGovSubmtDataSortMtd = "DESC";
 	}

	// ���� ������ ��ȣ �ޱ�.
	strGovSubmtDataPageNum = StringUtil.getEmptyIfNull(request.getParameter("strGovSubmtDataPageNum"));
	//strGovSubmtDataPageNum = objParams.getParamValue("strGovSubmtDataPageNum");
	if(strGovSubmtDataPageNum == null || strGovSubmtDataPageNum.equals("")){
		strGovSubmtDataPageNum = "1";
	}

	//System.out.println("[SGovSubDataBoxList jsp] strGovSubmtDataPageNum = " + strGovSubmtDataPageNum);
	Integer objIntD = new Integer(strGovSubmtDataPageNum);
	intCurrentPageNum = objIntD.intValue();
	//System.out.println("[SGovSubDataBoxList jsp] intCurrentPageNum = " + intCurrentPageNum);

    objGovSubmtData = new SGovSubmtDataDelegate();
	//intCurrentPageNum = 1

    intRecordNumber= (intCurrentPageNum -1) * intPageSize +1;
	intStartPage = intRecordNumber;
	intEndPage = intCurrentPageNum*10;

    //������� ( 001 �繫ó ,002 ������åó , 003 �ǿ��� , 004 ����ȸ ,006 ������)

	if(strOrgan_Kind.equals("001")){ // �繫ó(������)(GI00004754) �ϵ��ڵ�ó��
		if(strSubmtOrganId.equals("GI00004754")){
			if (objUserInfo.isRequester()) {
				objGovSubmtDataHash = objGovSubmtData.getGovSubmtDataInfo(strGbnCode,"GI00004754",strGovSubmtDataSortField,strGovSubmtDataSortMtd,intPageSize,intCurrentPageNum,strAnsSubmtQryField,strAnsSubmtQryTerm,strOrgan_Kind);
			} else {
				objGovSubmtDataHash = objGovSubmtData.getGovSubmtDataInfo(strGbnCode, objUserInfo.getOrganID(),strGovSubmtDataSortField,strGovSubmtDataSortMtd,intPageSize,intCurrentPageNum,strAnsSubmtQryField,strAnsSubmtQryTerm,strOrgan_Kind);
			}
		} else {
			if (objUserInfo.isRequester()) {
				objGovSubmtDataHash = objGovSubmtData.getGovSubmtDataInfo(strGbnCode,objUserInfo.getOrganID(),strGovSubmtDataSortField,strGovSubmtDataSortMtd,intPageSize,intCurrentPageNum,strAnsSubmtQryField,strAnsSubmtQryTerm,strOrgan_Kind);
			} else {
				objGovSubmtDataHash = objGovSubmtData.getGovSubmtDataInfo(strGbnCode, objUserInfo.getOrganID(),strGovSubmtDataSortField,strGovSubmtDataSortMtd,intPageSize,intCurrentPageNum,strAnsSubmtQryField,strAnsSubmtQryTerm,strOrgan_Kind);
			}
		}
	}else if(strOrgan_Kind.equals("002")){ // ������åó(GI00004746)�ϵ��ڵ�ó��
			objGovSubmtDataHash = objGovSubmtData.getGovSubmtDataInfo(strGbnCode,"GI00004746",strGovSubmtDataSortField,strGovSubmtDataSortMtd,intPageSize,intCurrentPageNum,strAnsSubmtQryField,strAnsSubmtQryTerm,strOrgan_Kind);
	}else if(strOrgan_Kind.equals("003")   // �ǿ���
			|| strOrgan_Kind.equals("004")   // ����ȸ
		 	|| strOrgan_Kind.equals("006")){ // ������
	        objGovSubmtDataHash = objGovSubmtData.getGovSubmtDataInfo(strGbnCode,strSubmtOrganId,strGovSubmtDataSortField,strGovSubmtDataSortMtd,intPageSize,intCurrentPageNum,strAnsSubmtQryField,strAnsSubmtQryTerm,strOrgan_Kind);
	}

    // ȸ���ڷ����� ���� �����ش�.
	//objGovSubmtDataHash = objGovSubmtData.getGovSubmtDataInfo(strGbnCode,strSubmtOrganId,strGovSubmtDataSortField,strGovSubmtDataSortMtd,intPageSize,intCurrentPageNum,strAnsSubmtQryField,strAnsSubmtQryTerm);

	if(objGovSubmtDataHash != null ){
		blnGovSubmtDataNoExist = false;

		objRs =new ResultSetHelper(objGovSubmtDataHash);

		intCurrentPageNum = objRs.getPageNumber();//������������ȣ
		//System.out.println("intCurrentPageNum = " + intCurrentPageNum);
	    intTotalRecordCount = objRs.getTotalRecordCount();//��ü ��ȸ�� ���ڵ尹��
		//System.out.println("intTotalRecordCount = " + intTotalRecordCount);
	    intRecordNumber = objRs.getRecordSize(); //����� ���ڵ尳��
		//System.out.println("intRecordNumber = " + intRecordNumber);
	    intTotalPage = objRs.getTotalPageCount();//����������
		//System.out.println("intTotalPage = " + intTotalPage);
 	}

   // strPageSize = Integer.toString(intRecordNumber);

%>
<%
	try{
		 blnUserInfo = objUserInfo.isRequester();
	 }catch(Exception e){
     }
%>
<jsp:include page="/inc/header.jsp" flush="true"/>
<link href="/css2/style.css" rel="stylesheet" type="text/css">
<script language=Javascript src="/js/nads_lib.js"></script>
<script language=Javascript src="/js/datepicker.js"></script>
<script language="JavaScript">
  function changeSortQuery(sortField,sortMethod){
  	GovSubmtList.strGovSubmtDataSortField.value=sortField;
  	GovSubmtList.strGovSubmtDataSortMtd.value=sortMethod;
  	GovSubmtList.submit();
  }


  function goPage(strPage){
  	GovSubmtList.strGovSubmtDataPageNum.value=strPage;
  	GovSubmtList.submit();
  }


  function gotoInsert(formName){

  		var varTarget = formName.target;
		var varAction = formName.action;
		formName.action="/reqsubmit/40_govsubdatabox/SGovSubDataInsert.jsp";
		formName.submit();
		formName.target = varTarget;
		formName.action = varAction;

  }



  function gotoDetailView(formName,strGovSubmtDataId){
  		var varTarget = formName.target;
		var varAction = formName.action;
		formName.action="/reqsubmit/40_govsubdatabox/SGovSubDataDetailView.jsp";
		formName.strGovSubmtDataId.value = strGovSubmtDataId;
		formName.submit();
		formName.target = varTarget;
		formName.action = varAction;
  }



  function gotoGovSubDataBoxLegiConnect(formName,checkPdfUploadComplete){
		var blnCheck = false;
		var blnCheck2 = false;

		if(formName.LegiConn == undefined){
			alert("ȸ���ڷ� ������� �Թ����սý��ۿ� ������ �ڷᰡ �����ϴ�.");
			blnCheck2 = true;
		}else{
			if(formName.LegiConn.length==undefined){
				if(formName.LegiConn.checked==true){
					blnCheck=true;
				}
			}else{
				var intLen=formName.LegiConn.length;
				for(var i=0;i<intLen;i++){
					if(formName.LegiConn[i].checked==true){
						blnCheck=true;
						break;
					}
				}
			}
		}

		if( !blnCheck2 ){
			if(blnCheck){
				var checkPdfUploadCompleteData = checkPdfUploadComplete;
				if(checkPdfUploadCompleteData == "true"){
				 	var varTarget = formName.target;
					var varAction = formName.action;
					formName.action="/reqsubmit/40_govsubdatabox/GovSubDataBoxLegiConnect.jsp";
					formName.submit();
					formName.target = varTarget;
					formName.action = varAction;
				}else{
					alert("�Թ����սý��ۿ� ����� PDF������ ���� ��ϵ��� �ʾҽ��ϴ�.");
				}

			}else {
				alert("�Թ����սý��ۿ� ����� ����� �����ϼ���");
			}
		}
  }



  function PdfFileOpen(strGovID,GPDF){

      var http = "/reqsubmit/common/ReqFileOpen.jsp?paramAnsId=" + strGovID + "&DOC=" + GPDF;
	  window.open(http,"PdfView",
		"resizable=yes,menubar=no,status=nos,titlebar=yes,scrollbars=no,location=no,toolbar=no,height=600,width=800" );

   }



    /** ��ü ���� ��ü ���� */
  var blnCheckBoxFlag=false;

  function checkAllOrNot(formName){

   var i, chked=0, k=0;
   	  blnCheckBoxFlag=!blnCheckBoxFlag;
	  for(i=0;i<formName.length;i++){
	   if(formName[i].type=='checkbox'){
		//if(document.formName[i].checked){formName[i].checked=false;} else{formName[i].checked=true;}
		  formName[i].checked=blnCheckBoxFlag;
		  formName.checkAll.checked=blnCheckBoxFlag;
	   }
	}
	return true;
  }//end func



  function gotoHeadQuery(formName){
		var varTarget = formName.target;
		var varAction = formName.action;
	   // formName.strCheckSearchGbnCode.value = "001";
	    formName.strGovSubmtDataPageNum.value = 1; //ó�� ��������
		formName.action="/reqsubmit/40_govsubdatabox/SGovSubDataBoxList.jsp";
		formName.submit();
		formName.target = varTarget;
		formName.action = varAction;
 }


  function gotoSearch(formName){

		var varTarget = formName.target;
		var varAction = formName.action;
	   // formName.strCheckSearchGbnCode.value = "001";
	    formName.strGovSubmtDataPageNum.value = 1; //ó�� ��������
		formName.action="/reqsubmit/40_govsubdatabox/SGovSubDataBoxList.jsp";
		formName.submit();
		formName.target = varTarget;
		formName.action = varAction;

  }

  	function OrgFileDownLoad(govSubmtDataId,strFileName,strYearData,formName){

		var varTarget = formName.target;
		var varAction = formName.action;
		var linkPath = "/reqsubmit/common/ReqFileOpen.jsp?paramAnsId=" + govSubmtDataId + "&DOC=GDOC&YEAR=" + strYearData + "&FName=" + strFileName;
		formName.method = "post";
		formName.action = linkPath;
		formName.submit();
		formName.target = varTarget;
		formName.action = varAction;
	}
</script>
</head>

<body>
<div id="wrap">
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
	if(blnUserInfo){
%>
        <h3>ȸ���ڷ��� �ڷ� ���</h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" />
<%
	out.println(MenuConstants.GOTO_HOME + " > " + MenuConstants.REQ_SUBMIT_MAIN_MENU + " > "  + MenuConstants.GOV_SUBMT_REQ_DATA_BOX);
%>
<%
	}else{

	  String strTitle1 = "ȸ���ڷ� ����� �ڷ� ���";
	  String strLocation2 =  MenuConstants.GOTO_HOME + " > " + MenuConstants.REQ_SUBMIT_MAIN_MENU + " > " + MenuConstants.GOV_SUBMT_DATA_BOX;
%>

	<h3><%=strTitle1%></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /><%=strLocation2%>
<%
	}
%>

	</div>
        <p><!--����--></p>
      </div>
      <!-- /pgTit -->

      <!-- contents -->

      <div id="contents">
<form name="GovSubmtList" method="post" action="<%=request.getRequestURI()%>">
        <!-- �˻����� ���� ��� �Ʒ� div ���� �� �ּ����� ��������.-->
        <div class="schBox">
          <p>�䱸����ȸ����</p>
          <span class="line"><img src="/images2/foundation/search_line.gif" width="172" height="3" /></span>
          <div class="box">
            <!-- ������ �˻� ����Ʈ�� ��ư�� ��������-->
            <select name="GovSubmtDataType" onChange="this.form.submit()">
			<option
			<%
			if(strGbnCode == "000" || strGbnCode.equals("000")){
				out.print(" selected ");
				}
			%>
				value="000">��ü</option>
			<%
  			Hashtable objGbnCodeList = objGovSubmtData.getGovSubmtDataGBNCodeList();
			int intSize = objGbnCodeList.size();
			Integer objInt =(Integer)objGbnCodeList.get("FETCH_COUNT");
			int intCount = objInt.intValue();
			String strGndCodeName = null;
			String strGbnCodeData = null;

			for( int i = 0 ; i < intCount ; i ++){
				 strGbnCodeData = (String)((Vector)objGbnCodeList.get("MSORT_CD")).elementAt(i);
				 //System.out.println(" strGbnCodeData = " + strGbnCodeData);
				 strGndCodeName = (String)((Vector)objGbnCodeList.get("CD_NM")).elementAt(i);
				 //System.out.println(" strGndCodeName = " + strGndCodeName);

			  //if(strGbnCodeData.equals("001") || strGbnCodeData.equals("002") || strGbnCodeData.equals("003")){
		%>
			<option
		<%
				if(strGbnCodeData == strGbnCode || strGbnCodeData.equals(strGbnCode)){
					out.print(" selected ");
					strGbnCode = strGbnCodeData;
				}
		%>
			value="<%=strGbnCodeData%>"><%=strGndCodeName%></option>
		<%
			  //}
			} //FOR
		%>
			</select>
            <a href="javascript:gotoSearch(GovSubmtList);"><img src="/images2/btn/bt_search2.gif" width="50" height="22" /></a> </div>
        </div>
        <!-- /�˻�����-->

        <!-- �������� ���� -->

        <!-- list -->

        <span class="list_total">&bull;&nbsp;��ü�ڷ�� : <%=intTotalRecordCount%>�� (<%=intCurrentPageNum%> / <%=intTotalPage%> page)</span>


        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
          <thead>
            <tr>
              <th scope="col" style="width:15px;">
				<input name="" type="checkbox" value="" class="borderNo" />
			 </th>
              <th scope="col" style="width:15px;"><%=SortingUtil.getSortLink("changeSortQuery","",strGovSubmtDataSortField,strGovSubmtDataSortMtd,"NO")%></th>
              <th scope="col" style="width:250px;"><%=SortingUtil.getSortLink("changeSortQuery","DATA_NM",strGovSubmtDataSortField,strGovSubmtDataSortMtd,"���⳻��")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","SUBMT_ORGAN_NM",strGovSubmtDataSortField,strGovSubmtDataSortMtd,"������")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","",strGovSubmtDataSortField,strGovSubmtDataSortMtd,"����")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","",strGovSubmtDataSortField,strGovSubmtDataSortMtd,"����")%></th>
               <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","",strGovSubmtDataSortField,strGovSubmtDataSortMtd,"�����")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","REG_DT",strGovSubmtDataSortField,strGovSubmtDataSortMtd,"�����")%></th>
            </tr>
          </thead>
          <tbody>
	<%
		if(!blnGovSubmtDataNoExist){
			  int intRecordNumberCount = intTotalRecordCount - ((intCurrentPageNum -1) * intPageSize);
			 if(intRecordNumber > 0){
				while(objRs.next()){
					//strGovSubmtYear  = (String)objRs.getObject("SUBMT_DATA_ID"); 		// ���������ڷ��� ID
					strGovSubmtDataId  = (String)objRs.getObject("SUBMT_DATA_ID"); 		// ���������ڷ��� ID
					strSubmtOrganNm = (String)objRs.getObject("SUBMT_ORGAN_NM");		// ������ ��
					strReqOrganId = (String)objRs.getObject("REQ_ORGAN_ID"); 			// ����� ID
					strCheckLegiConn = (String)objRs.getObject("ILKMS_REG_FLAG"); 	   // �Թ����յ�� Ȯ��

				 // System.out.println("[SGovSubDataBoxList.jsp] strCheckLegiConn = " + strCheckLegiConn);
				 // if(strCheckLegiConn.compareTo("Y") == 0){
				 //		continue;
				 // }

				   // if(strGbnCode.compareTo("001") == 0){
					strReqOrganNm = (String)objRs.getObject("REQ_ORGAN_NM");        // �������
						// System.out.println("[SGovSubDataBoxList.jsp] strReqOrganNm = " + strReqOrganNm);
					//}

					strGovSubmtGNB	= (String)objRs.getObject("SUBMT_DATA_GBN");        // �����ڵ�
					strCDNm = (String)objRs.getObject("CD_NM");        					// ���и�
					strSubmtDataCont  = (String)objRs.getObject("DATA_NM"); 			// ���⳻��
					strSubmtDate = (String)objRs.getObject("REG_DT");					// ����Ⱓ
					String strYear =strSubmtDate.substring(0,4); // �⵵

					strOrgFilePath = (String)objRs.getObject("APD_ORG_FILE_PATH"); 	// ���������н�
					strPdfFilePath = (String)objRs.getObject("APD_PDF_FILE_PATH"); 	// PDF�����н�
					strTocFilePath = (String)objRs.getObject("APD_TOC_FILE_PATH"); 	// TOC�����н�
					 strRegerNm = (String)objRs.getObject("USER_NM"); 	// TOC�����н�

					//ReqFileOpen.jsp?paramAnsId=6&DOC=PDF"
					 strSubmtDate = StringUtil.getDate(strSubmtDate);
					 //strHttpPdfFilePath = objGovSubmtData.getHttpFileInfo(strPdfFilePath);
					 //strHttpPdfFilePath = objDate.toMulti(strHttpPdfFilePath);

					 //System.out.println("[SGovSubDataBoxList.jsp] strHttpPdfFilePath =" + strHttpPdfFilePath);

		 %>
            <tr>
  			<%
				if( strCheckLegiConn == "Y" || strCheckLegiConn.equals("Y")){
					  strCheckLegiConn = "���";
			%>
			  <td >
				<input name="ReqInfoIDs" type="checkbox" class="borderNo" Disabled/>
			  </td>
			<%
				}else{
					  strCheckLegiConn = "�̵��";
			%>
			  <td>
				<input name="LegiConn" type="checkbox" value ="<%//=strGovSubmtDataId%>" class="borderNo" Disabled/>
			  </td>
			<%
				}
									//intIndexNum
			%>
              <td><%= intRecordNumberCount %></td>
              <td><a href="javascript:gotoDetailView(GovSubmtList,'<%=strGovSubmtDataId%>');"><%=strSubmtDataCont%></a></td>
              <td><%=strSubmtOrganNm%></td>
              <td><%=strCDNm%></td>
			  <!--<td><%//=strCheckLegiConn%></td>-->
              <td>
				<%
					if(strPdfFilePath == "DB�����" || strPdfFilePath.equals("DB�����")){
						out.println("�����");
						blnCheckPDFFileUploadComplet = false;
					}else{
						if(strPdfFilePath == "" || strPdfFilePath.equals("")){
						}else{
				%>
				<a href="javascript:PdfFileOpen('<%=strGovSubmtDataId%>','GPDF');"><img src="/image/common/icon_pdf.gif" border="0"></a>
				<%
						}
					String strExtension = FileUtil.getFileExtension(strOrgFilePath);
					String strOrgFileName =  "src_"  + strGovSubmtDataId + "." + strExtension;

					   if(strOrgFilePath == "" || strOrgFilePath.equals("")){
					   }else{
							if(strExtension.equals("DOC") || strExtension.equals("doc")){
				%>
				<a href="javascript:OrgFileDownLoad('<%=strGovSubmtDataId%>','<%=strOrgFileName%>','<%=strYear%>',document.GovSubmtList);"><img src="/image/common/icon_word.gif" border="0"></a>
					<%
						}else if(strExtension.equals("HWP") || strExtension.equals("hwp")){
					%>
				<a href="javascript:OrgFileDownLoad('<%=strGovSubmtDataId%>','<%=strOrgFileName%>','<%=strYear%>',document.GovSubmtList);"><img src="/image/common/icon_hangul.gif" border="0"></a>
					<%
						}else if(strExtension.equals("GUL") || strExtension.equals("gul")){
					%>
				<a href="javascript:OrgFileDownLoad('<%=strGovSubmtDataId%>','<%=strOrgFileName%>','<%=strYear%>',document.GovSubmtList);"><img src="/image/common/icon_hun.gif" border="0"></a>
					<%
						}else if(strExtension.equals("TXT") || strExtension.equals("txt")){
					%>
				<a href="javascript:OrgFileDownLoad('<%=strGovSubmtDataId%>','<%=strOrgFileName%>','<%=strYear%>',document.GovSubmtList);"><img src="/image/common/icon_txt.gif" border="0"></a>
					<%
						}else if(strExtension.equals("HTML") || strExtension.equals("html") || strExtension.equals("HTM") || strExtension.equals("htm")){
					%>
				<a href="javascript:OrgFileDownLoad('<%=strGovSubmtDataId%>','<%=strOrgFileName%>','<%=strYear%>',document.GovSubmtList);"><img src="/image/common/icon_html.gif" border="0"></a>
					<%
						}else if(strExtension.equals("XLS") || strExtension.equals("xls")){
					%>
				<a href="javascript:OrgFileDownLoad('<%=strGovSubmtDataId%>','<%=strOrgFileName%>','<%=strYear%>',document.GovSubmtList);"><img src="/image/common/icon_excel.gif" border="0"></a>
					<%
						}else if(strExtension.equals("TOC") || strExtension.equals("toc")){
					%>
				<a href="javascript:OrgFileDownLoad('<%=strGovSubmtDataId%>','<%=strOrgFileName%>','<%=strYear%>',document.GovSubmtList);"><img src="/image/common/icon_toc.gif" border="0"></a>
					<%
						}else if(strExtension.equals("ppt") || strExtension.equals("PPT")){
					%>
				<a href="javascript:OrgFileDownLoad('<%=strGovSubmtDataId%>','<%=strOrgFileName%>','<%=strYear%>',document.GovSubmtList);"><img src="/image/common/icon_ppt.gif" border="0"></a>
					<%
						}
				   }
				}
			%>
			  </td>
              <td><%=strRegerNm%></td>
              <td><%=strSubmtDate%></td>
            </tr>
		<%
				 intRecordNumberCount --; // intIndexNum++;
				 }//end While
			} else { // end intRecordNumber
				//System.out.println("\n ����� ���ڵ尳�� 0 ���� �۴�.");
		%>
			<tr>
				<td colspan="8" align="center">��ϵ� ȸ���ڷ� ���� ����� �����ϴ�</td>
			</tr>
			<%
				}
			} else { //end blnGovSubmtDataNoExist = true
					//System.out.println("\n DB���� �޾ƿ� HASHTABEL�� NULL �̴�.");
			%>
			<tr >
				<td colspan="8" height="40" align="center">��ϵ� ȸ���ڷ� ���� ����� �����ϴ�</td>
			</tr>
		<%
			} //blnBindFileSessionExist
		%>
          </tbody>
        </table>
		<%
		//System.out.println("blnGovSubmtDataNoExist = " +blnGovSubmtDataNoExist);
			if(intRecordNumber > 0){
		%>
        <!-- /list -->
		<%=objPaging.pagingTrans(PageCount.getLinkedString(
										new Integer(intTotalRecordCount).toString(),
										new Integer(intCurrentPageNum).toString(),
										new Integer(intPageSize).toString()))%>
		<%
		   }
		%>
        <!-- ����¡-->
         <!-- /����¡-->
        <!--  <p class="warning">* �䱸���� �߼��ϰ� �Ǹ� �ش� ���� ��� ��ǥ ����ڿ��� ���� �߼۵Ǹ�, ����ڰ� ���� ���� �ۼ� �� �䱸�Կ� �״�� �����ְ� �˴ϴ�.  </p>
          <p class="warning">* �䱸�� �߼� ��ư�� �̿��Ͻñ� ���ؼ��� ����ȸ�� ������ �ֽñ� �ٶ��ϴ�.  </p>  -->



        <!-- ����Ʈ ��ư-->
        <div id="btn_all" >        <!-- ����Ʈ �� �˻� -->
        <div class="list_ser" >
		<%
			//String strReqBoxQryField=objParams.getParamValue("ReqBoxQryField");
		%>
          <select name="strAnsSubmtQryField" class="selectBox5"  style="width:70px;" >
<%
 if(strAnsSubmtQryField == "001" || strAnsSubmtQryField.equals("001")){
%>
			<option	 selected value="001">���⳻��</option>
			<option	 value="002">������</option>
			<!--<option	 value="003">�����</option>-->
			<option	 value="004">�����</option>
<%
	}else if(strAnsSubmtQryField == "002" || strAnsSubmtQryField.equals("002")){
%>
			<option	  value="001">���⳻��</option>
			<option	selected  value="002">������</option>
			<!--<option	 value="003">�����</option>-->
			<option	 value="004">�����</option>
<%
						//}else if(strAnsSubmtQryField == "003" || strAnsSubmtQryField.equals("003")){
%>
	<!--		<option	 value="001">���⳻��</option>
				<option	 value="002">������</option>
				<option	selected value="003">�����</option>
				<option	 value="004">�����</option>
	 -->
<%
	}else if(strAnsSubmtQryField == "004" || strAnsSubmtQryField.equals("004")){
%>
			<option	 value="001">���⳻��</option>
			<option	 value="002">������</option>
			<!--<option	 value="003">�����</option>-->
			<option	selected value="004">�����</option>
<%
						}
%>
          </select>
          <input name="strAnsSubmtQryTerm" onKeyDown="return ch()" onMouseDown="return ch()"
		 class="li_input"  style="width:100px"value="<%=strAnsSubmtQryTerm%>"/>
          <img src="/images2/btn/bt_list_search.gif"  onMouseOver="menuOn(this);" onMouseOut="menuOut(this);" onClick="gotoSearch(GovSubmtList);"/>
<%
   // }
%>
		  </div>
        <!-- /����Ʈ �� �˻� -->
		<span class="right">
<%
	if ("003".equalsIgnoreCase(strOrgan_Kind)) {
	} else {
		if(strOrgan_Kind.equals("006")){ //������
%>
			<span class="list_bt"><a href="javascript:gotoInsert(GovSubmtList)">���</a></span>
<%
		}else{
%>
			<span class="list_bt"><a href="javascript:gotoInsert(GovSubmtList)">���</a></span>
<%
		}
	}
%>
		</span>

		</div>

        <!-- /����Ʈ ��ư-->

        <!-- /�������� ���� -->
      </div>
      <!-- /contents -->

    </div>
  </div>
   <input type="hidden" name="strOrganId" value="<%=strSubmtOrganId%>"> <!--������ id  -->
   <input type="hidden" name="strSubmtOrganNm" value="<%=strSubmtOrganNm%>"> <!--�������� -->
   <input type="hidden" name="strGbnCode" value="<%=strGbnCode%>"><!--���������ڷᱸ���ڵ� 000��ü 001�����-->
   <input type="hidden" name="strGovSubmtDataId" value="">  <!--���������ڷ� id -->
   <input type="hidden" name="strGovSubmtDataSortField" value="<%=strGovSubmtDataSortField%>">  <!--���� �ʵ� -->
   <input type="hidden" name="strGovSubmtDataSortMtd" value="<%=strGovSubmtDataSortMtd%>">

   <!--��������  ��������,�������� -->
   <input type="hidden" name="strGovSubmtDataPageNum" value="<%=strGovSubmtDataPageNum%>">  <!-- �������� -->
   <input type="hidden" name="strAnsSubmtQryField" value="<%=strAnsSubmtQryField%>"><!--�˻��ʵ� 000 �̸� ��ü-->
    <input type="hidden" name="strAnsSubmtQryTerm" value="<%=strAnsSubmtQryTerm%>"> <!--�˻��� -->
	<!--<input type="hidden" name="strCheckSearchGbnCode" value="">--> <!--search��ư ���ý� -->

</form>
  <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>