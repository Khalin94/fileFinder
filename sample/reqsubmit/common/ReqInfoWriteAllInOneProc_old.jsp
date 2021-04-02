<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RMemReqBoxWriteForm"%>
<%@ page import="nads.lib.reqsubmit.params.requestinfo.RMemReqInfoWriteForm"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.all.ReqInfoAllInOneDelegate" %>
<%@ page import="nads.lib.reqsubmit.form.RequestWrapper" %>
<%@ page import="nads.lib.reqsubmit.*" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	UserInfoDelegate objUserInfo =null;
	CDInfoDelegate objCdinfo =null;
%>

<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>

<%
	/*************************************************************************************************/
	/** 					파라미터 체크 Part 														  */
	/*************************************************************************************************/
	boolean blnParamCheck1 = false;
	boolean blnParamCheck2 = false;

	/**전달된 파리미터 체크 */
	/**Multipart일경우 반드시 이녀석을 이용해서 담의 Valid파람으로 넘겨줘야함 */
	RequestWrapper objRequestWrapper = null;
	try {
		objRequestWrapper = new RequestWrapper(request);
	} catch(java.io.IOException ex) {
		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
		objMsgBean.setStrCode("DSPARAM-0010");
		objMsgBean.setStrMsg("업로드할 파일사이즈를 초과하였습니다. 제한된 파일사이즈를 확인해 주세요!!");
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}

	/** 요구함 생성위한 세션 파라미터 설정.*/
	RMemReqBoxWriteForm objReqBox = new RMemReqBoxWriteForm();
	RMemReqInfoWriteForm objReqInfo = new RMemReqInfoWriteForm();
	ReqInfoAllInOneDelegate objAllInOne = new ReqInfoAllInOneDelegate();

	blnParamCheck1 = objReqBox.validateParams(objRequestWrapper);
	blnParamCheck2 = objReqInfo.validateParams(objRequestWrapper);

	String strReqBoxTp = StringUtil.getEmptyIfNull(objReqBox.getParamValue("ReqBoxTp"));
	String strReqBoxNm = this.checkNull(objReqBox.getParamValue("req_box_nm"));
	String strNatCnt = StringUtil.getEmptyIfNull(objReqBox.getParamValue("NatCnt"));

	strReqBoxNm = "제"+strNatCnt+"회 "+strReqBoxNm;


	String strRefreshURL = "";
	String strReqBoxStt = "";
	if(CodeConstants.REQ_BOX_TP_CMT.equals(strReqBoxTp)) {
		strRefreshURL = "/reqsubmit/20_comm/20_reqboxsh/20_accend/RAccBoxList.jsp";
		strReqBoxStt = CodeConstants.REQ_BOX_STT_002;
	} else {
		strRefreshURL = "/reqsubmit/10_mem/20_reqboxsh/10_make/RMakeReqBoxList.jsp";
		strReqBoxStt = CodeConstants.REQ_BOX_STT_003;
	}

	String strSubOrganID = StringUtil.getEmptyIfNull(objReqBox.getParamValue("SubmtOrganID"));
	String strSubmtOrganNM = StringUtil.getEmptyIfNull(objReqBox.getParamValue("SubmtOrganNM"));
	String SubmtOrganID[] = strSubOrganID.split(",");
	String SubmtOrganNM[] = strSubmtOrganNM.split(",");

	/**전달된 파리미터 체크 */
	objReqBox.setParamValue("RegrID",objUserInfo.getUserID());	//요구자 ID설정.
	objReqBox.setParamValue("ReqOrganID",objUserInfo.getOrganID());//요구기관을 세션에서 넣어줌.
	objReqBox.setParamValue("ReqBoxStt", strReqBoxStt);

	objReqInfo.setParamValue("ReqOrganID",objUserInfo.getOrganID());//요구기관을 세션에서 넣어줌.
	objReqInfo.setParamValue("RegrID",objUserInfo.getUserID());//요구생성자를 세션에서 넣어줌.

	if(blnParamCheck1==false) {
	  	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
	  	objMsgBean.setStrCode("DSPARAM-0000");
	  	objMsgBean.setStrMsg(objReqBox.getStrErrors());
	  	//out.println("ParamError:" + objParams.getStrErrors());
%>
  		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
	  	return;

	}

	if(blnParamCheck2==false){
	  	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
	  	objMsgBean.setStrCode("DSPARAM-0000");
	  	objMsgBean.setStrMsg(objReqInfo.getStrErrors());
	  	//out.println("ParamError:" + objParams.getStrErrors());
%>
  		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
  		return;
  	}
%>

<%
	/*************************************************************************************************/
	/** 					데이터 처리 Part 														  */
	/*************************************************************************************************/

	String strReqBoxID = "";//반환될 요구함번호 받기.
	String strTemp = "";

	try {

		// 2005-09-20 kogaeng ADD
		// 요구함 통합 등록 시 등록요구함들을 그룹 ID로 묶어서 저장한다.
		String strMakeGrdID = objAllInOne.getMakeGrdID();
		objReqBox.setParamValue("MakeGrdID", strMakeGrdID);

		/********* 대리자 정보 설정 *********/
		String[] strSubmitOrganID = new String[SubmtOrganID.length];
		String[] strCmtOrganID = new String[SubmtOrganID.length];
		//System.out.println("SubmtOrganID.length :"+SubmtOrganID.length);

		String strTitle = "";
		String strContent = "";
		strTitle = this.checkNull(objReqInfo.getParamValue("TempTitle"));
		strContent = this.checkNull(objReqInfo.getParamValue("TempContent"));



		System.out.println("strTitle "+strTitle);
		System.out.println("strContent "+strContent);

		String TITLEINFO[] = strTitle.split("Ω");
		String CONTENTINFO[] = strContent.split("Ω");
		String strReqID= "";
		String strOrgNameTemp = null;
		boolean flag = false;

		for(int z = 0; z < CONTENTINFO.length; z++) {

			String strAnsEstyleFilePathTemp = "";
			if(objReqInfo.getParamValue("AnsEstyleFilePath"+z).equals("")){
				strAnsEstyleFilePathTemp = "　";
			}else{
				strAnsEstyleFilePathTemp = objReqInfo.getParamValue("AnsEstyleFilePath"+z);
			}
			System.out.println("strAnsEstyleFilePath : "+strAnsEstyleFilePathTemp);
			strOrgNameTemp = strAnsEstyleFilePathTemp;
			if((strOrgNameTemp.trim()).equals("　")){
				strOrgNameTemp = "success.hwp";
			}
			System.out.println("strOrgNameTemp : "+strOrgNameTemp);
			int pos = strOrgNameTemp.lastIndexOf(".");
			//String[] strExtensions = nads.lib.reqsubmit.util.StringUtil.split(".",strOrgNameTemp);
			String strExtension = strOrgNameTemp.substring(pos+1);
			strExtension = strExtension.toLowerCase();
			String[] strEx = {"hwp", "pdf", "zip", "alz", "doc", "ppt", "xls", "txt","xlsx"};

			for(int i = 0; i < strEx.length ; i++){
				if(strEx[i].equals(strExtension)){
					flag = true;
				}
			}
			if(flag == false){
				out.println("<script language=javascript>");
				out.println("parent.notProcessing();");
				out.println("alert('hwp,pdf,zip,alz,doc,ppt,xls,txt 형식의 파일만 업로드가능합니다.');");

				out.println("</script>");
				return;
			}
			flag = false;
		}


		for(int i = 0; i<SubmtOrganID.length;i++) {
			String tempOrganID[] = StringUtil.split("^", SubmtOrganID[i]);
			strSubmitOrganID[i] = tempOrganID[1];
			strCmtOrganID[i] = tempOrganID[0];
			String ReqBoxNm = strReqBoxNm;
			objReqBox.setParamValue("SubmtOrganID",strSubmitOrganID[i]);
			objReqBox.setParamValue("CmtOrganID",strCmtOrganID[i]);
			ReqBoxNm = this.strReplaceString(ReqBoxNm);
			objReqBox.setParamValue("req_box_nm",ReqBoxNm);
			System.out.println("strReqBoxNm : "+ReqBoxNm);

			/********* 등록실행하기  **************/
			strTemp = objAllInOne.setNewRecord1(objReqBox);
			if(i == SubmtOrganID.length-1) strReqBoxID = strReqBoxID+strTemp;
			else strReqBoxID = strReqBoxID+strTemp+",";
		}

		//System.out.println("strReqBoxID :"+strReqBoxID);

		if(strReqBoxID.equalsIgnoreCase("False")) {
			objMsgBean.setMsgType(MessageBean.TYPE_WARN);
			objMsgBean.setStrCode("DSDATA-0010");
%>
			<script language="JavaScript">
				alert("신규 요구함 등록 정보가 중복되었습니다.");
				history.go(-1);
			</script>
<%
			return;
		}


		//System.out.println("strTitle :"+strTitle);
		//System.out.println("strContent :"+strContent);

		String REQBOXID[] = strReqBoxID.split(",");


		for(int k = 0 ; k < REQBOXID.length; k++) {
			objReqInfo.setParamValue("ReqBoxID",REQBOXID[k]);
			for(int n = 0; n < CONTENTINFO.length; n++) {
				System.out.println(TITLEINFO[n]);
				System.out.println(CONTENTINFO[n]);
				objReqInfo.setParamValue("ReqCont", this.checkNull(this.strReplaceString(TITLEINFO[n])));
				objReqInfo.setParamValue("ReqDtlCont", this.checkNull(this.strReplaceString(CONTENTINFO[n])));

				String strAnsEstyleFilePath = "";
				if(objReqInfo.getParamValue("AnsEstyleFilePath"+n).equals("")){
					strAnsEstyleFilePath = "　";
				}else{
					strAnsEstyleFilePath = objReqInfo.getParamValue("AnsEstyleFilePath"+n);
				}
				objReqInfo.setParamValue("AnsEstyleFilePath", strAnsEstyleFilePath);

				objReqInfo.setParamValue("Times", String.valueOf(n));
				System.out.println(TITLEINFO[n]);
				System.out.println(CONTENTINFO[n]);

				strReqID = objAllInOne.setNewRecord2(objReqInfo);
			}
		}

		//objAllInOne.deleteFile(objReqInfo);

		if(!StringUtil.isAssigned(strReqID)) {
			objMsgBean.setMsgType(MessageBean.TYPE_WARN);
			objMsgBean.setStrCode("DSDATA-0011");
			objMsgBean.setStrMsg("요청하신 요구 정보를 등록하지 못했습니다");
%>
			<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
			return;
		}

	} catch(AppException objAppEx) {
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		objMsgBean.setStrCode(objAppEx.getStrErrCode());
		//objMsgBean.setStrMsg(objAppEx.getMessage());
		//out.println("<br>Error!!!" + objAppEx.getMessage());
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}
	System.out.println("생성자 아이디 : "+objUserInfo.getUserID()+"요구함 아이디 : "+strReqBoxID);
	out.println("<script language='javascript'>");
	out.println("parent.notProcessing();");
	out.println("alert('입력하신 요구함 정보를 정상적으로 등록하였습니다.')");
	out.println("parent.close();");
	out.println("</script>");
%>
<%!
	public String strReplaceString(String strData) {
		if(strData != null && !strData.equals("")){
			strData = StringUtil.ReplaceString(strData, "'", "`");
			//strData = StringUtil.ReplaceString(strData, "&", "＆");
			strData = StringUtil.ReplaceString(strData, "^", "＾");
			strData = StringUtil.ReplaceString(strData, "\"", "＂");
		}
		return strData;
     }


	public String checkNull(String strData) {
		if(strData != null && !strData.equals("")){
			strData=StringUtil.ReplaceString(strData,"&#34;","\"");
			strData=StringUtil.ReplaceString(strData,"&#39;","\'");
			//strData=StringUtil.ReplaceString(strData,"＆lt;","<");
			//strData=StringUtil.ReplaceString(strData,"＆gt;",">");
		}else{
			strData = "";
		}
		return strData;
     }

%>
