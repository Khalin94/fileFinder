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
    System.out.println("�ռ���----------------------------------------------------------------");
    /*** PagingDelegate */
	PagingDelegate objPaging=new PagingDelegate(); 		/*����¡ ��ȯ Delegate*/
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
	/** 					�Ķ���� üũ Part 														  */
	/*************************************************************************************************/
	/**���õ� ����⵵�� ���õ� ����ȸID*/
	String strSelectedAuditYear= null; /**���õ� ����⵵*/
	String strSelectedCmtOrganID=null; /**���õ� ����ȸID*/
	String strRltdDuty=null;	/**���õ� �������� */
	String strDaeSuCh = null;
	String strCmtGubun = objUserInfo.getOrganGBNCode();	/**(�ۼ��� �䱸�� ��ȸ�� �ʿ�)*/
	String strBoxTp = null;			/**���õ� ���ں����ڱ���(����Ϸ� �䱸�� ��ȸ�� �ʿ�)*/
	String strReqBoxStt = null;		/**���õ� �������*/
	String strReqBoxStt2 = null;	/**���õ� �������2[�䱸�����ڷ�˻� �뵵(����Ʈ���� ������ ������ ������� ������ ����Ѵ�.)]*/

	/**�䱸�� �����ȸ�� �Ķ���� ����.*/
	RMemReqBoxListForm objParams=new RMemReqBoxListForm();

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
	strBoxTp=objParams.getParamValue("BoxTp") ;		/**���õ� ���ں����ڱ���(����Ϸ� �䱸�� ��ȸ�� �ʿ�)*/
	strReqBoxStt=objParams.getParamValue("ReqBoxStt") ;	/**���õ� �������*/

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
	String strStrDay = null;
	String strEndDay = null;

	String strStartdateReq = null;
	String strEnddateReq = null;
	String strStrDayReq = null;
	String strEndDayReq = null;

	String strSearchKeyword = null;
	strSearchKeyword = StringUtil.getEmptyIfNull(request.getParameter("SearchKeyword"));

	// ���ǿ��� �˻��� �ʿ��� Ű�� ��������
	HttpSession objSession = request.getSession();
	// �䱸��, ������ ���а�
	String REQ_SUBMT_FLAG = (String)objSession.getAttribute("REQ_SUBMT_FLAG").toString();	// �䱸�� : 001, ������ : 002
	String INOUT_GBN = (String)objSession.getAttribute("INOUT_GBN").toString();			// �䱸�� : I, ������ : X
	// ORGAN_ID
	String ORGAN_ID = (String)objSession.getAttribute("ORGAN_ID").toString();
	// ORGAN_KIND : �ǿ���(003), ����ȸ(004)
	String ORGAN_KIND = (String)objSession.getAttribute("ORGAN_KIND").toString();

	// ������, �䱸���
	String ans_organ_select = StringUtil.getEmptyIfNull(request.getParameter("ans_organ_select"));
	String ans_organ_select_id = StringUtil.getEmptyIfNull(request.getParameter("ans_organ_select_id"));
	if("".equals(ans_organ_select))	ans_organ_select_id = ""; // ������� ����� �˻��ϸ�, ���ID ���� ����

	String req_organ_select = StringUtil.getEmptyIfNull(request.getParameter("req_organ_select"));
	String req_organ_select_id = StringUtil.getEmptyIfNull(request.getParameter("req_organ_select_id"));
	if("".equals(req_organ_select))	req_organ_select_id = ""; // ������� ����� �˻��ϸ�, ���ID ���� ����

	// �Ҽ�����ȸ
	String CmtOrganID = StringUtil.getEmptyIfNull(request.getParameter("CmtOrganID"));
	// �����
	String REGR_NM = StringUtil.getEmptyIfNull(request.getParameter("REGR_NM"));

	try{
		/**�䱸�� ���� �븮�� New */
		objReqBox=new MemRequestBoxDelegate();
		objReqBoxDelegate = new RequestBoxDelegate();

		objBean2 = new CmtSubmtReqBoxDelegate();

		objDaeRs = new ResultSetHelper(objReqBoxDelegate.getOrganDaesu(objUserInfo.getOrganID()));

		// �������[�䱸�����ڷ�˻� ��������]
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
//		�� �˻�
		objhashdata.put("START_DATE",strStartdate);
	    objhashdata.put("END_DATE",strEnddate);
//		��û�� �˻�
		objhashdata.put("START_DATE_REQ",strStartdateReq);
	    objhashdata.put("END_DATE_REQ",strEnddateReq);
//		�˻���(�䱸�Ը�)
		objhashdata.put("SEARCH_KEYWORD",strSearchKeyword);
//		�Ҽ�����ȸ
		objhashdata.put("CmtOrganID",CmtOrganID);
//		�䱸�� �����
		objhashdata.put("REGR_NM",REGR_NM);
//		�������
		objhashdata.put("REQBOXSTT2",strReqBoxStt2);
//		����/������
		objhashdata.put("BOXTP",strBoxTp);
		// ����Ÿ��
		String strRegType = "";
		// �䱸��
		if("001".equals(REQ_SUBMT_FLAG)){
			// �ǿ���
			if("003".equals(ORGAN_KIND)){
				strRegType = "001";
			// ����ȸ
			}else{
				strRegType = "003";
			}
		// ������
		}else{
			strRegType = "002";
		}
//		����Ÿ��
		objhashdata.put("REGTYPE",strRegType);

//		����� ���ID
		objhashdata.put("ORGAN_ID",ORGAN_ID);
		// �䱸�� ����Ʈ ResultSet
		objRs=new ResultSetHelper(objReqBox.getRecordDaeList2(objParams,objhashdata));
		// �������� ����Ʈ ��¿� ResultSet
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
	/** 					������ �� �Ҵ�  Part 														  */
	/*************************************************************************************************/
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<title>�����ڷ���������ý���</title>
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
	// �䱸�� �ۼ� �޴� ������ �Ұ����ϰ� �߰�
	String strAddScript = "";
	String strAutoPopup = StringUtil.getEmptyIfNull(request.getParameter("AutoPopup"));
	if("Y".equalsIgnoreCase(strAutoPopup)) strAddScript = "AllInOne();";
%>
<body>
  <div id="container">
    <div id="rightCon">
      <!-- pgTit -->
        <h3>�䱸�����ڷ�˻�</h3>
      </div>
      <div id="contents">
        <!-- �˻����� ���� ��� �Ʒ� div ���� �� �ּ����� ��������.-->
        <div class="schBox">
          <div class="box03">
			<table width="100%" border="0" align="center" cellpadding="2" cellspacing="0" >
				<tr>
					<td width="15%" height="25" >
						<strong>&nbsp;��ȸ����</strong></td>
					<td width="35%">
					    <%
							if(objDaeRs != null){
								while(objDaeRs.next()){
									String str = objDaeRs.getObject("DAE_NUM")+"^"+objDaeRs.getObject("START_DATE")+"^"+objDaeRs.getObject("END_DATE");
                                    if(str.equals(strDaesuInfo)){%>
                                        <%=objDaeRs.getObject("DAE_NUM")%>��
                                  <%}
								}
							}
						%>
					</td>
					<td width="15%">
						<strong>&nbsp;��û��</strong></td>
					<td width="35%" colspan="3">
   					    <%=strStrDayReq%> ~ <%=strEndDayReq%>
					</td>
				</tr>
				<tr>
					<td height="25">
						<strong>&nbsp;�䱸�� �����</strong>
					</td>
					<td>
						<%=REGR_NM %>
					</td>
					<%if("001".equals(REQ_SUBMT_FLAG) && "I".equals(INOUT_GBN)){ // �䱸��%>
					<td>
						<strong>&nbsp;������</strong>
					</td>
					<td>
						<%=ans_organ_select %>
					</td>
					<%}else{ // ������%>
					<td>
						<strong>&nbsp;�䱸���</strong>
					</td>
					<td>
						<%=req_organ_select %>
					</td>
					<%} %>
				</tr>
				<tr>
					<%if("001".equals(REQ_SUBMT_FLAG) && "I".equals(INOUT_GBN)){ //�䱸�� %>
					<td height="25">
						<strong>&nbsp;�������</strong>
					</td>
					<td>
                        <%
                            if(strReqBoxStt2.equals("")){
                                out.print("��ü");
                            } else if(strReqBoxStt2.equals("003")){
                                out.print("�ۼ���");
                            } else if(strReqBoxStt2.equals("002")){
                                out.print("�����Ϸ�");
                            } else if(strReqBoxStt2.equals("006")){
                                out.print("�߼ۿϷ�");
                            } else if(strReqBoxStt2.equals("007")){
                                out.print("����Ϸ�");
                            }
                        %>
					</td>
					<%}else{ //������ %>
					<td >
						<strong>&nbsp;�������</strong>
					</td>
					<td>
                        <%
                            if(strReqBoxStt2.equals("")){
                                out.print("��ü");
                            } else if(strReqBoxStt2.equals("006")){
                                out.print("�ۼ���");
                            } else if(strReqBoxStt2.equals("007")){
                                out.print("�ۼ��Ϸ�");
						    }
                        %>
					</td>
					<%} %>
					<td>
						<strong>&nbsp;�Ҽ�����ȸ</strong>
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
						<strong>&nbsp;��������</strong>
					</td>
					<td>
                        <%
                           /**�������� ����Ʈ ��� */
                           while(objRltdDutyRs!=null && objRltdDutyRs.next()){
                                String strCode=(String)objRltdDutyRs.getObject("MSORT_CD");
                                if (strRltdDuty.equals(strCode)){
                                    out.print(objRltdDutyRs.getObject("CD_NM"));
                                }
                           }
                        %>
					</td>
					<td>
						<strong>&nbsp;��������</strong>
					</td>
					<td colspan="3">
                        <%
                            if(strBoxTp.equals("")){
                                out.print("����/������");
                            } else if (strBoxTp.equals("001")){
                                out.print("����");
                            } else if(strBoxTp.equals("005")){
                                out.print("������");
                            }
                        %>
					</td>
				</tr>
			</table>
            </div>
        </div>
        <!-- /�˻�����-->
        <!-- �������� ���� -->
        <!-- list -->
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <thead>
            <tr>
              <th scope="col" style="width:230px; ">�䱸�Ը�</th>
              <th scope="col">������</th>
              <th scope="col">��������</th>
              <th scope="col">�������</th>
              <th scope="col">����(����/�䱸)</th>
              <th scope="col">����Ͻ�</th>
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
			  <%if("001".equals(REQ_SUBMT_FLAG) && "I".equals(INOUT_GBN)){ // �䱸�� %>
			  <%=CodeConstants.getReqBoxStatus((String)objRs.getObject("REQ_BOX_STT"),true)%>
			  <%}else{ // ������ %>
        	  <%=CodeConstants.getReqBoxStatus((String)objRs.getObject("REQ_BOX_STT"),false)%>
			  <%} %>
			  </td>
              <td><%=objRs.getObject("SUBMT_CNT")%>��/<%=objRs.getObject("REQ_CNT")%>��</td>
              <td><%= StringUtil.getDate2((String)objRs.getObject("REG_DT"))%></td>
            </tr>
			<%
					}//endwhile
				}else{
			%>
			<tr>
              <td colspan="6">��ϵ� <%=MenuConstants.REQ_BOX_MAKE%>�� �����ϴ�.</td>
            </tr>
			<%
			}//end if ��� ��� ��.
			%>
          </tbody>
        </table>
  </div>
</div>
</body>
</html>
