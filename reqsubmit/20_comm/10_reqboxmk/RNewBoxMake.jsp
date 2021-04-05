<%@ page language="java" contentType="text/html;charset=euc-kr" %>

<%@ page import="java.util.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="kr.co.kcc.pf.util.PageCount"%>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.MemRequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.commreqsch.CommMakeBoxDelegate" %>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.params.cmtreqsch.CmtReqSchForm" %>
<%@ page import="nads.dsdm.app.common.page.PagingDelegate" %>
<jsp:include page="/inc/header.jsp" flush="true"/>

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
	CmtReqSchForm objForm = new CmtReqSchForm();

	boolean blnParamCheck = false;
	/**���޵� �ĸ����� üũ */
	blnParamCheck = objForm.validateParams(request);
	if(blnParamCheck == false){
		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
		objMsgBean.setStrCode("DSPARAM-0000");
		objMsgBean.setStrMsg(objForm.getStrErrors());
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}

	//�α����� �����ID�� �����´�.
	String strUserID   = objUserInfo.getUserID();
    String strOrganID = objUserInfo.getOrganID();
    String strKind       = objUserInfo.getOrganGBNCode();
    String strReqSubmitFlag = objUserInfo.getReqSubmitFlag();
    String strIngSttYes = "N";

    //�䱸�⵵ ��Delegate �����.
    CommMakeBoxDelegate objCommReq = new  CommMakeBoxDelegate();

	//������ �Ǵ� ������ ������϶� �ش� ����ȸ�� ã�´�.
    String strSelectedCmtOrganId = StringUtil.getEmptyIfNull(objForm.getParamValue("CmtOrganID"));
    MemRequestBoxDelegate objReqBox = new MemRequestBoxDelegate();
	List objList = objReqBox.getReqrPerYearCMTList(objUserInfo.getOrganID(), CodeConstants.REQ_BOX_STT_003);
    ResultSetHelper objCmtRs = new ResultSetHelper(objList);
	ResultSetHelper objCmtRs2 = new ResultSetHelper(objCommReq.getCmtList(objUserInfo.getOrganID()));
	if (!strKind.equals("004")) {
	    if(StringUtil.isAssigned(strSelectedCmtOrganId)) {
	    	strOrganID = strSelectedCmtOrganId;
	    } else {
			int i=0;
     		while(objCmtRs.next()) {
     			if(i==0) {
					strOrganID = (String)objCmtRs.getObject("CMT_ORGAN_ID");
					//out.println(strOrganID + " : " + (String)objCmtRs.getObject("CMT_ORGAN_NM"));
				}
				i++;
    	 	}
    	}
	}

	ArrayList objCommYear = new ArrayList();
    objCommYear = objCommReq.getCommYearSch(strOrganID);

   	String strYear    = null ;
    String strOrganNm = null ;
   	String strStrDay    = null;
    String strEndDay  = null;

   	strYear    = StringUtil.getEmptyIfNull(objForm.getParamValue("year_cd"));
    strOrganNm = StringUtil.getEmptyIfNull(objForm.getParamValue("organnm"));

   	strStrDay    = StringUtil.getEmptyIfNull(objForm.getParamValue("StartDate"));
    strEndDay  = StringUtil.getEmptyIfNull(objForm.getParamValue("EndDate"));

    if (objCommYear != null) {
		for(int i=0; i < objCommYear.size(); i++){
			Hashtable objAUDIT_YEAR2 = (Hashtable)objCommYear.get(i);
			if(StringUtil.getEmptyIfNull(strYear).equals("")){
				strYear = StringUtil.getEmptyIfNull((String)objAUDIT_YEAR2.get("AUDIT_YEAR"));		//�⵵
			}//end if

			if(StringUtil.getEmptyIfNull(strOrganNm).equals("")){
				strOrganNm = StringUtil.getEmptyIfNull((String)objAUDIT_YEAR2.get("ORGAN_NM"));		//����ȸ��
			}//end if
		}
	}

	Calendar now = Calendar.getInstance();
    SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");

	//if (!StringUtil.isAssigned(strYear)) strYear = String.valueOf(now.get(Calendar.YEAR));
	strYear = String.valueOf(now.get(Calendar.YEAR));

    int yyyy = now.get(Calendar.YEAR);
    int MM = now.get(Calendar.MONTH);
    int dd = now.get(Calendar.DATE);


    //�ʱ� ��ȸ ������ �������ش�.
    if (!StringUtil.isAssigned(strStrDay)) {
    	String strMonth = String.valueOf(now.get(Calendar.MONTH)-2);
    	if(strMonth.length() == 1) strMonth = "0"+strMonth;
   		strStrDay = strYear+"-"+strMonth+"-01";
        //��¥�� �������� ���ͼ� ����
        now.set(yyyy, MM - 3, dd);
        strStrDay = df.format(now.getTime());
        System.out.println("strStrDay"+df.format(now.getTime()));
   		objForm.setParamValue("StartDate", StringUtil.ReplaceString(strStrDay, "-", ""));
	}

    if (!StringUtil.isAssigned(strEndDay)) {
	    String strMonth = String.valueOf(now.get(Calendar.MONTH)+3);
    	if(strMonth.length() == 1) strMonth = "0"+strMonth;
		strEndDay = strYear+"-"+strMonth+"-"+((String.valueOf(now.get(Calendar.DATE)).length() == 1)?"0"+String.valueOf(now.get(Calendar.DATE)):String.valueOf(now.get(Calendar.DATE)));
        //��¥�� �������� ���ͼ� ����
        now.set(yyyy, MM + 3, dd);
        strEndDay = df.format(now.getTime());
        System.out.println("strEndDay"+df.format(now.getTime()));
		objForm.setParamValue("EndDate", StringUtil.ReplaceString(strEndDay, "-", ""));
	}

	//�������� �䱸������ �ִ��� Ȯ���Ѵ�.
	int intResult;
	ArrayList objCommStt = (ArrayList)objCommReq.selectComm_IngStt(strOrganID);
	intResult = objCommStt.size();
  	if (intResult > 0 ){
		strIngSttYes = "Y";
%>
  	   	<input type=hidden name=IngSttYes VALUE="<%=strIngSttYes%>">
<%
	}

    //����ȸ ��� ��ȸ
    if(strKind.equals("004")) {
    	objForm.setParamValue("CmtOrganID", strOrganID);
    } else {
    	if(StringUtil.isAssigned(strSelectedCmtOrganId)) {
	    	objForm.setParamValue("CmtOrganID", strSelectedCmtOrganId);
	    } else {
	    	objForm.setParamValue("CmtOrganID", strOrganID);
	    }
    }
	ResultSetHelper objRS = new ResultSetHelper(objCommReq.getCommSchFromToList(objForm));

	int intTotalRecordCount = objRS.getTotalRecordCount();
	int intCurrentPageNum = objRS.getPageNumber();
	int intTotalPage = objRS.getTotalPageCount();
%>

<link href="/css2/style.css" rel="stylesheet" type="text/css">
<script language=Javascript src="/js/calendar.js"></script>
<script language=Javascript src="/js/datepicker.js"></script>
<script language="javascript">
function fUsrAction(mode, strStrDay, strEndDay, strOrganId, strOrganNm) {
  switch(mode) {
    case "list" :
         if (!fCheckField()) return false;
      	 form1.submit();
         break;

  }
}

function fUsrActionChk(mode, strYear, strOrganId, strOrganNm) {
  switch(mode) {

    case "insertY" :
         if (!fCheckFieldIns()) return false;
         break;

    case "insertN" :
        form1.action="RCommSchWrite.jsp";
        form1.submit();
  }
}


function fCheckField() {
  with (form1) {
    if (StartDate.value == '' || EndDate.value == '') {
      alert('��ȸ �����ϰ� �������� ��� �����ϼ���');
      StartDate.focus();
      return false;
    }

    if ((StartDate.value).replace("-","").replace("-","") > (EndDate.value).replace("-","").replace("-","") ) {
      alert('��ȸ  �������� ������ ���� Ů�ϴ�.');
      StartDate.focus();
      return false;
    }
  }
  return true;
}

function fCheckFieldIns() {
  with (form1) {
    if (IngSttYes.value == 'Y') {
      alert('�������� �䱸������ �̹� �����մϴ�.');
      return false;
    }
  }
  return true;
}

function chgCmtOrgan(str) {
	document.form1.submit();
}

/** ����¡ �ٷΰ��� */
  function goPage(strPage){
  	form1.CmtSchPage.value=strPage;
  	form1.submit();
  }

</script>
</head>

<body>
<div id="wrap">
  <jsp:include page="/inc/top.jsp" flush="true"/>
  <jsp:include page="/inc/top_menu02.jsp" flush="true"/>
  <div id="container">
    <div id="leftCon">
      <jsp:include page="/inc/log_info.jsp" flush="true"/>
      <jsp:include page="/inc/left_menu02.jsp" flush="true"/>
    </div>
    <div id="rightCon">
<form name="form1" method="post" action="<%=request.getRequestURI()%>">
			<input type="hidden" name="organid" VALUE="<%=strOrganID%>">
			<input type="hidden" name="organnm" VALUE="<%=strOrganNm%>">
			<input type="hidden" name="year_cd" VALUE="<%=strYear%>">
            <input type="hidden" name="strYear" VALUE="<%=strYear%>">
            <input type="hidden" name="strOrganId" VALUE="<%=strOrganID%>">
            <input type="hidden" name="strOrganNm" VALUE="<%=strOrganNm%>">
			<input type="hidden" name="CmtSchPage" value="<%=intCurrentPageNum%>"><!--������ ��ȣ -->

      <!-- pgTit -->

      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=MenuConstants.REQ_BOX_SCH%></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.REQUEST_BOX_COMM%> > <%=MenuConstants.REQ_BOX_SCH %></div>
        <p><!--����--></p>
      </div>
      <!-- /pgTit -->

      <!-- contents -->

      <div id="contents">

        <!-- �˻����� ���� ��� �Ʒ� div ���� �� �ּ����� ��������.-->
        <div class="schBox">
         <!-- <p>�䱸����ȸ����</p>  -->
          <span class="line"><img src="/images2/foundation/search_line.gif" width="172" height="3" /></span>
			  <div class="box">
				<!-- ������ �˻� ����Ʈ�� ��ư�� ��������-->
				<!-- ������ �˻� ����Ʈ�� ��ư�� ��������-->
			<%
				if (strKind.equals("003")) {
			%>
				&bull;&nbsp;����ȸ :
				<select onChange="javascript:chgCmtOrgan(this.value)" name="CmtOrganID">
				<%
					String strSelected = "";
					while(objCmtRs2.next()) {
						String strCmtOrganID = (String)objCmtRs2.getObject("ORGAN_ID");
						String strCmtOrganNm = (String)objCmtRs2.getObject("ORGAN_NM");
						if(strCmtOrganID.equalsIgnoreCase(strSelectedCmtOrganId)) strSelected = " selected";
						else strSelected = "";
				%>
					<option value="<%= strCmtOrganID %>"<%= strSelected %>><%= strCmtOrganNm %></option>
				<% } %>
				</select>
			<%
				}
			%>
				&nbsp;
				&bull;&nbsp;������ :
<!--				<input OnKeyPress="if ((event.keyCode&lt;48)||(event.keyCode&gt;57)) event.returnValue=false;" OnClick="this.select()" readonly="readonly" maxlength="8" size="10" name="StartDate" value="<%=strStrDay%>"/>
				<a href="#" onClick="javascript:Calendar(form1.StartDate);"><img src="/images2/btn/bt_calender.gif" width="17" height="13" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"/></a>~
				<input onKeyPress="if ((event.keyCode&lt;48)||(event.keyCode&gt;57)) event.returnValue=false;" onClick="this.select()" readonly="readonly" maxlength="8" size="10" name="EndDate" value="<%=strEndDay%>" />
				<a href="#" onClick="javascript:Calendar(form1.EndDate);"><img src="/images2/btn/bt_calender.gif" width="17" height="13" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"  /></a><img src="/images2/btn/bt_search2.gif" width="50" height="22" OnClick="javascript:fUsrAction('list',form1.StartDate.value,form1.EndDate.value, form1.organid.value);" />
	-->			

				<input type="text" class="textfield" name="StartDate" size="10" maxlength="8" value="<%=strStrDay%>"  readonly" >
                <a href="#" OnClick="javascript:show_calendar('form1.StartDate');"><img src="/images2/btn/bt_calender.gif" width="17" height="13" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"/></a> ~
			    <input type="text" class="textfield" name="EndDate" size="10" maxlength="8" value="<%=strEndDay%>" readonly">
			    <a href="#" OnClick="javascript:show_calendar('form1.EndDate');"><img src="/images2/btn/bt_calender.gif" width="17" height="13" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"/></a>

				</div>
        </div>
        <!-- /�˻�����-->

        <!-- �������� ���� -->

        <!-- list -->

        <span class="list_total">&bull;&nbsp;��ü ������ : <%= intTotalRecordCount %>�� (<%=intCurrentPageNum%>/<%=intTotalPage%>  page)</span>


        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
          <thead>
            <tr>
				<th scope="col"><a href="#">NO<a/></td>
				<th scope="col" style="width:200px; "><a href="#">�䱸����</a></th>
				<th scope="col" ><a href="#">ȸ��</a></th>
				<th scope="col" ><a href="#">�������</a></th>
				<th scope="col" ><a href="#">������</a></th>
				<th scope="col"><a href="#">������</a></th>
            </tr>
          </thead>
          <tbody>
		<%
			int intRecordNumber = intTotalRecordCount - ((intCurrentPageNum -1) * Integer.parseInt((String)objForm.getParamValue("CmtSchPageSize")));
			if(objRS.getRecordSize() > 0) {
				while(objRS.next()){
						String strReqSchId  = (String)objRS.getObject("REQ_SCHE_ID");
						String strOrderInfo   = (String)objRS.getObject("ORDER_INFO");
						String strNatCnt      = (String)objRS.getObject("NAT_CNT");
						String strReqNm      = (String)objRS.getObject("REQNM");
						String strCdNm        = (String)objRS.getObject("CD_NM");
						String strAcptBgnDt = (String)objRS.getObject("ACPT_BGN_DT");
						String strAcptEndDt = (String)objRS.getObject("ACPT_END_DT");
						String strIngStt        = (String)objRS.getObject("ING_STT");
						strAcptBgnDt = strAcptBgnDt.substring(0, 4) + "-" + strAcptBgnDt.substring(4, 6) + "-" + strAcptBgnDt.substring(6, 8);
						strAcptEndDt = strAcptEndDt.substring(0, 4) + "-" + strAcptEndDt.substring(4, 6) + "-" + strAcptEndDt.substring(6, 8);
		%>
            <tr>
              <td ><%= intRecordNumber %></td>
              <td style="text-align:left; "><a href="RCommSchVList.jsp?ReqSchId=<%=strReqSchId%>"><%=strReqNm%></a></td>
              <td><%=strNatCnt%></td>
              <td><%=strCdNm%></td>
              <td><%=strAcptBgnDt%></td>
              <td><%=strAcptEndDt%></td>
            </tr>
		<%
					intRecordNumber --;
				}//end while
			} else {
		%>
			<tr>
				<td align="center" colspan="6">��ϵ� �䱸 ������ �����ϴ�.</td>
			</tr>
		<%
			}//end if ��� ��� ��.
		%>
          </tbody>
        </table>

        <!-- /list -->



        <!-- ����¡-->
			<%=objPaging.pagingTrans(PageCount.getLinkedString(
				new Integer(intTotalRecordCount).toString(),
				new Integer(intCurrentPageNum).toString(),
				objForm.getParamValue("CmtSchPageSize")))
			%>

         <!-- /����¡-->
        <!--  <p class="warning">* �䱸���� �߼��ϰ� �Ǹ� �ش� ���� ��� ��ǥ ����ڿ��� ���� �߼۵Ǹ�, ����ڰ� ���� ���� �ۼ� �� �䱸�Կ� �״�� �����ְ� �˴ϴ�.  </p>
          <p class="warning">* �䱸�� �߼� ��ư�� �̿��Ͻñ� ���ؼ��� ����ȸ�� ������ �ֽñ� �ٶ��ϴ�.  </p>  -->



        <!-- ����Ʈ ��ư
        <div id="btn_all" >        <!-- ����Ʈ �� �˻�
        <div class="list_ser" >
          <select name="select" class="selectBox5"  style="width:70px;" >
            <option value="">�䱸�Ը�</option>
            <option value="">�䱸�Լ���</option>
            <option value="">�䱸���</option>
          </select>
          <input name="iptName" onKeyDown="return ch()" onMouseDown="return ch()"
		 class="li_input"  style="width:100px"/>
          <img src="/images2/btn/bt_list_search.gif"  onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"/> </div>
        <!-- /����Ʈ �� �˻� --> <!-- /����Ʈ ��ư-->
<%
     if (strKind.equals("004") & !strReqSubmitFlag.equals("004")) {
%>
			<span class="right">
				<%
					 if (strIngSttYes.equals("Y")) {
				%>
				<span class="list_bt"><a href="#" onclick="javascript:fUsrActionChk('insertY',form1.year_cd.value, form1.organid.value, form1.organnm.value);">�䱸�������</a></span>
				<%
					} else {
				%>
				<span class="list_bt"><a href="#" onclick="javascript:fUsrActionChk('insertN',form1.year_cd.value, form1.organid.value, form1.organnm.value);">�䱸�������</a></span>
				<%
					}
				%>
			</span>
<%	}	%>
		</div>

         <!-- /����Ʈ ��ư-->

        <!-- /�������� ���� -->

</form>
      </div>
      <!-- /contents -->

    </div>
  </div>
  <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>