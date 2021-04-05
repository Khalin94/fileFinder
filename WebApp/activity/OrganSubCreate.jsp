<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*"%>
<%@ page import="nads.dsdm.app.common.code.CodeInfoDelegate"%>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<jsp:include page="/inc/header.jsp" flush="true"/>
<link href="/css2/style.css" rel="stylesheet" type="text/css">
<%

    String strOrganID = request.getParameter("strOrganID");//소속기관코드
    String strSubOrganID = request.getParameter("strSubOrganID");//하위기관코드
    String strSubOrganNM = request.getParameter("strSubOrganNM");//하위기관명
    String strUserID = StringUtil.getNVLNULL(request.getParameter("strUserID")).trim();

    /** 기관구분 */
    /** 서류 요구제출권한 여부 */
    ArrayList objReqAuth = null;

    Hashtable objResult = null;
    String strMessage = "";

    String strORGAN_NM = "";
    String strINOUT_GBN = "";
    String strORGAN_GBN = "";
    String strORGAN_KIND = "";
    String strPOST_CD = "";
    String strPOST_CD1 = "";
    String strPOST_CD2 = "";
    String strJUSO1 = "";
    String strJUSO2 = "";
    String strTEL_NUM = "";
    String strFAX_NUM = "";
    String strHOME_URL = "";
    String strDUTY_SIZE = "0";
    String strGOV_GBN = "";
    String strGOV_STD_CD = "";
    String strSTT_CD = "";
    String strREMARK = "";
    String strBUSEORANKING = "0";
    String strBUSEOCODE = "";
    String strReqSubmtCd = "";
    String strOrganNo = "";
    String strOrganNo1 = "";
    String strOrganNo2 = "";
    String strOrganNo3 = "";
    /** 코드관련 delegate */
    CodeInfoDelegate objCodeInfoDelegate = new CodeInfoDelegate();

    try
    {
        /** 서류요구제출권한 목록 조회*/
        objReqAuth = objCodeInfoDelegate.lookUpCode("C14");
    }
    catch (AppException objAppEx) {

        return;
    }

        try
        {
            nads.dsdm.app.join.JoinMemberDelegate objJoinMemberDelegate = new nads.dsdm.app.join.JoinMemberDelegate();

            /** 기관정보조회 */
            objResult = objJoinMemberDelegate.getOrganInfo(strSubOrganID);

            if(objResult.size() > 0)
            {
                strORGAN_NM = StringUtil.getNVLNULL((String)objResult.get("ORGAN_NM")).trim();
                strINOUT_GBN = StringUtil.getNVL((String)objResult.get("INOUT_GBN"), "X").trim();
                strORGAN_GBN = StringUtil.getNVL((String)objResult.get("ORGAN_GBN"), "001").trim();
                strORGAN_KIND = StringUtil.getNVL((String)objResult.get("ORGAN_KIND"), "006").trim();
                strPOST_CD = StringUtil.getNVLNULL((String)objResult.get("POST_CD")).trim();
                if(strPOST_CD.length() == 6) {
                    strPOST_CD1 = strPOST_CD.substring(0, 3);
                    strPOST_CD2 = strPOST_CD.substring(3, 6);
                }
                strJUSO1 = StringUtil.getNVLNULL((String)objResult.get("JUSO1")).trim();
                strJUSO2 = StringUtil.getNVLNULL((String)objResult.get("JUSO2")).trim();
                strTEL_NUM = StringUtil.getNVLNULL((String)objResult.get("TEL_NUM")).trim();
                strFAX_NUM = StringUtil.getNVLNULL((String)objResult.get("FAX_NUM")).trim();
                strHOME_URL = StringUtil.getNVLNULL((String)objResult.get("HOME_URL")).trim();

                //strDUTY_SIZE = StringUtil.getNVLNULL((String)objResult.get("DUTY_SIZE")).trim();
                strDUTY_SIZE = StringUtil.getNVL((String)objResult.get("DUTY_SIZE"), "0").trim();

                strGOV_GBN = StringUtil.getNVLNULL((String)objResult.get("GOV_GBN")).trim();
                strGOV_STD_CD = StringUtil.getNVLNULL((String)objResult.get("GOV_STD_CD")).trim();
                strSTT_CD = StringUtil.getNVLNULL((String)objResult.get("STT_CD")).trim();
                strREMARK = StringUtil.getNVLNULL((String)objResult.get("REMARK")).trim();
                strBUSEOCODE = StringUtil.getNVLNULL((String)objResult.get("BUSEOCODE")).trim();
                strBUSEORANKING = StringUtil.getNVLNULL((String)objResult.get("BUSEORANKING")).trim();
                //기관관리에서는 요구제출권한이 '002' 로 세팅
                strReqSubmtCd = StringUtil.getNVL((String)objResult.get("REQ_SUBMT_CD"), "002").trim();
                strOrganNo = StringUtil.getNVLNULL((String)objResult.get("ORGAN_NO")).trim();
                //사업자등록번호의 길이가 10인 경우만 substring
                if(strOrganNo.length() == 10) {
                    strOrganNo1 = strOrganNo.substring(0, 3);
                    strOrganNo2 = strOrganNo.substring(3, 5);
                    strOrganNo3 = strOrganNo.substring(5, 10);
                }
            }
        }
        catch (AppException objAppEx) {
            return;
        }

%>
    <script language="javascript" src="/ss/js/common/formchek.js"></script>
    <script language="JavaScript" type="text/JavaScript">
    <!--


        function organProcess() {
            if(frmOrgan.ORGAN_NM.value == "") {
                alert("기관명을 입력해 주십시요");
                frmOrgan.ORGAN_NM.focus();
                return;
            }

            if(frmOrgan.ORGAN_GBN.value ==""){
                alert("기관구분을 선택해 주십시요.");
                frmOrgan.ORGAN_GBN.focus();
                return;
            }
            if(frmOrgan.ORGAN_KIND.value ==""){
                alert("기관종류를 선택해 주십시요.");
                frmOrgan.ORGAN_KIND.focus();
                return;
            }
            if(frmOrgan.INOUT_GBN.value ==""){
                alert("내외부구분을 선택해 주십시요.");
                frmOrgan.INOUT_GBN.focus();
                return;
            }
            if(frmOrgan.GOV_GBN.value ==""){
                alert("행정구분을 선택해 주십시요.");
                frmOrgan.GOV_GBN.focus();
                return;
            }
            if(frmOrgan.DUTY_SIZE.value ==""){
                alert("문서함 용량을 입력해 주십시요.");
                frmOrgan.DUTY_SIZE.focus();
                return;
            }
            if(frmOrgan.strReqSubmtCd.value == "") {
                alert("요구제출권한을 선택해 주십시요");
                frmOrgan.strReqSubmtCd.focus();
                return;
            }
            if(frmOrgan.STT_CD.value ==""){
                alert("사용여부를 선택해 주십시요.");
                frmOrgan.STT_CD.focus();
                return;
            }

            //if(!isAlphanumeric(frmOrgan.GOV_STD_CD.value,  true)) {
            //    alert("행정표준코드는 영문 및 숫자를 입력해 주십시요");
            //    frmOrgan.GOV_STD_CD.focus();
            //    return;
            //}

            //if(!isInteger(frmOrgan.DUTY_SIZE.value)) {
            //    alert("문서함용량은 숫자를 입력해 주십시요");
            //    frmOrgan.DUTY_SIZE.focus();
            //    return;
            //}

/*            varOrganNo = frmOrgan.strOrganNo1.value + frmOrgan.strOrganNo2.value + frmOrgan.strOrganNo3.value ;
            if(varOrganNo.length < 1 ) {

                if(frmOrgan.strOrganNo1.value.length < 3) {
                    alert("사업자등록번호1의 자리수는 3자리입니다.");
                    frmOrgan.strOrganNo1.focus();
                    return;
                }
                if(frmOrgan.strOrganNo2.value.length < 2) {
                    alert("사업자등록번호2의 자리수는 2자리입니다.");
                    frmOrgan.strOrganNo2.focus();
                    return;
                }
                if(frmOrgan.strOrganNo3.value.length < 5) {
                    alert("사업자등록번호3의 자리수는 5자리입니다.");
                    frmOrgan.strOrganNo3.focus();
                    return;
                }
            }
            if (frmOrgan.FAX_NUM.value<1){
                alert("팩스번호를 입력해 주세요.");
                frmOrgan.FAX_NUM.focus();
                return;
            }*/
            frmOrgan.action = "OrganProcessNew.jsp";
            frmOrgan.submit();
        }
    //-->
    </script>
</head>
<body>
<div class="table_con2">

<form name="frmOrgan" method="post">
<input type="hidden" name="strOrganID" value="<%=strOrganID%>"/>
<input type="hidden" name="strSubOrganID" value="<%=strSubOrganID%>"/>
<input type="hidden" name="strSubOrganNM" value="<%=strSubOrganNM%>"/>
<input type="hidden" name="strUserID" value="<%=strUserID%>"/>
<table width="100%" cellspacing="0" cellpadding="0" class="list02">
    <tr>
        <th width="24%">&bull;&nbsp;기관명<font color="990033">*</font></th>
        <td>
            <input name="ORGAN_NM" type="text" class="input" style="WIDTH: 200px" value="<%=strORGAN_NM%>" maxlength="100">
        </td>
    </tr>
    <tr>
        <th width="24%">&bull;&nbsp;기관구분<font color="990033">*</font></th>
        <td>
            <input type="hidden" name="ORGAN_GBN" value="<%=strORGAN_GBN%>">
            기관
        </td>
    </tr>
    <tr>
        <th width="24%">&bull;&nbsp;기관종류<font color="990033">*</font></th>
        <td>
            <input type="hidden" name="ORGAN_KIND" value="<%=strORGAN_KIND%>">
            제출기관
        </td>
    </tr>
    <tr>
        <th width="24%">&bull;&nbsp;내외부구분<font color="990033">*</font></th>
        <td>
            <input type="hidden" name="INOUT_GBN" value="<%=strINOUT_GBN%>">외부
        </td>
      </tr>
      <tr>
        <th width="24%">&bull;&nbsp;행정구분<font color="990033">*</font></th>
        <td>
            <select name="GOV_GBN" class="input" style="WIDTH: 123px">
            <option vlalue=""><<행정구분>></option>
            <option value="G" <%if (strGOV_GBN.equals("G")) { out.println(" selected"); } %>>행정</option>
            <option value="N" <%if (strGOV_GBN.equals("N")) { out.println(" selected"); } %>>비행정</option>
          </select>
        </td>
      </tr>
      <tr>
        <th width="24%">&bull;&nbsp;행정표준코드</th>
        <td><input name="GOV_STD_CD" type="text" class="input" style="WIDTH: 100px" value="<%=strGOV_STD_CD%>" maxlength="7"></td>
      </tr>
      <tr>
        <th width="24%">&bull;&nbsp;사업자등록번호</th>
        <td>
            <input name="strOrganNo1" type="text" class="input" style="WIDTH: 30px" value="<%=strOrganNo1%>" maxlength="3"> -
            <input name="strOrganNo2" type="text" class="input" style="WIDTH: 20px" value="<%=strOrganNo2%>" maxlength="2"> -
            <input name="strOrganNo3" type="text" class="input" style="WIDTH: 50px" value="<%=strOrganNo3%>" maxlength="5">
        </td>
      </tr>
      <tr>
        <th width="24%">&bull;&nbsp;우편번호</th>
        <td><input name="POST_CD1" type="text" class="input" style="WIDTH: 30px" value="<%=strPOST_CD1%>" readonly>
          -
          <input name="POST_CD2" type="text" class="input" style="WIDTH: 30px" value="<%=strPOST_CD2%>"  readonly>

        </td>
      </tr>
      <tr>
        <th width="24%">&bull;&nbsp;대표 주소1</th>
        <td><input name="JUSO1" type="text" class="input" style="WIDTH: 350px" value="<%=strJUSO1%>"  maxlength="50" readonly ></td>
      </tr>
      <tr>
        <th width="24%">&bull;&nbsp;대표 주소2</th>
        <td><input name="JUSO2" type="text" class="input" style="WIDTH: 350px" value="<%=strJUSO2%>"  maxlength="50"></td>
      </tr>
      <tr>
        <th width="24%">&bull;&nbsp;홈페이지 URL</th>
        <td><input name="HOME_URL" type="text" class="input" style="WIDTH: 350px" value="<%=strHOME_URL%>" maxlength="100"></td>
      </tr>
      <tr>
        <th width="24%">&bull;&nbsp;전화번호 </th>
        <td><input name="TEL_NUM" type="text" class="input" style="WIDTH: 123px" value="<%=strTEL_NUM%>"  maxlength="16"></td>
      </tr>
      <tr>
        <th width="24%">&bull;&nbsp;팩스번호 </th>
        <td><input name="FAX_NUM" type="text" class="input" style="WIDTH: 123px" value="<%=strFAX_NUM%>"  maxlength="16"></td>
      </tr>
      <tr>
        <th width="24%">&bull;&nbsp;문서함용량<font color="990033">*</font></th>
        <td><input name="DUTY_SIZE" type="text" class="input" style="WIDTH: 123px" value="<%=strDUTY_SIZE%>" maxlength="4">&nbsp;MB</td>
      </tr>
        <input name="BUSEOCODE" type="hidden" class="input" style="WIDTH: 123px" value="<%=strBUSEOCODE%>"  maxlength="7">&nbsp;
        <input name="BUSEORANKING" type="hidden" class="input" style="WIDTH: 123px" value="<%=strBUSEORANKING%>"  maxlength="5">&nbsp;
     <tr>
        <th width="24%">&bull;&nbsp;요구제출권한<font color="990033">*</font></th>
        <td>
            <select name="strReqSubmtCd" style="WIDTH: 123px">
    <% for(int i=0; i< objReqAuth.size() ; i++) {%>
                <option value='<%=String.valueOf(((Hashtable)objReqAuth.get(i)).get("MSORT_CD"))%>'  <%if(strReqSubmtCd.equals(String.valueOf(((Hashtable)objReqAuth.get(i)).get("MSORT_CD")))){ out.println(" selected"); }%>>
                    <%=String.valueOf(((Hashtable)objReqAuth.get(i)).get("CD_NM"))%>
                </option>
    <%}%>
            </select>
        </td>
    </tr>
    <tr>
        <th width="24%">&bull;&nbsp;사용여부<font color="990033">*</font></th>
        <td>
            <select name="STT_CD" style="WIDTH: 123px">
                <option value=""><<사용여부>></option>
                <option value="001" <%if (strSTT_CD.equals("001")) { out.println(" selected"); } %>>사용</option>
                <option value="002" <%if (strSTT_CD.equals("002")) { out.println(" selected"); } %>>미사용</option>
                <option value="003" <%if (strSTT_CD.equals("003")) { out.println(" selected"); } %>>신규</option>
            </select>
       </td>
    </tr>
    <tr>
        <th width="24%">&bull;&nbsp;비고</th>
        <td>
            <input name="REMARK" type="text" class="input" style="WIDTH: 350px"  value="<%=strREMARK%>"  maxlength="250">
        </td>
      </tr>
    </table>

        <div class="btn_right">
            <span class="list_bt"><a href="javascript:organProcess();">저 장</a></span></div>
        </div>
    </form>
</div>
</body>
</html>