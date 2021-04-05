<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.EnvConstants"%>
<%@ page import="nads.lib.reqsubmit.params.govsubmtdata.SGovSubmtDataInsertForm" %>
<%@ page import="nads.lib.reqsubmit.util.FileUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.govSubmtData.SGovSubmtDataDelegate" %>
<%@ page import="nads.lib.reqsubmit.form.RequestWrapper"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.UserInfoDelegate"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.CDInfoDelegate"%>
<!--%@ page import="nads.lib.reqsubmit.uniflow.UniFlowWrapper"%-->
<%@ page import="nads.dsdm.app.reqsubmit.delegate.answerinfo.*" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%
 UserInfoDelegate objUserInfo =null;
 CDInfoDelegate objCdinfo =null;
%>
<%@ include file="../common/RUserCodeInfoInc.jsp" %>

<%
  FileUtil objFileUtil = new FileUtil();

//  UniFlowWrapper objUniFlowWrapper = new UniFlowWrapper();

  /**�Ķ���� ���� ��Ͽ��� ��� ����ٴ�..*/
  SGovSubmtDataInsertForm objParams = new SGovSubmtDataInsertForm();
  SGovSubmtDataDelegate objSubmtDataDelegate = new SGovSubmtDataDelegate();

  String RegDt = objParams.getParamValue("RegDt");
  String strInsertYear = RegDt.substring(0,4);

  String strInsertDBFilePath =  strInsertYear + "/etc/";

  // UNIX�� ���� �н� mnt/pdf_temp/2004/etc/
  String strSaveFilePath =       EnvConstants.UNIX_SAVE_PATH  + strInsertYear + "/etc";
  String strCreatEtcFolder =  strSaveFilePath  + "/" ;
  //System.out.println("etc ���� ���� = " + strCreatEtcFolder);
  FileUtil.prepareFolder(strCreatEtcFolder);

  String strSaveTempFilePath =  EnvConstants.UNIX_TEMP_SAVE_PATH ;   //EnvConstants.UNIX_TEMP_SAVE_PATH + strInsertYear + "/etc/temp";

  // UNIFLOWWORK�� �޼��� ������ �н�
  String strWorkFlowMsgFolder = EnvConstants.WIN_TEMP_SAVE_PATH ; //EnvConstants.WIN_SAVE_PATH + strInsertYear + "/etc/temp";
  //System.out.println("[SGovSubDataInsertProc.jsp] workflow  strWorkFlowMsgFolder = " + strWorkFlowMsgFolder);
  boolean blnParamCheck=false;
  /**���޵� �ĸ����� üũ */

  /**Multipart�ϰ�� �ݵ�� �̳༮�� �̿��ؼ� ���� Valid�Ķ����� �Ѱ������ */
  try{
      // ���� ���ε�

        AnsInfoDelegate objAnsDelegate = new AnsInfoDelegate();
      RequestWrapper objRequestWrapper =  new RequestWrapper(request,strSaveTempFilePath);
      //objRequestWrapper.setSaveDir(strSaveFilePath);
      blnParamCheck=objParams.validateParams(objRequestWrapper);

      objParams.setParamValue("PDFFilePath", objAnsDelegate.getDecryptedPdfPath(objParams.getParamValue("PDFFilePath")));
  }catch(Exception ex){
       if(blnParamCheck==false){
              objMsgBean.setMsgType(MessageBean.TYPE_WARN);
              objMsgBean.setStrCode("DSPARAM-0010"); // ���ε� ���Ͽ뷮 �ʰ��� �����ڵ�
              objMsgBean.setStrMsg(objParams.getStrErrors());
              //out.println("ParamError:" + objParams.getStrErrors());
              %>
              <jsp:forward page="/common/message/ViewMsg.jsp"/>
              <%
              return;
       }
  }
 %>
<%
 /*************************************************************************************************/
 /**                     DB ���                                                                     */
 /*************************************************************************************************/

   //  boolean blnResult = false; // pdf ���� temp�������� ���� Ȯ�� ����
     boolean blnCopyIndexFileResult = false; // index �������� temp�������� ���� Ȯ�� ����
     int intExtractTextResult = -1 ; // index�������� ��������
     boolean blnCheck = true;
      Vector objInsertData = new Vector();


      Hashtable objNextSubmtIdHash = objSubmtDataDelegate.getGovSubmtDataNextId();
      String strSubmtDataNextID = (String)objNextSubmtIdHash.get("NEXT_ID");

      System.out.println("[SGovSubDataInsertProc.jsp] strSubmtDataNextID = " + strSubmtDataNextID);

     //�䱸��� id
      String strReqOrganId = objParams.getParamValue("strReqOrganId");
      objInsertData.add(strReqOrganId);

     //������id
      String strOrganId = objParams.getParamValue("strOrganId");
      objInsertData.add(strOrganId);

     //���������ڷ��ڵ�
      String GovSubmtDataType = objParams.getParamValue("GovSubmtDataType");
      objInsertData.add(GovSubmtDataType);
      //System.out.println("\n GovSubmtDataType = " + GovSubmtDataType);

     //���⳻��
      String SubmtCont = objParams.getParamValue("SubmtCont");
      objInsertData.add(SubmtCont);

     //�����
      String RegDt2 = objParams.getParamValue("RegDt");
      objInsertData.add(RegDt2);

      int intFileMove = -1;

     String PDFFilePathName = objParams.getParamValue("PDFFilePath");
     System.out.println("[SGovSubDataInsertProc.jsp] PDFFilePathName = " + PDFFilePathName);

     if(PDFFilePathName == "" || PDFFilePathName.equals("")){
         PDFFilePathName = "";
     }else{



         String PDFFileName    = FileUtil.getFileName(PDFFilePathName);
         boolean flag = false;
         String strOrgNameTemp = null;
         strOrgNameTemp = PDFFileName;
         System.out.println("strOrgNameTemp : "+strOrgNameTemp);
         int pos = strOrgNameTemp.lastIndexOf(".");
         //String[] strExtensions = nads.lib.reqsubmit.util.StringUtil.split(".",strOrgNameTemp);
         String strExtension1 = strOrgNameTemp.substring(pos+1);
         strExtension1 = strExtension1.toLowerCase();
         String[] strEx = {"hwp", "pdf", "zip", "alz", "doc", "ppt", "xls", "txt"};

         for(int i = 0; i < strEx.length ; i++){
             if(strEx[i].equals(strExtension1)){
                flag = true;
             }
         }
         if(flag == false){
             out.println("<script language=javascript>");
             out.println("alert('hwp,pdf,zip,alz,doc,ppt,xls,txt ������ ���ϸ� ���ε尡���մϴ�.');");
             out.println("history.back(-1)");
             out.println("</script>");
             return;
         }
         String strReturnParam =  "GOV^" + PDFFileName + "^" +strInsertYear +"^etc^" + strSubmtDataNextID;
         String strErrorReturnParam = "ERROR^GOV^" + PDFFileName + "^" +strInsertYear +"^etc^" + strSubmtDataNextID;
         //System.out.println("[SGovSubDataInsertProc.jsp] strReturnParam = " + strReturnParam);

//         intExtractTextResult = objUniFlowWrapper.GovSubmitExtractIndexText(PDFFilePathName,strInsertYear,strSubmtDataNextID,strReturnParam,strErrorReturnParam);

         //System.out.println("   �۾�  intExtractTextResult  = " + intExtractTextResult);
         /** DB�� ������ PDF�����н� ���� */
         //PDFFilePathName =  strInsertDBFilePath + strFileName;
         PDFFilePathName = "DB�����";
      }

      objInsertData.add(PDFFilePathName);


     /** Temp�������� etc ������ �������� �̵�*/
     String OrginalFilePathName = objParams.getParamValue("OrginalFilePath");

     if(OrginalFilePathName == "" || OrginalFilePathName.equals("")){
         OrginalFilePathName = "";
     }else{
         System.out.println("[SGovSubDataInsertProc.jsp] OrginalFilePathName = " + OrginalFilePathName);

         String strOrginalFileName =(String)FileUtil.getFileName(OrginalFilePathName);
         boolean flag2 = false;
         String strOrgNameTemp2 = null;
         strOrgNameTemp2 = strOrginalFileName;
         System.out.println("strOrgNameTemp : "+strOrgNameTemp2);
         int pos2 = strOrgNameTemp2.lastIndexOf(".");
         //String[] strExtensions = nads.lib.reqsubmit.util.StringUtil.split(".",strOrgNameTemp);
         String strExtension2 = strOrgNameTemp2.substring(pos2+1);
         strExtension2 = strExtension2.toLowerCase();
         String[] strEx2 = {"hwp", "pdf", "zip", "alz", "doc", "ppt", "xls", "txt"};

         for(int i = 0; i < strEx2.length ; i++){
             if(strEx2[i].equals(strExtension2)){
                flag2 = true;
             }
         }
         if(flag2 == false){
             out.println("<script language=javascript>");
             out.println("alert('hwp,pdf,zip,alz,doc,ppt,xls,txt ������ ���ϸ� ���ε尡���մϴ�.');");

             out.println("history.back(-1)");
             out.println("</script>");
             return;
         }

         String strExtension = FileUtil.getFileExtension(strOrginalFileName);
         strOrginalFileName = "src_" + strSubmtDataNextID + "." + strExtension;
         String strORGSaveFilePath = strSaveFilePath + "/" + strOrginalFileName;

         System.out.println("[SGovSubDataInsertProc.jsp] strORGSaveFilePath =" + strORGSaveFilePath);
         intFileMove =FileUtil.moveFile(OrginalFilePathName,strORGSaveFilePath);

         if(intFileMove < 0){
             blnCheck = false;
         }
         /** DB�� ������ �������������н� ���� */
         OrginalFilePathName =  strInsertDBFilePath + strOrginalFileName;
     }

     objInsertData.add(OrginalFilePathName);

    //�����
      String RegrID = objParams.getParamValue("RegrID");
      objInsertData.add(RegrID);

     //��������
      String strIlkmsRegFlag = "N";
      objInsertData.add(strIlkmsRegFlag);

     //�������賯¥
      String strIlkmsRegDT = "";
      objInsertData.add(strIlkmsRegDT);

      //���� txt ����
     String strAddDbIndexFilePath =  strSaveFilePath + "/IDX_" + strSubmtDataNextID + ".txt" ;
      //System.out.println(" db�� ������ ���������н� strAddDbIndexFilePath =  " + strAddDbIndexFilePath );
      objInsertData.add(strAddDbIndexFilePath);

      //�ش� �⵵
      String strYear = objParams.getParamValue("strYear");
      objInsertData.add(strYear);

      //���������ڷ� ID
      objInsertData.add(strSubmtDataNextID);

      //���Ǳ�� �ڵ�
      String strReqOrganCd = objParams.getParamValue("strReqOrganCd");
      //objInsertData.add(strReqOrganCd);
     //System.out.println(" strReqOrganCd = " + strReqOrganCd);

     // ������� ����ȸ�� ���
      if(strReqOrganCd == "004" || strReqOrganCd.equals("004")){
          objInsertData.add(strReqOrganId);
      }else{
          objInsertData.add("");
      }

      //System.out.println("objInsertData.size() = " + objInsertData.size());
     int intResult = objSubmtDataDelegate.getGovSubmtDataInsert(objInsertData);

    // if((intExtractTextResult < 0) || !blnCheck || !blnCopyIndexFileResult || intResult < 0 ){
     //if(!blnCheck || intResult < 0 ){
     if(!blnCheck || intResult < 0){
        objMsgBean.setMsgType(MessageBean.TYPE_WARN);
          objMsgBean.setStrCode("DSDATA-0010"); //��Ͽ���
          objMsgBean.setStrMsg(objParams.getStrErrors());
          //out.println("ParamError:" + objParams.getStrErrors());
%>
          <jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
     }else{

%>
<%
 /*************************************************************************************************/
 /**                     ������ ��ȯ Part                                                           */
 /*************************************************************************************************/
%>
<html>
<script language="JavaScript">
    function init(){
        alert("ȸ���ڷ����Կ� ��ϵǾ����ϴ� ");
        formName.strGovSubmtDataPageNum.value = 1;
        formName.submit();
    }
</script>
<body onLoad="init()">
                <form name="formName" method="get" action="./SGovSubDataBoxList.jsp" ><!--�䱸�� �ű����� ���� -->
                    <input type="hidden" name="strAnsSubmtQryField" value="<%=objParams.getParamValue("strAnsSubmtQryField")%>"><!--�䱸�Ը�������ʵ� -->
                    <input type="hidden" name="strAnsSubmtQryTerm" value="<%=objParams.getParamValue("strAnsSubmtQryTerm")%>"><!--�䱸�Ը�����ɹ��-->
                    <input type="hidden" name="strGovSubmtDataPageNum" value="<%=objParams.getParamValue("strGovSubmtDataPageNum")%>"><!--�䱸�� ������ ��ȣ -->
                    <input type="hidden" name="strGovSubmtDataSortField" value="<%=objParams.getParamValue("strGovSubmtDataSortField")%>"><!--�䱸�� ��ȸ�ʵ� -->
                    <input type="hidden" name="strGovSubmtDataSortMtd" value="<%=objParams.getParamValue("strGovSubmtDataSortMtd")%>"><!--�䱸�� ��ȸ�� -->
                </form>
</body>
</html>
<%
    }
%>
