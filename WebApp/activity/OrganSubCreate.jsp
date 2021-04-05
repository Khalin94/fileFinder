<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*"%>
<%@ page import="nads.dsdm.app.common.code.CodeInfoDelegate"%>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<jsp:include page="/inc/header.jsp" flush="true"/>
<link href="/css2/style.css" rel="stylesheet" type="text/css">
<%

    String strOrganID = request.getParameter("strOrganID");//�Ҽӱ���ڵ�
    String strSubOrganID = request.getParameter("strSubOrganID");//��������ڵ�
    String strSubOrganNM = request.getParameter("strSubOrganNM");//���������
    String strUserID = StringUtil.getNVLNULL(request.getParameter("strUserID")).trim();

    /** ������� */
    /** ���� �䱸������� ���� */
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
    /** �ڵ���� delegate */
    CodeInfoDelegate objCodeInfoDelegate = new CodeInfoDelegate();

    try
    {
        /** �����䱸������� ��� ��ȸ*/
        objReqAuth = objCodeInfoDelegate.lookUpCode("C14");
    }
    catch (AppException objAppEx) {

        return;
    }

        try
        {
            nads.dsdm.app.join.JoinMemberDelegate objJoinMemberDelegate = new nads.dsdm.app.join.JoinMemberDelegate();

            /** ���������ȸ */
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
                //������������� �䱸��������� '002' �� ����
                strReqSubmtCd = StringUtil.getNVL((String)objResult.get("REQ_SUBMT_CD"), "002").trim();
                strOrganNo = StringUtil.getNVLNULL((String)objResult.get("ORGAN_NO")).trim();
                //����ڵ�Ϲ�ȣ�� ���̰� 10�� ��츸 substring
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
                alert("������� �Է��� �ֽʽÿ�");
                frmOrgan.ORGAN_NM.focus();
                return;
            }

            if(frmOrgan.ORGAN_GBN.value ==""){
                alert("��������� ������ �ֽʽÿ�.");
                frmOrgan.ORGAN_GBN.focus();
                return;
            }
            if(frmOrgan.ORGAN_KIND.value ==""){
                alert("��������� ������ �ֽʽÿ�.");
                frmOrgan.ORGAN_KIND.focus();
                return;
            }
            if(frmOrgan.INOUT_GBN.value ==""){
                alert("���ܺα����� ������ �ֽʽÿ�.");
                frmOrgan.INOUT_GBN.focus();
                return;
            }
            if(frmOrgan.GOV_GBN.value ==""){
                alert("���������� ������ �ֽʽÿ�.");
                frmOrgan.GOV_GBN.focus();
                return;
            }
            if(frmOrgan.DUTY_SIZE.value ==""){
                alert("������ �뷮�� �Է��� �ֽʽÿ�.");
                frmOrgan.DUTY_SIZE.focus();
                return;
            }
            if(frmOrgan.strReqSubmtCd.value == "") {
                alert("�䱸��������� ������ �ֽʽÿ�");
                frmOrgan.strReqSubmtCd.focus();
                return;
            }
            if(frmOrgan.STT_CD.value ==""){
                alert("��뿩�θ� ������ �ֽʽÿ�.");
                frmOrgan.STT_CD.focus();
                return;
            }

            //if(!isAlphanumeric(frmOrgan.GOV_STD_CD.value,  true)) {
            //    alert("����ǥ���ڵ�� ���� �� ���ڸ� �Է��� �ֽʽÿ�");
            //    frmOrgan.GOV_STD_CD.focus();
            //    return;
            //}

            //if(!isInteger(frmOrgan.DUTY_SIZE.value)) {
            //    alert("�����Կ뷮�� ���ڸ� �Է��� �ֽʽÿ�");
            //    frmOrgan.DUTY_SIZE.focus();
            //    return;
            //}

/*            varOrganNo = frmOrgan.strOrganNo1.value + frmOrgan.strOrganNo2.value + frmOrgan.strOrganNo3.value ;
            if(varOrganNo.length < 1 ) {

                if(frmOrgan.strOrganNo1.value.length < 3) {
                    alert("����ڵ�Ϲ�ȣ1�� �ڸ����� 3�ڸ��Դϴ�.");
                    frmOrgan.strOrganNo1.focus();
                    return;
                }
                if(frmOrgan.strOrganNo2.value.length < 2) {
                    alert("����ڵ�Ϲ�ȣ2�� �ڸ����� 2�ڸ��Դϴ�.");
                    frmOrgan.strOrganNo2.focus();
                    return;
                }
                if(frmOrgan.strOrganNo3.value.length < 5) {
                    alert("����ڵ�Ϲ�ȣ3�� �ڸ����� 5�ڸ��Դϴ�.");
                    frmOrgan.strOrganNo3.focus();
                    return;
                }
            }
            if (frmOrgan.FAX_NUM.value<1){
                alert("�ѽ���ȣ�� �Է��� �ּ���.");
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
        <th width="24%">&bull;&nbsp;�����<font color="990033">*</font></th>
        <td>
            <input name="ORGAN_NM" type="text" class="input" style="WIDTH: 200px" value="<%=strORGAN_NM%>" maxlength="100">
        </td>
    </tr>
    <tr>
        <th width="24%">&bull;&nbsp;�������<font color="990033">*</font></th>
        <td>
            <input type="hidden" name="ORGAN_GBN" value="<%=strORGAN_GBN%>">
            ���
        </td>
    </tr>
    <tr>
        <th width="24%">&bull;&nbsp;�������<font color="990033">*</font></th>
        <td>
            <input type="hidden" name="ORGAN_KIND" value="<%=strORGAN_KIND%>">
            ������
        </td>
    </tr>
    <tr>
        <th width="24%">&bull;&nbsp;���ܺα���<font color="990033">*</font></th>
        <td>
            <input type="hidden" name="INOUT_GBN" value="<%=strINOUT_GBN%>">�ܺ�
        </td>
      </tr>
      <tr>
        <th width="24%">&bull;&nbsp;��������<font color="990033">*</font></th>
        <td>
            <select name="GOV_GBN" class="input" style="WIDTH: 123px">
            <option vlalue=""><<��������>></option>
            <option value="G" <%if (strGOV_GBN.equals("G")) { out.println(" selected"); } %>>����</option>
            <option value="N" <%if (strGOV_GBN.equals("N")) { out.println(" selected"); } %>>������</option>
          </select>
        </td>
      </tr>
      <tr>
        <th width="24%">&bull;&nbsp;����ǥ���ڵ�</th>
        <td><input name="GOV_STD_CD" type="text" class="input" style="WIDTH: 100px" value="<%=strGOV_STD_CD%>" maxlength="7"></td>
      </tr>
      <tr>
        <th width="24%">&bull;&nbsp;����ڵ�Ϲ�ȣ</th>
        <td>
            <input name="strOrganNo1" type="text" class="input" style="WIDTH: 30px" value="<%=strOrganNo1%>" maxlength="3"> -
            <input name="strOrganNo2" type="text" class="input" style="WIDTH: 20px" value="<%=strOrganNo2%>" maxlength="2"> -
            <input name="strOrganNo3" type="text" class="input" style="WIDTH: 50px" value="<%=strOrganNo3%>" maxlength="5">
        </td>
      </tr>
      <tr>
        <th width="24%">&bull;&nbsp;�����ȣ</th>
        <td><input name="POST_CD1" type="text" class="input" style="WIDTH: 30px" value="<%=strPOST_CD1%>" readonly>
          -
          <input name="POST_CD2" type="text" class="input" style="WIDTH: 30px" value="<%=strPOST_CD2%>"  readonly>

        </td>
      </tr>
      <tr>
        <th width="24%">&bull;&nbsp;��ǥ �ּ�1</th>
        <td><input name="JUSO1" type="text" class="input" style="WIDTH: 350px" value="<%=strJUSO1%>"  maxlength="50" readonly ></td>
      </tr>
      <tr>
        <th width="24%">&bull;&nbsp;��ǥ �ּ�2</th>
        <td><input name="JUSO2" type="text" class="input" style="WIDTH: 350px" value="<%=strJUSO2%>"  maxlength="50"></td>
      </tr>
      <tr>
        <th width="24%">&bull;&nbsp;Ȩ������ URL</th>
        <td><input name="HOME_URL" type="text" class="input" style="WIDTH: 350px" value="<%=strHOME_URL%>" maxlength="100"></td>
      </tr>
      <tr>
        <th width="24%">&bull;&nbsp;��ȭ��ȣ </th>
        <td><input name="TEL_NUM" type="text" class="input" style="WIDTH: 123px" value="<%=strTEL_NUM%>"  maxlength="16"></td>
      </tr>
      <tr>
        <th width="24%">&bull;&nbsp;�ѽ���ȣ </th>
        <td><input name="FAX_NUM" type="text" class="input" style="WIDTH: 123px" value="<%=strFAX_NUM%>"  maxlength="16"></td>
      </tr>
      <tr>
        <th width="24%">&bull;&nbsp;�����Կ뷮<font color="990033">*</font></th>
        <td><input name="DUTY_SIZE" type="text" class="input" style="WIDTH: 123px" value="<%=strDUTY_SIZE%>" maxlength="4">&nbsp;MB</td>
      </tr>
        <input name="BUSEOCODE" type="hidden" class="input" style="WIDTH: 123px" value="<%=strBUSEOCODE%>"  maxlength="7">&nbsp;
        <input name="BUSEORANKING" type="hidden" class="input" style="WIDTH: 123px" value="<%=strBUSEORANKING%>"  maxlength="5">&nbsp;
     <tr>
        <th width="24%">&bull;&nbsp;�䱸�������<font color="990033">*</font></th>
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
        <th width="24%">&bull;&nbsp;��뿩��<font color="990033">*</font></th>
        <td>
            <select name="STT_CD" style="WIDTH: 123px">
                <option value=""><<��뿩��>></option>
                <option value="001" <%if (strSTT_CD.equals("001")) { out.println(" selected"); } %>>���</option>
                <option value="002" <%if (strSTT_CD.equals("002")) { out.println(" selected"); } %>>�̻��</option>
                <option value="003" <%if (strSTT_CD.equals("003")) { out.println(" selected"); } %>>�ű�</option>
            </select>
       </td>
    </tr>
    <tr>
        <th width="24%">&bull;&nbsp;���</th>
        <td>
            <input name="REMARK" type="text" class="input" style="WIDTH: 350px"  value="<%=strREMARK%>"  maxlength="250">
        </td>
      </tr>
    </table>

        <div class="btn_right">
            <span class="list_bt"><a href="javascript:organProcess();">�� ��</a></span></div>
        </div>
    </form>
</div>
</body>
</html>