<%@ page contentType="text/html; charset=euc-kr" language="java" %>
<%@ page import="java.security.cert.*" %>
<%@ page import="java.security.spec.*" %>
<%@ page import="java.io.*" %>
<%@ page import="ksign.jce.util.*" %>
<%@ page import="javak.crypto.*" %>
<%@ page import="javak.crypto.spec.*" %>
<%@ page import="ksign.jce.provider.pkcs.*" %>
<%@ page import="ksign.jce.provider.validate.ValidateCert" %>

<%
	System.out.println("START!!!!!!!!!!!!!!!!!!!");
%>

<%

	//	login.jsp���� �Ѿ�� pkcs#7 signeddata ��
	String tempEncode = request.getParameter("signed_data");
	String dn = "";
	String issuer_dn = "";
	String url = "";
	String err_msg = "";
	String err_msg_1 = "";
	String err_msg_2 = "";
	Enumeration el = null;
	String strCn;
    
	out.println("TEST => SignedData Input : " + tempEncode +"<BR>");

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
			           
        	
				out.println("TEST => NPKI, PPKI ������ ���� ����"+"<BR>");
			      
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
//					validateCert.setKsigngpki("/usr/libgpkiapi_jni", "/usr/libgpkiapi_jni/SVR9710000001_sig.cer","/usr/libgpkiapi_jni/SVR9710000001_sig.key","/usr/libgpkiapi_jni/Government.der","/usr/libgpkiapi_jni/conf/gpkiapi.conf");
//					isVerify = validateCert.validateCertificateNPKI_GPKI(certs, "tjqjdlswmdtj11",ValidateCert.KCE_ALLUSAGE_CERT);  

isVerify = true;

				out.println("TEST => Certificate Verify : "+ isVerify + "<BR>");
			
			//�������� ��ȿ�Ҷ��� ����Ÿ�� ������.
			if(isVerify) {
			  	out.println("TEST => ������ ��ȿ�� ���� ����<BR>");	 

				byte[] deSignedData = PKCS7.verifyPKCS7(new ByteArrayInputStream(temp), null, null);
   		  		String destrencode = new String(deSignedData);

				out.println("<BR>============ �������� ó���� ���� ===============<BR>");
				out.println("���� Message : " + new String(deSignedData) + "<BR>");
			   	out.println("����� ������ DN : " + x509.getSubjectDN().getName() + "<BR>");
			   	out.println("�߱��� ������ DN : " + x509.getIssuerDN().getName() + "<BR>");
			   	out.println("=================================================<BR>");

				dn = x509.getSubjectDN().getName();
				issuer_dn = x509.getIssuerDN().getName();

			}else{
				out.println("TEST => ������ ��ȿ�� ���� ���� <BR>");	    
			}
		}else{
			out.println("TEST => Can't exit Certificates.<BR>"); 
		}
	
	}
	catch(Exception e){
		session.removeAttribute("login_nonce");
    	e.printStackTrace();
	  	out.println("���� �ڵ� <BR>" + JCEUtil.getErrorcode());	  	  
	  	out.println(e.toString()+"<BR>");
	}


%>
