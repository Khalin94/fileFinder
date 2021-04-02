<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Vector"%>
<%@ page import="java.util.Hashtable"%>
<%@ page import="nads.lib.reqsubmit.util.StringUtil"%>
<%@ page import="nads.lib.reqsubmit.util.FileUtil"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.EnvConstants"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.binder.bindDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.UserInfoDelegate"%>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
/********************************************************************************************/
/*****  의원실,위원회의 제출완료 요구함의 바인딩 버튼 선택시 또는                           ****/
/*****  제출자일경우 작중중 요구함의  바인딩 버튼 선택시 SYNC JOB 으로 실행되는 PROCCESS    ****/
/********************************************************************************************/

   UserInfoDelegate objUser = new UserInfoDelegate(request);
   bindDelegate objBindDelegate = new bindDelegate();

   String   strReqBoxId = null;
   String   strReqBoxDsc = null;  //자료명(요구함명)
   String   strAnsID = null;
   String   strBinderSortMtd = null;
   String   strBinderSortField = null;
   String   strNewBindedFileName = null;
   String   strUserID = null; //등록자
   String 	strRegDt = null;  //등록일
   String   strYear = null ;  // 해당년도
   String   strReqBindID = null ; // 국감시스템연계자료함 ID
   String   strPDFFilePath = null;
   String 	strAnsMtd = null; //답변유형
   int      intCheckAnsCount = 0;  //답변유형확인

   ArrayList objArray = new ArrayList();
   Hashtable objArrayIDHashtable = null;
   Hashtable objBinderHash = null;

   strUserID = objUser.getUserID();
   //System.out.println("[SubBindingJob.jsp] strUserID =" + strUserID);
   strReqBoxId = request.getParameter("ReqBoxID");
   //System.out.println(" [SubBindingJob.jsp] 요구함 ID = " + strReqBoxId );
   strBinderSortMtd = request.getParameter("strBinderSortMtd");
   strBinderSortField = request.getParameter("strBinderSortField");

   if(strBinderSortMtd == null || strBinderSortMtd.equals("")){
		strBinderSortMtd = "DESC";
   }

   if(strBinderSortField == null || strBinderSortField.equals("")){
		strBinderSortField = "REG_DT";
   }

    /** 요구함ID에 대한 답변ID를 구한다.**/
    objArrayIDHashtable =  objBindDelegate.getAnsIDList(strReqBoxId);

    Integer intFieldCnt = (Integer)objArrayIDHashtable.get("FETCHCOUNTNAME");
	int intAnsCount = intFieldCnt.intValue();

	//System.out.println("[SubBindingJob.jsp] Count = " + intAnsCount );


    if(intAnsCount == 0){ //답변파일이 존재하지 않습니다.
     	objMsgBean.setMsgType(MessageBean.TYPE_INFO);
		 objMsgBean.setStrCode("DSDATA-0036"); //바인딩 실패
		 objMsgBean.setStrMsg("답변파일이 존재하지 않습니다. ");
        out.println("<script language='javascript'>");
        out.println("alert('답변파일이 존재하지 않습니다.');");
        out.println("self.close();");
        out.println("</script>");
%>
		 		 <!--jsp:forward page="/common/message/ViewMsg.jsp"/-->
<%
     		return;
    }else{
			strReqBoxDsc  =(String)((Vector)objArrayIDHashtable.get("REQ_BOX_DSC")).elementAt(0);

			for(int j =0 ; j < intAnsCount ; j++){
				strAnsID  =(String)((Vector)objArrayIDHashtable.get("ANS_ID")).elementAt(j);

				strPDFFilePath  =(String)((Vector)objArrayIDHashtable.get("PDF_FILE_PATH")).elementAt(j);
				//System.out.println(" [SubBindingJob.jsp]답변 ID = " + strAnsID);
				if(strPDFFilePath == "" || strPDFFilePath.equals("")){
					//답변 유형
					//strAnsMtd =(String)((Vector)objArrayIDHashtable.get("ANS_MTD")).elementAt(j);
					intCheckAnsCount ++ ;
				}else{
					objArray.add(strAnsID);
				}
			}

			// 요구에 대한 답변 PDF파일이 없는경우 (비전자문서,해당기관이 아님)
			if(objArray.size() == 0){

			   //비전자문서,해당기관이 아님
			   if(intAnsCount == intCheckAnsCount){

			     	objMsgBean.setMsgType(MessageBean.TYPE_INFO);
					objMsgBean.setStrCode("DSDATA-0037"); //바인딩 실패 ,비전자문서
					objMsgBean.setStrMsg("답변 PDF파일이 없습니다, 비전자 문서이거나 요구가 제출 해당기관이 아닙니다. ");

                    out.println("<script language='javascript'>");
    				out.println("alert('답변 PDF파일이 없습니다, 비전자 문서이거나 요구가 제출 해당기관이 아닙니다.');");
	    			out.println("self.close();");
                    out.println("</script>");
				 	return;
			   }
			}

			//System.out.println(" [SubBindingJob.jsp] 답변 ID 전체 갯수는  = " +  objArray.size());
			objBinderHash = objBindDelegate.getBindListInfo("ANS_ID",strBinderSortMtd,strBinderSortField,objArray);

			/** 북마크정보인 Xtoc 생성 **/

		    /** 기관종류 ( 001 사무처 ,002 예산정책처 , 003 의원실 , 004 위원회 ,006 제출기관)*/
			String strOrgan_Kind = (String)session.getAttribute("ORGAN_KIND");
			//System.out.println(" [SubBindingJob.jsp] strOrgan_Kind = " + strOrgan_Kind );
			String strXtocPath = null;

			if(strOrgan_Kind.equals(CodeConstants.GOV_ORGAN_KIND_004)){
				//System.out.println("[SubBindingJob.jsp] 004 위원회이다  strOrgan_Kind = " + strOrgan_Kind);
				strXtocPath = objBindDelegate.createXtocToDelegate(objBinderHash,strOrgan_Kind);
				//System.out.println("[SubBindingJob.jsp] Temp 폴더에 생성된 xtoc 파일 패스 정보   strXtocPath =" + strXtocPath);
			}else{
				//System.out.println("[SubBindingJob.jsp] strOrgan_Kind = " + strOrgan_Kind);
			    strXtocPath = objBindDelegate.createXtocToDelegate(objBinderHash,strOrgan_Kind);
				//System.out.println("[SubBindingJob.jsp] Temp 폴더에 생성된 xtoc 파일 패스 정보   strXtocPath =" + strXtocPath);
								System.out.println("[SubBindingJob.jsp] Temp 폴더에 생성된 xtoc 파일 패스 정보   strXtocPath =" + strXtocPath);
			}

			if(strXtocPath.compareTo("Error") == 0){
			   //System.out.println(" [SubBindingJob.jsp] strXtocPath 가 null 이다");
			}else{

				 strReqBindID = objBindDelegate.getReqGovConnectNextID();
				 strRegDt = FileUtil.getFileName(strXtocPath,"/");
				 strRegDt = FileUtil.getPureFileName(strRegDt);
				 //System.out.println(" ***** strRegDt = " + strRegDt + " *******");
				 strYear = strRegDt.substring(0,4);

				 //System.out.println("*****[ start binding ]******");
				 //String strXtocPath,String strYear,String strReqBoxId ,String reqBindID
				 strNewBindedFileName =  objBindDelegate.StartBinding(strXtocPath);
				 //System.out.println("[ReqBindingJob.jsp] 생성된 Binder 파일의 리턴값 = " +strNewBindedFileName);
				 //System.out.println("*****[ bind End ]***********");
			}

			String strNewBindedFilePath =  "pdf_temp/Binder/" + strNewBindedFileName;
			String strHttpFile = "/reqsubmit/common/PDFView.jsp?PDF=" + strNewBindedFilePath;

			//System.out.println("[SubBindingJob.jsp] strHttpFile =" + strHttpFile);

			if( strNewBindedFileName == "Error" || strNewBindedFileName.equals("Error") ){
				//System.out.println("바인딩 실패");
				objMsgBean.setMsgType(MessageBean.TYPE_WARN);
			  	objMsgBean.setStrCode("DSDATA-0034");
			  	objMsgBean.setStrMsg("바인딩된 파일 생성 실패.");
		%>
			  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
		<%
			}else{
		%>
		<html>
		<head>
		<title>바인딩</title>
		</head>
		<body leftmargin="0" topmargin="0"> <!--onLoad="javascript:open()">-->
			<iframe name="view" width=100% height=100% src="<%=strHttpFile%>"  frameborder=0>
			</iframe>
		<body>
		</html>
		<%
			}
	}
	%>

