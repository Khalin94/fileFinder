<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.bf.config.*"%>
<%@ page import="kr.co.kcc.pf.util.PageCount"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RMemReqBoxListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.MemRequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.RequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.cmtsubmt.*" %>

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
	String strDaeSuCh = null;

	/**�䱸�� �����ȸ�� �Ķ���� ����.*/
	RMemReqBoxListForm objParams=new RMemReqBoxListForm();
	/**�䱸��� ���� :: �Ҽ� ���.*/	
	objParams.setParamValue("ReqOrganID", objUserInfo.getOrganID());
	/**�䱸�� ����: �ۼ��� �䱸��.*/
	objParams.setParamValue("ReqBoxStt",CodeConstants.REQ_BOX_STT_006);
	if(!StringUtil.isAssigned(objParams.getParamValue("ReqBoxSortField"))) objParams.setParamValue("ReqBoxSortField", "LAST_REQ_DOC_SND_DT");
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
	String strDaesuInfo = StringUtil.getEmptyIfNull(request.getParameter("DaeSu"));
	strDaeSuCh = StringUtil.getEmptyIfNull(request.getParameter("DAESUCH"));

	/*************************************************************************************************/
	/** 					������ ȣ�� Part 														  */
	/*************************************************************************************************/
	
	/*** Delegate �� ������ Container��ü ���� */
	MemRequestBoxDelegate objReqBox=null; 		/**�䱸�� Delegate*/
	RequestBoxDelegate objReqBoxDelegate = null;
	
	// 2005-08-29 kogaeng ADD
	// �䱸�����ڵ������� üũ�ϱ� ���ؼ� �߰��Ǵ� Delegate
	CmtSubmtReqBoxDelegate objBean2 = null;
	 
	ResultSetHelper objRs=null;				/**�䱸�� ��� */
	ResultSetHelper objCmtRs=null;			/** ������ ����ȸ */
	ResultSetHelper objRltdDutyRs=null;   /** �������� ����Ʈ ��¿� RsHelper */
	ResultSetHelper objDaeRs=null;
	ResultSetHelper objYearRs=null;

	String strDaesu = null;
	String strStartdate = null;
	String strEnddate = null;

	try{
		/**�䱸�� ���� �븮�� New */
		objReqBox=new MemRequestBoxDelegate();
		objReqBoxDelegate = new RequestBoxDelegate();
		
		objBean2 = new CmtSubmtReqBoxDelegate();

		objDaeRs = new ResultSetHelper(objReqBoxDelegate.getOrganDaesu(objUserInfo.getOrganID()));
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

		System.out.println("TIMEMMMM1 : "+this.getCurrentTime());	
		objCmtRs=new ResultSetHelper(objReqBox.getReqrPerYearCMTDaeList(objUserInfo.getOrganID(), CodeConstants.REQ_BOX_STT_006,strStartdate,strEnddate,strSelectedAuditYear)); 
		objYearRs = new ResultSetHelper(objReqBox.getReqrPerYearDaeList(objUserInfo.getOrganID(), CodeConstants.REQ_BOX_STT_006,strStartdate,strEnddate));
		System.out.println("TIMEMMMM2 : "+this.getCurrentTime());

		objhashdata.put("START_DATE",strStartdate);
	    objhashdata.put("END_DATE",strEnddate);
		
		objRs=new ResultSetHelper(objReqBox.getRecordDaeList(objParams,objhashdata));
		System.out.println("TIMEMMMM3 : "+this.getCurrentTime());
		objRltdDutyRs=new ResultSetHelper(objCdinfo.getRelatedDutyList());
		System.out.println("TIMEMMMM4 : "+this.getCurrentTime());
	} catch(AppException objAppEx) {
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		objMsgBean.setStrCode(objAppEx.getStrErrCode());
		objMsgBean.setStrMsg(objAppEx.getMessage());
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%  	
		return;
	}

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
<title><%=MenuConstants.getReqBoxGeneral(request)%> > <%=MenuConstants.REQ_BOX_SEND_END%></title>
<link href="/css/System.css" rel="stylesheet" type="text/css">
<script language="javascript" src="/js/reqsubmit/common.js"></script>
<script language="javascript">
  
  /** ���Ĺ�� �ٲٱ� */
  function changeSortQuery(sortField,sortMethod){
  	formName.ReqBoxSortField.value=sortField;
  	formName.ReqBoxSortMtd.value=sortMethod;
	formName.DAESUCH.value = "N";
  	formName.submit();
  }
  
  //�䱸�Ի󼼺���� ����.
  function gotoDetail(strID, strCmtOrganID) {
  	formName.ReqBoxID.value = strID;
  	formName.CmtOrganID.value = strCmtOrganID;
  	formName.action="./RSendBoxVList.jsp";
  	formName.submit();
  }
  
  /** ����¡ �ٷΰ��� */
  function goPage(strPage){
  	formName.ReqBoxPage.value=strPage;
	formName.DAESUCH.value = "N";
  	formName.submit();
  }
  
  /**�⵵�� ����ȸ�θ� ��ȸ�ϱ� */
  function gotoHeadQuery(){
  	formName.ReqBoxQryField.value="";
  	formName.ReqBoxQryTerm.value="";
  	formName.ReqBoxSortField.value="";
  	formName.ReqBoxSortMtd.value="";
  	formName.ReqBoxPage.value="";
	formName.DAESUCH.value = "N";
  	formName.submit();
  }
  
	// 2005-07-18 ���õ� �䱸�� �ϰ� ����
	function doDelete() {
	  	if(getCheckCount(document.formName, "ReqBoxIDs") < 1) {
	  		alert("�����Ͻ� �ϳ� �̻��� �䱸���� ������ �ּ���.");
	  		return;
	  	}
	  	if(confirm("�����Ͻ� �䱸���� �ϰ� �����Ͻðڽ��ϱ�?\n\r\n\r1. ���Ե� ��� �䱸 ���뵵 �ϰ� �����˴ϴ�.\n\r2. �亯�� ���� ���� �䱸���� �������� �ʽ��ϴ�.")) {
	  		var w = 300;
	  		var h = 200;
			var winl = (screen.width - w) / 2;
			var winh = (screen.height - h) / 2;
			//document.all.loadingDiv.style.left = winl;
			//document.all.loadingDiv.style.top = winh;
			//document.all.loadingDiv.style.display = '';
			document.formName.action = "RSendBoxDelProc.jsp";
			document.formName.target = 'popwin';
			window.open('/blank.html', 'popwin', 'width='+w+', height='+h+', left='+winl+', top='+winh);
	  		document.formName.submit();
	  	}
	}  
			
	function changeDaesu(){
		formName.DAESUCH.value = "Y";
		formName.submit();
	}

	function doListRefresh() {
		var f = document.formName;
		f.target = "";
		f.submit();
	}
</script>
</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">

<DIV ID="loadingDiv" style="display:none;position:absolute;">
	<img src="/image/reqsubmit/loading.jpg" border="0"> </td>
</DIV>

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
		  <%//���� ���� �ޱ�.
			String strReqBoxSortField=objParams.getParamValue("ReqBoxSortField");
			String strReqBoxSortMtd=objParams.getParamValue("ReqBoxSortMtd");
		  %>
			<input type="hidden" name="ReqBoxSortField" value="<%=strReqBoxSortField%>"><!--�䱸�Ը�������ʵ� -->
			<input type="hidden" name="ReqBoxSortMtd" value="<%=strReqBoxSortMtd%>"><!--�䱸�Ը�����ɹ��-->
			<input type="hidden" name="ReqBoxPage" value="<%=intCurrentPageNum%>"><!--������ ��ȣ -->
			<input type="hidden" name="ReqBoxID" value=""><!--�䱸�Թ�ȣ �Ϲ������δ� ���ȵ�-->
			<input type="hidden" name="DAESUCH" value="">
              <tr> 
                <td height="23" align="left" valign="top"></td>
              </tr>
			  <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
				<h3><%=MenuConstants.REQ_BOX_SEND_END%></h3>
				<div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.getReqBoxGeneral(request)%> > <B><%=MenuConstants.REQ_BOX_SEND_END%></div>
				<p>���������� �߼��� �Ϸ��� �䱸�� ����Դϴ�.</p>
			  </div>

			  <div class="schBox">
				  <p>�䱸����ȸ����</p>
				  <span class="line"><img src="/images2/foundation/search_line.gif" width="172" height="3" /></span>
				  <div class="box"> 
					<!-- ������ �˻� ����Ʈ�� ��ư�� ��������-->
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
					<select name="AuditYear" class="select_reqsubmit" onChange="javascript:doListRefresh()">
						<option value="">��ü</option>
							<%
								if(objYearRs != null && objYearRs.getTotalRecordCount() > 0){
									while(objYearRs.next()){							
							%>
							<option value="<%=objYearRs.getObject("AUDIT_YEAR")%>" <%if(((String)objYearRs.getObject("AUDIT_YEAR")).equals(strSelectedAuditYear)){%>selected<%}%>><%=objYearRs.getObject("AUDIT_YEAR")%></option>
							<%
									}
								}
							%>
					</select>
					<select name="CmtOrganID" class="select_reqsubmit" onChange="javascript:doListRefresh()">
						<option value="">:::: ��ü����ȸ :::</option>
							<%
								if(objCmtRs != null && objCmtRs.getTotalRecordCount() > 0){
									while(objCmtRs.next()){							
							%>
							<option value="<%=objCmtRs.getObject("ORGAN_ID")%>" <%if(((String)objCmtRs.getObject("ORGAN_ID")).equals(strSelectedCmtOrganID)){%>selected<%}%>><%=objCmtRs.getObject("ORGAN_NM")%></option>
							<%
									}
								}
							%>
					</select>
					<select name="RltdDuty"  class="select_reqsubmit" onChange="this.form.submit()">
						<option value="">��������(��ü)</option>
							<%
							   /**�������� ����Ʈ ��� */
							   while(objRltdDutyRs!=null && objRltdDutyRs.next()){
						   		String strCode=(String)objRltdDutyRs.getObject("MSORT_CD");
						   		out.println("<option value=\"" + strCode + "\" " + StringUtil.getSelectedStr(strRltdDuty,strCode) + ">" + objRltdDutyRs.getObject("CD_NM") + "</option>");
							   }
							%>													
					</select>
					<a href="#"><img src="/images2/btn/bt_search2.gif" width="50" height="22" onClick="gotoHeadQuery();" /></a> 
				</div>
			  </div>
			  <span class="list_total">&bull;&nbsp;��ü�ڷ�� : <%=intTotalRecordCount%>�� (<%=intCurrentPageNum%> / <%=intTotalPage%> Page)</span>

              <tr> 
                <td align="left" valign="top" class="soti_reqsubmit">
                <!------------------------- TAB�� �ش��ϴ� ���̺�(����̵� ������̵� ��������) ��� ��~~~�� ------------------------->
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
					  <thead>
						<tr>
						  <th scope="col" style="width:15px;"><input type="checkbox" name="checkAll" onClick="javascript:checkAllOrNot(document.formName)"></th>
						  <th scope="col" style="width:250px; "><%=SortingUtil.getSortLink("changeSortQuery","REQ_BOX_NM",strReqBoxSortField,strReqBoxSortMtd,"�䱸�Ը�")%></th>
						  <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","SUBMT_ORGAN_NM",strReqBoxSortField,strReqBoxSortMtd,"������")%></th>
						  <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","RLTD_DUTY",strReqBoxSortField,strReqBoxSortMtd,"��������")%></th>
						  <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","REQ_BOX_STT",strReqBoxSortField,strReqBoxSortMtd,"�������")%></th>
						   <th scope="col">����䱸</th>
						  <th scope="col"><a href="#"><%=SortingUtil.getSortLink("changeSortQuery","LAST_REQ_DOC_SND_DT", strReqBoxSortField,strReqBoxSortMtd,"�߼��Ͻ�")%><img src="/images2/btn/bt_td.gif" width="11" height="11" alt="" /></a></th>
						</tr>
					  </thead>
					  <%
							  int intRecordNumber=intTotalRecordCount - ((intCurrentPageNum -1) * Integer.parseInt((String)objParams.getParamValue("ReqBoxPageSize")));
							  //int intRecordNumber=intTotalRecordCount;
							  if(objRs.getRecordSize()>0){
								 String strReqBoxID="";
							  while(objRs.next()){
								 strReqBoxID=(String)objRs.getObject("REQ_BOX_ID");
						%> 
					  <tbody>
						<tr>
						  <td ><input type="checkbox" name="ReqBoxIDs" value="<%= strReqBoxID %>"></td>
						  <td style="text-align:left;"><a href="javascript:gotoDetail('<%=strReqBoxID%>', '<%= objRs.getObject("CMT_ORGAN_ID") %>')"><%=(String)objRs.getObject("REQ_BOX_NM")%></a></td>
						  <td><%=(String)objRs.getObject("SUBMT_ORGAN_NM")%></td>
						  <td><%=objCdinfo.getRelatedDuty((String)objRs.getObject("RLTD_DUTY"))%></td>
						  <td><%=CodeConstants.getReqBoxStatus((String)objRs.getObject("REQ_BOX_STT"),true)%></td>
						  <td><%=objRs.getObject("SUBMT_CNT")%>/<%=objRs.getObject("REQ_CNT")%></td>
						  <td><%=StringUtil.getDate2((String)objRs.getObject("LAST_REQ_DOC_SND_DT"))%></td>
						</tr>
					  </tbody>
						<%
							intRecordNumber --;
								}//endwhile
							}else{
						%>
						<tbody>
							<tr><td></td>
								<td>��ϵ� <%=MenuConstants.REQ_BOX_SEND_END%>�� �����ϴ�.</td>
							</tr>
						</tbody>
						<%
							}//end if ��� ��� ��.
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
							<td width="503" align="left" valign="middle">
							<%
								String strReqBoxQryField=objParams.getParamValue("ReqBoxQryField");
							%>
								<select name="ReqBoxQryField" class="select">
									<option <%=(strReqBoxQryField.equalsIgnoreCase("req_box_nm"))? " selected ": ""%>value="req_box_nm">�䱸�Ը�</option>
									<option <%=(strReqBoxQryField.equalsIgnoreCase("req_box_dsc"))? " selected ": ""%>value="req_box_dsc">�䱸�Լ���</option>
									<option <%=(strReqBoxQryField.equalsIgnoreCase("submt_organ_nm"))? " selected ": ""%>value="submt_organ_nm">������</option>
								</select>
								<input type="text" class="textfield" name="ReqBoxQryTerm" value="<%=objParams.getParamValue("ReqBoxQryTerm")%>">
								<img src="/image/common/bt_search_table.gif" height="18" align="absmiddle" onClick="formName.submit();" style="cursor:hand">
							</td>
                      		<td width="256" height="40" align="right">
                      			<!-- ��ư�� �ʿ��ϴٸ� ���⿡ �߰��Ͻ� �˴ϴٿ� -->
                      			<img src="/image/button/bt_delReqBox.gif" border="0" style="cursor:hand" onClick="javascript:doDelete()" alt="������ �䱸���� �ϰ� �����մϴ�.">
                      			&nbsp;
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
<%
	System.out.println("TIMEMMMM5 : "+this.getCurrentTime());
%>
<%!
	public String getCurrentTime() {
        Calendar oCalendar = Calendar.getInstance();  
		String serverDate = oCalendar.get(Calendar.YEAR) + "/" +(oCalendar.get(Calendar.MONTH) + 1)+"/"+ oCalendar.get(Calendar.DAY_OF_MONTH)+"  "+oCalendar.get(Calendar.HOUR_OF_DAY)+":"+oCalendar.get(Calendar.MINUTE)+":"+oCalendar.get(Calendar.SECOND)+":"+oCalendar.get(Calendar.MILLISECOND);
		 return serverDate;
     }

%>
