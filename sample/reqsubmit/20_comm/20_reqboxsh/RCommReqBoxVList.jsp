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
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.CommRequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.CommRequestInfoDelegate" %>
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

<%@ include file="../../common/RUserCodeInfoInc.jsp" %>

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
 //�α��� ����� ������ �����´�. ���Ѿ��� ��� ������ �����ϴ�.
 String strReqSubmitFlag = objUserInfo.getReqSubmitFlag();

 /*** Delegate �� ������ Container��ü ���� */
 CommRequestBoxDelegate objReqBox=null; 		/**�䱸�� Delegate*/
 CommRequestInfoDelegate  objReqInfo=null;		/** �䱸���� Delegate */
 ResultSetSingleHelper objRsSH=null;			/** �䱸�� �󼼺��� ���� */
 ResultSetHelper objRs=null;					/**�䱸 ��� */
 try{
   /**�䱸�� ���� �븮�� New */
   objReqBox=new CommRequestBoxDelegate();
   /**�䱸�� �̿� ���� üũ */
   boolean blnHashAuth=objReqBox.checkReqBoxAuth((String)objParams.getParamValue("ReqBoxID"),objUserInfo.getCurrentCMTList()).booleanValue();
   if(!blnHashAuth){
      objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	  objMsgBean.setStrCode("DSAUTH-0001");
  	  objMsgBean.setStrMsg("�ش� �䱸���� �� ������ �����ϴ�.");
  	  out.println("�ش� �䱸���� �� ������ �����ϴ�.");
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%
      return;
  }else{

   /** �䱸�� ���� */
    objRsSH=new ResultSetSingleHelper(objReqBox.getRecord((String)objParams.getParamValue("ReqBoxID")));

	/** ����ȸ �������� �϶��� ȭ�鿡 �����.*/
	if(!objUserInfo.getOrganGBNCode().equals("004")){
		objParams.setParamValue("OldReqOrganID",objUserInfo.getOrganID());
	}
    /**�䱸 ���� �븮�� New */
    objReqInfo=new CommRequestInfoDelegate();
    objRs=new ResultSetHelper((Hashtable)objReqInfo.getRecordList(objParams));
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
<link href="/css/System.css" rel="stylesheet" type="text/css">
<script language=Javascript src="/js/reqsubmit/common.js"></script>
<script language=Javascript src="/js/nads_lib.js"></script>
<script language=Javascript src="/js/datepicker.js"></script>
<script language=Javascript src="/js/calendar.js"></script>
<script language="javascript">
  //�䱸�� �������� ����.
  function gotoEdit(strReqBoxID){
    form=document.formName;
  	form.ReqBoxID.value=strReqBoxID;
  	form.action="./RCommReqBoxEdit.jsp?IngStt=001&ReqBoxStt=001";
  	form.target = "";
  	form.submit();
  }

  //�䱸�� ������ ����.
  function gotoDelete(strReqBoxID){
    form=document.formName;
  	form.ReqBoxID.value=strReqBoxID;

  	if(<%=objRs.getRecordSize()%> >0){
		if(confirm("��ϵ� �䱸������ �ֽ��ϴ�. \n�䱸�� ������ �����Ͻø� ��ϵ� �䱸������ ���� �����˴ϴ�. \n�����Ͻðڽ��ϱ�? ")){
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

  //�䱸�󼼺���� ����.
  function gotoDetail(strReqBoxID, strCommReqID){
    form=document.formName;
  	form.ReqBoxID.value=strReqBoxID;
  	form.CommReqID.value=strCommReqID;
  	form.action="./RCommReqInfo.jsp";
  	form.target = "";
  	form.submit();
  }

  /** ������� ���� */
  function gotoList(){
  	form=document.formName;
  	form.action="./RCommReqBoxList.jsp";
  	form.target = "";
  	form.submit();
  }

  /** �䱸����������� ����. */
  function gotoReqInfo(){
  	form = document.formName;
  	form.action="./RCommReqInfoWrite.jsp";
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
</script>
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
	    <input type="hidden" name="CmtOrganID" value="<%=objRsSH.getObject("CMT_ORGAN_ID")%>">
	    <input type="hidden" name="IngStt" value="">
	    <input type="hidden" name="ReqBoxNm" value="<%=objRsSH.getObject("REQ_BOX_NM")%>">
	    <input type="hidden" name="AuditYear" value="<%=objParams.getParamValue("AuditYear")%>">
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
		<input type="hidden" name="DelURL" value="/reqsubmit/20_comm/20_reqboxsh/RCommReqBoxList.jsp">
		<input type="hidden" name="RltdDuty" value="<%=objParams.getParamValue("RltdDuty")%>">

      <!-- pgTit -->
      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=MenuConstants.COMM_REQ_BOX_MAKE%><span class="sub_stl" >- <%=MenuConstants.REQ_BOX_DETAIL_VIEW%></span></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.REQUEST_BOX_COMM%> > <B><%=MenuConstants.COMM_REQ_BOX_MAKE%></B></div>
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
         <div class="top_btn"><samp>
            <%
            //������ �䱸��(�����Ϸ�-��������,�䱸�Ը��)
            //�����Ϸ� �䱸��((�䱸������,����׹߼�,(�䱸�Ի���)-��������,�䱸�Ը��)-��ư���ٸ���)
            //�߼ۿϷ�䱸��(�䱸������-��������,�䱸�Ը��)
            //����Ϸ�䱸��(�䱸������,���⹮������-��������,�䱸�Ը��)

            /** ����ȸ �������� �϶��� ȭ�鿡 �����.*/
            if(objUserInfo.getOrganGBNCode().equals("004") && !strReqSubmitFlag.equals("004")){
            %>
			 <span class="btn"><a href="#" onClick="gotoEdit('<%=objRsSH.getObject("REQ_BOX_ID")%>')">�䱸�� ����</a></span>
			 <span class="btn"><a href="#" onClick="gotoDelete('<%=objRsSH.getObject("REQ_BOX_ID")%>')">�䱸�� ����</a></span>
             <% }%>
			 <span class="btn"><a href="#" onClick="gotoList()">�䱸�� ���</a></span>
		 </samp></div>
			<!------------------------- TAB�� �ش��ϴ� ���̺�(����̵� ������̵� ��������) ��� ��~~~�� ------------------------->
			<table width="100%" border="0" cellspacing="0" cellpadding="0" class="list02">
			<%
				//�䱸�� ���� ����.
				String strIngStt=(String)objRsSH.getObject("ING_STT");
			%>
			<tr>
				<th scope="col">&bull;&nbsp;�䱸�Ը� </th>
				<td height="25" colspan="3"><B><%=objRsSH.getObject("REQ_BOX_NM")%></B></td>
			</tr>
            <tr>
            	<th scope="col">&bull;&nbsp;���� �䱸 ����</th>
				<td width="570" height="25" colspan="3"><%=StringUtil.getDate((String)objRsSH.getObject("ACPT_BGN_DT"))%> ���� <%=StringUtil.getDate((String)objRsSH.getObject("ACPT_END_DT"))%> ������ �䱸 ���� �Ⱓ�� �����Ǿ����ϴ�.
				</td>
            </tr>
			<tr>
				<th scope="col">&bull;&nbsp;�������� </th>
				<td height="25" colspan="3">
               	<%=objCdinfo.getRelatedDuty((String)objRsSH.getObject("RLTD_DUTY"))%>
				</td>
			</tr>
            <tr>
              	<th scope="col">&bull;&nbsp;�Ұ� ����ȸ </th>
              	<td width="230" height="25">
           	   	<%=objRsSH.getObject("CMT_ORGAN_NM")%>
              	</td>
              	<th scope="col">&bull;&nbsp;������ </th>
              	<td width="230" height="25">
              	<%=(String)objRsSH.getObject("SUBMT_ORGAN_NM")%>
              	</td>
            </tr>
            <tr>
              	<th scope="col">&bull;&nbsp;������� </th>
              	<td height="25" colspan="3">
              	<%=StringUtil.getDate((String)objRsSH.getObject("SUBMT_DLN"))%> ���� �亯 ������ ��û�մϴ�.
              	</td>
	        </tr>
			<tr>
				<th scope="col">&bull;&nbsp;�䱸�Լ��� </th>
			  	<td height="25" colspan="3">
			  	<%=StringUtil.getDescString((String)objRsSH.getObject("REQ_BOX_DSC"))%>
			  	</td>
			</tr>
			</table>
			<!------------------------- TAB�� �ش��ϴ� ���̺�(����̵� ������̵� ��������) ��� �� ------------------------->

         <div id="btn_all"><div  class="t_right">
            <% if(objUserInfo.getOrganGBNCode().equals("004") && !strReqSubmitFlag.equals("004") && intTotalRecordCount > 0){ %>
			<div class="mi_btn"><a href="#" onClick="PreReqDocView(formName,'<%=objRsSH.getObject("REQ_BOX_ID")%>','002');"><span>�䱸�� �̸� ����</span></a></div>
            <%}%>
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
					<th scope="col"><a>NO</a></th>
					<th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","REQ_CONT",strCommReqInfoSortField,strCommReqInfoSortMtd,"�䱸����")%></th>
					<th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","OLD_REQ_ORGAN_NM",strCommReqInfoSortField,strCommReqInfoSortMtd,"��û���")%></th>
					<th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","OPEN_CL",strCommReqInfoSortField,strCommReqInfoSortMtd,"�������")%></th>
					<th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","REG_DT",strCommReqInfoSortField,strCommReqInfoSortMtd,"��û��")%></th>
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
						<td align="center" height="20"><%=intRecordNumber%></td>
						<td>&nbsp;&nbsp;<%= StringUtil.getNotifyImg((String)objRs.getObject("REG_DT"), (String)objRs.getObject("REQ_STT")) %><a href="javascript:gotoDetail('<%=objRsSH.getObject("REQ_BOX_ID")%>','<%=objRs.getObject("REQ_ID")%>')" hint="<%= StringUtil.substring((String)objRs.getObject("REQ_DTL_CONT"), 80) %>"><%=objRs.getObject("REQ_CONT")%></a></td>
						<td align="center"><%=objRs.getObject("OLD_REQ_ORGAN_NM")%></td>
						<td align="center"><%=CodeConstants.getOpenClass((String)objRs.getObject("OPEN_CL"))%></td>
						<td width="65" align="right" style="padding-top:2px;padding-bottom:2px"><%=StringUtil.getDate2((String)objRs.getObject("REG_DT"))%></td>
					</tr>
					<%
				    intRecordNumber--;
					}//endwhile
				} else {
				%>
					<tr>
						<td colspan="5" height="35" align="center">��ϵ� �䱸������ �����ϴ�.</td>
					</tr>
				<%
				}//endif
				%>
            </tbody>
			</table>

                <!-----------------------------------------  ����¡ �׺���̼� ---------------------------------------->
                <%=objPaging.pagingTrans(PageCount.getLinkedString(
                    new Integer(intTotalRecordCount).toString(),
                    new Integer(intCurrentPageNum).toString(),
                    objParams.getParamValue("CommReqInfoPageSize")))%>

        <div id="btn_all" >        <!-- ����Ʈ �� �˻� -->
        <div class="list_ser" >
					<%
					String strCommReqInfoQryField=(String)objParams.getParamValue("CommReqInfoQryField");
					%>
					<select name="CommReqInfoQryField" class="select">
					<option <%=(strCommReqInfoQryField.equalsIgnoreCase("req_cont"))? " selected ": ""%>value="req_cont">�䱸 ����</option>
					<option <%=(strCommReqInfoQryField.equalsIgnoreCase("req_dtl_cont"))? " selected ": ""%>value="req_dtl_cont">�䱸����</option>
					<option <%=(strCommReqInfoQryField.equalsIgnoreCase("old_req_organ_nm"))? " selected ": ""%>value="old_req_organ_nm">������</option>
					</select>
					<input type="text" name="CommReqInfoQryTerm" value="<%=objParams.getParamValue("CommReqInfoQryTerm")%>"><img src="/images2/btn/bt_list_search.gif"  onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"  onClick="formName.submit()"/></div>
                    <!-- ��ư�� �ʿ��ϴٸ� ���⿡ �߰��Ͻ� �˴ϴٿ� -->
					<%
					/** ����ȸ �������� �϶��� ȭ�鿡 �����.*/
					if(objUserInfo.getOrganGBNCode().equals("004") && !strReqSubmitFlag.equals("004")){
					%>
                    <span class="right">
                    <span class="list_bt" onClick="gotoReqInfo();return false;"><a href="#">�䱸���</a></span>
                    </span>
					<% } %>
        </div>
        </div>
        </div>
        </form>
    </div>
  <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>