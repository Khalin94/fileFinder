<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.pf.util.PageCount"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.params.requestinfo.SMemReqInfoListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.SMemReqBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.SMemReqInfoDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	UserInfoDelegate objUserInfo =null;
	CDInfoDelegate objCdinfo =null;
%>

<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>

<%
	String strSelectedAuditYear = null; // ����⵵
	String strSelectedReqOrganID = null; // �䱸��� ID

	SMemReqInfoListForm objParams = new SMemReqInfoListForm();  
	objParams.setParamValue("ReqStt", CodeConstants.REQ_STT_SUBMT); // �䱸��������
	objParams.setParamValue("SubmtOrganID", objUserInfo.getOrganID()); // ������ ID
	objParams.setParamValue("ReqInfoSortField", "last_ans_dt"); // ���ļ���. �����亯��
	objParams.setParamValue("IsRequester", String.valueOf(objUserInfo.isRequester())); // �䱸�亯�ڿ��μ���

	boolean blnParamCheck=false;
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

%>

<% 
	SMemReqBoxDelegate objReqBoxDelegate = null;
	SMemReqInfoDelegate objReqInfo = null;				// �䱸���� Delegate
	ResultSetHelper objRs = null;								// �䱸���� ResultSet
	ResultSetHelper objOrgRs = null;
	
	ResultSetHelper objRsAuditYear = null;
	ResultSetHelper objRsReqOrgan = null;

	try{
		objReqBoxDelegate = new SMemReqBoxDelegate();
		objReqInfo = new SMemReqInfoDelegate();
		
		strSelectedAuditYear = objParams.getParamValue("AuditYear"); // ����⵵
		strSelectedReqOrganID = objParams.getParamValue("ReqOrganID"); // �䱸���
	
		if (!StringUtil.isAssigned(strSelectedAuditYear)) {
			Calendar objDate = Calendar.getInstance();
			strSelectedAuditYear = String.valueOf(objDate.get(Calendar.YEAR));
			objParams.setParamValue("AuditYear", String.valueOf(objDate.get(Calendar.YEAR)));	
		}
		
		objRs = new ResultSetHelper(objReqInfo.getRecordListByReqOrgID(objParams));
		objRsAuditYear = new ResultSetHelper(objReqBoxDelegate.getAuditYearList(objUserInfo.getOrganID()));
		objRsReqOrgan = new ResultSetHelper(objReqBoxDelegate.getReqOrganList(objParams));

	} catch(AppException objAppEx) {
		objAppEx.printStackTrace();
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		objMsgBean.setStrCode(objAppEx.getStrErrCode());
		objMsgBean.setStrMsg(objAppEx.getMessage());
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%  	
		return;
	}

	int intTotalRecordCount=objRs.getTotalRecordCount();
	int intCurrentPageNum=objRs.getPageNumber();
	int intTotalPage=objRs.getTotalPageCount();	
%>

<html>
<head>
<title><%=MenuConstants.getReqBoxGeneral(request)%> > <%=MenuConstants.REQ_INFO_LIST%></title>
<link href="/css/System.css" rel="stylesheet" type="text/css">
<script language="javascript">

  	function makePerYearReqOrgList(strYear) {
		var f = document.listForm;
    	var field = f.ReqOrganID;
       	field.length=0;
		for(var i=0; i<arrPerYearReqOrg.length; i++) {
			var strTmpYear = arrPerYearReqOrg[i][0];
		   	if(strYear == strTmpYear){
				var tmpOpt = new Option();
			   	tmpOpt.value = arrPerYearReqOrg[i][1];
			   	tmpOpt.text = arrPerYearReqOrg[i][2];
			   	if(varReqOrg == tmpOpt.value){
		    		tmpOpt.selected=true;
			   	}
			   	field.add(tmpOpt);	
	   		}
		}
  	}

  	function changeReqOrgList() {
  		var f = document.listForm;
    	makePerYearReqOrgList(f.AuditYear.options[f.AuditYear.selectedIndex].value);
  	}

	/** ���Ĺ�� �ٲٱ� */
	function changeSortQuery(sortField, sortMethod) {
		var f = document.listForm;
		f.ReqInfoSortField.value=sortField;
	  	f.ReqInfoSortMtd.value=sortMethod;
	  	f.submit();
	}

	//�䱸 �󼼺��� �̵�
	function gotoDetail(strID){
		var f = document.listForm;
		f.ReqID.value = strID;
		f.action = "SSubReqVList.jsp";
		f.submit();
	}

	/** ����¡ �ٷΰ��� */
	function goPage(strPage){
		var f = document.listForm;
		f.ReqInfoPage.value = strPage;
		f.submit();
	} 

  /**�⵵�� ����ȸ�θ� ��ȸ�ϱ� */
  function gotoHeadQuery() {
	  var f = document.listForm;
	  f.ReqInfoQryField.value="";
	  f.ReqInfoQryTerm.value="";
	  f.ReqInfoSortField.value="";
	  f.ReqInfoSortMtd.value="";
	  f.ReqInfoPage.value="";
	  f.submit();
  }  
  
  /** �䱸�� �� ����� �̵� */
  function gotoReqBoxInfoView(strReqBoxStt, strReqBoxID) {
  	var strMoveURL;
  	if (strReqBoxStt == "<%= CodeConstants.REQ_BOX_STT_006 %>") { // �ۼ���
  		strMoveURL = "/reqsubmit/10_mem/20_reqboxsh/10_make/SMakeReqBoxVList.jsp?ReqBoxID="+strReqBoxID;
  	} else if (strReqBoxStt == "<%= CodeConstants.REQ_BOX_STT_007 %>") { // ����Ϸ�
  		strMoveURL = "/reqsubmit/10_mem/20_reqboxsh/30_makeend/SMakeEndBoxVList.jsp?ReqBoxID="+strReqBoxID;
  	}
  	location.href=strMoveURL;
  }
	
	function doRefresh() {
		var f = document.listForm;
		f.target = "";
		f.submit();
	}
</script>

</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">

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
<form name="listForm" method="post" action="<%=request.getRequestURI()%>">
          <%
          	String strReqInfoSortField=objParams.getParamValue("ReqInfoSortField");
			String strReqInfoSortMtd=objParams.getParamValue("ReqInfoSortMtd");
			String strReqInfoPagNum=objParams.getParamValue("ReqInfoPage");
		  %>
			  <input type="hidden" name="ReqInfoSortField" value="<%=strReqInfoSortField%>"><!--�䱸���� ��������ʵ� -->
			  <input type="hidden" name="ReqInfoSortMtd" value="<%=strReqInfoSortMtd%>"><!--�䱸���� ������ɹ��-->
			  <input type="hidden" name="ReqInfoPage" value="<%=strReqInfoPagNum%>"><!--�䱸���� ������ ��ȣ -->
			  <input type="hidden" name="ReqID" value=""><!--�䱸���� ID-->
			  <input type="hidden" name="ReturnUrl" value="<%=request.getRequestURI()%>"><!--�ǵ��ƿ� URL -->
			  
              <tr> 
                <td height="23" align="left" valign="top"></td>
              </tr>
              <tr> 
                <td height="23" align="left" valign="top"><table width="100%" height="23" border="0" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="25%" background="/image/reqsubmit/bg_reqsubmit_tit.gif">
                      		<!-------------------- Ÿ��Ʋ�� �Է��� �ּ��� ------------------------>
                      		<span class="title"><%=MenuConstants.REQ_INFO_LIST_SUBMT_DONE%></span>
                      </td>
                      <td width="16%" align="left" background="/image/common/bg_titLine.gif">&nbsp;</td>
                      <td width="59%" align="right" background="/image/common/bg_titLine.gif" class="text_s">
                      		<!-------------------- ���� ��ġ ������ ����Ѵ�ϴ�. ------------------------>
                      		<img src="/image/common/icon_navi.gif" width="3" height="5" align="absmiddle"> 
                        <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.getReqBoxGeneral(request)%> > <%=MenuConstants.REQ_INFO_LIST%> > <B><%=MenuConstants.REQ_INFO_LIST_SUBMT_DONE%></B>
                      </td>
                    </tr>
                  </table></td>
              </tr>
              <tr> 
                <td height="30" align="left" class="text_s">
                		<!-------------------- ���� �������� ���� ���� ��� ------------------------>
                		��� �亯 ������ �Ϸ��� �䱸 ����Դϴ�.
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
													<select name="AuditYear" class="select_reqsubmit" onChange="javascript:doRefresh()">
								                		<%
								                			/*
								                			Calendar objCal = Calendar.getInstance();
								                			int intNowYear = objCal.get(Calendar.YEAR);
								                			String strSelected = "";
								                			while(intNowYear > 2002) {
								                				if(String.valueOf(intNowYear).equals(paramForm.getParamValue("AuditYear"))) {
								                					strSelected = " selected";
								                				} else {
								                					strSelected = "";
								                				}
										                		out.println("<option value="+intNowYear+strSelected+">"+intNowYear+"</option>");
										             			intNowYear--;
										             		}
										             		*/
										             		if(objRsAuditYear.getTotalRecordCount() < 1) {
										             			Calendar objCal = Calendar.getInstance();
									                			int intNowYear = objCal.get(Calendar.YEAR);
									                			out.println("<option value="+intNowYear+">"+intNowYear+"</option>");
										             		}
										             		String strSelected1 = "";
										             		while(objRsAuditYear.next()) {
										             			if(strSelectedAuditYear.equals((String)objRsAuditYear.getObject("AUDIT_YEAR"))) strSelected1 = " selected";
										             			else strSelected1 = "";
										             			out.println("<option value="+(String)objRsAuditYear.getObject("AUDIT_YEAR")+strSelected1+">"+(String)objRsAuditYear.getObject("AUDIT_YEAR")+"</option>");
										             		}
										             	%>
								                	</select> �⵵
				                	
								                	<select name="ReqOrganID" class="select_reqsubmit" onChange="javascript:doRefresh()">
								                		<option value="">:::: ��ü �䱸��� ::::</option>
								                		<%
								                			if(objRsReqOrgan.getTotalRecordCount() < 1) {
									                			out.println("<option value=''>::: �䱸����� �����ϴ� :::</option>");
										             		}
										             		String strSelected2 = "";
										             		while(objRsReqOrgan.next()) {
											             		if(strSelectedReqOrganID.equalsIgnoreCase((String)objRsReqOrgan.getObject("REQ_ORGAN_ID"))) strSelected2 = " selected";
										             			else strSelected2 = "";
										             			out.println("<option value="+(String)objRsReqOrgan.getObject("REQ_ORGAN_ID")+strSelected2+">"+(String)objRsReqOrgan.getObject("REQ_ORGAN_NM")+"</option>");
										             		}
										             	%>
								                	</select> �䱸 ���
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
										<td height="22" width="10" align="center"><input type="checkbox" name="checkAll" onClick="checkAllOrNot(document.listForm);"></td>
										<td width="39" align="center">NO</td>
										<td width="310" align="center"><%=SortingUtil.getSortLink("changeSortQuery","REQ_CONT",strReqInfoSortField,strReqInfoSortMtd,"�䱸����")%></td>
										<td width="100" align="center"><%=SortingUtil.getSortLink("changeSortQuery","REQ_ORGAN_NM", strReqInfoSortField, strReqInfoSortMtd, "�䱸���")%></td>
										<td width="60" align="center"><%=SortingUtil.getSortLink("changeSortQuery","REQ_BOX_NM",strReqInfoSortField,strReqInfoSortMtd,"�䱸��")%></td>
										<td width="50" align="center">�亯</td>
										<td width="50" align="center">÷��</td>
										<td width="70" align="center"><%=SortingUtil.getSortLink("changeSortQuery","LAST_REQ_DT",strReqInfoSortField,strReqInfoSortMtd,"�䱸�Ͻ�")%></td>
										<td width="70" align="center"><%=SortingUtil.getSortLink("changeSortQuery","LAST_ANS_DT",strReqInfoSortField,strReqInfoSortMtd,"�亯�Ͻ�")%></td>
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
						  	while(objRs.next()) {
						  		strReqInfoID=(String)objRs.getObject("REQ_ID");
						 %>								
						<tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''">
							<td>
								<table width="759" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td height="22" width="10" align="center"><input type="checkbox" name="ReqInfoIDs" value="<%= strReqInfoID %>"></td>
										<td width="39" align="center"><%= intRecordNumber %></td>
										<td width="310" class="td_lmagin"><%= StringUtil.getNotifyImg((String)objRs.getObject("LAST_ANS_DT"), (String)objRs.getObject("REQ_STT")) %><a href="JavaScript:gotoDetail('<%= strReqInfoID %>');" hint="<%= StringUtil.substring((String)objRs.getObject("REQ_DTL_CONT"), 80) %> ..."><%= (String)objRs.getObject("REQ_CONT") %></a></td>
										<td width="100" align="left">
											<%
												String strOldOrganNm = (String)objRs.getObject("REQ_ORGAN_NM");
												String strOldOrganNm4Len = strOldOrganNm.substring(0, 4);
												if("��ȸ�ǿ�".equalsIgnoreCase(strOldOrganNm4Len)) {
													out.println(strOldOrganNm.substring(5, strOldOrganNm.length()));
												} else {
													out.println(strOldOrganNm);
												}
											%>
										</td>
										<td width="60" align="center" class="td_lmagin"><a href="javascript:gotoReqBoxInfoView('<%= (String)objRs.getObject("REQ_BOX_STT") %>', '<%= (String)objRs.getObject("REQ_BOX_ID") %>')"><img src="/image/reqsubmit/icon_secretariat.gif" border="0" alt="<%=objRs.getObject("REQ_BOX_NM")%> �ٷΰ���"></a></td>
										<td width="50" align="center"><%= nads.lib.reqsubmit.util.DBAccessUtil.makeAnsInfoHtml((String)objRs.getObject("ANS_ID"),(String)objRs.getObject("ANS_MTD"),StringUtil.ReplaceString((String)objRs.getObject("ANS_OPIN"), "'", ""),(String)objRs.getObject("SUBMT_FLAG"),objUserInfo.isRequester()) %></td>
										<td width="50" align="center"><%=makeAttachedFileLink((String)objRs.getObject("ANS_ESTYLE_FILE_PATH"))%></td>
										<td width="70" align="right"><%= StringUtil.getDate2((String)objRs.getObject("LAST_REQ_DT")) %> </td>
										<td width="70" align="right" style="padding-top:2px;padding-bottom:2px"><%= StringUtil.getDate2((String)objRs.getObject("LAST_ANS_DT")) %> </td>
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
                      			 if(intTotalRecordCount>0){
                      			%>
                      			<img src="/image/button/bt_putBinder.gif" height="20"  style="cursor:hand" onClick="javascript:addBinder(listForm);" alt="���õ� ������ ���δ� �䱸�Կ� ����Ͽ� ���ε��� �� �ֵ��� �մϴ�.">
                      			<%
                      			 }//endif ���ε��Ұ����־������..
                      			%>
                      		</td>
							<td width="503" align="right" valign="middle">
							<%
								String strReqInfoQryField=(String)objParams.getParamValue("ReqInfoQryField");
							%>
								<select name="ReqInfoQryField">
									<option <%=(strReqInfoQryField.equalsIgnoreCase("req_cont"))? " selected ": ""%>value="req_cont">�䱸����</option>
									<option <%=(strReqInfoQryField.equalsIgnoreCase("req_dtl_cont"))? " selected ": ""%>value="req_dtl_cont">�䱸����</option>
								</select>
								<input type="text" name="ReqInfoQryTerm" value="<%=objParams.getParamValue("ReqInfoQryTerm")%>" class="textfield">
								<img src="/image/common/bt_search_table.gif" height="18" align="absmiddle" onClick="document.listForm.submit();" style="cursor:hand">
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