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
<%@ page import="nads.dsdm.app.reqsubmit.delegate.cmtsubmt.CmtSubmtReqBoxDelegate" %>
<%@ page import="nads.dsdm.app.common.page.PagingDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.answerinfo.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.SMemReqBoxDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%
	/*** PagingDelegate */
	PagingDelegate objPaging=new PagingDelegate(); 		/*����¡ ��ȯ Delegate*/
%>
<%
	UserInfoDelegate objUserInfo =null;
	CDInfoDelegate objCdinfo =null;
%>

<%@ include file="../../../common/RUserCodeInfoInc.jsp" %>

<%
	/*************************************************************************************************/
	/** 					�Ķ���� üũ Part 														  */
	/*************************************************************************************************/

	/**�Ϲ� �䱸�� �󼼺��� �Ķ���� ����.*/
	RMemReqBoxVListForm objParams =new RMemReqBoxVListForm();
	//�䱸��Ŭ���� ANSW_INQ_YN�� ���� 2016.02.17 ksw
	AnsInfoDelegate objSMAIDelegate = new AnsInfoDelegate();
    //�߰��亯 �� ���⿩��Ȯ��
    SMemReqBoxDelegate sReqDelegate = new SMemReqBoxDelegate();
	objParams.setParamValue("IsRequester",String.valueOf(objUserInfo.isRequester()));//�䱸�亯�ڿ��μ���
	boolean blnParamCheck=false;
	/**���޵� �ĸ����� üũ */
	blnParamCheck=objParams.validateParams(request);
	if(blnParamCheck==false){
		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
		objMsgBean.setStrCode("DSPARAM-0000");
		objMsgBean.setStrMsg(objParams.getStrErrors());
		//out.println("ParamError:" + objParams.getStrErrors());
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}//endif

	//�䱸��Ŭ���� ANSW_INQ_YN�� ���� 2016.02.17 ksw
	String strBoxId = request.getParameter("ReqBoxID");
	//�亯�Ϸ�� �Ŀ� �߰��亯 �ִ��� ���� Ȯ��
	int intNotSubmitAnsCnt = sReqDelegate.getAnsCntNotSubmit(strBoxId);
	System.out.println("kangthis logs RMakeEndVList.jsp(strBoxId) => " + strBoxId);
	System.out.println("kangthis logs RMakeEndVList.jsp(intNotSubmitAnsCnt) => " + intNotSubmitAnsCnt);
	if (intNotSubmitAnsCnt > 0) {
		int intUpdateResult = objSMAIDelegate.setRecordToAnsInfo_view1(strBoxId);	
	}	

	/*** Delegate �� ������ Container��ü ���� */
	MemRequestBoxDelegate objReqBox=null; 		/**�䱸�� Delegate*/
	MemRequestInfoDelegate  objReqInfo=null;	/** �䱸���� Delegate */
	CmtSubmtReqBoxDelegate objCmtSubmt = null;

	ResultSetSingleHelper objRsSH=null;		/** �䱸�� �󼼺��� ���� */
	ResultSetHelper objRs=null;				/**�䱸 ��� */

	try{
		/**�䱸�� ���� �븮�� New */
		objReqBox=new MemRequestBoxDelegate();
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
			objRsSH=new ResultSetSingleHelper(objReqBox.getRecord((String)objParams.getParamValue("ReqBoxID"), CodeConstants.REQ_BOX_STT_007));
			/**�䱸 ���� �븮�� New */
			objReqInfo=new MemRequestInfoDelegate();
			objRs=new ResultSetHelper(objReqInfo.getRecordEndList(objParams));
		}/**���� endif*/
	}catch(AppException objAppEx){
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		objMsgBean.setStrCode(objAppEx.getStrErrCode());
		objMsgBean.setStrMsg(objAppEx.getMessage());
		//out.println("<br>Error!!!" + objAppEx.getMessage());
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}

	/**�䱸���� �����ȸ�� ��� ��ȯ.*/
	int intTotalRecordCount=objRs.getTotalRecordCount();
	int intCurrentPageNum=objRs.getPageNumber();
	int intTotalPage=objRs.getTotalPageCount();
%>
<jsp:include page="/inc/header.jsp" flush="true"/>
<link href="/css2/style.css" rel="stylesheet" type="text/css">
<style type="text/css">
	.tooltip_text, .tooltip_close{
		cursor: pointer;
	}
	div.tooltip {
		
		position:absolute;
	}
</style>
<script language="javascript">
  /** ���Ĺ�� �ٲٱ� */
  function changeSortQuery(sortField,sortMethod){
  	formName.ReqInfoSortField.value=sortField;
  	formName.ReqInfoSortMtd.value=sortMethod;
  	formName.submit();
  }

  /**�䱸�Ի󼼺���� ����.*/
  function gotoDetail(strID){
  	formName.ReqInfoID.value=strID;
  	formName.action="./RMakeEndReqInfoVList.jsp";
  	formName.submit();
  }

  /** ������� ���� */
  function gotoList(){
  	formName.action="./RMakeEndList.jsp";
  	formName.submit();
  }

  /** ����¡ �ٷΰ��� */
  function goPage(strPage){
  	formName.ReqInfoPage.value=strPage;
  	formName.submit();
  }

  /** �䱸�� ���� */
  function viewReqDoc(){
 	window.open("/reqsubmit/common/ReqDocView.jsp?ReqBoxId=<%= (String)objParams.getParamValue("ReqBoxID") %>&ReqTp=001", "",
	"resizable=no,menubar=no,status=yes,titlebar=yes,scrollbars=no,location=no,toolbar=no,height=600,width=800" );
  }

  /** �亯�� ���� */

  function viewAnsDoc(){
  	window.open("/reqsubmit/common/AnsDocView.jsp?ReqBoxId=<%= (String)objParams.getParamValue("ReqBoxID") %>", "",
	"resizable=no,menubar=no,status=yes,titlebar=yes,scrollbars=no,location=no,toolbar=no,height=600,width=800" );
  }

	function copyReqBox(ReqBoxID) {
		if(confirm("�ش�䱸���� �����Ͻðڽ��ϱ�?")){
  			NewWindow('/reqsubmit/common/MemReqBoxCopyList.jsp?ReqBoxID=<%= (String)objParams.getParamValue("ReqBoxID") %>','', '640', '450');
  		}
	}
</script>
<script type="text/javascript">
	$(document).ready(function(){
		//alert ('jQuery running');
		
		/* �⺻ ������ ���� */
		var defaults = {
			w : 170, /*���̾� �ʺ�*/
			padding: 0,
			bgColor: '#F6F6F6',
			borderColor: '#333'
		};
		
		var options = $.extend(defaults, options);
		
		/* ���̾� â �ݱ� */
		$(".tooltip_close").click(function(){
			$(this).parents(".tooltip").css({display:'none'});
		});
		
		/* ���콺 ������ */
		$('span.tooltip_text').hover(
			function(over){

				var top = $(this).offset().top;
				var left = $(this).offset().left;
				
				$(".tooltip").css({display:'none'});
				
				$(this).next(".tooltip").css({
					display:'',
					top:  top + 20 + 'px',
					left: left + 'px',
					background : options.bgColor,
					padding: options.padding,
					paddingRight: options.padding+1,
					width: (options.w+options.padding)
				});
				
				
			},
			/* ���콺 �ƿ��� */			   
			function(out){
				//$(this).html(currentText);
				//$('#link-text').pa
			}
		);
		
		


		
	});
	
	function test(){
		//$("button").next().css()
		//$("button").css({top});
	}
</script>
<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="/js/reqsubmit/reqboxview.js"></SCRIPT>
</head>

<body>
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

<form name="formName" method="get" action="<%=request.getRequestURI()%>"><!--�䱸�� �ű����� ���� -->
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
			<input type="hidden" name="ReturnUrl" value="<%=request.getRequestURI()%>"><!--�ǵ��ƿ� URL -->

      <!-- pgTit -->

      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=MenuConstants.REQ_BOX_MAKE_END%><span class="sub_stl" >- <%=MenuConstants.REQ_BOX_DETAIL_VIEW%></span></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.getReqBoxGeneral(request)%> > <%=MenuConstants.REQ_BOX_MAKE_END%></div>
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

         <div class="top_btn">
			<samp>
			<span class="btn"><a href="#"
			onClick="copyReqBox(<%= (String)objParams.getParamValue("ReqBoxID") %>)"">�䱸�� ����</a></span>
			<span class="btn"><a href="#" onClick="submtBindingJob(formName,'<%=(String)objParams.getParamValue("ReqBoxID")%>')">���ε�</a></span>
			<span class="btn"><a href="#" onClick="gotoList()">�䱸�� ���</a></span>
			</samp>
		 </div>

        <!-- /��� ��ư-->

        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list02">
            <tr>
              <th width="100px;" scope="col">&bull;&nbsp;�䱸�Ը� </th>
				  <td colspan="3"><%=objRsSH.getObject("REQ_BOX_NM")%></td>

		<%
			// 2004-07-08 �繫ó, ����ó�� ��쿡�� ����ȸ��°� ��������
			if (CodeConstants.ORGAN_GBN_ASM.equalsIgnoreCase(objUserInfo.getOrganGBNCode()) || CodeConstants.ORGAN_GBN_BUD.equalsIgnoreCase(objUserInfo.getOrganGBNCode())) {
			} else {
		  //�䱸�� ���� ����.
		  String strReqBoxStt=(String)objRsSH.getObject("REQ_BOX_STT");
		%>
            <tr>
              <th scope="col">&bull;&nbsp;�Ұ� ����ȸ </th>
			  <td>
				<%=objRsSH.getObject("CMT_ORGAN_NM")%>
				<%
					// 2004-06-17 kogaeng modified
					String strElcDocNo = (String)objRsSH.getObject("DOC_NO");
					if (StringUtil.isAssigned(strElcDocNo)) out.println(" (���ڹ�����ȣ : "+strElcDocNo+")");
				%>
			  </td>
            </tr>
		<% } %>
             <tr>
              <th scope="col">&bull;&nbsp;�������� </th>
			  <td colspan="3">
				 <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list_none">
					 <tr>
						 <td width="17" rowspan="2"><img src="/images2/common/icon_assembly.gif" width="16" height="13" /></td>
						 <td><%=(String)objRsSH.getObject("SUBMT_ORGAN_NM")%></td>
						 <td rowspan="2" width="150"><img src="/images2/common/arrow01.gif" width="26" height="14" /></td>
						 <td width="15" rowspan="2"><img src="/images2/common/icon_cube.gif" width="11" height="15" /></td>
						 <td><%=(String)objRsSH.getObject("REQ_ORGAN_NM")%></td>
					 </tr>
					 <tr>
						 <td class="fonts"><%=(String)objRsSH.getObject("RCVR_NM")%> (<a href="mailto:<%=(String)objRsSH.getObject("RCVR_EMAIL")%>"><%=(String)objRsSH.getObject("RCVR_EMAIL")%></a>) <br>(<%=(String)objRsSH.getObject("RCVR_OFFICE_TEL")%>/<%=(String)objRsSH.getObject("RCVR_CPHONE")%>)</td>
						 <td class="fonts"><%=(String)objRsSH.getObject("REGR_NM")%></td>
					 </tr>
				 </table>
			</td>

            </tr>
             <tr>

              <th scope="col" rowspan="2">&bull;&nbsp;�䱸���̷� </th>  <td colspan="3">
              <ul class="list_in">
              <li><span class="tl">&bull;&nbsp;�䱸�Ի����Ͻ� :</span> <%=StringUtil.getDate2((String)objRsSH.getObject("REG_DT"))%></li>
              <li><span class="tl">&bull;&nbsp;�䱸���߼��Ͻ� :</span><%=StringUtil.getDate2((String)objRsSH.getObject("LAST_REQ_DOC_SND_DT"))%></li>
              </ul>
              </td>
            </tr>
             <tr>
			 <td colspan="3">
              <ul class="list_in">
              <li><span class="tl">&bull;&nbsp;��������ȸ�Ͻ�:</span><%=StringUtil.getDate2((String)objRsSH.getObject("FST_QRY_DT"))%></li>
              <li><span class="tl">&bull;&nbsp;������� :</span><%=StringUtil.getDate((String)objRsSH.getObject("SUBMT_DLN"))%> 24:00</li>
			  <li><span class="tl">&bull;&nbsp;�亯���߼��Ͻ�:</span> <%=StringUtil.getDate2((String)objRsSH.getObject("LAST_ANS_DOC_SND_DT"))%></li>
              </ul>
              </td>
            </tr>

                <tr>
              <th scope="col">&bull;&nbsp;�䱸�Լ��� </th>   <td colspan="3"><%=StringUtil.getDescString((String)objRsSH.getObject("REQ_BOX_DSC"))%></td>
            </tr>
        </table>
        <!-- /list view -->
        <p class="warning mt10">* �䱸�� ���縦 ���� ������ �䱸���� �ۼ��� �䱸�Կ��� Ȯ���Ͻ� �� �ֽ��ϴ�.</p><br><br>
		<!-- �亯�� �߼� -->

        <div id="btn_all"><div  class="t_right">
			<div class="mi_btn"><a href="#" onClick="ReqDocOpenView('<%= (String)objParams.getParamValue("ReqBoxID") %>')"><span>�䱸�� ����</span></a></div>
			<div class="mi_btn"><a href="#" onClick="AnsDocOpenView('<%= (String)objParams.getParamValue("ReqBoxID") %>')"><span>�亯�� ����</span></a></div>
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
			  <th scope="col" style="width:15px"><input name="checkAll" type="checkbox" class="borderNo" onClick="checkAllOrNot(document.formName);" /></th>
              <th scope="col" style="width:15px"><a>NO</a></th>
			<%
				int intTmpWidth1=490;
				if(objUserInfo.getOrganGBNCode().equals("003")){//�ǿ��ǼҼ�
				  intTmpWidth1=intTmpWidth1-50;
				}//endif�ǿ��ǼҼ�Ȯ��
			%>
              <th scope="col" style="width:250px;text-align:center;"><%=SortingUtil.getSortLink("changeSortQuery","REQ_CONT",strReqInfoSortField,strReqInfoSortMtd,"�䱸����")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","OPEN_CL",strReqInfoSortField,strReqInfoSortMtd,"�������")%></th>
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
	  List objOpenClassList=CodeConstants.getOpenClassList();
	  String strCmtApplyValue = "Y";
	  while(objRs.next()){
		 strReqInfoID=(String)objRs.getObject("REQ_ID");
		 /** ����ȸ��û��������(Y) �ƴ��� "" ����*/
		if(CodeConstants.isDuplatedApplyToCmtReq((String)objRs.getObject("CMT_REQ_APP_FLAG"))) strCmtApplyValue = "";
		else strCmtApplyValue="Y";
	 %>
            <tr>
              <td><input name="ReqInfoIDs" type="checkbox" value="<%= strReqInfoID %>"  class="borderNo" /></td>
              <td><%=intRecordNumber%></td>
			<%
				int intTmpWidth2=490;
				if(objUserInfo.getOrganGBNCode().equals("003")){//�ǿ��ǼҼ�
				  intTmpWidth2=intTmpWidth2-50;
				}//endif�ǿ��ǼҼ�Ȯ��
			%>
              <td style="text-align:left;"><%=StringUtil.getNotifyImg((String)objRs.getObject("REG_DT"),(String)objRs.getObject("REQ_STT"))%><a href="JavaScript:gotoDetail('<%=strReqInfoID%>');" hint="<%= (String)objRs.getObject("REQ_DTL_CONT") %>"><%=StringUtil.substring((String)objRs.getObject("REQ_CONT"),35)%></a>
			  </td>
              <td><%=CodeConstants.getOpenClass((String)objRs.getObject("OPEN_CL"))%></td>
			<%
				if(objUserInfo.getOrganGBNCode().equals("003")){//�ǿ��ǼҼ�
			%>
              <td><%=CodeConstants.getCmtRequestAppoint((String)objRs.getObject("CMT_REQ_APP_FLAG"))%></td>
			<%
				}//endif�ǿ��ǼҼ�Ȯ��
			%>
              <td>
				<span class="tooltip_text"><%=this.makeAnsInfoImg((String)objRs.getObject("ANS_ID"),(String)objRs.getObject("ANS_MTD"),(String)objRs.getObject("ANS_OPIN"),(String)objRs.getObject("SUBMT_FLAG"),objUserInfo.isRequester(),"","_blank","")%></span> 
				<div class="tooltip" style="display:none;">
					<table width=100% height=100%>
					  <tr>
					   <td width=100% height=5% style="align:right">
						<img src="/images/bt-close.gif" style="cursor:hand" align="absmiddle" border="0" class="tooltip_close">
					   </td>
					  </tr>
					  <tr> 
					   <td  bgcolor="#FFFFFF" align="left" ><%=this.makeAnsInfoHtml2((String)objRs.getObject("ANS_ID"),(String)objRs.getObject("ANS_MTD"),(String)objRs.getObject("ANS_OPIN"),(String)objRs.getObject("SUBMT_FLAG"),objUserInfo.isRequester(),"","_blank","",StringUtil.substring((String)objRs.getObject("REQ_CONT"),35),(String)objRsSH.getObject("SUBMT_ORGAN_NM"))%></td>
					  </tr>
					 </table>
				</div>
			  </td>
              <td><%=StringUtil.getDate2((String)objRs.getObject("REG_DT"))%></td>
            </tr>
			<input type="hidden" name="ReqID" value="<%= strReqInfoID %>">
			<input type="hidden" name="CmtApplys" value="<%=strCmtApplyValue%>">
		<%
				intRecordNumber --;
			}//endwhile
		%>
		<%
		/*��ȸ��� ������ ��� ����.*/
		if(objRs.getRecordSize()<1){
		%>
			<tr>
			<%
				int intTmpWidth2=490;
				if(objUserInfo.getOrganGBNCode().equals("003")){//�ǿ��ǼҼ�
				  intTmpWidth2=intTmpWidth2-50;
				}//endif�ǿ��ǼҼ�Ȯ��
			%>
				<td colspan="6" align="center"> ��ϵ� �䱸������ �����ϴ�. </td>
			<%
				if(objUserInfo.getOrganGBNCode().equals("003")){//�ǿ��ǼҼ�
			%>
				<td colspan="5" align="center"> ��ϵ� �䱸������ �����ϴ�. </td>
			<%
				}//endif�ǿ��ǼҼ�Ȯ��
			%>
            </tr>
		<%
			}/*��ȸ��� ������ ��� ��.*/
		%>
          </tbody>
        </table>
        <p class="warning mt10">* �亯�� �ۼ��� �䱸�� üũ�ڽ��� ������ �ֽ� �� �Ʒ��� �亯 �ۼ� ��ư�� Ŭ���� �ֽñ� �ٶ��ϴ�..</p>
        <!-- /list -->

        <!-- ����¡-->

						<%=objPaging.pagingTrans(PageCount.getLinkedString(
							new Integer(intTotalRecordCount).toString(),
							new Integer(intCurrentPageNum).toString(),
							objParams.getParamValue("ReqInfoPageSize")))%>

       <!-- /����¡-->
<!--
���δ� ���
�䱸�� ����
����ȸ ���� ��û
-->

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
          <input name="ReqInfoQryTerm" onKeyDown="return ch()" onMouseDown="return ch()" value="<%=objParams.getParamValue("ReqInfoQryTerm")%>"
		 class="li_input"  style="width:100px"/>
          <img src="/images2/btn/bt_list_search.gif"  onMouseOver="menuOn(this);" onMouseOut="menuOut(this);" onClick="gotoReqInfoSearch(formName);"/> </div>
        <!-- /����Ʈ �� �˻� -->
			<span class="right">
			<span class="list_bt"><a href="#" onClick="addBinder(document.formName);">���δ� ���</a></span>
			<span class="list_bt"><a href="#" onClick="copyMemReqInfo(formName);">�䱸�� ����</a></span>
			<% if(objRs.getRecordSize()>0 && (!objCmtSubmt.checkCmtOrganMakeAutoSche((String)objRsSH.getObject("CMT_ORGAN_ID")) || !objUserInfo.getIsMyCmtOrganID((String)objRsSH.getObject("CMT_ORGAN_ID")))) { %>
			<span class="list_bt"><a href="#" onClick="ApplyCmt(document.formName);">����ȸ ���� ��û</a></span>
			<% } %>
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

<%!

	public static String makeAnsInfoHtml2(String strAnsIDs,String strAnsMtds,String strAnsOpins,String strSubmtFlags, boolean blnIsRequester,String strKeywords,String strLinkTarget,String strSummary,String strReqCont,String strSubmtorganNm){
		if(strLinkTarget.equals("0")){
			strLinkTarget="_blank";
		}else if(strLinkTarget.equals("1")){
			strLinkTarget="_self";
		}
		String strMsgSummary=StringUtil.getEmptyIfNull(strSummary,"PDF����");
		String strTop="";		//��¿� ��� ���ڿ�<a><talbe>
		String strMiddle="";	//��¿� �߰� <tr></tr>+
		String strBottom="";	//��¿� �ϴ� ���ڿ�..</table></a>
		if(strAnsIDs==null || strAnsIDs.trim().equals("")){
			return "";//�亯���� ������.
		}
		if(strAnsOpins!=null){
			strAnsOpins=strAnsOpins.replaceAll("'"," ");
			strAnsOpins=strAnsOpins.replaceAll("\""," ");
		}else{
			strAnsOpins="";
		}
		StringTokenizer strTokenAnsIDs=new StringTokenizer(strAnsIDs,",");
		StringTokenizer strTokenAnsMtds=new StringTokenizer(strAnsMtds,",");
		StringTokenizer strTokenAnsOpins=new StringTokenizer(strAnsOpins,",");
		StringTokenizer strTokenSubmtFlags=new StringTokenizer(strSubmtFlags,",");
		StringBuffer strBufReturn=new StringBuffer();
		String strAnsID=null;
		String strAnsMtd=null; 
		String strAnsOpin=null;
		String strSubmtFlag="Y";
		int intAnsCount=0;
		
		while(strTokenAnsIDs.hasMoreElements()&& strTokenAnsMtds.hasMoreElements() && strTokenSubmtFlags.hasMoreElements() ){
			strAnsID=strTokenAnsIDs.nextToken();
			strAnsMtd=strTokenAnsMtds.nextToken();
			strSubmtFlag=strTokenSubmtFlags.nextToken();
			try{
				if(strTokenAnsOpins.hasMoreElements()){
					strAnsOpin=strTokenAnsOpins.nextToken();
				}else{
					strAnsOpin="";
				}
			}catch(NoSuchElementException ex){
				strAnsOpin="";
			}
			strAnsOpin=StringUtil.getEmptyIfNull(strAnsOpin);
			strAnsOpin=strAnsOpin.replace('\n',' ');
			strAnsOpin=strAnsOpin.replace('\r',' ');
			//�䱸��(true)�̸鼭 �亯�Ϸ�(Y) �̰ų� ������(false)�̸� �亯���� ���̰��ϱ�.
			if((blnIsRequester && strSubmtFlag.equalsIgnoreCase("Y")) || blnIsRequester==false){
				//<tr>����
				if(strAnsMtd.equals(CodeConstants.ANS_MTD_ELEC)){
					strBufReturn.append("<img src='/image/reqsubmit/bt_EDoc.gif' width='73' height='16' border='0' alt='" + strAnsOpin + "'>");
					if(StringUtil.isAssigned(strKeywords)){
						strBufReturn.append("<a href='/reqsubmit/common/ReqFileOpenHL.jsp?ansID=" + strAnsID + "&keyword=" +  strKeywords+ "&DOC=PDF' target='" + strLinkTarget + "'>");						
					}else{
						strBufReturn.append("<a href='/reqsubmit/common/ReqFileOpen2.jsp?paramAnsId=" + strAnsID + "&DOC=PDF&REQNM=" + strReqCont + "&REQSEQ=" + (intAnsCount+1) + "&SubmtOrganNm="+strSubmtorganNm+"' target='_self'>");
					}
					/** ���ŵ� 2004.05.13
					if(intAnsCount>0){//ó���ѹ��� ��๮ �����شٰ���.
						strMsgSummary="PDF����";
					}
					 */
					strBufReturn.append("<img src='/image/common/icon_pdf.gif' width='16' height='16' border='0' alt='" + strMsgSummary + "'>");
					strBufReturn.append("</a>");
					strBufReturn.append("&nbsp;<a href='/reqsubmit/common/ReqFileOpen2.jsp?paramAnsId=" + strAnsID + "&DOC=DOC&REQNM=" + strReqCont + "&REQSEQ=" + (intAnsCount+1) + "&SubmtOrganNm="+strSubmtorganNm+"' target='_self'>");
					strBufReturn.append("<img src='/image/common/icon_file.gif' border='0' alt='��������'>");
					strBufReturn.append("</a>");
					strBufReturn.append("<br>");
				}else if(strAnsMtd.equals(CodeConstants.ANS_MTD_ETCS)){
					strBufReturn.append("<img src='/image/reqsubmit/bt_NotEDoc.gif' width='73' height='16' border='0' alt='" + strAnsOpin + "'>");
					strBufReturn.append("<br>");					
				}else if(strAnsMtd.equals("004")){
					strBufReturn.append("<img src='/image/reqsubmit/bt_offLineSubmit.gif' width='73' height='16' border='0' alt='���������� ���� ����'>");
					strBufReturn.append("<br>");					
				}else {
					strBufReturn.append("<img src='/image/reqsubmit/bt_NotPertinentOrg.gif' width='73' height='16' border='0' alt='" + strAnsOpin + "'>");
					strBufReturn.append("<br>");					
				}
				//</tr>�� 
				intAnsCount++; //�亯���� ī��Ʈ �ø�.
			}
		}
		
		strMiddle=strBufReturn.toString();//�߰����ڿ� �ޱ�.
		
		
		//�亯���� ��µ� ������ ������ ���.
		if(intAnsCount>0){
			return  strMiddle;
		}else{
			return "";//�亯���� ������.
		}
	}

	public static String makeAnsInfoImg(String strAnsIDs,String strAnsMtds,String strAnsOpins,String strSubmtFlags, boolean blnIsRequester,String strKeywords,String strLinkTarget,String strSummary){
		
		if(strAnsIDs==null || strAnsIDs.trim().equals("")){
			return "<img src='/image/reqsubmit/icon_noAnswer.gif' border='0'>";//�亯���� ������.
		}		
		
		StringTokenizer strTokenAnsIDs=new StringTokenizer(strAnsIDs,",");
		StringTokenizer strTokenAnsMtds=new StringTokenizer(strAnsMtds,",");
		StringTokenizer strTokenAnsOpins=new StringTokenizer(strAnsOpins,",");
		StringTokenizer strTokenSubmtFlags=new StringTokenizer(strSubmtFlags,",");
		StringBuffer strBufReturn=new StringBuffer();
		String strAnsID=null;
		String strAnsMtd=null; 
		String strAnsOpin=null;
		String strSubmtFlag="Y";
		int intAnsCount=0;
		
		while(strTokenAnsIDs.hasMoreElements()&& strTokenAnsMtds.hasMoreElements() && strTokenSubmtFlags.hasMoreElements() ){	
			strAnsID=strTokenAnsIDs.nextToken();
			strAnsMtd=strTokenAnsMtds.nextToken();
			strSubmtFlag=strTokenSubmtFlags.nextToken();
			try{
				if(strTokenAnsOpins.hasMoreElements()){
					strAnsOpin=strTokenAnsOpins.nextToken();
				}else{
					strAnsOpin="";
				}
			}catch(NoSuchElementException ex){
				strAnsOpin="";
			}
			//�䱸��(true)�̸鼭 �亯�Ϸ�(Y) �̰ų� ������(false)�̸� �亯���� ���̰��ϱ�.
			if((blnIsRequester && strSubmtFlag.equalsIgnoreCase("Y")) || blnIsRequester==false){
				intAnsCount++; //�亯���� ī��Ʈ �ø�.
			}
		}
		
		//�亯���� ��µ� ������ ������ ���.
		if(intAnsCount>0){
			return "<img src='/image/reqsubmit/icon_answer.gif' border='0'>";
		}else{
			return "<img src='/image/reqsubmit/icon_noAnswer.gif' border='0'>";//�亯���� ������.
		}
	}

%>