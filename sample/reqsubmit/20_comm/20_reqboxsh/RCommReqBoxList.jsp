<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.pf.util.PageCount"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RCommReqBoxListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.CommRequestBoxDelegate" %>
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
	/*************************************************************************************************/
	/** 	name : RCommReqBoxList.jsp																  */
	/** 		   ����ȸ �䱸�� ����� ����Ѵ�.													  */
	/** 		   �䱸������ �ִ� �Ҽ� ����ȸ�� ����� ����Ѵ�.										  */
	/*************************************************************************************************/

  	/**���õ� ����⵵�� ���õ� ����ȸID*/
	String strSelectedAuditYear= null; /**���õ� ����⵵*/
	String strSelectedCmtOrganID=null; /**���õ� ����ȸID*/
	String strReqScheID="";			 /**����ȸ �䱸����ID*/
	String strRltdDuty=null; 			 /**���õ� �������� */

  	//�α��� ����� ������ �����´�. ���Ѿ��� ��� ������ �����ϴ�.
 	String strReqSubmitFlag = objUserInfo.getReqSubmitFlag();

 	/**����ȸ�����ȸ�� �Ķ���� ����.*/
 	RCommReqBoxListForm objParams=new RCommReqBoxListForm();
 	//�䱸��� ���� :: �Ҽ� ���.
 	objParams.setParamValue("ReqOrganID",objUserInfo.getOrganID());
 	//����ȸ �䱸����������� : ������
 	objParams.setParamValue("IngStt",CodeConstants.REQ_ING_STT_001);
 	//�䱸�� ���� : ������
 	objParams.setParamValue("ReqBoxStt",CodeConstants.REQ_BOX_STT_001);
 	/** ����ȸ �������� �϶��� ȭ�鿡 �����.*/
 	if(objUserInfo.getOrganGBNCode().equals("004")){
  		objParams.setParamValue("CmtOrganID",objUserInfo.getOrganID());
	}

 	//�ش�����ȸ�� �������.. �����޼��� ���..
 	if(objUserInfo.getCurrentCMTList().isEmpty()){
		objParams.setParamValue("CmtOrganID","XXXXXXXXXX");
 	}//endif

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

  	strSelectedAuditYear= objParams.getParamValue("AuditYear"); 	/**���õ� ����⵵*/
  	strSelectedCmtOrganID=objParams.getParamValue("CmtOrganID") ; /**���õ� ����ȸID*/
  	strRltdDuty=objParams.getParamValue("RltdDuty") ; 			 /**���õ� �������� */

 	//�䱸�� ��ü ��Delegate �����.
 	CommRequestBoxDelegate objReqBox = null;
 	ResultSetHelper objCmtRs=null;					/** ������ ����ȸ */
 	ResultSetHelper objRs=null;					/** ����ȸ �䱸�� ��� */
 	ResultSetHelper objRltdDutyRs=null;    		/** �������� ����Ʈ ��¿� RsHelper */
 	ResultSetSingleHelper objRsInfo=null;
 	ResultSetHelper objReqOrganRS = null;				/** ����ȸ�� �ǿ��� ��� */

 	String strReqOrganID = objParams.getParamValue("ReqOrganIDZ");

 	try{
 		objReqBox=new CommRequestBoxDelegate();
		//�ش�����ȸ�� �������..
		if(objUserInfo.getCurrentCMTList().isEmpty()){
			List lst = objUserInfo.getCurrentCMTList();
			Hashtable objHash = new Hashtable();
			objHash.put("ORGAN_ID", "XXXXXXXXXX");
			objHash.put("ORGAN_NM", "XXXXXXXXXX");
			lst.add(objHash);

			objCmtRs=new ResultSetHelper(objReqBox.getReqrPerYearCMTList(lst,CodeConstants.REQ_ING_STT_001,CodeConstants.REQ_BOX_STT_001));
		} else {
	 		objCmtRs=new ResultSetHelper(objReqBox.getReqrPerYearCMTList(objUserInfo.getCurrentCMTList(),CodeConstants.REQ_ING_STT_001,CodeConstants.REQ_BOX_STT_001));
 		} //endif

 		//���¿� ���� ��� List���..
   		/** �Ķ���ͷ� ���� ������ ���� ��� ����Ʈ���� ������.*/
  		 if(objCmtRs.next() && !StringUtil.isAssigned(strSelectedAuditYear) && !StringUtil.isAssigned(strSelectedCmtOrganID)){
 			strSelectedAuditYear=(String)objCmtRs.getObject("AUDIT_YEAR");
 			strSelectedCmtOrganID=(String)objCmtRs.getObject("CMT_ORGAN_ID");
	 	   objParams.setParamValueIfNull("AuditYear",strSelectedAuditYear);
		    objParams.setParamValueIfNull("CmtOrganID",strSelectedCmtOrganID);
			if(!StringUtil.isAssigned(strSelectedCmtOrganID)){
				objParams.setParamValue("CmtOrganID",objUserInfo.getOrganID());
			}
   		} else if(!StringUtil.isAssigned(strSelectedAuditYear)) {
   			strSelectedAuditYear=(String)objCmtRs.getObject("AUDIT_YEAR");
	    	objParams.setParamValueIfNull("AuditYear",strSelectedAuditYear);
   		}

   		objRltdDutyRs=new ResultSetHelper(objCdinfo.getRelatedDutyList());
   		//�䱸�� ���
   		objRs=new ResultSetHelper(objReqBox.getRecordList(objParams));
   		//����ȸ����ID
   		strReqScheID=objReqBox.getReqScheID(strSelectedAuditYear,strSelectedCmtOrganID,CodeConstants.REQ_ING_STT_001,CodeConstants.REQ_BOX_STT_001);

		/** 2005-10-13 kogaeng ADD : �ǿ��� ��� ��ȸ */
		objReqOrganRS = new ResultSetHelper(objReqBox.getCmtReqOrganList(strSelectedCmtOrganID));

 	} catch(AppException objAppEx) {
 		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  		objMsgBean.setStrCode(objAppEx.getStrErrCode());
  		objMsgBean.setStrMsg(objAppEx.getMessage());
%>
  		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
  		return;
 	}

 	String strRsCmt = (String)objCmtRs.getObject("CMT_ORGAN_ID");

	//�䱸�� �����ȸ�� ��� ��ȯ.
 	int intTotalRecordCount=objRs.getTotalRecordCount();
 	int intCurrentPageNum=objRs.getPageNumber();
 	int intTotalPage=objRs.getTotalPageCount();
%>

<jsp:include page="/inc/header.jsp" flush="true"/>
<link href="/css2/style.css" rel="stylesheet" type="text/css">
<script language="javascript" src="/js/reqsubmit/common.js"></script>
<script language="javascript">
<%
 	//�޺� �ڽ��� �ڷ� �ֱ����� Array�� ������ �־��ִ� �κ�.
    out.println("var varSelectedYear='" + strSelectedAuditYear + "';");
    out.println("var varSelectedCmt='" + strSelectedCmtOrganID + "';");
    out.println("var arrPerYearCmt=new Array(" + objCmtRs.getTotalRecordCount() + ");");
	Vector vectorYear=new Vector();
	String strTmpYear="";
	String strOldYear="";
	objCmtRs.first();
	for(int i=0;objCmtRs.next();i++){
	  	strTmpYear=(String)objCmtRs.getObject("AUDIT_YEAR");
	    out.println("arrPerYearCmt[" + i + "]=new Array('"
			+ strTmpYear	+ "','" + objCmtRs.getObject("CMT_ORGAN_ID") + "','" + objCmtRs.getObject("CMT_ORGAN_NM") + "');");
		if(!strTmpYear.equals(strOldYear)){
			vectorYear.add(strTmpYear);
		}
		strOldYear=strTmpYear;
	 }
	 out.println("var arrYear=new Array(" + vectorYear.size() + ");");
	 for(int i=0;i<vectorYear.size();i++){
	   out.println("arrYear[" + i + "]= new Array('" + (String)vectorYear.get(i)+ "');");
	 }
%>

	/** ����ȸ ���� �ʱ�ȭ */
	function init() {
		var field=listqry.AuditYear;
		for(var i=0;i<arrYear.length;i++) {
			var tmpOpt=new Option();
		   	tmpOpt.text=arrYear[i];
			tmpOpt.value=tmpOpt.text;
			if(varSelectedYear==tmpOpt.text) {
				tmpOpt.selected=true;
			}
			field.add(tmpOpt);
		}
		makePerYearCmtList(field.options[field.selectedIndex].value);
  	}

	/** ������ ����ȸ ����Ʈ �ʱ�ȭ */
	function makePerYearCmtList(strYear) {
    	var field=listqry.CmtOrganID;
       	field.length=0;
		for(var i=0;i<arrPerYearCmt.length;i++) {
			var strTmpYear=arrPerYearCmt[i][0];
			if(strYear==strTmpYear) {
				var tmpOpt=new Option();
				tmpOpt.value=arrPerYearCmt[i][1];
				tmpOpt.text=arrPerYearCmt[i][2];
				if(varSelectedCmt==tmpOpt.value){
					tmpOpt.selected=true;
				}
				field.add(tmpOpt);
			}
		}
	}

	/** ���� ��ȭ�� ���� ����ȸ ����Ʈ ��ȭ */
	function changeCmtList(){
		makePerYearCmtList(listqry.AuditYear.options[listqry.AuditYear.selectedIndex].value);
	}

	/** ���Ĺ�� �ٲٱ� */
	function changeSortQuery(sortField,sortMethod){
  		listqry.CommReqBoxSortField.value=sortField;
	  	listqry.CommReqBoxSortMtd.value=sortMethod;
	  	listqry.target = "";
  		listqry.submit();
	}

	//�䱸�Ի󼼺���� ����.
	function gotoDetail(strID){
  		//listqry.ReqBoxID.value=strID;
	  	listqry.action="./RCommReqBoxVList.jsp?ReqBoxID="+strID;
	  	listqry.target = "";
  		listqry.submit();
	}

  	/** ����¡ �ٷΰ��� */
	function goPage(strPage){
  		listqry.CommReqBoxPage.value=strPage;
  		listqry.target = "";
  		listqry.submit();
	}

	/** �䱸�� ���� �ٷΰ��� */
	function gotoMake(strReqScheID){
    	form=document.listqry;
		if(<%= strRsCmt.equals("")%>){
    		alert("����ȸ �䱸 ������ �����ϴ�. \n����ȸ �䱸������ ���� �ۼ��Ͻʽÿ�.");
	    } else {
		  	form.ReqScheID.value=strReqScheID;
	  		form.action="./RCommNewBoxMake.jsp";
	  		listqry.target = "";
		  	form.submit();
		}
	}

	/**�⵵�� ����ȸ�θ� ��ȸ�ϱ� */
	function gotoHeadQuery(){
  		listqry.CommReqBoxQryField.value="";
	  	listqry.CommReqBoxQryTerm.value="";
  		listqry.CommReqBoxSortField.value="";
	  	listqry.CommReqBoxSortMtd.value="";
  		listqry.CommReqBoxPage.value="";
  		listqry.target = "";
	  	listqry.submit();
	}

	function doDelete() {
		if(getCheckCount(document.listqry, "ReqBoxID") < 1) {
			alert("�����Ͻ� �ϳ� �̻��� �䱸���� ������ �ֽñ� �ٶ��ϴ�.");
			return;
		}
		if(confirm("�䱸���� �����Ͻø� ���Ե� �䱸 ����鵵 �ϰ� �����˴ϴ�.\n\r\n\r�����Ͻ� �䱸���� �ϰ� �����Ͻðڽ��ϱ�?")) {
			var winl = (screen.width - 300) / 2;
			var winh = (screen.height - 240) / 2;
			document.listqry.target = "popwin";
			document.listqry.action = "/reqsubmit/20_comm/20_reqboxsh/RCommReqBoxDelProc2.jsp";
			window.open('/blank.html', 'popwin', 'width=300, height=240, left='+winl+', top='+winh);
			document.listqry.submit();
		}
	}

	// ��ȸ �ɼǿ� ���� Form submit �� ����
	function doListRefresh() {
		var f = document.listqry;
		f.target = "";
		f.submit();
	}
</script>
</head>
<body>
<div id="wrap">
  <jsp:include page="/inc/top.jsp" flush="true"/>
  <jsp:include page="/inc/top_menu02.jsp" flush="true"/>
<SCRIPT language="JavaScript" src="/js2/reqsubmit/tooltip.js"></SCRIPT>
<script language="javascript">balloonHint("balloonHint")</script>
  <div id="container">
    <div id="leftCon">
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
			<input type="hidden" name="ReqScheID" value="">		<!--����ȸ ����ID -->
			<input type="hidden" name="DelURL" value="<%= request.getRequestURI() %>">
      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=MenuConstants.COMM_REQ_BOX_MAKE%><span class="sub_stl" >- �䱸�� ���</span></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.REQUEST_BOX_COMM%> > <B><%=MenuConstants.COMM_REQ_BOX_MAKE%></B></div>
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
            <select name="AuditYear" onChange="changeCmtList()" class="select_reqsubmit" onChange="javascript:doListRefresh()"></select>
            <select name="CmtOrganID" class="select_reqsubmit" onChange="javascript:doListRefresh()"></select>
            <select name="ReqOrganIDZ" class="select_reqsubmit" onChange="javascript:doListRefresh()">
                <option value="">:::: �ǿ��Ǻ� ��ȸ ::::</option>
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
            </select>
            <select name="RltdDuty"  class="select_reqsubmit" onChange="javascript:doListRefresh()">
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
        <span class="list_total">&bull;&nbsp;��ü�ڷ�� : <%=intTotalRecordCount%>�� (<%=intCurrentPageNum%> / <%=intTotalPage%> page)</span>

        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
          <thead>
            <tr>
	          	<th scope="col" width="25" height="22" align="center"><input type="checkbox" name=""></th>
        	  	<th scope="col" width="320" height="22"><%=SortingUtil.getSortLink("changeSortQuery","REQ_BOX_NM",strCommReqBoxSortField,strCommReqBoxSortMtd,"�䱸�Ը�")%></th>
              	<th scope="col" width="170" height="22"><%=SortingUtil.getSortLink("changeSortQuery","SUBMT_ORGAN_NM",strCommReqBoxSortField,strCommReqBoxSortMtd,"������")%></th>
              	<th scope="col" width="70" height="22"><%=SortingUtil.getSortLink("changeSortQuery","RLTD_DUTY",strCommReqBoxSortField,strCommReqBoxSortMtd,"��������")%></th>
              	<th scope="col" width="40" height="22"><a>����</a></th>
              	<th scope="col" width="70" height="22"><%=SortingUtil.getSortLink("changeSortQuery","ACPT_END_DT",strCommReqBoxSortField,strCommReqBoxSortMtd,"�����Ͻ�")%></th>
              	<th scope="col" width="70" height="22"><%=SortingUtil.getSortLink("changeSortQuery","REG_DT",strCommReqBoxSortField,strCommReqBoxSortMtd,"����Ͻ�")%></th>
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
			if(objRs.getRecordSize()>0){
				String strReqBoxID="";
			  	while(objRs.next()){
			  		strReqBoxID=(String)objRs.getObject("REQ_BOX_ID");
					if(!objUserInfo.getOrganGBNCode().equals("004")){
						objRsInfo = new ResultSetSingleHelper(objReqBox.getReqCount(strReqBoxID,objUserInfo.getOrganID()));
					}
			 %>
            <tr>
              	<td width="25" height="20" align="center"><input type="checkbox" name="ReqBoxID" value="<%=strReqBoxID%>"></td>
    	      	<td width="320" class="td_lmagin"><a href="javascript:gotoDetail('<%=strReqBoxID%>')"><%=(String)objRs.getObject("REQ_BOX_NM")%></a></td>
        	  	<td width="170" class="td_lmagin"><%=(String)objRs.getObject("SUBMT_ORGAN_NM")%></td>
 				<td width="70" class="td_lmagin"><%=objCdinfo.getRelatedDuty((String)objRs.getObject("RLTD_DUTY"))%></td>
          		<td width="40" class="td_lmagin">
          		<% if(!objUserInfo.getOrganGBNCode().equals("004")){%>
				<%=objRsInfo.getObject("ORGAN_REQ_CONT")%> / <%}%> <%=objRs.getObject("REQ_CNT")%></td>
          		<td width="70" class="td_lmagin" align="right" style="padding-top:2px;padding-bottom:2px"><%=StringUtil.getDate((String)objRs.getObject("ACPT_END_DT"))%> 24:00</td>
              	<td width="70" class="td_lmagin" align="right" style="padding-top:2px;padding-bottom:2px"><%=StringUtil.getDate2((String)objRs.getObject("REG_DT"))%></td>
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
				<td colspan="7" height="40" align="center">��ϵ� �䱸���� �����ϴ�.</td>
			</tr>
			<%
			} // end if
			%>
            </tbody>
       		</table>

			<!-----------------------------------------  ����¡ �׺���̼� ---------------------------------------->
            <%=objPaging.pagingTrans(PageCount.getLinkedString(
                    new Integer(intTotalRecordCount).toString(),
                    new Integer(intCurrentPageNum).toString(),
                    objParams.getParamValue("CommReqBoxPageSize")))
			%>
    <%
        if(objUserInfo.getOrganGBNCode().equals("004")) {
    %>
    <p class="warning">* �������ڴ� �䱸 ���� �������ڸ� �ǹ��ϸ�, ����ڿ� ���ؼ� '�䱸����' �۾��� ����Ǿ����� �ش� ������ �䱸������ �ݿ��˴ϴ�.</p>
    <p class="warning">* ����ȸ ��ü���� �䱸���� ������ ��쿡�� '�����Ϸ� �䱸��'�� �䱸�� �ۼ��� ���ؼ� ������ �ֽñ� �ٶ��ϴ�.</p>
    <%
        }
    %>
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
          <img src="/images2/btn/bt_list_search.gif"  onMouseOver="menuOn(this);" onMouseOut="menuOut(this);" onClick="listqry.submit()"/> </div>
        <!-- /����Ʈ �� �˻� -->
	<%
        // 2005-08-08 kogaeng EDIT �����߿䱸�Կ����� ���� '�䱸�� �ۼ�' ��ư�� �ʿ����.
        //���� ����
        if(!strReqSubmitFlag.equals("004")){
            /** ����ȸ �������� �϶��� ȭ�鿡 �����.*/
            if(objUserInfo.getOrganGBNCode().equals("004") && !strRsCmt.equals("")){
    %>
		<span class="right"><span class="list_bt"><a href="javascript:doDelete()">�䱸�� ����</a></span></span>
	<%
		} }
	 %>

		</div>

        <!-- /����Ʈ ��ư-->

        <!-- /�������� ���� -->
      </div>
        <!------------------------- �� TAB�� �ΰ� �����ø� ���� �ҽ����� �����ؼ� �� ���� �ٿ��ֱ� �ؼ� �����ϼ��� ------------------------->
        <!----- [����] TAB <tr> �� �� �ؿ� ������ �����ϴ� <tr>�� �� �����ؼ� �� ì�� �ֽþ��. ������.. -------->
</form>
    </div>
  </div>
  <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>
<script>
    init();
</script>