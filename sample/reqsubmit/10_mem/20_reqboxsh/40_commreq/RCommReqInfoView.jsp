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
<%@ page import="nads.lib.reqsubmit.params.cmtsubmt.CmtSubmtReqBoxVListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.cmtsubmt.CmtSubmtReqInfoDelegate" %>

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
	
	/**�Ϲ� �䱸 �󼼺��� �Ķ���� ����.*/
	CmtSubmtReqBoxVListForm objParams =new CmtSubmtReqBoxVListForm();  
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

	/*************************************************************************************************/
	/** 					������ ȣ�� Part 														  */
	/*************************************************************************************************/
	
	/*** Delegate �� ������ Container��ü ���� */
	CmtSubmtReqInfoDelegate  objReqInfo=null;	/** �䱸���� Delegate */
	ResultSetSingleHelper objInfoRsSH=null;		/**�䱸 ���� �󼼺��� */
	 
	ResultSetHelper objRs = null;
 
	try{
		/**�䱸 ���� �븮�� New */    
		objReqInfo=new CmtSubmtReqInfoDelegate();
		/**�䱸���� �̿� ���� üũ */
		boolean blnHashAuth=objReqInfo.checkReqInfoAuth((String)objParams.getParamValue("ReqInfoID"),objUserInfo.getOrganID()).booleanValue(); 
		if(!blnHashAuth){
			objMsgBean.setMsgType(MessageBean.TYPE_WARN);
			objMsgBean.setStrCode("DSAUTH-0001");
			objMsgBean.setStrMsg("�ش� �䱸������  �� ������ �����ϴ�.");
%>
			<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
			return;
		}else{
			objInfoRsSH=new ResultSetSingleHelper(objReqInfo.getRecord((String)objParams.getParamValue("ReqInfoID")));
			objRs = new ResultSetHelper(objReqInfo.getRecordListToAnsInfo((String)objParams.getParamValue("ReqInfoID")));
		}/**���� endif*/
	}catch(AppException objAppEx){
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		System.out.println("SysErrorCode:" + objAppEx.getStrErrCode());
		objMsgBean.setStrCode("SYS-00010");//AppException����.
		objMsgBean.setStrMsg(objAppEx.getMessage());
		//out.println("<br>Error!!!" + objAppEx.getMessage());
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%  	
		return;
	}
%>

<html>
<head>
<title><%=MenuConstants.REQ_BOK_COMM_REQ%> > <%=MenuConstants.REQ_BOX_DETAIL_VIEW%></title>
<link href="/css/System.css" rel="stylesheet" type="text/css">
<script language="javascript">
  /**�䱸���� ������������ ����.*/
  function gotoEditPage(){
  	formName.action="./RCommReqInfoEdit.jsp";
  	formName.submit();
  }
  /**�䱸 ���� ���� */
  function gotoDeletePage(){
  	if(confirm('�����Ͻ� �䱸������ �����Ͻðڽ��ϱ�?')){
	  	formName.action="./RCommReqInfoDelProc.jsp";
  		formName.submit();  	
  	}
  }
  /** ������� ���� */
  function gotoList(){
  	formName.action="./RCommReqVList.jsp";
  	formName.submit();
  }
</script>
<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>
</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
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
          <form name="formName" method="<%=nads.lib.reqsubmit.EnvConstants.FORM_METHOD%>" action="<%=request.getRequestURI()%>"><!--�䱸�� �ű����� ���� -->
			<%//�䱸�� ���� ���� �ޱ�.
			String strReqBoxSortField=objParams.getParamValue("ReqBoxSortField");
			String strReqBoxSortMtd=objParams.getParamValue("ReqBoxSortMtd");
			//�䱸�� ������ ��ȣ �ޱ�.
			String strReqBoxPagNum=objParams.getParamValue("ReqBoxPage");
			//�䱸�� ��ȸ���� �ޱ�.
			String strReqBoxQryField=objParams.getParamValue("ReqBoxQryField");
			String strReqBoxQryTerm=objParams.getParamValue("ReqBoxQryTerm");
			//�䱸 ���� ���� ���� �ޱ�.
			String strReqInfoSortField=objParams.getParamValue("ReqInfoSortField");
			String strReqInfoSortMtd=objParams.getParamValue("ReqInfoSortMtd");
			//�䱸 ���� ������ ��ȣ �ޱ�.
			String strReqInfoPagNum=objParams.getParamValue("ReqInfoPage");					
		    %>
		     <%=objParams.getHiddenFormTags()%>
              <tr> 
                <td height="23" align="left" valign="top"></td>
              </tr>
              <tr> 
                <td height="23" align="left" valign="top"><table width="100%" height="23" border="0" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="35%" background="/image/reqsubmit/bg_reqsubmit_tit.gif">
                      		<!-------------------- Ÿ��Ʋ�� �Է��� �ּ��� ------------------------>
                      		<span class="title"><%=MenuConstants.REQ_BOK_COMM_REQ%></span><strong>-<%=MenuConstants.REQ_INFO_DETAIL_VIEW%></strong>
                      </td>
                      <td width="6%" align="left" background="/image/common/bg_titLine.gif">&nbsp;</td>
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
                		����ȸ �����û���� �䱸������ Ȯ���ϴ� ȭ���Դϴ�.
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
                      <td height="2" colspan="4"></td>
                    </tr>
                    
                    <tr> 
                      <td width="100" height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        �䱸���� </td>
                      <td width="580" colspan="3" class="td_lmagin">
                      	<B><%=StringUtil.getDescString((String)objInfoRsSH.getObject("REQ_CONT"))%></B>
                      </td>
                    </tr>
                    <tr height="1" class="tbl-line"> 
                      <td height="1" colspan="4"></td>
                    </tr>                    
                    <tr> 
                      <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        �䱸���� </td>
                      <td height="25" colspan="3" class="td_lmagin" style="padding-top:4px;padding-bottom:4px">
                      	<%=StringUtil.getDescString((String)objInfoRsSH.getObject("REQ_DTL_CONT"))%>
                      </td>
                    </tr>
                    <tr height="1" bgcolor="#d0d0d0"> 
                      <td height="1"></td>
                      <td height="1" colspan="3"></td>
                    </tr>
                    <tr height="1" bgcolor="#ffffff"> 
                      <td height="1"></td>
                      <td height="1" colspan="3"></td>
                    </tr>
                    <tr height="1" bgcolor="#d0d0d0"> 
                      <td height="1"></td>
                      <td height="1" colspan="3"></td>
                    </tr>
                    
                    <tr> 
                      <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        �Ұ� ����ȸ </td>
                      <td height="25" colspan="3" class="td_lmagin">
                      	<%=objInfoRsSH.getObject("CMT_ORGAN_NM")%>
                      </td>
                    </tr>
                    <tr height="1" class="tbl-line"> 
                      <td height="1" colspan="4"></td>
                    </tr>              
                    <tr> 
                      <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        ��û�Ը� </td>
                      <td height="25" colspan="3" class="td_lmagin">
                      	<%=objInfoRsSH.getObject("CMT_SUBMT_REQ_BOX_NM")%>
                      </td>
                    </tr>
                    <tr height="1" class="tbl-line"> 
                      <td height="1" colspan="4"></td>
                    </tr>
                    <tr> 
                      <td width="100" height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        ��û��� </td>
                      <td height="25" width="240" class="td_lmagin">
                      	<%=(String)objInfoRsSH.getObject("REQ_ORGAN_NM")%>
                      </td> 
                      <td height="25" width="100" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        ������ </td>
                      <td height="25" width="240" class="td_lmagin">
                      	<%=(String)objInfoRsSH.getObject("SUBMT_ORGAN_NM")%>
                      </td>
                    </tr>
                    <tr height="1" class="tbl-line"> 
                      <td height="1" colspan="4"></td>
                    </tr>
                    
                    <tr> 
                      <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        ������� </td>
                      <td height="25" class="td_lmagin">
                      	<%=CodeConstants.getOpenClass((String)objInfoRsSH.getObject("OPEN_CL"))%>
                      </td>
                      <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        ����������</td>
                      <td height="25" class="td_lmagin">
                      	<%=StringUtil.makeAttachedFileLink((String)objInfoRsSH.getObject("ANS_ESTYLE_FILE_PATH"),(String)objInfoRsSH.getObject("REQ_ID"))%>
                      </td> 
                    </tr>
                    <tr height="1" class="tbl-line"> 
                      <td height="1" colspan="4"></td>
                    </tr>                                                         
                    <tr> 
                      <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        ����� </td>
                      <td height="25" class="td_lmagin">
                      	<%=(String)objInfoRsSH.getObject("REGR_NM")%>
                      </td>
                      <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        ������� </td>
                      <td height="25" class="td_lmagin">
                      	<%=StringUtil.getDate2((String)objInfoRsSH.getObject("REG_DT"))%>
                      </td> 
                    </tr>
                    <tr height="2" class="tbl-line"> 
                      <td height="2" colspan="4"></td>
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
               	<!----------------------- ���� ��ҵ� Form���� ��ư ���� ------------------------->
               	    <%
					  //��û�� ���� ����.
					  String strReqBoxStt=(String)objInfoRsSH.getObject("STT");                    
					%>
               	
               	 <table>
               	   <tr>
               		 <td>
						<%
							// 2005-09-26 kogaeng EDIT
							//��û�Ի��°� �ۼ���(001), ��Ŵ��(002), ����ȸ�䱸����(009)
							if(strReqBoxStt.equals(CodeConstants.CMT_SUBMT_REQ_BOX_STT_001) || strReqBoxStt.equals(CodeConstants.CMT_SUBMT_REQ_BOX_STT_002) || strReqBoxStt.equals(CodeConstants.CMT_SUBMT_REQ_BOX_STT_009)){
						%>
						  <%
							/** ����ڿ�  �α����ڰ� �������� ȭ�鿡 �����.*/
							if(objUserInfo.getUserID().equals((String)objInfoRsSH.getObject("REGR_ID"))){
						  %>
						<img src="/image/button/bt_modifyReq.gif"  height="20" border="0" onClick="gotoEditPage()" style="cursor:hand">
						<img src="/image/button/bt_delReq.gif"  height="20" border="0" onClick="gotoDeletePage()" style="cursor:hand">
						  <%
							}//endif
						  %>												
					    <%	
						}//end if
						%>
						<img src="/image/button/bt_viewAppBox.gif"  height="20" border="0" onClick="gotoList()" style="cursor:hand">
               		 </td>
               	   </tr>
               	</table>   
               	<!----------------------- ���� ��ҵ� Form���� ��ư �� ------------------------->               	   
                </td>
              </tr>               
              <tr> 
				<td width="759" align="center">
					<table border="0" cellpadding="0" cellspacing="0">
						<tr>
						    <td width="400" height="30" align="left" class="soti_reqsubmit">
			                	<!	-------------------- TAB �� �ش��ϴ� ������ ����ϴ� ��������. ------------------------>
			                	<img src="/image/reqsubmit/icon_reqsubmit_soti.gif" width="9" height="9" align="absmiddle"> 
			                  �亯 ����
			                </td>
							<td width="359" align="right" valign="bottom" class="text_s">
				            	<!------------------------- COUNT (PAGE) ------------------------------------>
						    	&nbsp;&nbsp;<img src="/image/common/icon_nemo_gray.gif" width="3" height="6" align="absmiddle">
				            	��ü �ڷ� �� : <%= objRs.getRecordSize() %> ��&nbsp;&nbsp;
				            </td>
						</tr>
					</table>
				</td>
              </tr>
              <tr>
              
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
										<td height="22" width="19" align="center">NO</td>
										<td width="350" align="center">�����ǰ�</td>
										<td width="100" align="center">�ۼ���</td>
										<td width="80" align="center">����</td>
										<td width="120" align="center">�亯</td>
										<td width="90" align="center">�亯����</td>
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
						  if(objRs.getRecordSize() > 0) {
						  while(objRs.next()){
						   	 strAnsInfoID=(String)objRs.getObject("ANS_ID");
						 %>								
						<tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''">
							<td>
								<table width="759" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td height="22" width="19" align="center"><%=intRecordNumber%></td>
										<td width="350" class="td_lmagin"><a href="JavaScript:gotoAnsInfoView('<%=strAnsInfoID%>');"><%=StringUtil.substring((String)objRs.getObject("ANS_OPIN"),35)%></a></td>
										<td width="100" align="center"><%=(String)objRs.getObject("USER_NM")%></td>
										<td width="80" align="center"><%=CodeConstants.getOpenClass(((String)objRs.getObject("OPEN_CL")))%></td>
										<td width="120" align="center"><%=nads.lib.reqsubmit.util.DBAccessUtil.makeAnsInfoHtml(strAnsInfoID,(String)objRs.getObject("ANS_MTD"))%></td>
										<td width="90" align="center"><%=StringUtil.getDate((String)objRs.getObject("ANS_DT"))%></td>
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
						%>
						<tr>
							<td height="35" align="center">����� �亯�� �����ϴ�</td>
						</tr>
						<%
							}
						%>
    	                <tr class="tbl-line"> 
                      		<td height="1"></td>
                    	</tr>      
					</table>
				</td>
				</tr>
              
               	<!-- �����̽���ĭ -->
               	<td>&nbsp;</td>
               	<!-- �����̽���ĭ -->
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
