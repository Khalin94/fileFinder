<%@ page contentType="text/html; charset=euc-kr" language="java" %>
<%@ page import="java.security.cert.*" %>
<%@ page import="java.security.spec.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="ksign.jce.util.*" %>
<%@ page import="javak.crypto.*" %>
<%@ page import="javak.crypto.spec.*" %>
<%@ page import="ksign.jce.provider.pkcs.*" %>
<%@ page import="ksign.jce.provider.validate.ValidateCert" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.dsdm.app.activity.userinfo.UserInfoDelegate" %>
<%@ page import="nads.dsdm.app.join.JoinMemberDelegate" %>



<%
	System.out.println("START!!!!!!!!!!!!!!!!!!!");
    //request.setCharacterEncoding("KSC5601");
     String imgHome = "../../images/";
%>
<%

	//	nafs_login.jsp���� �Ѿ�� pkcs#7 signeddata ��
	String tempEncode = request.getParameter("signed_data");
	String dn = "";
	String issuer_dn = "";
	String url = "";
	String err_msg = "";
	String err_msg_1 = "";
	String err_msg_2 = "";
	Enumeration el = null;
		String strCn;
    
	//out.println("TEST => SignedData Input : " + tempEncode +"<BR>");

	boolean isVerify = false;

	Certificate[] certs; // �������� ����
	
	
        
	try
	{
		//�׻� ���־�� ��. (����� �������� �о��, ksign)
		JCEUtil.initProvider();    

		byte[] temp = Base64.decode(tempEncode);
		certs = PKCS7.getCertsForPKCS7(new ByteArrayInputStream(temp));
		X509Certificate x509 = (X509Certificate)certs[0];		
	  
		if(certs != null){
			           
        	
				//out.println("TEST => NPKI, PPKI ������ ���� ����"+"<BR>");
			      
				//������ ���� �������� CRL�� �����ϴ� ��ġ�� �����ϴ� �������Դϴ�.("C:/Program Files/NPKI" �̸� �������Ѿ� �մϴ�.")
				//���� ValidateCert validateCert = new ValidateCert()�� �����ϸ� ������ �ƹ��͵� �������� �ʽ��ϴ�.
				// ValidateCert validateCert = new ValidateCert("c:/kwon_test");
		 		ValidateCert validateCert = new ValidateCert();
				//ValidateCert validateCert = new ValidateCert();					  
				validateCert.setInitialPolicy("1.2.3.4.5",true);	  
				//�ɼ��� �ִµ� ValidateCert.KCV_CHECK_FULL_CRL�� ������� CRL ��� ����
				//                  ValidateCert.KCV_CHECK_USER_CRL_ONLY�� ����� CRL ����
			  	validateCert.setValidateOption(true, ValidateCert.KCV_CHECK_USER_CRL_ONLY);

				if(x509.getSubjectDN().getName().toLowerCase().endsWith("dc=kr")){
                    // Active ldap ������ ��� id�� pass�� ������ �ؾ� ��. (�츮 ������ active ladp ����)                           
                    validateCert.setADLdapInfo("ldapuser", "ldapuser"); 
                }				

				/* 1. ǥ�� ���� API ��Ÿ�� �Լ�. */
//				isVerify = validateCert.validateCertificateFromLDAP(certs, validateCert.KCE_ALLUSAGE_CERT);

				/* 2. ǥ�� ���� API ����. */
					//��Ⱥο��� �߱��� �������̺귯���� �ʱ�ȭ�ϴ� ������ 
					//ǥ�غ��� API(��Ⱥ� �������̺귯��)���� ������ �������� ��� ��ġ�� �־��ֽø� �˴ϴ�.
					// (ex : validateCert.setKsigngpki("/home/gpki/gpkiLib", "/home/gpki/gpkiLib/SVR1280720004_sig.cer","/home/gpki/gpkiLib/SVR1280720004_sig.key","/home/gpki/gpkiLib/Government.der","/home/gpki/gpkiLib/gpkiapi.conf");)
					validateCert.setKsigngpki("/usr/libgpkiapi_jni", "/usr/libgpkiapi_jni/SVR9710000001_sig.cer","/usr/libgpkiapi_jni/SVR9710000001_sig.key","/usr/libgpkiapi_jni/Government.der","/usr/libgpkiapi_jni/conf/gpkiapi.conf");
					isVerify = validateCert.validateCertificateNPKI_GPKI(certs, "dlswmdrhksfl11!",ValidateCert.KCE_ALLUSAGE_CERT);  

//				isVerify = true;

				//out.println("TEST => Certificate Verify : "+ isVerify + "<BR>");

			
			//�������� ��ȿ�Ҷ��� ����Ÿ�� ������.
			if(isVerify) {
			  	//out.println("TEST => ������ ��ȿ�� ���� ����<BR>");	 

				byte[] deSignedData = PKCS7.verifyPKCS7(new ByteArrayInputStream(temp), null, null);
   		  		String destrencode = new String(deSignedData);

				//out.println("<BR>============ �������� ó���� ���� ===============<BR>");
				//out.println("���� Message : " + new String(deSignedData) + "<BR>");
			   	//out.println("����� ������ DN : " + x509.getSubjectDN().getName() + "<BR>");
			   	//out.println("�߱��� ������ DN : " + x509.getIssuerDN().getName() + "<BR>");
			   	//out.println("=================================================<BR>");

				dn = x509.getSubjectDN().getName();
				issuer_dn = x509.getIssuerDN().getName();

			}else{
				//out.println("TEST => ������ ��ȿ�� ���� ���� <BR>");	    
			}
		}else{
			//out.println("TEST => Can't exit Certificates.<BR>"); 
		}
	
	}
	catch(Exception e){
		session.removeAttribute("login_nonce");
    	e.printStackTrace();
	  	out.println("���� �ڵ� <BR>" + JCEUtil.getErrorcode());	  	  
	  	out.println(e.toString()+"<BR>");
	}


%>
<%
	StringTokenizer st = new StringTokenizer(issuer_dn, ",");
	StringTokenizer st1 = new StringTokenizer(st.nextToken(), "=");
	st1.nextToken();
	String NPKI_name = st1.nextToken();
	
	System.out.println("NPKI_name : " + NPKI_name + "<br>");
	System.out.println("����������� ������ : " + NPKI_name);
	System.out.println("<br>");


	//2048bit CA������ �߰��� ���� ������� �������� 2048bit CA���� 1024bit CA���� �����ϵ��� �Ѵ�.
	/* ����� �������� IssauerName���� ���� "CN"���� ���� */
	st = new StringTokenizer(issuer_dn, ",");
	
	System.out.println("st : " + st);
	
	st.nextToken();
	st1 = new StringTokenizer(st.nextToken(), "=");
	st1.nextToken();
	String NPKI_CA_Type = st1.nextToken();
	
	System.out.println("CA������ : " + NPKI_CA_Type);
	System.out.println("<P>");

	JoinMemberDelegate joininfo = new JoinMemberDelegate();
	ResultSetHelper objRs = null;
	ResultSetSingleHelper objRsHs = null;
	ResultSetSingleHelper objRsHs2 = null;
	ResultSetSingleHelper objRsHs3 = null;
	
	if(!isVerify) {
		return;
	}

	String id = "";
	System.out.println("DN : "+dn);
	objRs = new ResultSetHelper((ArrayList)joininfo.selectUserInfoList(dn));
	System.out.println("USERINFO SIZE : "+objRs.getTotalRecordCount());
	if (objRs.getRecordSize() == 1)
	{
		String name = "";
		String userFlag = ""; // I:���λ����, X:�ܺλ����
		String pwd = "";
		//Hashtable detail = (Hashtable) vec.elementAt(0);
		if(objRs.next()){
			id = (String) objRs.getObject("ID");
			name = (String)objRs.getObject("NAME");
			userFlag = (String)objRs.getObject("INOUT_GBN"); // I:���λ����, X:�ܺλ����
			pwd = (String)objRs.getObject("PWD");
		}		

		System.out.println("id" + id);

		url = "outuser.jsp";


		//User user = new User(id);
		//user.setName(name);
		//user = (User) UserDAO.getInstance().select(user);

		objRsHs = new ResultSetSingleHelper((Hashtable)joininfo.getUserInfoDetail(id));
		String naDsState1 = (String)objRsHs.getObject("STATUS");
		//String nafsState = PtNewDAO.getInstance().selectNafsState(id);
		System.out.println("naDsState1 : "+naDsState1);
		int naDsState = Integer.parseInt(naDsState1);

		//���� G04C01     Ż���� G04C06
		if (naDsState == 1)   //1 -->7(����)
		{
			session.setAttribute("id", id);
			session.setAttribute("userFlag", userFlag);
			session.setAttribute("pwd", pwd);			
			// 07.23 �߰�. ��踦 ���� ī��Ʈ �����
			//SSOInfoDAO.getInstance().addLoginCnt();
		}
		else if (naDsState != 4)
		{
			//Ż����
			if (naDsState == 3)
			{
				err_msg = "Ż�������Դϴ�. \\n\\n�����ڿ��� ���ǹٶ��ϴ�.";
				err_msg_1 = "[ ������ ��ȭ : 02-788-3882 (������) ]";
				url = "login.jsp";
				
			}
			//�������
			else if (naDsState == 2)
			{
				err_msg = "������������Դϴ�. \\n\\n�����ڿ��� ���ǹٶ��ϴ�.";
				err_msg_1 = "[ ������ ��ȭ : 02-788-3882 (������) ]";
				url = "login.jsp";
				
			}
			//���ó��Ȯ����
			else if (naDsState == 5)
			{
				err_msg = "������� ��û������ �����ڰ� ���ó�����Դϴ�.";
				err_msg_1 = "������ ���� �� ��밡���մϴ�.";
				url = "login.jsp";				
			}
			//����ڵ�Ͻ���
			else if (naDsState == 6)
			{
				err_msg = "�α��� ȭ�鿡�� [����ڵ��Ȯ��]�޴��� �̿��Ͽ�";
				err_msg_1 = "����� ������ �Ϸ��Ͻ��� �α��� �Ͻʽÿ�.";
				url = "login.jsp";
				
			}
			//���Թݷ�
			else if (naDsState == 7)
			{
				err_msg = "�����ڰ� ��û�� �ݷ��Ͽ����ϴ�. \\n\\n�����ڿ��� ���ǹٶ��ϴ�.";
				err_msg_1 = "[ ������ ��ȭ : 02-788-3882 (������) ]";
				url = "login.jsp";
				
			}
		}
		else
		{
			err_msg = "�������ڰ� �ƴմϴ�. \\n\\n�����ڿ��� ���ǹٶ��ϴ�." ;
			err_msg_1 = "[ ������ ��ȭ : 02-788-3882 (������) ]";
			url = "login.jsp";
		}

		if (!err_msg.equals("")) {
			String msg = "";

			
			msg = err_msg + "\\n\\n" + err_msg_1;
			

			session.invalidate();
%>
			<script language="JavaScript">
				alert("<%= msg %>")
				self.location.replace("<%= url %>");
			</script>
<%
			return;
		} else {
			response.sendRedirect(url);
%>
                  
<%
			return;
		}
	}
	else if (objRs.getRecordSize() > 1)
	{
%>
		<script language="JavaScript">
			alert('�����ڿ��� �����Ͻʽÿ�.');
			self.location.replace("login.jsp");
		</script>
<%
		return;
	}
	else
	{
		//����� CN ����
		System.out.println(" //����� CN ����");

		StringTokenizer stCn1 = new StringTokenizer(dn, ",");
		StringTokenizer stCn2 = new StringTokenizer(stCn1.nextToken(), "=");
		stCn2.nextToken();
		strCn = stCn2.nextToken();
		
		
			
		String[] strCns = this.split("(",strCn);
		strCn = strCns[0];

		System.out.println("strCn : " + strCn);

		String nm = "";
		/*---------------------------------------
		 0709�߰�
		---------------------------------------*/
		if (NPKI_name.equals("CA131000002") || NPKI_name.equals("CA131000001") || NPKI_name.equals("CA974000001") || NPKI_name.equals("CA974000002") || NPKI_name.equals("CA131000009") || NPKI_name.equals("CA131000010") || NPKI_name.equals("CA134040001"))
		{
			// "089ȫ�浿001" ���� "ȫ�浿"�� ���´�.
			nm = strCn.substring(3, strCn.length()-3);

			System.out.println("GPKI ����ڸ� : " + nm);
			objRsHs2 = new ResultSetSingleHelper(joininfo.getBeforeRegUserGPKI(nm));
		}
		//else if (NPKI_name.equals("NCASign CA"))
		else if (NPKI_CA_Type.equals("LicensedCA") || NPKI_CA_Type.equals("licensedCA") )
		//else if (NPKI_CA_Type.equals("AccreditedCA") || NPKI_CA_Type.equals("LicensedCA") || NPKI_CA_Type.equals("licensedCA") )
		{
			// "�����(�μ���)" ���� "�����"�� ���´�.
			//nm = strCn.substring(0, strCn.lastIndexOf("("));
			System.out.println("ncasign �����1024 : " + nm);
			
			objRsHs2 = new ResultSetSingleHelper(joininfo.getBeforeRegUserNcasign(nm));
		}
		else if (NPKI_CA_Type.equals("AccreditedCA"))
		{
			// "�����(�μ���)" ���� "�����"�� ���´�.
			//nm = strCn.substring(0, strCn.lastIndexOf("("));
			System.out.println("ncasign �����2048 : " + strCn);
			
			objRsHs2 = new ResultSetSingleHelper(joininfo.getBeforeRegUserNcasign(strCn));
		}

		err_msg = "userListConfirm";
		url = "login.jsp";
	}

%>



<html>
<head>
<title>�����ڷ� �������� �ý���</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link href="http://naps.assembly.go.kr/css/System.css" rel="stylesheet" type="text/css">
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
  <table width="100%"  height="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td align="center">
        <table border="0" cellpadding="7" cellspacing="0"  height="322">
          <tr>
            <td height="322" valign="top" align="center">
              <table border="0" cellpadding="3" cellspacing="0" width="510">
                <tr>
                  <td><img src="../../images/intro/nafs01_logo1.gif" width="340" height="65"></td>
                </tr>
				
                <tr>
                  <td><img src="../../images/login/nafs_login_er.jpg" width="620" height="165"></td>
                </tr>
                <tr>
                  <td>
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td height="7" ></td>
                      </tr>
                    </table>
                  </td>
                </tr>
              </table>
              <table border="0" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" bordercolordark="#CCCCCC" width="620"  align="center">
                <tr>
                  <td align="center" width="558" height="200" bordercolor="white">
                    <table width="626"  border="0" >
                      <tr>
                        <td>
                          <table width="66%"  height="41" border="1"  align="center" cellpadding="0" cellspacing="0" bordercolorlight="#CCCCCC" bordercolordark="#CCCCCC">
                            <tr>
                              <td  width="30%" height="20" bgcolor="#E7E7E7"> <p align="center"><font size="2">�̸�</font></p></td>
                              <td bgcolor="#E7E7E7" width="30%"> <p align="center"><font size="2">�ֹε�Ϲ�ȣ</font></p></td>
                              <td bgcolor="#E7E7E7" width="30%"> <p align="center"><font size="2">����</font></p></td>
                            </tr>
                                      
<%
	

        
		String status = (String)objRsHs2.getObject("STT_CD");
		//String nafs_stat = (String)usrData.get("nafs_stat");
		id = (String)objRsHs2.getObject("usrId");
			
		if (id == null)
		{
			String cn = strCn.trim();

			System.out.println("strCntest : " + dn);

			objRsHs3 = new ResultSetSingleHelper(joininfo.selectId(dn));

			id = (String)objRsHs3.getObject("USER_ID");

			System.out.println("id" + objRsHs3.getObject("USER_ID"));
			//id = "0000050014"; // 1205
		}
		
		System.out.println("id2 : " + id);
		System.out.println("11_dn : " + dn);
		System.out.println("13_status : " + status);

	   

		if ("001".equals(status)) status = "����";
		else if ("002".equals(status)) status = "�������";
		else if ("003".equals(status)) status = "Ż����";
		else if ("004".equals(status)) status = "Ż��";
		else if ("005".equals(status)) status = "���Խ�û";
		else if ("006".equals(status)) status = "���Խ���";
		else if ("007".equals(status)) status = "���Թݷ�";
		else status = "-";

%>

                            <tr>
                              <td width="30%" height="19"><p align="center"><%=(String)objRsHs2.getObject("USER_NM")%></p></td>
                              <td width="30%"><p align="center"><%=(String)objRsHs2.getObject("JUMIN_NO")%></p></td>
                              <td width="30%"><p align="center"><font color="#FF6633"><%=status%></font></p></td>
                            </tr>

                          </table>
                        </td>
                      </tr>
                      <tr>
                        <td  height="5" ></td>
                      </tr>
                      <tr>
                        <td  height="45" width="616">
                          <table width="102%" border="0" cellspacing="8" cellpadding="0">
                            <tr>
                              <td><img src="../../images/login/bullet2.gif" width="3" height="5"></td>
                              <td><strong><font color="#3399FF">����</font></strong>: �ý��ۿ� �α����ϼż� ����Ͻñ� �ٶ��ϴ�.</td>
                            </tr>
                            <tr>
                              <td><img src="../../images/login/bullet2.gif" width="3" height="5"></td>
                              <td><strong><font color="#3399FF">���Խ�û</font></strong>: ����ڵ�Ͻ�û�� �� ���ü����� �ѽ��� �������ֽñ� �ٶ��ϴ�(FAX: 02-788-3378)
                   ���� ���� �� �������� ����ó���� �ʿ��մϴ�.</td>
                            </tr>
                            <tr>
                              <td><img src="../../images/login/bullet2.gif" width="3" height="5"></td>
                              <td><strong><font color="#3399FF">���Խ���</font></strong>: �ý��� ù ���������� ����ڵ��Ȯ�� �� �α����Ͻñ� �ٶ��ϴ�. </td>
                            </tr>
                            <tr>
                              <td><img src="../../images/login/bullet2.gif" width="3" height="5"></td>
                              <td><strong><font color="#3399FF">���Թݷ�</font></strong>: �����ڿ��� �����Ͻñ� �ٶ��ϴ�.(02-788-3882, ������)</td>
                            </tr>
                            <tr>
                              <td><img src="../../images/login/bullet2.gif" width="3" height="5"></td>
                              <td> <font color="#3399FF"><strong>�������</strong></font>: �����ڿ��� �����Ͻñ� �ٶ��ϴ�.(02-788-3882, ������) </td>
                            </tr>
                            <tr>
                              <td><img src="../../images/login/bullet2.gif" width="3" height="5"></td>
                              <td> <font color="#3399FF"><strong>Ż����</strong></font>: Ż���û�� �ϼ̽��ϴ�. �������� Ż��ó���� �ʿ��մϴ�. </td>
                            </tr>
                            <tr>
                              <td><img src="../../images/login/bullet2.gif" width="3" height="5"></td>
                              <td> <font color="#3399FF"><strong>Ż��</strong></font>: �ý����� ����Ͻ÷��� �ý��� ù ���������� ����ڵ�Ͻ�û�� �Ͻñ� �ٶ��ϴ�.  </td>
                            </tr>
                            <tr>
                              <td><img src="../../images/login/bullet2.gif" width="3" height="5"></td>
                              <td> <font color="#3399FF"><strong>���Դ��</strong></font>: �����ڿ��� �����Ͻñ� �ٶ��ϴ�.(02-788-3882, ������) </td>
                            </tr>
                          </table>
                        </td>
                      <tr>
                        <td  height="40" width="616"><font color="#999999">�� ����� �Ѱǵ� ��ȸ���� �ʾ��� ��쿡�� �����ڿ��� �����Ͻʽÿ�. </font> </td>
                      </tr>
                      <tr>
                        <td width="616"  height="1" bgcolor="#CCCCCC">[ ������ ��ȭ : 02-788-3882 (������) ]</td>
                      </tr>
                    </table>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
    
        <table width="641" border="0" cellspacing="0" cellpadding="0" >
          <tr width="558">
            <td colspan="2" height="20">
              <table width="633"  border="0" cellpadding="0" cellspacing="0">
                <tr>
                  <td><img src="../../images/login/btn_bot.gif" width="293" height="35"></td>
                  <td align="right"><a href="/index.html"><img src="/images/bt_23.gif" border="0" ></a></td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</body>
</html>
<%
//} //if(false) {
%>


<%!
/* �������� cn������ ����� �������� �κ� 20071212 */
public static String[] split(String delim, String str) {
	Vector buffer = new Vector();
	int fromIndex = 0;
	int endIndex;
	while((endIndex=str.indexOf(delim, fromIndex))!=-1) {
		buffer.add(str.substring(fromIndex, endIndex));
		fromIndex = endIndex+1;
	}
	String token = str.substring(fromIndex).trim();
	if(isAssigned(token)) buffer.add(token);
	return toArray(buffer);
}

public static boolean isAssigned(String value) {
	return value!=null && !value.trim().equals("");
}

public static String[] toArray(Vector vector) {
	String result[] = new String[vector.size()];
	for(int i=0; i<vector.size(); i++) result[i] = (String)vector.get(i);
	return result;
}

%>
