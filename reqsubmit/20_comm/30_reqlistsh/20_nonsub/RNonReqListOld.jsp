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
<%@ page import="nads.dsdm.app.reqsubmit.delegate.cmtmanager.CmtManagerConfirmDelegate" %>


<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	UserInfoDelegate objUserInfo =null;
	CDInfoDelegate objCdinfo =null;
%>

<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>

<%
 /*************************************************************************************************/
 /** 					�Ķ���� üũ Part 														  */
 /*************************************************************************************************/
  /**���õ� ����⵵�� ���õ� ����ȸID*/
  //�α��� ����� ������ �����´�. ���Ѿ��� ��� ������ �����ϴ�.
  String strReqSubmitFlag = objUserInfo.getReqSubmitFlag(); 
  
  String strSelectedAuditYear= null; /**���õ� ����⵵*/
  String strSelectedCmtOrganID=null; /**���õ� ����ȸID*/
  String strRltdDuty=null; 			 /**���õ� �������� */
  
  /**�Ϲ� �䱸�� �󼼺��� �Ķ���� ����.*/
  RCommSubReqListForm objParams =new RCommSubReqListForm();  
  objParams.setParamValue("ReqStt",CodeConstants.REQ_STT_NOT);/**����ȿ䱸�������.*/
  objParams.setParamValue("ReqOrganID",objUserInfo.getOrganID());/**�䱸���ID*/
  objParams.setParamValue("CommReqInfoSortField","last_req_dt");/**�����亯���� Default*/
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

  /** ����ȸ �������� �϶��� ȭ�鿡 �����.*/
	if(objUserInfo.getOrganGBNCode().equals("004")){
		objParams.setParamValue("CmtOrganID",objUserInfo.getOrganID());
	}

	//�ش�����ȸ�� �������.. �����޼��� ���..
	if(objUserInfo.getCurrentCMTList().isEmpty()){
		objParams.setParamValue("CmtOrganID","XXXXXXXXXX");
	}
  
  strSelectedAuditYear= objParams.getParamValue("AuditYear"); /**���õ� ����⵵*/
  strSelectedCmtOrganID=objParams.getParamValue("CmtOrganID") ; /**���õ� ����ȸID*/
  strRltdDuty=objParams.getParamValue("RltdDuty") ; 			 /**���õ� �������� */  
%>

<% 
 /*************************************************************************************************/
 /** 					������ ȣ�� Part 														  */
 /*************************************************************************************************/

 /*** Delegate �� ������ Container��ü ���� */
 CommRequestBoxDelegate objReqBox=null; 		/**�䱸�� Delegate*/
 CommRequestInfoDelegate  objReqInfo=null;	/** �䱸���� Delegate */
 CmtManagerConfirmDelegate cmtmanagerCn = new CmtManagerConfirmDelegate();
 
 ResultSetHelper objRs=null;				/**�䱸 ��� */
 ResultSetHelper objCmtRs=null;			/** ������ ����ȸ */
 ResultSetHelper objRltdDutyRs=null;   /** �������� ����Ʈ ��¿� RsHelper */
 ResultSetHelper objReqOrganRS = null;				/** ����ȸ�� �ǿ��� ��� */	
 ResultSetHelper objNoneOrgan = null;
 
 if(objUserInfo.getOrganGBNCode().equals("004") && !strReqSubmitFlag.equals("004")){
			
}else{
	if((StringUtil.getEmptyIfNull(objParams.getParamValue("ReqOrganIDZ"))).equals("")){
		String strSelfOrganID = (String)objUserInfo.getOrganID();
		objParams.setParamValue("ReqOrganIDZ",strSelfOrganID);
	}				
}

 String strReqOrganID = objParams.getParamValue("ReqOrganIDZ");
 boolean strFlag = true;
 String strCmtOpenCl = "";

 try{
   /**�䱸�� ���� �븮�� New */
   objReqBox=new CommRequestBoxDelegate();
   	//�ش�����ȸ�� �������.. 
	if(objUserInfo.getCurrentCMTList().isEmpty()){
		List lst = objUserInfo.getCurrentCMTList();
		Hashtable objHash = new Hashtable();
		objHash.put("ORGAN_ID", "XXXXXXXXXX"); 	
		objHash.put("ORGAN_NM", "XXXXXXXXXX"); 	
		lst.add(objHash);

		objCmtRs=new ResultSetHelper(objReqBox.getReqrPerYearCMTList(lst));   
	} else { 
      objCmtRs=new ResultSetHelper(objReqBox.getReqrPerYearCMTList(objUserInfo.getCurrentCMTList()));   
    }//endif

   //���¿� ���� ��� List���..
	if(objCmtRs.next() && !StringUtil.isAssigned(strSelectedAuditYear) && !StringUtil.isAssigned(strSelectedCmtOrganID)){
		strSelectedAuditYear =(String)objCmtRs.getObject("AUDIT_YEAR");
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
   /**�䱸 ���� �븮�� New */    
   objReqInfo=new CommRequestInfoDelegate();

   String strOrganIDNone = "";
   objNoneOrgan = new ResultSetHelper(cmtmanagerCn.getRelOrganIDList(strSelectedCmtOrganID,(String)objUserInfo.getOrganID()));
   for(int k = 0;objNoneOrgan.next(); k++){	    
		strOrganIDNone =(String)objNoneOrgan.getObject("ORGAN_ID");
		if(strOrganIDNone == null || strOrganIDNone.equals("")){
		
		}else{
			if(k == 0){
				strOrganIDNone = "'"+strOrganIDNone+"'";
			}else{
				strOrganIDNone = ",'"+strOrganIDNone+"'";
			}
		}
   }
   System.out.println("strOrganIDNone : "+strOrganIDNone);
   strCmtOpenCl = cmtmanagerCn.getOpenCl((String)objParams.getParamValue("CmtOrganID")) == null ? "" : cmtmanagerCn.getOpenCl((String)objParams.getParamValue("CmtOrganID"));

   int numflag = 0;
   if(objUserInfo.getOrganGBNCode().equals("004")  && !strReqSubmitFlag.equals("004")){
		strFlag = true;
		numflag = 1;
	}else{
		if(strCmtOpenCl.equals("Y")){
			strFlag = false;	
			numflag = 2;
		}else{
			strFlag = true;
			numflag = 3;
			if(strOrganIDNone.equals("")){
				strOrganIDNone = "'xxx'";
			}
		}
	}

	if(numflag == 1){
		objRs=new ResultSetHelper(objReqInfo.getRecordList(objParams));
	}else if(numflag == 2){
		objParams.setParamValue("ReqOrganIDZ",(String)objUserInfo.getOrganID());
		objParams.setParamValue("OpenCl","001");
		objRs=new ResultSetHelper(objReqInfo.getRecordList(objParams));
	}else{
		objRs=new ResultSetHelper(objReqInfo.getRecordListNone(objParams,strOrganIDNone));
	}
   
   	/** 2005-10-13 kogaeng ADD : �ǿ��� ��� ��ȸ */
	objReqOrganRS = new ResultSetHelper(objReqBox.getCmtReqOrganList(strSelectedCmtOrganID));
	
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

<html>
<head>
<title><%=MenuConstants.REQUEST_BOX_COMM%> > <%=MenuConstants.REQ_INFO_LIST%></title>
<link href="/css/System.css" rel="stylesheet" type="text/css">
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
  	formName.CommReqInfoSortField.value=sortField;
  	formName.CommReqInfoSortMtd.value=sortMethod;
  	formName.submit();
  }

  //�䱸�󼼺���� ����.
  function gotoDetail(strBoxID, strID){
  	formName.ReqBoxID.value=strBoxID;
  	formName.ReqInfoID.value=strID;
  	formName.action="./RNonReqInfo.jsp";
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

  //�䱸�Ի󼼺���� ����.
  function gotoBoxDetail(strBoxID, strURL){
  	formName.ReqBoxID.value=strBoxID;
  	formName.action=strURL;
  	formName.submit();
  }   
  	
  	// ��ȸ �ɼǿ� ���� Form submit �� ����
	function doListRefresh() {
		var f = document.formName;
		f.target = "";
		f.submit();
	}  
</script>
</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0"  onload="init()">

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
<SCRIPT language="JavaScript" src="/js/reqsubmit/tooltip.js"></SCRIPT>
<script language="javascript">balloonHint("balloonHint")</script>

<%@ include file="/reqsubmit/common/MenuTopReqsubmit.jsp" %>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr align="left" valign="top">
    <td width="186" height="470" background="/image/common/bg_leftMenu.gif">
	<%@ include file="/reqsubmit/common/MenuLeftReqsubmit.jsp" %>
	<SCRIPT language="JavaScript" src="/js/reqsubmit/reqinfo.js"></SCRIPT>
	<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>
	<SCRIPT language="JavaScript" src="/js/reqsubmit/preboxAppoint.js"></SCRIPT>
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
			  <input type="hidden" name="ReqInfoID" value=""><!--�䱸���� ID-->
			  <input type="hidden" name="OpenCl" value="<%=strCmtOpenCl%>">
			  
			  <input type="hidden" name="ReqBoxIDs" value=""><!--���� �䱸 ���� ���� ID by yan-->
			  <input type="hidden" name="ReturnUrl" value="<%=request.getRequestURI()%>"><!--�ǵ��ƿ� URL by yan-->			  
              <tr> 
                <td align="left" valign="top">
                <table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td colspan="3" height="23px">
				</tr>                 
                <tr> 
                      <td width="25%" background="/image/reqsubmit/bg_reqsubmit_tit.gif" height="23">
                      		<!-------------------- Ÿ��Ʋ�� �Է��� �ּ��� ------------------------>
                      		<span class="title"><%=MenuConstants.REQ_INFO_LIST_SUBMT_NONE%></span>
                      </td>
                      <td width="16%" align="left" background="/image/common/bg_titLine.gif">&nbsp;</td>
                      <td width="59%" align="right" background="/image/common/bg_titLine.gif" class="text_s">
                      		<!-------------------- ���� ��ġ ������ ����Ѵ�ϴ�. ------------------------>
                      		<img src="/image/common/icon_navi.gif" width="3" height="5" align="absmiddle"> 
                        <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.REQUEST_BOX_COMM%> > <%=MenuConstants.REQ_INFO_LIST%> > <B><%=MenuConstants.REQ_INFO_LIST_SUBMT_NONE%></B>
                      </td>
                    </tr>
                  </table></td>
              </tr>
              <tr> 
                <td height="30" align="left" class="text_s">
                		<!-------------------- ���� �������� ���� ���� ��� ------------------------>
                		�亯�� ������� ���� �䱸�� ����� ��ȸ�ϴ� ȭ�� �Դϴ�.
                </td>
              </tr>
              
              <!---------------------------------------------------------------------- �����ǵ� ��ȸ ���� ���� ���� ------------------------------------------------------------------------>
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
              								&nbsp;&nbsp;<img src="/image/common/icon_nemo_gray.gif" width="3" height="6" align="absmiddle">
				            	��ü �ڷ� �� : <%=intTotalRecordCount%>�� (<%=intCurrentPageNum%> / <%=intTotalPage%> Page)&nbsp;&nbsp;
              							</td>
              						</tr>
									<tr>
										<td height="29" colspan="2">
											<table border="0" cellpadding="0" cellspacing="0">
												<tr><td style="padding-left:25px">
													<select name="AuditYear" onChange="changeCmtList()" class="select_reqsubmit"  onChange="javascript:doListRefresh()"></select>
					                				<select name="CmtOrganID" class="select_reqsubmit"  onChange="javascript:doListRefresh()"></select>
													<%if(strFlag){%>
					                				<select name="ReqOrganIDZ" class="select_reqsubmit"  onChange="javascript:doListRefresh()">
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
													</select>
													<%}%>
													<select name="RltdDuty"  class="select_reqsubmit"  onChange="javascript:doListRefresh()">
														<option value="">��������(��ü)</option>
														<%
														   /**�������� ����Ʈ ��� */
														   while(objRltdDutyRs!=null && objRltdDutyRs.next()){
														   		String strCode=(String)objRltdDutyRs.getObject("MSORT_CD");
														   		out.println("<option value=\"" + strCode + "\" " + StringUtil.getSelectedStr(strRltdDuty,strCode) + ">" + objRltdDutyRs.getObject("CD_NM") + "</option>");
														   }
														%>													
													</select>
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
										<%
				                      		/** ����ȸ �������� �϶��� ȭ�鿡 �����.*/
											if(objUserInfo.getOrganGBNCode().equals("004")){
	        							%>									
										<td width="10" align="center"><input type="checkbox" name="checkAll" onClick="checkAllOrNot(document.formName);"></td>									
										<% } else { %>
										<td width="10" align="center"></td>									
										<% } %>
										<td width="34" align="center" height="22">NO</td>
										<td width="405" align="center"><%=SortingUtil.getSortLink("changeSortQuery","REQ_CONT",strCommReqInfoSortField,strCommReqInfoSortMtd,"�䱸����")%></td>
										<td width="120" align="center"><%=SortingUtil.getSortLink("changeSortQuery","OLD_REQ_ORGAN_NM",strCommReqInfoSortField,strCommReqInfoSortMtd,"�䱸���")%></td>
										<td width="50" align="center"><%=SortingUtil.getSortLink("changeSortQuery","REQ_BOX_NM",strCommReqInfoSortField,strCommReqInfoSortMtd,"�䱸��")%></td>
										<td width="70" align="center"><%=SortingUtil.getSortLink("changeSortQuery","SUBMT_DLN",strCommReqInfoSortField,strCommReqInfoSortMtd,"�������")%></td>
										<td width="70" align="center"><%=SortingUtil.getSortLink("changeSortQuery","LAST_REQ_DT",strCommReqInfoSortField,strCommReqInfoSortMtd,"�䱸�Ͻ�")%></td>
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
							     if("001".equalsIgnoreCase(strReqBoxStt)){
							     	strURL = "/reqsubmit/20_comm/20_reqboxsh/RCommReqBoxVList.jsp";
							     } else if("006".equalsIgnoreCase(strReqBoxStt)){
							     	strURL = "/reqsubmit/20_comm/20_reqboxsh/30_sendend/RSendBoxVList.jsp";							     
							     } else if("007".equalsIgnoreCase(strReqBoxStt)){
							     	strURL = "/reqsubmit/20_comm/20_reqboxsh/40_subend/RSubEndBoxVList.jsp";
							     } else {
   							     	strURL = "/reqsubmit/20_comm/20_reqboxsh/20_accend/RAccBoxVList.jsp";
							     }
						 %>								
						<tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''">
							<td>
								<table width="759" border="0" cellspacing="0" cellpadding="0">
									<tr>
									<%
			                      		/** ����ȸ �������� �϶��� ȭ�鿡 �����.*/
										if(objUserInfo.getOrganGBNCode().equals("004")){
        							%>
										<td width="10" align="center"><input type="checkbox" name="ReqInfoIDs" value="<%=strReqInfoID%>"></td>									
									<% } else { %>	
										<td width="10" align="center"></td>	
									<% } %>
										<td width="34" align="center" height="20"><%=intRecordNumber%></td>
										<td width="445" class="td_lmagin" style="padding-left:5px"><%= StringUtil.getNotifyImg((String)objRs.getObject("REG_DT"), (String)objRs.getObject("REQ_STT")) %><a href="JavaScript:gotoDetail('<%=strReqBoxID%>','<%=strReqInfoID%>');" hint="<%=StringUtil.substring((String)objRs.getObject("REQ_DTL_CONT"), 80)%>"><%=StringUtil.substring((String)objRs.getObject("REQ_CONT"),30)%></a></td>
										<td width="80">
											<%
												String strOldOrganNm = (String)objRs.getObject("OLD_REQ_ORGAN_NM");
												String strOldOrganNm4Len = strOldOrganNm.substring(0, 4);
												if("��ȸ�ǿ�".equalsIgnoreCase(strOldOrganNm4Len)) {
													out.println(strOldOrganNm.substring(5, strOldOrganNm.length()));
												} else {
													out.println(strOldOrganNm);
												}
											%>
										</td>
										<td width="50" class="td_lmagin" align="center"><a href="JavaScript:gotoBoxDetail('<%=strReqBoxID%>','<%=strURL%>');"><img src="/image/reqsubmit/icon_secretariat.gif" border="0" alt="<%= (String)objRs.getObject("REQ_BOX_NM")%> �ٷΰ���"></a></td>
										<td width="70" align="right" style="padding-top:2px;padding-bottom:2px"><%=StringUtil.getDate((String)objRs.getObject("SUBMT_DLN"))%> 24:00 </td>
										<td width="70" align="right"><%=StringUtil.getDate2((String)objRs.getObject("LAST_REQ_DT"))%> </td>
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
							<%
       					    //���� ���� 
							if(!strReqSubmitFlag.equals("004")){
                      		/** ����ȸ �������� �϶��� ȭ�鿡 �����.*/
							if(objUserInfo.getOrganGBNCode().equals("004") && (intTotalRecordCount > 0)){
        					%>
                      		<img src="/image/button/bt_appointPreReq.gif" height="20"  style="cursor:hand" onClick="preAppoint(document.formName);">
                      		<% } }	%>                      		
                      		</td>
							<td width="503" align="right" valign="middle">
							<%
								String strCommReqInfoQryField=(String)objParams.getParamValue("CommReqInfoQryField");
							%>
								<select name="CommReqInfoQryField" class="select">
									<option <%=(strCommReqInfoQryField.equalsIgnoreCase("req_cont"))? " selected ": ""%>value="req_cont">�䱸����</option>
									<option <%=(strCommReqInfoQryField.equalsIgnoreCase("req_dtl_cont"))? " selected ": ""%>value="req_dtl_cont">�䱸����</option>
									<option <%=(strCommReqInfoQryField.equalsIgnoreCase("req_box_nm"))? " selected ": ""%>value="req_box_nm">�䱸�Ը�</option>
									<option <%=(strCommReqInfoQryField.equalsIgnoreCase("submt_organ_nm"))? " selected ": ""%>value="submt_organ_nm">������</option>
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
<%@ include file="/common/Bottom.jsp" %>
</body>
</html>              
                	