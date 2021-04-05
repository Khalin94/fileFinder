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

	//	nafs_login.jsp에서 넘어온 pkcs#7 signeddata 값
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

	Certificate[] certs; // 인증서를 담음
	
	
        
	try
	{
		//항상 해주어야 함. (사용자 인증서를 읽어옴, ksign)
		JCEUtil.initProvider();    

		byte[] temp = Base64.decode(tempEncode);
		certs = PKCS7.getCertsForPKCS7(new ByteArrayInputStream(temp));
		X509Certificate x509 = (X509Certificate)certs[0];		
	  
		if(certs != null){
			           
        	
				//out.println("TEST => NPKI, PPKI 인증서 검증 시작"+"<BR>");
			      
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
					validateCert.setKsigngpki("/usr/libgpkiapi_jni", "/usr/libgpkiapi_jni/SVR9710000001_sig.cer","/usr/libgpkiapi_jni/SVR9710000001_sig.key","/usr/libgpkiapi_jni/Government.der","/usr/libgpkiapi_jni/conf/gpkiapi.conf");
					isVerify = validateCert.validateCertificateNPKI_GPKI(certs, "dlswmdrhksfl11!",ValidateCert.KCE_ALLUSAGE_CERT);  

//				isVerify = true;

				//out.println("TEST => Certificate Verify : "+ isVerify + "<BR>");

			
			//인증서가 유효할때만 데이타를 보여줌.
			if(isVerify) {
			  	//out.println("TEST => 인증서 유효성 검증 성공<BR>");	 

				byte[] deSignedData = PKCS7.verifyPKCS7(new ByteArrayInputStream(temp), null, null);
   		  		String destrencode = new String(deSignedData);

				//out.println("<BR>============ 서버에서 처리할 정보 ===============<BR>");
				//out.println("서명 Message : " + new String(deSignedData) + "<BR>");
			   	//out.println("사용자 인증서 DN : " + x509.getSubjectDN().getName() + "<BR>");
			   	//out.println("발급자 인증서 DN : " + x509.getIssuerDN().getName() + "<BR>");
			   	//out.println("=================================================<BR>");

				dn = x509.getSubjectDN().getName();
				issuer_dn = x509.getIssuerDN().getName();

			}else{
				//out.println("TEST => 인증서 유효성 검증 실패 <BR>");	    
			}
		}else{
			//out.println("TEST => Can't exit Certificates.<BR>"); 
		}
	
	}
	catch(Exception e){
		session.removeAttribute("login_nonce");
    	e.printStackTrace();
	  	out.println("에러 코드 <BR>" + JCEUtil.getErrorcode());	  	  
	  	out.println(e.toString()+"<BR>");
	}


%>
<%
	StringTokenizer st = new StringTokenizer(issuer_dn, ",");
	StringTokenizer st1 = new StringTokenizer(st.nextToken(), "=");
	st1.nextToken();
	String NPKI_name = st1.nextToken();
	
	System.out.println("NPKI_name : " + NPKI_name + "<br>");
	System.out.println("공인인증기관 구분자 : " + NPKI_name);
	System.out.println("<br>");


	//2048bit CA인증서 추가로 인해 사용자의 인증서가 2048bit CA인지 1024bit CA인지 구분하도록 한다.
	/* 사용자 인증서의 IssauerName으로 부터 "CN"값을 추출 */
	st = new StringTokenizer(issuer_dn, ",");
	
	System.out.println("st : " + st);
	
	st.nextToken();
	st1 = new StringTokenizer(st.nextToken(), "=");
	st1.nextToken();
	String NPKI_CA_Type = st1.nextToken();
	
	System.out.println("CA구분자 : " + NPKI_CA_Type);
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
		String userFlag = ""; // I:내부사용자, X:외부사용자
		String pwd = "";
		//Hashtable detail = (Hashtable) vec.elementAt(0);
		if(objRs.next()){
			id = (String) objRs.getObject("ID");
			name = (String)objRs.getObject("NAME");
			userFlag = (String)objRs.getObject("INOUT_GBN"); // I:내부사용자, X:외부사용자
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

		//정상 G04C01     탈퇴대기 G04C06
		if (naDsState == 1)   //1 -->7(정상)
		{
			session.setAttribute("id", id);
			session.setAttribute("userFlag", userFlag);
			session.setAttribute("pwd", pwd);			
			// 07.23 추가. 통계를 위한 카운트 남기기
			//SSOInfoDAO.getInstance().addLoginCnt();
		}
		else if (naDsState != 4)
		{
			//탈퇴대기
			if (naDsState == 3)
			{
				err_msg = "탈퇴대기중입니다. \\n\\n관리자에게 문의바랍니다.";
				err_msg_1 = "[ 관리자 전화 : 02-788-3882 (조혜경) ]";
				url = "login.jsp";
				
			}
			//사용정지
			else if (naDsState == 2)
			{
				err_msg = "사용정지상태입니다. \\n\\n관리자에게 문의바랍니다.";
				err_msg_1 = "[ 관리자 전화 : 02-788-3882 (방은정) ]";
				url = "login.jsp";
				
			}
			//등록처리확인중
			else if (naDsState == 5)
			{
				err_msg = "사용자의 신청정보를 관리자가 등록처리중입니다.";
				err_msg_1 = "관리자 승인 후 사용가능합니다.";
				url = "login.jsp";				
			}
			//사용자등록승인
			else if (naDsState == 6)
			{
				err_msg = "로그인 화면에서 [사용자등록확인]메뉴를 이용하여";
				err_msg_1 = "사용자 가입을 완료하신후 로그인 하십시오.";
				url = "login.jsp";
				
			}
			//가입반려
			else if (naDsState == 7)
			{
				err_msg = "관리자가 신청을 반려하였습니다. \\n\\n관리자에게 문의바랍니다.";
				err_msg_1 = "[ 관리자 전화 : 02-788-3882 (조혜경) ]";
				url = "login.jsp";
				
			}
		}
		else
		{
			err_msg = "정상사용자가 아닙니다. \\n\\n관리자에게 문의바랍니다." ;
			err_msg_1 = "[ 관리자 전화 : 02-788-3882 (방은정) ]";
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
			alert('관리자에게 문의하십시오.');
			self.location.replace("login.jsp");
		</script>
<%
		return;
	}
	else
	{
		//사용자 CN 추출
		System.out.println(" //사용자 CN 추출");

		StringTokenizer stCn1 = new StringTokenizer(dn, ",");
		StringTokenizer stCn2 = new StringTokenizer(stCn1.nextToken(), "=");
		stCn2.nextToken();
		strCn = stCn2.nextToken();
		
		
			
		String[] strCns = this.split("(",strCn);
		strCn = strCns[0];

		System.out.println("strCn : " + strCn);

		String nm = "";
		/*---------------------------------------
		 0709추가
		---------------------------------------*/
		if (NPKI_name.equals("CA131000002") || NPKI_name.equals("CA131000001") || NPKI_name.equals("CA974000001") || NPKI_name.equals("CA974000002") || NPKI_name.equals("CA131000009") || NPKI_name.equals("CA131000010") || NPKI_name.equals("CA134040001"))
		{
			// "089홍길동001" 에서 "홍길동"만 빼온다.
			nm = strCn.substring(3, strCn.length()-3);

			System.out.println("GPKI 사용자명 : " + nm);
			objRsHs2 = new ResultSetSingleHelper(joininfo.getBeforeRegUserGPKI(nm));
		}
		//else if (NPKI_name.equals("NCASign CA"))
		else if (NPKI_CA_Type.equals("LicensedCA") || NPKI_CA_Type.equals("licensedCA") )
		//else if (NPKI_CA_Type.equals("AccreditedCA") || NPKI_CA_Type.equals("LicensedCA") || NPKI_CA_Type.equals("licensedCA") )
		{
			// "기관명(부서명)" 에서 "기관명"만 빼온다.
			//nm = strCn.substring(0, strCn.lastIndexOf("("));
			System.out.println("ncasign 기관명1024 : " + nm);
			
			objRsHs2 = new ResultSetSingleHelper(joininfo.getBeforeRegUserNcasign(nm));
		}
		else if (NPKI_CA_Type.equals("AccreditedCA"))
		{
			// "기관명(부서명)" 에서 "기관명"만 빼온다.
			//nm = strCn.substring(0, strCn.lastIndexOf("("));
			System.out.println("ncasign 기관명2048 : " + strCn);
			
			objRsHs2 = new ResultSetSingleHelper(joininfo.getBeforeRegUserNcasign(strCn));
		}

		err_msg = "userListConfirm";
		url = "login.jsp";
	}

%>



<html>
<head>
<title>의정자료 전자유통 시스템</title>
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
                              <td  width="30%" height="20" bgcolor="#E7E7E7"> <p align="center"><font size="2">이름</font></p></td>
                              <td bgcolor="#E7E7E7" width="30%"> <p align="center"><font size="2">주민등록번호</font></p></td>
                              <td bgcolor="#E7E7E7" width="30%"> <p align="center"><font size="2">상태</font></p></td>
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

	   

		if ("001".equals(status)) status = "정상";
		else if ("002".equals(status)) status = "사용정지";
		else if ("003".equals(status)) status = "탈퇴대기";
		else if ("004".equals(status)) status = "탈퇴";
		else if ("005".equals(status)) status = "가입신청";
		else if ("006".equals(status)) status = "가입승인";
		else if ("007".equals(status)) status = "가입반려";
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
                              <td><strong><font color="#3399FF">정상</font></strong>: 시스템에 로그인하셔서 사용하시기 바랍니다.</td>
                            </tr>
                            <tr>
                              <td><img src="../../images/login/bullet2.gif" width="3" height="5"></td>
                              <td><strong><font color="#3399FF">가입신청</font></strong>: 사용자등록신청서 등 관련서류를 팩스로 전송해주시기 바랍니다(FAX: 02-788-3378)
                   서류 접수 후 관리자의 승인처리가 필요합니다.</td>
                            </tr>
                            <tr>
                              <td><img src="../../images/login/bullet2.gif" width="3" height="5"></td>
                              <td><strong><font color="#3399FF">가입승인</font></strong>: 시스템 첫 페이지에서 사용자등록확인 후 로그인하시기 바랍니다. </td>
                            </tr>
                            <tr>
                              <td><img src="../../images/login/bullet2.gif" width="3" height="5"></td>
                              <td><strong><font color="#3399FF">가입반려</font></strong>: 관리자에게 문의하시기 바랍니다.(02-788-3882, 조혜경)</td>
                            </tr>
                            <tr>
                              <td><img src="../../images/login/bullet2.gif" width="3" height="5"></td>
                              <td> <font color="#3399FF"><strong>사용정지</strong></font>: 관리자에게 문의하시기 바랍니다.(02-788-3882, 조혜경) </td>
                            </tr>
                            <tr>
                              <td><img src="../../images/login/bullet2.gif" width="3" height="5"></td>
                              <td> <font color="#3399FF"><strong>탈퇴대기</strong></font>: 탈퇴신청을 하셨습니다. 관리자의 탈퇴처리가 필요합니다. </td>
                            </tr>
                            <tr>
                              <td><img src="../../images/login/bullet2.gif" width="3" height="5"></td>
                              <td> <font color="#3399FF"><strong>탈퇴</strong></font>: 시스템을 사용하시려면 시스템 첫 페이지에서 사용자등록신청을 하시기 바랍니다.  </td>
                            </tr>
                            <tr>
                              <td><img src="../../images/login/bullet2.gif" width="3" height="5"></td>
                              <td> <font color="#3399FF"><strong>가입대기</strong></font>: 관리자에게 문의하시기 바랍니다.(02-788-3882, 조혜경) </td>
                            </tr>
                          </table>
                        </td>
                      <tr>
                        <td  height="40" width="616"><font color="#999999">※ 목록이 한건도 조회되지 않았을 경우에는 관리자에게 문의하십시오. </font> </td>
                      </tr>
                      <tr>
                        <td width="616"  height="1" bgcolor="#CCCCCC">[ 관리자 전화 : 02-788-3882 (조혜경) ]</td>
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
/* 인증서에 cn값에서 기관명만 가져오는 부분 20071212 */
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
