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
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.RequestBoxDelegate" %>


<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	UserInfoDelegate objUserInfo =null;
	CDInfoDelegate objCdinfo =null;
%>

<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>

<%
	String strSelectedAuditYear= null;
	String strSelectedReqOrganID = null;
	String strDaesuInfo = StringUtil.getEmptyIfNull(request.getParameter("DaeSu"));
	String strDaeSuCh = StringUtil.getEmptyIfNull(request.getParameter("DAESUCH"));
	String strSubmtOrganId = StringUtil.getEmptyIfNull(request.getParameter("submtOrganId2"));
	String strOrganId = null;

	if(strSubmtOrganId.equals("")){
		strOrganId = objUserInfo.getOrganID();
	}else{
		strOrganId = strSubmtOrganId;
	}

	
	String strDaesu = null;
	String strStartdate = null;
	String strEnddate = null;
	
	SMemReqBoxDelegate selfDelegate = null;
	MemRequestBoxDelegate objReqBox=null;
	RequestBoxDelegate objReqBoxDelegate = null;
	SMemReqBoxListForm paramForm = new SMemReqBoxListForm();
	paramForm.setParamValue("SubmtOrganID", strSubmtOrganId); // '������' �̹Ƿ�
	paramForm.setParamValue("ReqBoxStt", CodeConstants.REQ_BOX_STT_006); // '�������� �ۼ� ��' �̹Ƿ� 	

	if(((String)paramForm.getParamValue("ReqBoxSortField")).equals("last_req_doc_snd_dt")){
		paramForm.setParamValue("ReqBoxSortField", "REG_DT");
	}

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
	ResultSetHelper objDaeRs=null;
	ResultSetHelper objSubmtRs=null;

	try {
		objReqBoxDelegate = new RequestBoxDelegate();
		strSelectedAuditYear = paramForm.getParamValue("AuditYear");
		strSelectedReqOrganID = paramForm.getParamValue("ReqOrganID");

		objDaeRs = new ResultSetHelper(objReqBoxDelegate.getOrganDaesu(strOrganId));
		List lst = objReqBoxDelegate.getSubmtOrganList(objUserInfo.getOrganID());
		objSubmtRs = new ResultSetHelper(lst);
		if(strDaesuInfo.equals("")){
			if(objDaeRs != null){
				if(objDaeRs.next()){
					strDaesu = (String)objDaeRs.getObject("DAE_NUM");
					strStartdate = (String)objDaeRs.getObject("START_DATE");
					strEnddate = (String)objDaeRs.getObject("END_DATE");
					objDaeRs.first();
				}
			}			
		}else{
			String[] strDaesuInfos = StringUtil.split("^",strDaesuInfo);
			strDaesu = strDaesuInfos[0];
			strStartdate = strDaesuInfos[1];
			strEnddate = strDaesuInfos[2];
		
		}


		Hashtable objhashdata = new Hashtable();

		objhashdata.put("START_DATE",strStartdate);
		objhashdata.put("END_DATE",strEnddate);
		objhashdata.put("SUBMTORGANIDZ",lst);
		
		selfDelegate = new SMemReqBoxDelegate();
		objReqBox=new MemRequestBoxDelegate();
		
		Hashtable objaaa = (Hashtable)selfDelegate.getOpRecordDaeList(paramForm,objhashdata);
		
		rsHelper = new ResultSetHelper(objaaa);
		objRsAuditYear = new ResultSetHelper(selfDelegate.getAuditYearDaeList(lst,strSubmtOrganId,strStartdate,strEnddate,CodeConstants.REQ_BOX_STT_006));
		objRsReqOrgan = new ResultSetHelper(selfDelegate.getReqOrganDaeList(paramForm,objhashdata));
		
	} catch(AppException e) {
		e.printStackTrace();
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		objMsgBean.setStrCode(e.getStrErrCode());
		objMsgBean.setStrMsg(e.getMessage());
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
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
<script language="javascript" src="/js/reqsubmit/common.js"></script>

<script language="javascript">

	var form;
    var IsClick=false;

	
	var strPopup;
	var strGubun = -1;

	function ButtonProcessing()
	{
		try{			
			if(strGubun < 0){
				var oPopup = window.createPopup();
				var  oPopBody  =  oPopup.document.body;
				oPopBody.style.backgroundColor  =  "white";
				oPopBody.style.border  =  "solid  #dddddd 1px";



				// "ó�����Դϴ�"��� �޽����� �ε��̹����� ǥ�õǵ��� �Ѵ�.
				oPopBody.innerHTML  = "<table width='100%' height='100%' border='1'><tr><td align='center' style='font-size:9pt;'><b>ó�����Դϴ�. ��ø� ��ٷ��ּ���...<b><br><img src='/image/reqsubmit/processing.gif'></td></tr></table>";



				var leftX = document.body.clientWidth/2 -130;
				var topY = (document.body.clientHeight/1.7) - (oPopBody.offsetHeight/2);

				oPopup.show(leftX,  topY,  270,  130,  document.body);



				// createPopup()�� �̿��� �˾��������� ����� ��� 
				// �⺻������ �ش� �˾����� onblur�̺�Ʈ�� �߻��ϸ� �� �˾��������� ������ �˴ϴ�.

				// �ش� �˾����������� onblur�̺�Ʈ�� �߻��Ҷ�����  �޼ҵ带 ��ȣ���Ͽ�

				// �˾��������� �׻� ǥ�õǰ� �մϴ�.
				oPopBody.attachEvent("onblur", ButtonProcessing);
				strPopup = oPopup;
			}
			strGubun = -1;
		} 
		catch(e) {}
	}

	function notProcessing(){
		if(strPopup.isOpen){
			strPopup.hide();
			strGubun = 1;
		}		
	}
	/** ���Ĺ�� �ٲٱ� */
	function changeSortQuery(sortField, sortMethod){
		form = document.listqry;
  		form.ReqBoxSortField.value = sortField;
  		form.ReqBoxSortMtd.value = sortMethod;
		form.DAESUCH.value = "N";
		form.target="";
		form.action="SMakeOpReqBoxList.jsp";
  		form.submit();
  	}
  
  	/** �䱸�� �󼼺���� ���� */
  	function gotoDetail(strID){
  		//form = document.listqry;
  		//form.ReqBoxID.value = strID;
		//form.target="";
  		//form.action="SMakeOpReqBoxVList.jsp";
  		//form.submit();

		if(!IsClick){
			location.href="./SMakeOpReqBoxVList.jsp?ReqBoxID="+strID+"&AuditYear="+listqry.AuditYear.value;	
		}else{
			alert("���μ����� �۵����Դϴ�. ��� ��ٷ��ֽʽÿ�.");
			return;
		}
  	}
  
  	/** ����¡ �ٷΰ��� */
  	function goPage(strPage){
  		form = document.listqry;
  		form.ReqBoxPage.value=strPage;
		form.DAESUCH.value = "N";
		form.target="";
		form.action="SMakeOpReqBoxList.jsp";
  		form.submit();
  	}

	function doRefresh() {
		var f = document.listqry;
		f.DAESUCH.value = "N";
		f.target = "";
		f.action="SMakeOpReqBoxList.jsp";
		f.submit();
	}

	function changeDaesu(){
		form = document.listqry;
		form.target = '';
		form.DAESUCH.value = "Y";
		form.action="SMakeOpReqBoxList.jsp";
		form.submit();
	}

	function AllInOne(){
		
		var w = 800;
		var h = 700;
		var winl = (screen.width - w) / 2;
		var winh = (screen.height - h) / 2;
		var url = "/reqsubmit/common/AnsInfoWriteAllInOne.jsp";	window.open(url,'New','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=no,width='+w+',height='+h+',left='+winl+',top='+winh);
	}

	// �亯�� �߼�
	function sendAnsDoc(str) {
		var f = document.listqry;
		f.action = "/reqsubmit/common/AnsOpDocSend.jsp?ReqBoxID="+str;
		f.target = "popwin";
		NewWindow('/blank.html', 'popwin', '470', '300');
		f.submit();		
	}

	// 2005-07-18 ���õ� �䱸�� �ϰ� ����
	function doDelete() {
		if(!IsClick){
			if(getCheckCount(document.listqry, "ReqBoxID") < 1) {
				alert("�����Ͻ� �ϳ� �̻��� �䱸���� ������ �ּ���.");
				return;
			}
		}else{
			alert("���μ����� �۵����Դϴ�. ��� ��ٷ��ֽʽÿ�.");
			return false;
		}
	  	
	  	if(confirm("�����Ͻ� �䱸���� �ϰ� �����Ͻðڽ��ϱ�?\n\r���Ե� ��� �䱸 ���뵵 �ϰ� �����˴ϴ�.")) {
			IsClick = true;  //��ư ó���� ������..
			ButtonProcessing();  //ó�����¸� ǥ���ϴ� �޼ҵ� ȣ��

			//var winl = (screen.width - 300) / 2;
			//var winh = (screen.height - 240) / 2;
			//document.all.loadingDiv.style.left = winl;
			//document.all.loadingDiv.style.top = winh;
			//document.all.loadingDiv.style.display = '';
			document.listqry.action = "/reqsubmit/10_mem/20_reqboxsh/15_make/ReqBoxOpDelProcMulti.jsp";
			document.listqry.target = 'processingFrame';	
			//window.open('/blank.html', 'popwin', 'width=300, height=240, left='+winl+', top='+winh);
	  		document.listqry.submit();
	  	}
	}
</script>

</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<iframe name='processingFrame' height='0' width='0'></iframe>
<DIV ID="loadingDiv" style="display:none;position:absolute;">
	<img src="/image/reqsubmit/loading.jpg" border="0"> </td>
</DIV>
<%@ include file="/reqsubmit/common/MenuTopReqsubmit.jsp" %>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr align="left" valign="top">
    <td width="186" height="470" background="/image/common/bg_leftMenu.gif">
	<%@ include file="/reqsubmit/common/MenuLeftReqsubmit.jsp" %></td>

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
                      <td width="25%" background="/image/reqsubmit/bg_reqsubmit_tit.gif">
                      		<!-------------------- Ÿ��Ʋ�� �Է��� �ּ��� ------------------------>
                      		<span class="title"><%= MenuConstants.REQ_BOX_MAKE %></span> 
                      </td>
                      <td width="16%" align="left" background="/image/common/bg_titLine.gif">&nbsp;</td>
                      <td width="59%" align="right" background="/image/common/bg_titLine.gif" class="text_s">
                      		<!-------------------- ���� ��ġ ������ ����Ѵ�ϴ�. ------------------------>
                      		<img src="/image/common/icon_navi.gif" width="3" height="5" align="absmiddle"> 
                        <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > ��ȸ�ǿ� ������ �ڷ� �䱸 > <B><%=MenuConstants.REQ_BOX_MAKE%></B>
                      </td>
                    </tr>
                  </table></td>
              </tr>			  
              <tr> 
                <td height="30" align="left" class="text_s">
                		<!-------------------- ���� �������� ���� ���� ��� ------------------------>    
						��ȸ �ǿ��Ƿ� ���� ��������(��ȭ,����,�ѽ�,���� ��)���� ��û�� �ڷḦ �����Ͻ� �� �ֽ��ϴ�.
                </td>
              </tr>
			  <tr align="center"> 
                <td height="30" align="center" class="text_s">
                		<!-------------------- ���� �������� ���� ���� ��� ------------------------>    
						<img src="/image/reqsubmit/reqreg2.gif" style="cursor:hand" onClick="javascript:AllInOne();" alt="�������ο䱸 �����ڷḦ ����մϴ�." align="absmiddle">
                </td>
              </tr>

<form name="listqry" method="post" action="<%=request.getRequestURI()%>" style="margin:0px">   
			<input type="hidden" name="DAESUCH" value="">
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
              							<td width="200" height="24"><img src="/image/reqsubmit/searchTableTop3.jpg" border="0"></td>
              							<td width="546" align="right" valign="bottom">
              								&nbsp;&nbsp;<img src="/image/common/icon_nemo_gray.gif" width="3" height="6" align="absmiddle">
											��ü �ڷ� �� : <%=intTotalRecordCount%>�� (<%=intCurrentPageNum%> / <%=intTotalPage%> Page)
              							</td>
              						</tr>
									<tr>
										<td height="29" colspan="2">
											<table border="0" cellpadding="0" cellspacing="0">
												<tr><td style="padding-left:25px">
													<select name="DaeSu" class="select_reqsubmit" onChange="changeDaesu()">
														<%
															if(objDaeRs != null){
																while(objDaeRs.next()){
																	String str = objDaeRs.getObject("DAE_NUM")+"^"+objDaeRs.getObject("START_DATE")+"^"+objDaeRs.getObject("END_DATE");
														%>
																<option value="<%=objDaeRs.getObject("DAE_NUM")%>^<%=objDaeRs.getObject("START_DATE")%>^<%=objDaeRs.getObject("END_DATE")%>" <%if(str.equals(strDaesuInfo)){%>selected<%}%>><%=objDaeRs.getObject("DAE_NUM")%>��</option>
														<%
																}
															}
														%>
													</select>
													<select name="AuditYear" class="select_reqsubmit" onChange="javascript:doRefresh()">
														<option value="">��ü</option>
								                		<%								                			
										             		if(objRsAuditYear != null && objRsAuditYear.getTotalRecordCount() > 0) {
																String strSelected1 = "";
																while(objRsAuditYear.next()) {
																	if(strSelectedAuditYear.equals((String)objRsAuditYear.getObject("AUDIT_YEAR"))) strSelected1 = " selected";
																	else strSelected1 = "";
																	out.println("<option value="+(String)objRsAuditYear.getObject("AUDIT_YEAR")+strSelected1+">"+(String)objRsAuditYear.getObject("AUDIT_YEAR")+"</option>");
																}						             			
										             		}										             		
										             	%>
								                	</select> �⵵
				                					<%
														if(objSubmtRs.getTotalRecordCount() < 2){
													%>
													<%
														}else{													
													%>
														<select name="submtOrganId2" class="select_reqsubmit" onChange="javascript:doRefresh()">
															<option value="">��ü</option>
															<%
																while(objSubmtRs.next()){
															%>
																<option value="<%=objSubmtRs.getObject("ORGAN_ID")%>" 
																<%
																 if(strSubmtOrganId.equals(objSubmtRs.getObject("ORGAN_ID"))){
																%>
																	selected
																<%
																}%>
																><%=objSubmtRs.getObject("ORGAN_NM")%></option>
															<%}%>
														</select>
													<%
														}	
													%>
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
								                	</select> ��Ϻ���													
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
					<input type="hidden" name="ReturnURL" value="/reqsubmit/10_mem/20_reqboxsh/15_make/SMakeOpReqBoxList.jsp">
					
					<table width="759" border="0" cellspacing="0" cellpadding="0">
                    	<tr> 
                      		<td height="2" colspan="6" class="td_reqsubmit"></td>
	                    </tr>
    	                <tr align="center" class="td_top"> 
            	          	<td width="39" height="22" align="center"><input type="checkbox" name="checkAll" onClick="javascript:checkAllOrNot(document.listqry)"></td>
							<td width="80" height="22"><%=SortingUtil.getSortLink("changeSortQuery", "RLTD_DUTY", strReqBoxSortField, strReqBoxSortMtd, "��������")%></td>
	                	    <td width="340" height="22"><%=SortingUtil.getSortLink("changeSortQuery", "REQ_BOX_NM", strReqBoxSortField, strReqBoxSortMtd, "�䱸�ڷ�")%></td>
                    	  	<td width="120" height="22"><%=SortingUtil.getSortLink("changeSortQuery", "REQ_ORGAN_NM", strReqBoxSortField, strReqBoxSortMtd, "�䱸���")%></td>
	                      	
    	                  	<td width="70" height="22"><%=SortingUtil.getSortLink("changeSortQuery", "REG_DT", strReqBoxSortField, strReqBoxSortMtd, "����Ͻ�")%></td>
        	              	<td width="80" height="22">�亯�߼�</td>
            	        </tr>
                	    <tr> 
                    	  	<td height="1" colspan="6" class="td_reqsubmit"></td>
                    	</tr>
                    	<%
                    		int intRecordNumber = intTotalRecordCount - ((intCurrentPageNum -1) * Integer.parseInt((String)paramForm.getParamValue("ReqBoxPageSize")));
							if(rsHelper.getRecordSize() > 0) {
								String strReqBoxID = "";
								String strFstQryDt = "";
							  	while(rsHelper.next()) {
							  		strReqBoxID = (String)rsHelper.getObject("REQ_BOX_ID");
									strFstQryDt = (String)rsHelper.getObject("FST_QRY_DT");
							  		//Hashtable countHash = (Hashtable)selfDelegate.getReqBoxRelateCount(strReqBoxID);
						%>
	                    <tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''"> 
        	              	<td width="39" align="center"><input type="checkbox" name="ReqBoxID" value="<%=strReqBoxID%>"></td>
							<td width="80" align="center"><%= objCdinfo.getRelatedDuty((String)rsHelper.getObject("RLTD_DUTY")) %></td>
            	          	<td width="340" class="td_lmagin" style="padding-left:5px"><%if(strFstQryDt.equals("")||strFstQryDt == null){%><b><%}%><a href="javascript:gotoDetail('<%=strReqBoxID%>')"><%= (String)rsHelper.getObject("REQ_BOX_NM") %></a><%if(strFstQryDt.equals("")||strFstQryDt == null){%></b><%}%></td>
                	      	<td width="150" class="td_lmagin"><%= (String)rsHelper.getObject("REQ_ORGAN_NM") %></td>
                    	  	
                      		<td width="70" align="right" style="padding-top:2px;padding-bottom:2px"><%= StringUtil.getDate2((String)rsHelper.getObject("REG_DT")) %></td>
	                      	<td width="80" align="center"><img src="/image/reqsubmit/bt_sendAnswer7.gif" style="cursor:hand" onclick="javascript:sendAnsDoc('<%=strReqBoxID%>')"></td>
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
							<td colspan="6" height="40" align="center">��ϵ� �䱸�ڷᰡ �����ϴ�.</td>
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
								<img src="/image/reqsubmit/reqreg.gif" style="cursor:hand" onClick="javascript:AllInOne();" alt="�������ο䱸 �����ڷḦ ����մϴ�." align="absmiddle">
								&nbsp;&nbsp;
								<img src="/image/reqsubmit/reqdel.gif" style="cursor:hand" onClick="javascript:doDelete();" alt="�������ο䱸 �����ڷḦ �����մϴ�." align="absmiddle">
                      			
                      		</td>
                      		<td width="503" align="right" valign="middle">
                      			<!----------- �˻� �� ----------->								
                      			<% String strReqBoxQryField = paramForm.getParamValue("ReqBoxQryField"); %>
                      			<select name="ReqBoxQryField" class="select">
									<option <%=(strReqBoxQryField.equalsIgnoreCase("req_box_nm"))? " selected ": ""%>value="req_box_nm">�䱸�ڷ�</option>
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
