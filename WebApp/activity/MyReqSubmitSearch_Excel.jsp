<%@ page language="java" contentType="application/vnd.ms-excel;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.bf.config.*"%>
<%@ page import="kr.co.kcc.pf.util.PageCount"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RMemReqBoxListForm" %>
<%@ page import="nads.dsdm.app.common.page.PagingDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.MemRequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.RequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.cmtsubmt.*" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
    System.out.println("손성제----------------------------------------------------------------");
    /*** PagingDelegate */
	PagingDelegate objPaging=new PagingDelegate(); 		/*페이징 변환 Delegate*/
%>
<%
	UserInfoDelegate objUserInfo =null;
	CDInfoDelegate objCdinfo =null;
%>
<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>
<%
	//response.setHeader("Content-Disposition", "Statistics;filename=SelectSystem_Comm_Excel.xls");
	response.setHeader("Content-Disposition","attachment;filename=SelectSystem_Comm_Excel.xls;");
	//response.setHeader("Content-Description", "SelectSystem_Comm_Excel");
%>
<%
	/*************************************************************************************************/
	/** 					파라미터 체크 Part 														  */
	/*************************************************************************************************/
	/**선택된 감사년도와 선택된 위원회ID*/
	String strSelectedAuditYear= null; /**선택된 감사년도*/
	String strSelectedCmtOrganID=null; /**선택된 위원회ID*/
	String strRltdDuty=null;	/**선택된 업무구분 */
	String strDaeSuCh = null;
	String strCmtGubun = objUserInfo.getOrganGBNCode();	/**(작성중 요구함 조회시 필요)*/
	String strBoxTp = null;			/**선택된 전자비전자구분(제출완료 요구함 조회시 필요)*/
	String strReqBoxStt = null;		/**선택된 진행상태*/
	String strReqBoxStt2 = null;	/**선택된 진행상태2[요구제출자료검색 용도(디폴트세팅 문제로 별도의 진행상태 변수를 사용한다.)]*/

	/**요구함 목록조회용 파라미터 설정.*/
	RMemReqBoxListForm objParams=new RMemReqBoxListForm();

	boolean blnParamCheck=false;

	/**전달된 파리미터 체크 */
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

	strSelectedAuditYear= objParams.getParamValue("AuditYear"); /**선택된 감사년도*/
	strSelectedCmtOrganID=objParams.getParamValue("CmtOrganID") ; /**선택된 위원회ID*/
	strBoxTp=objParams.getParamValue("BoxTp") ;		/**선택된 전자비전자구분(제출완료 요구함 조회시 필요)*/
	strReqBoxStt=objParams.getParamValue("ReqBoxStt") ;	/**선택된 진행상태*/

	strRltdDuty=objParams.getParamValue("RltdDuty") ; 			 /**선택된 업무구분 */
	String strDaesuInfo = StringUtil.getEmptyIfNull(request.getParameter("DaeSu"));
	strDaeSuCh = StringUtil.getEmptyIfNull(request.getParameter("DAESUCH"));

	/*************************************************************************************************/
	/** 					데이터 호출 Part 														  */
	/*************************************************************************************************/

	/*** Delegate 과 데이터 Container객체 선언 */
	MemRequestBoxDelegate objReqBox=null; 		/**요구함 Delegate*/
	RequestBoxDelegate objReqBoxDelegate = null;

	// 2005-08-29 kogaeng ADD
	// 요구일정자동생성을 체크하기 위해서 추가되는 Delegate
	CmtSubmtReqBoxDelegate objBean2 = null;

	ResultSetHelper objRs=null;				/**요구함 목록 */
	ResultSetHelper objCmtRs=null;			/** 연도별 위원회 */
	ResultSetHelper objRltdDutyRs=null;   /** 업무구분 리스트 출력용 RsHelper */
	ResultSetHelper objDaeRs=null;
	ResultSetHelper objYearRs=null;

	String strDaesu = null;
	String strStartdate = null;
	String strEnddate = null;
	String strStrDay = null;
	String strEndDay = null;

	String strStartdateReq = null;
	String strEnddateReq = null;
	String strStrDayReq = null;
	String strEndDayReq = null;

	String strSearchKeyword = null;
	strSearchKeyword = StringUtil.getEmptyIfNull(request.getParameter("SearchKeyword"));

	// 세션에서 검색에 필요한 키값 가져오기
	HttpSession objSession = request.getSession();
	// 요구자, 제출자 구분값
	String REQ_SUBMT_FLAG = (String)objSession.getAttribute("REQ_SUBMT_FLAG").toString();	// 요구자 : 001, 제출자 : 002
	String INOUT_GBN = (String)objSession.getAttribute("INOUT_GBN").toString();			// 요구자 : I, 제출자 : X
	// ORGAN_ID
	String ORGAN_ID = (String)objSession.getAttribute("ORGAN_ID").toString();
	// ORGAN_KIND : 의원실(003), 위원회(004)
	String ORGAN_KIND = (String)objSession.getAttribute("ORGAN_KIND").toString();

	// 제출기관, 요구기관
	String ans_organ_select = StringUtil.getEmptyIfNull(request.getParameter("ans_organ_select"));
	String ans_organ_select_id = StringUtil.getEmptyIfNull(request.getParameter("ans_organ_select_id"));
	if("".equals(ans_organ_select))	ans_organ_select_id = ""; // 기관명을 지우고 검색하면, 기관ID 값도 삭제

	String req_organ_select = StringUtil.getEmptyIfNull(request.getParameter("req_organ_select"));
	String req_organ_select_id = StringUtil.getEmptyIfNull(request.getParameter("req_organ_select_id"));
	if("".equals(req_organ_select))	req_organ_select_id = ""; // 기관명을 지우고 검색하면, 기관ID 값도 삭제

	// 소속위원회
	String CmtOrganID = StringUtil.getEmptyIfNull(request.getParameter("CmtOrganID"));
	// 등록자
	String REGR_NM = StringUtil.getEmptyIfNull(request.getParameter("REGR_NM"));

	try{
		/**요구함 정보 대리자 New */
		objReqBox=new MemRequestBoxDelegate();
		objReqBoxDelegate = new RequestBoxDelegate();

		objBean2 = new CmtSubmtReqBoxDelegate();

		objDaeRs = new ResultSetHelper(objReqBoxDelegate.getOrganDaesu(objUserInfo.getOrganID()));

		// 진행상태[요구제출자료검색 페이지용]
		strReqBoxStt2	= StringUtil.getEmptyIfNull(request.getParameter("ReqBoxStt2"));

		strStrDay		= StringUtil.getEmptyIfNull(request.getParameter("StartDate"));
		strEndDay		= StringUtil.getEmptyIfNull(request.getParameter("EndDate"));
		strStartdate	= strStrDay.replaceAll("-","");
		strEnddate		= strEndDay.replaceAll("-","");
		strDaesu		= "";

		strStrDayReq		= StringUtil.getEmptyIfNull(request.getParameter("StartDateReq"));
		strEndDayReq		= StringUtil.getEmptyIfNull(request.getParameter("EndDateReq"));
		strStartdateReq		= strStrDayReq.replaceAll("-","");
		strEnddateReq		= strEndDayReq.replaceAll("-","");

		if("".equals(strStartdate) || "".equals(strEnddate)) {
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
		}
	    Hashtable objhashdata = new Hashtable();

		objCmtRs=new ResultSetHelper(objReqBox.getReqrPerYearCMTDaeList2(objUserInfo.getOrganID(), strStartdate,strEnddate,strSelectedAuditYear));
		objYearRs = new ResultSetHelper(objReqBox.getReqrPerYearDaeList2(objUserInfo.getOrganID(), strStartdate,strEnddate));
//		대 검색
		objhashdata.put("START_DATE",strStartdate);
	    objhashdata.put("END_DATE",strEnddate);
//		요청일 검색
		objhashdata.put("START_DATE_REQ",strStartdateReq);
	    objhashdata.put("END_DATE_REQ",strEnddateReq);
//		검색어(요구함명)
		objhashdata.put("SEARCH_KEYWORD",strSearchKeyword);
//		소속위원회
		objhashdata.put("CmtOrganID",CmtOrganID);
//		요구함 등록자
		objhashdata.put("REGR_NM",REGR_NM);
//		진행상태
		objhashdata.put("REQBOXSTT2",strReqBoxStt2);
//		전자/비전자
		objhashdata.put("BOXTP",strBoxTp);
		// 계정타입
		String strRegType = "";
		// 요구자
		if("001".equals(REQ_SUBMT_FLAG)){
			// 의원실
			if("003".equals(ORGAN_KIND)){
				strRegType = "001";
			// 위원회
			}else{
				strRegType = "003";
			}
		// 제출자
		}else{
			strRegType = "002";
		}
//		계정타입
		objhashdata.put("REGTYPE",strRegType);

//		사용자 기관ID
		objhashdata.put("ORGAN_ID",ORGAN_ID);
		// 요구함 리스트 ResultSet
		objRs=new ResultSetHelper(objReqBox.getRecordDaeList2(objParams,objhashdata));
		// 업무구분 리스트 출력용 ResultSet
		objRltdDutyRs=new ResultSetHelper(objCdinfo.getRelatedDutyList());
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
	/** 					데이터 값 할당  Part 														  */
	/*************************************************************************************************/
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<title>의정자료전자유통시스템</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
<meta http-equiv="Page-Enter" content="blendTrans(Duration=.01)" />
<meta http-equiv="Page-Exit" content="blendTrans(Duration=.01)" />
<script type="text/javascript" src="/js2/jquery-1.4.2.min.js"></script>
<script type="text/javascript" src="/js2/jquery.selectbox-0.6.1.js"></script>
<script type="text/javascript" src="/js2/common.js"></script>

<script language="javascript" src="/js/reqsubmit/common.js"></script>
<link href="http://naps.assembly.go.kr/css2/style.css" rel="stylesheet" type="text/css">

</head>
<%
	// 2005-08-09 kogaeng ADD
	// 요구함 작성 메뉴 때문에 불가피하게 추가
	String strAddScript = "";
	String strAutoPopup = StringUtil.getEmptyIfNull(request.getParameter("AutoPopup"));
	if("Y".equalsIgnoreCase(strAutoPopup)) strAddScript = "AllInOne();";
%>
<body>
  <div id="container">
    <div id="rightCon">
      <!-- pgTit -->
        <h3>요구제출자료검색</h3>
      </div>
      <div id="contents">
        <!-- 검색조건 없는 경우 아래 div 삭제 나 주석으로 막으세요.-->
        <div class="schBox">
          <div class="box03">
			<table width="100%" border="0" align="center" cellpadding="2" cellspacing="0" >
				<tr>
					<td width="15%" height="25" >
						<strong>&nbsp;국회구분</strong></td>
					<td width="35%">
					    <%
							if(objDaeRs != null){
								while(objDaeRs.next()){
									String str = objDaeRs.getObject("DAE_NUM")+"^"+objDaeRs.getObject("START_DATE")+"^"+objDaeRs.getObject("END_DATE");
                                    if(str.equals(strDaesuInfo)){%>
                                        <%=objDaeRs.getObject("DAE_NUM")%>대
                                  <%}
								}
							}
						%>
					</td>
					<td width="15%">
						<strong>&nbsp;요청일</strong></td>
					<td width="35%" colspan="3">
   					    <%=strStrDayReq%> ~ <%=strEndDayReq%>
					</td>
				</tr>
				<tr>
					<td height="25">
						<strong>&nbsp;요구함 등록자</strong>
					</td>
					<td>
						<%=REGR_NM %>
					</td>
					<%if("001".equals(REQ_SUBMT_FLAG) && "I".equals(INOUT_GBN)){ // 요구자%>
					<td>
						<strong>&nbsp;제출기관</strong>
					</td>
					<td>
						<%=ans_organ_select %>
					</td>
					<%}else{ // 제출자%>
					<td>
						<strong>&nbsp;요구기관</strong>
					</td>
					<td>
						<%=req_organ_select %>
					</td>
					<%} %>
				</tr>
				<tr>
					<%if("001".equals(REQ_SUBMT_FLAG) && "I".equals(INOUT_GBN)){ //요구자 %>
					<td height="25">
						<strong>&nbsp;진행상태</strong>
					</td>
					<td>
                        <%
                            if(strReqBoxStt2.equals("")){
                                out.print("전체");
                            } else if(strReqBoxStt2.equals("003")){
                                out.print("작성중");
                            } else if(strReqBoxStt2.equals("002")){
                                out.print("접수완료");
                            } else if(strReqBoxStt2.equals("006")){
                                out.print("발송완료");
                            } else if(strReqBoxStt2.equals("007")){
                                out.print("제출완료");
                            }
                        %>
					</td>
					<%}else{ //제출자 %>
					<td >
						<strong>&nbsp;진행상태</strong>
					</td>
					<td>
                        <%
                            if(strReqBoxStt2.equals("")){
                                out.print("전체");
                            } else if(strReqBoxStt2.equals("006")){
                                out.print("작성중");
                            } else if(strReqBoxStt2.equals("007")){
                                out.print("작성완료");
						    }
                        %>
					</td>
					<%} %>
					<td>
						<strong>&nbsp;소속위원회</strong>
					</td>
					<td>
						<%
							if(objCmtRs != null && objCmtRs.getTotalRecordCount() > 0){
								while(objCmtRs.next()){
                                    if(((String)objCmtRs.getObject("ORGAN_ID")).equals(strSelectedCmtOrganID)){
                                        out.print(objCmtRs.getObject("ORGAN_NM"));
                                    }
								}
							}
						%>
					</td>
				</tr>
				<tr>
					<td height="25">
						<strong>&nbsp;업무구분</strong>
					</td>
					<td>
                        <%
                           /**업무구분 리스트 출력 */
                           while(objRltdDutyRs!=null && objRltdDutyRs.next()){
                                String strCode=(String)objRltdDutyRs.getObject("MSORT_CD");
                                if (strRltdDuty.equals(strCode)){
                                    out.print(objRltdDutyRs.getObject("CD_NM"));
                                }
                           }
                        %>
					</td>
					<td>
						<strong>&nbsp;문서유형</strong>
					</td>
					<td colspan="3">
                        <%
                            if(strBoxTp.equals("")){
                                out.print("전자/비전자");
                            } else if (strBoxTp.equals("001")){
                                out.print("전자");
                            } else if(strBoxTp.equals("005")){
                                out.print("비전자");
                            }
                        %>
					</td>
				</tr>
			</table>
            </div>
        </div>
        <!-- /검색조건-->
        <!-- 각페이지 내용 -->
        <!-- list -->
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <thead>
            <tr>
              <th scope="col" style="width:230px; ">요구함명</th>
              <th scope="col">제출기관</th>
              <th scope="col">업무구분</th>
              <th scope="col">진행상태</th>
              <th scope="col">개수(제출/요구)</th>
              <th scope="col">등록일시</th>
            </tr>
          </thead>
          <tbody>
			<%
			  if(objRs.getRecordSize()>0){
				String strReqBoxID="";
				String strReqBoxSttParam="";
				int intMakeGrdID = 0;
				while(objRs.next()){
					 strReqBoxID=(String)objRs.getObject("REQ_BOX_ID");
					 strReqBoxSttParam=(String)objRs.getObject("REQ_BOX_STT");
					 intMakeGrdID = Integer.parseInt(StringUtil.getEmptyIfNull((String)objRs.getObject("MAKE_GRD_ID"), "0"));
					 String strBgColor = "";
					 if((intMakeGrdID % 2) == 0) strBgColor = "#f4f4f4";
			 %>
            <tr>
              <td><%=(String)objRs.getObject("REQ_BOX_NM")%></td>
              <td><%=(String)objRs.getObject("SUBMT_ORGAN_NM")%></td>
              <td><%=objCdinfo.getRelatedDuty((String)objRs.getObject("RLTD_DUTY"))%></td>
              <td>
			  <%if("001".equals(REQ_SUBMT_FLAG) && "I".equals(INOUT_GBN)){ // 요구자 %>
			  <%=CodeConstants.getReqBoxStatus((String)objRs.getObject("REQ_BOX_STT"),true)%>
			  <%}else{ // 제출자 %>
        	  <%=CodeConstants.getReqBoxStatus((String)objRs.getObject("REQ_BOX_STT"),false)%>
			  <%} %>
			  </td>
              <td><%=objRs.getObject("SUBMT_CNT")%>개/<%=objRs.getObject("REQ_CNT")%>개</td>
              <td><%= StringUtil.getDate2((String)objRs.getObject("REG_DT"))%></td>
            </tr>
			<%
					}//endwhile
				}else{
			%>
			<tr>
              <td colspan="6">등록된 <%=MenuConstants.REQ_BOX_MAKE%>이 없습니다.</td>
            </tr>
			<%
			}//end if 목록 출력 끝.
			%>
          </tbody>
        </table>
  </div>
</div>
</body>
</html>
