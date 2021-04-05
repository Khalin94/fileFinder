<%@ page contentType="text/html; charset=euc-kr" language="java" %>
<%@ page import="java.security.cert.*" %>
<%@ page import="java.security.spec.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="javak.crypto.*" %>
<%@ page import="javak.crypto.spec.*" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.dsdm.app.activity.userinfo.UserInfoDelegate" %>
<%@ page import="nads.dsdm.app.join.JoinMemberDelegate" %>

<%@ page import="com.raonsecure.ksbiz.log.KSBizLogger"%>
<%@ page import="com.raonsecure.ksbiz.*" %>
<%@ page import="com.raonsecure.ksbiz.crypto.*" %>


<%
	System.out.println("START!!!!!!!!!!!!!!!!!!!");
    //request.setCharacterEncoding("KSC5601");
     String imgHome = "../../images/";
%>
<%
	KSBiz_v2 ksobj = new KSBiz_v2();

	//	nafs_login.jsp에서 넘어온 pkcs#7 signeddata 값
	String signData = request.getParameter("signed_data");
	String dn = "";
	String issuer_dn = "";
	String url = "";
	String err_msg = "";
	String err_msg_1 = "";
	String err_msg_2 = "";
	Enumeration el = null;
		String strCn;
    
	System.out.println("TEST => SignedData Input : " + signData +"<BR>");

	boolean isVerify = false;

	int errorCode=-1;
	String errorMsg = "";

	Certificate[] certs; // 인증서를 담음
	

	try 
	{
		ksobj.libInit();
		System.out.println("lib init success");
		
		ksobj.verify(signData);
		errorCode = ksobj.getErrorCode();
		if(errorCode != 0)
		{
			errorMsg = ksobj.getErrorMsg();
		}
		else
		{
			dn = ksobj.getCertInfo(KSBizCertInfo.SUBJECTDN);
			issuer_dn = ksobj.getCertInfo(KSBizCertInfo.ISSUERDN);

			isVerify = true;
		}
	} 
	catch ( Exception e ) 
	{
	    out.print( e.toString() );
	    out.flush();
	    return;
	}	
    
%>
<%
	StringTokenizer st = new StringTokenizer(issuer_dn, ",");
	StringTokenizer st1 = new StringTokenizer(st.nextToken(), "=");
	st1.nextToken();
	String NPKI_name = st1.nextToken();
	
	System.out.println("dn : " + dn + "<br>");
	System.out.println("issuer_dn : " + issuer_dn + "<br>");

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
	System.out.println("-------------------------------- 1");
	ResultSetHelper objRs = null;
	System.out.println("-------------------------------- 2");
	ResultSetSingleHelper objRsHs = null;
	System.out.println("-------------------------------- 3");
	ResultSetSingleHelper objRsHs2 = null;
	System.out.println("-------------------------------- 4");
	ResultSetSingleHelper objRsHs3 = null;
	System.out.println("-------------------------------- 5");
	
	if(!isVerify) {
		return;
	}

	String id = "";
	objRs = new ResultSetHelper((ArrayList)joininfo.selectUserInfoList(dn));
	
	System.out.println("objRs : " + objRs.getRecordSize());

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

		System.out.println("ID" + id);
		session.setAttribute("dn", dn);

		url = "outuser.jsp";


		//User user = new User(id);
		//user.setName(name);
		//user = (User) UserDAO.getInstance().select(user);

		objRsHs = new ResultSetSingleHelper((Hashtable)joininfo.getUserInfoDetail(id));

		
		String naDsState1 = (String)objRsHs.getObject("STATUS");
		//String nafsState = PtNewDAO.getInstance().selectNafsState(id);

		int naDsState = Integer.parseInt(naDsState1);

		//정상 G04C01     탈퇴대기 G04C06
		if (naDsState == 1)   //1 -->7(정상)
		{
			session.setAttribute("id", id);
			session.setAttribute("userFlag", userFlag);
			session.setAttribute("pwd", pwd);			
			// 07.23 추가. 통계를 위한 카운트 남기기
			//SSOInfoDAO.getInstance().addLoginCnt();
			joininfo.addLgoinCnt();
		}
		else if (naDsState != 4)
		{
			//탈퇴대기
			if (naDsState == 3)
			{
				err_msg = "탈퇴대기중입니다. \\n\\n관리자에게 문의바랍니다.";
				err_msg_1 = "[ 관리자 전화 : 02-788-3882 ]";
				url = "login.jsp";
				
			}
			//사용정지
			else if (naDsState == 2)
			{
				err_msg = "사용정지상태입니다. \\n\\n관리자에게 문의바랍니다.";
				err_msg_1 = "[ 관리자 전화 : 02-788-3882  ]";
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
				err_msg_1 = "[ 관리자 전화 : 02-788-3882  ]";
				url = "login.jsp";
				
			}
		}
		else
		{
			err_msg = "정상사용자가 아닙니다. \\n\\n관리자에게 문의바랍니다." ;
			err_msg_1 = "[ 관리자 전화 : 02-788-3882  ]";
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
		if (NPKI_name.equals("CA131000002") || NPKI_name.equals("CA131000001") || NPKI_name.equals("CA974000001") || NPKI_name.equals("CA974000002") || NPKI_name.equals("CA131000009") || NPKI_name.equals("CA131000010") || NPKI_name.equals("CA134040001") || NPKI_name.equals("CA131100001")|| NPKI_name.equals("CA1311000031T"))
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
%>
		<script language="JavaScript">
			alert('인증서와 일치하는 사용자 정보를 찾을 수 없습니다.\n\n사용자 등록 확인 메뉴를 이용하여 주시기 바라며\n\n인증서가 변경된 경우는 인증서 재등록을 하여주시기 바랍니다.');
			self.location.replace("login.jsp");
		</script>
<%
	}

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
