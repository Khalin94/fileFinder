<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.pf.util.PageCount"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.params.requestbox.SCommReqBoxListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.SCommRequestBoxDelegate" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	UserInfoDelegate objUserInfo =null;
	CDInfoDelegate objCdinfo =null;
%>
<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>

<% 
	/*************************************************************************************************/
	/** 	name : SCommReqBoxList.jsp																  */
	/** 		   ����ȸ �䱸�� ����� ����Ѵ�.													  */
	/** 		   �䱸������ �ִ� �Ҽ� ����ȸ�� ����� ����Ѵ�.										  */
	/*************************************************************************************************/
 
	//�ش�����ȸ�� �������.. �����޼��� ���..
	if(objUserInfo.getCurrentCMTList().isEmpty()){
	  	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
	  	objMsgBean.setStrCode("DSDATA-0021");
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}
 
	/**���õ� ����⵵�� ���õ� ����ȸID*/
	String strSelectedAuditYear = null; /**���õ� ����⵵*/
	String strSelectedCmtOrganID = null; /**���õ� ����ȸID*/

	/**����ȸ�����ȸ�� �Ķ���� ����.*/
	SCommReqBoxListForm objParams=new SCommReqBoxListForm();
	//�䱸��� ���� :: �Ҽ� ���.
	objParams.setParamValue("SubmtOrganID",objUserInfo.getOrganID());
	//����ȸ �䱸����������� : ����Ϸ�
	objParams.setParamValue("IngStt",CodeConstants.REQ_ING_STT_002);
	//�䱸�� ���� : ����Ϸ�
	objParams.setParamValue("ReqBoxStt",CodeConstants.REQ_BOX_STT_007);
 
	boolean blnParamCheck = false;
	/**���޵� �ĸ����� üũ */
	blnParamCheck = objParams.validateParams(request);
	if(blnParamCheck == false){
	  	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
	  	objMsgBean.setStrCode("DSPARAM-0000");
	  	objMsgBean.setStrMsg(objParams.getStrErrors());
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}
  
	strSelectedAuditYear = objParams.getParamValue("AuditYear"); 	/**���õ� ����⵵*/
	strSelectedCmtOrganID = objParams.getParamValue("CmtOrganID") ; /**���õ� ����ȸID*/

	//�䱸�� ��ü ��Delegate �����.
	SCommRequestBoxDelegate objReqBox = null;
	ResultSetHelper objCmtRs = null;			/** ������ ����ȸ */
	ResultSetHelper objRs = null;			/** ����ȸ �䱸�� ��� */
    ResultSetSingleHelper objRsSH = null;			/** �䱸�� �󼼺��� ���� */

	try {
		objReqBox = new SCommRequestBoxDelegate();
		objCmtRs = new ResultSetHelper(objReqBox.getReqrPerYearCMTList(objUserInfo.getCurrentCMTList(),CodeConstants.REQ_ING_STT_002,CodeConstants.REQ_BOX_STT_007));   
		if(objCmtRs.next() && !StringUtil.isAssigned(strSelectedAuditYear) && !StringUtil.isAssigned(strSelectedCmtOrganID)) {
	 		strSelectedAuditYear=(String)objCmtRs.getObject("AUDIT_YEAR");
	 		strSelectedCmtOrganID=(String)objCmtRs.getObject("CMT_ORGAN_ID");
		    objParams.setParamValueIfNull("AuditYear",strSelectedAuditYear);
		    objParams.setParamValueIfNull("CmtOrganID",strSelectedCmtOrganID); 		
		}
   
		objRs=new ResultSetHelper(objReqBox.getRecordList2(objParams));

	} catch(AppException objAppEx) {
	 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
	  	objMsgBean.setStrCode(objAppEx.getStrErrCode());
	  	objMsgBean.setStrMsg(objAppEx.getMessage());
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%  	
		return;
	}
 
	//�䱸�� �����ȸ�� ��� ��ȯ.
	int intTotalRecordCount=objRs.getTotalRecordCount();
	int intCurrentPageNum=objRs.getPageNumber();
	int intTotalPage=objRs.getTotalPageCount();
%>

<html>
<head>
<title><%=MenuConstants.REQUEST_BOX_COMM%> > <%=MenuConstants.COMM_REQ_BOX_SUBMT_END%></title>
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
	var field=listqry.AuditYear;
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
       	var field=listqry.CmtOrganID;
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
    makePerYearCmtList(listqry.AuditYear.options[listqry.AuditYear.selectedIndex].value);
  }
  
  /** ���Ĺ�� �ٲٱ� */
  function changeSortQuery(sortField,sortMethod){
  	listqry.ReqBoxSortField.value=sortField;
  	listqry.ReqBoxSortMtd.value=sortMethod;
  	listqry.submit();
  }
  
  //�䱸�Ի󼼺���� ����.
  function gotoDetail(strID){
  	listqry.ReqBoxID.value=strID;
  	listqry.action="./SSubEndBoxVList.jsp";
  	listqry.submit();
  }
  
  /** ����¡ �ٷΰ��� */
  function goPage(strPage){
  	listqry.ReqBoxPage.value=strPage;
  	listqry.submit();
  }
  
  /**�⵵�� ����ȸ�θ� ��ȸ�ϱ� */
  function gotoHeadQuery(){
  	listqry.ReqBoxQryField.value="";
  	listqry.ReqBoxQryTerm.value="";
  	listqry.ReqBoxSortField.value="";
  	listqry.ReqBoxSortMtd.value="";
  	listqry.ReqBoxPage.value="";
  	listqry.submit();
  }
</script>
</head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onload="init()">
<%@ include file="/reqsubmit/common/MenuTopReqsubmit.jsp" %>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
<tr align="left" valign="top">
	<td width="186" height="470" background="/image/common/bg_leftMenu.gif">
	<%@ include file="/reqsubmit/common/MenuLeftReqsubmit.jsp" %></td>
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
			<form name="listqry" method="post" action="<%=request.getRequestURI()%>">
			<%//���� ���� �ޱ�.
				String strReqBoxSortField=objParams.getParamValue("ReqBoxSortField");
				String strReqBoxSortMtd=objParams.getParamValue("ReqBoxSortMtd");
			%>
			<input type="hidden" name="ReqBoxSortField" value="<%=strReqBoxSortField%>"><!--�䱸�Ը�������ʵ� -->
			<input type="hidden" name="ReqBoxSortMtd" value="<%=strReqBoxSortMtd%>">	<!--�䱸�Ը�����ɹ��-->
			<input type="hidden" name="ReqBoxPage" value="<%=intCurrentPageNum%>">			<!--������ ��ȣ -->
			<input type="hidden" name="ReqBoxID" value="">		<!--�䱸�� ID -->							
			<input type="hidden" name="CommOrganID" value="">	<!--����ȸ��� ID -->
			<input type="hidden" name="IngStt" value="">		<!--�䱸���� ����� -->
        <tr> 
        	<td align="left" valign="top">
        	<table width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td colspan="3" height="23px">
			</tr>            
            <tr> 
            	<td width="30%" background="/image/reqsubmit/bg_reqsubmit_tit.gif" height="23">
                	<!-------------------- Ÿ��Ʋ�� �Է��� �ּ��� ------------------------>
                	<span class="title"><%=MenuConstants.COMM_REQ_BOX_SUBMT_END%></span> <strong>- �䱸�� ���</strong>
                </td>
                <td width="15%" align="left" background="/image/common/bg_titLine.gif">&nbsp;</td>
                <td width="55%" align="right" background="/image/common/bg_titLine.gif" class="text_s">
				<!-------------------- ���� ��ġ ������ ����Ѵ�ϴ�. ------------------------>
					<img src="/image/common/icon_navi.gif" width="3" height="5" align="absmiddle"> 
                    <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.REQUEST_BOX_COMM%> > <B><%=MenuConstants.COMM_REQ_BOX_SUBMT_END%></B>
                </td>
			</tr>
			</table></td>
		</tr>
		<tr> 
			<td height="30" align="left" class="text_s">
            <!-------------------- ���� �������� ���� ���� ��� ------------------------>
            �亯�Ϸ��� �䱸�� ����� Ȯ���Ͻ� �� �ֽ��ϴ�.
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
													<select name="AuditYear" onChange="changeCmtList()" class="select_reqsubmit"></select> �⵵ 
													<select name="CmtOrganID" class="select_reqsubmit" onChange="this.form.submit()"></select> �䱸�� ��� 
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
          		<td height="2" colspan="6" class="td_reqsubmit"></td>
            </tr>
            <tr align="center" class="td_top"> 
	          	<td width="39" height="22">NO</td>
        	  	<td width="350"><%=SortingUtil.getSortLink("changeSortQuery","REQ_BOX_NM",strReqBoxSortField,strReqBoxSortMtd,"�䱸�Ը�")%></td>
               	<td width="150" style="padding-top:2px;padding-bottom:2px"><%=SortingUtil.getSortLink("changeSortQuery","REQ_ORGAN_NM", strReqBoxSortField, strReqBoxSortMtd, "�Ұ�����ȸ")%><BR><%=SortingUtil.getSortLink("changeSortQuery","OLD_REQ_ORGAN_NM", strReqBoxSortField, strReqBoxSortMtd, "(�ǿ���)")%></td>
             	<td width="80">����/�䱸</td>
             	<td width="70"><%=SortingUtil.getSortLink("changeSortQuery","LAST_REQ_DOC_SND_DT", strReqBoxSortField, strReqBoxSortMtd, "�䱸�Ͻ�")%></td>
               	<td width="70"><%=SortingUtil.getSortLink("changeSortQuery","LAST_ANS_DOC_SND_DT", strReqBoxSortField, strReqBoxSortMtd, "�亯�Ͻ�")%></td>
	        </tr>
    	    <tr> 
        	  	<td height="1" colspan="6" class="td_reqsubmit"></td>
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
				String strReqBoxID="";
			  	String strCommOrganID="";
			  		
			  	while(objRs.next()){
			  		strReqBoxID=(String)objRs.getObject("REQ_BOX_ID");
			  	 	strCommOrganID=(String)objRs.getObject("CMT_ORGAN_ID");
					objRsSH = new ResultSetSingleHelper(objReqBox.getOldOrganName(strReqBoxID));
			 %>
            <tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''"> 
              	<td width="39" align="center" height="22"><%= intRecordNumber %></td>
    	      	<td width="350" class="td_lmagin"><a href="javascript:gotoDetail('<%=strReqBoxID%>')"><%=(String)objRs.getObject("REQ_BOX_NM")%></a></td>
          		<td width="150" class="td_lmagin" align="left" style="padding-top:2px;padding-bottom:2px"><%=objRs.getObject("REQ_ORGAN_NM")%><BR>(<%=objRsSH.getObject("OLD_REQ_ORGAN_NM")%>)
				</td>
          		<td width="80" class="td_lmagin" align="center"><%=(String)objRs.getObject("SUBMT_CNT")%> / <%=(String)objRs.getObject("REQ_CNT")%></td>
              	<td width="70" class="td_lmagin" align="right"><%=StringUtil.getDate2((String)objRs.getObject("LAST_REQ_DOC_SND_DT"))%></td>
              	<td width="70" class="td_lmagin" align="right" style="padding-top:2px;padding-bottom:2px"><%=StringUtil.getDate2((String)objRs.getObject("LAST_ANS_DOC_SND_DT"))%></td>
            </tr>
            <tr class="tbl-line"> 
          		<td height="1" colspan="6"></td>
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
				<td colspan="6" height="40" align="center">��ϵ� �䱸���� �����ϴ�.</td>
			</tr>
            <tr class="tbl-line"> 
          		<td height="1" colspan="6"></td>
        	</tr>
			<%
				} // end if
			%>
            <tr class="tbl-line"> 
          		<td height="1" colspan="6"></td>
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
          		</td>
          		<td width="503" align="right" valign="middle">
          		<%
				String strReqBoxQryField=objParams.getParamValue("ReqBoxQryField");
				%>
				<select name="ReqBoxQryField"  class="select">
					<option <%=(strReqBoxQryField.equalsIgnoreCase("req_box_nm"))? " selected ": ""%>value="req_box_nm">�䱸�Ը�</option>
					<option <%=(strReqBoxQryField.equalsIgnoreCase("req_box_dsc"))? " selected ": ""%>value="req_box_dsc">�䱸�Լ���</option>
					<option <%=(strReqBoxQryField.equalsIgnoreCase("req_organ_nm"))? " selected ": ""%>value="req_organ_nm">�䱸���</option>
				</select>
				<input type="text" name="ReqBoxQryTerm" value="<%=objParams.getParamValue("ReqBoxQryTerm")%>"  class="textfield" style="WIDTH:180px">
				<img src="/image/common/bt_search_table.gif" width="51" height="18" align="absmiddle" onClick="listqry.submit()" style="cursor:hand">
				</td>	
        	</tr>
			</table>
			</td>
		</tr>
              
        <!------------------------- �� TAB�� �ΰ� �����ø� ���� �ҽ����� �����ؼ� �� ���� �ٿ��ֱ� �ؼ� �����ϼ��� ------------------------->
        <!----- [����] TAB <tr> �� �� �ؿ� ������ �����ϴ� <tr>�� �� �����ؼ� �� ì�� �ֽþ��. ������.. -------->
		</form>
        <tr>
        	<td height="35px"></td>
        </tr>  
        </table>
        </td>
	</tr>
    </table></td>
</tr>
</table>
<%@ include file="/common/Bottom.jsp" %>
</body>
</html>