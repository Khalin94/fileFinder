<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="nads.dsdm.app.forum.SLDBForumDelegate" %>
<%@ page import="nads.dsdm.app.common.ums.UmsInfoDelegate" %>
<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.pf.exception.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="kr.co.kcc.bf.config.*" %>
<%@ page import="java.io.*" %>
<%@ page import="nads.lib.session.*" %>
<%@ page import="nads.lib.message.MessageBean" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%@ include file="/common/CheckSession.jsp" %>

<%
	/* �޾ƿ� �Ķ���� */
	String strGbn = StringUtil.getNVLNULL(request.getParameter("gbn")); 
	//������ (ȸ������:joinUser ȸ��Ż��:leaveUser ����ȸ������:joinFUser ����ȸ��Ż��:leaveFUser)
	String strForumID = StringUtil.getNVLNULL(request.getParameter("fid")); //����ID
	String strRUserID = StringUtil.getNVLNULL(request.getParameter("Ruid")); //������ID
	String strForumForceLeaveRsn = StringUtil.getNVLNULL(request.getParameter("fRsn")); //���� ����Ż�� ����

	String strSessInOutGbn = (String)session.getAttribute("INOUT_GBN");

	/*
	SELECT A.FORUM_NM, D.CD_NM FORUM_SORT, A.FORUM_INTRO, 
		   B.JOIN_TS, B.OPRTR_GBN, B.JOIN_RSN,  
		   C.USER_NM R_USER_NM, C.CPHONE, C.DEPT_NM R_DEPT_NM, C.EMAIL R_EMAIL,
	       E.USER_ID S_USER_ID, E.USER_NM S_USER_NM, E.EMAIL S_EMAIL, G.ORGAN_NM S_ORGAN_NM, G.GOV_STD_CD S_GOV_STD_CD
	FROM TBDM_FORUM A, TBDM_FORUM_USER B, TBDM_USER_INFO C, TBDM_CD_INFO D, TBDM_USER_INFO E, TBDM_BRG_DEPT F, TBDM_ORGAN G
	WHERE A.FORUM_ID = '0000000035'
	AND A.FORUM_ID = B.FORUM_ID
	AND B.USER_ID = '0000018684'
	AND B.USER_ID = C.USER_ID
	AND D.BSORT_CD = 'M02'
	AND A.FORUM_SORT = D.MSORT_CD
	AND A.FORUM_OPRTR_ID = E.USER_ID
	AND F.USER_ID = E.USER_ID
	AND F.ORG_POSI_GBN = '1'
	AND F.ORGAN_ID = G.ORGAN_ID

 	SELECT A.USER_NM R_USER_NM, A.CPHONE, NVL(A.DEPT_NM, F.ORGAN_NM) R_DEPT_NM, A.EMAIL R_EMAIL, 
		   B.USER_ID S_USER_ID, B.USER_NM S_USER_NM, B.EMAIL S_EMAIL, D.ORGAN_NM S_ORGAN_NM, D.GOV_STD_CD S_GOV_STD_CD 
	FROM TBDM_USER_INFO A,  TBDM_BRG_DEPT E, TBDM_ORGAN F, 
						(SELECT USER_ID, USER_NM, EMAIL
						FROM TBDM_USER_INFO
						WHERE USER_GRP_ID = '0000000002'
						AND ROWNUM < 2) B, TBDM_BRG_DEPT C, TBDM_ORGAN D
	WHERE A.USER_ID = '0000020711'
	AND A.USER_ID = E.USER_ID
	AND E.ORG_POSI_GBN = '1'
	AND E.ORGAN_ID = F.ORGAN_ID
	AND B.USER_ID = C.USER_ID
	AND C.ORG_POSI_GBN = '1'
	AND C.ORGAN_ID = D.ORGAN_I
	*/

	
	String strForumNM = "";
	String strForumSort = "";
	String strForumIntro = "";
	String strForumJoinTS = "";
	String strForumOprtrGbn = "";
	//String strForumJoinRsn = "";

	String strRUserNM = "";
	//String strCPhone = "";
	//String strRDeptNM = "";
	String strREmail = "";

	String strSUserID = "";
	String strSUserNM = "";
	String strSOrganNM = "";
	String strSEmail = "";
	String strSGovStdCd = "";
	String strSOrganID = "";

	/* DB�κ��� ���Ͽ� ���� ���� �о���� START */
	try {

		SLDBForumDelegate objForum = new SLDBForumDelegate();

		Hashtable objHashData = objForum.selectMailInfo(strForumID, strRUserID);

		if(!strForumID.equals("")) {
			strForumNM = StringUtil.getNVLNULL((String)objHashData.get("FORUM_NM")); //������
			strForumSort = StringUtil.getNVLNULL((String)objHashData.get("FORUM_SORT")); //�����з�
			strForumSort = strForumSort.replaceAll("/","@1");

			strForumIntro = StringUtil.getNVLNULL((String)objHashData.get("FORUM_INTRO")); //�����Ұ�
			strForumIntro = strForumIntro.replaceAll("\n","@@");
			strForumIntro = strForumIntro.replaceAll("\r","");
			strForumIntro = strForumIntro.replaceAll("/","@1");

			strForumJoinTS =  StringUtil.getNVLNULL((String)objHashData.get("JOIN_TS")); //��������
			strForumOprtrGbn =  StringUtil.getNVLNULL((String)objHashData.get("OPRTR_GBN")); //ȸ������
			//strForumJoinRsn =  StringUtil.getNVLNULL((String)objHashData.get("JOIN_RSN")); //�����λ縻
		}

		strRUserNM = StringUtil.getNVLNULL((String)objHashData.get("R_USER_NM")); //�������̸�
		//strCPhone = StringUtil.getNVLNULL((String)objHashData.get("CPHONE")); //��ȭ��ȣ
		strREmail = StringUtil.getNVLNULL((String)objHashData.get("R_EMAIL")); //�������̸���
		//strRDeptNM = StringUtil.getNVLNULL((String)objHashData.get("R_DEPT_NM")); //�����ںμ���

		strSUserID = StringUtil.getNVLNULL((String)objHashData.get("S_USER_ID")); //�߽���ID
		strSUserNM = StringUtil.getNVLNULL((String)objHashData.get("S_USER_NM")); //�߽����̸�
		strSEmail = StringUtil.getNVLNULL((String)objHashData.get("S_EMAIL")); //�߽����̸���
		strSOrganNM = StringUtil.getNVLNULL((String)objHashData.get("S_ORGAN_NM")); //�߽��ںμ���
		strSGovStdCd = StringUtil.getNVLNULL((String)objHashData.get("S_GOV_STD_CD")); //�߽��ںμ�ID
		strSOrganID = StringUtil.getNVLNULL((String)objHashData.get("S_ORGAN_ID")); //�߽��ںμ�ID (�����)
		if(strSGovStdCd.equals(""))
			strSGovStdCd = "0000000";

		if(strSOrganID.equals(""))
			strSOrganID = "0000000000";
		
	} catch (AppException objAppEx) {
		
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		objMsgBean.setStrCode(objAppEx.getStrErrCode());
		objMsgBean.setStrMsg(objAppEx.getMessage());

		// ���� �߻� �޼��� �������� �̵��Ѵ�.
%>

		<jsp:forward page="/common/message/ViewMsg.jsp"/>

<%
		return;
		
	}
	/* DB�κ��� ���Ͽ� ���� ���� �о���� END */


	/* ���ϳ��� START */
	String webURL = ""; //http �ּ�
	try {

		Config objConfig = PropertyConfig.getInstance(); //������Ƽ
		webURL = objConfig.get("nads.dsdm.url");

	} catch (ConfigException objConfigEx) {
		out.println(objConfigEx.toString() + "<br>");
		return;
	}

	String strMailContentURL = webURL + "/newsletter/";

	if(strForumID.equals("")) { //ȸ������/Ż��
		strMailContentURL += "SendUser.jsp?gbn="+strGbn+"&inout="+strSessInOutGbn+"&uid="+strRUserID;
	} else {
		strMailContentURL += "SendForum.jsp?gbn="+strGbn+"&inout="+strSessInOutGbn+"&uid="+strRUserID;
		strMailContentURL += "&fNM=" + strForumNM + "&fSort=" + strForumSort + "&fIntro="+ strForumIntro;
		strMailContentURL += "&fJTs=" + strForumJoinTS + "&fOGbn=" + strForumOprtrGbn;
	}

	//strMailContentURL += "&uNM=" + strRUserNM + "&cPH=" + strCPhone + "&dNM=" + strRDeptNM + "&eM=" + strREmail;

	if(!strForumForceLeaveRsn.equals("")) {
		strForumForceLeaveRsn = strForumForceLeaveRsn.replaceAll("\n","@@");
		strForumForceLeaveRsn = strForumForceLeaveRsn.replaceAll("\r","");
		strForumForceLeaveRsn = strForumForceLeaveRsn.replaceAll("/","@1");
		strMailContentURL += "&fRsn=" + strForumForceLeaveRsn;
	}

	//out.print(strMailContentURL+"<br>length:"+strMailContentURL.length());
	/* ���ϳ��� END */


	/* ���Ϻ����� START */
	try {

		UmsInfoDelegate objUmsInfo = new UmsInfoDelegate();
		Hashtable objHashData = new Hashtable();
		int intResult = 0;

		String strSubject   = ""; //����
		String strServiceGbn = ""; //���񽺱��� (ȸ������:001 ȸ��Ż��:002 ����ȸ������:003 ����ȸ��Ż��:004)
		if(strGbn.equals("joinUser")) {
			strSubject = "[�����ڷ� �������� �ý���]����ڵ���� ���ϵ帳�ϴ�.";
			strServiceGbn = "001";
		} else if(strGbn.equals("leaveUser")) {
			strSubject = "[�����ڷ� �������� �ý���]�����Ż�� �Ǿ����ϴ�.";
			strServiceGbn = "002";
		} else if(strGbn.equals("joinFUser")) {
			strSubject = "[�����ڷ� �������� �ý���]" + strForumNM + " ���������� ���ϵ帳�ϴ�.";
			strServiceGbn = "003";
		} else {
			strSubject = "[�����ڷ� �������� �ý���]" + strForumNM + " ���� Ż���ϼ̽��ϴ�.";
			strServiceGbn = "004";
		}

		String strStatus    = "0"; //���ۻ���(���۴��='9' ���ۿ�û = '0')
		String strSystemGbn  = "S13002"; //�ý��۱���(��������:S13002)

		//����������
		objHashData.put("RID", strRUserID); //������ID
		objHashData.put("RNAME", strRUserNM); //�����ڸ�
		objHashData.put("RMAIL", strREmail); //������ �̸���
		//�߽�������
		objHashData.put("SID", strSUserID); //�߽���ID
		objHashData.put("SNAME", strSUserNM); //�߽��ڸ�
		objHashData.put("SMAIL", strSEmail); //�߽��� �̸���

		objHashData.put("SUBJECT", strSubject); //����
		objHashData.put("CONTENTS", strMailContentURL); //����
		objHashData.put("SYSTEM_GBN", strSystemGbn); //�ý��۱���
		objHashData.put("SERVICE_GBN", strServiceGbn); //���񽺱���
		objHashData.put("STATUS", strStatus); //���ۻ���
		//objHashData.put("DEPT_GBN", strSGovStdCd); //�μ�����(�μ�ID)
		objHashData.put("DEPT_GBN", strSOrganID); //�μ�����(�μ�ID)
		objHashData.put("DEPT_NM", strSOrganNM); //�μ���

		intResult = objUmsInfo.insertSMTP_WEB_REC(objHashData);
		
		if(intResult != 0 ){
			//out.println("<br>���� ����<br>");
		}

		if (intResult < 1) {
%>
			<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
			return;
		}
		
	} catch (AppException objAppEx) {
		
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		objMsgBean.setStrCode(objAppEx.getStrErrCode());
		objMsgBean.setStrMsg(objAppEx.getMessage());

		// ���� �߻� �޼��� �������� �̵��Ѵ�.
%>

		<jsp:forward page="/common/message/ViewMsg.jsp"/>

<%
		return;
		
	}

	//out.print("<br>���� ������ ����");
	/* ���Ϻ����� END */
%>