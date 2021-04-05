<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<jsp:include page="/inc/header.jsp" flush="true"/>
<link href="/css2/style.css" rel="stylesheet" type="text/css">

<%
	//기관 Type
	String strOrganID       = StringUtil.getNVLNULL(request.getParameter("ORGAN_ID")).trim();
	String strOrganIDOrig   = request.getParameter("strOrganIDOrig");
    String strOrganType     = request.getParameter("strOrganType");
	String strUserID = StringUtil.getNVLNULL(request.getParameter("strUserID")).trim();
	String strUserRep = request.getParameter("strUserRep");
    String strType =  request.getParameter("strType");
	//session_user_id

	String strORGAN_NM 	= StringUtil.getNVLNULL(request.getParameter("ORGAN_NM")).trim();
	String strINOUT_GBN  	= StringUtil.getNVLNULL(request.getParameter("INOUT_GBN")).trim();
	String strORGAN_GBN	= StringUtil.getNVLNULL(request.getParameter("ORGAN_GBN")).trim();
	String strORGAN_KIND	= StringUtil.getNVLNULL(request.getParameter("ORGAN_KIND")).trim();
	String strPOST_CD1		= StringUtil.getNVLNULL(request.getParameter("POST_CD1")).trim();
	String strPOST_CD2		= StringUtil.getNVLNULL(request.getParameter("POST_CD2")).trim();
	String strPOST_CD		= strPOST_CD1 + strPOST_CD2;
	String strJUSO1 			= StringUtil.getNVLNULL(request.getParameter("JUSO1")).trim();
	String strJUSO2 			= StringUtil.getNVLNULL(request.getParameter("JUSO2")).trim();
	String strTEL_NUM 		= StringUtil.getNVLNULL(request.getParameter("TEL_NUM")).trim();
	String strFAX_NUM 		= StringUtil.getNVLNULL(request.getParameter("FAX_NUM")).trim();
	String strHOME_URL 	= StringUtil.getNVLNULL(request.getParameter("HOME_URL")).trim();
	String strDUTY_SIZE 	= StringUtil.getNVLNULL(request.getParameter("DUTY_SIZE")).trim();
	String strGOV_GBN 		= StringUtil.getNVLNULL(request.getParameter("GOV_GBN")).trim();
	String strGOV_STD_CD = StringUtil.getNVLNULL(request.getParameter("GOV_STD_CD")).trim();
	String strSTT_CD 		= StringUtil.getNVLNULL(request.getParameter("STT_CD")).trim();
	String strREMARK  		= StringUtil.getNVLNULL(request.getParameter("REMARK")).trim();
	String strBUSEORANKING  	= StringUtil.getNVLNULL(request.getParameter("BUSEORANKING")).trim();
	String strBUSEOCODE  		= StringUtil.getNVLNULL(request.getParameter("BUSEOCODE")).trim();
	String strReqSubmtCd = StringUtil.getNVLNULL(request.getParameter("strReqSubmtCd")).trim();

	//사업자등록번호
	String strOrganNo1 = StringUtil.getNVLNULL(request.getParameter("strOrganNo1")).trim();
	String strOrganNo2 = StringUtil.getNVLNULL(request.getParameter("strOrganNo2")).trim();
	String strOrganNo3 = StringUtil.getNVLNULL(request.getParameter("strOrganNo3")).trim();
	String strOrganNo = strOrganNo1 + strOrganNo2 + strOrganNo3;

	Vector objParam = new Vector();

	objParam.add(strORGAN_NM);			//idx : 0
	objParam.add(strINOUT_GBN);			//1
	objParam.add(strORGAN_GBN);
	objParam.add(strORGAN_KIND);
	objParam.add(strGOV_GBN);				//4
	objParam.add(strGOV_STD_CD);
	objParam.add(strSTT_CD);
	objParam.add(strTEL_NUM);
	objParam.add(strFAX_NUM);
	objParam.add(strPOST_CD);
	objParam.add(strJUSO1);					//idx: 10
	objParam.add(strJUSO2);
	objParam.add(strHOME_URL);
	objParam.add(strDUTY_SIZE);
	objParam.add(strREMARK);
	objParam.add(strBUSEORANKING);
	objParam.add(strBUSEOCODE);
	objParam.add(strReqSubmtCd);
	objParam.add(strORGAN_NM);
	objParam.add(strOrganNo);
	objParam.add(strUserID);


	nads.dsdm.app.join.JoinMemberDelegate objJoinMemberDelegate = new nads.dsdm.app.join.JoinMemberDelegate();
	int result=0;
	try {
        if (strType.equals("save")){
            objParam.add(strOrganID);
            result=objJoinMemberDelegate.updateOrganInfo(objParam);
            //이력정보 기록
            result+=objJoinMemberDelegate.insertOrganHistory(strOrganID,"기관정보 수정",strUserID+"님이 수정");
        } else {
            result=objJoinMemberDelegate.deleteOrganRel(strOrganID);
            //이력정보 기록
            result+=objJoinMemberDelegate.insertOrganHistory(strOrganID,"기관정보 삭제",strUserID+"님이 수정");
        }
	} catch (AppException objAppEx) {
		return;
	}
%>
   	<form name="frmOrgan" method="post">
		<input type="hidden" name="strOrganID" value="<%=strOrganID%>"/>
		<input type="hidden" name="strOrganIDOrig" value="<%=strOrganIDOrig%>"/>
		<input type="hidden" name="strOrganType" value="<%=strOrganType%>"/>
		<input type="hidden" name="strUserID" value="<%=strUserID%>"/>
		<input type="hidden" name="strUserRep" value="<%=strUserRep%>"/>
	</form>

<%
    if (strType.equals("save")){%>
	<script language="javascript">
	<!--
		if(<%=result%>>0){
			alert("수정 되었습니다.");
		}
		frmOrgan.action = "OrganInfo.jsp";
		frmOrgan.submit();
	//-->
	</script>
<%} else {%>
	<script language="javascript">
	<!--
		if(<%=result%>>0){
			alert("삭제 되었습니다.");
		}
        parent.location.href="http://nafs.assembly.go.kr/activity/OrganInfoMng.jsp";
	//-->
	</script>
<%}%>