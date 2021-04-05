<%@ page language="java" contentType="text/html;charset=EUC-KR" %>

<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.pf.util.PageCount"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RCommReqBoxVListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.cmtmanager.CmtManagerDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.cmtmanager.CmtManagerConfirmDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.CommRequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.CommRequestInfoDelegate" %>
<%@ page import="nads.dsdm.app.common.page.PagingDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%
System.out.println("dfdfdf");
	/*** PagingDelegate */
	PagingDelegate objPaging=new PagingDelegate(); 		/*����¡ ��ȯ Delegate*/
%>
<%
	UserInfoDelegate objUserInfo = null;
	CDInfoDelegate objCdinfo = null;
%>

<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>

<%
  /**�Ϲ� �䱸�� �󼼺��� �Ķ���� ����.*/
  RCommReqBoxVListForm objParams =new RCommReqBoxVListForm();
  boolean blnParamCheck=false;
  /**���޵� �ĸ����� üũ */
  blnParamCheck=objParams.validateParams(request);
  if(blnParamCheck==false){
  	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	objMsgBean.setStrCode("DSPARAM-0000");
  	objMsgBean.setStrMsg(objParams.getStrErrors());
  	out.println("ParamError:" + objParams.getStrErrors());
%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
 	return;
  }//endif
%>

<%
  /**** Debug�� **** �����޽��� ������ ���������...****************/
  //out.println( objParams.getValuesForDebug());
  /****************************************************************/
%>

<%
  //�α��� ����� ������ �����´�. ���Ѿ��� ��� ������ �����ϴ�.
 String strReqSubmitFlag = objUserInfo.getReqSubmitFlag();
 String strUserId = objUserInfo.getUserID();
 String strOrganID = objUserInfo.getOrganID();
 String strCmtOpenCl = request.getParameter("OpenCl");
 String strReqBoxId = (String)objParams.getParamValue("ReqBoxID");



 String MenOrganID = "";
 String REQBOXID = "";
 int resultInt1 = -1;
 int resultInt2 = -1;
 int resultInt3 = -1;
 int resultCount = -1;
 int FLAG = -1;

 String strOpenCl = "";
 String strListMsg = "";
 String strOldReqOrganId = "";
 boolean strflag2 = true;


 /*** Delegate �� ������ Container��ü ���� */
 CmtManagerConfirmDelegate cmtmanagerCn = new CmtManagerConfirmDelegate();
 CommRequestBoxDelegate objReqBox=null; 		/**�䱸�� Delegate*/
 CommRequestInfoDelegate  objReqInfo=null;		/** �䱸���� Delegate */
 ResultSetSingleHelper objRsSH=null;			/** �䱸�� �󼼺��� ���� */
 ResultSetHelper objRs=null;					/**�䱸 ��� */
 ResultSetHelper objRsHST=null;					/** ���� �̷�����*/
 String strAuitYear = "";

 try{
   /**�䱸�� ���� �븮�� New */
   objReqBox=new CommRequestBoxDelegate();
   CmtManagerDelegate cmtmanager = new CmtManagerDelegate();
   resultCount = cmtmanager.searchUserId(strUserId, strOrganID);
   /** �䱸�� ���� */
   objRsSH=new ResultSetSingleHelper(objReqBox.getRecord((String)objParams.getParamValue("ReqBoxID")));
    //�䱸���� ���� ��� �ڷ� ��...
    System.out.println("123123123123123123"+(String)objRsSH.getObject("REG_DT"));
    String testRegdt = (String)objRsSH.getObject("REG_DT");
    if (testRegdt==null||testRegdt.equals("")){
        out.println("<script>alert('�䱸���� �������� �ʽ��ϴ�.');history.back();</script>");
        return;
    }
   /**�䱸�� �̿� ���� üũ */
   if((objParams.getParamValue("AuditYear")) == null || (objParams.getParamValue("AuditYear")).equals("")){
        System.out.println("regdt : " + ((String)objRsSH.getObject("REG_DT")));
		strAuitYear = ((String)objRsSH.getObject("REG_DT")).substring(0,4);
   }

   boolean blnHashAuth=objReqBox.checkReqBoxAuth((String)objParams.getParamValue("ReqBoxID"),objUserInfo.getCurrentCMTList()).booleanValue();
   if(!blnHashAuth){
	  if(!strOrganID.equals((String)objRsSH.getObject("OLD_REQ_ORGAN_ID")))
{
      objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	  objMsgBean.setStrCode("DSAUTH-0001");
  	  objMsgBean.setStrMsg("�ش� �䱸���� �� ������ �����ϴ�.");
  	  out.println("�ش� �䱸���� �� ������ �����ϴ�.");

  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%
      return;
	  }
  }else{

   /**�䱸 ���� �븮�� New */
    objReqInfo=new CommRequestInfoDelegate();
    objRs=new ResultSetHelper((Hashtable)objReqInfo.getRecordList(objParams));

	if(objRs != null){
		if(objRs.next()){
			strOpenCl = (String)objRs.getObject("OPEN_CL");
		}
		objRs.first();
	}
	if(objRs != null){
		if(objRs.next()){
			strOldReqOrganId = (String)objRs.getObject("OLD_REQ_ORGAN_ID");
		}
		objRs.first();
	}
	if(strCmtOpenCl == null || strCmtOpenCl.equals("") || strCmtOpenCl.equals("N")){
		strCmtOpenCl = cmtmanagerCn.getOpenCl(strOldReqOrganId) == null ? "" : cmtmanagerCn.getOpenCl(strOldReqOrganId);
	}
    if(objUserInfo.getOrganGBNCode().equals("004")  && !strReqSubmitFlag.equals("004")){
		strListMsg = "��ϵ� �䱸������ �����ϴ�.";
	}else{
		if(strCmtOpenCl.equals("Y")){
			if(strOpenCl.equals("002")){
					if(strOldReqOrganId.equals(strOrganID)){
						 strListMsg = "��ϵ� �䱸������ �����ϴ�.";
					}else{
						objParams.setParamValue("ReqBoxID","XXXXXXXXXX");
						objRs=new ResultSetHelper((Hashtable)objReqInfo.getRecordList(objParams));
						strListMsg = "����� �䱸��� �Դϴ�.";
						strflag2 = false;
					}
			}
		}else{
			strListMsg = "��ϵ� �䱸������ �����ϴ�.";
		}
	}
	objParams.setParamValue("ReqBoxID",strReqBoxId);


	String strflag = StringUtil.getEmptyIfNull(request.getParameter("gansa"));
	REQBOXID = StringUtil.getEmptyIfNull(request.getParameter("ReqBoxID"));
	if(strflag.equals("OK")){
		MenOrganID = cmtmanager.getMenOrganId(strUserId);
		resultInt1 = cmtmanagerCn.getCount(MenOrganID,REQBOXID);
		if(resultInt1 == 0){
			resultInt2 = cmtmanagerCn.getCountNo(REQBOXID);
		}
	}
	FLAG = cmtmanagerCn.getFLAG((String)objParams.getParamValue("CmtOrganID"));
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
%>
<%
 /**�䱸���� �����ȸ�� ��� ��ȯ.*/
 int intTotalRecordCount=objRs.getTotalRecordCount();
 int intCurrentPageNum=objRs.getPageNumber();
 int intTotalPage=objRs.getTotalPageCount();
%>
<jsp:include page="/inc/header.jsp" flush="true"/>
<link href="/css2/style.css" rel="stylesheet" type="text/css">
<%if(resultInt2 == 1 && resultInt1 == 0){
		cmtmanagerCn.UpdateBoxCode(MenOrganID,REQBOXID,resultInt2,resultInt1,strUserId);
		out.println("<script>");
		out.println("alert('��� ���簡 ��� �����Ͽ����ϴ�. ���� ���οϷ� �䱸�� ���� �̵��մϴ�.');");
		out.println("</script>");
		out.println("<meta http-equiv='refresh'content='0;url=/reqsubmit/20_comm/20_reqboxsh/25_accend/RAccBoxConfirmList.jsp'/>");
		return;
  }else{
		resultInt3 = cmtmanagerCn.UpdateBoxCode(MenOrganID,REQBOXID,resultInt2,resultInt1,strUserId);
		objRsHST = new ResultSetHelper(cmtmanagerCn.getCmtManagerHistoy(REQBOXID));
		if(resultInt3 > 0){
			out.println("<script>");
			out.println("alert('�����۾��� ���������� �Ϸ�Ǿ����ϴ�.');");
			out.println("</script>");
		}
  }%>
<script language="javascript">
  //�̹�Ȯ���Ѱ��.
  <%if(resultInt1 > 0){%>
	alert("�̹� �䱸�Կ� ���� Ȯ���� �ϼ̽��ϴ�.");
  <%}%>

  //�䱸�� �������� ����.
  function gotoEdit(strReqBoxID){
    form=document.formName;
  	form.ReqBoxID.value=strReqBoxID;
  	form.action="/reqsubmit/20_comm/20_reqboxsh/RCommReqBoxEdit.jsp?IngStt=002&ReqBoxStt=002";
  	form.target = "";
  	form.submit();
  }

  //�䱸�� ������ ����.
  function gotoDelete(strReqBoxID){
    form=document.formName;
  	form.ReqBoxID.value=strReqBoxID;

  	if(<%=objRs.getRecordSize()%> >0){
	if(confirm("��ϵ� �䱸������ �ֽ��ϴ�. \n\n�䱸���� �����Ǹ� ��ϵ� �䱸������ �Բ� ���� �˴ϴ�. \n\n�׷��� �����Ͻðڽ��ϱ�? ")){
	  		var winl = (screen.width - 300) / 2;
			var winh = (screen.height - 240) / 2;
			form.target = "popwin";
			form.action = "/reqsubmit/20_comm/20_reqboxsh/RCommReqBoxDelProc2.jsp";
			window.open('/blank.html', 'popwin', 'width=300, height=240, left='+winl+', top='+winh);
			form.submit();
	 	}
  	 	return;
  	} else {
		if(confirm(" �䱸���� �����Ͻðڽ��ϱ�? ")){
		  	var winl = (screen.width - 300) / 2;
			var winh = (screen.height - 240) / 2;
			form.target = "popwin";
			form.action = "/reqsubmit/20_comm/20_reqboxsh/RCommReqBoxDelProc2.jsp";
			window.open('/blank.html', 'popwin', 'width=300, height=240, left='+winl+', top='+winh);
			form.submit();
		}
		return;
  	}
  }

  //�䱸 �󼼺���� ����.
  function gotoDetail(strReqBoxID, strCommReqID){
    form=document.formName;
  	form.ReqBoxID.value=strReqBoxID;
  	form.CommReqID.value=strCommReqID;
  	form.action="./RAccReqInfo.jsp";
  	form.target = "";
  	form.submit();
  }

  /** ������� ���� */
  function gotoList(){
  	form=document.formName;
  	form.action="./RAccBoxList.jsp";
  	form.target = "";
  	form.submit();
  }

  /** ���Ĺ�� �ٲٱ� */
  function changeSortQuery(sortField,sortMethod){
  	form=document.formName;
  	form.CommReqInfoSortField.value=sortField;
  	form.CommReqInfoSortMtd.value=sortMethod;
  	form.target = "";
 	form.submit();
  }

  /** �䱸����������� ����. */
  function gotoReqInfo(){
  	form = document.formName;
  	form.action="/reqsubmit/20_comm/20_reqboxsh/RCommReqInfoWrite.jsp?IngStt=002";
  	form.target = "";
  	form.submit();
  }

  /** ����¡ �ٷΰ��� */
  function goPage(strPage){
  	form=document.formName;
  	form.CommReqInfoPage.value=strPage;
  	form.target = "";
  	form.submit();
  }

  /** ���� Ȯ�� */
  function GansaOk(){
	form=document.formName;
	if(confirm("�䱸�Կ� ���� ���� ������ �Ͻðڽ��ϱ�?")){
		form.gansa.value="OK"
		form.target = "";
		form.submit();
		form.gansa.value=""
  	}else{
  		return false;
  	}
  }
</script>
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
	<SCRIPT language="JavaScript" src="/js/reqinfo.js"></SCRIPT>
	<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>
	<SCRIPT language="JavaScript" src="/js/reqsubmit/reqboxview.js"></SCRIPT>
    </div>
    <div id="rightCon">
<form name="formName" method="post" action="<%=request.getRequestURI()%>">

		<%  //�䱸�� ���� ���� �ޱ�.
			String strCommReqBoxSortField=objParams.getParamValue("CommReqBoxSortField");
			String strCommReqBoxSortMtd=objParams.getParamValue("CommReqBoxSortMtd");
			//�䱸�� ������ ��ȣ �ޱ�.
			String strCommReqBoxPagNum=objParams.getParamValue("CommReqBoxPageNum");
			//�䱸�� ��ȸ���� �ޱ�.
			String strCommReqBoxQryField=objParams.getParamValue("CommReqBoxQryField");
			String strCommReqBoxQryTerm=objParams.getParamValue("CommReqBoxQryTerm");

			//�䱸 ���� ���� ���� �ޱ�.
			String strCommReqInfoSortField=objParams.getParamValue("CommReqInfoSortField");
			String strCommReqInfoSortMtd=objParams.getParamValue("CommReqInfoSortMtd");
			//�䱸�� ���� ������ ��ȣ �ޱ�.
			String strCommReqInfoPagNum=objParams.getParamValue("CommReqInfoPageNum");
		%>
	    <input type="hidden" name="ReqBoxID" value="<%=objParams.getParamValue("ReqBoxID")%>">
	    <input type="hidden" name="CmtOrganID" value="<%=objParams.getParamValue("CmtOrganID")%>">
   		<input type="hidden" name="AuditYear" value="<%=strAuitYear%>">
	    <input type="hidden" name="IngStt" value="">
	    <input type="hidden" name="ReqBoxNm" value="<%=objRsSH.getObject("REQ_BOX_NM")%>">
		<input type="hidden" name="CommReqBoxSortField" value="<%=strCommReqBoxSortField%>"><!--�䱸�Ը�������ʵ� -->
		<input type="hidden" name="CommReqBoxSortMtd" value="<%=strCommReqBoxSortMtd%>"><!--�䱸�Ը�����ɹ��-->
		<input type="hidden" name="CommReqBoxPage" value="<%=strCommReqBoxPagNum%>"><!--�䱸�� ������ ��ȣ -->
		<input type="hidden" name="CommReqBoxQryField" value="<%=strCommReqBoxQryField%>">
		<input type="hidden" name="CommReqBoxQryTerm" value="<%=strCommReqBoxQryTerm%>">
		<input type="hidden" name="CommReqInfoSortField" value="<%=strCommReqInfoSortField%>"><!--�䱸���� ��������ʵ� -->
		<input type="hidden" name="CommReqInfoSortMtd" value="<%=strCommReqInfoSortMtd%>"><!--�䱸���� ������ɹ��-->
		<input type="hidden" name="CommReqInfoPage" value="<%=strCommReqInfoPagNum%>"><!--�䱸���� ������ ��ȣ -->
		<input type="hidden" name="CommReqID" value=""><!--�䱸���� ID-->
		<input type="hidden" name="ReturnURL" value="<%=request.getRequestURI()%>">
		<input type="hidden" name="DelURL" value="/reqsubmit/20_comm/20_reqboxsh/20_accend/RAccBoxList.jsp">
		<input type="hidden" name="RltdDuty" value="<%=objParams.getParamValue("RltdDuty")%>">
		<input type="hidden" name="gansa">

      <!-- pgTit -->

      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%= (FLAG > 1)?MenuConstants.COMM_MNG_CHECK:MenuConstants.COMM_REQ_BOX_MAKE_END %> <span class="sub_stl" >- �䱸�� �󼼺���</span></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.REQUEST_BOX_COMM%> > <%= (FLAG > 1)?MenuConstants.COMM_MNG_CHECK:MenuConstants.COMM_REQ_BOX_MAKE_END %></div>
        <p>���������� ���� �䱸�� ������ Ȯ���ϴ� ȭ���Դϴ�.</p>
      </div>
      <!-- /pgTit -->

      <!-- contents -->

      <div id="contents">


        <!-- �˻����� ���� ��� �Ʒ� div ���� �� �ּ����� ��������.-->
        <!-- /�˻�����-->


        <!-- �������� ���� -->
         <!-- list view-->

        <span class="list02_tl">�䱸�� ���� </span>
        <table border="0" cellspacing="0" cellpadding="0" width="680" class="list02">
<%
	//�䱸�� ���� ����.
	String strIngStt=(String)objRsSH.getObject("ING_STT");
%>
            <tr>
                <th height="25">&bull; �䱸�Ը� </th>
                <td height="25" colspan="3"><strong><%=objRsSH.getObject("REQ_BOX_NM")%></strong></td>
            </tr>
            <tr>
                <th height="25">&bull; ���� �䱸 ���� </th>
                <td height="25" colspan="3">- <%=StringUtil.getDate((String)objRsSH.getObject("ACPT_BGN_DT"))%> ���� <%=StringUtil.getDate((String)objRsSH.getObject("ACPT_END_DT"))%> ������ �䱸 ���� �Ⱓ�� �����Ǿ����ϴ�.
				</td>
            </tr>
            <tr>
                <th height="25">&bull; �������� </th>
                <td height="25" colspan="3"><%=objCdinfo.getRelatedDuty((String)objRsSH.getObject("RLTD_DUTY"))%> </td>
            </tr>
            <tr>
                <th height="25">&bull; �Ұ� ����ȸ </th>
                <td height="25"><%=objRsSH.getObject("CMT_ORGAN_NM")%></td>
                <th height="25">&bull;&nbsp;������</th>
                <td height="25"> <span class="list_bts"><%=(String)objRsSH.getObject("SUBMT_ORGAN_NM")%></span></td>
            </tr>
            <tr>
                <th height="25">&bull; ������� </th>
                <td height="25" colspan="3">
				<%=StringUtil.getDate((String)objRsSH.getObject("SUBMT_DLN"))%> ���� �亯 ������ ��û�մϴ�.
				</td>
            </tr>
            <tr>
                <th height="25">&bull; �䱸�Լ��� </th>
                <td height="25" colspan="3">
					<%=StringUtil.getDescString((String)objRsSH.getObject("REQ_BOX_DSC"))%>
				</td>
            </tr>
        </table>
        <!-- /list view -->
<!--        <p class="warning mt10">* �䱸�� �߼� : �ǿ���(�Ǵ� �Ҽӱ��) ���Ƿ� �ش� �������� �䱸���� �߼��մϴ�.</p>
-->
        <!-- ����Ʈ ��ư
         <div id="btn_all"class="t_right">
			 <span class="list_bt"><a href="requestAddAnswer()">�߰� �亯 �䱸</a></span>
		 </div>

        <!-- /����Ʈ ��ư-->

        <!-- list -->
		<%
			// 2005-08-08 kogaeng ADD
			// ���� ��� ������� ���� �����޶�
			if(FLAG > 1) {
		%>
        <span class="list01_tl">����Ȯ�� ����
		<!--<span class="list_total">&bull;&nbsp;��ü�ڷ�� :  <%=objRs.getRecordSize()%>�� </span>-->
		</span>
<!--
checkbox
<input name="" type="checkbox" value="" class="borderNo" />
-->
        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
          <thead>
            <tr>
              <th scope="col">����</th>
              <th scope="col">Ȯ��������</th>
              <th scope="col">Ȯ�νð�</th>
              <th scope="col">�������</th>
            </tr>
          </thead>
          <tbody>
		<%if(objRsHST.getRecordSize() != 0){%>
				<%while(objRsHST.next()){%>
            <tr>
              <td><%
								if(!StringUtil.isAssigned((String)objRsHST.getObject("DESCRIPTION"))) out.println("[����]");
								else out.println("[�ݷ�]");
							%></td>
              <td><%=objRsHST.getObject("ORGAN_NM")%>(<%=objRsHST.getObject("USER_NM")%>)</td>
              <td><%=objRsHST.getObject("REG_DATE")%></td>

              <td><%=objRsHST.getObject("DESCRIPTION")%></td>
            </tr>
			<%}%>
		<%}else{%>
			<tr height="20">
				<td align="center" colspan="4">&nbsp</td>
			</tr>
		<%}%>
		<% } // ������ ���� if %>

<!----------------------- ���� ��ҵ� Form���� ��ư ���� ------------------------->
		 <div id="btn_all"class="t_right">
		<%
			// 2005-07-26 kogaeng Edit
			if(FLAG > 1 && resultCount > 0) {
		%>
			 <span class="list_bt"><a href="#" onclick="GansaOk()">���� ����</a></span>
		<%}%>
			<span class="list_bt"><a href="#" onclick="gotoList()">�䱸�� ���</a></span>
		<%
		/** ����ȸ �������� �϶��� ȭ�鿡 �����.*/
		if(objUserInfo.getOrganGBNCode().equals("004") && !strReqSubmitFlag.equals("004")){
		%>
		<% if (objRsSH.getObject("REQ_BOX_STT").equals("011") || objRsSH.getObject("REQ_BOX_STT").equals("005") || objRsSH.getObject("REQ_BOX_STT").equals("009")) { %>
		<!-- �䱸�� �߼� -->
			<span class="list_bt"><a href="#" onclick="sendReqDoc('<%=CodeConstants.REQ_DOC_TYPE_002%>', '<%=objParams.getParamValue("ReqBoxID")%>')">�䱸�� �߼�</a></span>
		<% } %>

		<%	if(objRsSH.getObject("REQ_BOX_STT").equals("002") || objRsSH.getObject("REQ_BOX_STT").equals("005")){ %>
		<!-- �䱸�� ���� -->
			<span class="list_bt"><a href="#" onclick="gotoEdit('<%=objRsSH.getObject("REQ_BOX_ID")%>')">�䱸�� ����</a></span>
			<!-- �䱸�� ���� -->
			<span class="list_bt"><a href="#" onclick="gotoDelete('<%=objRsSH.getObject("REQ_BOX_ID")%>')">�䱸�� ����</a></span>
		<%
		 } else {
		%>
			<span class="list_bt"><a href="#" onclick="ReqDocOpenView('<%=objRsSH.getObject("REQ_BOX_ID")%>','002')">�䱸�� ����</a></span>
		<%} %>

		<%if(intTotalRecordCount > 0){%>
				<!-- �䱸�� �̸� ���� -->
			<span class="list_bt"><a href="#" onclick="PreReqDocView(formName,'<%=objRsSH.getObject("REQ_BOX_ID")%>','002');">�䱸�� �̸� ����</a></span>
		<%if(FLAG < 2 && objRsSH.getObject("REQ_BOX_STT").equals("002")){%>
			<!-- �䱸�� �߼� -->
			<span class="list_bt"><a href="#" onclick="sendReqDoc('<%=CodeConstants.REQ_DOC_TYPE_002%>', '<%=objParams.getParamValue("ReqBoxID")%>')">�䱸�� �߼�</a></span>
			<%}%>

		<% } %>

	 <% }else{
		if(strOldReqOrganId.equals(strOrganID)){%>
			<span class="list_bt"><a href="#" onclick="PreReqDocView(formName,'<%=objRsSH.getObject("REQ_BOX_ID")%>','002');">�䱸�� �̸�����</a></span>
	<%	}
	}%>
		 </div>
			<BLOCKQUOTE></BLOCKQUOTE>
<!--
	�ڷᰡ ���� ���
			<tr>
			 <td colspan="6"  align ="center"> ��ϵ� �䱸������ �����ϴ�. </td>
            </tr>
-->
          </tbody>
        </table>

        <!-- /list===============================-->
        <span class="list01_tl">�䱸 ���
		<span class="list_total">&bull;&nbsp;��ü�ڷ�� :  <%=intTotalRecordCount%>�� (<%=intCurrentPageNum%> / <%=intTotalPage%> Page) </span>
		</span>
		<table>
			<tr>
				<td>&nbsp;</td>
			</tr>
		</table>
<!--
checkbox
<input name="" type="checkbox" value="" class="borderNo" />
-->
        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
          <thead>
            <tr>
              <th scope="col" style="width:10px;">NO</th>
              <th scope="col" style="width:250px;"><%=SortingUtil.getSortLink("changeSortQuery","REQ_CONT",strCommReqInfoSortField,strCommReqInfoSortMtd,"�䱸����")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","OLD_REQ_ORGAN_NM",strCommReqInfoSortField,strCommReqInfoSortMtd,"��û���")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","OPEN_CL",strCommReqInfoSortField,strCommReqInfoSortMtd,"�������")%></th>
		      <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","REG_DT",strCommReqInfoSortField,strCommReqInfoSortMtd,"��û�Ͻ�")%></th>
            </tr>
          </thead>
          <tbody>
	<%
	int intRecordNumber= intTotalRecordCount - ((intCurrentPageNum -1) * Integer.parseInt((String)objParams.getParamValue("CommReqInfoPageSize")));
	String strReqInfoID="";
	if(objRs.getRecordSize()>0){
		while(objRs.next()){
			strReqInfoID=(String)objRs.getObject("REQ_ID");
	%>
            <tr>
              <td><%=intRecordNumber%></td>
			  <td><%= StringUtil.getNotifyImg((String)objRs.getObject("REG_DT"), (String)objRs.getObject("REQ_STT")) %><a href="javascript:gotoDetail('<%=objRsSH.getObject("REQ_BOX_ID")%>','<%=objRs.getObject("REQ_ID")%>')" hint="<%= StringUtil.substring((String)objRs.getObject("REQ_DTL_CONT"), 80) %>"><%=objRs.getObject("REQ_CONT")%></a></td>
			  <td><%=objRs.getObject("OLD_REQ_ORGAN_NM")%></td>
			  <td><%=CodeConstants.getOpenClass((String)objRs.getObject("OPEN_CL"))%></td>
			  <td><%=StringUtil.getDate2((String)objRs.getObject("REG_DT"))%></td>
            </tr>
	<%
		intRecordNumber--;
		}//endwhile
	} else {
	%>
			<tr height="20">
				<td colspan="5" align="center"><%=strListMsg%></td>
			</tr>

	<%
		}//endif
	%>
<!----------------------- ���� ��ҵ� Form���� ��ư ���� ------------------------->

			<BLOCKQUOTE></BLOCKQUOTE>
<!--
	�ڷᰡ ���� ���
			<tr>
			 <td colspan="6"  align ="center"> ��ϵ� �䱸������ �����ϴ�. </td>
            </tr>
-->
          </tbody>
        </table>

			<%=objPaging.pagingTrans(PageCount.getLinkedString(
				new Integer(intTotalRecordCount).toString(),
				new Integer(intCurrentPageNum).toString(),
				objParams.getParamValue("CommReqInfoPageSize"))
			)%>

       <!-- ����Ʈ ��ư
        <div id="btn_all" >
		<!-- ����Ʈ �� �˻� -->

		<div class="list_ser" >
		<%
		String strCommReqInfoQryField=(String)objParams.getParamValue("CommReqInfoQryField");
		%>
          <select name="CommReqInfoQryField" class="selectBox5"  style="width:70px;" >
			  <option <%=(strCommReqInfoQryField.equalsIgnoreCase("req_cont"))? " selected ": ""%>value="req_cont">�䱸����</option>
			  <option <%=(strCommReqInfoQryField.equalsIgnoreCase("req_dtl_cont"))? " selected ": ""%>value="req_dtl_cont">�䱸����</option>
			  <option <%=(strCommReqInfoQryField.equalsIgnoreCase("old_req_organ_nm"))? " selected ": ""%>value="old_req_organ_nm">�䱸���</option>
          </select>
          <input name="CommReqInfoQryTerm" onKeyDown="return ch()" onMouseDown="return ch()"
		 class="li_input"  style="width:100px" value="<%=objParams.getParamValue("CommReqInfoQryTerm")%>"/>
          <img src="/images2/btn/bt_list_search.gif"  onMouseOver="menuOn(this);" onMouseOut="menuOut(this);" onClick="formName.submit()"/> </div>

        <!-- /����Ʈ �� �˻�  -->
			<span class="right">
					<%
					/** ����ȸ �������� �϶��� ȭ�鿡 �����.*/
					if(objUserInfo.getOrganGBNCode().equals("004")  && !strReqSubmitFlag.equals("004")){
						//if(objRsSH.getObject("REQ_BOX_STT").equals("002") || objRsSH.getObject("REQ_BOX_STT").equals("005")){
						%>
				<span class="list_bt"><a href="javascript:gotoReqInfo()">�䱸 ���</a></span>
						<% //}
				 	} %>
			</span>
		</div>

        <!-- /����Ʈ ��ư-->
        <!-- /�������� ����
      </div>
      <!-- /contents -->

    </div>
  </div>
</form>
  <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>