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

	//	login.jsp에서 넘어온 pkcs#7 signeddata 값
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

	Certificate[] certs; // 인증서를 담음
        
	try
	{
		//항상 해주어야 함. (사용자 인증서를 읽어옴, ksign)
		JCEUtil.initProvider();    

		byte[] temp = Base64.decode(tempEncode);
		certs = PKCS7.getCertsForPKCS7(new ByteArrayInputStream(temp));
		X509Certificate x509 = (X509Certificate)certs[0];
	  
		if(certs != null){
			           
        	
				out.println("TEST => NPKI, PPKI 인증서 검증 시작"+"<BR>");
			      
				//재사용을 위한 인증서와 CRL을 저장하는 위치를 지정하는 생성자입니다.("C:/Program Files/NPKI" 미리 생성시켜야 합니다.")
				//만약 ValidateCert validateCert = new ValidateCert()로 생성하면 폴더에 아무것도 저장하지 않습니다.
				// ValidateCert validateCert = new ValidateCert("c:/kwon_test");
		 		ValidateCert validateCert = new ValidateCert();
				//ValidateCert validateCert = new ValidateCert();					  
				validateCert.setInitialPolicy("1.2.3.4.5",true);	  
				//옵션이 있는데 ValidateCert.KCV_CHECK_FULL_CRL는 상위기관 CRL 모두 검정
				//                  ValidateCert.KCV_CHECK_USER_CRL_ONLY는 사용자 CRL 검정
			  	validateCert.setValidateOption(true, ValidateCert.KCV_CHECK_USER_CRL_ONLY);

				if(x509.getSubjectDN().getName().toLowerCase().endsWith("dc=kr")){
                    // Active ldap 서버일 경우 id와 pass를 설정을 해야 함. (우리 서버가 active ladp 서버)                           
                    validateCert.setADLdapInfo("ldapuser", "ldapuser"); 
                }				

				/* 1. 표준 보안 API 안타는 함수. */
//				isVerify = validateCert.validateCertificateFromLDAP(certs, validateCert.KCE_ALLUSAGE_CERT);

				/* 2. 표준 보안 API 사용시. */
					//행안부에서 발급한 서버라이브러리를 초기화하는 것으로 
					//표준보안 API(행안부 서버라이브러리)에서 받으신 데이터의 경로 위치를 넣어주시면 됩니다.
					// (ex : validateCert.setKsigngpki("/home/gpki/gpkiLib", "/home/gpki/gpkiLib/SVR1280720004_sig.cer","/home/gpki/gpkiLib/SVR1280720004_sig.key","/home/gpki/gpkiLib/Government.der","/home/gpki/gpkiLib/gpkiapi.conf");)
//					validateCert.setKsigngpki("/usr/libgpkiapi_jni", "/usr/libgpkiapi_jni/SVR9710000001_sig.cer","/usr/libgpkiapi_jni/SVR9710000001_sig.key","/usr/libgpkiapi_jni/Government.der","/usr/libgpkiapi_jni/conf/gpkiapi.conf");
//					isVerify = validateCert.validateCertificateNPKI_GPKI(certs, "tjqjdlswmdtj11",ValidateCert.KCE_ALLUSAGE_CERT);  

isVerify = true;

				out.println("TEST => Certificate Verify : "+ isVerify + "<BR>");
			
			//인증서가 유효할때만 데이타를 보여줌.
			if(isVerify) {
			  	out.println("TEST => 인증서 유효성 검증 성공<BR>");	 

				byte[] deSignedData = PKCS7.verifyPKCS7(new ByteArrayInputStream(temp), null, null);
   		  		String destrencode = new String(deSignedData);

				out.println("<BR>============ 서버에서 처리할 정보 ===============<BR>");
				out.println("서명 Message : " + new String(deSignedData) + "<BR>");
			   	out.println("사용자 인증서 DN : " + x509.getSubjectDN().getName() + "<BR>");
			   	out.println("발급자 인증서 DN : " + x509.getIssuerDN().getName() + "<BR>");
			   	out.println("=================================================<BR>");

				dn = x509.getSubjectDN().getName();
				issuer_dn = x509.getIssuerDN().getName();

			}else{
				out.println("TEST => 인증서 유효성 검증 실패 <BR>");	    
			}
		}else{
			out.println("TEST => Can't exit Certificates.<BR>"); 
		}
	
	}
	catch(Exception e){
		session.removeAttribute("login_nonce");
    	e.printStackTrace();
	  	out.println("에러 코드 <BR>" + JCEUtil.getErrorcode());	  	  
	  	out.println(e.toString()+"<BR>");
	}


%>
