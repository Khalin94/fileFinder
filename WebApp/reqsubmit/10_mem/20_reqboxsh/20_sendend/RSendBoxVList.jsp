<%@ page language="java" contentType="text/html;charset=EUC-KR" %>

<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.bf.config.*"%>
<%@ page import="kr.co.kcc.pf.util.PageCount"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RMemReqBoxVListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.MemRequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.MemRequestInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.SendReqBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.cmtsubmt.CmtSubmtReqBoxDelegate" %>
<%@ page import="nads.dsdm.app.common.page.PagingDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%
	/*** PagingDelegate */
	PagingDelegate objPaging=new PagingDelegate(); 		/*����¡ ��ȯ Delegate*/
%>
<%
	UserInfoDelegate objUserInfo =null;
	CDInfoDelegate objCdinfo =null;
	String existFlag = "N";
%>

<%@ include file="../../../common/RUserCodeInfoInc.jsp" %>

<%
	/*************************************************************************************************/
	/** 					�Ķ���� üũ Part 														  */
	/*************************************************************************************************/

	/**�Ϲ� �䱸�� �󼼺��� �Ķ���� ����.*/
	RMemReqBoxVListForm objParams =new RMemReqBoxVListForm();
	objParams.setParamValue("IsRequester",String.valueOf(objUserInfo.isRequester()));//�䱸�亯�ڿ��μ���
	boolean blnParamCheck=false;
	/**���޵� �ĸ����� üũ */
	blnParamCheck=objParams.validateParams(request);

	if(blnParamCheck==false) {
		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
		objMsgBean.setStrCode("DSPARAM-0000");
		objMsgBean.setStrMsg(objParams.getStrErrors());
		//out.println("ParamError:" + objParams.getStrErrors());
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}//endif

	/*************************************************************************************************/
	/** 					������ ȣ�� Part 														  */
	/*************************************************************************************************/

	/*** Delegate �� ������ Container��ü ���� */
	MemRequestBoxDelegate objReqBox=null; 		/**�䱸�� Delegate*/
	MemRequestInfoDelegate  objReqInfo=null;	/** �䱸���� Delegate */
	SendReqBoxDelegate objSendBean = null;
	CmtSubmtReqBoxDelegate objCmtSubmt = null;

	ResultSetSingleHelper objRsSH=null;		/** �䱸�� �󼼺��� ���� */
	ResultSetHelper objRs=null;				/**�䱸 ��� */

	try {
		/**�䱸�� ���� �븮�� New */
		objReqBox=new MemRequestBoxDelegate();
		objSendBean = new SendReqBoxDelegate();
		objCmtSubmt = new CmtSubmtReqBoxDelegate();

		/**�䱸�� �̿� ���� üũ */
		boolean blnHashAuth=objReqBox.checkReqBoxAuth((String)objParams.getParamValue("ReqBoxID"),objUserInfo.getOrganID()).booleanValue();
		if(!blnHashAuth){
			objMsgBean.setMsgType(MessageBean.TYPE_WARN);
			objMsgBean.setStrCode("DSAUTH-0001");
			objMsgBean.setStrMsg("�ش� �䱸���� �� ������ �����ϴ�.");
			//out.println("�ش� �䱸���� �� ������ �����ϴ�.");
%>
			<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
			return;
		} else {
			/** �䱸�� ���� */
			objRsSH=new ResultSetSingleHelper(objReqBox.getRecord((String)objParams.getParamValue("ReqBoxID"), CodeConstants.REQ_BOX_STT_006));
			/**�䱸 ���� �븮�� New */
			objReqInfo=new MemRequestInfoDelegate();
			objRs=new ResultSetHelper(objReqInfo.getRecordList(objParams));
		}/**���� endif*/

		/*
		 * 2005-07-26 kogaeng ADD
		 * �䱸���� �䱸�鿡 �亯���� �����ϴ����� üũ�ϴ� �Լ��� Ȱ��
		 * true�� ��ȯ�Ǹ� ������ �����ϴٶ�� ���. true ==> N
		 * false�� ��ȯ�Ǹ� ������ �� ���ٶ�� ���̴� false ==> Y
		 */
		if(objSendBean.checkDelReqBoxPermit((String)objParams.getParamValue("ReqBoxID"))) existFlag = "N";
		else existFlag = "Y";

	} catch(AppException objAppEx) {
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		objMsgBean.setStrCode(objAppEx.getStrErrCode());
		objMsgBean.setStrMsg(objAppEx.getMessage());
		//out.println("<br>Error!!!" + objAppEx.getMessage());
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}

	/*************************************************************************************************/
	/** 					������ �� �Ҵ�  Part 														  */
	/*************************************************************************************************/

	/**�䱸���� �����ȸ�� ��� ��ȯ.*/
	int intTotalRecordCount=objRs.getTotalRecordCount();
	int intCurrentPageNum=objRs.getPageNumber();
	int intTotalPage=objRs.getTotalPageCount();
%>
<jsp:include page="/inc/header.jsp" flush="true"/>
<link href="/css2/style.css" rel="stylesheet" type="text/css">
<script language="javascript">
  /** ���Ĺ�� �ٲٱ� */
  function changeSortQuery(sortField,sortMethod){
  	formName.ReqInfoSortField.value=sortField;
  	formName.ReqInfoSortMtd.value=sortMethod;
  	formName.target = '';
  	formName.submit();
  }

  /**�䱸�󼼺���� ����.*/
  function gotoDetail(strID){
  	formName.ReqInfoID.value=strID;
  	formName.action="./RSendReqInfoVList.jsp";
  	formName.target = '';
  	formName.submit();
  }

  /** ������� ���� */
  function gotoList(){
  	formName.action="./RSendBoxList.jsp";
  	formName.target = '';
  	formName.submit();
  }

  /** ����¡ �ٷΰ��� */
  function goPage(strPage){
  	formName.ReqInfoPage.value=strPage;
  	formName.target = '';
  	formName.submit();
  }

  function deleteReqBox(strBoxID){
  	var f = document.formName;
	if(confirm("�ش�䱸���� ���� �Ͻðڽ��ϱ�?")){
		f.ReqBoxIDs.value = strBoxID;
		f.action ="RSendBoxDelProc.jsp";
		f.target = "popwin";
		window.open('/blank.html', 'popwin', 'width=40, height=40, left=2000, top=2000');
		var winl = (screen.width - 304) / 2;
		var winh = (screen.height - 118) / 2;
		document.all.loadingDiv.style.left = winl;
		document.all.loadingDiv.style.top = winh;
		document.all.loadingDiv.style.display = '';
		f.submit();
	}
  }

	function copyReqBox(ReqBoxID) {
		if(confirm("�ش�䱸���� �����Ͻðڽ��ϱ�?")){
  			NewWindow('/reqsubmit/common/MemReqBoxCopyList.jsp?ReqBoxID='+ReqBoxID,'', '640', '450');
	  	}
	}
</script>
<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="/js/reqsubmit/reqboxview.js"></SCRIPT>
</head>

<body>
<DIV ID="loadingDiv" style="display:none;position:absolute;">
	<img src="/image/reqsubmit/loading.jpg" border="0"> </td>
</DIV>
<div id="wrap">
<div id="balloonHint" style="display:none;height:100px">
<table border="0" cellspacing="0" cellpadding="4">
	<tr>
		<td bgcolor="#EBF2F5" width="30" height="20" align="center" style="border-left:1px solid #808080;border-top:1px solid #808080;border-bottom:2px solid #808080;"><font style="font-size:11px;font-family:verdana,����;font-weight:bold">�䱸<BR>��<BR>����</font></td>
		<td style="border-left:1px solid #808080;border-top:1px solid #808080;border-bottom:2px solid #808080;border-right:2px solid #808080;text-align:justify;word-break:break-all;" width="220">
			<font style="font-size:11px;font-family:verdana,����">{{hint}}</font>
		</td>
	</tr>
</table>
</div>
<SCRIPT language="JavaScript" src="/js2/reqsubmit/tooltip.js"></SCRIPT>
<script language="javascript">balloonHint("balloonHint")</script>
  <jsp:include page="/inc/top.jsp" flush="true"/>
  <jsp:include page="/inc/top_menu02.jsp" flush="true"/>
  <div id="container">
    <div id="leftCon">
      <jsp:include page="/inc/log_info.jsp" flush="true"/>
      <jsp:include page="/inc/left_menu02.jsp" flush="true"/>
	<SCRIPT language="JavaScript" src="/js/reqsubmit/reqinfo.js"></SCRIPT>
    </div>
    <div id="rightCon">
<form name="formName" method="<%=nads.lib.reqsubmit.EnvConstants.FORM_METHOD%>" action="<%=request.getRequestURI()%>"><!--�䱸�� �ű����� ���� -->
<%//�䱸�� ���� ���� �ޱ�.
	String strReqBoxSortField=objParams.getParamValue("ReqBoxSortField");
	String strReqBoxSortMtd=objParams.getParamValue("ReqBoxSortMtd");
	//�䱸�� ������ ��ȣ �ޱ�.
	String strReqBoxPagNum=objParams.getParamValue("ReqBoxPage");
	//�䱸�� ��ȸ���� �ޱ�.
	String strReqBoxQryField=objParams.getParamValue("ReqBoxQryField");
	String strReqBoxQryTerm=objParams.getParamValue("ReqBoxQryTerm");
	//�䱸 ���� ���� ���� �ޱ�.
	String strReqInfoSortField=objParams.getParamValue("ReqInfoSortField");
	String strReqInfoSortMtd=objParams.getParamValue("ReqInfoSortMtd");
	//�䱸�� ���� ������ ��ȣ �ޱ�.
	String strReqInfoPagNum=objParams.getParamValue("ReqInfoPage");
	//�䱸��ȸ�����±׾��ֱ�����.
	objParams.getFormElement("ReqInfoQryField").setFormTagType(nads.lib.reqsubmit.form.FormElement.FORM_TAG_TYPE_SESSION);
	objParams.getFormElement("ReqInfoQryTerm").setFormTagType(nads.lib.reqsubmit.form.FormElement.FORM_TAG_TYPE_SESSION);
	%>
	<%=objParams.getHiddenFormTags()%>

<!-- 2005-09-27 kogaeng ADD -->
<input type="hidden" name="ReturnUrl" value="<%=request.getRequestURI()%>"><!--�ǵ��ƿ� URL -->

      <!-- pgTit -->
      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=MenuConstants.REQ_BOX_SEND_END%><span class="sub_stl" >- <%=MenuConstants.REQ_BOX_DETAIL_VIEW%></span></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.getReqBoxGeneral(request)%> > <%=MenuConstants.REQ_BOX_SEND_END%></div>
        <p><!--����--></p>
      </div>
      <!-- /pgTit -->

      <!-- contents -->

      <div id="contents">

        <!-- �˻����� ���� ��� �Ʒ� div ���� �� �ּ����� ��������.-->
        <!-- /�˻�����-->


        <!-- �������� ���� -->
         <!-- list view-->

        <span class="list02_tl">�䱸�� ���� </span>

		<!-- ��� ��ư-->
		<!--�䱸�� ���, ���ε�, �䱸�� ����, �亯�� �̸� ����, �亯�� �߼�, �������� ����-->
        <div class="top_btn">
		 <samp>
		<%
			String strJscript = "";
			if(existFlag.equals("N")) strJscript = "javascript:deleteReqBox('"+objRsSH.getObject("REQ_BOX_ID")+"')";
			else strJscript = "alert('���������� �亯 �ۼ��� ���� ���̹Ƿ� ������ �Ͻ� �� �����ϴ�.')";
		%>
			 <span class="btn"><a href="<%= strJscript %>">�䱸�� ����</a></span>
			 <span class="btn"><a href="javascript:copyReqBox('<%=objRsSH.getObject("REQ_BOX_ID")%>')">�䱸�� ����</a></span>
			 <span class="btn"><a href="javascript:gotoList()">�䱸�� ���</a></span>
		  </samp>
		 </div>

        <!-- /��� ��ư-->


        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list02">

            <tr>

              <th scope="col">&bull;&nbsp;�䱸�Ը� </th>
				  <td colspan="3"><%=objRsSH.getObject("REQ_BOX_NM")%></td>
            </tr>
<%
	// 2004-07-08 �繫ó, ����ó�� ��쿡�� ����ȸ��°� ��������
	if (CodeConstants.ORGAN_GBN_ASM.equalsIgnoreCase(objUserInfo.getOrganGBNCode()) || CodeConstants.ORGAN_GBN_BUD.equalsIgnoreCase(objUserInfo.getOrganGBNCode())) {
	} else {

	//�䱸�� ���� ����.
	String strReqBoxStt=(String)objRsSH.getObject("REQ_BOX_STT");
%>
            <tr>
              <th scope="col">&bull;&nbsp;�Ұ� ����ȸ </th>
			  <td><%=objRsSH.getObject("CMT_ORGAN_NM")%>
				<%
					// 2004-06-17 kogaeng modified
					String strElcDocNo = (String)objRsSH.getObject("DOC_NO");
					if (StringUtil.isAssigned(strElcDocNo)) out.println(" (���ڹ�����ȣ : "+strElcDocNo+")");
				%>
				</td>
            </tr>
<% } %>
             <tr>
              <th scope="col">&bull;&nbsp;�߼����� </th>
			  <td colspan="3">
				 <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list_none">
					 <tr>
						 <td width="17" rowspan="2"><img src="/images2/common/icon_assembly.gif" width="16" height="13" /></td>
						 <td><%=(String)objRsSH.getObject("REQ_ORGAN_NM")%></td>
						 <td rowspan="2"><img src="/images2/common/arrow01.gif" width="26" height="14" /></td>
						 <td width="15" rowspan="2"><img src="/images2/common/icon_cube.gif" width="11" height="15" /></td>
						 <td><%=(String)objRsSH.getObject("SUBMT_ORGAN_NM")%></td>
					 </tr>
					 <tr>
						 <td class="fonts"><%=(String)objRsSH.getObject("REGR_NM")%></td>
						 <td class="fonts"><%=(String)objRsSH.getObject("RCVR_NM")%> (<a href="mailto:<%=(String)objRsSH.getObject("RCVR_EMAIL")%>"><%=(String)objRsSH.getObject("RCVR_EMAIL")%></a>)
						 <br>(<%=(String)objRsSH.getObject("RCVR_OFFICE_TEL")%>/<%=(String)objRsSH.getObject("RCVR_CPHONE")%>)</td>
					 </tr>
				 </table>
			</td>

            </tr>
            <tr>
              <th scope="col" rowspan="2">&bull;&nbsp;�䱸���̷� </th>  <td colspan="3">
              <ul class="list_in">
              <li><span class="tl">&bull;&nbsp;�䱸�Ի����Ͻ� :</span> <%=StringUtil.getDate2((String)objRsSH.getObject("REG_DT"))%></li>
              <li><span class="tl">&bull;&nbsp;�䱸���߼��Ͻ� :</span> <%=StringUtil.getDate2((String)objRsSH.getObject("LAST_REQ_DOC_SND_DT"))%></li>
              </ul>
              </td>
            </tr>
              <tr>
			  <td colspan="3">
              <ul class="list_in">
              <li><span class="tl">&bull;&nbsp;��������ȸ�Ͻ� :</span> <%=StringUtil.getDate2((String)objRsSH.getObject("FST_QRY_DT"))%></li>
              <li><span class="tl">&bull;&nbsp;������� :</span>
			  <%=StringUtil.getDate((String)objRsSH.getObject("SUBMT_DLN"))%> 24:00</li>

              </ul>
              </td>
            </tr>
                <tr>
              <th scope="col">&bull;&nbsp;�䱸�Լ��� </th>   <td colspan="3"><%=StringUtil.getDescString((String)objRsSH.getObject("REQ_BOX_DSC"))%></td>
            </tr>
        </table>
        <!-- /list view -->
        <p class="warning mt10">�䱸�� ������ ���������� ��ϵ� �䱸�� ���� �亯�� �ۼ����� ���� ��쿡�� �����մϴ�.</p>
		<p class="warning mt10">�䱸�� ���縦 ���� ������ �䱸���� �ۼ��� �䱸�Կ��� Ȯ���Ͻ� �� �ֽ��ϴ�.</p><br><br>
		<!-- �亯�� �߼� -->
        <div id="btn_all"><div  class="t_right">
          <div class="mi_btn"><a href="javascript:ReqDocOpenView('<%= (String)objParams.getParamValue("ReqBoxID") %>')"><span>�䱸�� ����</span></a></div>
        </div></div>


        <!-- list -->
        <span class="list01_tl">�䱸 ��� <span class="list_total">&bull;&nbsp;��ü�ڷ�� : <%= intTotalRecordCount %>�� (<%= intCurrentPageNum %>/<%= intTotalPage %> page)</span></span>
		<table>
			<tr>
				<td>&nbsp;</td>
			</tr>
		</table>
        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
          <thead>
            <tr>
			  <th scope="col"><input name="checkAll" type="checkbox" class="borderNo" onClick="checkAllOrNot(document.formName);"/></th>
              <th scope="col"><a>NO</a></th>
			<%
			int intTmpWidth1=490;
			if(objUserInfo.getOrganGBNCode().equals("003")){//�ǿ��ǼҼ�
			  intTmpWidth1=intTmpWidth1-50;
			}//endif�ǿ��ǼҼ�Ȯ��
			%>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","REQ_CONT",strReqInfoSortField,strReqInfoSortMtd,"�䱸����")%></th>
              <th scope="col" style="width:40%; "><%=SortingUtil.getSortLink("changeSortQuery","OPEN_CL",strReqInfoSortField,strReqInfoSortMtd,"�������")%></th>
			<%
			if(objUserInfo.getOrganGBNCode().equals("003")){//�ǿ��ǼҼ�
			%>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","CMT_REQ_APP_FLAG",strReqInfoSortField,strReqInfoSortMtd,"����ȸ")%></th>
			<%
			}//endif�ǿ��ǼҼ�Ȯ��
			%>
              <th scope="col"><a>�亯</a></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","REG_DT",strReqInfoSortField,strReqInfoSortMtd,"����Ͻ�")%></th>
            </tr>
          </thead>
          <tbody>
		<%
		  int intRecordNumber=intTotalRecordCount - ((intCurrentPageNum -1) * Integer.parseInt((String)objParams.getParamValue("ReqInfoPageSize")));
		  String strReqInfoID="";
		  String strCmtApplyValue = "Y";
		  while(objRs.next()){
			 strReqInfoID=(String)objRs.getObject("REQ_ID");
			 /** ����ȸ��û��������(Y) �ƴ��� "" ����*/
			if(CodeConstants.isDuplatedApplyToCmtReq((String)objRs.getObject("CMT_REQ_APP_FLAG"))) strCmtApplyValue = "";
			else strCmtApplyValue="Y";
		 %>
            <tr>
              <td><input name="ReqInfoIDs" type="checkbox" value="<%=strReqInfoID%>"  class="borderNo"/></td>
              <td><%= intRecordNumber %></td>
			<%
			int intTmpWidth2=500;
			if(objUserInfo.getOrganGBNCode().equals("003")){//�ǿ��ǼҼ�
			  intTmpWidth2=intTmpWidth2-50;
			}//endif�ǿ��ǼҼ�Ȯ��
			%>
              <td style="text-align:left;"><%=StringUtil.getNotifyImg((String)objRs.getObject("REG_DT"),(String)objRs.getObject("REQ_STT"))%><a href="JavaScript:gotoDetail('<%=strReqInfoID%>');" hint="<%= (String)objRs.getObject("REQ_DTL_CONT") %>"><%=StringUtil.substring((String)objRs.getObject("REQ_CONT"),35)%></a></td>
              <td><%=CodeConstants.getOpenClass((String)objRs.getObject("OPEN_CL"))%></td>
			<%
			if(objUserInfo.getOrganGBNCode().equals("003")){//�ǿ��ǼҼ�
			%>
              <td><%=CodeConstants.getCmtRequestAppoint((String)objRs.getObject("CMT_REQ_APP_FLAG"))%></td>
			<%
			}//endif�ǿ��ǼҼ�Ȯ��
			%>
			<td><%=nads.lib.reqsubmit.util.DBAccessUtil.makeAnsInfoHtml((String)objRs.getObject("ANS_ID"),(String)objRs.getObject("ANS_MTD"),(String)objRs.getObject("ANS_OPIN"),(String)objRs.getObject("SUBMT_FLAG"),objUserInfo.isRequester())%></td>
              <td><%= StringUtil.getDate2((String)objRs.getObject("REG_DT")) %></td>
            </tr>
			<input type="hidden" name="ReqID" value="<%= strReqInfoID %>">
			<input type="hidden" name="CmtApplys" value="<%=strCmtApplyValue%>">
<%
		intRecordNumber--;
	} //endwhile
%>
	<%
	/*��ȸ��� ������ ��� ����.*/
	if(objRs.getRecordSize()<1){
	%>
	<tr>
	 <td colspan="7" align="center">��ϵ� �䱸������ �����ϴ�.</td>
            </tr>
	<%
	}/*��ȸ��� ������ ��� ��.*/
	%>
          </tbody>
        </table>
        <!-- /list -->

        <!-- ����¡-->
					<!--	<%= PageCount.getLinkedString(
								new Integer(intTotalRecordCount).toString(),
								new Integer(intCurrentPageNum).toString(),
								objParams.getParamValue("ReqInfoPageSize"))
						%>
						-->
						<%=objPaging.pagingTrans(PageCount.getLinkedString(
							new Integer(intTotalRecordCount).toString(),
							new Integer(intCurrentPageNum).toString(),
							objParams.getParamValue("ReqInfoPageSize")))%>

       <!-- /����¡-->


       <!-- ����Ʈ ��ư-->
        <div id="btn_all" >        <!-- ����Ʈ �� �˻� -->
        <div class="list_ser" >
		<%
			String strReqInfoQryField=(String)objParams.getParamValue("ReqInfoQryField");
		%>
          <select name="ReqInfoQryField" class="selectBox5"  style="width:70px;" >
           <option <%=(strReqInfoQryField.equalsIgnoreCase("req_cont"))? " selected ": ""%>value="req_cont">�䱸����</option>
			<option <%=(strReqInfoQryField.equalsIgnoreCase("req_dtl_cont"))? " selected ": ""%>value="req_dtl_cont">�䱸����</option>
          </select>
          <input name="ReqInfoQryTerm" onKeyDown="return ch()" onMouseDown="return ch()" alue="<%=objParams.getParamValue("ReqInfoQryTerm")%>"
		 class="li_input"  style="width:100px"/>
          <img src="/images2/btn/bt_list_search.gif"  onMouseOver="menuOn(this);" onMouseOut="menuOut(this);" onClick="gotoReqInfoSearch(formName);"/></div>
        <!-- /����Ʈ �� �˻�
		-->
			<span class="right">
			<span class="list_bt" onclick="javascript:copyMemReqInfo(formName);return false;"><a href="#">�䱸 ����</a></span>
		
<!--
			<span class="list_bt"><a href="#">�䱸����</a></span>
			<span class="list_bt"><a href="#">�䱸����</a></span>
-->
			</span>
		</div>

        <!-- /����Ʈ ��ư-->
        <!-- /�������� ���� -->
      </div>
      <!-- /contents -->

    </div>
</form>
  </div>
  <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>