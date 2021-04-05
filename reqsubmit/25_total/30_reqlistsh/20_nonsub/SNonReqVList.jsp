<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.bf.config.*"%>
<%@ page import="kr.co.kcc.pf.util.PageCount"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.params.requestinfo.SMemReqInfoViewForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.SMemReqInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.answerinfo.AnsInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.SCommRequestBoxDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	UserInfoDelegate objUserInfo =null;
 	CDInfoDelegate objCdinfo =null;
%>

<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>

<%
	SMemReqInfoViewForm objParams = new SMemReqInfoViewForm();  
	SMemReqInfoDelegate objReqInfo = new SMemReqInfoDelegate();
	AnsInfoDelegate objAnsInfo = new AnsInfoDelegate();

  	boolean blnParamCheck = false;
  	blnParamCheck = objParams.validateParams(request);
  	if(blnParamCheck == false){
  		System.out.println("Param Check Error ");
  		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  		objMsgBean.setStrCode("DSPARAM-0000");
  		objMsgBean.setStrMsg(objParams.getStrErrors());
%>
  		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
  		return;
  	}

	String strReqSubmitFlag = objUserInfo.getReqSubmitFlag();
 	ResultSetSingleHelper objInfoRsSH = null;	/**�䱸 ���� �󼼺��� */
	ResultSetHelper objRs = null;				/** �亯���� ��� ���*/
	String strReqID = (String)objParams.getParamValue("ReqID");
	SCommRequestBoxDelegate objReqBox2 = null; 		/**�䱸�� Delegate*/
	ResultSetSingleHelper objRsSH2 = null;			/** �䱸�� �󼼺��� ���� */

	// 2004-06-04 
	String strAuditYear = (String)objParams.getParamValue("strAuditYear");
	String strReqBoxID = (String)objParams.getParamValue("ReqBoxID");
	String strReqOrganID = (String)objParams.getParamValue("ReqOrganID");
	System.out.println("strReqBoxID :"+strReqBoxID);
 	try{
		objReqBox2 = new SCommRequestBoxDelegate();
		objRsSH2 = new ResultSetSingleHelper(objReqBox2.getRecord(strReqBoxID, objUserInfo.getUserID()));

  		objInfoRsSH = new ResultSetSingleHelper(objReqInfo.getRecord(strReqID));
		objRs = new ResultSetHelper(objAnsInfo.getRecordList(strReqID));
	} catch(AppException objAppEx) {
		System.out.println("AppException : "+objAppEx.getMessage());
  		objAppEx.printStackTrace();
 		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  		objMsgBean.setStrCode(objAppEx.getStrErrCode());
  		objMsgBean.setStrMsg(objAppEx.getMessage());
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>  	
<%  	
  		return;
	}
%>

<html>
<head>
<title><%=MenuConstants.REQ_BOX_MAKE%> > <%=MenuConstants.REQ_BOX_DETAIL_VIEW%></title>
<link href="/css/System.css" rel="stylesheet" type="text/css">
<script language="javascript">

	/**�亯���� �󼼺���� ����.*/
	function gotoDetail(strID){
		var f = document.formName;
		f.target = "popup";
		f.action = "/reqsubmit/common/SAnsInfoView.jsp?AnsID="+strID;
		f.WinType.value = "POPUP";
		NewWindow('/blank.html', 'popup', '520', '400');
		f.submit();
	}

	/** ������� ���� */
	function gotoList(){
		var f = document.formName;  	
  		f.action="SNonReqList.jsp";
  		f.target = "";
  		f.submit();
	}

	// �߰� �亯 �ۼ� ȭ������ �̵�
	function gotoAddAnsInfoWrite() {
		f = document.formName;
  		f.ReqID.value = "<%= strReqID %>";
		f.target = "newpopup";		  
		f.action = "/reqsubmit/common/SAnsInfoWrite.jsp?AddAnsFlag=Y";
		var winl = (screen.width - 550) / 2;
		var winh = (screen.height - 350) / 2;
		window.open("/blank.html","newpopup","resizable=yes,menubar=no,status=no,titlebar=no, scrollbars=yes,location=no,toolbar=no,height=350,width=520, left="+winl+", top="+winh);
		f.submit();
	}
	
	// �亯 �ۼ� ȭ������ �̵�
  	function goSbmtReqForm() {
  		f = document.formName;
  		f.ReqID.value = "<%= strReqID %>";
		f.target = "newpopup";		  
		f.action = "/reqsubmit/common/SAnsInfoWrite.jsp";
		var winl = (screen.width - 550) / 2;
		var winh = (screen.height - 350) / 2;
		window.open("/blank.html","newpopup","resizable=yes,menubar=no,status=no,titlebar=no, scrollbars=yes,location=no,toolbar=no,height=350,width=520, left="+winl+", top="+winh);
		f.submit();
  	}
  	
  	// ���� �亯 ����
  	function selectDelete() {
  		var f = document.formName;
  		f.ReqID.value = "<%= strReqID %>";
  		f.target = "";
  		if (getCheckCount(f, "AnsID") < 1) {
  			alert("�ϳ� �̻��� üũ�ڽ��� ������ �ּ���");
  			return;
  		}
  		f.action = "/reqsubmit/common/SAnsInfoDelProc.jsp";
  		if (confirm("�����Ͻ� �亯���� �����Ͻðڽ��ϱ�?\n�ش� �亯���� �����ϸ� ���Ե� ���ϵ鵵 �ϰ� �����˴ϴ�.")) f.submit();
  	}

	function sbmtReq() {
		f = document.formName;
		f.target = "";
		f.action = "/reqsubmit/common/SReqSubmtDoneProc.jsp";
		if (confirm("���� �䱸�� ���� �亯 ������ �Ϸ��Ͻðڽ��ϱ�?")) f.submit();
	}

</script>
<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>
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
<form name="formName" method="post" action="<%=request.getRequestURI()%>"><!--�䱸�� �ű����� ���� -->
			<%
				//�䱸 ���� ���� ���� �ޱ�.
				String strReqInfoSortField=objParams.getParamValue("ReqInfoSortField");
				String strReqInfoSortMtd=objParams.getParamValue("ReqInfoSortMtd");
				//�䱸 ���� ������ ��ȣ �ޱ�.
				String strReqInfoPagNum=objParams.getParamValue("ReqInfoPage");					
		    %>
		    <input type="hidden" name="ReqBoxID" value="<%= objInfoRsSH.getObject("REQ_BOX_ID") %>">
		    <input type="hidden" name="ReqID" value="<%= strReqID %>">

		    <!-- 2004-06-04 �䱸���ID �� ����⵵ �Ķ���� ���� -->
		    <input type="hidden" name="ReqOrganID" value="<%= strReqOrganID %>">
		    <input type="hidden" name="AuditYear" value="<%= strAuditYear %>">
    
			<input type="hidden" name="ReqInfoSortField" value="<%=objParams.getParamValue("ReqInfoSortField")%>"><!--�䱸���� ��������ʵ� -->
			<input type="hidden" name="ReqInfoSortMtd" value="<%=objParams.getParamValue("ReqInfoSortMtd")%>"><!--�䱸���� ������ɹ��-->
			<input type="hidden" name="ReqInfoQryField" value="<%=objParams.getParamValue("ReqInfoQryField")%>"><!--�䱸���� ��ȸ �ʵ�-->
			<input type="hidden" name="ReqInfoQryTerm" value="<%=objParams.getParamValue("ReqInfoQryTerm")%>"><!--�䱸���� ��ȸ��-->
			<input type="hidden" name="ReqInfoPage" value="<%=objParams.getParamValue("ReqInfoPage")%>"><!--�䱸���� ������ ��ȣ -->
			<input type="hidden" name="ReqInfoID" value="<%=objParams.getParamValue("ReqID")%>"><!--�䱸���� ID-->
			<input type="hidden" name="AnsInfoID" value=""><!--�亯����ID -->
			<input type="hidden" name="ReqStt" value="<%=objInfoRsSH.getObject("REQ_STT")%>">
			
			<input type="hidden" name="WinType" value="SELF">

			<!-- 2004-06-08 kogaeng �����ϰ� ReturnURL�� ���߷Ⱦ���. -->
			<input type="hidden" name="ReturnURL" value="<%=request.getRequestURI()%>?ReqBoxID=<%= objInfoRsSH.getObject("REQ_BOX_ID") %>&ReqID=<%= strReqID %>">
             
            <tr> 
                <td height="23" align="left" valign="top"></td>
             </tr>
              <tr> 
                <td height="23" align="left" valign="top"><table width="100%" height="23" border="0" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="35%" background="/image/reqsubmit/bg_reqsubmit_tit.gif">
                      		<!-------------------- Ÿ��Ʋ�� �Է��� �ּ��� ------------------------>
                      		<span class="title"><%= MenuConstants.REQ_INFO_LIST_SUBMT_NONE %></span><strong>-<%=MenuConstants.REQ_INFO_DETAIL_VIEW%></strong>
                      </td>
                      <td width="6%" align="left" background="/image/common/bg_titLine.gif">&nbsp;</td>
                      <td width="59%" align="right" background="/image/common/bg_titLine.gif" class="text_s">
                      		<!-------------------- ���� ��ġ ������ ����Ѵ�ϴ�. ------------------------>
                      		<img src="/image/common/icon_navi.gif" width="3" height="5" align="absmiddle"> 
                        <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.getReqBoxGeneral(request)%> > <B><%=MenuConstants.REQ_INFO_LIST_SUBMT_NONE%></B>
                      </td>
                    </tr>
                  </table></td>
              </tr>
              <tr> 
                <td height="30" align="left" class="text_s">
                		<!-------------------- ���� �������� ���� ���� ��� ------------------------>
                		   ���� �亯 ������ �Ϸ���� ���� �䱸�� �� ������ ��ȸ�Ͻ� �� �ֽ��ϴ�.
                </td>
              </tr>
              <tr> 
                <td height="5" align="left" class="soti_reqsubmit"></td>
              </tr>
              <tr> 
                <td height="30" align="left" class="soti_reqsubmit">
                	<!-------------------- TAB �� �ش��ϴ� ������ ����ϴ� ��������. ------------------------>
                	<img src="/image/reqsubmit/icon_reqsubmit_soti.gif" width="9" height="9" align="absmiddle"> 
                  �䱸 ����
                </td>
              </tr>
              <tr> 
                <td align="left" valign="top" class="soti_reqsubmit">
                <!------------------------- TAB�� �ش��ϴ� ���̺�(����̵� ������̵� ��������) ��� ��~~~�� ------------------------->
                <table width="680" border="0" cellspacing="0" cellpadding="0">
                    <tr class="td_reqsubmit"> 
                      <td width="110" height="2"></td>
                      <td height="2" colspan="3" width="570"></td>
                    </tr>
                    
                    <tr> 
                      <td height="25" class="td_gray1"width="110"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        �䱸���� </td>
                      <td height="25" colspan="3" class="td_lmagin" width="570" style="padding-top:5px;padding-bottom:5px">
                      	<B><%=StringUtil.getDescString((String)objInfoRsSH.getObject("REQ_CONT"))%></B>
                      </td>
                    </tr>
                    <tr height="1" class="tbl-line"> 
                      <td height="1"></td>
                      <td height="1" colspan="3"></td>
                    </tr>                    
                    <tr> 
                      <td height="25" class="td_gray1" width="110"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        �䱸���� </td>
                      <td colspan="3" class="td_lmagin" width="570" style="padding-top:5px;padding-bottom:5px">
                      	<%=StringUtil.getDescString((String)objInfoRsSH.getObject("REQ_DTL_CONT"))%>
                      </td>
                    </tr>
                    <tr height="1" bgcolor="#d0d0d0"> 
                      <td height="1" colspan="4"></td>
                    </tr>   
                    <tr height="1" bgcolor="#ffffff"> 
                      <td height="1" colspan="4"></td>
                    </tr>   
                    <tr height="1" bgcolor="#d0d0d0"> 
                      <td height="1" colspan="4"></td>
                    </tr>   
                    
                    <tr> 
                      <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        �䱸�Ը� </td>
                      <td colspan="3" class="td_lmagin">
                      	<%=objInfoRsSH.getObject("REQ_BOX_NM")%>
                      </td>
                    </tr>
                    <tr height="1" class="tbl-line"> 
                      <td height="1"></td>
                      <td height="1" colspan="3"></td>
                    </tr>
                    <tr> 
                      <td width="110" height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        �䱸��� </td>
                      <td class="td_lmagin" width="230">
                      	<%=(String)objInfoRsSH.getObject("REQ_ORGAN_NM")%> (<%=(String)objInfoRsSH.getObject("USER_NM")%>)
                      </td> 
                      <td class="td_gray1" width="110"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        ������ </td>
                      <td class="td_lmagin" width="230">
                      	<%=(String)objInfoRsSH.getObject("SUBMT_ORGAN_NM")%>
                      </td>
                    </tr>
                    <tr height="1" class="tbl-line"> 
                      <td height="1"></td>
                      <td height="1" colspan="3"></td>
                    </tr>
                    
                    <tr> 
                      <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        ������� </td>
                      <td class="td_lmagin">
                      	<%= CodeConstants.getOpenClass((String)objInfoRsSH.getObject("OPEN_CL")) %>
                      </td>
                      <td class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        ÷������ </td>
                      <td height="25" class="td_lmagin" width="220">
                      	<%=StringUtil.makeAttachedFileLink((String)objInfoRsSH.getObject("ANS_ESTYLE_FILE_PATH"),(String)objInfoRsSH.getObject("REQ_ID"))%>
                      </td> 
                    </tr>
                    <tr height="1" class="tbl-line"> 
                      <td height="1"></td>
                      <td height="1" colspan="3"></td>
                    </tr>                                                         
                    <tr> 
                      <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        ������� </td>
                      <td class="td_lmagin">
                      	<%= StringUtil.getDate((String)objInfoRsSH.getObject("SUBMT_DLN")) %> 24:00
                      </td>
                      <td class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        �䱸���� </td>
                      <td class="td_lmagin">
                      	<%=StringUtil.getDate2((String)objInfoRsSH.getObject("REG_DT"))%>
                      </td> 
                    </tr>
                    <tr height="1" class="tbl-line"> 
                      <td height="1"></td>
                      <td height="1" colspan="3"></td>
                    </tr>                                                                             
                </table>
				<!------------------------- TAB�� �ش��ϴ� ���̺�(����̵� ������̵� ��������) ��� �� ------------------------->                   
                </td>
              </tr>
              <tr>
               	<!-- �����̽���ĭ -->
               	<td>&nbsp;</td>
               	<!-- �����̽���ĭ -->
              </tr>
              <tr>
               	<td>
               	 <table border="0">
               	   <tr>
               		 <td>
					<img src="/image/button/bt_viewReqHistory.gif"  height="20" border="0" onClick="viewReqHistory('<%= strReqID %>')" style="cursor:hand"  alt="���� �䱸�� ó�������� ���ں��� ��ȸ�մϴ�">
						<img src="/image/button/bt_listReqInfo.gif"  height="20" border="0" onClick="gotoList()" style="cursor:hand" alt="������ �䱸 ��� ��ȸ ȭ������ �̵��մϴ�.">
               		 </td>
               	   </tr>
               	</table>   
                </td>
              </tr>               
              <tr>
               	<!-- �����̽���ĭ -->
               	<td>&nbsp;</td>
               	<!-- �����̽���ĭ -->
              </tr>
              <tr> 
                <td height="30" class="soti_reqsubmit">
                	<!-------------------- TAB �� �ش��ϴ� ������ ����ϴ� ��������. ------------------------>
                	<table border="0" cellpadding="0" cellspacing="0" width="759">
                		<tr>
                			<td width="400" class="soti_reqsubmit">
                			   <img src="/image/reqsubmit/icon_reqsubmit_soti.gif" width="9" height="9" align="absmiddle"> 
                  				�亯 ���
				            </td>
				            <td width="359" align="right" valign="bottom" class="text_s">
				            	<!------------------------- COUNT (PAGE) ------------------------------------>
				            	&nbsp;&nbsp;<img src="/image/common/icon_nemo_gray.gif" width="3" height="6" align="absmiddle">
				            	��ü �ڷ� �� : <%= objRs.getRecordSize() %>�� &nbsp;&nbsp;
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
										<td align="center" width="20"><input type="checkbox" name="checkAll" value="" onClick="javascript:checkAllOrNot(this.form)"></td>
										<td height="22" width="39" align="center">NO</td>
										<td width="350" align="center">�����ǰ�</td>
										<td width="100" align="center">�ۼ���</td>
										<td width="60" align="center">����</td>
										<td width="120" align="center">�亯</td>
										<td width="70" align="center">�亯��</td>
									</tr>
	                    		</table>
	                    	</td>
	                    </tr>
                	    <tr> 
                    	  	<td height="1" class="td_reqsubmit"></td>
                    	</tr>
						<%
							int intRecordNumber=1;
						  	String strAnsInfoID="";
						  	if (objRs.getRecordSize() > 0) {
							  	while(objRs.next()){
							   		 strAnsInfoID = (String)objRs.getObject("ANS_ID");
						 %>								
						<tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''">
							<td>
								<table width="759" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td width="20" align="center"><input type="checkbox" name="AnsID" value="<%= strAnsInfoID %>"></td>
										<td height="22" width="39" align="center"><%=intRecordNumber%></td>
										<td width="350" class="td_lmagin"><a href="JavaScript:gotoDetail('<%=strAnsInfoID%>');"><%=StringUtil.substring((String)objRs.getObject("ANS_OPIN"),35)%></a></td>
										<td width="100" align="center"><%=(String)objRs.getObject("USER_NM")%></td>
										<td width="60" align="center"><%=CodeConstants.getOpenClass(((String)objRs.getObject("OPEN_CL")))%></td>
										<td width="120" align="center"><%=nads.lib.reqsubmit.util.DBAccessUtil.makeAnsInfoHtml(strAnsInfoID,(String)objRs.getObject("ANS_MTD"))%></td>
										<td width="70" align="right" style="padding-top:2px;padding-bottom:2px"><%=StringUtil.getDate2((String)objRs.getObject("ANS_DT"))%></td>
									</tr>
								</table>
							</td>
						</tr>
    	                <tr class="tbl-line"> 
                      		<td height="1"></td>
                    	</tr>       	
						<%
								    intRecordNumber ++;
								}//endwhile
							} else {
								out.println("<tr><td align='center' height='30'>��ϵ� �亯�� �����ϴ�.</td></tr>");
							}
						%>
    	                <tr class="tbl-line"> 
                      		<td height="1"></td>
                    	</tr>       	
	                </table>
	                <p>
	                <%
						String strReqStt = (String)objInfoRsSH.getObject("REQ_STT");
						if (CodeConstants.REQ_STT_NOT.equalsIgnoreCase(strReqStt)) {
					%>
							<img src="/image/button/bt_makeAnswer2.gif" border="0" onClick="javascript:javascript:goSbmtReqForm()" style="cursor:hand"  alt="�䱸�� ���� �亯�� �ۼ��մϴ�.">
					<% } else { %>
						<img src="/image/button/bt_registerAddAnswer.gif" border="0" onClick="javascript:javascript:gotoAddAnsInfoWrite()" style="cursor:hand" alt="�߰� �䱸�� ���� �亯�� ����մϴ�">
							<input type="hidden" name="AddAnsFlag" value="Y">
					<% } %>
					<img src="/image/button/bt_delSelect.gif" border="0" onClick="javascript:selectDelete()" style="cursor:hand" alt="���õ� �亯�� �����մϴ�.">
					<% 					
					if(!strReqSubmitFlag.equals("004") && !CodeConstants.REQ_STT_SUBMT.equalsIgnoreCase((String)objInfoRsSH.getObject("REQ_STT")) && objRs.getRecordSize() > 0) {
					%>
							<img src="/image/button/bt_reqEnd2.gif" border="0" onClick="javascript:sbmtReq()" style="cursor:hand" alt="�亯�� ��ϵ� �䱸�� ��� �䱸������� �����մϴ�.">
					<%
						}
					%>
				<p><br></p>
				<!------------------------- TAB�� �ش��ϴ� ���̺�(����̵� ������̵� ��������) ��� �� ------------------------->
				</td>
			  </tr>
</form>
          </table>
          </td>
        </tr>
    </table>
    <!--------------------------------------- �������  MAIN WORK AREA ���� �ڵ��� ���Դϴ�. ----------------------------->      
    </td>
  </tr>
</table>
<%@ include file="/common/Bottom.jsp" %>
</body>
</html>