<%@ page language="java" contentType="text/html; charset=EUC-KR" %>

<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.pf.util.PageCount"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.lib.reqsubmit.params.requestbox.SMemReqBoxListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.SMemReqBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.MemRequestBoxDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	UserInfoDelegate objUserInfo =null;
	CDInfoDelegate objCdinfo =null;
%>

<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>

<%
	String strSelectedAuditYear = null;
	String strSelectedReqOrganID = null;
	
	SMemReqBoxDelegate selfDelegate = null;
	MemRequestBoxDelegate objReqBox=null;
	SMemReqBoxListForm paramForm = new SMemReqBoxListForm();
	paramForm.setParamValue("SubmtOrganID", objUserInfo.getOrganID()); // '������' �̹Ƿ�
	paramForm.setParamValue("ReqBoxStt", CodeConstants.REQ_BOX_STT_007); // '�������� �ۼ� �Ϸ�' �̹Ƿ� 	
	
	boolean blnCheckParam = false;
	blnCheckParam = paramForm.validateParams(request);

	if(!blnCheckParam) {
		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
		objMsgBean.setStrCode("DSPARAM-0000");
		objMsgBean.setStrMsg(paramForm.getStrErrors());
		out.println("ParamError:" + paramForm.getStrErrors());
	  	return;
	}
	
	ResultSetHelper rsHelper = null;
	ResultSetHelper objRsAuditYear = null;
	ResultSetHelper objRsReqOrgan = null;
		
	try {
		strSelectedAuditYear= paramForm.getParamValue("AuditYear");
		strSelectedReqOrganID = paramForm.getParamValue("ReqOrganID");
		
		if (!StringUtil.isAssigned(strSelectedAuditYear)) {
			Calendar objDate = Calendar.getInstance();
			strSelectedAuditYear = String.valueOf(objDate.get(Calendar.YEAR));
			paramForm.setParamValue("AuditYear", String.valueOf(objDate.get(Calendar.YEAR)));	
		}
		
		selfDelegate = new SMemReqBoxDelegate();
		objReqBox=new MemRequestBoxDelegate();
				
		rsHelper = new ResultSetHelper((Hashtable)selfDelegate.getRecordList(paramForm));
		objRsAuditYear = new ResultSetHelper(selfDelegate.getAuditYearList(objUserInfo.getOrganID()));
		objRsReqOrgan = new ResultSetHelper(selfDelegate.getReqOrganList(paramForm));

	} catch(AppException e) {
  		//throw new AppException(e.getMessage(), e);
  		out.println(e.getMessage());
  		return;
 	} 
 
	// �䱸�� �����ȸ�� ��� ��ȯ.
	int intTotalRecordCount = rsHelper.getTotalRecordCount();
	int intCurrentPageNum = rsHelper.getPageNumber();
	int intTotalPage = rsHelper.getTotalPageCount();

%>

<html>
<head>
<title><%=MenuConstants.getReqBoxGeneral(request)%> > <%=MenuConstants.REQ_BOX_MAKE%></title>
<link href="/css/System.css" rel="stylesheet" type="text/css">

<script language="javascript">

	/** ���Ĺ�� �ٲٱ� */
	function changeSortQuery(sortField, sortMethod){
		form = document.listqry;
  		form.ReqBoxSortField.value = sortField;
  		form.ReqBoxSortMtd.value = sortMethod;
  		form.submit();
  	}
  
  	/** �䱸�Ի󼼺���� ���� */
  	function gotoDetail(strID){
  		form = document.listqry;
  		form.ReqBoxID.value = strID;
  		form.action="SMakeEndBoxVList.jsp";
  		form.submit();
  	}
  
  	/** ����¡ �ٷΰ��� */
  	function goPage(strPage){
  		form = document.listqry;
  		form.ReqBoxPage.value=strPage;
  		form.submit();
  	}
  	
  	function doRefresh() {
		var f = document.listqry;
		f.target = "";
		f.submit();
	}
</script>

</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<%@ include file="/reqsubmit/common/MenuTopReqsubmit.jsp" %>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr align="left" valign="top">
    <td width="186" height="470" background="/image/common/bg_leftMenu.gif">
		<%@ include file="/reqsubmit/common/MenuLeftReqsubmit.jsp" %>
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
              <tr> 
                <td height="23" align="left" valign="top"></td>
              </tr>
              <tr> 
                <td height="23" align="left" valign="top"><table width="100%" height="23" border="0" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="35%" background="/image/reqsubmit/bg_reqsubmit_tit.gif">
                      		<!-------------------- Ÿ��Ʋ�� �Է��� �ּ��� ------------------------>
                      		<span class="title"><%= MenuConstants.REQ_BOX_MAKE_END %></span>
                      </td>
                      <td width="6%" align="left" background="/image/common/bg_titLine.gif">&nbsp;</td>
                      <td width="59%" align="right" background="/image/common/bg_titLine.gif" class="text_s">
                      		<!-------------------- ���� ��ġ ������ ����Ѵ�ϴ�. ------------------------>
                      		<img src="/image/common/icon_navi.gif" width="3" height="5" align="absmiddle"> 
                        <%= MenuConstants.GOTO_HOME %> > <%= MenuConstants.REQ_SUBMIT_MAIN_MENU %> > <%= MenuConstants.getReqBoxGeneral(request) %> > <B><%= MenuConstants.REQ_BOX_MAKE_END %></B>
                      </td>
                    </tr>
                  </table></td>
              </tr>
              <tr> 
                <td height="30" align="left" class="text_s">
                		<!-------------------- ���� �������� ���� ���� ��� ------------------------>
                		���� �Ϸ��� �䱸�� ����� Ȯ���Ͻ� �� �ֽ��ϴ�.
                </td>
              </tr>

<form name="listqry" method="post" action="<%=request.getRequestURI()%>" style="margin:0px">              
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
              							<td width="200" height="24"><img src="/image/reqsubmit/searchTableTop2.jpg" border="0"></td>
              							<td width="546" align="right" valign="bottom">
              								&nbsp;&nbsp;<img src="/image/common/icon_nemo_gray.gif" width="3" height="6" align="absmiddle">
											��ü �ڷ� �� : <%=intTotalRecordCount%>�� (<%=intCurrentPageNum%> / <%=intTotalPage%> Page)
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
								                	</select> �䱸�� ���
												</td>
												<td>&nbsp;&nbsp;</td>
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
<%
	// ���� ���� �ޱ�.
	String strReqBoxSortField = paramForm.getParamValue("ReqBoxSortField");
	String strReqBoxSortMtd = paramForm.getParamValue("ReqBoxSortMtd");
%>
					<input type="hidden" name="ReqBoxSortField" value="<%= strReqBoxSortField %>">
					<input type="hidden" name="ReqBoxSortMtd" value="<%= strReqBoxSortMtd %>">
					<input type="hidden" name="ReqBoxPage" value="<%= intCurrentPageNum %>">
					<input type="hidden" name="ReqBoxID" value="<%= "" %>">
					
					<table width="759" border="0" cellspacing="0" cellpadding="0">
                    	<tr> 
                      		<td height="2" colspan="6" class="td_reqsubmit"></td>
	                    </tr>
    	                <tr align="center" class="td_top"> 
            	          	<td width="39" height="22">NO</td>
	                	    <td width="340"><%=SortingUtil.getSortLink("changeSortQuery", "REQ_BOX_NM", strReqBoxSortField, strReqBoxSortMtd, "�䱸�Ը�")%></td>
                    	  	<td width="150"><%=SortingUtil.getSortLink("changeSortQuery", "REQ_ORGAN_NM", strReqBoxSortField, strReqBoxSortMtd, "�䱸���")%></td>
	                      	<td width="80"><%=SortingUtil.getSortLink("changeSortQuery", "RLTD_DUTY", strReqBoxSortField, strReqBoxSortMtd, "��������")%></td>
    	                  	<td width="70"><%=SortingUtil.getSortLink("changeSortQuery", "LAST_ANS_DOC_SND_DT", strReqBoxSortField, strReqBoxSortMtd, "�����Ͻ�")%></td>
        	              	<td width="80">�亯/�䱸</td>
            	        </tr>
                	    <tr> 
                    	  	<td height="1" colspan="6" class="td_reqsubmit"></td>
                    	</tr>
                    	<%
                    		int intRecordNumber = intTotalRecordCount - ((intCurrentPageNum -1) * Integer.parseInt((String)paramForm.getParamValue("ReqBoxPageSize")));
							if(rsHelper.getRecordSize() > 0) {
								String strReqBoxID = "";
							  	while(rsHelper.next()) {
							  		strReqBoxID = (String)rsHelper.getObject("REQ_BOX_ID");
							  		//Hashtable countHash = (Hashtable)selfDelegate.getReqBoxRelateCount(strReqBoxID);
						%>
	                    <tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''"> 
        	              	<td width="39" height="22" align="center"><%= intRecordNumber %></td>
            	          	<td width="340" class="td_lmagin"><a href="javascript:gotoDetail('<%=strReqBoxID%>')"><%= (String)rsHelper.getObject("REQ_BOX_NM") %></a></td>
                	      	<td width="150" class="td_lmagin"><%= (String)rsHelper.getObject("REQ_ORGAN_NM") %></td>
                    	  	<td width="80" align="center"><%= objCdinfo.getRelatedDuty((String)rsHelper.getObject("RLTD_DUTY")) %></td>
                      		<td width="70" align="right" style="padding-top:2px;padding-bottom:2px"><%= StringUtil.getDate2((String)rsHelper.getObject("LAST_ANS_DOC_SND_DT")) %></td>
	                      	<td width="80" align="center"><%= (String)rsHelper.getObject("SUBMT_CNT") %> / <%= (String)rsHelper.getObject("REQ_CNT") %></td>
    	                </tr>
    	                <tr class="tbl-line"> 
                      		<td height="1" colspan="6"></td>
                    	</tr>
                    	<%
                    				intRecordNumber--;
								} // endofwhile
							} else {
						%>
						<tr>
							<td colspan="6" height="40" align="center">��ϵ� �䱸���� �����ϴ�.</td>
						</tr>
						<%
							} // end if
						%>
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
							paramForm.getParamValue("ReqBoxPageSize"))
					%>
                </td>
              </tr>
              
              <!---------------------------------------------- ȸ�� ������ �ʿ���!!!!!!!! --------------------------------------------->
              <tr>
              	<td height="3" background="/image/common/line_table.gif"></td>
              </tr>
                            
              <!------------------ �˻�(��ȸ) �� <tr></tr> --------------------------->
              <tr> 
                <td height="40" align="left" valign="top">
                	<table width="100%" border="0" cellspacing="0" cellpadding="0">
                    	<tr> 
                      		<td width="256" height="40">
                      			<!-- ��ư�� �ʿ��ϴٸ� ���⿡ �߰��Ͻ� �˴ϴٿ� -->
                      			
                      		</td>
                      		<td width="503" align="right" valign="middle">
                      			<!----------- �˻� �� ----------->
                      			<% String strReqBoxQryField = paramForm.getParamValue("ReqBoxQryField"); %>
                      			<select name="ReqBoxQryField" class="select">
									<option <%=(strReqBoxQryField.equalsIgnoreCase("req_box_nm"))? " selected ": ""%>value="req_box_nm">�䱸�Ը�</option>
								</select>
                          		<input type="text" name="ReqBoxQryTerm" value="<%= paramForm.getParamValue("ReqBoxQryTerm") %>" class="textfield" style="WIDTH:180px" >
                          		<img src="/image/common/bt_search_table.gif" width="51" height="18" align="absmiddle" onClick="listqry.submit()" style="cursor:hand">
                          	</td>
                    	</tr>
                  	</table>
               </td>
              </tr>
              
            	<!------------------------- �� TAB�� �ΰ� �����ø� ���� �ҽ����� �����ؼ� �� ���� �ٿ��ֱ� �ؼ� �����ϼ��� ------------------------->
            	<!----- [����] TAB <tr> �� �� �ؿ� ������ �����ϴ� <tr>�� �� �����ؼ� �� ì�� �ֽþ��. ������.. -------->
</form>

            </table>
            </td>
        </tr>
      </table></td>
  </tr>
</table>
<%@ include file="/common/Bottom.jsp" %>
</body>
</html>
