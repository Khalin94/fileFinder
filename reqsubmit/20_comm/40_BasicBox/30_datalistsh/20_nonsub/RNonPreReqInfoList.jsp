<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.bf.config.*"%>
<%@ page import="kr.co.kcc.pf.util.PageCount"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.params.requestinfo.RPreReqInfoListForm" %>
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
<%@ include file="../../../../common/RUserCodeInfoInc.jsp" %>

<%
 /*************************************************************************************************/
 /** 					�Ķ���� üũ Part 														  */
 /*************************************************************************************************/
  /**���õ� ����⵵�� ���õ� ����ȸID*/
  String strSelectedAuditYear= null; /**���õ� ����⵵*/
  String strSelectedCmtOrganID=null; /**���õ� ����ȸID*/
  String strRltdDuty=null; 			 /**���õ� �������� */
  /**�Ϲ� �䱸�� �󼼺��� �Ķ���� ����.*/
  RPreReqInfoListForm objParams =new RPreReqInfoListForm();
  objParams.setParamValue("ReqStt",CodeConstants.REQ_STT_NOT);/**������ �䱸�������.*/
   /** ����ȸ �������� �϶��� ȭ�鿡 �����.*/

  if(objUserInfo.getOrganGBNCode().equals("003")){
  objParams.setParamValue("CmtOrganID",strSelectedCmtOrganID);
  }else{
  objParams.setParamValue("CmtOrganID",objUserInfo.getOrganID());
  }
   //�ش�����ȸ�� �������� ���� ���
  if(objUserInfo.getCurrentCMTList().isEmpty()){
  	objParams.setParamValue("CmtOrganID","XXXXXXXXXX");
  }
  //objParams.setParamValue("ReqOrganID",objUserInfo.getOrganID());/**�䱸���ID*/
  //objParams.setParamValue("CmtOrganID",objUserInfo.getOrganID());
  objParams.setParamValue("ReqInfoSortField","last_req_dt");/**�����䱸���� Default*/
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

  strSelectedAuditYear= objParams.getParamValue("AuditYear"); /**���õ� ����⵵*/
  strSelectedCmtOrganID=objParams.getParamValue("CmtOrganID") ; /**���õ� ����ȸID*/
  strRltdDuty=objParams.getParamValue("RltdDuty") ; 			 /**���õ� �������� */
%>

<%
 /*************************************************************************************************/
 /** 					������ ȣ�� Part 														  */
 /*************************************************************************************************/

 /*** Delegate �� ������ Container��ü ���� */
 PreRequestBoxDelegate objReqBox=null; 		/**�䱸�� Delegate*/
 PreRequestInfoDelegate  objReqInfo=null;	/** �䱸���� Delegate */

 ResultSetHelper objRs=null;				/**�䱸 ��� */
 ResultSetHelper objCmtRs=null;			/** ������ ����ȸ */
 ResultSetHelper objRltdDutyRs=null;   /** �������� ����Ʈ ��¿� RsHelper */
 try{
   /**�䱸�� ���� �븮�� New */
   objReqBox=new PreRequestBoxDelegate();


	//�ش�����ȸ�� �������� ���� ���
	if(objUserInfo.getCurrentCMTList().isEmpty()){
		List lst = objUserInfo.getCurrentCMTList();
		Hashtable objHash = new Hashtable();
		objHash.put("ORGAN_ID", "XXXXXXXXXX");
		objHash.put("ORGAN_NM", "XXXXXXXXXX");
		lst.add(objHash);

		objCmtRs=new ResultSetHelper(objReqBox.getReqrPerYearCMTList(lst,null));
	} else {
	 	objCmtRs=new ResultSetHelper(objReqBox.getReqrPerYearCMTList(objUserInfo.getCurrentCMTList(),null));
 	} //endif

   //objCmtRs=new ResultSetHelper(objReqBox.getReqrPerYearCMTList(objUserInfo.getOrganID(),null));
   //objCmtRs=new ResultSetHelper(objReqBox.getReqrPerYearCMTList(objUserInfo.getCurrentCMTList(),null));
    /** �Ķ���ͷ� ���� ������ ���� ��� ����Ʈ���� ������.*/
    if(objCmtRs.next() && !StringUtil.isAssigned(strSelectedAuditYear) ){
    //if(objCmtRs.next() && !StringUtil.isAssigned(strSelectedAuditYear) && !StringUtil.isAssigned(strSelectedCmtOrganID)){
        strSelectedAuditYear=(String)objCmtRs.getObject("AUDIT_YEAR");
 		strSelectedCmtOrganID=(String)objCmtRs.getObject("CMT_ORGAN_ID");
	    objParams.setParamValueIfNull("AuditYear",strSelectedAuditYear);
	    objParams.setParamValueIfNull("CmtOrganID",strSelectedCmtOrganID);
    }

   /**�䱸 ���� �븮�� New */
   objReqInfo=new PreRequestInfoDelegate();
   objRs=new ResultSetHelper(objReqInfo.getRecordList(objParams));
   objRltdDutyRs=new ResultSetHelper(objCdinfo.getRelatedDutyList());
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
<!--
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
  function init(){
	var field=formName.AuditYear;
	for(var i=0;i<arrYear.length;i++){
	   var tmpOpt=new Option();
	   tmpOpt.text=arrYear[i];
	   tmpOpt.value=tmpOpt.text;
	   if(varSelectedYear==tmpOpt.text){
	     tmpOpt.selected=true;
	   }
	   field.add(tmpOpt);
	}
	makePerYearCmtList(field.options[field.selectedIndex].value);
  }//end of func
  /** ������ ����ȸ ����Ʈ �ʱ�ȭ */
  function makePerYearCmtList(strYear){
       	var field=formName.CmtOrganID;
       	field.length=0;
	for(var i=0;i<arrPerYearCmt.length;i++){
	   var strTmpYear=arrPerYearCmt[i][0];
	   if(strYear==strTmpYear){
		   var tmpOpt=new Option();
		   tmpOpt.value=arrPerYearCmt[i][1];
		   tmpOpt.text=arrPerYearCmt[i][2];
		   if(varSelectedCmt==tmpOpt.value){
		     tmpOpt.selected=true;
		   }
		   field.add(tmpOpt);
	   }
	}
  }//end of func
  /** ���� ��ȭ�� ���� ����ȸ ����Ʈ ��ȭ */
  function changeCmtList(){
    makePerYearCmtList(formName.AuditYear.options[formName.AuditYear.selectedIndex].value);
  }//end of func
  /** ���Ĺ�� �ٲٱ� */
  function changeSortQuery(sortField,sortMethod){
  	formName.ReqInfoSortField.value=sortField;
  	formName.ReqInfoSortMtd.value=sortMethod;
  	formName.submit();
  }
  //�䱸�󼼺���� ����.
  function gotoDetail(strID){
  	formName.ReqInfoID.value=strID;
  	formName.action="./RNonPreReqInfoVList.jsp";
  	formName.submit();
  }
  //�䱸�Ի󼼺���� ����.
  function gotoDetail_Box(strID){
  	formName.ReqBoxID.value=strID;

  	formName.action="/reqsubmit/20_comm/40_BasicBox/20_databoxsh/RBasicReqBoxVList.jsp?ReqBoxID=<%=objParams.getParamValue("ReqBoxID")%>&CmtOrganID=<%=objParams.getParamValue("CmtOrganID")%>";
  	formName.submit();
  }
   /** ����¡ �ٷΰ��� */
  function goPage(strPage){
  	formName.ReqInfoPage.value=strPage;
  	formName.submit();
  }
  /**�⵵�� ����ȸ�θ� ��ȸ�ϱ� */
  function gotoHeadQuery(){
  	formName.ReqInfoQryField.value="";
  	formName.ReqInfoQryTerm.value="";
  	formName.ReqInfoSortField.value="";
  	formName.ReqInfoSortMtd.value="";
  	formName.ReqInfoPage.value="";
  	formName.submit();
  }

 //-->
</script>
<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>
</head>

<body onload="init()">
<div id="wrap">
  <jsp:include page="/inc/top.jsp" flush="true"/>
  <jsp:include page="/inc/top_menu02.jsp" flush="true"/>
  <div id="container">
    <div id="leftCon">
      <jsp:include page="/inc/log_info.jsp" flush="true"/>
      <jsp:include page="/inc/left_menu02.jsp" flush="true"/>
    </div>
    <div id="rightCon">
 <form name="formName" method="post" action="<%=request.getRequestURI()%>">
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
			   <input type="hidden" name="ReqBoxID" value=""><!--�䱸������ ID-->
			  <input type="hidden" name="ReqInfoID" value=""><!--�䱸���� ID-->
			  <input type="hidden" name="ReturnUrl" value="<%=request.getRequestURI()%>"><!--�ǵ��ƿ� URL -->
      <!-- pgTit -->

      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=MenuConstants.REQ_INFO_LIST_SUBMT_NONE%></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.REQUEST_BOX_COMM%> > <%=MenuConstants.REQUEST_BOX_PRE%> > <%=MenuConstants.REQ_INFO_LIST%> > <B><%=MenuConstants.REQ_INFO_LIST_SUBMT_NONE%></div>
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
           <select name="AuditYear" onChange="changeCmtList()"></select>
			<select name="CmtOrganID" ></select>
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
              <th scope="col" style="width:15px;"></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","",strReqInfoSortField,strReqInfoSortMtd,"NO")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","REQ_CONT",strReqInfoSortField,strReqInfoSortMtd,"�䱸����")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","REQ_BOX_NM",strReqInfoSortField,strReqInfoSortMtd,"�䱸�Ը�")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","SUBMT_DLN",strReqInfoSortField,strReqInfoSortMtd,"�������")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","REG_DT",strReqInfoSortField,strReqInfoSortMtd,"�����䱸����")%></th>
            </tr>
          </thead>
          <tbody>
			<%

			  int intRecordNumber=intTotalRecordCount - ((intCurrentPageNum -1) * Integer.parseInt((String)objParams.getParamValue("ReqInfoPageSize")));

			  String strReqInfoID="";
			  String strReqBoxID="";
			  String strCmtApplyValue="Y";
			  if(objRs.getRecordSize()>0){
			  while(objRs.next()){
				 strReqInfoID=(String)objRs.getObject("REQ_ID");
				 strReqBoxID=(String)objRs.getObject("REQ_BOX_ID");


				 /** ����ȸ��û��������(Y) �ƴ��� "" ����*/
				if(CodeConstants.isDuplatedApplyToCmtReq((String)objRs.getObject("CMT_REQ_APP_FLAG"))){
					strCmtApplyValue="";
				}else{
					strCmtApplyValue="Y";
				}
			 %>
            <tr>
              <td ></td>
			  <td><%= intRecordNumber %></td>
              <td><%=StringUtil.getNotifyImg((String)objRs.getObject("REG_DT"),(String)objRs.getObject("REQ_STT"))%><a href="JavaScript:gotoDetail('<%=strReqInfoID%>');"><%=StringUtil.substring((String)objRs.getObject("REQ_CONT"),35)%></a></td>
              <td><a href="javascript:gotoDetail_Box('<%=strReqBoxID%>')"><%=StringUtil.getReqBoxNmList((String)objRs.getObject("REQ_BOX_NM")==null?"":(String)objRs.getObject("REQ_BOX_NM"))%></a></td>
              <td><%=StringUtil.getDate((String)objRs.getObject("SUBMT_DLN"))%></td>
              <td><%=StringUtil.getDate((String)objRs.getObject("REG_DT"))%></td>
			  <input type="hidden" name="CmtApplys" value="<%=strCmtApplyValue%>">
            </tr>
			<%
				   intRecordNumber --;
				}//endwhile
			}else{
			%>
			<tr>
				<td colspan="6" align="center">��ϵ� �䱸������ �����ϴ�.</td>
            </tr>
			<%
			}//end if ��� ��� ��.
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
			<option <%=(strReqInfoQryField.equalsIgnoreCase("submt_organ_nm"))? " selected ": ""%>value="submt_organ_nm">������</option>
          </select>
          <input name="ReqInfoQryTerm" onKeyDown="return ch()" onMouseDown="return ch()"
		 class="li_input"  style="width:100px" value="<%=objParams.getParamValue("ReqInfoQryTerm")%>"/>
          <img src="/images2/btn/bt_list_search.gif"  onMouseOver="menuOn(this);" onMouseOut="menuOut(this);" onClick="formName.submit();"/> </div>
        <!-- /����Ʈ �� �˻� -->
<!--
		<span class="right"> <span class="list_bt"><a href="addBinder(document.formName);">���δ����</a></span> </span>
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