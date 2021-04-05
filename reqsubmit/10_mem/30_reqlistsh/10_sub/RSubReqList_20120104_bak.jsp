
<%@ page language="java" contentType="text/html;charset=EUC-KR" %>

<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.bf.config.*"%>
<%@ page import="kr.co.kcc.pf.util.PageCount"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.params.requestinfo.RMemReqInfoListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.MemRequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.MemRequestInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.cmtsubmt.CmtSubmtReqBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.RequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.common.page.PagingDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<jsp:include page="/inc/header.jsp" flush="true"/>

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
	/**���õ� ����⵵�� ���õ� ����ȸID*/
	String strSelectedAuditYear= null; /**���õ� ����⵵*/
	String strSelectedCmtOrganID=null; /**���õ� ����ȸID*/
	String strRltdDuty=null; 			 /**���õ� �������� */
	String strCmtReqAppFlag=null;	/** ���õ� ����ȸ �����û */
	/**�Ϲ� �䱸�� �󼼺��� �Ķ���� ����.*/
	RMemReqInfoListForm objParams =new RMemReqInfoListForm();
	objParams.setParamValue("ReqStt",CodeConstants.REQ_STT_SUBMT);/**����ȿ䱸�������.*/
	objParams.setParamValue("ReqOrganID",objUserInfo.getOrganID());/**�䱸���ID*/
	objParams.setParamValue("ReqInfoSortField","last_ans_dt");/**�����亯���� Default*/
	objParams.setParamValue("IsRequester",String.valueOf(objUserInfo.isRequester()));//�䱸�亯�ڿ��μ���

	boolean blnParamCheck=false;
	/**���޵� �ĸ����� üũ */
	blnParamCheck=objParams.validateParams(request);
	if(blnParamCheck==false){
		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
		objMsgBean.setStrCode("DSPARAM-0000");
		objMsgBean.setStrMsg(objParams.getStrErrors());
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}//endif

	strSelectedAuditYear= objParams.getParamValue("AuditYear"); /**���õ� ����⵵*/
	strSelectedCmtOrganID=objParams.getParamValue("CmtOrganID") ; /**���õ� ����ȸID*/
	strRltdDuty=objParams.getParamValue("RltdDuty") ; 			 /**���õ� �������� */
	strCmtReqAppFlag=objParams.getParamValue("CmtReqAppFlag");	/** ���õ� ����ȸ �����û */

	String strDaesuInfo = StringUtil.getEmptyIfNull(request.getParameter("DaeSu"));
	String strDaeSuCh = StringUtil.getEmptyIfNull(request.getParameter("DAESUCH"));

	/*************************************************************************************************/
	/** 					������ ȣ�� Part 														  */
	/*************************************************************************************************/

	/*** Delegate �� ������ Container��ü ���� */
	MemRequestBoxDelegate objReqBox=null; 		/**�䱸�� Delegate*/
	MemRequestInfoDelegate  objReqInfo=null;	/** �䱸���� Delegate */
	CmtSubmtReqBoxDelegate objCmtSubmt = null;
	RequestBoxDelegate objReqBoxDelegate = null;


	ResultSetHelper objRs=null;				/**�䱸 ��� */
	ResultSetHelper objCmtRs=null;			/** ������ ����ȸ */
	ResultSetHelper objRltdDutyRs=null;   /** �������� ����Ʈ ��¿� RsHelper */
	ResultSetHelper objDaeRs=null;
	ResultSetHelper objYearRs=null;

	String strDaesu = null;
	String strStartdate = null;
	String strEnddate = null;

	try{
		/**�䱸�� ���� �븮�� New */
		objReqBox=new MemRequestBoxDelegate();
		objCmtSubmt = new CmtSubmtReqBoxDelegate();
		objReqBoxDelegate = new RequestBoxDelegate();

		objDaeRs = new ResultSetHelper(objReqBoxDelegate.getOrganDaesu(objUserInfo.getOrganID()));
		if(strDaesuInfo.equals("")){
			if(objDaeRs != null){
				if(objDaeRs.next()){
					strDaesu = (String)objDaeRs.getObject("DAE_NUM");
					strStartdate = (String)objDaeRs.getObject("START_DATE");
					strEnddate = (String)objDaeRs.getObject("END_DATE");
					objDaeRs.first();
				}
			}
		}else{
			String[] strDaesuInfos = StringUtil.split("^",strDaesuInfo);
			strDaesu = strDaesuInfos[0];
			strStartdate = strDaesuInfos[1];
			strEnddate = strDaesuInfos[2];

		}


		Hashtable objhashdata = new Hashtable();

		objhashdata.put("START_DATE",strStartdate);
		objhashdata.put("END_DATE",strEnddate);

		objCmtRs=new ResultSetHelper(objReqBox.getReqrPerSubCmtDaeList(objUserInfo.getOrganID(), CodeConstants.REQ_STT_SUBMT,strStartdate,strEnddate,strSelectedAuditYear));
		objYearRs = new ResultSetHelper(objReqBox.getReqrPerSubYearDaeList(objUserInfo.getOrganID(), CodeConstants.REQ_STT_SUBMT,strStartdate,strEnddate));

		/**�䱸 ���� �븮�� New */
		objReqInfo=new MemRequestInfoDelegate();
		objRs=new ResultSetHelper(objReqInfo.getRecordDaeList(objParams,objhashdata));
		objRltdDutyRs=new ResultSetHelper(objCdinfo.getRelatedDutyList());
	}catch(AppException objAppEx){
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		objMsgBean.setStrCode(objAppEx.getStrErrCode());
		objMsgBean.setStrMsg(objAppEx.getMessage());
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

<link href="/css2/style.css" rel="stylesheet" type="text/css">
<script language="javascript">

  /** ���Ĺ�� �ٲٱ� */
  function changeSortQuery(sortField,sortMethod){
  	formName.ReqInfoSortField.value=sortField;
  	formName.ReqInfoSortMtd.value=sortMethod;
	formName.DAESUCH.value = "N";
  	formName.submit();
  }

  //�䱸�Ի󼼺���� ����.
  function gotoDetail(strID){
  	formName.ReqInfoID.value=strID;
  	formName.action="./RSubReqVList.jsp";
  	formName.submit();
  }

  /** ����¡ �ٷΰ��� */
  function goPage(strPage){
  	formName.ReqInfoPage.value=strPage;
	formName.DAESUCH.value = "N";
  	formName.submit();
  }

  /**�⵵�� ����ȸ�θ� ��ȸ�ϱ� */
  function gotoHeadQuery(){
  	formName.ReqInfoQryField.value="";
  	formName.ReqInfoQryTerm.value="";
  	formName.ReqInfoSortField.value="";
  	formName.ReqInfoSortMtd.value="";
  	formName.ReqInfoPage.value="";
	formName.DAESUCH.value = "N";
  	formName.submit();
  }

  function changeDaesu(){
	formName.target = '';
	formName.DAESUCH.value = "Y";
  	formName.submit();
  }
  function doListRefresh() {
	var f = document.formName;
	f.target = "";
	f.submit();
  }
</script>
<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>
</head>

<body>
<div id="balloonHint" style="display:none;height:60px">
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
<div id="wrap">
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
<form name="formName" method="get" action="<%=request.getRequestURI()%>">
          <%
			//�䱸 ���� ���� ���� �ޱ�.
			String strReqInfoSortField=objParams.getParamValue("ReqInfoSortField");
			String strReqInfoSortMtd=objParams.getParamValue("ReqInfoSortMtd");
			//�䱸 ���� ������ ��ȣ �ޱ�.
			String strReqInfoPagNum=objParams.getParamValue("ReqInfoPage");
		  %>
			  <input type="hidden" name="ReqInfoSortField" value="<%=strReqInfoSortField%>"><!--�䱸���� ��������ʵ� -->
			  <input type="hidden" name="ReqInfoSortMtd" value="<%=strReqInfoSortMtd%>"><!--�䱸���� ������ɹ��-->
			  <input type="hidden" name="ReqInfoPage" value="<%=strReqInfoPagNum%>"><!--�䱸���� ������ ��ȣ -->
			  <input type="hidden" name="ReqInfoID" value=""><!--�䱸���� ID-->
			  <input type="hidden" name="ReturnUrl" value="<%=request.getRequestURI()%>"><!--�ǵ��ƿ� URL -->
			  <input type="hidden" name="DAESUCH" value="">

      <!-- pgTit -->

      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=MenuConstants.REQ_INFO_LIST_SUBMT_DONE%></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.getReqBoxGeneral(request)%> > <%=MenuConstants.REQ_INFO_LIST%> > <%=MenuConstants.REQ_INFO_LIST_SUBMT_DONE%></div>
        <p>���������� ��� ������ �Ϸ��� �䱸 ����Դϴ�.</p>
      </div>
      <!-- /pgTit -->

      <!-- contents -->

      <div id="contents">

        <!-- �˻����� ���� ��� �Ʒ� div ���� �� �ּ����� ��������.-->
        <div class="schBox">
          <p>�䱸����ȸ����</p>
          <span class="line"><img src="/images2/foundation/search_line.gif" width="172" height="3" /></span>
          <div class="box">
            <!-- ������ �˻� ����Ʈ�� ��ư�� ��������-->
            <select onChange="changeDaesu()" name="DaeSu">
            <%
			if(objDaeRs != null){
				while(objDaeRs.next()){
					String str = objDaeRs.getObject("DAE_NUM")+"^"+objDaeRs.getObject("START_DATE")+"^"+objDaeRs.getObject("END_DATE");
			%>
			<option value="<%=objDaeRs.getObject("DAE_NUM")%>^<%=objDaeRs.getObject("START_DATE")%>^<%=objDaeRs.getObject("END_DATE")%>" <%if(str.equals(strDaesuInfo)){%>selected<%}%>><%=objDaeRs.getObject("DAE_NUM")%>��</option>
			<%
					}
				}
			%>
            </select>
            <select onChange="javascript:doListRefresh()" name="AuditYear">
             <option value="">��ü</option>
			<%
				if(objYearRs != null && objYearRs.getTotalRecordCount() > 0){
					while(objYearRs.next()){
				%>
					<option value="<%=objYearRs.getObject("AUDIT_YEAR")%>" <%if(((String)objYearRs.getObject("AUDIT_YEAR")).equals(strSelectedAuditYear)){%>selected<%}%>><%=objYearRs.getObject("AUDIT_YEAR")%></option>
				<%
					}
				}
			%>
            </select>
            <select onChange="javascript:doListRefresh()" name="CmtOrganID">
				  <option value="">:::: ��ü����ȸ :::</option>
				<%
				if(objCmtRs != null && objCmtRs.getTotalRecordCount() > 0){
					while(objCmtRs.next()){
				%>
					<option value="<%=objCmtRs.getObject("ORGAN_ID")%>" <%if(((String)objCmtRs.getObject("ORGAN_ID")).equals(strSelectedCmtOrganID)){%>selected<%}%>><%=objCmtRs.getObject("ORGAN_NM")%></option>
				<%
					}
				}
			%>
            </select>
            <select name="RltdDuty">
              <option value="">��������(��ü)</option>
				<%
				   /**�������� ����Ʈ ��� */
				   while(objRltdDutyRs!=null && objRltdDutyRs.next()){
						String strCode=(String)objRltdDutyRs.getObject("MSORT_CD");
						out.println("<option value=\"" + strCode + "\" " + StringUtil.getSelectedStr(strRltdDuty,strCode) + ">" + objRltdDutyRs.getObject("CD_NM") + "</option>");
				   }
				%>
            </select>
            <a href="javascript:gotoHeadQuery();"><img src="/images2/btn/bt_search2.gif" width="50" height="22" /></a> </div>
        </div>
        <!-- /�˻�����-->

        <!-- �������� ���� -->

        <!-- list -->

        <span class="list_total">&bull;&nbsp;��ü�ڷ�� : <%=intTotalRecordCount%>�� (<%=intCurrentPageNum%> / <%=intTotalPage%> page)</span>

        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
          <thead>
            <tr>
              <th scope="col"><input name="checkAll" type="checkbox" value="" class="borderNo" onClick="checkAllOrNot(document.formName);"/></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","",strReqInfoSortField,strReqInfoSortMtd,"NO")%></th>
              <th scope="col" width="250px;"><%=SortingUtil.getSortLink("changeSortQuery","REQ_CONT",strReqInfoSortField,strReqInfoSortMtd,"�䱸����")%></th>
			  <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","REGR_NM",strReqInfoSortField,strReqInfoSortMtd,"�����")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","SUBMT_ORGAN_NM",strReqInfoSortField,strReqInfoSortMtd,"������")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","REQ_BOX_NM",strReqInfoSortField,strReqInfoSortMtd,"�䱸��")%></th>
			<%
				int intTmpWidth1=90;
				if(objUserInfo.getOrganGBNCode().equals("003")){//�ǿ��ǼҼ�
			%>
			<%
				 intTmpWidth1=intTmpWidth1-50;
				}//endif�ǿ��ǼҼ�Ȯ��
			%>
               <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","",strReqInfoSortField,strReqInfoSortMtd,"�亯")%></th>
			   <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","REG_DT",strReqInfoSortField,strReqInfoSortMtd,"����Ͻ�")%></th>
			   <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","LAST_ANS_DT",strReqInfoSortField,strReqInfoSortMtd,"�亯�Ͻ�")%></th>
            </tr>
          </thead>
          <tbody>
		<%
		  int intRecordNumber=intTotalRecordCount - ((intCurrentPageNum -1) * Integer.parseInt((String)objParams.getParamValue("ReqInfoPageSize")));
		  String strReqInfoID="";
		  String strCmtApplyValue="Y";
		  while(objRs.next()){
			 strReqInfoID=(String)objRs.getObject("REQ_ID");
			 /** ����ȸ��û��������(Y) �ƴ��� "" ����*/
			if(CodeConstants.isDuplatedApplyToCmtReq((String)objRs.getObject("CMT_REQ_APP_FLAG"))){
				strCmtApplyValue="";
			}else{
				strCmtApplyValue="Y";
			}
		 %>
            <tr>
              <td><input name="ReqInfoIDs" type="checkbox" value="<%=strReqInfoID%>" class="borderNo" /></td>
              <td><%=intRecordNumber%></td>
              <td><a href="JavaScript:gotoDetail('<%=strReqInfoID%>');" hint="<%= StringUtil.substring((String)objRs.getObject("REQ_DTL_CONT"), 100) %> ..."><%=(String)objRs.getObject("REQ_CONT")%></a>
			  </td>
			  <td><%=(String)objRs.getObject("REGR_NM")%></td>
              <td><%=objRs.getObject("SUBMT_ORGAN_NM")%></td>
              <td><a href="<%=nads.dsdm.app.reqsubmit.delegate.requestinfo.RequestInfoDelegate.getGotoMemReqBoxURLReqr((String)objRs.getObject("REQ_BOX_STT"))%>?ReqBoxID=<%=objRs.getObject("REQ_BOX_ID")%>"><img src="/image/reqsubmit/icon_secretariat.gif" border="0" alt="<%=objRs.getObject("REQ_BOX_NM")%> �ٷΰ���"></a></td>
			<%
				int intTmpWidth2=90;
				if(objUserInfo.getOrganGBNCode().equals("003")){//�ǿ��ǼҼ�
			%>
			<%
				 intTmpWidth2=intTmpWidth2-50;
				}//endif�ǿ��ǼҼ�Ȯ��
			%>
              <td><%=nads.lib.reqsubmit.util.DBAccessUtil.makeAnsInfoHtml((String)objRs.getObject("ANS_ID"),(String)objRs.getObject("ANS_MTD"),(String)objRs.getObject("ANS_OPIN"),(String)objRs.getObject("SUBMT_FLAG"),objUserInfo.isRequester())%></td>
			  <td><%=StringUtil.getDate2((String)objRs.getObject("REG_DT"))%> </td>
			  <td><%=StringUtil.getDate2((String)objRs.getObject("LAST_ANS_DT"))%></td>
			  <input type="hidden" name="CmtApplys" value="<%=strCmtApplyValue%>">
            </tr>
			<%
					intRecordNumber --;
				}//endwhile
			%>
			<%
				/*��ȸ��� ������ ��� ����.*/
				if(objRs.getRecordSize()<1){
			%>
			<tr>
				<td colspan="8" align="center">��ϵ� �䱸������ �����ϴ�.</td>
			</tr>
			<%
				}/*��ȸ��� ������ ��� ��.*/
			%>
          </tbody>
        </table>

        <!-- /list -->
					<%=objPaging.pagingTrans(PageCount.getLinkedString(
							new Integer(intTotalRecordCount).toString(),
							new Integer(intCurrentPageNum).toString(),
							objParams.getParamValue("ReqInfoPageSize")))%>
        <!-- ����¡-->
         <!-- /����¡-->
        <!--  <p class="warning">* �䱸���� �߼��ϰ� �Ǹ� �ش� ���� ��� ��ǥ ����ڿ��� ���� �߼۵Ǹ�, ����ڰ� ���� ���� �ۼ� �� �䱸�Կ� �״�� �����ְ� �˴ϴ�.  </p>
          <p class="warning">* �䱸�� �߼� ��ư�� �̿��Ͻñ� ���ؼ��� ����ȸ�� ������ �ֽñ� �ٶ��ϴ�.  </p>  -->



        <!-- ����Ʈ ��ư-->
        <div id="btn_all" >        <!-- ����Ʈ �� �˻� -->
        <div class="list_ser" >
		<%
			String strReqInfoQryField=(String)objParams.getParamValue("ReqInfoQryField");
		%>
          <select name="ReqInfoQryField" class="selectBox5"  style="width:70px;" >
            <option <%=(strReqInfoQryField.equalsIgnoreCase("req_cont"))? " selected ": ""%>value="req_cont">�䱸����</option>
			<option <%=(strReqInfoQryField.equalsIgnoreCase("req_dtl_cont"))? " selected ": ""%>value="req_dtl_cont">�䱸����</option>
			<option <%=(strReqInfoQryField.equalsIgnoreCase("req_box_nm"))? " selected ": ""%>value="req_box_nm">�䱸�Ը�</option>
            <option <%=(strReqInfoQryField.equalsIgnoreCase("regr_nm"))? " selected ": ""%>value="regr_nm">�����</option>
			<option <%=(strReqInfoQryField.equalsIgnoreCase("submt_organ_nm"))? " selected ": ""%>value="submt_organ_nm">������</option>
          </select>
          <input name="ReqInfoQryTerm" onKeyDown="return ch()" onMouseDown="return ch()"
		 class="li_input"  style="width:100px" value="<%=objParams.getParamValue("ReqInfoQryTerm")%>"/>
          <img src="/images2/btn/bt_list_search.gif"  onMouseOver="menuOn(this);" onMouseOut="menuOut(this);" onClick="formName.submit();"/> </div>
        <!-- /����Ʈ �� �˻� -->
		<span class="right">
		<%
			if(objRs.getRecordSize() > 0) { //�䱸�����������������

				if(objUserInfo.getOrganGBNCode().equals("003") && objUserInfo.getIsMyCmtOrganID(strSelectedCmtOrganID) && !objCmtSubmt.checkCmtOrganMakeAutoSche(strSelectedCmtOrganID)) {
		%>
			<span class="list_bt"><a href="#" onclick="ApplyCmt(document.formName);">����ȸ ���� ��û</a></span>
		<%
				}
		%>
			<span class="list_bt"><a href="#" onclick="addBinder(document.formName);">���δ� ���</a></span>
		<%
			}
		%>
		</span>
		</div>
        <!-- /����Ʈ ��ư-->

        <!-- /�������� ���� -->
      </div>
      <!-- /contents -->
</form>
    </div>
  </div>
  <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>
<%
	System.out.println("TIMEMMMM5 : "+this.getCurrentTime());
%>
<%!
	public String getCurrentTime() {
        Calendar oCalendar = Calendar.getInstance();
		String serverDate = oCalendar.get(Calendar.YEAR) + "/" +(oCalendar.get(Calendar.MONTH) + 1)+"/"+ oCalendar.get(Calendar.DAY_OF_MONTH)+"  "+oCalendar.get(Calendar.HOUR_OF_DAY)+":"+oCalendar.get(Calendar.MINUTE)+":"+oCalendar.get(Calendar.SECOND)+":"+oCalendar.get(Calendar.MILLISECOND);
		 return serverDate;
     }

%>