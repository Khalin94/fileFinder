<%@ page language="java" contentType="text/html;charset=EUC-KR" %>

<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.lib.reqsubmit.params.answerinfo.SAnsInfoViewForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.answerinfo.AnsInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.MemRequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.MemRequestInfoDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	UserInfoDelegate objUserInfo = null;
	CDInfoDelegate objCdinfo = null;
%>

<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>

<%
	MemRequestBoxDelegate reqDelegate = null;
	AnsInfoDelegate selfDelegate = null;
	ResultSetSingleHelper objInfoRsSH=null;
	MemRequestInfoDelegate  objReqInfo=null;

	SAnsInfoViewForm objParams = new SAnsInfoViewForm();

	boolean blnParamCheck=false;
	blnParamCheck = objParams.validateParams(request);
	if(blnParamCheck==false) {
  		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  		objMsgBean.setStrCode("DSPARAM-0000");
  		objMsgBean.setStrMsg(objParams.getStrErrors());
  		out.println("ParamError:" + objParams.getStrErrors());
	  	return;
  	}//endif

	// 넘어온 파라미터를 설정해서 필요할 때 쓰도록 하자
	String strReqBoxID = null;
	String strReqID = null;
	String strAnsID = objParams.getParamValue("AnsID");
	String strAnsSEQ = request.getParameter("AnsSEQ")==null?"":request.getParameter("AnsSEQ");
	String strReturnURL = objParams.getParamValue("ReturnURL");
	//공개비공개 테스트
  String strOpenCL = request.getParameter("ReqOpenCL");
  System.out.println("kangthis logs SAnsInfoView2.jsp(strOpenCL) => " + strOpenCL);

	System.out.println("strAnsSEQ : "+strAnsSEQ);

	ResultSetSingleHelper objRsSH = null;

	// 답변 유형에 따라서 출력해야하는 항목들이 달라진다.
	String strAnsMtd = null;
	String strAnsStt = null;
	String reqnm = null;
	String submtnm = null;
	//실제파일명 작업 20170818
	String strPdfFileName = null;
	String strOrgFileName = null;

	try{
		reqDelegate = new MemRequestBoxDelegate();
		objReqInfo=new MemRequestInfoDelegate();
	   	selfDelegate = new AnsInfoDelegate();

    	objRsSH = new ResultSetSingleHelper(selfDelegate.getRecord(strAnsID));
		
    	strAnsMtd = (String)objRsSH.getObject("ANS_MTD");
    	strAnsStt = (String)objRsSH.getObject("SUBMT_FLAG");
    	strReqBoxID = (String)objRsSH.getObject("REQ_BOX_ID");
    	strReqID = (String)objRsSH.getObject("REQ_ID");
		//실제파일명 작업 20170818
		strPdfFileName = (String)objRsSH.getObject("PDF_FILE_NAME");
		strOrgFileName = (String)objRsSH.getObject("ORG_FILE_NAME");

		objInfoRsSH=new ResultSetSingleHelper(objReqInfo.getRecord2(strReqID));
		reqnm = (String)objInfoRsSH.getObject("REQ_CONT");
		submtnm = (String)objInfoRsSH.getObject("SUBMT_ORGAN_NM");


	} catch(AppException e) {
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  		objMsgBean.setStrCode(e.getStrErrCode());
  		objMsgBean.setStrMsg(e.getMessage());
  		out.println("<br>Error!!!" + e.getMessage());
	  	return;
 	}
%>
<jsp:include page="/inc/header.jsp" flush="true"/>
<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>

<script language="javascript">
	function submitDelete() {
		var f = document.viewForm;
		f.action = "/reqsubmit/common/SAnsInfoDelProc.jsp";
		if (confirm("해당 답변을 삭제하시겠습니까?")) f.submit();
	}

	function gotoEditForm() {
		var f = document.viewForm;
		f.target = "";
		f.action = "/reqsubmit/common/SAnsInfoEdit.jsp";
		//NewWindow('/reqsubmit/common/SAnsInfoEdit.jsp', 'popwin', '500', '580');
		f.submit();
		//self.close();
	}
	function gotoEditForm2() {
		var f = document.viewForm;
		f.target = "";
		f.action = "/reqsubmit/common/SAnsInfoEdit2.jsp";
		f.submit();
	}
	function viewFile(strAnsID, strType) {
		if (strType == "PDF") {
			location.href = "/reqsubmit/common/ReqFileOpen2.jsp?paramAnsId="+strAnsID+"&DOC="+strType+"&REQNM=<%=reqnm%>&REQSEQ=<%=strAnsSEQ%>&SubmtOrganNm=<%=submtnm%>";			
		} else {
			location.href = "/reqsubmit/common/ReqFileOpen2.jsp?paramAnsId="+strAnsID+"&DOC="+strType+"&REQNM=<%=reqnm%>&REQSEQ=<%=strAnsSEQ%>&SubmtOrganNm=<%=submtnm%>";
		}
	}

</script>
</head>

<body>
<div class="popup">
    <p>답변상세보기</p>
<FORM method="post" action="" name="viewForm" style="margin:0px">

		<input type="hidden" name="ReqBoxID" value="<%= strReqBoxID %>">
		<input type="hidden" name="ReqID" value="<%= strReqID %>">
		<input type="hidden" name="AnsID" value="<%= strAnsID %>">
		<input type="hidden" name="WinType" value="POPUP" %>
		<input type="hidden" name="ReturnURL" value="<%= strReturnURL %>">
		<input type="hidden" name="ReqOpenCL" value="<%= strOpenCL %>">
    <table width="100%" cellpadding="0" cellspacing="0">
        <tr>
            <td width="100%" style="padding:10px;">  <!-- list -->
        <!-- <span class="list01_tl">요구 목록 <span class="list_total">&bull;&nbsp;전체자료수 : 2개 </span></span> -->
        <table border="0" cellspacing="0" cellpadding="0" class="list02">
            <tbody>
                <tr>
                    <th height="25">&bull;&nbsp;&nbsp;답변유형 </th>
                    <td>
					<%if(strAnsMtd.equals("004")){%>
					오프라인제출
					<%}else{%>
					<%= CodeConstants.getAnswerMethod(strAnsMtd) %>
					<%}%>
					</td>
                </tr>
                <tr>
                    <th height="25">&bull;&nbsp;&nbsp;제출 여부 </th>
                    <td><% if ("Y".equalsIgnoreCase(strAnsStt)) out.println("제출완료"); else out.println("미제출"); %></td>
                </tr>
<%
	if (CodeConstants.ANS_MTD_ELEC.equalsIgnoreCase(strAnsMtd)) { // 답변 유형이 전자문서라면
%>
                <tr>
                    <th height="25">&bull;&nbsp;&nbsp;제출파일 </th>
                    <td>
					<a href="javascript:viewFile('<%= strAnsID %>', 'PDF');"><img border="0" src="/images2/common/icon_pdf.gif" /> [PDF 문서] <%= strPdfFileName %></a>
					</td>
                </tr>
                <tr>
                    <th height="25">&bull;&nbsp;&nbsp;원본파일 </th>
                    <td>
					<a href="javascript:viewFile('<%= strAnsID %>', 'DOC');"><img border="0" src="/images2/common/icon_file.gif" /> [원본파일] <%= strOrgFileName %></a>
					</td>
                </tr>
<%
	} else if (CodeConstants.ANS_MTD_ETCS.equalsIgnoreCase(strAnsMtd)){
%>
				<tr>
                    <th height="25">&bull;&nbsp;&nbsp;매체유형 </th>
                    <td>
					<%= objCdinfo.getNotElecMedium((String)objRsSH.getObject("NON_ELC_DOC_MED")) %>
					</td>
                </tr>
				<tr>
                    <th height="25">&bull;&nbsp;&nbsp;발송 방법 </th>
                    <td>
					<%= StringUtil.getEmptyIfNull((String)objCdinfo.getSendWay((String)objRsSH.getObject("NON_ELC_DOC_SUBMT_MTD"))) %>
					</td>
                </tr>
<% } %>
                <tr>
                    <th height="25">&bull;&nbsp;&nbsp;제출자 </th>
                    <td><%= objRsSH.getObject("USER_NM") %></td>
                </tr>
                <tr>
                    <th height="25">&bull;&nbsp;&nbsp;제출일 </th>
                    <td><%= StringUtil.getDate2((String)objRsSH.getObject("ANS_DT")) %></td>
                </tr>
                <tr>
                    <th height="25" width="100">&bull;&nbsp;&nbsp;제출 의견 </th>
                    <td width="340"><%= objRsSH.getObject("ANS_OPIN") %></td>
                </tr>
            </tbody>
        </table>        <!-- /list -->



       </td>
        </tr>
    </table>
    <p style= "height:2px;padding:0;"></p>
    <!-- 리스트 버튼-->
    <div id="btn_all"  class="t_right">
	<% if (!"Y".equalsIgnoreCase(strAnsStt)) { %>
		<%if (objUserInfo.getUserID().equals("0000039924")){%>
		<span class="list_bt"><a href="#" onClick="javascript:gotoEditForm2()">테스트수정</a></span>&nbsp;&nbsp;
		<%}%>
		<span class="list_bt"><a href="#" onClick="javascript:gotoEditForm()">수 정</a></span>&nbsp;&nbsp;
		<span class="list_bt"><a href="#" onClick="javascript:submitDelete()">삭 제</a></span>&nbsp;&nbsp;
		<span class="list_bt"><a href="#" onClick="javascript:window.close()">창닫기</a></span>&nbsp;&nbsp;
	<% } else { %>
		<span class="list_bt"><a href="#" onClick="javascript:window.close()">확 인</a></span>&nbsp;&nbsp;
	<%	}	%>
	</div>
</form>
    <!-- /리스트 버튼-->
</div>
</body>
</html>
