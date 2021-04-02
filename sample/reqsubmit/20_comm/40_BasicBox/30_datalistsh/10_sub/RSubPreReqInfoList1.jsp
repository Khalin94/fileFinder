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
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
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
  
  //�α��� ����� ������ �����´�. ���Ѿ��� ��� ������ �����ϴ�.
  String strReqSubmitFlag = objUserInfo.getReqSubmitFlag();

  /**�Ϲ� �䱸�� �󼼺��� �Ķ���� ����.*/
  RPreReqInfoListForm objParams =new RPreReqInfoListForm();  
  objParams.setParamValue("ReqStt",CodeConstants.REQ_STT_SUBMT);/**����ȿ䱸�������.*/
   /** ����ȸ �������� �϶��� ȭ�鿡 �����.*/
   
 
   if(objUserInfo.getOrganGBNCode().equals("003")){
  objParams.setParamValueIfNull("CmtOrganID",strSelectedCmtOrganID); 		
  }else{
  objParams.setParamValue("CmtOrganID",objUserInfo.getOrganID());
  }
   //�ش�����ȸ�� �������� ���� ���
  if(objUserInfo.getCurrentCMTList().isEmpty()){
  	objParams.setParamValue("CmtOrganID","XXXXXXXXXX");
  }
 
  //objParams.setParamValue("CmtOrganID",strSelectedCmtOrganID); 		
  
  objParams.setParamValue("ReqInfoSortField","last_ans_dt");/**�����亯���� Default*/
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
   //if(objCmtRs.next() && !StringUtil.isAssigned(strSelectedAuditYear) && !StringUtil.isAssigned(strSelectedCmtOrganID)){
   if(objCmtRs.next() && !StringUtil.isAssigned(strSelectedAuditYear) ){
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

<!DOCTYPE HTML PUBLIC "-//w3c//dtd html 4.0 transitional//en">
<html>
<head>
<title><%=MenuConstants.REQUEST_BOX_PRE%> > <%=MenuConstants.REQ_INFO_LIST%></title>
<link href="/css/System.css" rel="stylesheet" type="text/css">
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
  	formName.action="./RSubPreReqInfoVList.jsp";
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

</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0"  onload="init()">

<%@ include file="../../../../common/MenuTopReqsubmit.jsp" %>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr align="left" valign="top">
    <td width="186" height="470" background="/image/common/bg_leftMenu.gif">
	<%@ include file="../../../../common/MenuLeftReqsubmit.jsp" %>
	<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>
	<SCRIPT language="JavaScript" src="/js/reqsubmit/reqinfo.js"></SCRIPT>
	</td>
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
           <tr height="23"> 
                <td height="23" align="left" valign="top"></td>
           </tr>
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
			  <input type="hidden" name="ReqBoxID" value=""><!--�䱸���� ID-->
			  <input type="hidden" name="ReturnUrl" value="<%=request.getRequestURI()%>"><!--�ǵ��ƿ� URL -->
             
              <tr> 
                <td height="23" align="left" valign="top"><table width="100%" height="23" border="0" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="14%" background="/image/reqsubmit/bg_reqsubmit_tit.gif">
                      		<!-------------------- Ÿ��Ʋ�� �Է��� �ּ��� ------------------------>
                      		<span class="title"><%=MenuConstants.REQ_INFO_LIST_SUBMT_DONE%></span>
                      </td>
                      <td width="16%" align="left" background="/image/common/bg_titLine.gif">&nbsp;</td>
                      <td width="59%" align="right" background="/image/common/bg_titLine.gif" class="text_s">
                      		<!-------------------- ���� ��ġ ������ ����Ѵ�ϴ�. ------------------------>
                      		<img src="/image/common/icon_navi.gif" width="3" height="5" align="absmiddle"> 
                        <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.REQUEST_BOX_COMM%> 
                        > <%=MenuConstants.REQUEST_BOX_PRE%> > <%=MenuConstants.REQ_INFO_LIST%> > <B><%=MenuConstants.REQ_INFO_LIST_SUBMT_DONE%></B>
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
              <tr> 
                <td height="5" align="left" class="soti_reqsubmit"></td>
              </tr>
              <tr> 
                <td height="30" class="soti_reqsubmit">
                	<!-------------------- TAB �� �ش��ϴ� ������ ����ϴ� ��������. ------------------------>
                	<table border="0" cellpadding="0" cellspacing="0" width="759">
                		<tr>
                			<td width="400">
                				<table border="0" cellspacing="0" cellpadding="0">
                					<tr>
                						<td valign="top">
			                				<img src="/image/reqsubmit/icon_reqsubmit_soti.gif" width="9" height="9" align="absmiddle">
			                				<select name="AuditYear" onChange="changeCmtList()" class="select_reqsubmit"></select>
			                				<select name="CmtOrganID" class="select_reqsubmit">
											</select>                						
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
                						</td>
                						<td valign="bottom">&nbsp;&nbsp;
			                				<img src="/image/button/bt_inquiry.gif" height="20"  style="cursor:hand" onClick="gotoHeadQuery();">                						
                						</td>
                					</tr>
                				</table>
				            </td>
				            <td width="359" align="right" valign="bottom" class="text_s">
				            	<!------------------------- COUNT (PAGE) ------------------------------------>
				            	&nbsp;&nbsp;<img src="/image/common/icon_nemo_gray.gif" width="3" height="6" align="absmiddle">
				            	��ü �ڷ� �� : <%=intTotalRecordCount%>�� (<%=intCurrentPageNum%> / <%=intTotalPage%> Page)&nbsp;&nbsp;
				            </td>
				       </tr>
				   </table>
                </td>
              </tr>
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
										<%if(objUserInfo.getOrganGBNCode().equals("004")){%>
										<td height="22" width="20" align="center"><input type="checkbox" name="checkAll" onClick="checkAllOrNot(document.formName);"></td>
										<% }else{ %>
										<td height="22" width="20" align="center">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
										<% }%>
										<td width="20" align="center">NO</td>
										
										<td width="300" align="center"><%=SortingUtil.getSortLink("changeSortQuery","REQ_CONT",strReqInfoSortField,strReqInfoSortMtd,"�䱸����")%></td>
										<td width="255" align="center"><%=SortingUtil.getSortLink("changeSortQuery","REQ_BOX_NM",strReqInfoSortField,strReqInfoSortMtd,"�䱸�Ը�")%></td>
										<td width="80" align="center">�亯</td>
										<td width="100" align="center"><%=SortingUtil.getSortLink("changeSortQuery","LAST_ANS_DT",strReqInfoSortField,strReqInfoSortMtd,"�����亯��")%></td>
									</tr>
	                    		</table>
	                    	</td>
	                    </tr>
                	    <tr> 
                    	  	<td height="1" class="td_reqsubmit"></td>
                    	</tr>
						<%
						  int intRecordNumber= intTotalRecordCount;
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
						<tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''">
							<td>
								<table width="759" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<%if(objUserInfo.getOrganGBNCode().equals("004")){%>
										<td height="22" width="20" align="center"><input type="checkbox" name="ReqInfoIDs" value="<%=strReqInfoID%>"></td>
										<% }else{ %>
										<td height="22" width="20" align="center">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
										<% }%>
										<td width="20" align="center"><%=intRecordNumber%></td>
										
										<td width="300" class="td_lmagin"><a href="JavaScript:gotoDetail('<%=strReqInfoID%>');"><%=StringUtil.substring((String)objRs.getObject("REQ_CONT"),30)%></a></td>
										<td width="255" class="td_lmagin"><a href="javascript:gotoDetail_Box('<%=strReqBoxID%>')"><%=StringUtil.getReqBoxNmList((String)objRs.getObject("REQ_BOX_NM"))%></a></td>
										<td width="80" align="center"><%=nads.lib.reqsubmit.util.DBAccessUtil.makeAnsInfoHtml((String)objRs.getObject("ANS_ID"),(String)objRs.getObject("ANS_MTD"),(String)objRs.getObject("ANS_OPIN"),(String)objRs.getObject("SUBMT_FLAG"),objUserInfo.isRequester())%></td>
										<td width="100" align="center"><%=StringUtil.getDate((String)objRs.getObject("LAST_ANS_DT"))%> </td>
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
						}else{
		  				%>
			      			<tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''">
								<td align="center" height="22">��ϵ� �䱸������ �����ϴ�.</td>
				  			</tr>
    	                     							
		  				<%
						}//end if ��� ��� ��.
		  				%>
    	                <tr class="tbl-line"> 
                      		<td height="2"></td>
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
                      			 //���� ���� 
               		 			if(!strReqSubmitFlag.equals("004")){
						 			 if(objUserInfo.getOrganGBNCode().equals("004")){
								%>
                      			
                      			<img src="/image/button/bt_putBinder.gif" height="20"  style="cursor:hand" onClick="addBinder(document.formName);" style="cursor:hand" alt="���õ� ������ ���δ� �䱸�Կ� ����Ͽ� ���ε��� �� �ֵ��� �մϴ�.">
                      			<% }// getOrganGBNCode()
                      			}//���� ����  %>
                      		</td>
							<td width="503" align="right" valign="middle">
							<%
								String strReqInfoQryField=(String)objParams.getParamValue("ReqInfoQryField");
							%>
								<select name="ReqInfoQryField">
									<option <%=(strReqInfoQryField.equalsIgnoreCase("req_cont"))? " selected ": ""%>value="req_cont">�䱸����</option>
									<option <%=(strReqInfoQryField.equalsIgnoreCase("req_dtl_cont"))? " selected ": ""%>value="req_dtl_cont">�䱸����</option>
									<option <%=(strReqInfoQryField.equalsIgnoreCase("req_box_nm"))? " selected ": ""%>value="req_box_nm">�䱸�Ը�</option>
									<option <%=(strReqInfoQryField.equalsIgnoreCase("submt_organ_nm"))? " selected ": ""%>value="submt_organ_nm">������</option>
								</select>
								<input type="text" name="ReqInfoQryTerm" value="<%=objParams.getParamValue("ReqInfoQryTerm")%>">
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
        	<td height="35">&nbsp;</td>
        </tr>
    </table>
    <!--------------------------------------- �������  MAIN WORK AREA ���� �ڵ��� ���Դϴ�. ----------------------------->      
    </td>
  </tr>
</table>
<%@ include file="../../../../../common/Bottom.jsp" %>
</body>
</html>              
