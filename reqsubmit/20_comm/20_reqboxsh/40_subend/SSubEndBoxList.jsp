<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.pf.util.PageCount"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.params.requestbox.SCommReqBoxListFormNew" %>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.SCommRequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.RequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.common.page.PagingDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%
	/*** PagingDelegate */
	PagingDelegate objPaging=new PagingDelegate(); 		/*����¡ ��ȯ Delegate*/
%>
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

	/**���õ� ����⵵�� ���õ� ����ȸID*/
	String strSelectedAuditYear= null; /**���õ� ����⵵*/
	String strSelectedCmtOrganID=null; /**���õ� ����ȸID*/
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

	/**����ȸ�����ȸ�� �Ķ���� ����.*/
	SCommReqBoxListFormNew objParams=new SCommReqBoxListFormNew();
	//�䱸��� ���� :: �Ҽ� ���.
	objParams.setParamValue("SubmtOrganID",strOrganId);
	//����ȸ �䱸����������� : �����Ϸ�
	objParams.setParamValue("IngStt",CodeConstants.REQ_ING_STT_002);
	//�䱸�� ���� : �߼ۿϷ�
	objParams.setParamValue("ReqBoxStt",CodeConstants.REQ_BOX_STT_007);

	boolean blnParamCheck=false;
	/**���޵� �ĸ����� üũ */
	blnParamCheck=objParams.validateParams(request);
	if(blnParamCheck==false) {
	  	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
	  	objMsgBean.setStrCode("DSPARAM-0000");
	  	objMsgBean.setStrMsg(objParams.getStrErrors());
%>
  		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
  		return;
	}//endif

	strSelectedAuditYear= objParams.getParamValue("AuditYear"); 	/**���õ� ����⵵*/
	strSelectedCmtOrganID=objParams.getParamValue("CmtOrganID") ; /**���õ� ����ȸID*/

	//�ش�����ȸ�� �������.. �����޼��� ���..
	if(objUserInfo.getCurrentCMTList().isEmpty()){
	  	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
	  	objMsgBean.setStrCode("DSDATA-0021");
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
  		return;
	}//endif

	//�䱸�� ��ü ��Delegate �����.
	SCommRequestBoxDelegate objReqBox = null;
	RequestBoxDelegate objReqBoxDelegate = null;

	ResultSetHelper objCmtRs=null;			/** ������ ����ȸ */
	ResultSetHelper objRs=null;			/** ����ȸ �䱸�� ��� */
	ResultSetSingleHelper objRsSH = null;			/** �䱸�� �󼼺��� ���� */
	ResultSetHelper objDaeRs=null;
	ResultSetHelper objSubmtRs=null;
	ResultSetHelper objYearRs=null;

	try {
	 	objReqBox=new SCommRequestBoxDelegate();
		objReqBoxDelegate = new RequestBoxDelegate();

		objDaeRs = new ResultSetHelper(objReqBoxDelegate.getOrganDaesu(strOrganId));
		List lst = (List)objReqBoxDelegate.getSubmtOrganList(objUserInfo.getOrganID());
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

	 	objCmtRs = new ResultSetHelper(objReqBox.getCmtOrganDaeList(objParams,objhashdata));
		objYearRs =  new ResultSetHelper(objReqBox.getAuditYearDaeList(lst,strSubmtOrganId,strStartdate,strEnddate,CodeConstants.REQ_BOX_STT_007));
		objRs=new ResultSetHelper(objReqBox.getRecordDaeList(objParams,objhashdata));
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

<jsp:include page="/inc/header.jsp" flush="true"/>
<link href="/css2/style.css" rel="stylesheet" type="text/css">
<script language="javascript">
  /** ���� ��ȭ�� ���� ����ȸ ����Ʈ ��ȭ */
  function changeCmtList(){
    makePerYearCmtList(listqry.AuditYear.options[listqry.AuditYear.selectedIndex].value);
  }

  /** ���Ĺ�� �ٲٱ� */
  function changeSortQuery(sortField,sortMethod){
  	listqry.ReqBoxSortField.value=sortField;
  	listqry.ReqBoxSortMtd.value=sortMethod;
	listqry.DAESUCH.value = "N";
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
	listqry.DAESUCH.value = "N";
  	listqry.submit();
  }

  /**�⵵�� ����ȸ�θ� ��ȸ�ϱ� */
  function gotoHeadQuery(){
  	listqry.ReqBoxQryField.value="";
  	listqry.ReqBoxQryTerm.value="";
  	listqry.ReqBoxSortField.value="";
  	listqry.ReqBoxSortMtd.value="";
  	listqry.ReqBoxPage.value="";
	listqry.DAESUCH.value = "N";
  	listqry.submit();
  }

  function changeDaesu(){
	form = document.listqry;
	form.target = '';
	form.DAESUCH.value = "Y";
	form.submit();
 }

 function doRefresh() {
	var f = document.listqry;
	f.DAESUCH.value = "N";
	f.target = "";
	f.submit();
}
</script>
</head>

<body>
<div id="wrap">
<SCRIPT language="JavaScript" src="/js2/reqsubmit/tooltip.js"></SCRIPT>
<script language="javascript">balloonHint("balloonHint")</script>
	<jsp:include page="/inc/top.jsp" flush="true"/>
	<jsp:include page="/inc/top_menu02.jsp" flush="true"/>
  <div id="container">
    <div id="leftCon">
      <jsp:include page="/inc/log_info.jsp" flush="true"/>
      <jsp:include page="/inc/left_menu02.jsp" flush="true"/>
    </div>
    <div id="rightCon">
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
	<input type="hidden" name="DAESUCH" value="">
      <!-- pgTit -->
      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=MenuConstants.COMM_REQ_BOX_SUBMT_END%> - �䱸�� ���</h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" />  <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.REQUEST_BOX_COMM%> > <%=MenuConstants.COMM_REQ_BOX_SUBMT_END%></div>
        <p><!--����--></p>
      </div>
      <!-- /pgTit -->

      <!-- contents -->

      <div id="contents">
<form name="listqry" method="post" action="<%=request.getRequestURI()%>" style="margin:0px">
			<input type="hidden" name="DAESUCH" value="">
        <!-- �˻����� ���� ��� �Ʒ� div ���� �� �ּ����� ��������.-->
        <div class="schBox">
          <p>�䱸����ȸ����</p>
          <span class="line"><img src="/images2/foundation/search_line.gif" width="172" height="3" /></span>
          <div class="box">
            <!-- ������ �˻� ����Ʈ�� ��ư�� ��������-->
            <select onChange="changeDaesu()" name="DaeSu">
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
            <select onChange="javascript:doRefresh()" name="AuditYear">
			<option value="">��ü</option>
				<%
					if(objYearRs != null && objYearRs.getTotalRecordCount() > 0){
						while(objYearRs.next()){
					%>
						<option value="<%=objYearRs.getObject("AUDIT_YEAR")%>" <%if(((String)objYearRs.getObject("AUDIT_YEAR")).equals(strSelectedAuditYear)){%>selected<%}%>><%=objYearRs.getObject("AUDIT_YEAR")%>
				</option>
					<%
						}
					}
				%>
            </select>
			<%
                if(objSubmtRs.getTotalRecordCount() < 2){
            %>
            <%
                }else{
            %>
                <select name="submtOrganId2" onChange="javascript:doRefresh()">
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
            <select name ="CmtOrganID" onChange="javascript:doRefresh()">
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
            <a href="javascript:gotoHeadQuery();"><img src="/images2/btn/bt_search2.gif" width="50" height="22" /></a> </div>
        </div>
        <!-- /�˻�����-->

        <!-- �������� ���� -->

        <!-- list -->

        <span class="list_total">&bull;&nbsp;��ü�ڷ�� : <%=intTotalRecordCount%>�� (<%=intCurrentPageNum%> / <%=intTotalPage%> page)</span>


        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
          <thead>
            <tr>
              <th scope="col"><a>NO</a></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","REQ_BOX_NM",strReqBoxSortField,strReqBoxSortMtd,"�䱸�Ը�")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","REQ_ORGAN_NM", strReqBoxSortField, strReqBoxSortMtd, "�Ұ�����ȸ")%><BR><%=SortingUtil.getSortLink("changeSortQuery","OLD_REQ_ORGAN_NM", strReqBoxSortField, strReqBoxSortMtd, "(�ǿ���)")%></th>
              <th scope="col"><a>����/�䱸</a></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","LAST_REQ_DOC_SND_DT", strReqBoxSortField, strReqBoxSortMtd, "�䱸�Ͻ�")%></th>
               <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","LAST_ANS_DOC_SND_DT", strReqBoxSortField, strReqBoxSortMtd, "�亯�Ͻ�")%></th>
            </tr>
          </thead>
          <tbody>
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
            <tr>
              <td><%= intRecordNumber %></td>
              <td><a href="javascript:gotoDetail('<%=strReqBoxID%>')"><%=(String)objRs.getObject("REQ_BOX_NM")%></a></td>
              <td>
			  <%=objRs.getObject("REQ_ORGAN_NM")%><BR>(<%=objRsSH.getObject("OLD_REQ_ORGAN_NM")%>)
			  </td>
              <td><%=(String)objRs.getObject("SUBMT_CNT")%> / <%=(String)objRs.getObject("REQ_CNT")%></td>
              <td><%=StringUtil.getDate2((String)objRs.getObject("LAST_REQ_DOC_SND_DT"))%></td>
              <td><%=StringUtil.getDate2((String)objRs.getObject("LAST_ANS_DOC_SND_DT"))%></td>
            </tr>
				<%
						intRecordNumber --;
					}//endwhile
					%>
			<input type="hidden" name="RecordNumber" value="<%=intRecordNumber%>">
			<%
				} else {
				%>
			<tr>
				<td colspan="6" align="center">��ϵ� �䱸�ڷᰡ �����ϴ�.</td>
			</tr>
				<%
					} // end if
				%>
          </tbody>
        </table>

        <!-- /list -->
					<%=objPaging.pagingTrans(PageCount.getLinkedString(
						new Integer(intTotalRecordCount).toString(),
						new Integer(intCurrentPageNum).toString(),
						objParams.getParamValue("ReqBoxPageSize")))
					%>
        <!-- ����¡-->
         <!-- /����¡-->
        <!--  <p class="warning">* �䱸���� �߼��ϰ� �Ǹ� �ش� ���� ��� ��ǥ ����ڿ��� ���� �߼۵Ǹ�, ����ڰ� ���� ���� �ۼ� �� �䱸�Կ� �״�� �����ְ� �˴ϴ�.  </p>
          <p class="warning">* �䱸�� �߼� ��ư�� �̿��Ͻñ� ���ؼ��� ����ȸ�� ������ �ֽñ� �ٶ��ϴ�.  </p>  -->



        <!-- ����Ʈ ��ư-->
        <div id="btn_all" >        <!-- ����Ʈ �� �˻� -->
        <div class="list_ser" >
		<%
		String strReqBoxQryField=objParams.getParamValue("ReqBoxQryField");
		%>
          <select name="ReqBoxQryField" class="selectBox5"  style="width:70px;" >
			<option <%=(strReqBoxQryField.equalsIgnoreCase("req_box_nm"))? " selected ": ""%>value="req_box_nm">�䱸�Ը�</option>
			<option <%=(strReqBoxQryField.equalsIgnoreCase("req_box_dsc"))? " selected ": ""%>value="req_box_dsc">�䱸�Լ���</option>
			<option <%=(strReqBoxQryField.equalsIgnoreCase("req_organ_nm"))? " selected ": ""%>value="req_organ_nm">�䱸���</option>
          </select>
          <input name="ReqBoxQryTerm" onKeyDown="return ch()" onMouseDown="return ch()"
		 class="li_input"  style="width:100px" value="<%=objParams.getParamValue("ReqBoxQryTerm")%>"/>
          <img src="/images2/btn/bt_list_search.gif"  onMouseOver="menuOn(this);" onMouseOut="menuOut(this);" onClick="listqry.submit()"/> </div>
        <!-- /����Ʈ �� �˻� -->
		</div>

        <!-- /����Ʈ ��ư-->

        <!-- /�������� ���� -->
      </div>
      <!-- /contents -->
</form>
    </div>
  </div>
  <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>