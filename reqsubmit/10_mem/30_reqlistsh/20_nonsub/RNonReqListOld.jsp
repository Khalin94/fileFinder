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

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

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
	objParams.setParamValue("ReqStt",CodeConstants.REQ_STT_NOT);/**������ �䱸�������.*/
	objParams.setParamValue("ReqOrganID",objUserInfo.getOrganID());/**�䱸���ID*/
	objParams.setParamValue("ReqInfoSortField","last_req_dt");/**�����䱸������ Default*/
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
	strCmtReqAppFlag=objParams.getParamValue("CmtReqAppFlag");	/** ���õ� ����ȸ �����û */

	/*************************************************************************************************/
	/** 					������ ȣ�� Part 														  */
	/*************************************************************************************************/
	
	/*** Delegate �� ������ Container��ü ���� */
	MemRequestBoxDelegate objReqBox=null; 		/**�䱸�� Delegate*/
	MemRequestInfoDelegate  objReqInfo=null;	/** �䱸���� Delegate */
	CmtSubmtReqBoxDelegate objCmtSubmt = null;
	 
	ResultSetHelper objRs=null;				/**�䱸 ��� */
	ResultSetHelper objCmtRs=null;			/** ������ ����ȸ */
	ResultSetHelper objRltdDutyRs=null;   /** �������� ����Ʈ ��¿� RsHelper */
	try{
		/**�䱸�� ���� �븮�� New */
		objReqBox=new MemRequestBoxDelegate();
		objCmtRs=new ResultSetHelper(objReqBox.getReqrPerYearCMTList(objUserInfo.getOrganID(),null));   
		objCmtSubmt = new CmtSubmtReqBoxDelegate();
		
		/** �Ķ���ͷ� ���� ������ ���� ��� ����Ʈ���� ������.*/
		//if(objCmtRs.next() && !StringUtil.isAssigned(strSelectedAuditYear) && !StringUtil.isAssigned(strSelectedCmtOrganID)){
		if(objCmtRs.next() && !StringUtil.isAssigned(strSelectedAuditYear)){
			strSelectedAuditYear=(String)objCmtRs.getObject("AUDIT_YEAR");
			//strSelectedCmtOrganID=(String)objCmtRs.getObject("CMT_ORGAN_ID");
			objParams.setParamValueIfNull("AuditYear",strSelectedAuditYear);
			objParams.setParamValueIfNull("CmtOrganID",strSelectedCmtOrganID); 		
		}
		
		/**�䱸 ���� �븮�� New */    
		objReqInfo=new MemRequestInfoDelegate();
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

	/**�䱸���� �����ȸ�� ��� ��ȯ.*/
	int intTotalRecordCount=objRs.getTotalRecordCount();
	int intCurrentPageNum=objRs.getPageNumber();
	int intTotalPage=objRs.getTotalPageCount();	
%>

<html>
<head>
<title><%=MenuConstants.getReqBoxGeneral(request)%> > <%=MenuConstants.REQ_INFO_LIST%></title>
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

	out.println("arrPerYearCmt[0]=new Array('"+strSelectedAuditYear+"','','::: ��ü ����ȸ �䱸 ��� :::');");

	objCmtRs.first();
	for(int i=0;objCmtRs.next();i++){
	//for(int i=0; i<objCmtRs.getTotalRecordCount(); i++) {
		strTmpYear=(String)objCmtRs.getObject("AUDIT_YEAR");
		/**��Ÿ����ȸ�� �޸� ǥ���ϱ� 2004.06.04*/
		String strTmpCmtOrganNm=(String)objCmtRs.getObject("CMT_ORGAN_NM");
		String strTmpCmtOrganID=(String)objCmtRs.getObject("CMT_ORGAN_ID");

		if(objUserInfo.getIsMyCmtOrganID(strTmpCmtOrganID)==false){
		   strTmpCmtOrganNm=StringUtil.getOtherCmtOrganNm(strTmpCmtOrganNm);
		}	  	
		out.println("arrPerYearCmt[" +(i+1)+ "]=new Array('" 
			+ strTmpYear	+ "','" + strTmpCmtOrganID + "','" + strTmpCmtOrganNm + "');");
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
  
  //�䱸�Ի󼼺���� ����.
  function gotoDetail(strID){
  	formName.ReqInfoID.value=strID;
  	formName.action="./RNonReqVList.jsp";
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
</script>
<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0"  onload="init()">

<SCRIPT language="JavaScript" src="/js/reqsubmit/tooltip.js"></SCRIPT>
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
<script language="javascript">balloonHint("balloonHint")</script>

<%@ include file="../../../common/MenuTopReqsubmit.jsp" %>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr align="left" valign="top">
    <td width="186" height="470" background="/image/common/bg_leftMenu.gif">
	<%@ include file="../../../common/MenuLeftReqsubmit.jsp" %></td>
<!------- 2004-06-02 ������ �������� ���� ����� �κ� ���� ------->
<td width="100%"><table width="100%" border="0" cellspacing="0" cellpadding="0">
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
              <tr> 
                <td height="23" align="left" valign="top"></td>
              </tr>
              <tr> 
                <td height="23" align="left" valign="top"><table width="100%" height="23" border="0" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="25%" background="/image/reqsubmit/bg_reqsubmit_tit.gif">
                      		<!-------------------- Ÿ��Ʋ�� �Է��� �ּ��� ------------------------>
                      		<span class="title"><%=MenuConstants.REQ_INFO_LIST_SUBMT_NONE%></span>
                      </td>
                      <td width="16%" align="left" background="/image/common/bg_titLine.gif">&nbsp;</td>
                      <td width="59%" align="right" background="/image/common/bg_titLine.gif" class="text_s">
                      		<!-------------------- ���� ��ġ ������ ����Ѵ�ϴ�. ------------------------>
                      		<img src="/image/common/icon_navi.gif" width="3" height="5" align="absmiddle"> 
                        <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.getReqBoxGeneral(request)%> > <%=MenuConstants.REQ_INFO_LIST%> > <B><%=MenuConstants.REQ_INFO_LIST_SUBMT_NONE%></B>
                      </td>
                    </tr>
                  </table></td>
              </tr>
              <tr> 
                <td height="30" align="left" class="text_s">
                		<!-------------------- ���� �������� ���� ���� ��� ------------------------>
                		������������ ������ ���� ���� �䱸 ����Դϴ�.
                </td>
              </tr>
              <tr> 
                <td height="2"></td>
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
              								<!------------------------- COUNT (PAGE) ------------------------------------>
							            	&nbsp;&nbsp;<img src="/image/common/icon_nemo_gray.gif" width="3" height="6" align="absmiddle">
							            	��ü �ڷ� �� : <%=intTotalRecordCount%>�� (<%=intCurrentPageNum%> / <%=intTotalPage%> Page)&nbsp;&nbsp;
              							</td>
              						</tr>
									<tr>
										<td height="29" colspan="2">
											<table border="0" cellpadding="0" cellspacing="0">
												<tr><td style="padding-left:25px">
													<select name="AuditYear" onChange="changeCmtList()" class="select_reqsubmit"></select>
					                				<select name="CmtOrganID" class="select_reqsubmit" onChange="this.form.submit()"></select>                						
													<select name="RltdDuty"  class="select_reqsubmit">
														<option value="">��������(��ü)</option>
													<%
													   /**�������� ����Ʈ ��� */
													   while(objRltdDutyRs!=null && objRltdDutyRs.next()){
													   		String strCode=(String)objRltdDutyRs.getObject("MSORT_CD");
													   		out.println("<option value=\"" + strCode + "\" " + StringUtil.getSelectedStr(strRltdDuty,strCode) + ">" + objRltdDutyRs.getObject("CD_NM") + "</option>");
													   }
													%>													
													</select>
													<%
														if(objUserInfo.getOrganGBNCode().equals("003")){//�ǿ��ǼҼ�
													%>
													<select name="CmtReqAppFlag"  class="select_reqsubmit">
													   <option value="">����ȸ��û(��ü)</option>
													   <option <%=(strCmtReqAppFlag.equalsIgnoreCase(CodeConstants.CMT_REQ_APP_FLAG_MEM))? " selected ": ""%>value="<%=CodeConstants.CMT_REQ_APP_FLAG_MEM%>"><%=CodeConstants.CMT_REQ_APP_FLAG_MEM_NM%></option>
													   <option <%=(strCmtReqAppFlag.equalsIgnoreCase(CodeConstants.CMT_REQ_APP_FLAG_ING))? " selected ": ""%>value="<%=CodeConstants.CMT_REQ_APP_FLAG_ING%>"><%=CodeConstants.getCmtRequestAppoint(CodeConstants.CMT_REQ_APP_FLAG_ING)%></option>
													   <option <%=(strCmtReqAppFlag.equalsIgnoreCase(CodeConstants.CMT_REQ_APP_FLAG_CMT))? " selected ": ""%>value="<%=CodeConstants.CMT_REQ_APP_FLAG_CMT%>"><%=CodeConstants.getCmtRequestAppoint(CodeConstants.CMT_REQ_APP_FLAG_CMT)%></option>
													</select>
													<%
														}//endif�ǿ��ǼҼ�Ȯ��
													%>
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
											int intTmpWidth1= 529;
											if(objUserInfo.getOrganGBNCode().equals("003")){//�ǿ��ǼҼ�
										%>
										<td  width="15" align="center"><input type="checkbox" name="checkAll" onClick="checkAllOrNot(document.formName);"></td>									
										<%
												intTmpWidth1=intTmpWidth1-20;
											}//endif�ǿ��ǼҼ�Ȯ��
										%>
										<td height="22" width="35" align="center">NO</td>
										<td width="<%=intTmpWidth1%>" align="center"><%=SortingUtil.getSortLink("changeSortQuery","REQ_CONT",strReqInfoSortField,strReqInfoSortMtd,"�䱸����")%></td>
										<td width="60" align="center"><%=SortingUtil.getSortLink("changeSortQuery","REQ_BOX_NM",strReqInfoSortField,strReqInfoSortMtd,"�䱸��")%></td>
										<td width="70" align="center"><%=SortingUtil.getSortLink("changeSortQuery","SUBMT_DLN",strReqInfoSortField,strReqInfoSortMtd,"�������")%></td>
										<td width="70" align="center"><%=SortingUtil.getSortLink("changeSortQuery","LAST_REQ_DT",strReqInfoSortField,strReqInfoSortMtd,"�䱸�Ͻ�")%></td>
									</tr>
	                    		</table>
	                    	</td>
	                    </tr>
                	    <tr> 
                    	  	<td height="1" class="td_reqsubmit"></td>
                    	</tr>
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
						<tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''">
							<td>
								<table width="759" border="0" cellspacing="0" cellpadding="0">
									<tr>
									    <%
											int intTmpWidth2 = 529;
											if(objUserInfo.getOrganGBNCode().equals("003")){//�ǿ��ǼҼ�
										%>									
										<td width="15" align="center"><input type="checkbox" name="ReqInfoIDs" value="<%=strReqInfoID%>"></td>									
										<%
												intTmpWidth2=intTmpWidth2-20;
											}
										%>										
										<td height="22" width="35" align="center"><%=intRecordNumber%></td>
										<td width="<%=intTmpWidth2%>" class="td_lmagin">&nbsp;&nbsp;<%=StringUtil.getNotifyImg((String)objRs.getObject("REG_DT"),(String)objRs.getObject("REQ_STT"))%><a href="JavaScript:gotoDetail('<%=strReqInfoID%>');" hint="<%= StringUtil.substring((String)objRs.getObject("REQ_DTL_CONT"), 100) %> ..."><%=(String)objRs.getObject("REQ_CONT")%></a></td>
										<td width="60" align="center"><a href="<%=nads.dsdm.app.reqsubmit.delegate.requestinfo.RequestInfoDelegate.getGotoMemReqBoxURLReqr((String)objRs.getObject("REQ_BOX_STT"))%>?ReqBoxID=<%=objRs.getObject("REQ_BOX_ID")%>" hint="<%= StringUtil.ReplaceString((String)objRs.getObject("REQ_BOX_NM"), "'", "") %> �䱸�� ���� �̵�"><img src="/image/reqsubmit/icon_secretariat.gif" border="0" alt="<%=objRs.getObject("REQ_BOX_NM")%> �ٷΰ���"></a></td>
										<td width="70" align="right" style="padding-top:2px;pading-bottom:2px;padding-right:2px"><%=StringUtil.getDate((String)objRs.getObject("SUBMT_DLN"))%> 24:00 </td>
										<td width="70" align="right" style="padding-top:2px;pading-bottom:2px;padding-right:2px"><%=StringUtil.getDate2((String)objRs.getObject("LAST_REQ_DT"))%> </td>
										<input type="hidden" name="CmtApplys" value="<%=strCmtApplyValue%>">
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
						<%
						/*��ȸ��� ������ ��� ����.*/
						if(objRs.getRecordSize()<1){
						%>
						<tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''">
						    <td align="center" height="35" >��ϵ� �䱸������ �����ϴ�.</td>
						</tr>
						<%
							}
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
							objParams.getParamValue("ReqInfoPageSize"))
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
									// 2005-08-30 kogaeng EDIT
									// ���� ���ǵ��� �ϳ��� �����Ѵ�.
                      			 	if(objRs.getRecordSize() > 0 && objUserInfo.getOrganGBNCode().equals("003") && objUserInfo.getIsMyCmtOrganID(strSelectedCmtOrganID) && !objCmtSubmt.checkCmtOrganMakeAutoSche(strSelectedCmtOrganID)){
								%>
									<!-- ����ȸ ���� ��û -->
                      				<img src="/image/button/bt_formalReqSelsct.gif" height="20"  style="cursor:hand" onClick="ApplyCmt(document.formName);"  alt="���õ� �䱸������ ����ȸ���Ƿ� ���������� ���������� ��û�Կ� �߰��մϴ�.">
                      			<%
                      				}
								%>
                      		</td>
							<td width="503" align="right" valign="middle">
							<%
								String strReqInfoQryField=(String)objParams.getParamValue("ReqInfoQryField");
							%>
								<select name="ReqInfoQryField" class="select">
									<option <%=(strReqInfoQryField.equalsIgnoreCase("req_cont"))? " selected ": ""%>value="req_cont">�䱸����</option>
									<option <%=(strReqInfoQryField.equalsIgnoreCase("req_dtl_cont"))? " selected ": ""%>value="req_dtl_cont">�䱸����</option>
									<option <%=(strReqInfoQryField.equalsIgnoreCase("req_box_nm"))? " selected ": ""%>value="req_box_nm">�䱸�Ը�</option>
									<option <%=(strReqInfoQryField.equalsIgnoreCase("submt_organ_nm"))? " selected ": ""%>value="submt_organ_nm">������</option>
								</select>
								<input type="text" class="textfield" name="ReqInfoQryTerm" value="<%=objParams.getParamValue("ReqInfoQryTerm")%>">
								<img src="/image/common/bt_search_table.gif" height="18" align="absmiddle" onClick="formName.submit();" style="cursor:hand">
							</td>
                    	</tr>
                  	</table>
               </td>
              </tr>
          </form>
          </table>
          </td>
        </tr>
        <tr>
        	<td height="35">&nbsp;</td>
        </tr>
    </table>
    <!--------------------------------------- �������  MAIN WORK AREA ���� �ڵ��� ���Դϴ�. ----------------------------->      
    </td>
  </tr>
</table>
<%@ include file="../../../../common/Bottom.jsp" %>
</body>
</html>              
                	