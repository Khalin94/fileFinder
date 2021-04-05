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
<%@ page import="nads.lib.reqsubmit.params.requestbox.RPreReqBoxVListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.prereqbox.PreRequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.prereqinfo.PreRequestInfoDelegate" %>
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
<%@ include file="../../../common/RUserCodeInfoInc.jsp" %>

<%
  //�α��� ����� ������ �����´�. ���Ѿ��� ��� ������ �����ϴ�.
  String strReqSubmitFlag = objUserInfo.getReqSubmitFlag();

  String strSelectedAuditYear= null; /**���õ� ����⵵*/

  /**�Ϲ� �䱸�� �󼼺��� �Ķ���� ����.*/
  RPreReqBoxVListForm objParams =new RPreReqBoxVListForm();
  objParams.setParamValue("ReqStt",CodeConstants.REQ_STT_NOT);/**������ �䱸�������.*/

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

 strSelectedAuditYear= objParams.getParamValue("AuditYear"); /**���õ� ����⵵*/

 /*** Delegate �� ������ Container��ü ���� */
 PreRequestBoxDelegate objReqBox=null; 		/**�䱸�� Delegate*/
 PreRequestInfoDelegate  objReqInfo=null;	/** �䱸���� Delegate */
 ResultSetSingleHelper objRsSH=null;		/** �䱸�� �󼼺��� ���� */
 ResultSetHelper objRs=null;				/**�䱸 ��� */
 ResultSetSingleHelper objRsInfo=null; //�䱸�� ���� ��ư�� �����ִ� ����


 String strReqBoxID=null; // by yan
 try{
   /**�䱸�� ���� �븮�� New */
   objReqBox=new PreRequestBoxDelegate();
   /**�䱸�� �̿� ���� üũ */

   boolean blnHashAuth=objReqBox.checkReqBoxAuth((String)objParams.getParamValue("ReqBoxID"),objUserInfo.getOrganID()).booleanValue();
   //boolean blnHashAuth=objReqBox.checkReqBoxAuth((String)objParams.getParamValue("ReqBoxID"),(String)objParams.getParamValue("CmtOrganID")).booleanValue();
   if(!blnHashAuth){
      objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	  objMsgBean.setStrCode("DSAUTH-0001");
  	  objMsgBean.setStrMsg("�ش� �䱸���� �� ������ �����ϴ�.");
  	  //out.println("�ش� �䱸���� �� ������ �����ϴ�.");

  	%>
  	<!--jsp:forward page="/common/message/ViewMsg.jsp"/-->
  	<%
    out.print("<script>alert('�ش�䱸���� �� ������ �����ϴ�.');history.back();</script>");
      return;
  }else{


    // �䱸�� ����
    objRsSH=new ResultSetSingleHelper(objReqBox.getRecord((String)objParams.getParamValue("ReqBoxID")));

    //�䱸�� ���� �߰����� -by yan
    strReqBoxID=(String)objParams.getParamValue("ReqBoxID");


   // �䱸 ���� �븮�� New
    objReqInfo=new PreRequestInfoDelegate();
    objRs=new ResultSetHelper(objReqInfo.getRecordList(objParams));

    //�䱸�� ���� ��ư �����ִ� ����
    Hashtable objHashRsInfo=objReqInfo.getAnsCnt((String)objParams.getParamValue("ReqBoxID"));
    objRsInfo= new ResultSetSingleHelper(objHashRsInfo);

  }//���� endif
 }catch(AppException objAppEx){
 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
	System.out.println("SysErrorCode:" + objAppEx.getStrErrCode());
  	objMsgBean.setStrCode("SYS-00010");//AppException����.
  	objMsgBean.setStrMsg(objAppEx.getMessage());
  	//out.println("<br>Error!!!" + objAppEx.getMessage());
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%
  	return;
 }
%>
<%

 //�䱸���� �����ȸ�� ��� ��ȯ.
 int intTotalRecordCount=objRs.getTotalRecordCount();
 int intCurrentPageNum=objRs.getPageNumber();
 int intTotalPage=objRs.getTotalPageCount();

%>
<jsp:include page="/inc/header.jsp" flush="true"/>
<link href="/css2/style.css" rel="stylesheet" type="text/css">
<script language="javascript">

  /**�䱸�� ������������ ����.*/
  function gotoEdit(){
  	document.formName.target = "";
	document.formName.action="./RBasicReqBoxEdit.jsp";
  	document.formName.submit();
  }

  /**�䱸�� ���� ���� */
  function gotoDel(){
	document.formName.target = "";
  	if(<%=objRs.getRecordSize()%>>0){
  		if(confirm("��ϵ� �䱸������ �ֽ��ϴ�. \n\n �䱸�� ������ �����Ͻø� ��ϵ� �䱸������ ���� �����˴ϴ�.\n\n �����Ͻðڽ��ϱ�?")==true){
	  		document.formName.action="./RBasicReqBoxDelProc.jsp";
  			document.formName.submit();
  		}//endif
  	}else{
  		if(confirm("��ϵ� �䱸���� ���� �Ͻðڽ��ϱ�?")==true){
	  		document.formName.action="./RBasicReqBoxDelProc.jsp";
  			document.formName.submit();
  		}//endif
  	}//endif
  }

  /** ���Ĺ�� �ٲٱ� */
  function changeSortQuery(sortField,sortMethod){
  	document.formName.ReqInfoSortField.value=sortField;
  	document.formName.ReqInfoSortMtd.value=sortMethod;
	document.formName.target = "";
  	document.formName.submit();
  }

  /** ������� ���� */
  function gotoList(){
   	document.formName.action="./RBasicReqBoxList.jsp";
	document.formName.target = "";
  	document.formName.submit();
  }

  /** ����¡ �ٷΰ��� */
  function goPage(strPage){
  	document.formName.ReqInfoPage.value=strPage;
	document.formName.target = "";
  	document.formName.submit();
  }

   /** �䱸����������� ����. */
  function gotoRegReqInfo(){
  	document.formName.action="./RBasicReqInfoWrite.jsp";
	document.formName.target = "";
  	document.formName.submit();
  }

  //�䱸���� �󼼺���� ����.
  function gotoDetail(strID){
  	document.formName.ReqInfoID.value=strID;
  	document.formName.action="./RBasicReqInfoVList.jsp";
    document.formName.target = "";
  	document.formName.submit();
  }

  //���� �䱸 ��������� ����.
  function bringPre(){
  	NewWindow('RBasicReqInfoAppointList.jsp?ReqBoxID=<%=objRsSH.getObject("REQ_BOX_ID")%>&CmtOrganID=<%=objRsSH.getObject("CMT_ORGAN_ID")%>&SubmtOrganID=<%=objRsSH.getObject("SUBMT_ORGAN_ID")%>&CmtOrganNM=<%=objRsSH.getObject("CMT_ORGAN_NM")%>&SubmtOrganNM=<%=objRsSH.getObject("SUBMT_ORGAN_NM")%>&AuditYear=<%=objRsSH.getObject("AUDIT_YEAR")%>&RltdDuty=<%=objRsSH.getObject("RLTD_DUTY")%>&ReturnUrl=<%=request.getRequestURI()%>','', '660', '560');
  }


   /** �Ϲ� �䱸���� �ϰ� ���� */
  function delPreReqInfos(formName){
     //�䱸 ��� ���� üũ Ȯ��.
  	if(hashCheckedReqInfoIDs(formName)==false) return false;
  	if(confirm("�����Ͻ� �䱸������ �����Ͻðڽ��ϱ�?\n\n�����Ͻ� �䱸������ ������ �ۼ��� �䱸���븸 �����˴ϴ�.")){
  		document.formName.action="./RBasicReqInfoDelArrProc.jsp";
		document.formName.target = "";
  		document.formName.submit();
  	}else{
  		return false;
  	}
  }

    /** �䱸�� ���� */
  function copyPreReqBox(){
  	if(confirm("�ش�䱸���� �����Ͻðڽ��ϱ�?")){
  	NewWindow('/reqsubmit/common/PreReqBoxCopyList.jsp?ReqBoxID='+ formName.ReqBoxID.value+'&CmtOrganID=<%=objRsSH.getObject("CMT_ORGAN_ID")%>&CmtOrganNM=<%=objRsSH.getObject("CMT_ORGAN_NM")%>','', '530', '410');
  	}
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
	<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>
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
		         <input type="hidden" name="ReqBoxNm" value="<%=objRsSH.getObject("REQ_BOX_NM")%>"><!--�ǵ��ƿ� URL -->
			     <input type="hidden" name="ReturnUrl" value="<%=request.getRequestURI()%>"><!--�ǵ��ƿ� URL -->

      <!-- pgTit -->

      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=MenuConstants.REQ_BOX_PRE%></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.REQUEST_BOX_PRE%> > <%=MenuConstants.REQ_BOX_PRE%></div>
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

        <!-- ��� ��ư ����-->
         <div class="top_btn">
			<samp>
		<%
		//���� ����
		if(!strReqSubmitFlag.equals("004")){
		  if(objUserInfo.getOrganGBNCode().equals("004") ){
		%>

			<%//�䱸�� ���� ��ư:�����ڷ�䱸�Կ����� �䱸�� �䱸�� �亯�� �ִ� ��쿡�� �䱸�� ������ �̷������ �ʴ´�.
				if(objRsInfo.next()){
					String strAnsCnt = (String)objRsInfo.getObject("ANS_CNT_TOTAL");
					if(strAnsCnt.equals("0") || strAnsCnt.equals("")){
			%>
		<!-- �䱸�� ���� -->
			 <span class="btn"><a href="#" onclick="javascript:gotoEdit()">�䱸�� ����</a></span>
			 <span class="btn"><a href="#" onclick="javascript:gotoDel()">�䱸�� ����</a></span>
			<%
					}
				}
			%>
			<!-- �䱸�� ���� -->
			 <span class="btn"><a href="javascript:copyPreReqBox(formName)">�䱸�� ����</a></span>
			<%
			 }//end if
			} //end if ���Ѿ����� ����
			%>
			<!-- �䱸�� ��� -->
			 <span class="btn"><a href="javascript:gotoList()">�䱸�� ���</a></span>
			 </samp>
		 </div>

        <!-- /��� ��ư ��-->

        <table border="0" cellspacing="0" cellpadding="0" width="680" class="list02">
		<%
			//�䱸�� ���� ����.
			String strReqBoxStt=(String)objRsSH.getObject("REQ_BOX_STT");

		%>
            <tr>
                <th height="25">&bull; ����ȸ </th>
                <td height="25" colspan="3"><strong><%=objRsSH.getObject("CMT_ORGAN_NM")%></strong></td>
            </tr>
            <tr>
                <th height="25">&bull; �䱸�Ը� </th>
                <td height="25" colspan="3"><%=objRsSH.getObject("REQ_BOX_NM")%></td>
            </tr>
            <tr>
                <th height="25">&bull; �������� </th>
                <td height="25"><%=objCdinfo.getRelatedDuty((String)objRsSH.getObject("RLTD_DUTY"))%></td>
                <th height="25">&bull; ������ </th>
                <td height="25"><%=(String)objRsSH.getObject("SUBMT_ORGAN_NM")%></td>

            </tr>
            <tr>
                <th height="25" width="120">&bull; ������� </th>
                <td height="25" width="220"><%=StringUtil.getDate((String)objRsSH.getObject("SUBMT_DLN"))%></td>
                <th height="25" width="120">&bull;&nbsp;������� </th>
                <td height="25" width="220"><%=StringUtil.getDate((String)objRsSH.getObject("REG_DT"))%></td>
            </tr>
            <tr>
                <th height="25">&bull; �䱸�Լ��� </th>
                <td height="25" colspan="3">
				<%=StringUtil.getDescString((String)objRsSH.getObject("REQ_BOX_DSC"))%>
				</td>
            </tr>
        </table><br><br>
        <!-- /list view -->
        <!--<p class="warning mt10">* �䱸�� �߼� : �ǿ���(�Ǵ� �Ҽӱ��) ���Ƿ� �ش� �������� �䱸���� �߼��մϴ�.</p>  -->


        <!-- list -->
        <span class="list01_tl">�䱸��� <span class="list_total">&bull;&nbsp;��ü�ڷ�� : <%= intTotalRecordCount %>�� </span></span>

			<table width="100%" style="padding:0;">
			   <tr>
				<td>&nbsp;</td>
			   </tr>
			 </table>


        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
          <thead>
            <tr>
			<%if(objUserInfo.getOrganGBNCode().equals("004")){%>
               <th scope="col">
			  <input type="checkbox" name="checkAll" value="" onClick="checkAllOrNot(document.formName);" class="borderNo"/>
			  </th>
			  <% } %>
              <th scope="col"><a>NO</a></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","REQ_CONT",strReqInfoSortField,strReqInfoSortMtd,"�䱸����")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","OPEN_CL",strReqInfoSortField,strReqInfoSortMtd,"�������")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","REQ_STT",strReqInfoSortField,strReqInfoSortMtd,"�������")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","REG_DT",strReqInfoSortField,strReqInfoSortMtd,"�������")%></th>
            </tr>
          </thead>
          <tbody>
		<%
			int intRecordNumber= intTotalRecordCount - ((intCurrentPageNum -1) * Integer.parseInt((String)objParams.getParamValue("ReqInfoPageSize")));
			if(objRs.getRecordSize()>0){
				String strReqInfoID="";
				while(objRs.next()){
				strReqInfoID=(String)objRs.getObject("REQ_ID");
		 %>
            <tr>
			<% if(objRs.getObject("LAST_ANS_DT")== null){
				if(objUserInfo.getOrganGBNCode().equals("004")){
			%>
			  <td><input type="checkbox" name="ReqInfoIDs" value="<%= strReqInfoID %>" class="borderNo"/></td>
			  <%			}%>
              <td><%=intRecordNumber%></td>
              <td style="text-align:left;"><a href="JavaScript:gotoDetail('<%=strReqInfoID%>');"><%=StringUtil.substring((String)objRs.getObject("REQ_CONT"),35)%></a></td>

              <td><%=CodeConstants.getOpenClass((String)objRs.getObject("OPEN_CL"))%></td>
              <td><%=CodeConstants.getRequestStatus((String)objRs.getObject("REQ_STT"))%></td>
              <td><%=StringUtil.getDate((String)objRs.getObject("REG_DT"))%></td>
			  <% }else {
					if(objUserInfo.getOrganGBNCode().equals("004")){%>
              <td><input type="checkbox" name="ReqInfoIDs" value="<%= strReqInfoID %>" class="borderNo" disabled/></td>
			  <%			}%>
			  <td><%=intRecordNumber%></td>
              <td><a href="JavaScript:gotoDetail('<%=strReqInfoID%>');"><%=StringUtil.substring((String)objRs.getObject("REQ_CONT"),35)%></a></td>
			  <td><%=CodeConstants.getOpenClass((String)objRs.getObject("OPEN_CL"))%></td>
			  <td><%=CodeConstants.getRequestStatus((String)objRs.getObject("REQ_STT"))%></td>
			  <td><%=StringUtil.getDate((String)objRs.getObject("REG_DT"))%></td>
			  <% }%>
            </tr>
		<%

				intRecordNumber --;
			}//endwhile

		}else{
		%>
            <tr>
				<td colspan="6" align="center"> ��ϵ� �䱸������ �����ϴ�.</td>
            </tr>
		<%
		}//end if ��� ��� ��.
		%>

          </tbody>
        </table>

				<%=objPaging.pagingTrans(PageCount.getLinkedString(
							new Integer(intTotalRecordCount).toString(),
							new Integer(intCurrentPageNum).toString(),
							objParams.getParamValue("ReqInfoPageSize")))%>


		<div id="btn_all" >        <!-- ����Ʈ �� �˻� -->
        <div class="list_ser" >
		<%
			String strReqInfoQryField=(String)objParams.getParamValue("ReqInfoQryField");
		%>
          <select name="ReqInfoQryField" class="selectBox5"  style="width:70px;" >
			  <option <%=(strReqInfoQryField.equalsIgnoreCase("req_cont"))? " selected ": ""%>value="req_cont">�䱸����</option>
			  <option <%=(strReqInfoQryField.equalsIgnoreCase("req_dtl_cont"))? " selected ": ""%>value="req_dtl_cont">�䱸����</option>
          </select>
          <input name="ReqInfoQryTerm" onKeyDown="return ch()" onMouseDown="return ch()"
		 class="li_input"  style="width:100px" value="<%=objParams.getParamValue("ReqInfoQryTerm")%>"/>
          <img src="/images2/btn/bt_list_search.gif"  onMouseOver="menuOn(this);" onMouseOut="menuOut(this);" onClick="formName.submit();"/> </div>
        <!-- /����Ʈ �� �˻� -->

			<span class="right">
				<%
				  if(objUserInfo.getOrganGBNCode().equals("004")){
				%>
				<span class="list_bt"><a href="javascript:gotoRegReqInfo()">�䱸���</a></span>
				<span class="list_bt"><a href="javascript:bringPre()">�����䱸��������</a></span>
				<%
					if(objRs.getRecordSize()>0 ){/**�䱸�����������츸 ���*/
				%>
				<span class="list_bt"><a href="javascript:delPreReqInfos(formName);">�䱸����</a></span>
				<%
					}//endif
				%>
				<%
				 }//endif - first
				%>
			</span>
		</div>
        <!-- /�������� ���� -->
      </div>
</form>
      <!-- /contents -->

    </div>
  </div>
  <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>