<%@ page language="java" contentType="text/html;charset=EUC-KR" %>

<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.pf.util.PageCount"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.params.requestbox.SCommReqBoxVListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.SCommRequestBoxDelegate" %>

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
<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>

<%
	/**�Ϲ� �䱸�� �󼼺��� �Ķ���� ����.*/
	SCommReqBoxVListForm  objParams =new SCommReqBoxVListForm();
	objParams.setParamValue("IsRequester",String.valueOf(objUserInfo.isRequester()));//�䱸�亯�ڿ��μ���

	boolean blnParamCheck = false;
	/**���޵� �ĸ����� üũ */
	blnParamCheck = objParams.validateParams(request);
	if(blnParamCheck==false) {
	  	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
	  	objMsgBean.setStrCode("DSPARAM-0000");
	  	objMsgBean.setStrMsg(objParams.getStrErrors());
	  	out.println("ParamError:" + objParams.getStrErrors());
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}

	//�α��� ����� ������ �����´�. ���Ѿ��� ��� ������ �����ϴ�.
	String strReqSubmitFlag = objUserInfo.getReqSubmitFlag();

	/*** Delegate �� ������ Container��ü ���� */
	SCommRequestBoxDelegate objReqBox=null; 		/**�䱸�� Delegate*/
	ResultSetSingleHelper objRsSH=null;			/** �䱸�� �󼼺��� ���� */
	ResultSetHelper objRs=null;					/**�䱸 ��� */

	try {
		/**�䱸�� ���� �븮�� New */
		objReqBox=new SCommRequestBoxDelegate();
		/**�䱸�� �̿� ���� üũ */

		/** �䱸�� ���� */
		objRsSH=new ResultSetSingleHelper(objReqBox.getRecord((String)objParams.getParamValue("ReqBoxID"), (String)objUserInfo.getUserID()));
		/** �䱸 ���� */
		objRs=new ResultSetHelper((Hashtable)objReqBox.getReqRecordList(objParams));

	} catch(AppException objAppEx) {
	 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
	  	objMsgBean.setStrCode(objAppEx.getStrErrCode());
	  	objMsgBean.setStrMsg(objAppEx.getMessage());
	  	out.println("<br>Error!!!" + objAppEx.getMessage());
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}
	System.out.println("SSSSS1");
	String strYear = (String)objParams.getParamValue("AuditYear") == null?"2008":(String)objParams.getParamValue("AuditYear");
	if(strYear.equals("")){
		strYear = "2008";
	}
	int intAuditYear = Integer.parseInt(strYear);
	System.out.println("SSSSS2");

	/**�䱸���� �����ȸ�� ��� ��ȯ.*/
	int intTotalRecordCount=objRs.getTotalRecordCount();
	int intCurrentPageNum=objRs.getPageNumber();
	int intTotalPage=objRs.getTotalPageCount();
%>

<jsp:include page="/inc/header.jsp" flush="true"/>
<style type="text/css">
	.tooltip_text, .tooltip_close{
		cursor: pointer;
	}
	div.tooltip {
		
		position:absolute;
	}
</style>
<script language="javascript">

  /** �䱸�Ը������ ���� */
  function gotoList(){
  	form=document.formName;
  	form.action="./SSubEndBoxList.jsp";
  	form.target = "";
  	form.submit();
  }

  /** �䱸�󼼺���� ���� */
  function gotoDetail(str1, str2){
  	var f = document.formName;
  	f.action="./SSubEndReqInfo.jsp";
	f.ReqBoxID.value = str1;
	f.ReqID.value = str2;
  	f.target = "";
  	f.submit();
  }

  function gotoSend(){
  	form=document.formName;
  	form.action="./SCommAnsInfoWrite.jsp";
  	form.target = "";
  	form.submit();
  }

  /** ���Ĺ�� �ٲٱ� */
  function changeSortQuery(sortField,sortMethod){
  	form=document.formName;
  	form.ReqInfoSortField.value=sortField;
  	form.ReqInfoSortMtd.value=sortMethod;
  	form.target = "";
  	form.submit();
  }

  /** ����¡ �ٷΰ��� */
  function goPage(strPage){
  	form=document.formName;
        //var test = form.ReqInfoPage.value;
  	//alert(test);
  	//form.CommReqInfoPage.value=strPage;
  	form.ReqInfoPage.value=strPage;
  	form.target = "";
        form.action ="<%=request.getRequestURI()%>";
  	form.submit();
  }

	/**
  	 * 2005-10-20 kogaeng ADD
  	 * üũ�ڽ��� �ϳ��� �����ϰ� �ϴ� ��ũ��Ʈ
  	 */
  	function checkBoxValidate(cb) {
		if(<%= intTotalRecordCount %> == 1) {
			/*if(cb == 0) {
				document.formName.ReqInfoID.checked = true;
				document.formName.ReqID.value = document.formName.ReqInfoID.value;
				return;
			}*/
            return;
		}
		for (j = 0; j < <%= objRs.getRecordSize() %>; j++) {
			if (eval("document.formName.ReqInfoID[" + j + "].checked") == true) {
				document.formName.ReqInfoID[j].checked = false;
				if (j == cb) {
					document.formName.ReqInfoID[j].checked = true;
					document.formName.ReqID.value = document.formName.ReqInfoID[j].value;
				} else {
					document.formName.ReqInfoID[j].checked = false;
					document.formName.ReqID.value = "";
				}
			}
		}
	}

	/** �䱸 �̷º��� */
	function viewReqHistoryInList() {
		var cnt = 0;
		if(<%= intTotalRecordCount %> == 1) {
			if(eval("document.formName.ReqInfoID.checked") == true) {
                cnt = 1;
                document.formName.ReqID.value = document.formName.ReqInfoID.value;
            }
		} else {
			for (j = 0; j < <%= objRs.getRecordSize() %>; j++) {
				if (eval("document.formName.ReqInfoID[" + j + "].checked") == true) {
					document.formName.ReqID.value = document.formName.ReqInfoID[j].value;
					cnt++;
				}
			}
		}

  		if(cnt == 0) {
  			alert("�䱸�� �����Ͻ� �Ŀ� ��ư�� �ٽ� Ŭ���� �ּ���");
  			return;
  		}
  		var popModal = window.showModalDialog('/reqsubmit/common/ViewReqHistory.jsp?ReqInfoID='+document.formName.ReqID.value,
  																'', 'dialogWidth:540px;dialogHeight:450px; center:yes; help:no; status:no; scroll:yes; resizable:yes');
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
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<div id="wrap">
  <jsp:include page="/inc/top.jsp" flush="true"/>
  <jsp:include page="/inc/top_menu02.jsp" flush="true"/>
  <div id="container">
    <div id="leftCon">
      <jsp:include page="/inc/log_info.jsp" flush="true"/>
      <jsp:include page="/inc/left_menu02.jsp" flush="true"/>
	<SCRIPT language="JavaScript" src="/js/reqsubmit/reqinfo.js"></SCRIPT>
	<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>
    </div>
    <div id="rightCon">
<form name="formName" method="post" action="<%=request.getRequestURI()%>">

		<%  //�䱸�� ���� ���� �ޱ�.
			String strReqBoxSortField=objParams.getParamValue("ReqBoxSortField");
			String strReqBoxSortMtd=objParams.getParamValue("ReqBoxSortMtd");
			//�䱸�� ������ ��ȣ �ޱ�.
			String strReqBoxPagNum=objParams.getParamValue("ReqBoxPageNum");
			//�䱸�� ��ȸ���� �ޱ�.
			String strReqBoxQryField=objParams.getParamValue("ReqBoxQryField");
			String strReqBoxQryTerm=objParams.getParamValue("ReqBoxQryTerm");

			//�䱸 ���� ���� ���� �ޱ�.
			String strReqInfoSortField=objParams.getParamValue("ReqInfoSortField");
			String strReqInfoSortMtd=objParams.getParamValue("ReqInfoSortMtd");
			//�䱸�� ���� ������ ��ȣ �ޱ�.
			String strReqInfoPagNum=objParams.getParamValue("ReqInfoPageNum");
		%>
	    <input type="hidden" name="ReqBoxID" value="<%=objParams.getParamValue("ReqBoxID")%>">
	    <input type="hidden" name="CmtOrganID" value="<%=objParams.getParamValue("CmtOrganID")%>">
		<input type="hidden" name="AuditYear" value="<%=objParams.getParamValue("AuditYear")%>">
		<input type="hidden" name="ReqBoxSortField" value="<%=strReqBoxSortField%>"><!--�䱸�Ը�������ʵ� -->
		<input type="hidden" name="ReqBoxSortMtd" value="<%=strReqBoxSortMtd%>"><!--�䱸�Ը�����ɹ��-->
		<input type="hidden" name="ReqBoxPage" value="<%=strReqBoxPagNum%>"><!--�䱸�� ������ ��ȣ -->
		<input type="hidden" name="ReqInfoSortField" value="<%=strReqInfoSortField%>"><!--�䱸���� ��������ʵ� -->
		<input type="hidden" name="ReqInfoSortMtd" value="<%=strReqInfoSortMtd%>"><!--�䱸���� ������ɹ��-->
		<input type="hidden" name="ReqInfoPage" value="<%=strReqInfoPagNum%>"><!--�䱸���� ������ ��ȣ -->
		<input type="hidden" name="ReqID" value=""><!--�䱸���� ID-->
      <!-- pgTit -->
      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=MenuConstants.COMM_REQ_BOX_SUBMT_END%><span class="sub_stl" >- <%=MenuConstants.REQ_BOX_DETAIL_VIEW%></span></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.REQUEST_BOX_COMM%> > <%=MenuConstants.COMM_REQ_BOX_SUBMT_END%></div>
        <p><!--����--></p>
      </div>
      <!-- /pgTit -->

      <!-- contents -->

      <div id="contents">

        <!-- �˻����� ���� ��� �Ʒ� div ���� �� �ּ����� ��������.-->
        <!-- /�˻�����-->


        <!-- �������� ���� -->
         <!-- list view-->

        <span class="list02_tl">�䱸�� ����</span>
        <div class="top_btn"><samp>
			 <span class="btn"><a href="javascript:gotoList();">�䱸�� ���</a></span>
		</samp></div>

        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list02">
		<%
			//�䱸�� ���� ����.
			String strIngStt=(String)objRsSH.getObject("ING_STT");
		%>
            <tr>
              <th width="100px;" >&bull;&nbsp;�䱸�Ը� </th>
				  <td colspan="3"><%= objRsSH.getObject("REQ_BOX_NM") %>
				  <%
					// 2004-06-17 ADD
					String strElcDocNo = (String)objRsSH.getObject("DOC_NO");
					if (StringUtil.isAssigned(strElcDocNo)) {
						out.println(" (���ڰ����ȣ : "+strElcDocNo+")");
   					}
       			%>
				</td>

            </tr>

            <tr>
              <th>&bull;&nbsp;�Ұ� ����ȸ </th>
			  <td><%= objRsSH.getObject("CMT_ORGAN_NM") %></td>
            </tr>
            <tr>
              <th>&bull;&nbsp;��������  </th>
			  <td><%= objCdinfo.getRelatedDuty((String)objRsSH.getObject("RLTD_DUTY")) %></td>
            </tr>
             <tr>
              <th>&bull;&nbsp;�߼����� </th>
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
						 <td class="fonts"><%=(String)objRsSH.getObject("REGR_NM")%> (<a href="mailto:<%=(String)objRsSH.getObject("REGR_EMAIL")%>"><%=(String)objRsSH.getObject("REGR_EMAIL")%></a> / <%=(String)objRsSH.getObject("REGR_CPHONE")%>)</td>
						 <td class="fonts"><%=(String)objRsSH.getObject("RCVR_NM")%></td>
					 </tr>
				 </table>
			</td>

            </tr>
                <tr>

              <th>&bull;&nbsp;�䱸���̷� </th>  <td colspan="3">



              <ul class="list_in">
              <li><span class="tl">&bull;&nbsp;�䱸�Ի����Ͻ� :</span> <%=StringUtil.getDate2((String)objRsSH.getObject("REG_DT"))%></li>
              <li><span class="tl">&bull;&nbsp;�䱸�� ������ :</span> <%=StringUtil.getDate2((String)objRsSH.getObject("LAST_REQ_DOC_SND_DT"))%></li>
              <li><span class="tl">&bull;&nbsp;������ ��ȸ�� :</span> <%=StringUtil.getDate2((String)objRsSH.getObject("FST_QRY_DT"))%></li>
              <li><span class="tl"><strong>&bull;&nbsp;������� :</span> <%=StringUtil.getDate((String)objRsSH.getObject("SUBMT_DLN"))%> 24:00</strong></li>
              <li><span class="tl"><strong>&bull;&nbsp;�亯�� �߼��Ͻ� :</span> <%=StringUtil.getDate2((String)objRsSH.getObject("LAST_ANS_DOC_SND_DT"))%></strong></li>

              </ul>
              </td>

            </tr>
                <tr>
              <th>&bull;&nbsp;�䱸�Լ��� </th>   <td colspan="3"><%= objRsSH.getObject("REQ_BOX_DSC") %></td>
            </tr>
        </table>
        <!-- /list view -->
        <!-- ����Ʈ ��ư-->
<!--
�䱸�� ���, ���ε�, �䱸�� ����, �亯�� �̸� ����, �亯�� �߼�, �������� ����
-->
        <div id="btn_all"><div  class="t_right">
		<%
		//������ �䱸��(�����Ϸ�-��������,�䱸�Ը��)
		//�����Ϸ� �䱸��((�䱸������,����׹߼�,(�䱸�Ի���)-��������,�䱸�Ը��)-��ư���ٸ���)
		//�߼ۿϷ�䱸��(�䱸������-��������,�䱸�Ը��)
		//����Ϸ�䱸��(�䱸������,���⹮������-��������,�䱸�Ը��)
		    if(!strReqSubmitFlag.equals("004")){
			    if(CodeConstants.DOC_VIEW_YEAR <= intAuditYear){
			    %>
    			<div class="mi_btn" style="float:right"><a href="javascript:ReqDocOpenView('<%=objParams.getParamValue("ReqBoxID")%>','002')"><span>�䱸�� ����</span></a></div>
	    		<div class="mi_btn" style="float:right"><a href="javascript:AnsDocOpenView('<%=objParams.getParamValue("ReqBoxID")%>');"><span>�亯�� ����</span></a></div>
			    <%
				}
			}
			%>
		</div></div>

        <!-- /����Ʈ ��ư-->

        <!-- list -->
        <span class="list01_tl">�䱸 ��� <span class="list_total">&bull;&nbsp;��ü�ڷ�� : <%= intTotalRecordCount %>�� (<%= intCurrentPageNum %>/<%= intTotalPage %> page)</span></span>

        <table width="100%" style="padding:0;">
            <tr>
                <td>&nbsp;</td>
            </tr>
        </table>
        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
          <thead>
            <tr>
              <th style="width:10px;"><a>NO</a></th>
              <th style="width:250px;"><%=SortingUtil.getSortLink("changeSortQuery","REQ_CONT",strReqInfoSortField,strReqInfoSortMtd,"�䱸����")%></th>
              <th><%= SortingUtil.getSortLink("changeSortQuery", "REQ_STT", strReqInfoSortField, strReqInfoSortMtd, "����") %></th>
              <th><%= SortingUtil.getSortLink("changeSortQuery", "OPEN_CL", strReqInfoSortField, strReqInfoSortMtd, "�������") %></th>
              <th><a>�亯</a></th>
              <th><a>÷��</a></th>
              <th><%=SortingUtil.getSortLink("changeSortQuery","LAST_ANS_DT",strReqInfoSortField,strReqInfoSortMtd,"�����亯�Ͻ�")%></th>
            </tr>
          </thead>
          <tbody>
		<%

			int intRecordNumber= intTotalRecordCount - ((intCurrentPageNum -1) * Integer.parseInt((String)objParams.getParamValue("ReqInfoPageSize")));
			int strNumber = intRecordNumber;
			String strReqInfoID="";

			if(objRs.getRecordSize()>0){
				while(objRs.next()){
					 strReqInfoID=(String)objRs.getObject("REQ_ID");
		 %>
            <tr>
              <td><input name="ReqInfoID" type="checkbox" value="<%= strReqInfoID %>"  class="borderNo" onClick="javascript:checkBoxValidate(<%= (intRecordNumber-strNumber) %>)" /></td>
              <td><a href="javascript:gotoDetail('<%=objRsSH.getObject("REQ_BOX_ID")%>','<%=objRs.getObject("REQ_ID")%>')"><%=objRs.getObject("REQ_CONT")%></a></td>
              <td><%=CodeConstants.getRequestStatus((String)objRs.getObject("REQ_STT")) %></td>
              <td><%=CodeConstants.getOpenClass((String)objRs.getObject("OPEN_CL")) %></td>  
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
					   <td  bgcolor="#FFFFFF" align="left" ><%=this.makeAnsInfoHtml2((String)objRs.getObject("ANS_ID"),(String)objRs.getObject("ANS_MTD"),(String)objRs.getObject("ANS_OPIN"),(String)objRs.getObject("SUBMT_FLAG"),objUserInfo.isRequester(),"","_blank","")%></td>
					  </tr>
					 </table>
				</div>
			  </td>
              <td><%=makeAttachedFileLink((String)objRs.getObject("ANS_ESTYLE_FILE_PATH"))%></td>
              <td><%=StringUtil.getDate2((String)objRs.getObject("LAST_ANS_DT"))%></td>
            </tr>
				<%
						intRecordNumber++;
					} //endwhile
				} else {
				%>
					<tr>
						<td colspan="7" height="35" align="center">��ϵ� �䱸������ �����ϴ�.</td>
					</tr>
				<%
				}//endif
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
							objParams.getParamValue("ReqInfoPageSize")))
						%>

       <!-- /����¡-->


       <!-- ����Ʈ ��ư-->
        <div id="btn_all" >        <!-- ����Ʈ �� �˻� -->
        <div class="list_ser" >
		<%
			String strReqInfoQryField=(String)objParams.getParamValue("ReqInfoQryField");
		%>
          <select name="ReqInfoQryField" class="selectBox5"  style="width:70px;" >
			<option <%=(strReqInfoQryField.equalsIgnoreCase("req_cont"))? " selected ": ""%>value="req_cont">�䱸 ����</option>
			<option <%=(strReqInfoQryField.equalsIgnoreCase("req_dtl_cont"))? " selected ": ""%>value="req_dtl_cont">�䱸����</option>
          </select>
          <input name="iptName" onKeyDown="return ch()" onMouseDown="return ch()" value="<%=objParams.getParamValue("ReqInfoQryTerm")%>"
		 class="li_input"  style="width:100px"/>
          <img src="/images2/btn/bt_list_search.gif"  onMouseOver="menuOn(this);" onMouseOut="menuOut(this);" onClick="formName.submit()"/> </div>
        <!-- /����Ʈ �� �˻� -->
			<span class="right">
			<span class="list_bt"><a href="javascript:viewReqHistoryInList()">�䱸�̷º���</a></span>
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
<%!
	public String makeAttachedFileLink(String strFileName){
		String strReturnURL = null;
		if(!StringUtil.isAssigned(strFileName)){
			//���ϰ�ΰ� ������ �⺻ ���ϰ�η� ��ġ��.
			strReturnURL = "";
			//strFileName=nads.lib.reqsubmit.EnvConstants.getConstFilePath();
		} else {
			strReturnURL = "<a href=\"/reqsubmit/common/AttachStyleFileDownload.jsp?path=" + strFileName+ "\"><img src=\"/image/common/icon_etc.gif\" border=\"0\"></a>";
		}
		return strReturnURL;
	}

%>
  </div>
  <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>
<%!

	public static String makeAnsInfoHtml2(String strAnsIDs,String strAnsMtds,String strAnsOpins,String strSubmtFlags, boolean blnIsRequester,String strKeywords,String strLinkTarget,String strSummary){
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
						strBufReturn.append("<a href='/reqsubmit/common/ReqFileOpen.jsp?paramAnsId=" + strAnsID + "&DOC=PDF' target='" + strLinkTarget + "'>");
					}
					/** ���ŵ� 2004.05.13
					if(intAnsCount>0){//ó���ѹ��� ��๮ �����شٰ���.
						strMsgSummary="PDF����";
					}
					 */
					strBufReturn.append("<img src='/image/common/icon_pdf.gif' width='16' height='16' border='0' alt='" + strMsgSummary + "'>");
					strBufReturn.append("</a>");
					strBufReturn.append("&nbsp;<a href='/reqsubmit/common/ReqFileOpen.jsp?paramAnsId=" + strAnsID + "&DOC=DOC' target='_self'>");
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
