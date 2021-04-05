<%@ page language="java" contentType="text/html;charset=EUC-KR" %>

<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.pf.util.PageCount"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.*" %>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RCommReqBoxListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.CommRequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.cmtmanager.CmtManagerConfirmDelegate" %>

<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.RequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.common.page.PagingDelegate" %>
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

<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>


<%

	//�α��� ����� ������ �����´�. ���Ѿ��� ��� ������ �����ϴ�.


	String strReqSubmitFlag = objUserInfo.getReqSubmitFlag();


	/**���õ� ����⵵�� ���õ� ����ȸID*/


	String strSelectedAuditYear= null; /**���õ� ����⵵*/

	String strSelectedCmtOrganID=null; /**���õ� ����ȸID*/

	String strReqScheID="";			 /**����ȸ �䱸����ID*/

	String strRltdDuty=null; 			 /**���õ� �������� */

	String strUserId = objUserInfo.getUserID();

	String strDaeSuCh = null;

	String strDaesuInfo = StringUtil.getEmptyIfNull(request.getParameter("DaeSu"));

	strDaeSuCh = StringUtil.getEmptyIfNull(request.getParameter("DAESUCH"));

	String strDaesu = null;

	String strStartdate = null;

	String strEnddate = null;


	int FLAG = -1;





	/**����ȸ�����ȸ�� �Ķ���� ����.*/

	RCommReqBoxListForm objParams=new RCommReqBoxListForm();

	//�䱸��� ���� :: �Ҽ� ���.

	objParams.setParamValue("ReqOrganID",objUserInfo.getOrganID());

	//����ȸ �䱸����������� : �����Ϸ�

	objParams.setParamValue("IngStt",CodeConstants.REQ_ING_STT_002);

	//�䱸�� ���� : �����Ϸ�

	objParams.setParamValue("ReqBoxStt",CodeConstants.REQ_BOX_STT_007);

	/** ����ȸ �������� �϶��� ȭ�鿡 �����.*/

	if(objUserInfo.getOrganGBNCode().equals("004") && (objParams.getParamValue("CmtOrganID")).equals("")){

		objParams.setParamValue("CmtOrganID",objUserInfo.getOrganID());

	}

	//�ش�����ȸ�� �������.. �����޼��� ���..

	if(objUserInfo.getCurrentCMTList().isEmpty()){

		objParams.setParamValue("CmtOrganID","XXXXXXXXXX");

	}

	String strReqOrganID = "";

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

	}

	strSelectedAuditYear= objParams.getParamValue("AuditYear"); 	/**���õ� ����⵵*/

	strSelectedCmtOrganID=objParams.getParamValue("CmtOrganID");    /**���õ� ����ȸID*/

	strRltdDuty=objParams.getParamValue("RltdDuty") ;


	//�䱸�� ��ü ��Delegate �����.

	CommRequestBoxDelegate objReqBox = null;

	ResultSetHelper objCmtRs=null;			/** ������ ����ȸ */

	ResultSetHelper objDaeRs=null;

	ResultSetHelper objRs=null;			/** ����ȸ �䱸�� ��� */

	ResultSetHelper objRltdDutyRs=null;   /** �������� ����Ʈ ��¿� RsHelper */

	ResultSetHelper objYearRs=null;

	ResultSetSingleHelper objOrganNm = null;

	CmtManagerConfirmDelegate cmtmanagerCn = new CmtManagerConfirmDelegate();

	//�߰��亯 �� ���⿩��Ȯ��
    SMemReqBoxDelegate sReqDelegate = new SMemReqBoxDelegate();


	RequestBoxDelegate objReqBoxDelegate = null;

	ResultSetHelper objReqOrganRS = null;				/** ����ȸ�� �ǿ��� ��� */

	String strCmtOpenCl = "";

	ArrayList listdata2 = null;

	Hashtable obOrganNm = null;

	try{
		strReqOrganID = StringUtil.getEmptyIfNull(objParams.getParamValue("ReqOrganIDZ"));


		if(objUserInfo.getOrganGBNCode().equals("004") && !strReqSubmitFlag.equals("004")){



		}else{
				String strSelfOrganID = (String)objUserInfo.getOrganID();
				if((strSelectedCmtOrganID.equals("") && strReqOrganID.equals("00")) || strSelectedCmtOrganID.equals("") && strReqOrganID.equals("")){
					objParams.setParamValue("ReqOrganIDZ",strSelfOrganID);
				}else if(!strSelectedCmtOrganID.equals("") && strReqOrganID.equals("00")){
					//objParams.setParamValue("ReqOrganIDZ",strSelfOrganID);
				}



		}



	 	objReqBox=new CommRequestBoxDelegate();

		objReqBoxDelegate = new RequestBoxDelegate();

		obOrganNm = (Hashtable)objReqBoxDelegate.getEndDate(objUserInfo.getOrganID());
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

		Hashtable objhashdata = null;



		List lst = null;

		if(objUserInfo.getOrganGBNCode().equals("004")){
			lst = objUserInfo.getCurrentCMTList();

			for(int i = 0 ; i < lst.size();i++){

				objhashdata = new Hashtable();

				objhashdata = (Hashtable)lst.get(i);

				List lst2 = (List)objReqBox.getDaeCMTList((String)objhashdata.get("ORGAN_ID"));

				Hashtable objhashdata2 = null;

				if(lst2.size() > 0){

					for(int j = 0; j < lst2.size(); j++){

						objhashdata2 = new Hashtable();

						Hashtable temp = (Hashtable)lst2.get(j);

						if(((String)temp.get("ORGAN_ID")) != null){

							objhashdata2.put("ORGAN_ID",(String)temp.get("ORGAN_ID"));

							objhashdata2.put("ORGAN_NM",(String)temp.get("ORGAN_NM"));

							lst.add(objhashdata2);

						}

					}

				}

			}

			objCmtRs=new ResultSetHelper(lst);
			objYearRs = new ResultSetHelper(objReqBox.getDaeCmtYearList(lst,CodeConstants.REQ_BOX_STT_007,strStartdate,strEnddate));


		}else{
			lst = objReqBox.getDaeCMTListNew(CodeConstants.REQ_BOX_STT_007,strStartdate,strEnddate,strSelectedAuditYear,(String)objUserInfo.getOrganID());
			if(lst.size() == 0){
				lst = objUserInfo.getCurrentCMTList();
			}
			objCmtRs = new ResultSetHelper(lst);
			objYearRs = new ResultSetHelper(objReqBox.getDaeYearList(CodeConstants.REQ_BOX_STT_007,strStartdate,strEnddate,(String)objUserInfo.getOrganID()));

		}

		Hashtable objhashdata2 = new Hashtable();

		objhashdata2.put("START_DATE",strStartdate);

		objhashdata2.put("END_DATE",strEnddate);
		objhashdata2.put("CMTORGANIDZ",lst);

		objParams.setParamValue("AuditYear",strSelectedAuditYear);


   		objRltdDutyRs=new ResultSetHelper(objCdinfo.getRelatedDutyList());

   		//�䱸�� ���

		objRs=new ResultSetHelper(objReqBox.getRecordDaeList(objParams,objhashdata2));

	   	//����ȸ����ID

	   	strReqScheID = objReqBox.getReqScheID(strSelectedAuditYear, strSelectedCmtOrganID, CodeConstants.REQ_ING_STT_002, CodeConstants.REQ_BOX_STT_007);

		FLAG = cmtmanagerCn.getFLAG((String)objParams.getParamValue("CmtOrganID"));


		//����ȸ�䱸�ڷ�������������2006-09-20


		strCmtOpenCl = cmtmanagerCn.getOpenCl((String)objParams.getParamValue("CmtOrganID")) == null ? "" : cmtmanagerCn.getOpenCl((String)objParams.getParamValue("CmtOrganID"));


		objReqOrganRS = new ResultSetHelper(objReqBox.getCmtReqOrganList2(objParams,objhashdata2));


	} catch(AppException objAppEx) {

 		objMsgBean.setMsgType(MessageBean.TYPE_ERR);

  		objMsgBean.setStrCode(objAppEx.getStrErrCode());

  		objMsgBean.setStrMsg(objAppEx.getMessage());

%>

		<jsp:forward page="/common/message/ViewMsg.jsp"/>


<%

		return;

	}

	String strRsCmt = (String)objCmtRs.getObject("ORGAN_ID");


	//�䱸�� �����ȸ�� ��� ��ȯ.

	int intTotalRecordCount=objRs.getTotalRecordCount();

	int intCurrentPageNum=objRs.getPageNumber();

	int intTotalPage=objRs.getTotalPageCount();


%>
<jsp:include page="/inc/header.jsp" flush="true"/>
<link href="/css2/style.css" rel="stylesheet" type="text/css">
<script language="javascript">


	/** ���Ĺ�� �ٲٱ� */
	function changeSortQuery(sortField,sortMethod){
  		listqry.CommReqBoxSortField.value=sortField;
  		listqry.CommReqBoxSortMtd.value=sortMethod;
		listqry.DAESUCH.value = "N";
  		listqry.submit();
  	}

  	//�䱸�Ի󼼺���� ����.
  	function gotoDetail(strID){
  		listqry.ReqBoxID.value=strID;
  		listqry.action="./RSubEndBoxVList.jsp";
  		listqry.submit();
  	}

  	/** ����¡ �ٷΰ��� */
	function goPage(strPage){
  		listqry.CommReqBoxPage.value=strPage;
		listqry.DAESUCH.value = "N";
		listqry.target = '';
  		listqry.submit();
  	}

  	/**�⵵�� ����ȸ�θ� ��ȸ�ϱ� */
  	function gotoHeadQuery(){
  		listqry.CommReqBoxQryField.value="";
  		listqry.CommReqBoxQryTerm.value="";
  		listqry.CommReqBoxSortField.value="";
  		listqry.CommReqBoxSortMtd.value="";
  		listqry.CommReqBoxPage.value="";
		listqry.DAESUCH.value = "N";
  		listqry.submit();
  	}

	// ��ȸ �ɼǿ� ���� Form submit �� ����
	function doListRefresh() {
		var f = document.listqry;
		f.DAESUCH.value = "N";
		f.target = "";
		f.submit();
	}

	function changeDaesu(){

		listqry.DAESUCH.value = "Y";

		listqry.submit();

    }
</script>
</head>

<body>
<div id="wrap">
<SCRIPT language="JavaScript" src="/js2/reqsubmit/tooltip.js"></SCRIPT>
<script language="javascript">balloonHint("balloonHint")</script>
  <jsp:include page="/inc/top.jsp" flush="true"/>
  <jsp:include page="/inc/top_menu02.jsp" flush="true"/>
  <div id="container">
    <div id="leftCon">
<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="/js/reqsubmit/reqinfo.js"></SCRIPT>
      <jsp:include page="/inc/log_info.jsp" flush="true"/>
      <jsp:include page="/inc/left_menu02.jsp" flush="true"/>
    </div>
    <div id="rightCon">
<form name="listqry" method="post" action="<%=request.getRequestURI()%>">
			<%//���� ���� �ޱ�.
				String strCommReqBoxSortField=objParams.getParamValue("CommReqBoxSortField");
				String strCommReqBoxSortMtd=objParams.getParamValue("CommReqBoxSortMtd");
			%>
			<input type="hidden" name="CommReqBoxSortField" value="<%=strCommReqBoxSortField%>"><!--�䱸�Ը�������ʵ� -->
			<input type="hidden" name="CommReqBoxSortMtd" value="<%=strCommReqBoxSortMtd%>">	<!--�䱸�Ը�����ɹ��-->
			<input type="hidden" name="CommReqBoxPage" value="<%=intCurrentPageNum%>">			<!--������ ��ȣ -->
			<input type="hidden" name="ReqBoxID" value="">		<!--�䱸�� ID -->
			<input type="hidden" name="CommOrganID" value="">	<!--����ȸ��� ID -->
			<input type="hidden" name="IngStt" value="">		<!--�䱸���� ����� -->
			<input type="hidden" name="OpenCl" value="<%=strCmtOpenCl%>">
			<input type="hidden" name="DAESUCH" value="">

      <!-- pgTit -->

      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=MenuConstants.COMM_REQ_BOX_SUBMT_END%><span class="sub_stl" >- �䱸�� ���</span></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" />  <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.REQUEST_BOX_COMM%> > <%=MenuConstants.COMM_REQ_BOX_SUBMT_END%></div>
        <p><!--����--></p>
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
					 String str = 						 objDaeRs.getObject("DAE_NUM")+"^"+objDaeRs.getObject("START_DATE")+"^"+objDaeRs.getObject("END_DATE");
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
				<option value="<%=objYearRs.getObject("AUDIT_YEAR")%>" <%if(((String)objYearRs.getObject("AUDIT_YEAR")).equals(strSelectedAuditYear)){%>selected<%}%>><%=objYearRs.getObject("AUDIT_YEAR")%>
			</option>
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
						<option value="<%=objCmtRs.getObject("ORGAN_ID")%>" <%if(((String)objCmtRs.getObject("ORGAN_ID")).equals(strSelectedCmtOrganID)){%>selected<%}%>><%=objCmtRs.getObject("ORGAN_NM")%>
						</option>
					<%
						}
					}
				%>
            </select>
            <select onChange="javascript:doListRefresh()" name="ReqOrganIDZ">
              <%
				if((strSelectedCmtOrganID.equals("") && strReqOrganID.equals("00")) || strSelectedCmtOrganID.equals("") && strReqOrganID.equals("")){

			%>
				<option value="00"><%=obOrganNm.get("ORGAN_NM")%></option>
			<%}else{%>
				<option value="00">:::: �ǿ��Ǻ� ��ȸ ::::</option>
				<%
					if(StringUtil.isAssigned(strSelectedCmtOrganID)) {
						String strSelected = "";
						if(strSelectedCmtOrganID.equalsIgnoreCase(strReqOrganID)) strSelected = " selected";
						else strSelected = "";
				%>
						<option value="<%= strSelectedCmtOrganID %>" <%= strSelected %>>:::: ����ȸ ��ü ���� ::::</option>
				<%
						if(objReqOrganRS.getTotalRecordCount() > 0) {
							while(objReqOrganRS.next()) {
								if(strReqOrganID.equalsIgnoreCase((String)objReqOrganRS.getObject("ORGAN_ID"))) {
									strSelected = " selected";
								} else {
									strSelected = "";
								}
								out.println("<option value='"+(String)objReqOrganRS.getObject("ORGAN_ID")+"' "+strSelected+">"+(String)objReqOrganRS.getObject("ORGAN_NM")+"</option>");
							}
						}
					} else {
						out.println("<option value=''>:::: ����ȸ�� ���� ������ �ּ��� ::::</option>");
					}
				%>
			<%}%>
            </select>
            <select onChange="javascript:doListRefresh()" name="RltdDuty">
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
              <th scope="col" style="width:15px;"><%=SortingUtil.getSortLink("changeSortQuery","",strCommReqBoxSortField,strCommReqBoxSortMtd,"NO")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","REQ_BOX_NM",strCommReqBoxSortField,strCommReqBoxSortMtd,"�䱸�Ը�")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","SUBMT_ORGAN_NM",strCommReqBoxSortField,strCommReqBoxSortMtd,"������")%></th>
			  <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","",strCommReqBoxSortField,strCommReqBoxSortMtd,"����/�䱸")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","LAST_REQ_DOC_SND_DT",strCommReqBoxSortField,strCommReqBoxSortMtd, "�߼��Ͻ�")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","LAST_ANS_DOC_SND_DT",strCommReqBoxSortField,strCommReqBoxSortMtd, "�����Ͻ�")%></th>
            </tr>
          </thead>
          <tbody>
  			<%
			String strRecordNumber = request.getParameter("RecordNumber");
			int intRecordNumber=0;
			if(intCurrentPageNum == 1){
				intRecordNumber= intTotalRecordCount;
			} else {
				intRecordNumber= java.lang.Integer.parseInt(strRecordNumber);
			}
			intRecordNumber = intTotalRecordCount - ((intCurrentPageNum -1) * Integer.parseInt((String)objParams.getParamValue("CommReqBoxPageSize")));
			if(objRs.getRecordSize()>0){
				String strReqBoxID="";
			  	String strCommOrganID="";

			  	while(objRs.next()){
			  		strReqBoxID=(String)objRs.getObject("REQ_BOX_ID");
			  	 	strCommOrganID=(String)objRs.getObject("CMT_ORGAN_ID");
			  	    //�亯�Ϸ�� �Ŀ� �߰��亯 �ִ��� ���� Ȯ��
					int intNotSubmitAnsCnt = sReqDelegate.getAnsCntNotSubmit((String)objRs.getObject("REQ_BOX_ID"));
			 %>
            <tr>
              <td><%= intRecordNumber %></td>
              <td><% if (intNotSubmitAnsCnt > 0)  { %>
              <img src=/image/reqsubmit/bt_add_reqsubmit.gif border=0>&nbsp;
              <% } %>
			  <a href="javascript:gotoDetail('<%=strReqBoxID%>')"><%=(String)objRs.getObject("REQ_BOX_NM")%></a></td>
              <td><%=(String)objRs.getObject("SUBMT_ORGAN_NM")%></td>
              <td><%=objRs.getObject("SUBMT_CNT")%> / <%=objRs.getObject("REQ_CNT")%></td>
              <td><%= StringUtil.getDate2((String)objRs.getObject("LAST_REQ_DOC_SND_DT"))%></td>
              <td><%=StringUtil.getDate2((String)objRs.getObject("LAST_ANS_DOC_SND_DT"))%></td>
            </tr>
			<%
				    intRecordNumber--;
				}//endofwhile
			%>
			<input type="hidden" name="RecordNumber" value="<%=intRecordNumber%>">
			<%
			}else{
			%>
			<tr>
				<td colspan="6" align="center">��ϵ� �䱸���� �����ϴ�.</td>
			</tr>
			<%
				} // end if
			%>
          </tbody>
        </table>

        <!-- /list -->
		<%=objPaging.pagingTrans(PageCount.getLinkedString(
					new Integer(intTotalRecordCount).toString(),
					new Integer(intCurrentPageNum).toString(),
					objParams.getParamValue("CommReqBoxPageSize")))%>
        <!-- ����¡-->
         <!-- /����¡-->
        <!--  <p class="warning">* �䱸���� �߼��ϰ� �Ǹ� �ش� ���� ��� ��ǥ ����ڿ��� ���� �߼۵Ǹ�, ����ڰ� ���� ���� �ۼ� �� �䱸�Կ� �״�� �����ְ� �˴ϴ�.  </p>
          <p class="warning">* �䱸�� �߼� ��ư�� �̿��Ͻñ� ���ؼ��� ����ȸ�� ������ �ֽñ� �ٶ��ϴ�.  </p>  -->



        <!-- ����Ʈ ��ư-->
        <div id="btn_all" >        <!-- ����Ʈ �� �˻� -->
        <div class="list_ser" >
		<%
			String strCommReqBoxQryField=objParams.getParamValue("CommReqBoxQryField");
		%>
          <select name="CommReqBoxQryField" class="selectBox5"  style="width:70px;" >
            <option <%=(strCommReqBoxQryField.equalsIgnoreCase("req_box_nm"))? " selected ": ""%>value="req_box_nm">�䱸�Ը�</option>
			<option <%=(strCommReqBoxQryField.equalsIgnoreCase("req_box_dsc"))? " selected ": ""%>value="req_box_dsc">�䱸�Լ���</option>
			<option <%=(strCommReqBoxQryField.equalsIgnoreCase("submt_organ_nm"))? " selected ": ""%>value="submt_organ_nm">������</option>
          </select>
          <input name="CommReqBoxQryTerm" onKeyDown="return ch()" onMouseDown="return ch()"
		 class="li_input"  style="width:100px" value="<%=objParams.getParamValue("CommReqBoxQryTerm")%>"/>
          <img src="/images2/btn/bt_list_search.gif"  onMouseOver="menuOn(this);" onMouseOut="menuOut(this);" onClick="listqry.submit();"/> </div>
        <!-- /����Ʈ �� �˻� -->

<!--		<span class="right"> <span class="list_bt"><a href="javascript:addBinder(listForm);">���δ����</a></span> </span>
-->
		</div>

        <!-- /����Ʈ ��ư-->

        <!-- /�������� ���� -->
      </div>
      <!-- /contents -->

    </div>
  </div>
<jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>