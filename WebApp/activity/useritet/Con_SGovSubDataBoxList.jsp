<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.bf.config.*"%>
<%@ page import="kr.co.kcc.pf.util.PageCount"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.EnvConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.govSubmtData.SGovSubmtDataDelegate"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.UserInfoDelegate"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.CDInfoDelegate"%>
<%@ page import="nads.lib.reqsubmit.params.govsubmtdata.SGovSubmtDataInsertForm" %>
<%
 UserInfoDelegate objUserInfo =null;
 CDInfoDelegate objCdinfo =null;
%>
<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>
<%
 /*************************************************************************************************/
 /** 					파라미터 체크 Part 														  */
 /*************************************************************************************************/
  /**정부제출자료함 파라미터 설정.*/
 /*
  SGovSubmtDataInsertForm objParams =new SGovSubmtDataInsertForm();
  boolean blnParamCheck=false;
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
  }*/
%>
<%
 /*************************************************************************************************/
 /** 					파라미터 체크 Part 														  */
 /*************************************************************************************************/
  /**정부제출자료함 파라미터 설정.*/
 /*
  SGovSubmtDataInsertForm objParams =new SGovSubmtDataInsertForm();
  boolean blnParamCheck=false;
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
  }*/
%>
<%
    StringUtil objDate = new StringUtil();
	ArrayList objAllBinderArray = null;
	Hashtable objGovSubmtDataHash = null;
	ResultSetHelper objRs = null;
	UserInfoDelegate objUser = null;
	SGovSubmtDataDelegate objGovSubmtData = null;
	String strReqId = null;
	String strGovSubmtDataSortField = null;
	String strGovSubmtDataSortMtd = null;
	String strGovSubmtDataPageNum = null;
	String strPageSize = null;
	String strUserID = null;
	String strGbnCode = null;    // 정부제출자료구분코드 000 전체 001 예산안 ..
	//String strOrganId = null;  // 기관 id
	String	strGovSubmtGNB = null;
	String strGovSubmtDataId = null;
	String strSubmtOrganId = null;
	String strOrgFilePath = null;
	String strPdfFilePath = null;
	String strTocFilePath = null;
	String strGovSubmtYear = null;
	String	strSubmtDate = null;
	String	strSubmtOrganNm = null;
	String	strSubmtDataCont = null;
	String  strHttpPdfFilePath = null;
	String	strReqOrganId = null;
	String  strReqOrganNmValue = null;
	String	strAnsSubmtQryField = null;
	String	strAnsSubmtQryTerm = null;
	String	strReqOrganNm  = null;
    String  strCheckLegiConn = null;
	String strCheckSearchGbnCode = null; //정부제출자료조회를 했는지 확인.
	String	strRegerNm = null ; //등록자
	boolean blnGovSubmtDataNoExist =  true;
	int intPageSize = 10 ; //  보여줄수있는 페이지 수
	int	intTotalRecordCount = 0;
	int	intCurrentPageNum = 1; // 현재 페이지
	int	intTotalPage = 0;
	int	intRecordNumber = 0;
	int intIndexNum = 1;
	int intStartPage = 0;
	int intEndPage = 0;
	String strQryFieldValue = StringUtil.getNoTagStr(StringUtil.toHan(request.getParameter("strAnsSubmtQryField")));
	String strQryTermValue = StringUtil.getNoTagStr(request.getParameter("strAnsSubmtQryTerm"));
    strGbnCode = StringUtil.getNoTagStr(request.getParameter("GovSubmtDataType")); // 정부제출자료 기관코드 000 전체 001 예산안 ..
	strReqOrganNmValue = StringUtil.getNoTagStr(StringUtil.toHan(request.getParameter("strReqOrganNm")));
	//System.out.println("[SGovSubDataBoxList.jsp] strQryFieldValue = " + strQryFieldValue);
	if(strGbnCode == null || strGbnCode == "" || strGbnCode.equals("")){
		strGbnCode = "000";
	}
	//System.out.println("[SGovSubDataBoxList.jsp] strGbnCode 코드는 = " + strGbnCode);
/*    strCheckSearchGbnCode  = request.getParameter("strCheckSearchGbnCode"); //정부제출자료 조회(Search)를 했는지 확인.
	System.out.println("[SGovSubDataBoxList.jsp] strCheckSearchGbnCode = " + strCheckSearchGbnCode);
	if(strCheckSearchGbnCode == null){
			strCheckSearchGbnCode = "0000";
	}
*/
	if(strQryFieldValue == null || strQryFieldValue == "" ||strQryFieldValue.equals("")){
		strAnsSubmtQryField = "001";
	}else{
	    strAnsSubmtQryField = strQryFieldValue;
		/*if(strCheckSearchGbnCode == "001" || strCheckSearchGbnCode.equals("001")){
			strAnsSubmtQryField = strQryFieldValue;
			strGbnCode = strAnsSubmtQryField;
		}else{
			if(strGbnCode == "000" || strGbnCode.equals("000")){
				strAnsSubmtQryField = strGbnCode;
			}else{
				strAnsSubmtQryField = strQryFieldValue;
			}
		}*/
	}
	//System.out.println("[SGovSubDataBoxList.jsp] 최종 strAnsSubmtQryField = " + strAnsSubmtQryField);
	//System.out.println("[SGovSubDataBoxList.jsp] 최종 strGbnCode = " + strGbnCode);
	if( strQryTermValue == null || strQryTermValue.equals("")){
		strAnsSubmtQryTerm = "";
	}else{
		strQryTermValue = StringUtil.toMulti(strQryTermValue);
		StringUtil.isAssigned(strQryTermValue);
		strAnsSubmtQryTerm = strQryTermValue;
	}
	//System.out.println("[SGovSubDataBoxList.jsp] 최종 strAnsSubmtQryTerm = " + strAnsSubmtQryTerm);
	objUser = new UserInfoDelegate(request);
	String strOrganGbnCode = objUser.getOrganGBNCode();
	strSubmtOrganId = objUser.getOrganID();
	//정렬 정보 받기.
	strGovSubmtDataSortField = StringUtil.getNoTagStr(StringUtil.toHan(request.getParameter("strGovSubmtDataSortField")));
	if(strGovSubmtDataSortField == null || strGovSubmtDataSortField.equals("")){
		strGovSubmtDataSortField = "REG_DT";
	}
	//strGovSubmtDataSortField = objParams.getParamValue("strGovSubmtDataSortField");
	//System.out.println("[SGovSubDataBoxList jsp] strGovSubmtDataSortField = " + strGovSubmtDataSortField);
 	strGovSubmtDataSortMtd= StringUtil.getNoTagStr(request.getParameter("strGovSubmtDataSortMtd"));
 	if(strGovSubmtDataSortMtd == null || strGovSubmtDataSortMtd.equals("")){
	 	strGovSubmtDataSortMtd = "DESC";
 	}
 	//strGovSubmtDataSortMtd= objParams.getParamValue("strGovSubmtDataSortMtd");
	//System.out.println("[SGovSubDataBoxList jsp] strGovSubmtDataSortMtd = " + strGovSubmtDataSortMtd);
	// 정보 페이지 번호 받기.
	strGovSubmtDataPageNum = StringUtil.getNoTagStr(request.getParameter("strGovSubmtDataPageNum"));
	//strGovSubmtDataPageNum = objParams.getParamValue("strGovSubmtDataPageNum");
	if(strGovSubmtDataPageNum == null || strGovSubmtDataPageNum.equals("")){
		strGovSubmtDataPageNum = "1";
	}
	//System.out.println("[SGovSubDataBoxList jsp] strGovSubmtDataPageNum = " + strGovSubmtDataPageNum);
	Integer objIntD = new Integer(strGovSubmtDataPageNum);
	intCurrentPageNum = objIntD.intValue();
	//System.out.println("[SGovSubDataBoxList jsp] intCurrentPageNum = " + intCurrentPageNum);
    objGovSubmtData = new SGovSubmtDataDelegate();
	 //intCurrentPageNum = 1
    intRecordNumber= (intCurrentPageNum -1) * intPageSize +1;
	intStartPage = intRecordNumber;
	intEndPage = intCurrentPageNum*10;
	//System.out.println("intStartPage =" + intStartPage + "\nintEndPage =" + intEndPage);
	objGovSubmtDataHash = objGovSubmtData.getGovSubmtDataInfo(strGbnCode,strSubmtOrganId,strGovSubmtDataSortField,strGovSubmtDataSortMtd,intPageSize,intCurrentPageNum,strAnsSubmtQryField,strAnsSubmtQryTerm,(String)session.getAttribute("ORGAN_KIND"));
	/*for (java.util.Enumeration enum=objGovSubmtDataHash.keys(); enum.hasMoreElements();){
		System.out.println("Key:" + (String)enum.nextElement());
	}*/
	if(objGovSubmtDataHash != null ){
		blnGovSubmtDataNoExist = false;
		objRs =new ResultSetHelper(objGovSubmtDataHash);
 	}
 	if(strUserGubn.equals("false")){
 		strPrgNm = "회의자료 등록함";
 	}else{
 		strPrgNm = "회의자료함";
 	}
%><!-- list -->  <span class="list01_tl">  <%=strPrgNm%><span class="sbt"><a href="<%=strPrgUrl%>"><img src="/images2/btn/bt_all.gif" width="78" height="19" /></a></span></span>  <table>	  <tr>		<td>&nbsp;</td>	  </tr>  </table>  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">	<thead>	  <tr>		<th scope="col"><a>NO</a></th>		<th scope="col" style="width:300px; "><a>제출내용</a></th>		<th scope="col"><a>제출기관</a></th>		<th scope="col"><a>담당기관</a></th>		<th scope="col"><a>등록일</a></th>		<th scope="col"><a>입법통합등록</a></th>		<th scope="col"><a>파일</a></th>	  </tr>	</thead>	<%		if(objRs.getRecordSize()>0){			int i=1;			while(objRs.next()) {				if(i == 4) break;				strGovSubmtDataId  = (String)objRs.getObject("SUBMT_DATA_ID"); 		// 정부제출자료함 ID				strSubmtOrganNm = (String)objRs.getObject("SUBMT_ORGAN_NM");		// 제출기관 명				strReqOrganId = (String)objRs.getObject("REQ_ORGAN_ID"); 			// 담담기관 ID				strCheckLegiConn = (String)objRs.getObject("ILKMS_REG_FLAG"); 			// 입법통합등록 확인				strReqOrganNm = (String)objRs.getObject("REQ_ORGAN_NM");				strGovSubmtGNB	= (String)objRs.getObject("SUBMT_DATA_GBN");        // 구분코드				strSubmtDataCont  = (String)objRs.getObject("DATA_NM"); 			// 제출내용				strSubmtDate = (String)objRs.getObject("REG_DT");					// 제출기간				strOrgFilePath = (String)objRs.getObject("APD_ORG_FILE_PATH"); 	// 원본문서패스				strPdfFilePath = (String)objRs.getObject("APD_PDF_FILE_PATH"); 	// PDF문서패스				strTocFilePath = (String)objRs.getObject("APD_TOC_FILE_PATH"); 	// TOC문서패스				strSubmtDate = nads.lib.reqsubmit.util.StringUtil.getDate(strSubmtDate);	%>	<tbody>	  <tr>		<td><%=Integer.toString(i)%></td>		<td style="text-align:left;"><%=strSubmtDataCont%></td>		<td><%=strSubmtOrganNm%></td>		<td><%=strReqOrganNm%></td>		<td><%=strSubmtDate%></td>		<td><%=strCheckLegiConn%></td>		<td>			<a href="javascript:PdfFileOpen('<%=strGovSubmtDataId%>','GPDF');">	            <img src="/image/common/icon_pdf.gif" border="0">			</a>		</td>	  </tr>	</tbody>		<%					i++;					}				} else {		%>	<tbody>	  <tr>		<td colspan="7">해당 데이타가 없습니다</td>	  </tr>	</tbody>			<%				}			%>	</table><!-- /list --><!-- 2011-09-05 이전 소스                <tr>                  <td height="5" colspan="2" align="left" class="soti_reqsubmit"></td>                </tr>                 <tr>                   <td width="655" height="30" align="left"><span class="soti_reqsubmit"><img src="../../image/mypage/icon_mypage_soti.gif" width="9" height="9" align="absmiddle">                     </span><span class="soti_mypage"><%=strPrgNm%></span></td>                   <td width="104" align="left"><a href="<%=strPrgUrl%>"><img src="../../image/button/bt_allList.gif" width="101" height="20" border="0"></a></td>                 </tr>                 <tr>                 <td colspan="2" align="left" valign="top"><table width="759" border="0" cellspacing="0" cellpadding="0">                    <tr>                      <td height="2" colspan="7" class="td_mypage"></td>                    </tr>                    <tr class="td_top">                      <td width="48" height="22" align="center">NO</td>                      <td width="236" height="22" align="center">제출내용</td>                      <td width="95" height="22" align="center">제출기관</td>                      <td width="95" height="22" align="center">담당기관</td>                      <td width="95" height="22" align="center">등록일</td>                      <td width="95" height="22" align="center">입법통합등록</td>                      <td width="95" height="22" align="center">파일</td>                    </tr>                    <tr>                      <td height="1" colspan="7" class="td_mypage"></td>                    </tr>                    <%						if(objRs.getRecordSize()>0){							int i=1;							while(objRs.next()) {								if(i == 4) break; 							    strGovSubmtDataId  = (String)objRs.getObject("SUBMT_DATA_ID"); 		// 정부제출자료함 ID								strSubmtOrganNm = (String)objRs.getObject("SUBMT_ORGAN_NM");		// 제출기관 명  							    strReqOrganId = (String)objRs.getObject("REQ_ORGAN_ID"); 			// 담담기관 ID  							    strCheckLegiConn = (String)objRs.getObject("ILKMS_REG_FLAG"); 			// 입법통합등록 확인  							    strReqOrganNm = (String)objRs.getObject("REQ_ORGAN_NM");								strGovSubmtGNB	= (String)objRs.getObject("SUBMT_DATA_GBN");        // 구분코드								strSubmtDataCont  = (String)objRs.getObject("DATA_NM"); 			// 제출내용 							    strSubmtDate = (String)objRs.getObject("REG_DT");					// 제출기간 							    strOrgFilePath = (String)objRs.getObject("APD_ORG_FILE_PATH"); 	// 원본문서패스 							    strPdfFilePath = (String)objRs.getObject("APD_PDF_FILE_PATH"); 	// PDF문서패스 							    strTocFilePath = (String)objRs.getObject("APD_TOC_FILE_PATH"); 	// TOC문서패스								 strSubmtDate = nads.lib.reqsubmit.util.StringUtil.getDate(strSubmtDate);					%>                    <tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''">                      <td height="22" align="center"><%=Integer.toString(i)%></td>                      <td height="22" class="td_lmagin"><%=strSubmtDataCont%></td>                      <td height="22" align="center"><%=strSubmtOrganNm%></td>                      <td height="22" align="center"><%=strReqOrganNm%></td>                      <td height="22" align="center"><%=strSubmtDate%></td>                      <td height="22" align="center"><%=strCheckLegiConn%></td>                      <td height="22" align="center">                        <a href="javascript:PdfFileOpen('<%=strGovSubmtDataId%>','GPDF');">                          <img src="/image/common/icon_pdf.gif" border="0">                        </a>                      </td>                    </tr>                    <tr class="tbl-line">                      <td height="1"></td>                      <td height="1" align="left" class="td_lmagin"></td>                      <td height="1"></td>                      <td height="1"></td>                      <td height="1"></td>                      <td height="1"></td>                      <td height="1"></td>                    </tr>                    <%                    			i++;							}						} else {							out.println("<tr>");							out.println("<td height='22' colspan='5' align='center'>해당 데이타가 없습니다.");							out.println("</td>");							out.println("</tr>");							out.println("<tr class='tbl-line'>");							out.println("<td height='1'></td>");							out.println("<td height='1' align='left' class='td_lmagin'></td>");							out.println("<td height='1' align='left' class='td_lmagin'></td>");							out.println("<td height='1' align='left' class='td_lmagin'></td>");							out.println("</tr>");						}					%>					 <tr class="tbl-line">                      <td height="1"></td>                      <td height="1" align="left" class="td_lmagin"></td>                      <td height="1"></td>                      <td height="1"></td>                      <td height="1"></td>                      <td height="1"></td>                      <td height="1"></td>                    </tr>                  </table>				 </td>              </tr>-->