<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="kr.co.kcc.bf.config.*" %>
<%@ page import="java.util.*" %>
<%@ page import="nads.lib.util.*"%>
<%@ page import="kr.co.kcc.bf.bfutil.*" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.dsdm.app.activity.userinfo.UserInfoDelegate" %>
<%@ page import="kr.co.kcc.pf.exception.*" %>

<%@ page import="nads.lib.message.MessageBean" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/> 


<%
	String webURL = ""; //http �ּ�
	try {

		Config objConfig = PropertyConfig.getInstance(); //������Ƽ
		webURL = objConfig.get("nads.dsdm.url");

	} catch (ConfigException objConfigEx) {
		out.println(objConfigEx.toString() + "<br>");
		return;
	}

	String strGbn = StringUtil.getNVLNULL(request.getParameter("gbn")); 
	//������ (ȸ������:joinUser ȸ��Ż��:leaveUser ����ȸ������:joinFUser ����ȸ��Ż��:leaveFUser)
	String strUserID = StringUtil.getNVLNULL(request.getParameter("uid")); //�����id

	String strSessInOutGbn =  StringUtil.getNVLNULL(request.getParameter("inout")); //���ܺ� ����
	//�ܺ� �̿��ڿ��Ը� ������ ǥ��

/*
	String strUserNM = StringUtil.getNVLNULL(request.getParameter("uNM")); //����ڸ�
	String strCPhone = StringUtil.getNVLNULL(request.getParameter("cPH")); //��ȭ��ȣ
	String strDeptNM = StringUtil.getNVLNULL(request.getParameter("dNM")); //�μ���
	String strEmail = StringUtil.getNVLNULL(request.getParameter("eM")); //����
*/

	Hashtable objUserInfoHt;
	ArrayList objChargeInfoArry = new ArrayList();
	ArrayList objUserChargeArry = new ArrayList();	
	UserInfoDelegate objUserInfoDelegate = new UserInfoDelegate();

	try {

		objUserInfoHt = objUserInfoDelegate.selectUserInfo(strUserID);

		if(strSessInOutGbn.equals("X")){
			objChargeInfoArry = objUserInfoDelegate.selectChargeCdInfo();
			objUserChargeArry = objUserInfoDelegate.selectUserCharge(strUserID);
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

%>	

<html>
<head>
<title>����Ȱ�� �������� �ý���</title>
<meta http-equiv='Content-Type' content='text/html; charset=euc-kr'>
<style type='text/css'>
<!--
.title {
	FONT-WEIGHT: bold; FONT-SIZE: 15px; COLOR: #343434; FONT-FAMILY: ����,verdana,seoul,Arial ;letter-spacing: -1px 
}
-->
</style>

<style type='text/css'>
<!--
.TD {
     FONT-SIZE: 12px; COLOR: #5c5c5c; FONT-FAMILY: ����,verdana,seoul,Arial ;letter-spacing: 0.5px; line-height: 150%;
}
</style>

<style type='text/css'>
<!--
.text {
	font-family: ����,verdana,seoul,Arial
	font-size: 12px;
	line-height: 150%;
	color: 000000;
	text-decoration: none;
	font-weight: normal;
	text-align: justify;
}
-->
</style>
</head>

<body leftmargin='0' topmargin='0' marginwidth='0' marginheight='0'>

<%
	if((objUserInfoHt != null) && (objUserInfoHt.size() > 0)){
		String strUserNm = (String)objUserInfoHt.get("USER_NM");
		String strJuminNo = (String)objUserInfoHt.get("JUMIN_NO");
		String strGender = "";
		if(strJuminNo.length() >= 13){
			if((strJuminNo.substring(6,7).equals("1")) || (strJuminNo.substring(6,7).equals("3")))
				strGender = "��";

			if((strJuminNo.substring(6,7).equals("2")) || (strJuminNo.substring(6,7).equals("4")))
				strGender = "��";
			
			strJuminNo = strJuminNo.substring(0,6) + "-" + strJuminNo.substring(6,13);
		}

		String strOrganNm = (String)objUserInfoHt.get("ORGAN_NM");
		String strRegTs = (String)objUserInfoHt.get("REG_TS");
		String strInitDate = strRegTs.substring(0,4) + "��" + strRegTs.substring(4,6) + "��" + strRegTs.substring(6,8) + "��" ;
		String strDeptNm   = (String)objUserInfoHt.get("DEPT_NM");
		String strEmail   = (String)objUserInfoHt.get("EMAIL");
		String strOfficeTel   = (String)objUserInfoHt.get("OFFICE_TEL");
		String strFaxNo   = (String)objUserInfoHt.get("FAX_NO");
		String strCphone   = (String)objUserInfoHt.get("CPHONE");
		String strPostCd   = (String)objUserInfoHt.get("POST_CD");
		if(strPostCd.length() >= 6)
			strPostCd = "("+strPostCd.substring(0, 3) + "-"+strPostCd.substring(3, 6)+") ";

		String strJuso1   = (String)objUserInfoHt.get("JUSO1");
		String strJuso2   = (String)objUserInfoHt.get("JUSO2");
		String strRepFlag   = (String)objUserInfoHt.get("REP_FLAG");
		strRepFlag = (strRepFlag.equals("Y")) ? "��ǥ�����":"�Ϲݻ����";

		String strPhotoPath   = (String)objUserInfoHt.get("PHOTO_PATH");
		String strRemark   = (String)objUserInfoHt.get("REMARK");

/*
		String strRegTs = (String)objUserInfoHt.get("REG_TS");
		String strInoutGbn = (String)objUserInfoHt.get("INOUT_GBN");
		String strGovGbn = (String)objUserInfoHt.get("GOV_GBN");
*/
%>
<table width='588' border='0' cellpadding='0' cellspacing='3' bgcolor='E7E7E7'>
  <tr>
    <td align='left' valign='top'><table width='100%' border='0' cellpadding='0' cellspacing='1' bgcolor='AAAAAA'>
        <tr>
          <td bgcolor='ffffff'><table width='100%' border='0' cellspacing='0' cellpadding='0'>
              <tr> 
                <td align='left' valign='top'><img src='<%=webURL%>/image/newsletter/img_newsletter.jpg' width='580' height='170' border='0' usemap='#Map'></td>
              </tr>
              <tr> 
                <td height='1' align='left' valign='top' bgcolor='DBDBDB'></td>
              </tr>
              <tr> 
                <td height='35' align='center' valign='middle'><table width='568' height='29' border='0' cellpadding='0' cellspacing='0' bgcolor='E7E7E7'>
                    <tr> 
                      <td width='30' align='center'><img src='<%=webURL%>/image/newsletter/icon_tit.gif' width='20' height='20'></td>
                      <td width='538' align='left' valign='middle' class='title'>
						<%
							if(strGbn.equals("joinUser"))
								out.print("����� ����� ���ϵ帳�ϴ�.");
							else
								out.print("�����ڷ� �������� �ý��ۿ� ����� Ż��Ǿ����ϴ�.");
						%>
					  </td>
                    </tr>
                  </table></td>
              </tr>
              <tr> 
                <td height='1' align='left' valign='top' bgcolor='DBDBDB'></td>
              </tr>
              <tr> 
                <td height='17' align='left' valign='top'>&nbsp;</td>
              </tr>
              <tr> 
                <td align='center' valign='top'><table width='87%' border='0' cellspacing='0' cellpadding='0'>
                    <tr> 
                      <td align='left' valign='top' class='TD'><strong><%=strUserNm%></strong>�� �ݰ����ϴ�.<br>
						<%
							if(strGbn.equals("joinUser")){
								out.print("�����ڷ� �������� �ý��ۿ� ����ڷ� ���� ��ϵǾ����ϴ�.");
								
							}else
								out.print("�����ڷ� �������� �ý��ۿ� ����� Ż��Ǿ����ϴ�.");
						%>
					  </td>
                    </tr>
                    <tr> 
                      <td align='left' valign='top' class='TD'>&nbsp;</td>
                    </tr>
                    <tr> 
                      <td height='25' valign='middle'><img src='<%=webURL%>/image/newsletter/icon_soti.gif' width='9' height='9' align='absmiddle'> 
                        <span class='TD'><strong><font color='006699'>����ڵ������</font></strong></span></td>
                    </tr>
                    <tr height='5'> 
                      <td height='5' align='left' valign='top'></td>
                    </tr>
                    <tr> 
                      <td align='left' valign='top'><table width='100%' border='0' cellpadding='0' cellspacing='0' class='TD'>
                          <tr bgcolor='75B2D0'> 
                            <td width='26%' height='2'></td>
                            <td width='74%' height='2'></td>
                          </tr>
                          <tr> 
                            <td height='25' bgcolor='F5F5F5'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src='<%=webURL%>/image/newsletter/icon_nemo_gray.gif' width='3' height='6'> 
                              <strong>�̸�</strong> </td>
                            <td height='25'>&nbsp;&nbsp;&nbsp;&nbsp;<%=strUserNm%></td>
                          </tr>
                          <tr height='1' bgcolor='E0E0E0'> 
                            <td height='1'></td>
                            <td height='1'></td>
                          </tr>
                          <tr> 
                            <td height='25' bgcolor='F5F5F5'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src='<%=webURL%>/image/newsletter/icon_nemo_gray.gif' width='3' height='6'> 
                              <strong>�ֹι�ȣ</strong> </td>
                            <td height='25'>&nbsp;&nbsp;&nbsp;&nbsp;<%=strJuminNo%></td>
                          </tr>
                          <tr height='1' bgcolor='E0E0E0'> 
                            <td height='1'></td>
                            <td height='1'></td>
                          </tr>
                          <tr> 
                            <td height='25' bgcolor='F5F5F5'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src='<%=webURL%>/image/newsletter/icon_nemo_gray.gif' width='3' height='6'> 
                              <strong>����</strong> </td>
                            <td height='25'>&nbsp;&nbsp;&nbsp;&nbsp;<%=strGender%></td>
                          </tr>
                          <tr height='1' bgcolor='E0E0E0'> 
                            <td height='1'></td>
                            <td height='1'></td>
                          </tr>
                          <tr> 
                            <td height='25' bgcolor='F5F5F5'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src='<%=webURL%>/image/newsletter/icon_nemo_gray.gif' width='3' height='6'> 
                              <strong>�����</strong> </td>
                            <td height='25'>&nbsp;&nbsp;&nbsp;&nbsp;<%=strOrganNm%></td>
                          </tr>
                          <tr height='1' bgcolor='E0E0E0'> 
                            <td height='1'></td>
                            <td height='1'></td>
                          </tr>
                          <tr> 
                            <td height='25' bgcolor='F5F5F5'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src='<%=webURL%>/image/newsletter/icon_nemo_gray.gif' width='3' height='6'> 
                              <strong>�������</strong> </td>
                            <td height='25'>&nbsp;&nbsp;&nbsp;&nbsp;<%=strInitDate%></td>
                          </tr>
                          <tr height='1' bgcolor='E0E0E0'> 
                            <td height='1'></td>
                            <td height='1'></td>
                          </tr>
                          <tr> 
                            <td height='25' bgcolor='F5F5F5'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src='<%=webURL%>/image/newsletter/icon_nemo_gray.gif' width='3' height='6'> 
                              <strong>�μ���</strong> </td>
                            <td height='25'>&nbsp;&nbsp;&nbsp;&nbsp;<%=strDeptNm%></td>
                          </tr>
                          <tr height='1' bgcolor='E0E0E0'> 
                            <td height='1'></td>
                            <td height='1'></td>
                          </tr>
                          <tr> 
                            <td height='25' bgcolor='F5F5F5'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src='<%=webURL%>/image/newsletter/icon_nemo_gray.gif' width='3' height='6'> 
                              <strong>E-Mail</strong> </td>
                            <td height='25'>&nbsp;&nbsp;&nbsp;&nbsp;<%=strEmail%></td>
                          </tr>
                          <tr height='1' bgcolor='E0E0E0'> 
                            <td height='1'></td>
                            <td height='1'></td>
                          </tr>
                          <tr> 
                            <td height='25' bgcolor='F5F5F5'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src='<%=webURL%>/image/newsletter/icon_nemo_gray.gif' width='3' height='6'> 
                              <strong>�繫��</strong> </td>
                            <td height='25'>&nbsp;&nbsp;&nbsp;&nbsp;<%=strOfficeTel%></td>
                          </tr>
                          <tr height='1' bgcolor='E0E0E0'> 
                            <td height='1'></td>
                            <td height='1'></td>
                          </tr>
                          <tr> 
                            <td height='25' bgcolor='F5F5F5'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src='<%=webURL%>/image/newsletter/icon_nemo_gray.gif' width='3' height='6'> 
                              <strong>FAX</strong> </td>
                            <td height='25'>&nbsp;&nbsp;&nbsp;&nbsp;<%=strFaxNo%></td>
                          </tr>
                          <tr height='1' bgcolor='E0E0E0'> 
                            <td height='1'></td>
                            <td height='1'></td>
                          </tr>
                          <tr> 
                            <td height='25' bgcolor='F5F5F5'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src='<%=webURL%>/image/newsletter/icon_nemo_gray.gif' width='3' height='6'> 
                              <strong>�̵���Ź�ȣ</strong> </td>
                            <td height='25'>&nbsp;&nbsp;&nbsp;&nbsp;<%=strCphone%></td>
                          </tr>
                          <tr height='1' bgcolor='E0E0E0'> 
                            <td height='1'></td>
                            <td height='1'></td>
                          </tr>
                          <tr> 
                            <td height='25' bgcolor='F5F5F5'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src='<%=webURL%>/image/newsletter/icon_nemo_gray.gif' width='3' height='6'> 
                              <strong>�ּ�</strong> </td>
                            <td height='25'>&nbsp;&nbsp;&nbsp;&nbsp;<%=strPostCd%><%=strJuso1%> <%=strJuso2%>
							</td>
                          </tr>
                          <tr height='1' bgcolor='E0E0E0'> 
                            <td height='1'></td>
                            <td height='1'></td>
                          </tr>
				<%
					if(strSessInOutGbn.equals("X")){ //�ܺλ���ڿ��Ը� �������� �����ش�
				%>
                          <tr> 
                            <td height='25' bgcolor='F5F5F5'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src='<%=webURL%>/image/newsletter/icon_nemo_gray.gif' width='3' height='6'> 
                              <strong>������</strong> </td>
                            <td height='25'>
							<%
								String strMDutyWord = "";
								String strSDutyWord = "";
								String strMsortCd = "";
								String strCdNm = "";
								
								String strType = "";
								String strCharge = "";
								
								String strChecked = "";
								String strDisabled = "";
								String strFunction = "";
								String strChkName = "";
								String strSpace = "";
								String strMRemark = "";
								String strTextType="hidden";
								
								Hashtable objChargeInfoHt = new Hashtable();
								Hashtable objUserChargeHt = new Hashtable();
								for(int i=0; i < objChargeInfoArry.size(); i++){
									objChargeInfoHt = (Hashtable)objChargeInfoArry.get(i);
									strMsortCd = (String)objChargeInfoHt.get("MSORT_CD");
									strCdNm = (String)objChargeInfoHt.get("CD_NM");			
									
									strChecked = "";
									strDisabled = "";
									for(int k=0; k < objUserChargeArry.size(); k++){
										objUserChargeHt = (Hashtable)objUserChargeArry.get(k);
										strType = (String)objUserChargeHt.get("CHARGE_TYPE");
										strCharge = (String)objUserChargeHt.get("CHARGE_CD");
										if(strType.equals("S") && !strCharge.equals("999")){  ////�������� ��Ÿ�׸��� �ƴ� ��� ����
											if(strCharge.equals(strMsortCd)){
												strDisabled = "disabled";
												break;
											}
											continue;
										}
										if(strType.equals("M") && strCharge.equals(strMsortCd)){
											strChecked = "checked";
											if(!strCharge.equals("999")){   //�������� ��Ÿ�׸� ����
												strMDutyWord = strMDutyWord + "&nbsp;&nbsp;&nbsp;"+ strCdNm;
											} else {
												strMDutyWord = strMDutyWord + "&nbsp;&nbsp;&nbsp;"+ (String)objUserChargeHt.get("REMARK");
											}

											if(strCharge.equals("999")){   //�������� ��Ÿ�׸� ����
												strMRemark = (String)objUserChargeHt.get("REMARK");
											}
											break;
										}
									}
									if(strMsortCd.equals("999")){   //�������� ��Ÿ�׸� ����
										strDisabled = "";
										strChkName = "mchr999";
										strSpace = "";
										strFunction = "fun_make('m', '" + strMRemark + "')";
									}else{
										strChkName = "mchr" + Integer.toString(i);
										strFunction = "fun_check(this)";
										strSpace = "&nbsp;&nbsp;";
									}

								}

								// �ξ���
								strChecked = "";
								strDisabled = "";
								strFunction = "";
								strTextType="hidden";
								strChkName = "";
								strSpace = "";
								String strSRemark = "";
								
								for(int i=0; i < objChargeInfoArry.size(); i++){
									objChargeInfoHt = (Hashtable)objChargeInfoArry.get(i);
									strMsortCd = (String)objChargeInfoHt.get("MSORT_CD");
									strCdNm = (String)objChargeInfoHt.get("CD_NM");
									
									strChecked = "";
									strDisabled = "";
									for(int k=0; k < objUserChargeArry.size(); k++){
										objUserChargeHt = (Hashtable)objUserChargeArry.get(k);
										strType = (String)objUserChargeHt.get("CHARGE_TYPE");
										strCharge = (String)objUserChargeHt.get("CHARGE_CD");
										if(strType.equals("M")){
											if(strCharge.equals(strMsortCd) && !strCharge.equals("999")){ //�������� ��Ÿ�׸��� �ƴ� ��� ����
												strDisabled = "disabled";
												break;
											}
											continue;
										}
										if(strType.equals("S") && strCharge.equals(strMsortCd)){
											strChecked = "checked";

											if(!strCharge.equals("999")){   //�������� ��Ÿ�׸� ����
												strSDutyWord = strSDutyWord + "&nbsp;&nbsp;&nbsp;"+ strCdNm;
											} else {
												strSDutyWord = strSDutyWord + "&nbsp;&nbsp;&nbsp;"+ (String)objUserChargeHt.get("REMARK");
											}

											if(strCharge.equals("999")){   //�������� ��Ÿ�׸� ����
												strSRemark = (String)objUserChargeHt.get("REMARK");
											}
											break;
										}
									}
									if(strMsortCd.equals("999")){   //�������� ��Ÿ�׸� ����
										strDisabled = "";
										strSpace = "";
										strChkName = "schr999";
										strFunction = "fun_make('s', '" + strSRemark + "')";
									}else{
										strChkName = "schr" + Integer.toString(i);
										strFunction = "fun_checkm(this)";
										strSpace = "&nbsp;&nbsp;";
									}

								}
							%>
							&nbsp;&nbsp;&nbsp;&nbsp;<b>�־��� : </b><%=strMDutyWord%>
							<br>&nbsp;&nbsp;&nbsp;&nbsp;<b>�ξ��� : </b><%=strSDutyWord%>
							</td>
                          </tr>
                          <tr height='1' bgcolor='E0E0E0'> 
                            <td height='1'></td>
                            <td height='1'></td>
                          </tr>
				<%
					}
				%>
                          <tr> 
                            <td height='25' bgcolor='F5F5F5'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src='<%=webURL%>/image/newsletter/icon_nemo_gray.gif' width='3' height='6'> 
                              <strong>��ǥ�ڿ���</strong> </td>
                            <td height='25'>&nbsp;&nbsp;&nbsp;&nbsp;<%=strRepFlag%></td>
                          </tr>
                          <tr height='1' bgcolor='E0E0E0'> 
                            <td height='2'></td>
                            <td height='2'></td>
                          </tr>
                        </table></td>
                    </tr>
                  </table></td>
              </tr>

              <tr> 
                <td height='15' align='left' valign='top'>&nbsp;</td>
              </tr>
              <tr> 
                <td height='20' align='center' valign='top'>
				<table width='87%' border='0' cellspacing='0' cellpadding='0'>
                    
					<%
							if(strGbn.equals("joinUser")) {
					%>
					<tr> 
						<td height="25" align='left' valign='middle' class='TD' bgcolor='F5F5F5'>
						<%
								String strImgTag = "<img src='" + webURL + "/image/infosearch/icon_infosearch_soti.gif'>";
								out.println(strImgTag + "&nbsp;&nbsp;<strong>�������� �̿��Ͽ� �α����Ͻ� �� �ý����� ����Ͻʽÿ�.</strong>");
						%>
						</td>
					</tr>
					<%
						}		
					%>


              <tr> 
                <td height='20' align='center' valign='top'>
                    <tr> 
                      <td align='right' valign='top'><a href='<%=webURL%>'><img src='<%=webURL%>/image/newsletter/bt_goNaps.gif' width='107' height='20' border=0></td>
                    </tr>
                  </table>
				  </td>
              </tr>
              <tr> 
                <td height='35' align='left' valign='top'>&nbsp;</td>
              </tr>
              <tr> 
                <td align='left' valign='top'><img src='<%=webURL%>/image/newsletter/copyright.gif' width='580' height='47'></td>
              </tr>
            </table></td>
        </tr>
      </table></td>
  </tr>
</table>
<p class='text'>&nbsp;</p>
<p class='text'>&nbsp;</p>
<p class='title'>&nbsp; </p>
<map name='Map'>
  <area shape='rect' coords='5,3,191,40' href='#'>
</map>

<%
		}//if((objUserInfoHt != null) && (objUserInfoHt.size() > 0))
%>
</body>
</html>