<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*"%>
<%@ page import="nads.dsdm.app.common.code.CodeInfoDelegate"%>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<jsp:include page="/inc/header.jsp" flush="true"/>
<link href="/css2/style.css" rel="stylesheet" type="text/css">
<%
    //��� ID ,Type
    String strOrganID = request.getParameter("strOrganID");
    String strOrganIDOrig = request.getParameter("strOrganIDOrig");
    String strOrganType = request.getParameter("strOrganType");
    String strUserID = request.getParameter("strUserID");
    String strUserRep = request.getParameter("strUserRep");

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
            objResult = objJoinMemberDelegate.getOrganInfo(strOrganID);

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
        function MM_preloadImages() { //v3.0
            var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
            var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
            if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
        }

        //������� �̵�
        function goList() {
            frmOrgan.action = "ManageOrgList.jsp";
            frmOrgan.submit();
        }

        function organProcess(type) {
            if (type=='del'){
                frmOrgan.strType.value="del";
                frmOrgan.action = "OrganProcess.jsp";
                frmOrgan.submit();
                return;
            }
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

            varOrganNo = frmOrgan.strOrganNo1.value + frmOrgan.strOrganNo2.value + frmOrgan.strOrganNo3.value ;
            if(varOrganNo.length > 0 ) {
                //if(!isInteger(varOrganNo)) {
                //    alert("����ڵ�Ϲ�ȣ�� ���ڸ� �Է��� �ֽʽÿ�");
                //    frmOrgan.strOrganNo1.focus();
                //    return;
                //}

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



            if(frmOrgan.checkFlag.value == "false" ) {
                alert("����� �ߺ�üũ�� �Ͻñ� �ٶ��ϴ�.");
                return;
            }
            if(frmOrgan.ORGAN_NM.value != frmOrgan.checkORGAN_NM.value ) {
                alert("����� �ߺ�üũ�� �Ͻñ� �ٶ��ϴ�.");
                frmOrgan.checkFlag.value = "false";
                return;
            }


            frmOrgan.strType.value="save";
            frmOrgan.action = "OrganProcess.jsp";
            frmOrgan.submit();
        }



        function checkOrganName(){

            if(frmOrgan.ORGAN_NM.value == "" ) {
                alert("������� �Է��Ͻñ� �ٶ��ϴ�.");
                frmOrgan.ORGAN_NM.focus();
                return;
            }
            window.open("../join/OrganNameCheck2.jsp?strOrganName="+frmOrgan.ORGAN_NM.value+"&strOrganID=<%=strOrganID%>", "OrganNameCheck", "top=300,left=500,width=200,height=50,toolbar=no,menubar=no,location=no,scrollbars=no,status=no,resizable=no");
       }


        //�����ȣ ã�⸦ ���� �����ȣ �� ��ǥ�ּ� ����
        function selectZipCd(varZipCd1, varZipCd2, varAddr1) {
            frmOrgan.POST_CD1.value = varZipCd1;
            frmOrgan.POST_CD2.value = varZipCd2;
            frmOrgan.JUSO1.value = varAddr1;
            return;
        }

        //�����ȣ ã�� â
        function setPostNo() {
            window.open("../common/SearchZipCodePop.jsp", "zipcode", "width=520,height=300,toolbar=no,menubar=no,location=no,scrollbars=yes,status=yes");
        }

        function setSubOrgan(varOrganID,varUserID) {
            window.open("OrganSubList.jsp?strOrganID="+varOrganID+"&strUserID="+varUserID, "subOrgan", "width=530,height=610,toolbar=no,menubar=no,location=no,scrollbars=yes,status=yes,resizable=yes");
        }

        //�̷����� ����
        function organHistory(varOrganID) {
            window.open("OrganHistory.jsp?strOrganID="+varOrganID, "OrganHistory", "width=530,height=610,toolbar=no,menubar=no,location=no,scrollbars=yes,status=yes,resizable=yes");
        }
    //-->
    </script>
</head>

<body>
<form name="frmOrgan" method="post">
<input type="hidden" name="strUserID" value="<%=strUserID%>"/>
<input type="hidden" name="strOrganIDOrig" value="<%=strOrganIDOrig%>"/>
<input type="hidden" name="strOrganID" value="<%=strOrganID%>"/>
<input type="hidden" name="strOrganType" value="<%=strOrganType%>"/>
<input type="hidden" name="strUserRep" value="<%=strUserRep%>"/>
<input type="hidden" name="strType"/>
<div class="table_con">
    <span class="list01_tl">������ġ : <%=strORGAN_NM%></span>
    <table width="100%" cellspacing="0" cellpadding="0" class="list04">
        <tr>
            <th width="26%" scope="col">&bull;&nbsp;��� ID</th>
            <td width="74%"><input name="ORGAN_ID" type="text" class="input" style="WIDTH: 123px" value="<%=strOrganID%>" readonly></td>
        </tr>
        <tr>
            <th>&bull;&nbsp;�����<font color="990033">*</font></th>
            <td>
                <input name="ORGAN_NM" type="text" class="input" style="WIDTH: 200px" value="<%=strORGAN_NM%>" maxlength="100">
                <a href="javascript:checkOrganName();"><img src="../images2/btn/btn_chk.gif" align="absmiddle" onMouseOver="this.src='../images2/btn/btn_chk_o.gif'"  onMouseOut="this.src='../images2/btn/btn_chk.gif'"></a>
                <input type="hidden" name="checkFlag" value="<% if(strOrganID.equals("")) {out.print("false");} else{out.print("true");}%>">
                <input type="hidden" name="checkORGAN_NM" value="<% if(strOrganID.equals("")) {} else{out.print(strORGAN_NM);}%>">
            </td>
        </tr>
        <tr>
            <th>&bull;&nbsp;�������<font color="990033">*</font></th>
            <td><input type="hidden" name="ORGAN_GBN" value="<%=strORGAN_GBN%>">���</td>
        </tr>
        <tr>
            <th>&bull;&nbsp;�������<font color="990033">*</font></th>
            <td>
                <input type="hidden" name="ORGAN_KIND" value="<%=strORGAN_KIND%>">
                ������
            </td>
        </tr>
        <tr>
            <th>&bull;&nbsp;���ܺα���<font color="990033">*</font><font color="990033">&nbsp;</font></th>
            <td><input type="hidden" name="INOUT_GBN" value="<%=strINOUT_GBN%>">�ܺ�</td>
        </tr>
        <tr>
            <th>&bull;&nbsp;��������<font color="990033">*</font></th>
            <td>
                <select name="GOV_GBN" class="input" style="WIDTH: 123px">
                <option vlalue=""><<��������>></option>
                <option value="G" <%if (strGOV_GBN.equals("G")) { out.println(" selected"); } %>>����</option>
                <option value="N" <%if (strGOV_GBN.equals("N")) { out.println(" selected"); } %>>������</option>
              </select>
            </td>
        </tr>
        <tr>
            <th>&bull;&nbsp;����ǥ���ڵ�</th>
            <td><input name="GOV_STD_CD" type="text" class="input" style="WIDTH: 100px" value="<%=strGOV_STD_CD%>" maxlength="7"></td>
        </tr>
        <tr>
            <th>&bull;&nbsp;����ڵ�Ϲ�ȣ</th>
            <td>
                <input name="strOrganNo1" type="text" class="input" style="WIDTH: 30px" value="<%=strOrganNo1%>" maxlength="3"> -
                <input name="strOrganNo2" type="text" class="input" style="WIDTH: 20px" value="<%=strOrganNo2%>" maxlength="2"> -
                <input name="strOrganNo3" type="text" class="input" style="WIDTH: 50px" value="<%=strOrganNo3%>" maxlength="5">
            </td>
        </tr>
        <tr>
            <th>&bull;&nbsp;�����ȣ</th>
            <td><input name="POST_CD1" type="text" class="input" style="WIDTH: 30px" value="<%=strPOST_CD1%>" readonly>
              -
              <input name="POST_CD2" type="text" class="input" style="WIDTH: 30px" value="<%=strPOST_CD2%>"  readonly>
              <a href="javascript:setPostNo()"><img src="../images2/btn/btn_post.gif" align="absmiddle" onMouseOver="this.src='../images2/btn/btn_post_o.gif'"  onMouseOut="this.src='../images2/btn/btn_post.gif'"></a>
            </td>
        </tr>
        <tr>
            <th>&bull;&nbsp;��ǥ �ּ�1</th>
            <td><input name="JUSO1" type="text" class="input" style="WIDTH: 350px" value="<%=strJUSO1%>"  maxlength="50" readonly ></td>
        </tr>
        <tr>
            <th>&bull;&nbsp;��ǥ �ּ�2</th>
            <td><input name="JUSO2" type="text" class="input" style="WIDTH: 350px" value="<%=strJUSO2%>"  maxlength="50"></td>
          </tr>
          <tr>
            <th>&bull;&nbsp;Ȩ������ URL</th>
            <td><input name="HOME_URL" type="text" class="input" style="WIDTH: 350px" value="<%=strHOME_URL%>" maxlength="100"></td>
          </tr>
          <tr>
            <th>&bull;&nbsp;��ȭ��ȣ </th>
            <td><input name="TEL_NUM" type="text" class="input" style="WIDTH: 123px" value="<%=strTEL_NUM%>"  maxlength="16"></td>
          </tr>
          <tr>
            <th>&bull;&nbsp;�ѽ���ȣ </th>
            <td><input name="FAX_NUM" type="text" class="input" style="WIDTH: 123px" value="<%=strFAX_NUM%>"  maxlength="16"></td>
          </tr>
          <tr>
            <th>&bull;&nbsp;�����Կ뷮<font color="990033">*</font></th>
            <td><input name="DUTY_SIZE" type="text" class="input" style="WIDTH: 123px" value="<%=strDUTY_SIZE%>" maxlength="4">&nbsp;MB</td>
          </tr>
            <input name="BUSEOCODE" type="hidden" class="input" style="WIDTH: 123px" value="<%=strBUSEOCODE%>"  maxlength="7">&nbsp;
            <input name="BUSEORANKING" type="hidden" class="input" style="WIDTH: 123px" value="<%=strBUSEORANKING%>"  maxlength="5">&nbsp;
         <tr>
            <th>&bull;&nbsp;�䱸�������<font color="990033">*</font></th>
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
            <th>&bull;&nbsp;��뿩��<font color="990033">*</font></th>
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
            <th>&bull;&nbsp;���</th>
            <td>
                <input name="REMARK" type="text" class="input" style="WIDTH: 350px"  value="<%=strREMARK%>"  maxlength="250">
            </td>
          </tr>
        </table>

        <div class="btn_left">
            <%if(strUserRep.equals("Y")){%>
              <!-- �̷����� ���� -->
                <span class="list_bt"><a href="javascript:organHistory('<%=strOrganID%>');">[�̷����� ����]</a></span>
            <%}%>
        </div>
        <div class="btn_right">
            <%if(strUserRep.equals("Y") && strOrganIDOrig.equals(strOrganID)){%>
            <span class="list_bt"><a href="javascript:organProcess('save');">�� ��</a></span>
            <%if(strOrganType.equals("Main")){%>
            <span class="list_bt"><a href="javascript:setSubOrgan('<%=strOrganID%>','<%=strUserID%>')">���������</a></span>
            <%}}%>
            <%
              if(strUserRep.equals("Y") && !strOrganID.equals(strOrganIDOrig)){
            %>
`           <span class="list_bt"><a href="javascript:organProcess('del');">�� ��</a></span>
            <%
              }
            %>
        </div>
        </div>
    </form>
</body>
</html>