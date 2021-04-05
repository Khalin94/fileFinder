<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.bf.config.*"%>
<%@ page import="kr.co.kcc.pf.util.PageCount"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.params.cmtsubmt.CmtSubmtReqBoxListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
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
	
	/**�䱸�� �����ȸ�� �Ķ���� ����.*/
	CmtSubmtReqBoxListForm objParams=new CmtSubmtReqBoxListForm();
	/**�䱸��� ���� :: �Ҽ� ���.*/
	objParams.setParamValue("ReqOrganID",objUserInfo.getOrganID());
	/**�䱸�� ����: �ۼ��� �䱸��.*/
	objParams.setParamValue("ReqBoxStt",CodeConstants.REQ_BOX_STT_003);
	
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
%>

<% 
	/*************************************************************************************************/
	/** 					������ ȣ�� Part 														  */
	/*************************************************************************************************/
	
	/*** Delegate �� ������ Container��ü ���� */
	CmtSubmtReqBoxDelegate objReqBox=null; 		/**�䱸�� Delegate*/
	 
	ResultSetHelper objRs=null;				/**�䱸�� ��� */
	ResultSetHelper objCmtRs=null;			/** ������ ����ȸ */
	ResultSetHelper objRltdDutyRs=null;   /** �������� ����Ʈ ��¿� RsHelper */
	
	try{
		/**�䱸�� ���� �븮�� New */
		objReqBox=new CmtSubmtReqBoxDelegate();
		objCmtRs=new ResultSetHelper(objReqBox.getReqrPerYearCMTList(objUserInfo.getOrganID()));  
		//objCmtRs = new ResultSetHelper(objUserInfo.getCurrentCMTList());
		/** �Ķ���ͷ� ���� ������ ���� ��� ����Ʈ���� ������.*/
		if(objCmtRs.next() && !StringUtil.isAssigned(strSelectedAuditYear) && !StringUtil.isAssigned(strSelectedCmtOrganID)){
			strSelectedAuditYear = (String)objCmtRs.getObject("AUDIT_YEAR");
			strSelectedCmtOrganID=(String)objCmtRs.getObject("CMT_ORGAN_ID");
			objParams.setParamValueIfNull("AuditYear",strSelectedAuditYear);
			objParams.setParamValueIfNull("CmtOrganID",strSelectedCmtOrganID); 		
		}
		objRs=new ResultSetHelper(objReqBox.getRecordList(objParams));
		objRltdDutyRs=new ResultSetHelper(objCdinfo.getRelatedDutyList());
	} catch(AppException objAppEx) {
	 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
	  	objMsgBean.setStrCode(objAppEx.getStrErrCode());
	  	objMsgBean.setStrMsg(objAppEx.getMessage());
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
<title><%=MenuConstants.getReqBoxGeneral(request)%> > <%=MenuConstants.REQ_BOK_COMM_REQ%></title>
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
  	formName.ReqBoxSortField.value=sortField;
  	formName.ReqBoxSortMtd.value=sortMethod;
	formName.target = "";
  	formName.submit();
  }

  //�䱸�Ի󼼺���� ����.
  function gotoDetail(strID){
  	formName.ReqBoxID.value=strID;
  	formName.action="./RCommReqVList.jsp?AuditYear=<%= strSelectedAuditYear %>";
	formName.target = "";
  	formName.submit();
  }

  /** ����¡ �ٷΰ��� */
  function goPage(strPage){
  	formName.ReqBoxPage.value=strPage;
	formName.target = "";
  	formName.submit();
  }

  /**�⵵�� ����ȸ�θ� ��ȸ�ϱ� */
  function gotoHeadQuery(){
  	formName.ReqBoxQryField.value="";
  	formName.ReqBoxQryTerm.value="";
  	formName.ReqBoxSortField.value="";
  	formName.ReqBoxSortMtd.value="";
  	formName.ReqBoxPage.value="";
	formName.target = "";
  	formName.submit();
  }

	/**
	 * 2005-09-14 kogaeng ADD
   	 */
	function NewCmtReqWrite() {
		var w = 800;
		var h = 700;
		var winl = (screen.width - w) / 2;
		var winh = (screen.height - h) / 2;
		formName.action =  "/reqsubmit/common/CommSubmtReqWriteAllInOne.jsp";
		formName.CmtOrganIDX.value = formName.CmtOrganID.value;
		formName.target = "AllInOne";
		window.open('/blank.html', 'AllInOne', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=no,width='+w+',height='+h+',left='+winl+',top='+winh);
		formName.submit();
	}

	function changeSelectValue() {
		formName.target = "";
		formName.submit();
	}
</script>
</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0"  onload="init()">
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
<form name="formName" method="<%=nads.lib.reqsubmit.EnvConstants.FORM_METHOD%>" action="<%=request.getRequestURI()%>">
		  <%//���� ���� �ޱ�.
			String strReqBoxSortField=objParams.getParamValue("ReqBoxSortField");
			String strReqBoxSortMtd=objParams.getParamValue("ReqBoxSortMtd");
		  %>
			<input type="hidden" name="ReqBoxSortField" value="<%=strReqBoxSortField%>"><!--�䱸�Ը�������ʵ� -->
			<input type="hidden" name="ReqBoxSortMtd" value="<%=strReqBoxSortMtd%>"><!--�䱸�Ը�����ɹ��-->
			<input type="hidden" name="ReqBoxPage" value="<%=intCurrentPageNum%>"><!--������ ��ȣ -->
			<input type="hidden" name="ReqBoxID" value=""><!--�䱸�Թ�ȣ �Ϲ������δ� ���ȵ�-->
			<input type="hidden" name="CmtOrganIDX" value="">
              <tr> 
                <td height="23" align="left" valign="top"></td>
              </tr>
              <tr> 
                <td height="23" align="left" valign="top"><table width="100%" height="23" border="0" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="25%" background="/image/reqsubmit/bg_reqsubmit_tit.gif">
                      		<!-------------------- Ÿ��Ʋ�� �Է��� �ּ��� ------------------------>
                      		<span class="title"><%=MenuConstants.REQ_BOK_COMM_REQ%></span>
                      </td>
                      <td width="16%" align="left" background="/image/common/bg_titLine.gif">&nbsp;</td>
                      <td width="59%" align="right" background="/image/common/bg_titLine.gif" class="text_s">
                      		<!-------------------- ���� ��ġ ������ ����Ѵ�ϴ�. ------------------------>
                      		<img src="/image/common/icon_navi.gif" width="3" height="5" align="absmiddle"> 
                        <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.getReqBoxGeneral(request)%> > <B><%=MenuConstants.REQ_BOK_COMM_REQ%></B>
                      </td>
                    </tr>
                  </table></td>
              </tr>
              <tr> 
                <td height="30" align="left" class="text_s">
                		<!-------------------- ���� �������� ���� ���� ��� ------------------------>
                		����ȸ�� �����û�� �䱸����� ���� ��û�� ����� ��ȸ�մϴ�.
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
			                				<select name="CmtOrganID" class="select_reqsubmit" onChange="javascript:changeSelectValue()"></select>                						
											<select name="RltdDuty"  class="select_reqsubmit" onChange="javascript:changeSelectValue()">
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
				            <td width="359" align="right" valign="bottom"  class="text_s">
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
										<td height="22" width="34" align="center">NO</td>
										<td width="415" align="center"><%=SortingUtil.getSortLink("changeSortQuery","CMT_SUBMT_REQ_BOX_NM",strReqBoxSortField,strReqBoxSortMtd,"��û�Ը�")%></td>
										<td width="80" align="center"><%=SortingUtil.getSortLink("changeSortQuery","CNT",strReqBoxSortField,strReqBoxSortMtd,"��ûȽ��")%></td>
										<td width="80" align="center"><%=SortingUtil.getSortLink("changeSortQuery","RLTD_DUTY",strReqBoxSortField,strReqBoxSortMtd,"��������")%></td>
										<td width="70" align="center"><%=SortingUtil.getSortLink("changeSortQuery","STT",strReqBoxSortField,strReqBoxSortMtd,"�������")%></td>
										<td width="80" align="center"><%=SortingUtil.getSortLink("changeSortQuery","CMT_SUBMT_REQ_DT",strReqBoxSortField,strReqBoxSortMtd,"����Ͻ�")%></td>
									</tr>
	                    		</table>
	                    	</td>
	                    </tr>
                	    <tr> 
                    	  	<td height="1" class="td_reqsubmit"></td>
                    	</tr>
						<%
						  int intRecordNumber=intTotalRecordCount - ((intCurrentPageNum -1) * Integer.parseInt((String)objParams.getParamValue("ReqBoxPageSize"))); 
						  if(objRs.getRecordSize()>0){
						  	String strReqBoxID="";
						  	while(objRs.next()){
						  	 strReqBoxID=(String)objRs.getObject("CMT_SUBMT_REQ_BOX_ID");
						 %>								
						<tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''">
							<td>
								<table width="759" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td height="22" width="34" align="center"><%=intRecordNumber%></td>
										<td width="415" class="td_lmagin"><a href="javascript:gotoDetail('<%=strReqBoxID%>')"><%=(String)objRs.getObject("CMT_SUBMT_REQ_BOX_NM")%></a></td>
										<td width="80" align="center"><%=(String)objRs.getObject("CNT")%> ��°</td>
										<td width="90" align="center"><%=objCdinfo.getRelatedDuty((String)objRs.getObject("RLTD_DUTY"))%></td>
										<td width="70" align="center"><%=CodeConstants.getCmtSubmtReqBoxStt((String)objRs.getObject("STT"))%></td>
										<td width="70" align="right" style="padding-top:2px;padding-bottom:2px;padding-right:4px"><%=StringUtil.getDate2((String)objRs.getObject("CMT_SUBMT_REQ_DT"))%></td>
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
							<td align="center" height="35">��ϵ� ��û���� �����ϴ�.</td>
						</tr>
    	                <tr class="tbl-line"> 
                      		<td height="1"></td>
                    	</tr>       							
						<%
						}//end if ��� ��� ��.
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
							objParams.getParamValue("ReqBoxPageSize"))
					%>
                </td>
              </tr>

              <!------------------ �˻�(��ȸ) �� <tr></tr> --------------------------->
              <tr> 
                <td height="40" align="left" valign="top">
                	<% if(objUserInfo.getIsMyCmtOrganID(strSelectedCmtOrganID) && objReqBox.checkCmtOrganMakeAutoSche(strSelectedCmtOrganID)) { %> 
                  			<img src="/image/common/icon_exclam_mark.gif" border="0"> ������Ư������ȸ, �����������ȸ ��� ���� ����ȸ ���� �ڵ� ���� ����� ����ϴ� ����ȸ �Ҽ� �ǿ��ǿ�����<BR>&nbsp;&nbsp;&nbsp;&nbsp;�ǿ��� > �ۼ��� �䱸�� ���� �ۼ��� �� '����ȸ ���� �䱸�� �߼�' �� �̿��Ͽ� ����ȸ�� ���� �ٶ��ϴ�.
           			<% } %>
                	<table width="100%" border="0" cellspacing="0" cellpadding="0">
                    	<tr> 
                      		<td width="256" height="40">
                      			<!-- ��ư�� �ʿ��ϴٸ� ���⿡ �߰��Ͻ� �˴ϴ� -->
                      			<!-- 2005-05-30 ������ �Ҽ� �ǿ����� ������� ���������� ����� ���� �д� -->
                      			<% if(objUserInfo.getIsMyCmtOrganID(strSelectedCmtOrganID) && !objReqBox.checkCmtOrganMakeAutoSche(strSelectedCmtOrganID)) { %> 
	                      			<img src="/image/button/bt_makeAppBox.gif" height="20"  style="cursor:hand" onClick="javascript:NewCmtReqWrite()" alt="���ο� ����ȸ ���� ��û���� �����մϴ�.">
                      			<% } %>
                      		</td>
							<td width="503" align="right" valign="middle">
							<%
								String strReqBoxQryField=objParams.getParamValue("ReqBoxQryField");
							%>
								<select name="ReqBoxQryField" class="select">
									<option <%=(strReqBoxQryField.equalsIgnoreCase("CMT_SUBMT_REQ_BOX_NM"))? " selected ": ""%>value="CMT_SUBMT_REQ_BOX_NM">��û�Ը�</option>
								</select>
								<input type="text" class="textfield" name="ReqBoxQryTerm" value="<%=objParams.getParamValue("ReqBoxQryTerm")%>">
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
