<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.pf.util.PageCount"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RCommSubReqListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.CommRequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.CommRequestInfoDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	UserInfoDelegate objUserInfo =null;
	CDInfoDelegate objCdinfo =null;
%>
<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>

<%
	//�ش�����ȸ�� �������.. �����޼��� ���..
	if(objUserInfo.getCurrentCMTList().isEmpty()){
	  	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
	  	objMsgBean.setStrCode("DSDATA-0021");
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}

	/*************************************************************************************************/
	/** 					�Ķ���� üũ Part 														  */
	/*************************************************************************************************/
	//�α��� ����� ������ �����´�. ���Ѿ��� ��� ������ �����ϴ�.
	String strReqSubmitFlag = objUserInfo.getReqSubmitFlag(); 

	/**���õ� ����⵵�� ���õ� ����ȸID*/
	String strSelectedAuditYear= null; /**���õ� ����⵵*/
	String strSelectedCmtOrganID=null; /**���õ� ����ȸID*/

	/**�Ϲ� �䱸�� �󼼺��� �Ķ���� ����.*/
	RCommSubReqListForm objParams =new RCommSubReqListForm();  
	objParams.setParamValue("ReqStt",CodeConstants.REQ_STT_SUBMT);/**����ȿ䱸�������.*/
	objParams.setParamValue("SmtOrganID",objUserInfo.getOrganID());/**�䱸���ID*/
	objParams.setParamValue("CommReqInfoSortField","last_ans_dt");/**�����亯���� Default*/
	objParams.setParamValue("IsRequester",String.valueOf(objUserInfo.isRequester()));//�䱸�亯�ڿ��μ���
	
	boolean blnParamCheck = false;
	/**���޵� �ĸ����� üũ */
	blnParamCheck = objParams.validateParams(request);
	if(blnParamCheck == false) {
	  	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
	  	objMsgBean.setStrCode("DSPARAM-0000");
	  	objMsgBean.setStrMsg(objParams.getStrErrors());
	  	//out.println("ParamError:" + objParams.getStrErrors());
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}
  
	strSelectedAuditYear= objParams.getParamValue("AuditYear"); /**���õ� ����⵵*/
	strSelectedCmtOrganID=objParams.getParamValue("CmtOrganID") ; /**���õ� ����ȸID*/

	/*************************************************************************************************/
	/** 					������ ȣ�� Part 														  */
	/*************************************************************************************************/

	/*** Delegate �� ������ Container��ü ���� */
	CommRequestBoxDelegate objReqBox = null; 		/**�䱸�� Delegate*/
	CommRequestInfoDelegate  objReqInfo = null;	/** �䱸���� Delegate */
 
	ResultSetHelper objRs=null;				/**�䱸 ��� */
	ResultSetHelper objCmtRs=null;			/** ������ ����ȸ */
	
	try{
		/**�䱸�� ���� �븮�� New */
		objReqBox=new CommRequestBoxDelegate();
		objCmtRs=new ResultSetHelper(objReqBox.getReqrPerYearCMTList(objUserInfo.getCurrentCMTList()));   
		/** �Ķ���ͷ� ���� ������ ���� ��� ����Ʈ���� ������.*/
		if(objCmtRs.next() && !StringUtil.isAssigned(strSelectedAuditYear) && !StringUtil.isAssigned(strSelectedCmtOrganID)){
	 		strSelectedAuditYear=(String)objCmtRs.getObject("AUDIT_YEAR");
	 		//strSelectedCmtOrganID=(String)objCmtRs.getObject("CMT_ORGAN_ID");
		    objParams.setParamValueIfNull("AuditYear",strSelectedAuditYear);
		    //objParams.setParamValueIfNull("CmtOrganID",strSelectedCmtOrganID); 		
		}

		/**�䱸 ���� �븮�� New */    
		objReqInfo = new CommRequestInfoDelegate();
		objRs = new ResultSetHelper(objReqInfo.getRecordList(objParams));
		
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

	/**�䱸���� �����ȸ�� ��� ��ȯ.*/
	int intTotalRecordCount = objRs.getTotalRecordCount();
	int intCurrentPageNum = objRs.getPageNumber();
	int intTotalPage = objRs.getTotalPageCount();	
%>

<html>
<head>
<title><%=MenuConstants.REQUEST_BOX_GENERAL%> > <%=MenuConstants.REQ_INFO_LIST%></title>
<link href="/css/System.css" rel="stylesheet" type="text/css">
<script language="javascript">
 <%
 	//�޺� �ڽ��� �ڷ� �ֱ����� Array�� ������ �־��ִ� �κ�.
    out.println("var varSelectedYear='" + strSelectedAuditYear + "';");
    out.println("var varSelectedCmt='" + strSelectedCmtOrganID + "';");
	out.println("var arrPerYearCmt=new Array(" + (objCmtRs.getTotalRecordCount()+1) + ");");
	Vector vectorYear=new Vector();
	String strTmpYear="";
	String strOldYear="";
	objCmtRs.first();
	out.println("arrPerYearCmt[0] = new Array('" 
			+ strSelectedAuditYear + "','',':::::::::::: ��ü ����ȸ �䱸 ��� ::::::::::::');");
	for(int i=1;objCmtRs.next();i++){
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
  }
  
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
  }
  
  /** ���� ��ȭ�� ���� ����ȸ ����Ʈ ��ȭ */
  function changeCmtList(){
    makePerYearCmtList(formName.AuditYear.options[formName.AuditYear.selectedIndex].value);
  }
  
  /** ���Ĺ�� �ٲٱ� */
  function changeSortQuery(sortField,sortMethod){
  	formName.CommReqInfoSortField.value=sortField;
  	formName.CommReqInfoSortMtd.value=sortMethod;
  	formName.submit();
  }
  
  //�䱸�󼼺���� ����.
  function gotoDetail(strBoxID, strID){
  	formName.ReqBoxID.value=strBoxID;
  	formName.ReqID.value=strID;
  	formName.action="./SCommSubReqInfo.jsp";
  	formName.submit();
  }
  
  /** ����¡ �ٷΰ��� */
  function goPage(strPage){
  	formName.CommReqInfoPage.value=strPage;
  	formName.submit();
  } 
  
  /**�⵵�� ����ȸ�θ� ��ȸ�ϱ� */
  function gotoHeadQuery(){
  	formName.CommReqInfoQryField.value="";
  	formName.CommReqInfoQryTerm.value="";
  	formName.CommReqInfoSortField.value="";
  	formName.CommReqInfoSortMtd.value="";
  	formName.CommReqInfoPage.value="";
  	formName.submit();
  }  
  
  /** �䱸�� �� ����� �̵� */
  function gotoReqBoxInfoView(strReqBoxStt, strReqBoxID) {
	formName.ReqBoxID.value = strReqBoxID;
  	if (strReqBoxStt == "<%= CodeConstants.REQ_BOX_STT_006 %>") { // �߼ۿϷ�
  		formName.action= "/reqsubmit/20_comm/20_reqboxsh/SCommReqBoxVList.jsp?ReqBoxID";
  	} else if (strReqBoxStt == "<%= CodeConstants.REQ_BOX_STT_007 %>") { // ����Ϸ�
  		formName.action= "/reqsubmit/20_comm/20_reqboxsh/40_subend/SSubEndBoxVList.jsp";
  	}
  	formName.submit();
  }      
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0"  onload="init()">
<%@ include file="/reqsubmit/common/MenuTopReqsubmit.jsp" %>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr align="left" valign="top">
    <td width="186" height="470" background="/image/common/bg_leftMenu.gif">
	<%@ include file="/reqsubmit/common/MenuLeftReqsubmit.jsp" %>
	<SCRIPT language="JavaScript" src="/js/reqsubmit/reqinfo.js"></SCRIPT>
	<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>
	</td>
<!------- 2004-06-02 ������ �������� ���� ����� �κ� ���� ------->
	<td width="100%">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr height="24" valign="top"> 
    	<td height="24" colspan="2" align="left"><table width="789" height="24" border="0" cellpadding="0" cellspacing="0" bgcolor="DEEFCC">
    <tr>
    	<td height="24"></td>
	</tr>
    </table></td>
    </tr>
<!------- 2004-06-02 ������ �������� ���� ����� �κ� �� ------->
        <tr valign="top"> 
          <td width="30" align="left"><img src="/image/common/bg_leftBody.gif" width="30" height="1"></td>
          <td align="left">
          <table width="759" border="0" cellspacing="0" cellpadding="0">
          <form name="formName" method="post" action="<%=request.getRequestURI()%>">
          <%
			//�䱸 ���� ���� ���� �ޱ�.
			String strCommReqInfoSortField=objParams.getParamValue("CommReqInfoSortField");
			String strCommReqInfoSortMtd=objParams.getParamValue("CommReqInfoSortMtd");
			//�䱸 ���� ������ ��ȣ �ޱ�.
			String strCommReqInfoPagNum=objParams.getParamValue("CommReqInfoPage");
		  %>
			  <input type="hidden" name="CommReqInfoSortField" value="<%=strCommReqInfoSortField%>"><!--�䱸���� ��������ʵ� -->
			  <input type="hidden" name="CommReqInfoSortMtd" value="<%=strCommReqInfoSortMtd%>"><!--�䱸���� ������ɹ��-->
			  <input type="hidden" name="CommReqInfoPage" value="<%=strCommReqInfoPagNum%>"><!--�䱸���� ������ ��ȣ -->
			  <input type="hidden" name="ReqBoxID" value=""><!--�䱸���� ID-->
			  <input type="hidden" name="ReqID" value=""><!--�䱸���� ID-->
              <tr> 
                <td align="left" valign="top">
                <table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td colspan="3" height="23px">
				</tr>
                <tr> 
                      <td width="25%" background="/image/reqsubmit/bg_reqsubmit_tit.gif" height="23">
                      		<!-------------------- Ÿ��Ʋ�� �Է��� �ּ��� ------------------------>
                      		<span class="title"><%=MenuConstants.REQ_INFO_LIST_SUBMT_DONE%></span>
                      </td>
                      <td width="16%" align="left" background="/image/common/bg_titLine.gif">&nbsp;</td>
                      <td width="59%" align="right" background="/image/common/bg_titLine.gif" class="text_s">
                      		<!-------------------- ���� ��ġ ������ ����Ѵ�ϴ�. ------------------------>
                      		<img src="/image/common/icon_navi.gif" width="3" height="5" align="absmiddle"> 
                        <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%= MenuConstants.REQUEST_BOX_COMM %> > <%=MenuConstants.REQ_INFO_LIST%> > <B><%=MenuConstants.REQ_INFO_LIST_SUBMT_DONE%></B>
                      </td>
                    </tr>
                  </table></td>
              </tr>
              <tr> 
                <td height="30" align="left" class="text_s">
                		<!-------------------- ���� �������� ���� ���� ��� ------------------------>
                		���������� ��� ������ �Ϸ��� �䱸 ����Դϴ�.
                </td>
              </tr>
              
              <!---------------------------------------------------------------------- �����ǵ� ��ȸ ���� ���� ���� ------------------------------------------------------------------------>
              <tr> 
                <td height="2"></td>
              </tr>
              <tr>
              	<td width="759">
              		<table border="0" cellpadding="0" cellspacing="0">
              			<tr>
              				<td width="6" height="53"><img src="/image/reqsubmit/searchTableLeft.jpg" border="0"></td>
              				<td width="746" height="53" background="/image/reqsubmit/searchTableBg.jpg">
              					<table border="0" cellpadding="0" cellspacing="0" width="746">
              						<tr>
              							<td width="200" height="24"><img src="/image/reqsubmit/searchTableTop.jpg" border="0"></td>
              							<td width="546" align="right" valign="bottom">
              								<!------------------------- COUNT (PAGE) ------------------------------------>
							            	&nbsp;&nbsp;<img src="/image/common/icon_nemo_gray.gif" width="3" height="6" align="absmiddle">
							            	��ü �ڷ� �� : <%=intTotalRecordCount%>�� (<%=intCurrentPageNum%> / <%=intTotalPage%> Page)&nbsp;&nbsp;
              							</td>
              						</tr>
									<tr>
										<td height="29" colspan="2">
											<table border="0" cellpadding="0" cellspacing="0">
												<tr><td style="padding-left:25px">
													<select name="AuditYear" onChange="changeCmtList()" class="select_reqsubmit"></select> �⵵ 
					                				<select name="CmtOrganID" class="select_reqsubmit" onChange="this.form.submit()"></select> �䱸 ��� 
												</td>
												<td>&nbsp;&nbsp;<img src="/image/button/bt_inquiry.gif" height="20"  style="cursor:hand" onClick="gotoHeadQuery();"></td>
												</tr>
											</table>
										</td>
									</tr>
              					</table>
              				</td>
              				<td width="7" height="53"><img src="/image/reqsubmit/searchTableRight.jpg" border="0"></td>
              			</tr>
              		</table>
              	</td>
              </tr>
              <tr> 
                <td height="5"></td>
              </tr>
              <!---------------------------------------------------------------------- �����ǵ� ��ȸ ���� ���� �� ------------------------------------------------------------------------>

              <tr> 
                <td align="left" valign="top" class="soti_reqsubmit">
                <!------------------------- TAB�� �ش��ϴ� ���̺�(����̵� ������̵� ��������) ��� ��~~~�� ------------------------->
					<table width="759" border="0" cellspacing="0" cellpadding="0">
                    	<tr> 
                      		<td height="2" class="td_reqsubmit"></td>
	                    </tr>
	                    <tr align="center" class="td_top">
	                    	<td>
	                    		<table width="759" border="0" cellspacing="0" cellpadding="0">
									<tr class="td_top">
										<td height="22" width="10" align="center"><input type="checkbox" name="checkAll" onClick="checkAllOrNot(document.formName);"></td>										
										<td width="39" align="center">NO</td>
										<td width="310" align="center"><%=SortingUtil.getSortLink("changeSortQuery","REQ_CONT",strCommReqInfoSortField,strCommReqInfoSortMtd,"�䱸����")%></td>
										<td width="120" align="center"><%=SortingUtil.getSortLink("changeSortQuery","REQ_ORGAN_NM",strCommReqInfoSortField,strCommReqInfoSortMtd,"�䱸���")%></td>
										<td width="60" align="center"><%=SortingUtil.getSortLink("changeSortQuery","REQ_BOX_NM",strCommReqInfoSortField,strCommReqInfoSortMtd,"�䱸��")%></td>
										<td width="40" align="center">�亯</td>
										<td width="40" align="center">÷��</td>
										<td width="70" align="center"><%=SortingUtil.getSortLink("changeSortQuery","LAST_REQ_DT",strCommReqInfoSortField,strCommReqInfoSortMtd,"�䱸�Ͻ�")%></td>
										<td width="70" align="center"><%=SortingUtil.getSortLink("changeSortQuery","LAST_ANS_DT",strCommReqInfoSortField,strCommReqInfoSortMtd,"�亯�Ͻ�")%></td>
									</tr>
	                    		</table>
	                    	</td>
	                    </tr>
                	    <tr> 
                    	  	<td height="1" class="td_reqsubmit"></td>
                    	</tr>
						<%
						  String strRecordNumber = request.getParameter("RecordNumber");
  						  int intRecordNumber=0;
						  if(intCurrentPageNum == 1){
							  intRecordNumber= intTotalRecordCount;
						  } else {
						  	  intRecordNumber= java.lang.Integer.parseInt(strRecordNumber);
						  }
						  if(objRs.getRecordSize()>0){
							  String strReqInfoID="";
							  String strReqBoxID="";
							  String strReqBoxStt="";
							  String strURL="";							  
							  while(objRs.next()){
							   	 strReqBoxID=(String)objRs.getObject("REQ_BOX_ID");
							   	 strReqInfoID=(String)objRs.getObject("REQ_ID");
							     strReqBoxStt = (String)objRs.getObject("REQ_BOX_STT");		
						 %>								
						<tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''">
							<td>
								<table width="759" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td height="20" width="10" align="center"><input type="checkbox" name="ReqInfoIDs" value="<%=strReqInfoID%>"></td>									
										<td width="39" align="center"><%=intRecordNumber%></td>
										<td width="310" class="td_lmagin"><a href="JavaScript:gotoDetail('<%=strReqBoxID%>','<%=strReqInfoID%>');"><%=StringUtil.substring((String)objRs.getObject("REQ_CONT"),30)%></a></td>
										<td width="120" class="td_lmagin"><%=objRs.getObject("REQ_ORGAN_NM")%></td>										
										<td width="60" class="td_lmagin" align="center"><a href="JavaScript:gotoReqBoxInfoView('<%=strReqBoxStt%>','<%=strReqBoxID%>');"><img src="/image/reqsubmit/icon_secretariat.gif" border="0" alt="<%=objRs.getObject("REQ_BOX_NM")%> �ٷΰ���"></a></td>
										<td width="40" align="center"><%=nads.lib.reqsubmit.util.DBAccessUtil.makeAnsInfoHtml((String)objRs.getObject("ANS_ID"),(String)objRs.getObject("ANS_MTD"),(String)objRs.getObject("ANS_OPIN"),(String)objRs.getObject("SUBMT_FLAG"),objUserInfo.isRequester())%></td>
										<td width="40" align="center"><%=makeAttachedFileLink((String)objRs.getObject("ANS_ESTYLE_FILE_PATH"))%></td>
										<td width="70" align="right"><%=StringUtil.getDate2((String)objRs.getObject("LAST_REQ_DT"))%> </td>
										<td width="70" align="right" style="padding-top:2px;padding-bottom:2px"><%=StringUtil.getDate2((String)objRs.getObject("LAST_ANS_DT"))%> </td>
									</tr>
								</table>
							</td>
						</tr>
    	                <tr class="tbl-line"> 
                      		<td height="1"></td>
                    	</tr>       	
						<%
							    intRecordNumber --;
							}//endwhile
						%>
						<input type="hidden" name="RecordNumber" value="<%=intRecordNumber%>">
						<%
						}else{
						%>
						<tr>
							<td>
							<table width="759" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td height="40" align="center">��ϵ� �䱸������ �����ϴ�.</td>
							</tr>
							<tr class="tbl-line"> 
                      			<td height="1"></td>
                    		</tr>   
							</table>
							</td>
						</td>
						<%
							} // end if
						%>
    	                <tr class="tbl-line"> 
                      		<td height="1"></td>
                    	</tr>       													
	                </table>
				<!------------------------- TAB�� �ش��ϴ� ���̺�(����̵� ������̵� ��������) ��� �� ------------------------->
               </td>
              </tr>
              <tr> 
                <td height="35" align="center">
                	<!-----------------------------------------  ����¡ �׺���̼� ---------------------------------------->
                	<%= PageCount.getLinkedString(
							new Integer(intTotalRecordCount).toString(),
							new Integer(intCurrentPageNum).toString(),
							objParams.getParamValue("CommReqInfoPageSize"))
					%>
                </td>
              </tr>
              <tr height="3">
              	<td height="3" align="left" valign="top" background="/image/common/line_table.gif"></td>
              </tr>              
              <!------------------ �˻�(��ȸ) �� <tr></tr> --------------------------->
              <tr> 
                <td height="40" align="left" valign="top">
                	<table width="100%" border="0" cellspacing="0" cellpadding="0">
                    	<tr> 
                      		<td width="256" height="40">
                   			<!-- ��ư�� �ʿ��ϴٸ� ���⿡ �߰��Ͻ� �˴ϴٿ� -->
				            <%//���� ���� 
							if(!strReqSubmitFlag.equals("004")){
								 if (intTotalRecordCount > 0){ %>
                   				<img src="/image/button/bt_putBinder.gif" height="20"  style="cursor:hand" onClick="addBinder(document.formName);">
                   			<%	} } %>
                      		</td>
							<td width="503" align="right" valign="middle">
							<%
								String strCommReqInfoQryField=(String)objParams.getParamValue("CommReqInfoQryField");
							%>
								<select name="CommReqInfoQryField" class="select">
									<option <%=(strCommReqInfoQryField.equalsIgnoreCase("req_cont"))? " selected ": ""%>value="req_cont">�䱸����</option>
									<option <%=(strCommReqInfoQryField.equalsIgnoreCase("req_dtl_cont"))? " selected ": ""%>value="req_dtl_cont">�䱸����</option>
									<option <%=(strCommReqInfoQryField.equalsIgnoreCase("req_box_nm"))? " selected ": ""%>value="req_box_nm">�䱸�Ը�</option>
								</select>
								<input type="text" name="CommReqInfoQryTerm" value="<%=objParams.getParamValue("CommReqInfoQryTerm")%>">
								<img src="/image/common/bt_search_table.gif" height="18" align="absmiddle" onClick="formName.submit();" style="cursor:hand">
							</td>
                    	</tr>
                  	</table>
               </td>
              </tr>              
            </table>
          </form>
          </table>
          </td>
        </tr>
        <tr>
        	<td height="35px"></td>
        </tr>        
    </table>
    <!--------------------------------------- �������  MAIN WORK AREA ���� �ڵ��� ���Դϴ�. ----------------------------->      
    </td>
  </tr>
</table>

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

<%@ include file="/common/Bottom.jsp" %>
</body>
</html>              
                	