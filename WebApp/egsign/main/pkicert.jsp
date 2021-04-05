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

	//	nafs_login.jsp���� �Ѿ�� pkcs#7 signeddata ��
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

	Certificate[] certs; // �������� ����
	

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
		String userFlag = ""; // I:���λ����, X:�ܺλ����
		String pwd = "";
		//Hashtable detail = (Hashtable) vec.elementAt(0);
		if(objRs.next()){
			id = (String) objRs.getObject("ID");
			name = (String)objRs.getObject("NAME");
			userFlag = (String)objRs.getObject("INOUT_GBN"); // I:���λ����, X:�ܺλ����
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

		//���� G04C01     Ż���� G04C06
		if (naDsState == 1)   //1 -->7(����)
		{
			session.setAttribute("id", id);
			session.setAttribute("userFlag", userFlag);
			session.setAttribute("pwd", pwd);			
			// 07.23 �߰�. ��踦 ���� ī��Ʈ �����
			//SSOInfoDAO.getInstance().addLoginCnt();
			joininfo.addLgoinCnt();
		}
		else if (naDsState != 4)
		{
			//Ż����
			if (naDsState == 3)
			{
				err_msg = "Ż�������Դϴ�. \\n\\n�����ڿ��� ���ǹٶ��ϴ�.";
				err_msg_1 = "[ ������ ��ȭ : 02-788-3882 ]";
				url = "login.jsp";
				
			}
			//�������
			else if (naDsState == 2)
			{
				err_msg = "������������Դϴ�. \\n\\n�����ڿ��� ���ǹٶ��ϴ�.";
				err_msg_1 = "[ ������ ��ȭ : 02-788-3882  ]";
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
				err_msg_1 = "[ ������ ��ȭ : 02-788-3882  ]";
				url = "login.jsp";
				
			}
		}
		else
		{
			err_msg = "�������ڰ� �ƴմϴ�. \\n\\n�����ڿ��� ���ǹٶ��ϴ�." ;
			err_msg_1 = "[ ������ ��ȭ : 02-788-3882  ]";
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
		if (NPKI_name.equals("CA131000002") || NPKI_name.equals("CA131000001") || NPKI_name.equals("CA974000001") || NPKI_name.equals("CA974000002") || NPKI_name.equals("CA131000009") || NPKI_name.equals("CA131000010") || NPKI_name.equals("CA134040001") || NPKI_name.equals("CA131100001")|| NPKI_name.equals("CA1311000031T"))
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
%>
		<script language="JavaScript">
			alert('�������� ��ġ�ϴ� ����� ������ ã�� �� �����ϴ�.\n\n����� ��� Ȯ�� �޴��� �̿��Ͽ� �ֽñ� �ٶ��\n\n�������� ����� ���� ������ ������ �Ͽ��ֽñ� �ٶ��ϴ�.');
			self.location.replace("login.jsp");
		</script>
<%
	}

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
