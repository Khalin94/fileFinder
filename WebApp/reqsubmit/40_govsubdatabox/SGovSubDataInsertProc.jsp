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

  /**파라미터 설정 등록에도 계속 따라다님..*/
  SGovSubmtDataInsertForm objParams = new SGovSubmtDataInsertForm();
  SGovSubmtDataDelegate objSubmtDataDelegate = new SGovSubmtDataDelegate();

  String RegDt = objParams.getParamValue("RegDt");
  String strInsertYear = RegDt.substring(0,4);

  String strInsertDBFilePath =  strInsertYear + "/etc/";

  // UNIX의 파일 패스 mnt/pdf_temp/2004/etc/
  String strSaveFilePath =       EnvConstants.UNIX_SAVE_PATH  + strInsertYear + "/etc";
  String strCreatEtcFolder =  strSaveFilePath  + "/" ;
  //System.out.println("etc 폴더 생성 = " + strCreatEtcFolder);
  FileUtil.prepareFolder(strCreatEtcFolder);

  String strSaveTempFilePath =  EnvConstants.UNIX_TEMP_SAVE_PATH ;   //EnvConstants.UNIX_TEMP_SAVE_PATH + strInsertYear + "/etc/temp";

  // UNIFLOWWORK에 메세지 전달한 패스
  String strWorkFlowMsgFolder = EnvConstants.WIN_TEMP_SAVE_PATH ; //EnvConstants.WIN_SAVE_PATH + strInsertYear + "/etc/temp";
  //System.out.println("[SGovSubDataInsertProc.jsp] workflow  strWorkFlowMsgFolder = " + strWorkFlowMsgFolder);
  boolean blnParamCheck=false;
  /**전달된 파리미터 체크 */

  /**Multipart일경우 반드시 이녀석을 이용해서 담의 Valid파람으로 넘겨줘야함 */
  try{
      // 파일 업로드

        AnsInfoDelegate objAnsDelegate = new AnsInfoDelegate();
      RequestWrapper objRequestWrapper =  new RequestWrapper(request,strSaveTempFilePath);
      //objRequestWrapper.setSaveDir(strSaveFilePath);
      blnParamCheck=objParams.validateParams(objRequestWrapper);

      objParams.setParamValue("PDFFilePath", objAnsDelegate.getDecryptedPdfPath(objParams.getParamValue("PDFFilePath")));
  }catch(Exception ex){
       if(blnParamCheck==false){
              objMsgBean.setMsgType(MessageBean.TYPE_WARN);
              objMsgBean.setStrCode("DSPARAM-0010"); // 업로드 파일용량 초과시 에러코드
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
 /**                     DB 등록                                                                     */
 /*************************************************************************************************/

   //  boolean blnResult = false; // pdf 파일 temp폴더에서 복사 확인 변수
     boolean blnCopyIndexFileResult = false; // index 색인파일 temp폴더에서 복사 확인 변수
     int intExtractTextResult = -1 ; // index파일추출 성공여부
     boolean blnCheck = true;
      Vector objInsertData = new Vector();


      Hashtable objNextSubmtIdHash = objSubmtDataDelegate.getGovSubmtDataNextId();
      String strSubmtDataNextID = (String)objNextSubmtIdHash.get("NEXT_ID");

      System.out.println("[SGovSubDataInsertProc.jsp] strSubmtDataNextID = " + strSubmtDataNextID);

     //요구기관 id
      String strReqOrganId = objParams.getParamValue("strReqOrganId");
      objInsertData.add(strReqOrganId);

     //제출기관id
      String strOrganId = objParams.getParamValue("strOrganId");
      objInsertData.add(strOrganId);

     //정부제출자료코드
      String GovSubmtDataType = objParams.getParamValue("GovSubmtDataType");
      objInsertData.add(GovSubmtDataType);
      //System.out.println("\n GovSubmtDataType = " + GovSubmtDataType);

     //제출내용
      String SubmtCont = objParams.getParamValue("SubmtCont");
      objInsertData.add(SubmtCont);

     //등록일
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
             out.println("alert('hwp,pdf,zip,alz,doc,ppt,xls,txt 형식의 파일만 업로드가능합니다.');");
             out.println("history.back(-1)");
             out.println("</script>");
             return;
         }
         String strReturnParam =  "GOV^" + PDFFileName + "^" +strInsertYear +"^etc^" + strSubmtDataNextID;
         String strErrorReturnParam = "ERROR^GOV^" + PDFFileName + "^" +strInsertYear +"^etc^" + strSubmtDataNextID;
         //System.out.println("[SGovSubDataInsertProc.jsp] strReturnParam = " + strReturnParam);

//         intExtractTextResult = objUniFlowWrapper.GovSubmitExtractIndexText(PDFFilePathName,strInsertYear,strSubmtDataNextID,strReturnParam,strErrorReturnParam);

         //System.out.println("   작업  intExtractTextResult  = " + intExtractTextResult);
         /** DB에 저장할 PDF파일패스 설정 */
         //PDFFilePathName =  strInsertDBFilePath + strFileName;
         PDFFilePathName = "DB등록중";
      }

      objInsertData.add(PDFFilePathName);


     /** Temp폴더에서 etc 폴더로 원본파일 이동*/
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
             out.println("alert('hwp,pdf,zip,alz,doc,ppt,xls,txt 형식의 파일만 업로드가능합니다.');");

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
         /** DB에 저장할 원본문서파일패스 설정 */
         OrginalFilePathName =  strInsertDBFilePath + strOrginalFileName;
     }

     objInsertData.add(OrginalFilePathName);

    //등록자
      String RegrID = objParams.getParamValue("RegrID");
      objInsertData.add(RegrID);

     //국감연계
      String strIlkmsRegFlag = "N";
      objInsertData.add(strIlkmsRegFlag);

     //국감연계날짜
      String strIlkmsRegDT = "";
      objInsertData.add(strIlkmsRegDT);

      //색인 txt 파일
     String strAddDbIndexFilePath =  strSaveFilePath + "/IDX_" + strSubmtDataNextID + ".txt" ;
      //System.out.println(" db에 저장할 색인파일패스 strAddDbIndexFilePath =  " + strAddDbIndexFilePath );
      objInsertData.add(strAddDbIndexFilePath);

      //해당 년도
      String strYear = objParams.getParamValue("strYear");
      objInsertData.add(strYear);

      //정부제출자료 ID
      objInsertData.add(strSubmtDataNextID);

      //심의기관 코드
      String strReqOrganCd = objParams.getParamValue("strReqOrganCd");
      //objInsertData.add(strReqOrganCd);
     //System.out.println(" strReqOrganCd = " + strReqOrganCd);

     // 담당기관이 위원회일 경우
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
          objMsgBean.setStrCode("DSDATA-0010"); //등록오류
          objMsgBean.setStrMsg(objParams.getStrErrors());
          //out.println("ParamError:" + objParams.getStrErrors());
%>
          <jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
     }else{

%>
<%
 /*************************************************************************************************/
 /**                     페이지 전환 Part                                                           */
 /*************************************************************************************************/
%>
<html>
<script language="JavaScript">
    function init(){
        alert("회의자료등록함에 등록되었습니다 ");
        formName.strGovSubmtDataPageNum.value = 1;
        formName.submit();
    }
</script>
<body onLoad="init()">
                <form name="formName" method="get" action="./SGovSubDataBoxList.jsp" ><!--요구함 신규정보 전달 -->
                    <input type="hidden" name="strAnsSubmtQryField" value="<%=objParams.getParamValue("strAnsSubmtQryField")%>"><!--요구함목록정렬필드 -->
                    <input type="hidden" name="strAnsSubmtQryTerm" value="<%=objParams.getParamValue("strAnsSubmtQryTerm")%>"><!--요구함목록정령방법-->
                    <input type="hidden" name="strGovSubmtDataPageNum" value="<%=objParams.getParamValue("strGovSubmtDataPageNum")%>"><!--요구함 페이지 번호 -->
                    <input type="hidden" name="strGovSubmtDataSortField" value="<%=objParams.getParamValue("strGovSubmtDataSortField")%>"><!--요구함 조회필드 -->
                    <input type="hidden" name="strGovSubmtDataSortMtd" value="<%=objParams.getParamValue("strGovSubmtDataSortMtd")%>"><!--요구함 조회어 -->
                </form>
</body>
</html>
<%
    }
%>
