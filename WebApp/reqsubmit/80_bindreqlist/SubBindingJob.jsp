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
/*****  �ǿ���,����ȸ�� ����Ϸ� �䱸���� ���ε� ��ư ���ý� �Ǵ�                           ****/
/*****  �������ϰ�� ������ �䱸����  ���ε� ��ư ���ý� SYNC JOB ���� ����Ǵ� PROCCESS    ****/
/********************************************************************************************/

   UserInfoDelegate objUser = new UserInfoDelegate(request);
   bindDelegate objBindDelegate = new bindDelegate();

   String   strReqBoxId = null;
   String   strReqBoxDsc = null;  //�ڷ��(�䱸�Ը�)
   String   strAnsID = null;
   String   strBinderSortMtd = null;
   String   strBinderSortField = null;
   String   strNewBindedFileName = null;
   String   strUserID = null; //�����
   String 	strRegDt = null;  //�����
   String   strYear = null ;  // �ش�⵵
   String   strReqBindID = null ; // �����ý��ۿ����ڷ��� ID
   String   strPDFFilePath = null;
   String 	strAnsMtd = null; //�亯����
   int      intCheckAnsCount = 0;  //�亯����Ȯ��

   ArrayList objArray = new ArrayList();
   Hashtable objArrayIDHashtable = null;
   Hashtable objBinderHash = null;

   strUserID = objUser.getUserID();
   //System.out.println("[SubBindingJob.jsp] strUserID =" + strUserID);
   strReqBoxId = request.getParameter("ReqBoxID");
   //System.out.println(" [SubBindingJob.jsp] �䱸�� ID = " + strReqBoxId );
   strBinderSortMtd = request.getParameter("strBinderSortMtd");
   strBinderSortField = request.getParameter("strBinderSortField");

   if(strBinderSortMtd == null || strBinderSortMtd.equals("")){
		strBinderSortMtd = "DESC";
   }

   if(strBinderSortField == null || strBinderSortField.equals("")){
		strBinderSortField = "REG_DT";
   }

    /** �䱸��ID�� ���� �亯ID�� ���Ѵ�.**/
    objArrayIDHashtable =  objBindDelegate.getAnsIDList(strReqBoxId);

    Integer intFieldCnt = (Integer)objArrayIDHashtable.get("FETCHCOUNTNAME");
	int intAnsCount = intFieldCnt.intValue();

	//System.out.println("[SubBindingJob.jsp] Count = " + intAnsCount );


    if(intAnsCount == 0){ //�亯������ �������� �ʽ��ϴ�.
     	objMsgBean.setMsgType(MessageBean.TYPE_INFO);
		 objMsgBean.setStrCode("DSDATA-0036"); //���ε� ����
		 objMsgBean.setStrMsg("�亯������ �������� �ʽ��ϴ�. ");
        out.println("<script language='javascript'>");
        out.println("alert('�亯������ �������� �ʽ��ϴ�.');");
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
				//System.out.println(" [SubBindingJob.jsp]�亯 ID = " + strAnsID);
				if(strPDFFilePath == "" || strPDFFilePath.equals("")){
					//�亯 ����
					//strAnsMtd =(String)((Vector)objArrayIDHashtable.get("ANS_MTD")).elementAt(j);
					intCheckAnsCount ++ ;
				}else{
					objArray.add(strAnsID);
				}
			}

			// �䱸�� ���� �亯 PDF������ ���°�� (�����ڹ���,�ش����� �ƴ�)
			if(objArray.size() == 0){

			   //�����ڹ���,�ش����� �ƴ�
			   if(intAnsCount == intCheckAnsCount){

			     	objMsgBean.setMsgType(MessageBean.TYPE_INFO);
					objMsgBean.setStrCode("DSDATA-0037"); //���ε� ���� ,�����ڹ���
					objMsgBean.setStrMsg("�亯 PDF������ �����ϴ�, ������ �����̰ų� �䱸�� ���� �ش����� �ƴմϴ�. ");

                    out.println("<script language='javascript'>");
    				out.println("alert('�亯 PDF������ �����ϴ�, ������ �����̰ų� �䱸�� ���� �ش����� �ƴմϴ�.');");
	    			out.println("self.close();");
                    out.println("</script>");
				 	return;
			   }
			}

			//System.out.println(" [SubBindingJob.jsp] �亯 ID ��ü ������  = " +  objArray.size());
			objBinderHash = objBindDelegate.getBindListInfo("ANS_ID",strBinderSortMtd,strBinderSortField,objArray);

			/** �ϸ�ũ������ Xtoc ���� **/

		    /** ������� ( 001 �繫ó ,002 ������åó , 003 �ǿ��� , 004 ����ȸ ,006 ������)*/
			String strOrgan_Kind = (String)session.getAttribute("ORGAN_KIND");
			//System.out.println(" [SubBindingJob.jsp] strOrgan_Kind = " + strOrgan_Kind );
			String strXtocPath = null;

			if(strOrgan_Kind.equals(CodeConstants.GOV_ORGAN_KIND_004)){
				//System.out.println("[SubBindingJob.jsp] 004 ����ȸ�̴�  strOrgan_Kind = " + strOrgan_Kind);
				strXtocPath = objBindDelegate.createXtocToDelegate(objBinderHash,strOrgan_Kind);
				//System.out.println("[SubBindingJob.jsp] Temp ������ ������ xtoc ���� �н� ����   strXtocPath =" + strXtocPath);
			}else{
				//System.out.println("[SubBindingJob.jsp] strOrgan_Kind = " + strOrgan_Kind);
			    strXtocPath = objBindDelegate.createXtocToDelegate(objBinderHash,strOrgan_Kind);
				//System.out.println("[SubBindingJob.jsp] Temp ������ ������ xtoc ���� �н� ����   strXtocPath =" + strXtocPath);
								System.out.println("[SubBindingJob.jsp] Temp ������ ������ xtoc ���� �н� ����   strXtocPath =" + strXtocPath);
			}

			if(strXtocPath.compareTo("Error") == 0){
			   //System.out.println(" [SubBindingJob.jsp] strXtocPath �� null �̴�");
			}else{

				 strReqBindID = objBindDelegate.getReqGovConnectNextID();
				 strRegDt = FileUtil.getFileName(strXtocPath,"/");
				 strRegDt = FileUtil.getPureFileName(strRegDt);
				 //System.out.println(" ***** strRegDt = " + strRegDt + " *******");
				 strYear = strRegDt.substring(0,4);

				 //System.out.println("*****[ start binding ]******");
				 //String strXtocPath,String strYear,String strReqBoxId ,String reqBindID
				 strNewBindedFileName =  objBindDelegate.StartBinding(strXtocPath);
				 //System.out.println("[ReqBindingJob.jsp] ������ Binder ������ ���ϰ� = " +strNewBindedFileName);
				 //System.out.println("*****[ bind End ]***********");
			}

			String strNewBindedFilePath =  "pdf_temp/Binder/" + strNewBindedFileName;
			String strHttpFile = "/reqsubmit/common/PDFView.jsp?PDF=" + strNewBindedFilePath;

			//System.out.println("[SubBindingJob.jsp] strHttpFile =" + strHttpFile);

			if( strNewBindedFileName == "Error" || strNewBindedFileName.equals("Error") ){
				//System.out.println("���ε� ����");
				objMsgBean.setMsgType(MessageBean.TYPE_WARN);
			  	objMsgBean.setStrCode("DSDATA-0034");
			  	objMsgBean.setStrMsg("���ε��� ���� ���� ����.");
		%>
			  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
		<%
			}else{
		%>
		<html>
		<head>
		<title>���ε�</title>
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

